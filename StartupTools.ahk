#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%

fileExtensions := ["lnk", "ahk", "exe", "bat"]

baseDir := "Autostart"
pcDir = %A_ComputerName%
targetDir := baseDir "\" pcDir


EnvGet, sessionName, SESSIONNAME
;MsgBox, %sessionName%
searchString := "RDP-"
StringGetPos, pos, sessionName, %searchString%

isRemoteSession := 0
if(pos = 0) {
	isRemoteSession := 1
}


if (!FileExist(baseDir)) {	
	FileCreateDir, %baseDir%
}

if(!FileExist(targetDir)) {	
	FileCreateDir, %targetDir%
}


filesFound := 0
for index, element in fileExtensions
{
	filesFound := filesFound + countFiles(targetDir, element)
}

if(filesFound = 0) {
	extensionsList := ""
	for index, element in fileExtensions
	{	
		if(index = 1) {
			extensionsList := element
		} else {
			extensionsList := extensionsList ", " element
		}		
	}

	MsgBox, No files found in`r%A_ScriptDir%\%targetDir%`r`rPlease create files with the following extensions: %extensionsList%
	ExitApp
}

for index, element in fileExtensions
{
	runFiles(targetDir, element)
}

ExitApp


runFiles(targetDir, fileExtension) {

	searchPattern = %targetDir%\*.%fileExtension%	

	Loop Files, %searchPattern%, R  ; Recurse into subfolders.
	{
		;MsgBox, %A_LoopFileName%
		if(!shouldLaunchFile(A_LoopFileName)) {
			continue
		}

		try 
		{
			Run, %A_LoopFileLongPath%
		}
		catch e  ; Handles the first error/exception raised by the block above.
		{
			MsgBox, Cannot start %A_LoopFileLongPath%
		}
		
		Sleep, 100
	}
}

countFiles(targetDir, fileExtension) {

	searchPattern = %targetDir%\*.%fileExtension%	
	count := 0
	Loop Files, %searchPattern%, R  ; Recurse into subfolders.
	{
		count := count + 1
	}
	return count
}
/*
	Checks if the file should be launched.
	Will not launch files containing _nordp if the session is a remote session via remote desktop
*/
shouldLaunchFile(fileName) {
	global isRemoteSession
	if(isRemoteSession = 0) {
		return true
	}

	SplitPath, fileName, , , , name
	StringLen, length, name
	foundPos := InStr(name, "_nordp")
	
	if(foundPos > 0) {		
		return false
	}

	return true

}