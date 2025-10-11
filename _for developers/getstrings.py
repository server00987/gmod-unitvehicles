import os
import re
from collections import defaultdict
import tkinter as tk
from tkinter import simpledialog

# output file
OUT_FILE = "unitvehicles_subtitles.properties"
# default existing string file path for comparison (use components for portability)
DEFAULT_EXISTING_FILE = os.path.join("resource", "localization", "en", "unitvehicles_subtitles.properties")

def natural_sort_key(s):
    """Split string into ints and text for natural sorting."""
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

def read_existing_strings(file_path):
    """
    Read an existing string file into:
      - original_lines: list of raw lines (kept for potential future use)
      - key_to_line: mapping key -> original line (preserves comment state if the key line is commented)
    It will capture keys even if they're commented with '#' at the start (e.g. '# uvsub.default...=...')
    """
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
                key, val = candidate.split("=", 1)
                key = key.strip()
                if key:
                    key_to_line[key] = line
    return original_lines, key_to_line

def parse_key_to_group(key, expected_folder_name):
    """
    Given a key like: uvsub.default.misc.static.static-01
    return (unit_type, speech_folder) -> ('misc', 'static')
    Only returns a result if key appears to match the uvsub.<folder>.<unit>.<speech>... structure.
    """
    parts = key.split(".")
    if len(parts) >= 4 and parts[0].lower() == "uvsub":
        folder_component = parts[1].lower()
        if folder_component == expected_folder_name.lower():
            unit_type = parts[2].lower()
            speech_folder = parts[3].lower()
            return unit_type, speech_folder
    return None, None

def ensure_replaceme(line):
    """
    Add 'REPLACEME' if line contains '=' but no value after it (ignoring whitespace).
    Works for both commented and uncommented lines.
    """
    stripped = line.lstrip()
    prefix = ""
    if stripped.startswith("#"):
        prefix = line[:line.index("#") + 1]  # capture leading spacing + '#'
        candidate = stripped[1:].lstrip()
    else:
        candidate = stripped

    if "=" in candidate:
        left, right = candidate.split("=", 1)
        if right.strip() == "":
            # no value after '=' -> add REPLACEME
            new_candidate = f"{left.strip()}=REPLACEME"
            return prefix + " " + new_candidate if prefix else new_candidate
    return line

def main():
    # Tkinter prompts
    root = tk.Tk()
    root.withdraw()  # hide main window

    # Folder under sound/chatter2
    folder_name = simpledialog.askstring(
        "Folder Selection",
        "Enter the folder name under sound/chatter2/ (e.g., default, nfsmw, alternative):",
        initialvalue="default"
    )
    if not folder_name:
        print("No folder entered. Exiting.")
        return
    ROOT = os.path.join("sound", "chatter2", folder_name)
    if not os.path.isdir(ROOT):
        print(f"Folder does not exist: {ROOT}")
        return

    # Existing string file selection (can be in subfolders); default path provided
    existing_file = simpledialog.askstring(
        "Existing String File",
        "Enter the path to the existing string file for comparison:",
        initialvalue=DEFAULT_EXISTING_FILE
    )
    if existing_file and not os.path.isfile(existing_file):
        print(f"Warning: Existing string file not found at: {existing_file}")
        existing_file = None

    original_lines, existing_key_lines = read_existing_strings(existing_file)

    # Group audio entries by unit type and speech folder
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

    all_keys_to_write = {}

    # 1) Process existing keys
    for key, original_line in existing_key_lines.items():
        if key in audio_keys_set:
            line_to_use = ensure_replaceme(original_line)
            all_keys_to_write[key] = line_to_use
        else:
            stripped = original_line.lstrip()
            if stripped.startswith("#"):
                all_keys_to_write[key] = ensure_replaceme(original_line)
            else:
                all_keys_to_write[key] = ensure_replaceme("# " + original_line)

    # 2) Add new keys (audio exists but not in existing file)
    for unit in grouped_entries:
        for speech_folder in grouped_entries[unit]:
            for key in grouped_entries[unit][speech_folder]:
                if key not in all_keys_to_write:
                    all_keys_to_write[key] = f"{key}=REPLACEME"

    # 3) Add missing-audio keys (commented) into groups so they appear
    if existing_key_lines:
        for key in existing_key_lines.keys():
            if key not in audio_keys_set:
                unit_type, speech_folder = parse_key_to_group(key, folder_name)
                if unit_type and speech_folder:
                    if key not in grouped_entries[unit_type][speech_folder]:
                        grouped_entries[unit_type][speech_folder].append(key)

    # 4) Write the output file
    with open(OUT_FILE, "w", encoding="utf-8") as f:
        for unit in sorted(grouped_entries.keys(), key=natural_sort_key):
            f.write(f"#------ {unit.capitalize()}\n")
            for speech_folder in sorted(grouped_entries[unit].keys(), key=natural_sort_key):
                keys_sorted = sorted(grouped_entries[unit][speech_folder], key=natural_sort_key)
                for key in keys_sorted:
                    f.write(all_keys_to_write.get(key, f"{key}=REPLACEME") + "\n")
                f.write("\n")
            f.write("\n")

    print(f"Written grouped entries with REPLACEME placeholders to {OUT_FILE}")

if __name__ == "__main__":
    main()
