// sdx_deform.cpp -- SuperDex's deformable bodies asked questions that have textbook answers (SuperDex v1.0.0). One
// body is in the scene: a rod, a shell (cloth) or a soft body, built here as a plain regular mesh so that nothing
// about it is hidden in an asset file. It falls freely, hangs from a clamp, sticks out level from a clamp, or lies
// on the static ground plane. y is up, as in SuperDex's own scenes. What has a right answer:
//   fall        (rod_fall shell_fall soft_fall) no contact, no clamp. Backward Euler moves every node by the same
//               amount: after k steps the body has dropped g dt^2 k (k + 1) / 2 exactly, whatever the mesh and the
//               material, and it keeps its shape (the last column stays 0).
//   hang        (rod_hang shell_hang soft_hang) clamped at the top and let go unstretched. It rings up and down
//               and comes to rest longer by  w L^2 / (2 EA)  for the rod, with w = lin g;  rhoa g L^2 / (2 Y)  for
//               the strip, with Y = 4 mmu (mlambda + mmu) / (mlambda + 2 mmu);  rho g L^2 / (2 young)  for the
//               bar. The slowest ring has the period 4 L sqrt(lin / EA), 4 L sqrt(rhoa / Y), 4 L sqrt(rho / young).
//   cantilever  (rod_cantilever) level, clamped at one end. The tip sags w L^4 / (8 EI) and the slowest bending
//               ring has the frequency (1.8751^2 / (2 pi)) sqrt(EI / (lin L^4)).
//   rest        (shell_rest soft_rest) let go h0 above the ground: it must come to rest on the ground and stay.
//   slide       (shell_slide soft_slide) lying on the ground, then given the speed v0 along +x: Coulomb's law stops
//               the centre of mass in the distance v0^2 / (2 mu g).
//   hold        (shell_hold soft_hold) lying on the ground, then gravity is turned by the angle `tilt` towards +x,
//               which is the same thing as tilting the table: with tan(tilt) below mu it must not move.
// The program only plays the scene and writes what the body did at every step, as whole numbers. The measuring is
// done elsewhere.
//
// usage: sdx_deform <out.txt> case=<name> dt=<seconds> [setting=value ...]
//   case     rod_fall rod_hang rod_cantilever shell_fall shell_hang shell_rest shell_slide shell_hold soft_fall
//            soft_hang soft_rest soft_slide soft_hold
//   secs     how long to play, settling included (default: fall 0.5, hang 2, cantilever 4, rest 1, slide and
//            hold 1.5)
//   g        gravity, m/s^2 (default 9.8)
//   n        mesh resolution: elements along a rod; cells along a strip or a bar (cells of the same size go
//            across it); cells along each side of a patch or a cube. A shell cell is two triangles, a soft cell is
//            five tetrahedra (default: rod 32, cantilever 64, strip and bar 20, patch 8, cube 4)
//   len      length of the rod, the strip or the bar, metres (default 0.5)
//   clampmid 1 = cantilever: the held first element sits across the clamp, its middle at x = 0, and the rod runs
//            on to x = len; so the length that bends is len (default 0: the rod runs from x = 0, and holding its
//            first two nodes makes it stiff for half an element beyond the clamp)
//   wid      width of the strip or of the square bar, metres (default: strip 0.1, bar 0.05)
//   size     side of the square patch or of the cube, metres (default: patch 0.2, cube 0.1)
//   the rod:    lin ea ei gj rotin   mass per length kg/m, stretching stiffness N, bending stiffness N m^2 (the
//            same about both axes), twisting stiffness N m^2, turning inertia per length kg m (default 0.1, 100, 2,
//            5e-4, 1e-6: SuperDex's shipped values but for ei, shipped 5e-4, which would let a 0.5 m rod sag far
//            past the small deflection the textbook formula is for)
//   the shell:  mlambda mmu balpha bbeta rhoa   the two membrane Lame constants N/m, the two bending constants
//            N m, mass per area kg/m^2 (default 0, 400, 2e-5, 7e-5, 1: SuperDex's shipped values but for mlambda,
//            shipped 300; with mlambda 0 a stretched membrane does not narrow, so the clamp does not fight it)
//   the soft body:  young nu rho mat   Young's modulus Pa, Poisson ratio, density kg/m^3, and the material law:
//            nh neo-Hookean, svk St Venant-Kirchhoff, lin linear elastic (default 1e6, 0, 1000, nh; shipped 1e5,
//            0.45, 1000, nh)
//   massdamp, stiffdamp   the body's mass and stiffness damping coefficients, 1/s and s (shipped: 0, 0)
//   recenter 0 = a soft body's own frame is not moved along with it (shipped: 1)
//   on the ground (rest, slide, hold):
//   h0       height of the body's lowest face above the ground when it is let go, metres (default: rest 0.01,
//            slide and hold 0.001, which is where the shipped contact force starts)
//   settle   seconds the body is first left to settle under plain gravity; v0 and tilt begin when it is over
//            (default: rest 0, slide and hold 0.5)
//   v0       speed along +x given to every node when the settling is over, m/s (default: slide 1, else 0; in the
//            fall cases it is the sideways speed at release; ignored when the body is clamped)
//   tilt     angle gravity is turned by towards +x when the settling is over, radians (default: hold 0.2, else 0)
//   mu       Coulomb friction coefficient of the body and of the ground (default 0.5, the shipped value)
//   ndamp, visc, penalty, smooth, falloff   the contact's normal damping coefficient, viscous friction
//            coefficient, penalty stiffness, smoothing half-distance and friction falloff speed (shipped: 0, 0, 1e9,
//            0.005, 0.01)
//   pc       0 = the shell has no point-cloud collider (shipped: 1); pcradius its radius, metres (shipped: 0.01)
//   the solver:
//   integ    time integrator: be bdf2 dirk33 bdf3 dirk22 dirk23 sdirk12 (implicit midpoint) sdirk22 (shipped: be)
//   maxiter  nonlinear iteration limit (default 200; shipped 4)
//   abstol, reltol        nonlinear solver absolute and relative residual tolerances (shipped: 1e-3, 1e-6)
//   linabstol, linreltol  linear solver absolute and relative tolerances (shipped: 1e-9, 1e-5)
//   explosion  0 = the nonlinear solver's explosion control is off (shipped: 1)
//   implicitn, expnormals, fade, fricmodel=cinf, armijo   SuperDex's own evaluation switches, as in sdx_contact
// writes <out.txt>: one header line, then one line a solver step.
//   The header is the word DEFORM and then pairs "<name> <whole number>", always the same names in the same order.
//   Lengths are in nanometres, the rest in millionths of the SI unit unless the name says otherwise:
//     case_id (1 rod_fall 2 rod_hang 3 rod_cantilever 4 shell_fall 5 shell_hang 6 shell_rest 7 shell_slide
//     8 shell_hold 9 soft_fall 10 soft_hang 11 soft_rest 12 soft_slide 13 soft_hold)  kind (1 rod 2 shell 3 soft)
//     up_axis (1: y)  dt_ns  steps  settle_steps  integ (1 be 2 bdf2 3 dirk33 4 bdf3 5 dirk22 6 dirk23 7 sdirk12
//     8 sdirk22)  maxiter  g_ums2  tilt_urad  v0_ums
//     h0_nm  mu_ppm  n  nodes  elements  clamped_dofs  mass_mg  len_nm  wid_nm  size_nm  lin_mgpm  ea_uN  ei_uNm2
//     gj_uNm2  rotin_ugm (micrograms metre)  mlambda_uNpm  mmu_uNpm  balpha_nNm  bbeta_nNm (nano newton metres)
//     rhoa_mgpm2  young_Pa (whole pascals)  nu_ppm  rho_gpm3 (grams per cubic metre)  mat (1 nh 2 svk 3 lin)
//     massdamp_u  stiffdamp_u  penalty_Papm (whole pascals per metre)  smooth_nm  thresh_nm (the distance the
//     contact force starts at)  falloff_ums  ndamp_u  visc_u  track_node  com0_x_nm com0_y_nm com0_z_nm (the centre
//     of mass before the first step)  trk0_x_nm trk0_y_nm trk0_z_nm (the tracked node before the first step)
//   A constant the body does not have (ea for a shell, say) is still written, at its default, and means nothing.
//   Each line after it is the state at the end of one solver step, eleven whole numbers:
//     1      the step, counted from 0 (so line 0 is one time step after release)
//     2-4    centre of mass x y z, nanometres. It is the centre of the body's rest mass: every node weighed by
//            its share of the rest length, area or volume of the elements it belongs to
//     5-7    the tracked node x y z, nanometres. The tracked node is the free tip when the body is clamped (the
//            lowest node nearest the middle when it hangs, the far end of the cantilever) and node 0 otherwise
//     8-10   velocity of the centre of mass x y z, micrometres a second: its move over the step divided by dt,
//            which for backward Euler is the solver's own velocity (SuperDex gives no node velocities back)
//     11     the largest distance of any node from where the rest shape puts it, nanometres. For a clamped body
//            the rest shape stays where it was; for a free one it is carried along with the centre of mass (not
//            turned), so this column is 0 for as long as the body only shifts
// prints one STATS line. Exit 0 on success.
#include <superdex_physics.h>
#include <mochi_physics/mochi_physics_experimental.h>

