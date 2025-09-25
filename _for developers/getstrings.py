import os
import re
from collections import defaultdict
import tkinter as tk
from tkinter import simpledialog

# output file
OUT_FILE = "uvsub.properties"

def natural_sort_key(s):
    """Split string into ints and text for natural sorting."""
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

def main():
    # Ask user which folder to use
    root = tk.Tk()
    root.withdraw()  # hide the main tkinter window
    folder_name = simpledialog.askstring("Folder Selection",
                                         "Enter the folder name under sound/chatter2/ (e.g., default, nfsmw, alternative):")
    if not folder_name:
        print("No folder entered. Exiting.")
        return

    # Root path
    ROOT = os.path.join("sound", "chatter2", folder_name)
    if not os.path.isdir(ROOT):
        print(f"Folder does not exist: {ROOT}")
        return

    # Group entries by unit type and speech folder
    grouped_entries = defaultdict(lambda: defaultdict(list))

    for dirpath, _, filenames in os.walk(ROOT):
        for filename in filenames:
            if filename.lower().endswith((".mp3", ".wav")):
                full_path = os.path.join(dirpath, filename)
                rel_path = os.path.relpath(full_path, ROOT)  # relative to chosen folder
                parts = rel_path.replace("\\", "/").split("/")

                if len(parts) < 2:
                    continue  # skip files not inside a unit folder

                unit_type = parts[0].lower()
                speech_folder = parts[1].lower()
                key_path = ".".join([p.lower() for p in parts])
                key = f"uvsub.{folder_name.lower()}.{key_path.rsplit('.', 1)[0]}"

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

if __name__ == "__main__":
    main()
