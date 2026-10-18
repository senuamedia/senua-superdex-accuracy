// model_chain.cpp -- a standalone model of SuperDex v1.0.0's articulated inertia under backward Euler and BDF2, for
// a planar chain of one or two links on revolute joints about +z, to check the derivation of patch G's BDF2 form
// before any library is built. Not SuperDex: it mirrors the quantities SuperDex forms (mochi_articulated_body.cpp,
// mochi_rigid.cpp, rigid_body_assembly.h, mochi_integration.h):
//   - the joint angles q are the differential variable; the stage start is the integrator's combination of their
//     history (BE: q_n; BDF2: q_n + (1/3)(q_n - q_{n-1})), stage time step h_s = beta h (BE h, BDF2 2h/3);
//   - each link's pose is ALGEBRAIC: its stage-start centre is the forward kinematics of that combination, X(q_s);
//   - each link's velocity is DIFFERENTIAL: its stage-start velocity is the combination of the link's stored
//     velocities, and the stored velocity at a stage end is (X(q) - X(q_s)) / h_s (ComputeVelocityAtStageEnd);
//   - the translational inertial force m ((X(q) - X(q_s)) / h_s - v_s) / h_s is projected with J(q) (stock);
//   - the spin of each link (Newton-Euler inertia, planar: I (w - w_s) / h_s with w the finite difference of the
//     link's angle, which is linear in q, so FK and the combination commute for it).
// Variants (argument 'variant'):
//   0 stock
//   1 patch G as it stands: + share (J(q_n) - J(q))^T F per link; share 1 BE (q_n is the stage start), 1/3 BDF2
//   2 the derived BDF2 form: BE as variant 1; BDF2: no Jacobian transport, and the force that BDF2 gives a body
//     whose pose is a differential variable: F* = m ((X(q) - xs*) / h_s - vs*) / h_s with xs* = sum alpha X_{n+1-j}
//     and vs* = sum alpha V*_{n+1-j}, V*_k = (X_k - xs*_k) / h_s, written as F + m (D / h_s - sum alpha W) / h_s with
//     D = X(q_s) - xs* and W_k = D_k / h_s (the velocity defect of each step), projected with J(q)
// Reference: RK4 on M(q) qdd + c(q, qd) + g(q) = 0 at a step of 1e-6 s (independent of everything above).
// usage: model_chain links=<1|2> integ=<be|bdf2> variant=<0|1|2> dt=<s> secs=<s> [m1= m2= h= a1= l1= a2= q1= q2=
//        w1= w2= gravity=0|1]
// prints one line: final angles and speeds, their errors against the reference, angular momentum and energy drift
// (from the joint state, and from the link velocities as SuperDex stores them), in parts per million.
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

struct Geo {
  int n = 2;
  double m[2] = {1.0, 1.0}, I[2] = {0.0, 0.0}, a[2] = {0.2, 0.2}, l1 = 0.4, g = 0.0;
};
static void E(double p, double* e) { e[0] = std::cos(p); e[1] = std::sin(p); }
static void T(double p, double* t) { t[0] = -std::sin(p); t[1] = std::cos(p); }
// link centres
static void Fk(Geo const& G, double const* q, double X[2][2]) {
  double e1[2], e2[2];
  E(q[0], e1);
  X[0][0] = G.a[0] * e1[0]; X[0][1] = G.a[0] * e1[1];
  if (G.n == 2) {
    E(q[0] + q[1], e2);
    X[1][0] = G.l1 * e1[0] + G.a[1] * e2[0]; X[1][1] = G.l1 * e1[1] + G.a[1] * e2[1];
  }
}
// J[i][c][k]: d X_i[c] / d q_k ; spin Jacobian of link i on joint k: 1 when k <= i
static void Jac(Geo const& G, double const* q, double J[2][2][2]) {
  double t1[2], t2[2];
  T(q[0], t1);
  J[0][0][0] = G.a[0] * t1[0]; J[0][1][0] = G.a[0] * t1[1]; J[0][0][1] = 0; J[0][1][1] = 0;
  if (G.n == 2) {
    T(q[0] + q[1], t2);
    J[1][0][0] = G.l1 * t1[0] + G.a[1] * t2[0]; J[1][1][0] = G.l1 * t1[1] + G.a[1] * t2[1];
    J[1][0][1] = G.a[1] * t2[0]; J[1][1][1] = G.a[1] * t2[1];
  }
}
static double Spin(int i, double const* q) { return i == 0 ? q[0] : q[0] + q[1]; }
static double SpinRate(int i, double const* qd) { return i == 0 ? qd[0] : qd[0] + qd[1]; }

