import os
import json
import re
import shutil
from unidecode import unidecode

# Paths
ADDON_PATH = os.getcwd()
SOUND_ROOT = os.path.join(ADDON_PATH, "sound", "uvracemusic")
BACKUP_ROOT = os.path.join(ADDON_PATH, "sound_backup", "uvracemusic")
OUTPUT_DIR = ADDON_PATH

# Placeholders
placeholder_map = {
    ",,": ".", ";;": "?", "-;-": "/", "==": ":", "-!-": "\""
}

rename_suggestions = []
all_metadata = {}

def unsanitize(text):
    for placeholder, real_char in placeholder_map.items():
        text = text.replace(placeholder, real_char)
    return text

def format_name(name):
    return "music_" + re.sub(r'\W+', '_', name.strip().lower())

def extract_metadata_from_filename(filename):
    name_part = os.path.splitext(os.path.basename(filename))[0]
    name_part = unsanitize(name_part)
    if " - " in name_part:
        artist, title = name_part.split(" - ", 1)
    else:
        artist = "Unknown"
        title = name_part
    return {"title": title.strip(), "artist": artist.strip()}

def contains_uppercase_non_ascii(s):
    return any(ord(c) > 127 and c.isupper() for c in s)

def backup_file(original_path, relative_path):
    backup_path = os.path.join(BACKUP_ROOT, relative_path)
    os.makedirs(os.path.dirname(backup_path), exist_ok=True)
    shutil.copy2(original_path, backup_path)

def rename_file(original_path, new_path):
    os.makedirs(os.path.dirname(new_path), exist_ok=True)
    shutil.move(original_path, new_path)

def scan_and_process(folder_path, rel_folder_path):
    folder_name = os.path.normpath(folder_path).split(os.sep)[-2]  # Get "NFS Unbound"
    for root, _, files in os.walk(folder_path):
        for file in files:
            if not file.lower().endswith(".mp3"):
                continue

            full_path = os.path.join(root, file)
            sub_path = os.path.relpath(full_path, ADDON_PATH).replace("\\", "/")  # e.g., sound/uvracemusic/...
            rel_path = os.path.relpath(full_path, folder_path).replace("\\", "/")  # just filename path

            meta = extract_metadata_from_filename(file)
            filename = os.path.basename(file)

            folder_relative = os.path.relpath(root, ADDON_PATH).replace("\\", "/")
            new_filename = filename  # default: no change

            # Rename logic
            if contains_uppercase_non_ascii(filename):
                new_filename = unidecode(filename)
                new_filename = re.sub(r'\s+', ' ', new_filename).strip()

                suggestion_key = f"{folder_name} - {filename}"
                rename_suggestions.append((suggestion_key, new_filename))

                # Backup original
                backup_rel_path = os.path.join("uvracemusic", folder_name, "race", filename)
                backup_file(full_path, backup_rel_path)

                # Rename in place
                new_path = os.path.join(root, new_filename)
                rename_file(full_path, new_path)
                full_path = new_path  # update reference

            # Construct normalized path (for JSON key)
            normalized_path = f"sound/uvracemusic/{folder_name.lower()}/race/{new_filename.lower()}"

            all_metadata[normalized_path] = {
                "artist": meta["artist"],
                "title": meta["title"],
                "folder": folder_name
            }

def main():
    if not os.path.exists(SOUND_ROOT):
        print(f"❌ Directory not found: {SOUND_ROOT}")
        return

    # Step 1: Scan folders and rename
    for subfolder in os.listdir(SOUND_ROOT):
        subfolder_path = os.path.join(SOUND_ROOT, subfolder)
        race_folder = os.path.join(subfolder_path, "race")
        if os.path.isdir(race_folder):
            rel_folder = os.path.relpath(race_folder, ADDON_PATH).replace("\\", "/")
            scan_and_process(race_folder, rel_folder)

    # Step 2: Rename suggestions report
    if rename_suggestions:
        report_path = os.path.join(OUTPUT_DIR, "files_renamed.txt")
        with open(report_path, "w", encoding="utf-8") as f:
            for original, suggestion in rename_suggestions:
                f.write(f"{original} -> {suggestion}\n")
        print(f"✓ Wrote rename suggestions ({len(rename_suggestions)} entries) to files_renamed.txt")
    else:
        print("✓ No rename suggestions needed.")

    # Step 3: Group metadata by folder and write JSON
    folder_json_map = {}
    for path, meta in all_metadata.items():
        parts = path.split("/")
        if len(parts) < 4:
            continue
        folder = parts[2]  # e.g., "nfs unbound"
        folder_json_map.setdefault(folder, {})[path] = meta

    for folder, data in folder_json_map.items():
        json_filename = format_name(folder) + ".json"
        json_path = os.path.join(OUTPUT_DIR, json_filename)
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print(f"✓ Wrote {json_filename} ({len(data)} entries)")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"❌ Error: {e}")
    input("\n✅ Done. Press Enter to exit...")
