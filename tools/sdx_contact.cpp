// sdx_contact.cpp -- the smallest contact scene SuperDex can be asked about (SuperDex v1.0.0): one rigid cube and
// the static ground plane, under gravity. The cube is released with its lowest point h0 above the ground, with a
// horizontal speed vx0. Nothing else is in the scene, so what happens at the ground is contact and nothing but
// contact, and two things about it have a right answer that does not depend on the time step:
//   - with no friction and no contact damping the contact force comes from an energy (SuperDex's own penalty), so
//     the exact motion gives all of the impact energy back: the cube returns to the height it was dropped from;
//   - while the cube slides, Coulomb's law says the friction force is mu times the normal force at every
//     instant, so over an impact the horizontal momentum it loses is mu times the vertical momentum the ground
//     gives it.
// The program only plays the scene and writes what the cube did at every step, as whole numbers. The measuring is
// done elsewhere (sx_contact.sx).
//
// usage: sdx_contact <out.txt> dt=<seconds> [setting=value ...]
//   h0       drop height of the cube's lowest face, metres (default 0.05)
//   vx0      horizontal speed at release, m/s (default 0)
//   mu       Coulomb friction coefficient of the cube and the ground (default 0)
//   lock     1 = the cube's rotation is held fixed, so friction cannot turn into spin (default 1)
//   mass, radius   kg; the cube's half-size in metres (default 1, 0.05)
//   secs     how long to play (default 1)
//   push     a constant horizontal force on the cube, newtons, from the time `pushat` on (default 0)
//   pushat   seconds at which the push starts (default 0: from the first step)
//   lift     a constant upward force on the cube, newtons, from the time `liftat` on (default 0)
//   liftat   seconds at which the lift starts (default 0.3)
//   ndamp    normal viscous damping coefficient of the contact (shipped: 0)
//   visc     viscous friction coefficient of the contact (shipped: 0)
//   penalty, smooth, falloff   contact penalty stiffness, smoothing half-distance, friction falloff speed (shipped:
//            1e9, 0.005, 0.01)
//   integ    time integrator: be bdf2 dirk33 bdf3 dirk22 dirk23 sdirk12 (implicit midpoint) sdirk22 (shipped: be)
//   maxiter  nonlinear iteration limit (default 200; shipped 4)
//   rotk     stiffness of the constraint that holds the rotation fixed (shipped default: 1e6)
//   abstol   nonlinear solver absolute residual tolerance (shipped: 1e-3)
//   floor    cloud = the ground is not a plane but a level cloth sheet with every node held in place, which the
//            cube meets through SuperDex's point-cloud collider (the collider its shells and rods carry). The
//            sheet is `cloudlen` metres along x from 0.5 m behind the cube, `cloudwid` metres across, with
//            a node every `cloudh` metres; `pcradius` is the collider's range (defaults 2.5, 0.3, 0.01; shipped
//            range 0.01). Default: the plane
//            soft = the ground is a soft block with every node held in place, which the cube meets through
//            SuperDex's tetrahedral-map collider (the mapped collider its soft bodies carry). The block is
//            `cloudlen` metres along x from 0.5 m behind the cube, `cloudwid` metres across and `softh` metres
//            deep under y = 0, cut into cells of `softcell` metres, five tetrahedra a cell (defaults 2.5, 0.3, 0.05,
//            0.05). softhold=bottom holds only the nodes of its bottom face, so the block deforms under the cube
//            (SuperDex's shipped soft material); default: every node held
//   exitscene  1 = the scene is destroyed only after main has returned, by an object in static storage made
//            after the context and before the scene, as a program that keeps its scene in static storage would
//            (ctx->DestroyScene, then DestroyContext). 2 = the same from a destructor function, which runs after
//            every static object is gone, the library's own included. Unset: destroyed before main returns, as
//            before
//   pcquad   the sheet's collider points: q1 q3 q6 q7 q12 q16 = that many quadrature points on each triangle
//            (pointCloudCollider.colliderTriangleElementType); unset: one point a node, as shipped
//   reltol   nonlinear solver relative residual tolerance (shipped: 1e-6)
//   sdfcell  the largest cell of the cube's grid distance field, metres (GridSdfParams, resolution mode Explicit;
//            unset: SuperDex sizes it from the mesh, at least 6 cells a side). The plane meets the cube by its
//            corners and does not use it; the point-cloud floor reads the cube through it
//   sdfdiv   the same, as a share of the cube's side: the cell is the side over this number (sdfcell is then not used)
//   twinscene  seconds: before that step a second scene with its own ground and cube is made, played one step and
//            destroyed (a check that one scene leaves another's contact state alone)
//   rollout, rolloutsteps, rolloutpush   seconds, steps, newtons: before that step the state is captured, the
//            steps are played with that push along x and not written, and the state is restored (a check of
//            what a planner's trial rollout leaves behind)
//   teleport, teleportdx   seconds, metres: before that step the cube is moved along x by `teleportdx` with SuperDex's
//            SetRootTransform, its rotation and speed kept (a check of what a body set to a new pose from outside
//            carries over)
//   SuperDex's own evaluation switches (SolverParams.experimentalEval), all at their shipped values unless given:
//   implicitn   1 = the normal force used by friction and damping is the force of the step being solved
//               (implicitNormalForceForDissipation; shipped 0: the force at the start of the step)
//   expnormals  1 = normals and the start-of-step distance taken exactly from the start of the step (explicitNormals;
//               shipped 0: the start-of-step distance is estimated)
//   fade        0 = friction is not faded by the alignment of the normals (fadeFriction; shipped 1)
//   fricmodel   cinf = the C-infinity friction smoothing (shipped: the C1 one)
//   armijo      1 = Armijo line search on the merit (shipped: the default line search)
// writes <out.txt>: a header line "CONTACT dt_ns <n> h0_nm <n> vx0_ums <n> mu_ppm <n> mass_g <n> steps <n>", then one
//   line a step: "<step> <height of the lowest face, nm> <vx, um/s> <vy, um/s> <contact force up, mN> <contact
//   force along x, mN>"
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>
#include <mochi_physics/mochi_physics_experimental.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <functional>
#include <string>
#include <vector>

