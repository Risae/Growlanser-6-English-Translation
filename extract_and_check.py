#!/usr/bin/env python3
import os
import subprocess
import re
import sys

SCEN_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_SCEN.DAT/"
FILE_DIR = "/home/runner/work/Growlanser-6-English-Translation/Growlanser-6-English-Translation/source/GL6_FILE.DAT/"

# Game-specific proper nouns and terms to whitelist (not typos)
WHITELIST = {
    # Character/place names
    'yurii', 'dastis', 'goatland', 'pothrad', 'yarstill', 'hingis', 'yggdra',
    'olgamore', 'olga', 'torel', 'aldric', 'transgate', 'kaiser', 'celestial',
    'growlanser', 'schwartz', 'monika', 'cecile', 'liscia', 'ramue', 'laysha',
    'carlie', 'orbalance', 'krutz', 'rein', 'aston', 'aloof', 'fenn',
    'platoon', 'mana', 'atk', 'def', 'spd', 'lvl', 'xp', 'hp', 'mp',
    'jp', 'dp', 'grp', 'rng', 'mov', 'agi', 'str', 'vit', 'int', 'wis',
    'luk', 'acc', 'eva', 'res', 'spellcaster', 'spellcasters', 'spellcasting',
    'guardbreak', 'guardbreaks', 'counterattack', 'counterattacks',
    'knack', 'knacks', 'timelapse', 'skillset', 'skillsets',
    'overground', 'heirloom', 'entrapment', 'bequeath', 'transference',
    'interception', 'teleportation', 'reincarnation',
    'combatant', 'combatants', 'spellbook', 'spellbooks',
    'lifespan', 'lifelong', 'lifeline', 'lifeblood',
    'overheal', 'overhealing', 'backstab', 'backstabs',
    'knockback', 'knockbacks', 'aoe', 'npc', 'npcs',
    'spd', 'regen', 'crit', 'debuff', 'debuffs', 'buff', 'buffs',
    'respawn', 'respawning', 'playthru', 'playthrough',
    'guildmaster', 'swordsman', 'swordsmen', 'swordsmanship',
    'spearman', 'spearmen', 'bowman', 'bowmen', 'demi', 'demigod',
    'manapool', 'manashield', 'manastorm',
    'haaken', 'hestin', 'dorvan', 'riviera', 'meldor',
    'revorse', 'briskia', 'valeria', 'brannard',
    'caulk', 'rezef', 'sable', 'balzack', 'kuhnbeck',
    'alentius', 'altecia', 'rasfaras', 'rastafar',
    # Game terms
    'mithril', 'orichalcum', 'adamantite', 'adamant', 'orihalcon',
    'elemental', 'elementals', 'spellsword', 'runeblade',
    'enchant', 'enchants', 'enchantment', 'enchantments',
    'sigil', 'sigils', 'glyph', 'glyphs', 'rune', 'runes',
    'talisman', 'talismans', 'amulet', 'amulets',
    'foe', 'foes', 'boon', 'boons',
    'skillchain', 'combochain',
    # Common game abbreviations
    'ok', 'vs', 'etc', 'ie', 'eg',
}

def is_command_line(line):
    """Check if a line is a command (should be ignored)."""
    stripped = line.strip()
    if not stripped:
        return True
    if stripped.startswith('//'):
        return True
    if stripped.startswith('#'):
        return True
    # Lines that are purely command brackets like [END-FF]
    # but we want to keep lines that have text + commands
    # Pure command lines: entirely made of [...] blocks
    text_without_brackets = re.sub(r'\[[^\]]*\]', '', stripped).strip()
    if not text_without_brackets:
        return True
    return False

def extract_text_from_line(line):
    """Extract just the text content, removing command brackets."""
    # Remove [...] commands
    text = re.sub(r'\[[^\]]*\]', '', line)
    # Remove #... commands at start
    text = re.sub(r'^#[^\s]*(\([^)]*\))?', '', text)
    return text.strip()

def get_english_lines(filepath):
    """Extract English text lines from a translation file."""
    lines = []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            for lineno, raw_line in enumerate(f, 1):
                line = raw_line.rstrip('\n').rstrip('\r')
                if is_command_line(line):
                    continue
                text = extract_text_from_line(line)
                if text:
                    lines.append((lineno, line.strip(), text))
    except Exception as e:
        print(f"Error reading {filepath}: {e}", file=sys.stderr)
    return lines

