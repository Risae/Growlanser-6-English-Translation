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

# Remove ALL control codes entirely (not replace with space)
CTRL_PATTERN = re.compile(r'\[(?:END-F[EF]|NLINE|NWIN|COL0[0-9]|CHAR[0-9A-Fa-f]{4}|V[0-9A-Fa-f]{4}|CC\.[0-9A-Fa-f]{4}|CH\.FACE:[^\]]+|MUSIC-NOTE|TEAR-DROP|TRIANGLE|START|L1|R1|L2|R2)\]')

def strip_controls(text):
    return CTRL_PATTERN.sub('', text).strip()

issues_all = []

def report(fname, lineno, issue, text, fix):
    issues_all.append((fname, lineno, issue, text, fix))

for fname in files:
    fpath = f"{BASE}/{fname}"
    
    try:
        with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
            lines = f.readlines()
    except Exception as e:
        print(f"ERROR reading {fname}: {e}")
        continue
    
    for lineno, line in enumerate(lines, 1):
        raw = line.rstrip('\n')
        
        if not raw.strip():
            continue
        if raw.strip().startswith('//'):
            continue
        if raw.strip().startswith('#'):
            continue
        
        clean = strip_controls(raw)
        
        # Skip lines that are purely control codes
        if not clean.strip():
            continue
        
        # ── DOUBLE SPACE (in raw text, not near control codes) ──
        # Check for two consecutive spaces in the raw line (not between control-code brackets)
        # First remove control codes and check clean version
        if '  ' in clean:
            report(fname, lineno, "Double space in text", raw.strip(), "Remove extra space")
        
        # ── REPEATED WORDS ──
        m = re.search(r'\b(\w{3,})\s+\1\b', clean, re.IGNORECASE)
        if m:
            report(fname, lineno, f"Repeated word: '{m.group(0)}'", raw.strip(), f"Remove duplicate '{m.group(1)}'")
        
        # ── COMMON MISSPELLINGS ──
        misspellings = [
            (r'\brecieve\b', 'receive'),
            (r'\brecieved\b', 'received'),
            (r'\brecieving\b', 'receiving'),
            (r'\bbelive\b', 'believe'),
            (r'\bbelived\b', 'believed'),
            (r'\bbeliving\b', 'believing'),
            (r'\bfreinds?\b', 'friend/friends'),
            (r'\bthier\b', 'their'),
            (r'\bwierd\b', 'weird'),
            (r'\boccured\b', 'occurred'),
            (r'\boccuring\b', 'occurring'),
            (r'\bseperate\b', 'separate'),
            (r'\bseperated\b', 'separated'),
            (r'\bdefinately\b', 'definitely'),
            (r'\bdefintely\b', 'definitely'),
            (r'\bdefinely\b', 'definitely'),
            (r'\bfoward\b', 'forward'),
            (r'\buntill\b', 'until'),
            (r'\bsucess\b', 'success'),
            (r'\bsucceed\b', None),
            (r'\bproffesional\b', 'professional'),
            (r'\bgoverment\b', 'government'),
            (r'\bgovenment\b', 'government'),
            (r'\bthrought\b', 'thought or through'),
            (r'\bstregnth\b', 'strength'),
            (r'\bstrenth\b', 'strength'),
            (r'\bexisitng\b', 'existing'),
            (r'\bexsit\b', 'exist'),
            (r'\bvictorey\b', 'victory'),
            (r'\bvilliage\b', 'village'),
            (r'\bmagican\b', 'magician'),
            (r'\bmagicain\b', 'magician'),
            (r'\bsolider\b', 'soldier'),
            (r'\bsoliders\b', 'soldiers'),
            (r'\bgauard\b', 'guard'),
            (r'\bgaurd\b', 'guard'),
            (r'\bgaurds?\b', 'guard(s)'),
            (r'\bpeoples\b', 'people'),
            (r'\bprobaly\b', 'probably'),
            (r'\bprobabaly\b', 'probably'),
            (r'\binfomation\b', 'information'),
            (r'\bcomon\b', 'common'),
            (r'\bdisapear\b', 'disappear'),
            (r'\bwich\b', 'which'),
            (r'\breaon\b', 'reason'),
            (r'\blieing\b', 'lying'),
            (r'\bunfortuately\b', 'unfortunately'),
            (r'\bunfortuantely\b', 'unfortunately'),
            (r'\bunfortnately\b', 'unfortunately'),
            (r'\bdestory\b', 'destroy'),
            (r'\bprotcet\b', 'protect'),
            (r'\bcarefuly\b', 'carefully'),
            (r'\bknolwedge\b', 'knowledge'),
            (r'\bconviced\b', 'convinced'),
            (r'\bexpeirenced\b', 'experienced'),
            (r'\bdangerou\b', 'dangerous (missing s)'),
            (r'\bopporutnity\b', 'opportunity'),
            (r'\bsacrafice\b', 'sacrifice'),
            (r'\bsurprized\b', 'surprised'),
            (r'\bextraordanary\b', 'extraordinary'),
            (r'\bfamiiar\b', 'familiar'),
            (r'\bpossiblity\b', 'possibility'),
            (r'\bneccesary\b', 'necessary'),
            (r'\bnecesary\b', 'necessary'),
            (r'\bimmedately\b', 'immediately'),
            (r'\bimmediatly\b', 'immediately'),
            (r'\bstategey\b', 'strategy'),
            (r'\bgenerel\b', 'general'),
            (r'\bemporer\b', 'emperor'),
            (r'\bsoldires\b', 'soldiers'),
            (r'\bdestroyeed\b', 'destroyed'),
            (r'\bvillians?\b', 'villain(s)'),
            (r'\bescap\b(?!e)', 'escape'),
            (r'\bpowerfu\b', 'powerful (missing l)'),
            (r'\bdangerous\b', None),  # correct - skip
            (r'\bsacrifice\b', None),
            (r'\bsurprised\b', None),
            (r'\bimmediately\b', None),
            (r'\bnecessary\b', None),
            (r'\bgenereal\b', 'general'),
            (r'\bintrest\b', 'interest'),
            (r'\binterest\b', None),
            (r'\bthough\b', None),
            (r'\bthrough\b', None),
            (r'\bknew\b', None),
            (r'\bknow\b', None),
            (r'\bcontiue\b', 'continue'),
            (r'\bcontinue\b', None),
            (r'\bcontiued\b', 'continued'),
            (r'\bcontinued\b', None),
            (r'\bappraoch\b', 'approach'),
            (r'\bapproach\b', None),
            (r'\batack\b', 'attack'),
            (r'\battack\b', None),
            (r'\bteh\b', 'the'),
            (r'\bwihout\b', 'without'),
            (r'\bwithout\b', None),
            (r'\bhte\b', 'the'),
            (r'\bfomr\b', 'from'),
            (r'\bform\b', None),
            (r'\bfrom\b', None),
            (r'\bstrikng\b', 'striking'),
            (r'\bstiking\b', 'striking'),
            (r'\bsoemone\b', 'someone'),
            (r'\bsomeone\b', None),
            (r'\bbecomeing\b', 'becoming'),
            (r'\bbecoming\b', None),
            (r'\bstruggle\b', None),
            (r'\bstruggled\b', None),
            (r'\bsurvive\b', None),
            (r'\bsurvived\b', None),
            (r'\bsurvival\b', None),
            (r'\bsurvivor\b', None),
            (r'\bbeleive\b', 'believe'),
            (r'\bbeleived\b', 'believed'),
            (r'\bexistance\b', 'existence'),
            (r'\bexistence\b', None),
            (r'\baliiance\b', 'alliance'),
            (r'\bgoverning\b', None),
            (r'\bgovernment\b', None),
            (r'\borganization\b', None),
            (r'\borganisation\b', None),  # British - valid
            (r'\bescaped\b', None),
            (r'\bnot be able\b', None),
            (r'\bshouldn\'t\b', None),
            (r'\bwoudn\'t\b', "wouldn't"),
            (r'\bwoudn\'t\b', "wouldn't"),
            (r'\bcoudn\'t\b', "couldn't"),
            (r'\bwoudl\b', 'would'),
            (r'\bshoudl\b', 'should'),
            (r'\bbeforte\b', 'before'),
            (r'\bunderstadn\b', 'understand'),
            (r'\bunderstand\b', None),
            (r'\badvisr\b', 'advisor'),
            (r'\badvisor\b', None),
            (r'\bguardaian\b', 'guardian'),
            (r'\bguardian\b', None),
            (r'\bprotection\b', None),
            (r'\bdiscover\b', None),
            (r'\bdiscovered\b', None),
            (r'\bpreapre\b', 'prepare'),
            (r'\bprepare\b', None),
            (r'\bprepared\b', None),
            (r'\bapologize\b', None),
            (r'\bapologise\b', None),
            (r'\bappologize\b', 'apologize'),
            (r'\bappologise\b', 'apologise'),
            (r'\bsuprise\b', 'surprise'),
            (r'\bsupprised\b', 'surprised'),
            (r'\brelieze\b', 'realize'),
            (r'\brecognize\b', None),
            (r'\brecognise\b', None),
            (r'\bgrateful\b', None),
            (r'\bgratefull\b', 'grateful'),
            (r'\bfaithfull\b', 'faithful'),
            (r'\bfaithful\b', None),
            (r'\bbeautifull\b', 'beautiful'),
            (r'\bbeautiful\b', None),
            (r'\bpowerful\b', None),
            (r'\bpowerfull\b', 'powerful'),
            (r'\bwonderful\b', None),
            (r'\bwonderfull\b', 'wonderful'),
            (r'\bsuccessfull\b', 'successful'),
            (r'\bsuccessful\b', None),
            (r'\bhelpfull\b', 'helpful'),
            (r'\bhelpful\b', None),
            (r'\bharmfull\b', 'harmful'),
            (r'\bharmful\b', None),
            (r'\bcarefull\b', 'careful'),
            (r'\bcareful\b', None),
            (r'\bpeacefull\b', 'peaceful'),
            (r'\bpeaceful\b', None),
            (r'\bcheerfull\b', 'cheerful'),
            (r'\bcheerful\b', None),
            (r'\bfearfull\b', 'fearful'),
            (r'\bfearful\b', None),
            (r'\bcolourfull\b', 'colourful'),
            (r'\bcolorfull\b', 'colorful'),
            (r'\bcolorful\b', None),
            (r'\bcolourful\b', None),
            (r'\bthankfull\b', 'thankful'),
            (r'\bthankful\b', None),
            (r'\bwastfull\b', 'wasteful'),
            (r'\bwasteful\b', None),
            (r'\bshamefull\b', 'shameful'),
            (r'\bshameful\b', None),
        ]

        for pattern, fix in misspellings:
            if fix is None:
                continue
            if re.search(pattern, clean, re.IGNORECASE):
                report(fname, lineno, f"Spelling error: '{pattern}' → '{fix}'", raw.strip(), fix)

        # ── GRAMMAR: missing apostrophes in contractions ──
        contractions = [
            (r'\bIm\b(?!\w)', "I'm", "I'm"),
            (r'\bIve\b(?!\w)', "I've", "I've"),
            (r'\bId\b(?!\w)', "I'd", "I'd"),
            (r'\bIll\b(?!\w)', "I'll", "I'll"),
            # These ones appear very often but can be false positives (names etc), be careful
            # (r'\byoure\b', "you're", "you're"),
            # (r'\bwere\b', None, None),  # "were" is valid
            (r'\bdont\b', "don't", "don't"),
            (r'\bdoesnt\b', "doesn't", "doesn't"),
            (r'\bdidnt\b', "didn't", "didn't"),
            (r'\bcant\b', "can't", "can't"),
            (r'\bcouldnt\b', "couldn't", "couldn't"),
            (r'\bwouldnt\b', "wouldn't", "wouldn't"),
            (r'\bshouldnt\b', "shouldn't", "shouldn't"),
            (r'\bisnt\b', "isn't", "isn't"),
            (r'\barent\b', "aren't", "aren't"),
            (r'\bwasnt\b', "wasn't", "wasn't"),
            (r'\bwerent\b', "weren't", "weren't"),
            (r'\bhavent\b', "haven't", "haven't"),
            (r'\bhasnt\b', "hasn't", "hasn't"),
            (r'\bwont\b', "won't (if contraction)", "won't"),
            (r'\bwhats\b', "what's", "what's"),
            (r'\bthats\b', "that's", "that's"),
            (r'\bwhos\b', "who's", "who's"),
            (r'\bhes\b', "he's", "he's"),
            (r'\bshes\b', "she's", "she's"),
            (r'\bits\b', None, None),  # "its" is valid possessive
            (r'\bwere\b', None, None),  # "were" is valid
            (r'\blets\b(?!\s+(?:go|me|us|him|her|it|them))', None, None),  # ambiguous
            (r'\byouve\b', "you've", "you've"),
            (r'\byoud\b', "you'd", "you'd"),
            (r'\byoull\b', "you'll", "you'll"),
            (r'\bhed\b', "he'd", "he'd"),
            (r'\bshell\b', None, None),  # "shell" is a real word
            (r'\bhell\b', None, None),   # "hell" is a real word, not necessarily he'll
            (r'\bweve\b', "we've", "we've"),
            (r'\bwed\b', "we'd", "we'd"),
            (r'\bwell\b', None, None),  # "well" is a real word
            (r'\bwere\b', None, None),  # "were" is a real word
        ]
        
        for pattern, label, fix in contractions:
            if fix is None:
                continue
            if re.search(pattern, clean, re.IGNORECASE):
                # Filter out false positives
                word = re.search(pattern, clean, re.IGNORECASE).group(0)
                # Skip if it could be a name or different word
                if pattern == r'\bIll\b(?!\w)':
                    # Check context - is it "I'll" or "I'm ill" etc
                    # "Ill" as standalone at start of sentence could be I'll
                    # Too many false positives, skip
                    pass
                elif pattern in [r'\bwont\b']:
                    # "wont" can mean habit, too ambiguous
                    pass
                else:
                    report(fname, lineno, f"Missing apostrophe: '{word}' should be '{label}'", 
                           raw.strip(), fix)
        
        # ── GRAMMAR: "a" before vowel (should be "an") ──
        # Very targeted check - only clear cases
        for m in re.finditer(r'\ba ([aeiouAEIOU][a-zA-Z]{2,})\b', clean):
            word = m.group(1).lower()
            # Words that start with vowel letter but consonant sound
            u_exceptions = ['use', 'used', 'uses', 'using', 'user', 'users',
                            'unit', 'units', 'united', 'uniform', 'uniforms',
                            'unique', 'union', 'unions', 'usual', 'usually',
                            'once', 'one', 'ones', 'universe', 'universal',
                            'university', 'urgent', 'urgently',
                            'european', 'euro', 'eerie']
            if word not in u_exceptions:
                # "a order" -> "an order", "a enemy" -> "an enemy", etc
                report(fname, lineno, f"Article error: 'a {m.group(1)}' should be 'an {m.group(1)}'",
                       raw.strip(), f"an {m.group(1)}")
        
        # ── AWKWARD GRAMMAR: specific patterns ──
        # "in order to ... is" type issues - too complex to detect automatically
        
        # Check for "I are" or "he are" type agreement errors
        agreement_errors = [
            (r'\bI are\b', "I am"),
            (r'\bhe are\b', "he is"),
            (r'\bshe are\b', "she is"),
            (r'\bit are\b', "it is"),
            (r'\bI is\b', "I am"),
            (r'\bwe is\b', "we are"),
            (r'\bthey is\b', "they are"),
            (r'\bI were\b', "I was (usually)"),
        ]
        for pattern, fix in agreement_errors:
            if re.search(pattern, clean, re.IGNORECASE):
                report(fname, lineno, f"Subject-verb agreement error: '{pattern}'", raw.strip(), fix)
        
        # ── MISSING SPACE after punctuation ──
        if re.search(r'[a-zA-Z][,\.][a-zA-Z]', clean):
            report(fname, lineno, "Missing space after punctuation", raw.strip(), "Add space after ',' or '.'")

for fname, lineno, issue, text, fix in issues_all:
    print(f"FILE: {fname}")
    print(f"LINE: {lineno}")
    print(f"ISSUE: {issue}")
    print(f"TEXT: {text}")
    print(f"FIX: {fix}")
    print()

print(f"Total issues found: {len(issues_all)}")
