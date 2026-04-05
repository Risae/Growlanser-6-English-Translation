import re
import os
import glob

SCEN_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

# Get all translated/edited files
files = []
for f in os.listdir(SCEN_DIR):
    if '[TRANSLATED]' in f or '[EDITED]' in f:
        files.append(os.path.join(SCEN_DIR, f))
files.sort()

def is_english_line(line):
    stripped = line.strip()
    if not stripped:
        return False
    if stripped.startswith('//'):
        return False
    if stripped.startswith('#'):
        return False
    return True

def clean_line(line):
    # Remove control codes for analysis
    cleaned = re.sub(r'\[END-F[EF]\]|\[NLINE\]|\[NWIN\]|\[COL[0-9A-F]{2}\]|\[CHARKA[0-9A-F]+\]|\[V[0-9A-F]+\]|\[CC\.[A-Z0-9]+\]', ' ', line)
    return cleaned

issues = []

for filepath in files:
    filename = os.path.basename(filepath)
    is_dialect = '00000079' in filename or '00000034' in filename or '00000086' in filename
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except Exception as e:
        continue
    
    for lineno, line in enumerate(lines, 1):
        if not is_english_line(line):
            continue
        
        raw = line.rstrip('\n')
        text = clean_line(raw)
        
        # 1. Doubled words
        for word in ['the', 'a', 'is', 'in', 'to', 'of', 'and', 'that', 'for', 'it', 'as', 'or', 'was', 'be', 'I', 'you', 'we', 'he', 'she', 'they']:
            pattern = r'\b' + word + r'\s+' + word + r'\b'
            if re.search(pattern, text, re.IGNORECASE):
                issues.append((filename, lineno, f'Doubled word: {word}', raw.strip()))
        
        # 2. Common misspellings (not substrings of larger correct words)
        misspellings = {
            r'\brecieve\b': 'receive',
            r'\boccured\b': 'occurred',
            r'\baccomodat': 'accommodate',
            r'\bdefinately\b': 'definitely',
            r'\bseperate\b': 'separate',
            r'\bwierd\b': 'weird',
            r'\bbeleive\b': 'believe',
            r'\baquire\b': 'acquire',
            r'\bbegining\b': 'beginning',
            r'\boccurance\b': 'occurrence',
            r'\bembarass\b': 'embarrass',
            r'\bposession\b': 'possession',
            r'\bexistance\b': 'existence',
            r'\bindependant\b': 'independent',
            r'\bneccessary\b': 'necessary',
            r'\buntill\b': 'until',
            r'\btruely\b': 'truly',
            r'\ba lot\b': None,  # this is CORRECT, skip
            r'\bnoone\b': 'no one',
            r'\bfulfiled\b': 'fulfilled',
            r'\bdissapear': 'disappear',
            r'\bprefered\b': 'preferred',
            r'\boccassion\b': 'occasion',
            r'\bfreindly\b': 'friendly',
            r'\borigional\b': 'original',
        }
        for pattern, correction in misspellings.items():
            if correction is None:
                continue
            if re.search(pattern, text, re.IGNORECASE):
                issues.append((filename, lineno, f'Possible misspelling (→ {correction})', raw.strip()))
        
        # 3. Article errors: "a" before vowel sound words
        a_before_vowel = re.findall(r'\ba (a|e|i|o|u)[a-z]+', text, re.IGNORECASE)
        # Filter out known exceptions: "a one", "a European", "a uniform", "a unique", "a unit", "a university", "a useful"
        exceptions = ['one', 'once', 'onc', 'european', 'uniform', 'unique', 'unit', 'university', 'useful', 'usual', 'user', 'use ', 'used']
        for match in a_before_vowel:
            # Check not an exception
            is_exc = False
            for exc in exceptions:
                if exc.lower().startswith(match.lower()):
                    is_exc = True
                    break
            if not is_exc:
                # Get context
                full_match = re.search(r'\ba (' + match + r'[a-z]*)', text, re.IGNORECASE)
                if full_match:
                    word_after = full_match.group(1).lower()
                    if not any(word_after.startswith(exc) for exc in exceptions):
                        issues.append((filename, lineno, f'"a" before vowel: "a {full_match.group(1)}" (should be "an"?)', raw.strip()))
        
        # 4. "an" before consonant sounds
        an_before_consonant = re.findall(r'\ban ([b-df-hj-np-tv-z][a-z]+)', text, re.IGNORECASE)
        # Common exceptions: an hour, an heir, an honest, an honorable, an herb (AmE), an historical
        consonant_exceptions = ['hour', 'heir', 'honest', 'honor', 'honour', 'herb', 'historical', 'historic']
        for word in an_before_consonant:
            if not any(word.lower().startswith(exc) for exc in consonant_exceptions):
                issues.append((filename, lineno, f'"an" before consonant: "an {word}"', raw.strip()))
        
        # 5. Missing apostrophes in contractions: wont, dont, cant, isnt, arent, wasnt, etc.
        contractions_missing = {
            r'\bwont\b': "won't",
            r'\bdont\b': "don't", 
            r'\bcant\b': "can't",
            r'\bisnt\b': "isn't",
            r'\barent\b': "aren't",
            r'\bwasnt\b': "wasn't",
            r'\bwerent\b': "weren't",
            r'\bcouldnt\b': "couldn't",
            r'\bwouldnt\b': "wouldn't",
            r'\bshouldnt\b': "shouldn't",
            r'\bhadnt\b': "hadn't",
            r'\bhasnt\b': "hasn't",
            r'\bdidnt\b': "didn't",
            r'\bdoesnt\b': "doesn't",
        }
        for pattern, correction in contractions_missing.items():
            if re.search(pattern, text, re.IGNORECASE):
                issues.append((filename, lineno, f'Missing apostrophe in contraction: {correction}', raw.strip()))
        
        # 6. Comma splice or missing comma indicators
        # Check for "its" vs "it's" in context
        its_apostrophe = re.findall(r"\bits ([a-z]+ing|[a-z]+ed|[a-z]+ly|not|been|got|time|ok|fine|good|bad|clear|true|false|over|done|right|wrong|just|already|possible|impossible|hard|easy|difficult|simple|complex|great|wonderful|terrible|awful|nice|beautiful|ugly)\b", text, re.IGNORECASE)
        for match in its_apostrophe:
            issues.append((filename, lineno, f'"its" might need apostrophe: "its {match}"', raw.strip()))

# Print results
for filename, lineno, issue_type, text in issues:
    print(f"{filename}:{lineno}: [{issue_type}]")
    print(f"  >> {text[:120]}")
    print()

print(f"\nTotal issues found: {len(issues)}")
