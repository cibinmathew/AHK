; http://www.cibinmathew.com
; github.com/cibinmathew

; If file not found, add an option as create that empty file and open in npp
SplitPath, A_ScriptDir , , , , , A_Script_Drive
ifexist,run.ico
	menu, Tray, Icon, run.ico
else
	menu, Tray, Icon, Shell32.dll, 24
#SingleInstance Force
SetWorkingDir %A_ScriptDir% 
setupMenu ("Context1_icons")

#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\! new smart run lib.ahk
#include C:\cbn_gits\AHK\LIB\contextmenu.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
suspend_if_VMwareHorizonClient()


return

; <^`::	; recently downloaded
	GetKeyState,state,CTRL
	If ( state= "D" )
	{		
		keywait,ctrl
		run, "%A_Script_Drive%\cbn\opus\opus_scripts\newest file.ahk" "C:\users\%a_username%\Downloads"
	}
return


>+`::	; na
	send,``
return


` up::	; na
	; tooltip,up
	; sleep,200
	; tooltip
	smart_run_HK_active:=0
return


#IfWinActive, ahk_class dopus.lister
#IfWinActive, ahk_class ThunderRT6FormDC
>+enter:: ; open with
#IfWinActive
/*
	if (shift_enter_trigger)	; already triggered
		goto,wait_for_123
		
	shift_enter_trigger:=1
	trigger_from_explorer:=1
	gosub,smart_check
	*/
return

`::
	SelectedFile:=Get_Selected_Text()
	smart_run_open(SelectedFile)
return




	
#ifWinActive ahk_class Notepad++

<+`::	; na
send,``
return

>+`::	; na
send,~
return

#ifWinActive

return

!1:: ; calculator
	selText :=Get_Selected_Text()
	sum=0
	tot_items := 0
	msg=
	output =
	expression := 0
	selText := regexreplace(selText, "^\s+|\s+$","")
	if RegExMatch(selText, "(.*)[\*\+-]([\d]*\.?[\d]*)$")
	{
		expression := 1
		list := RegExreplace(selText, "^(.*)([\*\+-])([\d]*\.?[\d]*)$", "$1")
		;msgbox,%list%
		operator := RegExreplace(selText, "i)^(.)([\*\+-])(\d+\.?\d*)$", "$2")
		msgbox, %selText%=`n`n%operator%=
			operand := RegExreplace(selText, "^(.*)([\*\+-])([\d]*\.?[\d]*)$", "$3")
		msgbox, =%operand%=
	}
	else 
		list := selText
	; if RegExMatch(selText, "^(.*)[\*\+-/]([\d]*\.?[\d]*)$")
	loop,parse,list,`n,`r
	{
		; strip commas and .... from ends
		item := regexreplace( A_LoopField,"^[\s,;]*([\d,]*\d+)[\s,;]*$","$1")
		if (item!="")
		{
			sum += item
			tot_items+=1
			msg .= item . "+"
			if operator=""
				result := item + operand
			else if operator="-"
				result := item - operand
			else if operator="*"
				result := item * operand
			else if operator="/"
				result := item / operand
			output .= result . "`n"
		}
	}
	if (tot_items)
		average := sum/tot_items	
	clipboard := output
	SetTimer, removetooltip, 3500
	tooltip,%tot_items% items`nsum = %sum%`navg = %average%`n%msg%

Return
