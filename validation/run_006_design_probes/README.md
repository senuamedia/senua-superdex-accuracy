# Run 006: design probes for the third registration, on throwaway actions

Made on 13 October 2026 after the second registration did not hold in full, to design the third
([PREREGISTRATION_03.md](../../preregistrations/PREREGISTRATION_03.md)). These are not registered data: twelve episodes a scene on
seeded actions (seeds 9111, 9112, 9113) that are used nowhere else. The instrument read none of the probe streams.
Everything here is plain subtraction of the rig's noiseless encoder streams, in encoder counts (one count is 0.022
degrees), except the third harness's dry run at the end of `old_streams.txt`, which is instrument output.

**The question:** the second registration's order failures have four possible owners: the instrument, the rig, the
scene, or the engine. Which can be ruled out, and with what test?

## Files

| File | What it is |
|---|---|
| `probe.txt` | One `PLAY` line a source from the rig, then every comparison as the harness printed it |
| `by_part.txt` | The same comparisons as a table: the summed absolute difference in each part of the episode |
| `old_streams.txt` | The second registration's own streams (`streams/02/`) read again by plain subtraction: by part of the episode, and fold by fold beside what the instrument had read |

## How to read the tables

- A row is one pair of sources. In a chain each source is compared with the next finer one.
- The columns are parts of the episode, in readings: 0-5, 5-10, 10-20, 20-40, 40-80, 80-120, 120-160, 160-200. A
  reading is one shipped simulation step (10 ms on `half_cheetah` and `ant`, 20 ms on `cart_pole`).
- The number is the absolute difference between the two encoder streams, summed over that part of all twelve
  episodes.
- `t1 t2 ... t64` is the time step at 1, 1/2 ... 1/64 of the shipped step. `g` is the same with the ground plane
  left out, `m` with friction off, `k7_` and `k5_` with the contact penalty at 1e7 and 1e5 (shipped: 1e9), `f` with
  the friction falloff speed at 0.1 m/s (shipped: 0.01). `p3 p6 p9 p12` and `n00 n01` are the reference with the
  first command nudged by 1e-3, 1e-6, 1e-9, 1e-12, 1 and 10.

## What it showed

**The rig repeats.** The reference played twice, and played with the nudge set to zero, gives byte-identical encoder
streams and state files on all three scenes.

**The scenes do not amplify a small change. They forget it.** This refuted our working guess that the motion was
too sensitive for any simulator to settle.

| Nudge on the first command | half_cheetah | ant | cart_pole |
|---|---|---|---|
| 1e-12, 1e-9, 1e-6 | every reading identical | every reading identical | every reading identical |
| 1e-3 | 1 reading differs, by 1 count | 7 readings differ, by 1 count | every reading identical |
| 1 | largest part 502, then 9 by the end | largest part 2,125, then 540 | largest part 820, then 2 |
| 10 | largest part 5,076, then 92 by the end | largest part 16,767, then 225 | largest part 8,022, then 24 |

Ten times the nudge gives about ten times the response (7.9 to 10.1 times in the largest part), and the response
fades.

**Without the ground, `half_cheetah`'s time-step settings halve through the whole episode. With the ground they
stop halving once the ground starts to matter.**

| half_cheetah | 0-5 | 5-10 | 10-20 | 20-40 | 40-80 | 80-120 | 120-160 | 160-200 |
|---|---|---|---|---|---|---|---|---|
| With ground: step 1 to 1/2 | 348 | 406 | 1,925 | 8,865 | 16,157 | 12,541 | 15,015 | 18,501 |
| 1/2 to 1/4 | 191 | 216 | 1,102 | 6,739 | 11,695 | 7,346 | 10,022 | 10,344 |
| 1/4 to 1/8 | 101 | 118 | 837 | 9,848 | 18,614 | 14,424 | 8,322 | 8,074 |
| 1/8 to 1/16 | 49 | 59 | 647 | 7,890 | 29,651 | 19,689 | 22,531 | 10,541 |
| 1/16 to 1/32 | 23 | 29 | 455 | 7,165 | 42,407 | 28,566 | 29,242 | 24,486 |
| 1/32 to 1/64 | 14 | 14 | 277 | 3,941 | 30,826 | 38,310 | 33,966 | 29,537 |
| No ground: step 1 to 1/2 | 348 | 409 | 2,393 | 5,556 | 15,204 | 14,345 | 15,019 | 17,797 |
| 1/2 to 1/4 | 191 | 217 | 1,277 | 3,069 | 8,494 | 7,988 | 8,449 | 10,379 |
| 1/4 to 1/8 | 101 | 118 | 664 | 1,600 | 4,351 | 4,252 | 4,568 | 5,639 |
| 1/8 to 1/16 | 49 | 60 | 336 | 829 | 2,149 | 2,224 | 2,396 | 2,936 |

