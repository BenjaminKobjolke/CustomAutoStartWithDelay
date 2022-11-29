/*
* This script will run Chrome.ahk and StartupTools.ahk after some delay
* cancel with ESC
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%


clipboard := A_ComputerName
MsgBox, %A_ComputerName% was copied to clipboard


return