; http://www.cibinmathew.com
; github.com/cibinmathew

;#include C:\cbn_gits\AHK\LIB\cbn.ahk
;#include C:\cbn_gits\AHK\LIB\contextmenu.ahk
;#include C:\cbn_gits\AHK\LIB\misc functions.ahk

fileread, a,%A_ScriptDir%\! new smart run open_with1.txt
open_with_count:=1
loop,parse,a,`n,`r
{
	ext_list%a_index%:=a_loopfield
	total_open_type:=a_index
}

fileread,a,%A_ScriptDir%\! new smart run open_with2.txt
loop,parse,a,`n,`r
{
	n:=1
	open_type:=a_index
	loop,parse,a_loopfield,`,
	{
		if (fileExist(a_loopfield))
		{
			file_folder_category_open_%open_type%_%n%:=a_loopfield
			file_folder_%open_type%_max_steps:= n
			n++
		}
	}
}
tooltip_msg = Lshift: use clipB`nRShift: Copy cleaned`nSpace: next`n1text decode::`n2::smart File find`n3-4::preview

; c:\a.avi

; www.googl.com
url_tooltip_0=cancel
url_action_0=nil
n:=0
browsers=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe,C:\Program Files (x86)\Mozilla Firefox\Firefox.exe
		; open_type++
		; www.ggooo.com
loop,parse,browsers,`,
	if FileExist(a_loopfield) 
	{
		n++
		BrowserPath := a_loopfield
		splitpath,BrowserPath,,,,Browser
		url_tooltip_%n%=Open in %Browser%
		url_category_open_%n%=Open in %Browser%
		url_action_%n%=Open_in_Browser
		url_category_open_1_%n%:=BrowserPath
		url_%open_type%_max_steps:= n
			
			
	}
url_max_steps:=n+1

/*
file_folder_max_steps:=4
file_folder_tooltip_0=cancel
file_folder_action_0=nil
file_folder_tooltip_1=select in opus
file_folder_action_1=open_in_opus
file_folder_tooltip_2=open sel file in sublime
file_folder_action_2=sel_file_in_Npp
file_folder_tooltip_3=n++
file_folder_action_3=nil
*/

HotkeySTEP87:=0
smart_text_cycle:=0

show_preview:=0
smart_run_HK_active:=0
gui_number := 7
gui,%gui_number%: +resize +alwaysontop
gui,%gui_number%: add, button,x10 y5 w100 h30 ghold,HOLD
gui,%gui_number%: add, button, x10 y+2 w100 h30 ,exit
gui,%gui_number%: add, edit, x10 y+2 w300 h250 vtext_data_edit 


smart_run_open(fullfilepath)
{	
; /cygdrive/c/cbn_gits/AHK
	global
	fullfilepath := linux_to_windows(fullfilepath)
	; msgbox,%fullfilepath%
	selText_raw:=fullfilepath
	shift_enter_trigger:=0
	gosub,smart_check
	return

; C:\cbn_gits\AHK\LIB\misc functions.ahk
smart_check:
	smart_run_HK_active:=1

	; selText_raw:=get_selected_filepath()
	trigger_from_explorer:=1	; opening from explorer
	if (selText_raw="" )
	{
	; msgbox,=%selText_raw%==
		; if !(HotkeySTEP87)
			selText_raw:=Get_Selected_Text()
			trigger_from_explorer:=0
	}
	selText:=selText_raw
	gosub,smart_run
	; msgbox
wait_for_123:
	if (shift_enter_trigger)
	{
		gosub,smart_run
		return
	}
	else
		Input, UserInput, T2 L1 C,{Enter}{space}{esc}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause},1,2,3,4
	if (ErrorLevel = "Max")
	{
		; MsgBox, You entered "%UserInput%", which is the maximum length of text.
		return
	}
	if (ErrorLevel = "Timeout")
	{
		CoordMode, ToolTip, Screen
		MouseGetPos, xpos, ypos
		y_pos:=ypos-30
		tooltip,Timeout,,%y_pos%,2
		settimer,removetooltip2,-250
		if (smart_run_HK_active)
			goto,wait_for_123
		return
	}
	if (ErrorLevel = "NewInput")
		return
	else If InStr(ErrorLevel, "EndKey:space")
	{
		gosub,smart_run
		goto,wait_for_123
	}
	else If InStr(ErrorLevel, "EndKey:")
	{
		tooltip,terminated  %ErrorLevel%.
		If InStr(ErrorLevel, "EndKey:Esc")
		{
			; msgbox,esc
		}
		else If InStr(ErrorLevel, "EndKey:Rshift")
		{
			; tooltip,copying
			; sleep,200
			; tooltip
			clipboard:=selText
		}
		else If (InStr(ErrorLevel, "EndKey:Lshift")) 
		{
			selText:=clipboard
			HotkeySTEP87:=0
			gosub,smart_run
			goto,wait_for_123
		}
		gosub,cancelHotkeySTEP87
		sleep,300
		tooltip
		stringreplace,thiskey,ErrorLevel,EndKey:
		send, {%thiskey%}
		return
	}
	
	if (UserInput = "1") ; smart text decoding
	{
		gosub,run2
		goto,wait_for_123
	}
	else if (UserInput = "2")
	{
		goto,smart_find_file
		; gosub,smart_run
	}
	else if (UserInput = "3")
	{	
		show_preview_direction:=1
		gosub,show_preview
		goto,wait_for_123
	}
	else if (UserInput = "4")
	{	
		show_preview_direction:=-1
		gosub,show_preview
		goto,wait_for_123
	}
	keywait,``
Return



smart_run:

if !(HotkeySTEP87)
	{
		if (selText= )
			return
		selText := clean_filepath_string(selText)
		smart_check_count:=1
		type := "no_Match"
		run_entry_offset:=0
		open_type:=1
		; ("f:\cbn\AHK")
		; #include LIB\cbn.ahk
		; www.google.com
		; C:\cbn_gits\AHK\tips.txt
		; C:\users\%a_username%\Downloads\541949343_Jul2015.pdf
		again3:
		type:=determine_text(selText)

		; msgbox,%type%
		if ( type = "relative_path" )
		{
			SetTitleMatchMode, 2
			ifWinActive, - Notepad++
			{
				WinGetActiveTitle , Title
				StringTrimRight, Script, Title, 12
			}
			else ifWinActive, - Sublime Text (UNREGISTERED)
			{
				WinGetActiveTitle , Title
				StringTrimRight, Script, Title, 30
			}
			splitpath, script, , outdir
			selText := outdir . "\" . selText
			type = file_folder
			gosub, find_open_with_list
			
		}
		if ( type = "file_folder" )
		{		
			gosub, find_open_with_list
			run_entry_offset := from_explorer_offset
		}
		; tooltip, type = %type% %selText%
		; sleep,2000
		if ( type = "no_Match" OR type = "numbers")
		{
			; try to clean and check again twice
			if ( smart_check_count=1 ) 
			{
				tooltip, no_Match
				sleep,500
				tooltip,Retry %smart_check_count%`n%tooltip_msg%
				sleep,1000
				selText := RegExReplace(selText, "^(.*)?(\w:|/)(.*)","$2$3")	
			}
			else if ( smart_check_count = 2 )
			{
				tooltip,Retry %smart_check_count%`n%tooltip_msg%
				sleep,1000
				selText := RegExReplace(selText,"(^\s+)|(\s+$)|""","")
			}
			else if ( smart_check_count = 3 )
			{
				tooltip,Retry %smart_check_count%`n%tooltip_msg%
				sleep,1000
				selText := RegExReplace(selText,"(^#include)","")
			}
			else ; no match found even after cleaning
			{
				; msgbox, type = %type% %selText%`n%smart_check_count%
				%type%_action_1=nil
				%type%_max_steps:=2
				; tooltip, No match
				; sleep,500
				; tooltip
				; return
			}
			if (smart_check_count<3)
			{
				smart_check_count++
				goto,again3
			}
		}
		; if (type ="no_Match" )
			; return
		HotkeySTEP87_count:=1
		; msgbox,%type% 
	}
	; a:= %type%_max_steps
	; tooltip,%type% max = %a%,300,,6
	; C:\cbn.txt
	; http://127.8.9.89/d
	
	/* a:=%type%_max_steps
tooltip,%selText_raw%`n%selText%`ntype= %type% %type%_max_steps=%a%
sleep,2000
 */
	
	if ( HotkeySTEP87_count < %type%_max_steps )
	{
		action:=%type%_action_%HotkeySTEP87_count%
	; tooltip,action=%type%_action_%HotkeySTEP87_count%=%action%,300,,5
		tmp_n:=%type%_max_steps-1
		tmp_msg=%HotkeySTEP87_count%/%tmp_n%. %type% ( %selText% )`n%action%
		n:=HotkeySTEP87_count-run_entry_offset
		if (action="Open_in_Browser")
		{
			BrowserPath := open_with_program
			; open_type:=14
			BrowserPath := %type%_category_open_1_%n%
		}
		else if (action="open_with")
		{
		}
		; tooltip,%type%_category_open_%open_type%_%n%,,,5
		
		splitpath,%type%_category_open_%open_type%_%n%,open_with_program
		tmp_msg .= " " . open_with_program 
	
	}
	else
	{
		HotkeySTEP87_count:=0
		tmp_msg=CANCEL
		action=nil
	}
	CoordMode, ToolTip, Screen
	MouseGetPos, xpos, ypos
	y_pos:=ypos-5
	; tooltip,Timeout,,%y_pos%,2
		
	tooltip,%tmp_msg%`n%tooltip_msg%,,%y_pos%
	HotkeySTEP87_count++
	HotkeySTEP87:=1
	setTimer, HotkeySTEP87, 70

	; tooltip,run1 finished
	; sleep,500

return


HotkeySTEP87:

	GetKeyState,state,VKC0sc029,P
	GetKeyState,state_s,shift
	; tooltip,ErrorLevel=%ErrorLevel% state=%state% state_s=%state_s%
	If ( state= "D" OR  state_s = "D")
	{
	
	}
	else If ( state= "U" )
	{	
		cycle_count:=HotkeySTEP87_count-1
		; action:=%type%_action_%cycle_count%
		gosub,cancelHotkeySTEP87
		SendEvent, {esc}  ; to Cancel input monitoring
		gosub,%action%
	}

return
	
cancelHotkeySTEP87:	;	cancel without action
	setTimer,HotkeySTEP87,off
	HotkeySTEP87:=0
	smart_run_HK_active:=0
	show_preview:=0
	settimer,removetooltip,-1000
	; hotkey,^q,off
		
return
	
; removetooltip:
	settimer ,removetooltip,off
	tooltip
return
removetooltip2:
	settimer ,removetooltip2,off
	tooltip,,,,2
return

open_in_explorer:
	FileFullpaths:=selText
	menuEvent_function("openInExplorer",FileFullpaths)
	return
	
open_in_opus:
	FileFullpaths:=selText
	lines=0
	Loop, Parse, FileFullpaths, `n,`r
		lines++
	if (lines<2)
	{
		; IFExist %FileFullpaths%
		{			  
			menuEvent_function("OpenIfFolder_SelectIfFile",FileFullpaths)
		}
	}
	else
	{
		menuEvent_function("openInDopusColl",FileFullpaths)
	}	
return

nil:
	tooltip,nil
	sleep,800
	tooltip
return

sel_file_in_Npp:
	file=%selText%
	file:=regexreplace(file,"(^\s+)|(\s+$)|""","")	
	menuEvent_function("N++",file)

return

Open_in_Browser:

	Run %BrowserPath% %selText%
	return


run2:
	if !(HotkeySTEP87)
		selText:=Get_Selected_Text()
	else
		gosub,cancelHotkeySTEP87
	; HotkeySTEP87:=0
	goto,smart_text_decoding
return

smart_text_decoding:
; 125$
if !(smart_text_cycle)
	{
		if (selText= )
			return		
		smart_text_cycle_count:=1
		gui,%gui_number%: Color, ffffff
	}
	if ( smart_text_cycle_count =1 )
	{
		text_data=
		msg=smart_text_decoding
		gosub,currency_conversion
		text_data .= "`n______________________________"
		gosub, text_statistics
		text_data .= "`n______________________________"
		; if matches a date, display the day
		; if an expression display result

		gosub,check_selText
		tooltip,%msg%`n%text_data%
	}
	else if ( smart_text_cycle_count =2 )
	{
		msg=GUI
		MouseGetPos, xpos, ypos
		tooltip
		hold:=0
		gui,%gui_number%: show, x%xpos% y%ypos%,NoActivate
		GuiControl, %gui_number%:, text_data_edit ,%text_data%
	}
	else
	{
		if (!hold)
			gui,%gui_number%: hide
		smart_text_cycle_count:=0
		msg=cancel
		tooltip,%smart_text_cycle_count% %msg%
	}
	
	smart_text_cycle_count++
	smart_text_cycle:=1
	setTimer, smart_text_cycle, 70

return

smart_text_cycle:	;	cancel checking status of ctrl key
; vkC0sc029
	GetKeyState,state,VKC0sc029,P
	GetKeyState,state_s,shift
	; tooltip,%state%
	; sleep,500
	If ( state= "U" )
	{	
		n:=smart_text_cycle_count-1
		action:=%type%_action_%n%
		; tooltip, %n% cancelled`na=%action%
		; sleep,1000
		gosub,cancelsmart_text_cycle
		; gosub,%action%
	}	
