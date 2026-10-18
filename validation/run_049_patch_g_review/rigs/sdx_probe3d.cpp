// sdx_probe3d.cpp -- the probe rig with the second joint axis tilted (tilt=, radians); only the link reading of
// energy (3D) and of the angular momentum about z is meaningful here (the joint reading and the RK4 reference are
// planar). Otherwise as sdx_probe.cpp: probe rig for patch G's review (not a registered rig). The scenes of tools/sdx_joint.cpp (one arm)
// and tools/sdx_chain.cpp (two arms), built the same way, played with SuperDex, and read in double precision two
// ways at every step:
//   link:  from SuperDex's own account of each arm (GetCenterOfMassTransform, GetLinearVelocity, GetAngularVelocity),
//          as measure/sx_contact.sx's chain reading does;
//   joint: from the joint speeds (GetArticulatedJointVelocities), each arm's velocity being the one its joints'
//          motion implies about the joints it rides on (positions from SuperDex);
// and against an independent reference: RK4 at 1e-6 s on the reduced equations M(q) qdd + c(q, qd) + g(q) = 0 of
// the same chain (cubes: inertia 2/3 m h^2 about the centre).
// usage: sdx_probe links=<1|2> dt=<s> secs=<s> [mass1= mass2= radius= arm1= len1= arm2= angle1= angle2= omega1= omega2=
//        gravity=0|1 integ=be|bdf2|bdf3 newtoneuler=0|1 abstol= reltol= maxiter=]
// prints one PROBE line.
#include <superdex_physics.h>
#include <mochi_physics/mochi_physics_experimental.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

using superdex::operator""_r;
using superdex::real;

namespace {
struct Geo { int n = 2; double m[2] = {1, 1}, I[2] = {0, 0}, a[2] = {0.2, 0.2}, l1 = 0.4, g = 0; };
void E(double p, double* e) { e[0] = std::cos(p); e[1] = std::sin(p); }
void Accel(Geo const& G, double const* q, double const* qd, double* qdd) {
  double p[2] = {q[0], q[0] + q[1]}, pd[2] = {qd[0], qd[0] + qd[1]};
  double t1[2] = {-std::sin(p[0]), std::cos(p[0])}, t2[2] = {-std::sin(p[1]), std::cos(p[1])};
  double J[2][2][2] = {{{G.a[0] * t1[0], 0}, {G.a[0] * t1[1], 0}}, {{G.l1 * t1[0] + G.a[1] * t2[0], G.a[1] * t2[0]}, {G.l1 * t1[1] + G.a[1] * t2[1], G.a[1] * t2[1]}}};
  double M[2][2] = {{0, 0}, {0, 0}}, rhs[2] = {0, 0};
  for (int i = 0; i < G.n; ++i) {
    double c[2] = {0, 0}, e[2];
    E(p[0], e);
    double r0 = i == 0 ? G.a[0] : G.l1;
    c[0] -= r0 * pd[0] * pd[0] * e[0]; c[1] -= r0 * pd[0] * pd[0] * e[1];
    if (i == 1) { E(p[1], e); c[0] -= G.a[1] * pd[1] * pd[1] * e[0]; c[1] -= G.a[1] * pd[1] * pd[1] * e[1]; }
    for (int k = 0; k < G.n; ++k) {
      for (int l = 0; l < G.n; ++l)
        M[k][l] += G.m[i] * (J[i][0][k] * J[i][0][l] + J[i][1][k] * J[i][1][l]) + G.I[i] * (k <= i ? 1.0 : 0.0) * (l <= i ? 1.0 : 0.0);
      rhs[k] -= G.m[i] * (J[i][0][k] * c[0] + J[i][1][k] * c[1]) + G.m[i] * G.g * J[i][1][k];
    }
  }
  if (G.n == 1) { qdd[0] = rhs[0] / M[0][0]; qdd[1] = 0; return; }
  double det = M[0][0] * M[1][1] - M[0][1] * M[1][0];
  qdd[0] = (M[1][1] * rhs[0] - M[0][1] * rhs[1]) / det;
  qdd[1] = (-M[1][0] * rhs[0] + M[0][0] * rhs[1]) / det;
}
void Reference(Geo const& G, double const* q0, double const* qd0, double secs, double* q, double* qd) {
  double y[4] = {q0[0], q0[1], qd0[0], qd0[1]};
  long const steps = std::lround(secs / 1e-6);
  double const h = secs / steps;
  auto f = [&](double const* s, double* d) { d[0] = s[2]; d[1] = s[3]; Accel(G, s, s + 2, d + 2); };
  for (long k = 0; k < steps; ++k) {
    double k1[4], k2[4], k3[4], k4[4], t[4];
    f(y, k1); for (int i = 0; i < 4; ++i) t[i] = y[i] + 0.5 * h * k1[i];
    f(t, k2); for (int i = 0; i < 4; ++i) t[i] = y[i] + 0.5 * h * k2[i];
    f(t, k3); for (int i = 0; i < 4; ++i) t[i] = y[i] + h * k3[i];
    f(t, k4); for (int i = 0; i < 4; ++i) y[i] += h / 6 * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]);
  }
  q[0] = y[0]; q[1] = y[1]; qd[0] = y[2]; qd[1] = y[3];
}
}  // namespace

