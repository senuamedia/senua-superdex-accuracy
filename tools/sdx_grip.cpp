// sdx_grip.cpp: the smallest manipulation scene SuperDex can be asked about (SuperDex v1.0.0): a parallel-jaw
// gripper holding one rigid cube between its two fingers, under gravity. The gripper's base is fixed in space, each
// finger slides on one prismatic joint, and a commanded force on each finger joint presses the finger against the
// cube. Nothing else is in the scene: no ground and no table. Write m for the cube's mass, mu for the friction
// coefficient, F for the grip force on each finger and g for gravity (9.8 m/s^2). Four things about the scene have a
// right answer that does not depend on the time step:
//   - hold: when 2 mu F >= m g, friction can carry the cube, so it must not slip;
//   - slide: when 2 mu F < m g, Coulomb's law leaves a net force of m g - 2 mu F, so the cube must fall at
//     g - 2 mu F / m for as long as both fingers are on it;
//   - grip force: a finger at rest feels its joint force and the cube and nothing else along its line of travel, so
//     each finger must press on the cube with exactly F;
//   - symmetry: the two fingers do the same thing from opposite sides, so the cube must not move sideways and must
//     not turn.
// The program only plays the scene and writes what happened at every step, as whole numbers. The measuring is done
// elsewhere.
//
// Two grippers, chosen with gripper=:
//   fr3    the Franka FR3 arm and hand shipped with SuperDex (assets/franka_arm/fr3/fr3.mochi_prefab, Apache-2.0).
//          The prefab is loaded as shipped and three things are changed before it goes into the scene, the way
//          SuperDex's own test changes it (mochi_newton_euler_test.cpp, CreateFr3Actor): every joint that is not a
//          finger joint is made a weld, so the arm is a fixed mount and the hand points straight down; every link
//          that is not a finger loses its collider, so only the fingers can touch the cube; and the shipped pose
//          controller is left out, because it would hold each finger joint with a spring. The two finger links,
//          their meshes, their distance-field colliders, their density and their joints are as shipped.
//   built  a gripper made by hand in this file: a welded palm that nothing can touch and two box fingers, each on
//          one prismatic joint that opens as its coordinate grows. By default the boxes have the outer size of the
//          FR3 finger's mesh, the mass of a solid box of the FR3 links' density (1000 kg/m^3) and the FR3 finger
//          joint's limits (0 to 0.04 m). Nothing in it comes from a file, so it is the control.
// Either way the grip force is a force on each finger's joint coordinate (Actor::SetExternalForcesOnDofs on the
// gripper), with the sign that moves that finger towards the other one. No controller is used.
//
// Nothing about a gripper's layout is assumed. Before the cube is made the program asks SuperDex: which two joints
// are prismatic, where each finger's link goes when its joint coordinate grows, and the bounding box of each finger
// in its own frame. From those it takes the grip axis (the line the fingers travel on, which must be level), the
// face of each finger that looks at the other, and the lowest point of the fingers. It then puts the two fingers
// `clear` metres from the cube's faces, each as near the middle of its travel as that allows, and makes the cube
// midway between them, turned about the vertical so that two of its faces are square to the grip axis, with its
// centre `tip` metres above the fingers' lowest point. What it found is written in the header line.
//
// The play has two phases. Settle: the cube is supported while the fingers close; the grip force rises in a
// straight line from zero over `ramp` seconds and then stays. Hold: from `settle` seconds on the support is gone
// and only the fingers carry the cube.
//
// usage: sdx_grip <out.txt> [setting=value ...]
//   gripper  fr3 or built (default fr3)
//   assets   the directory that holds franka_arm/fr3 (SuperDex's superdex_physics/assets); needed for gripper=fr3
//   dt       time step, seconds (default 0.01, the step of SuperDex's shipped contact benchmarks)
//   secs     how long to play (default 2)
//   settle   seconds at which the support is removed (default 0.5)
//   ramp     seconds over which the grip force rises from zero (default 0.1; 0 = full force from the first step)
//   mass, half   the cube's mass in kg and its half-size in metres (default 0.1, 0.01)
//   mu       Coulomb friction coefficient on every contact surface (default 0.5, SuperDex's own)
//   grip     the force on each finger's joint, newtons (default 10)
//   penalty, smooth, falloff, ndamp, visc   contact penalty stiffness, penalty smoothing half-distance, the sliding
//            speed under which friction falls away, the normal viscous damping coefficient and the viscous friction
//            coefficient, set on the cube, the gripper and every link (defaults are the shipped values: 1e9, 0.005,
//            0.01, 0, 0)
//   collider sdf = the cube and the hand-built fingers use the collider SuperDex picks by itself for a mesh, its
//            grid distance field; box = they use its box collider (default sdf). The FR3 fingers always keep the
//            collider their prefab names.
//   support  force = during the settle phase an upward force of m g on the cube cancels its weight, as the lift
//            in sdx_contact; gravity = the scene has no gravity during the settle phase and gets it at `settle`
//            seconds (default force)
//   clear    the distance between each finger's bounding box and the cube's face at the start, metres (default
//            0.001, the distance at which SuperDex's contact begins)
//   tip      the height of the cube's centre above the fingers' lowest point, metres (default: half, so the cube's
//            lower face is level with the fingertips)
//   jvisc    viscous friction of the two finger joints (default: as the gripper has it, which is 10 for the
//            shipped FR3 and 0 for the hand-built gripper)
//   fthick, flen, fwide   gripper=built only: the finger box's size along the grip axis, along the vertical and
//            across, metres (default 0.0264, 0.0539, 0.0210: the outer size of the FR3 finger's mesh)
//   integ    time integrator: be bdf2 bdf3 dirk22 dirk23 dirk33 sdirk12 sdirk22 (shipped: be)
//   maxiter  nonlinear iteration limit (default 200; shipped 4)
//   abstol   nonlinear solver absolute residual tolerance (shipped: 1e-3); reltol its relative one (shipped: 1e-6)
//   SuperDex's own evaluation switches, at their shipped values unless given: implicitn=1, expnormals=1, fade=0,
//   fricmodel=cinf, armijo=1, as in sdx_contact; newtoneuler=1 = SuperDex's experimental Newton-Euler inertia on
//   the gripper, as in sdx_joint.
//
// writes <out.txt>. All numbers are whole. Lengths are in nanometres, speeds in micrometres a second, angles in
// micro-radians, forces in micro-newtons. Three directions are used throughout: n, the grip axis, level, pointing
// from finger B to finger A; u, straight up; t = n x u, level and across the grip. Finger A is the finger on the
// +n side of the cube.
//
// The first line is "GRIP" followed by pairs "<name> <number>":
//   dt_ns secs_ns steps release_step settle_ns ramp_ns   the play; release_step is the first step of the hold phase
//   maxiter abstol_ppb implicitn expnormals fade cinf armijo   the solver settings in force, read back from the scene
//   integ    0 be, 1 bdf2, 2 bdf3, 3 dirk22, 4 dirk23, 5 dirk33, 6 sdirk12, 7 sdirk22
//   gripper  0 fr3, 1 built;  collider  0 sdf, 1 box;  support  0 force, 1 gravity;  newtoneuler  0 or 1
//   mass_mg half_nm mu_ppm grip_uN penalty_Pa_m smooth_nm falloff_nms ndamp_ppm visc_ppm clear_nm tip_nm
//   jvisc_ppm   -1 when not given
//   fthick_nm flen_nm fwide_nm fmass_mg   the hand-built finger box and its mass (used by gripper=built only)
//   real_bits dofs links contact_actors_set   32 or 64; the gripper's degrees of freedom and links; how many
//            actors and links took the contact settings
//   link_query   1 = finger A's link accepted the contact force query, 2 = finger B's did, 3 = both
//   axis_x_ppb axis_y_ppb axis_z_ppb   n in world axes; axis_up_ppb, the upward part of the fingers' line of
//            travel that was taken off to make n level
//   turn_urad   how far the cube is turned about the vertical to face the fingers
//   gap_nm maxgap_nm   the distance between the two fingers' facing faces at the start, and the widest the gripper
//            can make it inside its joint limits
//   cube_x_nm cube_y_nm cube_z_nm   the cube's centre at the start, world axes
//   then for finger A and for finger B (names begin a_ and b_):
//     link dof   its link and its degree of freedom in the gripper
//     dir      +1 = the finger moves along +n when its joint coordinate grows, -1 = along -n
//     opens    1 = the gripper opens when this joint coordinate grows, 0 = it closes
//     close    the sign of the joint force that closes this finger (the row's command times this is applied)
//     q0_nm lo_nm hi_nm   its joint coordinate at the start and its joint limits
//     thick_nm long_nm wide_nm   its bounding box along n, u and t
// then one line a solver step, 30 numbers:
//    1 step
//    2 phase        0 = settle (cube supported), 1 = hold
//    3 read         which readings SuperDex gave this step: 1 total contact force on the cube, 2 the force on the
//                   cube from finger A, 4 from finger B, 8 total contact force on finger A's link, 16 on finger
//                   B's, 32 the positions and speeds; added together. A force that was not given is written 0, and
//                   a place that was not given is written as where it started.
//    4 command      the grip force commanded on each finger joint during this step, uN
//    5 height       the cube's centre along u, less where it started, nm
//    6 vertical speed   of the cube's centre, um/s
//    7 along        the cube's centre along n, less where it started, nm (sideways, towards finger A)
//    8 across       the cube's centre along t, less where it started, nm
//    9 roll         the cube's turn about n since the start, urad
//   10 pitch        its turn about t, urad
//   11 yaw          its turn about u, urad
//   12 slip A       the cube's height less finger A's height, less the same at the start, nm
//   13 slip B       the same against finger B
//   14 q A          finger A's joint coordinate, nm
//   15 q B
//   16 joint speed A   um/s
//   17 joint speed B
//   18 clearance A  from finger A's facing face to the cube's face, nm; negative when the two boxes overlap
//   19 clearance B
//   20 normal A     the force on the cube from finger A, along the grip axis, positive when it presses the cube
//                   towards finger B, uN (Actor::GetContactForceFromActorWorld on the cube)
//   21 normal B     the same from finger B, positive when it presses the cube towards finger A
//   22 lift A       the force on the cube from finger A along u, uN (friction that carries the cube is positive)
//   23 lift B
//   24 drag A       the force on the cube from finger A along t, uN
//   25 drag B
//   26 27 28        the total contact force on the cube along n, u and t, uN (Actor::GetContactForceWorld)
//   29 push A       the total contact force on finger A's link along +n, uN: the cube pushing that finger away
//   30 push B       the total contact force on finger B's link along -n, uN
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>

