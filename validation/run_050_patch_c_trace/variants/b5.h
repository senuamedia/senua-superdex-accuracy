/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <cstdlib>

#include <concepts>

#include <mochi_core/contact/contact_params.h>
#include <mochi_core/contact/contact_types.h>
#include <mochi_core/geometry/bvh_tree.h>
#include <mochi_core/geometry/geometry_utils.h>
#include <mochi_core/geometry/grid_sdf.h>
#include <mochi_core/geometry/tetrahedral_mesh.h>
#include <mochi_core/geometry/triangular_mesh.h>
#include <mochi_core/linear_algebra/matrix.h>
#include <mochi_core/utils/activations.h>
#include <mochi_core/utils/batch_types.h>
#include <mochi_core/utils/decomposition_utils.h>
#include <mochi_core/utils/differentiability.h>
#include <mochi_core/utils/dynamic_array.h>
#include <mochi_core/utils/eval_params.h>
#include <mochi_core/utils/nd_array_utils.h>
#include <mochi_core/utils/no_copy.h>
#include <mochi_core/utils/profile.h>
#include <mochi_core/utils/spmat_utils.h>
#include <mochi_core/utils/task_scheduler.h>

#include <array>
#include <cmath>
#include <iterator>
#include <limits>
#include <memory>
#include <optional>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

namespace mochi {

/*************************************************************************************************/

// Forward declarations
class BaseMap;

/*
Jacobian of contact points wrt state DoFs. Notation:
- pi: position of each contact point.
- x: state of the actor.
- z: some intermediate state of the actor.
*
Jacobians are represented as dpi/dx = dpi/dz * dz/dx, where dz/dx (aka jacAux) is shared by all
contacts for efficiency. The dpi/dz only store non-zero values, with the corresponding indices
stored in 'inds'. If dz/dx is identity (i.e., there's no intermediate state), then it is not stored
and dpi/dz = dpi/dx. The Jacobians are packed in a single matrix [dp0/dz, dp1/dz, ...].
*
DoF indices can be accessed in two ways:
- Inds(i) returns all affected DoF indices of the i-th contact (always nDoFsInternal entries).
- IndGroups(i) returns the affected DoF indices of the i-th contact in consecutive groups. This is
convenient for assembly operations into sparse matrices. Different contacts may produce different
numbers of groups (e.g. skinned contact where skinning connectivity varies per contact),
so the per-contact group count is tracked separately in _indGroupCounts and IndGroups(i) returns
only the valid prefix of row i.
*
Example (uniform group counts):
- Contact 0 of a soft actor acts on DoFs: 15, 16, 17, 33, 34, 35, 21, 22, 23.
- Contact 1 of a soft actor acts on DoFs: 21, 22, 23, 6, 7, 8, 12, 13, 14.
- _inds = {{15, 16, 17, 33, 34, 35, 21, 22, 23},
           {21, 22, 23,  6,  7,  8, 12, 13, 14}}.
- Inds(0) = {15, 16, 17, 33, 34, 35, 21, 22, 23}.
- Inds(1) = {21, 22, 23,  6,  7,  8, 12, 13, 14}.
- _indGroupCounts = {3, 3}.
- _indGroups = {{{dst=15, src=0, count=3}, {dst=21, src=6, count=3}, {dst=33, src=3, count=3}},
                {{dst= 6, src=3, count=3}, {dst=12, src=6, count=3}, {dst=21, src=0, count=3}}}.
- IndGroups(0) = {{dst=15, src=0, count=3}, {dst=21, src=6, count=3}, {dst=33, src=3, count=3}}.
- IndGroups(1) = {{dst= 6, src=3, count=3}, {dst=12, src=6, count=3}, {dst=21, src=0, count=3}}.
*
Example (variable group counts; e.g. skinned contact with variable connectivity):
- Contact 0 acts on DoFs: 15, 16, 17, 21, 22, 23, 33, 34, 35 — 3 disjoint runs.
- Contact 1 acts on DoFs: 12, 13, 14, 15, 16, 17, 12, 13, 14 — only 2 distinct runs (the 12-14
  triplet is repeated as padding because every row of _inds has nDoFsInternal entries).
- _indGroupCounts = {3, 2}.
- _indGroups storage is rectangular with maxGroups columns; row 1's trailing slot is unused.
- IndGroups(0) returns 3 groups, IndGroups(1) returns 2 — the trailing slot of row 1 is hidden
  by the per-row count.
*/
struct ContactJac {
 private:
  // The ContactJac of a pair of actors is recycled across assemblies until the actors are no longer
  // in contact. For performance reasons, a matrix view to a DynamicArray is used for each resizable
  // matrix whose size may change across assemblies.
  struct Data {
    DynamicArray<int> inds = {};
    DynamicArray<IndexGroup> indGroups = {};
    DynamicArray<int> indGroupCounts = {};
    DynamicArray<real> jac = {};
  };
  Data _data = {};

  // Indices of DoFs, stored as a 2D matrix where the rows span the contacts and the columns span
  // the DoFs for each contact. If all contacts share the same DoFs, then simply store 1 row.
  RowMatrixView<int> _inds;

  // Group indices of consecutive DoFs. Stored as a rectangular row x maxGroups buffer where rows
  // span the contacts and columns span the DoF groups. Different contacts may have different
  // numbers of valid groups, so the per-row valid count is tracked in _data.indGroupCounts and
  // accessed via IndGroups(i). If all contacts share the same DoFs, then simply store 1 row.
  RowMatrixView<IndexGroup> _indGroups;

  // Packed Jacobian storage (3 x (nContacts x nDoFsInternal)). Stored in column-major format, so
  // memory is arranged in blocks per contact. If all contacts share the same Jacobian, then simply
  // store 1 block.
  MatrixView<real, 3> _jac;

  // Auxiliary Jacobian dz/dx (optional), with no ownership. Size nDoFsInternal x nDoFsState if
  // there is an auxiliary Jacobian and empty otherwise.
  MatrixView<real const> _jacAux = {};

 public:
  static constexpr int kDofsPerNode = 3;
  bool groupsInitialized = false;
  bool hasSharedDoFs = false; // if all contacts of the actor share the same DoFs.
  bool hasSharedJacs = false; // if all contacts of the actor share the same Jacobian.
  int nDoFsState = 0; // nnzs per row of dpi/dx
  int nDoFsInternal = 0; // nnzs per row of dpi/dz
  int nContacts = 0;

  ContactJac() = default;
  MOCHI_DECLARE_NO_COPY(ContactJac); // Avoid copies for performance reasons.

  ContactJac(ContactJac&& other) noexcept {
    *this = std::move(other);
  }

  ContactJac& operator=(ContactJac&& other) noexcept {
    _data = std::move(other._data);
    // Matrix views must be reset.
    _inds.Reset(_data.inds.data(), other._inds.Rows(), other._inds.Cols());
    _indGroups.Reset(_data.indGroups.data(), other._indGroups.Rows(), other._indGroups.Cols());
    _jac.Reset(_data.jac.data(), other._jac.Rows(), other._jac.Cols());
    _jacAux.Reset(other._jacAux);
    groupsInitialized = other.groupsInitialized;
    hasSharedDoFs = other.hasSharedDoFs;
    hasSharedJacs = other.hasSharedJacs;
    nDoFsState = other.nDoFsState;
    nDoFsInternal = other.nDoFsInternal;
    nContacts = other.nContacts;
    return *this;
  }

  /// @brief Get the dof indices for a given contact point.
  Span<int const> Inds(int contactIndex) const {
    return _inds.Row(hasSharedDoFs ? 0 : contactIndex).GetConstSpan();
  }

  /// @brief Get the dof indices for a given contact point.
  Span<int> Inds(int contactIndex) {
    return _inds.Row(hasSharedDoFs ? 0 : contactIndex).GetSpan();
  }

  /// @brief Get the dof index groups for a given contact point.
  Span<IndexGroup const> IndGroups(int contactIndex) const {
    int row = hasSharedDoFs ? 0 : contactIndex;
    return {_indGroups.Row(row).Data(), static_cast<size_t>(_data.indGroupCounts[row])};
  }

  /// @brief Get the dof index groups for a given contact point.
  Span<IndexGroup> IndGroups(int contactIndex) {
    int row = hasSharedDoFs ? 0 : contactIndex;
    return {_indGroups.Row(row).Data(), static_cast<size_t>(_data.indGroupCounts[row])};
  }

  /// @brief Get the Jacobian block for a given contact point.
  auto Jac(int i) {
    return _jac.MiddleCols(hasSharedJacs ? 0 : i * nDoFsInternal, nDoFsInternal);
  }

  /// @brief Get the Jacobian block for a given contact point.
  auto Jac(int i) const {
    return _jac.MiddleCols(hasSharedJacs ? 0 : i * nDoFsInternal, nDoFsInternal);
  }

  /// @brief Constant view of the auxiliary Jacobian. Empty if there is no auxiliary Jacobian.
  MatrixView<real const> JacAux() const {
    return _jacAux;
  }

  /// @brief Set the auxiliary Jacobian view.
  void SetJacAuxView(MatrixView<real const> jacAux) {
    MOCHI_ASSERT_VERBOSE(jacAux.Rows() == nDoFsInternal && jacAux.Cols() == nDoFsState);
    _jacAux.Reset(jacAux);
  }

  /// @brief Initialize the sizes of the internal data structures (except for the index groups)
  void
  Resize(bool sharedDoFs, bool sharedJacs, int _nDoFsInternal, int _nDoFsState, int _nContacts) {
    hasSharedDoFs = sharedDoFs;
    hasSharedJacs = sharedJacs;
    nDoFsInternal = _nDoFsInternal;
    nDoFsState = _nDoFsState;
    nContacts = _nContacts;
    // jac has only 1 block if jacs are shared by all contacts
    _data.jac.resize_noinit(3 * (hasSharedJacs ? 1 : nContacts) * nDoFsInternal);
    _jac.Reset(_data.jac.data(), 3, (hasSharedJacs ? 1 : nContacts) * nDoFsInternal);
    // inds has only 1 row if DoFs are shared by all contacts
    _data.inds.resize_noinit((hasSharedDoFs ? 1 : nContacts) * nDoFsState);
    _inds.Reset(_data.inds.data(), hasSharedDoFs ? 1 : nContacts, nDoFsState);
    groupsInitialized = false;
  }

  /// @brief Set to zero all the Jacobian blocks.
  void SetZero() {
    _jac.SetZero();
  }

  /// @brief Initialize the index groups from the indices.
  void CompressIndices();
};

/**
 * @brief Results returned by a contact detection query.
 * @note Reused to avoid repeated memory allocations.
 */
struct ContactDetectionResult {
  // PERFORMANCE: All arrays should contain POD types for fast resize and clear.

  /** @brief Id of the colliding actor's contact sample partition. */
  int collidingPartitionId = 0;

  /**
   * @brief Index of each sample point that contacts the collider.
   * @note May contain an index multiple times if the sample contacts multiple collider features.
   */
  DynamicArray<int> sampleIndices = {};

  /**
   * @brief Position of the contact point in the collider's local space.
   * @note 1-to-1 with sampleIndices.
   */
  DynamicArray<Real3> posColliding = {};

  /**
   * @brief Position of the contact point in the collider's local space at stage start.
   * @note Empty after current-time collision detection; 1-to-1 with sampleIndices after stage-start
   * collision detection.
   */
  DynamicArray<Real3> posCollidingStageStart = {};

  /**
   * @brief Optional: stick anchor of each contact point in the collider's local space (anchored
   * Coulomb friction). Friction acts on the tangential displacement from this anchor instead of
   * the displacement since stage start, so a contact can hold with zero velocity.
   * @note Empty (anchored friction off) or 1-to-1 with sampleIndices.
   */
  DynamicArray<Real3> frictionAnchor = {};

  /**
   * @brief SDF information about each contact point (distance, gradient).
   * @note Each array in the struct is 1-to-1 with sampleIndices.
   * @note sdfInfo.grad is expressed in the collider's local space.
   */
  SdfInfo sdfInfo = {};

  /**
   * @brief Optional: SDF information about each contact point at stage start.
   * @note Either sdfInfoStageStart.Empty() or each array is 1-to-1 with sampleIndices.
   * @note sdfInfoStageStart.grad is expressed in the collider's stage-start local space.
   */
  SdfInfo sdfInfoStageStart = {};

  /**
   * @brief Normal of the colliding sample expressed in the collider's local space.
   * @note Empty after collision detection; 1-to-1 with sampleIndices after initializing collision
   * response.
   * @note Evaluated at TimeStep::Current or TimeStep::StageStart, depending on
   * ExperimentalEvalParams.explicitNormals
   */
  DynamicArray<Real3> normalColliding = {};

