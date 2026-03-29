#!/usr/bin/env python3
import os, re, sys

SCEN_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT/"
FILE_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_FILE.DAT/"

def is_command_line(line):
    stripped = line.strip()
    if not stripped: return True
    if stripped.startswith('//'): return True
    if stripped.startswith('#'): return True
    text_without_brackets = re.sub(r'\[[^\]]*\]', '', stripped).strip()
    if not text_without_brackets: return True
    return False

def extract_text_from_line(line):
    text = re.sub(r'\[[^\]]*\]', '', line)
    text = re.sub(r'^#[^\s]*(\([^)]*\))?', '', text)
    return text.strip()

output = []
for dirpath in [SCEN_DIR, FILE_DIR]:
    if not os.path.exists(dirpath): continue
    for filename in sorted(os.listdir(dirpath)):
        if not ('[TRANSLATED]' in filename or '[EDITED]' in filename): continue
        if filename.endswith('.asm'): continue
        filepath = os.path.join(dirpath, filename)
        try:
            with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
                for lineno, raw_line in enumerate(f, 1):
                    line = raw_line.rstrip('\n\r')
                    if is_command_line(line): continue
                    text = extract_text_from_line(line)
                    if text:
                        output.append(f"{filename}\t{lineno}\t{line.strip()}\t{text}")
        except Exception as e:
            print(f"Error: {filename}: {e}", file=sys.stderr)

for o in output:
    print(o)
