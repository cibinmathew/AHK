; http://www.cibinmathew.com
; github.com/cibinmathew

ifexist, settings.ico
	Menu, Tray, Icon,settings.ico
#SingleInstance,Force
#include LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\more_functions.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
#include C:\cbn_gits\AHK\LIB\HK_cycle.ahk

config =
(
ikonland@gmail.com,Session125,pass2
,
,
,
mail_cycle,mail_cycle,mail_cycle
,
,
,
)

HK_cycle_register("<!l","login_HK",4,4000,"LAlt", "$!q",config) 

return
;		LESS FREQUENT HOT KEYS


 
; <+'::	;;simultaneous clicks	
	CoordMode, Mouse,Screen
	Click 665, 550, 0  ; Move the mouse without clicking.
	sleep,50
	send, {LButton}

	sleep,50
	Click 1030, 80, 0  ; Move the mouse without clicking.
	sleep,50
	send, {LButton}

	CoordMode, Mouse,relative
	return
	;PIXLR O MATIC

paste_all_F:
	send,^a
	; send ^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	return

removetooltip:
	tooltip,
	return
 
; $^+q::	;	Photoshop
	winactivate, ahk_class Photoshop
	sleep,100
	send, ^+q	;place command
	sleep,300
	send, ^v
	sleep,300
	send,{enter}
	sleep,300
	send,{NumpadEnter}

return

;^+e::	; mail to
	Run, mailto:someone@domain.com?subject=This is the subject line&body=This is the message body's text.
return

~esc::	; na
	settimer,diff_timer,off
	tooltip
	diff_1_copied:=0
return

<^+8::	;	open in diff tools
	; if (A_PriorHotKey = "^+8" AND A_TimeSincePriorHotkey < 5000)
	; {
		; diff_1_copied:=1
	; }
	; else
		; diff_1_copied:=0

	; t:=A_tickcount
	; if t>3000
	hotkey,esc,on
	if (diff_1_copied =1 )	;	if text 1 is already copied
	{
	
		selText2:=Get_Selected_Text()
		temp_file2=%A_temp%\~temp_diff2.txt
		filedelete,%temp_file2%
		fileappend,%selText2%,%temp_file2%	
		run, F:\cbn\opus\apps\WinMerge-2.14.0-exe\WinMergeU.exe "%temp_file1%"  "%temp_file2%" /maximize	
		tooltip, opening in  diff
		sleep,500
		tooltip
		diff_1_copied=0
		settimer,diff_timer,off
		return
	}
else 
	{
		diff_1_copied=1
		selText:=Get_Selected_Text()
		temp_file1=%A_temp%\~temp_diff1.txt
		filedelete,%temp_file1%
		fileappend,%selText%,%temp_file1%
		tooltip, next text in  diff`nin 10 sec`n[esc to restart]
		tmp_t:=25
		settimer,diff_timer,400	
	}
return

diff_timer:
	if (tmp_t<1)
	{
		
		settimer,diff_timer,off
		tooltip
		diff_1_copied:=0
		return
	}
	tmp_t:=tmp_t-1
	; tooltip, next text in  diff`nin %tmp_t% msec`n[esc to restart]

return


; <^numpad8::	;	insert html gap in php 
	cliptmp:=clipboard
	sleep,10
	clipboard=?> <?php
	sleep,10
	send ^v
	sleep,10
	clipboard:=cliptmp


return


; <^numpad7::	; happy bday
	tooltip,happy bday
	t_mp=Happy Bdaay....`nHapy b'dy...`nHappy b'day..`nhappy b'day...`nhaapppy bdaay...`nhaaaaappy bdaaaaaay...`nhappy Bday.........`nhappy bday...

	Random, rand, 1, 8

	loop,parse,t_mp,`n,`r
		t_mp_%A_index%:=A_Loopfield
	t_mp:=t_mp_%rand%
	send %t_mp%

	sleep,300
	tooltip
	
	tmp=
	tmp_1=
	tmp_2=
	tmp_3=
	tmp_4=
	keywait ctrl
	return
	
