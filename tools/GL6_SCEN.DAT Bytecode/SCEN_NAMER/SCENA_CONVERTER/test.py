import os
import struct

header_sdf = "SDF\0"
header_stxt = "STXT"

def GetSTXTStrings(STXT):

    result = []
    STXT.seek(0x80, os.SEEK_SET)
    header = STXT.read(4).decode('utf-8')
    is_sdf = True

    for i in range(len(header)):
        if header[i] != header_sdf[i]:
            is_sdf = False
            break

    if not is_sdf:
        print("Wrong SDF header...")

    else:
        STXT.seek(0x2, os.SEEK_CUR)
        lines = struct.unpack('<H', STXT.read(2))[0]
        sdf_size = struct.unpack('<I', STXT.read(4))[0] + 0x80
        text_start = struct.unpack('<I', STXT.read(4))[0] + 0x80
        STXT.seek(text_start, os.SEEK_SET)
        for i in range(lines):
            value = []
            while True:
                byte = STXT.read(1)[0]
                value.append(byte)
                if byte == 0:
                    break
            result.append(bytes(value).decode('utf-8'))

    return result

def PadString(text):
    lines = text.count('\n')
    return text + '\n' * (7 - lines)

def ProcessLines(br2, lines, pointers_start, textl_start, defs, isJPN=False):
    for i in range(len(lines)):
        br2.seek(pointers_start, os.SEEK_SET)
        temp = struct.unpack('<I', br2.read(4))[0]
        br2.seek(temp + textl_start, os.SEEK_SET)
        def_ = ""

        if isJPN:
            def_ = f"//POINTER #{i} @ ${pointers_start:X} - STRING #{i} @ ${(temp + textl_start):X}#W32(${pointers_start:X})\n"

        pointers_start += 0x4
        value = []

        while True:
            byte = br2.read(1)[0]
            value.append(byte)

            if value[-1] == 0xFF:
                cc = br2.read(1)[0]

                if cc in [0xCE, 0xCF, 0xAA, 0xEA, 0xBE, 0xBF]:
                    value.append(cc)
                    value.append(br2.read(1)[0])
                    value.append(br2.read(1)[0])

                elif cc in [0xE6, 0xEF, 0xAC, 0xD8, 0xDF, 0xE1]:
                    value.append(cc)
                    value.append(br2.read(1)[0])

                elif cc in [0xFC, 0xFE, 0xFD, 0xFF, 0xCD]:
                    value.append(cc)

                else:
                    value.append(cc)
                    value.append(br2.read(1)[0])
                    print(f"Unknown CC: {cc:02X}")
                continue
            
            if value[-1] == 0:
                break

        if isJPN:
            defs[i] = def_

        lines[i] = bytes(value).decode('utf-8')

    return lines

def GetBoxName(npc_mode, npc_indx, names, lines):
    if npc_mode == -1:
        if npc_indx < len(names) and npc_indx >= 0:
            return names[npc_indx]

        else:
            print(f"INVALID NPC INDEX: {npc_indx}")

    if npc_mode == 0:
        if npc_indx < len(names) and npc_indx >= 0:
            return names[npc_indx]

        else:
            print(f"INVALID NPC INDEX: {npc_indx}")

    if npc_mode < len(lines) and npc_mode >= 0:
        return lines[npc_mode]
    return ""


