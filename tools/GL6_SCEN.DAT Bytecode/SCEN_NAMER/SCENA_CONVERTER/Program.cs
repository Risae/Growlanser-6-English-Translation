using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//Dumb program to parse character names for Growlanser 6 (and 5?)
//

namespace SCENA_CONVERTER
{
    class Program
    {
        static char[] header_sdf = { 'S', 'D', 'F', '\0' }; //Rework
        static char[] header_stxt = { 'S', 'T', 'X', 'T' }; //Rework

        /*
         STXT FILE string extractor
         STXT files are simple string holding archives
         They are used to store some globally accessed strings with a placeholder

         Structure:
         Follow the FLK file structure with a single SDF block
         with all the strings
         */
        static string[] GetSTXTStrings(FileStream STXT)
        {
            string[] result = new string[0];

            BinaryReader br1 = new BinaryReader(STXT);

            //we asume the file is an STXT, so the SDF starts at 0x80
            br1.BaseStream.Seek(0x80, SeekOrigin.Begin); 

            //Terrible error detection below :)
            char[] header = new char[4];
            br1.Read(header, 0, 4);

            bool is_sdf = true;
            for (int i = 0; i < header.Length; i++)
            {
                if (header[i] != header_sdf[i])
                {
                    is_sdf = false;
                    break;
                }
            }

            if (!is_sdf)
            {
                //TO-DO throw exceptions like a sane person
                Console.WriteLine("Wrong SDF header..."); ;
            }
            else
            {
                //Read SDF Header
                //int16 = UNKNOWN
                //int16 = total lines
                //int32 = total SDF block size (including header)
                //int32 = text starting address

                //skip unknown int16
                br1.BaseStream.Seek(0x2, SeekOrigin.Current); 
                int lines = br1.ReadUInt16();

                //SDF size is ignored, Atlas doesn't update this field on reinsertion, 
                //so it's wrong on the english translated STXT's
                int sdf_size = br1.ReadInt32() + 0x80;
                int text_start = br1.ReadInt32() + 0x80;

                //Go to text starting address
                br1.BaseStream.Seek(text_start, SeekOrigin.Begin);

                //Debug
                //Console.WriteLine("Lines: " + lines);
                //Console.WriteLine(br1.BaseStream.Position);

                result = new string[lines];

                for (int i = 0; i < lines; i++)
                {
                    List<byte> value = new List<byte>();
                    do
                    {
                        value.Add(br1.ReadByte());
                        if (value.Last() == 0)
                        {
                            break;
                        }
                    } while (true);

                    result[i] = DecodeBytesToString(value.ToArray());

                    //debug
                    //Console.WriteLine(NPC_NAMES[i]);
                }

            }
            br1.Dispose();
            br1.Close();
            return result;
        }

        //UNUSED
        public static string PadString(string text)
        {
            int lines = 0;
            using (StringReader reader = new StringReader(text))
            {
                while (reader.ReadLine() != null)
                {
                    lines++;
                }
            }

            //lines++;
            //text += Environment.NewLine;

            //while (lines % 9 != 0)
            //{
            //    lines++;
            //    text += Environment.NewLine;
            //}

            return text + "\r\n\r\n\r\n\r\n\r\n\r\n\r\n";
        }

