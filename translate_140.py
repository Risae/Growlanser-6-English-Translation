import re

filepath = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT/00000140.SDMY (no idea) [ONGOING]"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Multi-line replacements first (order matters)
multiline_replacements = [
    # String 56 - Fermentia warning
    ("フェルメンティアのイベントを見る為だけの設定なので[NLINE]\nこのままプレイするとヤバイです。[NLINE]\n注意してください。[END-FE]",
     "This setup is only for viewing the Fermentia event,[NLINE]\ncontinuing to play like this may cause issues.[NLINE]\nPlease be careful.[END-FE]"),
    # String 57 - unimplemented
    ("　[NLINE]\n未実装[END-FE]",
     "　[NLINE]\nNot implemented[END-FE]"),
    # String 75 - voice check mode
    ("ボイスチェックモードです。[NLINE]\nチェックしたい項目を選んで下さい。[NLINE]\n×キャンセルで終わります。[END-FE]",
     "Voice check mode.[NLINE]\nPlease select the item to check.[NLINE]\nPress × to cancel.[END-FE]"),
    # String 162 - cursor align
    ("パーティー２にカーソルを合わせます。[NLINE]\nどの速度であわせますか？[END-FE]",
     "Aligning cursor to Party 2.[NLINE]\nWhat speed would you like to use?[END-FE]"),
    # Protagonist visual check entries
    ("主人公０の[NLINE]\n普通[END-FE]", "Protagonist 0[NLINE]\nNormal[END-FE]"),
    ("主人公０の[NLINE]\nまじめ[END-FE]", "Protagonist 0[NLINE]\nSerious[END-FE]"),
    ("主人公０の[NLINE]\n穏やか[END-FE]", "Protagonist 0[NLINE]\nCalm[END-FE]"),
    ("主人公０の[NLINE]\n怒り[END-FE]", "Protagonist 0[NLINE]\nAnger[END-FE]"),
    ("主人公０の[NLINE]\n悲しい[END-FE]", "Protagonist 0[NLINE]\nSad[END-FE]"),
    ("主人公０の[NLINE]\n照れる[END-FE]", "Protagonist 0[NLINE]\nEmbarrassed[END-FE]"),
    ("主人公０の[NLINE]\n笑い[END-FE]", "Protagonist 0[NLINE]\nLaughing[END-FE]"),
    ("主人公０の[NLINE]\n瀕死[END-FE]", "Protagonist 0[NLINE]\nNear death[END-FE]"),
    # Wendy 0
    ("ウェンディ０の[NLINE]\n普通[END-FE]", "Wendy 0[NLINE]\nNormal[END-FE]"),
    ("ウェンディ０の[NLINE]\nまじめ[END-FE]", "Wendy 0[NLINE]\nSerious[END-FE]"),
    ("ウェンディ０の[NLINE]\n穏やか[END-FE]", "Wendy 0[NLINE]\nCalm[END-FE]"),
    ("ウェンディ０の[NLINE]\n怒り[END-FE]", "Wendy 0[NLINE]\nAnger[END-FE]"),
    ("ウェンディ０の[NLINE]\n悲しい[END-FE]", "Wendy 0[NLINE]\nSad[END-FE]"),
    ("ウェンディ０の[NLINE]\n照れる[END-FE]", "Wendy 0[NLINE]\nEmbarrassed[END-FE]"),
    ("ウェンディ０の[NLINE]\n笑い[END-FE]", "Wendy 0[NLINE]\nLaughing[END-FE]"),
    ("ウェンディ０の[NLINE]\n瀕死[END-FE]", "Wendy 0[NLINE]\nNear death[END-FE]"),
    # Wendy 1
    ("ウェンディ１の[NLINE]\n普通[END-FE]", "Wendy 1[NLINE]\nNormal[END-FE]"),
    ("ウェンディ１の[NLINE]\nまじめ[END-FE]", "Wendy 1[NLINE]\nSerious[END-FE]"),
    ("ウェンディ１の[NLINE]\n穏やか[END-FE]", "Wendy 1[NLINE]\nCalm[END-FE]"),
    ("ウェンディ１の[NLINE]\n怒り[END-FE]", "Wendy 1[NLINE]\nAnger[END-FE]"),
    ("ウェンディ１の[NLINE]\n悲しい[END-FE]", "Wendy 1[NLINE]\nSad[END-FE]"),
    ("ウェンディ１の[NLINE]\n照れる[END-FE]", "Wendy 1[NLINE]\nEmbarrassed[END-FE]"),
    ("ウェンディ１の[NLINE]\n瀕死[END-FE]", "Wendy 1[NLINE]\nNear death[END-FE]"),
    # Yuri 0
    ("ユリィ０の[NLINE]\n普通[END-FE]", "Yuri 0[NLINE]\nNormal[END-FE]"),
    ("ユリィ０の[NLINE]\nまじめ[END-FE]", "Yuri 0[NLINE]\nSerious[END-FE]"),
    ("ユリィ０の[NLINE]\n穏やか[END-FE]", "Yuri 0[NLINE]\nCalm[END-FE]"),
    ("ユリィ０の[NLINE]\n怒り[END-FE]", "Yuri 0[NLINE]\nAnger[END-FE]"),
    ("ユリィ０の[NLINE]\n悲しい[END-FE]", "Yuri 0[NLINE]\nSad[END-FE]"),
    ("ユリィ０の[NLINE]\n照れる[END-FE]", "Yuri 0[NLINE]\nEmbarrassed[END-FE]"),
    ("ユリィ０の[NLINE]\n笑い[END-FE]", "Yuri 0[NLINE]\nLaughing[END-FE]"),
    # Yuri 1
    ("ユリィ１の[NLINE]\n普通[END-FE]", "Yuri 1[NLINE]\nNormal[END-FE]"),
    ("ユリィ１の[NLINE]\nまじめ[END-FE]", "Yuri 1[NLINE]\nSerious[END-FE]"),
    ("ユリィ１の[NLINE]\n穏やか[END-FE]", "Yuri 1[NLINE]\nCalm[END-FE]"),
    ("ユリィ１の[NLINE]\n怒り[END-FE]", "Yuri 1[NLINE]\nAnger[END-FE]"),
    ("ユリィ１の[NLINE]\n悲しい[END-FE]", "Yuri 1[NLINE]\nSad[END-FE]"),
    ("ユリィ１の[NLINE]\n照れる[END-FE]", "Yuri 1[NLINE]\nEmbarrassed[END-FE]"),
    ("ユリィ１の[NLINE]\n笑い[END-FE]", "Yuri 1[NLINE]\nLaughing[END-FE]"),
    # Yuri 2
    ("ユリィ２の[NLINE]\n普通[END-FE]", "Yuri 2[NLINE]\nNormal[END-FE]"),
    ("ユリィ２の[NLINE]\nまじめ[END-FE]", "Yuri 2[NLINE]\nSerious[END-FE]"),
    ("ユリィ２の[NLINE]\n穏やか[END-FE]", "Yuri 2[NLINE]\nCalm[END-FE]"),
    ("ユリィ２の[NLINE]\n怒り[END-FE]", "Yuri 2[NLINE]\nAnger[END-FE]"),
    ("ユリィ２の[NLINE]\n悲しい[END-FE]", "Yuri 2[NLINE]\nSad[END-FE]"),
    ("ユリィ２の[NLINE]\n照れる[END-FE]", "Yuri 2[NLINE]\nEmbarrassed[END-FE]"),
    ("ユリィ２の[NLINE]\n笑い[END-FE]", "Yuri 2[NLINE]\nLaughing[END-FE]"),
]