#include <algorithm>
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

enum { kRod = 1, kShell = 2, kSoft = 3 };                    // what the body is
enum { kFall = 0, kHang = 1, kCantilever = 2, kGround = 3 };  // what is done with it
enum { kRest = 0, kSlide = 1, kHold = 2 };                   // on the ground: what happens after the settling

struct CaseInfo {
  char const* name;
  int id;
  int kind;
  int setup;
  int event;
};
CaseInfo const kCases[] = {
    {"rod_fall", 1, kRod, kFall, kRest},        {"rod_hang", 2, kRod, kHang, kRest},
    {"rod_cantilever", 3, kRod, kCantilever, kRest}, {"shell_fall", 4, kShell, kFall, kRest},
    {"shell_hang", 5, kShell, kHang, kRest},    {"shell_rest", 6, kShell, kGround, kRest},
    {"shell_slide", 7, kShell, kGround, kSlide}, {"shell_hold", 8, kShell, kGround, kHold},
    {"soft_fall", 9, kSoft, kFall, kRest},      {"soft_hang", 10, kSoft, kHang, kRest},
    {"soft_rest", 11, kSoft, kGround, kRest},   {"soft_slide", 12, kSoft, kGround, kSlide},
    {"soft_hold", 13, kSoft, kGround, kHold}};

// A flat rectangle of nu x nv cells with a corner at o and the edges eu and ev, every cell cut into two triangles.
// Node (i, j) has the number i + j (nu + 1). The numbering and the cut are those of SuperDex's own uniform test
// mesh (UniformSquareTriangularMeshData), and the triangles face along eu x ev.
void TriGrid(int nu, int nv, double const o[3], double const eu[3], double const ev[3], std::vector<real>& coords,
             std::vector<int>& tris) {
  int const row = nu + 1;
  for (int j = 0; j <= nv; ++j)
    for (int i = 0; i <= nu; ++i)
      for (int k = 0; k < 3; ++k) coords.push_back(static_cast<real>(o[k] + eu[k] * i / nu + ev[k] * j / nv));
  for (int j = 0; j < nv; ++j)
    for (int i = 0; i < nu; ++i) {
      int const a = i + j * row, b = a + 1, c = a + row, d = c + 1;
      int const two[6] = {a, b, c, b, d, c};
      tris.insert(tris.end(), two, two + 6);
    }
}

