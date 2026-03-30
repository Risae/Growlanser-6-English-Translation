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
            print(f"  [{occurrences}x] {repr(old[:60])} -> {repr(new[:60])}")
        else:
            print(f"  [NOT FOUND] {repr(old[:60])}")
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
    return count

total = 0

# ==================== 00000005.SCEN Prologue Tutorial ====================
print("\n=== Prologue Tutorial ===")
total += fix_file("00000005.SCEN Prologue Tutorial [EDITED]", [
    ("you won't able\n", "you won't be able\n"),
    ("the ATW Gauge has ran out", "the ATW Gauge has run out"),
])

# ==================== 00000006.SCEN CHAPTER 2.3 ====================
print("\n=== Chapter 2.3 ===")
total += fix_file("00000006.SCEN CHAPTER 2.3 [TRANSLATED]", [
    ("When the action completed, the party member", "When the action is completed, the party member"),
])

# ==================== 00000009.SCEN CHAPTER 8.3 ====================
print("\n=== Chapter 8.3 ===")
total += fix_file("00000009.SCEN CHAPTER 8.3 [TRANSLATED]", [
    ("rivals moreso than brothers", "rivals more so than brothers"),
])

# ==================== 00000010.SCEN CHAPTER 12.2 ====================
print("\n=== Chapter 12.2 ===")
total += fix_file("00000010.SCEN CHAPTER 12.2 [TRANSLATED]", [
    ("・How bothersome..[END-FE]", "・How bothersome...[END-FE]"),
])

# ==================== 00000011.SCEN CHAPTER 14.2 ====================
print("\n=== Chapter 14.2 ===")
total += fix_file("00000011.SCEN CHAPTER 14.2 [TRANSLATED]", [
    ("That reminds, they prepared", "That reminds me, they prepared"),
])

# ==================== 00000028.SCEN CHAPTER 4.1 (Ship to Goatland) ====================
print("\n=== Chapter 4.1 (Ship to Goatland) ===")
total += fix_file("00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]", [
    ("the boat. Everyday we dealt with", "the boat. Every day we dealt with"),
    ("Expect to pay a steep price for it..[END-FE]", "Expect to pay a steep price for it.[END-FE]"),
    ("you have to choice but to buy it from a broker", "you have no choice but to buy it from a broker"),
    ("Captain Shuweizer's strength seems to\nderived from", "Captain Shuweizer's strength seems to be\nderived from"),
])

# ==================== 00000031.SCEN CHAPTER 2.1 (Makinus City) ====================
print("\n=== Chapter 2.1 (Makinus City) ===")
total += fix_file("00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]", [
    ("It's a far-way problem for now,", "It's a faraway problem for now,"),
    ("they make a big deal out\nguarding this place", "they make a big deal out of\nguarding this place"),
    ("terrorists, starting referring to him as", "terrorists started referring to him as"),
    ("Monoplis can not only contribute to", "Monopolis can not only contribute to"),
    ("[COL01]Pollumine[COL00], Monoplis\n", "[COL01]Pollumine[COL00], Monopolis\n"),
    ("There's no other building the whole world,", "There's no other building in the whole world,"),
    ("Rukias doesn't have a one, does he?", "Rukias doesn't have one, does he?"),
])

# ==================== 00000032.SCEN CHAPTER 2.4 (Dastis City) ====================
print("\n=== Chapter 2.4 (Dastis City) ===")
total += fix_file("00000032.SCEN CHAPTER 2.4 (Dastis City) [TRANSLATED]", [
    ("Where could be a\nplace with design technology?", "Where could there be a\nplace with design technology?"),
    ("when that times comes", "when that time comes"),
])

# ==================== 00000034.SCEN CHAPTER 3.1 (Schizarz) ====================
print("\n=== Chapter 3.1 (Schizarz) ===")
total += fix_file("00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]", [
    ("If she keep this up,", "If she keeps this up,"),
    ("all the wells in the whole\nthe world will turn into dungeon", "all the wells in the whole\nworld will turn into dungeon"),
    ("We have to teke back the rod from", "We have to take back the rod from"),
    ("No way! Did he really say those\nthings out loud", "No way! Did she really say those\nthings out loud"),
    ("village and see is she's\nstill there!", "village and see if she's\nstill there!"),
    ("come out hiding... However,", "come out of hiding... However,"),
    ("The important thing is create a\nsituation that is advantageous to\nyou. Keep this in mind if you\nwant to get stronger.[END-FE]\n・Reply", "The important thing is to create a\nsituation that is advantageous to\nyou. Keep this in mind if you\nwant to get stronger.[END-FE]\n・Reply"),
    ("thing is create a situation that\nis advantageous to you. Keep this\nin mind if you want to get stronger.[END-FE]\n・Remain silent", "thing is to create a situation that\nis advantageous to you. Keep this\nin mind if you want to get stronger.[END-FE]\n・Remain silent"),
    ("The important thing is create a\nsituation that is advantageous to\nyou. Keep this in mind if you\nwant to get stronger.[END-FE]\n\n\n//POINTER", "The important thing is to create a\nsituation that is advantageous to\nyou. Keep this in mind if you\nwant to get stronger.[END-FE]\n\n\n//POINTER"),
    ("We have to choice but to stop\nthe giant as quickly as we can", "We have no choice but to stop\nthe giant as quickly as we can"),
])

