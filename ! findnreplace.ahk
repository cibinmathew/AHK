; http://www.cibinmathew.com
; github.com/cibinmathew

#SingleInstance, Force
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk
HotkeySTEP29_active := 0
#include C:\cbn_gits\AHK\LIB\HK_cycle.ahk
menu, Tray, Icon, Shell32.dll, 89
HotkeySTEP29_count := 0
ReplacementCount := 0

Gui,11: +AlwaysOnTop  +border +toolwindow -caption +LastFound   
Gui,11: font,s12
gui,11: add,text, x10 y5 h20 w250 vstats1, count: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gui,11: add,text, x+10 yp h20 w300, >+enter:: feedback
gui,11: add,Edit, x10 y+0 w200 h30 Multi hWndEd1 vfindtext gpreview
; Gui,11: font,s10
gui,11: add,Edit, x+0 yp w100 h30 Multi hWndEd2 vreplacetext gpreview2
gui,11: add,Edit, x+0 yp w100 h30 Multi vreplacetext2 gextract
; gui,11: add,text, x+0 yp h20 w300 vstatustext,ack
; gui,11: add,button, x10 y+10 w400 h25 gextract,extract
gui,11: add,button, x10 y+10 w400 h25 gfindreplace, Ok
gui,11: add,button, x10 y+10 w400 h25 gcopynclose, copynclose
Gui,11: font, s10
gui,11: add,Edit,x10 y+0 w200 h150 T8 vedit3 -wrap gpreview,
gui,11: add,Edit,x+0 yp w200 h150 T8 vedit4 -wrap gpreview,
gui,11: add,text,x10 y+0 w400 vstats2 cgreen, count: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Placeholder(Ed1, "Enter some text")
Placeholder(Ed2, "Enter some text")
hotkey,esc,off
text=
config =
(
findreplace,1 to many (* to Many),Nth to Nth
,
pre_disp_gui,1toMany,NthToNth
,
disp_gui,
,
,,
,
)

HK_cycle_register("<^!o","Control_launcher_HK",4,4000,"LCtrl", "$^q",config) 
return


>!p::	; findreplace
	settimer , cancelHotkeySTEP29,off	
	if !(HotkeySTEP29_active)	;	if hotkey is currently not in cycle mode 
	{
		HotkeySTEP29_count:=0
		selText := Get_Selected_Text_fast()
		guicontrol,11:,edit3,%selText%
		; msgbox,%selText%		
	}

	if (HotkeySTEP29_count=0)
	{	

		HotkeySTEP29_count++
		msg=findreplace
		settimer,removetooltip,-3600
		tooltip,%HotkeySTEP29_count% %msg%
		settimer,cancelHotkeySTEP29,-3500	
		HotkeySTEP29_action = nil
	}
	else if (HotkeySTEP29_count=1)
	{	

		HotkeySTEP29_count++
		msg=1toMany ( * to many)
		settimer,removetooltip,-3600
		tooltip,%HotkeySTEP29_count% %msg%
		gosub, 1toMany	
		tooltip,%HotkeySTEP29_count% %msg%`n%output%

		settimer,cancelHotkeySTEP29,-3500	
		; HotkeySTEP29_action = 1toMany	
	}
	else if (HotkeySTEP29_count=2)
	{	

		HotkeySTEP29_count++
		msg=NthToNth
		settimer,removetooltip,-3600
		tooltip,%HotkeySTEP29_count% %msg%
		gosub, NthToNth	
		tooltip,%HotkeySTEP29_count% %msg%`n%output%

		settimer,cancelHotkeySTEP29,-3500	
	}
	else if (HotkeySTEP29_count=3)
	{	

		HotkeySTEP29_count++
		msg=step4
		settimer,removetooltip,-3600
		tooltip,%HotkeySTEP29_count% %msg%
		settimer,cancelHotkeySTEP29,-3500	
		HotkeySTEP29_action = nil	
	}
	else
	{	

		HotkeySTEP29_count:=0
		msg=cancel
		settimer,removetooltip,-1600
		tooltip,%HotkeySTEP29_count% %msg%
		settimer,cancelHotkeySTEP29,-1500		
	}
	
	HotkeySTEP29_active:=1
	hotkey,^q,on
	setTimer,HotkeySTEP29,70
	sleep,10
return


