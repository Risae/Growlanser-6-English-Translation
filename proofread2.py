import os
import re
from spellchecker import SpellChecker

BASE_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

translated_files = sorted([f for f in os.listdir(BASE_DIR) if '[TRANSLATED]' in f])

CODE_PATTERN = re.compile(r'\[[^\]]*\]')

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
    except Exception:
        pass
    return lines

# Game-specific terms / proper nouns to ignore in spell check
GAME_TERMS = {
    'rana','yurii','schizarz','dastis','monopolis','leystan','goatland',
    'felmentia','zaramba','totuwa','geilenach','juwaina','zerdok','warslee',
    'jaergen','royferon','makinus','fomeros','lennox','pothrad','yarstill',
    'kaiser','hingis','transgate','mil','futon','steed','pmb','npc',
    'growlanser','carmaine','wein','sherris','ferim','vansen','dryst','senia',
    'clarett','celes','laffine','haschen','charlone','zelos','chacole',
    'eliotte','andie','tippi','dehl','dorris','emilita','rind','selis',
    'velhart','espie','lana','cleo','lena','garyu','dios','geo','blaze',
    'strom','solt','zekell','malt','jio','mervina','soltier','beldine',
    'gardios','vaynard','silmeria','celestial','guardians','maincharname',
    # Sound effects
    'aaah','aah','ahh','ahhh','ahhhh','hm','hmm','haha','hahaha',
    'keh','tch','urk','ugh','pfft','grr','ngh','hyah','whoa','woah',
    'argh','gah','bah','hmph','huh','eh','nn','nnn','ff','fe',
    # Abbreviations/codes that leak through
    'nline','nwin','col','addr','cc','r2','r1','endff','endfe',
    # Common fantasy/medieval terms
    'mana','liege','sire','spellcaster','spellcasters','knack','knacks',
    'ore','ores','transgate','transgates','fae','arcana','arcane',
    # Names from game
    'angie','rio','rey','tippi','geo','mil','futondog','cain','abel',
    'sylvia','sylvie','selene','selius','telmon','jenas','gillan',
    'dolce','vira','marsha','sasha','nia','nis','nias','luna','lunae',
    'gillan','telmon','hasse','vira','selh','marsha','sasha',
    # More game terms
    'growl','rune','runic','runebreaker','runeblade','frostbite',
    'leafblade','leafblades','stoneblade','flameblades','flameblade',
    'windblades','windblade','earthblade','earthblades','iceblades',
    'iceblade','lightningblade','lightningblades',
    # Contractions & short forms used in game
    'gonna','wanna','gotta','kinda','sorta','lotta','dunno','gimme',
    'lemme','coulda','woulda','shoulda','musta','hafta','outta','lotsa',
    'betcha','whatcha','gotcha','oughta',
    # Japanese loanwords sometimes kept
    'sensei','sama','kun','chan','san','dono',
    # Place names
    'dastis','pothrad','monopolis','leystan','makinus','fomeros','goatland',
    'zaramba','totuwa','jaergen','juwaina','zerdok','warslee','geilenach',
    'felmentia','royferon','yarstill','schizarz','hingis','kaiser',
    # Character names from game
    'yurii','malt','jio','soltier','beldine','carmaine','vaynard','wein',
    'sherris','ferim','vansen','dryst','senia','laffine','haschen',
    'charlone','zelos','chacole','eliotte','andie','dehl','dorris',
    'emilita','rind','selis','velhart','espie','gardios','silmeria',
    'blaze','strom','solt','garyu','dios','celes','clarett',
    # Misc
    'ok', 'gah', 'pfft', 'tch', 'mm', 'mhm', 'yep', 'yup', 'nope',
    'dammit', 'damn', 'dang', 'geez', 'jeez',
    'ha', 'bwah', 'bwahahaha', 'uwah', 'uwaaah', 'eek',
    # Numbers as text
    'th', 'st', 'nd', 'rd',
    # Game menu terms
    'equip', 'unequip', 'reequip', 'sp', 'hp', 'mp', 'xp', 'exp',
    'lv', 'lvl', 'str', 'def', 'agi', 'int', 'spd', 'atk',
    # More names
    'gillan', 'telmon', 'hasse', 'vira', 'dolce', 'marsha', 'sasha',
    'sylvia', 'selene', 'luna',
    # Misc game
    'ain', 'nah', 'ya', 'y',
}

# Spell checker - load with custom word list
sc = SpellChecker()
sc.word_frequency.load_words(GAME_TERMS)

def words_from_text(text):
    # Remove game codes
    text = CODE_PATTERN.sub(' ', text)
    # Remove punctuation but keep apostrophes within words
    text = re.sub(r"[^\w\s'-]", ' ', text)
    # Split on whitespace
    return text.split()

