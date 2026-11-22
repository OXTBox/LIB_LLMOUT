#!/usr/bin/env python3
"""Compile a card script handler by handler on the 9.6.3 server to find which one fails."""
import re, subprocess, sys, tempfile, os
SERVER = os.path.expanduser('~/projects/LIB_BIN/livecode-server/9.6.3-linux-x64/livecode-community-server')
text = open(sys.argv[1]).read()
parts = re.split(r'\n(?=(?:on|function|command) )', text)
header = parts[0]
def compile_text(t):
    with tempfile.TemporaryDirectory() as d:
        open(d+'/s.txt','w').write(t)
        open(d+'/r.lc','w').write('<?lc\ncreate stack "Z"\nput url "binfile:%s/s.txt" into tS\nset the script of stack "Z" to tS\nput the result\n?>' % d)
        return subprocess.run([SERVER, d+'/r.lc'], capture_output=True, text=True).stdout.strip()
# declarations (locals/constants/globals) before the first handler
decl = '\n'.join(l for l in header.split('\n') if re.match(r'(local|global|constant)\b', l))
for p in parts[1:]:
    name = p.split('\n')[0]
    r = compile_text(decl + '\n' + p)
    if r: print('FAIL', name, '->', r.replace('\n',' | '))
print('checked', len(parts)-1, 'handlers')