  /**
   * @brief Jacobian of the transformation to collider space from world space.
   * @note Size 1 for rigid colliders; 1-to-1 with sampleIndices for deformable colliders.
   */
  DynamicArray<VMatrix3x3r> jacColliderFromWorld = {};

  /**
   * @brief Optional: Jacobian of the transformation to collider space from world space at stage
   * start.
   * @note Empty or: Size 1 for rigid colliders; 1-to-1 with sampleIndices for deformable colliders.
   */
  DynamicArray<VMatrix3x3r> jacColliderFromWorldStageStart = {};

  /**
   * @brief Jacobian wrt DoFs of the transformation to world space from collider space.
   * @note Empty for rigid colliders; 1-to-1 with sampleIndices for deformable colliders.
   */
  DynamicArray<ColliderJacDofs> jacWorldFromDofs = {};

  /** @brief Number of DoFs in the mapping Jacobians. */
  int ndofs = 0;

  /**
   * @brief True if the gradient of the SDF is guaranteed to be unitary.
   * @note Applies to all contact points, since it's a property of the collider.
   */
  bool isSdfGradUnitary = true;

  /**
   * @brief Temporary buffers used during collision culling to store filtered sample points and
   * their indices.
   */
  DynamicArray<Real3> culledPositionsBuffer = {};
  DynamicArray<int> culledIndicesBuffer = {};

  /**
   * @brief Optional: Force per unit area for each contact point.
   * @note Empty or 1-to-1 with sampleIndices.
   * @note Only used if QueryType::ContactPoint was requested by the user.
   * @note Unlike other fields in this struct, force is computed after contact detection. It is
   * stored here for convenience.
   */
  DynamicArray<Real3> forcePerUnitArea = {};

  /**
   * @brief Optional: Integration weight for each contact point on the collider.
   * @note Empty (sentinel meaning all weights = 1) or 1-to-1 with sampleIndices.
   * @note For shell/shell contact, this is the collider node weight; the colliding sample weight is
   * accounted for during standard contact assembly. For other contact types, this is typically left
   * empty (implying weight = 1).
   */
  DynamicArray<real> colliderIntegrationWeights = {};

  /**
   * @brief Optional: Collider feature index for each contact point.
   * @note Empty or 1-to-1 with sampleIndices.
   * @note Currently only populated for shell-type colliders, where each sample index has a
   * corresponding collider node that is the feature being indexed.
   */
  DynamicArray<int> colliderFeatureIndices = {};

  void CheckSizes() const {
#define MOCHI_ASSERT_FULL(var) MOCHI_ASSERT_VERBOSE((var).size() == sampleIndices.size())
#define MOCHI_ASSERT_EMPTY_OR_FULL(var) \
  MOCHI_ASSERT_VERBOSE((var).empty() || ((var).size() == sampleIndices.size()))
#define MOCHI_ASSERT_EMPTY_ONE_OR_FULL(var) \
  MOCHI_ASSERT_VERBOSE(                     \
      (var).empty() || ((var).size() == 1) || ((var).size() == sampleIndices.size()))
    MOCHI_ASSERT_FULL(posColliding);
    MOCHI_ASSERT_EMPTY_OR_FULL(posCollidingStageStart);
    MOCHI_ASSERT_EMPTY_OR_FULL(frictionAnchor);
    MOCHI_ASSERT_FULL(sdfInfo);
    MOCHI_ASSERT_EMPTY_OR_FULL(sdfInfoStageStart);
    MOCHI_ASSERT_EMPTY_OR_FULL(normalColliding);
    MOCHI_ASSERT_EMPTY_ONE_OR_FULL(jacColliderFromWorld);
    MOCHI_ASSERT_EMPTY_ONE_OR_FULL(jacColliderFromWorldStageStart);
    MOCHI_ASSERT_EMPTY_OR_FULL(jacWorldFromDofs);
    MOCHI_ASSERT_EMPTY_OR_FULL(forcePerUnitArea);
    MOCHI_ASSERT_EMPTY_OR_FULL(colliderIntegrationWeights);
    MOCHI_ASSERT_EMPTY_OR_FULL(colliderFeatureIndices);
#undef MOCHI_ASSERT_FULL
#undef MOCHI_ASSERT_EMPTY_OR_FULL
#undef MOCHI_ASSERT_EMPTY_ONE_OR_FULL
  }

  void Clear() {
    CheckSizes();
    sampleIndices.clear();
    posColliding.clear();
    posCollidingStageStart.clear();
    frictionAnchor.clear();
    sdfInfo.clear();
    sdfInfoStageStart.clear();
    normalColliding.clear();
    jacColliderFromWorld.clear();
    jacColliderFromWorldStageStart.clear();
    jacWorldFromDofs.clear();
    culledPositionsBuffer.clear();
    culledIndicesBuffer.clear();
    forcePerUnitArea.clear();
    colliderIntegrationWeights.clear();
    colliderFeatureIndices.clear();
    isSdfGradUnitary = true;
  }

  bool Empty() const {
    CheckSizes();
    return sampleIndices.empty();
  }

  // Uses posColliding, sdfGrad, and distance to compute the approximate location of the
  // corresponding point on the surface of the collider.
  Vec4r GetApproxPosCollider(int i) {
    auto const& sdfGrad = ToSimd(sdfInfo.grad[i]);
    auto norm = isSdfGradUnitary ? sdfGrad : Normalize<3>(sdfGrad);
    return ToSimd(posColliding[i]) - norm * sdfInfo.val[i];
  }
};

/*
  Results from collision response involving a point-collider.
  The data matches the indices in a ContactDetectionResult.
*/
struct CollisionResponseResult : public NoCopy {
  DynamicArray<double> energy = {};
  DynamicArray<Real3> force = {};
  DynamicArray<VMatrix3x3r> dforce = {};

  CollisionResponseResult() = default;

  // A FILO allocator can be used provided (1) all energy, force and dforce allocations and
  // deallocations are performed through member functions (Reserve, ResizeNoInit), and (2) energy,
  // force and dforce are destructed together with the struct (i.e. they are NOT moved to a
  // different data structure).
  CollisionResponseResult(Allocator* allocator)
      : energy(allocator), force(allocator), dforce(allocator) {}

  // Reserve energy, force and dforce for the maximum number of points in any of the active
  // collisions.
  template <typename ActiveCollisions>
  void Reserve(
      ActiveCollisions const& collisions,
      bool reserveEnergy,
      bool reserveForce,
      bool reserveDForce) {
    MOCHI_PROFILE_SCOPE();
    int maxPoints = 0;
    for (auto const& collision : collisions) {
      maxPoints = Max(maxPoints, isize(collision.collisionResult.sampleIndices));
    }
    if (reserveEnergy) {
      energy.reserve(maxPoints);
    }
    if (reserveForce) {
      force.reserve(maxPoints);
    }
    if (reserveDForce) {
      dforce.reserve(maxPoints);
    }
  }

  void ResizeNoInit(int newSize, bool resizeEnergy, bool resizeForce, bool resizeDForce) {
    MOCHI_PROFILE_SCOPE();
    if (resizeEnergy) {
      energy.resize_noinit(newSize);
    }
    if (resizeForce) {
      force.resize_noinit(newSize);
    }
    if (resizeDForce) {
      dforce.resize_noinit(newSize);
    }
  }
};

// Runtime settings that define how contact is evaluated
/**
 * @brief Elastic stick distance [m] for anchored Coulomb friction; 0 disables it.
 * @details Read once from the environment variable SUPERDEX_STICK_DISTANCE. When > 0, a contact
 * sticks to an anchor and friction rises smoothly with the tangential displacement from it,
 * reaching mu*N at this distance; beyond it the anchor is dragged (return mapping) and friction
 * stays at mu*N. This replaces the velocity-regularised smoothing width (frictionFalloffVel * dt),
 * which cannot hold a contact at rest.
 */
inline real FrictionStickDistance() {
  static real const kStick = [] {
    char const* v = std::getenv("SUPERDEX_STICK_DISTANCE");
    return v != nullptr ? static_cast<real>(std::atof(v)) : 0_r;
  }();
  return kStick;
}

/**
 * @brief Contact damping that cannot pull. Off unless the environment variable
 * SUPERDEX_DAMPING_UNILATERAL is set.
 * @details With normal viscous damping on, the normal force of a contact is the penalty force times
 * (1 - c * vn), the penalty part plus the damping part. As shipped that factor is not bounded below,
 * so a body leaving the surface faster than 1 / c is pulled back by it. With this on, the damping
 * part can cancel the penalty part and no more: the normal force never goes below zero.
 */
inline bool ContactDampingUnilateral() {
  static bool const kOn = std::getenv("SUPERDEX_DAMPING_UNILATERAL") != nullptr;
  return kOn;
}

/**
 * @brief Friction on the full normal force. Off unless the environment variable
 * SUPERDEX_FRICTION_FULL_NORMAL is set.
 * @details As shipped, Coulomb and viscous friction are proportional to the penalty part of the normal
 * force alone, so with normal viscous damping on friction is short of the coefficient times the normal
 * force by the damping part. With this on, friction is proportional to the whole normal force.
 */
inline bool FrictionOnFullNormalForce() {
  static bool const kOn = std::getenv("SUPERDEX_FRICTION_FULL_NORMAL") != nullptr;
  return kOn;
}

/**
 * @brief Damped stick for anchored Coulomb friction. Off unless the environment variable
 * SUPERDEX_STICK_DAMPING is set; needs SUPERDEX_STICK_DISTANCE > 0 and frictionFalloffVel > 0.
 * @details Anchored friction acts on u, the tangential offset of a contact from its stick anchor. On its
 * own that is a spring with no loss, and a body that slides to a stop rings on it. With this on, friction
 * acts on u / stickDistance + v / frictionFalloffVel, the anchored offset and the shipped velocity term
 * inside one saturation: at rest it holds as before, while sliding it is mu * N as before, and in between
 * the velocity term is the loss (the bristle damping of the LuGre friction law).
 */
inline bool FrictionStickDamped() {
  static bool const kOn = std::getenv("SUPERDEX_STICK_DAMPING") != nullptr;
  return kOn;
}

/**
 * @brief Whether any of the contact corrections is switched on (see FrictionStickDistance,
 * ContactDampingUnilateral, FrictionOnFullNormalForce). When none is, the shipped kernel runs.
 */
inline bool SenuaContactPatchOn() {
  static bool const kOn =
      FrictionStickDistance() > 0_r || ContactDampingUnilateral() || FrictionOnFullNormalForce();
  return kOn;
}

struct ContactEvalConfig {
  // Project dresidual to PSD
  bool psdDRes = false;

  // Add ContactParams::penaltyExtraPadding to ContactParams::penaltyThresholdDist
  bool addPadding = false;

  // Mark if the colliding normals are valid
  bool validCollidingNormals = true;

  // Treat normals (both collider and colliding) explicitly for the evaluation of alignment and the
  // friction plane. With explicit normals, explicit contact distance is also available; otherwise
  // it must be approximated.
  bool explicitNormals = ExperimentalEvalParams{}.explicitNormals;

  // Fade the friction coefficient based on the alignment of normals. If the colliding actor has
  // invalid normals, a value of true will be ignored.
  bool fadeFriction = ExperimentalEvalParams{}.fadeFriction;

  // Treat the normal contact force implicitly. If it is treated explicitly, the computation is
  // exact if explicitNormals = true, and approximate otherwise.
  bool implicitNormalForceForDissipation =
      ExperimentalEvalParams{}.implicitNormalForceForDissipation;

  // For Coulomb friction, use the Hessian of a fitted quadratic potential. The fitted Hessian is an
  // approximation of the true Hessian. It improves stability but may degrade non-linear
  // convergence.
  bool useFittedHessian = ExperimentalEvalParams{}.fittedSaturationHessian.contactFriction;

  // Selects which Coulomb friction smoothing model to use.
  CoulombFrictionModel frictionModel = ExperimentalEvalParams{}.frictionModel;
};

/*************************************************************************************************/

// Maximum batch size for collision force and dforce computation.
inline constexpr int kCollResponseMaxBatchSize = 8;

template <int kBatchSize>
MOCHI_FORCE_INLINE void ComputeBatchContactPenaltyForceDForce(
    BatchDouble<kBatchSize>& outEnergy,
    BatchReal3<kBatchSize>& outForce,
    BatchReal6<kBatchSize>& outDForce,
    BatchReal<kBatchSize>& outForceNorm,
    BatchReal<kBatchSize> const& d,
    BatchReal3<kBatchSize> const& sdfGrad,
    BatchReal<kBatchSize> const& alignmentMask,
    BatchReal<kBatchSize> const& alignmentFactor,
    ContactParams const& params,
    ContactEvalConfig const& config,
    bool assemEnergy,
    bool assemForce,
    bool assemDForce,
    bool assemForceNorm) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  MOCHI_ASSERT_VERBOSE(
      params.penaltyCoefficient > 0_r && params.penaltySmoothingHalfDistance >= 0_r,
      "Invalid contact params.");

