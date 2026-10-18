// sdx_chain.cpp -- two arms on two revolute joints, with nothing touching them (SuperDex v1.0.0): a base welded to
// the world, a first arm on a joint at the base, and a second arm on a joint carried by the first. Both joints turn
// about +z and gravity, when it is on, is along -y, so the motion stays in the x-y plane: a double pendulum. Each
// arm is a cube of half-size `radius`. The first arm's centre is `arm1` metres from the first joint and the second
// joint is `len1` metres from the first joint, both along the first arm's +x; the second arm's centre is `arm2`
// metres from the second joint, along the second arm's +x.
// Things with a right answer, none of which depends on how small the step is:
//   - with no gravity nothing does work on the chain: its kinetic energy stays what it was, and so does its angular
//     momentum about the first joint;
//   - with gravity its total energy (kinetic plus mass x 9.8 x height) stays what it was.
// The program only plays the scene and writes, as whole numbers, what the joints did and where SuperDex says each
// arm is and how it moves. The measuring is done elsewhere.
//
// usage: sdx_chain <out.txt> dt=<seconds> [mass1=KG] [mass2=KG] [radius=M] [arm1=M] [len1=M] [arm2=M] [angle1=RAD]
//                  [angle2=RAD] [omega1=RAD_S] [omega2=RAD_S] [secs=S] [gravity=0] [integ=NAME] [maxiter=N]
//                  [newtoneuler=1] [abstol=X] [reltol=X] [tilt2=RAD]
//   integ    time integrator: be bdf2 dirk33 bdf3 dirk22 dirk23 sdirk12 (implicit midpoint) sdirk22 (shipped: be)
//   abstol, reltol   nonlinear solver absolute and relative residual tolerances (shipped: 1e-3, 1e-6)
//   newtoneuler  1 = SuperDex's own experimental Newton-Euler inertia for the chain (EnableNewtonEulerInertia;
//                shipped 0: the merit-based inertia)
//   tilt2    the second joint's axis tilted from +z towards the first arm's +x by this many radians (unset: +z, the
//            planar chain above). With it the chain moves in three dimensions. The file is the same: each arm's x, y,
//            velocity along x and y and spin about z carry the angular momentum about the first joint's axis (z)
//            whole, since a cube's inertia is the same about every axis, so with no gravity that momentum is the
//            right answer the file holds; the kinetic energy read from them is the part in the x-y plane only
// writes <out.txt>: a header line
//   "CHAIN dt_ns <n> mass1_g <n> mass2_g <n> radius_um <n> arm1_um <n> len1_um <n> arm2_um <n> gravity <0|1> steps <n>"
// then one line a step, 15 whole numbers:
//   <step>
//   <joint 1 angle, micro-radians> <joint 1 speed, micro-radians a second>
//   <joint 2 angle, micro-radians> <joint 2 speed, micro-radians a second>
//   <arm 1 centre x, y, micrometres> <arm 1 velocity x, y, micrometres a second> <arm 1 spin about z, micro-radians a second>
//   <arm 2 centre x, y, micrometres> <arm 2 velocity x, y, micrometres a second> <arm 2 spin about z, micro-radians a second>
// The first line after the header (step -1) is the state before any step.
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
    std::fprintf(stderr, "usage: sdx_chain <out.txt> dt=<seconds> [mass1=KG] [mass2=KG] [radius=M] [arm1=M] [len1=M] "
                         "[arm2=M] [angle1=RAD] [angle2=RAD] [omega1=RAD_S] [omega2=RAD_S] [secs=S] [gravity=0] "
                         "[integ=NAME] [maxiter=N] [newtoneuler=1]\n");
    return 2;
  }
  double dt = 0.0, mass1 = 1.0, mass2 = 1.0, radius = 0.05, arm1 = 0.2, len1 = 0.4, arm2 = 0.2, secs = 2.0;
  double angle1 = 0.0, angle2 = 0.0, omega1 = 0.0, omega2 = 0.0, tilt2 = 0.0;
  int gravity = 1, maxIter = 200, newtonEuler = 0, tilted = 0;
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
    else if ((v = val("mass1="))) mass1 = std::atof(v);
    else if ((v = val("mass2="))) mass2 = std::atof(v);
    else if ((v = val("radius="))) radius = std::atof(v);
    else if ((v = val("arm1="))) arm1 = std::atof(v);
    else if ((v = val("len1="))) len1 = std::atof(v);
    else if ((v = val("arm2="))) arm2 = std::atof(v);
    else if ((v = val("angle1="))) angle1 = std::atof(v);
    else if ((v = val("angle2="))) angle2 = std::atof(v);
    else if ((v = val("omega1="))) omega1 = std::atof(v);
    else if ((v = val("omega2="))) omega2 = std::atof(v);
    else if ((v = val("secs="))) secs = std::atof(v);
    else if ((v = val("gravity="))) gravity = std::atoi(v);
    else if ((v = val("integ="))) { integ = v; extra += " " + a; }
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("newtoneuler="))) { newtonEuler = std::atoi(v); extra += " " + a; }
    else if ((v = val("abstol="))) { absTol = std::atof(v); extra += " " + a; }
    else if ((v = val("reltol="))) { relTol = std::atof(v); extra += " " + a; }
    else if ((v = val("tilt2="))) { tilt2 = std::atof(v); tilted = 1; extra += " " + a; }
    else { std::fprintf(stderr, "sdx_chain: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (!(dt > 0.0)) { std::fprintf(stderr, "sdx_chain: dt must be given and positive\n"); return 2; }

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("chain");
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
    else { std::fprintf(stderr, "sdx_chain: unknown integrator %s\n", integ.c_str()); return 2; }
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol >= 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol >= 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  // a cube of half-size `radius` as a triangle mesh
  real const H = static_cast<real>(radius);
  std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  superdex::ShapeHandle const cube = ctx->CreateTriMeshShape(corners, tris, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: shape: %s\n", e.ToString().c_str()); return 1; }

  superdex::ArticulatedActorParams ap;
  ap.name = "chain";
  superdex::ArticulatedJointParams weld;
  weld.name = "weld";
  weld.type = superdex::ArticulatedJointType::Hard;
  superdex::ArticulatedJointParams hinge1;
  hinge1.name = "hinge1";
  hinge1.type = superdex::ArticulatedJointType::Revolute;
  hinge1.axis = superdex::Real3{0_r, 0_r, 1_r};
  superdex::ArticulatedJointParams hinge2;
  hinge2.name = "hinge2";
  hinge2.type = superdex::ArticulatedJointType::Revolute;
  hinge2.axis = superdex::Real3{0_r, 0_r, 1_r};
  // with tilt2 given, the second joint turns about an axis tilted from +z towards the first arm's +x
  if (tilted == 1) hinge2.axis = superdex::Real3{static_cast<real>(std::sin(tilt2)), 0_r, static_cast<real>(std::cos(tilt2))};
  // the second joint sits on the first arm, len1 from the first joint; the first arm's own frame is at its centre
  hinge2.parentLinkFromJoint.SetTranslation(superdex::Real3{static_cast<real>(len1 - arm1), 0_r, 0_r});
  ap.joints.push_back(weld);
  ap.joints.push_back(hinge1);
  ap.joints.push_back(hinge2);
  superdex::ArticulatedLinkParams base;
  base.name = "base";
  base.parentLink = -1;
  base.shape = cube;
  base.colliderType = superdex::ColliderType::None;
  base.mass = 1_r;
  superdex::ArticulatedLinkParams link1;
  link1.name = "arm1";
  link1.parentLink = 0;
  link1.shape = cube;
  link1.colliderType = superdex::ColliderType::None;
  link1.mass = static_cast<real>(mass1);
  link1.parentJointFromLink.SetTranslation(superdex::Real3{static_cast<real>(arm1), 0_r, 0_r});
  superdex::ArticulatedLinkParams link2;
  link2.name = "arm2";
  link2.parentLink = 1;
  link2.shape = cube;
  link2.colliderType = superdex::ColliderType::None;
  link2.mass = static_cast<real>(mass2);
  link2.parentJointFromLink.SetTranslation(superdex::Real3{static_cast<real>(arm2), 0_r, 0_r});
  ap.links.push_back(base);
  ap.links.push_back(link1);
  ap.links.push_back(link2);
  superdex::Actor* actor = sc->CreateArticulatedActor(ap, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: actor: %s\n", e.ToString().c_str()); return 1; }
  if (newtonEuler == 1) {
    mochi::experimental::EnableNewtonEulerInertia(actor, true, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: newton-euler inertia: %s\n", e.ToString().c_str()); return 1; }
  }
  int const nDof = actor->GetNumDofs();
  if (nDof < 2) { std::fprintf(stderr, "sdx_chain: expected two degrees of freedom, found %d\n", nDof); return 1; }
  std::vector<real> pose(static_cast<size_t>(nDof), 0_r), vel(static_cast<size_t>(nDof), 0_r);
  pose[static_cast<size_t>(nDof - 2)] = static_cast<real>(angle1);
  pose[static_cast<size_t>(nDof - 1)] = static_cast<real>(angle2);
  vel[static_cast<size_t>(nDof - 2)] = static_cast<real>(omega1);
  vel[static_cast<size_t>(nDof - 1)] = static_cast<real>(omega2);
  actor->SetArticulatedPoseFromJoints(superdex::Span<real const>(pose.data(), pose.size()), e);
  actor->SetArticulatedJointVelocities(superdex::Span<real const>(vel.data(), vel.size()), e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: initial state: %s\n", e.ToString().c_str()); return 1; }

  // the two arms as SuperDex's own rigid actors: found by name, or, if the links do not carry their names, the last
  // two links in the order they were given
  superdex::Actor* arm[2] = {nullptr, nullptr};
  std::vector<superdex::Actor*> nested;
  for (superdex::ActorHandle h : actor->GetNestedLinkActors(e)) {
    superdex::Actor* link = sc->GetActor(h);
    if (link == nullptr) continue;
    nested.push_back(link);
    if (std::strcmp(link->GetName(), "arm1") == 0) arm[0] = link;
    if (std::strcmp(link->GetName(), "arm2") == 0) arm[1] = link;
  }
  int byName = 1;
  if ((arm[0] == nullptr || arm[1] == nullptr) && nested.size() >= 2) {
    arm[0] = nested[nested.size() - 2];
    arm[1] = nested[nested.size() - 1];
    byName = 0;
  }
  if (arm[0] == nullptr || arm[1] == nullptr) { std::fprintf(stderr, "sdx_chain: the arms were not found\n"); return 1; }
  extra += byName == 1 ? " arms_by=name" : " arms_by=order";

  FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_chain: cannot write %s\n", argv[1]); return 1; }
  long const steps = static_cast<long>(std::llround(secs / dt));
  std::fprintf(f, "CHAIN dt_ns %lld mass1_g %lld mass2_g %lld radius_um %lld arm1_um %lld len1_um %lld arm2_um %lld "
                  "gravity %d steps %ld\n",
               Round(dt * 1e9), Round(mass1 * 1e3), Round(mass2 * 1e3), Round(radius * 1e6), Round(arm1 * 1e6),
               Round(len1 * 1e6), Round(arm2 * 1e6), gravity != 0 ? 1 : 0, steps);
  auto writeRow = [&](long step) {
    actor->GetArticulatedPose(superdex::Span<real>(pose.data(), pose.size()), e);
    actor->GetArticulatedJointVelocities(superdex::Span<real>(vel.data(), vel.size()), e);
    std::fprintf(f, "%ld %lld %lld %lld %lld", step,
                 Round(static_cast<double>(pose[static_cast<size_t>(nDof - 2)]) * 1e6),
                 Round(static_cast<double>(vel[static_cast<size_t>(nDof - 2)]) * 1e6),
                 Round(static_cast<double>(pose[static_cast<size_t>(nDof - 1)]) * 1e6),
                 Round(static_cast<double>(vel[static_cast<size_t>(nDof - 1)]) * 1e6));
    for (int k = 0; k < 2; ++k) {
      superdex::Real3 const p = arm[k]->GetCenterOfMassTransform(e).GetTranslation();
      superdex::Real3 const v = arm[k]->GetLinearVelocity(e);
      superdex::Real3 const w = arm[k]->GetAngularVelocity(e);
      std::fprintf(f, " %lld %lld %lld %lld %lld", Round(static_cast<double>(p[0]) * 1e6),
                   Round(static_cast<double>(p[1]) * 1e6), Round(static_cast<double>(v[0]) * 1e6),
                   Round(static_cast<double>(v[1]) * 1e6), Round(static_cast<double>(w[2]) * 1e6));
    }
    std::fprintf(f, "\n");
  };
  writeRow(-1);
  long nConverged = 0, nStopped = 0, nDiverged = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  for (long i = 0; i < steps; ++i) {
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;
    writeRow(i);
  }
  std::fclose(f);
  if (trace != nullptr) std::fclose(trace);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_chain: reading the state: %s\n", e.ToString().c_str()); return 1; }
  std::printf("STATS chain dt %g mass1 %g mass2 %g radius %g arm1 %g len1 %g arm2 %g gravity %d dofs %d steps %ld "
              "converged %ld stopped %ld diverged %ld most_iterations %d real_bits %d extra%s\n",
              dt, mass1, mass2, radius, arm1, len1, arm2, gravity, nDof, steps, nConverged, nStopped, nDiverged,
              mostIters, static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  superdex::DestroyContext(ctx);
  return 0;
}
