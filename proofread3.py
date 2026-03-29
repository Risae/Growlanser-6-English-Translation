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

# All game terms to ignore in spell checker
GAME_TERMS = set("""
rana yurii schizarz dastis monopolis leystan goatland felmentia zaramba totuwa
geilenach juwaina zerdok warslee jaergen royferon makinus fomeros lennox pothrad
yarstill kaiser hingis transgate mil futon steed pmb npc growlanser carmaine
wein sherris ferim vansen dryst senia clarett celes laffine haschen charlone
zelos chacole eliotte andie tippi dehl dorris emilita rind selis velhart espie
lana cleo lena garyu dios geo blaze strom solt zekell malt jio mervina soltier
beldine gardios vaynard silmeria celestia gillan telmon hasse vira dolce marsha
sasha sylvia selene luna mana liege sire spellcaster knack ore arcana arcane
transgate runic rune runebreaker runeblade leafblade stoneblade flameblade
windblade earthblade iceblade lightningblade gonna wanna gotta kinda sorta lotta
dunno gimme lemme coulda woulda shoulda musta hafta outta lotsa betcha whatcha
gotcha oughta sensei sama kun chan san dono ok gah pfft tch mm mhm yep yup
nope dammit geez jeez ha bwah uwah eek aaah aah ahh ahhh hmm hmph huh ngh
hyah whoa argh bah grr ugh urk hm nline nwin col addr endff endfe maincharname
equip unequip sp hp mp xp exp lv lvl str def agi int spd atk ain nah ya
angie rio rey telmon hasse selene luna dolce ain gah nah ya yoink ugh hmph
gah whoa yikes eek ooh oof wow phew bleh meh pfft tsk nah yep nope
growl fae runebreaker spellcast spellcasters
dios cain abel sylvie selius jenas luna lunae selh marsha gillan
id ugh mhm ok hmm hm uh em nah ya
leiston razan azlan azan golem prism
ok um er ah uh ya yup nah
aaah aah ahh ahhh hmm hmph huh ngh
wanna gonna gotta kinda sorta
lv lvl xp exp hp mp sp
equip dps aoe atk def int agi spd
mm mhm
""".split())

sc = SpellChecker()
sc.word_frequency.load_words(GAME_TERMS)

def clean_text(text):
    """Remove game codes and get plain text."""
    return CODE_PATTERN.sub(' ', text)

def check_spelling(text):
    """Return list of (misspelled_word, suggestion) pairs."""
    clean = clean_text(text)
    # Only extract actual word tokens
    words = re.findall(r"[a-zA-Z]+(?:'[a-zA-Z]+)*", clean)
    issues = []
    seen = set()
    for w in words:
        wl = w.lower()
        if wl in seen:
            continue
        seen.add(wl)
        if len(wl) < 3:
            continue
        if wl in GAME_TERMS:
            continue
        # Skip words that are all caps (acronyms) or start with capital (proper nouns)
        if w[0].isupper() and len(w) > 1:
            continue
        # Skip words with numbers mixed in
        if any(c.isdigit() for c in w):
            continue
        misspelled = sc.unknown([w])
        if misspelled:
            correction = sc.correction(w)
            if correction and correction != wl:
                issues.append((w, correction))
    return issues

# ---- PATTERN-BASED CHECKS ----