  using V = BatchReal<kBatchSize>;
  using Vd = BatchDouble<kBatchSize>;
  using V3 = BatchReal3<kBatchSize>;

  auto const penaltyCoeff = V{params.penaltyCoefficient};
  auto const penaltyThr = V{params.GetPenaltyThresholdDist(config.addPadding)};
  auto const penaltyFalloff = V{params.penaltySmoothingHalfDistance};

  // Contact penalty
  V penalty MOCHI_NO_INIT;
  V dPenalty MOCHI_NO_INIT;
  V ddPenalty MOCHI_NO_INIT;
  PolyReLU<V>(-d, penaltyFalloff, penaltyFalloff - penaltyThr, penalty, dPenalty, ddPenalty);
  penalty &= alignmentMask; // Ensure no energy, force or dforce
  dPenalty &= alignmentMask; // Ensure no energy, force or dforce
  ddPenalty &= alignmentMask; // Ensure no energy, force or dforce

  // Output energy
  if (assemEnergy) {
    outEnergy = 0.5 * Get0(penaltyCoeff) * Sqr(StaticCast<Vd>(penalty));
  }

  if (assemForce || assemForceNorm) {
    V forceNorm = penaltyCoeff * penalty * dPenalty;

    // Output force
    if (assemForce) {
      outForce = forceNorm * sdfGrad;
    }

    // Output force norm
    if (assemForceNorm) {
      outForceNorm = alignmentFactor * forceNorm;
    }
  }

  // Output dforce
  if (assemDForce) {
    V dForceNorm = -penaltyCoeff * (dPenalty * dPenalty + penalty * ddPenalty);
    MOCHI_ASSERT_VERBOSE(AllTrue(dForceNorm <= 0_r), "dForceNorm must not be positive.");

    V3 auxDForce = dForceNorm * sdfGrad;
    outDForce[0] = auxDForce[0] * sdfGrad[0]; // xx
    outDForce[1] = auxDForce[1] * sdfGrad[1]; // yy
    outDForce[2] = auxDForce[2] * sdfGrad[2]; // zz
    outDForce[3] = auxDForce[0] * sdfGrad[1]; // xy
    outDForce[4] = auxDForce[0] * sdfGrad[2]; // xz
    outDForce[5] = auxDForce[1] * sdfGrad[2]; // yz
  }
}

template <int kBatchSize>
MOCHI_FORCE_INLINE void ComputeBatchContactPenaltyForceNormDForceNorm(
    BatchReal<kBatchSize>& outForceNorm,
    BatchReal<kBatchSize>& outDForceNorm,
    BatchReal<kBatchSize> const& d,
    BatchReal<kBatchSize> const& alignmentMask,
    BatchReal<kBatchSize> const& alignmentFactor,
    ContactParams const& params,
    ContactEvalConfig const& config,
    bool assemDForceNorm) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  MOCHI_ASSERT_VERBOSE(
      params.penaltyCoefficient > 0_r && params.penaltySmoothingHalfDistance >= 0_r,
      "Invalid contact params.");

  using V = BatchReal<kBatchSize>;

  auto const penaltyCoeff = V{params.penaltyCoefficient};
  auto const penaltyThr = V{params.GetPenaltyThresholdDist(config.addPadding)};
  auto const penaltyFalloff = V{params.penaltySmoothingHalfDistance};

  // Contact penalty
  V penalty MOCHI_NO_INIT;
  V dPenalty MOCHI_NO_INIT;
  V ddPenalty MOCHI_NO_INIT;
  PolyReLU<V>(-d, penaltyFalloff, penaltyFalloff - penaltyThr, penalty, dPenalty, ddPenalty);
  penalty &= alignmentMask; // Ensure no energy, force or dforce
  dPenalty &= alignmentMask; // Ensure no energy, force or dforce
  ddPenalty &= alignmentMask; // Ensure no energy, force or dforce

  // Output force norm
  V forceNorm = penaltyCoeff * penalty * dPenalty;
  outForceNorm = alignmentFactor * forceNorm;

  // Output dforce norm
  if (assemDForceNorm) {
    V dForceNorm = -penaltyCoeff * (dPenalty * dPenalty + penalty * ddPenalty);
    MOCHI_ASSERT_VERBOSE(AllTrue(dForceNorm <= 0_r), "dForceNorm must not be positive.");

    outDForceNorm = -alignmentFactor * dForceNorm;
  }
}

// Batch storage of dForce: 6 entries for GradTarget::Current (symmetric) or 9 entries for
// GradTarget::Previous (non-symmetric).
template <int kBatchSize, GradTarget kGradTarget>
using BatchDForce = std::conditional_t<
    kGradTarget == GradTarget::Current,
    BatchReal6<kBatchSize>,
    BatchReal9<kBatchSize>>;

template <int kBatchSize, GradTarget kGradTarget>
MOCHI_FORCE_INLINE void ComputeBatchContactDissipationForceDForce(
    BatchDouble<kBatchSize>& outEnergy,
    BatchReal3<kBatchSize>& outForce,
    BatchDForce<kBatchSize, kGradTarget>& outDForce,
    BatchReal<kBatchSize> const& fPenalty,
    BatchReal<kBatchSize> const& dFPenalty,
    BatchReal3<kBatchSize> const& sdfGrad,
    BatchReal3<kBatchSize> const& nColliding,
    BatchReal3<kBatchSize> const& pRel,
    ContactParams const& params,
    ContactEvalConfig const& config,
    real dtFactor,
    bool assemEnergy,
    bool assemForce,
    bool assemDForce,
    bool isSdfGradUnitary) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  MOCHI_ASSERT_VERBOSE(
      params.coulombFrictionCoefficient >= 0_r && params.viscousFrictionCoefficient >= 0_r &&
          params.normalViscousDampingCoefficient >= 0_r,
      "Invalid dissipation params.");

  using V = BatchReal<kBatchSize>;
  using Vd = BatchDouble<kBatchSize>;
  using V3 = BatchReal3<kBatchSize>;

  // Define the normal for dissipation.
  // If the colliding normal is invalid, override any request to use the colliding normal.
  V3 normal MOCHI_NO_INIT;
  bool const useColliderNormal = params.frictionWithColliderNormal || !config.validCollidingNormals;
  if (useColliderNormal) {
    // Normalize the SDF gradient to get the collider normal direction.
    normal = sdfGrad;
    real constexpr kNormalIsZeroThreshold = 100_r * kDefaultNearEqualEpsilon<real>;
    [[maybe_unused]] real constexpr kNormalIsUnitThreshold = 10_r * kDefaultNearEqualEpsilon<real>;
    if (!isSdfGradUnitary) {
      V norm = Norm(normal);
      normal *= 1_r / norm;

      V isNearZero = norm < kNormalIsZeroThreshold;
      if (AnyTrue(isNearZero))
        MOCHI_UNLIKELY {
          // TODO: Support member-wise Select with NdArray
          if (config.validCollidingNormals) {
            normal[0] = Select(isNearZero, -nColliding[0], normal[0]);
            normal[1] = Select(isNearZero, -nColliding[1], normal[1]);
            normal[2] = Select(isNearZero, -nColliding[2], normal[2]);
          } else {
            normal[0] = Select(isNearZero, V{0_r}, normal[0]);
            normal[1] = Select(isNearZero, V{0_r}, normal[1]);
            normal[2] = Select(isNearZero, V{0_r}, normal[2]);
          }
        }
    }
    MOCHI_ASSERT_VERBOSE(
        (NearEqual<kBatchSize, real, V::kSize, real>(Norm(normal), V{1_r}, kNormalIsUnitThreshold)),
        "Collider normal must be unitary.");
  } else {
    normal = -nColliding;
  }

  // Project the relative displacement
  V const pRelNScalar = Dot(pRel, normal);
  V3 const pRelN = pRelNScalar * normal;
  V3 const pRelT = pRel - pRelN;
  V pRelTNorm = Norm(pRelT);

  // Eigenvalues for dforce accumulation. The dforce matrix can be decomposed as:
  // dforce = eigP * P + eigN * n ⊗ n + eigDeltaT * t ⊗ t
  // where P = I - n ⊗ n is the tangent plane projection matrix.
  V eigP MOCHI_NO_INIT; // Eigenvalue for tangent plane
  V eigN MOCHI_NO_INIT; // Eigenvalue along normal direction
  V eigDeltaT MOCHI_NO_INIT; // Eigenvalue delta along tangent (Coulomb unfitted only)
  V3 tangent MOCHI_NO_INIT; // Unit tangent direction

  // Energy factor. The full dissipation energy can be obtained as contactForce * energyFactor.
  // With GradTarget::Previous, this term is also needed for the gradient, and its derivative for
  // the Hessian.
  Vd energyFactor MOCHI_NO_INIT;
  V3 dEnergyFactor MOCHI_NO_INIT;
  bool const computeEnergyFactor =
      assemEnergy || (kGradTarget == GradTarget::Previous && assemForce);

  // Coulomb friction
  if (params.coulombFrictionCoefficient > 0) {
    real const coulombCoefficient = params.coulombFrictionCoefficient;

    MOCHI_ASSERT_VERBOSE(params.frictionFalloffVel >= 0_r, "Invalid friction falloff velocity.");
    V const falloffFriction = V{params.frictionFalloffVel * dtFactor};

    // Compute friction smoothing function.
    // Note: falloffFriction serves as the transition width `t` for IPC (compact support) and as the
    // regularization parameter `eps` for CinfRegularized (no compact support). Both control the
    // smoothing scale near the stick-slip transition; the semantics differ but the numerical value
    // (frictionFalloffVel * dtFactor) is shared.
    V smoother, dSmoother, ddSmoother, dSmoother_ptNorm;
    switch (config.frictionModel) {
      case CoulombFrictionModel::CinfRegularized:
        CinfRegularized<V>(
            pRelTNorm, falloffFriction, smoother, dSmoother, ddSmoother, dSmoother_ptNorm);
        break;
      case CoulombFrictionModel::C1Regularized:
        IPCstepC1<V>(pRelTNorm, falloffFriction, smoother, dSmoother, ddSmoother, dSmoother_ptNorm);
        break;
      default:
        MOCHI_ASSERT_VERBOSE(false, "Invalid friction model.");
    }

    // Output energy
    if (computeEnergyFactor) {
      energyFactor = static_cast<double>(coulombCoefficient) * StaticCast<Vd>(smoother);
    }

    if (assemForce || assemDForce) {
      V tmp = (coulombCoefficient * fPenalty) * dSmoother_ptNorm;

      // Output force
      if (assemForce) {
        // force = -kC * fN * dSmoother * t
        if constexpr (kGradTarget == GradTarget::Previous) {
          // Flip the sign for GradTarget::Previous
          outForce += tmp * pRelT;
        } else {
          outForce -= tmp * pRelT;
        }
      }

      // Output dforce
      if (assemDForce) {
        // For simplicity, we define alpha = kC * fN
        // dforce = -alpha * dSmoother * dpRelTUnit/dpRelT * P
        //          -alpha  * ddSmoother * t * dpRelTNorm/dpRelT * P
        // With dpRelTUnit/dpRelT = 1/pRelTNorm * (I - t ⊗ t) and dpRelTNorm/dpRelT = tT:
        // dforce = -alpha * dSmoother * 1/pRelTNorm * P * (I - t ⊗ t)
        //          -alpha * ddSmoother * t ⊗ t
        // It is easiest to build dforce through eigen-decomposition on an orthonormal frame
        // {n, t, b = n x t}:
        // dforce = eigT * t ⊗ t + eigB * b ⊗ b
        // eigT = -alpha * ddSmoother, eigB = -alpha * dSmoother / pRelTNorm, eigN = 0.
        // However, for eigT we use the Hessian of a fitted quadratic potential, which performs
        // better globally. Then the term is exactly the same as for eigB.
        // Note the d(fN) term is dropped even if implicitNormalForceForDissipation is true (see
        // rationale above).
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigP must not be positive.");
        eigP = -tmp;
        if (!config.useFittedHessian) {
          V ptMask = (pRelTNorm > 1e-11_r);
          V eigT = ((-coulombCoefficient) * fPenalty) * ddSmoother;
          MOCHI_ASSERT_VERBOSE(AllTrue(eigT <= 0_r), "eigT must not be positive.");
          V ptNormInv = 1_r / (pRelTNorm + std::numeric_limits<real>::min());
          MOCHI_ASSERT_VERBOSE(IsFinite(ptNormInv), "Inverse norm is not finite.");
          tangent = pRelT * ptNormInv;
          eigDeltaT = Select(ptMask, eigT - eigP, V{});
        }

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          dEnergyFactor = coulombCoefficient * dSmoother_ptNorm * pRelT;
        }
      }
    }
  } else {
    if (computeEnergyFactor) {
      energyFactor = {};
    }

    if (assemDForce) {
      eigP = {};
      if constexpr (kGradTarget == GradTarget::Previous) {
        dEnergyFactor = {};
      }
    }
  }

  // Viscous friction
  if (params.viscousFrictionCoefficient > 0) {
    real const viscousCoefficient = params.viscousFrictionCoefficient / dtFactor;

    // Output energy
    if (computeEnergyFactor) {
      energyFactor +=
          0.5 * static_cast<double>(viscousCoefficient) * Sqr(StaticCast<Vd>(pRelTNorm));
    }

    if (assemForce || assemDForce) {
      V tmp = viscousCoefficient * fPenalty;

      // Output force
      if (assemForce) {
        // force = -k * fN * pRelT / dtFactor
        if constexpr (kGradTarget == GradTarget::Previous) {
          // Flip the sign for GradTarget::Previous
          outForce += tmp * pRelT;
        } else {
          outForce -= tmp * pRelT;
        }
      }

      // Output dforce
      if (assemDForce) {
        // dforce = -k * fN / dtFactor * P. The d(fN) term is dropped even if
        // implicitNormalForceForDissipation is true (see rationale above).
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigP must not be positive.");
        eigP -= tmp;

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          dEnergyFactor += viscousCoefficient * pRelT;
        }
      }
    }
  }

  // Normal viscous damping
  // Analogous to tangential viscous friction, but acting in the normal direction and depending on
  // the normal component of velocity. Force is proportional to the elastic normal force and the
  // normal velocity.
  if (params.normalViscousDampingCoefficient > 0) {
    real const normalDampingCoefficient = params.normalViscousDampingCoefficient / dtFactor;

    // Output energy
    if (computeEnergyFactor) {
      energyFactor +=
          0.5 * static_cast<double>(normalDampingCoefficient) * Sqr(StaticCast<Vd>(pRelNScalar));
    }

    if (assemForce || assemDForce) {
      V tmp = normalDampingCoefficient * fPenalty;

      // Output force: force = -coeff * fN * pn / dtFactor (damping in normal direction)
      if (assemForce) {
        if constexpr (kGradTarget == GradTarget::Previous) {
          outForce += tmp * pRelN;
        } else {
          outForce -= tmp * pRelN;
        }
      }

      // Output dforce: The full derivative of the damping force includes both the derivative
      // with respect to the normal velocity and the derivative of the normal force.
      // force_damping = -coeff * fN * pRelN
      // dforce = -coeff * fN * (n ⊗ n)
      // As in viscous friction, the derivative of fN is dropped, even when fN is implicit.
      if (assemDForce) {
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigN must not be positive.");
        eigN = -tmp;

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          dEnergyFactor += normalDampingCoefficient * pRelN;
        }
      }
    }
  } else {
    if (assemDForce) {
      eigN = {};
    }
  }

  // Write accumulated eigenvalues to dforce.
  if (assemDForce) {
    if constexpr (kGradTarget == GradTarget::Previous) {
      // Flip the sign of the eigenvalues
      eigP = -eigP;
      eigN = -eigN;
    }
    V eigDeltaN = eigN - eigP;
    V3 auxN = eigDeltaN * normal;
    outDForce[0] += eigP + auxN[0] * normal[0]; // xx
    outDForce[1] += eigP + auxN[1] * normal[1]; // yy
    outDForce[2] += eigP + auxN[2] * normal[2]; // zz
    outDForce[3] += auxN[0] * normal[1]; // xy
    outDForce[4] += auxN[0] * normal[2]; // xz
    outDForce[5] += auxN[1] * normal[2]; // yz
    if constexpr (kGradTarget == GradTarget::Previous) {
      outDForce[6] += auxN[0] * normal[1]; // yx
      outDForce[7] += auxN[0] * normal[2]; // zx
      outDForce[8] += auxN[1] * normal[2]; // zy
    }

    // Extra pass for tangent contribution (Coulomb unfitted only)
    if (!config.useFittedHessian && (params.coulombFrictionCoefficient > 0)) {
      if constexpr (kGradTarget == GradTarget::Previous) {
        // Flip the sign of the eigenvalues
        eigDeltaT = -eigDeltaT;
      }
      V3 auxT = eigDeltaT * tangent;
      outDForce[0] += auxT[0] * tangent[0];
      outDForce[1] += auxT[1] * tangent[1];
      outDForce[2] += auxT[2] * tangent[2];
      outDForce[3] += auxT[0] * tangent[1];
      outDForce[4] += auxT[0] * tangent[2];
      outDForce[5] += auxT[1] * tangent[2];
      if constexpr (kGradTarget == GradTarget::Previous) {
        outDForce[6] += auxT[0] * tangent[1];
        outDForce[7] += auxT[0] * tangent[2];
        outDForce[8] += auxT[1] * tangent[2];
      }
    }
  }

  // Output energy. Add to current value.
  if (assemEnergy) {
    outEnergy += StaticCast<Vd>(fPenalty) * energyFactor;
  }

  // Add Previous-target terms from differentiating the explicit stage-start penalty force.
  if constexpr (kGradTarget == GradTarget::Previous) {
    // sdfGrad stores the appropriate gradient of the SDF (explicit or implicit).
    if (assemForce) {
      V const dFPenaltyTimesEnergyFactor = dFPenalty * StaticCast<V>(energyFactor);
      outForce += dFPenaltyTimesEnergyFactor * sdfGrad;
    }
    if (assemDForce) {
      V3 const row0 = dFPenalty * dEnergyFactor[0] * sdfGrad;
      V3 const row1 = dFPenalty * dEnergyFactor[1] * sdfGrad;
      V3 const row2 = dFPenalty * dEnergyFactor[2] * sdfGrad;
      outDForce[0] += row0[0]; // xx
      outDForce[1] += row1[1]; // yy
      outDForce[2] += row2[2]; // zz
      outDForce[3] += row0[1]; // xy
      outDForce[4] += row0[2]; // xz
      outDForce[5] += row1[2]; // yz
      outDForce[6] += row1[0]; // yx
      outDForce[7] += row2[0]; // zx
      outDForce[8] += row2[1]; // zy
    }
  }
}