// A box of nx x ny x nz cells with a corner at o and the sides s, every cell cut into five tetrahedra. Node
// (i, j, k) has the number i + j (nx + 1) + k (nx + 1) (ny + 1). The cut is mirrored from each cell to the next so
// that the triangles on shared faces agree: again the numbering and the cut of SuperDex's own uniform test mesh
// (UniformCubeTetMeshData).
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

// The rest length, area or volume of one element: `nodes` of them, numbered in `el`, at the positions x.
double Measure(int nodes, int const* el, std::vector<double> const& x) {
  double const* const a = &x[3 * static_cast<size_t>(el[0])];
  double const* const b = &x[3 * static_cast<size_t>(el[1])];
  double const u[3] = {b[0] - a[0], b[1] - a[1], b[2] - a[2]};
  if (nodes == 2) return std::sqrt(u[0] * u[0] + u[1] * u[1] + u[2] * u[2]);
  double const* const c = &x[3 * static_cast<size_t>(el[2])];
  double const v[3] = {c[0] - a[0], c[1] - a[1], c[2] - a[2]};
  double const w[3] = {u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0]};
  if (nodes == 3) return 0.5 * std::sqrt(w[0] * w[0] + w[1] * w[1] + w[2] * w[2]);
  double const* const d = &x[3 * static_cast<size_t>(el[3])];
  return std::fabs(w[0] * (d[0] - a[0]) + w[1] * (d[1] - a[1]) + w[2] * (d[2] - a[2])) / 6.0;
}
} // namespace

