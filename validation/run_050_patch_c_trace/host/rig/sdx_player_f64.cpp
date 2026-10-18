// sdx_player.cpp -- plays one of SuperDex's three published benchmark scenes (cart_pole, half_cheetah, ant; SuperDex
// v1.0.0, assets/benchmarks) under chosen accuracy settings, driven by a file of seeded actions, and writes one
// joint's encoder reading at every shipped simulation step.
//
// The scene is built the way SuperDex Lab's own environment builds it (superdex_lab/.../benchmarks/*_env.py and
// superdex_python/.../scene_helpers.py at v1.0.0): the published prefab, a +Y ground plane with default contact
// parameters where the environment adds one, the environment's simulation and control rates, its force scales, and
// the action applied before every simulation step. Two things differ from the environment and are stated in
// PREREGISTRATION_01.md: every episode starts from the unperturbed initial pose (the environment adds reset noise), and
// one worker thread is used throughout.
//
// usage: sdx_player <scene> <assets_root> <actions.txt> <out_prefix> [setting=value ...]
//   integ    time integrator: be bdf2 bdf3 dirk22 dirk23 dirk33 sdirk12 sdirk22 (shipped: be, backward Euler)
//   maxiter  nonlinear solver iteration limit (shipped: 4)
//   sub      K solver steps of dt/K per shipped simulation step (shipped: 1)
//   smooth   contact penalty smoothing half-distance in metres on every actor (shipped: 0.005)
//   abstol   nonlinear solver absolute residual tolerance (shipped: 1e-3)
//   reltol   nonlinear solver relative residual tolerance (shipped: 1e-6)
//   relstep  nonlinear solver relative step tolerance; 0 switches the rule off (shipped: 10 x machine epsilon)
//   linsolve linear solver: auto ldlt lu cg (shipped: auto)
//   linstrat linear tolerance strategy: constant ew2 (shipped: ew2, Eisenstat-Walker 2)
//   linreltol, linabstol  linear solver tolerances (shipped: 1e-5, 1e-9; Ant's environment sets linabstol 1e-10)
//   exacth   1 = exact derivatives in the saturation terms, no fitted Hessian (shipped: fitted)
//   ground   0 = the environment's ground plane is left out, so nothing touches the agent from outside (shipped: 1)
//   penalty  contact penalty stiffness in Pa/m on every actor (shipped: 1e9)
//   falloff  the sliding speed in m/s under which friction falls away, on every actor (shipped: 0.01)
//   mu       Coulomb friction coefficient on every actor; 0 = no friction (shipped: as the scene has it)
//   ndamp    normal viscous damping coefficient of the contact on every actor (shipped: 0)
//   visc     viscous friction coefficient of the contact on every actor (shipped: 0)
//   SuperDex's own evaluation switches (SolverParams.experimentalEval), at their shipped values unless given:
//   implicitn   1 = friction and contact damping use the normal force of the step being solved
//               (implicitNormalForceForDissipation; shipped 0: the force at the start of the step)
//   expnormals  1 = normals and the start-of-step distance taken exactly from the start of the step
//               (explicitNormals; shipped 0)
//   fade        0 = friction is not faded by the alignment of the normals (fadeFriction; shipped 1)
//   fricmodel   cinf = the C-infinity friction smoothing (shipped: the C1 one)
//   armijo      1 = Armijo line search on the merit (shipped: the default line search)
//   newtoneuler 1 = SuperDex's own experimental Newton-Euler inertia on the agent (EnableNewtonEulerInertia;
//               shipped 0: the merit-based inertia)
//   nudge    X = the command on the first actuated degree of freedom is larger by X (newtons or newton metres)
//            during the first control step of every episode, and by nothing after. Not an accuracy setting: a
//            known, tiny change to the input, to see how far the scene itself carries one (third registration).
//            Needs the 64-bit build to be felt below about 1e-5.
// A setting that is not given is left as the scene has it. The arithmetic precision (32 or 64 bit) is a build option
// of SuperDex (MOCHI_USE_DOUBLE_PRECISION), not a setting here; the STATS line reports which build was linked.
// writes <out_prefix>_enc.pcm  (s16 little-endian, one reading per shipped simulation step: the primary joint in
//                               counts of a 14-bit encoder, 16384 counts a turn)
//        <out_prefix>_state.f32 (float32, every degree of freedom at every shipped simulation step)
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>

