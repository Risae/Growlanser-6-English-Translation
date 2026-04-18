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

CTRL_PATTERN = re.compile(
    r'\[(?:END-F[EF]|NLINE|NWIN|COL0[0-9]|CHAR[0-9A-Fa-f]{2,4}|V[0-9A-Fa-f]{2,4}|'
    r'CC\.[0-9A-Fa-f]{2,8}|CH\.FACE:[^\]]+|MUSIC-NOTE|TEAR-DROP|TRIANGLE|START|L1|R1|L2|R2)\]'
)

def strip_controls(text):
    return CTRL_PATTERN.sub('', text).strip()

issues = []

def report(fname, lineno, issue, text, fix):
    issues.append((fname, lineno, issue, text.strip(), fix))

for fname in files:
    fpath = f"{BASE}/{fname}"
    with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()

    for lineno, line in enumerate(lines, 1):
        raw = line.rstrip('\n')
        if not raw.strip() or raw.strip().startswith('//') or raw.strip().startswith('#'):
            continue
        
        clean = strip_controls(raw)
        if not clean:
            continue

        # ── ACTUAL DOUBLE SPACES (in the clean text) ──
        if '  ' in clean:
            report(fname, lineno, "Double space in text", raw, "Remove extra space")

        # ── REPEATED WORDS ──
        for m in re.finditer(r'\b(\w{3,})\s+\1\b', clean, re.IGNORECASE):
            word = m.group(0)
            # "that that" can be legit in "now that that's..." but flag anyway
            report(fname, lineno, f"Possible repeated word: '{word}'", raw, f"Remove duplicate '{m.group(1)}'")

        # ── MISSING SPACE AFTER COMMA/PERIOD (only in real text, not control codes) ──
        # Only check in clean version (controls stripped)
        if re.search(r'[a-zA-Z],[a-zA-Z]', clean):
            report(fname, lineno, "Missing space after comma", raw, "Add space after ','")
        
        # Period followed directly by capital letter (not abbreviations like A.M., O.D., etc.)
        for m in re.finditer(r'([a-z])\.([ ]?)([A-Z])', clean):
            if m.group(2) == '':  # no space
                # Check it's not an abbreviation context
                before = clean[max(0,m.start()-3):m.start()+4]
                if not re.match(r'[A-Z]\.[A-Z]\.', before):
                    pass  # too many false positives, skip

        # ── SPELLING ERRORS ──
        misspellings = [
            (r'\breciev', 'receive/received/receiving'),
            (r'\bbeliev(?!e)', 'believe (check spelling)'),  # too broad, skip
            (r'\bbeliev\b', None),
            (r'\bfreind', 'friend'),
            (r'\bthier\b', 'their'),
            (r'\bwierd\b', 'weird'),
            (r'\boccured\b', 'occurred'),
            (r'\boccuring\b', 'occurring'),
            (r'\bseperate\b', 'separate'),
            (r'\bdefinately\b', 'definitely'),
            (r'\bdefintely\b', 'definitely'),
            (r'\bfoward\b', 'forward'),
            (r'\buntill\b', 'until'),
            (r'\bproffesional\b', 'professional'),
            (r'\bgoverment\b', 'government'),
            (r'\bgovenment\b', 'government'),
            (r'\bthrought\b', 'thought or through'),
            (r'\bstregnth\b', 'strength'),
            (r'\bstrenth\b', 'strength'),
            (r'\bexisitng\b', 'existing'),
            (r'\bvilliage\b', 'village'),
            (r'\bmagican\b', 'magician'),
            (r'\bsolider\b', 'soldier'),
            (r'\bgaurd', 'guard'),
            (r'\bprobaly\b', 'probably'),
            (r'\binfomation\b', 'information'),
            (r'\bdisapear', 'disappear'),
            (r'\breaon\b', 'reason'),
            (r'\bunfortu[an]+tely\b', 'unfortunately'),
            (r'\bdestory\b', 'destroy'),
            (r'\bprotcet\b', 'protect'),
            (r'\bconviced\b', 'convinced'),
            (r'\bexpeirenced\b', 'experienced'),
            (r'\bopporutnity\b', 'opportunity'),
            (r'\bsacrafice\b', 'sacrifice'),
            (r'\bsurprized\b', 'surprised'),
            (r'\bextraordanary\b', 'extraordinary'),
            (r'\bpossiblity\b', 'possibility'),
            (r'\bneccesary\b', 'necessary'),
            (r'\bnecesary\b', 'necessary'),
            (r'\bimmedately\b', 'immediately'),
            (r'\bimmediatly\b', 'immediately'),
            (r'\bgenerel\b', 'general'),
            (r'\bemporer\b', 'emperor'),
            (r'\bsoldires\b', 'soldiers'),
            (r'\bvillians?\b', 'villain(s)'),
            (r'\bpowerfu\b(?!l)', 'powerful (missing l)'),
            (r'\bgratefull\b', 'grateful'),
            (r'\bbeautifull\b', 'beautiful'),
            (r'\bpowerfull\b', 'powerful'),
            (r'\bwonderfull\b', 'wonderful'),
            (r'\bsuccessfull\b', 'successful'),
            (r'\bhelpfull\b', 'helpful'),
            (r'\bharmfull\b', 'harmful'),
            (r'\bcarefull\b', 'careful'),
            (r'\bpeacefull\b', 'peaceful'),
            (r'\bfearfull\b', 'fearful'),
            (r'\bcolorfull\b', 'colorful'),
            (r'\bthankfull\b', 'thankful'),
            (r'\bshamefull\b', 'shameful'),
            (r'\bexistance\b', 'existence'),
            (r'\bintrest\b', 'interest'),
            (r'\bcontiue\b', 'continue'),
            (r'\bappraoch\b', 'approach'),
            (r'\batack\b', 'attack'),
            (r'\bteh\b', 'the'),
            (r'\bwihout\b', 'without'),
            (r'\bhte\b', 'the'),
            (r'\bfomr\b', 'from'),
            (r'\bsoemone\b', 'someone'),
            (r'\bbeleive\b', 'believe'),
            (r'\bbeforte\b', 'before'),
            (r'\bunderstadn\b', 'understand'),
            (r'\bpreapre\b', 'prepare'),
            (r'\bappologize\b', 'apologize'),
            (r'\bsuprise\b', 'surprise'),
            (r'\bsupprised\b', 'surprised'),
            (r'\bvicitm\b', 'victim'),
            (r'\bvicimt\b', 'victim'),
            (r'\bimportent\b', 'important'),
            (r'\bimporant\b', 'important'),
            (r'\bsomethig\b', 'something'),
            (r'\bsomethng\b', 'something'),
            (r'\beverythig\b', 'everything'),
            (r'\banythig\b', 'anything'),
            (r'\bnothing\b', None),
            (r'\bsomething\b', None),
            (r'\beverything\b', None),
            (r'\banything\b', None),
            (r'\bcompletely\b', None),
            (r'\bcompletly\b', 'completely'),
            (r'\bcompletley\b', 'completely'),
            (r'\boriginal\b', None),
            (r'\borignal\b', 'original'),
            (r'\bactually\b', None),
            (r'\bacutally\b', 'actually'),
            (r'\bactaully\b', 'actually'),
            (r'\bseriously\b', None),
            (r'\bseriosuly\b', 'seriously'),
            (r'\bserioulsy\b', 'seriously'),
            (r'\bespecially\b', None),
            (r'\bespecailly\b', 'especially'),
            (r'\bdifference\b', None),
            (r'\bdifernce\b', 'difference'),
            (r'\bdifferent\b', None),
            (r'\bdiferent\b', 'different'),
            (r'\bconsider\b', None),
            (r'\bconsidder\b', 'consider'),
            (r'\bpossible\b', None),
            (r'\bpossibe\b', 'possible'),
            (r'\bdefinite\b', None),
            (r'\bdefinite\b', None),
            (r'\bdescription\b', None),
            (r'\bdescirption\b', 'description'),
            (r'\bimmediately\b', None),
            (r'\bimmediate\b', None),
            (r'\bstraight\b', None),
            (r'\bstraigth\b', 'straight'),
            (r'\bperhaps\b', None),
            (r'\bprehaps\b', 'perhaps'),
            (r'\bpossibly\b', None),
            (r'\bpossiby\b', 'possibly'),
            (r'\bprobably\b', None),
            (r'\bprobably\b', None),
            (r'\bpermission\b', None),
            (r'\bpermision\b', 'permission'),
            (r'\bsituation\b', None),
            (r'\bsiutation\b', 'situation'),
            (r'\bstuation\b', 'situation'),
            (r'\bcombination\b', None),
            (r'\bcombnation\b', 'combination'),
            (r'\bcommunication\b', None),
            (r'\bcomunication\b', 'communication'),
            (r'\bconsciousness\b', None),
            (r'\bconcious\b', 'conscious'),
            (r'\bunconscious\b', None),
            (r'\bunconcious\b', 'unconscious'),
            (r'\bconfidence\b', None),
            (r'\bconfedence\b', 'confidence'),
            (r'\bconvince\b', None),
            (r'\bconvinced\b', None),
            (r'\bconvince\b', None),
            (r'\bdeceive\b', None),
            (r'\bdesceive\b', 'deceive'),
            (r'\bdisguise\b', None),
            (r'\bdisquise\b', 'disguise'),
            (r'\bengaged\b', None),
            (r'\bengageed\b', 'engaged'),
            (r'\benemies\b', None),
            (r'\benemeis\b', 'enemies'),
            (r'\benemy\b', None),
            (r'\bemphasized?\b', None),
            (r'\bemphsize\b', 'emphasize'),
            (r'\bexcellent\b', None),
            (r'\bexcelent\b', 'excellent'),
            (r'\bexcellennt\b', 'excellent'),
            (r'\bexecution\b', None),
            (r'\bexcution\b', 'execution'),
            (r'\bextremely\b', None),
            (r'\bextreamly\b', 'extremely'),
            (r'\bfundamental\b', None),
            (r'\bfundametal\b', 'fundamental'),
            (r'\bfuture\b', None),
            (r'\bfutre\b', 'future'),
            (r'\bgather\b', None),
            (r'\bgahter\b', 'gather'),
            (r'\bhonored?\b', None),
            (r'\bhonoured?\b', None),
            (r'\bhappened\b', None),
            (r'\bhapenned\b', 'happened'),
            (r'\bhappned\b', 'happened'),
            (r'\bidentify\b', None),
            (r'\bidentiy\b', 'identify'),
            (r'\bimpression\b', None),
            (r'\bimpresson\b', 'impression'),
            (r'\bimpressive\b', None),
            (r'\bimpresive\b', 'impressive'),
            (r'\bindividual\b', None),
            (r'\bindivdual\b', 'individual'),
            (r'\bintelligent\b', None),
            (r'\bintellignet\b', 'intelligent'),
            (r'\bintelligance\b', 'intelligence'),
            (r'\bintelligence\b', None),
            (r'\birresponsible\b', None),
            (r'\birresponsble\b', 'irresponsible'),
            (r'\bjealous\b', None),
            (r'\bjealousy\b', None),
            (r'\bjelous\b', 'jealous'),
            (r'\bknowledge\b', None),
            (r'\bknolwedge\b', 'knowledge'),
            (r'\bliberty\b', None),
            (r'\bliberry\b', 'library'),
            (r'\blibrary\b', None),
            (r'\blieutenant\b', None),
            (r'\bleutenant\b', 'lieutenant'),
            (r'\bliuetenant\b', 'lieutenant'),
            (r'\blogical\b', None),
            (r'\blogicall\b', 'logical'),
            (r'\bmagician\b', None),
            (r'\bmagicain\b', 'magician'),
            (r'\bmaintain\b', None),
            (r'\bmaitain\b', 'maintain'),
            (r'\bmaneuver\b', None),
            (r'\bmanuever\b', 'maneuver'),
            (r'\bmasacre\b', 'massacre'),
            (r'\bmassacre\b', None),
            (r'\bmercenary\b', None),
            (r'\bmercanary\b', 'mercenary'),
            (r'\bmerconary\b', 'mercenary'),
            (r'\bmiracle\b', None),
            (r'\bmiracle\b', None),
            (r'\bmiserable\b', None),
            (r'\bmusuem\b', 'museum'),
            (r'\bmuseum\b', None),
            (r'\bnecessary\b', None),
            (r'\bnegotiate\b', None),
            (r'\bnegociate\b', 'negotiate'),
            (r'\bnegotation\b', 'negotiation'),
            (r'\bnegotiation\b', None),
            (r'\bobvious\b', None),
            (r'\bobivous\b', 'obvious'),
            (r'\bopponent\b', None),
            (r'\bopponant\b', 'opponent'),
            (r'\borganize\b', None),
            (r'\borganise\b', None),
            (r'\borganize\b', None),
            (r'\bparticipate\b', None),
            (r'\bpartcipate\b', 'participate'),
            (r'\bperseverance\b', None),
            (r'\bperseverence\b', 'perseverance'),
            (r'\bphysical\b', None),
            (r'\bpysical\b', 'physical'),
            (r'\bprevious\b', None),
            (r'\bprevous\b', 'previous'),
            (r'\bprivilege\b', None),
            (r'\bprivelege\b', 'privilege'),
            (r'\bproceed\b', None),
            (r'\bprocede\b', 'proceed'),
            (r'\bprofessional\b', None),
            (r'\bprofesional\b', 'professional'),
            (r'\bpromise\b', None),
            (r'\bpromiss\b', 'promise'),
            (r'\bprotect\b', None),
            (r'\bprotecet\b', 'protect'),
            (r'\bpurpose\b', None),
            (r'\bpurpuse\b', 'purpose'),
            (r'\bquickly\b', None),
            (r'\bquikly\b', 'quickly'),
            (r'\brather\b', None),
            (r'\braher\b', 'rather'),
            (r'\brecognize\b', None),
            (r'\brecognise\b', None),
            (r'\breluctant\b', None),
            (r'\brelucant\b', 'reluctant'),
            (r'\bremember\b', None),
            (r'\brember\b', 'remember'),
            (r'\brememebr\b', 'remember'),
            (r'\bresemble\b', None),
            (r'\bresemle\b', 'resemble'),
            (r'\bresponsible\b', None),
            (r'\bresponsble\b', 'responsible'),
            (r'\bretreat\b', None),
            (r'\bretret\b', 'retreat'),
            (r'\bsacrifice\b', None),
            (r'\bsatisfied\b', None),
            (r'\bsatisified\b', 'satisfied'),
            (r'\bscenario\b', None),
            (r'\bsceanrio\b', 'scenario'),
            (r'\bsentence\b', None),
            (r'\bsentance\b', 'sentence'),
            (r'\bseparate\b', None),
            (r'\bserious\b', None),
            (r'\bseriouis\b', 'serious'),
            (r'\bsignificant\b', None),
            (r'\bsignifcant\b', 'significant'),
            (r'\bsimply\b', None),
            (r'\bsimlpy\b', 'simply'),
            (r'\bsoldier\b', None),
            (r'\bsoldiers\b', None),
            (r'\bspecifically\b', None),
            (r'\bspecificaly\b', 'specifically'),
            (r'\bstrategy\b', None),
            (r'\bstregth\b', 'strength'),
            (r'\bstrenght\b', 'strength'),
            (r'\bstrength\b', None),
            (r'\bsuccessful\b', None),
            (r'\bsuddenly\b', None),
            (r'\bsudenly\b', 'suddenly'),
            (r'\bsudddenly\b', 'suddenly'),
            (r'\bsupport\b', None),
            (r'\bsurroundings?\b', None),
            (r'\bsurvive\b', None),
            (r'\bsuspicious\b', None),
            (r'\bsuspicous\b', 'suspicious'),
            (r'\bsympathy\b', None),
            (r'\bsympathy\b', None),
            (r'\bsymphathy\b', 'sympathy'),
            (r'\btechnology\b', None),
            (r'\btechnolgy\b', 'technology'),
            (r'\btemporary\b', None),
            (r'\btemproary\b', 'temporary'),
            (r'\bterritorial\b', None),
            (r'\bterritories\b', None),
            (r'\bterritory\b', None),
            (r'\bthroughout\b', None),
            (r'\bthruout\b', 'throughout'),
            (r'\btransfer\b', None),
            (r'\btransfor\b', 'transfer'),
            (r'\btransform\b', None),
            (r'\btreasure\b', None),
            (r'\btreasure\b', None),
            (r'\btreacherous\b', None),
            (r'\btreachrous\b', 'treacherous'),
            (r'\btriumph\b', None),
            (r'\btriumf\b', 'triumph'),
            (r'\bundoubtedly\b', None),
            (r'\bundoubtely\b', 'undoubtedly'),
            (r'\bunnecessary\b', None),
            (r'\bunnecesary\b', 'unnecessary'),
            (r'\bunusual\b', None),
            (r'\bunusal\b', 'unusual'),
            (r'\bvarious\b', None),
            (r'\bvarious\b', None),
            (r'\bvengeance\b', None),
            (r'\bvegence\b', 'vengeance'),
            (r'\bvictory\b', None),
            (r'\bvigilant\b', None),
            (r'\bvigilence\b', 'vigilance'),
            (r'\bvigilance\b', None),
            (r'\bviolence\b', None),
            (r'\bviolance\b', 'violence'),
            (r'\bwhatever\b', None),
            (r'\bwhatver\b', 'whatever'),
            (r'\bwherever\b', None),
            (r'\bwherver\b', 'wherever'),
            (r'\bwhether\b', None),
            (r'\bwether\b', 'whether'),
            (r'\bwhichever\b', None),
            (r'\bwhoever\b', None),
            (r'\bwilling\b', None),
            (r'\bwiling\b', 'willing'),
            (r'\bwitness\b', None),
            (r'\bwitenss\b', 'witness'),
            (r'\bworthwhile\b', None),
            (r'\bwrong\b', None),
            (r'\byesterday\b', None),
            (r'\byersterday\b', 'yesterday'),
        ]
        
        for pattern, fix in misspellings:
            if fix is None:
                continue
            if re.search(pattern, clean, re.IGNORECASE):
                report(fname, lineno, f"Spelling: {fix}", raw, fix)

        # ── MISSING APOSTROPHES in contractions ──
        # Very careful - only flag clear cases where word cannot be anything else
        contraction_checks = [
            # Pattern, possible_valid_word, suggested_fix
            (r'\bdont\b', "don't"),
            (r'\bdoesnt\b', "doesn't"),
            (r'\bdidnt\b', "didn't"),
            (r'\bcant\b', "can't"),
            (r'\bcouldnt\b', "couldn't"),
            (r'\bwouldnt\b', "wouldn't"),
            (r'\bshouldnt\b', "shouldn't"),
            (r'\bisnt\b', "isn't"),
            (r'\barent\b', "aren't"),
            (r'\bwasnt\b', "wasn't"),
            (r'\bwerent\b', "weren't"),
            (r'\bhavent\b', "haven't"),
            (r'\bhasnt\b', "hasn't"),
            (r'\bwont\b', "won't"),
            (r'\bwhats\b', "what's"),
            (r'\bthats\b', "that's"),
            (r'\bwhos\b', "who's"),
            (r'\byouve\b', "you've"),
            (r'\byoud\b', "you'd"),
            (r'\byoull\b', "you'll"),
            (r'\bweve\b', "we've"),
            (r'\bwed\b', "we'd"),
            (r'\btheyre\b', "they're"),
            (r'\btheyd\b', "they'd"),
            (r'\btheyll\b', "they'll"),
            (r'\btheyve\b', "they've"),
            (r'\bhes\b', "he's"),
            (r'\bshes\b', "she's"),
            (r'\bhed\b', "he'd"),
        ]
        
        for pattern, fix in contraction_checks:
            if re.search(pattern, clean, re.IGNORECASE):
                m = re.search(pattern, clean, re.IGNORECASE)
                word = m.group(0)
                # Skip "wont" as it can mean "accustomed"
                if pattern == r'\bwont\b':
                    # Check context
                    ctx_start = max(0, m.start() - 10)
                    ctx = clean[ctx_start:m.end()+10]
                    # Only flag if it's clearly a contraction context
                    if not re.search(r'\b(his|her|my|their|our|your)\s+wont\b', clean, re.IGNORECASE):
                        report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)
                elif pattern == r'\bwed\b':
                    # "wed" can mean married
                    ctx_start = max(0, m.start() - 15)
                    ctx = clean[ctx_start:m.end()+15]
                    if re.search(r'\bget\s+wed\b|\bwed\s+(?:him|her|them)\b', clean, re.IGNORECASE):
                        pass  # real word
                    else:
                        report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)
                elif pattern == r'\bhes\b':
                    # "hes" is unlikely to be a real word
                    report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)
                elif pattern == r'\bshes\b':
                    report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)
                elif pattern == r'\bhed\b':
                    # "hed" can be hedgehog abbreviation? Unlikely in game text
                    ctx_start = max(0, m.start() - 5)
                    ctx = clean[ctx_start:m.end()+10].lower()
                    report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)
                else:
                    report(fname, lineno, f"Possible missing apostrophe: '{word}' → '{fix}'", raw, fix)

        # ── "AN" vs "A" before vowels ──
        for m in re.finditer(r'\ba ([aeiou][a-zA-Z]{2,})\b', clean):
            word = m.group(1).lower()
            # Exceptions: words starting with vowel letter but consonant sound
            exceptions = {
                'use', 'used', 'uses', 'using', 'user', 'users', 'useful',
                'unit', 'units', 'united', 'uniform', 'uniforms', 'uniformed',
                'unique', 'union', 'unions', 'unification',
                'usual', 'usually', 'unusual', 'unusually',
                'once', 'one', 'ones',
                'universe', 'universal', 'universally', 'university', 'universities',
                'urgent', 'urgently', 'urgency',
                'european', 'euro', 'euros',
                'eulogy',
            }
            if word not in exceptions:
                report(fname, lineno, f"Article: 'a {m.group(1)}' should be 'an {m.group(1)}'",
                       raw, f"'an {m.group(1)}'")
        
        # ── SUBJECT-VERB AGREEMENT ──
        agreement_errors = [
            (r'\bI are\b', "I am"),
            (r'\bhe are\b', "he is"),
            (r'\bshe are\b', "she is"),
            (r'\bit are\b', "it is"),
            (r'\bI is\b', "I am"),
            (r'\bwe is\b', "we are"),
            (r'\bthey is\b', "they are"),
            # "I were" flagged ONLY when not clearly subjunctive
            # Subjunctive: "if I were", "as if I were", "I wish I were"
            # Grammar error: "I were born", "I were told" (indicative mood)
        ]
        for pattern, fix in agreement_errors:
            if re.search(pattern, clean, re.IGNORECASE):
                report(fname, lineno, f"Subject-verb agreement: '{pattern}'", raw, fix)
        
        # "I were" - only flag when not in subjunctive context
        for m in re.finditer(r'\bI were\b', clean, re.IGNORECASE):
            ctx_start = max(0, m.start() - 20)
            ctx = clean[ctx_start:m.end()].lower()
            # Subjunctive triggers: "if", "as if", "wish", "imagine", "suppose", "even if"
            if not re.search(r'\b(if|as if|wish|imagine|suppose|even if|what if)\b', ctx):
                report(fname, lineno, "Grammar: 'I were' in non-subjunctive context (should be 'I was')", raw, "I was")
        
        # ── AWKWARD PHRASING / SPECIFIC ISSUES ──
        # "the the" 
        if re.search(r'\bthe the\b', clean, re.IGNORECASE):
            report(fname, lineno, "Repeated article: 'the the'", raw, "Remove duplicate 'the'")
        
        # "a a" or "an an"
        if re.search(r'\ba a\b|\ban an\b', clean, re.IGNORECASE):
            report(fname, lineno, "Repeated article", raw, "Remove duplicate article")
        
        # Missing space between words: lowercase letter directly touching uppercase (not inside a name like "MacDonald")
        for m in re.finditer(r'[a-z][A-Z]', clean):
            pos = m.start()
            # Make sure this isn't at start of a name/title
            before = clean[max(0,pos-5):pos+2]
            # Skip if after a quote or bracket
            if not re.search(r'[\(\[\'""]', clean[max(0,pos-1):pos+1]):
                report(fname, lineno, f"Possible missing space: '{clean[max(0,pos-3):pos+5]}'", raw, "Add space")
            break  # only report once per line to avoid spam

for fname, lineno, issue, text, fix in issues:
    print(f"FILE: {fname}")
    print(f"LINE: {lineno}")
    print(f"ISSUE: {issue}")
    print(f"TEXT: {text}")
    print(f"FIX: {fix}")
    print()

print(f"Total: {len(issues)} issues")
