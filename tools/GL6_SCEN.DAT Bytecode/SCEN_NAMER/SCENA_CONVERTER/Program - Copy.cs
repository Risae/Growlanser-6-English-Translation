//using System;
//using System.Collections.Generic;
//using System.IO;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;


//Y's text extractor
//reads the SCENA file and XOR's every byte with
//0xA5, then dumps it all on a file called SCENA.txt
//It can also do the inverse with SCENA.txt

//namespace SCENA_CONVERTER
//{
//    class Program
//    {
//        static void Main(string[] args)
//        {
//            // The code provided will print ‘Hello World’ to the console.
//            // Press Ctrl+F5 (or go to Debug > Start Without Debugging) to run your app.
//            if (args.Length == 0)
//                return;

//            if (Path.GetFileName(args[0]).ToLower() == "scena.dat")
//            {
//                string o = "";

//                FileStream fs = new FileStream(args[0],FileMode.Open);
//                BinaryReader rb = new BinaryReader(fs);

//                int lines = rb.ReadInt32();
//                int size = rb.ReadInt32();

//                Console.WriteLine("Lines: " + lines + " size: " + size);

//                int[] sizes = new int[lines];

//                for(int i = 0; i < lines; i++)
//                {
//                    sizes[i] = rb.ReadInt32();
//                }

//                for (int i = 0; i < lines; i++)
//                {
//                    if (sizes[i] != -1)
//                    {                        
//                        byte[] temp = rb.ReadBytes(sizes[i]);
//                        for (int j = 0; j < temp.Length; j++)
//                        {
//                            if((temp[j] ^ 0xA5) == 0xA)
//                            {
//                                o += "[\\n]";
//                                continue;
//                            }
//                            if ((temp[j] ^ 0xA5) == 0xA8 || (temp[j] ^ 0xA5) == 0xAA || (temp[j] ^ 0xA5) == 0x81)
//                            {
//                                o += "[0x" + (temp[j] ^ 0xA5).ToString("X2") + "]";
//                                continue;
//                            }
//                            if ((temp[j] ^ 0xA5) == 0x00)
//                            {
//                                o += "\n";
//                                continue;
//                            }
//                            o += (char)(temp[j] ^ 0xA5);
//                        }                       
                        
//                        //Console.WriteLine(o);
//                    } else
//                    {
//                        o += "[NULL]";
//                        if(i != lines - 1)
//                        {
//                            o+="\n";
//                        }
//                    }
//                    Console.Write("\rWriting line: " + (i+1) + "/" + lines);
//                }                

//                File.WriteAllText(Path.GetDirectoryName(args[0]) + "/SCENA.txt", o);

//                rb.Close();

//                Console.Write("\nDone! Press Any key to exit...");

//            } else if (Path.GetFileName(args[0]).ToLower() == "scena.txt")
//            {
//                string[] lines = File.ReadAllLines(args[0]);

//                FileStream fs = new FileStream(Path.GetDirectoryName(args[0]) + "/SCENA_NEW.DAT", FileMode.Create);
//                BinaryWriter bw = new BinaryWriter(fs);

//                bw.Write(lines.Length);
//                bw.Seek(0x4, SeekOrigin.Current);
//                int size = 0;
//                for(int i = 0; i < lines.Length; i++)
//                {
//                    if (lines[i].Contains("[NULL]"))
//                    {
//                        bw.Write(-1);
//                        continue;
//                    }
                    
//                    lines[i] = lines[i].Replace("[\\n]", "\n");
//                    lines[i] = lines[i].Replace("[0x81]", ((char)0x81).ToString());
//                    lines[i] = lines[i].Replace("[0xAA]", ((char)0xAA).ToString());
//                    lines[i] = lines[i].Replace("[0xA8]", ((char)0xA8).ToString());
//                    lines[i] += (char)0x00;
//                    bw.Write(lines[i].Length);
//                    //Console.WriteLine(lines[i]);
//                    size += lines[i].Length;
//                }
//                long check = bw.BaseStream.Position;
//                bw.Seek(0x4, SeekOrigin.Begin);
//                bw.Write(size);
//                bw.Seek((int)check, SeekOrigin.Begin);

//                Console.WriteLine("Lines: " + lines.Length + " Size: " + size);

//                for (int i = 0; i < lines.Length; i++)
//                {
//                    if (lines[i].Contains("[NULL]"))
//                    {
//                        Console.Write("\rWriting line: " + (i + 1) + "/" + lines.Length);
//                        continue;
//                    }
//                    byte[] temp = Encoding.Default.GetBytes(lines[i]);
//                    for (int j = 0; j < temp.Length; j++)
//                    {
//                        temp[j] = (byte)(temp[j] ^ 0xA5);
//                    }
//                    bw.Write(temp);
//                    Console.Write("\rWriting line: " + (i + 1) + "/" + lines.Length);                    
//                }

//                bw.Close();

//                Console.Write("\nDone! Press Any key to exit...");
//            }

//            Console.ReadKey();

//            // Go to http://aka.ms/dotnet-get-started-console to continue learning how to build a console app! 
//        }

//        public void Dat2Txt(String path)
//        {

//        }
//    }
//}
