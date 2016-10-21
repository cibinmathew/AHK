; http://www.cibinmathew.com
; github.com/cibinmathew

SplitPath, A_ScriptDir , , , , , A_Script_Drive
Menu, Tray, Icon, Shell32.dll,13

#include LIB\cbn.ahk
#include LIB\contextmenu.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk

#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk

#SingleInstance force

space_hotkey =1
power_save:=0
HK_extract_filenames_cycle:=0
HK_sel_Text_cycle:=0

PrintScreenCycleHK_active:=0
PrintScreenCycleHK_count:=0
suspend_if_VMwareHorizonClient()
hotkey,^q,off	;	start disabled
;gosub, space_toggle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fav_data_f=fav_data
Menu,Tray,tip,HotKeys
mbuttonpaste=0
/*
path2=%A_ScriptDir%\qwerty.ahk
IfExist, %path2%
	Run,%path2%
else
{
	tooltip,%path2% is missing
	sleep,800
	tooltip
}
*/
flag=1
backspace_A=backspace_F
capslock_A=backspace_f  
C_wheelup_A=PgUP_f
A_Wheeldown_A=winmenu_F
C_Wheeldown_A=Pgdn_f
alt_C_A=copy_line_F
alt_V_A=paste_line_F
Ralt_V_A=paste_line_F_enter
win_C_A=copy_all_F
win_V_A=paste_all_F
S_wheelup_A=ctrl_home_F
S_wheeldown_A=ctrl_end
alt_L_A=login1_f
win_alt_L_A=select_all_F
win_Lbutton_A=copy_F
win_rbutton_A=paste_F
win_mbutton_A=cut_F
alt_lbutton_A=nil

flag=0

;priority 
Hotkey, <^Wheeldown, , p1
Hotkey, <^Wheelup, , p1
return

/*
if (A_PriorHotKey = "~lctrl" AND A_TimeSincePriorHotkey < 400)
{
	run,C:\Users\welcome\Downloads\COMPRESSED\Everything-1.3.0.631b\Everything-1.3.0.631b.exe
  
 }
else
{
  
}
Sleep 0
KeyWait lctrl
return
*/
; ~lshift::	; na
;400 is the maximum allowed delay (in milliseconds) between presses.
if (A_PriorHotKey = "~lshift" AND A_TimeSincePriorHotkey < 300)
{
	DetectHiddenWindows, On 

	ifwinexist, %path2% ahk_class AutoHotkey
	{

		; msgbox
		WinClose, %path2% ahk_class AutoHotkey
		flag=0
		Progress, b    w80  fs16 zh0  CTFFFFFF CWFF0000, H keyB OFF, , , Calibri
		Sleep, 500
		Progress, off
	  
	 }
else
  {
	  Run,%path2%
	  flag=1
	  Progress, b   w80 fs16 zh0  CT000000 CW00FF00, H keyB ON, , , Calibri
	  SoundBeep, 1200, 100  ; Play a higher pitch for half a second.
	  SoundBeep, 1200, 300  ; Play a higher pitch for half a second.
	  Sleep, 200
	  Progress, off
  }
}
Sleep 0
KeyWait lshift
return
/*
~RShift::	; na
	GetKeyState, CapState, CapsLock, T
	If CapState=U
	{
		; tooltip,caps OFF
		SetCapsLockState, off
	}
	Else if CapState=D
	{
		; tooltip,caps ON
		; settimer,removetooltip,400
		SetCapsLockState, on
	}
	; sleep, 400
	; Tooltip
	Return  
*/

+F1::	;	monitor off
	sleep,200
	SendMessage,0x112,0xF170,2,,Program Manager
	Return


~LWin Up:: ;disble win key

return


<#z::	; na
	send, ^z
return

;
<#c::	; na
gosub, %win_C_A%
 return
;
<#v::	; na
gosub, %win_V_A%
return

;ctrl home
<+wheelup::	; na
gosub, %S_wheelup_A%
return  

;ctrl end
<+wheeldown::	; na
	gosub, %S_wheeldown_A%
return 

<#lbutton::	; na
	gosub, %win_Lbutton_A%
return

 
#rbutton::	; na
	gosub, %win_rbutton_A%