// exact invariants from the joint state
static void Invariants(Geo const& G, double const* q, double const* qd, double& L, double& K, double& U) {
  double X[2][2], J[2][2][2];
  Fk(G, q, X); Jac(G, q, J);
  L = 0; K = 0; U = 0;
  for (int i = 0; i < G.n; ++i) {
    double v[2] = {J[i][0][0] * qd[0] + J[i][0][1] * qd[1], J[i][1][0] * qd[0] + J[i][1][1] * qd[1]};
    double w = SpinRate(i, qd);
    L += G.m[i] * (X[i][0] * v[1] - X[i][1] * v[0]) + G.I[i] * w;
    K += 0.5 * G.m[i] * (v[0] * v[0] + v[1] * v[1]) + 0.5 * G.I[i] * w * w;
    U += G.m[i] * G.g * X[i][1];
  }
}

// RK4 reference on M qdd + c + g = 0
static void Accel(Geo const& G, double const* q, double const* qd, double* qdd) {
  double X[2][2], J[2][2][2];
  Fk(G, q, X); Jac(G, q, J);
  int const n = G.n;
  double M[2][2] = {{0, 0}, {0, 0}}, rhs[2] = {0, 0};
  double p[2] = {q[0], q[0] + q[1]}, pd[2] = {qd[0], qd[0] + qd[1]};
  for (int i = 0; i < n; ++i) {
    // centripetal part of the link's acceleration: Jdot qd = -sum_j r_ij pd_j^2 e(p_j)
    double c[2] = {0, 0}, e[2];
    E(p[0], e);
    double r0 = (i == 0) ? G.a[0] : G.l1;
    c[0] -= r0 * pd[0] * pd[0] * e[0]; c[1] -= r0 * pd[0] * pd[0] * e[1];
    if (i == 1) { E(p[1], e); c[0] -= G.a[1] * pd[1] * pd[1] * e[0]; c[1] -= G.a[1] * pd[1] * pd[1] * e[1]; }
    for (int k = 0; k < n; ++k) {
      for (int l = 0; l < n; ++l) {
        M[k][l] += G.m[i] * (J[i][0][k] * J[i][0][l] + J[i][1][k] * J[i][1][l]) +
                   G.I[i] * ((k <= i) ? 1.0 : 0.0) * ((l <= i) ? 1.0 : 0.0);
      }
      rhs[k] -= G.m[i] * (J[i][0][k] * c[0] + J[i][1][k] * c[1]) + G.m[i] * G.g * J[i][1][k];
    }
  }
  if (n == 1) { qdd[0] = rhs[0] / M[0][0]; qdd[1] = 0; return; }
  double det = M[0][0] * M[1][1] - M[0][1] * M[1][0];
  qdd[0] = (M[1][1] * rhs[0] - M[0][1] * rhs[1]) / det;
  qdd[1] = (-M[1][0] * rhs[0] + M[0][0] * rhs[1]) / det;
}
static void Reference(Geo const& G, double const* q0, double const* qd0, double secs, double* q, double* qd) {
  double y[4] = {q0[0], q0[1], qd0[0], qd0[1]};
  long const steps = std::lround(secs / 1e-6);
  double const h = secs / steps;
  auto f = [&](double const* s, double* d) { d[0] = s[2]; d[1] = s[3]; Accel(G, s, s + 2, d + 2); };
  for (long k = 0; k < steps; ++k) {
    double k1[4], k2[4], k3[4], k4[4], t[4];
    f(y, k1);
    for (int i = 0; i < 4; ++i) t[i] = y[i] + 0.5 * h * k1[i];
    f(t, k2);
    for (int i = 0; i < 4; ++i) t[i] = y[i] + 0.5 * h * k2[i];
    f(t, k3);
    for (int i = 0; i < 4; ++i) t[i] = y[i] + h * k3[i];
    f(t, k4);
    for (int i = 0; i < 4; ++i) y[i] += h / 6 * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]);
  }
  q[0] = y[0]; q[1] = y[1]; qd[0] = y[2]; qd[1] = y[3];
}

