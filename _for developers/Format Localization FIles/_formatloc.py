import os

BASE_LANG = "en"
NOSTRING_PREFIX = "# NOSTRING; "
NUM_PRESERVE_LINES = 3


def parse_properties(filepath):
    """Parses a .properties file into a list of tuples (is_comment, key, value, raw_line)."""
    entries = []
    if not os.path.exists(filepath):
        return entries

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            raw = line.rstrip("\n")
            if raw.strip().startswith("#") or "=" not in raw:
                entries.append((True, None, None, raw))
            else:
                key, value = raw.split("=", 1)
                entries.append((False, key.strip(), value.strip(), raw))
    return entries


def build_translation_map(entries):
    return {key: value for is_comment, key, value, _ in entries if not is_comment}


def restructure_file(ref_entries, old_lines, output_path):
    old_entries = parse_properties_from_lines(old_lines)
    old_map = build_translation_map(old_entries)

    # Strip header comments from English structure — skip until first key
    ref_entries_trimmed = []
    seen_key = False
    for entry in ref_entries:
        if not entry[0]:  # not a comment
            seen_key = True
        if seen_key:
            ref_entries_trimmed.append(entry)

    with open(output_path, "w", encoding="utf-8") as f:
        # Preserve the first NUM_PRESERVE_LINES lines from the target language
        for i in range(min(NUM_PRESERVE_LINES, len(old_lines))):
            f.write(old_lines[i].rstrip("\n") + "\n")

        if NUM_PRESERVE_LINES < len(old_lines):
            f.write("\n")

        # Apply structured content from English file, starting after headers
        for is_comment, key, value, raw_line in ref_entries_trimmed:
            if is_comment:
                f.write(raw_line + "\n")
            else:
                translated = old_map.get(key)
                if translated is None:
                    f.write(f"{NOSTRING_PREFIX}{key}={value}\n")
                elif translated.strip() == value.strip():
                    f.write(f"{NOSTRING_PREFIX}{key}={translated}\n")
                else:
                    f.write(f"{key}={translated}\n")



def parse_properties_from_lines(lines):
    entries = []
    for line in lines:
        raw = line.rstrip("\n")
        if raw.strip().startswith("#") or "=" not in raw:
            entries.append((True, None, None, raw))
        else:
            key, value = raw.split("=", 1)
            entries.append((False, key.strip(), value.strip(), raw))
    return entries


def main():
    base_dir = os.getcwd()
    en_path = os.path.join(base_dir, BASE_LANG)

    reference_files = [
        fname for fname in os.listdir(en_path)
        if fname.endswith(".properties") and os.path.isfile(os.path.join(en_path, fname))
    ]

    for lang_folder in os.listdir(base_dir):
        lang_path = os.path.join(base_dir, lang_folder)
        if not os.path.isdir(lang_path) or lang_folder == BASE_LANG:
            continue

        for filename in reference_files:
            ref_file = os.path.join(en_path, filename)
            target_file = os.path.join(lang_path, filename)

            if not os.path.exists(target_file):
                continue

            print(f"Restructuring: {lang_folder}/{filename}")
            ref_entries = parse_properties(ref_file)

            # Read raw lines for metadata preservation
            with open(target_file, "r", encoding="utf-8") as f:
                old_lines = f.readlines()

            restructure_file(ref_entries, old_lines, target_file)

    print("\n✅ All applicable localization files restructured.")


if __name__ == "__main__":
    main()
