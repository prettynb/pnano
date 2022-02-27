
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars


on open location myURL
	
	set oldDelims to AppleScript's text item delimiters
	set newDelims to {"://"}
	set AppleScript's text item delimiters to newDelims
	
	set pathname to item 2 of the text items of myURL
	set pathname to replace_chars(pathname, "%20", "\\ ")
	
	set newDelims to {"/"}
	set AppleScript's text item delimiters to newDelims
	
	set filename to item (count of the text items in pathname) of the text items of pathname
	
	set cmd to "nbn-pprint -n " & "\"" & filename & "\""
	
	tell application "iTerm"
		activate
		
		tell current session of current tab of current window
			write text "clear && printf '\\e[3J'"
			write text cmd
			
		end tell
		
	end tell
	
	set AppleScript's text item delimiters to oldDelims
	
end open location