int main(int argc, char** argv) {
  int links = 2, gravity = 0, maxIter = 200, newtonEuler = 0;
  double dt = 0, secs = 2, mass1 = 1, mass2 = 1, radius = 0.05, arm1 = 0.2, len1 = 0.4, arm2 = 0.2;
  double angle1 = 0, angle2 = 0, omega1 = 0, omega2 = 0, absTol = -1, relTol = -1;
  double tilt = 0;
  std::string integ = "be";
  for (int i = 1; i < argc; ++i) {
    std::string a = argv[i];
    auto v = [&](char const* k) -> char const* { size_t n = std::strlen(k); return a.compare(0, n, k) == 0 ? a.c_str() + n : nullptr; };
    char const* x;
    if ((x = v("links="))) links = std::atoi(x);
    else if ((x = v("dt="))) dt = std::atof(x);
    else if ((x = v("secs="))) secs = std::atof(x);
    else if ((x = v("mass1="))) mass1 = std::atof(x);
    else if ((x = v("mass2="))) mass2 = std::atof(x);
    else if ((x = v("radius="))) radius = std::atof(x);
    else if ((x = v("arm1="))) arm1 = std::atof(x);
    else if ((x = v("len1="))) len1 = std::atof(x);
    else if ((x = v("arm2="))) arm2 = std::atof(x);
    else if ((x = v("angle1="))) angle1 = std::atof(x);
    else if ((x = v("angle2="))) angle2 = std::atof(x);
    else if ((x = v("omega1="))) omega1 = std::atof(x);
    else if ((x = v("omega2="))) omega2 = std::atof(x);
    else if ((x = v("gravity="))) gravity = std::atoi(x);
    else if ((x = v("integ="))) integ = x;
    else if ((x = v("newtoneuler="))) newtonEuler = std::atoi(x);
    else if ((x = v("abstol="))) absTol = std::atof(x);
    else if ((x = v("reltol="))) relTol = std::atof(x);
    else if ((x = v("maxiter="))) maxIter = std::atoi(x);
    else if ((x = v("tilt="))) tilt = std::atof(x);
    else { std::fprintf(stderr, "sdx_probe: unknown setting %s\n", a.c_str()); return 2; }
  }
  if (!(dt > 0)) { std::fprintf(stderr, "sdx_probe: dt\n"); return 2; }
  if (links == 1) { mass2 = 0; angle2 = 0; omega2 = 0; }
  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("probe");
  sc->SetGravity(superdex::Real3{0_r, gravity != 0 ? -9.8_r : 0_r, 0_r});
  {
    superdex::SolverParams sol = sc->GetSolverParams();
    if (integ == "be") sol.integrationMethod = superdex::IntegrationMethod::BackwardEuler;
    else if (integ == "bdf2") sol.integrationMethod = superdex::IntegrationMethod::BDF2;
    else if (integ == "bdf3") sol.integrationMethod = superdex::IntegrationMethod::BDF3;
    else { std::fprintf(stderr, "sdx_probe: integrator\n"); return 2; }
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol >= 0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol >= 0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_probe: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  real const H = static_cast<real>(radius);
  std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4, 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  superdex::ShapeHandle const cube = ctx->CreateTriMeshShape(corners, tris, e);
  superdex::ArticulatedActorParams ap;
  ap.name = "probe";
  superdex::ArticulatedJointParams weld; weld.name = "weld"; weld.type = superdex::ArticulatedJointType::Hard;
  superdex::ArticulatedJointParams hinge1; hinge1.name = "hinge1"; hinge1.type = superdex::ArticulatedJointType::Revolute; hinge1.axis = superdex::Real3{0_r, 0_r, 1_r};
  superdex::ArticulatedJointParams hinge2; hinge2.name = "hinge2"; hinge2.type = superdex::ArticulatedJointType::Revolute; hinge2.axis = superdex::Real3{0_r, 0_r, 1_r};
  // probe 3D: the second joint turns about an axis tilted from z towards x by `tilt` radians
  hinge2.axis = superdex::Real3{static_cast<real>(std::sin(tilt)), 0_r, static_cast<real>(std::cos(tilt))};
  hinge2.parentLinkFromJoint.SetTranslation(superdex::Real3{static_cast<real>(len1 - arm1), 0_r, 0_r});
  ap.joints.push_back(weld); ap.joints.push_back(hinge1);
  if (links == 2) ap.joints.push_back(hinge2);
  superdex::ArticulatedLinkParams base; base.name = "base"; base.parentLink = -1; base.shape = cube; base.colliderType = superdex::ColliderType::None; base.mass = 1_r;
  superdex::ArticulatedLinkParams l1; l1.name = "arm1"; l1.parentLink = 0; l1.shape = cube; l1.colliderType = superdex::ColliderType::None; l1.mass = static_cast<real>(mass1);
  l1.parentJointFromLink.SetTranslation(superdex::Real3{static_cast<real>(arm1), 0_r, 0_r});
  superdex::ArticulatedLinkParams l2; l2.name = "arm2"; l2.parentLink = 1; l2.shape = cube; l2.colliderType = superdex::ColliderType::None; l2.mass = static_cast<real>(mass2);
  l2.parentJointFromLink.SetTranslation(superdex::Real3{static_cast<real>(arm2), 0_r, 0_r});
  ap.links.push_back(base); ap.links.push_back(l1);
  if (links == 2) ap.links.push_back(l2);
  superdex::Actor* actor = sc->CreateArticulatedActor(ap, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_probe: actor: %s\n", e.ToString().c_str()); return 1; }
  if (newtonEuler == 1) { mochi::experimental::EnableNewtonEulerInertia(actor, true, e); }
  int const nDof = actor->GetNumDofs();
  std::vector<real> pose(nDof, 0_r), vel(nDof, 0_r);
  if (links == 2) { pose[nDof - 2] = angle1; pose[nDof - 1] = angle2; vel[nDof - 2] = omega1; vel[nDof - 1] = omega2; }
  else { pose[nDof - 1] = angle1; vel[nDof - 1] = omega1; }
  actor->SetArticulatedPoseFromJoints(superdex::Span<real const>(pose.data(), pose.size()), e);
  actor->SetArticulatedJointVelocities(superdex::Span<real const>(vel.data(), vel.size()), e);
  superdex::Actor* arm[2] = {nullptr, nullptr};
  std::vector<superdex::Actor*> nested;
  for (superdex::ActorHandle hh : actor->GetNestedLinkActors(e)) {
    superdex::Actor* lk = sc->GetActor(hh);
    if (lk == nullptr) continue;
    nested.push_back(lk);
    if (std::strcmp(lk->GetName(), "arm1") == 0) arm[0] = lk;
    if (std::strcmp(lk->GetName(), "arm2") == 0) arm[1] = lk;
  }
  // as tools/sdx_chain.cpp: if the links do not carry their names, the last links in the order they were given
  if ((arm[0] == nullptr || (links == 2 && arm[1] == nullptr)) && static_cast<int>(nested.size()) >= links) {
    if (links == 2) { arm[0] = nested[nested.size() - 2]; arm[1] = nested[nested.size() - 1]; }
    else { arm[0] = nested.back(); }
  }
  if (arm[0] == nullptr || (links == 2 && arm[1] == nullptr)) { std::fprintf(stderr, "sdx_probe: arms\n"); return 1; }
  Geo G; G.n = links; G.m[0] = mass1; G.m[1] = mass2; G.a[0] = arm1; G.a[1] = arm2; G.l1 = len1; G.g = gravity ? 9.8 : 0;
  for (int i = 0; i < 2; ++i) G.I[i] = 2.0 / 3.0 * G.m[i] * radius * radius;
  // one reading of the state: link and joint
  struct Rd { double Kl, Ll, Kj, Lj, U, q[2], qd[2]; };
  auto read = [&]() -> Rd {
    Rd r{};
    actor->GetArticulatedPose(superdex::Span<real>(pose.data(), pose.size()), e);
    actor->GetArticulatedJointVelocities(superdex::Span<real>(vel.data(), vel.size()), e);
    if (links == 2) { r.q[0] = pose[nDof - 2]; r.q[1] = pose[nDof - 1]; r.qd[0] = vel[nDof - 2]; r.qd[1] = vel[nDof - 1]; }
    else { r.q[0] = pose[nDof - 1]; r.qd[0] = vel[nDof - 1]; }
    double X[2][2], V[2][2], W[2];
    for (int i = 0; i < links; ++i) {
      superdex::Real3 p = arm[i]->GetCenterOfMassTransform(e).GetTranslation(), v = arm[i]->GetLinearVelocity(e), w = arm[i]->GetAngularVelocity(e);
      X[i][0] = p[0]; X[i][1] = p[1]; V[i][0] = v[0]; V[i][1] = v[1]; W[i] = w[2];
      r.Kl += 0.5 * G.m[i] * (v[0] * v[0] + v[1] * v[1] + v[2] * v[2]) + 0.5 * G.I[i] * (w[0] * w[0] + w[1] * w[1] + w[2] * w[2]);  // a cube's inertia is isotropic
      r.Ll += G.m[i] * (X[i][0] * V[i][1] - X[i][1] * V[i][0]) + G.I[i] * W[i];
      r.U += G.m[i] * G.g * X[i][1];
    }
    // joint reading: the elbow from the first centre's direction
    double px = X[0][0] * len1 / arm1, py = X[0][1] * len1 / arm1;
    double v1[2] = {-r.qd[0] * X[0][1], r.qd[0] * X[0][0]};
    r.Kj = 0.5 * G.m[0] * (v1[0] * v1[0] + v1[1] * v1[1]) + 0.5 * G.I[0] * r.qd[0] * r.qd[0];
    r.Lj = G.m[0] * (X[0][0] * v1[1] - X[0][1] * v1[0]) + G.I[0] * r.qd[0];
    if (links == 2) {
      double v2[2] = {-r.qd[0] * X[1][1] - r.qd[1] * (X[1][1] - py), r.qd[0] * X[1][0] + r.qd[1] * (X[1][0] - px)};
      double w2 = r.qd[0] + r.qd[1];
      r.Kj += 0.5 * G.m[1] * (v2[0] * v2[0] + v2[1] * v2[1]) + 0.5 * G.I[1] * w2 * w2;
      r.Lj += G.m[1] * (X[1][0] * v2[1] - X[1][1] * v2[0]) + G.I[1] * w2;
    }
    return r;
  };
  Rd const r0 = read();
  double const q0[2] = {angle1, angle2}, qd0[2] = {omega1, omega2};
  long const steps = std::lround(secs / dt);
  long nStop = 0, nDiv = 0; int most = 0;
  double kmost = std::max(r0.Kl, 1e-300), maxLl = 0, maxLj = 0, maxEl = 0, maxEj = 0;
  double maxLl2 = 0, maxLj2 = 0, maxEl2 = 0, maxEj2 = 0;
  // turning points of the first joint (links=1: the swings), placed between steps by a parabola, per 10,000 of a half turn
  std::vector<double> turns;
  double qa = r0.q[0], qb = r0.q[0], va = r0.qd[0];
  double lastTurn = r0.q[0];
  Rd r = r0;
  for (long s = 0; s < steps; ++s) {
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStop;
    if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiv;
    if (st.maxNonLinearIters > most) most = st.maxNonLinearIters;
    r = read();
    kmost = std::max(kmost, r.Kl);
    maxLl = std::max(maxLl, std::fabs(r.Ll - r0.Ll));
    maxLj = std::max(maxLj, std::fabs(r.Lj - r0.Lj));
    maxEl = std::max(maxEl, std::fabs(r.Kl + r.U - r0.Kl - r0.U));
    maxEj = std::max(maxEj, std::fabs(r.Kj + r.U - r0.Kj - r0.U));
    if (s >= 2) {  // after the start-up (the backward-Euler step and the first BDF2 step)
      maxLl2 = std::max(maxLl2, std::fabs(r.Ll - r0.Ll)); maxLj2 = std::max(maxLj2, std::fabs(r.Lj - r0.Lj));
      maxEl2 = std::max(maxEl2, std::fabs(r.Kl + r.U - r0.Kl - r0.U)); maxEj2 = std::max(maxEj2, std::fabs(r.Kj + r.U - r0.Kj - r0.U));
    }
    if ((va > 0 && r.qd[0] <= 0) || (va < 0 && r.qd[0] >= 0)) {
      // the extreme among the last three angles, refined by the parabola through them
      double a = qa, b = qb, c = r.q[0], k = a - 2 * b + c, top = b;
      if (k != 0 && ((b >= a && b >= c) || (b <= a && b <= c))) top = b - (c - a) * (c - a) / (8 * k);
      else if ((c >= b && va > 0) || (c <= b && va < 0)) top = c;
      turns.push_back(std::fabs(top - lastTurn) / M_PI * 10000);
      lastTurn = top;
    }
    qa = qb; qb = r.q[0]; va = r.qd[0];
  }
  double qr[2], qdr[2];
  Reference(G, q0, qd0, secs, qr, qdr);
  double const L0 = std::fabs(r0.Lj) > 1e-12 ? std::fabs(r0.Lj) : 1.0;
  std::printf("PROBE links %d integ %s dt %.9g steps %ld | L_link_end_ppm %.3f L_link_max_ppm %.3f L_joint_end_ppm %.3f L_joint_max_ppm %.3f"
              " | K_link_end_ppm %.3f K_joint_end_ppm %.3f E_link_maxdev_ppm %.3f E_joint_maxdev_ppm %.3f"
              " | q1_err %.4e q2_err %.4e qd1_err %.4e qd2_err %.4e | speed1_end %.9f speed2_end %.9f | stopped %ld diverged %ld most_iterations %d",
              links, integ.c_str(), dt, steps, (r.Ll - r0.Ll) / L0 * 1e6, maxLl / L0 * 1e6, (r.Lj - r0.Lj) / L0 * 1e6, maxLj / L0 * 1e6,
              (r.Kl - r0.Kl) / kmost * 1e6, (r.Kj - r0.Kj) / kmost * 1e6, maxEl / kmost * 1e6, maxEj / kmost * 1e6,
              r.q[0] - qr[0], r.q[1] - qr[1], r.qd[0] - qdr[0], r.qd[1] - qdr[1], r.qd[0], r.qd[1], nStop, nDiv, most);
  if (!turns.empty()) {
    double lo = 1e18, hi = 0;
    for (double t : turns) { lo = std::min(lo, t); hi = std::max(hi, t); }
    std::printf(" | swings %zu first %.2f %.2f %.2f least %.2f most %.2f last %.2f", turns.size(), turns[0], turns.size() > 1 ? turns[1] : 0.0,
                turns.size() > 2 ? turns[2] : 0.0, lo, hi, turns.back());
  }
  std::printf(" | E_link_end_ppm %.3f E_joint_end_ppm %.3f | after_startup L_link_max_ppm %.3f L_joint_max_ppm %.3f E_link_max_ppm %.3f E_joint_max_ppm %.3f\n",
              (r.Kl + r.U - r0.Kl - r0.U) / kmost * 1e6, (r.Kj + r.U - r0.Kj - r0.U) / kmost * 1e6,
              maxLl2 / L0 * 1e6, maxLj2 / L0 * 1e6, maxEl2 / kmost * 1e6, maxEj2 / kmost * 1e6);
  superdex::DestroyContext(ctx);
  return 0;
}
