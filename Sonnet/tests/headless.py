#!/usr/bin/env python3
"""Run a Sonnet Arcade card headless on the LiveCode 9.6.3 server (no window, no mouse).
   python3 -I headless.py <card file name stem> <body.lc>
The body is LiveCode that may use the stubs (tests/stubs.livecodescript) and ends with `return tLog`.
It runs after Game.OnStart. Helper: T.Step "keys" = one 33 ms step with those key codes held."""
import os, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
LIB_BIN = os.path.expanduser('~/projects/LIB_BIN')
SERVER = os.path.join(LIB_BIN, 'livecode-server', '9.6.3-linux-x64', 'livecode-community-server')
CARDS = os.path.join(HERE, '..', 'cards')

RUNNER = """<?lc
create stack "T"
put url "binfile:%(stub)s" into tS
delete line 1 of tS
put url "binfile:%(body)s" into tBody
put tS & cr & "function RunTest" & cr & "local tLog" & cr & tBody & cr & "end RunTest" into tAll
set the script of stack "T" to tAll
put the result into tErr1
set the script of card 1 of stack "T" to url "binfile:%(card)s"
put the result into tErr2
if tErr1 is not empty or tErr2 is not empty then
  put "COMPILE ERROR (stubs+body): " & tErr1 & " card: " & tErr2
else
  try
    dispatch "Game.OnStart" to card 1 of stack "T"
    dispatch function "RunTest" to stack "T"
    put the result
  catch tE
    put "THREW: " & line 1 to 8 of tE
  end try
end if
?>
"""

def run(card, bodyfile):
    with tempfile.TemporaryDirectory() as tmp:
        r = os.path.join(tmp, 'run.lc')
        card_path = os.path.abspath(os.path.join(CARDS, 'Vibecode3D_Play_%s.livecodescript' % card))
        open(r, 'w', newline='\n').write(RUNNER % dict(stub=os.path.join(HERE, 'stubs.livecodescript'), card=card_path, body=os.path.abspath(bodyfile)))
        out = subprocess.run([SERVER, r], capture_output=True, text=True, timeout=300)
    return (out.stdout + out.stderr).strip()

if __name__ == '__main__':
    print(run(sys.argv[1], sys.argv[2]))