- For the first ten readings (0.1 s) the two chains agree to within 3 counts (406 against 409 is the largest
  gap): the ground plays almost no part yet. The second registration's contact-smoothing chain says when it starts
  to: on `half_cheetah` no smoothing setting changes any reading by more than one count before reading 10 (two of
  its gaps differ by 1 count in readings 5 to 10).
- From there the chain without ground keeps halving, as a first-order integrator should.
- The chain with ground does not. By 0.4 s its finer gaps are larger than its coarser ones, and they are still not
  falling at 1/64 of the shipped step (0.16 ms).

**`cart_pole` and `ant`.** `cart_pole`, which has no ground and no contact, halves at every step out to 1/64 of the
step through reading 40 (first part: 753, 368, 179, 93, 44, 24); after reading 40 its gaps are a few tens of
counts or less and no longer halve. `ant` without the ground falls at every step in every part. `ant`
with the ground halves early (first part: 773, 371, 175, 90, 48, 24) and loses its order late and at the fine end
(last part: 25,500, 16,149, 9,470, 3,379, 8,775, 22,368). That is the same thing as `half_cheetah`, later and
finer. The second registration asked `ant` only down to 1/16 of the step and over whole episodes, where it was
still in order.

**Which part of contact** (exploratory):

- Friction off, `half_cheetah`: the coarse gaps fall in every part but readings 20-40, where the third rises a
  little (3,116 then 3,332), and the finest rises again (readings 40-80: 14,869, 8,304, 6,559, then 14,637). The
  most iterations any solve needs drops from 178 to 6, so friction is what makes the solves hard. Friction is part
  of it and not all of it.
- Friction off, `ant`: the chain is the chain without ground almost to the count early in the episode, and stays in
  order but for the finest gap late (last part: 27,608, 18,520, 5,260, 5,336).
- Contact a hundred times softer, `half_cheetah`: the chain stays in order a little longer into the episode and is
  then further out of order than before (last part: 17,198, 20,695, 32,287, 49,157). A softer contact is not a
  cure.
- Friction falling away ten times more gradually: on `half_cheetah` the shipped chain almost number for number; on
  `ant` the same early in the episode, and apart by up to about three times late at the fine end (readings 160-200,
  1/8 against 1/16: 9,766 against 3,379). The width of the friction law is not what limits it.
- Softer contact on `ant`: in order early, out of order late (last part: 17,599, 13,512, 16,714, 15,334).
- The softest contact (`k5_`) was stopped after three sources because it played slowly; what there is of it is in
  the files.
- None of these is a cure. What the ground does to refinement is not located further here.

**The second registration's own streams, read again by plain subtraction** (`old_streams.txt`; 108 episodes; the
instrument's sizes in this table are that registration's own record):

| Cell of the second registration | The instrument's sizes | Plain subtraction |
|---|---|---|
| `half_cheetah` time step, fold 0 | 4,390,727; 3,590,152; 4,855,786; 7,158,702 | 4,408,507; 3,595,249; 4,861,806; 7,192,479 |
| `half_cheetah` contact smoothing, fold 0 | 770,013; 483,295; 277,291; 157,462; 172,908 | 823,125; 530,790; 330,215; 202,130; 223,540 |
| `ant` solver ladder, fold 1, limits 8 and 16 | 242,122 then 591,273 | 328,531 then 673,129 |

The instrument's sizes are the plain sizes, a little lower where its gate leaves windows out, and in the same
order. Each of these order failures is present in the subtraction.

By part of the episode, `half_cheetah`'s time-step chain in those streams halves for the first ten readings (2,644,
1,450, 742, 404), is still in order at readings 10 to 20, and is out of order from reading 20 on. `cart_pole`
halves through reading 40. `ant` falls in every part.

The third registration's harness was then dry-run on three of those lists (`half_cheetah` time step and contact
smoothing, `ant` solver ladder: nine cells), with noise that no registration uses. In all nine cells the
instrument and plain subtraction order alike, the failing `ant` fold among them. That output is the second half
of `old_streams.txt`.
