#!/usr/bin/env python3
"""Run every headless Sonnet Arcade test (LiveCode 9.6.3 server, stand-ins in stubs.livecodescript).
   python3 -I tests/run_all.py          builds nothing; run ../build.py first
Each line below is: card, test body, a text that must be in the output. Every run must also end
with an empty 'bad:' (no call on a dead object) and an empty 'badhud:' (no letter the HUD font lacks)."""
import os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import headless

CASES = [
    ('SonnetRain',     't_rain_idle.lc',          'lost'),
    ('SonnetRain',     't_rain_bot.lc',           'bot ended after'),
    ('SonnetPassword', 't_password.lc',           'after the right throw: won'),
    ('SonnetGlaze',    't_glaze_idle.lc',         'lost'),
    ('SonnetGlaze',    't_glaze_bot.lc',          ': won 12'),
    ('SonnetRuntime',  't_runtime_solutions.lc',  'room 5 solution'),
    ('SonnetSquad',    't_squad_idle.lc',         ': lost'),
    ('SonnetSquad',    't_squad_bot.lc',          ': won 16'),
    ('SonnetArcade',   't_arcade.lc',             'won count 2'),
]

def main():
    bad = 0
    for card, body, must in CASES:
        out = headless.run(card, os.path.join(HERE, body))
        ok = must in out and 'THREW' not in out and 'COMPILE ERROR' not in out
        for l in out.split('\n'):
            if l.startswith('bad:'):
                rest = l[len('bad:'):].split(' ents:')[0]
                bad_calls, _, bad_hud = rest.partition('badhud:')
                ok = ok and bad_calls.strip() == '' and bad_hud.strip() == ''
        if body == 't_runtime_solutions.lc':
            ok = ok and all(('room %d' % n) in out for n in range(1, 6)) and out.count(': won ') == 5
        if body == 't_password.lc':
            ok = ok and out.count('(want') == 5 and all(
                l.split(': ')[1].split(' (')[0] == l.split('want ')[1].rstrip(')')
                for l in out.split('\n') if '(want' in l)
        print(('PASS ' if ok else 'FAIL ') + card + ' ' + body)
        if not ok:
            bad += 1
            print(out[:800])
    print('%d of %d passed' % (len(CASES) - bad, len(CASES)))
    return 1 if bad else 0

sys.exit(main())
