# Before writing the nvim command to iTerm, we need to know if iTerm is open
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

on run {input, parameters}
	set nvimPath to "/opt/homebrew/bin/nvim"
	
	# Extract filepaths from the input
	set filepaths to ""
	set sampleFile to ""
	
	if input is not {} then
		repeat with currentFile in input
			set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
			set sampleFile to POSIX path of currentFile
		end repeat
		
		# -p opens files in separate tabs
		set nvimCommand to nvimPath & " -p " & filepaths
		
		# Get the dirname of the input files
		set parentDir to quoted form of (do shell script "dirname \"" & sampleFile & "\"")
	else
		set nvimCommand to nvimPath
		set parentDir to system attribute "HOME"
	end if
	
	# final command to send to iTerm
	set finalCommand to ("cd " & parentDir & " && " & nvimCommand)
	
	# Create an iTerm instance (if needed) and write the nvim command
	if not appIsRunning("iTerm") then
		# Two tells because just telling iTerm to activate (not launch) will cause problems
		tell application "iTerm" to launch
		tell application "iTerm" to create window with default profile
	end if
	
	# Finally, write the complete NeoVim command for the selected files to the iTerm window
	tell application "iTerm"
		tell current session of current window
			write text finalCommand
		end tell
	end tell
	
end run