// An optional trace of the solver's own status of every step, for diagnosis: set SDX_TRACE=<file>. One line a solver
// step: "<solver step> <status: 1 converged, 2 stopped, 3 diverged, 0 none> <iterations> <residual norm in
// millionths, capped at 2,000,000,000>". Nothing else about a play changes when it is set.
static std::FILE* TraceOpen() {
  char const* const p = std::getenv("SDX_TRACE");
  return (p != nullptr && p[0] != 0) ? std::fopen(p, "w") : nullptr;
}
static void TraceStep(std::FILE* t, long step, superdex::SolverStats const& st) {
  if (t == nullptr) return;
  int const code = st.convergenceStatus == superdex::ConvergenceStatus::Converged ? 1
                   : st.convergenceStatus == superdex::ConvergenceStatus::Stopped ? 2
                   : st.convergenceStatus == superdex::ConvergenceStatus::Diverged ? 3 : 0;
  double r = static_cast<double>(st.residualNorm) * 1e6;
  if (!(r < 2e9)) r = 2e9;
  std::fprintf(t, "%ld %d %d %lld\n", step, code, st.maxNonLinearIters, static_cast<long long>(std::llround(r)));
}

using superdex::operator""_r;
using superdex::real;

namespace {
long long Round(double x) { return static_cast<long long>(std::llround(x)); }

// A box of nx x ny x nz cells with a corner at o and the sides s, every cell cut into five tetrahedra, as in
// sdx_deform.cpp (the numbering and the cut of SuperDex's own uniform test mesh, UniformCubeTetMeshData).
void TetGrid(int nx, int ny, int nz, double const o[3], double const s[3], std::vector<real>& coords,
             std::vector<int>& tets) {
  int const row = nx + 1, slab = (nx + 1) * (ny + 1);
  for (int k = 0; k <= nz; ++k)
    for (int j = 0; j <= ny; ++j)
      for (int i = 0; i <= nx; ++i) {
        coords.push_back(static_cast<real>(o[0] + s[0] * i / nx));
        coords.push_back(static_cast<real>(o[1] + s[1] * j / ny));
        coords.push_back(static_cast<real>(o[2] + s[2] * k / nz));
      }
  static int const even[20] = {0, 1, 2, 4, 6, 7, 4, 2, 5, 4, 7, 1, 3, 2, 1, 7, 1, 2, 4, 7};
  static int const odd[20] = {1, 0, 5, 3, 2, 0, 3, 6, 4, 0, 6, 5, 7, 3, 5, 6, 0, 3, 6, 5};
  for (int k = 0; k < nz; ++k)
    for (int j = 0; j < ny; ++j)
      for (int i = 0; i < nx; ++i) {
        int const b = slab * k + row * j + i;
        int const v[8] = {b, b + 1, b + row, b + row + 1, b + slab, b + slab + 1, b + slab + row, b + slab + row + 1};
        int const* const cut = ((i + j + k) % 2 == 0) ? even : odd;
        for (int q = 0; q < 20; ++q) tets.push_back(v[cut[q]]);
      }
}

// exitscene: holds the context and its scene until the process exits; its destructor destroys the scene the
// documented way and then the context.
struct ExitHolder {
  superdex::Context* ctx = nullptr;
  superdex::Scene* sc = nullptr;
  ~ExitHolder() {
    if (ctx != nullptr) {
      if (sc != nullptr) ctx->DestroyScene(sc);
      superdex::DestroyContext(ctx);
    }
  }
};

// exitscene=2: the holder is deleted by a destructor function, which the system runs at exit after the destructors
// of every static object
ExitHolder* gLateHolder = nullptr;
__attribute__((destructor)) void DestroyLate() {
  if (gLateHolder != nullptr) {
    delete gLateHolder;
    gLateHolder = nullptr;
  }
}
} // namespace