return	

cancelsmart_text_cycle:	;	cancel without action

	setTimer,smart_text_cycle,off
	smart_text_cycle:=0
	if (!hold)
		gui,%gui_number%: hide
	settimer,removetooltip,-1000

return



currency_conversion:
	dollar_rate:=62
	pound_rate:=92
	Contents:=selText
	reg=\$$|^\$
	if ( RegExMatch(Contents, reg) )
	{
		prefix=$
	}
	else
		prefix=

	;	cleaning unwanted
	Contents:=regexreplace(Contents,"\n\r", "")
	Contents:=regexreplace(Contents,"`,", "")
	; Contents:=regexreplace(Contents,"\$", "")
	Contents:=regexreplace(Contents,"[^\d\.]", "$1")
	if regexmatch(Contents,"[\d`,]+")
	{
		; msgbox, %contents%
		r:=Contents*dollar_rate
		p:=Contents*pound_rate
		r:=Round(r,2)		
		p:=Round(p,2)		
			text_data .= "`n" . prefix . Contents . " = Rs " . r . "`t[" . dollar_rate . "]`nif pounds " . p
	}
return

text_statistics:

If selText is space   
   return
   
             
	len:=StrLen(selText)
	Spaces=
	newline:=0
	chars=
	Tabs=
	Loop, Parse, seltext, `n
			newline++
	Loop, Parse, seltext
		{
			If A_loopField=%A_Space%
					Spaces++
			If A_loopField=%A_Tab%
					tabs++
		}

	If tabs=
			tabs:=0
	If Spaces=
			Spaces:=0

	chars:= len-Spaces-tabs
	tooltip2=Length: %len%`nSpaces/words: %spaces%`nTabs: %Tabs%`nCharacters: %chars%`nLines: %newline%
	text_data .= "`n`n" . tooltip2
	; keywait, Lbutton, D ,t5
	 
	; tooltip

	
	; 2,3
Return

check_selText:
; ratio checking
if (selText=clipboard)
	{
		if (regexmatch(seltext,clipboard))
			text_data .= "`n`ncase also EQUAL to clipb"
		else
			text_data .= "`n`ncaseless EQUAL to clipb"
	}
else
	{
		text_data .= "`n`nNOT EQUAL to clipb. sel Text=" . StrLen(seltext) . " clipb len= " . StrLen(clipboard)
		text_data .= "`n______________________________" 
	}
	if RegExMatch(selText, "(\d+)([x,/])(\d+)")
	{
		a:= regexreplace(selText,"i)(\d+).(\d+)","$1")
		b:= regexreplace(selText,"(\d+)([x,/])(\d+)","$3")
		c:= a/b
		text_data .= "`n`n" . a . " / " . b . "=" . c 

	}
	calculator:
	calculator_mode:=0
		; calculator	
