# Run 018: design probes for the eighth registration (joint limits)

14 October 2026. Throwaway parameters and throwaway commands; nothing here decides anything. Probe arm: 1 kg,
0.5 m from the joint (inertia 0.2517 kg m2), limit at -0.2 rad. The probes' output was not kept: this folder holds
only this README, so the numbers below are as noted at the time and cannot be checked from the record.

- **The limit at rest is the spring it says it is.** An arm resting on a limit under gravity sits at the angle a
  linear spring gives, at stiffness 100, 1,000 and 10,000 (for example -204,799 micro-radians against -204,800).
  Stock is right here. Its shipped default stiffness (100 N m a radian) lets a 1 kg arm at 0.5 m sag 2.7 degrees
  past the limit.
- **A bounce off an undamped limit is set by the step**, as at a contact: an arm that should leave at 2 rad/s
  leaves at 0.81 at the shipped step and 1.97 at 1/64 (stiffness 1,000). The integrator's loss, not the limit's.
- **A damped limit holds back an arm that is leaving it.** Released at rest 0.02 rad inside a limit of stiffness
  1,000 with damping 10, the arm reaches 0.827 rad/s and is then slowed, inside the limit, to 0.670 before it is
  out. A spring and damper that can only push would release it at 0.832; one that can also pull, at 0.673. With
  damping 50, above critical, it never leaves: it is held at the limit and creeps. Stock's limit force is stiffness
  times depth plus damping times the rate of change of depth, with no lower bound
  (`mochi_constraint.cpp`, `ComputeLocalObjResDRes`), so it is negative while the joint comes back into range.
- **Meta's benchmark scenes ship such limits**: `ant` stiffness 1,000 and damping 50, `cart_pole` 1,000 and 2,500,
  `half_cheetah` damping 100 at the default stiffness.
- **The correction** (`patches/superseded/senua_joint_limit_registration14.patch`, 92 added lines, none removed,
  the form the eighth registration names as `patches/senua_joint_limit.patch`; off unless
  `SUPERDEX_LIMIT_UNILATERAL` is set): the force along a range constraint is never below zero. It is the derivative of an energy, so the solver still
  minimises one. With it the arm leaves at 0.827 rad/s (damping 10) and 0.332 (damping 50) at 1/64 of the step,
  against 0.832 and 0.334; the angle at rest is unchanged; an arm lifted off its limit leaves at once; the sixth
  registration's 30 runs are reproduced bit for bit with the switch off.
- **A fault of ours, found and fixed in the probes.** The first build read the constraint's value in a pass where
  SuperDex does not compute it, and with `cart_pole`'s damping the solver failed on the step an arm first met the
  limit. The fixed build converges there exactly as stock (6 iterations).
- **The benchmark with the correction, throwaway commands.** `cart_pole` and `half_cheetah` barely change (summed
  difference 91 to 531 and 0 to 150,997 against chain gaps of 130,000 and 400,000) and their solver status is
  stock's. `ant` changes a great deal (6 to 7 million): its legs live on their limits. Its solver status is
  close to stock's (24 steps stopped of 2,400 against 21). Its time-step chain is in order in fewer folds with the
  correction: 1 of 3 against stock's 2 of 3, and 2 of 3 against 3 of 3 under the recommended configuration
  corrected.