# ==================== 00000036.SCEN CHAPTER 8.2 (Leystan) ====================
print("\n=== Chapter 8.2 (Leystan) ===")
total += fix_file("00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]", [
    ("・One of your companies dies", "・One of your companions dies"),
    ("That's why there also still Fomeros", "That's why there are also still Fomeros"),
    ("...It's like the Formeros army", "...It's like the Fomeros army"),
    ("We of the Formeros army keep a close", "We of the Fomeros army keep a close"),
])

# ==================== 00000043.SCEN CHAPTER 1 (Lennox Facility 1) ====================
print("\n=== Chapter 1 (Lennox Facility 1) ===")
total += fix_file("00000043.SCEN CHAPTER 1 (Lennox Facility 1) [EDITED]", [
    ("This is Lenox Research Facility.", "This is the Lennox Research Facility."),
    ("Lenox Facility[END-FE]", "Lennox Facility[END-FE]"),
    ("on the Lenox Research Facility...", "on the Lennox Research Facility..."),
    ("tell me how you got chest wound.", "tell me how you got a chest wound."),
    ("hunch that there will an enemy attack", "hunch that there will be an enemy attack"),
    ("I'll just\nhave take a peek at your name tag", "I'll just\nhave to take a peek at your name tag"),
])

# ==================== 00000046.SCEN CHAPTER 2.2 (Monopolis HQ) ====================
print("\n=== Chapter 2.2 (Monopolis HQ) ===")
total += fix_file("00000046.SCEN CHAPTER 2.2 (Monopolis HQ) [TRANSLATED]", [
    ("Then room used for product presentations", "The room used for product presentations"),
    ("・Ask her what is she doing", "・Ask her what she is doing"),
])

# ==================== 00000049.SCEN CHAPTER 5.3 ====================
print("\n=== Chapter 5.3 ===")
total += fix_file("00000049.SCEN CHAPTER 5.3 [TRANSLATED]", [
    ("On the way lies a village [COL01]Totuwa[COL00].", "On the way lies a village called [COL01]Totuwa[COL00]."),
    ("If you got no money, you can't go aboard.", "If you have no money, you can't go aboard."),
    ("pass through this environment\nfor a long time[END-FE]", "pass through this environment\nfor a long time?[END-FE]"),
    ("someone named Ziekwalt seemed to have\ntook it away.", "someone named Ziekwalt seemed to have\ntaken it away."),
    ("・Ask what is the purpose of his journey is", "・Ask what the purpose of his journey is"),
    ("...What are planning to do!?", "...What are you planning to do!?"),
])

# ==================== 00000050.SCEN CHAPTER 5.2 ====================
print("\n=== Chapter 5.2 ===")
total += fix_file("00000050.SCEN CHAPTER 5.2 [TRANSLATED]", [
    ("we won't get picked up\nuntil quite a while.", "we won't get picked up\nfor quite a while."),
    ("Until then, uur task is to land", "Until then, our task is to land"),
    ("・All party member die[END-FE]", "・All party members die[END-FE]"),
    ("It's true that they're are rumors", "It's true that there are rumors"),
    ("are scared of their lives because\nbecause of their actions?", "are scared for their lives because\nof their actions?"),
])

# ==================== 00000056.SCEN CHAPTER 7.1 ====================
print("\n=== Chapter 7.1 ===")
total += fix_file("00000056.SCEN CHAPTER 7.1 [TRANSLATED]", [
    ("it used\nwatch over the countries of this continent from", "it used to\nwatch over the countries of this continent from"),
])

# ==================== 00000074.SCEN CHAPTER 4.2 (Warslee village) ====================
print("\n=== Chapter 4.2 (Warslee village) ===")
total += fix_file("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", [
    ("Oh, the village no longer in ruins!", "Oh, the village is no longer in ruins!"),
    ("step by and properly thank them!", "stop by and properly thank them!"),
    ("We don't call this content Goatland,", "We don't call this continent Goatland,"),
    ("How could they what was going\nto happen now?", "How could they know what was going\nto happen?"),
])

# ==================== 00000082.SCEN CHAPTER 5.1 (Jaergen) ====================
print("\n=== Chapter 5.1 (Jaergen) ===")
total += fix_file("00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]", [
    ("Gemstone cause various effects.", "Gemstones cause various effects."),
    ("Here you go. I made it out\nsome navy blue fabric I had laying\naround.", "Here you go. I made it out of\nsome navy blue fabric I had lying\naround."),
    ("Here you go. I made it out\nsome green fabric I had laying\naround.", "Here you go. I made it out of\nsome green fabric I had lying\naround."),
])

# ==================== 00000084.SCEN CHAPTER 9.1 (Guardian's Village) ====================
print("\n=== Chapter 9.1 (Guardian's Village) ===")
total += fix_file("00000084.SCEN CHAPTER 9.1 (Guardian's Village) [TRANSLATED]", [
    ("They're supposed to be clan that", "They're supposed to be a clan that"),
])

# ==================== 00000151.STXT Item Descriptions ====================
print("\n=== Item Descriptions ===")
total += fix_file("00000151.STXT Item Descriptions [TRANSLATED]", [
    ("basement of the Lenox Institute.", "basement of the Lennox Institute."),
    ("Lenox Facility.[END-FF]", "Lennox Facility.[END-FF]"),
    ("Lenox Facility. It's out of ink", "Lennox Facility. It's out of ink"),
])

# ==================== 00000157.STXT Menu Help ====================
print("\n=== Menu Help ===")
total += fix_file("00000157.STXT Menu Help [TRANSLATED]", [
    ("Grayed-out item cannot be purchased with your current funds.", "Grayed-out items cannot be purchased with your current funds."),
])

print(f"\n\nTotal fixes applied: {total}")