return


<#mbutton::	; na
	gosub, %win_mbutton_A%
return

pause::	;	ToolTip,Clipboard
	StringLeft, MyText, Clipboard, 200
	ToolTip, %MyText% 
	keywait, Lbutton, D ,t2
	ToolTip,
return
 

<^Wheeldown::	; na
	gosub, %C_Wheeldown_A%
return

<^wheelup::	; na
	gosub, %C_Wheelup_A%
return

wheelup_F:
	send {wheelup}
return

wheeldown_F:
	send {wheelDOWN}
return

PgUP_F:
	send {PGup}
return

Pgdn_f:
	send {PGdn} 
return
 
PgUP2_F:
	send {PGUP} 
	send {wheelDOWN}
return

PgDN2_F:
	send {PGdn} 
	send {wheelup}
return

backspace_f:
	Send, {BackSpace}
return

tabmenu_f:
	Send,  !{Tab}
return

winmenu_f:
	send, #{tab}
return

copy_line_F:
	send {end}
	send +{home}
	send ^c
return

paste_line_F:
send {end}
send +{home}
; send ^v
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
return

paste_line_F_enter:
send {end}
send +{home}
; send ^v
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
send {enter}
return
;
copy_all_F:
send ^{end}
send ^+{home}
; send ^c
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")
return
;
paste_all_F:
	send,^a
	sleep,10
	send ^v
return

ctrl_home_F: 
send ^{home}
return  

ctrl_end:
send ^{end}  
return 

select_all_F:
send, ^a
return

copy_F:

send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")

ClipWait,1,1
if ErrorLevel
    return


return


enter_F:
	send, {enter}
return
	
paste_F:
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	SetTimer, RemoveToolTip, 750
return

cut_F:
	; send, ^x
	
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-w")
	; ToolTip, %clipboard%
	; SetTimer, RemoveToolTip, 750
	return

nil:
	return

RemoveToolTip:
	SetTimer,RemoveToolTip,Off
	ToolTip
return
RemoveToolTip2:
	SetTimer,RemoveToolTip2,Off
	ToolTip,,,,2
return

exit:
	exitapp
return

<#capslock::	;	AlwaysOnTop
If NOT IsWindow(WinExist("A"))
   Return
WinGetTitle, TempText, A
If GetKeyState("shift")
{
   WinSet AlwaysOnTop, Off, A
   If (SubStr(TempText, 1, 2) = "† ")
      TempText := SubStr(TempText, 3)
}
else
{
   WinSet AlwaysOnTop, On, l
   If (SubStr(TempText, 1, 2) != "† ")
      TempText := "† " . TempText ;chr(134)
}
WinSetTitle, A, , %TempText%
Return

IsWindow(hwnd) 
{
    WinGet, s, Style, ahk_id %hwnd% 
    return s & 0xC00000 ? (s & 0x80000000 ? 0 : 1) : 0
    ;WS_CAPTION AND !WS_POPUP(for tooltips etc) 
}

