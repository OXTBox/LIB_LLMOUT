# The Sonnet Arcade

Sonnet 5.5, 21 Nov 2026. Ten game ideas for the Prompt / Probe / Glaze / Cone / Squad C /
Runaway Runtime lore (`IDEAS.md`), and five of them built as playable Vibecode3D cards with a
small launcher of their own.

| Ladder rung | Game | Card |
|---|---|---|
| 1 | NONSENSE RAIN (Probe vs Cone) | `Vibecode3D_Play_SonnetRain` |
| 2 | THE PASSWORD (Probe + Glaze barter) | `Vibecode3D_Play_SonnetPassword` |
| 3 | GLAZE OVER (charm ring) | `Vibecode3D_Play_SonnetGlaze` |
| 5 | RUNAWAY RUNTIME (two copies, one brain, 5 rooms) | `Vibecode3D_Play_SonnetRuntime` |
| 6 | SQUAD SHUFFLE (Squad C) | `Vibecode3D_Play_SonnetSquad` |
| all | THE SONNET ARCADE: menu with all five, a 14-line sonnet that you win line by line | `Vibecode3D_Play_SonnetArcade` |

Ideas 4, 7, 8, 9 and 10 (ICE PROMPT, CODE SCROLL, THE CONE'S CHOIR, THE HOPE ENGINE, THE LONG RUN)
are written up in `IDEAS.md` only.

## Play it

Any LiveCode / OXT-Beyond Message Box that can reach the files (the Game_Player and its engine
library are used as they are; nothing in LIB_GAMES or LIB_DEV is changed):

```
start using stack "//wsl$/Ubuntu/home/igame3d/projects/LIB_LLMOUT/Sonnet/sonnet_launcher.livecodescript"
put Sonnet.Open("SonnetArcade")
```

`Sonnet.Open "SonnetRuntime"` (or Rain, Password, Glaze, Squad) opens one game alone. The menu:
UP DOWN + SPACE or 1-5; **M** comes back to the menu; Escape pauses (the player's). Keyboard only,
no mouse, no files, no sound. Win a game and its three lines of the sonnet appear on the menu.

If you would rather have the cards in the real Vibecode3D stack or the games list, copy
`cards/Vibecode3D_Play_*.livecodescript` into `LIB_GAMES/Vibecode3D_Games/` (your call; I did not).

## How it is made

* `src/*.part` are the source: `00_core` (keys, clean-up, HUD helpers), `g01`..`g05` one game
  each (own prefix `Rain.` `Password.` `Glaze.` `Runtime.` `Squad.`), `90_arcade` (the menu),
  `91_solo` (the thin card wrapper for single games).
* `python3 -I build.py` writes `cards/` (6 files). **Edit `src`, never `cards`.**
* Engine contract only (`python3 -I LIB_ig3d/tools/contract_check.py cards/*.livecodescript`
  says 0 debts). Two engines note: these are Engine-1 cards (pure xTalk Vibecode3D); the
  Game_Player runs them on its xt3d-drawn Engine 1 library.
* The shape of every game is `Pre.Start`, `Pre.Step` (every 33 ms), `Pre.State()`.

## Tested

`python3 -I tests/run_all.py` (9 of 9 pass): LiveCode 9.6.3 server in WSL, engine stand-ins in
`tests/stubs.livecodescript`, no window. It plays each game with a bot and with no input
(Rain idle loses, Rain bot wins; Glaze idle loses, bot wins; Squad bot wins perfectly; Password:
the scoring rule on five known cases, a won game, a lost game, a barter; Runtime: the solver's
solutions for all five rooms play through to a win; Arcade: menu, entering and leaving every game,
the sonnet reveal). The stand-ins also count calls on dead objects and HUD letters the vector font
lacks (both zero).

The Runtime rooms (`tests/runtime_levels.txt`) were proved winnable by a breadth-first solver
(`tests/run_solver.py`, same rules as the card). Shortest solutions: 6, 12, 12, 13 and 20 moves.

On the real engine (`tests/engine_play.sh`, LIB_MCP test standalone, snapshots of the game's own
card): all five games and the menu start and run at 20 to 25 fps and the HUD fits the 900 px
window. Seen on screen: the menu with a partly revealed sonnet, Rain, Password, Glaze (a converted
guard), Runtime rooms 1 and 5, Squad.

## Not tested / honest caveats

* **Played by no human.** The balance is from bots: Glaze Over is won by a simple bot 4 of 5 seeds,
  Nonsense Rain by a careful one with 2 lives to spare. Expect to tune numbers (they are
  constants at the top of each part) once you have played.
* Squad C and Runaway Runtime lore is what I found in the repos plus my inventions (the soldiers'
  roles, the Cone's cones, the sonnet). Fix freely.
* On the real engine the harness, not the games, was flaky: starting a second test run within a
  few seconds of the last one (same window name) sometimes lost the new window ("Chunk: no such
  object"). Leave 6 seconds between runs.
* The first snapshot of Squad showed two games' HUD at once: a failed Runtime test run had left its
  window running in the same standalone. Not a game bug; the harness now leaves a gap.
* Entity.SetColor / SetMesh / Camera.WorldToScreen are used: they are in the contract and in the
  Game_Player's engine; the Vibecode3D stack's own engine library predates them (not checked in the
  stack).

## Cards in the review list

`LIB_LLMOUT/FOR_REVIEW.txt` lists the six cards, the launcher, IDEAS and this README.
