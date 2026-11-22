# Ten ideas: Prompt, Probe, Glaze, the Cone, Squad C and the Runaway Runtimes

By Sonnet 5.5, 21 Nov 2026. A ladder from one rule to a whole campaign. **[BUILT]** = playable in the
Sonnet Arcade (this folder); the rest are ideas only.

Lore I could find in the repos: PROMPT = cyan, gets the job done no matter what; GLAZE = magenta,
barter / charm / influence; PROBE = the logic-probe spear; the CONE = purple boss behind rings of
shield cubes and a password; SQUAD = the three-soldier buggy crew; RUNAWAY RUNTIME = disposable
runner copies, never more than two at a time (a hung one is replaced by a fresh copy), "be
respectful of LiveCode's legacy". I found no written Squad C story beyond Squad Buggy, so the
three soldier roles and the Cone's "nonsense code" being cones are **my inventions**. Correct
them freely.

Rule of the ladder: every idea has one sentence you could say out loud, and each rung adds exactly
one new thing the player has to hold in their head.

| # | Name | Cast | The one rule | Rung |
|---|------|------|--------------|------|
| 1 | **NONSENSE RAIN** [BUILT] | Probe vs Cone | Slide the Probe under falling code. Cubes are valid, cones are nonsense. Some tokens *re-parse* (flash white, then swap type) halfway down. | 1 axis, 1 rule |
| 2 | **THE PASSWORD** [BUILT] | Probe, Glaze | Mastermind against the Cone: guess a 4-symbol password in 8 throws; gold = right symbol right slot, white = right symbol wrong slot. GLAZE can *barter*: pay two throws for one slot revealed. | 1 screen of thinking |
| 3 | **GLAZE OVER** [BUILT] | Glaze, Cone's guards | Hold Space to grow a charm ring, let go to convert every guard inside it. A bigger ring costs more stamina and gives the guards longer to reach you. Converted guards take the next hit for you. | risk vs reward |
| 4 | **ICE PROMPT** | Prompt | Prompt cannot stop: once moving he slides until something is in the way ("no matter what"). Push shield cubes, wedge the Cone's code into walls, never choose a speed. | movement as the puzzle |
| 5 | **RUNAWAY RUNTIME** [BUILT] | the Runtime, two copies | One input drives every copy at once. Space starts a fresh copy (never more than two); a copy that steps on a HANG tile freezes and keeps its slot until you retire it. A frozen copy still weighs down a pad. Five rooms, all proved solvable. | two bodies, one brain |
| 6 | **SQUAD SHUFFLE** [BUILT] | Squad C | Three soldiers ride in three lanes. Gates come down the lanes and each needs the soldier of its shape. Rotate and swap the formation before the gates land. Mid-way the Cone re-parses a gate. | a permutation in real time |
| 7 | **CODE SCROLL** | Prompt, Cone | The level *is* a script. Each line of real xTalk is a platform as wide as the line; lines the Cone has corrupted are holes. Run along `on mouseUp`, drop through `end if`. The HUD text and the floor are the same thing. | the screen as the level |
| 8 | **THE CONE'S CHOIR** | Probe, Cone | A rhythm boss. The Cone sings nonsense at a tempo; you throw on the off-beat to hit the gaps. Each shield ring is a bar of music, the password is the tune. | timing as shield |
| 9 | **THE HOPE ENGINE** | Prompt, Glaze | The note under the whole project: *train them, let them hope, then blow them away.* Win three games in a row with a hope meter rising; the fourth is rigged, and the runtime **fakes its own crash**: freeze, "NOT RESPONDING", then the run-away copy (test2) resumes with hope reset. The crash is the level. | a game about the player's mood |
| 10 | **THE LONG RUN** | Everyone | The campaign. Stamina persists across the nine games above, played as rooms of one long corridor; the Cone's password is spread across them as keys. Two runtimes at a time, never three: a third copy kills the oldest. | the whole arcade as one level |

## Why this order

1 and 2 are *one rule* games you can teach in a sentence (good tutorial cards for the engine).
3 and 4 add the character: GLAZE's charm and PROMPT's inability to stop are verbs the other games
can borrow. 5 and 6 add structure (two bodies / three bodies). 7 to 9 are the avant-garde bunch:
the level is text, the boss is a tempo, the game lies about crashing. 10 stitches them.

## What I would build next

7 CODE SCROLL, because it only needs the HUD font and a line table, and nothing like it exists
in the arcade. Then 9 as a *wrapper* around any of the others: it needs no new game, only a clock
and a lie.