def check_patterns(fname, lineno, original):
    issues = []
    clean = clean_text(original)
    
    # Duplicate words - careful version
    for m in re.finditer(r'\b([a-zA-Z]{2,})\s+\1\b', clean, re.IGNORECASE):
        w = m.group(1).lower()
        # Skip intentional repetitions (sound effects, emphasis)
        if w in ('ha', 'la', 'na', 'ta', 'da', 'hm', 'mm', 'oh', 'no',
                 'bye', 'very', 'long', 'far', 'so', 'too', 'ever', 'more',
                 'all', 'and', 'yes', 'tick', 'tock', 'doom', 'boom'):
            continue
        issues.append((f'Duplicate word: "{m.group(0)}"', original))
    
    # "your" used where "you're" likely intended (before verb)
    if re.search(r"\byour\s+(going|coming|doing|being|trying|making|getting|taking|saying|thinking|feeling|looking|running|leaving|staying|right|wrong|sure|welcome|free|able|not)\b", clean, re.IGNORECASE):
        m = re.search(r"\b(your)\s+(\w+)\b", clean, re.IGNORECASE)
        issues.append((f'"your" should be "you\'re" before "{m.group(2)}"', original))
    
    # "there" used where "their" or "they're" likely intended
    # "there" before a noun phrase is sometimes wrong  
    # Too tricky - skip
    
    # Subject-verb: "we was" / "they was" / "I were"
    if re.search(r'\b(we|they)\s+was\b', clean, re.IGNORECASE):
        issues.append(('"we/they was" should be "we/they were"', original))
    if re.search(r'\bI\s+were\b', clean, re.IGNORECASE):
        issues.append(('"I were" should be "I was" (unless subjunctive)', original))
    
    # Missing apostrophe in contractions - very targeted
    # "its" when context suggests "it's" - hard to determine without context, skip
    
    # "alot" - should be "a lot"
    if re.search(r'\balot\b', clean, re.IGNORECASE):
        issues.append(('"alot" should be "a lot"', original))
    
    # "then" vs "than" in comparisons
    if re.search(r'\b(better|worse|more|less|rather|other|bigger|smaller|faster|slower|stronger|weaker|older|newer|higher|lower|greater|longer|shorter)\s+then\b', clean, re.IGNORECASE):
        m = re.search(r'(\w+)\s+then\b', clean, re.IGNORECASE)
        issues.append((f'"then" after comparative "{m.group(1)}" should be "than"', original))
    
    # "of" should be "have" in "could of / would of / should of"
    if re.search(r"\b(could|would|should|must|might)\s+of\b", clean, re.IGNORECASE):
        m = re.search(r"(\w+)\s+of\b", clean, re.IGNORECASE)
        issues.append((f'"{m.group(1)} of" should be "{m.group(1)} have"', original))
    
    # "loose" vs "lose"
    if re.search(r"\bdon't\s+loose\b|\bwill\s+loose\b|\byou\s+loose\b", clean, re.IGNORECASE):
        issues.append(('"loose" should probably be "lose"', original))
    
    # "an" before consonant sound
    if re.search(r'\ban\s+[bdfgjklmnpqrstvwxyz]\w', clean, re.IGNORECASE):
        m = re.search(r'\b(an)\s+([bdfgjklmnpqrstvwxyz]\w+)', clean, re.IGNORECASE)
        next_word = m.group(2).lower()
        # Exceptions: words that start with a vowel sound despite consonant letter
        vowel_sound_exceptions = {'hour', 'honour', 'honest', 'heir', 'herb', 'homage'}
        if next_word not in vowel_sound_exceptions and next_word not in GAME_TERMS:
            # More targeted: skip proper nouns (capitalized in original)
            m2 = re.search(r'\ban\s+([A-Z]\w+)', clean)
            if not m2:  # original next word is lowercase
                # Only flag very clear cases
                if re.search(r'\ban\s+(the|this|that|these|those|[bdfgjklmnpqrstvwxyz][a-z]{2,})\b', clean, re.IGNORECASE):
                    issues.append((f'"an" before consonant sound: "{m.group(0)}"', original))
    
    return issues

# -------- SPELL CHECK focused on common errors --------

# Load all lines
print("Checking files...", flush=True)
all_issues = []

# Track unique issues to avoid flooding
seen_issues = set()

for fname in translated_files:
    filepath = os.path.join(BASE_DIR, fname)
    for lineno, original in get_english_lines(filepath):
        
        # Pattern checks
        for reason, _ in check_patterns(fname, lineno, original):
            key = (fname, lineno, reason[:30])
            if key not in seen_issues:
                seen_issues.add(key)
                all_issues.append({
                    'file': fname,
                    'lineno': lineno,
                    'original': original,
                    'reason': reason,
                    'type': 'grammar'
                })
        
        # Spell check
        clean = clean_text(original)
        # Only check lowercase words (upper = proper nouns/acronyms)
        words = re.findall(r"\b[a-z][a-z']{2,}\b", clean)
        for w in words:
            wl = w.lower().replace("'", "")
            if wl in GAME_TERMS:
                continue
            misspelled = sc.unknown([w])
            if misspelled:
                correction = sc.correction(w)
                if correction and correction.lower() != w.lower():
                    key = (fname, lineno, w)
                    if key not in seen_issues:
                        seen_issues.add(key)
                        all_issues.append({
                            'file': fname,
                            'lineno': lineno,
                            'original': original,
                            'reason': f'Possibly misspelled: "{w}" → "{correction}"',
                            'type': 'spell'
                        })

print(f"Found {len(all_issues)} potential issues\n")
for iss in all_issues:
    print(f"FILE: {iss['file']}")
    print(f"LINE_NUM: {iss['lineno']}")
    print(f"ORIGINAL: {iss['original']}")
    print(f"REASON: {iss['reason']}")
    print()

