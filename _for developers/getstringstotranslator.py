#!/usr/bin/env python3
"""
extract_missing_keys.py

Scans every language folder under resource/localization/, finds commented-out
localization keys (lines starting with '#' where the remainder contains '='),
and writes a Discord-ready text file with per-language blocks and ```properties
code blocks per .properties file that had commented keys.

Usage:
    # Process all languages (default):
    python3 extract_missing_keys.py

    # Process only selected languages (folder names), e.g.:
    python3 extract_missing_keys.py de cs ru

    # or explicitly request all:
    python3 extract_missing_keys.py all

Options:
    --root / -r      : Localization root (default: resource/localization)
    --out  / -o      : Output filename (default: missing_localization_keys.txt)
    --skip-empty     : Do not write a start/end marker if no languages found
"""
from __future__ import annotations

import argparse
import os
from typing import Dict, List, Tuple

ENCODING = "utf-8"
DEFAULT_ROOT = "resource/localization"
DEFAULT_OUT = "missing_localization_keys.txt"

# Discord shortcode flags map (folder name -> discord shortcode)
# Extend as needed.
FLAG_MAP: Dict[str, str] = {
    "es": ":flag_es:",
    "es-es": ":flag_es:",
    "de": ":flag_de:",
    "fr": ":flag_fr:",
    "ru": ":flag_ru:",
    "cs": ":flag_cz:",  # Czech
    "pl": ":flag_pl:",
    "it": ":flag_it:",
    "pt": ":flag_pt:",
    "pt-br": ":flag_br:",
    "ja": ":flag_jp:",
    "zh": ":flag_cn:",
    "zh-cn": ":flag_cn:",
    "zh-tw": ":flag_tw:",
    "ko": ":flag_kr:",
    "nl": ":flag_nl:",
    "sv": ":flag_se:",
    "no": ":flag_no:",
    "da": ":flag_dk:",
    "fi": ":flag_fi:",
    "tr": ":flag_tr:",
    "hu": ":flag_hu:",
    "ro": ":flag_ro:",
    "bg": ":flag_bg:",
    "sr": ":flag_rs:",
    "sk": ":flag_sk:",
    "hr": ":flag_hr:",
    "uk": ":flag_ua:",
    # add more if you like...
}

# Human readable labels for some language folders (folder -> "Country / Language")
LABEL_MAP: Dict[str, str] = {
    "es-es": "Spain / Spanish",
    "es": "Spain / Spanish",
    "de": "Germany / German",
    "fr": "France / French",
    "ru": "Russia / Russian",
    "cs": "Czech Republic / Czech",
    "pl": "Poland / Polish",
    "it": "Italy / Italian",
    "pt-br": "Brazil / Portuguese (Brazil)",
    "pt": "Portugal / Portuguese",
    "ja": "Japan / Japanese",
    "zh-cn": "China / Chinese (Simplified)",
    "zh-tw": "Taiwan / Chinese (Traditional)",
    "ko": "Korea / Korean",
    "nl": "Netherlands / Dutch",
    "sv": "Sweden / Swedish",
    "no": "Norway / Norwegian",
    "da": "Denmark / Danish",
    "fi": "Finland / Finnish",
    "tr": "Turkey / Turkish",
    # add more if you want
}


def read_lines(path: str) -> List[str]:
    with open(path, "r", encoding=ENCODING, errors="replace") as f:
        return [line.rstrip("\n\r") for line in f.readlines()]


def is_commented_key_line(raw_line: str) -> bool:
    """
    A line is a commented-out key if:
      - after left-stripping whitespace it starts with '#'
      - after removing the leading '#' and following whitespace, it contains '='
    """
    if raw_line is None:
        return False
    s = raw_line.lstrip()
    if not s.startswith("#"):
        return False
    after = s.lstrip("#").lstrip()
    return "=" in after and len(after.split("=", 1)[0].strip()) > 0


def extract_commented_key(raw_line: str) -> str:
    """
    Return the textual content after the leading '#' and whitespace.
    Example:
      raw_line = "  #  key = value"
      returns "key = value"
    """
    s = raw_line.lstrip()
    after = s.lstrip("#").lstrip()
    return after.rstrip("\n\r")


def gather_languages(root: str) -> List[str]:
    try:
        names = [n for n in os.listdir(root) if os.path.isdir(os.path.join(root, n))]
    except FileNotFoundError:
        return []
    return sorted(names, key=lambda s: s.lower())


def gather_properties_files(lang_dir: str) -> List[str]:
    try:
        allfiles = os.listdir(lang_dir)
    except FileNotFoundError:
        return []
    props = [f for f in allfiles if f.lower().endswith(".properties") and os.path.isfile(os.path.join(lang_dir, f))]
    return sorted(props, key=lambda s: s.lower())


