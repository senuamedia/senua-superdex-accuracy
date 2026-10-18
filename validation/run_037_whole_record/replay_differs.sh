#!/usr/bin/env bash
# Run 037, after the comparison: the decision the seventeenth registration fixed in advance for a file that differs.
# One play differed of the 2,099: Study 5's ant benchmark under the recommended configuration with SuperDex's
# implicitNormalForceForDissipation (source qi1; its stream and its line of run 013's statistics). It is played again
# here with the same rig and the same settings as run 037 played it (tools/plays/play_05.sh), on:
#   build4   the library kept from the fifth registration's time: library build 4, 77708fa8b023ed18..., built at 02:55 on
#            14 October, before the fifth registration's commit (03:00) and run 013 (committed 04:01); the record does
#            not give its checksum, as the registration said
#   build15  the library of record, again: run 037's own play repeated, to show the play is the same twice
# Each play's stream and STATS line are compared with the registered ones and with run 037's. The library each play
# loaded is recorded from the loader (DYLD_PRINT_LIBRARIES), not assumed.
# usage: replay_differs.sh <clone run 037 played in> <the record> <SuperDex assets> <folder of the kept builds>
set -u
C="$(cd "${1:?usage: replay_differs.sh <clone> <record> <assets> <builds>}" && pwd)"; REF="$(cd "${2:?}" && pwd)"
A="${3:?}"; L="${4:?}"
O="$(cd "$(dirname "$0")" && pwd)/replay"; mkdir -p "$O"
for lib in build4 build15; do
  W="$O/$lib"; rm -rf "$W"; mkdir -p "$W"
  ( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL
    export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003
    DYLD_PRINT_LIBRARIES=1 DYLD_LIBRARY_PATH="$L/bin_$lib" "$C/tools/sdx_player64" ant "$A" "$C/actions/05/ant.txt" \
      "$W/qi1" integ=be maxiter=200 ndamp=5 implicitn=1 < /dev/null > "$W/qi1.out" 2> "$W/loader.txt" )
  grep -o '[^ ]*libmochi_physics_double[^ ]*' "$W/loader.txt" | sort -u > "$W/library.txt"
  shasum -a 256 "$(cat "$W/library.txt")" >> "$W/library.txt"
  sed 's/^STATS/STATS source qi1/' "$W/qi1.out" | grep '^STATS' | sed 's/ wall_s [^ ]*//' > "$W/stats_line.txt"
done
reg_line() { grep '^STATS source qi1 ' "$1" | sed 's/ wall_s [^ ]*//'; }
{
  for lib in build4 build15; do
    W="$O/$lib"
    echo "== $lib: $(head -1 "$W/library.txt")"
    echo "library sha256 $(tail -1 "$W/library.txt" | cut -c1-16)"
    for side in registered:"$REF" run037:"$C"; do
      name="${side%%:*}"; root="${side#*:}"
      if cmp -s "$W/qi1_enc.pcm" "$root/streams/05/ant/qi1_enc.pcm"; then s="SAME"; else s="DIFFERS $(cmp "$W/qi1_enc.pcm" "$root/streams/05/ant/qi1_enc.pcm" | sed 's/.*differ: //')"; fi
      if [ "$(cat "$W/stats_line.txt")" = "$(reg_line "$root/validation/run_013_counts/stats_ant.txt")" ]; then t="SAME"; else t="DIFFERS"; fi
      echo "stream vs $name: $s; STATS line vs $name: $t"
    done
    echo "STATS $(cut -d' ' -f24-29 "$W/stats_line.txt")"
  done
} > "$O/verdict.txt"
cat "$O/verdict.txt"