#include <mochi_physics/mochi_physics_experimental.h>
#include <mochi_physics/utils/mochi_prefab.h>

#include <chrono>
#include <cmath>
#include <cstdint>
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

struct SceneSpec {
  char const* name;
  char const* prefab;        // relative to the assets root
  char const* agent;         // the articulated actor's name
  bool plane;                // the environment adds a ground plane
  int simHz, ctrlHz;         // the environment's shipped rates
  int firstDof, nAct;        // actuated degrees of freedom
  double limit;              // the action space is [-limit, limit]
  double scale[8];           // force per unit of action, per actuated degree of freedom
  int primary;               // the recorded joint: the first revolute degree of freedom outside the root joint
  bool ant;                  // Ant: initial pose and linear solver tolerance set by its environment
};

SceneSpec const kScenes[] = {
    {"cart_pole", "benchmarks/cart_pole/cart_pole.mochi_scene", "CartPole", false, 50, 25, 0, 1, 3.0,
     {100, 0, 0, 0, 0, 0, 0, 0}, 1, false},
    {"half_cheetah", "benchmarks/half_cheetah/half_cheetah.mochi_scene", "HalfCheetah", true, 100, 20, 3, 6, 1.0,
     {120, 90, 60, 120, 60, 30, 0, 0}, 3, false},
    {"ant", "benchmarks/ant/ant.mochi_prefab", "Ant", true, 100, 20, 6, 8, 1.0,
     {150, 150, 150, 150, 150, 150, 150, 150}, 6, true},
};

constexpr double kTwoPi = 6.283185307179586476925286766559;
constexpr double kCountsPerTurn = 16384.0;   // a 14-bit absolute encoder

int Fail(char const* what, superdex::Error const& e) {
  std::fprintf(stderr, "sdx_player: %s: %s\n", what, e.ToString().c_str());
  return 1;
}

int16_t Encode(double angle) {
  double c = std::round(angle * kCountsPerTurn / kTwoPi);
  if (c > 32767.0) c = 32767.0;
  if (c < -32767.0) c = -32767.0;
  return static_cast<int16_t>(c);
}

} // namespace

