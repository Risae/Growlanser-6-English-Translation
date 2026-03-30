import os

BASE = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT/"

fixes = [
    # File: 00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]
    ("00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]", "One of your companies dies", "One of your companions dies"),

    # File: 00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]
    ("00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]", "If she keep this up", "If she keeps this up"),
    ("00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]", "We have to choice but to stop", "We have no choice but to stop"),
    ("00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]", "We have to teke back the rod from", "We have to take back the rod from"),

    # File: 00000079.SCEN CHAPTER 6.1 (Totuwa) [TRANSLATED]
    ("00000079.SCEN CHAPTER 6.1 (Totuwa) [TRANSLATED]", "I'm confident that he is the[NLINE]\nthe Brave One", "I'm confident that he is the[NLINE]\nBrave One"),

    # File: 00000050.SCEN CHAPTER 5.2 [TRANSLATED]
    ("00000050.SCEN CHAPTER 5.2 [TRANSLATED]", "That reminds me, wasn't it the[NLINE]\nthe chairman who ordered us to[NLINE]", "That reminds me, wasn't it the[NLINE]\nchairman who ordered us to[NLINE]"),

    # File: 00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]
    ("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", "We don't call this content Goatland", "We don't call this continent Goatland"),
    ("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", "How could they what was going", "How could they know what was going"),
    ("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", "Flower have been arranged in a vase.", "Flowers have been arranged in a vase."),
    ("00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]", "step by and properly thank them!", "stop by and properly thank them!"),

    # File: 00000073.SCEN CHAPTER 10.1 (PMB HQ) [TRANSLATED]
    ("00000073.SCEN CHAPTER 10.1 (PMB HQ) [TRANSLATED]", "because its\nlocated in the center", "because it's\nlocated in the center"),
    ("00000073.SCEN CHAPTER 10.1 (PMB HQ) [TRANSLATED]", "This must have been awful[NLINE]\nexperience for you, Korin.", "This must have been an awful[NLINE]\nexperience for you, Korin."),

    # File: 00000026.SCEN CHAPTER 9.2 (Underground ancient ship) [TRANSLATED]
    ("00000026.SCEN CHAPTER 9.2 (Underground ancient ship) [TRANSLATED]", "formed by using the[NLINE]\nthe Ley Lines.", "formed by using the[NLINE]\nLey Lines."),

    # File: 00000025.SCEN CHAPTER 19.1 (Celestial ship) [TRANSLATED]
    ("00000025.SCEN CHAPTER 19.1 (Celestial ship) [TRANSLATED]", "I haven't seem him here", "I haven't seen him here"),

    # File: 00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]
    ("00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]", "by the looks it.[END-FE]\n...", "by the looks of it.[END-FE]\n..."),
    ("00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]", "strict towars his woman", "strict towards his woman"),
    ("00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]", "I've ran out of money", "I've run out of money"),
    ("00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]", "first on next month.", "first of next month."),

    # File: 00000103.SCEC CHAPTER 12.4 [TRANSLATED]
    ("00000103.SCEC CHAPTER 12.4 [TRANSLATED]", "we got you of there to fight", "we got you out of there to fight"),

    # File: 00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]
    ("00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]", "Gemstone cause various effects.", "Gemstones cause various effects."),
    ("00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]", "I made it out[NLINE]\nsome navy blue fabric I had laying", "I made it out of[NLINE]\nsome navy blue fabric I had laying"),
    ("00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]", "I made it out[NLINE]\nsome green fabric I had laying", "I made it out of[NLINE]\nsome green fabric I had laying"),

    # File: 00000056.SCEN CHAPTER 7.1 [TRANSLATED]
    ("00000056.SCEN CHAPTER 7.1 [TRANSLATED]", "it used[NLINE]\nwatch over the countries", "it used to[NLINE]\nwatch over the countries"),

    # File: 00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [TRANSLATED]
    ("00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [TRANSLATED]", "but I had[NLINE]\nmuster what little courage I had to do", "but I had to[NLINE]\nmuster what little courage I had to do"),
    ("00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [TRANSLATED]", "Or at very least, just the memories", "Or at the very least, just the memories"),

    # File: 00000055.SCEN CHAPTER 10.4 [TRANSLATED]
    ("00000055.SCEN CHAPTER 10.4 [TRANSLATED]", "Please be careful on our journey!", "Please be careful on your journey!"),

    # File: 00000136.SCEC CHAPTER 11.2 [TRANSLATED]
    ("00000136.SCEC CHAPTER 11.2 [TRANSLATED]", "I'm lookinga[NLINE]\nfor someone.", "I'm looking[NLINE]\nfor someone."),
    ("00000136.SCEC CHAPTER 11.2 [TRANSLATED]", "only three Red Wolf Unit\nmember who survived.", "only three Red Wolf Unit\nmembers who survived."),
    ("00000136.SCEC CHAPTER 11.2 [TRANSLATED]", "Perhaps it would[NLINE]\nbest to tell him the truth.", "Perhaps it would[NLINE]\nbe best to tell him the truth."),

    # File: 00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]
    ("00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]", "to choice but to buy it from a broker", "no choice but to buy it from a broker"),
    ("00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]", "a steep price for it..", "a steep price for it."),

    # File: 00000078.SCEN CHAPTER 4.5 (Zaramba) [TRANSLATED]
    ("00000078.SCEN CHAPTER 4.5 (Zaramba) [TRANSLATED]", "blick of an eye.", "blink of an eye."),
    ("00000078.SCEN CHAPTER 4.5 (Zaramba) [TRANSLATED]", "Flower have been arranged in a vase.", "Flowers have been arranged in a vase."),

    # File: 00000080.SCEN CHAPTER 4.8 (Geilenach) [TRANSLATED]
    ("00000080.SCEN CHAPTER 4.8 (Geilenach) [TRANSLATED]", "Flower have been arranged in a vase.", "Flowers have been arranged in a vase."),
    ("00000080.SCEN CHAPTER 4.8 (Geilenach) [TRANSLATED]", "These not accessible to the general public.", "These are not accessible to the general public."),

    # File: 00000030.SCEN CHAPTER 14.3 (Makinus City 2) [TRANSLATED]
    ("00000030.SCEN CHAPTER 14.3 (Makinus City 2) [TRANSLATED]", "a shorde of Screapers.", "a horde of Screapers."),
    ("00000030.SCEN CHAPTER 14.3 (Makinus City 2) [TRANSLATED]", "It's a far-way problem for now", "It's a far-off problem for now"),

    # File: 00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]
    ("00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]", "It's a far-way problem for now", "It's a far-off problem for now"),

    # File: 00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [TRANSLATED]
    ("00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [TRANSLATED]", "I didn't take long for Anita to lose", "It didn't take long for Anita to lose"),
    ("00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [TRANSLATED]", "Based her physical condition, she", "Based on her physical condition, she"),

    # File: 00000024.SCEN CHAPTER 18.1 (Dragon Tower) [TRANSLATED]
    ("00000024.SCEN CHAPTER 18.1 (Dragon Tower) [TRANSLATED]", "Infinitor intents to use the", "Infinitor intends to use the"),

    # File: 00000083.SCEN CHAPTER 10.2 (PMB HQ 2) [TRANSLATED]
    ("00000083.SCEN CHAPTER 10.2 (PMB HQ 2) [TRANSLATED]", "...Hey, where you're going?", "...Hey, where are you going?"),

    # File: 00000029.SCEN CHAPTER 19.2 (Past Celestial Ship) [TRANSLATED]
    ("00000029.SCEN CHAPTER 19.2 (Past Celestial Ship) [TRANSLATED]", "me a like a child.", "me like a child."),

    # File: 00000022.SCEN CHAPTER 12.1 (Giant) [TRANSLATED]
    ("00000022.SCEN CHAPTER 12.1 (Giant) [TRANSLATED]", "The other person attendant was", "The other attendant was"),

    # File: 00000138.SCEC CHAPTER 18.2 [TRANSLATED]
    ("00000138.SCEC CHAPTER 18.2 [TRANSLATED]", "I was just about to about[NLINE]\nto animate the conversation", "I was just about to[NLINE]\nanimate the conversation"),

    # File: 00000093.SCEN CHAPTER 16.1 (Lennox 3) [TRANSLATED]
    ("00000093.SCEN CHAPTER 16.1 (Lennox 3) [TRANSLATED]", "does you hold a grudge against", "do you hold a grudge against"),

    # File: 00000063.SCEN CHAPTER 17.2 (Juwaina Cave) [TRANSLATED]
    ("00000063.SCEN CHAPTER 17.2 (Juwaina Cave) [TRANSLATED]", "there's\nmistaking it!", "there's no\nmistaking it!"),

    # File: 00000076.SCEN CHAPTER X.X (Zerdok) [TRANSLATED]
    ("00000076.SCEN CHAPTER X.X (Zerdok) [TRANSLATED]", "not something\ndisappears with time.", "not something that\ndisappears with time."),

    # File: 00000137.SCEC CHAPTER 10.3 [TRANSLATED]
    ("00000137.SCEC CHAPTER 10.3 [TRANSLATED]", "This must have been awful[NLINE]\nexperience for you, Korin.", "This must have been an awful[NLINE]\nexperience for you, Korin."),

    # File: 00000058.SCEN CHAPTER 10.5 [TRANSLATED]
    ("00000058.SCEN CHAPTER 10.5 [TRANSLATED]", "Tt looks like they still haven't", "It looks like they still haven't"),

    # File: 00000107.SCEC CHAPTER 4.9 (Fairy development screen) [TRANSLATED]
    ("00000107.SCEC CHAPTER 4.9 (Fairy development screen) [TRANSLATED]", "I look like it would fit right at home", "I look like I would fit right at home"),

    # File: 00000130.SCEC CHAPTER 11.4 [TRANSLATED]
    ("00000130.SCEC CHAPTER 11.4 [TRANSLATED]", "wouldn't be able travel through time", "wouldn't be able to travel through time"),

    # File: 00000135.SCEC CHAPTER 14.2 [TRANSLATED]
    ("00000135.SCEC CHAPTER 14.2 [TRANSLATED]", "I would like to[NLINE]\nyou to tell the story about your", "I would like[NLINE]\nyou to tell the story about your"),

    # File: 00000053.SCEN CHAPTER 4.4 [TRANSLATED]
    ("00000053.SCEN CHAPTER 4.4 [TRANSLATED]", "Ships maybe common on your continent,", "Ships may be common on your continent,"),
    ("00000053.SCEN CHAPTER 4.4 [TRANSLATED]", "a man in cloak and hat ran past", "a man in a cloak and hat ran past"),

    # File: 00000057.SCEN CHAPTER 4.3 [TRANSLATED]
    ("00000057.SCEN CHAPTER 4.3 [TRANSLATED]", "spans\na body water.", "spans\na body of water."),

    # File: 00000052.SCEN CHAPTER 4.6 [TRANSLATED]
    ("00000052.SCEN CHAPTER 4.6 [TRANSLATED]", "resemblance too someone I heard about.", "resemblance to someone I heard about."),

    # File: 00000042.SCEN CHAPTER 6.5 (Pothrad village) [TRANSLATED]
    ("00000042.SCEN CHAPTER 6.5 (Pothrad village) [TRANSLATED]", "do such a[NLINE]\na terrible thing?", "do such a[NLINE]\nterrible thing?"),

    # File: 00000090.SCEN CHAPTER 9.3 (Past Warslee village) [TRANSLATED]
    ("00000090.SCEN CHAPTER 9.3 (Past Warslee village) [TRANSLATED]", "step by and properly thank them!", "stop by and properly thank them!"),

    # File: 00000019.SCEN CHAPTER 8.4 [TRANSLATED]
    ("00000019.SCEN CHAPTER 8.4 [TRANSLATED]", "But how much of them\nshould we defeat?", "But how many of them\nshould we defeat?"),

    # File: 00000006.SCEN CHAPTER 2.3 [TRANSLATED]
    ("00000006.SCEN CHAPTER 2.3 [TRANSLATED]", "When the action completed, the party member", "When the action is completed, the party member"),

    # File: 00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [TRANSLATED]
    ("00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [TRANSLATED]", "There would no point for a person", "There would be no point for a person"),
    ("00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [TRANSLATED]", "only one who is the position to", "only one who is in the position to"),

    # File: 00000081.SCEN CHAPTER X.X (Juwaina) [TRANSLATED]
    ("00000081.SCEN CHAPTER X.X (Juwaina) [TRANSLATED]", "don't enter the[NLINE]\nthe kitchen!", "don't enter the[NLINE]\nkitchen!"),

    # File: 00000007.SCEN CHAPTER 3.3 [TRANSLATED]
    ("00000007.SCEN CHAPTER 3.3 [TRANSLATED]", "participate in the[NLINE]\nthe operation?", "participate in the[NLINE]\noperation?"),

    # File: 00000048.SCEN CHAPTER 6.3 [TRANSLATED]
    ("00000048.SCEN CHAPTER 6.3 [TRANSLATED]", "easier to reach the[NLINE]\nthe Commonwealth to the south.", "easier to reach the[NLINE]\nCommonwealth to the south."),
]

count = 0
not_found = []
for fname, old, new in fixes:
    path = os.path.join(BASE, fname)
    if not os.path.exists(path):
        print(f"FILE NOT FOUND: {fname}")
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    if old in content:
        content = content.replace(old, new, 1)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        count += 1
        print(f"Fixed: {fname[:60]}: {repr(old[:50])} -> {repr(new[:50])}")
    else:
        not_found.append((fname, old))
        print(f"NOT FOUND: {fname[:60]}: {repr(old[:50])}")

print(f"\nTotal fixes: {count}")
print(f"Not found: {len(not_found)}")
