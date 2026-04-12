import os
import re
import json

base_dir = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT/"

files = [
    "00000049.SCEN CHAPTER 5.3 [TRANSLATED]",
    "00000050.SCEN CHAPTER 5.2 [TRANSLATED]",
    "00000051.SCEN CHAPTER 4.7 [TRANSLATED]",
    "00000052.SCEN CHAPTER 4.6 [TRANSLATED]",
    "00000053.SCEN CHAPTER 4.4 [TRANSLATED]",
    "00000054.SCEN CHAPTER 10.6 [TRANSLATED]",
    "00000055.SCEN CHAPTER 10.4 [TRANSLATED]",
    "00000056.SCEN CHAPTER 7.1 [TRANSLATED]",
    "00000057.SCEN CHAPTER 4.3 [TRANSLATED]",
    "00000058.SCEN CHAPTER 10.5 [TRANSLATED]",
    "00000059.SCEN (Fairy's Forest) [ONGOING]",
    "00000060.SCEN CHAPTER 17.1 [TRANSLATED]",
]

# ---------------------------------------------------------------
# All confirmed fixes: (filename, 1-based line number, old text, new text, reason)
# Lines are 1-based. old/new are exact line content (without newline).
# ---------------------------------------------------------------

FIXES = [
    # --- FILE 49: Korin/Yurii name error ---
    # JP: ・コリンを食べたモンスターの逃走 (POINTER #203)
    # "コリン" = Korin, not Yurii
    (
        "00000049.SCEN CHAPTER 5.3 [TRANSLATED]",
        2603,
        "・The monster that ate Yurii flees[NLINE]",
        "・The monster that ate Korin flees[NLINE]",
        "NAME_ERROR: コリン=Korin was mistranslated as Yurii (POINTER #203)"
    ),
    # JP: ・コリンを食べたモンスターの逃走 (POINTER #204)
    (
        "00000049.SCEN CHAPTER 5.3 [TRANSLATED]",
        2615,
        "・The monster that ate Yurii flees[NLINE]",
        "・The monster that ate Korin flees[NLINE]",
        "NAME_ERROR: コリン=Korin was mistranslated as Yurii (POINTER #204)"
    ),

    # --- FILE 55: Untranslated stage-clear condition string ---
    # JP: ここのクリアは完全のみです = "Only perfect clear for this stage"
    (
        "00000055.SCEN CHAPTER 10.4 [TRANSLATED]",
        774,
        "ここのクリアは完全のみです[END-FE]",
        "Only perfect clear for this stage[END-FE]",
        "UNTRANSLATED: JP text left in EN block (POINTER #63)"
    ),

    # --- FILE 59: Untranslated EN blocks (ONGOING file) ---

    # POINTER #1: 妖精の長老 = "Fairy Elder"
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        30,
        "妖精の長老[END-FF]",
        "Fairy Elder[END-FF]",
        "UNTRANSLATED: 妖精の長老 = Fairy Elder (POINTER #1)"
    ),

    # POINTER #14: に、ニンゲンよ！ = "A-A human!"
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        165,
        "に、ニンゲンよ！[END-FE]",
        "A-A human![END-FE]",
        "UNTRANSLATED: に、ニンゲンよ！ (POINTER #14)"
    ),

    # POINTER #15: あら？ / ユリィのお仲間？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        175,
        "あら？[NLINE]",
        "Oh?[NLINE]",
        "UNTRANSLATED: あら？ (POINTER #15)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        176,
        "ユリィのお仲間？[END-FE]",
        "Are you friends with Yurii?[END-FE]",
        "UNTRANSLATED: ユリィのお仲間？ (POINTER #15)"
    ),

    # POINTER #16: あら？ / ユリィさんのお仲間でしょうか？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        186,
        "あら？[NLINE]",
        "Oh?[NLINE]",
        "UNTRANSLATED: あら？ (POINTER #16)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        187,
        "ユリィさんのお仲間でしょうか？[END-FE]",
        "Are you companions of Ms. Yurii?[END-FE]",
        "UNTRANSLATED: ユリィさんのお仲間でしょうか？ (POINTER #16)"
    ),

    # POINTER #17: 妖精？ / ユリィの仲間か？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        197,
        "妖精？[NLINE]",
        "A fairy?[NLINE]",
        "UNTRANSLATED: 妖精？ (POINTER #17)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        198,
        "ユリィの仲間か？[END-FE]",
        "Are you with Yurii?[END-FE]",
        "UNTRANSLATED: ユリィの仲間か？ (POINTER #17)"
    ),

    # POINTER #18: この妖精は… / あなたのお仲間ですか？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        208,
        "この妖精は…[NLINE]",
        "This fairy is...[NLINE]",
        "UNTRANSLATED: この妖精は… (POINTER #18)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        209,
        "あなたのお仲間ですか？[END-FE]",
        "your companion?[END-FE]",
        "UNTRANSLATED: あなたのお仲間ですか？ (POINTER #18)"
    ),

    # POINTER #19: ここは、エルファンの森といいまして、 / いくつかある妖精の集落の１つです。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        219,
        "ここは、エルファンの森といいまして、[NLINE]",
        "This place is called Elphan Forest,[NLINE]",
        "UNTRANSLATED: ここは、エルファンの森 (POINTER #19)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        220,
        "いくつかある妖精の集落の１つです。[END-FE]",
        "one of several fairy settlements.[END-FE]",
        "UNTRANSLATED: いくつかある妖精の集落の１つです。 (POINTER #19)"
    ),

    # POINTER #20: ニンゲンだけじゃない？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        229,
        "ニンゲンだけじゃない？[END-FE]",
        "You're not just humans?[END-FE]",
        "UNTRANSLATED: ニンゲンだけじゃない？ (POINTER #20)"
    ),

    # POINTER #21: 初めまして、 / 私、東の砂漠のユリィと申します。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        239,
        "初めまして、[NLINE]",
        "Nice to meet you,[NLINE]",
        "UNTRANSLATED: 初めまして、 (POINTER #21)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        240,
        "私、東の砂漠のユリィと申します。[END-FE]",
        "I am Yurii, from the eastern desert.[END-FE]",
        "UNTRANSLATED: 私、東の砂漠のユリィと申します。 (POINTER #21)"
    ),

    # POINTER #22: ようこそ、ユリィ！ / エルファンの森へ！
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        250,
        "ようこそ、ユリィ！[NLINE]",
        "Welcome, Yurii![NLINE]",
        "UNTRANSLATED: ようこそ、ユリィ！ (POINTER #22)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        251,
        "エルファンの森へ！[END-FE]",
        "To Elphan Forest![END-FE]",
        "UNTRANSLATED: エルファンの森へ！ (POINTER #22)"
    ),

    # POINTER #25: ・Ｂパターン (note: POINTER #24 ・Ａパターン already translated as "・A Pattern")
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        278,
        "・Ｂパターン[END-FE]",
        "・B Pattern[END-FE]",
        "UNTRANSLATED: ・Ｂパターン (POINTER #25)"
    ),

    # POINTER #26: モンスターがいて危険です！ / 今は戦いに集中して下さい。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        288,
        "モンスターがいて危険です！[NLINE]",
        "It's dangerous, there are monsters![NLINE]",
        "UNTRANSLATED: モンスターがいて危険です！ (POINTER #26)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        289,
        "今は戦いに集中して下さい。[END-FE]",
        "Please focus on the battle![END-FE]",
        "UNTRANSLATED: 今は戦いに集中して下さい。 (POINTER #26)"
    ),

    # POINTER #27: Multi-line elder speech about Earth Priestess
    # あなたは大地の巫女ですね。 / このエルファンの森には / 初代の巫女様の母の形見があります。
    # / それは精神と知識を司った物です。 / あなたがそれに見合う強い力を得たならば、 / お渡ししましょう。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        306,
        "あなたは大地の巫女ですね。[NWIN]",
        "You are the Earth Priestess, aren't you.[NWIN]",
        "UNTRANSLATED: あなたは大地の巫女ですね。 (POINTER #27)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        308,
        "このエルファンの森には[NLINE]",
        "In this Elphan Forest,[NLINE]",
        "UNTRANSLATED: このエルファンの森には (POINTER #27)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        309,
        "初代の巫女様の母の形見があります。[NWIN]",
        "there is a keepsake from the first Priestess's mother.[NWIN]",
        "UNTRANSLATED: 初代の巫女様の母の形見があります。 (POINTER #27)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        311,
        "それは精神と知識を司った物です。[NWIN]",
        "It is something that governs mind and knowledge.[NWIN]",
        "UNTRANSLATED: それは精神と知識を司った物です。 (POINTER #27)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        313,
        "あなたがそれに見合う強い力を得たならば、[NLINE]",
        "When you have obtained power worthy of it,[NLINE]",
        "UNTRANSLATED: あなたがそれに見合う強い力を得たならば、 (POINTER #27)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        314,
        "お渡ししましょう。[END-FE]",
        "we shall give it to you.[END-FE]",
        "UNTRANSLATED: お渡ししましょう。 (POINTER #27)"
    ),

    # POINTER #28: 大地の巫女よ。 / あなたは強き力を得ていますね。
    # / ならばそれにふさわしき、 / 守りの力を授けましょう！
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        327,
        "大地の巫女よ。[NLINE]",
        "Earth Priestess.[NLINE]",
        "UNTRANSLATED: 大地の巫女よ。 (POINTER #28)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        328,
        "あなたは強き力を得ていますね。[NWIN]",
        "You have obtained great power.[NWIN]",
        "UNTRANSLATED: あなたは強き力を得ていますね。 (POINTER #28)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        330,
        "ならばそれにふさわしき、[NLINE]",
        "Then we shall bestow upon you[NLINE]",
        "UNTRANSLATED: ならばそれにふさわしき、 (POINTER #28)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        331,
        "守りの力を授けましょう！[END-FE]",
        "the protective power befitting it![END-FE]",
        "UNTRANSLATED: 守りの力を授けましょう！ (POINTER #28)"
    ),

    # POINTER #29: 力なき者に代わり、 / この世界を守って下さい。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        341,
        "力なき者に代わり、[NLINE]",
        "In place of the powerless,[NLINE]",
        "UNTRANSLATED: 力なき者に代わり、 (POINTER #29)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        342,
        "この世界を守って下さい。[END-FE]",
        "please protect this world.[END-FE]",
        "UNTRANSLATED: この世界を守って下さい。 (POINTER #29)"
    ),

    # POINTER #30: きゃ～！ / モンスターがいるわ！
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        352,
        "きゃ～！[NLINE]",
        "Kyaa![NLINE]",
        "UNTRANSLATED: きゃ～！ (POINTER #30)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        353,
        "モンスターがいるわ！[END-FE]",
        "There's a monster![END-FE]",
        "UNTRANSLATED: モンスターがいるわ！ (POINTER #30)"
    ),

    # POINTER #31: きゃ～！ / ニンゲン、ニンゲン～！
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        363,
        "きゃ～！[NLINE]",
        "Kyaa![NLINE]",
        "UNTRANSLATED: きゃ～！ (POINTER #31)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        364,
        "ニンゲン、ニンゲン～！[END-FE]",
        "Humans, humans![END-FE]",
        "UNTRANSLATED: ニンゲン、ニンゲン～！ (POINTER #31)"
    ),

    # POINTER #32: き、危険です！ / モンスターの気配が…。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        374,
        "き、危険です！[NLINE]",
        "D-Danger![NLINE]",
        "UNTRANSLATED: き、危険です！ (POINTER #32)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        375,
        "モンスターの気配が…。[END-FE]",
        "I sense monsters...[END-FE]",
        "UNTRANSLATED: モンスターの気配が…。 (POINTER #32)"
    ),

    # POINTER #33: 私たち妖精の多くは、 / 時の流れにそって生きます。 / 世界を変えようとは考えません。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        386,
        "私たち妖精の多くは、[NLINE]",
        "Most of us fairies[NLINE]",
        "UNTRANSLATED: 私たち妖精の多くは、 (POINTER #33)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        387,
        "時の流れにそって生きます。[NLINE]",
        "live by the flow of time.[NLINE]",
        "UNTRANSLATED: 時の流れにそって生きます。 (POINTER #33)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        388,
        "世界を変えようとは考えません。[END-FE]",
        "We don't seek to change the world.[END-FE]",
        "UNTRANSLATED: 世界を変えようとは考えません。 (POINTER #33)"
    ),

    # POINTER #34: きゃ～！ / こわいモンスターがいる！
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        398,
        "きゃ～！[NLINE]",
        "Kyaa![NLINE]",
        "UNTRANSLATED: きゃ～！ (POINTER #34)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        399,
        "こわいモンスターがいる！[END-FE]",
        "There's a scary monster![END-FE]",
        "UNTRANSLATED: こわいモンスターがいる！ (POINTER #34)"
    ),

    # POINTER #35: ユリィの勇者と / コリンの勇者と / どっちがホンモノ？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        410,
        "ユリィの勇者と[NLINE]",
        "Yurii's Brave One and[NLINE]",
        "UNTRANSLATED: ユリィの勇者と (POINTER #35)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        411,
        "コリンの勇者と[NLINE]",
        "Korin's Brave One,[NLINE]",
        "UNTRANSLATED: コリンの勇者と (POINTER #35)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        412,
        "どっちがホンモノ？[END-FE]",
        "which one is real?[END-FE]",
        "UNTRANSLATED: どっちがホンモノ？ (POINTER #35)"
    ),

    # POINTER #36: モ、モンスター…こわい…。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        421,
        "モ、モンスター…こわい…。[END-FE]",
        "M-Monsters... scary...[END-FE]",
        "UNTRANSLATED: モ、モンスター…こわい…。 (POINTER #36)"
    ),

    # POINTER #37: ニンゲン…平気？
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        430,
        "ニンゲン…平気？[END-FE]",
        "Human... are you okay?[END-FE]",
        "UNTRANSLATED: ニンゲン…平気？ (POINTER #37)"
    ),

    # POINTER #38: モンスター…いる…、 / …危険…とても…。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        440,
        "モンスター…いる…、[NLINE]",
        "Monsters... are here...,[NLINE]",
        "UNTRANSLATED: モンスター…いる…、 (POINTER #38)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        441,
        "…危険…とても…。[END-FE]",
        "...Very... dangerous...[END-FE]",
        "UNTRANSLATED: …危険…とても…。 (POINTER #38)"
    ),

    # POINTER #39: ユリィも…一緒…。 / …ニンゲンと…。
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        451,
        "ユリィも…一緒…。[NLINE]",
        "Yurii too... is here...[NLINE]",
        "UNTRANSLATED: ユリィも…一緒…。 (POINTER #39)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        452,
        "…ニンゲンと…。[END-FE]",
        "...with humans...[END-FE]",
        "UNTRANSLATED: …ニンゲンと…。 (POINTER #39)"
    ),

    # POINTER #40: 湖がある。 / 澄んだ水がきれいだ。
    # Note: original has fullwidth spaces after 湖がある。; preserving those.
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        465,
        "湖がある。\u3000\u3000\u3000\u3000\u3000[NLINE]",
        "There's a lake.\u3000\u3000\u3000\u3000\u3000[NLINE]",
        "UNTRANSLATED: 湖がある。 (POINTER #40)"
    ),
    (
        "00000059.SCEN (Fairy's Forest) [ONGOING]",
        466,
        "澄んだ水がきれいだ。[NLINE]",
        "The clear water is beautiful.[NLINE]",
        "UNTRANSLATED: 澄んだ水がきれいだ。 (POINTER #40)"
    ),
]