int main(int argc, char** argv) {
  if (argc < 5) {
    std::fprintf(stderr, "usage: sdx_player <scene> <assets_root> <actions.txt> <out_prefix> [integ=NAME] "
                         "[maxiter=N] [sub=K] [smooth=M] [abstol=X] [reltol=X] [relstep=X] [linsolve=NAME] "
                         "[linstrat=NAME] [linreltol=X] [linabstol=X] [exacth=1] [nudge=X] [ground=0] [penalty=X] [falloff=X] [mu=X] [ndamp=X] [visc=X] [implicitn=1] [expnormals=1] [fade=0] [fricmodel=cinf] [armijo=1]\n");
    return 2;
  }
  SceneSpec const* S = nullptr;
  for (SceneSpec const& s : kScenes)
    if (std::strcmp(s.name, argv[1]) == 0) S = &s;
  if (S == nullptr) { std::fprintf(stderr, "sdx_player: unknown scene %s\n", argv[1]); return 2; }
  std::string const root = argv[2];
  std::string const out = argv[4];
  struct IntegName { char const* name; superdex::IntegrationMethod method; };
  IntegName const kIntegs[] = {
      {"be", superdex::IntegrationMethod::BackwardEuler},     {"bdf2", superdex::IntegrationMethod::BDF2},
      {"bdf3", superdex::IntegrationMethod::BDF3},            {"dirk22", superdex::IntegrationMethod::DIRK22},
      {"dirk23", superdex::IntegrationMethod::DIRK23},        {"dirk33", superdex::IntegrationMethod::DIRK33},
      {"sdirk12", superdex::IntegrationMethod::SymplecticDIRK12},
      {"sdirk22", superdex::IntegrationMethod::SymplecticDIRK22},
  };
  IntegName const* integ = &kIntegs[0];
  int maxIter = -1, sub = 1, exactH = 0;
  double smooth = -1.0, absTol = -1.0, relTol = -1.0, relStep = -1.0, linRelTol = -1.0, linAbsTol = -1.0;
  double nudge = 0.0, penalty = -1.0, falloff = -1.0, mu = -1.0, ndamp = -1.0, visc = -1.0;
  int implicitN = -1, expNormals = -1, fade = -1, cinf = 0, armijo = 0;
  int ground = 1;
  int newtonEuler = 0;
  std::string linSolve, linStrat, extra;   // extra: the settings beyond the first registration's, for the STATS line
  for (int i = 5; i < argc; ++i) {
    std::string a = argv[i];
    if (a.rfind("integ=", 0) == 0) {
      IntegName const* found = nullptr;
      for (IntegName const& n : kIntegs)
        if (a.substr(6) == n.name) found = &n;
      if (found == nullptr) { std::fprintf(stderr, "sdx_player: unknown integrator %s\n", a.c_str()); return 2; }
      integ = found;
    }
    else if (a.rfind("maxiter=", 0) == 0) maxIter = std::atoi(a.c_str() + 8);
    else if (a.rfind("sub=", 0) == 0) sub = std::atoi(a.c_str() + 4);
    else if (a.rfind("smooth=", 0) == 0) smooth = std::atof(a.c_str() + 7);
    else if (a.rfind("abstol=", 0) == 0) { absTol = std::atof(a.c_str() + 7); extra += " " + a; }
    else if (a.rfind("reltol=", 0) == 0) { relTol = std::atof(a.c_str() + 7); extra += " " + a; }
    else if (a.rfind("relstep=", 0) == 0) { relStep = std::atof(a.c_str() + 8); extra += " " + a; }
    else if (a.rfind("linreltol=", 0) == 0) { linRelTol = std::atof(a.c_str() + 10); extra += " " + a; }
    else if (a.rfind("linabstol=", 0) == 0) { linAbsTol = std::atof(a.c_str() + 10); extra += " " + a; }
    else if (a.rfind("linsolve=", 0) == 0) { linSolve = a.substr(9); extra += " " + a; }
    else if (a.rfind("linstrat=", 0) == 0) { linStrat = a.substr(9); extra += " " + a; }
    else if (a == "exacth=1") { exactH = 1; extra += " " + a; }
    else if (a.rfind("nudge=", 0) == 0) { nudge = std::atof(a.c_str() + 6); extra += " " + a; }
    else if (a.rfind("ground=", 0) == 0) { ground = std::atoi(a.c_str() + 7); extra += " " + a; }
    else if (a.rfind("penalty=", 0) == 0) { penalty = std::atof(a.c_str() + 8); extra += " " + a; }
    else if (a.rfind("falloff=", 0) == 0) { falloff = std::atof(a.c_str() + 8); extra += " " + a; }
    else if (a.rfind("mu=", 0) == 0) { mu = std::atof(a.c_str() + 3); extra += " " + a; }
    else if (a.rfind("ndamp=", 0) == 0) { ndamp = std::atof(a.c_str() + 6); extra += " " + a; }
    else if (a.rfind("visc=", 0) == 0) { visc = std::atof(a.c_str() + 5); extra += " " + a; }
    else if (a.rfind("implicitn=", 0) == 0) { implicitN = std::atoi(a.c_str() + 10); extra += " " + a; }
    else if (a.rfind("expnormals=", 0) == 0) { expNormals = std::atoi(a.c_str() + 11); extra += " " + a; }
    else if (a.rfind("fade=", 0) == 0) { fade = std::atoi(a.c_str() + 5); extra += " " + a; }
    else if (a == "fricmodel=cinf") { cinf = 1; extra += " " + a; }
    else if (a == "armijo=1") { armijo = 1; extra += " " + a; }
    else if (a.rfind("newtoneuler=", 0) == 0) { newtonEuler = std::atoi(a.c_str() + 12); extra += " " + a; }
    else { std::fprintf(stderr, "sdx_player: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (sub < 1) { std::fprintf(stderr, "sdx_player: sub must be at least 1\n"); return 2; }
  if (!linSolve.empty() && linSolve != "auto" && linSolve != "ldlt" && linSolve != "lu" && linSolve != "cg") {
    std::fprintf(stderr, "sdx_player: unknown linear solver %s\n", linSolve.c_str());
    return 2;
  }
  if (!linStrat.empty() && linStrat != "constant" && linStrat != "ew2") {
    std::fprintf(stderr, "sdx_player: unknown linear tolerance strategy %s\n", linStrat.c_str());
    return 2;
  }

  // the action file: "<episodes> <control_steps> <actions_per_step>", then one integer in [-32767, 32767] per action
  FILE* af = std::fopen(argv[3], "r");
  if (af == nullptr) { std::fprintf(stderr, "sdx_player: cannot read %s\n", argv[3]); return 1; }
  int episodes = 0, ctrlSteps = 0, perStep = 0;
  if (std::fscanf(af, "%d %d %d", &episodes, &ctrlSteps, &perStep) != 3 || perStep != S->nAct) {
    std::fprintf(stderr, "sdx_player: bad action file header\n");
    return 1;
  }
  std::vector<int> act(static_cast<size_t>(episodes) * ctrlSteps * perStep);
  for (int& v : act)
    if (std::fscanf(af, "%d", &v) != 1) { std::fprintf(stderr, "sdx_player: short action file\n"); return 1; }
  std::fclose(af);

  int const simPerCtrl = S->simHz / S->ctrlHz;
  double const dt = 1.0 / S->simHz / sub;
  std::vector<int16_t> enc;
  std::vector<double> state;
  long steps = 0, nConverged = 0, nStopped = 0, nDiverged = 0, nNone = 0;
  std::FILE* const trace = TraceOpen();
  int maxIterSeen = 0, nDof = 0, contactActors = 0;
  double maxResidual = 0.0;
  auto const t0 = std::chrono::steady_clock::now();

  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Error e;
  std::string const prefabPath = root + "/" + S->prefab;
  for (int ep = 0; ep < episodes; ++ep) {
    // the scene, as the environment builds it
    superdex::Scene* sc = ctx->CreateScene("benchmark");
    superdex::prefab::ScenePrefab p = superdex::prefab::LoadFromFile(prefabPath, root, ctx, e);
    if (!e.IsOK()) return Fail("load prefab", e);
    if (S->ant) {
      superdex::prefab::SceneParams sp;
      superdex::SolverParams sol;
      sol.linearSolver.absTol = static_cast<real>(1e-10);
      sp.solver = sol;
      p.scene = sp;
    }
    superdex::prefab::AddToScene(p, sc, e);
    if (!e.IsOK()) return Fail("add prefab to scene", e);
    if (S->plane && ground != 0) {
      superdex::RigidActorParams gp;
      gp.name = "StaticPlane";
      gp.layer = "Environment";
      gp.shape = ctx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
      gp.colliderType = superdex::ColliderType::Plane;
      gp.isStatic = true;
      sc->CreateRigidActor(gp, e);
      if (!e.IsOK()) return Fail("ground plane", e);
    }
    superdex::Actor* agent = nullptr;
    std::vector<superdex::Actor*> all;
    sc->ForEachActor([&](superdex::Actor* a) {
      all.push_back(a);
      if (std::strcmp(a->GetName(), S->agent) == 0) agent = a;
    });
    if (agent == nullptr) { std::fprintf(stderr, "sdx_player: no actor named %s\n", S->agent); return 1; }
    nDof = agent->GetNumDofs();
    if (newtonEuler == 1) {
      mochi::experimental::EnableNewtonEulerInertia(agent, true, e);
      if (!e.IsOK()) return Fail("newton-euler inertia", e);
    }

    // the settings under test
    superdex::SolverParams sol = sc->GetSolverParams();
    sol.integrationMethod = integ->method;
    if (maxIter > 0) sol.nonLinearSolver.maxIter = maxIter;
    if (absTol >= 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol >= 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    if (relStep >= 0.0) sol.nonLinearSolver.relStepTol = static_cast<real>(relStep);
    if (linStrat == "constant") sol.nonLinearSolver.linearToleranceStrategy = superdex::LinearToleranceStrategy::Constant;
    if (linStrat == "ew2")
      sol.nonLinearSolver.linearToleranceStrategy = superdex::LinearToleranceStrategy::EisenstatWalker2;
    if (linSolve == "auto") sol.linearSolver.solverType = superdex::LinearSolverType::Auto;
    if (linSolve == "ldlt") sol.linearSolver.solverType = superdex::LinearSolverType::LDLT;
    if (linSolve == "lu") sol.linearSolver.solverType = superdex::LinearSolverType::LU;
    if (linSolve == "cg") sol.linearSolver.solverType = superdex::LinearSolverType::CG;
    if (linRelTol >= 0.0) sol.linearSolver.relTol = static_cast<real>(linRelTol);
    if (linAbsTol >= 0.0) sol.linearSolver.absTol = static_cast<real>(linAbsTol);
    if (implicitN >= 0) sol.experimentalEval.implicitNormalForceForDissipation = implicitN != 0;
    if (expNormals >= 0) sol.experimentalEval.explicitNormals = expNormals != 0;
    if (fade >= 0) sol.experimentalEval.fadeFriction = fade != 0;
    if (cinf == 1) sol.experimentalEval.frictionModel = superdex::CoulombFrictionModel::CinfRegularized;
    if (armijo == 1) sol.nonLinearSolver.lineSearchType = superdex::LineSearchType::Armijo;
    if (exactH == 1) {
      sol.experimentalEval.fittedSaturationHessian.contactFriction = false;
      sol.experimentalEval.fittedSaturationHessian.jointFriction = false;
      sol.experimentalEval.fittedSaturationHessian.constraintSaturation = false;
    }
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) return Fail("solver params", e);
    if (smooth > 0.0 || penalty > 0.0 || falloff > 0.0 || mu >= 0.0 || ndamp >= 0.0 || visc >= 0.0) {
      // every actor that carries contact parameters: the scene's actors and each link of the agent. An actor with
      // none (the articulated parent) is skipped. The setter does not reach nested actors by itself.
      std::vector<superdex::Actor*> targets = all;
      {
        superdex::Error le;
        for (superdex::ActorHandle h : agent->GetNestedLinkActors(le)) {
          superdex::Actor* link = sc->GetActor(h);
          bool seen = false;
          for (superdex::Actor* t : targets) seen = seen || t == link;
          if (link != nullptr && !seen) targets.push_back(link);
        }
      }
      int set = 0;
      for (superdex::Actor* a : targets) {
        superdex::Error ce;
        superdex::ContactParams cp = a->GetContactParams(ce);
        if (!ce.IsOK()) continue;
        if (smooth > 0.0) cp.penaltySmoothingHalfDistance = static_cast<real>(smooth);
        if (penalty > 0.0) cp.penaltyCoefficient = static_cast<real>(penalty);
        if (falloff > 0.0) cp.frictionFalloffVel = static_cast<real>(falloff);
        if (mu >= 0.0) cp.coulombFrictionCoefficient = static_cast<real>(mu);
        if (ndamp >= 0.0) cp.normalViscousDampingCoefficient = static_cast<real>(ndamp);
        if (visc >= 0.0) cp.viscousFrictionCoefficient = static_cast<real>(visc);
        a->SetContactParams(cp, ce);
        if (!ce.IsOK()) return Fail("set contact params", ce);
        ++set;
      }
      contactActors = set;
    }

    // the initial state: unperturbed, at rest
    std::vector<real> pose(static_cast<size_t>(nDof), 0_r), vel(static_cast<size_t>(nDof), 0_r);
    if (S->ant) {
      pose[1] = static_cast<real>(0.55);
      for (int i = 7; i < nDof; i += 2) pose[static_cast<size_t>(i)] = static_cast<real>(57.30 * kTwoPi / 360.0);
      agent->SetArticulatedPoseFromJoints(superdex::Span<real const>(pose.data(), pose.size()), e);
      if (!e.IsOK()) return Fail("initial pose", e);
    }
    agent->SetArticulatedJointVelocities(superdex::Span<real const>(vel.data(), vel.size()), e);
    if (!e.IsOK()) return Fail("initial velocity", e);

    std::vector<int> dofs(static_cast<size_t>(S->nAct));
    std::vector<real> force(static_cast<size_t>(S->nAct));
    for (int j = 0; j < S->nAct; ++j) dofs[static_cast<size_t>(j)] = S->firstDof + j;
    for (int c = 0; c < ctrlSteps; ++c) {
      int const* q = &act[(static_cast<size_t>(ep) * ctrlSteps + c) * perStep];
      for (int j = 0; j < S->nAct; ++j)
        force[static_cast<size_t>(j)] = static_cast<real>(q[j] / 32767.0 * S->limit * S->scale[j]);
      if (c == 0 && nudge != 0.0) force[0] = static_cast<real>(q[0] / 32767.0 * S->limit * S->scale[0] + nudge);
      for (int s = 0; s < simPerCtrl; ++s) {
        for (int k = 0; k < sub; ++k) {
          agent->SetExternalForcesOnDofs(superdex::Span<int const>(dofs.data(), dofs.size()),
                                         superdex::Span<real const>(force.data(), force.size()), e);
          if (!e.IsOK()) return Fail("apply action", e);
          sc->Step(dt);
          superdex::SolverStats st = sc->GetSolverStats();
          TraceStep(trace, steps, st);
          ++steps;
          if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
          else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
          else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
          else ++nNone;
          if (st.maxNonLinearIters > maxIterSeen) maxIterSeen = st.maxNonLinearIters;
          if (st.residualNorm > maxResidual) maxResidual = st.residualNorm;
        }
        agent->GetArticulatedPose(superdex::Span<real>(pose.data(), pose.size()), e);
        if (!e.IsOK()) return Fail("read pose", e);
        enc.push_back(Encode(static_cast<double>(pose[static_cast<size_t>(S->primary)])));
        for (real v : pose) state.push_back(static_cast<double>(v));
      }
    }
    ctx->DestroyScene(sc);
  }
  superdex::DestroyContext(ctx);

  FILE* f = std::fopen((out + "_enc.pcm").c_str(), "wb");
  if (f == nullptr) { std::fprintf(stderr, "sdx_player: cannot write %s_enc.pcm\n", out.c_str()); return 1; }
  for (int16_t v : enc) {
    uint16_t u = static_cast<uint16_t>(v);
    unsigned char b[2] = {static_cast<unsigned char>(u & 0xff), static_cast<unsigned char>(u >> 8)};
    std::fwrite(b, 1, 2, f);
  }
  std::fclose(f);
  f = std::fopen((out + "_state.f64").c_str(), "wb");
  if (f == nullptr) return 1;
  std::fwrite(state.data(), sizeof(double), state.size(), f);
  std::fclose(f);

  double const wall =
      std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
  int lo = 32767, hi = -32767;
  for (int16_t v : enc) { if (v < lo) lo = v; if (v > hi) hi = v; }
  std::printf("STATS scene %s integ %s maxiter %d sub %d smooth %g contact_actors_set %d episodes %d readings %zu dofs %d "
              "solver_steps %ld converged %ld stopped %ld diverged %ld unset %ld most_iterations %d enc_min %d enc_max %d "
              "wall_s %.1f real_bits %d worst_residual %.3g extra%s\n",
              S->name, integ->name, maxIter, sub, smooth, contactActors, episodes, enc.size(), nDof, steps,
              nConverged, nStopped, nDiverged, nNone,
              maxIterSeen, lo, hi, wall, static_cast<int>(8 * sizeof(real)), maxResidual,
              extra.empty() ? " none" : extra.c_str());
  return 0;
}
