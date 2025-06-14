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
    files = [f for f in os.listdir() if os.path.isfile(f) and f != current_file]

    renamed = False
    for filename in files:
        if target in filename:
            new_name = filename.replace(target, "")
            os.rename(filename, new_name)
            print(f'Renamed: "{filename}" -> "{new_name}"')
            renamed = True

    if not renamed:
        print("No matching filenames found.")

    input("\nDone. Press Enter to close...")

if __name__ == "__main__":
    main()