HotkeySTEP29:	;	cancel checking status of ctrl key
	GetKeyState,state,ALT
	If state=u
	{
		gosub,cancelHotkeySTEP29
		if (HotkeySTEP29_count = 0)
		{	
			settimer,removetooltip,-1500
			tooltip,%HotkeySTEP29_count% cancelled
			
		}
		else if (HotkeySTEP29_count=1)
		{
		
			; gosub,%HotkeySTEP29_action%
			replaced_count=0
			selText:=Get_Selected_Text()
			gui, 11: Show,w413, findreplace.ahk
			hotkey, esc, on
			GuiControl, 11:focus, findtext
			GuiControl, 11:, findtext,*
			GuiControl, 11:, replacetext,*
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%
			; t1:=no_of_lines(selText)	
			; t2:=no_of_lines(selText,0)
			gosub,preview
			; guicontrol, 11:, stats1, replaced:%ReplacementCount%text lines:%t2%  tot:%t1%

		}
		else if ((HotkeySTEP29_count=2) or (HotkeySTEP29_count=3))
		{	
			gosub,%HotkeySTEP29_action%
			setTimer,removetooltip,-2500
			text:=truncated_text(output,420)
			tooltip,%text%
			clipboard:=output
		}
		else if (HotkeySTEP29_count=4)
		{
			gosub,%HotkeySTEP29_action%
		}

	}
	return

cancelHotkeySTEP29:	;	cancel without action
	setTimer,HotkeySTEP29,off
	HotkeySTEP29_active:=0
	; tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return


$^q::	; na
	send ^q
Return

nil:
return

pre_disp_gui:
	selText := Get_Selected_Text_fast()
	guicontrol,11:,edit3,%selText%
	Return

disp_gui:
	replaced_count=0
	selText:=Get_Selected_Text()
	gui, 11: Show,w413, findreplace.ahk
	hotkey, esc, on
	GuiControl, 11:focus, findtext
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%
	; t1:=no_of_lines(selText)	
	; t2:=no_of_lines(selText,0)
	gosub,preview
	return


1toMany:
	newlines1:=0
	newlines2:=0
	selText:=Get_Selected_Text()
	if (selText = )
		selText:=prev_output
	find_string:="*1"
	selText:=regexreplace(selText,"im)\*$","*1")
	selText:=regexreplace(selText,"im)\*([\D])","*1$1")
	; replace * to *1
	loop,5 ; to find the next *n to be replaced
	{
		ifinstring,selText,*%a_index%	
		{
			find_string=*%a_index%	
			break
		}
	}
	output=
	text2 :=clipboard
	Loop, Parse, text2,`n,`r
		newlines1++
	Loop, Parse, selText,`n,`r
		newlines2++
	if ( newlines1>newlines2)
		total_items:=newlines1
	else
		total_items:=newlines2
	if ( newlines2=1)
	{

		loop, parse, text2,`n,`r
		{
			stringreplace,text,selText,%find_string%,%A_LoopField%, all
			
			output .= text . "`n"
		}
	}
	else
	{
		text:=selText
		loop, parse, text2,`n,`r
		{
			; tmp_text_%a_index%:=a_loopfield
			stringreplace,text,text,%find_string%,%A_LoopField%
		}
		output :=text
	}
	prev_output:=output
return

; http://127.0.0.1:5000/collec_
findreplace:
	gui,11: submit
	clipboard:= text
	; settimer,preview,off
	tooltip,
	; send,^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	gosub,hide
return

copynclose:
	gui,11: submit
	clipboard:= text
	gosub,hide
return

#IfWinActive, findreplace.ahk

$enter::	; na
	ControlGetFocus, OutputVar 
	If (OutputVar = "edit1" OR OutputVar = "edit2"  )
		gosub,findreplace
	else
		send, {enter}
return

>+enter::	; na
	gui,11: submit,nohide
	guicontrol,11:,edit3,%edit4%
	guicontrol,11:,edit2,
	GuiControl, 11:focus, findtext
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	; preselects the text
return

#IfWinActive

extract:
	gui,11: submit,nohide
	GuiControl, 11:, replacetext,

	findtext2 := regexreplace(findtext, "([\.\?\+\[\{\|\(\)\^\$])","\$1")
	stringreplace, findtext2, findtext2, *, (.*), all
	text = 
	loop, parse, edit3, `n, `r
	{
		if regexmatch( a_loopfield, findtext2, match)
			text .= match . "`n"
	}
	; guicontrol, 11:, edit3, %text%
	text := replace( text, findtext, replacetext2 )
	guicontrol, 11:, edit4, %text%