; 2+3
	reg=[a-zA-Z_]	;	include invalid math symbols
	; if ( !RegExMatch(selText, reg) )
	; {
		if selText contains +,-,*,/,`%	; %
		 {
			; it is an expression
			if selText contains 1,2,3,4,5,6,7,8,9,0
			{
		
				; reg=\D+$	;	remove trailing operators like 12+5+ or 2*(
				reg=([/\+\*\(-])+$
				expression1:=selText
				if ( RegExMatch(selText, reg) )
				{
					expression1:=RegExreplace(selText, reg)
					msgbox,%expression1%
				
					;	add closing bracket automatically
					right_paranthesis=0
					left_paranthesis=0
					loop,parse,expression1,
					{
						if a_loopfield=(
							left_paranthesis++
						else if a_loopfield=)
							right_paranthesis++
					}
					if (left_paranthesis-right_paranthesis=1)
						expression1 .= ")"	;	append ) automatically
					
					tmpfile = %A_temp%\$temp$.ahk             ; any unused filename
					; tmpfile = C:\$temp$.ahk           ; any unused filename ; use C:\
					
					FileDelete %tmpfile%             ; delete old temporary file -> write new
					FileAppend #SingleInstance Force`n#ErrorStdOut`n#NoTrayIcon`nFileDelete %tmpfile%`nFileAppend `% %expression1%`, %tmpfile%, %tmpfile%
					RunWait %A_AhkPath% %tmpfile%    ; run AHK to execute temp script, evaluate expression %
					FileRead Result, %tmpfile%       ; get result
					FileDelete %tmpfile%
								
					floor_value:=floor(result)
					dec_value:=result-floor_value
					stringreplace,dec_value,dec_value,0.
					dec_value:=regexreplace(dec_value,"([^0])?0(0)+$","$10")
					compact_result:=regexreplace(result,"\.(.*?)0*$",".$1")

					; msgbox,%dec_value%
					result_tooltip=
					tmp_n:=3	; for thoudands  grouping 3,2,2,2.....
					while (StrLen(floor_value)>0)
					{
						StringRight, OutputVar, floor_value, %tmp_n% 
						StringTrimRight, floor_value, floor_value, %tmp_n% 
						result_tooltip=%OutputVar% %result_tooltip% 
						if (tmp_n=3)
							tmp_n:=2
					}
					result_tooltip=%result_tooltip%.%dec_value%
					text_data .= "`n`ncalc: " . expression1 . "= " . result_tooltip
				
				}
		}
	}
