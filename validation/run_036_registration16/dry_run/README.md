# The sixteenth registration's dry run

Played before the sixteenth registration was committed, with throwaway numbers (mass, size, friction, push, move and
the viscous landing changed), to check the corrections part and the new 32-bit rig. Nothing here decides anything.
`play_dry16.sh` is the script as it was played, with placeholders for the local folders it named; `runs/` is
what it wrote. `reading.txt` was made again from those files after run 036, by the script's own reading lines (the
plays are not repeated). The registration cites its figures: on build 15 the viscous landings with and without patch
F were byte-identical at both steps and on build 14 they differed; after the move build 15's cube moved with the push
at 110 micrometres a second and build 14's was pulled back at 189; no step of either build stopped or diverged; and
`cart_pole` with an iteration limit of 3 gave the same bytes on `tools/sdx_player32` with build 15 in 32-bit as on the
stock 32-bit rig and library.