#include <mochi_physics/mochi_physics_experimental.h>
#include <mochi_physics/utils/mochi_prefab.h>

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

constexpr double kGravity = 9.8;          // SuperDex's default gravity, and the other rigs'
constexpr double kFingerDensity = 1000.0; // kg/m^3: what the FR3 prefab gives every link
constexpr double kFingerTravel = 0.04;    // metres: the FR3 finger joint's limits are 0 to 0.04
constexpr double kPalmHalf = 0.01;        // metres: the hand-built palm, a cube nothing can touch

long long Round(double x) { return static_cast<long long>(std::llround(x)); }

// plain vectors in double precision, for the arithmetic this program does itself
struct V3 { double x, y, z; };
V3 From(superdex::Real3 const& r) {
  return V3{static_cast<double>(r[0]), static_cast<double>(r[1]), static_cast<double>(r[2])};
}
double VDot(V3 const& a, V3 const& b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
V3 VSub(V3 const& a, V3 const& b) { return V3{a.x - b.x, a.y - b.y, a.z - b.z}; }
V3 VScale(V3 const& a, double s) { return V3{a.x * s, a.y * s, a.z * s}; }
V3 VCross(V3 const& a, V3 const& b) {
  return V3{a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x};
}
double VLen(V3 const& a) { return std::sqrt(VDot(a, a)); }

// the reach of one finger's bounding box along n, u and t, and where its link's frame is, in world axes
struct Reach { double nLo, nHi, uLo, uHi, tLo, tHi; V3 origin; };

int Fail(char const* what, superdex::Error const& e) {
  std::fprintf(stderr, "sdx_grip: %s: %s\n", what, e.ToString().c_str());
  return 1;
}

// a box of half-sizes a, b, c along x, y, z as a triangle mesh (a dynamic body needs a surface mesh)
superdex::ShapeHandle BoxShape(superdex::Context* ctx, double a, double b, double c, superdex::Error& e) {
  real const A = static_cast<real>(a), B = static_cast<real>(b), C = static_cast<real>(c);
  std::vector<real> const corners = {-A, -B, -C, A, -B, -C, -A, B, -C, A, B, -C, -A, -B, C, A, -B, C, -A, B, C, A, B, C};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  return ctx->CreateTriMeshShape(corners, tris, e);
}

} // namespace