; 127.101.056
; binary decimal 2.3 101.100
if (regexmatch(seltext,"^[01\.]+$"))
{
	a=
	loop,parse,selText,.
	{
		x:=a_loopfield
		r=
		b:=StrLen(x),r:=0
		loop,parse,x
			r|=A_LoopField<<--b

		a.= r . "."
	}
	StringTrimRight, a, a, 1
	text_data .= "`n`nbinary to decimal= " . a
}
if (regexmatch(seltext,"^[\d\.]+$"))
{
	a=
	loop,parse,selText,.
	{	
		r=
		x:=a_loopfield
		; msgbox,%x%
		while x
		{
			r:=1&x r,x>>=1
		}
		a.= r . "."
	}
	StringTrimRight, a, a, 1
/*
*/
	text_data .= "`ndecimal to binary= " . a
}
return

hold:
	hold:=1
	gui,%gui_number%: Color, ffdddd
return


find_open_with_list:

If InStr( FileExist(selText), "D" )
{
	%type%_action_1=open_in_opus
	%type%_action_2=open_in_explorer
	%type%_max_steps:=3
}
else
{
	open_type:=1
	SplitPath, selText , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	loop, %total_open_type%
	{
		tmp_txt:=ext_list%a_index%
		if OutExtension in %tmp_txt%
			open_type:=a_index
	}
	%type%_max_steps:=%type%_%open_type%_max_steps + 2
	n:=%type%_max_steps
	; msgbox,%n%
	if (trigger_from_explorer)
	{
		from_explorer_offset:=0	
		explorer_option:=n+1
		; open_with_program%explorer_option%:= %type%_category_open_%open_type%_%open_with_count%
	}
	else
	{
		from_explorer_offset:=1	;	first action is default
		explorer_option:=1
	}
	; open_with_program1:= %type%_category_open_%open_type%_%open_with_count%
	%type%_action_%explorer_option%=open_in_opus
	;tmpvar3=%type%_action_%explorer_option%
	;tmpvar2:=%type%_action_%explorer_option%
	; msgbox, last %explorer_option%.%tmpvar2% tot=%n%+1`n%tmpvar3%
	; C:\cbn_gits\AHK\! new smart run.ahk

	loop,%n% {
		a:=a_index+from_explorer_offset
		%type%_action_%a%=open_with
		; msgbox,%a%
	}
	;d=
	;tmpvar:=n+1
	; msgbox, last %explorer_option%.%tmpvar2% tot=%n%+1
	;loop,%tmpvar% {
		;a:=a_index+from_explorer_offset
		; %type%_action_%a%=open_with
		;b=%type%_action_%a%
		;c:=b
		;e:= %type%_category_open_%open_type%_%a%
		;d .= b . "=" . c . " " . %c% . e . "`n" 
	;}
		; msgbox,tot=%tmpvar%`n%d%`nexplorer_option=%explorer_option%
