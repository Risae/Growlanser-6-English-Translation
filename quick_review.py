#!/usr/bin/env python3
import os
import re

files_to_check = [
    "00000053.SCEN CHAPTER 4.4 [TRANSLATED]",
    "00000054.SCEN CHAPTER 10.6 [TRANSLATED]",
    "00000055.SCEN CHAPTER 10.4 [TRANSLATED]",
    "00000056.SCEN CHAPTER 7.1 [TRANSLATED]",
    "00000057.SCEN CHAPTER 4.3 [TRANSLATED]",
    "00000058.SCEN CHAPTER 10.5 [TRANSLATED]",
    "00000060.SCEN CHAPTER 17.1 [TRANSLATED]",
    "00000063.SCEN CHAPTER 17.2 (Juwaina Cave) [TRANSLATED]",
    "00000065.SCEN CHAPTER X.X (Goatland Cave) [TRANSLATED]",
    "00000069.SCEN CHAPTER 7.2 (Kaiser Island) [TRANSLATED]",
    "00000073.SCEN CHAPTER 10.1 (PMB HQ) [TRANSLATED]",
    "00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]",
    "00000075.SCEN CHAPTER 6.4 (Felmentia) [TRANSLATED]",
    "00000076.SCEN CHAPTER X.X (Zerdok) [TRANSLATED]",
    "00000077.SCEN CHAPTER X.X (Rio Rey) [TRANSLATED]",
    "00000078.SCEN CHAPTER 4.5 (Zaramba) [TRANSLATED]",
    "00000079.SCEN CHAPTER 6.1 (Totuwa) [TRANSLATED]",
    "00000080.SCEN CHAPTER 4.8 (Geilenach) [TRANSLATED]",
    "00000081.SCEN CHAPTER X.X (Juwaina) [TRANSLATED]",
    "00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]",
    "00000083.SCEN CHAPTER 10.2 (PMB HQ 2) [TRANSLATED]",
]

base_dir = "source/GL6_SCEN.DAT"
issues = []

# Common errors to check
def check_common_errors(filename, line_num, japanese, english):
    errors = []
    
    # Skip dialect files
    if filename in ["00000079.SCEN CHAPTER 6.1 (Totuwa) [TRANSLATED]"]:
        # Allow intentional dialect
        pass
    
    # Check for common spelling/grammar
    if " dont " in english or " Dont " in english:
        errors.append(("Missing apostrophe in don't", english, english.replace(" dont ", " don't ").replace(" Dont ", " Don't ")))
    if " cant " in english or " Cant " in english:
        errors.append(("Missing apostrophe in can't", english, english.replace(" cant ", " can't ").replace(" Cant ", " Can't ")))
    if " wont " in english or " Wont " in english:
        errors.append(("Missing apostrophe in won't", english, english.replace(" wont ", " won't ").replace(" Wont ", " Won't ")))
    if " didnt " in english:
        errors.append(("Missing apostrophe in didn't", english, english.replace(" didnt ", " didn't ")))
    if " wouldnt " in english:
        errors.append(("Missing apostrophe in wouldn't", english, english.replace(" wouldnt ", " wouldn't ")))
    if " im " in english.lower() and not "[NWI" in english:
        errors.append(("Missing apostrophe in I'm", english, english.replace(" im ", " I'm ").replace(" Im ", " I'm ")))
    
    # Check for double spaces
    if "  " in english and "[" not in english:
        errors.append(("Double space", english, english.replace("  ", " ")))
    
    return errors

for filename in files_to_check:
    filepath = os.path.join(base_dir, filename)
    if not os.path.exists(filepath):
        continue
        
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    i = 0
    while i < len(lines):
        line = lines[i].rstrip()
        if line.startswith("//"):
            japanese = line[2:].strip()
            # Next line should be English
            if i + 1 < len(lines):
                english_line = lines[i + 1].rstrip()
                if not english_line.startswith("//"):
                    errors = check_common_errors(filename, i + 2, japanese, english_line)
                    for reason, current, suggested in errors:
                        issues.append({
                            'file': filename,
                            'line': i + 2,
                            'japanese': japanese,
                            'current': current,
                            'suggested': suggested,
                            'reason': reason
                        })
        i += 1

# Print issues
for issue in issues:
    print(f"FILE: {issue['file']}")
    print(f"LINE: {issue['line']}")
    print(f"JAPANESE: {issue['japanese']}")
    print(f"CURRENT ENGLISH: {issue['current']}")
    print(f"SUGGESTED FIX: {issue['suggested']}")
    print(f"REASON: {issue['reason']}")
    print()

print(f"Total issues found: {len(issues)}")
