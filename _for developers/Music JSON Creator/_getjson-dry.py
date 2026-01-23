import os
import json
import re
import hashlib
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
all_metadata = []

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

def contains_non_ascii(s):
    return any(ord(c) > 127 for c in s)
    
def safe_ascii_filename(file):
    name, ext = os.path.splitext(file)

    # Attempt transliteration
    ascii_name = unidecode(name)
    ascii_name = re.sub(r'[^a-zA-Z0-9]+', '_', ascii_name).strip('_')

    # Fallback if transliteration fails (CJK, Thai, etc.)
    if not ascii_name:
        digest = hashlib.md5(name.encode("utf-8")).hexdigest()[:10]
        ascii_name = f"track_{digest}"

    return ascii_name.lower() + ext.lower()

def scan_and_process(folder_path):
    folder_name = os.path.normpath(folder_path).split(os.sep)[-2]  # e.g., NFS Unbound

    for root, _, files in os.walk(folder_path):
        for file in files:
            if not file.lower().endswith(".mp3"):
                continue

            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, ADDON_PATH).replace("\\", "/")

            meta = extract_metadata_from_filename(file)
            new_filename = file

            if contains_non_ascii(file):
                new_filename = safe_ascii_filename(file)

                suggestion_key = f"{folder_name} - {file}"
                rename_suggestions.append((suggestion_key, new_filename))

                print(f"[Dry Run] Would back up: {rel_path}")
                print(f"[Dry Run] Would rename to: {new_filename}")

            # Use suggested name in JSON key (even if not renamed physically)
            normalized_path = f"sound/uvracemusic/{folder_name.lower()}/race/{new_filename.lower()}"
            all_metadata.append({
                "path": normalized_path,
                "artist": meta["artist"],
                "title": meta["title"],
                "folder": folder_name
            })

def main():
    if not os.path.exists(SOUND_ROOT):
        print(f"❌ Directory not found: {SOUND_ROOT}")
        return

    print("🔍 Starting dry run...\n")

    for subfolder in os.listdir(SOUND_ROOT):
        subfolder_path = os.path.join(SOUND_ROOT, subfolder)
        race_folder = os.path.join(subfolder_path, "race")
        if os.path.isdir(race_folder):
            scan_and_process(race_folder)

    # Write rename_suggestions.txt
    if rename_suggestions:
        report_path = os.path.join(OUTPUT_DIR, "files_renamed.txt")
        with open(report_path, "w", encoding="utf-8") as f:
            for original, suggestion in rename_suggestions:
                f.write(f"{original} -> {suggestion}\n")
        print(f"\n📝 Wrote {len(rename_suggestions)} suggestions to files_renamed.txt")
    else:
        print("\n✅ No renaming suggestions needed.")

    # Group metadata by folder and write JSONs
    folder_json_map = {}
    for entry in all_metadata:
        folder = entry["folder"]
        path = entry["path"]
        if folder not in folder_json_map:
            folder_json_map[folder] = {}
        folder_json_map[folder][path] = {
            "artist": entry["artist"],
            "title": entry["title"],
            "folder": folder
        }

    for folder, data in folder_json_map.items():
        json_filename = format_name(folder) + ".json"
        json_path = os.path.join(OUTPUT_DIR, json_filename)
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print(f"🗂️ Wrote {json_filename} ({len(data)} entries)")

    input("\n✅ Dry run complete. Press Enter to exit...")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"❌ Error: {e}")
        input("\nPress Enter to exit...")