; <^printscreen::	; screenshot, save & open
screenshot_save_open:
FormatTime, TimeString2, , dd MMM  yyyy ( ddd ) hh-mm ss tt
Runwait, %comspec% /c ""F:\cbn\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "%A_ScriptDir%\screenshots\screenshot %TimeString2%.png" ,,Hide
screenshot_moved:=0
tooltip,screenshot saved to %A_ScriptDir%\screenshots\screenshot %TimeString2%.png`nLshift=move to fav`nRshift =open`nLctrl=cancel,,,2
settimer,RemoveToolTip2,-4000
again2:
Input, SingleKey, L1 T4,  {esc}{LControl}{RControl}{LShift}{RShift}

if ErrorLevel = Timeout
{
    ;MsgBox,   the input timed out. 
	tooltip,saved to default,,,2
	settimer,RemoveToolTip2,-3000
	return
}
else IfInString, ErrorLevel, EndKey:
{
	if ( (ErrorLevel = "EndKey:esc") OR (ErrorLevel = "EndKey:LControl" ) )
	{
		tooltip,,,,2
		return
	}
	else if (ErrorLevel = "EndKey:RShift")
	{
		tooltip,opening C:\users\%a_username%\Downloads\screenshots\screenshot %TimeString2%.png,,,2
		if (screenshot_moved)
			run,"C:\users\%a_username%\Downloads\screenshots\screenshot %TimeString2%.png"
		else
			{
			run,"%A_ScriptDir%\screenshots"
			sleep,200
			run,"%A_ScriptDir%\screenshots\screenshot %TimeString2%.png"
			}
		settimer,removetooltip2,-4000
		return		
		
	}
	else if (ErrorLevel ="EndKey:LShift")	;	space to return to main menu
	{
			tooltip,MOVING,,,2
			sleep,300
			filemove,%A_ScriptDir%\screenshots\screenshot %TimeString2%.png,C:\users\%a_username%\Downloads\screenshots\screenshot %TimeString2%.png
			tooltip,MOVED !`n%A_ScriptDir%\screenshots\screenshot %TimeString2%.png `nto C:\users\%a_username%\Downloads\screenshots\screenshot %TimeString2%.png`n`nRshift =open`nLctrl=cancel,,,2
			settimer,removetooltip2,-4000
			screenshot_moved:=1
			goto,again2
	}

}
else  
{	
; goto,again2
}

return

; <+printscreen::	; screenshot loop 5s
screenshot_loop_5:
	printscreen_delay:=5000
	tooltip,looping %printscreen_delay%
	sleep,500
	loop,5
	{

		FormatTime, TimeString2, , dd MMM  yyyy ( ddd ) hh-mm ss tt

		tooltip,%a_index%
		Runwait, %comspec% /c ""F:\cbn\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "%A_ScriptDir%\screenshots\screenshot %TimeString2%.png" ,,Hide
		sleep,%printscreen_delay%
	}
	tooltip,
	tooltip,screenshot saved...f2=open
	settimer,removetooltip,-2000
	keywait,f2, D ,t3
	if !ErrorLevel
	{
		tooltip,opening
		run,"%A_ScriptDir%\screenshots"
		; sleep,200
		; run,"%A_ScriptDir%\screenshots\screenshot %TimeString2%.png"
		settimer,removetooltip,-1000
	}

return
open_screenshot_folder:
	run,"%A_ScriptDir%\screenshots"
return


save_AOT_Screenshot:
	tooltip,AOT image`n^+5:: open
	sleep,500
	FormatTime, TimeString2, , dd MMM  yyyy ( ddd ) hh-mm ss tt
	tooltip,click
	sleep,50
	tooltip
	Runwait, %comspec% /c ""F:\cbn\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "C:\users\%a_username%\Downloads\AOT Clipboard Image.png" ,,Hide
	tooltip,saved`n^+5:: open
	sleep,2000
	tooltip	; sleep,%printscreen_delay%
return

save_AOT_image:

	FormatTime, TimeString2, , dd MMM  yyyy ( ddd ) hh-mm ss tt
	if !ErrorLevel
		inputbox,tmp,save screenshot as,click OK to take snapshot`n`nin %A_ScriptDir%\screenshots\,,,,,,,,%TimeString2%
	sleep,100
	Runwait, %comspec% /c ""F:\cbn\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "%A_ScriptDir%\screenshots\%tmp%.png" ,,Hide

	tooltip,screenshot saved...f2=open
	settimer,removetooltip,-2000

	keywait,f2, D ,t3
	if !ErrorLevel
	{
		tooltip,opening
		run,"%A_ScriptDir%\screenshots"
		; sleep,200
		; run,"%A_ScriptDir%\screenshots\screenshot %TimeString2%.png"
		settimer,removetooltip,-1000
	}
return
	
<^printscreen:: ; Print Screen CycleHK
settimer,cancelPrintScreenCycleHK,off	
if !(PrintScreenCycleHK_active)	;	if hotkey is currently not in cycle mode 
{
	PrintScreenCycleHK_count:=0
}