def process_language(root: str, lang: str) -> List[Tuple[str, List[str]]]:
    """
    Returns a list of tuples (filename, [extracted_lines...]) for the language.
    Only files with at least one extracted commented key are returned.
    """
    lang_dir = os.path.join(root, lang)
    files = gather_properties_files(lang_dir)
    results: List[Tuple[str, List[str]]] = []
    for fname in files:
        path = os.path.join(lang_dir, fname)
        try:
            lines = read_lines(path)
        except Exception:
            # skip files we can't read
            continue
        extracted: List[str] = []
        for ln in lines:
            if is_commented_key_line(ln):
                extracted.append(extract_commented_key(ln))
        if extracted:
            results.append((fname, extracted))
    return results


def choose_languages_interactively(all_langs: List[str]) -> List[str]:
    if not all_langs:
        return []
    print("Found language folders:")
    print(", ".join(all_langs))
    ans = input("Process all languages? (Y/n): ").strip().lower()
    if ans in ("", "y", "yes"):
        return all_langs
    ans2 = input("Enter comma-separated language folder names to process (e.g. 'de, cs, es-es'): ").strip()
    if not ans2:
        return []
    picks = [p.strip() for p in ans2.split(",") if p.strip()]
    # validate and warn about unknowns
    unknown = [p for p in picks if p not in all_langs]
    if unknown:
        print("Warning: the following languages were not found and will be skipped:", ", ".join(unknown))
    return [p for p in picks if p in all_langs]


def main():
    parser = argparse.ArgumentParser(description="Extract commented-out localization keys for translators.")
    parser.add_argument("langs", nargs="*", help="Optional: language folders to process (e.g. de cs ru). Use 'all' to force all.")
    parser.add_argument("-r", "--root", default=DEFAULT_ROOT, help=f"Localization root folder (default: {DEFAULT_ROOT})")
    parser.add_argument("-o", "--out", default=DEFAULT_OUT, help=f"Output filename (default: {DEFAULT_OUT})")
    parser.add_argument("--skip-empty", action="store_true", help="If there are no matches, do not write start/end markers")
    args = parser.parse_args()

    root = args.root
    outfile = args.out

    all_langs = gather_languages(root)
    if not all_langs:
        print(f"No language folders found under: {root}")
        return

    selected_langs: List[str]
    if args.langs:
        # user provided languages on CLI
        if len(args.langs) == 1 and args.langs[0].lower() == "all":
            selected_langs = all_langs
        else:
            # filter only those that exist; warn about invalid names
            picks = [p for p in args.langs]
            unknown = [p for p in picks if p not in all_langs]
            if unknown:
                print("Warning: the following requested languages were not found and will be skipped:",
                      ", ".join(unknown))
            selected_langs = [p for p in picks if p in all_langs]
            if not selected_langs:
                print("No valid languages requested. Exiting.")
                return
    else:
        # interactive prompt
        selected_langs = choose_languages_interactively(all_langs)
        if not selected_langs:
            print("No languages selected. Exiting.")
            return

    selected_langs = sorted(selected_langs, key=lambda s: s.lower())

    # Collect all extracted data
    output_sections: List[str] = []
    total_languages_with_matches = 0
    total_files_with_matches = 0
    for lang in selected_langs:
        lang_results = process_language(root, lang)
        if not lang_results:
            # skip languages with no commented keys
            continue

        total_languages_with_matches += 1
        total_files_with_matches += len(lang_results)

        flag = FLAG_MAP.get(lang.lower(), ":triangular_flag_on_post:")
        label = LABEL_MAP.get(lang.lower(), f"{lang} / {lang}")
        # Header line, match your example: ":flag_es: <-- Spain / Spanish"
        output_sections.append(f"{flag} <-- {label}")

        # For each file that had commented keys, create a separate ```properties block
        for fname, keys in lang_results:
            output_sections.append("```properties")
            # write each extracted line as-is. Keep original order; separate items by newline.
            for k in keys:
                output_sections.append(k)
            output_sections.append("```")

        # blank line between languages
        output_sections.append("")

    # Write the output file
    with open(outfile, "w", encoding=ENCODING, newline="\n") as out:
        if not output_sections:
            # Nothing found
            if args.skip_empty:
                # write nothing
                print("No commented-out keys were found in the selected languages. No output written.")
                return
            else:
                print(f"No commented-out keys found. Wrote empty markers to {outfile}.")
                return

        # start marker
        out.write("\n")
        # join and write sections
        for line in output_sections:
            out.write(f"{line}\n")

    print(f"Wrote {outfile}.")
    print(f"Languages processed: {len(selected_langs)} (with matches: {total_languages_with_matches}); files with matches: {total_files_with_matches}.")


if __name__ == "__main__":
    main()
