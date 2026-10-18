// sdx_joint.cpp -- the smallest jointed scene SuperDex can be asked about (SuperDex v1.0.0): a base welded to the
// world and one arm on a revolute joint, with nothing touching it. The arm is a cube of half-size `radius` whose
// centre is `arm` metres from the joint, along +x when the joint angle is zero, and the joint turns about +z, so
// gravity (along -y) pulls a horizontal arm down with a torque of mass x 9.8 x arm. Things with a right answer:
//   - with no joint friction the arm is a pendulum, and a pendulum keeps its energy: released level, it comes up
//     level on the other side, every swing;
//   - with joint friction larger than gravity's torque, the arm stays where it was put;
//   - a constant joint torque with no gravity turns the arm at torque / inertia.
// The program only plays the scene and writes what the joint did at every step, as whole numbers. The measuring is
// done elsewhere (sx_contact.sx reads the same six columns).
//
// usage: sdx_joint <out.txt> dt=<seconds> [setting=value ...]
//   mass, radius, arm   kg; the cube's half-size, m; the distance from the joint to the cube's centre, m (default
//            1, 0.05, 0.5)
//   angle0   the joint angle at release, radians; 0 is level (default 0)
//   omega0   the joint speed at release, radians a second (default 0)
//   secs     how long to play (default 2)
//   gravity  0 = no gravity (default 1)
//   coulomb, viscous, falloff   the joint's friction: dry friction torque (N m), viscous coefficient, and the speed
//            under which the dry friction falls away (shipped: 0, 0, 0.001 rad/s)
//   torque   a constant torque on the joint, N m, from the time `torqueat` on (default 0)
//   torqueat seconds at which the torque starts (default 0: from the first step)
//   lo, hi   joint limits in radians (default: none); limitk, limitd their stiffness and damping (shipped: 100, 0)
//   integ    time integrator: be bdf2 dirk33 bdf3 dirk22 dirk23 sdirk12 (implicit midpoint) sdirk22 (shipped: be)
//   maxiter  nonlinear iteration limit (default 200; shipped 4)
//   newtoneuler  1 = SuperDex's own experimental Newton-Euler inertia for the arm (EnableNewtonEulerInertia;
//            shipped 0: the merit-based inertia)
//   abstol, reltol   nonlinear solver absolute and relative residual tolerances (shipped: 1e-3, 1e-6)
// writes <out.txt>: a header line "CONTACT dt_ns <n> h0_nm 0 vx0_ums 0 mu_ppm 0 mass_g <n> steps <n>" (the header
//   the measuring harness reads), then one line a step: "<step> <joint angle, micro-radians> <joint speed,
//   micro-radians a second> 0 0 0"
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>
#include <mochi_physics/mochi_physics_experimental.h>

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
  if (argc < 3) {
    std::fprintf(stderr, "usage: sdx_joint <out.txt> dt=<seconds> [mass=KG] [radius=M] [arm=M] [angle0=RAD] [omega0=RAD_S] [secs=S] "
                         "[gravity=0] [coulomb=NM] [viscous=X] [falloff=RAD_S] [torque=NM] [lo=RAD] [hi=RAD] "
                         "[limitk=X] [limitd=X] [integ=NAME] [maxiter=N]\n");
    return 2;
  }
  double dt = 0.0, mass = 1.0, radius = 0.05, arm = 0.5, angle0 = 0.0, secs = 2.0, torque = 0.0, omega0 = 0.0;
  double coulomb = -1.0, viscous = -1.0, falloff = -1.0, lo = 0.0, hi = 0.0, limitK = -1.0, limitD = -1.0, torqueAt = 0.0;
  int gravity = 1, maxIter = 200, hasLimits = 0;
  int newtonEuler = 0;
  double absTol = -1.0, relTol = -1.0;
  std::string integ = "be", extra;
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto val = [&](char const* key) -> char const* {
      size_t n = std::strlen(key);
      return a.compare(0, n, key) == 0 ? a.c_str() + n : nullptr;
    };
    char const* v = nullptr;
    if ((v = val("dt="))) dt = std::atof(v);
    else if ((v = val("mass="))) mass = std::atof(v);
    else if ((v = val("radius="))) radius = std::atof(v);
    else if ((v = val("arm="))) arm = std::atof(v);
    else if ((v = val("angle0="))) angle0 = std::atof(v);
    else if ((v = val("omega0="))) omega0 = std::atof(v);
    else if ((v = val("secs="))) secs = std::atof(v);
    else if ((v = val("gravity="))) gravity = std::atoi(v);
    else if ((v = val("coulomb="))) { coulomb = std::atof(v); extra += " " + a; }
    else if ((v = val("viscous="))) { viscous = std::atof(v); extra += " " + a; }
    else if ((v = val("falloff="))) { falloff = std::atof(v); extra += " " + a; }
    else if ((v = val("torque="))) { torque = std::atof(v); extra += " " + a; }
    else if ((v = val("torqueat="))) { torqueAt = std::atof(v); extra += " " + a; }
    else if ((v = val("lo="))) { lo = std::atof(v); hasLimits = 1; extra += " " + a; }
    else if ((v = val("hi="))) { hi = std::atof(v); hasLimits = 1; extra += " " + a; }
    else if ((v = val("limitk="))) { limitK = std::atof(v); extra += " " + a; }
    else if ((v = val("limitd="))) { limitD = std::atof(v); extra += " " + a; }
    else if ((v = val("integ="))) { integ = v; extra += " " + a; }
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("newtoneuler="))) { newtonEuler = std::atoi(v); extra += " " + a; }
    else if ((v = val("abstol="))) { absTol = std::atof(v); extra += " " + a; }
    else if ((v = val("reltol="))) { relTol = std::atof(v); extra += " " + a; }
    else { std::fprintf(stderr, "sdx_joint: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (dt <= 0.0) { std::fprintf(stderr, "sdx_joint: dt must be given\n"); return 2; }

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("joint");
  sc->SetGravity(superdex::Real3{0_r, gravity != 0 ? -9.8_r : 0_r, 0_r});
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
    else { std::fprintf(stderr, "sdx_joint: unknown integrator %s\n", integ.c_str()); return 2; }
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol >= 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol >= 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_joint: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  // a cube of half-size `radius` as a triangle mesh
  real const H = static_cast<real>(radius);
  std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  superdex::ShapeHandle const cube = ctx->CreateTriMeshShape(corners, tris, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_joint: shape: %s\n", e.ToString().c_str()); return 1; }

  superdex::ArticulatedActorParams ap;
  ap.name = "arm";
  superdex::ArticulatedJointParams weld;
  weld.name = "weld";
  weld.type = superdex::ArticulatedJointType::Hard;
  superdex::ArticulatedJointParams hinge;
  hinge.name = "hinge";
  hinge.type = superdex::ArticulatedJointType::Revolute;
  hinge.axis = superdex::Real3{0_r, 0_r, 1_r};
  if (coulomb >= 0.0) hinge.friction.coulomb = static_cast<real>(coulomb);
  if (viscous >= 0.0) hinge.friction.viscous = static_cast<real>(viscous);
  if (falloff >= 0.0) hinge.friction.falloffVel = static_cast<real>(falloff);
  if (hasLimits == 1) {
    hinge.minLimit = superdex::Real3{0_r, 0_r, static_cast<real>(lo)};  // the limit of a revolute joint is read along its axis (z)
    hinge.maxLimit = superdex::Real3{0_r, 0_r, static_cast<real>(hi)};
  }
  if (limitK >= 0.0) hinge.limitStiffness = static_cast<real>(limitK);
  if (limitD >= 0.0) hinge.limitDamping = static_cast<real>(limitD);
  ap.joints.push_back(weld);
  ap.joints.push_back(hinge);
  superdex::ArticulatedLinkParams base;
  base.name = "base";
  base.parentLink = -1;
  base.shape = cube;
  base.colliderType = superdex::ColliderType::None;
  base.mass = 1_r;
  superdex::ArticulatedLinkParams link;
  link.name = "arm";
  link.parentLink = 0;
  link.shape = cube;
  link.colliderType = superdex::ColliderType::None;
  link.mass = static_cast<real>(mass);
  link.parentJointFromLink.SetTranslation(superdex::Real3{static_cast<real>(arm), 0_r, 0_r});
  ap.links.push_back(base);
  ap.links.push_back(link);
  superdex::Actor* actor = sc->CreateArticulatedActor(ap, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_joint: actor: %s\n", e.ToString().c_str()); return 1; }
  if (newtonEuler == 1) {
    mochi::experimental::EnableNewtonEulerInertia(actor, true, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_joint: newton-euler inertia: %s\n", e.ToString().c_str()); return 1; }
  }
  int const nDof = actor->GetNumDofs();
  std::vector<real> pose(static_cast<size_t>(nDof), 0_r), vel(static_cast<size_t>(nDof), 0_r);
  pose[static_cast<size_t>(nDof - 1)] = static_cast<real>(angle0);
  vel[static_cast<size_t>(nDof - 1)] = static_cast<real>(omega0);
  actor->SetArticulatedPoseFromJoints(superdex::Span<real const>(pose.data(), pose.size()), e);
  actor->SetArticulatedJointVelocities(superdex::Span<real const>(vel.data(), vel.size()), e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_joint: initial state: %s\n", e.ToString().c_str()); return 1; }

  FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_joint: cannot write %s\n", argv[1]); return 1; }
  long const steps = static_cast<long>(std::llround(secs / dt));
  std::fprintf(f, "CONTACT dt_ns %lld h0_nm 0 vx0_ums 0 mu_ppm 0 mass_g %lld steps %ld\n", Round(dt * 1e9),
               Round(mass * 1e3), steps);
  long nConverged = 0, nStopped = 0, nDiverged = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  int const dof[1] = {nDof - 1};
  real const tq[1] = {static_cast<real>(torque)};
  for (long i = 0; i < steps; ++i) {
    if (torque != 0.0 && (static_cast<double>(i) + 0.5) * dt >= torqueAt) {
      actor->ClearExternalForces();
      actor->SetExternalForcesOnDofs(dof, tq, e);
    }
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;
    actor->GetArticulatedPose(superdex::Span<real>(pose.data(), pose.size()), e);
    actor->GetArticulatedJointVelocities(superdex::Span<real>(vel.data(), vel.size()), e);
    std::fprintf(f, "%ld %lld %lld 0 0 0\n", i, Round(static_cast<double>(pose[static_cast<size_t>(nDof - 1)]) * 1e6),
                 Round(static_cast<double>(vel[static_cast<size_t>(nDof - 1)]) * 1e6));
  }
  std::fclose(f);
  std::printf("STATS joint dt %g mass %g radius %g arm %g angle0 %g gravity %d dofs %d steps %ld converged %ld stopped "
              "%ld diverged %ld most_iterations %d real_bits %d extra%s\n",
              dt, mass, radius, arm, angle0, gravity, nDof, steps, nConverged, nStopped, nDiverged, mostIters,
              static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  superdex::DestroyContext(ctx);
  return 0;
}
