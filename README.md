[What is this](https://github.com/prettynb/pnbp/blob/master/commands/pprint.py), and what does it do?

Modern terminal emulators can handle clickable links (e.g. [GNOME](https://unix.stackexchange.com/questions/112267/create-clickable-links-in-terminal#437585)). 

[Rich](https://github.com/willmcgugan/rich) is a Python library that can handle rendering [markup links](https://rich.readthedocs.io/en/latest/markup.html?highlight=link#links) to terminals that support them. 

[iTerm2](https://iterm2.com/) is a terminal emulator for macos that can handle clicks to links, and has an [Applescript API](https://iterm2.com/documentation-scripting.html) -> ... 
  
iTerm (and the like) will open clicked links to the default Application that handles a protocol :
- (e.g. ```https``` -> https://github.com/,  URL, to default browser)
- (e.g. ```file``` -> ```file:///Users/alice/hello.txt```, [file URI scheme](https://en.wikipedia.org/wiki/File_URI_scheme), to default app) 
- ... 

**pnano** ("protocol-ed nano") is ultimately a non-nano name to call some monkey patch that handles for the (unused) URI protocol namespace of ```nano://``` to open files directly to the nano text editor. (e.g. as written for macos, when clicking ```nano:///Users/alice/hello.py```, ```hello.py``` will be opened in ```nano``` to the second (to the right) pane in a split-pane iTerm2 window (closed/->reopened).

Why? 
- (a) [vim]() has a [wiki](https://vimwiki.github.io/) system.
- (b) [emacs]() has a [wiki](https://github.com/caiorss/org-wiki) system.
- (c) [nano](https://www.nano-editor.org/) *doesn't* have a wiki system.

--- 

a wiki-linked .md file (e.g. 

```sh
% cat notebook/INDEX.md

mocs:
- [[SCHOOL]]
- [[PROJECTS]]
- [[WORK]]
- [[LIFE]]
```
), 

With [pnbp](https://github.com/prettynb/pnbp), 

```sh
% nb-pprint -n index
# ...
```

on ```nb-pprint -n mynote```, before rich [Markdown](https://rich.readthedocs.io/en/stable/markdown.html) handling, every internal **\[\[link\]\]** is converted to **\[link\]\(pnbp:///path/to/notebook/mynote.md\)** and a frame is added to the pretty print-out w/ : 

MENU : 
--->: [refresh]() - re-print the current note (e.g. on update)
nano: [mynote]() - split-pane and open the currently printed (`-n`) note to ```nano```
nano: [new note]() - split-pane to a new (incremented, default name) .md note on path

if the markdown wasn't being marked-up and rendered, it would look like this e.g. :

```sh
% nb-pprint -n "INDEX.md"

MENU :
--->: [refresh](pnbp:///Users/alice/notebook/INDEX.md)
nano: [INDEX](nano:///Users/alice/notebook/INDEX.md)
nano: [new note](nano:///Users/alice/notebook/new2.md)

--- 

mocs:
- [SCHOOL](pnbp:///Users/alice/notebook/INDEX.md)
- [PROJECTS](pnbp:///Users/alice/notebook/PROJECTS.md)
- [WORK](pnbp:///Users/alice/notebook/WORK.md)
- [LIFE](pnbp:///Users/alice/notebook/LIFE.md)


--- 

MENU :
--->: [refresh](pnbp:///Users/alice/notebook/INDEX.md)
nano: [INDEX](nano:///Users/alice/notebook/INDEX.md)
nano: [new note](nano:///Users/alice/notebook/new2.md)

% # ...
```

Every internal link (e.g. ```[[LINK]]```) within the content of the current pretty printed note (e.g. as [LINK]()) being redirected to ```pnbp://```, on click, will call ```ppnbp.app```, -> iTerm's current window (the one you clicked in) is instructed to ```clear ``` (fully) and then ```nb-pprint -n "LINK.md"```. This "refreshes" the window to the exclusive content of the newly clicked note (so that any scrolling instance only holds the current note context).

--- 

All in, you can achieve something to the effect of using a split-pane markdown editor in the terminal; viewing (and moving through the wiki-link .md system) with the rendered content on the left: 

![left](https://github.com/prettynb/pnano/blob/main/left.png)

while making edits in nano on the right:

![right](https://github.com/prettynb/pnano/blob/main/right.png)


--- 

**macos set-up instructions** :
- In Finder, navigate to and open /Applications/Utilities/**Script Editor.app**
	- click **New Document** in the pop-up window
	- paste the contents of [pnano.app](https://github.com/prettynb/pnano/blob/main/pnano/pnano.app)
	- -> save (command+s)
		- File Format: **Application**
		- Save As: pnano.app
		- click **Save**
- In Finder, navigate to **/Applications/pnano.app**, secondary click (control+click, 2 finger trackpad, or right-click) -> click **Show Package Contents**
	- navigate to and open **Contents/Info.plist** ( \*\* )
	- -> between the last ```CFBundle``` ```</key>``` and the ```<key>LSMinimumSystemVersionByArchitecture</key>``` enter this (and save):

```xml
<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string>Pnano URL</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>nano</string>
			</array>
		</dict>
	</array>
```

You may need to reboot, but can try entering e.g. ```nano:///Users/alice/hello.py``` into a web browser. It should open to a split pane with ```hello.py``` opened (empty/new or as exists) in a buffer with  ```nano -m```. 

... 
The same thing can then be done to handle for "protocol" ```pnbp``` -> ```pnbp://``` by following the same steps above, but using the contents of [ppnbp.app](https://github.com/prettynb/pnano/blob/main/ppnbp/ppnbp.app) and making adjustments to ppnb/Contents/[Info.plist](https://github.com/prettynb/pnano/blob/main/ppnbp/Info.plist), changing to ```<string>Ppnbp URL</string>``` and ```<string>pnbp</string>``` accordingly within the above xml snippit).

--- 

\*\* You will need something to properly open and save ```.plist``` files. I recommend [Sublime Text](https://www.sublimetext.com/download) and the Package Control available [BinaryPlist](https://packagecontrol.io/packages/BinaryPlist). 

\*\* You will want to install a newer version of ```nano``` than ```/usr/bin/nano```.
As written, the ".app" (scripts... ) point to open using ```/usr/local/Cellar/nano/5.8/bin/nano```, which happened to be the current installation path (and version) via ```brew install nano```  ([homebrew](https://formulae.brew.sh/formula/nano#default)). This way, syntax highlighting can be enabled:  ```echo 'include "/usr/local/share/nano/markdown.nanorc"' >> ~/.nanorc```.


--- 