/**
 * @brief Compute collision response (energy, force, and force derivative) for a batch of contact
 * points.
 *
 * @details Processes a batch of contacts using SIMD operations to compute penalty-based collision
 * response. Supports penalty forces with optional Coulomb friction, viscous friction, and
 * normal collision damping. All quantities are expressed in the collider's local space.
 *
 * @tparam kBatchSize Number of contact points to process (must be <= @ref
 * kCollResponseMaxBatchSize)
 * @tparam kGradTarget Indicates whether the energy gradient is for the current state (i.e. the
 * force) or the previous state
 *
 * @param[out] outEnergy Output collision energies (size kBatchSize, written if assemEnergy)
 * @param[out] outForce Output collision forces (size kBatchSize, written if assemForce)
 * @param[out] outDForce Output collision force derivatives (size kBatchSize, written if
 * assemDForce)
 * @param[in] distance Signed distances at contact points (negative = penetration)
 * @param[in] distanceGrad Gradient of signed distance at current state
 * @param[in] distanceStageStart Signed distances at stage start (used only with explicit normals)
 * @param[in] distanceGradStageStart Gradient of signed distance at stage start (used only with
 * explicit normals)
 * @param[in] normalColliding Surface normals of the colliding body at the contact points (used only
 * with valid colliding normals)
 * @param[in] posColliding Current positions of contact points
 * @param[in] posCollidingStageStart Positions of contact points at stage start
 * @param[in] params Contact parameters (penalty coefficient, friction, damping, etc.)
 * @param[in] config Contact evaluation configuration (explicit normals, padding, etc.)
 * @param[in] dtFactor Time step factor (time step multiplied by a factor depending on the
 * integration method)
 * @param[in] assemEnergy Whether to compute and output energies
 * @param[in] assemForce Whether to compute and output forces
 * @param[in] assemDForce Whether to compute and output force derivatives
 * @param[in] isSdfGradUnitary Whether the SDF gradient is already unit length
 */
