; http://www.cibinmathew.com
; github.com/cibinmathew

SplitPath, A_ScriptDir , , , , , A_Script_Drive
#SingleInstance Force
#include C:\cbn_gits\AHK\LIB\json.ahk
#include C:\cbn_gits\AHK\LIB\para.ahk
#include C:\cbn_gits\AHK\LIB\more_functions.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
#include C:\cbn_gits\AHK\LIB\google desc.ahk
#include C:\cbn_gits\AHK\LIB\contextmenu.ahk
#include C:\cbn_gits\AHK\LIB\edit.ahk
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk
; #include C:\cbn_gits\AHK\LIB\LVCustomColors.ahk
text_changed :=0 
HotkeySTEP88_count := 0
HotkeySTEP88:=0
hotkey,^q,off	;	start disabled

#MaxMem 200
SetBatchLines -1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
a_search_is_running:=0

ifexist,a.ico
	Menu, Tray, Icon,a.ico
settimer,read_searchlists_all,7200000
hold=0
gui_ON:=0
calculator_hist=

appname=SMART_SEARCH
source_Filename= ;	type of file from which match text is obtained
smart_search_commands=load_result_into_listview_continue_smart_action`nsearch_in_result`nload_result_and_search_in_result`ncopy_only_listed_in_list_view`ncopy_full_results
Gui +AlwaysOnTop  +border +LastFound +toolwindow   -caption ;	  +resize
; Gui, add, button,x2  y5 w50 h30 ghide   , x
fileread,fileContent2,smart_search_keywords.ini
keywordChoice_all=
all_keywords=
Loop, Parse, fileContent2,`n,`r
{	loop,parse,A_LoopField,=
	t%a_index%:=A_LoopField
	keywordChoice_all=%keywordChoice_all%|%t1%
	all_keywords=%all_keywords%`n%t1%
} 
; more keywords
fileread,fileContent3,smart_search_keywords_lookup_files.ini
n:=0
file_lookup_keywords=
loop,parse, filecontent3,`n,`r
{	
	loop,parse,A_LoopField,=
	l%a_index%:=A_LoopField
	n++	
	keyword_%n%:=l1
	stringreplace,l2,l2,``n,`n,all	;remove `n text to actual newline
	lookup_%n%:=l2
	keywordChoice_all=%keywordChoice_all%|%l1%
	file_lookup_keywords=%file_lookup_keywords%`n%l1%
	all_keywords=%all_keywords%`n%l1%
	all_keywords:=regexreplace(all_keywords,"^\n","")	
	file_lookup_keywords:=regexreplace(file_lookup_keywords,"^\n","")	
}
gosub,read_searchlists_all
; clipboard =%searchlists_all%
keywordChoice_all=%keywordChoice_all%|
sort,keywordChoice_all,D| U	;sort and remove duplicates
sort,all_keywords, U	;sort and remove duplicates
; msgbox, %all_keywords%

width := 1355
width2 := 305

Gui, Font, s11 ;cred ,
; Gui, Font, s14 cblack ,
; msgbox,%keywordChoice_all%
Gui,add, Edit, x2 y24 vvisibleSchStr w500 hwndEd1 +0x100 gtIncrementalSearch ,	; -WantReturn
Gui, Font, s11 cblack,
Gui, Add, combobox, x+2 yp w200 vkeywordChoice gkeyword_sel, %keywordChoice_all%
Gui, Font, s9 cblack,
Gui, add, button, x+0  y25 w30 h30 ggui_roll_Down  , +
Gui, add, button, x+5  yp w70 h30 gDefAction vAction_button1 hwndbutton1 , action
ILButton(button1, "shell32.dll:" 151, 18, 18, 5)	
Gui, add, button, x+0  yp w50 h30 gDefAction6 hwndbutton6 vAction_button6 , open line
ILButton(button6, "shell32.dll:" 151, 18, 18, 5)	
; Gui, add, button, x+0  yp w50 h30 gDefAction7 hwndbutton7 vAction_button7 , copy
ILButton(button7, "shell32.dll:" 121, 18, 18, 5)	
Gui, add, button, x+0  yp w50 h30 gDefAction2 vAction_button2 , send mail
Gui, add, button, x+0  yp w50 h30 gDefAction3 vAction_button3 , send mail
Gui, add, button, x+0  yp w50 h30 gDefAction4 vAction_button4 , send mail
Gui, add, button, x+0  yp w50 h30 gDefAction5 vAction_button5 , multi sch
Gui,add, text,x5  y2 W200 cred  vaction_term_selected,dddd dddd dddd dddd 
Gui,add,text,x+10  yp w120 cgreen vtext1
Gui,add,text,x+0  yp w50 cblue  vsource , source
Gui,add,text,x+0 yp cred vmatch2  w50, match
Gui,add,text,x+0 yp cblue vmatch_count  w20, match
Gui, Font, s11 cblack ,
Gui,Add,ListView, x2 y+40 w%width% h400  0x8 vResultList gListEvent AltSubmit     hwndList  ,1 match|2 source file path|3 match line type|4 mod time|5 source_Filename| 6 type
Gui, Add, MonthCal, x1090 y10  vDateMain  +AltSubmit ,
guicontrol,1: hide,DateMain 
Gui, Font, s10 cblack ,

Gui +LastFound
GUI_ID:=WinExist()
; Placeholder(Ed1, "Enter your search query")
show_width:=width+160
Gui,  Show, hide x100 w%show_width%,SMART_SEARCH ;h500 w800  ,%name%
Gui +LastFound
WinSet, Region, 0-26 w%show_width% H30 ;H75

CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
CustomColor = FFFFFF  ; Can be any RGB color (it will be made transparent below).
; Gui +LastFound
; Gui, Color, %CustomColor%
; WinSet, TransColor, %CustomColor% 240
Gui  +LastFound
Gui  Color, FFFFFF
setupMenu("context1")

;	icon
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.
; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

IL_Add(ImageListID1, "shell32.dll", 240)
IL_Add(ImageListID1, "shell32.dll", 201)
IL_Add(ImageListID1, "shell32.dll", 250)
IL_Add(ImageListID1, "shell32.dll", 45)
IL_Add(ImageListID1, "shell32.dll", 291)
IL_Add(ImageListID1, "shell32.dll", 75)
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int,25, Int,0x18, Int,1, Int,1 ), 1 )
;	icon
/*
LV_Change("", "ResultList",,6)
p = 0
; Loop, % LV_GetCount()/3
{	p++
	LV_SetColor(p, "", 0xF0B0F0)
	p++
	LV_SetColor(p, "", 0xA3F003)
	p++
	LV_SetColor(p, "", 0xFFF000)
}
*/
return
/*

~rctrl::	; na
if (A_PriorHotKey = "~rctrl" AND A_TimeSincePriorHotkey < 250)
{
	; selText:=Get_Selected_Text()
	; if seltext <>
	; 	guicontrol,,visibleSchStr,%selText%
	if (!gui_ON)
	{
		Gui +LastFound
		SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
		settimer,showGui_animate,-1	
	}
	WinSet, Region, 0-26 w%width2% H35 ;H75 
	gui_ON:=1
	SelectedLine=launcher
	stringreplace,keywordChoice_new,keywordChoice_all,||,|
	stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
	; msgbox,%keywordChoice_new%
	; guicontrol,,visibleSchStr,
	guicontrol,,keywordChoice,%keywordChoice_new%
	SetTimer,search,-1
	SetTimer, tIncrementalSearch, 500

	sleep,800	;	launch after N ms
	
	settimer,checkactive,800
	
}
Sleep 0
KeyWait rctrl
return

~*Rctrl::	; na
if (A_PriorHotKey = "~*Rctrl" AND A_TimeSincePriorHotkey < 400)
{
	GetKeyState, state_c, shift
	if (state_c ="D" )
	{
		selText:=Get_Selected_Text()
		; if seltext <>
			; guicontrol,,visibleSchStr,%selText%
		if (!gui_ON)
		{
			Gui +LastFound
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
			settimer,showGui_animate,-1	
		}
		WinSet, Region, 0-26 w%width2% H35 ;H75 
		gui_ON:=1
		SelectedLine=sel text
		stringreplace,keywordChoice_new,keywordChoice_all,||,|
		stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
		; msgbox,%keywordChoice_new%
		guicontrol,,visibleSchStr,
		guicontrol,,keywordChoice,%keywordChoice_new%
		SetTimer,search,-1
		SetTimer, tIncrementalSearch, 500

		sleep,800	;	launch after N ms
		
		settimer,checkactive,800
	}
}
Sleep 0
KeyWait  Rctrl
return
*/


~*Lshift::	; na
if (A_PriorHotKey = "~*Lshift" AND A_TimeSincePriorHotkey < 300)
{	
; msgbox,%A_PriorHotKey%
	GetKeyState, state_c, ctrl
	if (state_c !="D" )
	{
		if (!gui_ON)
		{
			Gui +LastFound
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
			settimer,showGui_animate,-1	
		}
		trigger_HK=clipb_text
		WinSet, Region, 0-26 w%width2% H35 ;H75 
		gui_ON:=1
		SelectedLine=smart action
		stringreplace,keywordChoice_new,keywordChoice_all,||,|
		stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
		; msgbox,%keywordChoice_new%
		; guicontrol,,visibleSchStr,
		guicontrol,1:,keywordChoice,%keywordChoice_new%
		action_term =
		guicontrol,1:,action_term_selected,%action_term%
		SetTimer,search,-1
		
		; SetTimer, tIncrementalSearch, 500

		sleep,800	;	launch after N ms
		
		settimer,checkactive,800
	}
	else
	{
	
		field_by_field_pos:=0
		; selText:=Get_Selected_Text()
		; if seltext <>
			; guicontrol,,visibleSchStr,%selText%
		if (!gui_ON)
		{
			Gui +LastFound
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
			settimer,showGui_animate,-1	
		}
		WinSet, Region, 0-26 w%width2% H35 ;H75
		gui_ON:=1		
		keyword_identified=0
		guicontrol,,keywordChoice,
		guicontrol,,keywordChoice,%keywordChoice_all%
		; Gui,  Show,	x550 y250
		SetTimer,search,-1
		SetTimer, tIncrementalSearch, 500
		sleep,800	;	launch after N ms
		settimer,checkactive,800	
	}
}
Sleep 0
; tooltip,`nsearch waiting
KeyWait lshift
return


~*Rshift::	; na
if (A_PriorHotKey = "~*Rshift" AND A_TimeSincePriorHotkey < 300)
{	
; msgbox,%A_PriorHotKey%
	GetKeyState, state_c, ctrl
 	GetKeyState, state_a, alt

  
	if (state_c !="D" and state_a!="D")
	{
		field_by_field_pos:=0
		; selText:=Get_Selected_Text()
		; if seltext <>
			; guicontrol,,visibleSchStr,%selText%
		if (!gui_ON)
		{
			Gui +LastFound
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
			settimer,showGui_animate,-1	
		}
		WinSet, Region, 0-26 w%width2% H35 ;H75
		gui_ON:=1		
		keyword_identified=0
		guicontrol,,keywordChoice,
		guicontrol,,keywordChoice,%keywordChoice_all%
		; Gui,  Show,	x550 y250
		SetTimer,search,-1
		SetTimer, tIncrementalSearch, 500
		sleep,800	;	launch after N ms
		settimer,checkactive,800
		
	}
	else
	{
		if (!gui_ON)
		{
			Gui +LastFound
			SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
			settimer,showGui_animate,-1	
		}
		WinSet, Region, 0-26 w%width2% H35 ;H75 
		gui_ON:=1
		SelectedLine=launcher
		stringreplace,keywordChoice_new,keywordChoice_all,||,|
		stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
		; msgbox,%keywordChoice_new%
		; guicontrol,,visibleSchStr,
		guicontrol,,keywordChoice,%keywordChoice_new%
		SetTimer,search,-1
		SetTimer, tIncrementalSearch, 500

		sleep,800	;	launch after N ms
		
		settimer,checkactive,800
		
	}
}
Sleep 0
; tooltip,`nsearch waiting
KeyWait rshift
return

showGui_animate:	; shows the gui with animation
OnMessage(0x200, "WM_MOUSEMOVE")
	if (!matchcount)
	WinSet, Region, 0-26 w%width2% H50 ;H75
	Gui, Show ,x100	w%show_width% ;h650
	tooltip,L^enter: paste | L+enter: copy | R+enter: open guiL | >^enter: field by field ,0,-55,2
	GuiControl,Focus,visibleSchStr
	; DllCall("AnimateWindow","UInt",GUI_ID,"Int",500,"UInt","0x60011")	; AnimateWindow
	; sleep,250

	WinWaitActive ,ahk_class AutoHotkeyGUI
	; CoordMode, Mouse,Screen
	; sleep,650
	Click 50 ,40, 0  ; Move the mouse without clicking.

return

tIncrementalSearch:
; msgbox,aaaa
	; REPEAT SEARCHING UNTIL USER HAS STOPPED CHANGING THE QUERY STRING
	;tooltip, tIncrementalSearch
	Gui, Submit, NoHide
	CurFilename = %visibleSchStr%
	If (NewKeyPhrase != CurFilename)
	{	 
		;tooltip, tIncrementalSearch changed`n%NewKeyPhrase% != %CurFilename%
		gosub, search_box_size
		field_by_field_pos := 0
		stop_search := 1	
		text_changed := 1
		n := 0
		/*
		while (a_search_is_running and n<35)
		{
			tooltip,%n% sleeping %text_changed%
			sleep,100
			n++			
		}
		*/
		;tooltip,no sleeping %text_changed%
		SetTimer, search,-1
			
		;text_changed := 0
		NewKeyPhrase := CurFilename
		;Sleep, 100 ; DON'T HOG THE CPU!
	}
	Else
	{
		text_changed := 0
	}