if (PrintScreenCycleHK_count=0)
{	
	PrintScreenCycleHK_count++
	msg=screenshot_save_open
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500	
	PrintScreenCycleHK_action = screenshot_save_open
}
else if (PrintScreenCycleHK_count=1)
{	

	PrintScreenCycleHK_count++
	msg=screenshot_loop 5s
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500	
	PrintScreenCycleHK_action = screenshot_loop_5	
}
else if (PrintScreenCycleHK_count=2)
{	

	PrintScreenCycleHK_count++
	msg=save_AOT_Screenshot
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500	
	PrintScreenCycleHK_action = save_AOT_Screenshot	
}
else if (PrintScreenCycleHK_count=3)
{	

	PrintScreenCycleHK_count++
	msg=save_AOT_image
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500	
	PrintScreenCycleHK_action = save_AOT_image	
}
else if (PrintScreenCycleHK_count=4)
{	

	PrintScreenCycleHK_count++
	msg=open saved folder
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500	
	PrintScreenCycleHK_action = open_screenshot_folder	
}
else
{	

	PrintScreenCycleHK_count:=0
	msg=cancel
	settimer,removetooltip,-1600
	tooltip,%PrintScreenCycleHK_count% %msg%
	settimer,cancelPrintScreenCycleHK,-2500		
}
	
	PrintScreenCycleHK_active:=1
	hotkey,^q,on
	setTimer,PrintScreenCycleHK,70
	sleep,10



PrintScreenCycleHK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
	
		gosub,cancelPrintScreenCycleHK
		if (PrintScreenCycleHK_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%PrintScreenCycleHK_count% cancelled
			
		}
		else if (PrintScreenCycleHK_count=1)
		{
		
		gosub,%PrintScreenCycleHK_action%
			
			
		}
		else if (PrintScreenCycleHK_count=2)
		{	

		gosub,%PrintScreenCycleHK_action%

		}
		else if (PrintScreenCycleHK_count=3)
		{

		gosub,%PrintScreenCycleHK_action%
		}
		else if (PrintScreenCycleHK_count=4)
		{

		gosub,%PrintScreenCycleHK_action%
		}

	}
return

cancelPrintScreenCycleHK:	;	cancel without action
	setTimer,PrintScreenCycleHK,off
	PrintScreenCycleHK_active:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return
; ===================dopus============

#IfWinActive, ahk_class dopus.viewpicframe 
right::send {wheeldown} ; na
return

left::send {wheelup} ; na
return

rbutton::send {enter} ; na
return

#IfWinActive

~LButton & XButton1::Send, {Ctrldown}c{CtrlUp} ;copies stuff 
~LButton & XButton2::Send, {Ctrldown}v{CtrlUp} ;pastes stuff
; ~XButton1 & RButton::WinMinimize A              ;minimizes windows

; XButton1::Send, {BROWSER_FORWARD}
; XButton2::Send, {BROWSER_BACK}

XButton1::	; na
tooltip,a
send,{f11}
sleep,200
tooltip,
return

XButton2::	; na
tooltip,a
send,{f11}
sleep,200
tooltip,
return


#IfWinActive, ahk_class dopus.lister
XButton1::	; na
tooltip,a
send,{f11}
sleep,200
tooltip,
return


; ~LWin Up:: ;disble win key
<+wheelup::	; na
send, +f

return

<+wheeldown::	; na
send, +d

return

<!wheeldown::	; na
send, ^g
return 

<!wheelup::	; na
send, ^h
return

<#lbutton::	; na
send,{enter}
return 

<#wheeldown::	; na
send,{down}
sleep,200
/*
send, ^g
sleep,200
send,{enter}
*/
return 

<#wheelup::	; na
send,{up}
sleep,200
/*
send, ^h
sleep,200
send,{enter}
*/
return

<^wheeldown::	; na
send, +d 
return 

<^wheelup::	; na
send, {backspace}
return

<^+wheelup::	; na
send, {f11}
return

<^+wheeldown::	; na
send, {f10}
return

#IfWinActive

copy:
	send ^c
	return

paste:
	send ^v
	return

~rbutton::	; na
return

rbutton & wheelup::	; na
	tooltip,wheelup
	sleep,800
	tooltip,
Return

rbutton & wheeldown::	; na
	tooltip,wheelup
	sleep,800
	tooltip,
return
 