def apply_fixes(fixes):
    """Apply all fixes, grouped by file. Returns a list of applied change records."""
    # Group fixes by filename
    fixes_by_file = {}
    for fix in fixes:
        fname = fix[0]
        if fname not in fixes_by_file:
            fixes_by_file[fname] = []
        fixes_by_file[fname].append(fix)

    all_changes = []

    for fname, file_fixes in fixes_by_file.items():
        path = os.path.join(base_dir, fname)
        with open(path, encoding='utf-8', errors='replace') as f:
            lines = f.readlines()

        changed = False
        file_changes = []

        for fix in file_fixes:
            _, line_num_1based, old_text, new_text, reason = fix
            idx = line_num_1based - 1  # 0-based index

            if idx < 0 or idx >= len(lines):
                print(f"  [ERROR] Line {line_num_1based} out of range in {fname}")
                continue

            # Check the line matches what we expect
            actual = lines[idx].rstrip('\n').rstrip('\r')
            if actual != old_text:
                print(f"  [MISMATCH] {fname} line {line_num_1based}:")
                print(f"    Expected: {repr(old_text)}")
                print(f"    Actual:   {repr(actual)}")
                continue

            # Detect original line ending
            if lines[idx].endswith('\r\n'):
                ending = '\r\n'
            elif lines[idx].endswith('\n'):
                ending = '\n'
            else:
                ending = ''

            lines[idx] = new_text + ending
            changed = True

            change_record = {
                "file": fname,
                "line": line_num_1based,
                "old": old_text,
                "new": new_text,
                "reason": reason,
            }
            file_changes.append(change_record)
            all_changes.append(change_record)
            print(f"  [FIXED] {fname} L{line_num_1based}: {old_text[:60]} → {new_text[:60]}")

        if changed:
            with open(path, 'w', encoding='utf-8') as f:
                f.writelines(lines)
            print(f"  Saved {fname} ({len(file_changes)} changes)")

    return all_changes


print("=" * 70)
print("Growlanser 6 Script Proofreader")
print("=" * 70)
print(f"\nTotal fixes planned: {len(FIXES)}")
print("\nApplying fixes...\n")

all_changes = apply_fixes(FIXES)

print("\n" + "=" * 70)
print("SUMMARY")
print("=" * 70)

summary = {
    "total_changes": len(all_changes),
    "changes_by_file": {},
    "changes": all_changes,
}

for change in all_changes:
    fname = change["file"]
    if fname not in summary["changes_by_file"]:
        summary["changes_by_file"][fname] = 0
    summary["changes_by_file"][fname] += 1

print(json.dumps(summary, indent=2, ensure_ascii=False))