; tooltip, incre OFF
Return

search:
	a_search_is_running:=1
	text_changed := 0
	Gui, Submit, NoHide
	stop_search:=0
	SchStr:=visibleSchStr
	length:=StrLen(SchStr)
	LV_Delete()
	matchlist=
	
	if (text_changed)
		goto, ENDSEARCH
	if (SchStr != "")	;if empty query
	{
		SchStr_Tmp := make_lookarounds(SchStr," ")
		Loop, Parse, smart_search_commands,`n,`r
		{
			; if (Levenshtein_distance( A_LoopField, SchStr ) < 2)
			if RegExMatch(A_LoopField,SchStr_Tmp)
			{
				;matchlist=%matchlist%`n"%A_LoopField%","smart_search_commands","smart_search_commands"  ; "
				LV_Add("",A_LoopField,"smart_search_commands")
			}
		}
	}
	if (text_changed)
		goto, ENDSEARCH
	
	if keywordchoice=
	{
		if (SchStr = "")	;if empty query
		{
			GuiControl, Show, ResultList
			; LV_Delete()
			Goto,StopSearch
			return
		}
		;LV_Delete()
					
		keyword_search()
		recent_windows_and_files()
		;	keyword search
		if (length < 2)
			Goto,StopSearch
		Search_text_type:=determine_text(SchStr)
		gosub,checkdate
		gosub,timer_alarms	
		gosub,currency
		gosub,calculator
		; binary to decimal
		if ( RegExMatch(SchStr, "[\d\.]*") )
		{
		}
		search_in_progress := 1

		GuiControl, Show, ResultList		
		SchStr_Tmp:=make_lookarounds(SchStr," ")
		SchStr_Tmp=i)%SchStr_Tmp%
		; msgbox,%SchStr_Tmp%
		searchlist1:=searchlists_all
		tmp_count:=LV_GetCount() +1
		
		Loop,parse,searchlist1,`n,`r
		{
			if A_LoopField =  ; Omit the last linefeed (blank item) at the end of the list.
					continue
			if (stop_search)
			{
				stop_search:=0
				goto ENDSEARCH
			}

			filepath:=A_LoopField
			fileread,fileContent,%filepath%
			splitpath,filepath,source_Filename
			; source_Filename:=filepath
			Loop, Parse, fileContent,`n,`r
			{
				; if (Levenshtein_distance( A_LoopField, SchStr ) < 2)
				if RegExMatch(A_LoopField,SchStr_Tmp)
				{
					;StringReplace, a, A_LoopField, " "", All
					matchlist=%matchlist%`n"%A_LoopField%","%source_Filename%","%filepath%" ; "
				}
			}
			if (stop_search)
			{
				stop_search:=0
				goto ENDSEARCH
			}
		}
		matchlist:=regexreplace(matchlist,"m)^\n","")	
		GuiControl, -Redraw,ResultList
		matchlist2 = 
		matchlist11=
		matchlist12=
		reg= i)^%SchStr%.*
		; msgbox,=%matchlist%=
		loop,parse,matchlist,`n,`r
		{
			loop,parse,a_loopfield,CSV
			{
				a%a_index%:=a_loopfield
			}
			; msgbox,%a_loopfield%`n%a1%`n%a2%
			if RegExMatch( a1,reg)
			{	
				matchlist11 .= """" . a1 . """,""" . a2 . """,""" . a3 . "`n"
			}
			else
			{	
				matchlist12 .= """" . a1 . """,""" . a2 . """,""" . a3 . "`n"
			}
		}
		matchlist2 .= matchlist11 . matchlist12
		matchlist:= matchlist2
		matchlist:=regexreplace(matchlist,"m)^\s+|\s+$","")	
		; msgbox,%matchlist%
		Loop, Parse, matchlist,`n,`r
		{
			loop, parse,a_loopfield,CSV
			{
				a%a_index%:=a_loopfield
			}
			; msgbox,%a1%
			; LV_Add("",A_LoopField,filepath,"text",ext,source_Filename,"4")
			LV_Add("",a1,a2,"text",a3,,"4")
			; LV_Add("",a1,,"text",,a2,"4")
			if ((a2="commands.txt") OR (a2="05 god mode.txt") OR (a2= "07 START mENU.txt"))
			{
				LV_Modify(tmp_count,"Icon" . 2, , , , , "commmmmmanddssss","1")	
		
			}
			else if ( (source_Filename="bday.txt") OR (source_Filename="bday EEEa.txt") )
			{						
				LV_Modify(tmp_count,"Icon" . 1, , , , , ,"2")	
			
			}
			else if (source_Filename="all hotkeys ahk.txt") 
			{
				LV_Modify(tmp_count,"Icon" . 3, , , , , ,"3")						
			}
			else 
			{
				LV_Modify(tmp_count,"Icon" . 5)			
			}					
			tmp_count++
		}
		GuiControl, +Redraw,ResultList
	} ; finished if no keyword
		
	/*
		if % ConnectedToInternet()		;	%
		{
			settimer,from_internet,-0
		}
		else
		{
			tooltip,instant off,700,60,3
		}
			GuiControl,Focus,visibleSchStr
			settimer,removetooltip3,300
	*/
	else if (keywordchoice="maps")
	{
		lv_delete()
		LV_Add("","calculate distance" , ,"maps",,,"4")
	}
	else if (keywordchoice="calculator")
	{
		; gosub,calculator
	}
	else if (keywordchoice="smart action")
	{	
	;tooltip,%new_search_string%`n%visibleSchStr%
	;sleep,1500
		if (new_search_string<>visibleSchStr) ; not a change made by user, it is changed due to autofill suggestion
		{	
			;tooltip, searching %visibleSchStr%
			if (action_term="")
			{
				ControlGet, selection_text, selected,, %visibleSchStr%, A
				stringtrimright,text_to_search,visibleSchStr,strlen(selection_text)
				;tooltip,sent waiting %visibleSchStr%,130,,3
				args = "get_keyword_match_as_you_type" "%text_to_search%"
				if (text_changed)
					goto, ENDSEARCH
				
;				result := send_to_python_script("C:\cbn_gits\AHK\smart search\smart_search_api.py",args)
				result := send_to_python_script_run("C:\cbn_gits\AHK\smart search\smart_search_api.py",args)
				;tooltip,sent recieved,130,,3
				if (text_changed)
					goto, ENDSEARCH
				
				;tooltip,args=%args%`nresult=%result%
				;loop,parse,
				load_csv_to_listview(result)
			}
			else
			{
			

				/*
				args = "get_next_arguments_of_commands" "%action_term%" "%text_to_search%"
				result := send_to_python_script_debug("C:\cbn_gits\AHK\smart search\smart_search_api.py",args)
				;CoordMode, ToolTip, caret
				stringsplit,result,result,`n,`r
				tab_suggestions=
				loop,%result0%
				{
					if a_index>1
						tab_suggestions.= result%a_index% . "`n"
				}
				stringtrimright,tab_suggestions,tab_suggestions,1
				stringsplit,tab_suggestions,tab_suggestions,`n,`r
				gosub,fill_next_suggestion
				gosub,show_suggestions
				
				present_suggestion_count:=0
				*/
				;CoordMode, ToolTip, Screen
				
				if ( A_thisHotkey="~backspace")
				{
					trigger = backspace					
				}
				if (text_changed)
					goto, ENDSEARCH
					
				gosub, get_suggestions
				if (text_changed)
					goto, ENDSEARCH
				gosub, show_suggestions
			}
			gosub,guiHeight
		}
	}
	else ; other keywords
	{
		loop,parse, file_lookup_keywords,`n,`r
		{
			if (keywordchoice=a_loopfield)
			{
				item:=a_index
				searchlist1:=lookup_%item%
					break
			}
		}
		; lv_delete()
		searchlist1:=lookup_%item%
		; SchStr_Tmp:=make_lookarounds(SchStr,"+")
		SchStr_Tmp:=make_lookarounds(SchStr," ")
		search_files(searchlist1,SchStr_Tmp)	
	}

STOPSEARCH:
	Oldschstr:=schstr
	LV_ModifyCol(1,"AutoHdr")
	LV_ModifyCol()
	LV_ModifyCol(1, 540)
		if (!calculator_mode)
		gosub,guiHeight
	guicontrol,,match_count,%matchcount%
	guicontrol,,text1,%SchStr_Tmp%
	guicontrol,,source,%Search_text_type%
	gosub,preselection
	GuiControl,Focus,visibleSchStr	

ENDSEARCH:
	if (text_changed)
		text_changed:=0
	stop_search:=0
	a_search_is_running:=0
return

preselection:

	LV_Modify(1, "Select")	; preselects first
	LV_GetText(SelectedLine, LV_GetNext(0))
	; match_line_type:=determine_text(SelectedLine)
	LV_GetText(match_line_type,LV_GetNext(0),3)
		gosub,dynamic_actions
	return

guiHeight:
	matchcount:=LV_GetCount()
	if (matchcount>15)
		a = 15
	else if (matchcount<1)
		a := 1
	else
		a:=matchcount
	h:=a*23
	h2:=h + 45  
	GuiControl, move, ResultList,h%h2%
	; tmp_w := 800
	; width := 900
	tmp_w := width*0.95 -200
	; GuiControl, 1: move, ResultList,w1000
	GuiControl, Show, ResultList
	Gui,  +LastFound
	h1:=h+190 ; 86
	; Gui,  Show, w%width%,SMART_SEARCH
	; WinSet, Region, 0-26  w1300 H%h1%
	; sleep,1000
	; WinSet, Region, 0-26  w1100 H%h1%
	; sleep,1000 
	WinSet, Region, 0-0  W%show_width% H%h1% R5-5
	GuiControl, 1: move, ResultList,w%tmp_w%
	; tooltip,%width% %tmp_w%
return

ListEvent:
	LV_GetText(SelectedLine, LV_GetNext(0))
	if (A_GuiEvent = "DoubleClick")
	{
		tooltip,open
		settimer,removetooltip,-300
		menuEvent_function("open",SelectedLine)
	}
	if (A_GuiEvent = "normal")
	{
		
		; match_line_type:=determine_text(SelectedLine)
		LV_GetText(SelectedLine, LV_GetNext(0))
		LV_GetText(match_line_type,LV_GetNext(),3)
		gosub,dynamic_actions

	}
return

GuiContextMenu:
	If (A_GuiControl = "ResultList" && A_GuiControlEvent = "RightClick")    ; Only show menu when listview is right clicked.
	{		LV_GetText(FileFullpath,LV_GetNext(),2)
		menu Context1, Show, %A_GuiX%, %A_GuiY%
	}
return

MenuEvent:
	If ( !ThisMenuItem )
	ThisMenuItem = %A_ThisMenuItem%
		;msgbox,%ThisMenuItem%	
		menuEvent_function(ThisMenuItem,FileFullpath)
	ThisMenuItem=
return

removetooltip:
	tooltip,
	settimer,removetooltip,off
return

removetooltip2:
	tooltip,,,,2
	settimer,removetooltip2,off
return

removetooltip3:
	tooltip,,,,3
	settimer,removetooltip3,off
return

hide:
OnMessage(0x200, "")
	trigger_HK=
	calculator_mode:=0
	DllCall("AnimateWindow","UInt",GUI_ID,"Int",200,"UInt","0x90000")
	; gui,hide
	stop_search:=1
	SetTimer, tIncrementalSearch, off
	settimer,checkactive,off
	gui_ON:=0
	tooltip,,,,7
	tooltip,,,,6
	tooltip,,,,5
	tooltip,,,,4
	tooltip,,,,3
	tooltip,,,,2
	settimer,removetooltip,300
	a_search_is_running:=0

	return

checkactive:

	IfWinNotActive, ahk_class AutoHotkeyGUI

	; IfWinNotActive, SMART_SEARCH
	{
		sleep,300
		; IfWinNotActive, SMART_SEARCH
		IfWinNotActive, ahk_class AutoHotkeyGUI
		{
			if hold=0
			{
				gosub,Gui3_hide
				gosub,hide
				settimer,checkactive,off

			}
		}
	}
return

DYNAMIC_ACTIONS:

	if keywordchoice<>
	{
		match_line_type:=keywordchoice
		;	if ( !keyword_identified)	;	deletes keyword if keyword identified
		;	{
		;	guicontrol,,visibleSchStr,
		;	keyword_identified=1
		;	}
	}
	;sleep,10
	guicontrol,,match2,%match_line_type%
	guicontrol,,Action_button1,--
	guicontrol,,Action_button2,--
	guicontrol,,Action_button3,--
	guicontrol,,Action_button4,--
	LV_GetText(source_Filename,LV_GetNext(),5)

	if (calculator_mode)	;	 AND (matchcount<1)
	{	
		button1_action=action_calculator
	}
	else if ((match_line_type="smart action") )
	{
		guicontrol,,Action_button1,run
		button1_action=action_smart_action

	}
	else if ((match_line_type="maps") )
	{
		guicontrol,,Action_button1,Map
		button1_action=action_maps

	}
	else if ((source_Filename="recent window") )
	{
		guicontrol,,Action_button1,activate
		button1_action=action_activate_window

	}
	else if ((match_line_type="file_folder") )
	{
		guicontrol,,Action_button1,OPEN
		guicontrol,,Action_button2,OPEN F

		button1_action=action_open
		button2_action=action_openFolder
		button3_action=nil
		button4_action=nil

	}
	else if ((match_line_type="file_folder") )
	{
		guicontrol,,Action_button1,OPEN
		guicontrol,,Action_button2,OPEN F

		button1_action=action_open
		button2_action=action_openFolder
		button3_action=nil
		button4_action=nil

	}
	else if (match_line_type="numbers")
	{
		button1_action=calculator
		button2_action=nil
		button3_action=nil
		button4_action=nil
	}
	else if (match_line_type="timer")
	{
		guicontrol,,Action_button1,timer
		guicontrol,,Action_button2,timer
		button1_action=action_timer
		button2_action=nil
		button3_action=nil
		button4_action=nil
		}
	else if (match_line_type="read")
	{
		guicontrol,,Action_button1,read
		button1_action=action_read
		button2_action=nil
		button3_action=nil
		button4_action=nil
	}
	else if ((match_line_type="email") 	| (source_Filename="gmail contacts.txt") |	(source_Filename="mails.txt")|	(source_Filename="phone contacts.txt")|	(source_Filename="others.csv")|	(source_Filename="less used.txt")|	(source_Filename="ea.csv")|	(source_Filename="mail id.txt")	)

		{			
			guicontrol,,Action_button1,mail
			guicontrol,,Action_button2,sms
			guicontrol,,Action_button3,call
			guicontrol,,Action_button4,FB
			button1_action=action_mail
			button2_action=action_sms
			button3_action=action_call
			button4_action=action_openFB
			ILButton(button1, "shell32.dll:" 200, 22, 22, 5)	
		}
	else if (match_line_type="keyword")
		{
			LV_GetText(button1_action,LV_GetNext(),4)	
			LV_GetText(t,LV_GetNext(),1)	
			guicontrol,,Action_button1,%t%
			; button1_action=action_Open_DB
		}
	else if (match_line_type="calendar")
		{
			button1_action=action_calendar	
			guicontrol,,Action_button1,open cal
		}
	else if ( (source_Filename="bday.txt") OR (source_Filename="bday EEEa.txt") )
		{
			button1_action=action_calendar	
			guicontrol,,Action_button1,open cal
			; button1_action=action_Open_DB
			ILButton(button1, "shell32.dll:" 239, 22, 22, 5)	
		}
		
		
	else if (  (source_Filename="sel text.txt") OR (source_Filename="sel text2.txt") OR (match_line_type="launcher"))
		{
			button1_action=action_run_command_from_match	
			guicontrol,,Action_button1,seLL
			; button1_action=action_Open_DB
			ILButton(button1, "shell32.dll:" 249, 22, 22, 5)	
		}
	else if (source_Filename="all hotkeys ahk.txt")
		{
			button1_action=action_ahk_run_Hotkey	
			guicontrol,,Action_button1,run
			; button1_action=action_Open_DB
			ILButton(button1, "shell32.dll:" 249, 22, 22, 5)	
		}
		
	else
		{
			LV_GetText(SelectedLine, LV_GetNext(0))
			match_line_type:=determine_text(SelectedLine)

			if (match_line_type="file_folder")
			{
				guicontrol,,Action_button2,OPEN
				guicontrol,,Action_button3,OPEN F
				
				button2_action=action_open
				button3_action=action_openFolder
			}
			guicontrol,,Action_button1,Open DB file
			button1_action=action_Open_DB
			ILButton(button1, "shell32.dll:" 290, 22, 22, 5)				
		}
		
		; msgbox,%match_line_type%
	button5_action=action_multisearch
	button6_action=action_Open_line
	; button7_action=action_copy_line
return	

action_timer:
	tooltip,%action_timer%
	settimer,removetooltip,-300
	{
		StringToSend=%visibleSchStr%

		TargetScriptTitle = my calendar.ahk ahk_class AutoHotkey

		Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
	/*
		inputbox, msg, timer,add timer,,,,,,,,%TimeString2%

		FormatTime, time1 ,  ,yyyyMMdd
		a=%schstr%
		stringreplace,a,a,:
		time=%time1%%a%00
		; msgbox,%time%
		if msg=
			msg=reminder
		tmp=`n%time%=%msg%
		fileappend,%tmp%,%A_Script_Drive%\cbn\ahk\calendar\my calendar.ini
		*/
	}
return

action_calculator:	;	replace edit field with result
	; GuiControl, Text, MyText, %NewText% ; Write text back to Edit control
	; ControlGet, cursorPos, CurrentCol,, %MyText%, A ; Get current cursor position
	; cursorPos := cursorPos - 2
	
	guicontrol,,visibleSchStr,%compact_result%
	cursorPos := StrLen(compact_result)
	; set cursor position
	SendMessage, 0xB1, cursorPos, cursorPos,, ahk_id %Ed1% ; EM_SETSEL ; Add hwndh to Edit control for this to work
return

action_calendar:
	LV_GetText(button1_action,LV_GetNext(),2)
	; msgbox,%%
	; time:=a_now
	gosub,getdate
	date_tmp := date
	tooltip,%action_calendar%
	settimer,removetooltip,-300

	TargetScriptTitle = my calendar.ahk ahk_class AutoHotkey
	StringToSend=-showgui -d%date_tmp%
	; StringToSend=-showgui -d%date_tmp% -add
	result := Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
	if result = FAIL
		MsgBox SendMessage failed. Does the following WinTitle exist?:`n%TargetScriptTitle%
	else if result = 0
		MsgBox Message sent but the target window responded with 0, which may mean it ignored it.

return

action_call:
	LV_GetText(tmp_1,LV_GetNext(),1)
	reg=(\+)?(\d)+
	RegExMatch(tmp_1,reg, SubPat)
	; msgbox,%SubPat%
	run, "C:\Program Files (x86)\Skype\Phone\Skype.exe" "/callto:%SubPat%"
	; run, "C:\Program Files (x86)\Skype\Phone\Skype.exe"
	settimer,removetooltip,-300
return

action_SMS:
	tooltip,%SMS%
	settimer,removetooltip,-300
return

action_mail:
	tooltip,%mail%
	settimer,removetooltip,-300
	run,%A_Script_Drive%\cbn\ahk\smart search\send mail.ahk
return

action_openFB:
	tooltip,%FB%
	settimer,removetooltip,-300
return

action_open:
	tooltip,opening
	settimer,removetooltip,-300
	menuEvent_function("open",SelectedLine)
return

action_ahk_run_Hotkey:
	LV_GetText(command,LV_GetNext(),1)
	reg=i)^(.*)::(.*)
	RegExMatch(command,reg, SubPat)
SubPat1 := RegExReplace(SubPat1, "^\s+|\s+$") 	;trim whitespace
	; ahk_run_Hotkey:=regexmatch(command,reg)
; msgbox,=%SubPat1%=
/*
reg1=i)([+!\^]*)(\w*)
reg2=$1 - { $2 }
pattern2:=regexreplace(SubPat1,reg1,reg2)
*/
keys1=^,!,+,#,&,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadAdd,NumpadClear,NumpadDel,NumpadDiv,NumpadDot,NumpadDown,NumpadEnd,NumpadEnter,NumpadHome,NumpadIns,NumpadLeft,NumpadMult,NumpadPgDn,NumpadPgUp,NumpadRight,NumpadSub,NumpadUp,,Break,Pause,CtrlBreak,PrintScreen,AppsKey,,Space,Tab,Enter,Escape,Esc,Backspace,BS,,Delete,Del,Insert,Ins,Home,End,PgUp,PgDn,Up,Down,Left,Right,NumLock,CapsLock,ScrollLock
keys2=^!+#&
pattern3=

stringreplace,subpat1,subpat1,&,%a_space%&%a_space%,all

stringreplace,subpat1,subpat1,^,%a_space%^%a_space%,all
stringreplace,subpat1,subpat1,!,%a_space%!%a_space%,all
stringreplace,subpat1,subpat1,+,%a_space%+%a_space%,all
stringreplace,subpat1,subpat1,#,%a_space%#%a_space%,all
stringreplace,subpat1,subpat1,%a_space%%a_space%,%a_space%,all

	loop,parse,SubPat1,%a_space%
	{	
		if (a_loopfield="AppsKey")
		{
			tooltip,cannot run
			sleep,900
			; settimer,removetooltip,-500
			return
		}
		ifinstring,keys2,%a_loopfield%
			pattern3.=a_loopfield
		else
			pattern3.= "{" a_loopfield "}"
	}
	; msgbox,%pattern3%
	send %pattern3%
	; send %SubPat1%
	; msgbox,%pattern2%
return

action_openFolder:
	tooltip,opening parent
	settimer,removetooltip,-300
	menuEvent_function("Open &parent",SelectedLine)
return

action_multisearch:

	SearchTerms:=visibleSchStr
	Run, http://www.google.com/search?q=%SearchTerms%
	Run, http://www.google.com/search?q=%SearchTerms%&tbm=isch
	Run, http://en.wikipedia.org/wiki/%SearchTerms%
	Run, http://en.wikipedia.org/wiki/Special:Search/%SearchTerms%
	Run, http://www.bing.com/search?q=%SearchTerms%

	; quick search
	TargetScriptTitle = quick search alphasearch.ahk ahk_class AutoHotkey
	StringToSend=%SearchTerms%
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
	; First set the structure's cbData member to the size of the string, including its zero terminator:
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows On
	SetTitleMatchMode 2
	SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
	DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
	SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
	; quick search
return

action_Google:
	tooltip,%action_Google%
	settimer,removetooltip,-300
	SearchTerms:=visibleSchStr
	Run, http://www.google.com/search?q=%SearchTerms%
return
action_Open_DB:
	LV_GetText(filepath,LV_GetNext(),4)
	tooltip,%action_Open_DB%
	settimer,removetooltip,-300
	SearchTerms:=visibleSchStr
	Run, %filepath%
return

action_maps:
	Gui, Submit, NoHide

	ifinstring,visibleSchStr,%a_space%to%a_space%
	{
		StringReplace, locations, visibleSchStr,%a_space%to%a_space%,@
		StringSplit, location, locations,@
	}
	else
	{
		location1=muvattupuzha
		location2:=visibleSchStr
	}
	url2=http://maps.googleapis.com/maps/api/geocode/xml?address=%visibleSchStr%&sensor=false
url=http://maps.googleapis.com/maps/api/distancematrix/xml?origins=%location1%&destinations=%location2%&mode=car&sensor=false
filedelete,%a_scriptdir%\gmaps_info.tmp
urldownloadtofile,%url%,%a_scriptdir%\gmaps_info.tmp

filedelete,%a_scriptdir%\gmaps_info2.tmp
urldownloadtofile,%url2%,%a_scriptdir%\gmaps_info2.tmp
sleep,100
fileread,txt,%a_scriptdir%\gmaps_info.tmp
fileread,xmldata,%a_scriptdir%\gmaps_info2.tmp

doc := ComObjCreate("MSXML2.DOMDocument.6.0")
doc.async := false
doc.loadXML(xmldata)
DocNode := doc.selectSingleNode("//GeocodeResponse/status")
status:= DocNode.text
if (status="ok")
{
	DocNode := doc.selectSingleNode("//GeocodeResponse/result/address_component/short_name")
	suggestion := DocNode.text
	tooltip,%suggestion%
	sleep,500

}

; msgbox,%weather%

reg=<origin_address>(.*)</origin_address>
; FoundPos := RegExMatch("abcXYZ123", "abc(.*)123", SubPat)
a:=regexmatch(txt,reg,ao)
reg=<destination_address>(.*)</destination_address>
a:=regexmatch(txt,reg,ad)
reg=<distance>(.*)</distance>
a:=regexmatch(txt,reg,k)
reg=<text>(.*)</text>

a:=regexmatch(k1,reg,k)

v := ComObjCreate("SAPI.SpVoice")
v.Voice := v.GetVoices().Item( 0 ) ; set the voice
v.rate := 2 ; slow down speak	

tooltip_tmp=%k1% : %ao1%   ===>`n`t%ad1%
Say_String=%k1%
tooltip,%tooltip_tmp%,204,-30,2
v.Speak(Say_String)
; sleep 5000

return

action_Open_line:
/*
	LV_GetText(filepath,LV_GetNext(),2)
	LV_GetText(line,LV_GetNext(),1)
	inputbox, msg, timer,line`n%filepath%,,,150,100,200,,,%line%
return
*/
action_Open_line_near:
this_line=
prev_line=
next_line=
	LV_GetText(filepath,LV_GetNext(),4)
	LV_GetText(line,LV_GetNext(),1)
	fileread,text_tmp,%filepath%
		found:=0
	loop,parse,text_tmp,`n,`r
	{
		if (found)
		{	
			next_line:=a_loopfield
			break
		}
		this_line:=a_loopfield
		if (a_loopfield=line)
		{
		found:=1
			continue
		}
		prev_line:=this_line
		
	}
tmp_txt=%prev_line%`n%this_line%`n%next_line%	
gui3edit2:=tmp_txt
gui, 3: destroy
gui, 3: font,s10
gui, 3: +toolwindow +AlwaysOnTop  -caption  +border    -lastfound

Gui, 3: Add, Button, x2 y2 w30 h30  , <
Gui, 3: Add, Button, x+2 y2 w30 h30  , >
Gui, 3: Add, Button, x+2 y2 w70 h30 gcopy_all , copy all
Gui, 3: Add, Button, x+2 yp w70 h30 gGui3_hide , HIDE
Gui, 3: Add, Button, x+2 yp w70 h30 gGui3_close_all , ClOSE ALL
Gui, 3: Add, Button, x+0 yp w70 h30 gcopy_line , copy  line
Gui, 3: Add, Button, x+10 yp w70 h30 gsend_line ,^v sel line
Gui, 3: Add, Button, x+0 yp w70 h30 gcopy_sel_line , copy sel line
Gui, 3: Add, Button, x+0 yp w70 h30 gshow_all , show all
Gui, 3: Add, Button, x+0 yp w70 h30 gopen_edit , edit

delimiter=`n
delimiter_all=,`;`:`"`=.&
loop,parse,delimiter_all
{	; msgbox,%a_loopfield%
	ifinstring,line,%a_loopfield%
	{
		delimiter=%a_loopfield%
		break
	}
}
/*
	else ifinstring,line,`;
		delimiter=`;
	else ifinstring,line,`:
		delimiter=`:
	else ifinstring,line,"
		delimiter="
		
	*/	
	x_pos:=2
	y_pos:=40
	Position := 0
	line:=tmp_txt
	loop,parse,line,`n%delimiter%
	{
		Position += StrLen(A_LoopField) + 1
		; Retrieve the delimiter found by the parsing loop.
		Delimiter := SubStr(line, Position, 1)
		item:=a_loopfield
		item := RegExReplace(item, "^\s+|\s+$") 	;trim whitespace

		if A_index >30
			break
		skip:=0
		;	check for invalid data
		; if ( RegExmatch(item, "[^\.-""']" ) )
		if item=""
			skip:=1
		if item=
			skip:=1
		if (!skip)
			{
				copy_word%a_index%:=item
				width_tmp:=strlen(item)*9
				if (width_tmp<30)
					width_tmp:=30
				else if (width_tmp>600)
					width_tmp:=600
				; msgbox,=%Delimiter%=
				Gui, 3: Add, Button, x%x_pos% y%y_pos% w%width_tmp% h35 gcopy_wordbutton%a_index% , %item%
				x_pos+=width_tmp
				if (regexmatch(Delimiter,"\R"))	
				; if Delimiter=`r`n
				{
					x_pos:=2
					y_pos:=y_pos+36
				}
				else if (x_pos>500)
					{
					x_pos:=2
					y_pos:=y_pos+36
					}
				else
					x_pos+=2
			}
	}
	/*	
loop,parse,line,%delimiter%`n
	{
		item:=a_loopfield
		item := RegExReplace(item, "^\s+|\s+$") 	;trim whitespace

		if A_index >30
			break
		skip=0
		;	check for invalid data
		; if ( RegExmatch(item, "[^\.-""']" ) )
		if item=""
			skip:=1
		if item=
			skip:=1
		if (!skip)
			{
				copy_word%a_index%:=item
				width_tmp:=strlen(item)*7.5
				if (width_tmp<25)
					width_tmp:=25
				Gui, 3: Add, Button, x+2 yp w%width_tmp% h35 gcopy_wordbutton%a_index% , %item%
			}
	}
	*/
; Gui, 3: Add, edit, x10 y+5 w600 r1 vgui3edit2, %line%

Gui, 3: Add, edit, x2 y+2 w550 r20 vgui3edit2 ,%tmp_txt%
Gui, 3: Add, Button, x2 y+2 w100 h40 gGui3_hide ,HIDE
Gui, 3: Add, Button, x+2 yp w100 h40 gGui3_close_all ,ClOSE ALL
gui, 3: show, x700 y205
Gui 3: +LastFound
GUI_ID3:=WinExist()
return

action_copy_line:
	LV_GetText(filepath,LV_GetNext(),2)
	LV_GetText(line,LV_GetNext(),1)
	; inputbox, msg, timer,line`n%filepath%,,,150,100,200,,,%line%
	gui, 3: destroy
	gui, 3: +toolwindow +AlwaysOnTop  -caption  +border

Gui, 3: Add, Button, x10 y5 w100 h40 gGui3_hide , hide
Gui, 3: Add, Button, x+0 yp w100 h40 gcopy_all , copy all
delimiter=`n
delimiter_all=,`;`:`"`=.&
loop,parse,delimiter_all
{
; msgbox,%a_loopfield%
ifinstring,line,%a_loopfield%
		{
		delimiter=%a_loopfield%
		break
		}
} 
/*
	else ifinstring,line,`;
		delimiter=`;
	else ifinstring,line,`:
		delimiter=`:
	else ifinstring,line,"
		delimiter="
		
	*/	
		
loop,parse,line,%delimiter%
	{
		item:=a_loopfield
		item := RegExReplace(item, "^\s+|\s+$") 	;trim whitespace

		if A_index >30
			break
		skip=0
		;	check for invalid data
		; if ( RegExmatch(item, "[^\.-""']" ) )
		if item=""
			skip:=1
		if item=
			skip:=1
		if (!skip)
			{
				copy_word%a_index%:=item
				Gui, 3: Add, Button, x+2 yp w120 h35 gcopy_wordbutton%a_index% , %item%
			}
	}
Gui, 3: Add, edit, x10 y+5 w600 r1 vgui3edit2, %line%
Gui, 3: Add, Button, x+10 y+10 w100 h30 gGui3_hide , hide
gui, 3: show, x700 y235
GUI_ID3:=WinExist()
return

DefAction:
	gosub,%button1_action%

/*
	LV_GetText(SelectedLine, LV_GetNext(0))
	match_line_type:=determine_text(SelectedLine)
	tooltip,%match_line_type%
	settimer,removetooltip,-300
	if (match_line_type="file_folder")
	{
		tooltip,opening
		settimer,removetooltip,-300
		menuEvent_function("open",SelectedLine)
	}
	else if (match_line_type="numbers")
	{

	}
	else if (match_line_type="email")
	{
		run,%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\gmail contacts.csv
	}
*/
; if (!calculator_mode)
	; gosub,hide
return

DefAction2:
	gosub,%button2_action%

	gosub,hide
return

DefAction3:
	gosub,%button3_action%
return

DefAction4:
	gosub,%button4_action%
return

DefAction5:
	gosub,%button5_action%
return

DefAction6:
	gosub,%button6_action%
return

; DefAction7:
; gosub,%button7_action%
; return

action_run_command_from_match:
	gui,submit
	LV_GetText(line, LV_GetNext(),1)
	tmp_a3=
	tmp_a1=
	loop,parse,line,csv
	{
		tmp_a%a_index%:=a_loopfield
	}
	;if tmp_a1=
	;	tmp_a1:=tmp_a1
  tmp_a1 := regexreplace(tmp_a1,".*?;\s*(.*?)\s*","$1")
	tmp_a1:= regexreplace(tmp_a1,"(^\s*)|(\s*$)","")
	;msgbox,=%tmp_a1%=`n%tmp_a2%
	if (tmp_a3="")
	{
    run,%tmp_a1%
	}
	else
	{
	call_func_from_string(tmp_a3)
	}
	
return

nil:
return

#IfWinActive, SMART_SEARCH

wheeldown::	; na
	ControlGetFocus, OutputVar
	; tooltip,%OutputVar%
	; sleep,200
	; tooltip
if (OutputVar="edit1")
{	
	control=syslistview321
	SendMessage, 0x115, 1, 0,%control% ;	Scroll up by one line (for a control that has a vertical scroll bar)
	SendMessage, 0x115, 1, 0,%control% ;	Scroll up by one line (for a control that has a vertical scroll bar)
	SendMessage, 0x115, 1, 0,%control% ;	Scroll up by one line (for a control that has a vertical scroll bar)
}
else
	send {wheeldown}
return

wheelup::	; na
	ControlGetFocus, OutputVar
	if (OutputVar="edit1")
	{
		control=syslistview321
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
	}
	else
		send {wheelup}
return


numpadEnter::	; na
Enter::	; na
	Gui, Submit,nohide
	hide_tmp:=1
	LV_GetText(match_line_type,LV_GetNext(),3)
	if (match_line_type="keyword")
	{	
		gosub,keyword_mode_toggle
		return
	}
	else if  (keywordchoice="smart action")
	{
	
		if (Edit_TextIsSelected(Ed1)) ;(selection)
		{
		
			;unselects
			ControlGet, selection_text, selected,, %visibleSchStr%, A ; Get current cursor position
			ControlGet, cursorPos, CurrentCol,, %visibleSchStr%, A ; Get current cursor position
			;tooltip,%cursorPos% %CurrentCol%
			;sleep,500
			cursorPos := cursorPos + StrLen(selection_text)-1
			; set cursor position
			SendMessage, 0xB1, cursorPos, cursorPos,, ahk_id %Ed1% 
			settimer,search,-10
			trigger = 
			gosub, get_suggestions
			gosub, show_suggestions
		}
		else if (action_term="")
		{
			LV_GetText(action_term,LV_GetNext(),5)
			setTimer,removetooltip,500
			tooltip,%action_term% fixed
			guicontrol, 1:, action_term_selected,%action_term%
			;length :=StrLen(action_term)
			trigger = enter
			location:= "here" ; get_parent_filepath()
			if (trigger_HK="clipb_text")
				new_search_string := action_term . " text=clipboard output=clipboard location=""" . location . """ "
			else
				new_search_string = %action_term%%a_space%
			length :=StrLen(new_search_string)
			guicontrol,,visibleSchStr,%new_search_string%
			SendMessage, ( EM_SETSEL := 0xB1 ), length, length, , ahk_id %ED1%	;preselects the text
			gosub, get_suggestions
			gosub, show_suggestions
	
			;guicontrol, 1:, action_term_selected,%action_term% syntax here
			;guicontrol, 1:, action_term_selected,%action_term% %result%
			;tooltip,%result% ,0,-25,3
			; msgbox,%result%
			
		}
		else
			gosub, DefAction
		;msgbox,%action_term%
	}
	else
	{
		if (keywordchoice="maps")
			hide_tmp:=0
		if (calculator_mode)
			hide_tmp:=0
		if (hide_tmp)
			Gui, hide
		sleep,100
		; if keywordChoice=
		gosub, DefAction
		; else
	}
return

>+Enter::	; na
	Gui , Submit
	gosub , action_Open_line
return

<+Enter::	; na
	LV_GetText( SelectedLine , LV_GetNext() )
	Gui, Submit
	if ( calculator_mode )
	{
		clipboard:=result
	}
	else
	{
		clipboard:=SelectedLine
	}
	; Gui, hide
	tooltip,%clipboard%
	sleep,1300
	tooltip

return

<^Enter::	; na
	Gui, Submit
	LV_GetText(SelectedLine, LV_GetNext())
	if (calculator_mode)
	{
		clipboard=%result%
	}
	else
	{
		clipboard=%SelectedLine%
	}
	tooltip,pasting
	Gui, hide
	sleep,700
	; send ^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	sleep,100
	tooltip

return

up::	; na
	; guicontrol,focus,ResultList

	selected:=LV_GetNext()
	if (selected=1)
		return
	selected-=1
	LV_Modify(0, "-Select")
	LV_Modify(selected, "Select")
	LV_Modify(selected, "Vis")
	LV_GetText(SelectedLine, LV_GetNext(0))
	LV_GetText(match_line_type,LV_GetNext(),3)
	gosub,dynamic_actions
return	

down::	; na
; guicontrol,focus,ResultList

selected:=LV_GetNext()
selected+=1
LV_Modify(0, "-Select")
LV_Modify(selected, "Select")
LV_Modify(selected, "Vis")
LV_GetText(SelectedLine, LV_GetNext(0))
LV_GetText(match_line_type,LV_GetNext(),3)
gosub,dynamic_actions

return	

keyword_mode_toggle:
LV_GetText(SelectedLine, LV_GetNext(0),1)
if keywordchoice =
{
	stringreplace,keywordChoice_new,keywordChoice_all,||,|
	; msgbox,%keywordChoice_all%
	stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
	guicontrol,,visibleSchStr,
; guicontrol,show,keywordChoice,
}
else
{
keywordChoice=
stringreplace,keywordChoice_new,keywordChoice_all,||,|

; guicontrol,hide,keywordChoice,
}
guicontrol,,keywordChoice,%keywordChoice_new%
; guicontrol,,visibleSchStr,
sleep,10
gui,submit,nohide

gosub,preselection
SetTimer,search,-1

;{    "AA": "44",    "ADF": "AFA"}
return

~backspace::
return

tooltip,backspace
sleep,200
	trigger = backspace
	gosub, get_suggestions
	trigger=
	gosub, show_suggestions
	return
tab::	; na
	trigger = tab
	gosub, get_suggestions
	trigger=
	gosub, show_suggestions
	return
	
get_suggestions:
	
	gui,submit,nohide
	ControlGet, selection_text, selected,, %visibleSchStr%, A
	
	ControlGet, cursorPos, CurrentCol,, %visibleSchStr%, A ; Get current cursor position
	stringleft,un_selected_prefix,visibleSchStr,cursorPos-1
	stringtrimleft,un_selected_suffix,visibleSchStr,cursorPos+strlen(selection_text)-1
	
	args = "tab_fill_next_suggestion" "%action_term%" "%un_selected_prefix%" "%selection_text%" "%un_selected_suffix%"  "%trigger%"
	trigger =
	; tooltip,sending data
	if (text_changed)
	{
		tooltip, changed
		sleep, 1000
		goto, ENDSEARCH
	}
	result := send_to_python_script("C:\cbn_gits\AHK\smart search\smart_search_api.py",args)
	if (text_changed)
	{
		tooltip, changed
		sleep, 1000
		goto, ENDSEARCH
	}
	;msgbox, %result%
	; tooltip, received processing
	result := JSON.Load(result)
	; str := JSON.Dump( result)
	un_selected_prefix := result.un_selected_prefix
	selection_text:= result.selection_text
	un_selected_suffix := result.un_selected_suffix
	tab_suggestions := result.suggestions
	full_syntax := result.full_syntax
	guicontrol, 1: , action_term_selected,%action_term% %full_syntax%
	result1 := result.first_desc
	new_search_string := un_selected_prefix . selection_text . un_selected_suffix
	; sleep, 10
		
	guicontrol, 1: , visibleSchStr,%new_search_string%
	start:= strlen(un_selected_prefix)
	end := start + strlen(selection_text)
	SendMessage, 0xB1, start, end,, ahk_id %Ed1%
	
	if (text_changed)
	{
		tooltip, changed
		sleep, 1000
		goto, ENDSEARCH
	}
	; gosub, fill_next_suggestion
return

show_suggestions:
	y1 := A_CaretY + 17
	y2 := A_CaretY + 42

	x1 := A_CaretX + 15
	x2 := A_CaretX + 5
	tooltip, %result1%,%x1%,%y1%,5
	tooltip, %tab_suggestions%,%x1%,%y2%,4
return

~Esc::	; na
	gosub,Gui3_hide
	gosub,hide

return

#IfWinActive

fill_next_suggestion:
loop,parse,text_to_search,%a_space%
	raw_last_word := a_loopfield
last_word := regexreplace(raw_last_word,"^-(.*)","$1")
last_word := regexreplace(last_word,"^([^=]*=)(.*)","$1")
if regexmatch(raw_last_word,"^-(.*)")
	argument_key_without_hypen :=0
else
	argument_key_without_hypen :=1

ControlGet, selection_text, selected,, %visibleSchStr%, A
selection_text := regexreplace(selection_text,"^(.*)=$","$1")
search_for := last_word . selection_text
present_suggestion_count := get_present_match_pos(tab_suggestions,,search_for )

present_suggestion_count++

suggestion := tab_suggestions%present_suggestion_count%
if (suggestion <>"")
{
	;msgbox,%present_suggestion_count%.%suggestion%
	
	start := strlen(text_to_search)
	end := start + strlen(suggestion)
	stringtrimleft,append_word,suggestion,strlen(last_word)
	if (argument_key_without_hypen)
	{
		end+=1
		append_word .= "="
	}
	new_search_string=%text_to_search%%append_word%
	guicontrol,,visibleSchStr,%new_search_string%
	SendMessage, 0xB1, start, end,, ahk_id %Ed1%
}
;ControlSend, , % "{Right " . StrLen(needle) . "}+^{End}", ahk_id %h%

return

check_calendar:
calendars=%A_Script_Drive%\cbn\ahk\calendar\bday EEEa.txt`n%A_Script_Drive%\cbn\ahk\calendar\bday.txt`n%A_Script_Drive%\cbn\ahk\calendar\indian calendar.txt`n%A_Script_Drive%\cbn\ahk\calendar\my calendar.ini

loop,parse,calendars,`n,`r
{
	filepath:=a_loopfield
	fileread,all,%filepath%
		; msgbox,%date%
		reg1=i).*%date%.*
	loop,parse,all,`n,`r
	{
		
		if  ( regexmatch(a_loopfield,reg1))
		{
		; msgbox,%a_jloopfield%
		loop,parse,a_loopfield,=
			{
			tmp_%A_index%:=a_loopfield
			}
			; reminder_time_%A_index%:=tmp_1
			; reminder_msg_%A_index%:=tmp_2
		FormatTime, time , %tmp_1%
			LV_Add("",tmp_2,time,"calendar",filepath)
		}
	}
}
return

gui_roll_Down:
	gosub,guiHeight
	gosub,preselection
return
/*
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{	
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
	; First set the structure's cbData member to the size of the string, including its zero terminator:
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows On
	SetTitleMatchMode 2
	SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
	DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
	SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
	return ErrorLevel  ; Return SendMessage's reply back to our caller.
} ;search and populate if empty string displays all lines

*/
search_files(searchlist1,SchStr)	

{
	global
	if (keywordchoice="launcher")
		SchStr_Tmp:=make_lookarounds(SchStr," ")
	else
		SchStr_Tmp:=SchStr
	SchStr_Tmp=i)%SchStr_Tmp%

	if (SchStr = "")							;if empty query
	{
		Loop,parse,searchlist1,`n,`r
		{
			if A_LoopField =  ; Omit the last linefeed (blank item) at the end of the list.
					continue
			filepath:=A_LoopField
			fileread,fileContent,%filepath%
			
			matchlist=
			splitpath,filepath,source_Filename
			; source_Filename:=filepath
			Loop, Parse, fileContent,`n,`r
			{
			
				; if RegExMatch(A_LoopField,SchStr_Tmp)
					{
					matchlist=%matchlist%`n%A_LoopField%
					}
			}
			matchlist:=regexreplace(matchlist,"m)^\n","")	
			
			Loop, Parse, matchlist,`n,`r
			{
				LV_Add("",A_LoopField,filepath,keywordchoice,ext,source_Filename)
			}
		}
	}
	else
	{
		Loop,parse,searchlist1,`n,`r
		{
			if A_LoopField =  ; Omit the last linefeed (blank item) at the end of the list.
					continue
			filepath:=A_LoopField
			fileread,fileContent,%filepath%
			; msgbox,%filecontent%
			matchlist=
			splitpath,filepath,source_Filename
			; source_Filename:=filepath
			Loop, Parse, fileContent,`n,`r
			{
			
				if RegExMatch(A_LoopField,SchStr_Tmp)
				{
					matchlist=%matchlist%`n%A_LoopField%
				}
			}
			matchlist:=regexreplace(matchlist,"m)^\n","")	
	; msgbox,%matchlist%		
			Loop, Parse, matchlist,`n,`r
			{
				LV_Add("",A_LoopField,filepath,keywordchoice,ext,source_Filename)
			}
		}	
	}
}
read_searchlists_all:
	searchlist1=
	fileread,searchlist1,%A_ScriptDir%\searchlist.ini
	fileread,loop_folders,%A_ScriptDir%\searchlist_Folders.ini
	; loop_folders=%A_ScriptDir%\db`nC:\cbn\docs

	; scanning watch folders
	; Loop, %A_ScriptDir%\db\*.(txt|csv|db), ,
	if loop_folders<>
	{

		loop,parse,loop_folders,`n,`r
		{	
			Loop, %A_loopfield%\*.*, ,
			{
				searchlist1=%searchlist1%`n%A_LoopFileFullPath%
			}
		}
	}
	searchlist1:=regexreplace(searchlist1,"m)^\s*\n","")
			; msgbox,%searchlist1%
	searchlists_all:=searchlist1
return

Gui3_hide:
	; gui,3: hide
	DllCall("AnimateWindow","UInt",GUI_ID3,"Int",200,"UInt","0x90000")
	return
Gui3_close_all:
	gosub,Gui3_hide
	gosub,hide
return

send_line:
	sleep,200
	guicontrol, 3: focus,gui3edit2
	sleep,80
	selText5:=Get_Selected_Text()
	gosub,hide
	gosub,Gui3_hide
	clipboard=%selText5%
	tooltip,pasting`n%selText5%
	sleep,700
	; send ^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	sleep,100
	tooltip

return
copy_sel_line:
	sleep,200
	guicontrol, 3: focus,gui3edit2
	sleep,80
	selText5:=Get_Selected_Text()

	clipboard=%selText5%
	tooltip,%selText5%
settimer,removetooltip,-700

return

copy_line:
	clipboard:=line
	sleep,50
	tooltip,%clipboard%
	settimer,removetooltip,-500
return

copy_all:
	gui, 3: submit,nohide
	clipboard:=gui3edit2
	sleep,50
	gosub,Gui3_hide
	tooltip,%clipboard%
	settimer,removetooltip,-800
return

show_all:

	LV_GetText(filepath,LV_GetNext(),2)
	fileread,gui3edit2,%filepath%
	guicontrol, 3: ,gui3edit2,%gui3edit2%
	tooltip,%line%
	settimer,removetooltip,-500
return

open_edit:

	LV_GetText(filepath,LV_GetNext(),2)
	run,%filepath%
return

copy_wordbutton1:
copy_wordbutton2:
copy_wordbutton3:
copy_wordbutton4:
copy_wordbutton5:
copy_wordbutton6:
copy_wordbutton7:
copy_wordbutton8:
copy_wordbutton9:
copy_wordbutton10:
copy_wordbutton11:
copy_wordbutton12:
copy_wordbutton13:
copy_wordbutton14:
copy_wordbutton15:
copy_wordbutton16:
copy_wordbutton17:
copy_wordbutton18:
copy_wordbutton19:
copy_wordbutton20:
copy_wordbutton21:
copy_wordbutton22:
copy_wordbutton23:
copy_wordbutton24:
copy_wordbutton25:
copy_wordbutton26:
copy_wordbutton27:
copy_wordbutton28:
copy_wordbutton29:
copy_wordbutton30:

Stringtrimleft, Button , A_Thislabel, 15

clipboard:=copy_word%Button%
tmp:=copy_word%Button%
tooltip,%tmp%
settimer,removetooltip,-500

return


ConnectedToInternet(flag=0x40)
{
    return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0)
}



from_internet:

ibc_matches=

	ibc_matches:=get_suggestions_google(SchStr)
	desc:=get_description_google(SchStr,7)
				
					
	desc:=para(desc, 45 )
	tooltip,%ibc_matches%`n`n%desc%,700,60,3
	return
keyword_sel:

gosub,preselection
SetTimer,search,-1
return

OnScroll(wParam, lParam, msg, hwnd)
{	static SIF_ALL=0x17, SCROLL_STEP=100

	bar := msg=0x115 ; SB_HORZ=0, SB_VERT=1

	VarSetCapacity(si, 28, 0)
	NumPut(28, si) ; cbSize
	NumPut(SIF_ALL, si, 4) ; fMask
	if !DllCall("GetScrollInfo", "uint", hwnd, "int", bar, "uint", &si)
		return

	VarSetCapacity(rect, 16)
	DllCall("GetClientRect", "uint", hwnd, "uint", &rect)

	new_pos := NumGet(si, 20) ; nPos

	action := wParam & 0xFFFF
	if action = 0 ; SB_LINEUP
		new_pos -= SCROLL_STEP
	else if action = 1 ; SB_LINEDOWN
		new_pos += SCROLL_STEP
	else if action = 2 ; SB_PAGEUP
		new_pos -= NumGet(rect, 12, "int") - SCROLL_STEP
	else if action = 3 ; SB_PAGEDOWN
		new_pos += NumGet(rect, 12, "int") - SCROLL_STEP
	else if action = 5 ; SB_THUMBTRACK
		new_pos := NumGet(si, 24, "int") ; nTrackPos
	else if action = 6 ; SB_TOP
		new_pos := NumGet(si, 8, "int") ; nMin
	else if action = 7 ; SB_BOTTOM
		new_pos := NumGet(si, 12, "int") ; nMax
	else
		return

	min := NumGet(si, 8, "int") ; nMin
	max := NumGet(si, 12, "int") - NumGet(si, 16) ; nMax-nPage
	new_pos := new_pos > max ? max : new_pos
	new_pos := new_pos < min ? min : new_pos

	old_pos := NumGet(si, 20, "int") ; nPos

	x := y := 0
	if bar = 0 ; SB_HORZ
		x := old_pos-new_pos
	else
		y := old_pos-new_pos
	; Scroll contents of window and invalidate uncovered area.
	DllCall("ScrollWindow", "uint", hwnd, "int", x, "int", y, "uint", 0, "uint", 0)

	; Update scroll bar.
	NumPut(new_pos, si, 20, "int") ; nPos
	DllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", &si, "int", 1)
}
	
getdate:
	;	date
	date=
	date_day_reg=((mon|tues?|wed(nes)?|thu(rs)?|fri|sat|sun)(day)?)
	date_dd_reg=([0-9])|([0-2][0-9])|([3][0-1])
	date_MMM_reg=(Jan(uary)?)|(Feb(ruary)?)|(Mar(ch)?)|(Apr(il)?)|(May)|(June?)|(July?)|(Aug(ust)?)|(Sep(t(ember)?)?)|(Oct(ober)?)|(Nov(ember)?)|(Dec(ember)?)
	date_separator_reg=[\-\s*_/]
	reg=i)^(%date_dd_reg%)%date_separator_reg%?(%date_MMM_reg%)$
	reg2=i)^(%date_MMM_reg%)%date_separator_reg%?(%date_dd_reg%)$
	reg3=i)^(%date_day_reg%)$
	a1:= RegExMatch(SchStr, reg)
	a2:= RegExMatch(SchStr, reg2)
	a3:= RegExMatch(SchStr, reg3)
	if ( a1 |a2 | a3)
	{
		reg11=i)(%date_dd_reg%)
		reg22=i)(%date_MMM_reg%)
		; RegExMatch(SchStr, reg11,SubPata)
		SubPata:=RegExreplace(SchStr, "\D","")
		RegExMatch(SchStr, reg22,SubPatb)
		tmp=jan`nfeb`nmar`napr`nmay`njun`njul`naug`nsep`noct`nnov`ndec
		loop,parse,tmp,`n,`r
		{
			tmp2:=A_index
			IfInString, SubPatb,%a_loopfield%
			{
				if (tmp2<10)
					tmp2=0%tmp2%
				mm:=tmp2
			}
		}

		if ( SubPata <10)
			date_dd=0%SubPata%	;	padding with 0
		else
			date_dd=%SubPata%
		date_MM:=mm
		sleep,10	; no idea
		FormatTime, year ,, yyyy


		date=%year%%date_MM%%date_dd%
		formatted_date=%year% %date_MM% %date_dd%
	}
	
	return	
	
update_filelist:	;	from quick search
	tmp_count++
	IfExist, %output_file%
	{
		fileread,tmp,%output_file%
		Loop, Parse, tmp,`n,`r
		{
			LV_Add("",A_LoopField,output_file,"file_folder",ext)
		}
		gosub,STOPSEARCH
	}
	else
	{
		if (tmp_count<8)	;	until timeout
			settimer,update_filelist,-150	
	}
return

WM_MOUSEMOVE(wParam, lParam, msg, hwnd)
{
	global
	If(hwnd = List)	;only if the mouse moved over the listview
	{	
		LV_MouseGetCellPos(LV_CurrRow, LV_CurrCol, List)
		If(oldLV_CurrRow != LV_CurrRow)	;if it has changed
		{	oldLV_CurrRow := LV_CurrRow
			ToolTip,,,, 20
			counter := A_TickCount + 500
			Loop	;loop for 500 ms and cancel tip if row changed
			{	LV_MouseGetCellPos(LV_CurrRow, LV_CurrCol, List)
				IfNotEqual, oldLV_CurrRow, %LV_CurrRow%
				{	SetTimer, KillNow, -1
					Return
				}
				looper := A_TickCount
				IfGreater, looper, %counter%, Break
				sleep, 150
			}
			; LV_GetText(txt1, LV_currRow, 1)
			
			LV_GetText(txt2, LV_currRow, 2)
			fileread,MyText,%txt2%
			SetTimer, killTip, 500
			
			if(StrLen(MyText)>500)
			{
				StringLeft, MyText, MyText,500
				MyText=%MyText%`n`n.........`n.........`n.........`n.........
			}
			ToolTip,#%txt2%:`n%MyText%,,,20
			
		}
		Return
		killTip:
			killTipCounter++
			MouseGetPos, , , outWm, outK, 2
			If(outK != List) or (killTipCounter >= 8)	;500ms*8 = ~4 secs
			{	;this lets us kill the tooltip immediately
				KillNow:
					SetTimer, killTip, Off
					ToolTip,,,, 20
					killTipCounter=0
				Return
			}
		Return
	}
	Else	;if not over lv, destroy tip
	{	
		SetTimer, killTip, -1	;go now once
	}
}	

LV_MouseGetCellPos(ByRef LV_CurrRow, ByRef LV_CurrCol, List)
{	
	LVIR_LABEL = 0x0002					;LVM_GETSUBITEMRECT constant - get label info
	LVM_GETITEMCOUNT = 4100			;gets total number of rows
	LVM_SCROLL = 4116						;scrolls the listview
	LVM_GETTOPINDEX = 4135			;gets the first displayed row
	LVM_GETCOUNTPERPAGE = 4136	;gets number of displayed rows
	LVM_GETSUBITEMRECT = 4152		;gets cell width,height,x,y
	ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %List%	;get info on listview

	SendMessage, LVM_GETITEMCOUNT, 0, 0, , ahk_id %List%
	LV_TotalNumOfRows := ErrorLevel	;get total number of rows
	SendMessage, LVM_GETCOUNTPERPAGE, 0, 0, , ahk_id %List%
	LV_NumOfRows := ErrorLevel	;get number of displayed rows
	SendMessage, LVM_GETTOPINDEX, 0, 0, , ahk_id %List%
	LV_topIndex := ErrorLevel	;get first displayed row
		CoordMode, MOUSE, RELATIVE
	MouseGetPos, LV_mx, LV_my
	LV_mx -= LV_lx, LV_my -= LV_ly
		VarSetCapacity(LV_XYstruct, 16, 0)	;create struct
	Loop,% LV_NumOfRows + 1	;gets the current row and cell Y,H
	{	LV_which := LV_topIndex + A_Index - 1	;loop through each displayed row
		NumPut(LVIR_LABEL, LV_XYstruct, 0)	;get label info constant
		NumPut(A_Index - 1, LV_XYstruct, 4)	;subitem index
		SendMessage, LVM_GETSUBITEMRECT, %LV_which%, &LV_XYstruct, , ahk_id %List%	;get cell coords
		LV_RowY := NumGet(LV_XYstruct,4)	;row upperleft y
		LV_RowY2 := NumGet(LV_XYstruct,12)	;row bottomright y2
		LV_currColHeight := LV_RowY2 - LV_RowY ;get cell height
		If(LV_my <= LV_RowY + LV_currColHeight)	;if mouse Y pos less than row pos + height
		{	LV_currRow  := LV_which + 1	;1-based current row
			LV_currRow0 := LV_which		;0-based current row, if needed
			;LV_currCol is not needed here, so I didn't do it! It will always be 0. See my ListviewInCellEditing function for details on finding LV_currCol if needed.
			LV_currCol=0
			Break
		}
	}
}
copy_field_by_field:
	LV_GetText(filepath,LV_GetNext(),2)
	LV_GetText(line,LV_GetNext(),1)
	fileread,text_tmp,%filepath%
	field_by_field_pos++

	delimiter=`n
	delimiter_all=,`;`:`"`=.&
	loop,parse,delimiter_all
	{
		; msgbox,%a_loopfield%
		ifinstring,line,%a_loopfield%
		{
			delimiter=%a_loopfield%
			break
		}
	}
	Position := 0
	loop,parse,line,%delimiter%
	{
		Position += StrLen(A_LoopField) + 1
		; Retrieve the delimiter found by the parsing loop.
		Delimiter := SubStr(line, Position, 1)
item:=a_loopfield
		item := RegExReplace(item, "^\s+|\s+$") 	;trim whitespace
		if ( A_index = field_by_field_pos )
		break
		if item=""
		continue			
	}
	tooltip,delim=%delimiter%`n%field_by_field_pos% =%item%
	settimer,removetooltip,2000
	return

#IfWinActive, SMART_SEARCH

	>^enter::	; copy next field

#IfWinActive

	if (HotkeySTEP88)	;	if hotkey is currently in cycle mode
	{
		gosub, copy_field_by_field

	}
	else
	{
		HotkeySTEP88_count:=0	
		field_by_field_pos:=0		
		gosub, copy_field_by_field
	}
		settimer,removetooltip,-2500
HotkeySTEP88:=1
	hotkey,^q,on	;	cancelling hot key is made vigilant
	setTimer,HotkeySTEP88,70
	setTimer,HotkeySTEP88_sleep,-2500
	sleep,10
	return
	HotkeySTEP88_sleep:	;	cancel after a delay even if ctrl is pressed
	gosub,cancelHotkeySTEP88		
	settimer,removetooltip,-10
		return

HotkeySTEP88:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		gosub,cancelHotkeySTEP88
		tooltip,executing %msg%
		settimer,removetooltip,-600	
		clipboard:=item
		; tooltip,copied,0,-20,2
		; sleep,200
		; settimer,removetooltip2,800
	}
	return

cancelHotkeySTEP88:	;	cancel without action
	setTimer,HotkeySTEP88,off
	setTimer,HotkeySTEP88_sleep,off
	HotkeySTEP88:=0
	HotkeySTEP88_count:=0
	hotkey,^q,off
	return

	$^q::	; na
	if  (HotkeySTEP88)
	{
		gosub,cancelHotkeySTEP88
	}
	else
	{
		send ^q
	}
	Return

calculator:
	calculator_mode:=0
	; calculator	

	reg=[a-zA-Z_]	;	include invalid math symbols
	if ( !RegExMatch(SchStr, reg) )
	{
		if SchStr contains +,-,*,/,`%	; %
		{
			; it is an expression
			if SchStr contains 1,2,3,4,5,6,7,8,9,0
			{
				
				; reg=\D+$	;	remove trailing operators like 12+5+ or 2*(
				reg=([/\+\*\(-])+$
				expression1:=SchStr
				if ( RegExMatch(SchStr, reg) )
				{
					expression1:=RegExreplace(SchStr, reg)
					; msgbox,%expression1%
				}
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
				loop % left_paranthesis-right_paranthesis
				expression1 .= ")"	;	append ) automatically
				; ifinstring,expression1,(
				; file = C:\$temp$.ahk
				tmpfile = %A_temp%\$temp$.ahk             ; any unused filename
				; tmpfile = C:\$temp$.ahk           ; any unused filename ; use C:\
				; Gui Add, ComboBox, X0 Y0 H1 W300 vExpr
				; GuiControlGet Expr,,Expr      ; get Expr from ComboBox
				; GuiControl,,Expr,%Expr%       ; write Expr to internal ComboBox list
				; Expr:=expression1
				FileDelete %tmpfile%             ; delete old temporary file -> write new
				FileAppend #SingleInstance Force`n#ErrorStdOut`n#NoTrayIcon`nFileDelete %tmpfile%`nFileAppend `% %expression1%`, %tmpfile%, %tmpfile%
				RunWait %A_AhkPath% %tmpfile%    ; run AHK to execute temp script, evaluate expression %
				FileRead Result, %tmpfile%       ; get result
				FileDelete %tmpfile%
				; GuiControl,,Expr,%Result%     ; write Result to internal ComboBox list
				; N += 2                        ; count lines
				; GuiControl Choose,Expr,%N%    ; show Result
				
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
				result_tooltip=%result_tooltip%.%dec_value%	 ;`n%compact_result% `n%result%
				
				calc_tooltip=%calculator_hist%`n`n%expression1%`n%a_tab%=%result_tooltip%
				
				calc_tooltip:=regexreplace(calc_tooltip,"^(\n)+","")

				tooltip,%calc_tooltip%,254,-50,2
				GuiControl,Focus,visibleSchStr
				
				ifnotinstring, expression1,%last_expression%	;	 new expression
				{
					calculator_hist=%calculator_hist%`n%last_calc_event%
					if (strlen(calculator_hist)>150)
					Stringright, calculator_hist, calculator_hist, 120

				}
				last_expression:=expression1
				last_calc_event=%expression1%`n%a_tab%=%Result%
				
				Gui +LastFound
				WinSet, Region, 0-26 w%width2% H35
				calculator_mode:=1
				Goto,StopSearch
			}
		}
	}

	return

	Levenshtein_distance( s, t )
	{
		n := StrLen(s)
		IfEqual n,0, Return m
		m := StrLen(t)
		IfEqual m,0, Return n

		d0_0 = 0
		Loop %n%
		d0_%A_Index% := A_Index
		Loop %m%
		d%A_Index%_0 := A_Index

		Loop Parse, s
		{
			i  = %A_Index%
			i1:= i-1
			si = %A_LoopField%
			Loop Parse, t
			{
				j1 := A_Index - 1
				d%A_Index%_%i% := min( d%A_Index%_%i1%+1, d%j1%_%i%+1, d%j1%_%i1%+(si <> A_LoopField) )
			}
		}
		Return d%m%_%n%
	}

	min( a, b, c )
	{
		IfLess b, %a%, SetEnv a, %b%
		IfLess c, %a%, Return c
		Return a
	}
	timer_alarms:
	reg=\d?\d:\d?\d?
	if ( RegExMatch(SchStr, reg) )
	{
		Contents:=regexreplace(SchStr,"[^\d\.:]", "$1")
		if (contents<60)	;	valid time
		{
			list = 
			list .= "set alarm at " . SchStr . "am," . ext . ",timer," . ext . "`n"
			list .= "set alarm at " . SchStr . "pm," . ext . ",timer," . ext . "`n"
			list .= "set alarm after " . SchStr . ","  . ext . ",timer," . ext . "`n"
			list .= "set alarm after 30 min," . ext . ",timer," . ext . "`n"
			list .= "set alarm after 1 Hour," . ext . ",timer," . ext . "`n"
			load_csv_to_listview(list)
			tooltip,set alarm at %SchStr%,250,-16,2
			sleep,1000
			settimer,removetooltip,-4000
		}
	}

	return
currency:
reg=\$$|^\$
if ( RegExMatch(SchStr, reg) )
{
	prefix=$

	;	cleaning unwanted	
	Contents:=regexreplace(SchStr,"\n\r", "")
	Contents:=regexreplace(SchStr,"`,", "")
	Contents:=regexreplace(SchStr,"[^\d\.]", "$1")

	dollar_rate:=62
	pound_rate:=77
	r:=Contents*dollar_rate
	p:=Contents*pound_rate
	r:=Round(r,2)		
	p:=Round(p,2)
	;	add thousands separator
	Contents:=RegExReplace(Contents, "(?(?<=\.)(*COMMIT)(*FAIL))\d(?=(\d{3})+(\D|$))", "$0,")				
	r:=RegExReplace(r, "(?(?<=\.)(*COMMIT)(*FAIL))\d(?=(\d{3})+(\D|$))", "$0,")				
	p:=RegExReplace(p, "(?(?<=\.)(*COMMIT)(*FAIL))\d(?=(\d{3})+(\D|$))", "$0,")				
	tooltip,%prefix% %Contents%  = Rs %r%`t[%dollar_rate%]`n%p% `tif pounds[%pound_rate%],250,-36,2
}

return
	
checkdate:
	if schstr between 1 and 31
	{	FormatTime, date ,, yyyyMM
		date=%date%%date_MM%%schstr%
		FormatTime, TimeString, 20050423220133, dddd MMMM d, yyyy hh:mm:ss tt
	}
	else
		gosub,getdate
	if (date)	
	{
		FormatTime, TimeString, %date%, %formatted_date%: dddd
		LV_Add("icon" . 2,TimeString,ext,"calendar",ext)
		LV_Add("icon" . 2,"go 2 calendar",ext,"calendar",ext)
		; Date_today := SubStr(A_Now,1,8)
		tooltip,go to %SchStr% in calendar,250,-16,2
		guicontrol,1: show,DateMain
		guicontrol,1: ,DateMain,%date%
		;guicontrol, Move, ResultList,w700
		; get entries on this date
		gosub,check_calendar
		;sleep,1000
		settimer,removetooltip,-4000
	}	
	else
		guicontrol,1: hide,DateMain
		return
keyword_search()
{
	global
	SchStr_Tmp=i)^%SchStr%
	source_Filename=%A_ScriptDir%\smart_search_keywords.ini
	Loop, Parse, all_keywords,`n,`r
	{
		if RegExMatch(A_LoopField,SchStr_Tmp)
		{
			LV_Add("icon" . 1,A_LoopField,filepath,"keyword",t2,source_Filename)
		}
	}
}
recent_windows_and_files()
{
	global
	list := WinGetAll()
	SchStr_Tmp:=make_lookarounds(SchStr," ")
	SchStr_Tmp=i)%SchStr_Tmp%
	Loop, Parse, list,`n,`r
	{
	 	;msgbox,%A_LoopField%, %SchStr_Tmp%
		if RegExMatch(A_LoopField,SchStr_Tmp)
			LV_Add("icon" . 1, A_LoopField,"recent window","","","recent window")
	}
}

action_activate_window:
	LV_GetText(WinTitle,LV_GetNext(0),1)
	WinActivate, %WinTitle%
	Return


^+7:: ; last run action smart action	
	tooltip,%arg%
	keywait,Shift
	run, smart_functions.py "%arg%"
	ToolTip, 

Return
;space & t::

search_box_size:
;tooltip, % strlen(visibleSchStr)
;sleep,50
; to do: donot run if already resized
if strlen(visibleSchStr)<20
	return
else if strlen(visibleSchStr)<30
{
	Gui, Font, s11
	GuiControl, Font, visibleSchStr
	GuiControl, Move, visibleSchStr, w550
	GuiControl, Move, keywordChoice, x552  w150

}
else if strlen(visibleSchStr)>30
{
	Gui, Font, s9 ;cred
	GuiControl, Font, visibleSchStr
	GuiControl,  Move, visibleSchStr, w600
	GuiControl,  Move, keywordChoice, x602  w100
}
return

action_smart_action:
	if ( keyword_type="smart_search_commands")
	{
		LV_GetText(action,LV_GetNext(),1)
		if IsLabel(action)
		{		
			goto, %action%
			return
		}	
	}
	arg := action_term
	stringreplace,arg,arg,",\",all	
	; run, smart_functions.py "%arg%"
	args = "decode_and_execute" "%arg%" "%SchStr%"
	;msgbox,%args%
	Gui, 1: Font,  cred 
	guicontrol,1: font ,action_term_selected
	guicontrol,1:,action_term_selected,%action_term% running
	final_result := send_to_python_script_debug("C:\cbn_gits\AHK\smart search\smart_search_api.py",args)
	;msgbox,%final_result%
	Gui, 1: Font,  cgreen 
	guicontrol,1: font ,action_term_selected
	guicontrol,1:,action_term_selected,%action_term% loaded
	settimer,removetooltip,1000
	tooltip, %final_result%
	gosub,guiHeight
	last_run_action := arg
	return

^+y:: ; show as tooltip again
	settimer,removetooltip,3000
	tooltip,result=%final_result%

	return

copy_full_results:
^+o:: ; copy results
	settimer,removetooltip,3000
	tooltip,copied
	sleep,300
	tooltip
	clipboard := final_result

	return
	
load_result_into_listview_continue_smart_action:
^+t:: ; load to listview
	load_csv_to_listview(final_result)
	gosub,guiHeight

	return
	
load_result_and_search_in_result:
^+u:: ; search in results
	load_csv_to_listview(final_result)
	gosub,guiHeight
	filedelete,C:\cbn_gits\AHK\smart search\search_in_result.txt
	fileappend,%final_result%,C:\cbn_gits\AHK\smart search\search_in_result.txt
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	
	SelectedLine=search_in_result
	stringreplace,keywordChoice_new,keywordChoice_all,||,|
	stringreplace,keywordChoice_new,keywordChoice_new,%SelectedLine%|,%SelectedLine%||
	; msgbox,%keywordChoice_new%
	; guicontrol,,visibleSchStr,
	guicontrol,1:,keywordChoice,%keywordChoice_new%
	return

send_to_python_script_run(script_pathname,args)
{
	global text_changed
	Random, output_filename, 1000000, 100000000
	output_filename = python_output_%output_filename%.txt
	filedelete,%output_filename%
	Run, %script_pathname% %output_filename% %args%,, Hide,OutputVarPID	
	exist := 1
	n:=0
	while (exist && !text_changed)
	{
		;n++
		;tooltip,%n% sent waiting run %exist% && %text_changed%,,120,2
		Process, Exist , %OutputVarPID%
		exist := ErrorLevel
	}
	;tooltip,%n% sent waiting finishedddddddd %exist% && %text_changed%,,120,2
	if (text_changed)
		return
	;tooltip,sent recievd run,,140,3
	fileread,result,%output_filename%
	filedelete,%output_filename%	
	return result
}