int main(int argc, char** argv) {
  if (argc < 2) {
    std::fprintf(stderr, "usage: sdx_grip <out.txt> [gripper=fr3|built] [assets=DIR] [dt=S] [secs=S] [settle=S] [ramp=S] "
                         "[mass=KG] [half=M] [mu=X] [grip=N] [penalty=X] [smooth=M] [falloff=V] [ndamp=X] [visc=X] "
                         "[collider=sdf|box] [support=force|gravity] [clear=M] [tip=M] [jvisc=X] [fthick=M] [flen=M] "
                         "[fwide=M] [integ=NAME] [maxiter=N] [abstol=X] [implicitn=1] [expnormals=1] [fade=0] "
                         "[fricmodel=cinf] [armijo=1] [newtoneuler=1]\n");
    return 2;
  }
  struct IntegName { char const* name; superdex::IntegrationMethod method; };
  IntegName const kIntegs[] = {
      {"be", superdex::IntegrationMethod::BackwardEuler},     {"bdf2", superdex::IntegrationMethod::BDF2},
      {"bdf3", superdex::IntegrationMethod::BDF3},            {"dirk22", superdex::IntegrationMethod::DIRK22},
      {"dirk23", superdex::IntegrationMethod::DIRK23},        {"dirk33", superdex::IntegrationMethod::DIRK33},
      {"sdirk12", superdex::IntegrationMethod::SymplecticDIRK12},
      {"sdirk22", superdex::IntegrationMethod::SymplecticDIRK22},
  };
  int integ = 0;
  double dt = 0.01, secs = 2.0, settle = 0.5, ramp = 0.1, mass = 0.1, half = 0.01, mu = 0.5, grip = 10.0;
  double penalty = 1e9, smooth = 0.005, falloff = 0.01, ndamp = 0.0, visc = 0.0, clear = 0.001, tip = -1.0;
  double jvisc = -1.0, fthick = 0.0264, flen = 0.0539, fwide = 0.0210, absTol = -1.0;
  double relTol = -1.0;
  int maxIter = 200, built = 0, box = 0, gravSupport = 0, newtonEuler = 0;
  int implicitN = -1, expNormals = -1, fade = -1, cinf = 0, armijo = 0;
  std::string assets, extra;
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto val = [&](char const* key) -> char const* {
      size_t n = std::strlen(key);
      return a.compare(0, n, key) == 0 ? a.c_str() + n : nullptr;
    };
    char const* v = nullptr;
    if ((v = val("dt="))) dt = std::atof(v);
    else if ((v = val("secs="))) secs = std::atof(v);
    else if ((v = val("settle="))) settle = std::atof(v);
    else if ((v = val("ramp="))) ramp = std::atof(v);
    else if ((v = val("mass="))) mass = std::atof(v);
    else if ((v = val("half="))) half = std::atof(v);
    else if ((v = val("mu="))) mu = std::atof(v);
    else if ((v = val("grip="))) grip = std::atof(v);
    else if (a == "gripper=fr3") built = 0;
    else if (a == "gripper=built") built = 1;
    else if ((v = val("assets="))) assets = v;
    else if ((v = val("penalty="))) { penalty = std::atof(v); extra += " " + a; }
    else if ((v = val("smooth="))) { smooth = std::atof(v); extra += " " + a; }
    else if ((v = val("falloff="))) { falloff = std::atof(v); extra += " " + a; }
    else if ((v = val("ndamp="))) { ndamp = std::atof(v); extra += " " + a; }
    else if ((v = val("visc="))) { visc = std::atof(v); extra += " " + a; }
    else if (a == "collider=sdf") box = 0;
    else if (a == "collider=box") { box = 1; extra += " " + a; }
    else if (a == "support=force") gravSupport = 0;
    else if (a == "support=gravity") { gravSupport = 1; extra += " " + a; }
    else if ((v = val("clear="))) { clear = std::atof(v); extra += " " + a; }
    else if ((v = val("tip="))) { tip = std::atof(v); extra += " " + a; }
    else if ((v = val("jvisc="))) { jvisc = std::atof(v); extra += " " + a; }
    else if ((v = val("fthick="))) { fthick = std::atof(v); extra += " " + a; }
    else if ((v = val("flen="))) { flen = std::atof(v); extra += " " + a; }
    else if ((v = val("fwide="))) { fwide = std::atof(v); extra += " " + a; }
    else if ((v = val("integ="))) {
      int found = -1;
      for (int k = 0; k < static_cast<int>(sizeof(kIntegs) / sizeof(kIntegs[0])); ++k)
        if (std::strcmp(v, kIntegs[k].name) == 0) found = k;
      if (found < 0) { std::fprintf(stderr, "sdx_grip: unknown integrator %s\n", v); return 2; }
      integ = found;
      extra += " " + a;
    }
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("abstol="))) { absTol = std::atof(v); extra += " " + a; }
    else if ((v = val("reltol="))) { relTol = std::atof(v); extra += " " + a; }
    else if ((v = val("implicitn="))) { implicitN = std::atoi(v); extra += " " + a; }
    else if ((v = val("expnormals="))) { expNormals = std::atoi(v); extra += " " + a; }
    else if ((v = val("fade="))) { fade = std::atoi(v); extra += " " + a; }
    else if (a == "fricmodel=cinf") { cinf = 1; extra += " " + a; }
    else if ((v = val("armijo="))) { armijo = std::atoi(v); extra += " " + a; }
    else if ((v = val("newtoneuler="))) { newtonEuler = std::atoi(v); extra += " " + a; }
    else { std::fprintf(stderr, "sdx_grip: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (tip < 0.0) tip = half;
  if (!(dt > 0.0) || !(secs > 0.0) || !(mass > 0.0) || !(half > 0.0) || grip < 0.0 || mu < 0.0 || clear < 0.0 ||
      settle < 0.0 || ramp < 0.0 || !(penalty > 0.0) || smooth < 0.0 || falloff < 0.0 || ndamp < 0.0 || visc < 0.0 ||
      !(fthick > 0.0) || !(flen > 0.0) || !(fwide > 0.0)) {
    std::fprintf(stderr, "sdx_grip: a setting is out of range\n");
    return 2;
  }
  if (built == 0 && assets.empty()) {
    std::fprintf(stderr, "sdx_grip: gripper=fr3 needs assets=<SuperDex's superdex_physics/assets directory>\n");
    return 2;
  }

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("grip");
  sc->SetGravity(superdex::Real3{0_r, gravSupport == 1 ? 0_r : -9.8_r, 0_r});

  // the contact settings, the same on every surface
  auto contact = [&](superdex::ContactParams& cp) {
    cp.coulombFrictionCoefficient = static_cast<real>(mu);
    cp.penaltyCoefficient = static_cast<real>(penalty);
    cp.penaltySmoothingHalfDistance = static_cast<real>(smooth);
    cp.frictionFalloffVel = static_cast<real>(falloff);
    cp.normalViscousDampingCoefficient = static_cast<real>(ndamp);
    cp.viscousFrictionCoefficient = static_cast<real>(visc);
  };

  // the gripper
  superdex::Actor* hand = nullptr;
  double const fingerMass = kFingerDensity * fthick * flen * fwide; // a solid box of the FR3 links' density
  if (built == 1) {
    superdex::ShapeHandle const palmShape = BoxShape(ctx, kPalmHalf, kPalmHalf, kPalmHalf, e);
    superdex::ShapeHandle const fingerShape = BoxShape(ctx, 0.5 * fthick, 0.5 * flen, 0.5 * fwide, e);
    if (!e.IsOK()) return Fail("finger shape", e);
    superdex::ArticulatedActorParams ap;
    ap.name = "gripper";
    superdex::ArticulatedJointParams weld;
    weld.name = "weld";
    weld.type = superdex::ArticulatedJointType::Hard;
    ap.joints.push_back(weld);
    superdex::ArticulatedLinkParams palm;
    palm.name = "palm";
    palm.parentLink = -1;
    palm.shape = palmShape;
    palm.colliderType = superdex::ColliderType::None;
    palm.mass = 1_r;
    ap.links.push_back(palm);
    // finger 0 travels along +x and finger 1 along -x, so each opens as its coordinate grows; at coordinate zero
    // the two facing faces meet at x = 0. A prismatic joint's limits are read along its axis.
    for (int k = 0; k < 2; ++k) {
      real const sx = k == 0 ? 1_r : -1_r;
      superdex::ArticulatedJointParams slide;
      slide.name = k == 0 ? "slide_0" : "slide_1";
      slide.type = superdex::ArticulatedJointType::Prismatic;
      slide.axis = superdex::Real3{sx, 0_r, 0_r};
      slide.minLimit = superdex::Real3{0_r, 0_r, 0_r};
      slide.maxLimit = superdex::Real3{sx * static_cast<real>(kFingerTravel), 0_r, 0_r};
      if (jvisc >= 0.0) slide.friction.viscous = static_cast<real>(jvisc);
      ap.joints.push_back(slide);
      superdex::ArticulatedLinkParams fl;
      fl.name = k == 0 ? "finger_0" : "finger_1";
      fl.parentLink = 0;
      fl.shape = fingerShape;
      if (box == 1) fl.colliderType = superdex::ColliderType::Box;
      fl.mass = static_cast<real>(fingerMass);
      contact(fl.contact);
      // the box hangs under the palm, its centre half a thickness out from the joint along the finger's travel
      fl.parentJointFromLink.SetTranslation(
          superdex::Real3{sx * static_cast<real>(0.5 * fthick), static_cast<real>(-(kPalmHalf + 0.5 * flen)), 0_r});
      ap.links.push_back(fl);
    }
    hand = sc->CreateArticulatedActor(ap, e);
    if (!e.IsOK()) return Fail("gripper", e);
  } else {
    std::string const prefabPath = assets + "/franka_arm/fr3/fr3.mochi_prefab";
    superdex::prefab::ScenePrefab p = superdex::prefab::LoadFromFile(prefabPath, assets, ctx, e);
    if (!e.IsOK()) return Fail("load prefab", e);
    if (p.actors.articulated.size() != 1) {
      std::fprintf(stderr, "sdx_grip: expected one articulated actor in %s\n", prefabPath.c_str());
      return 1;
    }
    auto& arm = p.actors.articulated[0];
    if (arm.joints.size() != arm.links.size()) {
      std::fprintf(stderr, "sdx_grip: the prefab's joints and links do not pair up\n");
      return 1;
    }
    // joint i carries link i. Everything that is not a finger joint is welded, root joint included.
    for (size_t i = 0; i < arm.joints.size(); ++i) {
      if (arm.joints[i].type == superdex::ArticulatedJointType::Prismatic) {
        if (jvisc >= 0.0) arm.joints[i].friction.viscous = static_cast<real>(jvisc);
        contact(arm.links[i].contact);
      } else {
        arm.joints[i].type = superdex::ArticulatedJointType::Hard;
        arm.links[i].colliderType = superdex::ColliderType::None;
      }
    }
    p.controllers.clear();
    // the prefab is drawn with z up; SuperDex's world has y up
    superdex::prefab::PrefabParams pp;
    pp.rotation = superdex::Quaternion::RotationX(-90_r * superdex::kRadiansPerDegree);
    superdex::prefab::AddToScene(p, sc, pp, e);
    if (!e.IsOK()) return Fail("add prefab to scene", e);
    sc->ForEachActor([&](superdex::Actor* a) {
      if (a->GetType() == superdex::ActorType::Articulated) hand = a;
    });
    if (hand == nullptr) { std::fprintf(stderr, "sdx_grip: the prefab made no articulated actor\n"); return 1; }
  }
  if (newtonEuler == 1) {
    mochi::experimental::EnableNewtonEulerInertia(hand, true, e);
    if (!e.IsOK()) return Fail("newton-euler inertia", e);
  }

  // the settings under test
  {
    superdex::SolverParams sol = sc->GetSolverParams();
    sol.integrationMethod = kIntegs[integ].method;
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol > 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol > 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    if (implicitN >= 0) sol.experimentalEval.implicitNormalForceForDissipation = implicitN != 0;
    if (expNormals >= 0) sol.experimentalEval.explicitNormals = expNormals != 0;
    if (fade >= 0) sol.experimentalEval.fadeFriction = fade != 0;
    if (cinf == 1) sol.experimentalEval.frictionModel = superdex::CoulombFrictionModel::CinfRegularized;
    if (armijo == 1) sol.nonLinearSolver.lineSearchType = superdex::LineSearchType::Armijo;
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) return Fail("solver params", e);
  }
  superdex::SolverParams const inForce = sc->GetSolverParams();

  // the two fingers: the links whose own joint is prismatic
  superdex::ArticulatedShapeInfo const info = hand->GetArticulatedShapeInfo(e);
  if (!e.IsOK()) return Fail("gripper shape", e);
  std::vector<superdex::ActorHandle> linkHandles;
  for (superdex::ActorHandle h : hand->GetNestedLinkActors(e)) linkHandles.push_back(h);
  if (!e.IsOK()) return Fail("gripper links", e);
  int const nLinks = static_cast<int>(linkHandles.size());
  int const nDof = hand->GetNumDofs();
  int fLink[2] = {-1, -1}, fDof[2] = {-1, -1}, nFingers = 0;
  for (int i = 0; i < nLinks && i < static_cast<int>(info.jointTypes.size()); ++i) {
    if (info.jointTypes[static_cast<size_t>(i)] != superdex::ArticulatedJointType::Prismatic) continue;
    if (nFingers < 2) {
      fLink[nFingers] = i;
      fDof[nFingers] = info.dofInfo[static_cast<size_t>(i)].offset;
    }
    ++nFingers;
  }
  if (nFingers != 2 || fDof[0] < 0 || fDof[1] < 0 || fDof[0] >= nDof || fDof[1] >= nDof) {
    std::fprintf(stderr, "sdx_grip: the gripper has %d prismatic joints; two are needed\n", nFingers);
    return 1;
  }
  superdex::Actor* const finger[2] = {sc->GetActor(linkHandles[static_cast<size_t>(fLink[0])]),
                                      sc->GetActor(linkHandles[static_cast<size_t>(fLink[1])])};
  if (finger[0] == nullptr || finger[1] == nullptr) { std::fprintf(stderr, "sdx_grip: no finger link\n"); return 1; }

  std::vector<real> pose(static_cast<size_t>(nDof), 0_r), vel(static_cast<size_t>(nDof), 0_r);
  std::vector<superdex::TransformRT> tx(static_cast<size_t>(nLinks));
  std::vector<superdex::Real2> lim(static_cast<size_t>(nDof));
  hand->GetArticulatedDofLimits(superdex::Span<superdex::Real2>(lim.data(), lim.size()), e);
  if (!e.IsOK()) return Fail("joint limits", e);
  double lo[2], hi[2], mid[2];
  for (int k = 0; k < 2; ++k) {
    lo[k] = static_cast<double>(lim[static_cast<size_t>(fDof[k])][0]);
    hi[k] = static_cast<double>(lim[static_cast<size_t>(fDof[k])][1]);
    if (!std::isfinite(lo[k]) || !std::isfinite(hi[k]) || !(hi[k] > lo[k])) {
      std::fprintf(stderr, "sdx_grip: a finger joint has no limits to place it by\n");
      return 1;
    }
    mid[k] = 0.5 * (lo[k] + hi[k]);
  }
  // put the two fingers at given joint coordinates and read where every link is
  auto place = [&](double q0, double q1) -> bool {
    superdex::Error le;
    pose[static_cast<size_t>(fDof[0])] = static_cast<real>(q0);
    pose[static_cast<size_t>(fDof[1])] = static_cast<real>(q1);
    hand->SetArticulatedPoseFromJoints(superdex::Span<real const>(pose.data(), pose.size()), le);
    hand->GetArticulatedLinkTransforms(superdex::Span<superdex::TransformRT>(tx.data(), tx.size()), le);
    if (!le.IsOK()) std::fprintf(stderr, "sdx_grip: place fingers: %s\n", le.ToString().c_str());
    return le.IsOK();
  };
  auto origin = [&](int k) -> V3 { return From(tx[static_cast<size_t>(fLink[k])].GetTranslation()); };

  // where each finger goes when its joint coordinate grows: move it a known distance and look
  double const probe = 0.25 * std::fmin(hi[0] - lo[0], hi[1] - lo[1]);
  V3 travel[2];
  {
    if (!place(mid[0], mid[1])) return 1;
    V3 const at0 = origin(0), at1 = origin(1);
    if (!place(mid[0] + probe, mid[1])) return 1;
    travel[0] = VScale(VSub(origin(0), at0), 1.0 / probe);
    if (!place(mid[0], mid[1] + probe)) return 1;
    travel[1] = VScale(VSub(origin(1), at1), 1.0 / probe);
    if (!place(mid[0], mid[1])) return 1;
  }
  if (std::fabs(VLen(travel[0]) - 1.0) > 1e-3 || std::fabs(VLen(travel[1]) - 1.0) > 1e-3) {
    std::fprintf(stderr, "sdx_grip: a finger does not move one metre for one metre of its joint coordinate\n");
    return 1;
  }
  V3 const U{0.0, 1.0, 0.0};
  double const axisUp = VDot(travel[0], U);
  V3 const level = VSub(travel[0], VScale(U, axisUp));
  if (std::fabs(axisUp) > 1e-3 || !(VLen(level) > 0.5)) {
    std::fprintf(stderr, "sdx_grip: the fingers do not travel on a level line\n");
    return 1;
  }
  // the grip axis n: level, along the way the first finger travels when its joint coordinate grows
  V3 const N = VScale(level, 1.0 / VLen(level));
  V3 const T = VCross(N, U);
  double const along1 = VDot(travel[1], N);
  if (std::fabs(std::fabs(along1) - 1.0) > 1e-3) {
    std::fprintf(stderr, "sdx_grip: the two fingers do not travel on one line\n");
    return 1;
  }

  // each finger's bounding box where the finger now is, seen along n, u and t
  auto reach = [&](int k, Reach& out) -> bool {
    superdex::Error le;
    superdex::Aabb const bb = finger[k]->GetAabbLocal(le);
    if (!le.IsOK()) {
      std::fprintf(stderr, "sdx_grip: finger bounding box: %s\n", le.ToString().c_str());
      return false;
    }
    superdex::Real3 const c = bb.GetCenter();
    superdex::Real3 const h = bb.GetHalfExtents();
    superdex::TransformRT const& w = tx[static_cast<size_t>(fLink[k])];
    for (int corner = 0; corner < 8; ++corner) {
      real const cx = (corner & 1) != 0 ? c[0] + h[0] : c[0] - h[0];
      real const cy = (corner & 2) != 0 ? c[1] + h[1] : c[1] - h[1];
      real const cz = (corner & 4) != 0 ? c[2] + h[2] : c[2] - h[2];
      V3 const pt = From(w.TransformPoint(superdex::Real3{cx, cy, cz}));
      double const pn = VDot(pt, N), pu = VDot(pt, U), ptv = VDot(pt, T);
      if (corner == 0 || pn < out.nLo) out.nLo = pn;
      if (corner == 0 || pn > out.nHi) out.nHi = pn;
      if (corner == 0 || pu < out.uLo) out.uLo = pu;
      if (corner == 0 || pu > out.uHi) out.uHi = pu;
      if (corner == 0 || ptv < out.tLo) out.tLo = ptv;
      if (corner == 0 || ptv > out.tHi) out.tHi = ptv;
    }
    out.origin = From(w.GetTranslation());
    return true;
  };

  // which finger is on which side: finger A is the one whose box lies further along n, so n points from B to A
  Reach r0{}, r1{};
  if (!reach(0, r0) || !reach(1, r1)) return 1;
  bool const zeroIsA = (r0.nLo + r0.nHi) >= (r1.nLo + r1.nHi);
  int const ia = zeroIsA ? 0 : 1, ib = 1 - ia;
  // the sign of each finger's travel along n when its joint coordinate grows; the first finger's is +1 by the
  // choice of n
  int const dir[2] = {1, along1 > 0.0 ? 1 : -1};
  // finger A opens by moving along +n and closes by moving along -n; finger B the other way round
  int const closeSign[2] = {ia == 0 ? -dir[0] : dir[0], ia == 1 ? -dir[1] : dir[1]};

  // put each finger `clear` from the cube's face. The gap between the facing faces has to be 2 (half + clear);
  // each finger takes half of the change from the middle of its travel.
  Reach const& ra0 = zeroIsA ? r0 : r1;
  Reach const& rb0 = zeroIsA ? r1 : r0;
  double const gapMid = ra0.nLo - rb0.nHi;
  double const want = 2.0 * (half + clear);
  double q[2];
  q[ia] = mid[ia] + dir[ia] * 0.5 * (want - gapMid);
  q[ib] = mid[ib] - dir[ib] * 0.5 * (want - gapMid);
  double const maxGap = gapMid + (dir[ia] > 0 ? hi[ia] - mid[ia] : mid[ia] - lo[ia]) +
                        (dir[ib] > 0 ? mid[ib] - lo[ib] : hi[ib] - mid[ib]);
  if (q[0] < lo[0] || q[0] > hi[0] || q[1] < lo[1] || q[1] > hi[1]) {
    std::fprintf(stderr, "sdx_grip: the cube does not fit: it needs the fingers %.6f m apart and the gripper opens to "
                         "%.6f m\n", want, maxGap);
    return 1;
  }
  if (!place(q[0], q[1])) return 1;
  hand->SetArticulatedJointVelocities(superdex::Span<real const>(vel.data(), vel.size()), e);
  if (!e.IsOK()) return Fail("initial velocity", e);
  Reach ra{}, rb{};
  if (!reach(ia, ra) || !reach(ib, rb)) return 1;
  double const faceA0 = ra.nLo, faceB0 = rb.nHi;
  // the cube goes at the fingers' lower end, so the fingers must hang down from their joints, not stand up
  if (ra.uHi - VDot(ra.origin, U) > VDot(ra.origin, U) - ra.uLo + 1e-6 ||
      rb.uHi - VDot(rb.origin, U) > VDot(rb.origin, U) - rb.uLo + 1e-6) {
    std::fprintf(stderr, "sdx_grip: the fingers do not hang down from their joints\n");
    return 1;
  }

  // the cube: midway between the facing faces, on the fingers' centre line, `tip` above their lowest point
  double const cubeN = 0.5 * (faceA0 + faceB0);
  double const cubeU = std::fmin(ra.uLo, rb.uLo) + tip;
  double const cubeT = 0.25 * (ra.tLo + ra.tHi + rb.tLo + rb.tHi);
  V3 const start{N.x * cubeN + U.x * cubeU + T.x * cubeT, N.y * cubeN + U.y * cubeU + T.y * cubeT,
                 N.z * cubeN + U.z * cubeU + T.z * cubeT};
  // turned about the vertical so that the cube's own x axis lies along n
  double turn = std::atan2(-N.z, N.x);
  if (std::fabs(turn) < 1e-9) turn = 0.0;
  superdex::RigidActorParams bp;
  bp.name = "cube";
  bp.shape = BoxShape(ctx, half, half, half, e);
  if (box == 1) bp.colliderType = superdex::ColliderType::Box;
  if (turn != 0.0) {
    // a rotation vector along the vertical; if SuperDex turns the other way for the same vector, use its opposite
    superdex::Quaternion rot =
        superdex::Quaternion::FromRotationVector(superdex::Real3{0_r, static_cast<real>(turn), 0_r});
    if (VDot(From(rot * superdex::Real3{1_r, 0_r, 0_r}), N) < 0.999999) {
      turn = -turn;
      rot = superdex::Quaternion::FromRotationVector(superdex::Real3{0_r, static_cast<real>(turn), 0_r});
    }
    bp.worldFromLocal.SetRotation(rot);
  }
  bp.worldFromLocal.SetTranslation(
      superdex::Real3{static_cast<real>(start.x), static_cast<real>(start.y), static_cast<real>(start.z)});
  bp.mass = static_cast<real>(mass);
  contact(bp.contact);
  superdex::Actor* cube = sc->CreateRigidActor(bp, e);
  if (!e.IsOK()) return Fail("cube", e);
  if (VDot(From(cube->GetRootTransform().GetRotation() * superdex::Real3{1_r, 0_r, 0_r}), N) < 0.999999) {
    std::fprintf(stderr, "sdx_grip: the cube's faces are not square to the grip axis\n");
    return 1;
  }

  // the contact settings on every actor that carries them: the cube, the gripper and each of its links. An actor
  // with none (the articulated parent) is skipped. The setter does not reach nested actors by itself. The cube and
  // the two fingers are the surfaces that touch, so they must take the settings.
  int contactActors = 0;
  {
    std::vector<superdex::Actor*> targets;
    sc->ForEachActor([&](superdex::Actor* a) { targets.push_back(a); });
    for (superdex::ActorHandle h : linkHandles) {
      superdex::Actor* link = sc->GetActor(h);
      bool seen = false;
      for (superdex::Actor* t : targets) seen = seen || t == link;
      if (link != nullptr && !seen) targets.push_back(link);
    }
    for (superdex::Actor* a : targets) {
      bool const touches = a == cube || a == finger[0] || a == finger[1];
      superdex::Error ce;
      superdex::ContactParams cp = a->GetContactParams(ce);
      if (ce.IsOK()) {
        contact(cp);
        a->SetContactParams(cp, ce);
      }
      if (!ce.IsOK()) {
        if (touches) return Fail("set contact params", ce);
        continue;
      }
      ++contactActors;
    }
  }

  // the readings: the cube's contact forces, and each finger link's own if it will give them
  cube->RegisterQuery(superdex::QueryType::TotalContactForce, e);
  if (!e.IsOK()) return Fail("cube contact query", e);
  int linkQuery = 0;
  {
    superdex::Error le;
    finger[ia]->RegisterQuery(superdex::QueryType::TotalContactForce, le);
    if (le.IsOK()) linkQuery |= 1;
  }
  {
    superdex::Error le;
    finger[ib]->RegisterQuery(superdex::QueryType::TotalContactForce, le);
    if (le.IsOK()) linkQuery |= 2;
  }

  // where everything is at the start, to measure from
  V3 const cube0 = From(cube->GetCenterOfMassTransform(e).GetTranslation());
  if (!e.IsOK()) return Fail("cube position", e);
  V3 const fa0 = ra.origin, fb0 = rb.origin;
  double roll0 = 0.0, pitch0 = 0.0, yaw0 = 0.0;
  {
    superdex::Quaternion const cq = cube->GetRootTransform().GetRotation();
    V3 const X = From(cq * superdex::Real3{1_r, 0_r, 0_r});
    V3 const Y = From(cq * superdex::Real3{0_r, 1_r, 0_r});
    roll0 = std::atan2(VDot(Y, T), VDot(Y, U));
    pitch0 = std::atan2(VDot(X, U), VDot(X, N));
    yaw0 = std::atan2(-VDot(X, T), VDot(X, N));
  }

  long const steps = static_cast<long>(std::llround(secs / dt));
  long release = steps;
  for (long i = steps - 1; i >= 0; --i)
    if ((static_cast<double>(i) + 0.5) * dt >= settle) release = i;

  FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_grip: cannot write %s\n", argv[1]); return 1; }
  std::fprintf(f, "GRIP dt_ns %lld secs_ns %lld steps %ld release_step %ld settle_ns %lld ramp_ns %lld maxiter %d "
                  "abstol_ppb %lld implicitn %d expnormals %d fade %d cinf %d armijo %d integ %d gripper %d collider %d "
                  "support %d newtoneuler %d",
               Round(dt * 1e9), Round(secs * 1e9), steps, release, Round(settle * 1e9), Round(ramp * 1e9),
               inForce.nonLinearSolver.maxIter, Round(static_cast<double>(inForce.nonLinearSolver.absTol) * 1e9),
               inForce.experimentalEval.implicitNormalForceForDissipation ? 1 : 0,
               inForce.experimentalEval.explicitNormals ? 1 : 0, inForce.experimentalEval.fadeFriction ? 1 : 0,
               inForce.experimentalEval.frictionModel == superdex::CoulombFrictionModel::CinfRegularized ? 1 : 0,
               inForce.nonLinearSolver.lineSearchType == superdex::LineSearchType::Armijo ? 1 : 0, integ, built, box,
               gravSupport, newtonEuler == 1 ? 1 : 0);
  std::fprintf(f, " mass_mg %lld half_nm %lld mu_ppm %lld grip_uN %lld penalty_Pa_m %lld smooth_nm %lld "
                  "falloff_nms %lld ndamp_ppm %lld visc_ppm %lld clear_nm %lld tip_nm %lld jvisc_ppm %lld fthick_nm %lld "
                  "flen_nm %lld fwide_nm %lld fmass_mg %lld",
               Round(mass * 1e6), Round(half * 1e9), Round(mu * 1e6), Round(grip * 1e6), Round(penalty),
               Round(smooth * 1e9), Round(falloff * 1e9), Round(ndamp * 1e6), Round(visc * 1e6), Round(clear * 1e9),
               Round(tip * 1e9), jvisc < 0.0 ? -1LL : Round(jvisc * 1e6), Round(fthick * 1e9), Round(flen * 1e9),
               Round(fwide * 1e9), Round(fingerMass * 1e6));
  std::fprintf(f, " real_bits %d dofs %d links %d contact_actors_set %d link_query %d axis_x_ppb %lld axis_y_ppb %lld "
                  "axis_z_ppb %lld axis_up_ppb %lld turn_urad %lld gap_nm %lld maxgap_nm %lld cube_x_nm %lld "
                  "cube_y_nm %lld cube_z_nm %lld",
               static_cast<int>(8 * sizeof(real)), nDof, nLinks, contactActors, linkQuery, Round(N.x * 1e9),
               Round(N.y * 1e9), Round(N.z * 1e9), Round(axisUp * 1e9), Round(turn * 1e6),
               Round((faceA0 - faceB0) * 1e9), Round(maxGap * 1e9), Round(cube0.x * 1e9), Round(cube0.y * 1e9),
               Round(cube0.z * 1e9));
  for (int side = 0; side < 2; ++side) {
    int const k = side == 0 ? ia : ib;
    Reach const& r = side == 0 ? ra : rb;
    char const* const s = side == 0 ? "a" : "b";
    bool const opens = side == 0 ? dir[k] > 0 : dir[k] < 0;
    std::fprintf(f, " %s_link %d %s_dof %d %s_dir %d %s_opens %d %s_close %d %s_q0_nm %lld %s_lo_nm %lld %s_hi_nm %lld "
                    "%s_thick_nm %lld %s_long_nm %lld %s_wide_nm %lld",
                 s, fLink[k], s, fDof[k], s, dir[k], s, opens ? 1 : 0, s, closeSign[k], s, Round(q[k] * 1e9), s,
                 Round(lo[k] * 1e9), s, Round(hi[k] * 1e9), s, Round((r.nHi - r.nLo) * 1e9), s,
                 Round((r.uHi - r.uLo) * 1e9), s, Round((r.tHi - r.tLo) * 1e9));
  }
  std::fprintf(f, "\n");

  long nConverged = 0, nStopped = 0, nDiverged = 0, missed = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  bool released = false;
  std::vector<int> const gripDofs = {fDof[0], fDof[1]};
  std::vector<real> gripForce(2, 0_r);
  int const upDof[1] = {1};
  real const upForce[1] = {static_cast<real>(mass * kGravity)};
  for (long i = 0; i < steps; ++i) {
    double const tMid = (static_cast<double>(i) + 0.5) * dt; // the middle of this step, as the other rigs time things
    bool const hold = tMid >= settle;
    double const command = (ramp > 0.0 && tMid < ramp) ? grip * tMid / ramp : grip;
    gripForce[0] = static_cast<real>(command * closeSign[0]);
    gripForce[1] = static_cast<real>(command * closeSign[1]);
    hand->SetExternalForcesOnDofs(superdex::Span<int const>(gripDofs.data(), gripDofs.size()),
                                  superdex::Span<real const>(gripForce.data(), gripForce.size()), e);
    if (!e.IsOK()) return Fail("grip force", e);
    if (gravSupport == 0) {
      if (!hold) {
        cube->SetExternalForcesOnDofs(upDof, upForce, e);
        if (!e.IsOK()) return Fail("support force", e);
      } else if (!released) {
        cube->ClearExternalForces();
        released = true;
      }
    } else if (hold && !released) {
      sc->SetGravity(superdex::Real3{0_r, -9.8_r, 0_r});
      released = true;
    }
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;

    int got = 0; // which readings SuperDex gave this step (column 3)
    V3 c = cube0, cv{0.0, 0.0, 0.0}, fa = fa0, fb = fb0;
    double roll = 0.0, pitch = 0.0, yaw = 0.0, qa = q[ia], qb = q[ib], va = 0.0, vb = 0.0;
    {
      superdex::Error re;
      superdex::Real3 const cp = cube->GetCenterOfMassTransform(re).GetTranslation();
      superdex::Real3 const cl = cube->GetLinearVelocity(re);
      superdex::Quaternion const cq = cube->GetRootTransform().GetRotation();
      hand->GetArticulatedPose(superdex::Span<real>(pose.data(), pose.size()), re);
      hand->GetArticulatedJointVelocities(superdex::Span<real>(vel.data(), vel.size()), re);
      hand->GetArticulatedLinkTransforms(superdex::Span<superdex::TransformRT>(tx.data(), tx.size()), re);
      if (re.IsOK()) {
        got |=32;
        c = From(cp);
        cv = From(cl);
        V3 const X = From(cq * superdex::Real3{1_r, 0_r, 0_r});
        V3 const Y = From(cq * superdex::Real3{0_r, 1_r, 0_r});
        roll = std::atan2(VDot(Y, T), VDot(Y, U)) - roll0;
        pitch = std::atan2(VDot(X, U), VDot(X, N)) - pitch0;
        yaw = std::atan2(-VDot(X, T), VDot(X, N)) - yaw0;
        fa = origin(ia);
        fb = origin(ib);
        qa = static_cast<double>(pose[static_cast<size_t>(fDof[ia])]);
        qb = static_cast<double>(pose[static_cast<size_t>(fDof[ib])]);
        va = static_cast<double>(vel[static_cast<size_t>(fDof[ia])]);
        vb = static_cast<double>(vel[static_cast<size_t>(fDof[ib])]);
      }
    }
    V3 total{0.0, 0.0, 0.0}, fromA{0.0, 0.0, 0.0}, fromB{0.0, 0.0, 0.0}, onA{0.0, 0.0, 0.0}, onB{0.0, 0.0, 0.0};
    {
      superdex::Error qe;
      superdex::Real3 const r = cube->GetContactForceWorld(qe);
      if (qe.IsOK()) { total = From(r); got |=1; }
    }
    {
      superdex::Error qe;
      superdex::Real3 const r = cube->GetContactForceFromActorWorld(finger[ia], qe);
      if (qe.IsOK()) { fromA = From(r); got |=2; }
    }
    {
      superdex::Error qe;
      superdex::Real3 const r = cube->GetContactForceFromActorWorld(finger[ib], qe);
      if (qe.IsOK()) { fromB = From(r); got |=4; }
    }
    if ((linkQuery & 1) != 0) {
      superdex::Error qe;
      superdex::Real3 const r = finger[ia]->GetContactForceWorld(qe);
      if (qe.IsOK()) { onA = From(r); got |=8; }
    }
    if ((linkQuery & 2) != 0) {
      superdex::Error qe;
      superdex::Real3 const r = finger[ib]->GetContactForceWorld(qe);
      if (qe.IsOK()) { onB = From(r); got |=16; }
    }
    if ((got & 39) != 39) ++missed; // the positions and the three readings on the cube

    V3 const moved = VSub(c, cube0);
    double const slipA = VDot(VSub(moved, VSub(fa, fa0)), U);
    double const slipB = VDot(VSub(moved, VSub(fb, fb0)), U);
    double const faceA = faceA0 + VDot(VSub(fa, fa0), N);
    double const faceB = faceB0 + VDot(VSub(fb, fb0), N);
    double const cn = VDot(c, N);
    std::fprintf(f, "%ld %d %d %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld "
                    "%lld %lld %lld %lld %lld %lld %lld %lld %lld\n",
                 i, hold ? 1 : 0, got, Round(command * 1e6), Round(VDot(moved, U) * 1e9), Round(VDot(cv, U) * 1e6),
                 Round(VDot(moved, N) * 1e9), Round(VDot(moved, T) * 1e9), Round(roll * 1e6), Round(pitch * 1e6),
                 Round(yaw * 1e6), Round(slipA * 1e9), Round(slipB * 1e9), Round(qa * 1e9), Round(qb * 1e9),
                 Round(va * 1e6), Round(vb * 1e6), Round((faceA - (cn + half)) * 1e9),
                 Round(((cn - half) - faceB) * 1e9), Round(-VDot(fromA, N) * 1e6), Round(VDot(fromB, N) * 1e6),
                 Round(VDot(fromA, U) * 1e6), Round(VDot(fromB, U) * 1e6), Round(VDot(fromA, T) * 1e6),
                 Round(VDot(fromB, T) * 1e6), Round(VDot(total, N) * 1e6), Round(VDot(total, U) * 1e6),
                 Round(VDot(total, T) * 1e6), Round(VDot(onA, N) * 1e6), Round(-VDot(onB, N) * 1e6));
  }
  std::fclose(f);
  std::printf("STATS grip gripper %s dt %g secs %g settle %g ramp %g mass %g half %g mu %g grip %g maxiter %d dofs %d "
              "contact_actors_set %d link_query %d steps %ld release_step %ld converged %ld stopped %ld diverged %ld "
              "most_iterations %d missed_readings %ld real_bits %d extra%s\n",
              built == 1 ? "built" : "fr3", dt, secs, settle, ramp, mass, half, mu, grip, maxIter, nDof, contactActors,
              linkQuery, steps, release, nConverged, nStopped, nDiverged, mostIters, missed,
              static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  superdex::DestroyContext(ctx);
  return 0;
}