int main(int argc, char** argv) {
  Geo G;
  std::string integ = "bdf2";
  int variant = 0;
  double dt = 0.01, secs = 2.0, h = 0.04, q0[2] = {0, 0}, qd0[2] = {0, 0};
  int gravity = 0;
  for (int i = 1; i < argc; ++i) {
    std::string a = argv[i];
    auto v = [&](char const* k) -> char const* { size_t n = std::strlen(k); return a.compare(0, n, k) == 0 ? a.c_str() + n : nullptr; };
    char const* x;
    if ((x = v("links="))) G.n = std::atoi(x);
    else if ((x = v("integ="))) integ = x;
    else if ((x = v("variant="))) variant = std::atoi(x);
    else if ((x = v("dt="))) dt = std::atof(x);
    else if ((x = v("secs="))) secs = std::atof(x);
    else if ((x = v("m1="))) G.m[0] = std::atof(x);
    else if ((x = v("m2="))) G.m[1] = std::atof(x);
    else if ((x = v("h="))) h = std::atof(x);
    else if ((x = v("a1="))) G.a[0] = std::atof(x);
    else if ((x = v("l1="))) G.l1 = std::atof(x);
    else if ((x = v("a2="))) G.a[1] = std::atof(x);
    else if ((x = v("q1="))) q0[0] = std::atof(x);
    else if ((x = v("q2="))) q0[1] = std::atof(x);
    else if ((x = v("w1="))) qd0[0] = std::atof(x);
    else if ((x = v("w2="))) qd0[1] = std::atof(x);
    else if ((x = v("gravity="))) gravity = std::atoi(x);
    else { std::fprintf(stderr, "unknown %s\n", a.c_str()); return 2; }
  }
  G.g = gravity ? 9.8 : 0.0;
  for (int i = 0; i < 2; ++i) G.I[i] = 2.0 / 3.0 * G.m[i] * h * h;  // a cube of half-size h about its centre
  if (G.n == 1) { q0[1] = 0; qd0[1] = 0; }
  int const n = G.n;
  bool const bdf2 = integ == "bdf2";

  // history: joint angles, link centres, stored link velocities and spins, velocity defects (variant 2)
  double qn[2] = {q0[0], q0[1]}, qm[2] = {q0[0], q0[1]};
  double Xn[2][2], Xm[2][2], J0[2][2][2];
  Fk(G, qn, Xn); Fk(G, qm, Xm); Jac(G, qn, J0);
  double Vn[2][2], Vm[2][2], wn[2], wm[2], Wn[2][2] = {{0, 0}, {0, 0}}, Wm[2][2] = {{0, 0}, {0, 0}};
  for (int i = 0; i < n; ++i) {
    for (int c = 0; c < 2; ++c) Vn[i][c] = J0[i][c][0] * qd0[0] + J0[i][c][1] * qd0[1];
    wn[i] = SpinRate(i, qd0);
  }
  std::memcpy(Vm, Vn, sizeof Vn); std::memcpy(wm, wn, sizeof wn);
  double L0, K0, U0;
  Invariants(G, q0, qd0, L0, K0, U0);
  double const E0 = K0 + U0;
  long const steps = std::lround(secs / dt);
  double qd[2] = {qd0[0], qd0[1]};
  double maxdL = 0, maxdE = 0;
  for (long s = 0; s < steps; ++s) {
    bool const multi = bdf2 && s >= 1;  // SuperDex runs the first step of BDF2 as backward Euler
    double const hs = multi ? 2.0 / 3.0 * dt : dt;
    double const al1 = multi ? -1.0 / 3.0 : 0.0;  // q_s = q_n + al1 (q_{n-1} - q_n)
    double qs[2] = {qn[0] + al1 * (qm[0] - qn[0]), qn[1] + al1 * (qm[1] - qn[1])};
    double Xs[2][2];
    Fk(G, qs, Xs);
    double vs[2][2], ws[2];
    for (int i = 0; i < n; ++i) {
      for (int c = 0; c < 2; ++c) vs[i][c] = Vn[i][c] + al1 * (Vm[i][c] - Vn[i][c]);
      ws[i] = wn[i] + al1 * (wm[i] - wn[i]);
    }
    double Jn[2][2][2];
    Jac(G, qn, Jn);
    double const share = (variant == 1) ? (multi ? 1.0 / 3.0 : 1.0) : (variant >= 2 ? (multi ? 0.0 : 1.0) : 0.0);
    // variant 2's force correction per link, constant over the step
    double dF[2][2] = {{0, 0}, {0, 0}}, Wnow[2][2] = {{0, 0}, {0, 0}};
    if (variant >= 2 && multi) {
      for (int i = 0; i < n; ++i) {
        for (int c = 0; c < 2; ++c) {
          double const xs_star = Xn[i][c] + al1 * (Xm[i][c] - Xn[i][c]);
          double const D = Xs[i][c] - xs_star;
          double const Wc = Wn[i][c] + al1 * (Wm[i][c] - Wn[i][c]);
          dF[i][c] = G.m[i] * (D / hs - Wc) / hs;
          Wnow[i][c] = D / hs;
        }
      }
    }
    auto residual = [&](double const* q, double* R) {
      double X[2][2], J[2][2][2];
      Fk(G, q, X); Jac(G, q, J);
      R[0] = 0; R[1] = 0;
      for (int i = 0; i < n; ++i) {
        double F[2];
        for (int c = 0; c < 2; ++c) F[c] = G.m[i] / hs * ((X[i][c] - Xs[i][c]) / hs - vs[i][c]);
        F[1] += G.m[i] * G.g;  // gravity on the link's centre (its gradient is constant)
        double Fi[2] = {G.m[i] / hs * ((X[i][0] - Xs[i][0]) / hs - vs[i][0]), G.m[i] / hs * ((X[i][1] - Xs[i][1]) / hs - vs[i][1])};
        double tau = G.I[i] / hs * ((Spin(i, q) - Spin(i, qs)) / hs - ws[i]);
        for (int k = 0; k < n; ++k) {
          R[k] += J[i][0][k] * F[0] + J[i][1][k] * F[1] + ((k <= i) ? tau : 0.0);
          R[k] += share * ((Jn[i][0][k] - J[i][0][k]) * Fi[0] + (Jn[i][1][k] - J[i][1][k]) * Fi[1]);
          R[k] += J[i][0][k] * dF[i][0] + J[i][1][k] * dF[i][1];
        }
      }
    };
    // Newton with a finite-difference matrix, from q_n, to the last digit
    double q[2] = {qn[0], qn[1]};
    for (int it = 0; it < 60; ++it) {
      double R[2], A[2][2];
      residual(q, R);
      for (int k = 0; k < n; ++k) {
        double e = 1e-7, qp[2] = {q[0], q[1]}, qm2[2] = {q[0], q[1]}, Rp[2], Rm[2];
        qp[k] += e; qm2[k] -= e;
        residual(qp, Rp); residual(qm2, Rm);
        for (int r = 0; r < n; ++r) A[r][k] = (Rp[r] - Rm[r]) / (2 * e);
      }
      double dq[2];
      if (n == 1) { dq[0] = -R[0] / A[0][0]; dq[1] = 0; }
      else {
        double det = A[0][0] * A[1][1] - A[0][1] * A[1][0];
        dq[0] = -(A[1][1] * R[0] - A[0][1] * R[1]) / det;
        dq[1] = -(-A[1][0] * R[0] + A[0][0] * R[1]) / det;
      }
      q[0] += dq[0]; q[1] += dq[1];
      if (std::fabs(dq[0]) + std::fabs(dq[1]) < 1e-16) break;
    }
    // stage end: stored link velocities and spins, joint speeds
    double X[2][2];
    Fk(G, q, X);
    double Vnew[2][2], wnew[2];
    for (int i = 0; i < n; ++i) {
      for (int c = 0; c < 2; ++c) Vnew[i][c] = (X[i][c] - Xs[i][c]) / hs;
      wnew[i] = (Spin(i, q) - Spin(i, qs)) / hs;
    }
    qd[0] = (q[0] - qs[0]) / hs; qd[1] = (q[1] - qs[1]) / hs;
    // variant 3: variant 2 with a second-order start. At the backward-Euler step that starts a BDF2 run, the link
    // velocity kept for the history is the trapezoidal one, 2 (X_1 - X_0) / h - V_0, not the chord: W = V - v_s.
    if (variant == 3 && bdf2 && !multi) {
      for (int i = 0; i < n; ++i) for (int c = 0; c < 2; ++c) Wnow[i][c] = Vnew[i][c] - vs[i][c];
    }
    // variant 4: variant 2, and at the backward-Euler step that starts a BDF2 run the link velocities kept for the
    // history are projected onto the constraint's tangent (mass-weighted least squares: qd* = M^-1 sum J^T m V +
    // Jr^T I w), W = J qd* - V
    if (variant == 4 && bdf2 && !multi) {
      double J1[2][2][2];
      Jac(G, q, J1);
      double M[2][2] = {{0, 0}, {0, 0}}, b[2] = {0, 0};
      for (int i = 0; i < n; ++i) {
        for (int k = 0; k < n; ++k) {
          for (int l = 0; l < n; ++l)
            M[k][l] += G.m[i] * (J1[i][0][k] * J1[i][0][l] + J1[i][1][k] * J1[i][1][l]) + G.I[i] * ((k <= i) ? 1.0 : 0.0) * ((l <= i) ? 1.0 : 0.0);
          b[k] += G.m[i] * (J1[i][0][k] * Vnew[i][0] + J1[i][1][k] * Vnew[i][1]) + G.I[i] * ((k <= i) ? wnew[i] : 0.0);
        }
      }
      double qs_[2];
      if (n == 1) { qs_[0] = b[0] / M[0][0]; qs_[1] = 0; }
      else { double det = M[0][0] * M[1][1] - M[0][1] * M[1][0]; qs_[0] = (M[1][1] * b[0] - M[0][1] * b[1]) / det; qs_[1] = (-M[1][0] * b[0] + M[0][0] * b[1]) / det; }
      for (int i = 0; i < n; ++i) for (int c = 0; c < 2; ++c) Wnow[i][c] = J1[i][c][0] * qs_[0] + J1[i][c][1] * qs_[1] - Vnew[i][c];
    }
    // variant 5: variant 2, and at the backward-Euler step that starts a BDF2 run the link velocity kept for the
    // history is the one its joint motion implies, J(q_1) (q_1 - q_0) / h, W = J qd - V
    if (variant == 5 && bdf2 && !multi) {
      double J1[2][2][2];
      Jac(G, q, J1);
      for (int i = 0; i < n; ++i) for (int c = 0; c < 2; ++c) Wnow[i][c] = J1[i][c][0] * qd[0] + J1[i][c][1] * qd[1] - Vnew[i][c];
    }
    std::memcpy(Vm, Vn, sizeof Vn); std::memcpy(Vn, Vnew, sizeof Vn);
    std::memcpy(wm, wn, sizeof wn); std::memcpy(wn, wnew, sizeof wn);
    std::memcpy(Wm, Wn, sizeof Wn); std::memcpy(Wn, Wnow, sizeof Wn);
    std::memcpy(Xm, Xn, sizeof Xn); std::memcpy(Xn, X, sizeof Xn);
    qm[0] = qn[0]; qm[1] = qn[1]; qn[0] = q[0]; qn[1] = q[1];
    double L, K, U;
    Invariants(G, qn, qd, L, K, U);
    if (std::fabs(L - L0) > maxdL) maxdL = std::fabs(L - L0);
    if (std::fabs(K + U - E0) > maxdE) maxdE = std::fabs(K + U - E0);
  }
  // final readings: from the joint state, and from the link velocities as stored
  double L, K, U;
  Invariants(G, qn, qd, L, K, U);
  double Ls = 0, Ks = 0;
  for (int i = 0; i < n; ++i) {
    Ls += G.m[i] * (Xn[i][0] * Vn[i][1] - Xn[i][1] * Vn[i][0]) + G.I[i] * wn[i];
    Ks += 0.5 * G.m[i] * (Vn[i][0] * Vn[i][0] + Vn[i][1] * Vn[i][1]) + 0.5 * G.I[i] * wn[i] * wn[i];
  }
  double qr[2], qdr[2];
  Reference(G, q0, qd0, secs, qr, qdr);
  double Kscale = K0 > 0 ? K0 : 1;
  std::printf("MODEL links %d integ %s variant %d dt %.7g steps %ld | q1_err %.3e q2_err %.3e qd1_err %.3e qd2_err %.3e | "
              "L_joint_ppm %.4f L_link_ppm %.4f L_joint_maxdev_ppm %.4f | E_joint_ppm %.4f E_link_ppm %.4f E_maxdev_ppm %.4f\n",
              n, integ.c_str(), variant, dt, steps, qn[0] - qr[0], qn[1] - qr[1], qd[0] - qdr[0], qd[1] - qdr[1],
              L0 != 0 ? (L - L0) / std::fabs(L0) * 1e6 : (L - L0) * 1e6, L0 != 0 ? (Ls - L0) / std::fabs(L0) * 1e6 : (Ls - L0) * 1e6,
              L0 != 0 ? maxdL / std::fabs(L0) * 1e6 : maxdL * 1e6,
              (K + U - E0) / Kscale * 1e6, (Ks + U - E0) / Kscale * 1e6, maxdE / Kscale * 1e6);
  return 0;
}
