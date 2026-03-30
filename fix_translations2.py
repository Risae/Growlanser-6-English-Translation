import os

BASE = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT"

def fix_file(filename, replacements):
    filepath = os.path.join(BASE, filename)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content
    count = 0
    for old, new in replacements:
        occurrences = content.count(old)
        if occurrences > 0:
            content = content.replace(old, new)
            count += occurrences
            print(f"  [{occurrences}x] {repr(old[:70])} -> {repr(new[:70])}")
        else:
            print(f"  [NOT FOUND] {repr(old[:70])}")
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
    return count

total = 0

# ==================== 00000028.SCEN CHAPTER 4.1 ====================
print("\n=== Chapter 4.1 (Ship to Goatland) ===")
total += fix_file("00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]", [
    ("to choice but to buy it from a broker", "no choice but to buy it from a broker"),
    ("strength seems to[NLINE]\nderived from", "strength seems to be[NLINE]\nderived from"),
])

# ==================== 00000031.SCEN CHAPTER 2.1 ====================
print("\n=== Chapter 2.1 (Makinus City) ===")
total += fix_file("00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]", [
    ("big deal out[NLINE]\nguarding this place", "big deal out of[NLINE]\nguarding this place"),
    ("[COL01]Pollumine[COL00], Monoplis[NLINE]\ncan not only contribute", "[COL01]Pollumine[COL00], Monopolis[NLINE]\ncan not only contribute"),
])

# ==================== 00000032.SCEN CHAPTER 2.4 ====================
print("\n=== Chapter 2.4 (Dastis City) ===")
total += fix_file("00000032.SCEN CHAPTER 2.4 (Dastis City) [TRANSLATED]", [
    ("Where could be a[NLINE]\nplace with design technology?", "Where could there be a[NLINE]\nplace with design technology?"),
])

# ==================== 00000034.SCEN CHAPTER 3.1 ====================
print("\n=== Chapter 3.1 (Schizarz) ===")
total += fix_file("00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]", [
    ("the whole[NLINE]\nthe world will turn into dungeon", "the whole[NLINE]\nworld will turn into dungeon"),
    ("Did he really say those[NLINE]\nthings out loud", "Did she really say those[NLINE]\nthings out loud"),
    ("see is she's[NLINE]\nstill there!", "see if she's[NLINE]\nstill there!"),
    # "important thing is create a" - need 3 distinct replacements
    ("The important thing is create a[NLINE]\nsituation that is advantageous to[NLINE]\nyou. Keep this in mind if you[NLINE]\nwant to get stronger.[END-FE]",
     "The important thing is to create a[NLINE]\nsituation that is advantageous to[NLINE]\nyou. Keep this in mind if you[NLINE]\nwant to get stronger.[END-FE]"),
    ("thing is create a situation that[NLINE]\nis advantageous to you. Keep this[NLINE]\nin mind if you want to get stronger.[END-FE]",
     "thing is to create a situation that[NLINE]\nis advantageous to you. Keep this[NLINE]\nin mind if you want to get stronger.[END-FE]"),
    ("We have to choice but to stop[NLINE]\nthe giant as quickly as we can", "We have no choice but to stop[NLINE]\nthe giant as quickly as we can"),
])

# ==================== 00000043.SCEN CHAPTER 1 ====================
print("\n=== Chapter 1 (Lennox Facility 1) ===")
total += fix_file("00000043.SCEN CHAPTER 1 (Lennox Facility 1) [EDITED]", [
    ("have take a peek at your name tag", "have to take a peek at your name tag"),
])

# ==================== 00000049.SCEN CHAPTER 5.3 ====================
print("\n=== Chapter 5.3 ===")
total += fix_file("00000049.SCEN CHAPTER 5.3 [TRANSLATED]", [
    ("pass through this environment[NLINE]\nfor a long time[END-FE]", "pass through this environment[NLINE]\nfor a long time?[END-FE]"),
    ("Ziekwalt seemed to have[NLINE]\ntook it away.", "Ziekwalt seemed to have[NLINE]\ntaken it away."),
])

# ==================== 00000050.SCEN CHAPTER 5.2 ====================
print("\n=== Chapter 5.2 ===")
total += fix_file("00000050.SCEN CHAPTER 5.2 [TRANSLATED]", [
    ("we won't get picked up[NLINE]\nuntil quite a while.", "we won't get picked up[NLINE]\nfor quite a while."),
    ("are scared of their lives because[NLINE]\nbecause of their actions?", "are scared for their lives because[NLINE]\nof their actions?"),
])

# ==================== 00000056.SCEN CHAPTER 7.1 ====================
print("\n=== Chapter 7.1 ===")
total += fix_file("00000056.SCEN CHAPTER 7.1 [TRANSLATED]", [
    ("it used[NLINE]\nwatch over the countries of this continent from", 
     "it used to[NLINE]\nwatch over the countries of this continent from"),
])

# ==================== 00000074.SCEN CHAPTER 4.2 ====================
print("\n=== Chapter 4.2 (Warslee village) ===")
total += fix_file("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", [
    ("How could they what was going[NLINE]\nto happen now?", "How could they know what was going[NLINE]\nto happen?"),
])

# ==================== 00000082.SCEN CHAPTER 5.1 ====================
print("\n=== Chapter 5.1 (Jaergen) ===")
total += fix_file("00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]", [
    ("made it out[NLINE]\nsome navy blue fabric I had laying[NLINE]\naround.", 
     "made it out of[NLINE]\nsome navy blue fabric I had lying[NLINE]\naround."),
    ("made it out[NLINE]\nsome green fabric I had laying[NLINE]\naround.",
     "made it out of[NLINE]\nsome green fabric I had lying[NLINE]\naround."),
])

# ==================== 00000005.SCEN Prologue Tutorial ====================
print("\n=== Prologue Tutorial ===")
total += fix_file("00000005.SCEN Prologue Tutorial [EDITED]", [
    ("you won't able[NLINE]\nto devise any strategies.", "you won't be able[NLINE]\nto devise any strategies."),
])

print(f"\n\nTotal additional fixes: {total}")