# Apply multi-line replacements (only on non-comment lines)
# We need to be careful: don't modify comment lines
# Strategy: split on comment-line boundaries and replace only in non-comment blocks

def apply_replacements_safe(content, replacements):
    """Apply replacements only to non-comment, non-directive lines."""
    lines = content.split('\n')
    result_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith('//') or line.startswith('#'):
            result_lines.append(line)
            i += 1
        else:
            result_lines.append(line)
            i += 1
    return '\n'.join(result_lines)

# For multi-line replacements, we need to be smart.
# The approach: replace in whole content, but only in segments that aren't comment lines.
# Simple approach: since comment lines start with // and the Japanese text lines don't,
# we can do replacements on the whole content because the comment lines also contain the same
# Japanese text - BUT we must ensure comments remain unchanged.
# Solution: Process line by line, accumulate non-comment runs, apply substitutions there.

def safe_replace(content, old, new):
    """Replace old with new, but never inside comment lines (lines starting with //)."""
    # Split into segments separated by comment/directive lines
    lines = content.split('\n')
    # Find all positions where old text starts, check if any of those lines start with //
    # Easier: do the replacement in the full string, then re-check comment lines are unchanged
    # Even simpler: only replace in "data" sections
    
    # Build a modified content where we only replace in non-comment, non-directive context
    # We'll process block by block
    result = []
    chunk = []
    for line in lines:
        if line.startswith('//') or line.startswith('#'):
            # Process accumulated chunk
            if chunk:
                chunk_text = '\n'.join(chunk)
                chunk_text = chunk_text.replace(old, new)
                result.extend(chunk_text.split('\n'))
                chunk = []
            result.append(line)
        else:
            chunk.append(line)
    if chunk:
        chunk_text = '\n'.join(chunk)
        chunk_text = chunk_text.replace(old, new)
        result.extend(chunk_text.split('\n'))
    return '\n'.join(result)

# Apply multi-line replacements
for old, new in multiline_replacements:
    content = safe_replace(content, old, new)

