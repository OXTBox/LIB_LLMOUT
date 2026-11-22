#!/usr/bin/env bash
# engine_play.sh - play one Sonnet card on the REAL engine (the Game_Player's engine library) in
# LIB_MCP's test standalone (port 8767), the way LIB_GAMES/tools/engine_play.sh does for LIB_GAMES.
#   tests/engine_play.sh <Card> <StateFunction> "<keys>:<steps> ..." [snap.png]
#   e.g. tests/engine_play.sh SonnetRain Rain.State "65363:30 0:10" C:/LIB_MCP/rain.png
# The card is opened by sonnet_launcher.livecodescript (Sonnet.Open). A key list is held through
# Arc.TestKeys for that many 33 ms steps. A snapshot is of the game's own card, never the screen.
CARD="$1"; STATEFN="$2"; PLAN="$3"; SNAP="${4:-}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
LCMCP="$HERE/../../LIB_MCP/tools/lcmcp"
ERRS="$HERE/../../LIB_LLMIN/LIB_DEV/GAME_PLAYER_ERRORS.txt"
BEFORE=0; [[ -f "$ERRS" ]] && BEFORE=$(wc -l < "$ERRS")
{
cat <<LC
put "//wsl\$/Ubuntu/home/igame3d/projects" into tP
if not ("SonnetLauncher" is among the lines of the stacksInUse) then start using stack (tP & "/LIB_LLMOUT/Sonnet/sonnet_launcher.livecodescript")
put Sonnet.Open("$CARD", "Sonnet") into tWhy
if tWhy is not empty then return "OPEN FAILED: " & tWhy
put "Play $CARD" into tS
wait 400 milliseconds with messages
put "start: " & value("$STATEFN()", card 1 of stack tS) & cr into tLog
LC
for step in $PLAN; do
  K="${step%%:*}"; N="${step##*:}"
  if [[ "$K" == !* ]]; then   # !Handler:arg dispatches a test handler, e.g. !Runtime.GoLevel:5
    echo "if there is a stack tS then dispatch \"${K#!}\" to card 1 of stack tS with \"$N\""
    continue
  fi
  cat <<LC
if there is a stack tS then
  dispatch "Arc.TestKeys" to card 1 of stack tS with "$K"
  wait $N * 33 milliseconds with messages
  put "$K x$N: " & value("$STATEFN()", card 1 of stack tS) & cr after tLog
end if
LC
done
cat <<LC
if there is a stack tS then
  put "fps: " & field "PlayerStatus" of stack tS & cr after tLog
LC
[[ -n "$SNAP" ]] && echo "  export snapshot from card 1 of stack tS to file \"$SNAP\" as PNG"
cat <<LC
  dispatch "Arc.TestKeys" to card 1 of stack tS with empty
  close stack tS
end if
return tLog
LC
} | timeout 110 "$LCMCP" --standalone run - | sed 's/^result: //'
AFTER=0; [[ -f "$ERRS" ]] && AFTER=$(wc -l < "$ERRS")
if [[ "$AFTER" -gt "$BEFORE" ]]; then echo "ERRORS:"; tail -n $((AFTER - BEFORE)) "$ERRS" | tr '/' '\n' | head -12; fi