#Esc::	; na
Suspend, Permit
	If ( !A_IsSuspended )
	{
		Suspend, On
		;SYS_TrayTipText = NiftyWindows is suspended now.`nPress WIN+ESC to resume it again.
		;SYS_TrayTipOptions = 2
		Progress, b fs18 zh0 CBFF0000, HK suspended, , , Calibri
        Sleep, 750
        Progress, off

	}
	Else
	{
	    Progress, b fs18 zh0 CB5,HK  activated, , , Calibri
        Sleep, 750
        Progress, off
		Suspend, Off
		;SYS_TrayTipText = NiftyWindows is resumed now.`nPress WIN+ESC to suspend it again.
	}

Return

;=====SEARCH

#IfWinActive, ahk_class Chrome_WidgetWin_1
#IfWinActive, ahk_class Chrome_WidgetWin_0
#ifWinActive, Chrome
; #IfWinActive, ahk_class DSUI:PDFXCViewer

f10:: ; PDFXCViewer fullscreen  ; na
	sleep,200
	send {F11}
	sleep,200
	send {F12}
	sleep,500
	Run, RunDLL32.EXE shell32.dll`,Options_RunDLL 1
	WinWait,Taskbar and Navigation properties
	Send, ua{ESC}
return
numpadADD::	;	send,^{numpadADD}

	send,^{numpadADD}
	return

numpadsub:: ;	send,^{numpadsub}
	send,^{numpadsub}
return

#ifWinActive



open_in_opus:
	menuEvent_function("Open &directory",contents)

return

open_in_explorer:
	FileFullpath:=contents
	If InStr( FileExist(FileFullpath), "D" )
	{
		;if folder ,open in opus
		filex="%FileFullpath%"
		 run  %Filex% 		
	}
	else
	{
		 splitpath,FileFullpath,,Folder		
		Run %Folder%	 
	}
	Return
<^numpadenter::	; send, {lbutton}
	send, {lbutton}
return

>^numpadenter::	; send, {rbutton}
	send, {rbutton}
return


<^+F6::	      ;google map      
	direction:=0
	inputbox,tmp,google map,enter source to destination,,,,,,,,muvattupuzha
	; if !ErrorLevel
	if (RegExMatch(tmp, " to "))
		{
		direction:=1	
		SubPata1:=RegExreplace(tmp, " to .*","")
		SubPata2:=RegExreplace(tmp, ".* to ","")
		; msgbox,%SubPata1%= %SubPata2%
		}
	if (direction)	
		; run, http://maps.google.co.in/maps?q=%tmp%&qscrl=1&um=1&ie=UTF-8&sa=X&ei=ZDvDUZWWBMSUrAfc04DgDA&ved=0CAoQ_AUoAg
		run, http://maps.google.co.in/maps?saddr=%SubPata1%&daddr=%SubPata2%	;&hl=en&ll=10.021934,76.604404&spn=0.097537,0.169086&sll=9.979848,76.573807&sspn=0.048775,0.084543&geocode=FZ6BmQAdy1uRBCmpjmFgEuYHOzEHXNSJ30Yiow%3BFchHmAAdb2yQBCnz8PadjN0HOzHlYnDM_2xQtA&mra=ls&t=m&z=13
	else
		; run, http://maps.google.com/maps?q=10.00131`,76.582947&num=1&t=m&z=9
		run, http://maps.google.co.in/maps?q=Muvattupuzha
return

contents_of_clip_path:
	file=%clipboard%
	fileread,contents,%file%
	if contents<>
		{
			clipboard:=contents
			text:=truncated_text(contents,300)
		}
	else
		text=EMPTY	

	settimer,removetooltip,-4500
	tooltip,contents of %file%`n`n%text%

return


