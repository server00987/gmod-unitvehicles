import os
import re
from collections import defaultdict
import tkinter as tk
from tkinter import simpledialog

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
OUT_FILE = os.path.join(SCRIPT_DIR, "unitvehicles_subtitles.properties")
DEFAULT_EXISTING_FILE = os.path.join(SCRIPT_DIR, "resource", "localization", "en", "unitvehicles_subtitles.properties")

def natural_sort_key(s):
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

def read_existing_strings(file_path):
    original_lines = []
    key_to_line = {}
    if not file_path or not os.path.isfile(file_path):
        return original_lines, key_to_line

    with open(file_path, "r", encoding="utf-8") as f:
        for raw in f:
            line = raw.rstrip("\n")
            original_lines.append(line)
            striped = line.lstrip()
            is_commented = striped.startswith("#")
            candidate = striped[1:].lstrip() if is_commented else striped
            if "=" in candidate:
                key, _ = candidate.split("=", 1)
                key = key.strip()
                if key:
                    key_to_line[key] = line
    return original_lines, key_to_line

def parse_key_to_group(key, expected_folder_name):
    parts = key.split(".")
    if len(parts) >= 4 and parts[0].lower() == "uvsub":
        folder_component = parts[1].lower()
        if folder_component == expected_folder_name.lower():
            unit_type = parts[2].lower()
            speech_folder = parts[3].lower()
            return unit_type, speech_folder
    return None, None

def ensure_replaceme(line):
    stripped = line.lstrip()
    prefix = ""
    if stripped.startswith("#"):
        prefix = line[:line.index("#") + 1]
        candidate = stripped[1:].lstrip()
    else:
        candidate = stripped

    if "=" in candidate:
        left, right = candidate.split("=", 1)
        if right.strip() == "":
            new_candidate = f"# {left.strip()}= "
            return prefix + " " + new_candidate if prefix else new_candidate
    return line

def main():
    root = tk.Tk()
    root.withdraw()

    folder_name = simpledialog.askstring(
        "Folder Selection",
        "Enter the folder name under sound/chatter2/ (e.g., default, nfsmw, alternative):",
        initialvalue="default"
    )
    if not folder_name:
        print("No folder entered. Exiting.")
        return
    
    ROOT = os.path.join(SCRIPT_DIR, "sound", "chatter2", folder_name)
    if not os.path.isdir(ROOT):
        print(f"Folder does not exist: {ROOT}")
        return

    existing_file = simpledialog.askstring(
        "Existing String File",
        "Enter the path to the existing string file for comparison:",
        initialvalue=DEFAULT_EXISTING_FILE
    )
    if existing_file and not os.path.isfile(existing_file):
        print(f"Warning: Existing string file not found at: {existing_file}")
        existing_file = None

    original_lines, existing_key_lines = read_existing_strings(existing_file)

    grouped_entries = defaultdict(lambda: defaultdict(list))
    audio_keys_set = set()

    for dirpath, _, filenames in os.walk(ROOT):
        for filename in filenames:
            if filename.lower().endswith((".mp3", ".wav")):
                full_path = os.path.join(dirpath, filename)
                rel_path = os.path.relpath(full_path, ROOT).replace("\\", "/")
                parts = rel_path.split("/")
                if len(parts) < 2:
                    continue
                unit_type = parts[0].lower()
                speech_folder = parts[1].lower()
                key_path = ".".join([p.lower() for p in parts])
                key = f"uvsub.{folder_name.lower()}.{key_path.rsplit('.', 1)[0]}"
                grouped_entries[unit_type][speech_folder].append(key)
                audio_keys_set.add(key)

    all_keys_to_write = defaultdict(list)
    notfound_entries = defaultdict(lambda: defaultdict(list))

    # Process existing keys
    for key, original_line in existing_key_lines.items():
        stripped = original_line.lstrip()
        is_commented = stripped.startswith("#")
        unit_type, speech_folder = parse_key_to_group(key, folder_name)

        if key in audio_keys_set:
            line_to_use = ensure_replaceme(original_line)
            all_keys_to_write[key].append(line_to_use)
        else:
            if unit_type and speech_folder:
                notfound_entries[unit_type][speech_folder].append(key)

    # Add new keys (audio exists but not in existing file)
    for unit in grouped_entries:
        for speech_folder in grouped_entries[unit]:
            for key in grouped_entries[unit][speech_folder]:
                if key not in all_keys_to_write and key not in notfound_entries[unit][speech_folder]:
                    all_keys_to_write[key].append(f"{key}= ")

    # Add missing keys to groups
    if existing_key_lines:
        for key in existing_key_lines.keys():
            if key not in audio_keys_set:
                unit_type, speech_folder = parse_key_to_group(key, folder_name)
                if unit_type and speech_folder:
                    if key not in grouped_entries[unit_type][speech_folder]:
                        grouped_entries[unit_type][speech_folder].append(key)

    # Write legit files first
    with open(OUT_FILE, "w", encoding="utf-8") as f:
        for unit in sorted(grouped_entries.keys(), key=natural_sort_key):
            f.write(f"#------ {unit.capitalize()}\n")
            for speech_folder in sorted(grouped_entries[unit].keys(), key=natural_sort_key):
                keys_sorted = sorted(grouped_entries[unit][speech_folder], key=natural_sort_key)
                prev_subcategory = None
                for key in keys_sorted:
                    insert_blank_before = False
                    # Detect both vehicledescription and addressgroup_map
                    if "vehicledescription" in key or "addressgroup_map" in key:
                        parts = key.split(".")
                        try:
                            if "vehicledescription" in key:
                                idx = parts.index("vehicledescription")
                            else:
                                idx = parts.index("addressgroup_map")
                            subcat = parts[idx + 1] if len(parts) > idx + 1 else None
                        except ValueError:
                            subcat = None

                        # Insert blank line when the subcategory changes
                        if subcat and prev_subcategory is not None and subcat != prev_subcategory:
                            insert_blank_before = True
                        prev_subcategory = subcat or prev_subcategory

                    if insert_blank_before:
                        f.write("\n")

                    lines_for_key = all_keys_to_write.get(key, [f"{key}= "])
                    for out_line in lines_for_key:
                        f.write(out_line + "\n")
                f.write("\n")
            f.write("\n")

        # Write all NOTFOUND entries at the end
        f.write("# ----------- [ FILES NOT FOUND ] -----------\n")
        for unit in sorted(notfound_entries.keys(), key=natural_sort_key):
            f.write(f"#------ {unit.capitalize()}\n")
            for speech_folder in sorted(notfound_entries[unit].keys(), key=natural_sort_key):
                keys_sorted = sorted(notfound_entries[unit][speech_folder], key=natural_sort_key)
                for key in keys_sorted:
                    original_line = existing_key_lines.get(key, f"{key}= ")
                    stripped = original_line.lstrip()
                    if stripped.startswith("#"):
                        stripped = stripped[1:].lstrip()
                    f.write(f"# {stripped}\n")
            f.write("\n")

    print(f"Written grouped entries with REPLACEME placeholders and NOTFOUND markings to {OUT_FILE}")

if __name__ == "__main__":
    main()