int main(int argc, char** argv) {
  if (argc < 3) {
    std::fprintf(stderr, "usage: sdx_deform <out.txt> case=NAME dt=<seconds> [secs=S] [g=X] [n=N] [len=M] [wid=M] "
                         "[size=M] [lin=X] [ea=X] [ei=X] [gj=X] [rotin=X] [mlambda=X] [mmu=X] [balpha=X] [bbeta=X] "
                         "[rhoa=X] [young=X] [nu=X] [rho=X] [mat=nh|svk|lin] [massdamp=X] [stiffdamp=X] "
                         "[recenter=0] [h0=M] [settle=S] [v0=V] [tilt=RAD] [mu=X] [ndamp=X] [visc=X] [penalty=X] "
                         "[smooth=M] [falloff=V] [pc=0] [pcradius=M] [integ=NAME] [maxiter=N] [abstol=X] "
                         "[reltol=X] [linabstol=X] [linreltol=X] [explosion=0] [implicitn=1] [expnormals=1] "
                         "[fade=0] [fricmodel=cinf] [armijo=1]\n"
                         "  cases: rod_fall rod_hang rod_cantilever shell_fall shell_hang shell_rest shell_slide "
                         "shell_hold soft_fall soft_hang soft_rest soft_slide soft_hold\n");
    return 2;
  }
  // the case sets the defaults, so it is read before the other settings
  CaseInfo const* info = nullptr;
  bool caseGiven = false;
  for (int i = 2; i < argc; ++i) {
    if (std::strncmp(argv[i], "case=", 5) != 0) continue;
    caseGiven = true;
    info = nullptr;
    for (CaseInfo const& c : kCases)
      if (std::strcmp(argv[i] + 5, c.name) == 0) info = &c;
    if (info == nullptr) { std::fprintf(stderr, "sdx_deform: unknown case %s\n", argv[i] + 5); return 2; }
  }
  if (!caseGiven) { std::fprintf(stderr, "sdx_deform: case must be given\n"); return 2; }
  bool const isRod = info->kind == kRod, isShell = info->kind == kShell;
  bool const onGround = info->setup == kGround, clamped = info->setup == kHang || info->setup == kCantilever;

  // SuperDex's shipped constants, read from its own parameter structs
  mochi::experimental::RodMaterialParams rodShipped;
  mochi::experimental::ShellMaterialParams shellShipped;
  superdex::SoftMaterialParams softShipped;
  superdex::ContactParams contactShipped;

  double dt = 0.0, g = 9.8;
  double secs = info->setup == kFall ? 0.5 : info->setup == kHang ? 2.0 : info->setup == kCantilever ? 4.0
                : info->event == kRest ? 1.0 : 1.5;
  double settle = (onGround && info->event != kRest) ? 0.5 : 0.0;
  double h0 = onGround ? (info->event == kRest ? 0.01 : 0.001) : 0.0;
  double v0 = (onGround && info->event == kSlide) ? 1.0 : 0.0;
  double tilt = (onGround && info->event == kHold) ? 0.2 : 0.0;
  double mu = static_cast<double>(contactShipped.coulombFrictionCoefficient);
  int n = isRod ? (info->setup == kCantilever ? 64 : 32) : info->setup == kHang ? 20 : isShell ? 8 : 4;
  double len = 0.5, wid = isShell ? 0.1 : 0.05, size = isShell ? 0.2 : 0.1;
  double lin = static_cast<double>(rodShipped.linearDensity), ea = static_cast<double>(rodShipped.axialStiffness);
  double ei = 2.0, gj = static_cast<double>(rodShipped.torsionalStiffness);
  double rotin = static_cast<double>(rodShipped.linearRotationalInertia);
  double mlambda = 0.0, mmu = static_cast<double>(shellShipped.membraneMu);
  double balpha = static_cast<double>(shellShipped.bendingAlpha), bbeta = static_cast<double>(shellShipped.bendingBeta);
  double rhoa = static_cast<double>(shellShipped.density);
  double young = 1e6, nu = 0.0, rho = static_cast<double>(softShipped.density);
  double massDamp = -1.0, stiffDamp = -1.0;
  double ndamp = -1.0, visc = -1.0, penalty = -1.0, smooth = -1.0, falloff = -1.0, pcRadius = -1.0;
  double absTol = -1.0, relTol = -1.0, linAbsTol = -1.0, linRelTol = -1.0;
  int recenter = 1, pc = 1, maxIter = 200, explosion = 1, implicitN = 0, expNormals = 0, fade = 1, cinf = 0, armijo = 0;
  int clampMid = 0;
  std::string integ = "be", mat = "nh", extra;
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto val = [&](char const* key) -> char const* {
      size_t k = std::strlen(key);
      return a.compare(0, k, key) == 0 ? a.c_str() + k : nullptr;
    };
    char const* v = nullptr;
    bool note = true; // every setting but the case and the time step goes on the STATS line
    if ((v = val("case="))) note = false;
    else if ((v = val("dt="))) { dt = std::atof(v); note = false; }
    else if ((v = val("secs="))) secs = std::atof(v);
    else if ((v = val("g="))) g = std::atof(v);
    else if ((v = val("n="))) n = std::atoi(v);
    else if ((v = val("len="))) len = std::atof(v);
    else if ((v = val("wid="))) wid = std::atof(v);
    else if ((v = val("size="))) size = std::atof(v);
    else if ((v = val("lin="))) lin = std::atof(v);
    else if ((v = val("ea="))) ea = std::atof(v);
    else if ((v = val("ei="))) ei = std::atof(v);
    else if ((v = val("gj="))) gj = std::atof(v);
    else if ((v = val("rotin="))) rotin = std::atof(v);
    else if ((v = val("mlambda="))) mlambda = std::atof(v);
    else if ((v = val("mmu="))) mmu = std::atof(v);
    else if ((v = val("balpha="))) balpha = std::atof(v);
    else if ((v = val("bbeta="))) bbeta = std::atof(v);
    else if ((v = val("rhoa="))) rhoa = std::atof(v);
    else if ((v = val("young="))) young = std::atof(v);
    else if ((v = val("nu="))) nu = std::atof(v);
    else if ((v = val("rho="))) rho = std::atof(v);
    else if ((v = val("mat="))) mat = v;
    else if ((v = val("massdamp="))) massDamp = std::atof(v);
    else if ((v = val("stiffdamp="))) stiffDamp = std::atof(v);
    else if ((v = val("recenter="))) recenter = std::atoi(v);
    else if ((v = val("clampmid="))) clampMid = std::atoi(v);
    else if ((v = val("h0="))) h0 = std::atof(v);
    else if ((v = val("settle="))) settle = std::atof(v);
    else if ((v = val("v0="))) v0 = std::atof(v);
    else if ((v = val("tilt="))) tilt = std::atof(v);
    else if ((v = val("mu="))) mu = std::atof(v);
    else if ((v = val("ndamp="))) ndamp = std::atof(v);
    else if ((v = val("visc="))) visc = std::atof(v);
    else if ((v = val("penalty="))) penalty = std::atof(v);
    else if ((v = val("smooth="))) smooth = std::atof(v);
    else if ((v = val("falloff="))) falloff = std::atof(v);
    else if ((v = val("pcradius="))) pcRadius = std::atof(v);
    else if ((v = val("pc="))) pc = std::atoi(v);
    else if ((v = val("integ="))) integ = v;
    else if ((v = val("maxiter="))) maxIter = std::atoi(v);
    else if ((v = val("abstol="))) absTol = std::atof(v);
    else if ((v = val("reltol="))) relTol = std::atof(v);
    else if ((v = val("linabstol="))) linAbsTol = std::atof(v);
    else if ((v = val("linreltol="))) linRelTol = std::atof(v);
    else if ((v = val("explosion="))) explosion = std::atoi(v);
    else if ((v = val("implicitn="))) implicitN = std::atoi(v);
    else if ((v = val("expnormals="))) expNormals = std::atoi(v);
    else if ((v = val("fade="))) fade = std::atoi(v);
    else if (a == "fricmodel=cinf") cinf = 1;
    else if ((v = val("armijo="))) armijo = std::atoi(v);
    else { std::fprintf(stderr, "sdx_deform: unknown setting %s\n", a.c_str()); return 2; }
    if (note) extra += " " + a;
  }
  if (dt <= 0.0) { std::fprintf(stderr, "sdx_deform: dt must be given\n"); return 2; }
  if (n < (info->setup == kCantilever ? 2 : 1)) { std::fprintf(stderr, "sdx_deform: n is too small\n"); return 2; }
  if (!(len > 0.0) || !(wid > 0.0) || !(size > 0.0)) {
    std::fprintf(stderr, "sdx_deform: len, wid and size must be positive\n");
    return 2;
  }
  int const integId = integ == "be" ? 1 : integ == "bdf2" ? 2 : integ == "dirk33" ? 3 : integ == "bdf3" ? 4
                      : integ == "dirk22" ? 5 : integ == "dirk23" ? 6 : integ == "sdirk12" ? 7 : integ == "sdirk22" ? 8 : 0;
  if (integId == 0) { std::fprintf(stderr, "sdx_deform: unknown integrator %s\n", integ.c_str()); return 2; }
  int const matId = mat == "nh" ? 1 : mat == "svk" ? 2 : mat == "lin" ? 3 : 0;
  if (matId == 0) { std::fprintf(stderr, "sdx_deform: unknown material law %s\n", mat.c_str()); return 2; }
  long const steps = std::max(0L, static_cast<long>(std::llround(secs / dt)));
  long const settleSteps = std::min(steps, std::max(0L, static_cast<long>(std::llround(settle / dt))));

  superdex::Error e;
  superdex::Context* ctx = superdex::CreateContext(0);
  superdex::Scene* sc = ctx->CreateScene("deform");
  // gravity, turned by the angle `turned` from straight down towards +x
  auto gravity = [&](double turned) {
    real const along = static_cast<real>(g * std::sin(turned)), down = static_cast<real>(-g * std::cos(turned));
    sc->SetGravity(superdex::Real3{along, down, 0_r});
  };
  gravity(settleSteps > 0 ? 0.0 : tilt);
  {
    superdex::SolverParams sol = sc->GetSolverParams();
    if (integId == 1) sol.integrationMethod = superdex::IntegrationMethod::BackwardEuler;
    else if (integId == 2) sol.integrationMethod = superdex::IntegrationMethod::BDF2;
    else if (integId == 3) sol.integrationMethod = superdex::IntegrationMethod::DIRK33;
    else if (integId == 4) sol.integrationMethod = superdex::IntegrationMethod::BDF3;
    else if (integId == 5) sol.integrationMethod = superdex::IntegrationMethod::DIRK22;
    else if (integId == 6) sol.integrationMethod = superdex::IntegrationMethod::DIRK23;
    else if (integId == 7) sol.integrationMethod = superdex::IntegrationMethod::SymplecticDIRK12;
    else sol.integrationMethod = superdex::IntegrationMethod::SymplecticDIRK22;
    sol.nonLinearSolver.maxIter = maxIter;
    if (absTol >= 0.0) sol.nonLinearSolver.absTol = static_cast<real>(absTol);
    if (relTol >= 0.0) sol.nonLinearSolver.relTol = static_cast<real>(relTol);
    if (explosion == 0) sol.nonLinearSolver.explosionControl = false;
    if (linAbsTol >= 0.0) sol.linearSolver.absTol = static_cast<real>(linAbsTol);
    if (linRelTol >= 0.0) sol.linearSolver.relTol = static_cast<real>(linRelTol);
    sol.experimentalEval.implicitNormalForceForDissipation = implicitN != 0;
    sol.experimentalEval.explicitNormals = expNormals != 0;
    sol.experimentalEval.fadeFriction = fade != 0;
    if (cinf == 1) sol.experimentalEval.frictionModel = superdex::CoulombFrictionModel::CinfRegularized;
    if (armijo == 1) sol.nonLinearSolver.lineSearchType = superdex::LineSearchType::Armijo;
    sc->SetSolverParams(sol, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: solver params: %s\n", e.ToString().c_str()); return 1; }
  }
  auto contact = [&](superdex::ContactParams& cp) {
    cp.coulombFrictionCoefficient = static_cast<real>(mu);
    if (ndamp >= 0.0) cp.normalViscousDampingCoefficient = static_cast<real>(ndamp);
    if (visc >= 0.0) cp.viscousFrictionCoefficient = static_cast<real>(visc);
    if (penalty > 0.0) cp.penaltyCoefficient = static_cast<real>(penalty);
    if (smooth > 0.0) cp.penaltySmoothingHalfDistance = static_cast<real>(smooth);
    if (falloff > 0.0) cp.frictionFalloffVel = static_cast<real>(falloff);
  };
  superdex::ContactParams shown; // the contact constants in force, for the header
  contact(shown);
  if (onGround) {
    superdex::RigidActorParams gp;
    gp.name = "ground";
    gp.shape = ctx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
    gp.colliderType = superdex::ColliderType::Plane;
    gp.isStatic = true;
    contact(gp.contact);
    sc->CreateRigidActor(gp, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: ground: %s\n", e.ToString().c_str()); return 1; }
  }

  // the body. Its mesh is laid out where the body starts, so the body's own frame is the world's
  superdex::ShapeHandle shape;
  superdex::Actor* actor = nullptr;
  double massDampUsed = 0.0, stiffDampUsed = 0.0;
  int const across = std::max(1, static_cast<int>(std::lround(n * wid / len))); // cells across a strip or a bar
  if (isRod) {
    // fall: level along x, centred. hang: straight down from the origin. cantilever: level along +x from the origin
    // with clampmid the element length is len / (n - 1/2), and the rod starts half an element behind the clamp
    double const a[3] = {info->setup == kFall ? -0.5 * len
                         : (info->setup == kCantilever && clampMid == 1) ? -0.5 * len / (n - 0.5) : 0.0, 0.0, 0.0};
    double const b[3] = {info->setup == kHang ? 0.0 : (info->setup == kCantilever && clampMid == 1) ? len : a[0] + len,
                         info->setup == kHang ? -len : 0.0, 0.0};
    std::vector<superdex::Real3> nodes, axes;
    for (int i = 0; i <= n; ++i)
      nodes.push_back(superdex::Real3{static_cast<real>(a[0] + (b[0] - a[0]) * i / n),
                                      static_cast<real>(a[1] + (b[1] - a[1]) * i / n), 0_r});
    // one unit vector an element, square to the rod: it names the first of the two bending axes
    for (int i = 0; i < n; ++i)
      axes.push_back(info->setup == kHang ? superdex::Real3{1_r, 0_r, 0_r} : superdex::Real3{0_r, 1_r, 0_r});
    superdex::Span<superdex::Real3 const> const nodeSpan(nodes.data(), nodes.size());
    superdex::Span<superdex::Real3 const> const axisSpan(axes.data(), axes.size());
    shape = mochi::experimental::CreatePolylineShape(ctx, nodeSpan, axisSpan, /*isClosedLoop=*/false, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: rod shape: %s\n", e.ToString().c_str()); return 1; }
    mochi::experimental::RodActorParams rp;
    rp.name = "rod";
    rp.shape = shape;
    rp.material.linearDensity = static_cast<real>(lin);
    rp.material.linearRotationalInertia = static_cast<real>(rotin);
    rp.material.axialStiffness = static_cast<real>(ea);
    rp.material.torsionalStiffness = static_cast<real>(gj);
    rp.material.flexuralStiffness = superdex::Real2{static_cast<real>(ei), static_cast<real>(ei)};
    if (massDamp >= 0.0) rp.material.massDampingCoefficient = static_cast<real>(massDamp);
    if (stiffDamp >= 0.0) rp.material.stiffnessDampingCoefficient = static_cast<real>(stiffDamp);
    massDampUsed = static_cast<double>(rp.material.massDampingCoefficient);
    stiffDampUsed = static_cast<double>(rp.material.stiffnessDampingCoefficient);
    contact(rp.contact);
    actor = mochi::experimental::CreateRodActor(sc, rp, e);
  } else if (isShell) {
    std::vector<real> coords;
    std::vector<int> tris;
    if (info->setup == kHang) {
      // a strip standing in the xy plane, its top edge on y = 0
      double const o[3] = {-0.5 * wid, -len, 0.0}, eu[3] = {wid, 0.0, 0.0}, ev[3] = {0.0, len, 0.0};
      TriGrid(across, n, o, eu, ev, coords, tris);
    } else {
      // a square patch lying level, facing up, h0 above the ground (or on y = 0 when there is no ground)
      double const o[3] = {-0.5 * size, h0, -0.5 * size}, eu[3] = {0.0, 0.0, size}, ev[3] = {size, 0.0, 0.0};
      TriGrid(n, n, o, eu, ev, coords, tris);
    }
    shape = ctx->CreateTriMeshShape(coords, tris, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: shell shape: %s\n", e.ToString().c_str()); return 1; }
    mochi::experimental::ShellActorParams sp;
    sp.name = "shell";
    sp.shape = shape;
    sp.material.membraneLambda = static_cast<real>(mlambda);
    sp.material.membraneMu = static_cast<real>(mmu);
    sp.material.bendingAlpha = static_cast<real>(balpha);
    sp.material.bendingBeta = static_cast<real>(bbeta);
    sp.material.density = static_cast<real>(rhoa);
    if (massDamp >= 0.0) sp.material.massDampingCoefficient = static_cast<real>(massDamp);
    if (stiffDamp >= 0.0) sp.material.stiffnessDampingCoefficient = static_cast<real>(stiffDamp);
    massDampUsed = static_cast<double>(sp.material.massDampingCoefficient);
    stiffDampUsed = static_cast<double>(sp.material.stiffnessDampingCoefficient);
    if (pc == 0) sp.colliderType = superdex::ColliderType::None;
    if (pcRadius > 0.0) sp.pointCloudCollider.radius = static_cast<real>(pcRadius);
    contact(sp.contact);
    actor = mochi::experimental::CreateShellActor(sc, sp, e);
  } else {
    std::vector<real> coords;
    std::vector<int> tets;
    if (info->setup == kHang) {
      // a square bar hanging down from y = 0, its axis on the y axis
      double const o[3] = {-0.5 * wid, -len, -0.5 * wid}, s[3] = {wid, len, wid};
      TetGrid(across, n, across, o, s, coords, tets);
    } else {
      // a cube standing h0 above the ground (or on y = 0 when there is no ground)
      double const o[3] = {-0.5 * size, h0, -0.5 * size}, s[3] = {size, size, size};
      TetGrid(n, n, n, o, s, coords, tets);
    }
    shape = ctx->CreateTetMeshShape(coords, tets, e);
    if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: soft shape: %s\n", e.ToString().c_str()); return 1; }
    superdex::SoftActorParams bp;
    bp.name = "soft";
    bp.shape = shape;
    bp.material.type = matId == 1 ? superdex::SoftMaterialType::NeoHookean
                       : matId == 2 ? superdex::SoftMaterialType::StVenantKirchhoff
                       : superdex::SoftMaterialType::LinearElastic;
    // only the constants of the chosen law are read, so all three are given the same
    bp.material.neoHookean.youngsModulus = static_cast<real>(young);
    bp.material.neoHookean.poissonRatio = static_cast<real>(nu);
    bp.material.stVenantKirchhoff.youngsModulus = static_cast<real>(young);
    bp.material.stVenantKirchhoff.poissonRatio = static_cast<real>(nu);
    bp.material.linearElastic.youngsModulus = static_cast<real>(young);
    bp.material.linearElastic.poissonRatio = static_cast<real>(nu);
    bp.material.density = static_cast<real>(rho);
    if (massDamp >= 0.0) bp.material.massDampingCoefficient = static_cast<real>(massDamp);
    if (stiffDamp >= 0.0) bp.material.stiffnessDampingCoefficient = static_cast<real>(stiffDamp);
    massDampUsed = static_cast<double>(bp.material.massDampingCoefficient);
    stiffDampUsed = static_cast<double>(bp.material.stiffnessDampingCoefficient);
    contact(bp.contact);
    actor = sc->CreateSoftActor(bp, e);
    if (e.IsOK() && actor != nullptr && recenter == 0) {
      superdex::RecenteringParams rc;
      rc.useRecentering = false;
      actor->SetRecenteringParams(rc, e);
    }
  }
  if (!e.IsOK() || actor == nullptr) { std::fprintf(stderr, "sdx_deform: body: %s\n", e.ToString().c_str()); return 1; }

  // the rest mesh as SuperDex holds it: the node numbers below are SuperDex's, whatever was handed in
  int const perElem = isRod ? 2 : isShell ? 3 : 4; // nodes an element
  int const perNode = isRod ? 4 : 3;               // degrees of freedom a node: x y z, and a rod's twist
  superdex::MeshDataView const mv = ctx->GetShapeMesh(shape, e);
  if (!e.IsOK() || mv.nodesPerElement != perElem) {
    std::fprintf(stderr, "sdx_deform: rest mesh: %s\n", e.IsOK() ? "unexpected element type" : e.ToString().c_str());
    return 1;
  }
  std::vector<double> const ref(mv.coordinates.begin(), mv.coordinates.end());
  std::vector<int> const conn(mv.connectivity.begin(), mv.connectivity.end());
  size_t const nNodes = ref.size() / 3, nElems = conn.size() / static_cast<size_t>(perElem);
  int const nDofs = actor->GetNumDofs();
  if (nNodes < 2 || nElems < 1 || static_cast<size_t>(nDofs) != static_cast<size_t>(perNode) * nNodes) {
    std::fprintf(stderr, "sdx_deform: %zu nodes do not go with %d degrees of freedom\n", nNodes, nDofs);
    return 1;
  }
  // each node's share of the body's rest mass: an equal part of every element it belongs to
  std::vector<double> share(nNodes, 0.0);
  {
    double whole = 0.0;
    for (size_t el = 0; el < nElems; ++el) {
      int const* const nodes = &conn[el * static_cast<size_t>(perElem)];
      double const m = Measure(perElem, nodes, ref);
      for (int k = 0; k < perElem; ++k) share[static_cast<size_t>(nodes[k])] += m / perElem;
      whole += m;
    }
    for (double& s : share) s /= whole;
  }
  double const mass = static_cast<double>(actor->GetMass(e));
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: mass: %s\n", e.ToString().c_str()); return 1; }

  // where the nodes are, in the world: the rest position plus the displacement SuperDex gives back, both in the
  // body's own frame, moved to the world by the body's transform (a soft body's frame may follow it)
  std::vector<real> dofs(static_cast<size_t>(nDofs), 0_r);
  auto read = [&](std::vector<double>& pos) {
    actor->GetDofValues(superdex::Span<int const>(), superdex::Span<real>(dofs.data(), dofs.size()), e);
    superdex::TransformRT const root = actor->GetRootTransform();
    for (size_t i = 0; i < nNodes; ++i) {
      size_t const d = static_cast<size_t>(perNode) * i;
      superdex::Real3 const own{static_cast<real>(ref[3 * i] + static_cast<double>(dofs[d])),
                                static_cast<real>(ref[3 * i + 1] + static_cast<double>(dofs[d + 1])),
                                static_cast<real>(ref[3 * i + 2] + static_cast<double>(dofs[d + 2]))};
      superdex::Real3 const world = root.TransformPoint(own);
      for (size_t k = 0; k < 3; ++k) pos[3 * i + k] = static_cast<double>(world[k]);
    }
  };
  auto centre = [&](std::vector<double> const& pos, double c[3]) {
    c[0] = c[1] = c[2] = 0.0;
    for (size_t i = 0; i < nNodes; ++i)
      for (size_t k = 0; k < 3; ++k) c[k] += share[i] * pos[3 * i + k];
  };
  std::vector<double> pos0(3 * nNodes, 0.0);
  read(pos0);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: first read: %s\n", e.ToString().c_str()); return 1; }
  double c0[3];
  centre(pos0, c0);

  // the clamp and the node to follow
  size_t track = 0;
  if (info->setup == kHang) {
    // the lowest node; of the lowest ones, the one nearest the vertical line through the centre of mass
    double low = pos0[1];
    for (size_t i = 0; i < nNodes; ++i) low = std::min(low, pos0[3 * i + 1]);
    double best = -1.0;
    for (size_t i = 0; i < nNodes; ++i) {
      if (pos0[3 * i + 1] > low + 1e-6 * len) continue;
      double const dx = pos0[3 * i] - c0[0], dz = pos0[3 * i + 2] - c0[2], d2 = dx * dx + dz * dz;
      if (best < 0.0 || d2 < best - 1e-12 * len * len) { best = d2; track = i; }
    }
  } else if (info->setup == kCantilever) {
    for (size_t i = 0; i < nNodes; ++i)
      if (pos0[3 * i] > pos0[3 * track]) track = i;
  }
  if (clamped && isRod) {
    // the first node is held where it is and the first element's twist with it. A cantilever also holds the
    // second node, which fixes the direction the rod leaves the clamp in
    std::vector<int> bcDof;
    std::vector<real> bcVal;
    int const held = info->setup == kCantilever ? 2 : 1;
    for (int node = 0; node < held; ++node)
      for (int k = 0; k < 3; ++k) {
        bcDof.push_back(4 * node + k);
        bcVal.push_back(static_cast<real>(pos0[static_cast<size_t>(3 * node + k)]));
      }
    bcDof.push_back(3);
    bcVal.push_back(0_r);
    actor->AddBoundaryConditionDofsWorld(superdex::Span<int const>(bcDof.data(), bcDof.size()),
                                         superdex::Span<real const>(bcVal.data(), bcVal.size()), e);
  } else if (clamped) {
    // every node of the top edge (strip) or the top face (bar) is held where it is
    double top = pos0[1];
    for (size_t i = 0; i < nNodes; ++i) top = std::max(top, pos0[3 * i + 1]);
    double const cut = top - 0.25 * len / n;
    mochi::experimental::ConstrainNodesByPosition(
        actor, [cut](int, superdex::Real3 const& x) -> bool { return static_cast<double>(x[1]) > cut; }, e);
  }
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_deform: clamp: %s\n", e.ToString().c_str()); return 1; }
  long const clampedDofs = static_cast<long>(actor->GetBoundaryConditionDofIndices().size());

  FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_deform: cannot write %s\n", argv[1]); return 1; }
  {
    auto put = [&](char const* name, long long value) { std::fprintf(f, " %s %lld", name, value); };
    std::fprintf(f, "DEFORM");
    put("case_id", info->id);
    put("kind", info->kind);
    put("up_axis", 1);
    put("dt_ns", Round(dt * 1e9));
    put("steps", steps);
    put("settle_steps", settleSteps);
    put("integ", integId);
    put("maxiter", maxIter);
    put("g_ums2", Round(g * 1e6));
    put("tilt_urad", Round(tilt * 1e6));
    put("v0_ums", Round(v0 * 1e6));
    put("h0_nm", Round(h0 * 1e9));
    put("mu_ppm", Round(mu * 1e6));
    put("n", n);
    put("nodes", static_cast<long long>(nNodes));
    put("elements", static_cast<long long>(nElems));
    put("clamped_dofs", clampedDofs);
    put("mass_mg", Round(mass * 1e6));
    put("len_nm", Round(len * 1e9));
    put("wid_nm", Round(wid * 1e9));
    put("size_nm", Round(size * 1e9));
    put("lin_mgpm", Round(lin * 1e6));
    put("ea_uN", Round(ea * 1e6));
    put("ei_uNm2", Round(ei * 1e6));
    put("gj_uNm2", Round(gj * 1e6));
    put("rotin_ugm", Round(rotin * 1e9));
    put("mlambda_uNpm", Round(mlambda * 1e6));
    put("mmu_uNpm", Round(mmu * 1e6));
    put("balpha_nNm", Round(balpha * 1e9));
    put("bbeta_nNm", Round(bbeta * 1e9));
    put("rhoa_mgpm2", Round(rhoa * 1e6));
    put("young_Pa", Round(young));
    put("nu_ppm", Round(nu * 1e6));
    put("rho_gpm3", Round(rho * 1e3));
    put("mat", matId);
    put("massdamp_u", Round(massDampUsed * 1e6));
    put("stiffdamp_u", Round(stiffDampUsed * 1e6));
    put("penalty_Papm", Round(static_cast<double>(shown.penaltyCoefficient)));
    put("smooth_nm", Round(static_cast<double>(shown.penaltySmoothingHalfDistance) * 1e9));
    put("thresh_nm", Round(static_cast<double>(shown.penaltyThresholdDefault) * 1e9));
    put("falloff_ums", Round(static_cast<double>(shown.frictionFalloffVel) * 1e6));
    put("ndamp_u", Round(static_cast<double>(shown.normalViscousDampingCoefficient) * 1e6));
    put("visc_u", Round(static_cast<double>(shown.viscousFrictionCoefficient) * 1e6));
    put("track_node", static_cast<long long>(track));
    put("com0_x_nm", Round(c0[0] * 1e9));
    put("com0_y_nm", Round(c0[1] * 1e9));
    put("com0_z_nm", Round(c0[2] * 1e9));
    put("trk0_x_nm", Round(pos0[3 * track] * 1e9));
    put("trk0_y_nm", Round(pos0[3 * track + 1] * 1e9));
    put("trk0_z_nm", Round(pos0[3 * track + 2] * 1e9));
    std::fprintf(f, "\n");
  }

  long nConverged = 0, nStopped = 0, nDiverged = 0;
  std::FILE* const trace = TraceOpen();
  int mostIters = 0;
  std::vector<double> pos(pos0);
  double before[3] = {c0[0], c0[1], c0[2]}; // the centre of mass one step ago
  for (long i = 0; i < steps; ++i) {
    if (i == settleSteps) {
      // the settling is over (or there was none): gravity takes its tilt and the body its speed
      if (settleSteps > 0) gravity(tilt);
      if (v0 != 0.0 && !clamped) {
        superdex::Real3 const own =
            actor->GetRootTransform().TransformDirectionInverse(superdex::Real3{static_cast<real>(v0), 0_r, 0_r});
        std::vector<real> vel(static_cast<size_t>(nDofs), 0_r);
        for (size_t node = 0; node < nNodes; ++node)
          for (size_t k = 0; k < 3; ++k) vel[static_cast<size_t>(perNode) * node + k] = own[k];
        actor->SetNodeVelocitiesLocal(superdex::Span<real const>(vel.data(), vel.size()), e);
        if (!e.IsOK()) {
          std::fprintf(stderr, "sdx_deform: speed: %s\n", e.ToString().c_str());
          std::fclose(f);
          return 1;
        }
      }
    }
    sc->Step(dt);
    superdex::SolverStats st = sc->GetSolverStats();
    TraceStep(trace, i, st);
    if (st.convergenceStatus == superdex::ConvergenceStatus::Converged) ++nConverged;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Stopped) ++nStopped;
    else if (st.convergenceStatus == superdex::ConvergenceStatus::Diverged) ++nDiverged;
    if (st.maxNonLinearIters > mostIters) mostIters = st.maxNonLinearIters;
    read(pos);
    if (!e.IsOK()) {
      std::fprintf(stderr, "sdx_deform: step %ld: %s\n", i, e.ToString().c_str());
      std::fclose(f);
      return 1;
    }
    double c[3];
    centre(pos, c);
    // how far the worst node is from its place in the rest shape; a free body's rest shape goes with its centre
    double shift[3] = {0.0, 0.0, 0.0};
    if (!clamped)
      for (size_t k = 0; k < 3; ++k) shift[k] = c[k] - c0[k];
    double worst = 0.0;
    for (size_t node = 0; node < nNodes; ++node) {
      double d2 = 0.0;
      for (size_t k = 0; k < 3; ++k) {
        double const d = pos[3 * node + k] - pos0[3 * node + k] - shift[k];
        d2 += d * d;
      }
      worst = std::max(worst, d2);
    }
    std::fprintf(f, "%ld %lld %lld %lld %lld %lld %lld %lld %lld %lld %lld\n", i, Round(c[0] * 1e9), Round(c[1] * 1e9),
                 Round(c[2] * 1e9), Round(pos[3 * track] * 1e9), Round(pos[3 * track + 1] * 1e9),
                 Round(pos[3 * track + 2] * 1e9), Round((c[0] - before[0]) / dt * 1e6),
                 Round((c[1] - before[1]) / dt * 1e6), Round((c[2] - before[2]) / dt * 1e6),
                 Round(std::sqrt(worst) * 1e9));
    for (size_t k = 0; k < 3; ++k) before[k] = c[k];
  }
  std::fclose(f);
  std::printf("STATS deform case %s dt %g steps %ld settle_steps %ld nodes %zu elements %zu clamped_dofs %ld mass %g "
              "converged %ld stopped %ld diverged %ld most_iterations %d real_bits %d extra%s\n",
              info->name, dt, steps, settleSteps, nNodes, nElems, clampedDofs, mass, nConverged, nStopped, nDiverged,
              mostIters, static_cast<int>(8 * sizeof(real)), extra.empty() ? " none" : extra.c_str());
  superdex::DestroyContext(ctx);
  return 0;
}
