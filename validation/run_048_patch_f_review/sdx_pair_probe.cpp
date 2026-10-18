// PROBE COPY of tools/sdx_pair.cpp (review of patch F; not a record rig): adds probefrom/probeto (seconds: the
// window in which the library's SDX_KPROBE lines are switched on), STEP markers on stderr after every step, and
// two of SuperDex's own settings as controls: explicitn=1 (experimentalEval.explicitNormals) and nofade=1
// (experimentalEval.fadeFriction = false).
// sdx_pair.cpp -- the smallest scene with contact between two moving bodies (SuperDex v1.0.0): a large cube A and a
// small cube B. Two layouts:
//   stack  A rests on the ground (if there is one) and B rests on top of A, under gravity
//   side   no ground and no gravity; B is beside A and moves towards it along x
// Rotation is held fixed on both, so what passes between them is a force along the line of contact and friction
// across it and nothing else. What has a right answer whatever the time step:
//   - whatever B does to A, A does to B: with nothing else pushing along x, the total momentum along x of the two
//     cubes never changes;
//   - friction between them obeys Coulomb's law: B rides on A when A is pushed gently, and slips at the friction
//     limit when A is pushed hard.
// The program only plays the scene and writes what each cube did at every step, as whole numbers. The measuring is
// done elsewhere (sx_contact.sx, pair).
//
// usage: sdx_pair <out prefix> dt=<seconds> layout=stack|side [setting=value ...]
//   massa, ra    kg and half-size in metres of A (default 2, 0.1)
//   massb, rb    of B (default 0.5, 0.03)
//   mu           Coulomb friction coefficient of A and of B (default 0); between them it is this value
//   mug          the ground's own coefficient (default 0); between the ground and A SuperDex uses the geometric
//                mean of the two, so 0 here makes the ground frictionless
//   vxa, vxb     speeds along x at release, m/s (default 0, 0)
//   gap          side: the distance between the two facing faces at release, metres (default 0.02)
//   ha, hb       stack: the height of A's lowest face above the ground, and of B's above A's top, at release
//                (default 0, 0)
//   pusha, pushb a constant force along x on A, on B, newtons, from the time `pushat` on (default 0, 0)
//   pushat       seconds (default 0)
//   secs         how long to play (default 1)
//   collider     box = SuperDex's box collider for both cubes; sdf = its grid distance field (default sdf, which is
//                what SuperDex picks by itself for a mesh)
//   ndamp, falloff, penalty, smooth   contact settings, as in sdx_contact (shipped: 0, 0.01, 1e9, 0.005)
//   integ, maxiter, implicitn         as in sdx_contact (shipped: be, 4, 0; default maxiter here 200)
//   rotk     stiffness of the constraint that holds the rotation fixed (shipped default: 1e6)
//   abstol   nonlinear solver absolute residual tolerance (shipped: 1e-3); reltol its relative one (shipped: 1e-6)
//   sdfcell  collider sdf: the largest cell of each cube's grid distance field, metres (SuperDex's GridSdfParams,
//            resolution mode Explicit). Unset: SuperDex sizes the grid from the mesh's mean edge, a quarter of it,
//            with at least 6 cells a side, which for a 12-triangle cube is about a sixth of its side
//   sdfdiv   the same, as a share of each cube's own side: the cell is the side over this number (sdfcell is then
//            not used)
//   integ    time integrator: be bdf2 dirk33 bdf3 dirk22 dirk23 sdirk12 (implicit midpoint) sdirk22 (shipped: be)
// writes <out prefix>_a.txt and <out prefix>_b.txt, each: a header line "CONTACT dt_ns <n> h0_nm <n> vx0_ums <n>
//   mu_ppm <n> mass_g <n> steps <n>", then one line a step: "<step> <place, nm> <vx, um/s> <vy, um/s> <contact force
//   up, mN> <contact force along x, mN>". The place is, stack: for A the height of its lowest face above the ground,
//   for B the height of its lowest face above A's top; side: for A its centre along x, for B the distance between the
//   two facing faces.
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
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
} // namespace