# Single-line replacements (applied line by line to non-comment, non-directive lines)
single_line_map = {
    # String 14 - main menu prompt
    "どうする？　[COL09][CROSS][COL00]で抜ける[END-FE]": "What will you do?　[COL09][CROSS][COL00] to exit[END-FE]",
    # String 15
    "・セーブ([R1]押しでLOAD)[END-FE]": "・Save ([R1] to LOAD)[END-FE]",
    # String 16
    "・ＧＬ[SIX]　シナリオ　開始[END-FE]": "・GL[SIX] Scenario Start[END-FE]",
    # String 17
    "・イベントチェック[END-FE]": "・Event Check[END-FE]",
    # String 18
    "・顔グラチェック[END-FE]": "・Portrait Check[END-FE]",
    # String 19
    "・ボイスチェック[END-FE]": "・Voice Check[END-FE]",
    # String 20
    "・マクロ命令チェック[END-FE]": "・Macro Command Check[END-FE]",
    # String 21
    "・キャラメイク[END-FE]": "・Character Creation[END-FE]",
    # String 22
    "・もろもろチェック[END-FE]": "・Misc. Check[END-FE]",
    # String 23
    "・デバッグ用シナリオ[END-FE]": "・Debug Scenario[END-FE]",
    # String 24
    "・デバッグセーブ部屋[END-FE]": "・Debug Save Room[END-FE]",
    # String 25
    "スキップフラグを立てますか？[END-FE]": "Set skip flag?[END-FE]",
    # String 26
    "戦闘スキップフラグを立てますか？[END-FE]": "Set combat skip flag?[END-FE]",
    # String 27
    "・最初から[END-FE]": "・From the beginning[END-FE]",
    # Chapters
    "・第１章[END-FE]": "・Chapter 1[END-FE]",
    "・第２章[END-FE]": "・Chapter 2[END-FE]",
    "・第３章[END-FE]": "・Chapter 3[END-FE]",
    "・第４章[END-FE]": "・Chapter 4[END-FE]",
    "・第５章[END-FE]": "・Chapter 5[END-FE]",
    "・第６章[END-FE]": "・Chapter 6[END-FE]",
    "・第７章[END-FE]": "・Chapter 7[END-FE]",
    "・第８章[END-FE]": "・Chapter 8[END-FE]",
    "・第９章[END-FE]": "・Chapter 9[END-FE]",
    # String 37
    "研究所の医務室からスタートです。[END-FE]": "Starting from the laboratory infirmary.[END-FE]",
    # Chapter 1 locations
    "・第１章　マキナス[END-FE]": "・Chapter 1: Makinus[END-FE]",
    "・第１章　ダスティス[END-FE]": "・Chapter 1: Dustis[END-FE]",
    "・第１章　シザーズ[END-FE]": "・Chapter 1: Schizarz[END-FE]",
    "・第１章　シザーズ後マキナス[END-FE]": "・Chapter 1: Post-Schizarz Makinus[END-FE]",
    # String 42, 43
    "・初マキナスから[END-FE]": "・From first Makinus[END-FE]",
    "・ダスティスに向かうところから[END-FE]": "・From heading to Dustis[END-FE]",
    # Strings 44-46
    "研究所のイベントの後、マキナスからです。[END-FE]": "After the laboratory event, from Makinus.[END-FE]",
    "任務を受けた後、マキナスの外からです。[END-FE]": "After accepting the mission, from outside Makinus.[END-FE]",
    "任務を受けた後、ダスティスからです。[END-FE]": "After accepting the mission, from Dustis.[END-FE]",
    # Chapter 2 locations
    "・第２章　休暇明け[END-FE]": "・Chapter 2: End of Leave[END-FE]",
    "・第２章　船上[END-FE]": "・Chapter 2: Aboard Ship[END-FE]",
    "・第２章　ワースリー村[END-FE]": "・Chapter 2: Warslee Village[END-FE]",
    "・第２章　ザーランバ[END-FE]": "・Chapter 2: Zalamba[END-FE]",
    "・第２章　フェルメンティア[END-FE]": "・Chapter 2: Fermentia[END-FE]",
    # String 52
    "先へ進むには、ベッドで寝て下さい。[END-FE]": "To proceed, please sleep in the bed.[END-FE]",
    # String 53-55
    "・初日から[END-FE]": "・From Day 1[END-FE]",
    "・２日目から[END-FE]": "・From Day 2[END-FE]",
    "・３日目から[END-FE]": "・From Day 3[END-FE]",
    # String 58
    "追加のネーリスイベントチェック？[END-FE]": "Additional Nelis event check?[END-FE]",
    # Strings 59-61
    "・盲目のネーリス１[END-FE]": "・Blind Nelis 1[END-FE]",
    "・盲目のネーリス３[END-FE]": "・Blind Nelis 3[END-FE]",
    "・ノーラにアイテム見て貰う[END-FE]": "・Have Nora look at an item[END-FE]",
    # String 62
    "・やらない[END-FE]": "・Don't do it[END-FE]",
    # Strings 63-65
    "ネーリスのナイフも欲しい？[END-FE]": "Do you also want Nelis's knife?[END-FE]",
    "ついでにアニータのアイテムも？[END-FE]": "While we're at it, Anita's items too?[END-FE]",
    # String 66-70
    "・７章開始時[END-FE]": "・At Chapter 7 start[END-FE]",
    "・７章終了間際[END-FE]": "・Near the end of Chapter 7[END-FE]",
    "・マキナスに帰還から[END-FE]": "・From returning to Makinus[END-FE]",
    "・マキナスから出発[END-FE]": "・Departing from Makinus[END-FE]",
    "・ウェンディ合流から[END-FE]": "・From joining up with Wendy[END-FE]",
    # String 71
    "・何もせず抜ける[END-FE]": "・Exit without doing anything[END-FE]",
    # String 72-74
    "・ロイフェロンの地下マーケットチェック？[END-FE]": "・Royferon underground market check?[END-FE]",
    "・ネーリス子供救出戦闘[END-FE]": "・Nelis child rescue battle[END-FE]",
    "・過去の記憶[END-FE]": "・Memory of the past[END-FE]",
    # String 76
    "・Ｃファイルシリーズ[END-FE]": "・C File Series[END-FE]",
    # String 84
    "何をする？[CROSS]で抜けます[END-FE]": "What will you do? Press [CROSS] to exit[END-FE]",
    # String 86-99
    "・座標指定メッセージチェック[END-FE]": "・Coordinate-specified message check[END-FE]",
    "・顔とメッセージチェック[END-FE]": "・Portrait and message check[END-FE]",
    "・顔マクロチェック[END-FE]": "・Portrait macro check[END-FE]",
    "・妖精チェック[END-FE]": "・Fairy check[END-FE]",
    "・パーティー集合解散チェック[END-FE]": "・Party gather/dismiss check[END-FE]",
    "・外字チェック[END-FE]": "・Special character check[END-FE]",
    "・武器ＣＧ変更[END-FE]": "・Weapon CG change[END-FE]",
    "・常駐エフェクトチェック[END-FE]": "・Resident effect check[END-FE]",
    "・特殊画面効果チェック[END-FE]": "・Special screen effect check[END-FE]",
    "・クラス吹き出しチェック[END-FE]": "・Class speech bubble check[END-FE]",
    "・モーションチェック[END-FE]": "・Motion check[END-FE]",
    "・ムービーチェック[END-FE]": "・Movie check[END-FE]",
    "・ビジュアルチェック[END-FE]": "・Visual check[END-FE]",
    "・セーブチェック[END-FE]": "・Save check[END-FE]",
    # String 100-104
    "チェックシナリオへ飛びますか？[END-FE]": "Jump to check scenario?[END-FE]",
    "本地名表示しますか？[END-FE]": "Display actual location name?[END-FE]",
    "ダミーイベント導入終了[END-FE]": "Dummy event intro done[END-FE]",
    "どれをチェックしますか？[END-FE]": "Which would you like to check?[END-FE]",
    # String 105-109
    "・ダンジョン[END-FE]": "・Dungeon[END-FE]",
    "・配置[END-FE]": "・Placement[END-FE]",
    "・その他[END-FE]": "・Other[END-FE]",
    "・ＰＣ待機モーション[END-FE]": "・PC idle motion[END-FE]",
    # String 110-111
    "ダンジョンをチェックしますか？[END-FE]": "Check dungeon?[END-FE]",
    # String 125
    "・最終ダンジョン[END-FE]": "・Final Dungeon[END-FE]",
    # String 126-127
    "襲撃前に飛びますか？[END-FE]": "Jump to before the raid?[END-FE]",
    "配置をチェックしますか？[END-FE]": "Check placement?[END-FE]",
    # String 139
    "捕食マクロを試しますか？[END-FE]": "Try the predation macro?[END-FE]",
    # String 140-145
    "・何をチェックしますか？[END-FE]": "・What would you like to check?[END-FE]",
    "・盗みマクロチャック[END-FE]": "・Steal macro check[END-FE]",
    "・捕食君チェック[END-FE]": "・Predation-kun check[END-FE]",
    "・ふとん犬[END-FE]": "・Futon Dog[END-FE]",
    "・闘技場[END-FE]": "・Arena[END-FE]",
    "・カーソルチェック[END-FE]": "・Cursor check[END-FE]",
    # String 147
    "どれを確認しますか？[END-FE]": "Which would you like to confirm?[END-FE]",
    # String 148-150
    "・初ふとん犬[END-FE]": "・First Futon Dog[END-FE]",
    "・ふとん犬仲間中[END-FE]": "・Futon Dog companion[END-FE]",
    # String 151
    "どのふとん犬にしますか？[END-FE]": "Which Futon Dog?[END-FE]",
    # String 152-161 (dog names)
    "・ニシキ[END-FE]": "・Nishiki[END-FE]",
    "・テツ[END-FE]": "・Tetsu[END-FE]",
    "・タマ[END-FE]": "・Tama[END-FE]",
    "・モモ[END-FE]": "・Momo[END-FE]",
    "ニシキ[END-FE]": "Nishiki[END-FE]",
    "テツ[END-FE]": "Tetsu[END-FE]",
    "タマ[END-FE]": "Tama[END-FE]",
    "モモ[END-FE]": "Momo[END-FE]",
    # Speed entries
    "・速度１[END-FE]": "・Speed 1[END-FE]",
    "・速度２[END-FE]": "・Speed 2[END-FE]",
    "・速度３[END-FE]": "・Speed 3[END-FE]",
    "・速度４[END-FE]": "・Speed 4[END-FE]",
    "・速度５[END-FE]": "・Speed 5[END-FE]",
    "・速度６[END-FE]": "・Speed 6[END-FE]",
    "・速度７[END-FE]": "・Speed 7[END-FE]",
    # String 171
    "どのデバッグシナリオに行きますか？[END-FE]": "Which debug scenario would you like to go to?[END-FE]",
    # String 174-175
    "ダミーから来た[END-FE]": "Came from dummy[END-FE]",
    "座標指定メッセージのチェックをします[END-FE]": "Checking coordinate-specified messages[END-FE]",
    # Strings 176, 183
    "まず、吹き出しなし版[END-FE]": "First, version without speech bubbles[END-FE]",
    "次に、吹き出しあり版[END-FE]": "Next, version with speech bubbles[END-FE]",
    # Strings 190-193
    "選択文の吹き出しチェック（北）[END-FE]": "Selection bubble check (North)[END-FE]",
    "選択文の吹き出しチェック（南）[END-FE]": "Selection bubble check (South)[END-FE]",
    "選択文の吹き出しチェック（東）[END-FE]": "Selection bubble check (East)[END-FE]",
    "選択文の吹き出しチェック（西）[END-FE]": "Selection bubble check (West)[END-FE]",
    # String 194
    "顔グラからのセリフのチェックをします[END-FE]": "Checking dialogue from portraits[END-FE]",
    # Strings 195-199
    "コリンです[END-FE]": "It's Colin.[END-FE]",
    "[MainCharName]です[END-FE]": "It's [MainCharName].[END-FE]",
    "またコリンです[END-FE]": "Colin again.[END-FE]",
    "また[MainCharName]です[END-FE]": "[MainCharName] again.[END-FE]",
    # Strings 199-210
    "ファニル消します[END-FE]": "Removing Fanir.[END-FE]",
    "ＭＥＳに顔指定でファニル０を出します[END-FE]": "Displaying Fanir 0 in MES with face specification.[END-FE]",
    "ファニル出します[END-FE]": "Displaying Fanir.[END-FE]",
    "再度チェック？[END-FE]": "Check again?[END-FE]",
    "主人公消します[END-FE]": "Removing protagonist.[END-FE]",
    "主人公出します[END-FE]": "Displaying protagonist.[END-FE]",
    "両方消します[END-FE]": "Removing both.[END-FE]",
    "両方出します[END-FE]": "Displaying both.[END-FE]",
    # Expressions
    "普通[END-FE]": "Normal[END-FE]",
    "瀕死[END-FE]": "Near death[END-FE]",
    "怒り[END-FE]": "Anger[END-FE]",
    "悲しい[END-FE]": "Sad[END-FE]",
    "照れる[END-FE]": "Embarrassed[END-FE]",
    "まじめ[END-FE]": "Serious[END-FE]",
    "穏やか[END-FE]": "Calm[END-FE]",
    "笑い[END-FE]": "Laughing[END-FE]",
    # Directions
    "北[END-FE]": "North[END-FE]",
    "南[END-FE]": "South[END-FE]",
    "東[END-FE]": "East[END-FE]",
    "西[END-FE]": "West[END-FE]",
    # String 220-223
    "どのチェック？[END-FE]": "Which check?[END-FE]",
    "・顔保護チェック[END-FE]": "・Portrait protection check[END-FE]",
    "・顔優先チェック[END-FE]": "・Portrait priority check[END-FE]",
    "・顔移動チェック[END-FE]": "・Portrait movement check[END-FE]",
    # String 224-233
    "顔グラ保護のチェックをします[END-FE]": "Checking portrait protection[END-FE]",
    "主人公０の顔は保護されています。[END-FE]": "Protagonist 0's portrait is protected.[END-FE]",
    "ファニル０は通常です[END-FE]": "Fanir 0 is normal[END-FE]",
    "コリン０は通常です[END-FE]": "Colin 0 is normal[END-FE]",
    "ファニル０を保護しました[END-FE]": "Protected Fanir 0[END-FE]",
    "コリン１は通常です[END-FE]": "Colin 1 is normal[END-FE]",
    "主人公０は普通です。[END-FE]": "Protagonist 0 is normal.[END-FE]",
    "保護を解除しました。[END-FE]": "Protection removed.[END-FE]",
    # String 234-237
    "顔グラ優先のチェックをします[END-FE]": "Checking portrait priority[END-FE]",
    "主人公０の顔は優先です。[END-FE]": "Protagonist 0's portrait has priority.[END-FE]",
    "ファニル０を優先にしました。[END-FE]": "Set Fanir 0 to priority.[END-FE]",
    # String 238
    "顔移動のチェックする[END-FE]": "Checking portrait movement[END-FE]",
    # Speed+movement strings
    "速度０で[(3)]へ移動[END-FE]": "Moving to [(3)] at speed 0[END-FE]",
    "速度１で[(4)]へ移動[END-FE]": "Moving to [(4)] at speed 1[END-FE]",
    "速度２で[(6)]へ移動[END-FE]": "Moving to [(6)] at speed 2[END-FE]",
    "速度３で[(4)]へ移動[END-FE]": "Moving to [(4)] at speed 3[END-FE]",
    "速度４で[(2)]へ移動[END-FE]": "Moving to [(2)] at speed 4[END-FE]",
    "速度５で[(6)]へ移動[END-FE]": "Moving to [(6)] at speed 5[END-FE]",
    "速度６で[(2)]へ移動[END-FE]": "Moving to [(2)] at speed 6[END-FE]",
    "速度７で[(6)]へ移動[END-FE]": "Moving to [(6)] at speed 7[END-FE]",
    "速度５で（５０，０）へ移動[END-FE]": "Moving to (50, 0) at speed 5[END-FE]",
    "速度５で相対（２５６、０）へ移動[END-FE]": "Moving relative to (256, 0) at speed 5[END-FE]",
    "移動チェック終了[END-FE]": "Movement check complete[END-FE]",
    # String 250
    "顔表情のチェックする[END-FE]": "Checking portrait expressions[END-FE]",
    # String 251-259
    "目を閉じます[END-FE]": "Closing eyes[END-FE]",
    "口を『あ』にします[END-FE]": "Setting mouth to 'A'[END-FE]",
    "口を『い』にします[END-FE]": "Setting mouth to 'I'[END-FE]",
    "口を『う』にします[END-FE]": "Setting mouth to 'U'[END-FE]",
    "口を『え』にします[END-FE]": "Setting mouth to 'E'[END-FE]",
    "口を『お』にします[END-FE]": "Setting mouth to 'O'[END-FE]",
    "口を半開きにします[END-FE]": "Setting mouth to half-open[END-FE]",
    "目を通常に戻します[END-FE]": "Returning eyes to normal[END-FE]",
    "終わります[END-FE]": "Done.[END-FE]",
    # String 260-261
    "現在未使用の部分です。[END-FE]": "This section is currently unused.[END-FE]",
    "妖精関係のチェックする？[END-FE]": "Check fairy-related items?[END-FE]",
    # String 262-263
    "・ユリィ[END-FE]": "・Yuri[END-FE]",
    "・コリン[END-FE]": "・Colin[END-FE]",
    # String 264
    "ユリィをどうする？[END-FE]": "What will you do with Yuri?[END-FE]",
    # String 265-270
    "・表示する[END-FE]": "・Show[END-FE]",
    "・表示消す[END-FE]": "・Hide[END-FE]",
    "・分離する[END-FE]": "・Separate[END-FE]",
    "・合流する[END-FE]": "・Reunite[END-FE]",
    "・上下する[END-FE]": "・Move up/down[END-FE]",
    "・上下しない[END-FE]": "・Don't move up/down[END-FE]",
    # String 271-275
    "・妖精能力ＭＡＸ[END-FE]": "・Fairy ability MAX[END-FE]",
    "・追従者を[MainCharName]にする[END-FE]": "・Set follower to [MainCharName][END-FE]",
    "・追従者をウェンディにする[END-FE]": "・Set follower to Wendy[END-FE]",
    "・追従者をルキアスにする[END-FE]": "・Set follower to Lukias[END-FE]",
    "・Ｓフラグ妖精誕生　ＯＮ[END-FE]": "・S-flag fairy birth ON[END-FE]",
    # String 276
    "コリンをどうする？[END-FE]": "What will you do with Colin?[END-FE]",
    # String 286-294
    "集合解散のチェックする[END-FE]": "Checking party gather/dismiss[END-FE]",
    "どうする？[END-FE]": "What will you do?[END-FE]",
    "・パーティーを増やす[END-FE]": "・Add party member[END-FE]",
    "・同行人付ける[END-FE]": "・Add companion[END-FE]",
    "・同行人外す[END-FE]": "・Remove companion[END-FE]",
    "・パーティー解散[END-FE]": "・Disband party[END-FE]",
    "・パーティー集合２[END-FE]": "・Gather party 2[END-FE]",
    "・パーティー集合[END-FE]": "・Gather party[END-FE]",
    "・パーティー陣形[END-FE]": "・Party formation[END-FE]",
    # String 295-300
    "吹き出し位置調整する？[END-FE]": "Adjust speech bubble position?[END-FE]",
    "・する[END-FE]": "・Yes[END-FE]",
    "・しない[END-FE]": "・No[END-FE]",
    "・主人公[END-FE]": "・Protagonist[END-FE]",
    "・ウェンディ[END-FE]": "・Wendy[END-FE]",
    # String 302
    "・もどる[END-FE]": "・Back[END-FE]",
    # Yuri outfit/version entries
    "・ユリィ服０[END-FE]": "・Yuri Outfit 0[END-FE]",
    "・ユリィ服１[END-FE]": "・Yuri Outfit 1[END-FE]",
    "・ユリィ服２[END-FE]": "・Yuri Outfit 2[END-FE]",
    "・ユリィ服３[END-FE]": "・Yuri Outfit 3[END-FE]",
    "・ユリィ服４[END-FE]": "・Yuri Outfit 4[END-FE]",
    "・ユリィ服５[END-FE]": "・Yuri Outfit 5[END-FE]",
    "・ユリィ服６[END-FE]": "・Yuri Outfit 6[END-FE]",
    "・ユリィ服７[END-FE]": "・Yuri Outfit 7[END-FE]",
    "・ユリィ服８[END-FE]": "・Yuri Outfit 8[END-FE]",
    "・ユリィ服９[END-FE]": "・Yuri Outfit 9[END-FE]",
    "・ユリィ服１０[END-FE]": "・Yuri Outfit 10[END-FE]",
    "・ユリィ服１１[END-FE]": "・Yuri Outfit 11[END-FE]",
    "・ユリィ０[END-FE]": "・Yuri 0[END-FE]",
    "・ユリィ１[END-FE]": "・Yuri 1[END-FE]",
    "・ユリィ２[END-FE]": "・Yuri 2[END-FE]",
    # Strings 362-375
    "服を選び直しますか？[END-FE]": "Change outfit selection?[END-FE]",
    "どれか選んで。×で終了[END-FE]": "Select one. Press × to end.[END-FE]",
    "・ウェンディＥＮＤ[END-FE]": "・Wendy END[END-FE]",
    "・ルキアスＥＮＤ[END-FE]": "・Lukias END[END-FE]",
    "・アニータＥＮＤ[END-FE]": "・Anita END[END-FE]",
    "・ホフマンＥＮＤ[END-FE]": "・Hoffman END[END-FE]",
    "・イリステレサＥＮＤ[END-FE]": "・Ilistelesa END[END-FE]",
    "・ゼオンシルトＥＮＤ[END-FE]": "・Zeonshilto END[END-FE]",
    "・ユリィＥＮＤ[END-FE]": "・Yuri END[END-FE]",
    "・主人公ＥＮＤ[END-FE]": "・Protagonist END[END-FE]",
    "・ネーリスＥＮＤ[END-FE]": "・Nelis END[END-FE]",
    "・巨人見上げる[END-FE]": "・Giant looking up[END-FE]",
    "・アドモと巨人[END-FE]": "・Admo and the giant[END-FE]",
    "・龍穴塔[END-FE]": "・Dragon Cave Tower[END-FE]",
    # String 376-380
    "終了は×ボタン[END-FE]": "Press × to end[END-FE]",
    "・下方向[END-FE]": "・Down direction[END-FE]",
    "・上方向[END-FE]": "・Up direction[END-FE]",
    "・左方向[END-FE]": "・Left direction[END-FE]",
    "・右方向[END-FE]": "・Right direction[END-FE]",
    # Movie check entries
    "・V_00 ウェンディエンド[END-FE]": "・V_00 Wendy END[END-FE]",
    "・V_01 ルキアスエンド[END-FE]": "・V_01 Lukias END[END-FE]",
    "・V_02 アニータエンド[END-FE]": "・V_02 Anita END[END-FE]",
    "・V_03 ホフマンエンド[END-FE]": "・V_03 Hoffman END[END-FE]",
    "・V_04 イリステレサエンド[END-FE]": "・V_04 Ilistelesa END[END-FE]",
    "・V_05 ゼオンシルトエンド[END-FE]": "・V_05 Zeonshilto END[END-FE]",
    "・V_06 ユリィエンド[END-FE]": "・V_06 Yuri END[END-FE]",
    "・V_07 主人公エンド[END-FE]": "・V_07 Protagonist END[END-FE]",
    "・V_08 ネーリスエンド[END-FE]": "・V_08 Nelis END[END-FE]",
    "・V_09 巨人見上げる[END-FE]": "・V_09 Giant looking up[END-FE]",
    "・V_10 アドモニと巨人[END-FE]": "・V_10 Admoni and the giant[END-FE]",
    "・V_11 龍穴塔[END-FE]": "・V_11 Dragon Cave Tower[END-FE]",
    # Save check
    "セーブのチェックする[END-FE]": "Checking saves[END-FE]",
    "どれ？[END-FE]": "Which one?[END-FE]",
    "・セーブロード[END-FE]": "・Save/Load[END-FE]",
    "・セーブポイントＯＮ[END-FE]": "・Save Point ON[END-FE]",
    "・セーブポイントＯＦＦ[END-FE]": "・Save Point OFF[END-FE]",
    "デバッグセーブ[END-FE]": "Debug Save[END-FE]",
    # Weapon CG
    "武器ＣＧ変更のチェックする[END-FE]": "Checking weapon CG changes[END-FE]",
    "どれをセットしますか？[END-FE]": "Which would you like to set?[END-FE]",
    "・海魔制御装置[END-FE]": "・Sea demon control device[END-FE]",
    "・手紙[END-FE]": "・Letter[END-FE]",
    "・光点黄[END-FE]": "・Light dot (yellow)[END-FE]",
    "・光点赤[END-FE]": "・Light dot (red)[END-FE]",
    "・光点青[END-FE]": "・Light dot (blue)[END-FE]",
    "・木槌[END-FE]": "・Mallet[END-FE]",
    "・赤ちゃん[END-FE]": "・Baby[END-FE]",
    "・本閉[END-FE]": "・Book (closed)[END-FE]",
    "・本開[END-FE]": "・Book (open)[END-FE]",
    "・信号弾[END-FE]": "・Signal flare[END-FE]",
    "・マスク[END-FE]": "・Mask[END-FE]",
    "・外す[END-FE]": "・Remove[END-FE]",
    # Playback
    "再生の仕方は？（初期値は１回）[END-FE]": "How to play? (Default is 1 time)[END-FE]",
    "・１回再生[END-FE]": "・Play 1 time[END-FE]",
    "・ループ再生[END-FE]": "・Loop playback[END-FE]",
    "・エフェクト消す[END-FE]": "・Remove effect[END-FE]",
    "どれを表示する？[END-FE]": "Which one to display?[END-FE]",
    # Effects
    "・火柱[END-FE]": "・Pillar of fire[END-FE]",
    "・爆発小[END-FE]": "・Small explosion[END-FE]",
    "・爆発大[END-FE]": "・Large explosion[END-FE]",
    "・キラリ１[END-FE]": "・Sparkle 1[END-FE]",
    "・キラリ２[END-FE]": "・Sparkle 2[END-FE]",
    "・煙１[END-FE]": "・Smoke 1[END-FE]",
    "・煙２[END-FE]": "・Smoke 2[END-FE]",
    "・煙３[END-FE]": "・Smoke 3[END-FE]",
    "・煙４[END-FE]": "・Smoke 4[END-FE]",
    "・光の柱（緑）[END-FE]": "・Pillar of light (green)[END-FE]",
    "・光の柱（赤）[END-FE]": "・Pillar of light (red)[END-FE]",
    "・光の柱（青）[END-FE]": "・Pillar of light (blue)[END-FE]",
    "・光の柱２[END-FE]": "・Pillar of light 2[END-FE]",
    "・松明[END-FE]": "・Torch[END-FE]",
    # Blur effects
    "・0 通常ブラー　終了[END-FE]": "・0 Normal blur end[END-FE]",
    "・0 通常ブラー[END-FE]": "・0 Normal blur[END-FE]",
    "・1 横方向ホワイトフェードでブラー　終了[END-FE]": "・1 Horizontal white fade blur end[END-FE]",
    "・1 横方向ホワイトフェードでブラー[END-FE]": "・1 Horizontal white fade blur[END-FE]",
    "・2 回転ホワイトフェードでブラー　終了[END-FE]": "・2 Rotation white fade blur end[END-FE]",
    "・2 回転ホワイトフェードでブラー[END-FE]": "・2 Rotation white fade blur[END-FE]",
    # Music/movie entries
    "・イベント[END-FE]": "・Event[END-FE]",
    "・魔法[END-FE]": "・Magic[END-FE]",
    "・05爆風に飛ばされる[END-FE]": "・05 Blown away by explosion[END-FE]",
    "・06爆発の地響き[END-FE]": "・06 Explosion tremor[END-FE]",
    "・07宇宙船、浮上[END-FE]": "・07 Spaceship, rising[END-FE]",
    "・18アドモニッシャー解説[END-FE]": "・18 Admonisher explanation[END-FE]",
    "・19マザー封印[END-FE]": "・19 Mother sealing[END-FE]",
    "・23アドモニッシャー浮上[END-FE]": "・23 Admonisher rising[END-FE]",
    "・08主人公[END-FE]": "・08 Protagonist[END-FE]",
    "・09エンディング共通部[END-FE]": "・09 Ending common part[END-FE]",
    "・10ウェンディ[END-FE]": "・10 Wendy[END-FE]",
    "・11ルキアス[END-FE]": "・11 Lukias[END-FE]",
    "・12イリステレサ[END-FE]": "・12 Ilistelesa[END-FE]",
    "・13アニータ[END-FE]": "・13 Anita[END-FE]",
    "・14ホフマン[END-FE]": "・14 Hoffman[END-FE]",
    "・15ゼオンシルト[END-FE]": "・15 Zeonshilto[END-FE]",
    "・16ユリィ[END-FE]": "・16 Yuri[END-FE]",
    "・17ネーリス[END-FE]": "・17 Nelis[END-FE]",
    "・00サンダーストーム[END-FE]": "・00 Thunderstorm[END-FE]",
    "・01ソニックウェーブ[END-FE]": "・01 Sonic Wave[END-FE]",
    "・02アースクエイク[END-FE]": "・02 Earthquake[END-FE]",
    "・03メテオ[END-FE]": "・03 Meteor[END-FE]",
    "・04レイズ[END-FE]": "・04 Raise[END-FE]",
    "・20オープニング[END-FE]": "・20 Opening[END-FE]",
    "・21キャラ紹介[END-FE]": "・21 Character introduction[END-FE]",
    "・22スタッフロール[END-FE]": "・22 Staff roll[END-FE]",
    "どの音楽？[END-FE]": "Which music?[END-FE]",
    # Misc debug
    "松２デバッグ実行？[END-FE]": "Run Matsu 2 debug?[END-FE]",
    "カーソル移動チェック[END-FE]": "Cursor movement check[END-FE]",
    "・左上へ[END-FE]": "・To upper left[END-FE]",
    "・右上へ[END-FE]": "・To upper right[END-FE]",
    "・左下へ[END-FE]": "・To lower left[END-FE]",
    "・右下へ[END-FE]": "・To lower right[END-FE]",
    "・中央へ[END-FE]": "・To center[END-FE]",
    "どれが見たい？[END-FE]": "Which would you like to see?[END-FE]",
    # Motion check entries
    "・休め１[END-FE]": "・At ease 1[END-FE]",
    "・休め２[END-FE]": "・At ease 2[END-FE]",
    "・休め３[END-FE]": "・At ease 3[END-FE]",
    "・勝利[END-FE]": "・Victory[END-FE]",
    # String 526
    "戻るのかい？[END-FE]": "Going back?[END-FE]",
}

# Apply single-line replacements safely
for old, new in single_line_map.items():
    content = safe_replace(content, old, new)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done. Checking for remaining Japanese...")

# Quick check for remaining Japanese in non-comment lines
import unicodedata

def has_japanese(text):
    for ch in text:
        cp = ord(ch)
        if (0x3040 <= cp <= 0x309F or   # hiragana
            0x30A0 <= cp <= 0x30FF or   # katakana
            0x4E00 <= cp <= 0x9FFF or   # CJK unified
            0x3400 <= cp <= 0x4DBF):    # CJK extension A
            return True
    return False

remaining = []
with open(filepath, 'r', encoding='utf-8') as f:
    for i, line in enumerate(f, 1):
        stripped = line.rstrip('\n')
        if stripped.startswith('//') or stripped.startswith('#'):
            continue
        if has_japanese(stripped):
            remaining.append((i, stripped[:80]))

print(f"Remaining Japanese lines (non-comment): {len(remaining)}")
for lineno, text in remaining[:30]:
    print(f"  Line {lineno}: {text}")
