#!/usr/bin/env python3
import os
import re

files = [
    "00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]",
    "00000029.SCEN CHAPTER 19.2 (Past Celestial Ship) [TRANSLATED]",
    "00000030.SCEN CHAPTER 14.3 (Makinus City 2) [TRANSLATED]",
    "00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]",
    "00000032.SCEN CHAPTER 2.4 (Dastis City) [TRANSLATED]",
    "00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]",
    "00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]",
    "00000037.SCEN CHAPTER 13.1 (Leystan 2) [TRANSLATED]",
    "00000038.SCEN CHAPTER 14.3 (Royferon) [TRANSLATED]",
    "00000040.SCEN CHAPTER 15.1 (El Hingis) [TRANSLATED]",
    "00000041.SCEN CHAPTER 16.3 (Great Land Village) [TRANSLATED]",
    "00000042.SCEN CHAPTER 6.5 (Pothrad village) [TRANSLATED]",
    "00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [TRANSLATED]",
    "00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [TRANSLATED]",
    "00000046.SCEN CHAPTER 2.2 (Monopolis HQ) [TRANSLATED]",
    "00000047.SCEN CHAPTER 14.1 (Monopolis HQ 2) [TRANSLATED]",
    "00000048.SCEN CHAPTER 6.3 [TRANSLATED]",
    "00000049.SCEN CHAPTER 5.3 [TRANSLATED]",
    "00000050.SCEN CHAPTER 5.2 [TRANSLATED]",
    "00000051.SCEN CHAPTER 4.7 [TRANSLATED]",
    "00000052.SCEN CHAPTER 4.6 [TRANSLATED]",
]

base_dir = "source/GL6_SCEN.DAT"
issues = []

# Common patterns to check
def check_grammar(eng_text, filename):
    errors = []
    
    # Skip dialect files
    is_dialect = filename in ["00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]",
                              "00000079.SCEN", "00000086.SCEN"]
    
    # Basic grammar checks
    if not is_dialect:
        # Double spaces
        if "  " in eng_text:
            errors.append("double spaces")
        
        # Common typos
        if " dont " in eng_text.lower() or eng_text.lower().startswith("dont "):
            errors.append("missing apostrophe in don't")
        if " cant " in eng_text.lower() or eng_text.lower().startswith("cant "):
            errors.append("missing apostrophe in can't")
        if " wont " in eng_text.lower() or eng_text.lower().startswith("wont "):
            errors.append("missing apostrophe in won't")
        if " isnt " in eng_text.lower() or eng_text.lower().startswith("isnt "):
            errors.append("missing apostrophe in isn't")
        if " didnt " in eng_text.lower() or eng_text.lower().startswith("didnt "):
            errors.append("missing apostrophe in didn't")
    
    return errors

for filename in files:
    filepath = os.path.join(base_dir, filename)
    if not os.path.exists(filepath):
        print(f"WARNING: File not found: {filepath}")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    i = 0
    while i < len(lines):
        line = lines[i].rstrip('\n')
        
        # Check if this is a Japanese comment
        if line.startswith("//"):
            japanese = line[2:].strip()
            # Get the English translation (next non-empty, non-comment line)
            j = i + 1
            english = ""
            eng_line_num = i + 2  # 1-indexed, next line
            
            while j < len(lines):
                next_line = lines[j].rstrip('\n')
                if next_line and not next_line.startswith("//"):
                    english = next_line
                    eng_line_num = j + 1
                    break
                j += 1
            
            if english and not english.startswith("[") and not english.startswith("{"):
                # Check for grammar issues
                grammar_issues = check_grammar(english, filename)
                for issue in grammar_issues:
                    issues.append({
                        'file': filename,
                        'line': eng_line_num,
                        'japanese': japanese,
                        'english': english,
                        'reason': issue
                    })
        
        i += 1

# Print found issues
if issues:
    for issue in issues:
        print(f"FILE: {issue['file']}")
        print(f"LINE: {issue['line']}")
        print(f"JAPANESE: {issue['japanese']}")
        print(f"CURRENT ENGLISH: {issue['english']}")
        print(f"REASON: {issue['reason']}")
        print()
else:
    print("Initial automated scan complete. Manual review of content needed.")
