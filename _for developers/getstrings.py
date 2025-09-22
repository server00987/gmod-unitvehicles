import os
import re
from collections import defaultdict

# root folder to scan
ROOT = "sound/chatter2/Default"

# output file
OUT_FILE = "uvsub.properties"

def natural_sort_key(s):
    """Split string into ints and text for natural sorting."""
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

# Group entries by unit type and speech folder
grouped_entries = defaultdict(lambda: defaultdict(list))

for dirpath, _, filenames in os.walk(ROOT):
    for filename in filenames:
        if filename.lower().endswith((".mp3", ".wav")):
            full_path = os.path.join(dirpath, filename)
            rel_path = os.path.relpath(full_path, ROOT)  # relative to Default/
            parts = rel_path.replace("\\", "/").split("/")
            
            if len(parts) < 2:
                continue  # skip files not inside a unit folder
            
            unit_type = parts[0].lower()  # first folder under Default
            speech_folder = parts[1].lower()  # folder directly under unit type
            key_path = ".".join([p.lower() for p in parts])
            key = f"uvsub.default.{key_path.rsplit('.',1)[0]}"  # remove extension
            
            grouped_entries[unit_type][speech_folder].append(key)

# Write to file
with open(OUT_FILE, "w", encoding="utf-8") as f:
    for unit in sorted(grouped_entries.keys(), key=natural_sort_key):
        f.write(f"#------ {unit.capitalize()}\n")
        for speech_folder in sorted(grouped_entries[unit].keys(), key=natural_sort_key):
            for key in sorted(grouped_entries[unit][speech_folder], key=natural_sort_key):
                f.write(f"{key}=\n")
            f.write("\n")  # blank line after each speech folder
        f.write("\n")  # blank line between unit types

print(f"Written grouped entries with spacing to {OUT_FILE}")