def decode_bytes_to_string(value):
    sb = []
    i = 0
    while i < len(value):
        if i + 1 != len(value):
            if value[i] >= 0x80:
                if value[i] == 0x84 and value[i + 1] >= 0x88 and value[i + 1] <= 0xB5:
                    if value[i + 1] == 0xBD and value[i + 2] == 0x84 and value[i + 3] == 0xBE:
                        sb.append("[{==}]")
                        i += 3
                        continue

                    if value[i + 1] == 0x88:
                        sb.append("[Lv]")
                        i += 1
                        continue

                    if value[i + 1] == 0x80:
                        sb.append("[SWORD]")
                        i += 1
                        continue

                    if value[i + 1] == 0x81:
                        sb.append("[SHIELD]")
                        i += 1
                        continue

                    if value[i + 1] == 0x82:
                        sb.append("[GEM]")
                        i += 1
                        continue

                    if value[i + 1] == 0x52:
                        sb.append("[GOODS]")
                        i += 1
                        continue

                    if value[i + 1] == 0x84:
                        sb.append("[ITEMS]")
                        i += 1
                        continue

                    if value[i + 1] == 0x85:
                        sb.append("[PLATE]")
                        i += 1
                        continue

                    if value[i + 1] == 0xA5:
                        sb.append("[CIRCLE]")
                        i += 1
                        continue

                    if value[i + 1] == 0xA6:
                        sb.append("[CROSS]")
                        i += 1
                        continue

                    if value[i + 1] == 0xA7:
                        sb.append("[SQUARE]")
                        i += 1
                        continue

                    if value[i + 1] == 0xA8:
                        sb.append("[TRIANGLE]")
                        i += 1
                        continue

                    if value[i + 1] == 0xA1 and value[i + 2] == 0x84 and value[i + 3] == 0xA2:
                        sb.append("[L1]")
                        i += 3
                        continue

                    if value[i + 1] == 0xA3 and value[i + 2] == 0x84 and value[i + 3] == 0xA4:
                        sb.append("[L2]")
                        i += 3
                        continue

                    if value[i + 1] == 0xAC and value[i + 2] == 0x84 and value[i + 3] == 0xAD:
                        sb.append("[R1]")
                        i += 3
                        continue

                    if value[i + 1] == 0xAE and value[i + 2] == 0x84 and value[i + 3] == 0xAF:
                        sb.append("[R2]")
                        i += 3
                        continue

                    if value[i + 1] == 0xB0 and value[i + 2] == 0x84 and value[i + 3] == 0xB1 and value[i + 4] == 0x84 and value[i + 5] == 0xB2:
                        sb.append("[START]")
                        i += 5
                        continue

                    if value[i + 1] == 0xB5 and value[i + 2] == 0x84 and value[i + 3] == 0xB6 and value[i + 4] == 0x84 and value[i + 5] == 0xB7:
                        sb.append("[SELECT]")
                        i += 5
                        continue

                if value[i] == 0x81 and value[i + 1] >= 0xB8 and value[i + 1] <= 0xF4:
                    if value[i + 1] == 0xB8 and value[i + 2] == 0x81 and value[i + 3] == 0xB9 and value[i + 4] == 0x81 and value[i + 5] == 0xBA:
                        sb.append("[---]")
                        i += 5
                        continue

                    if value[i + 1] == 0xB9:
                        sb.append("[-]")
                        i += 1
                        continue

                    if value[i + 1] == 0xBE:
                        sb.append("[!?]")
                        i += 1
                        continue

                    if value[i + 1] == 0xBF:
                        sb.append("[2-TEAR-DROP]")
                        i += 1
                        continue
                    if value[i + 1] == 0xCC:
                        sb.append("[{=}]")
                        i += 1
                        continue

                    if value[i + 1] == 0xCD:
                        sb.append("[HEART]")
                        i += 1
                        continue

                    if value[i + 1] == 0xCE:
                        sb.append("[TEAR-DROP]")
                        i += 1
                        continue

                    if value[i + 1] == 0xF4:
                        sb.append("[MUSIC-NOTE]")
                        i += 1
                        continue

                if value[i] == 0x87 and value[i + 1] >= 0x40 and value[i + 1] <= 0x5D:
                    if value[i + 1] == 0x40:
                        sb.append("[(1)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x41:
                        sb.append("[(2)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x42:
                        sb.append("[(3)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x43:
                        sb.append("[(4)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x44:
                        sb.append("[(5)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x45:
                        sb.append("[(6)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x46:
                        sb.append("[(7)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x47:
                        sb.append("[(8)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x48:
                        sb.append("[(9)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x49:
                        sb.append("[(19)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4A:
                        sb.append("[(11)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4B:
                        sb.append("[(12)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4C:
                        sb.append("[(13)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4D:
                        sb.append("[(14)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4E:
                        sb.append("[(15)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x4F:
                        sb.append("[(16)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x50:
                        sb.append("[(17)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x51:
                        sb.append("[(18)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x52:
                        sb.append("[(19)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x53:
                        sb.append("[(20)]")
                        i += 1
                        continue
                    if value[i + 1] == 0x54:
                        sb.append("[ONE]")
                        i += 1
                        continue
                    if value[i + 1] == 0x55:
                        sb.append("[TWO]")
                        i += 1
                        continue
                    if value[i + 1] == 0x56:
                        sb.append("[THREE]")
                        i += 1
                        continue
                    if value[i + 1] == 0x57:
                        sb.append("[FOUR]")
                        i += 1
                        continue
                    if value[i + 1] == 0x58:
                        sb.append("[FIVE]")
                        i += 1
                        continue
                    if value[i + 1] == 0x59:
                        sb.append("[SIX]")
                        i += 1
                        continue
                    if value[i + 1] == 0x5A:
                        sb.append("[SEVEN]")
                        i += 1
                        continue
                    if value[i + 1] == 0x5B:
                        sb.append("[EIGTH]")
                        i += 1
                        continue
                    if value[i + 1] == 0x5C:
                        sb.append("[NINE]")
                        i += 1
                        continue
                    if value[i + 1] == 0x5D:
                        sb.append("[TEN]")
                        i += 1
                        continue
                if value[i] == 0xff:
                    if value[i + 1] == 0xff:
                        sb.append("[END-FF]\n\n\n\n\n\n")
                    elif value[i + 1] == 0xfe:
                        sb.append("[END-FE]\n\n\n\n\n\n")
                    elif value[i + 1] == 0xfc:
                        sb.append("[NLINE]\n")
                    elif value[i + 1] == 0xfd:
                        sb.append("[NWIN]\n\n")
                    elif value[i + 1] == 0xCF:
                        sb.append("[V" + format(value[i + 2], 'X2') + format(value[i + 3], 'X2') + "]\n")
                        i += 2
                    elif value[i + 1] == 0xCE:
                        sb.append("[CHAR" + format(value[i + 2], 'X2') + format(value[i + 3], 'X2') + "]")
                        i += 2
                    elif value[i + 1] == 0xAA or value[i + 1] == 0xEA or value[i + 1] == 0xBE or value[i + 1] == 0xBF:
                        sb.append("[CC." + format(value[i + 1], 'X2') + format(value[i + 2], 'X2') + format(value[i + 3], 'X2') + "]")
                        i += 2
                    elif value[i + 1] == 0xE6 or value[i + 1] == 0xEF or value[i + 1] == 0xAC or value[i + 1] == 0xD8:
                        sb.append("[CC." + format(value[i + 1], 'X2') + format(value[i + 2], 'X2') + "]")
                        i += 1
                    elif value[i + 1] == 0xDF:
                        sb.append("[COL" + format(value[i + 2], 'X2') + "]")
                        i += 1
                    i += 1
                    continue
                jis = [value[i], value[i + 1]]
                i += 1
                sb.append(jis.decode('shift_jis'))
                continue
            sb.append(chr(value[i]))
            continue
        sb.append(chr(value[i]))
        i += 1
    return ''.join(sb)

def main():

    jpn_folder = os.path.dirname(args[0])
    eng_folder = os.path.dirname(args[1])

    o = (f"""\
#VAR(dialogue, TABLE)
#ADDTBL("abcde.tbl", dialogue)
#ACTIVETBL(dialogue)

#VAR(PTR, CUSTOMPOINTER)
#CREATEPTR(PTR, "LINEAR", [txtptr], 32)

#VAR(PTRTBL, POINTERTABLE)
#PTRTBL(PTRTBL, [tblptr], 4, PTR)

#JMP([txtptr])
#HDR([txtptr])
""")

    o = PadString(o)

    NPC_NamesJPN = []
    with open(jpn_folder + "/00000141.STXT", "rb") as NPC_FILE_jpn:
        NPC_NamesJPN = GetSTXTStrings(NPC_FILE_jpn)

    NPC_NamesENG = []
    with open(eng_folder + "/00000141.STXT", "rb") as NPC_FILE_eng:
        NPC_NamesENG = GetSTXTStrings(NPC_FILE_eng)

    if len(NPC_NamesENG) != len(NPC_NamesJPN):
        print("Name list size mismatch! Press Any key to exit...")
        input()
        return

    jpnPaths = [f for f in os.listdir(jpn_folder) if f.endswith(".SCEN")]
    engPaths = [f for f in os.listdir(eng_folder) if f.endswith(".SCEN")]

    for f in range(len(jpnPaths)):
        with open(jpn_folder + "/" + jpnPaths[f], "rb") as JPN_SCEN_FILE, open(eng_folder + "/" + engPaths[f], "rb") as ENG_SCEN_FILE:
            print(os.path.basename(jpnPaths[f]))
            jpnBR = JPN_SCEN_FILE.read()
            engBR = ENG_SCEN_FILE.read()
            jpnBR.seek(0x18, os.SEEK_SET)

            if struct.unpack('<I', jpnBR.read(4))[0] != 4:
                print("SCEN has more than 4 blocks...")

            else:
                lines = 0
                jpnBR.seek(0x38, os.SEEK_SET)
                sdf_text_start = struct.unpack('<I', jpnBR.read(4))[0]
                jpnBR.seek(sdf_text_start, os.SEEK_SET)
                pointers_start = jpnBR.tell() + 0x20
                o = o.replace("[tblptr]", f"{pointers_start:X}")
                jpnBR.seek(sdf_text_start + 6, os.SEEK_SET)
                lines = struct.unpack('<H', jpnBR.read(2))[0]
                jpnBR.seek(0x4, os.SEEK_CUR)
                lines_start = struct.unpack('<I', jpnBR.read(4))[0]
                jpnBR.seek(sdf_text_start, os.SEEK_SET)
                jpnBR.seek(lines_start, os.SEEK_CUR)
                textl_start = jpnBR.tell()
                o = o.replace("[txtptr]", f"{textl_start:X}")
                print(lines)
                SCEN_LINES_JPN = [''] * lines
                SCEN_LINES_ENG = [''] * lines
                SCEN_LINES_DEF = [''] * lines
                SCEN_LINES_ENG = ProcessLines(engBR, SCEN_LINES_ENG, pointers_start, textl_start, SCEN_LINES_DEF)
                SCEN_LINES_JPN = ProcessLines(jpnBR, SCEN_LINES_JPN, pointers_start, textl_start, SCEN_LINES_DEF, True)
                jpnBR.seek(0x30, os.SEEK_SET)
                scpt_start = struct.unpack('<I', jpnBR.read(4))[0]
                scpt_size = struct.unpack('<I', jpnBR.read(4))[0]
                jpnBR.seek(scpt_start + 0xDA, os.SEEK_SET)
                offset = jpnBR.read(1)[0]

                while jpnBR.tell() < scpt_size:
                    opcode = jpnBR.read(1)[0]

                    if opcode == 0x42 or opcode == 0x43:
                        choices_S = ""
                        jpnBR.seek(1, os.SEEK_CUR)
                        choices = jpnBR.read(1)[0]

                        if choices == 0 and opcode == 0x43:
                            choices_S = " (Yes/No question)"

                        if choices > 0 and opcode == 0x43:
                            choices_S = f" ({choices + 1} choices)"

                        magic_number = jpnBR.read(1)[0]

                        if magic_number == 0x08:
                            npc_id = struct.unpack('<h', jpnBR.read(2))[0]
                            jpnBR.seek(1, os.SEEK_CUR)
                            npc_mode = struct.unpack('b', jpnBR.read(1))[0]
                            line_indx = struct.unpack('<h', jpnBR.read(2))[0]

                            if line_indx < len(SCEN_LINES_JPN) and line_indx >= 0 and opcode != 0x43:
                                SCEN_LINES_ENG[line_indx + offset] = f"//{GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).replace('[END-FF]\\n\\n\\n\\n\\n\\n\\n', '[END-FF]')}\n{SCEN_LINES_ENG[line_indx + offset]}"
                                SCEN_LINES_JPN[line_indx + offset] = f"{GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN)}\n{SCEN_LINES_JPN[line_indx + offset]}"

                            elif line_indx < len(SCEN_LINES_JPN) and line_indx >= 0 and opcode == 0x43:
                                SCEN_LINES_ENG[line_indx + offset - 1] = f"//08080808080808080808080808080808{GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).replace('[END-FF]\\n\\n\\n\\n\\n\\n\\n', '[END-FF]')}{choices_S}\n{SCEN_LINES_ENG[line_indx + offset]}"
                                SCEN_LINES_JPN[line_indx + offset - 1] = f"{GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN)}\n{SCEN_LINES_JPN[line_indx + offset]}"

                            else:
                                print(f"INVALID LINE INDEX: {line_indx}, {jpnBR.tell():X}")
                                continue

                        if magic_number == 0x18:
                            npc_id = struct.unpack('<h', jpnBR.read(2))[0]
                            jpnBR.seek(3, os.SEEK_CUR)
                            npc_mode = struct.unpack('b', jpnBR.read(1))[0]
                            line_indx = struct.unpack('<h', jpnBR.read(2))[0]
                            
                            if line_indx < len(SCEN_LINES_JPN) and line_indx >= 0:
                                SCEN_LINES_ENG[line_indx + offset] = f"//{GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).replace('[END-FF]\\n\\n\\n\\n\\n\\n\\n', '[END-FF]')}\n{SCEN_LINES_ENG[line_indx + offset]}"
                                SCEN_LINES_JPN[line_indx + offset] = f"{GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN)}\n{SCEN_LINES_JPN[line_indx + offset]}"

                            elif line_indx < len(SCEN_LINES_JPN) and line_indx >= 0 and opcode == 0x43:
                                SCEN_LINES_ENG[line_indx + offset - 1] = f"//18181818181818181818181818181818181818{GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).replace('[END-FF]\\n\\n\\n\\n\\n\\n\\n', '[END-FF]')}{choices_S}\n{SCEN_LINES_ENG[line_indx + offset]}"
                                SCEN_LINES_JPN[line_indx + offset - 1] = f"{GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN)}\n{SCEN_LINES_JPN[line_indx + offset]}"

                            else:
                                print(f"INVALID LINE INDEX: {line_indx}")
                                continue

                        if magic_number == 0x20:
                            jpnBR.seek(4, os.SEEK_CUR)
                            line_indx = struct.unpack('<h', jpnBR.read(2))[0]

                            if line_indx < len(SCEN_LINES_JPN) and line_indx >= 0:
                                SCEN_LINES_ENG[line_indx + offset] = f"//20202020202020202020202020202020[SYSTEM TEXT]{choices_S}\n{SCEN_LINES_ENG[line_indx + offset]}"
                                SCEN_LINES_JPN[line_indx + offset] = f"[SYSTEM TEXT]\n{SCEN_LINES_JPN[line_indx + offset]}"

                            else:
                                print(f"INVALID LINE INDEX: {line_indx}")
                                continue

                for i in range(len(SCEN_LINES_JPN)):
                    SCEN_LINES_DEF[i] = SCEN_LINES_DEF[i].replace("\0", "")
                    SCEN_LINES_DEF[i] = SCEN_LINES_DEF[i].replace("#W32", "\n#W32")
                    SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].replace("[END-FF]\\n\\n\\n\\n\\n\\n\\n", "[END-FF]")
                    SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].replace("[END-FE]\\n\\n\\n\\n\\n\\n\\n", "[END-FE]")
                    SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].replace("\n", "\n//")
                    SCEN_LINES_JPN[i] = f"//{SCEN_LINES_JPN[i]}"
                    SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].replace("\0", "")
                    SCEN_LINES_ENG[i] = SCEN_LINES_ENG[i].replace("\0", "")
                    o += SCEN_LINES_DEF[i]
                    o += SCEN_LINES_JPN[i] + '\n'
                    o += SCEN_LINES_ENG[i]

                with open(os.path.dirname(args[2]) + "/" + os.path.basename(jpnPaths[f]) + ".txt", "w") as file:
                    file.write(f"""\
#VAR(dialogue, TABLE)
#ADDTBL("abcde.tbl", dialogue)
#ACTIVETBL(dialogue)

#VAR(PTR, CUSTOMPOINTER)
#CREATEPTR(PTR, "LINEAR", [txtptr], 32)

#VAR(PTRTBL, POINTERTABLE)
#PTRTBL(PTRTBL, [tblptr], 4, PTR)

#JMP([txtptr])
#HDR([txtptr])
""")

        print("\nDone! Press Any key to exit...")
        input()