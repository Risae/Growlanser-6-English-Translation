import re
import sys

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

# Remove control codes to get clean text
CTRL_PATTERN = re.compile(r'\[(END-F[EF]|NLINE|NWIN|COL0[0-9]|CHAR[0-9A-Fa-f]{4}|V[0-9A-Fa-f]{4}|CC\.[0-9A-Fa-f]{4}|CH\.FACE:[^\]]+|MUSIC-NOTE|TEAR-DROP|TRIANGLE|START|L1|R1|L2|R2)\]')

def strip_controls(text):
    return CTRL_PATTERN.sub(' ', text).strip()

# Common spelling errors
SPELL_CHECK = [
    (r'\brecieve\b', 'receive'),
    (r'\brecieved\b', 'received'),
    (r'\bbelive\b', 'believe'),
    (r'\bbelived\b', 'believed'),
    (r'\bfreinds?\b', 'friend'),
    (r'\bthier\b', 'their'),
    (r'\bwierd\b', 'weird'),
    (r'\boccured\b', 'occurred'),
    (r'\boccuring\b', 'occurring'),
    (r'\bseperate\b', 'separate'),
    (r'\bdefinately\b', 'definitely'),
    (r'\bforsee\b', 'foresee'),
    (r'\bfoward\b', 'forward'),
    (r'\bheroe\b', 'hero'),
    (r'\bheros\b', 'heroes'),
    (r'\bsorrounding\b', 'surrounding'),
    (r'\buntill\b', 'until'),
    (r'\buntil\b', None),  # until is correct - skip
    (r'\bsucess\b', 'success'),
    (r'\bproffesional\b', 'professional'),
    (r'\bgoverment\b', 'government'),
    (r'\bgovenment\b', 'government'),
    (r'\bcommander\b', None),
    (r'\bthough\b', None),
    (r'\bthrough\b', None),
    (r'\bthrought\b', 'thought/through'),
    (r'\bstregnth\b', 'strength'),
    (r'\bstrenth\b', 'strength'),
    (r'\bstrength\b', None),
    (r'\bexisitng\b', 'existing'),
    (r'\bexsit\b', 'exist'),
    (r'\bvictorey\b', 'victory'),
    (r'\bvictory\b', None),
    (r'\bvilliage\b', 'village'),
    (r'\bvillage\b', None),
    (r'\bmagican\b', 'magician'),
    (r'\bmagicain\b', 'magician'),
    (r'\bsolider\b', 'soldier'),
    (r'\bsoliders\b', 'soldiers'),
    (r'\bguard\b', None),
    (r'\bgaurds?\b', 'guard(s)'),
    (r'\bpeoples\b', 'people (usually no plural -s)'),
    (r'\byoure\b', "you're"),
    (r'\bwhats\b', "what's"),
    (r'\bdoesnt\b', "doesn't"),
    (r'\bwont\b', "won't (or 'wont' meaning habit - context dependent)"),
    (r'\bcant\b', "can't"),
    (r'\bdidnt\b', "didn't"),
    (r'\bwasnt\b', "wasn't"),
    (r'\bisnt\b', "isn't"),
    (r'\barent\b', "aren't"),
    (r'\bwerent\b', "weren't"),
    (r'\bhavent\b', "haven't"),
    (r'\bhasnt\b', "hasn't"),
    (r'\bwouldnt\b', "wouldn't"),
    (r'\bcouldnt\b', "couldn't"),
    (r'\bshouldnt\b', "shouldn't"),
    (r'\bthier\b', 'their'),
    (r'\beit her\b', 'either'),
    (r'\bneither\b', None),
    (r'\bprobaly\b', 'probably'),
    (r'\bprobabaly\b', 'probably'),
    (r'\bprobably\b', None),
    (r'\bgoverment\b', 'government'),
    (r'\binfomation\b', 'information'),
    (r'\binformation\b', None),
    (r'\bcomon\b', 'common'),
    (r'\bcommon\b', None),
    (r'\bdisapear\b', 'disappear'),
    (r'\bdisappear\b', None),
    (r'\bwich\b', 'which'),
    (r'\bwhich\b', None),
    (r'\breaon\b', 'reason'),
    (r'\breason\b', None),
    (r'\blieing\b', 'lying'),
    (r'\blying\b', None),
    (r'\bunfortuately\b', 'unfortunately'),
    (r'\bunfortuantely\b', 'unfortunately'),
    (r'\bunfortnately\b', 'unfortunately'),
    (r'\bdestory\b', 'destroy'),
    (r'\bprotcet\b', 'protect'),
    (r'\bdefintely\b', 'definitely'),
    (r'\bcarefuly\b', 'carefully'),
    (r'\bcarefully\b', None),
    (r'\bknolwedge\b', 'knowledge'),
    (r'\bknowledge\b', None),
    (r'\bconvinced\b', None),
    (r'\bconviced\b', 'convinced'),
    (r'\bexpeirenced\b', 'experienced'),
    (r'\bexperienced\b', None),
    (r'\bdangerou\b', 'dangerous'),
    (r'\bdangerous\b', None),
    (r'\bopporutnity\b', 'opportunity'),
    (r'\bopportunity\b', None),
    (r'\bsacrafice\b', 'sacrifice'),
    (r'\bsacrifice\b', None),
    (r'\bsurprised\b', None),
    (r'\bsurprized\b', 'surprised'),
    (r'\bextraordanary\b', 'extraordinary'),
    (r'\bfamiiar\b', 'familiar'),
    (r'\bfamiliar\b', None),
    (r'\bpossiblity\b', 'possibility'),
    (r'\bpossibility\b', None),
    (r'\bneccesary\b', 'necessary'),
    (r'\bnecessary\b', None),
    (r'\bimmedately\b', 'immediately'),
    (r'\bimmediately\b', None),
    (r'\bstrategey\b', 'strategy'),
    (r'\bstrategy\b', None),
    (r'\bgenerel\b', 'general'),
    (r'\bgeneral\b', None),
    (r'\bemporer\b', 'emperor'),
    (r'\bsoldires\b', 'soldiers'),
    (r'\bweapon\b', None),
    (r'\bweapons\b', None),
    (r'\bprotect\b', None),
    (r'\bsurround\b', None),
    (r'\battack\b', None),
    (r'\bdefense\b', None),
    (r'\bdefence\b', None),  # British spelling - valid
    (r'\bmonster\b', None),
    (r'\bmonsters\b', None),
    (r'\benemies\b', None),
    (r'\benemy\b', None),
    (r'\bcastle\b', None),
    (r'\btown\b', None),
    (r'\bcity\b', None),
    (r'\bkingdom\b', None),
    (r'\bmagic\b', None),
    (r'\bsword\b', None),
    (r'\bspell\b', None),
    (r'\bpower\b', None),
    (r'\bstrength\b', None),
    (r'\bweakness\b', None),
    (r'\bvictory\b', None),
    (r'\bdefeat\b', None),
    (r'\bsurrender\b', None),
    (r'\bescap\b', 'escape'),
    (r'\bescape\b', None),
    (r'\bfight\b', None),
    (r'\bbattle\b', None),
    (r'\bwar\b', None),
    (r'\bpeace\b', None),
    (r'\balliance\b', None),
    (r'\bbetrayal\b', None),
    (r'\bbetrayed\b', None),
    (r'\btrust\b', None),
    (r'\bhonor\b', None),
    (r'\bhonour\b', None),  # British spelling - valid
    (r'\bjourney\b', None),
    (r'\bquest\b', None),
    (r'\bmission\b', None),
    (r'\bsacrifice\b', None),
    (r'\bhero\b', None),
    (r'\bheroes\b', None),
    (r'\bvillain\b', None),
    (r'\bvillians?\b', 'villain(s)'),
    (r'\bguardian\b', None),
    (r'\bguardians\b', None),
    (r'\bwarrior\b', None),
    (r'\bwarriors\b', None),
    (r'\bpriest\b', None),
    (r'\bpriests\b', None),
    (r'\bwizard\b', None),
    (r'\bwizards\b', None),
    (r'\bliberate\b', None),
    (r'\bliberation\b', None),
    (r'\bdestroyeed\b', 'destroyed'),
    (r'\bdestroyed\b', None),
    (r'\bdestroy\b', None),
    (r'\bdefeated\b', None),
    (r'\bfailed\b', None),
    (r'\bfailure\b', None),
    (r'\bsuccess\b', None),
    (r'\baccomplish\b', None),
    (r'\baccomplishment\b', None),
    (r'\bprevious\b', None),
    (r'\bcurrent\b', None),
    (r'\bfuture\b', None),
    (r'\bhistory\b', None),
    (r'\bpolitics\b', None),
    (r'\bpolitical\b', None),
    (r'\bcounty\b', None),
    (r'\bcountry\b', None),
    (r'\bnation\b', None),
    (r'\bnations\b', None),
    (r'\borderss?\b', 'orders'),
    (r'\bcommand\b', None),
    (r'\bcommands\b', None),
    (r'\bcompany\b', None),
    (r'\bunits?\b', None),
    (r'\bsquads?\b', None),
    (r'\bcamp\b', None),
    (r'\bfort\b', None),
    (r'\bfortress\b', None),
    (r'\bgate\b', None),
    (r'\bwall\b', None),
    (r'\bpath\b', None),
    (r'\broad\b', None),
    (r'\broute\b', None),
    (r'\bbridge\b', None),
    (r'\bforest\b', None),
    (r'\bplain\b', None),
    (r'\bplains\b', None),
    (r'\bmountain\b', None),
    (r'\bmountains\b', None),
    (r'\briver\b', None),
    (r'\bocean\b', None),
    (r'\bsea\b', None),
    (r'\bcoast\b', None),
    (r'\bisland\b', None),
    (r'\bdesert\b', None),
    (r'\bswamp\b', None),
]

