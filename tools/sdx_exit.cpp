// sdx_exit.cpp -- a SuperDex scene destroyed after the library's own static objects are gone, as in a program that
// loads the library at run time (a plugin, or a Python extension). The program registers its exit handler first and
// only then loads the library with dlopen, so at exit the library's static destructors run before the handler (exit
// handlers run last in, first out). The handler then destroys the scene the documented way (ctx->DestroyScene) and
// the context (DestroyContext).
//
// It plays a cube resting on the ground plane for `steps` steps of 10 ms with the friction 0.35, so that with patch
// C's switches set there are stick anchors when the scene is destroyed, prints one STATS line and returns 0; the
// destruction happens at exit, and the handler writes one line to stderr before and after it.
//
// The library is reached by two names looked up in it (CreateContext, DestroyContext); every other call goes through
// SuperDex's virtual interface or its headers, so the program does not link the library.
//
// usage: sdx_exit <path of libmochi_physics_double> [steps]
#include <dlfcn.h>

#include <superdex_physics.h>

#include <cstdio>
#include <cstdlib>
#include <vector>

using superdex::operator""_r;
using superdex::real;

namespace {
using CreateFn = superdex::Context* (*)(int);
using DestroyFn = void (*)(superdex::Context*);
DestroyFn gDestroy = nullptr;
superdex::Context* gCtx = nullptr;
superdex::Scene* gSc = nullptr;

void DestroyAtExit() {
  if (gCtx == nullptr) return;
  std::fprintf(stderr, "sdx_exit: destroying the scene at exit\n");
  gCtx->DestroyScene(gSc);
  gDestroy(gCtx);
  std::fprintf(stderr, "sdx_exit: destroyed\n");
}
} // namespace

int main(int argc, char** argv) {
  if (argc < 2) {
    std::fprintf(stderr, "usage: sdx_exit <path of libmochi_physics_double> [steps]\n");
    return 2;
  }
  long const steps = argc > 2 ? std::atol(argv[2]) : 10;
  // the exit handler first, then the library
  std::atexit(DestroyAtExit);
  void* const lib = dlopen(argv[1], RTLD_NOW | RTLD_LOCAL);
  if (lib == nullptr) { std::fprintf(stderr, "sdx_exit: %s\n", dlerror()); return 1; }
  auto const create = reinterpret_cast<CreateFn>(dlsym(lib, "_ZN5mochi13CreateContextEi"));
  gDestroy = reinterpret_cast<DestroyFn>(dlsym(lib, "_ZN5mochi14DestroyContextEPNS_7ContextE"));
  if (create == nullptr || gDestroy == nullptr) { std::fprintf(stderr, "sdx_exit: names not found\n"); return 1; }

  superdex::Error e;
  gCtx = create(0);
  gSc = gCtx->CreateScene("exit");
  gSc->SetGravity(superdex::Real3{0_r, -9.8_r, 0_r});
  superdex::RigidActorParams gp;
  gp.name = "ground";
  gp.shape = gCtx->CreatePlaneShape(superdex::Real3{0_r, 1_r, 0_r}, 0_r, e);
  gp.colliderType = superdex::ColliderType::Plane;
  gp.isStatic = true;
  gp.contact.coulombFrictionCoefficient = 0.35_r;
  gSc->CreateRigidActor(gp, e);
  superdex::RigidActorParams bp;
  bp.name = "cube";
  real const H = 0.035_r;
  std::vector<real> const corners = {-H, -H, -H, H, -H, -H, -H, H, -H, H, H, -H, -H, -H, H, H, -H, H, -H, H, H, H, H, H};
  std::vector<int> const tris = {0, 2, 1, 1, 2, 3, 4, 5, 6, 5, 7, 6, 0, 1, 5, 0, 5, 4,
                                 2, 6, 3, 3, 6, 7, 0, 4, 2, 2, 4, 6, 1, 3, 5, 3, 7, 5};
  bp.shape = gCtx->CreateTriMeshShape(corners, tris, e);
  bp.worldFromLocal.SetTranslation(superdex::Real3{0_r, H, 0_r});
  bp.mass = 0.8_r;
  bp.contact.coulombFrictionCoefficient = 0.35_r;
  gSc->CreateRigidActor(bp, e);
  if (!e.IsOK()) { std::fprintf(stderr, "sdx_exit: scene: %s\n", e.ToString().c_str()); return 1; }
  for (long i = 0; i < steps; ++i) gSc->Step(0.01_r);
  std::printf("STATS exit steps %ld real_bits %d\n", steps, static_cast<int>(8 * sizeof(real)));
  std::fflush(stdout);
  return 0;
}
