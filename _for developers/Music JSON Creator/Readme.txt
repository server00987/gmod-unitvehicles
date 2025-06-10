This tool automatically creates .json files for use in Unit Vehicle races. It allows workshop-uploaded content to have proper displays, such as special characters, upper-cased characters and more.

---> Requirements <---
1) Python 3.11 or newer
2) unidecode
	> Installed using pip
	> Open command prompt (cmd) and type in "pip install unidecode" and hit enter
3) A proper folder structure for audio files, with audio files in the correct path
	> "sound/uvracemusic/<Folder Name>/race/" - place your songs here
	> To properly create .json files, ensure the songs are titled "Artist - Title"

---> How do I use this? <---
1) Move the .py and .bat files into the main addon folder (where you find "sound", "lua", "model", "materials", etc.)
2) Run the .bat file!
3) Move the created .json files (they'll be where the script was run) into a "data_static" folder.

The .json files should be in "<Addon>/data_static". They'll be read automatically once in-game.

You can thereafter modify the .json file to your hearts content, such as adding 

---> Important Notes <---
1) The "_getjson" script does two things:
	1. Goes through ALL folders in "sound/uvracemusic" and creates a .json file for each folder within that.
	2. *If the files include illegal characters (such as "é", "ë", "ü" or anything in Cyrillic) that won't load properly when using a .json file, it'll automatically rename those files and provide a file detailing exactly which files were changed.
* If you don't want files to be renamed, run the "-dry" variant.

2) If your file has punctuation before its file extention (such as "Mr. Fuzz - Deez Nutz.mp3"), you'll need to change those manually. Below is a full list of special characters that will be recognized by Unit Vehicles:

	,,		> 	.
	;;		> 	?
	-;-	> 	/
	==	> 	:
	-!-	> 	"
	
So for example, if you want your title to be "Mr. Fuzzy / Mrs. Fuzzy - Moving? That's for Whimps/Dummies!", you'll have to rename it to "Mr,, Fuzzy -;- Mrs,, Fuzzy - Moving;; That's for Whimps-;-Dummies!".
It is definitely not fancy, but it gets around Windows file naming restrictions.