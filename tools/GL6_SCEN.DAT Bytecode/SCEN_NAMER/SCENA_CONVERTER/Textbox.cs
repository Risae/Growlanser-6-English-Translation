using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SCENA_CONVERTER
{
    class Textbox
    {
        public string Name { get; set; }
        public string Content { get; set; }
        public int Id { get; set; }
        public bool HasChoice { get; set; }
        public enum TextboxType
        {
            NORMAL,
            SYSTEM
        }

        }
}