int main(int argc, char** argv) {
  if (argc < 3) {
    std::fprintf(stderr, "usage: sdx_contact <out.txt> dt=<seconds> [h0=M] [vx0=V] [mu=X] [lock=0|1] [mass=KG] "
                         "[radius=M] [secs=S] [push=N] [pushat=S] [lift=N] [liftat=S] [ndamp=X] [visc=X] [penalty=X] [smooth=M] [falloff=V] [integ=NAME] [maxiter=N] "
                         "[implicitn=1] [expnormals=1] [fade=0] [fricmodel=cinf] [armijo=1]\n");
    return 2;
  }
  double dt = 0.0, h0 = 0.05, vx0 = 0.0, mu = 0.0, mass = 1.0, radius = 0.05, secs = 1.0;
  double ndamp = -1.0, penalty = -1.0, smooth = -1.0, falloff = -1.0, visc = -1.0, push = 0.0, lift = 0.0, liftAt = 0.3;
  double pushAt = 0.0;
  int lock = 1, maxIter = 200, implicitN = 0, expNormals = 0, fade = 1, cinf = 0, armijo = 0;
  double rotK = -1.0, absTol = -1.0;
  int floorCloud = 0;
  double cloudLen = 2.5, cloudWid = 0.3, cloudH = 0.01, pcRadius = -1.0;
  int pcQuad = 0;
  double sdfCell = -1.0, sdfDiv = -1.0;
  double twinAt = -1.0, rollAt = -1.0, rollPush = 0.0;
  double teleAt = -1.0, teleDx = 0.0;
  long rollSteps = 0;
  double relTol = -1.0;
  double softH = 0.05, softCell = 0.05;
  int exitScene = 0, softBottom = 0;
  std::string integ = "be", extra;
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto val = [&](char const* key) -> char const* {
      size_t n = std::strlen(key);
      return a.compare(0, n, key) == 0 ? a.c_str() + n : nullptr;
    };
    char const* v = nullptr;
    if ((v = val("dt="))) dt = std::atof(v);
    else if ((v = val("h0="))) h0 = std::atof(v);
    else if ((v = val("vx0="))) vx0 = std::atof(v);
    else if ((v = val("mu="))) mu = std::atof(v);
    else if ((v = val("mass="))) mass = std::atof(v);
    else if ((v = val("radius="))) radius = std::atof(v);
    else if ((v = val("secs="))) secs = std::atof(v);
    else if ((v = val("lock="))) lock = std::atoi(v);
    else if ((v = val("ndamp="))) { ndamp = std::atof(v); extra += " " + a; }
    else if ((v = val("visc="))) { visc = std::atof(v); extra += " " + a; }
    else if ((v = val("push="))) { push = std::atof(v); extra += " " + a; }
    else if ((v = val("lift="))) { lift = std::atof(v); extra += " " + a; }
    else if ((v = val("liftat="))) { liftAt = std::atof(v); extra += " " + a; }
    else if ((v = val("pushat="))) { pushAt = std::atof(v); extra += " " + a; }
    else if ((v = val("penalty="))) { penalty = std::atof(v); extra += " " + a; }
    else if ((v = val("smooth="))) { smooth = std::atof(v); extra += " " + a; }
    else if ((v = val("falloff="))) { falloff = std::atof(v); extra += " " + a; }
    else if ((v = val("integ="))) { integ = v; extra += " " + a; }
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("rotk="))) { rotK = std::atof(v); extra += " " + a; }
    else if ((v = val("abstol="))) { absTol = std::atof(v); extra += " " + a; }
    else if ((v = val("implicitn="))) { implicitN = std::atoi(v); extra += " " + a; }
    else if ((v = val("expnormals="))) { expNormals = std::atoi(v); extra += " " + a; }
    else if ((v = val("fade="))) { fade = std::atoi(v); extra += " " + a; }
    else if (a == "fricmodel=cinf") { cinf = 1; extra += " " + a; }
    else if ((v = val("armijo="))) { armijo = std::atoi(v); extra += " " + a; }
    else if ((v = val("floor="))) {
      if (std::strcmp(v, "cloud") == 0) floorCloud = 1;
      else if (std::strcmp(v, "soft") == 0) floorCloud = 2;
      else if (std::strcmp(v, "plane") != 0) { std::fprintf(stderr, "sdx_contact: unknown floor %s\n", v); return 2; }
      extra += " " + a;
    }
    else if ((v = val("cloudlen="))) { cloudLen = std::atof(v); extra += " " + a; }
    else if ((v = val("cloudwid="))) { cloudWid = std::atof(v); extra += " " + a; }
    else if ((v = val("cloudh="))) { cloudH = std::atof(v); extra += " " + a; }
    else if ((v = val("pcradius="))) { pcRadius = std::atof(v); extra += " " + a; }
    else if ((v = val("pcquad=q"))) { pcQuad = std::atoi(v); extra += " " + a; }
    else if ((v = val("sdfcell="))) { sdfCell = std::atof(v); extra += " " + a; }
    else if ((v = val("sdfdiv="))) { sdfDiv = std::atof(v); extra += " " + a; }
    else if ((v = val("twinscene="))) { twinAt = std::atof(v); extra += " " + a; }
    else if ((v = val("rolloutsteps="))) { rollSteps = std::atol(v); extra += " " + a; }
    else if ((v = val("rolloutpush="))) { rollPush = std::atof(v); extra += " " + a; }
    else if ((v = val("rollout="))) { rollAt = std::atof(v); extra += " " + a; }
    else if ((v = val("teleportdx="))) { teleDx = std::atof(v); extra += " " + a; }
    else if ((v = val("teleport="))) { teleAt = std::atof(v); extra += " " + a; }
    else if ((v = val("reltol="))) { relTol = std::atof(v); extra += " " + a; }
    else if ((v = val("softh="))) { softH = std::atof(v); extra += " " + a; }
    else if ((v = val("softcell="))) { softCell = std::atof(v); extra += " " + a; }
    else if ((v = val("softhold="))) {
      if (std::strcmp(v, "bottom") == 0) softBottom = 1;
      else if (std::strcmp(v, "all") != 0) { std::fprintf(stderr, "sdx_contact: unknown softhold %s\n", v); return 2; }
      extra += " " + a;
    }
    else if ((v = val("exitscene="))) { exitScene = std::atoi(v); extra += " " + a; }
    else { std::fprintf(stderr, "sdx_contact: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (dt <= 0.0) { std::fprintf(stderr, "sdx_contact: dt must be given\n"); return 2; }

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  // exitscene: the holder is made after the context and before the scene, so it is destroyed after anything made
  // with the scene and before anything made with the context
  ExitHolder* holder = nullptr;
  if (exitScene == 1) {
    static ExitHolder exitHolder;
    holder = &exitHolder;
  } else if (exitScene == 2) {
    holder = new ExitHolder();
    gLateHolder = holder;
  }
  superdex::Scene* sc = ctx->CreateScene("contact");
  sc->SetGravity(superdex::Real3{0_r, -9.8_r, 0_r});
  {
    superdex::SolverParams sol = sc->GetSolverParams();
    if (integ == "be") sol.integrationMethod = superdex::IntegrationMethod::BackwardEuler;
    else if (integ == "bdf2") sol.integrationMethod = superdex::IntegrationMethod::BDF2;
    else if (integ == "dirk33") sol.integrationMethod = superdex::IntegrationMethod::DIRK33;
    else if (integ == "bdf3") sol.integrationMethod = superdex::IntegrationMethod::BDF3;
    else if (integ == "dirk22") sol.integrationMethod = superdex::IntegrationMethod::DIRK22;
    else if (integ == "dirk23") sol.integrationMethod = superdex::IntegrationMethod::DIRK23;
    else if (integ == "sdirk12") sol.integrationMethod = superdex::IntegrationMethod::SymplecticDIRK12;
    else if (integ == "sdirk22") sol.integrationMethod = superdex::IntegrationMethod::SymplecticDIRK22;
    else { std::fprintf(stderr, "sdx_contact: unknown integrator %s\n", integ.c_str()); return 2; }
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol > 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol > 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    sol.experimentalEval.implicitNormalForceForDissipation = implicitN != 0;
    sol.experimentalEval.explicitNormals = expNormals != 0;
    sol.experimentalEval.fadeFriction = fade != 0;
    if (cinf == 1) sol.experimentalEval.frictionModel = superdex::CoulombFrictionModel::CinfRegularized;
    if (armijo == 1) sol.nonLinearSolver.lineSearchType = superdex::LineSearchType::Armijo;
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  auto contact = [&](superdex::ContactParams& cp) {
    cp.coulombFrictionCoefficient = static_cast<real>(mu);
    if (ndamp >= 0.0) cp.normalViscousDampingCoefficient = static_cast<real>(ndamp);
    if (visc >= 0.0) cp.viscousFrictionCoefficient = static_cast<real>(visc);
    if (penalty > 0.0) cp.penaltyCoefficient = static_cast<real>(penalty);
    if (smooth > 0.0) cp.penaltySmoothingHalfDistance = static_cast<real>(smooth);
    if (falloff > 0.0) cp.frictionFalloffVel = static_cast<real>(falloff);
  };
  if (floorCloud == 2) {
    // a soft block whose top face is y = 0, every node held: a floor the cube meets through the tetrahedral map
    int const nx = std::max(1, static_cast<int>(std::lround(cloudLen / softCell)));
    int const ny = std::max(1, static_cast<int>(std::lround(softH / softCell)));
    int const nz = std::max(1, static_cast<int>(std::lround(cloudWid / softCell)));
    double const o[3] = {-0.5, -softH, -0.5 * cloudWid}, s[3] = {cloudLen, softH, cloudWid};
    std::vector<real> coords;
    std::vector<int> tets;
    TetGrid(nx, ny, nz, o, s, coords, tets);
    superdex::SoftActorParams sp;
    sp.name = "ground";
    sp.shape = ctx->CreateTetMeshShape(coords, tets, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: soft block shape: %s\n", e.ToString().c_str()); return 1; }
    contact(sp.contact);
    superdex::Actor* const floorActor = sc->CreateSoftActor(sp, e);
    if (!e.IsOK() || floorActor == nullptr) { std::fprintf(stderr, "sdx_contact: soft block: %s\n", e.ToString().c_str()); return 1; }
    // every node held, or (softhold=bottom) only those of the bottom face, a quarter cell's depth below its middle
    real const cut = static_cast<real>(-softH + 0.25 * softH / ny);
    mochi::experimental::ConstrainNodesByPosition(
        floorActor,
        [softBottom, cut](int, superdex::Real3 const& x) -> bool { return softBottom == 0 || x[1] < cut; }, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: soft block clamp: %s\n", e.ToString().c_str()); return 1; }
  } else if (floorCloud == 0) {
  superdex::RigidActorParams gp;
  gp.name = "ground";
  gp.shape = ctx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
  gp.colliderType = superdex::ColliderType::Plane;
  gp.isStatic = true;
  contact(gp.contact);
  sc->CreateRigidActor(gp, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: ground: %s\n", e.ToString().c_str()); return 1; }
  } else {
    // a level sheet of triangles facing up on y = 0, every node held: a floor the cube can only meet through the
    // point-cloud collider
    int const nx = std::max(1, static_cast<int>(std::lround(cloudLen / cloudH)));
    int const nz = std::max(1, static_cast<int>(std::lround(cloudWid / cloudH)));
    std::vector<real> sheet;
    std::vector<int> sheetTris;
    for (int j = 0; j <= nx; ++j)
      for (int i = 0; i <= nz; ++i) {
        sheet.push_back(static_cast<real>(-0.5 + cloudLen * j / nx));
        sheet.push_back(0_r);
        sheet.push_back(static_cast<real>(-0.5 * cloudWid + cloudWid * i / nz));
      }
    for (int j = 0; j < nx; ++j)
      for (int i = 0; i < nz; ++i) {
        int const a0 = i + j * (nz + 1), b0 = a0 + 1, c0 = a0 + nz + 1, d0 = c0 + 1;
        int const two[6] = {a0, b0, c0, b0, d0, c0};
        sheetTris.insert(sheetTris.end(), two, two + 6);
      }
    mochi::experimental::ShellActorParams sp;
    sp.name = "ground";
    sp.shape = ctx->CreateTriMeshShape(sheet, sheetTris, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: sheet shape: %s\n", e.ToString().c_str()); return 1; }
    sp.colliderType = superdex::ColliderType::PointCloud;
    if (pcRadius > 0.0) sp.pointCloudCollider.radius = static_cast<real>(pcRadius);
    if (pcQuad != 0) {
      superdex::ActorBoundaryElementType q = superdex::ActorBoundaryElementType::P1Q1;
      if (pcQuad == 1) q = superdex::ActorBoundaryElementType::P1Q1;
      else if (pcQuad == 3) q = superdex::ActorBoundaryElementType::P1Q3;
      else if (pcQuad == 6) q = superdex::ActorBoundaryElementType::P1Q6;
      else if (pcQuad == 7) q = superdex::ActorBoundaryElementType::ExperimentalP1Q7;
      else if (pcQuad == 12) q = superdex::ActorBoundaryElementType::ExperimentalP1Q12;
      else if (pcQuad == 16) q = superdex::ActorBoundaryElementType::ExperimentalP1Q16;
      else { std::fprintf(stderr, "sdx_contact: unknown pcquad q%d\n", pcQuad); return 2; }
      sp.pointCloudCollider.colliderTriangleElementType = q;
    }
    sp.hasGravity = false;
    contact(sp.contact);
    superdex::Actor* const floorActor = mochi::experimental::CreateShellActor(sc, sp, e);
    if (!e.IsOK() || floorActor == nullptr) { std::fprintf(stderr, "sdx_contact: sheet: %s\n", e.ToString().c_str()); return 1; }
    mochi::experimental::ConstrainNodesByPosition(
        floorActor, [](int, superdex::Real3 const&) -> bool { return true; }, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: sheet clamp: %s\n", e.ToString().c_str()); return 1; }
  }
  superdex::RigidActorParams bp;
  bp.name = "cube";
  // a cube of half-size `radius` as a triangle mesh (a dynamic rigid actor needs a surface mesh)
  real const H = static_cast<real>(radius);
  std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  bp.shape = ctx->CreateTriMeshShape(corners, tris, e);
  bp.worldFromLocal.SetTranslation(superdex::Real3{0_r, static_cast<real>(radius + h0), 0_r});
  bp.mass = static_cast<real>(mass);
  if (sdfCell > 0.0 || sdfDiv > 0.0) {
    bp.sdf.resolutionMode = superdex::GridSdfResolutionMode::Explicit;
    real const c = static_cast<real>(sdfDiv > 0.0 ? 2.0 * radius / sdfDiv : sdfCell);
    bp.sdf.resolutionDelta = superdex::Real3{c, c, c};
  }
  bp.linearVelocity = superdex::Real3{static_cast<real>(vx0), 0_r, 0_r};
  contact(bp.contact);
  superdex::Actor* ball = sc->CreateRigidActor(bp, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: cube: %s\n", e.ToString().c_str()); return 1; }
  ball->RegisterQuery(superdex::QueryType::TotalContactForce, e);
  if (lock == 1) {
    superdex::RigidPivotRotationConstraintParams rp;
    if (rotK >= 0.0) rp.stiffness = static_cast<real>(rotK);
    rp.actor = ball->GetHandle();
    sc->CreateRigidPivotRotationConstraint(rp, e);
  }
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: %s\n", e.ToString().c_str()); return 1; }

  FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_contact: cannot write %s\n", argv[1]); return 1; }
  long const steps = static_cast<long>(std::llround(secs / dt));
  std::fprintf(f, "CONTACT dt_ns %lld h0_nm %lld vx0_ums %lld mu_ppm %lld mass_g %lld steps %ld\n", Round(dt * 1e9),
               Round(h0 * 1e9), Round(vx0 * 1e6), Round(mu * 1e6), Round(mass * 1e3), steps);
  long nConverged = 0, nStopped = 0, nDiverged = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  for (long i = 0; i < steps; ++i) {
    // twinscene: before this step a second scene, with its own ground and cube, is made, played one step and
    // destroyed; nothing of it is written
    if (twinAt >= 0.0 && i == static_cast<long>(std::llround(twinAt / dt))) {
      superdex::Scene* const twin = ctx->CreateScene("twin");
      superdex::RigidActorParams tg;
      tg.name = "ground";
      tg.shape = ctx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
      tg.colliderType = superdex::ColliderType::Plane;
      tg.isStatic = true;
      contact(tg.contact);
      twin->CreateRigidActor(tg, e);
      twin->CreateRigidActor(bp, e);
      twin->Step(dt);
      ctx->DestroyScene(twin);
      if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: twin scene: %s\n", e.ToString().c_str()); return 1; }
    }
    // rollout: before this step the scene's state is captured, `rolloutsteps` steps are played with the push
    // `rolloutpush` and not written, and the state is restored
    if (rollAt >= 0.0 && i == static_cast<long>(std::llround(rollAt / dt))) {
      superdex::StateHandle const saved = sc->CaptureState(e);
      int const dof[1] = {0};
      real const fx[1] = {static_cast<real>(rollPush)};
      for (long r = 0; r < rollSteps; ++r) {
        ball->ClearExternalForces();
        ball->SetExternalForcesOnDofs(dof, fx, e);
        sc->Step(dt);
      }
      sc->RestoreState(saved, true, e);
      ball->ClearExternalForces();
      if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: rollout: %s\n", e.ToString().c_str()); return 1; }
    }
    // teleport: before this step the cube is moved along x by `teleportdx`, its rotation and speed kept
    if (teleAt >= 0.0 && i == static_cast<long>(std::llround(teleAt / dt))) {
      superdex::TransformRT tx = ball->GetRootTransform();
      superdex::Real3 const p = tx.GetTranslation();
      tx.SetTranslation(superdex::Real3{p[0] + static_cast<real>(teleDx), p[1], p[2]});
      ball->SetRootTransform(tx, e);
      if (!e.IsOK()) { std::fprintf(stderr, "sdx_contact: teleport: %s\n", e.ToString().c_str()); return 1; }
    }
    bool const lifting = lift != 0.0 && (static_cast<double>(i) + 0.5) * dt >= liftAt;
    if (lifting) {
      int const dof[2] = {0, 1};
      bool const pushing = push != 0.0 && (pushAt <= 0.0 || (static_cast<double>(i) + 0.5) * dt >= pushAt);
      real const fxy[2] = {static_cast<real>(pushing ? push : 0.0), static_cast<real>(lift)};
      ball->ClearExternalForces();
      ball->SetExternalForcesOnDofs(dof, fxy, e);
    } else if (push != 0.0 && (pushAt <= 0.0 || (static_cast<double>(i) + 0.5) * dt >= pushAt)) {
      int const dof[1] = {0};
      real const fx[1] = {static_cast<real>(push)};
      ball->ClearExternalForces();
      ball->SetExternalForcesOnDofs(dof, fx, e);
    }
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;
    superdex::Real3 const p = ball->GetCenterOfMassTransform(e).GetTranslation();
    superdex::Real3 const v = ball->GetLinearVelocity(e);
    superdex::Real3 const cf = ball->GetContactForceWorld(e);
    std::fprintf(f, "%ld %lld %lld %lld %lld %lld\n", i, Round((static_cast<double>(p[1]) - radius) * 1e9),
                 Round(static_cast<double>(v[0]) * 1e6), Round(static_cast<double>(v[1]) * 1e6),
                 Round(static_cast<double>(cf[1]) * 1e3), Round(static_cast<double>(cf[0]) * 1e3));
  }
  std::fclose(f);
  std::printf("STATS contact dt %g h0 %g vx0 %g mu %g lock %d mass %g radius %g steps %ld converged %ld stopped %ld "
              "diverged %ld most_iterations %d real_bits %d extra%s\n",
              dt, h0, vx0, mu, lock, mass, radius, steps, nConverged, nStopped, nDiverged, mostIters,
              static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  if (holder != nullptr) {
    // exitscene: the scene and the context are destroyed after main returns, by the holder
    std::fflush(stdout);
    holder->ctx = ctx;
    holder->sc = sc;
    return 0;
  }
  superdex::DestroyContext(ctx);
  return 0;
}
