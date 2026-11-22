# Handoff: after the Sonnet Arcade (21 Nov 2026, written by Sonnet 5.5 before a /clear)

Read first: `README.md` (what exists), `IDEAS.md` (ten ideas, 5 built), this file (what is next).
Memory notes to read: sonnet-arcade, two-engines, lib-games, review-dashboard, plain-git-and-python.

## State
* `LIB_LLMOUT` main has the whole `Sonnet/` folder (merged 21 Nov at the owner's word, NOT pushed). The
  parent repo's `.gitignore` keeps only READMEs; `Sonnet/.gitignore` re-includes everything in this folder.
  The owner also built `Sonnet/build/SonnetLauncher/SonnetLauncher.exe` (his build, committed with it).
* Nothing in LIB_GAMES / LIB_DEV was changed by the Arcade.

## Job A (owner's next order): PERFECT DotMaze, in steps, with FPS on screen
File: `LIB_GAMES/Vibecode3D_Games/Vibecode3D_Play_DotMaze.livecodescript` (240 lines, 19x13 maze, `kCell` 40,
walls = one `Mesh.Box` entity each, dots = one `Mesh.Box(6,6,6)` entity each in `sDot[c,r]`, chasers, 5 levels).
Owner: "the FPS of the first version is terrible, make it smooth as light, step by step."
Rules: one step at a time, each step MEASURED and shown on screen (`HUD.Set "Maze.FPS", "FPS" && Engine.Info("fps")`)
and written to a table in `LIB_GAMES/Vibecode3D_Games/DotMaze/PERF.md` (step, what changed, fps, headless step ms).
Keep a copy of the original as step 0 (the baseline number first: run it on the real engine, 
`tests/engine_play.sh`-style, or `LIB_GAMES/tools/engine_play.sh DotMaze Maze "0:60"`).

Why it is slow (from reading `LIB_DEV/livecode/game_player.livecodescript` Player.Draw): every entity is
projected vertex by vertex in xTalk and every edge goes into a per-colour polyline graphic. ~250 dots x 12 edges
+ ~100 wall boxes x 12 edges per frame, all static.

### Step 1 (the owner's idea): dots as MARKER INSTANCES, walls as ONE line object
* **markerPoints test, done 21 Nov** (`tests/markerpoints_test.lc`, run with `lcmcp --standalone run -`):
  for a polygon graphic with `markerDrawn` true, `lineSize` 0 and `markerFilled` true:
  - `the points` = WHERE the markers go (one per vertex: the dot positions, a star field, trees, clutter).
  - `the markerPoints` = the SHAPE that is stamped at each of those points (a small outline, e.g.
    `-2,-2 / 2,-2 / 2,2 / -2,2 / -2,-2`). The 3D shape data goes in markerPoints, not in points.
    (I first had it the wrong way round and got scribbles: 5000-point shape stamped on 3 points.)
  - `markerLineSize` 1 draws the stamped outline thin; `hiliteColor` colours the marker, `foregroundColor` the line.
  - Cost with the stack visible: 200 dots 2 ms, 1000 dots 6.7 ms, 3000 dots 18.8 ms for set + redraw (0.15 / 0.8 /
    2.95 ms for the set alone, screen locked). One line graphic of 1000 separate segments (points with a BLANK LINE
    between segments: `x1,y1 & cr & x2,y2 & cr & cr & x3,y3 ...`) cost 39 ms per set + redraw: so lines are the
    expensive part, not points. Walls: draw them ONCE (static) in one blank-line-separated line graphic and do not
    touch it per frame; only set it when the level changes.
  - Note LiveCode counts `the number of lines of the markerPoints` as n+1 when the string ends with a return: build
    strings without a trailing return.
* The player (Engine 1 host) draws only polylines per colour. A "marker batch" call has to be added to the engine
  side: suggested contract addition `Dots.Set pId, pPoints, pColor, pShape` (pPoints = world x,y,z a line each;
  the host projects them and sets `the points` of one pooled marker graphic) and `Dots.Remove pId`. It is a
  contract change: write it in `LIB_ig3d/ENGINE_CONTRACT.md` (tables with `<!-- contract:... -->` marks, XT = add
  until built), implement in `LIB_DEV/livecode/game_player.livecodescript` (Player.Draw) and
  `xt3D_Raylib_Livecode_Bridge/testbench/vibe_xt3d_overrides.livecodescript` (NEVER edit the generated
  `vibe_engine_xt3d.livecodescript`; see two-engines), add a stub in `LIB_GAMES/tools/engine_stubs.livecodescript`
  and make `contract_check.py --stubs` pass. Ask the owner before changing the contract (he answered the last
  five questions on 17 Nov): put the question in FOR_REVIEW.
* Static dots never move: project them once per level (camera is fixed in DotMaze), remove one by deleting its line
  from the string when eaten (`delete line n`), so a frame costs one `set the points`.

### Later steps (each measured): chasers/player as few meshes; HUD only when text changes (see `sHUDWas`);
tile logic with arrays not strings; `gV3DTickMS`; level data from a string; chaser path via a distance field computed once per
player cell change; stop calling `Entity.SetPosition` for things that did not move.

## Job B: ten more games (after A, or when the owner says)
Rungs 4, 7, 8, 9, 10 of IDEAS.md are unbuilt: ICE PROMPT, CODE SCROLL, THE CONE'S CHOIR, THE HOPE ENGINE, THE LONG RUN.
Five more ideas to write first (one-liners in IDEAS.md, then build in this order, simple to complex):
1 STARFIELD COUNT (marker-point star field: tap Space when the star pattern matches the Probe's; shows what markers can do),
2 TREE MAP (a forest as marker points: Squad C must find the one tree the Cone has re-parsed),
3 PROBE POOL (Probe ricochet puzzle on a 1-bit grid), 4 BARTER ROW (Glaze trades dots in a market, stamina as money),
5 RUNTIME REVOLUTION (never; "no Runaway Runtime Revolution": two copies max stays the rule).
Build the same way as the Arcade: `src/gNN_*.part` + `build.py`, headless bot tests in `tests/`, engine run + snapshot,
README caveats honest. Add each to the Arcade menu (`Arcade.Pre/Title/Blurb/LinesOf`, five becomes ten: the menu needs two pages).

## Traps met (all in the memory note sonnet-arcade too)
single-line `if..then x` followed by `else` binds the else to it (also in test bodies); `tOp` is a keyword; boolean*number
errors; `repeat for each item n in "literal"` fails (put the list in a variable first); `update stack` is not a command
(use `wait 0 milliseconds with messages`); real-engine test runs: wait ~6 s between runs and hold keys 4-5 steps
(66 ms is not always one game step); HUD font has only A-Z 0-9 : - + . ! / ^ ? , ' and space.
