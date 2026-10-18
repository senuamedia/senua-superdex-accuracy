#!/usr/bin/env bash
# Run 038, the eighteenth registration (preregistrations/PREREGISTRATION_18.md): runs 032 and 034 made again whole on
# library build 15, in the fresh clone run 037 played in, with the same rigs (every rig, the *_stock names included,
# loads library build 15), and every file compared with the registered one. The command is the registration's.
# usage: play.sh <clone run 037 played in> <SuperDex assets> <library build 13's folder> <this run's folder>
set -u
C="$(cd "${1:?usage: play.sh <clone> <assets> <build 13 folder> <run folder>}" && pwd)"
O="$(cd "${4:?}" && pwd)"
cd "$C" || exit 2
git log --oneline -1 > "$O/clone_commit.txt"
date -u +%FT%TZ > "$O/started.txt"
SUPERDEX_ASSETS="${2:?}" SUPERDEX_BUILD13="${3:?}" tools/play_identity.sh "$O/identity.txt" r032 r034 > "$O/play.txt" 2>&1
echo "rc $?" > "$O/rc.txt"
date -u +%FT%TZ > "$O/finished.txt"