# ---- PATTERN-BASED CHECKS ----

def check_patterns(fname, lineno, original):
    issues = []
    text = original
    clean = CODE_PATTERN.sub('', text)
    
    # Duplicate words (case-insensitive), skip if same word repeated is intentional
    dup_match = re.search(r'\b(\w+)\s+\1\b', clean, re.IGNORECASE)
    if dup_match:
        w = dup_match.group(1).lower()
        # Skip common false positives
        if w not in ('ha', 'la', 'na', 'ta', 'da', 'hm', 'mm', 'oh',
                     'very', 'long', 'far', 'so', 'too', 'bye', 'no'):
            issues.append({
                'reason': f'Duplicate word: "{dup_match.group(0)}"',
                'fix_hint': f'Remove duplicate "{dup_match.group(1)}"'
            })
    
    # "i " as standalone lowercase I
    if re.search(r'(?<![a-zA-Z])i (?=[a-z])', clean):
        # Make sure it's not inside a word
        if re.search(r'(?:^|[^a-zA-Z])i (?=[a-z])', clean):
            issues.append({'reason': 'Lowercase "i" should be "I"', 'fix_hint': 'Capitalize "i" to "I"'})
    
    # "dont" / "cant" / "wont" / "doesnt" / "isnt" / "arent" / "wasnt" / "werent" / "havent" / "hasnt" / "hadnt" / "wouldnt" / "couldnt" / "shouldnt" / "didnt"
    # Missing apostrophe in contractions
    missing_apos = {
        r'\bdont\b': "don't",
        r'\bcant\b': "can't",
        r'\bwont\b': "won't",  # careful: wont also means "accustomed"
        r'\bdoesnt\b': "doesn't",
        r'\bisnt\b': "isn't",
        r'\barent\b': "aren't",
        r'\bwasnt\b': "wasn't",
        r'\bwerent\b': "weren't",
        r'\bhavent\b': "haven't",
        r'\bhasnt\b': "hasn't",
        r'\bhadnt\b': "hadn't",
        r'\bwouldnt\b': "wouldn't",
        r'\bcouldnt\b': "couldn't",
        r'\bshouldnt\b': "shouldn't",
        r'\bdidnt\b': "didn't",
        r'\bim\b': "I'm",
        r'\bive\b': "I've",
        r'\bill\b': "I'll",
        r'\bid\b': "I'd",
        r'\byoure\b': "you're",
        r'\byouve\b': "you've",
        r'\byoull\b': "you'll",
        r'\bthats\b': "that's",
        r'\bwhats\b': "what's",
        r'\bwhos\b': "who's",
        r'\bwheres\b': "where's",
        r'\btheres\b': "there's",
        r'\bheres\b': "here's",
        r'\bits\b': None,  # ambiguous - it's vs its
        r'\blets\b': "let's",  # might also be "lets" as in allow
        r'\bweve\b': "we've",
        r'\bwere\b': None,  # ambiguous
        r'\bwell\b': None,  # ambiguous
        r'\bshell\b': "she'll",
        r'\bhell\b': None,  # ambiguous
        r'\bhed\b': "he'd",
        r'\bshed\b': "she'd",
        r'\btheyd\b': "they'd",
        r'\btheyre\b': "they're",
        r'\btheyve\b': "they've",
        r'\btheyll\b': "they'll",
        r'\bwont\b': "won't",
        r'\bitll\b': "it'll",
        r'\bits\b': None,  # skip - too ambiguous
    }
    
    for pattern, correction in missing_apos.items():
        if correction is None:
            continue
        if re.search(pattern, clean, re.IGNORECASE):
            m = re.search(pattern, clean, re.IGNORECASE)
            found = m.group(0)
            # Skip if it's actually the correct word (e.g. "lets" as in "allows")
            issues.append({'reason': f'Missing apostrophe: "{found}" → "{correction}"', 'fix_hint': correction})
            break  # only report one per line to avoid flood
    
    return issues


# Collect all issues
all_issues = []

for fname in translated_files:
    filepath = os.path.join(BASE_DIR, fname)
    for lineno, original in get_english_lines(filepath):
        pattern_issues = check_patterns(fname, lineno, original)
        for iss in pattern_issues:
            all_issues.append({
                'file': fname,
                'lineno': lineno,
                'original': original,
                'reason': iss['reason'],
            })

print(f"Found {len(all_issues)} potential issues\n")
for iss in all_issues:
    print(f"FILE: {iss['file']}")
    print(f"LINE_NUM: {iss['lineno']}")
    print(f"ORIGINAL: {iss['original']}")
    print(f"REASON: {iss['reason']}")
    print()

