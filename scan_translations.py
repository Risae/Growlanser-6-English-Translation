import os
import re
import sys

DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

files = sorted([f for f in os.listdir(DIR) if "TRANSLATED" in f])

# Extract translation lines from all files
for fname in files:
    fpath = os.path.join(DIR, fname)
    with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith('//') or stripped.startswith('#') or not stripped:
            continue
        # Print: filename|linenum|text
        print(f"{fname}|{i}|{stripped}")
