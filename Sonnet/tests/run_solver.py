#!/usr/bin/env python3
"""Runaway Runtime rule mirror + BFS solver. Same rules as src/g04_runtime.part.
Tiles: # wall . floor S spawn E exit X hang  B pad  D door (open while a copy stands on B or Y)
       Y hang-pad (hangs the copy that enters AND counts as a pad)
Copies: list of (x,y,hung); max 2. Actions: U D L R, S spawn, K retire (oldest hung copy)."""
import sys
from collections import deque

def load(rows):
    g = {}
    spawn = None
    for y, r in enumerate(rows):
        for x, c in enumerate(r):
            g[(x, y)] = c
            if c == 'S': spawn = (x, y)
    return g, spawn

DIRS = {'U': (0, -1), 'D': (0, 1), 'L': (-1, 0), 'R': (1, 0)}

def door_open(g, copies):
    return any(g.get((x, y)) in ('B', 'Y') for x, y, h in copies)

def step(g, spawn, copies, a):
    copies = list(copies)
    if a == 'S':
        if len(copies) >= 2: return None
        if any((x, y) == spawn for x, y, h in copies): return None
        copies.append((spawn[0], spawn[1], False)); return tuple(copies)
    if a == 'K':
        for i, (x, y, h) in enumerate(copies):
            if h:
                del copies[i]; return tuple(copies)
        return None
    dx, dy = DIRS[a]
    open_ = door_open(g, copies)
    for i, (x, y, h) in enumerate(copies):
        if h: continue
        nx, ny = x + dx, y + dy
        t = g.get((nx, ny), '#')
        if t == '#': continue
        if t == 'D' and not open_: continue
        if any((cx, cy) == (nx, ny) for j, (cx, cy, ch) in enumerate(copies) if j != i): continue
        hung = t in ('X', 'Y')
        copies[i] = (nx, ny, hung)
    return tuple(copies)

def won(g, copies):
    return any(g.get((x, y)) == 'E' and not h for x, y, h in copies)

def solve(rows, limit=200000):
    g, spawn = load(rows)
    start = ((spawn[0], spawn[1], False),)
    seen = {start: ''}
    q = deque([start])
    while q and len(seen) < limit:
        s = q.popleft()
        if won(g, s): return seen[s]
        for a in 'UDLRSK':
            n = step(g, spawn, s, a)
            if n is None or n in seen or n == s: continue
            seen[n] = seen[s] + a
            q.append(n)
    return None


def read_levels(path):
    out=[];cur=[]
    for line in open(path).read().split("\n"):
        if line.strip()=="" :
            if cur: out.append(cur);cur=[]
        else: cur.append(line.rstrip())
    if cur: out.append(cur)
    return out

if __name__ == '__main__':
    path = sys.argv[1]
    for i, rows in enumerate(read_levels(path), 1):
        w = {len(r) for r in rows}
        sol = solve(rows)
        print(i, 'width', w, 'solution', sol, len(sol) if sol is not None else None)