int main(int argc, char** argv) {
  if (argc < 4) {
    std::fprintf(stderr, "usage: sdx_pair <out prefix> dt=<seconds> layout=stack|side [massa=KG] [ra=M] [massb=KG] [rb=M] "
                         "[mu=X] [mug=X] [vxa=V] [vxb=V] [gap=M] [ha=M] [hb=M] [pusha=N] [pushb=N] [pushat=S] [secs=S] "
                         "[collider=box|sdf] [ndamp=X] [falloff=V] [penalty=X] [smooth=M] [integ=NAME] [maxiter=N] [implicitn=1]\n");
    return 2;
  }
  double dt = 0.0, massA = 2.0, rA = 0.1, massB = 0.5, rB = 0.03, mu = 0.0, mug = 0.0, vxa = 0.0, vxb = 0.0, gap = 0.02;
  double ha = 0.0, hb = 0.0, pushA = 0.0, pushB = 0.0, pushAt = 0.0, secs = 1.0;
  double ndamp = -1.0, falloff = -1.0, penalty = -1.0, smooth = -1.0;
  int maxIter = 200, implicitN = 0, box = 0, stack = -1;
  double rotK = -1.0, absTol = -1.0, relTol = -1.0, sdfCell = -1.0, sdfDiv = -1.0;
  double probeFrom = -1.0, probeTo = -1.0; int explicitN = 0, noFade = 0;
  std::string integ = "be", extra;
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto val = [&](char const* key) -> char const* {
      size_t n = std::strlen(key);
      return a.compare(0, n, key) == 0 ? a.c_str() + n : nullptr;
    };
    char const* v = nullptr;
    if ((v = val("dt="))) dt = std::atof(v);
    else if (a == "layout=stack") stack = 1;
    else if (a == "layout=side") stack = 0;
    else if ((v = val("massa="))) massA = std::atof(v);
    else if ((v = val("ra="))) rA = std::atof(v);
    else if ((v = val("massb="))) massB = std::atof(v);
    else if ((v = val("rb="))) rB = std::atof(v);
    else if ((v = val("mug="))) mug = std::atof(v);
    else if ((v = val("mu="))) mu = std::atof(v);
    else if ((v = val("vxa="))) vxa = std::atof(v);
    else if ((v = val("vxb="))) vxb = std::atof(v);
    else if ((v = val("gap="))) gap = std::atof(v);
    else if ((v = val("ha="))) ha = std::atof(v);
    else if ((v = val("hb="))) hb = std::atof(v);
    else if ((v = val("pusha="))) { pushA = std::atof(v); extra += " " + a; }
    else if ((v = val("pushb="))) { pushB = std::atof(v); extra += " " + a; }
    else if ((v = val("pushat="))) { pushAt = std::atof(v); extra += " " + a; }
    else if ((v = val("secs="))) secs = std::atof(v);
    else if (a == "collider=box") { box = 1; extra += " " + a; }
    else if (a == "collider=sdf") { box = 0; }
    else if ((v = val("ndamp="))) { ndamp = std::atof(v); extra += " " + a; }
    else if ((v = val("falloff="))) { falloff = std::atof(v); extra += " " + a; }
    else if ((v = val("penalty="))) { penalty = std::atof(v); extra += " " + a; }
    else if ((v = val("smooth="))) { smooth = std::atof(v); extra += " " + a; }
    else if ((v = val("integ="))) { integ = v; extra += " " + a; }
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("rotk="))) { rotK = std::atof(v); extra += " " + a; }
    else if ((v = val("abstol="))) { absTol = std::atof(v); extra += " " + a; }
    else if ((v = val("reltol="))) { relTol = std::atof(v); extra += " " + a; }
    else if ((v = val("sdfcell="))) { sdfCell = std::atof(v); extra += " " + a; }
    else if ((v = val("sdfdiv="))) { sdfDiv = std::atof(v); extra += " " + a; }
    else if ((v = val("implicitn="))) { implicitN = std::atoi(v); extra += " " + a; }
    else if ((v = val("probefrom="))) probeFrom = std::atof(v);
    else if ((v = val("probeto="))) probeTo = std::atof(v);
    else if ((v = val("explicitn="))) { explicitN = std::atoi(v); extra += " " + a; }
    else if ((v = val("nofade="))) { noFade = std::atoi(v); extra += " " + a; }
    else { std::fprintf(stderr, "sdx_pair: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (dt <= 0.0 || stack < 0) { std::fprintf(stderr, "sdx_pair: dt and layout must be given\n"); return 2; }

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("pair");
  sc->SetGravity(superdex::Real3{0_r, stack == 1 ? -9.8_r : 0_r, 0_r});
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
    else { std::fprintf(stderr, "sdx_pair: unknown integrator %s\n", integ.c_str()); return 2; }
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol > 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol > 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    sol.experimentalEval.implicitNormalForceForDissipation = implicitN != 0;
    if (explicitN != 0) sol.experimentalEval.explicitNormals = true;
    if (noFade != 0) sol.experimentalEval.fadeFriction = false;
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_pair: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  auto contact = [&](superdex::ContactParams& cp, double coefficient) {
    cp.coulombFrictionCoefficient = static_cast<real>(coefficient);
    if (ndamp >= 0.0) cp.normalViscousDampingCoefficient = static_cast<real>(ndamp);
    if (penalty > 0.0) cp.penaltyCoefficient = static_cast<real>(penalty);
    if (smooth > 0.0) cp.penaltySmoothingHalfDistance = static_cast<real>(smooth);
    if (falloff > 0.0) cp.frictionFalloffVel = static_cast<real>(falloff);
  };
  if (stack == 1) {
    superdex::RigidActorParams gp;
    gp.name = "ground";
    gp.shape = ctx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
    gp.colliderType = superdex::ColliderType::Plane;
    gp.isStatic = true;
    contact(gp.contact, mug);
    sc->CreateRigidActor(gp, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_pair: ground: %s\n", e.ToString().c_str()); return 1; }
  }
  // a cube of half-size H as a triangle mesh (a dynamic rigid actor needs a surface mesh)
  auto cube = [&](char const* name, double half, double mass, double x, double y, double vx) -> superdex::Actor* {
    superdex::RigidActorParams bp;
    bp.name = name;
    real const H = static_cast<real>(half);
    std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
    std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                   2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
    bp.shape = ctx->CreateTriMeshShape(corners, tris, e);
    if (box == 1) bp.colliderType = superdex::ColliderType::Box;
    if (sdfCell > 0.0 || sdfDiv > 0.0) {
      bp.sdf.resolutionMode = superdex::GridSdfResolutionMode::Explicit;
      real const c = static_cast<real>(sdfDiv > 0.0 ? 2.0 * half / sdfDiv : sdfCell);
      bp.sdf.resolutionDelta = superdex::Real3{c, c, c};
    }
    bp.worldFromLocal.SetTranslation(superdex::Real3{static_cast<real>(x), static_cast<real>(y), 0_r});
    bp.mass = static_cast<real>(mass);
    bp.linearVelocity = superdex::Real3{static_cast<real>(vx), 0_r, 0_r};
    contact(bp.contact, mu);
    superdex::Actor* a = sc->CreateRigidActor(bp, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_pair: %s: %s\n", name, e.ToString().c_str()); return nullptr; }
    a->RegisterQuery(superdex::QueryType::TotalContactForce, e);
    superdex::RigidPivotRotationConstraintParams rp;
    if (rotK >= 0.0) rp.stiffness = static_cast<real>(rotK);
    rp.actor = a->GetHandle();
    sc->CreateRigidPivotRotationConstraint(rp, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_pair: %s: %s\n", name, e.ToString().c_str()); return nullptr; }
    return a;
  };
  superdex::Actor* A = nullptr;
  superdex::Actor* B = nullptr;
  if (stack == 1) {
    A = cube("a", rA, massA, 0.0, rA + ha, vxa);
    B = cube("b", rB, massB, 0.0, 2.0 * rA + ha + hb + rB, vxb);
  } else {
    A = cube("a", rA, massA, 0.0, 0.0, vxa);
    B = cube("b", rB, massB, -(rA + rB + gap), 0.0, vxb);
  }
  if (A == nullptr || B == nullptr) return 1;

  std::string const pre = argv[1];
  FILE* fa = std::fopen((pre + "_a.txt").c_str(), "w");
  FILE* fb = std::fopen((pre + "_b.txt").c_str(), "w");
  if (fa == nullptr || fb == nullptr) { std::fprintf(stderr, "sdx_pair: cannot write %s\n", argv[1]); return 1; }
  long const steps = static_cast<long>(std::llround(secs / dt));
  std::fprintf(fa, "CONTACT dt_ns %lld h0_nm %lld vx0_ums %lld mu_ppm %lld mass_g %lld steps %ld\n", Round(dt * 1e9),
               Round(ha * 1e9), Round(vxa * 1e6), Round(mu * 1e6), Round(massA * 1e3), steps);
  std::fprintf(fb, "CONTACT dt_ns %lld h0_nm %lld vx0_ums %lld mu_ppm %lld mass_g %lld steps %ld\n", Round(dt * 1e9),
               Round((stack == 1 ? hb : gap) * 1e9), Round(vxb * 1e6), Round(mu * 1e6), Round(massB * 1e3), steps);
  long nConverged = 0, nStopped = 0, nDiverged = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  for (long i = 0; i < steps; ++i) {
    if ((pushA != 0.0 || pushB != 0.0) && (static_cast<double>(i) + 0.5) * dt >= pushAt) {
      int const dof[1] = {0};
      real const fA[1] = {static_cast<real>(pushA)};
      real const fB[1] = {static_cast<real>(pushB)};
      A->ClearExternalForces();
      B->ClearExternalForces();
      if (pushA != 0.0) A->SetExternalForcesOnDofs(dof, fA, e);
      if (pushB != 0.0) B->SetExternalForcesOnDofs(dof, fB, e);
    }
    { double const tEnd = (static_cast<double>(i) + 1.0) * dt;
      bool const on = probeFrom >= 0.0 && tEnd > probeFrom - 0.5 * dt && tEnd < probeTo + 0.5 * dt;
      setenv("SDX_KPROBE_ON", on ? "1" : "0", 1); }
    sc->Step(dt);
    std::fprintf(stderr, "STEP %ld %.9g\n", i, (static_cast<double>(i) + 1.0) * dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;
    superdex::Real3 const pa = A->GetCenterOfMassTransform(e).GetTranslation();
    superdex::Real3 const pb = B->GetCenterOfMassTransform(e).GetTranslation();
    superdex::Real3 const va = A->GetLinearVelocity(e);
    superdex::Real3 const vb = B->GetLinearVelocity(e);
    superdex::Real3 const ca = A->GetContactForceWorld(e);
    superdex::Real3 const cb = B->GetContactForceWorld(e);
    double const placeA = stack == 1 ? static_cast<double>(pa[1]) - rA : static_cast<double>(pa[0]);
    double const placeB = stack == 1 ? (static_cast<double>(pb[1]) - rB) - (static_cast<double>(pa[1]) + rA)
                                     : (static_cast<double>(pa[0]) - rA) - (static_cast<double>(pb[0]) + rB);
    std::fprintf(fa, "%ld %lld %lld %lld %lld %lld\n", i, Round(placeA * 1e9), Round(static_cast<double>(va[0]) * 1e6),
                 Round(static_cast<double>(va[1]) * 1e6), Round(static_cast<double>(ca[1]) * 1e3),
                 Round(static_cast<double>(ca[0]) * 1e3));
    std::fprintf(fb, "%ld %lld %lld %lld %lld %lld\n", i, Round(placeB * 1e9), Round(static_cast<double>(vb[0]) * 1e6),
                 Round(static_cast<double>(vb[1]) * 1e6), Round(static_cast<double>(cb[1]) * 1e3),
                 Round(static_cast<double>(cb[0]) * 1e3));
  }
  std::fclose(fa);
  std::fclose(fb);
  std::printf("STATS pair dt %g layout %s massa %g ra %g massb %g rb %g mu %g mug %g steps %ld converged %ld stopped %ld "
              "diverged %ld most_iterations %d real_bits %d extra%s\n",
              dt, stack == 1 ? "stack" : "side", massA, rA, massB, rB, mu, mug, steps, nConverged, nStopped, nDiverged,
              mostIters, static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  superdex::DestroyContext(ctx);
  return 0;
}