; <^9::	; upload via url download
	list=%clipboard%
	tooltip,upload via url
	reg=&imgurl=(.*)?.jpg


	haystack=%clipboard%
	if RegExMatch(haystack,reg,SubPatb)
	{
		reg=(&imgurl=)(.*)?(\.jpg|\.gif)
		Contents:=regexreplace(SubPatb,reg,"$2$3")

		; msgbox,%Contents%
		list=%Contents%
		clipboard=%Contents%
	}
	sleep,100


	tooltip,downloading
	loop,parse,list,`n,`r
	{
		splitpath,a_loopfield,name
		urldownloadtofile,%a_loopfield%,%a_temp%\%name%
	}

	clipboard=%a_temp%\%name%
	sleep,100
	IfExist, %a_temp%\%name%
		{
		SoundPlay %A_Windir%\Media\Windows Navigation Start.wav
		tooltip,finished
		sleep,600
		}
	else
		{
		SoundPlay %A_Windir%\Media\Windows Error.wav
			loop,3
			{
			tooltip,Failed
			sleep,200
			tooltip
			sleep,100
			}
		; tooltip,Failed
		; sleep,200
		}
	; send ^v

	tooltip,
return

; <^f6::	;	download_clipB_url
	download_clipB_url()
return


; <^+f6::	; YOUTUBE
download_Youtube_url()
return

>^numpad1::	;	tooltip hotkey help
	; freeze_tooltip:=0
	aLL_tooltips=
	Loop, tooltips\*.txt, ,
		{
		fileread,tooltips%a_index%,%A_LoopFileFullPath%
		filereadline,tmp5,%A_LoopFileFullPath%,1
		
		tmp3:=tmp5
		aLL_tooltips .=a_index " "  tmp3 "`n"
		}
	aLL_tooltips .=	"`n`n[space to return to main menu]`nctrl or esc to close`nshift to freeze"

	again3:
	tooltips:=aLL_tooltips
	tooltip,%tooltips%
	settimer,removetooltip,-4000

again2:
	Input, SingleKey, L1 T4,  {esc}{LControl}{RControl}{LShift}{RShift}
	; clipboard:=singlekey
	; MsgBox,%SingleKey%
	; MsgBox,%ErrorLevel%
	if ErrorLevel = Timeout
	{
		;MsgBox,   the input timed out. 
		tooltip
		return
	}
	else IfInString, ErrorLevel, EndKey:
	{
		if ( (ErrorLevel = "EndKey:esc") OR (ErrorLevel = "EndKey:LControl" ) )
		{
			tooltip
			return
		}
		else if (ErrorLevel = "EndKey:LShift")
		{
			; freeze_tooltip:=!freeze_tooltip
			; if (freeze_tooltip)
			{
				sleep,500	;	prevent key bouncing
				settimer,removetooltip,off
				tooltip,%tooltips%`n`n[shift to close]
				KeyWait, shift, D 
				tooltip
			}
			; else
				; tooltip
			return
		}
	}
	else if (SingleKey = A_space)	;	space to return to main menu
	{
		goto,again3
	}
	else  
	{	
		tooltip_no:=SingleKey
		tmp_tooltip:=tooltips%tooltip_no%
		tooltips=%tooltip_no%`n%tmp_tooltip%
		tooltip,%tooltips%
		settimer,removetooltip,-4000
		goto,again2
	}

return

#IfWinActive, ahk_class DSUI:PDFXCViewer
numpadADD::	;	send,^{numpadADD}

	send,^{numpadADD}
	return
	numpadsub::	; na
	send,^{numpadsub}
return


#ifWinActive

;!9::	;make clipboard html url

  Sleep, 100
  clipurl := clipboard
  Send ^c
  Sleep, 50
  clipurl := "<a href=""" . clipurl . """>" . clipboard . "</a>"
  SendInput {Raw}%clipurl%
  clipboard := clipurl
  clipurl =;
Return



mail_cycle:
	msg:=HK_msgs%HK_cycle_id_count%
	SendInput {Raw}%msg%
return

cancelmail_cycle:	;	cancel without action
	setTimer,mail_cycle,off
	mail_cycle_active:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return

$^q::	; na
	send ^q
Return

#!t:: ; toggle_autohide_taskbar()
	toggle_autohide_taskbar()
	Return

