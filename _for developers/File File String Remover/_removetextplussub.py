import os
import sys

def main():
    print("Enter the string to remove from all filenames (include quotes, e.g. \" (1080P)\"):")
    input_str = input().strip()

    # Remove surrounding quotes if present
    if input_str.startswith('"') and input_str.endswith('"'):
        target = input_str[1:-1]
    else:
        print("Please enclose the input in double quotes, like this: \"example\"")
        input("Press Enter to exit...")
        return

    current_file = os.path.basename(__file__)
    renamed = False

    # Walk recursively through all subdirectories (including current one)
    for root, dirs, files in os.walk(os.getcwd()):
        for filename in files:
            if filename == current_file:
                continue  # Skip this script itself

            if target in filename:
                old_path = os.path.join(root, filename)
                new_name = filename.replace(target, "")
                new_path = os.path.join(root, new_name)

                # Avoid renaming to an existing file accidentally
                if os.path.exists(new_path):
                    print(f'Skipped (already exists): "{new_path}"')
                    continue

                os.rename(old_path, new_path)
                print(f'Renamed: "{old_path}" -> "{new_path}"')
                renamed = True

    if not renamed:
        print("No matching filenames found.")

    input("\nDone. Press Enter to close...")

if __name__ == "__main__":
    main()
