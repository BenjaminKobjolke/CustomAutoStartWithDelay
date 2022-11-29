/*
* This script will run Chrome.ahk and StartupTools.ahk after some delay
* cancel with ESC
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%

seconds := 10
x := 0
Progress, b w300, Press ESC to cancel, Delayed autostart, Delayed autostart
Sleep, 15000
settimer,progress, 1000
GoSub, progress
return

progress:
    x += 1
    secondsLeft := seconds - x
    percent := (100*x)/seconds ;Change this to 10 if you change the above number to 100
    ;ToolTip, %percent%
    Progress, %percent%, Press ESC to cancel or F1 to start now, Delayed autostart in %secondsLeft%, Delayed autostart

    if percent=100
    {
		ExitApp
		;GoSub, Execute
    }
return

F1::
	GoSub, Execute
return

Execute:
	Progress, Off
	settimer,progress,off        
	RunWait, StartupTools.ahk
	;Run, Chrome.ahk
	ExitApp
return

Escape::
    ExitApp
return


if(!A_IsCompiled) {
	#y::
		;ControlGetText, output , SysListView321, 
		;ControlGet, output, Line, 1, SysListView321, - Notepad++
		Send ^s
		reload
	return
}

