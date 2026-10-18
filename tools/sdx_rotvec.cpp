// sdx_rotvec.cpp -- the rotation vector of a small rotation, through SuperDex's own quaternion (SuperDex v1.0.0).
// A rotation by an angle a about a unit axis n has the rotation vector a * n, whatever the size of a. The program
// builds SuperDex's quaternion from that vector (Quaternion::FromRotationVector), reads the rotation vector back
// (Quaternion::ToRotationVector), and writes both as whole numbers. Nothing is simulated: this asks one function of
// SuperDex one question with a known answer. SuperDex uses that function wherever a rotation becomes a vector: in
// its rigid rotation constraints, in its articulated bodies and in its time integration.
//
// usage: sdx_rotvec <out.txt> <case> [<case> ...]
//   a case is nx,ny,nz,mantissa,exponent: an axis (the program normalises it) and an angle of mantissa x 10^exponent
//   radians, for example 0,0,1,2.5,-9
// writes <out.txt>: a header line "ROTVEC cases <n> real_bits <b>", then one line a case:
//   "<case> <axis x> <axis y> <axis z> <angle mantissa in thousandths> <angle exponent> <read back x> <read back y>
//    <read back z> <distance>"
//   the axis in millionths; the rotation vector read back in millionths of the angle (so the right answer is the
//   axis); the distance of the vector read back from the right answer, in millionths of the angle
// Exit 0 on success.

#include <superdex_physics.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

using mochi::Quaternion;
using mochi::Real3;
using mochi::real;

static long long Round(double x) { return std::llround(x); }

int main(int argc, char** argv) {
  if (argc < 3) {
    std::fprintf(stderr, "usage: sdx_rotvec <out.txt> nx,ny,nz,mantissa,exponent [...]\n");
    return 2;
  }
  std::FILE* f = std::fopen(argv[1], "w");
  if (f == nullptr) { std::fprintf(stderr, "sdx_rotvec: cannot write %s\n", argv[1]); return 1; }
  std::fprintf(f, "ROTVEC cases %d real_bits %d\n", argc - 2, static_cast<int>(8 * sizeof(real)));
  for (int c = 2; c < argc; ++c) {
    double nx = 0.0, ny = 0.0, nz = 0.0, mant = 0.0;
    int ex = 0;
    if (std::sscanf(argv[c], "%lf,%lf,%lf,%lf,%d", &nx, &ny, &nz, &mant, &ex) != 5) {
      std::fprintf(stderr, "sdx_rotvec: bad case %s\n", argv[c]);
      return 2;
    }
    double const len = std::sqrt(nx * nx + ny * ny + nz * nz);
    if (!(len > 0.0) || !(mant > 0.0)) { std::fprintf(stderr, "sdx_rotvec: bad case %s\n", argv[c]); return 2; }
    nx /= len; ny /= len; nz /= len;
    double const ang = mant * std::pow(10.0, static_cast<double>(ex));
    Real3 const in{static_cast<real>(ang * nx), static_cast<real>(ang * ny), static_cast<real>(ang * nz)};
    Quaternion const q = Quaternion::FromRotationVector(in);
    Real3 const out = q.ToRotationVector();
    double const dx = static_cast<double>(out[0]) - static_cast<double>(in[0]);
    double const dy = static_cast<double>(out[1]) - static_cast<double>(in[1]);
    double const dz = static_cast<double>(out[2]) - static_cast<double>(in[2]);
    double const dist = std::sqrt(dx * dx + dy * dy + dz * dz);
    std::fprintf(f, "%d %lld %lld %lld %lld %d %lld %lld %lld %lld\n", c - 2, Round(nx * 1e6), Round(ny * 1e6), Round(nz * 1e6),
                 Round(mant * 1e3), ex, Round(static_cast<double>(out[0]) / ang * 1e6),
                 Round(static_cast<double>(out[1]) / ang * 1e6), Round(static_cast<double>(out[2]) / ang * 1e6),
                 Round(dist / ang * 1e6));
  }
  std::fclose(f);
  std::printf("STATS rotvec cases %d real_bits %d\n", argc - 2, static_cast<int>(8 * sizeof(real)));
  return 0;
}