def aspell_check_text(text):
    """Run aspell on text and return list of misspelled words."""
    try:
        result = subprocess.run(
            ['aspell', 'list', '--lang=en_US', '--mode=none'],
            input=text, capture_output=True, text=True, timeout=10
        )
        misspelled = [w.strip() for w in result.stdout.strip().split('\n') if w.strip()]
        # Filter whitelist and short words
        misspelled = [w for w in misspelled 
                      if w.lower() not in WHITELIST and len(w) > 2]
        return misspelled
    except Exception as e:
        return []

def check_grammar_patterns(text, raw_line):
    """Check for common grammar/punctuation issues."""
    issues = []
    
    # Double words
    double_word = re.search(r'\b(\w+)\s+\1\b', text, re.IGNORECASE)
    if double_word:
        issues.append(f"Double word: '{double_word.group(0)}'")
    
    # Missing space after comma/period (but not ellipsis ...)
    if re.search(r'[,;](?!\s)(?!$)', text):
        issues.append("Missing space after comma/semicolon")
    if re.search(r'\.(?!\s)(?!\.)(?!$)(?![A-Z]{2})', text):
        issues.append("Missing space after period")
    
    # Extra spaces
    if re.search(r'  ', text):
        issues.append("Extra space")
    
    # Space before punctuation (not ellipsis)
    if re.search(r'\s[,!?;:](?!\s*\.)', text):
        issues.append("Space before punctuation")
    
    return issues

def process_directory(dirpath):
    """Process all translated/edited files in a directory."""
    results = {}
    
    files = os.listdir(dirpath)
    translated_files = [f for f in files if 
                        ('[TRANSLATED]' in f or '[EDITED]' in f) and
                        not f.endswith('.asm')]
    
    for filename in sorted(translated_files):
        filepath = os.path.join(dirpath, filename)
        english_lines = get_english_lines(filepath)
        
        file_issues = []
        
        for lineno, raw_line, text in english_lines:
            misspelled = aspell_check_text(text)
            grammar_issues = check_grammar_patterns(text, raw_line)
            
            for word in misspelled:
                # Get suggestion
                try:
                    result = subprocess.run(
                        ['aspell', '-a', '--lang=en_US', '--mode=none'],
                        input=f"^{word}\n", capture_output=True, text=True, timeout=5
                    )
                    suggestion = ""
                    for out_line in result.stdout.split('\n'):
                        if out_line.startswith('&'):
                            parts = out_line.split(':')
                            if len(parts) > 1:
                                suggestions = parts[1].strip().split(', ')
                                if suggestions:
                                    suggestion = suggestions[0]
                                break
                    if not suggestion:
                        suggestion = "(no suggestion)"
                except:
                    suggestion = "(no suggestion)"
                
                file_issues.append({
                    'lineno': lineno,
                    'line': raw_line,
                    'issue': f"Possible misspelling: '{word}'",
                    'fix': f"Suggested: '{suggestion}'" if suggestion != "(no suggestion)" else "No suggestion"
                })
            
            for gissue in grammar_issues:
                file_issues.append({
                    'lineno': lineno,
                    'line': raw_line,
                    'issue': gissue,
                    'fix': "Review manually"
                })
        
        if file_issues:
            results[filename] = file_issues
    
    return results

def main():
    print("Processing GL6_SCEN.DAT files...\n")
    scen_results = process_directory(SCEN_DIR)
    
    print("Processing GL6_FILE.DAT files...\n")
    file_results = process_directory(FILE_DIR)
    
    all_results = {**scen_results, **file_results}
    
    total_issues = 0
    for filename, issues in sorted(all_results.items()):
        print(f"\n{'='*70}")
        print(f"FILE: {filename}")
        print(f"{'='*70}")
        for issue in issues:
            print(f"\n  LINE {issue['lineno']}: {issue['line']}")
            print(f"  ISSUE: {issue['issue']}")
            print(f"  SUGGESTED FIX: {issue['fix']}")
            total_issues += 1
    
    print(f"\n\nTOTAL ISSUES FOUND: {total_issues}")
    print(f"FILES WITH ISSUES: {len(all_results)}")

if __name__ == '__main__':
    main()