/*	
	if !FileExist(open_with_program1)
		{
			tooltip,specified program not exists So default open
			sleep,150
			setTimer,removetooltip,500
			%type%_action_1=default_run
		}
*/
	; tooltip, total=%n%+1 line=%open_type% with=|%open_with_program1%| count=%open_with_count%
	; sleep,500
}
return

; C:\cbn_gits\AHK\tips.txt

open_with:
	n:=cycle_count-from_explorer_offset
	open_with_pgm:= %type%_category_open_%open_type%_%n%
	; msgbox,n=%n% "%open_with_pgm%" "%selText%"
	if !fileExist(selText)
	{
		tooltip,file not found
		setTimer,removetooltip,800
	}
	else
	{
		stringright,pgm,open_with_pgm,15
		if (pgm=="emacsclient.exe")
			args:="-n"
			; prevent the cmd window from waiting
		else
			args=
		;msgbox,"%open_with_pgm%" "%selText%" %args%
		run,"%open_with_pgm%" "%selText%" %args%
		update_recently_used_files(selText)
	
	}
return
default_run:
	run, "%selText%"
	update_recently_used_files(selText)
return


smart_find_file:
	selText:=Get_Selected_Text()
	filepath:=selText
	; selText=temp.ahk
	type:=determine_text(selText)
	if ( type = "file_folder" )
	{
	}
	else ; if ( type = "relative_path" )
	{
		SetTitleMatchMode, 2
		ifWinActive, - Notepad++
		{
			WinGetActiveTitle , Title
			StringTrimRight, Script, Title, 12
			stringreplace, Script, Script, *,
			msgbox,%script%
		}
		else ifWinActive, - Sublime Text (UNREGISTERED)
		{
			WinGetActiveTitle , Title
			StringTrimRight, Script, Title, 30
		}
		paths_to_check:= script . "`n" last_opened_file
		; msgbox,%paths_to_check%
		loop,parse,paths_to_check,`n,`r
		{
			splitpath, a_loopfield, , outdir
			filepath := outdir . "\" . selText
			; tooltip,%filepath%
			; sleep,500
			stop:=0
			found:=0
			timeout_count := 0
			while !(stop)
			{
				timeout_count++
				if (timeout_count>10)
				{
					found:=0
					stop:=1	
				}
				ifnotexist,%filepath%
				{
					splitpath, outdir, , outdir
					filepath := outdir . "\" . selText
					if (outdir="")
						stop:=1
				}
				Else
				{
					found:=1
					stop:=1			
				}
			}
			if (found)
				break			
		}
	}
	; msgbox
	ifexist,%filepath%
	{
		type= file_folder
		last_opened_file:= filepath
		ToolTip, %filepath%
		Sleep,700
		SetTimer, removetooltip, 800
		menuEvent_function("N++",filepath)
	}
	else
	{
		tooltip,not found
		settimer,removetooltip,1000
	}
