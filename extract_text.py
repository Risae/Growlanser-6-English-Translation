import re

BASE = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

files = [
    "00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]",
    "00000032.SCEN CHAPTER 2.4 (Dastis City) [TRANSLATED]",
    "00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]",
    "00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]",
    "00000037.SCEN CHAPTER 13.1 (Leystan 2) [TRANSLATED]",
    "00000038.SCEN CHAPTER 14.3 (Royferon) [TRANSLATED]",
    "00000040.SCEN CHAPTER 15.1 (El Hingis) [TRANSLATED]",
    "00000041.SCEN CHAPTER 16.3 (Great Land Village) [TRANSLATED]",
]

# Match all control codes comprehensively
CTRL_PATTERN = re.compile(
    r'\[(?:END-F[EF]|NLINE|NWIN|COL0[0-9]|CHAR[0-9A-Fa-f]{2,4}|V[0-9A-Fa-f]{2,4}|'
    r'CC\.[0-9A-Fa-f]{2,6}|CH\.FACE:[^\]]+|MUSIC-NOTE|TEAR-DROP|TRIANGLE|START|L1|R1|L2|R2|'
    r'W32\([^\)]+\)|JMP\([^\)]+\)|HDR\([^\)]+\))\]'
)
# Also strip "・" bullet points
def strip_controls(text):
    t = CTRL_PATTERN.sub('', text)
    return t.strip()

for fname in files:
    fpath = f"{BASE}/{fname}"
    with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    for lineno, line in enumerate(lines, 1):
        raw = line.rstrip('\n')
        if not raw.strip():
            continue
        if raw.strip().startswith('//'):
            continue
        if raw.strip().startswith('#'):
            continue
        clean = strip_controls(raw)
        # Remove bullet point
        clean = clean.replace('・', '').strip()
        if not clean:
            continue
        # Skip lines that are just game mechanics labels (single words like "Orders", "Manager", etc.)
        # Still print them for review
        print(f"{fname}|{lineno}|{raw.strip()}")