# Filter: only check rules with a non-None replacement
ACTIVE_RULES = [(pat, fix) for pat, fix in SPELL_CHECK if fix is not None]

def check_line(text_clean, line_raw):
    issues = []
    
    # Check spelling errors
    for pattern, fix in ACTIVE_RULES:
        if re.search(pattern, text_clean, re.IGNORECASE):
            issues.append(('spelling', fix, pattern))
    
    # Check for double spaces (not counting leading whitespace)
    if re.search(r'\S  +\S', text_clean):
        issues.append(('double_space', 'Remove extra space', None))
    
    # Check for repeated words  
    m = re.search(r'\b(\w{3,})\s+\1\b', text_clean, re.IGNORECASE)
    if m:
        issues.append(('repeat_word', f'Repeated word: "{m.group(0)}"', None))
    
    # Check for missing space after period/comma/etc (before capital)
    if re.search(r'[a-z][,.][A-Z]', text_clean):
        issues.append(('missing_space', 'Missing space after punctuation', None))
    
    # Check for "a" before vowel sounds (basic)
    # a apple, a elephant, a obvious, a unusual, a honor
    if re.search(r'\ba [aeiou][a-z]', text_clean, re.IGNORECASE):
        # skip "a one", "a unit", "a unique", "a uniform" etc. (words that start with vowel but sound like consonant)
        for m in re.finditer(r'\ba ([aeiou][a-z]+)', text_clean, re.IGNORECASE):
            word = m.group(1).lower()
            # Words starting with vowel but use "a"
            exceptions = ['use', 'used', 'using', 'user', 'unit', 'units', 'united', 'uniform', 
                         'unique', 'union', 'usual', 'usually', 'once', 'one', 'universe',
                         'universal', 'university', 'urgent']
            if word not in exceptions and not word.startswith('u') and not word.startswith('eu'):
                pass  # Would be "an" - but this produces too many false positives for game text
    
    return issues


for fname in files:
    fpath = f"{BASE}/{fname}"
    issues_found = []
    
    try:
        with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
            lines = f.readlines()
    except Exception as e:
        print(f"ERROR reading {fname}: {e}")
        continue
    
    for lineno, line in enumerate(lines, 1):
        line = line.rstrip('\n')
        
        # Skip empty lines
        if not line.strip():
            continue
        # Skip comment lines (starting with //)
        if line.strip().startswith('//'):
            continue
        # Skip directive lines (starting with #)
        if line.strip().startswith('#'):
            continue
        
        # This is a translation line - clean it and check
        clean = strip_controls(line)
        
        issues = check_line(clean, line)
        for issue_type, fix, pattern in issues:
            issues_found.append((lineno, issue_type, fix, pattern, line.strip()))
    
    if issues_found:
        for lineno, issue_type, fix, pattern, text in issues_found:
            print(f"FILE: {fname}")
            print(f"LINE: {lineno}")
            print(f"ISSUE: {issue_type} - {fix}")
            print(f"TEXT: {text}")
            print()

