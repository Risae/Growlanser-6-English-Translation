import os, re, sys

base_dir = "source/GL6_SCEN.DAT/"

files = [
    "00000050.SCEN CHAPTER 5.2 [TRANSLATED]",
    "00000051.SCEN CHAPTER 4.7 [TRANSLATED]",
    "00000052.SCEN CHAPTER 4.6 [TRANSLATED]",
    "00000053.SCEN CHAPTER 4.4 [TRANSLATED]",
    "00000054.SCEN CHAPTER 10.6 [TRANSLATED]",
    "00000055.SCEN CHAPTER 10.4 [TRANSLATED]",
    "00000056.SCEN CHAPTER 7.1 [TRANSLATED]",
    "00000057.SCEN CHAPTER 4.3 [TRANSLATED]",
    "00000058.SCEN CHAPTER 10.5 [TRANSLATED]",
    "00000060.SCEN CHAPTER 17.1 [TRANSLATED]",
]

def strip_codes(text):
    text = re.sub(r'\[END-F[EF]\]|\[END-FF\]', '', text)
    text = re.sub(r'\[NLINE\]|\[NWIN\]', ' ', text)
    text = re.sub(r'\[COL\d+\]', '', text)
    text = re.sub(r'#W\d+\(\$[0-9A-Fa-f]+\)', '', text)
    text = re.sub(r'\[CHAR[0-9A-Fa-f]+\]|\[VD\d+\]|\[V[0-9A-Fa-f]+\]', '', text)
    return text.strip()

def get_blocks(lines):
    blocks = []
    i = 0
    while i < len(lines):
        if not lines[i].startswith('//'):
            i += 1
            continue
        jp_block = []
        while i < len(lines) and lines[i].startswith('//'):
            jp_block.append((i, lines[i]))
            i += 1
        en_block = []
        while i < len(lines):
            line = lines[i]
            if line.strip() == '' or line.startswith('//'):
                break
            if line.startswith('#') and not line.startswith('#W'):
                i += 1
                continue
            if not line.startswith('#'):
                en_block.append((i, line))
            i += 1
        if en_block:
            blocks.append((jp_block, en_block))
    return blocks

for fname in files:
    path = os.path.join(base_dir, fname)
    with open(path, encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    
    blocks = get_blocks(lines)
    print(f"\n{'='*65}")
    print(f"FILE: {fname}")
    print(f"{'='*65}")
    
    for jp_block, en_block in blocks:
        jp_texts = []
        for _, jl in jp_block:
            content = jl[2:]
            if not re.match(r'POINTER #\d+.*STRING #\d+', content):
                jp_texts.append(content.rstrip('\n'))
        jp_full = ''.join(jp_texts)
        jp_clean = strip_codes(jp_full)
        
        if len(jp_clean) < 10:
            continue
        if jp_clean.startswith('・') and len(jp_clean) < 40:
            continue
        if not re.search(r'[\u3040-\u30FF\u4E00-\u9FFF]', jp_clean):
            continue
            
        en_full = ''.join(l[1].rstrip('\n') for l in en_block)
        en_clean = strip_codes(en_full)
        lnum = en_block[0][0] + 1
        
        print(f"\n[L{lnum}] JP: {jp_clean[:200]}")
        print(f"       EN: {en_clean[:200]}")