return	

; C:\cbn_gits\AHK\tips.txt

show_preview:

	; msgbox, %file%
	if !(show_preview)
	{
		action=nil
		files_count:=0
		all_files =
		splitpath,selText,,outdir,this_FileExt

		Loop, %outdir%\*.*, ,
		{
			if A_LoopFileExt not in txt,ini,c,java,py,ahk,%this_FileExt%
				continue
			files_count++
			all_files .= A_LoopFileFullPath . "`n"
			if (A_LoopFileFullPath=selText)
				show_preview_count:=files_count-1 ; to compensate for the increment done later
			;melse
				; show_preview_count:=0
		}
		stringsplit,all_files,all_files,`n,`r
		show_preview:=1
	}
	; C:\cbn_gits\AHK\LIB\misc functions.ahk
	show_preview_count +=show_preview_direction
	show_preview_count := reset_counter_if_out_of_bound(show_preview_count,0,files_count,show_preview_direction)
	 ;msgbox,%A_LoopFileFullPath%`n%selText% %show_preview_count%/%files_count%. %file_name%`n%all_files%
	; if (show_preview_direction)
	; {
		; if ( show_preview_count > files_count )
		; {
			; show_preview_count:=0
			; msg=CANCEL
		; }
	; }
	; else
	; {
		; if ( show_preview_count >=0 )
		; {
			; show_preview_count:=files_count
			; msg=CANCEL
		; }
	; }
	HotkeySTEP87_count:=1
	file:=all_files%show_preview_count%
	; selText:=file ; actions will be applied on new file only
	;file := selText
	fileread,tmp_text,%file%
	FileGetSize, FileSize, %file%,k
	splitpath,file,file_name
	; if (FileSize > 1000)
	if (tmp_text= "")
		msg=%show_preview_count%/%files_count%. %file_name% (%FileSize% kB) %file%`n======`nEMPTY
	else
	{
		tmp_text2:= truncated_text(tmp_text,1000,25)
		msg=Space: open in n++`n%show_preview_count%/%files_count%. %file_name% (%FileSize% kB) %file%`n======`n%tmp_text2%
	}
	sleep,200
	CoordMode, ToolTip, Screen
	MouseGetPos, xpos, ypos
	y_pos:=ypos-30
	tooltip,%msg%,,%y_pos%
	settimer,removetooltip,3000

return
}
