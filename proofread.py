import os
import re

BASE_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

# Collect all translated files
translated_files = [f for f in os.listdir(BASE_DIR) if '[TRANSLATED]' in f]
translated_files.sort()

# Extract English lines
def get_english_lines(filepath):
    lines = []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            for i, line in enumerate(f, 1):
                stripped = line.rstrip('\n')
                s = stripped.strip()
                if not s:
                    continue
                if s.startswith('//'):
                    continue
                if s.startswith('#'):
                    continue
                lines.append((i, stripped))
    except Exception as e:
        pass
    return lines

# Remove game control codes for spell checking
CODE_PATTERN = re.compile(r'\[[^\]]*\]')
def clean_for_check(text):
    return CODE_PATTERN.sub(' ', text)

# Known game-specific terms to ignore
GAME_TERMS = {
    'rana', 'yurii', 'schizarz', 'dastis', 'monopolis', 'leystan', 'goatland',
    'felmentia', 'zaramba', 'totuwa', 'geilenach', 'juwaina', 'zerdok', 'rio',
    'warslee', 'jaergen', 'royferon', 'makinus', 'fomeros', 'lennox', 'pothrad',
    'yarstill', 'kaiser', 'hingis', 'transgate', 'mil', 'futon', 'steed',
    'scen', 'scec', 'stxt', 'pmb', 'npc', 'cc', 'nline', 'nwin', 'col',
    'maincharname', 'teardown', 'musknote', 'growlanser', 'celestial',
    'guardians', 'yurii', 'rana', 'malt', 'jio', 'mervina', 'soltier',
    'beldine', 'gardios', 'vaynard', 'silmeria', 'carmaine', 'wein', 'sherris',
    'ferim', 'vansen', 'dryst', 'senia', 'clarett', 'celes', 'laffine',
    'haschen', 'wein', 'charlone', 'zelos', 'chacole', 'eliotte', 'laffine',
    'andie', 'tippi', 'dehl', 'dorris', 'emilita', 'rind', 'selis', 'velhart',
    'espie', 'lana', 'cleo', 'lena', 'garyu', 'dios', 'geo', 'geo',
    'blaze', 'strom', 'solt', 'zekell', 'zekelll',
    # Sound effects / expressions
    'aaah', 'ahh', 'ahhh', 'ahhhh', 'hm', 'hmm', 'haha', 'hahaha',
    'keh', 'tch', 'urk', 'ugh', 'pfft', 'grr', 'ngh', 'hyah',
    'whoa', 'woah', 'argh', 'gah', 'bah', 'hmph', 'huh', 'eh',
}

print("Extracting English dialogue from", len(translated_files), "files...\n")
all_lines = []
for fname in translated_files:
    filepath = os.path.join(BASE_DIR, fname)
    lines = get_english_lines(filepath)
    for lineno, text in lines:
        all_lines.append((fname, lineno, text))

print(f"Total English lines: {len(all_lines)}\n")

# Output all English lines for manual review
for fname, lineno, text in all_lines:
    print(f"FILE:{fname}|LINE:{lineno}|{text}")