return

preview2:
	GuiControl, 11:, replacetext2
preview:
	gui,11: submit,nohide
	text := replace(edit3, findtext, replacetext)	

	; tmptxt:=truncated_text(text,600)
	; coordmode,tooltip,window
	; tooltip,%tmptxt%,395,65,2
	; guicontrol,11:,edit3,%selText%
	guicontrol, 11:, edit4, %text%
	
return

replace(text, findtext, replacetext)
{

	global ReplacementCount, stats1, stats2
	t1:=no_of_lines(text)	
	t2:=no_of_lines(text,0)	
	if ( text="")
	{
		tooltip,EMPTY
	}
	else
	{
		if (findtext="")
		{
			findtext =*
			GuiControl,  , findtext, *
		}
		; findtext := regex_safe_escape(findtext)
		if findtext=*
			stringreplace,findtext,findtext,*,^(.*)$
		else
			stringreplace,findtext,findtext,*,(.*),all
	;	msgbox,%findtext%
		; a=
		Loop
		{
			StringReplace, replacetext, replacetext, *,$%a_index%
			ifnotinstring, replacetext, *
				break
		}
		; replacetext := a
		; reg=im`a)%findtext%
		reg=im)(*ANYCRLF)%findtext%
		text:= RegExReplace(text, reg, replacetext, ReplacementCount) 
	}

	guicontrol, 11: , stats1,replaced:%ReplacementCount% lines:%t2% tot:%t1%
	guicontrol, 11: , stats2,%reg% -> %replacetext%
	if ( ReplacementCount=0)
	{
		gui,11: font,cGreen
	}
	else
	{
		gui,11: font,cRed
	}
	guicontrol,11: font ,stats1
; msgbox,%text%
return	text

}
	
esc::	; na
	gosub,hide
return

hide:
	gui,11: hide
	settimer,removetooltip2,-100
	settimer,removetooltip,-100
	hotkey,esc,off
return

removetooltip:
	settimer ,removetooltip,off
	tooltip

removetooltip2:
	settimer ,removetooltip2,off
	tooltip,,,,2
return

NthToNth:
	selText := Get_Selected_Text()
	if (selText = )
		selText:=prev_output
	selText:=regexreplace(selText,"im)\*([\D])","*1$1")
	selText:=regexreplace(selText,"im)\*$","*1")


	source := selText	
	output =
	text2 := clipboard
	loop, 8
	{
		field%a_index%=
	}
	{
		field1:=regexreplace(text2,"\n*$","") ; remove  
		field2:=regexreplace(edit5,"\n*$","") ; remove  
		field3:=regexreplace(edit6,"\n*$","") ; remove  
		field4:=regexreplace(edit7,"\n*$","") ; remove  
		field5:=regexreplace(edit8,"\n*$","") ; remove 
		field6:=regexreplace(edit9,"\n*$","") ; remove 
		field7:=regexreplace(edit10,"\n*$","") ; remove 
		field8:=regexreplace(edit11,"\n*$","") ; remove
	}	
	if ( !(InStr( source, "*")) )	;no replacements %
	{
		
		tooltip, no markers ( * # `% @ & $)
		settimer,removetooltip,-1400
		
	  return
	}

loop,parse,	text2,`n,`r
{
	limit:=a_index
}

/*
loop, parse, edit5,`n,`r
{
	limit2 := a_index
}

if ( limit2 > limit )
	limit := limit2
	guicontrol,,limit,%limit%
	loop, 8
	{
		find%a_index%=`*%a_index%
		n:=a_index
		Loop, %limit%
		{
			field%n%Lines%a_index%=
		}
		StringSplit, field%a_index%Lines, field%a_index%,`n,`r
	}
*/

	StringSplit, field1Lines, field1,`n,`r
	count=0
	output=
	Loop, %limit%
	{
		text:=source
		count++
		n:=a_index
		repwith1:=field1Lines%n%
		a:=`*1
		b:=repwith1
		StringReplace,text,text, *1,%b%,all		
		output .= text . "`n"		
	}
	prev_output:=output
return