template <int kBatchSize, GradTarget kGradTarget>
// TODO[T247578555]: This is a workaround for a bug in VS2022, but it will hurt performance.
// A better solution is needed.
#if MOCHI_COMPILER_MSVC
MOCHI_NO_INLINE
#else
MOCHI_FORCE_INLINE
#endif
    void ComputeBatchCollisionForceDForce(
        Span<double> outEnergy,
        Span<Real3> outForce,
        Span<VMatrix3x3r> outDForce,
        Span<real const> distance,
        Span<Real3 const> distanceGrad,
        Span<real const> distanceStageStart,
        Span<Real3 const> distanceGradStageStart,
        Span<Real3 const> normalColliding,
        Span<Real3 const> posColliding,
        Span<Real3 const> posCollidingStageStart,
        ContactParams const& params,
        ContactEvalConfig const& config,
        real dtFactor,
        bool assemEnergy,
        bool assemForce,
        bool assemDForce,
        bool isSdfGradUnitary) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  static_assert(
      kGradTarget == GradTarget::Current || kGradTarget == GradTarget::Previous,
      "Contact assembly should be called only for GradTarget::Current or GradTarget::Previous");

  MOCHI_ASSERT_VERBOSE(!assemEnergy || (outEnergy.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(!assemForce || (outForce.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(!assemDForce || (outDForce.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(
      distance.size() == kBatchSize && distanceGrad.size() == kBatchSize &&
      posColliding.size() == kBatchSize && posCollidingStageStart.size() == kBatchSize);
  MOCHI_ASSERT_VERBOSE(!config.validCollidingNormals || normalColliding.size() == kBatchSize);
  MOCHI_ASSERT_VERBOSE(
      !config.explicitNormals ||
      (distanceStageStart.size() == kBatchSize && distanceGradStageStart.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(
      params.penaltyCoefficient > 0_r && params.penaltySmoothingHalfDistance >= 0_r,
      "Invalid contact params.");
  MOCHI_ASSERT_VERBOSE(
      params.maxAlignmentNormals >= -1_r && params.maxAlignmentNormals <= 1_r,
      "maxAlignmentNormals must be in [-1, 1].");

  // Forbid unsupported combinations
  MOCHI_ASSERT_VERBOSE(
      !(config.implicitNormalForceForDissipation && config.explicitNormals),
      "implicitNormalForceForDissipation = true with explicitNormals = true is not supported.");
  MOCHI_ASSERT_VERBOSE(
      kGradTarget == GradTarget::Current ||
          (!config.implicitNormalForceForDissipation && config.explicitNormals),
      "GradTarget::Previous requires implicitNormalForceForDissipation = false and explicitNormals = true.");

  using V = BatchReal<kBatchSize>;
  using Vd = BatchDouble<kBatchSize>;
  using V3 = BatchReal3<kBatchSize>;

  // Create SIMD locals for outputs
  Vd energy MOCHI_NO_INIT;
  V3 force MOCHI_NO_INIT;
  BatchDForce<kBatchSize, kGradTarget> dForce MOCHI_NO_INIT;
  V fPenalty MOCHI_NO_INIT;
  V dFPenalty MOCHI_NO_INIT;

  // Load input distance and distance gradient
  V const d = Load<kBatchSize, V>(&distance[0]);

  V3 sdfGrad MOCHI_NO_INIT;
  LoadTransposed<kBatchSize>(&distanceGrad[0][0], sdfGrad);

  // Load collider normal, explicit or implicit
  V3 nCollider = sdfGrad;
  if (config.explicitNormals) {
    LoadTransposed<kBatchSize>(&distanceGradStageStart[0][0], nCollider);
  }

  // Load colliding normals if valid
  V3 nColliding MOCHI_NO_INIT;
  if (config.validCollidingNormals) {
    LoadTransposed<kBatchSize>(&normalColliding[0][0], nColliding);
  }

  // Normally, the gradient of signed distance (nCollider) points in the opposite direction of the
  // surface normal at the sample point (nColliding). If they point in the same direction, then it
  // means that the contact force would be pulling the object apart instead of compressing the
  // object. That happens when one collider gets embedded within another one. The contact energy
  // would normally trap the collider preventing it from escaping. We prevent that contact energy to
  // allow it to escape.
  V const alignmentNormals = config.validCollidingNormals ? Dot(nCollider, nColliding) : V{-1_r};
  V const maxAlignment = V{params.maxAlignmentNormals};
  V const alignmentMask = alignmentNormals <= maxAlignment;
  // maxAlignmentNormals == -1 leaves no nonzero fade interval. Use an unfaded factor instead of
  // evaluating the degenerate endpoint formula.
  bool const useAlignmentFading =
      config.fadeFriction && config.validCollidingNormals && params.maxAlignmentNormals > -1_r;
  // Compute alignment fading for dissipation
  V const alignmentFactor =
      useAlignmentFading ? (maxAlignment - alignmentNormals) / (maxAlignment + 1_r) : V{1_r};

  // Compute penalty force with current data.
  bool constexpr kAssemPenalty =
      IsAssemblyNeeded(StateDependency::ZeroOrder, false /*inputDependency*/, kGradTarget);
  bool const hasDissipation = params.coulombFrictionCoefficient > 0_r ||
      params.viscousFrictionCoefficient > 0_r || params.normalViscousDampingCoefficient > 0_r;
  bool const useImplicitNormalForceForDissipation =
      config.implicitNormalForceForDissipation && hasDissipation;
  if constexpr (kAssemPenalty) {
    ComputeBatchContactPenaltyForceDForce<kBatchSize>(
        energy,
        force,
        dForce,
        fPenalty,
        d,
        sdfGrad,
        alignmentMask,
        alignmentFactor,
        params,
        config,
        assemEnergy,
        assemForce,
        assemDForce,
        useImplicitNormalForceForDissipation);
  } else {
    // Ensure containers are initialized for GradTarget::Previous
    if (assemEnergy) {
      energy = {};
    }
    if (assemForce) {
      force = {};
    }
    if (assemDForce) {
      dForce = {};
    }
  }

  // Compute dissipation force.
  if (hasDissipation) {
    // Load positions and compute relative displacement
    V3 pColliding MOCHI_NO_INIT;
    LoadTransposed<kBatchSize>(&posColliding[0][0], pColliding);

    V3 pCollidingStageStart MOCHI_NO_INIT;
    LoadTransposed<kBatchSize>(&posCollidingStageStart[0][0], pCollidingStageStart);

    V3 const pRel = pColliding - pCollidingStageStart;

    // Compute penalty force with stage-start data.
    if (!useImplicitNormalForceForDissipation) {
      // Distance for penalty force computation (stage-start data)
      V dStageStart MOCHI_NO_INIT;

      if (config.explicitNormals) {
        // Use stage-start distance
        dStageStart = Load<kBatchSize, V>(&distanceStageStart[0]);
      } else {
        // Estimate stage-start distance using current gradient.
        dStageStart = d - Dot(sdfGrad, pRel);
      }

      // We need dForceNorm for GradTarget::Previous force or dforce.
      bool const assemDForceNorm =
          kGradTarget == GradTarget::Previous && (assemForce || assemDForce);
      ComputeBatchContactPenaltyForceNormDForceNorm<kBatchSize>(
          fPenalty,
          dFPenalty,
          dStageStart,
          alignmentMask,
          alignmentFactor,
          params,
          config,
          assemDForceNorm);
    }

    ComputeBatchContactDissipationForceDForce<kBatchSize, kGradTarget>(
        energy,
        force,
        dForce,
        fPenalty,
        dFPenalty,
        nCollider,
        nColliding,
        pRel,
        params,
        config,
        dtFactor,
        assemEnergy,
        assemForce,
        assemDForce,
        isSdfGradUnitary);
  }

  // Store outputs to Spans
  if (assemEnergy) {
    Store<kBatchSize>(outEnergy.data(), energy);
  }

  if (assemForce) {
    StoreTransposed<kBatchSize>(&outForce[0][0], force);
  }

  if (assemDForce) {
    // TODO: outDForce should be either:
    //   1. Nine dense arrays of real, in which case this loop would be 9 vector Stores.
    //   2. A dense array of Matrix3x3, in which case this loop would still be needed.
    for (int i = 0; i < kBatchSize; ++i) {
      if constexpr (kGradTarget == GradTarget::Current) {
        // outDForce is symmetric and stored in a 6-value array.
        outDForce[i] = VMatrix3x3r{
            Vec4r{dForce[0][i], dForce[3][i], dForce[4][i]}, // xx, xy, xz
            Vec4r{dForce[3][i], dForce[1][i], dForce[5][i]}, // xy, yy, yz
            Vec4r{dForce[4][i], dForce[5][i], dForce[2][i]}}; // xz, yz, zz
      } else {
        // outDForce is asymmetric and stored in a 9-value array.
        outDForce[i] = VMatrix3x3r{
            Vec4r{dForce[0][i], dForce[3][i], dForce[4][i]}, // xx, xy, xz
            Vec4r{dForce[6][i], dForce[1][i], dForce[5][i]}, // yx, yy, yz
            Vec4r{dForce[7][i], dForce[8][i], dForce[2][i]}}; // zx, zy, zz
      }
    }
    // NOTE: outDForce is expected to be PSD. If it is not, a projection onto the PSD cone must be
    // added here.
  }
}

/*************************************************************************************************/
// The patched contact kernel. It is a copy of the two functions above with three corrections, each
// off unless its environment variable is set (FrictionStickDistance, ContactDampingUnilateral,
// FrictionOnFullNormalForce). The functions above are exactly as shipped, and the library calls
// these copies only when a switch is set (see ComputeCollisionResponseRange), so with no switch
// set the shipped code path is the one that runs.

template <int kBatchSize, GradTarget kGradTarget>
MOCHI_FORCE_INLINE void ComputeBatchContactDissipationForceDForceSenua(
    BatchDouble<kBatchSize>& outEnergy,
    BatchReal3<kBatchSize>& outForce,
    BatchDForce<kBatchSize, kGradTarget>& outDForce,
    BatchReal<kBatchSize> const& fPenalty,
    BatchReal<kBatchSize> const& dFPenalty,
    BatchReal3<kBatchSize> const& sdfGrad,
    BatchReal3<kBatchSize> const& nColliding,
    BatchReal3<kBatchSize> const& pRel,
    ContactParams const& params,
    ContactEvalConfig const& config,
    real dtFactor,
    bool assemEnergy,
    bool assemForce,
    bool assemDForce,
    bool isSdfGradUnitary,
    BatchReal<kBatchSize> const& fPenaltyNow,
    BatchReal<kBatchSize> const& dFPenaltyNow,
    BatchReal3<kBatchSize> const& pRelStep) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  MOCHI_ASSERT_VERBOSE(
      params.coulombFrictionCoefficient >= 0_r && params.viscousFrictionCoefficient >= 0_r &&
          params.normalViscousDampingCoefficient >= 0_r,
      "Invalid dissipation params.");

  using V = BatchReal<kBatchSize>;
  using Vd = BatchDouble<kBatchSize>;
  using V3 = BatchReal3<kBatchSize>;

  // Define the normal for dissipation.
  // If the colliding normal is invalid, override any request to use the colliding normal.
  V3 normal MOCHI_NO_INIT;
  bool const useColliderNormal = params.frictionWithColliderNormal || !config.validCollidingNormals;
  if (useColliderNormal) {
    // Normalize the SDF gradient to get the collider normal direction.
    normal = sdfGrad;
    real constexpr kNormalIsZeroThreshold = 100_r * kDefaultNearEqualEpsilon<real>;
    [[maybe_unused]] real constexpr kNormalIsUnitThreshold = 10_r * kDefaultNearEqualEpsilon<real>;
    if (!isSdfGradUnitary) {
      V norm = Norm(normal);
      normal *= 1_r / norm;

      V isNearZero = norm < kNormalIsZeroThreshold;
      if (AnyTrue(isNearZero))
        MOCHI_UNLIKELY {
          // TODO: Support member-wise Select with NdArray
          if (config.validCollidingNormals) {
            normal[0] = Select(isNearZero, -nColliding[0], normal[0]);
            normal[1] = Select(isNearZero, -nColliding[1], normal[1]);
            normal[2] = Select(isNearZero, -nColliding[2], normal[2]);
          } else {
            normal[0] = Select(isNearZero, V{0_r}, normal[0]);
            normal[1] = Select(isNearZero, V{0_r}, normal[1]);
            normal[2] = Select(isNearZero, V{0_r}, normal[2]);
          }
        }
    }
    MOCHI_ASSERT_VERBOSE(
        (NearEqual<kBatchSize, real, V::kSize, real>(Norm(normal), V{1_r}, kNormalIsUnitThreshold)),
        "Collider normal must be unitary.");
  } else {
    normal = -nColliding;
  }

  // Project the relative displacement
  V const pRelNScalar = Dot(pRel, normal);
  V3 const pRelN = pRelNScalar * normal;
  V3 const pRelT = pRel - pRelN;
  V pRelTNorm = Norm(pRelT);

  // The step's own tangential displacement. With anchored friction pRel is the offset from the stick
  // anchor, and viscous friction must still act on the velocity.
  V3 const pStepT = pRelStep - Dot(pRelStep, normal) * normal;
  V const pStepTNorm = Norm(pStepT);
  // Damped stick (see FrictionStickDamped): Coulomb friction acts on the anchored offset plus the step's
  // displacement scaled to the stick distance. Its derivative gains the factor 1 + stickRate and its
  // energy loses it.
  real const stickFalloffStep = params.frictionFalloffVel * dtFactor;
  real const stickRate =
      (FrictionStickDamped() && FrictionStickDistance() > 0_r && stickFalloffStep > 0_r)
          ? FrictionStickDistance() / stickFalloffStep
          : 0_r;
  real const stickHessScale = 1_r + stickRate;
  V3 pFricT = pRelT;
  V pFricTNorm = pRelTNorm;
  if (stickRate > 0_r) {
    pFricT = pRelT + stickRate * pStepT;
    pFricTNorm = Norm(pFricT);
  }

  // Contact damping that cannot pull, and friction on the full normal force (both off unless their
  // environment variables are set; see ContactDampingUnilateral and FrictionOnFullNormalForce).
  bool const hasNormalDamping = params.normalViscousDampingCoefficient > 0_r;
  bool const unilateralDamping = hasNormalDamping && ContactDampingUnilateral();
  bool const fullNormalFriction = hasNormalDamping && FrictionOnFullNormalForce();
  V pRelNClamp = pRelNScalar; // the normal displacement the damping force acts on
  V dampActive = V{}; // lanes where the damping is not at its bound
  V dampScale = V{1_r}; // the whole normal force over its penalty part, never below zero
  if (unilateralDamping || fullNormalFriction) {
    // The normal displacement over the step at which the damping part cancels the penalty force of the step
    // being solved. The damping part is built on fPenalty, which is the force at the start of the step unless
    // the implicit setting is on, so the bound is scaled by the ratio of the two forces.
    real const dampLimitBase = dtFactor / params.normalViscousDampingCoefficient;
    V const hasForce = fPenalty > 0_r;
    V const forceRatio = Select(hasForce, fPenaltyNow / Select(hasForce, fPenalty, V{1_r}), V{1_r});
    V const dampLimit = dampLimitBase * forceRatio;
    dampActive = pRelNScalar < dampLimit;
    V const clamped = Select(dampActive, pRelNScalar, dampLimit);
    if (unilateralDamping) {
      pRelNClamp = clamped;
    }
    // For friction: the whole normal force over its penalty part, both taken as friction takes the penalty
    // part (the start of the step unless the implicit setting is on), and never below zero.
    dampScale =
        Max(V{0_r}, V{1_r} - V{params.normalViscousDampingCoefficient / dtFactor} * pRelNScalar);
  }
  V const fFriction = fullNormalFriction ? fPenalty * dampScale : fPenalty;
  V3 const pRelNDamp = unilateralDamping ? pRelNClamp * normal : pRelN;

  // Eigenvalues for dforce accumulation. The dforce matrix can be decomposed as:
  // dforce = eigP * P + eigN * n ⊗ n + eigDeltaT * t ⊗ t
  // where P = I - n ⊗ n is the tangent plane projection matrix.
  V eigP MOCHI_NO_INIT; // Eigenvalue for tangent plane
  V eigN MOCHI_NO_INIT; // Eigenvalue along normal direction
  V eigDeltaT MOCHI_NO_INIT; // Eigenvalue delta along tangent (Coulomb unfitted only)
  V3 tangent MOCHI_NO_INIT; // Unit tangent direction

  // Energy factor. The full dissipation energy can be obtained as contactForce * energyFactor.
  // With GradTarget::Previous, this term is also needed for the gradient, and its derivative for
  // the Hessian.
  Vd energyFactor MOCHI_NO_INIT;
  V3 dEnergyFactor MOCHI_NO_INIT;
  bool const computeEnergyFactor =
      assemEnergy || (kGradTarget == GradTarget::Previous && assemForce);

  // Coulomb friction
  if (params.coulombFrictionCoefficient > 0) {
    real const coulombCoefficient = params.coulombFrictionCoefficient;

    MOCHI_ASSERT_VERBOSE(params.frictionFalloffVel >= 0_r, "Invalid friction falloff velocity.");
    real const stickDistance = FrictionStickDistance();
    V const falloffFriction =
        V{stickDistance > 0_r ? stickDistance : params.frictionFalloffVel * dtFactor};

    // Compute friction smoothing function.
    // Note: falloffFriction serves as the transition width `t` for IPC (compact support) and as the
    // regularization parameter `eps` for CinfRegularized (no compact support). Both control the
    // smoothing scale near the stick-slip transition; the semantics differ but the numerical value
    // (frictionFalloffVel * dtFactor) is shared.
    V smoother, dSmoother, ddSmoother, dSmoother_ptNorm;
    switch (config.frictionModel) {
      case CoulombFrictionModel::CinfRegularized:
        CinfRegularized<V>(
            pFricTNorm, falloffFriction, smoother, dSmoother, ddSmoother, dSmoother_ptNorm);
        break;
      case CoulombFrictionModel::C1Regularized:
        IPCstepC1<V>(pFricTNorm, falloffFriction, smoother, dSmoother, ddSmoother, dSmoother_ptNorm);
        break;
      default:
        MOCHI_ASSERT_VERBOSE(false, "Invalid friction model.");
    }

    // Output energy
    if (computeEnergyFactor) {
      energyFactor = static_cast<double>(coulombCoefficient) * StaticCast<Vd>(smoother);
      if (fullNormalFriction) {
        energyFactor = energyFactor * StaticCast<Vd>(dampScale);
      }
      if (stickRate > 0_r) {
        energyFactor = energyFactor * (1.0 / static_cast<double>(stickHessScale));
      }
    }

    if (assemForce || assemDForce) {
      V tmp = (coulombCoefficient * fFriction) * dSmoother_ptNorm;

      // Output force
      if (assemForce) {
        // force = -kC * fN * dSmoother * t
        if constexpr (kGradTarget == GradTarget::Previous) {
          // Flip the sign for GradTarget::Previous
          outForce += tmp * pFricT;
        } else {
          outForce -= tmp * pFricT;
        }
      }

      // Output dforce
      if (assemDForce) {
        // For simplicity, we define alpha = kC * fN
        // dforce = -alpha * dSmoother * dpRelTUnit/dpRelT * P
        //          -alpha  * ddSmoother * t * dpRelTNorm/dpRelT * P
        // With dpRelTUnit/dpRelT = 1/pFricTNorm * (I - t ⊗ t) and dpRelTNorm/dpRelT = tT:
        // dforce = -alpha * dSmoother * 1/pFricTNorm * P * (I - t ⊗ t)
        //          -alpha * ddSmoother * t ⊗ t
        // It is easiest to build dforce through eigen-decomposition on an orthonormal frame
        // {n, t, b = n x t}:
        // dforce = eigT * t ⊗ t + eigB * b ⊗ b
        // eigT = -alpha * ddSmoother, eigB = -alpha * dSmoother / pFricTNorm, eigN = 0.
        // However, for eigT we use the Hessian of a fitted quadratic potential, which performs
        // better globally. Then the term is exactly the same as for eigB.
        // Note the d(fN) term is dropped even if implicitNormalForceForDissipation is true (see
        // rationale above).
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigP must not be positive.");
        eigP = -tmp;
        if (stickRate > 0_r) {
          eigP = stickHessScale * eigP;
        }
        // Anchored friction needs the exact Hessian: the fitted (secant) one acts as an extra brake
        // once friction saturates, delaying breakaway beyond mu*N.
        if (!config.useFittedHessian || FrictionStickDistance() > 0_r) {
          V ptMask = (pFricTNorm > 1e-11_r);
          V eigT = ((-coulombCoefficient) * fFriction) * ddSmoother;
          if (stickRate > 0_r) {
            eigT = stickHessScale * eigT;
          }
          MOCHI_ASSERT_VERBOSE(AllTrue(eigT <= 0_r), "eigT must not be positive.");
          V ptNormInv = 1_r / (pFricTNorm + std::numeric_limits<real>::min());
          MOCHI_ASSERT_VERBOSE(IsFinite(ptNormInv), "Inverse norm is not finite.");
          tangent = pFricT * ptNormInv;
          eigDeltaT = Select(ptMask, eigT - eigP, V{});
        }

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          dEnergyFactor = coulombCoefficient * dSmoother_ptNorm * pFricT;
          if (fullNormalFriction) {
            dEnergyFactor = dampScale * dEnergyFactor;
          }
        }
      }
    }
  } else {
    if (computeEnergyFactor) {
      energyFactor = {};
    }

    if (assemDForce) {
      eigP = {};
      if constexpr (kGradTarget == GradTarget::Previous) {
        dEnergyFactor = {};
      }
    }
  }

  // Viscous friction
  if (params.viscousFrictionCoefficient > 0) {
    real const viscousCoefficient = params.viscousFrictionCoefficient / dtFactor;

    // Output energy
    if (computeEnergyFactor) {
      Vd viscousEnergy =
          0.5 * static_cast<double>(viscousCoefficient) * Sqr(StaticCast<Vd>(pStepTNorm));
      if (fullNormalFriction) {
        viscousEnergy = viscousEnergy * StaticCast<Vd>(dampScale);
      }
      energyFactor += viscousEnergy;
    }

    if (assemForce || assemDForce) {
      V tmp = viscousCoefficient * fFriction;

      // Output force
      if (assemForce) {
        // force = -k * fN * pStepT / dtFactor
        if constexpr (kGradTarget == GradTarget::Previous) {
          // Flip the sign for GradTarget::Previous
          outForce += tmp * pStepT;
        } else {
          outForce -= tmp * pStepT;
        }
      }

      // Output dforce
      if (assemDForce) {
        // dforce = -k * fN / dtFactor * P. The d(fN) term is dropped even if
        // implicitNormalForceForDissipation is true (see rationale above).
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigP must not be positive.");
        eigP -= tmp;

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          V3 dViscous = viscousCoefficient * pStepT;
          if (fullNormalFriction) {
            dViscous = dampScale * dViscous;
          }
          dEnergyFactor += dViscous;
        }
      }
    }
  }

  // Normal viscous damping
  // Analogous to tangential viscous friction, but acting in the normal direction and depending on
  // the normal component of velocity. Force is proportional to the elastic normal force and the
  // normal velocity.
  if (params.normalViscousDampingCoefficient > 0) {
    real const normalDampingCoefficient = params.normalViscousDampingCoefficient / dtFactor;

    // Output energy
    if (computeEnergyFactor) {
      if (unilateralDamping) {
        // The damping energy, continued in a straight line beyond the bound so that its slope stays there.
        Vd const pc = StaticCast<Vd>(pRelNClamp);
        Vd const pn = StaticCast<Vd>(pRelNScalar);
        energyFactor +=
            static_cast<double>(normalDampingCoefficient) * (0.5 * Sqr(pc) + pc * (pn - pc));
      } else {
        energyFactor +=
            0.5 * static_cast<double>(normalDampingCoefficient) * Sqr(StaticCast<Vd>(pRelNScalar));
      }
    }

    if (assemForce || assemDForce) {
      V tmp = normalDampingCoefficient * fPenalty;

      // Output force: force = -coeff * fN * pn / dtFactor (damping in normal direction)
      if (assemForce) {
        if constexpr (kGradTarget == GradTarget::Previous) {
          outForce += tmp * pRelNDamp;
        } else {
          outForce -= tmp * pRelNDamp;
        }
      }

      // Output dforce: The full derivative of the damping force includes both the derivative
      // with respect to the normal velocity and the derivative of the normal force.
      // force_damping = -coeff * fN * pRelN
      // dforce = -coeff * fN * (n ⊗ n)
      // As in viscous friction, the derivative of fN is dropped, even when fN is implicit.
      if (assemDForce) {
        MOCHI_ASSERT_VERBOSE(AllTrue(tmp >= 0_r), "eigN must not be positive.");
        // At its bound the damping part is minus the penalty force of the step, so its derivative is minus the
        // penalty force derivative: the two cancel and the contact has no normal stiffness there.
        eigN = unilateralDamping ? Select(dampActive, -tmp, dFPenaltyNow) : -tmp;

        // dEnergyFactor term needed for GradTarget::Previous
        if constexpr (kGradTarget == GradTarget::Previous) {
          dEnergyFactor += normalDampingCoefficient * pRelNDamp;
        }
      }
    }
  } else {
    if (assemDForce) {
      eigN = {};
    }
  }

  // Write accumulated eigenvalues to dforce.
  if (assemDForce) {
    if constexpr (kGradTarget == GradTarget::Previous) {
      // Flip the sign of the eigenvalues
      eigP = -eigP;
      eigN = -eigN;
    }
    V eigDeltaN = eigN - eigP;
    V3 auxN = eigDeltaN * normal;
    outDForce[0] += eigP + auxN[0] * normal[0]; // xx
    outDForce[1] += eigP + auxN[1] * normal[1]; // yy
    outDForce[2] += eigP + auxN[2] * normal[2]; // zz
    outDForce[3] += auxN[0] * normal[1]; // xy
    outDForce[4] += auxN[0] * normal[2]; // xz
    outDForce[5] += auxN[1] * normal[2]; // yz
    if constexpr (kGradTarget == GradTarget::Previous) {
      outDForce[6] += auxN[0] * normal[1]; // yx
      outDForce[7] += auxN[0] * normal[2]; // zx
      outDForce[8] += auxN[1] * normal[2]; // zy
    }

    // Extra pass for tangent contribution (Coulomb unfitted only)
    if ((!config.useFittedHessian || FrictionStickDistance() > 0_r) &&
        (params.coulombFrictionCoefficient > 0)) {
      if constexpr (kGradTarget == GradTarget::Previous) {
        // Flip the sign of the eigenvalues
        eigDeltaT = -eigDeltaT;
      }
      V3 auxT = eigDeltaT * tangent;
      outDForce[0] += auxT[0] * tangent[0];
      outDForce[1] += auxT[1] * tangent[1];
      outDForce[2] += auxT[2] * tangent[2];
      outDForce[3] += auxT[0] * tangent[1];
      outDForce[4] += auxT[0] * tangent[2];
      outDForce[5] += auxT[1] * tangent[2];
      if constexpr (kGradTarget == GradTarget::Previous) {
        outDForce[6] += auxT[0] * tangent[1];
        outDForce[7] += auxT[0] * tangent[2];
        outDForce[8] += auxT[1] * tangent[2];
      }
    }
  }

  // Output energy. Add to current value.
  if (assemEnergy) {
    outEnergy += StaticCast<Vd>(fPenalty) * energyFactor;
  }

  // Add Previous-target terms from differentiating the explicit stage-start penalty force.
  if constexpr (kGradTarget == GradTarget::Previous) {
    // sdfGrad stores the appropriate gradient of the SDF (explicit or implicit).
    if (assemForce) {
      V const dFPenaltyTimesEnergyFactor = dFPenalty * StaticCast<V>(energyFactor);
      outForce += dFPenaltyTimesEnergyFactor * sdfGrad;
    }
    if (assemDForce) {
      V3 const row0 = dFPenalty * dEnergyFactor[0] * sdfGrad;
      V3 const row1 = dFPenalty * dEnergyFactor[1] * sdfGrad;
      V3 const row2 = dFPenalty * dEnergyFactor[2] * sdfGrad;
      outDForce[0] += row0[0]; // xx
      outDForce[1] += row1[1]; // yy
      outDForce[2] += row2[2]; // zz
      outDForce[3] += row0[1]; // xy
      outDForce[4] += row0[2]; // xz
      outDForce[5] += row1[2]; // yz
      outDForce[6] += row1[0]; // yx
      outDForce[7] += row2[0]; // zx
      outDForce[8] += row2[1]; // zy
    }
  }
}

template <int kBatchSize, GradTarget kGradTarget>
MOCHI_NO_INLINE
    void ComputeBatchCollisionForceDForceSenua(
        Span<double> outEnergy,
        Span<Real3> outForce,
        Span<VMatrix3x3r> outDForce,
        Span<real const> distance,
        Span<Real3 const> distanceGrad,
        Span<real const> distanceStageStart,
        Span<Real3 const> distanceGradStageStart,
        Span<Real3 const> normalColliding,
        Span<Real3 const> posColliding,
        Span<Real3 const> posCollidingStageStart,
        ContactParams const& params,
        ContactEvalConfig const& config,
        real dtFactor,
        bool assemEnergy,
        bool assemForce,
        bool assemDForce,
        bool isSdfGradUnitary,
        Span<Real3 const> frictionAnchor = {}) {
  static_assert(
      kCollResponseMaxBatchSize == 8,
      "Please update batched contact functions if the max batch size changes");
  static_assert(kBatchSize > 0 && kBatchSize <= kCollResponseMaxBatchSize, "Invalid batch size");
  static_assert(
      kGradTarget == GradTarget::Current || kGradTarget == GradTarget::Previous,
      "Contact assembly should be called only for GradTarget::Current or GradTarget::Previous");

  MOCHI_ASSERT_VERBOSE(!assemEnergy || (outEnergy.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(!assemForce || (outForce.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(!assemDForce || (outDForce.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(
      distance.size() == kBatchSize && distanceGrad.size() == kBatchSize &&
      posColliding.size() == kBatchSize && posCollidingStageStart.size() == kBatchSize);
  MOCHI_ASSERT_VERBOSE(!config.validCollidingNormals || normalColliding.size() == kBatchSize);
  MOCHI_ASSERT_VERBOSE(
      !config.explicitNormals ||
      (distanceStageStart.size() == kBatchSize && distanceGradStageStart.size() == kBatchSize));
  MOCHI_ASSERT_VERBOSE(
      params.penaltyCoefficient > 0_r && params.penaltySmoothingHalfDistance >= 0_r,
      "Invalid contact params.");
  MOCHI_ASSERT_VERBOSE(
      params.maxAlignmentNormals >= -1_r && params.maxAlignmentNormals <= 1_r,
      "maxAlignmentNormals must be in [-1, 1].");

  // Forbid unsupported combinations
  MOCHI_ASSERT_VERBOSE(
      !(config.implicitNormalForceForDissipation && config.explicitNormals),
      "implicitNormalForceForDissipation = true with explicitNormals = true is not supported.");
  MOCHI_ASSERT_VERBOSE(
      kGradTarget == GradTarget::Current ||
          (!config.implicitNormalForceForDissipation && config.explicitNormals),
      "GradTarget::Previous requires implicitNormalForceForDissipation = false and explicitNormals = true.");

  using V = BatchReal<kBatchSize>;
  using Vd = BatchDouble<kBatchSize>;
  using V3 = BatchReal3<kBatchSize>;

  // Create SIMD locals for outputs
  Vd energy MOCHI_NO_INIT;
  V3 force MOCHI_NO_INIT;
  BatchDForce<kBatchSize, kGradTarget> dForce MOCHI_NO_INIT;
  V fPenalty MOCHI_NO_INIT;
  V dFPenalty MOCHI_NO_INIT;

  // Load input distance and distance gradient
  V const d = Load<kBatchSize, V>(&distance[0]);

  V3 sdfGrad MOCHI_NO_INIT;
  LoadTransposed<kBatchSize>(&distanceGrad[0][0], sdfGrad);

  // Load collider normal, explicit or implicit
  V3 nCollider = sdfGrad;
  if (config.explicitNormals) {
    LoadTransposed<kBatchSize>(&distanceGradStageStart[0][0], nCollider);
  }

  // Load colliding normals if valid
  V3 nColliding MOCHI_NO_INIT;
  if (config.validCollidingNormals) {
    LoadTransposed<kBatchSize>(&normalColliding[0][0], nColliding);
  }

  // Normally, the gradient of signed distance (nCollider) points in the opposite direction of the
  // surface normal at the sample point (nColliding). If they point in the same direction, then it
  // means that the contact force would be pulling the object apart instead of compressing the
  // object. That happens when one collider gets embedded within another one. The contact energy
  // would normally trap the collider preventing it from escaping. We prevent that contact energy to
  // allow it to escape.
  V const alignmentNormals = config.validCollidingNormals ? Dot(nCollider, nColliding) : V{-1_r};
  V const maxAlignment = V{params.maxAlignmentNormals};
  V const alignmentMask = alignmentNormals <= maxAlignment;
  // maxAlignmentNormals == -1 leaves no nonzero fade interval. Use an unfaded factor instead of
  // evaluating the degenerate endpoint formula.
  bool const useAlignmentFading =
      config.fadeFriction && config.validCollidingNormals && params.maxAlignmentNormals > -1_r;
  // Compute alignment fading for dissipation
  V const alignmentFactor =
      useAlignmentFading ? (maxAlignment - alignmentNormals) / (maxAlignment + 1_r) : V{1_r};

  // Compute penalty force with current data.
  bool constexpr kAssemPenalty =
      IsAssemblyNeeded(StateDependency::ZeroOrder, false /*inputDependency*/, kGradTarget);
  bool const hasDissipation = params.coulombFrictionCoefficient > 0_r ||
      params.viscousFrictionCoefficient > 0_r || params.normalViscousDampingCoefficient > 0_r;
  bool const useImplicitNormalForceForDissipation =
      config.implicitNormalForceForDissipation && hasDissipation;
  if constexpr (kAssemPenalty) {
    ComputeBatchContactPenaltyForceDForce<kBatchSize>(
        energy,
        force,
        dForce,
        fPenalty,
        d,
        sdfGrad,
        alignmentMask,
        alignmentFactor,
        params,
        config,
        assemEnergy,
        assemForce,
        assemDForce,
        useImplicitNormalForceForDissipation);
  } else {
    // Ensure containers are initialized for GradTarget::Previous
    if (assemEnergy) {
      energy = {};
    }
    if (assemForce) {
      force = {};
    }
    if (assemDForce) {
      dForce = {};
    }
  }

  // Compute dissipation force.
  if (hasDissipation) {
    // Load positions and compute relative displacement
    V3 pColliding MOCHI_NO_INIT;
    LoadTransposed<kBatchSize>(&posColliding[0][0], pColliding);

    V3 pCollidingStageStart MOCHI_NO_INIT;
    LoadTransposed<kBatchSize>(&posCollidingStageStart[0][0], pCollidingStageStart);

    V3 const pRel = pColliding - pCollidingStageStart;

    // Anchored friction: tangential displacement from each contact's stick anchor.
    V3 pRelFriction = pRel;
    if (frictionAnchor.size() == kBatchSize && FrictionStickDistance() > 0_r) {
      V3 pAnchor MOCHI_NO_INIT;
      LoadTransposed<kBatchSize>(&frictionAnchor[0][0], pAnchor);
      pRelFriction = pColliding - pAnchor;
    }

    // Compute penalty force with stage-start data.
    if (!useImplicitNormalForceForDissipation) {
      // Distance for penalty force computation (stage-start data)
      V dStageStart MOCHI_NO_INIT;

      if (config.explicitNormals) {
        // Use stage-start distance
        dStageStart = Load<kBatchSize, V>(&distanceStageStart[0]);
      } else {
        // Estimate stage-start distance using current gradient.
        dStageStart = d - Dot(sdfGrad, pRel);
      }

      // We need dForceNorm for GradTarget::Previous force or dforce.
      bool const assemDForceNorm =
          kGradTarget == GradTarget::Previous && (assemForce || assemDForce);
      ComputeBatchContactPenaltyForceNormDForceNorm<kBatchSize>(
          fPenalty,
          dFPenalty,
          dStageStart,
          alignmentMask,
          alignmentFactor,
          params,
          config,
          assemDForceNorm);
    }

    // The penalty force of the step being solved and its derivative, which bound the damping part
    // (ContactDampingUnilateral).
    V fPenaltyNow = fPenalty;
    V dFPenaltyNow = V{};
    if (ContactDampingUnilateral() && params.normalViscousDampingCoefficient > 0_r) {
      ComputeBatchContactPenaltyForceNormDForceNorm<kBatchSize>(
          fPenaltyNow, dFPenaltyNow, d, alignmentMask, alignmentFactor, params, config, true);
    }

    ComputeBatchContactDissipationForceDForceSenua<kBatchSize, kGradTarget>(
        energy,
        force,
        dForce,
        fPenalty,
        dFPenalty,
        nCollider,
        nColliding,
        pRelFriction,
        params,
        config,
        dtFactor,
        assemEnergy,
        assemForce,
        assemDForce,
        isSdfGradUnitary,
        fPenaltyNow,
        dFPenaltyNow,
        pRel);
  }

  // Store outputs to Spans
  if (assemEnergy) {
    Store<kBatchSize>(outEnergy.data(), energy);
  }

  if (assemForce) {
    StoreTransposed<kBatchSize>(&outForce[0][0], force);
  }

  if (assemDForce) {
    // TODO: outDForce should be either:
    //   1. Nine dense arrays of real, in which case this loop would be 9 vector Stores.
    //   2. A dense array of Matrix3x3, in which case this loop would still be needed.
    for (int i = 0; i < kBatchSize; ++i) {
      if constexpr (kGradTarget == GradTarget::Current) {
        // outDForce is symmetric and stored in a 6-value array.
        outDForce[i] = VMatrix3x3r{
            Vec4r{dForce[0][i], dForce[3][i], dForce[4][i]}, // xx, xy, xz
            Vec4r{dForce[3][i], dForce[1][i], dForce[5][i]}, // xy, yy, yz
            Vec4r{dForce[4][i], dForce[5][i], dForce[2][i]}}; // xz, yz, zz
      } else {
        // outDForce is asymmetric and stored in a 9-value array.
        outDForce[i] = VMatrix3x3r{
            Vec4r{dForce[0][i], dForce[3][i], dForce[4][i]}, // xx, xy, xz
            Vec4r{dForce[6][i], dForce[1][i], dForce[5][i]}, // yx, yy, yz
            Vec4r{dForce[7][i], dForce[8][i], dForce[2][i]}}; // zx, zy, zz
      }
    }
    // NOTE: outDForce is expected to be PSD. If it is not, a projection onto the PSD cone must be
    // added here.
  }
}

#undef MOCHI_SIMD_FROM_STRUCT_MEMBER_INDEXED

template <GradTarget kGradTarget>
void ComputeCollisionResponseRange(
    Interval<int> pointRange,
    ContactDetectionResult const& contactQuery,
    ContactParams const& params,
    ContactEvalConfig const& config,
    real dtStage,
    bool assemEnergy,
    bool assemForce,
    bool assemDForce,
    CollisionResponseResult& outResponse);

// Compute collision response for a collider and store it in CollisionResponseResult.
template <GradTarget kGradTarget>
void ComputeCollisionResponse(
    ContactDetectionResult const& contactQuery,
    ContactParams const& params,
    ContactEvalConfig const& config,
    real dtStage,
    bool assemEnergy,
    bool assemForce,
    bool assemDForce,
    CollisionResponseResult& outResponse) {
  ComputeCollisionResponseRange<kGradTarget>(
      Interval<int>{0, isize(contactQuery.sampleIndices)},
      contactQuery,
      params,
      config,
      dtStage,
      assemEnergy,
      assemForce,
      assemDForce,
      outResponse);
}

/*************************************************************************************************/

/*
  A collider defined by a oriented bounding box.
*/
struct BoxCollider {
  Obb shape;
};

/*
  A collider defined by a sphere shape.
*/
struct SphereCollider {
  Sphere shape;
};

/*
  A collider defined by a plane shape.
*/
struct PlaneCollider {
  Plane shape;
};

/**
  A collider defined by a signed distance field (SDF).
*/
struct SdfCollider {
  std::shared_ptr<Sdf const> shape;
};

/**
  An SDF collider augmented with a mapping
*/
struct MappedSdfCollider {
  Sdf const* shape = nullptr;
  BaseMap* mapping = nullptr;
};

/** @brief A collider defined by a triangular mesh. */
template <typename Bv>
class MeshColliderBvh {
 public:
  MOCHI_DECLARE_MOVE_ONLY(MeshColliderBvh); // No copy please

  MeshColliderBvh() = default;

  explicit MeshColliderBvh(std::shared_ptr<TriangularMesh const> const& mesh) : _mesh(mesh) {}

  virtual ~MeshColliderBvh() = default;

  /** @brief Initialize the internal data structures. */
  virtual void Initialize(bool allowRefitting = false) {
    MOCHI_PROFILE_SCOPE();
    MOCHI_ASSERT_VERBOSE(_mesh != nullptr, "Invalid collider _mesh pointer");

    // Create the half-edge data structure from the _mesh
    _halfEdge = _mesh->GenerateHalfEdgeStructure();
    bool closed = mochi::IsMeshClosed(_halfEdge);
    if (!closed) {
      // If refitting is not allowed, we can try to stitch the mesh. In this way, the MeshCollider
      // supports meshes with vertex multiplicity. This is useful for the generation of SDFs for
      // rigid actors.
      if (!allowRefitting) {
        if (auto stitchedMesh = TriangularMeshFromClusteredVertices(
                _mesh->GetNodeCoordinates(), _mesh->GetElementConnectivity())) {
          _mesh = std::move(stitchedMesh);
          _halfEdge = _mesh->GenerateHalfEdgeStructure();
          closed = mochi::IsMeshClosed(_halfEdge);
        }
      }
    }
    _isMeshClosed = closed;

    // Initialize node coordinates and primitive normals.
    if (allowRefitting) {
      _deformedNodeCoordinates = {
          _mesh->GetNodeCoordinates().begin(), _mesh->GetNodeCoordinates().end()};
      _deformedElementNormals = {
          _mesh->GetElementNormals().begin(), _mesh->GetElementNormals().end()};
      _nodeCoordinates = _deformedNodeCoordinates;
      _elementNormals = _deformedElementNormals;
    } else {
      _nodeCoordinates = _mesh->GetNodeCoordinates();
      _elementNormals = _mesh->GetElementNormals();
    }
    _nodeNormals.resize(_mesh->GetNumNodes());
    _edgeNormals.resize(_mesh->GetNumEdges());
    _mesh->ComputeNodeNormals(_nodeCoordinates, _elementNormals, _nodeNormals);
    _mesh->ComputeEdgeNormals(_halfEdge, _elementNormals, _edgeNormals);

    // Compute acceleration structures.
    _bvhTreeObject = std::make_unique<TriangularMeshBvhObject<Bv>>(_mesh, _nodeCoordinates);
    _bvhTree = std::make_unique<BvhTree<Bv>>(_bvhTreeObject.get(), BvhTreeParams{});
    _initialized = true;
  }

  [[nodiscard]] bool IsInitialized() const {
    return _initialized;
  }

  /** @brief True if the mesh is topologically closed (watertight) after initialization. */
  [[nodiscard]] bool IsMeshClosed() const {
    MOCHI_ASSERT_VERBOSE(_initialized, "IsMeshClosed() called before Initialize()");
    return _isMeshClosed;
  }

  [[nodiscard]] Span<Real3 const> GetCoordinates() const {
    return _nodeCoordinates;
  }

  [[nodiscard]] std::shared_ptr<TriangularMesh const> const& GetMesh() const {
    return _mesh;
  }

  [[nodiscard]] HalfEdgeStructure const& GetHalfEdge() const {
    return _halfEdge;
  }

  // Dynamic refit function. Virtual to allow other implementations in subclasses.
  virtual void Refit(ColumnVectorView<real const> displacements, Error& error) {
    MOCHI_ERROR_RETURN(error);

    MOCHI_ERROR_IF(
        _deformedNodeCoordinates.empty(),
        error,
        "Trying to refit MeshCollider created with allowRefitting = false");
    MOCHI_ERROR_RETURN(error);

    MOCHI_ASSERT(
        displacements.size() == 3 * _nodeCoordinates.size(),
        "Size of displacements does not match mesh");
    _nodeDisplacements = Unflatten<Real3 const>(displacements);

    RefitGeometry();

    _bvhTree->Refit();
  }

  // Main collision detection query
  bool QueryPoint(
      Vec4r position,
      ContactDetectionParams const& params,
      Vec4r& outPos,
      real& outSdf,
      Vec4r& outSdfGrad) const;

 protected:
  void RefitGeometry() {
    _mesh->ComputeNodeCoordinates(_nodeDisplacements, _deformedNodeCoordinates);
    _mesh->ComputeElementNormals(_deformedNodeCoordinates, _deformedElementNormals);
    _mesh->ComputeNodeNormals(_deformedNodeCoordinates, _deformedElementNormals, _nodeNormals);
    _mesh->ComputeEdgeNormals(_halfEdge, _deformedElementNormals, _edgeNormals);
  }

  int FindClosestFaceBruteForce(Vec4r position, real& outDistSqr) const;

  // Source information.
  std::shared_ptr<TriangularMesh const> _mesh;

  // Derived information.
  HalfEdgeStructure _halfEdge;
  std::unique_ptr<BvhTree<Bv>> _bvhTree;
  std::unique_ptr<TriangularMeshBvhObject<Bv>>
      _bvhTreeObject; // unique_ptr is used here because bvhTree points to bvhTreeObject. If this
                      // MeshCollider is move constructed, the two members still need to point to
                      // each other.
  Span<Real3 const> _nodeCoordinates; // Points to _deformedNodeCoordinates if the collider is
                                      // refit, and to _mesh->GetNodeCoordinates() otherwise.
  Span<Real3 const> _elementNormals; // Points to _deformedElementNormals if the collider is refit,
                                     // and to _mesh->GetElementNormals() otherwise.
  std::vector<Real3> _nodeNormals;
  std::vector<Real3> _edgeNormals;
  bool _initialized = false;
  bool _isMeshClosed = true;

  // Dynamic information
  Span<Real3 const> _nodeDisplacements; // Points to an external container.
  std::vector<Real3> _deformedNodeCoordinates; // Reserved only upon refitting.
  std::vector<Real3> _deformedElementNormals; // Reserved only upon refitting.
};

using MeshCollider = MeshColliderBvh<Aabb>;

/*
  NOTE:
  - All types must implement HasOverlap overloads.
  - SdfBv with a mapping is not currently supported.
*/
using AnyBoundingVolume = std::variant<Plane, Sphere, Obb, Aabb, SdfBv>;

inline AnyBoundingVolume ToAnyBoundingVolume(AnyShape const& anyShape) {
  return std::visit([](auto const& shape) -> AnyBoundingVolume { return shape; }, anyShape);
}

/*************************************************************************************************/

/**
 * @brief Find contacts between a span of points and a MappedSdfCollider in different coordinate
 * spaces. Output results in the collider's space. SDF and Jacobian outputs are optional.
 */
void FindPointContactsMapped(
    Span<Real3 const> points,
    MappedSdfCollider const* collider,
    ContactDetectionParams const& params,
    TransformRT const& pointsFromCollider,
    AnyShape const& bounds,
    DynamicArray<int>& outIndices,
    DynamicArray<Real3>& outContacts,
    SdfInfo* outSdf,
    bool& outIsSdfGradUnitary,
    int* outNDofs,
    DynamicArray<VMatrix3x3r>* outMapJac,
    DynamicArray<ColliderJacDofs>* outDofsJac);

/**
 * @brief Concept for collider types that support point contact detection.
 * These are the types with explicit specializations of FindPointContactsT.
 */
template <typename T>
concept FindPointContactsCollider = std::same_as<std::decay_t<T>, Plane> ||
    std::same_as<std::decay_t<T>, Sphere> || std::same_as<std::decay_t<T>, Obb> ||
    std::same_as<std::decay_t<T>, MeshCollider> || std::same_as<std::decay_t<T>, GridSdf>;

/**
 * @brief Templatized function for finding contacts between a span of points and a collider in
 * different coordinate spaces. Output results in the collider's space.
 */
template <FindPointContactsCollider T>
void FindPointContactsT(
    Span<Real3 const> points,
    T const* collider,
    ContactDetectionParams const& params,
    TransformRT const& pointsFromCollider,
    DynamicArray<int>& outIndices,
    DynamicArray<Real3>& outContacts,
    SdfInfo& outSdf,
    bool& outIsSdfGradUnitary);

// Templatized parallel function for finding contacts between a span of points and a collider in
// different coordinate spaces. Output results in the collider's space. The points will be divided
// evenly between the requested number of async tasks. If the number of tasks is not specified (i.e.
// -1), then it is automatically determined based on the number of query points.
template <FindPointContactsCollider T>
inline void FindPointContactsParallel(
    Span<Real3 const> points,
    T const* collider,
    ContactDetectionParams const& params,
    TransformRT const& pointsFromCollider,
    DynamicArray<int>& outIndices,
    DynamicArray<Real3>& outContacts,
    SdfInfo& outSdf,
    bool& outIsSdfGradUnitary,
    int minPointsPerTask = 5000) {
  if (points.empty()) {
    return;
  }

  // If we don't have enough points for multiple tasks, then forward to FindPointContactsT.
  if (isize(points) <= minPointsPerTask) {
    FindPointContactsT(
        points,
        collider,
        params,
        pointsFromCollider,
        outIndices,
        outContacts,
        outSdf,
        outIsSdfGradUnitary);
    return;
  }

  int maxTasks = 2 * (1 + TaskScheduler::StaticGetNumOtherThreads());
  int numTasks = Clamp(isize(points) / minPointsPerTask, 1, maxTasks);
  MOCHI_ASSERT_VERBOSE(numTasks >= 1);

  // Show the scope name in the profiler if we're actually doing parallel work
  MOCHI_PROFILE_SCOPE();
  int const numPoints = isize(points);

  // Prepare per-thread response
  int numPointsPerTask = static_cast<int>(std::ceil(numPoints / numTasks));

#define MOCHI_PREPARE_THREAD_DATA(type, data, ptr, out) \
  DynamicArray<type> data(numTasks - 1);                \
  DynamicArray<type*> ptr;                              \
  ptr.resize_noinit(numTasks);                          \
  ptr[0] = &out;                                        \
  for (int i = 1; i < numTasks; ++i) {                  \
    ptr[i] = &data[i - 1];                              \
  }

  MOCHI_PREPARE_THREAD_DATA(DynamicArray<int>, extIndices, thrIndices, outIndices);
  MOCHI_PREPARE_THREAD_DATA(DynamicArray<Real3>, extContacts, thrContacts, outContacts);
  MOCHI_PREPARE_THREAD_DATA(SdfInfo, extSdf, thrSdf, outSdf);
  MOCHI_PREPARE_THREAD_DATA(bool, extUnitGrad, thrUnitGrad, outIsSdfGradUnitary);
#undef MOCHI_PREPARE_THREAD_DATA

  ParallelForN("FindPointContactsT", numTasks, 1, [&](int i) {
    int pointsBegin = i * numPointsPerTask;
    int pointsEnd = (i == numTasks - 1) ? numPoints : (pointsBegin + numPointsPerTask);
    Span<Real3 const> pointsForTask = points.subspan(pointsBegin, pointsEnd - pointsBegin);
    FindPointContactsT(
        pointsForTask,
        collider,
        params,
        pointsFromCollider,
        *thrIndices[i],
        *thrContacts[i],
        *thrSdf[i],
        *thrUnitGrad[i]);
  });

  size_t numContacts = 0;
  for (auto const* r : thrContacts) {
    numContacts += r->size();
  }

  // Concat responses
  outIndices.reserve(numContacts);
  outContacts.reserve(numContacts);
  outSdf.reserve(numContacts);
  for (int i = 0; i < numTasks - 1; ++i) {
    // Check consistency of unitary gradient.
    int const prevSize = isize(outIndices);
    if (prevSize == 0) {
      outIsSdfGradUnitary = extUnitGrad[i];
    } else {
      MOCHI_ASSERT_VERBOSE(
          outIsSdfGradUnitary == extUnitGrad[i], "Inconsistent isSdfGradUnitary flags.");
    }

    // Append indices and contacts
    outIndices.append(extIndices[i]);
    outContacts.append(extContacts[i]);
    outSdf.append(extSdf[i]);

    // Apply offset to incoming indices
    int const indexOffset = (i + 1) * numPointsPerTask;
    int newSize = isize(outIndices);
    for (int j = prevSize; j < newSize; ++j) {
      outIndices[j] += indexOffset;
    }
  }
}

/*************************************************************************************************
  Utility functions for boundary discretizations
*/

// Helper function to get node weights of a boundary discretization sample
template <typename ElementT>
inline NdArray<real, ElementT::kNumNodes> GetWeightInfo(
    Span<ElementT const> femElements,
    int sampleIndex) {
  static_assert(ElementT::kNumDofs == 4 || ElementT::kNumDofs == 3 || ElementT::kNumDofs == 2);

  // Determine element
  static int constexpr kNumQuads = ElementT::kNumQuadPoints;
  int const boundaryElementIndex = sampleIndex / kNumQuads;
  auto const& element = femElements[boundaryElementIndex];

  // Fetch quadrature weights.
  int const quadPointIndex = sampleIndex % kNumQuads;
  auto const& basisWeights = element.basisEvaluated[quadPointIndex];

  // Get weights for the local nodes corresponding to the boundary face.
  auto const inds = element.LocalNodes();
  NdArray<real, ElementT::kNumNodes> weightInfo{};
  for (int i = 0; i < ElementT::kNumNodes; i++) {
    weightInfo[i] = basisWeights[inds[i]];
  }
  return weightInfo;
}

// Helper function to get node indices of a boundary discretization sample
template <typename ElementT>
inline NdArray<int, ElementT::kNumNodes> GetNodeInfo(
    Span<ElementT const> femElements,
    int sampleIndex) {
  static_assert(ElementT::kNumDofs == 4 || ElementT::kNumDofs == 3 || ElementT::kNumDofs == 2);

  // Determine element
  static int constexpr kNumQuads = ElementT::kNumQuadPoints;
  int const boundaryElementIndex = sampleIndex / kNumQuads;
  auto const& element = femElements[boundaryElementIndex];

  // Get node indices
  return element.Nodes();
}

} // namespace mochi