        static void Main(string[] args)
        {
            //No arguments, leave
            if (args.Length == 0)
                return;

            string jpn_folder = Path.GetDirectoryName(args[0]);
            string eng_folder = Path.GetDirectoryName(args[1]);

            string nl = Environment.NewLine;


            string o = "#VAR(dialogue, TABLE)" + nl
                + "#ADDTBL(\"abcde.tbl\", dialogue)"
                + nl + "#ACTIVETBL(dialogue)" + nl + nl + "#VAR(PTR, CUSTOMPOINTER)" + nl;

            o += "#CREATEPTR(PTR, \"LINEAR\", $[txtptr], 32)"
                + nl + nl + "#VAR(PTRTBL, POINTERTABLE)" + nl;
            o += "#PTRTBL(PTRTBL, $[tblptr], 4, PTR)" + nl + nl;
            o += "#JMP($[txtptr])" + nl;
            o += "#HDR($[txtptr])";
            o = PadString(o);


            string[] NPC_NamesJPN;
            using (FileStream NPC_FILE_jpn = new FileStream(jpn_folder + "/00000141.STXT", FileMode.Open))
            {
                NPC_NamesJPN = GetSTXTStrings(NPC_FILE_jpn);
            }

            string[] NPC_NamesENG;
            using (FileStream NPC_FILE_eng = new FileStream(eng_folder + "/00000141.STXT", FileMode.Open))
            {
                NPC_NamesENG = GetSTXTStrings(NPC_FILE_eng);
            }

            if (NPC_NamesENG.Length != NPC_NamesJPN.Length)
            {
                Console.WriteLine("Name list size mismatch! Press Any key to exit...");
                Console.ReadKey();
                return;
            }


            string[] jpnPaths = Directory.GetFiles(jpn_folder, "*.SCEN", SearchOption.TopDirectoryOnly);
            string[] engPaths = Directory.GetFiles(eng_folder, "*.SCEN", SearchOption.TopDirectoryOnly);

            for (int f = 0; f < jpnPaths.Length; f++)
            {
                FileStream JPN_SCEN_FILE = new FileStream(jpnPaths[f], FileMode.Open);
                FileStream ENG_SCEN_FILE = new FileStream(engPaths[f], FileMode.Open);
                Console.WriteLine(Path.GetFileName(jpnPaths[f]));

                BinaryReader jpnBR = new BinaryReader(JPN_SCEN_FILE);
                BinaryReader engBR = new BinaryReader(ENG_SCEN_FILE);

                jpnBR.BaseStream.Seek(0x18, SeekOrigin.Begin);
                if (jpnBR.ReadInt32() != 4)
                {
                    //TO-DO do this properly
                    Console.WriteLine("SCEN has more than 4 blocks...");
                }
                else
                {
                    short lines;
                    jpnBR.BaseStream.Seek(0x38, SeekOrigin.Begin); //0x38 is the offset to the offset to the SDF

                    long sdf_text_start = jpnBR.ReadInt32();
                    jpnBR.BaseStream.Seek(sdf_text_start, SeekOrigin.Begin);

                    long pointers_start = jpnBR.BaseStream.Position + 0x20;

                    o = o.Replace("[tblptr]", pointers_start.ToString("X")); //replace the placeholder with the actual address

                    jpnBR.BaseStream.Seek(sdf_text_start + 6, SeekOrigin.Begin);
                    lines = jpnBR.ReadInt16();
                    jpnBR.BaseStream.Seek(0x4, SeekOrigin.Current);
                    int lines_start = jpnBR.ReadInt32();
                    jpnBR.BaseStream.Seek(sdf_text_start, SeekOrigin.Begin);
                    jpnBR.BaseStream.Seek(lines_start, SeekOrigin.Current);
                    long textl_start = jpnBR.BaseStream.Position;

                    o = o.Replace("[txtptr]", textl_start.ToString("X")); //replace the placeholder with the actual address

                    Console.WriteLine(lines);

                    string[] SCEN_LINES_JPN = new string[lines];
                    string[] SCEN_LINES_ENG = new string[lines];
                    string[] SCEN_LINES_DEF = new string[lines];

                    SCEN_LINES_ENG = ProcessLines(engBR, SCEN_LINES_ENG, pointers_start, textl_start, ref SCEN_LINES_DEF);
                    SCEN_LINES_JPN = ProcessLines(jpnBR, SCEN_LINES_JPN, pointers_start, textl_start, ref SCEN_LINES_DEF, true);

                    jpnBR.BaseStream.Seek(0x30, SeekOrigin.Begin);
                    long scpt_start = jpnBR.ReadInt32();
                    long scpt_size = jpnBR.ReadInt32();
                    jpnBR.BaseStream.Seek(scpt_start + 0xDA, SeekOrigin.Begin);

                    byte offset = jpnBR.ReadByte();
                    //Console.WriteLine("Magic number: " + offset);

                    while (jpnBR.BaseStream.Position < scpt_size)
                    {
                        byte opcode = jpnBR.ReadByte();
                        if (opcode == 0x42 || opcode == 0x43)
                        {
                            string choices_S = "";


                            //0x42 = text texbox
                            //byte = ID
                            //byte unk
                            //byte = type
                            //Console.WriteLine("Opcode: " + opcode.ToString("X2"));
                            //long pos = br2.BaseStream.Position;
                            jpnBR.BaseStream.Seek(1, SeekOrigin.Current);
                            byte choices = jpnBR.ReadByte();
                            //Console.WriteLine("Choices: " + choices.ToString("X2"));


                            //Workout the real way this is done, there's false positives
                            if (choices == 0 && opcode == 0x43)
                            {
                                choices_S = " (Yes/No question)";
                            }
                            if (choices > 0 && opcode == 0x43)
                            {
                                choices_S = " (" + (choices + 1) + " choices)";
                            }
                            //Console.WriteLine(br2.BaseStream.Position);

                            byte magic_number = jpnBR.ReadByte();

                            //Console.WriteLine("Magic number: " + magic_number.ToString("X2"));


                            //REDO THIS ASAP
                            if (magic_number == 0x08)
                            {
                                //World textboxes
                                //short = NPC ID
                                //byte UNK
                                //byte NPC MODE aka where to look for the name, -1, 1 or 2
                                //short Line Index (for the text)

                                //br2.BaseStream.Seek(4, SeekOrigin.Current);
                                short npc_id = jpnBR.ReadInt16();
                                jpnBR.BaseStream.Seek(1, SeekOrigin.Current);
                                sbyte npc_mode = (sbyte)jpnBR.ReadByte();
                                //Console.WriteLine("ACTOR " + npc_indx);
                                int line_indx = jpnBR.ReadInt16();

                                //Console.WriteLine("LINE " + line_indx);
                                if (line_indx < SCEN_LINES_JPN.Length && line_indx >= 0 && opcode != 0x43)
                                {
                                    SCEN_LINES_ENG[line_indx + offset] = "//" + GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]") + nl + SCEN_LINES_ENG[line_indx + offset];
                                    SCEN_LINES_JPN[line_indx + offset] = GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN) + nl + SCEN_LINES_JPN[line_indx + offset];

                                }
                                else if (line_indx < SCEN_LINES_JPN.Length && line_indx >= 0 && opcode == 0x43)
                                {
                                    SCEN_LINES_ENG[line_indx + offset - 1] = "//08080808080808080808080808080808" + GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]") + choices_S + nl + SCEN_LINES_ENG[line_indx + offset];
                                    SCEN_LINES_JPN[line_indx + offset - 1] = GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN) + nl + SCEN_LINES_JPN[line_indx + offset];
                                }
                                else
                                {
                                    Console.WriteLine("INVALID LINE INDEX: " + line_indx + ", " + jpnBR.BaseStream.Position.ToString("X"));
                                    continue;
                                }
                            }

                            if (magic_number == 0x18)
                            {
                                //Portrait textboxes
                                //short = NPC ID
                                //byte[3] UNK
                                //byte NPC MODE aka where to look for the name, -1, 1 or 2
                                //short Line Index (for the text)

                                //9th line numbah, 10 & 11 line nambah
                                short npc_id = jpnBR.ReadInt16();
                                jpnBR.BaseStream.Seek(3, SeekOrigin.Current);
                                sbyte npc_mode = (sbyte)jpnBR.ReadByte();

                                int line_indx = jpnBR.ReadInt16();
                                //Console.WriteLine(jpnBR.BaseStream.Position + " magic: " + magic_number + " offset: " + offset + " Line: " + (line_indx + offset));

                                if (line_indx < SCEN_LINES_JPN.Length && line_indx >= 0)
                                {
                                    SCEN_LINES_ENG[line_indx + offset] = "//" + GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]")+ nl + SCEN_LINES_ENG[line_indx + offset];
                                    SCEN_LINES_JPN[line_indx + offset] = GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN) + nl + SCEN_LINES_JPN[line_indx + offset];

                                }
                                else if (line_indx < SCEN_LINES_JPN.Length && line_indx >= 0 && opcode == 0x43)
                                {
                                    SCEN_LINES_ENG[line_indx + offset - 1] = "//18181818181818181818181818181818181818" + GetBoxName(npc_mode, npc_id, NPC_NamesENG, SCEN_LINES_ENG).Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]") + choices_S + nl + SCEN_LINES_ENG[line_indx + offset];
                                    SCEN_LINES_JPN[line_indx + offset - 1] = GetBoxName(npc_mode, npc_id, NPC_NamesJPN, SCEN_LINES_JPN) + nl + SCEN_LINES_JPN[line_indx + offset];
                                }
                                else
                                {
                                    Console.WriteLine("INVALID LINE INDEX: " + line_indx);
                                    continue;
                                }
                            }

                            if (magic_number == 0x20)
                            {
                                //Special? the 0x42 is preceded by 0x44
                                //short = UNK
                                //byte[3] UNK
                                //byte NPC MODE aka where to look for the name, -1, 1 or 2
                                //short Line Index (for the text)

                                //9th line numbah, 10 & 11 line nambah
                                //short npc_id = jpnBR.ReadInt16();
                                jpnBR.BaseStream.Seek(4, SeekOrigin.Current);
                                //sbyte npc_mode = (sbyte)jpnBR.ReadByte();

                                int line_indx = jpnBR.ReadInt16();
                                //Console.WriteLine(jpnBR.BaseStream.Position + " magic: " + magic_number + " offset: " + offset + " Line: " + (line_indx + offset));

                                if (line_indx < SCEN_LINES_JPN.Length && line_indx >= 0)
                                {
                                    SCEN_LINES_ENG[line_indx + offset] = "//20202020202020202020202020202020[SYSTEM TEXT]" + choices_S + nl + SCEN_LINES_ENG[line_indx + offset];
                                    //Console.WriteLine(SCEN_LINES_ENG[line_indx + offset]);
                                   SCEN_LINES_JPN[line_indx + offset] = "[SYSTEM TEXT]" + nl + SCEN_LINES_JPN[line_indx + offset];

                                }
                                else
                                {
                                    Console.WriteLine("INVALID LINE INDEX: " + line_indx);
                                    continue;
                                }
                            }
                        }

                        //SCEN_LINES[i] = ByteToUTF8(value.ToArray());
                        //Console.WriteLine(SCEN_LINES[i]);
                    }


                    //Really need to make SCEN lines their own object to avoid having to go
                    //through this many hoops
                    for (int i = 0; i < SCEN_LINES_JPN.Length; i++)
                    {
                        SCEN_LINES_DEF[i] = SCEN_LINES_DEF[i].Replace("\0", "");
                        SCEN_LINES_DEF[i] = SCEN_LINES_DEF[i].Replace("#W32", nl + "#W32");

                        SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]");
                        SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace("[END-FE]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FE]");
                        SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace(nl, nl + "//");
                        SCEN_LINES_JPN[i] = "//" + SCEN_LINES_JPN[i];
                        
                        //SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FF]");
                        //SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace("[END-FE]\r\n\r\n\r\n\r\n\r\n\r\n", "[END-FE]");
                        SCEN_LINES_JPN[i] = SCEN_LINES_JPN[i].Replace("\0", "");

                        SCEN_LINES_ENG[i] = SCEN_LINES_ENG[i].Replace("\0", "");
                        o += SCEN_LINES_DEF[i];
                        o += SCEN_LINES_JPN[i] + nl;
                        o += SCEN_LINES_ENG[i];
                        //o = PadString(o);
                    }

                    File.WriteAllText(Path.GetDirectoryName(args[2]) + "/" + Path.GetFileName(jpnPaths[f]) + ".txt", o);
                    o = "#VAR(dialogue, TABLE)" + nl
                        + "#ADDTBL(\"abcde.tbl\", dialogue)"
                        + nl + "#ACTIVETBL(dialogue)" + nl + nl + "#VAR(PTR, CUSTOMPOINTER)" + nl;

                    o += "#CREATEPTR(PTR, \"LINEAR\", $[txtptr], 32)"
                        + nl + nl + "#VAR(PTRTBL, POINTERTABLE)" + nl;
                    o += "#PTRTBL(PTRTBL, $[tblptr], 4, PTR)" + nl + nl;
                    o += "#JMP($[txtptr])" + nl;
                    o += "#HDR($[txtptr])";
                    o = PadString(o);
                }
                jpnBR.Close();
                engBR.Close();
            }

            //Console.WriteLine(o);
            Console.Write("\nDone! Press Any key to exit...");


            Console.ReadKey();

            // Go to http://aka.ms/dotnet-get-started-console to continue learning how to build a console app! 
        }

        public static string[] ProcessLines(BinaryReader br2, string[] lines, long pointers_start, long textl_start, ref string[] defs, bool isJPN = false)
        {
            for (int i = 0; i < lines.Length; i++)
            {
                br2.BaseStream.Seek(pointers_start, SeekOrigin.Begin);
                int temp = br2.ReadInt32();
                br2.BaseStream.Seek(temp + textl_start, SeekOrigin.Begin);

                string def = "";
                if (isJPN)
                {
                    def = "//POINTER #" + i + " @ $" + pointers_start.ToString("X") + " - STRING #" + i + " @ $" + (temp + textl_start).ToString("X") + "#W32($" + pointers_start.ToString("X") + ")\r\n";
                }

                pointers_start += 0x4;
                List<byte> value = new List<byte>();
                do
                {
                    byte tmp = br2.ReadByte();
                    //Console.Write((char)tmp);
                    value.Add(tmp);
                    if (value.Last() == 0xFF)
                    {
                        byte cc = br2.ReadByte();
                        switch (cc)
                        {
                            case 0xCE:
                            case 0xCF:
                            case 0xAA:
                            case 0xEA:
                            case 0xBE:
                            case 0xBF:
                                value.Add(cc);
                                value.Add(br2.ReadByte());
                                value.Add(br2.ReadByte());
                                break;
                            case 0xE6:
                            case 0xEF:
                            case 0xAC:
                            case 0xD8:
                            case 0xDF:
                            case 0xE1:
                                value.Add(cc);
                                value.Add(br2.ReadByte());
                                break;
                            case 0xFC:
                            case 0xFE:
                            case 0xFD:
                            case 0xFF:
                            case 0xCD:
                                value.Add(cc);
                                break;
                            default:
                                value.Add(cc);
                                value.Add(br2.ReadByte());
                                Console.WriteLine("Unknown CC: " + cc.ToString("X2"));
                                break;
                        }
                        continue;
                    }

                    if (value.Last() == 0)
                    {
                        //Console.WriteLine("\n");
                        break;
                    }
                } while (true);

                if (isJPN)
                {
                    defs[i] = def;
                }

                lines[i] = DecodeBytesToString(value.ToArray());
                //Console.WriteLine(i + ": " + SCEN_LINES[i]);
            }
            return lines;
        }

        public static string GetBoxName(sbyte npc_mode, short npc_indx, string[] names, string[] lines)
        {
            if (npc_mode == -1)
            {
                if (npc_indx < names.Length && npc_indx >= 0)
                {
                    //Console.WriteLine("NAMAE: " + names[npc_indx]);
                    return /*"[HIDDEN] " +*/ names[npc_indx];
                }
                else
                {
                    Console.WriteLine("INVALID NPC INDEX: " + npc_indx);
                }
            }

            if (npc_mode == 0)
            {
                if (npc_indx < names.Length && npc_indx >= 0)
                {
                    return names[npc_indx];
                }
                else
                {
                    Console.WriteLine("INVALID NPC INDEX: " + npc_indx);
                }
            }
            //else
            // {
            if (npc_mode < lines.Length && npc_mode >= 0)
            {
                return lines[npc_mode];
            }
            // else
            // {
            //     Console.WriteLine("INVALID NPC INDEX FOR 0x18: " + npc_indx);
            // }
            // }
            return "";
        }


        //TO-DO:
        //Replace this mess with .tbl file support
        public static string DecodeBytesToString(byte[] value)
        {
            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < value.Length; i++)
            {
                if (i + 1 != value.Length)
                {
                    if (value[i] >= 0x80)
                    {
                        if (value[i] == 0x84 && value[i + 1] >= 0x88 && value[i + 1] <= 0xB5)
                        {
                            if (value[i + 1] == 0xBD && value[i + 2] == 0x84 && value[i + 3] == 0xBE)
                            {
                                sb.Append("[{==}]");
                                i += 3;
                                continue;
                            }
                            if (value[i + 1] == 0x88)
                            {
                                sb.Append("[Lv]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x80)
                            {
                                sb.Append("[SWORD]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x81)
                            {
                                sb.Append("[SHIELD]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x82)
                            {
                                sb.Append("[GEM]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x52)
                            {
                                sb.Append("[GOODS]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x84)
                            {
                                sb.Append("[ITEMS]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x85)
                            {
                                sb.Append("[PLATE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xA5)
                            {
                                sb.Append("[CIRCLE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xA6)
                            {
                                sb.Append("[CROSS]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xA7)
                            {
                                sb.Append("[SQUARE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xA8)
                            {
                                sb.Append("[TRIANGLE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xA1 && value[i + 2] == 0x84 && value[i + 3] == 0xA2)
                            {
                                sb.Append("[L1]");
                                i += 3;
                                continue;
                            }

                            if (value[i + 1] == 0xA3 && value[i + 2] == 0x84 && value[i + 3] == 0xA4)
                            {
                                sb.Append("[L2]");
                                i += 3;
                                continue;
                            }
                            if (value[i + 1] == 0xAC && value[i + 2] == 0x84 && value[i + 3] == 0xAD)
                            {
                                sb.Append("[R1]");
                                i += 3;
                                continue;
                            }
                            if (value[i + 1] == 0xAE && value[i + 2] == 0x84 && value[i + 3] == 0xAF)
                            {
                                sb.Append("[R2]");
                                i += 3;
                                continue;
                            }
                            if (value[i + 1] == 0xB0 && value[i + 2] == 0x84 && value[i + 3] == 0xB1 && value[i + 4] == 0x84 && value[i + 5] == 0xB2)
                            {
                                sb.Append("[START]");
                                i += 5;
                                continue;
                            }
                            if (value[i + 1] == 0xB5 && value[i + 2] == 0x84 && value[i + 3] == 0xB6 && value[i + 4] == 0x84 && value[i + 5] == 0xB7)
                            {
                                sb.Append("[SELECT]");
                                i += 5;
                                continue;
                            }

                        }

                        if (value[i] == 0x81 && value[i + 1] >= 0xB8 && value[i + 1] <= 0xF4)
                        {
                            if (value[i + 1] == 0xB8 && value[i + 2] == 0x81 && value[i + 3] == 0xB9 && value[i + 4] == 0x81 && value[i + 5] == 0xBA)
                            {
                                sb.Append("[---]");
                                i += 5;
                                continue;
                            }
                            if (value[i + 1] == 0xB9)
                            {
                                sb.Append("[-]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xBE)
                            {
                                sb.Append("[!?]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xBF)
                            {
                                sb.Append("[2-TEAR-DROP]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xCC)
                            {
                                sb.Append("[{=}]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xCD)
                            {
                                sb.Append("[HEART]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xCE)
                            {
                                sb.Append("[TEAR-DROP]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0xF4)
                            {
                                sb.Append("[MUSIC-NOTE]");
                                i++;
                                continue;
                            }
                        }

                        if (value[i] == 0x87 && value[i + 1] >= 0x40 && value[i + 1] <= 0x5D)
                        {
                            if (value[i + 1] == 0x40)
                            {
                                sb.Append("[(1)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x41)
                            {
                                sb.Append("[(2)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x42)
                            {
                                sb.Append("[(3)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x43)
                            {
                                sb.Append("[(4)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x44)
                            {
                                sb.Append("[(5)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x45)
                            {
                                sb.Append("[(6)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x46)
                            {
                                sb.Append("[(7)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x47)
                            {
                                sb.Append("[(8)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x48)
                            {
                                sb.Append("[(9)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x49)
                            {
                                sb.Append("[(19)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4A)
                            {
                                sb.Append("[(11)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4B)
                            {
                                sb.Append("[(12)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4C)
                            {
                                sb.Append("[(13)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4D)
                            {
                                sb.Append("[(14)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4E)
                            {
                                sb.Append("[(15)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x4F)
                            {
                                sb.Append("[(16)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x50)
                            {
                                sb.Append("[(17)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x51)
                            {
                                sb.Append("[(18)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x52)
                            {
                                sb.Append("[(19)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x53)
                            {
                                sb.Append("[(20)]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x54)
                            {
                                sb.Append("[ONE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x55)
                            {
                                sb.Append("[TWO]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x56)
                            {
                                sb.Append("[THREE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x57)
                            {
                                sb.Append("[FOUR]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x58)
                            {
                                sb.Append("[FIVE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x59)
                            {
                                sb.Append("[SIX]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x5A)
                            {
                                sb.Append("[SEVEN]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x5B)
                            {
                                sb.Append("[EIGTH]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x5C)
                            {
                                sb.Append("[NINE]");
                                i++;
                                continue;
                            }
                            if (value[i + 1] == 0x5D)
                            {
                                sb.Append("[TEN]");
                                i++;
                                continue;
                            }
                        }

                        if (value[i] == 0xff)
                        {
                            switch (value[i + 1])
                            {
                                case 0xff:
                                    sb.Append("[END-FF]\r\n\r\n\r\n\r\n\r\n\r\n");
                                    break;

                                case 0xfe:
                                    sb.Append("[END-FE]\r\n\r\n\r\n\r\n\r\n\r\n");
                                    break;

                                case 0xfc:
                                    sb.Append("[NLINE]\r\n");
                                    break;

                                case 0xfd:
                                    sb.Append("[NWIN]\r\n\r\n");
                                    break;

                                case 0xCF:
                                    sb.Append("[V" + value[i + 2].ToString("X2") + value[i + 3].ToString("X2") + "]\r\n");
                                    i++;
                                    i++;
                                    break;

                                case 0xCE:
                                    sb.Append("[CHAR" + value[i + 2].ToString("X2") + value[i + 3].ToString("X2") + "]");
                                    i++;
                                    i++;
                                    break;

                                case 0xAA:
                                case 0xEA:
                                case 0xBE:
                                case 0xBF:
                                    sb.Append("[CC." + value[i + 1].ToString("X2") + value[i + 2].ToString("X2") + value[i + 3].ToString("X2") + "]");
                                    i++;
                                    i++;
                                    break;

                                case 0xE6:
                                case 0xEF:
                                case 0xAC:
                                case 0xD8:
                                    sb.Append("[CC." + value[i + 1].ToString("X2") + value[i + 2].ToString("X2") + "]");
                                    i++;
                                    break;

                                case 0xDF:
                                    sb.Append("[COL" + value[i + 2].ToString("X2") + "]");
                                    i++;
                                    break;

                                default:
                                    break;
                            }
                            i++;
                            continue;
                        }

                        byte[] jis = { value[i], value[i + 1] };
                        i++;
                        sb.Append(Encoding.UTF8.GetString(Encoding.Convert(Encoding.GetEncoding("shift_jis"), Encoding.UTF8, Encoding.GetEncoding("shift_jis").GetBytes(Encoding.GetEncoding("shift_jis").GetString(jis, 0, jis.Length)))));
                        continue;
                    }
                    sb.Append((char)value[i]);
                    continue;
                }
                sb.Append((char)value[i]);
            }

            return sb.ToString();
        }
    }
}
