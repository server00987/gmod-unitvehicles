import os
import subprocess
import sys

# Get the folder where this script is located
base_folder = os.path.dirname(os.path.abspath(__file__))

# Walk through all subfolders
for root, _, files in os.walk(base_folder):
    for filename in files:
        if filename.lower().endswith(".mp3"):
            file_path = os.path.join(root, filename)
            temp_path = file_path + ".tmp.mp3"

            print(f"Converting: {file_path}")

            # FFmpeg command: convert to 128k mono
            command = [
                "ffmpeg",
                "-y",                 # overwrite without asking
                "-i", file_path,      # input file
                "-b:a", "128k",       # set bitrate
                "-ac", "1",           # mono
                temp_path             # temporary output
            ]

            # Run FFmpeg silently
            subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)

            # Replace original with converted version
            os.replace(temp_path, file_path)

print("✅ Conversion complete! All MP3 files updated.")
