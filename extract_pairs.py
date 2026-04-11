import os
import re

base = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"
files = [
    "00000006.SCEN CHAPTER 2.3 [TRANSLATED]",
    "00000007.SCEN CHAPTER 3.3 [TRANSLATED]",
    "00000008.SCEN CHAPTER 8.1 [TRANSLATED]",
    "00000009.SCEN CHAPTER 8.3 [TRANSLATED]",
    "00000010.SCEN CHAPTER 12.2 [TRANSLATED]",
    "00000011.SCEN CHAPTER 14.2 [TRANSLATED]",
    "00000012.SCEN CHAPTER 15.2 [TRANSLATED]",
    "00000014.SCEN CHAPTER 7.3 [TRANSLATED]",
    "00000015.SCEN CHAPTER 16.2 [TRANSLATED]",
    "00000016.SCEN CHAPTER 2.5 (below Dastis City) [TRANSLATED]",
    "00000017.SCEN CHAPTER 7.4 (Pothrad Cave) [TRANSLATED]",
    "00000018.SCEN CHAPTER 7.5 (Transgate center) [TRANSLATED]",
    "00000019.SCEN CHAPTER 8.4 [TRANSLATED]",
    "00000020.SCEN CHAPTER 11.1 (Resistance hideout) [TRANSLATED]",
    "00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [TRANSLATED]",
    "00000022.SCEN CHAPTER 12.1 (Giant) [TRANSLATED]",
    "00000023.SCEN CHAPTER 15.3 (El Hingis HQ) [TRANSLATED]",
    "00000024.SCEN CHAPTER 18.1 (Dragon Tower) [TRANSLATED]",
    "00000025.SCEN CHAPTER 19.1 (Celestial ship) [TRANSLATED]",
    "00000026.SCEN CHAPTER 9.2 (Underground ancient ship) [TRANSLATED]",
    "00000027.SCEN CHAPTER 9.4 (Past Kaiser Island) [TRANSLATED]",
]

for fname in files:
    fpath = os.path.join(base, fname)
    print(f"\n=== FILE: {fname} ===")
    with open(fpath, encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    
    i = 0
    while i < len(lines):
        line = lines[i].rstrip('\n')
        # Check if this is a JP comment line (starts with //)
        # but not a directive line (#VAR, etc.) or POINTER comment
        if line.startswith('//') and not line.startswith('//#') and not line.startswith('//POINTER') and not line.startswith('//STRING'):
            jp_lines = []
            en_lines = []
            lineno = i + 1
            # Collect all consecutive // lines (Japanese)
            while i < len(lines) and lines[i].startswith('//') and not lines[i].startswith('//#') and not lines[i].startswith('//POINTER') and not lines[i].startswith('//STRING'):
                jp_lines.append(lines[i][2:].rstrip('\n'))
                i += 1
            # Now collect all non-// non-blank non-directive lines (English)
            while i < len(lines):
                l = lines[i].rstrip('\n')
                if l.startswith('//') or l.startswith('#') or l.strip() == '':
                    break
                en_lines.append(l)
                i += 1
            
            jp = ' '.join(jp_lines).strip()
            en = ' '.join(en_lines).strip()
            
            if jp and en:  # Only print pairs that have both JP and EN
                print(f"  L{lineno} JP: {jp}")
                print(f"       EN: {en}")
                print()
        else:
            i += 1