filenames_from_clipb_path:
	filepaths=%clipboard%

	tooltip,extract filenames from clipboard FILES

	sleep,100

	reg=\w:\\(.*)\.(\w)+

	matchlist=
	matchlist2=

	loop,parse, filepaths,`n,`r
	{
		fileread, edit3, %A_LoopField%

		matchlist:=CBN_TF_Find(edit3,1,0,reg,0,3,1)
		matchlist2=%matchlist2%`n%matchlist%
	}
	newline:=0
	Loop, Parse, matchlist, `n,`r
		newline++
	if matchlist<>
		{
			clipboard:=matchlist2
			text:=truncated_text(matchlist2,300)
		}
	else
		text=EMPTY	

	settimer,removetooltip,-4500
	tooltip,extract filenames from clipboard FILES`ncopied`n%text%`n(filenames without spaces only)

return

;extract filenames from clipboard TEXT
filenames_from_clipb_TEXT:

	edit3=%clipboard%

	tooltip,(filenames with ext & without spaces only)
	sleep,150

	reg=\w:\\(.*)\.(\w)+

	matchlist=

	matchlist:=CBN_TF_Find(edit3,1,0,reg,0,3,1)
	newline:=0
	Loop, Parse, matchlist, `n,`r
		newline++
	if matchlist<>
	{
		text2:=truncated_text(matchlist,300)
	}
	else
		text2=EMPTY
	settimer,removetooltip,-4500
	tooltip,%newline% files (filenames with ext & without spaces only)`n%text2%

return

<^+f8::	; extract filenames from clipboard...

	text:=truncated_text(clipboard,120)
	if !(HK_extract_filenames_cycle)	;	if hotkey is currently in cycle mode 
	{
		HK_extract_filenames_cycle_count:=0
	}
	if (HK_extract_filenames_cycle_count=0)
	{
		HK_extract_filenames_cycle_count++
		gosub,filenames_from_clipb_TEXT
		tmptext:=truncated_text(clipboard,300)
		msg=filenames from clipboard TEXT %newline% files`n`n%text2%`n`n`n`n%tmptext%
		HK_extract_filenames_cycle_action=filenames_from_clipb_TEXT

	}
	else if (HK_extract_filenames_cycle_count=1)
	{
		HK_extract_filenames_cycle_count++
		msg=copy contents of clip path`n%text%
		HK_extract_filenames_cycle_action=contents_of_clip_path

	}		
	else if (HK_extract_filenames_cycle_count=2)
	{
		HK_extract_filenames_cycle_count++
		msg=filenames from clipboard FILES`n%text%
		HK_extract_filenames_cycle_action=filenames_from_clipb_path

	}		
	else
	{
		HK_extract_filenames_cycle_count:=0
		msg=cancel
		HK_extract_filenames_cycle_action=nil
		settimer, cancelHK_extract_filenames_cycle,-300

	}
	tooltip,%msg%
	settimer,removetooltip,-4500
	setTimer,HK_extract_filenames_cycle_sleep,-4500
	
	HK_extract_filenames_cycle:=1
	hotkey,^q,on	;	cancelling hot key is made vigilant
	setTimer,HK_extract_filenames_cycle,70	
	sleep,10
return

HK_extract_filenames_cycle:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		settimer,removetooltip,-800		
		if ( HK_extract_filenames_cycle_count=0 )
		{

		}
		else if ( HK_extract_filenames_cycle_count=1 )
		{
		
			clipboard:=matchlist
		}
		else
		{
			gosub,%HK_extract_filenames_cycle_action%
		}
		gosub,cancelHK_extract_filenames_cycle
	}
return

HK_extract_filenames_cycle_sleep:	;	cancel after a delay even if ctrl is pressed

	if (HK_extract_filenames_cycle)
		tooltip,cancelling
	gosub,cancelHK_extract_filenames_cycle				
	settimer,removetooltip,-100			
return

cancelHK_extract_filenames_cycle:	;	cancel without action
	setTimer,HK_extract_filenames_cycle,off
	HK_extract_filenames_cycle:=0
	HK_extract_filenames_cycle_count:=0
	hotkey,^q,off
	settimer,removetooltip,-100			
return


sel_file_in_Npp:
	file=%selText%
	file:=regexreplace(file,"(^\s+)|(\s+$)|""","")	
	menuEvent_function("N++",file)
return

clipB_file_in_Npp:
	file:=contents
	stringreplace,file,file,",all	
	file:=regexreplace(file,"(^\s+)|(\s+$)","") ; "
	menuEvent_function("N++",file)

return

; <^f8::	; open selected text
	if !(HK_sel_Text_cycle)
	{
			selText:=Get_Selected_Text()
			text:=truncated_text(selText,120)
			HK_sel_Text_cycle_count:=0
			text:=truncated_text(selText,120)
			HK_sel_Text_cycle:=1
	}
	if (HK_sel_Text_cycle)
	{
		HK_sel_Text_cycle_count++
		if (HK_sel_Text_cycle_count=1)
		{
			msg=open sel text in N++
			HK_sel_Text_cycle_action=sel_in_Npp
		}	
		else if (HK_sel_Text_cycle_count=2)
		{
			msg=open in quicknote
			HK_sel_Text_cycle_action=sel_in_Notepad
		}		
		else
		{
			HK_sel_Text_cycle_count:=0
			msg = cancel
			HK_sel_Text_cycle_action=nil
			settimer,cancelHK_sel_Text_cycle,-300
		}			
	}

	tooltip,%msg%
	settimer,removetooltip,-3500
	setTimer,HK_sel_Text_cycle_sleep,-3500
	
	hotkey,^q,on	;	cancelling hot key is made vigilant
	setTimer,HK_sel_Text_cycle,70	

return

HK_sel_Text_cycle:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		gosub,cancelHK_sel_Text_cycle
		tooltip,executing %msg%
		settimer,removetooltip,-600		
		sleep,350
		gosub,%HK_sel_Text_cycle_action%
	}
return

HK_sel_Text_cycle_sleep:	;	cancel after a delay even if ctrl is down

		if (HK_sel_Text_cycle)
			tooltip,cancelling
		gosub,cancelHK_sel_Text_cycle		
		
		settimer,removetooltip,-100
return

cancelHK_sel_Text_cycle:	;	cancel without action
	setTimer,HK_sel_Text_cycle,off
	HK_sel_Text_cycle:=0
	HK_sel_Text_cycle_count:=0
	hotkey,^q,off
return

$^q::	; na
	if  (HK_extract_filenames_cycle) 
	{
		gosub,cancelHK_extract_filenames_cycle
	}
	else if  (HK_sel_Text_cycle) 
	{
		gosub,cancelHK_sel_Text_cycle
	}
	else if (PrintScreenCycleHK_active)		
	{
		gosub,cancelPrintScreenCycleHK
	}
	else
	{
		send ^q
	}
Return



; ^!r::	; ratio calculator
	run,%A_Script_Drive%\cbn\ahk\ratio calculator.ahk
return
; for pydev in eclipse
<^+lbutton::

	send, ^!{enter}
return

^+i::	; remove indent uniformly from all lines
output := clipboard
trim:=1
while(trim)
{
	/*
			*/
	trim:=1
	loop,parse,output,`n,`r
		if !(regexmatch(a_loopfield,"m)^\t(.*)$"))
		{
			trim:=0
			break
		}
	if (trim)
		output := regexreplace(output,"m)^\t(.*)$","$1")
	trim:=1
	loop,parse,output,`n,`r
		if !(regexmatch(a_loopfield,"m)^ (.*)$"))
		{
			trim:=0
			break
		}
	if (trim)
		output := regexreplace(output,"m)^ (.*)$","$1")
}
clipboard := output
settimer,removetooltip,500
tooltip,no change
return

#printscreen::

	clipsave = %clipboard%
	send {printscreen}
	run, mspaint.exe
	tooltip, waiting
	sleep,300
	tooltip
	winActivate ahk_class MSPaintApp
	winwaitactive ahk_class MSPaintApp
	{
		; send, ^v
		send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	}
	clipboard = %clipsave%
	clipsave=
return

	
^+4:: ; google feeeling lucky
	
	selText:=Get_Selected_Text()
	url := "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&ie=UTF-8&oe=UTF-8&q=" . selText . "%20lyrics" 

	run,%url%
	
	return


^+f11::
iniread,f_path,all_settings.ini,paths,emacs
run, "%f_path%" "C:\Users\cibin\Downloads\clear these doubts.txt" -n

return

^+f12::
run, "C:\users\%A_UserName%\ca_cabling\depot.prod.corduroy\packages\Scripts\python.exe" "C:\users\%A_UserName%\ca_cabling\depot.prod.corduroy\configadvisor.py"

return
^F11::
run,"C:\cbn_gits\AHK\python.py"

return