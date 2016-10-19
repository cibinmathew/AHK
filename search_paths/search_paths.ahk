; to do
; if triggered from npp, prevent opening other files like images in npp itself
; for npp, parse opened file names also
npp_path=C:\Program Files (x86)\Notepad++\notepad++.exe
sublime_text_path=C:\Program Files\Sublime Text 3\sublime_text.exe
eclipse_path=C:\users\%A_UserName%\Desktop\eclipse-java-luna-SR2-win32-x86_64\eclipse\eclipse.exe
#include C:\cbn_gits\AHK\! new smart run lib.ahk
#include C:\cbn_gits\AHK\LIB\HK_Cycle dev2.ahk
#SingleInstance Force
SplitPath, A_ScriptDir , OutFileName, OutDir, OutExtension, OutNameNoExt, A_Script_Drive
run_mode:=0
ifexist,search.ico
	menu, Tray, Icon, search.ico
else
	menu, Tray, Icon, Shell32.dll, 23
#Persistent
setTimer,update_db,14400000
#NoEnv
SendMode Input

SetWorkingDir %A_ScriptDir%
FileEncoding,UTF-8
#MaxMem 200
gui_shown:=0
SetBatchLines -1


HKC_Group_register("F4", "search_HK",500,"")
config =
(
recent files, common, all
,
,
search_in_recent_files,search_in_common,search_in_everywhere
,
)

HKC_Key_register("F4", "search_HK",config,"aux")


quicksearch_db_file =%A_Script_Drive%\cbn\ahk\quick search\db\1_folder_list.qsearch
recently_used_file =%A_Script_Drive%\cbn\ahk\search_paths\recently_used_files.txt
opus_recent_file =C:\Users\%A_UserName%\AppData\Local\GPSoftware\Directory Opus\State Data\recent.osd
more_paths_frequent_file=more paths frequent.txt
more_paths_file=more paths.txt
search_shortcuts_file =%A_Script_Drive%\cbn\opus\shortcuts\search shortcuts.txt
recent_searches_file =recent_searches.txt

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA

appname=search_paths.ahk
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
#include C:\cbn_gits\AHK\LIB\contextmenu.ahk
setupMenu ("Context1_icons")
name=simple search 
intelligent_level=2
recent_searches=
Gui,   +AlwaysOnTop  +border +LastFound +toolwindow   -caption 	;	+resize 

Gui, 1: font,s11 ,segoe
Gui, 1: add,text,x2 y0 h16 w450 vtext_folder cgreen ,
Gui, 1: add,text,x+10 y0 h16 w550 vtext_folder2 cblue ,
Gui, 1: add,Button,x0 h28 y17 w30 ghide ,X
Gui,  add,Edit,x30  yp+1 vvisibleSchStr h26  w200 hWndEd1  +0x100,downloads	; -WantReturn
Gui, 1: add,Button,x+0 yp-1 h28 w40 gdel_schstr ,X
Gui, 1: add,text, x+10 h21 yp+7  vstats1 cred ,nnnnn/nnnnnn files
Gui, 1: font,s12
Gui, Add, ListView, x0 y+0 w950 r15  vResultList  gListEvent  hwndhList      AltSubmit,Name|path

gosub,icons
; gosub,disp_gui
gosub,update_db ; updates static contents
gosub,get_contents_dynamic
gosub,append_static
gosub,index
return

launch:	;	launch updating only dynamic db's
	gosub,disp_gui
	gosub,get_contents_dynamic
	gosub,append_static
	gosub,index

return

get_contents_dynamic:
	all_files =
	files =
	files2 =
	fileread, files2,%more_paths_frequent_file%
	files :=  files2
	fileread, files2, %search_shortcuts_file%

	files .= "`n" files2
	fileread, recent_searches,%recent_searches_file%	; recently searched entries in the gui
	sort,recent_searches,R
	; msgbox,%recent_searches%
	all_files := recent_searches "`n" files
	gosub,get_contents_opus_recent
	all_files .= "`n" opus_recents
	all_files := remove_duplicates( all_files )
	; msgbox,%all_files%
	; clipboard := all_files
	all:=all_files
return

append_static: 
	all .= "`n" . all_files2
return

get_contents_static:
	all_files2 = 
	fileread,files2,%more_paths_file%
	all_files2 := files2
	fileread,files2,pathlist.txt
	all_files2 .= "`n" files2
	all_files2 := RegExReplace(all_files2, "im)^\s+|\s+$")

return

index:

	actual_file_names_all := Object()
	file_fullpath_list_all := Object()
	file_names_volatile_all := Object()
	all_tmp = 
	Loop, parse, all,`n,`r 
	{
		file_fullpath_list_all.Insert(A_Loopfield) ; Append this line to the array.
		splitpath,A_Loopfield,fname
		actual_file_names_all.Insert(fname) ; Append this line to the array.
		fname:=make_text_search_smart(fname,intelligent_level,1)
		file_names_volatile_all.Insert(fname) ; Append this line to the array.
		total_files:=A_index
		all_tmp .= a_loopfield "`n"				
	}
	all:=all_tmp
	stringtrimright, all,all,1
	guicontrol,,stats1,%total_files% files
	
return
disp_gui:
	; LV_Delete()	
	; NewKeyPhrase=
	Coordmode, Mouse, Screen 
	MouseGetPos,nx,ny
	Coordmode, Mouse, relative
	if ny>180
		ny:=180
	if nx>410
		nx:=410
	x:=nx +5 ;+30
	y:=ny	+5 ; +20
	sleep,150
	gui,1:show,x%x%  y%y%  w950 ,search_paths
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
	GuiControl,Focus,visibleSchStr
	SetTimer, IncrementalSearch, 300
	tooltip,F6:: index sel folder`nF4 & F3:: everywhere`nF3 & F4:: recent`npress  TAB`tf & k:: down`n>+enter:: in N++,270,-80,3
	SetTimer, CheckMouse, 300
	gui_shown:=1
	hotkey,esc,on
Return

INCREMENTALSEARCH:

	Gui, Submit, NoHide
	CurFilename = %visibleSchStr%
	If NewKeyPhrase <> %CurFilename%	
	{	
		SetTimer,search,-1
		NewKeyPhrase = %CurFilename%
		;Sleep, 100 ; DON'T HOG THE CPU!
	}
	Else
	{
		; QUERY STRING HAS STOPPED CHANGING
		;Break
	}
Return

SEARCH:

	Gui, Submit, NoHide
	SchStr:=visibleSchStr

	StopSearch=0

	matchlist=	
	matchlist2=	
	matchlist3=	
	matchlist4=	
	matchlist5=	
	matchlist6=	
	matchlist7=
	matchlist11=
	
	matchlist_names=
	matchlist_names2=	
	matchlist_names3=	
	matchlist_names4=	
	matchlist_names5=	
	matchlist_names6=	
	matchlist_names7=	
	matchlist_names11=
	search_in_progress := 1

	if ((SchStr ="" ) OR	(SchStr ="\\")OR	(SchStr ="/"))					;if empty query
	{
		; SchStr=(\\|/)	;	matches all valid full pathnames
		LV_Delete()	
		if ( searchInDir = 1 )
		{
			t := all_original
		}
		else
		t:= opus_recents "`n" . recent_searches
		loop,parse,t,`n,`r	
		{
			FileName:=a_loopfield
			gosub,get_iconnumber
			stringreplace,file,a_loopfield,%searchInFolder%\
			LV_Add( "Icon" . IconNumber, file,a_loopfield)
		}
		GuiControl, Show, ResultList
		Goto,StopSearch
		return
	}
	GuiControl, Show, ResultList
	LV_Delete()
	FilesMatch=0
	word_count:=0
	SchStr2=
	SchStr3=
	SchStr4=
	SchStr5=
	SchStr6=
	SchStr7=
	SchStr8=
	if ( searchInDir = 1 )
	{	
		SchStr3=
		SchStr:=make_text_search_smart(SchStr,2,0)

	}
	else
		SchStr:=make_text_search_smart(SchStr,0,0)
	stringreplace,SchStr,SchStr,%a_space%,+,All
	SchStr:=make_lookarounds(SchStr,"+")
	loop,parse,SchStr,%a_space%
	{
		word_count++
		SchStr2 .= A_loopfield . ".*"
		if ( ( word_count=1 ) AND ( strlen(A_loopfield)) )
		{
			SchStr3 .= "^" . A_loopfield . ".*"
			SchStr6 .= "^" . A_loopfield . "[^\\]*"
		}
		else
		{
			SchStr3 .= "\b" . A_loopfield . ".*"
			SchStr6 .= "\\" . A_loopfield . "[^\\]*"
		}
	}
	
	SchStr1=i)%SchStr2%
	SchStr3=i)%SchStr3%
	stringtrimright,SchStr4,SchStr3,2
	; stringtrimright,SchStr7,SchStr6,
	; SchStr7 := SchStr6 "$"
	stringtrimright,SchStr7,SchStr6,6
	SchStr6 := "i)" SchStr6 "$"
	SchStr7 := "i)^" SchStr7
	SchStr5 := SchStr4 "$"
	SchStr4 .= "[^\\]*$"
	SchStr11 := "i)^" visibleschstr "$"
	regex_patterns=SchStr=%SchStr% 11=%SchStr11%  1=%SchStr1%  2=%SchStr2%  3=%SchStr3%  5= %SchStr5%  4=%SchStr4%  6= %SchStr6%  7= %SchStr7%
	file_lineNo_all := Object()
	; msgbox,%schstr1% %schstr2%
	loop,parse,all,`n,`r
	{
		if ( searchInDir = 1 )
			{
				splitpath,a_loopfield,file				
			}
		else
			file:=a_loopfield
		file:=make_text_search_smart(file,0,1)		
			
		if RegExMatch(file,SchStr1)
		{
			file_lineNo_all.Insert(A_index)			
			matchlist .= file_fullpath_list_all[A_index] "`n" 
			b := file_fullpath_list_all[A_index] "`n" 
			matchlist_names .= actual_file_names_all[A_index] "`n"
			a:=actual_file_names_all[A_index]
		}
	}
	stringtrimright ,matchlist, matchlist,1
	stringtrimright ,matchlist_names, matchlist_names,1
	loop,parse,matchlist_names,`n,`r
	{
		lineNo:=file_lineNo_all[A_index]
		a:=actual_file_names_all[lineNo]
		b:=file_fullpath_list_all[lineNo]
		; msgbox,%b%
		
		if RegExMatch( a_loopfield,SchStr11)
		{			
			matchlist11 .= A_LoopField "`n"
			matchlist_names11 .= lineNo  "`n"
		}
		else if RegExMatch( a_loopfield,SchStr7)
		{			
			matchlist7 .= A_LoopField "`n"
			matchlist_names7 .= lineNo  "`n"
		}
		else if RegExMatch( a_loopfield,SchStr6)
		{			
			matchlist2 .= A_LoopField "`n"
			matchlist_names2 .= lineNo  "`n"
		}
		else if RegExMatch( a_loopfield,SchStr5)
		{
			matchlist3 .= A_LoopField "`n"
			matchlist_names3 .= lineNo  "`n"
		}
		else if RegExMatch( a_loopfield,SchStr4)
		{
			matchlist4 .= A_LoopField "`n"
			matchlist_names4 .= lineNo  "`n"
		}
		else if RegExMatch(a_loopfield,SchStr3)
		{
			matchlist5 .= A_LoopField "`n"
			matchlist_names5 .= lineNo  "`n"
		}
		else
		{
			matchlist6 .= A_LoopField "`n"
			matchlist_names6 .= lineNo  "`n"
		}	
	} 
	; msgbox,%matchlist11%
	matchlist=
	matchlist_names=
	matchlist .= matchlist11 . matchlist7 . matchlist2 . matchlist3 . matchlist4 . matchlist5 . matchlist6
	; msgbox,%matchlist%
	matchlist_names .= matchlist_names11 . matchlist_names7 . matchlist_names2 . matchlist_names3 . matchlist_names4 . matchlist_names5 . matchlist_names6
	matchlist := regexreplace( matchlist,"m)^(?:[\t ]*(?:\r?\n|\r))+","")
	matchlist_names := regexreplace(matchlist_names,"m)^(?:[\t ]*(?:\r?\n|\r))+","")
	stringtrimright , matchlist,matchlist,1
	stringtrimright , matchlist_names, matchlist_names,1
	; msgbox,w %matchlist%=
	text= 
	file_lineNo_all := Object()
	Loop, Parse, matchlist_names,`n,`r
	{	
		file_lineNo_all.Insert(a_loopfield)	
	} 
	Loop, Parse, matchlist,`n,`r
	{
		if ( (a_index>50) OR (A_Loopfield= ) )
			break
		text .= A_Loopfield "`n"
	} 
	matchlist:=text
	stringtrimright ,matchlist,matchlist,1
	; matchlist :=remove_duplicates( matchlist )
;============;;
STOPSEARCH:  ;;
;============;;

	Oldschstr:=schstr
	matchlist:=regexreplace(matchlist,"m)^\n","")	
	Loop, Parse, matchlist,`n,`r
	{	
		lineNo:=file_lineNo_all[A_index]	
		fname:=	actual_file_names_all[lineNo]
		full:=	file_fullpath_list_all[lineNo]
		FileName:=full
		; msgbox,%full%
		gosub,get_iconnumber
		if ( searchInDir = 1 )	
			LV_Add( "Icon" . IconNumber, fname,full )
		else
			LV_Add( "Icon" . IconNumber, full,full )
	} 
	GuiControl, Show, ResultList
	; guicontrol,,text_folder,%searchInFolder%
	guicontrol,,text_folder2,%regex_patterns%
	t:=LV_GetCount()
	guicontrol,,stats1,%t% / %total_files% files
	; GuiControl,, ResultList,r8
	LV_ModifyCol() 
	LV_ModifyCol(1,"AutoHdr")
	LV_Modify(1, "Select")
	gosub, find_suggestions
return

ListEvent: 
	if (A_GuiEvent = "DoubleClick")
	{
	}
	if (A_GuiEvent = "normal")
	{
		selected:=LV_GetNext()
		if (selected<1)
			Return
		guicontrol,1: focus,ResultList
		gosub,open
	}
	else If (A_GuiEvent = "K")
	{	

	}
Return

GuiContextMenu:
	If (A_GuiControl = "ResultList" && A_GuiControlEvent = "RightClick")    ; Only show menu when listview is right clicked.
	{
		LV_GetText(FileFullpath,LV_GetNext(),2)	
		Menu Context1, Show, %A_GuiX%, %A_GuiY%
	}
	return 

MenuEvent:
	If ( !ThisMenuItem )
	   ThisMenuItem = %A_ThisMenuItem%
	menuEvent_function(ThisMenuItem,FileFullpath)
	ThisMenuItem=
return	

removetooltip:
	tooltip,
	settimer,removetooltip,off
return

del_schstr:
	guicontrol,,visibleschstr,

return

guiclose:
~esc::	; na
	Gosub,hide
	SetTimer, CheckMouse, off
	hotkey,esc,off
return

hide:
	Gui, hide
	tooltip,,,,3
	tooltip
	SetTimer, IncrementalSearch, off
	; exitapp
	gui_shown:=0
	run_mode:=0
return

~lbutton::	; na
	gosub,checkMouse
return

CheckMouse:	; check mouse position

	IfWinNotActive,search_paths ahk_class AutoHotkeyGUI
	{
		gosub,hide
		SetTimer, CheckMouse, off
		; exitapp
		return
	}
return



; #IfWinActive, search_paths.ahk
#IfWinActive,search_paths ahk_class AutoHotkeyGUI

`::
	LV_GetText(FileFullpath,LV_GetNext(),2)
	smart_run_open(FileFullpath)
return

<+enter::	; na
	LV_GetText(FileFullpath,LV_GetNext(),2)	
	splitpath,filefullpath,,outdir
	menuEvent_function("OpenIfFolder_SelectIfFile",FileFullpath)
	; settimer,removetooltip,-300
	gosub,hide
	; update_recently_used_files(FileFullpath)
	
return
>+enter::	; na
	LV_GetText(FileFullpath,LV_GetNext(),2)	
	menuEvent_function("N++",FileFullpath)
	tooltip,opening %FileFullpath% in N++
	sleep,1000
	settimer,removetooltip,-300
	gosub,hide
	update_recently_used_files(FileFullpath)
	
return


^Enter::	; na
	Gui, Submit
	LV_GetText(FileFullpath,LV_GetNext(),2)
	menuEvent_function("open",FileFullpath)
	gosub,hide
return

Tab::
	Gui, Submit,nohide
	
	gosub, apply_suggestions
return

F6::
foldercontent:
; tab::	; na
	; if ( searchInDir = 1 )
		; return
	Gui, Submit,nohide
	LV_GetText(FileFullpath,LV_GetNext(),2)
	if !(InStr(FileExist(FileFullpath), "D"))
		SplitPath, FileFullpath,, FileFullpath
	gosub,smart_ranking
	tooltip,folder content %FileFullpath%
	sleep,550
	FileFullpath := RegExReplace(FileFullpath, "m`n)^[ \t]+", "")	;leading 
	FileFullpath := RegExReplace(FileFullpath, "m`n)[ \t]+$","")		;trailing
	searchInFolder:=FileFullpath
	gosub,searchInFolder_Index
	GuiControl,Focus,visibleSchStr
return

/*
wheeldown::	; na
	ControlGetFocus, OutputVar 
	tooltip 
	if (OutputVar="visibleSchStr")
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
	msgbox
	ControlGetFocus, OutputVar 
	if (OutputVar="visibleSchStr")
	{
		control=syslistview321
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
		SendMessage, 0x115, 0, 0,%control%	;	Scroll up by one line (for a control that has a vertical scroll bar)
	}
	else 
		send {wheelup}
return
*/

wheelup::	; na
	control=syslistview321
	SendMessage, 0x115, 0, 0,%control% ;	Scroll 
return

wheeldown::	; na
	control=syslistview321
	SendMessage, 0x115, 1, 0,%control% ;	Scroll 
return

f & i::	; na
up::	; na

	; guicontrol,focus,syslistview321
	selected:=LV_GetNext()
	selected-=1
	if (selected<1)
		selected:=LV_GetCount()
	LV_Modify(0, "-Select")
	LV_Modify(selected, "Select") 
	LV_Modify(selected, "Vis")
return	

f & k::	; na
Down::	; na
  

	; guicontrol,focus,syslistview321
	selected:=LV_GetNext()
	selected+=1
	LV_Modify(0, "-Select")
	LV_Modify(selected, "Select")  
	LV_Modify(selected, "Vis")
return	

Enter::	; na
	gosub, open
return

$f::	; na
	StringRight, thisKey, A_ThisHotkey, 1
	send %thiskey%
return

#IfWinActive

searchInFolder_Index:
	pathdelimiter=|
	ListFile=%A_ScriptDir%\foldercontent.txt
	indexfiles(searchInFolder,pathdelimiter,ListFile,0,0,index_recurse)
	fileread,foldercontent,%ListFile%
	names_volatile:=make_text_search_smart(foldercontent,intelligent_level)
	filedelete,%A_ScriptDir%\foldercontent_volatile.txt
	FileAppend, %names_volatile%,%A_ScriptDir%\foldercontent_volatile.txt		
	all:= foldercontent
	all_original := foldercontent
	gosub,index
	searchInDir:= 1
	all:=names_volatile
	tooltip,
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	; preselects the text
	LV_delete()
	loop,parse,foldercontent,`n,`r
	{
		splitpath,A_LoopField,fname
		FileName:=A_LoopField
		gosub,get_iconnumber
		LV_Add("Icon" . IconNumber,fname,A_LoopField)
		total_files:=A_index
	}
	guicontrol,,text_folder,%searchInFolder%
	guicontrol,,stats1,/ %total_files% files	
return

open:
	Gui, Submit
	LV_GetText(FileFullpath,LV_GetNext(),2)

	gosub,smart_ranking
	tooltip,%FileFullpath%
	sleep,250
	SplitPath, FileFullpath, , , OutExtension
	if (active_window)
	; to do 
		; if OutExtension in txt,ini,ahk,py
		run,"%active_window_path%" "%FileFullpath%"
	else
		menuEvent_function("OpenIfFolder_SelectIfFile",FileFullpath)
	gosub,hide
	tooltip,
	; if ((run_mode=1) OR (run_mode=2))
	gosub,update_recent_used_files
return

update_recent_used_files:
	update_recently_used_files(FileFullpath)
return

icons:
	ImageListID1 := IL_Create(10)
	ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.
	; Attach the ImageLists to the ListView so that it can later display the icons:
	LV_SetImageList(ImageListID1)
	LV_SetImageList(ImageListID2)
	; IL_Add(ImageListID1, "shell32.dll", 234)	; for offline file
	IL_Add(ImageListID1, "shell32.dll", 278)	; for offline file
	IL_Add(ImageListID1, "shell32.dll", 274)	; for offline file
	IL_Add(ImageListID1, "shell32.dll", 277)	; for offline file
	IL_Add(ImageListID1, "shell32.dll", 275)	; for offline file
	IL_Add( ImageListID1, "shell32.dll", 276)	; for offline file
	IL_Add( ImageListID1 , A_ScriptDir . "\f_blue.ico" )
	IL_Add( ImageListID1 , A_ScriptDir . "\g_gold.ico" )
	IL_Add( ImageListID1 , A_ScriptDir . "\h_grey.ico" )
	IL_Add( ImageListID1 , A_ScriptDir . "\i_lg.ico" )
	VarSetCapacity(FileName, 260)
	sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
	VarSetCapacity(sfi, sfi_size)
return

; #IfWinActive, ahk_class ExploreWClass


#IfWinActive, search_paths
$f3::	; na
#IfWinActive, ahk_class CabinetWClass
$f3::	; na
#IfWinActive, ahk_class ExploreWClass
$f3::	; na
#IfWinActive, ahk_class dopus.lister
$f3::	; na
#IfWinActive, ahk_class ThunderRT6FormDCk
$f3::	; na
#IfWinActive, ahk_exe XYplorerFree.exe

$f3::	; na
#IfWinActive
active_window=

	if ( gui_shown )
	{

		run_mode:=2
		tooltip,recursing
		index_recurse:=1
		gosub, search_folder
		index_recurse:=0
		tooltip
		LV_ModifyCol() 
		return
	}
	else
	{
		source_path:=get_parent_filepath()
		run_mode:=1
		gosub, search_folder
		return
	}
return

#IfWinActive,ahk_exe eclipse.exe
$f3::	; na

	active_window=eclipse.exe
	active_window_path:=eclipse_path
	fileread,all,%A_ScriptDir%\a.txt
gosub,index_this
	
Return

#IfWinActive,ahk_exe sublime_text.exe
$f3::	; na
	active_window=sublime_text.exe
	active_window_path:=sublime_text_path
	source_path:=get_current_filepath_from_active_window()
	if !InStr(FileExist(source_path), "D")
		splitpath,source_path,,source_path
	gosub, search_folder
gosub,index_this
	
Return

#IfWinActive,ahk_exe notepad++.exe
$f3::	; na
	active_window=notepad++.exe
	active_window_path:=npp_path
	source_path:=get_current_filepath_from_active_window()
	if !InStr(FileExist(source_path), "D")
		splitpath,source_path,,source_path
	gosub, search_folder
	gosub,index_this
Return
#IfWinActive

index_this:
return

	active_window=eclipse
	run_mode:=1
	index_recurse:=1
	NewKeyPhrase=
	searchInDir:=1
	gosub,index
	gosub,disp_gui
	;msgbox,%all%
return

search_folder:

	sleep,150
	; path:=Clipboard	
	searchInFolder:=source_path
	gosub,searchInFolder_Index
	NewKeyPhrase=
	searchInDir:=1
	gosub,disp_gui

; guicontrol,,text_folder,
return
		
F3 & f4::	; na

search_in_recent_files:
	gosub,get_recent_used_files
	gosub,index
	guicontrol,,text_folder,searching RECENT used Files
	NewKeyPhrase=
	gosub,disp_gui
	searchInDir:=0
	searchInFolder=

	return


search_in_common:
	gosub,get_contents_dynamic
	gosub,index
	guicontrol,,text_folder,searching common+recent searched files+foldss
	NewKeyPhrase=
	gosub,disp_gui
	searchInDir:=0
	searchInFolder=

	return

; f4 & f3::	; na
search_in_everywhere:
	; all := recent_searches "`n" files
	guicontrol,,text_folder,searching everywhere
	gosub,launch
	searchInDir:=0
	searchInFolder=
	NewKeyPhrase=
return

smart_ranking:
	ifnotinstring, recent_searches , %FileFullpath%`r`n
	{

	}
	else
	{
		stringreplace,recent_searches,recent_searches,%FileFullpath%`n,,All
	}
	recent_searches := FileFullpath "`n" recent_searches
	filedelete,%recent_searches_file%
	fileappend,`n%recent_searches%,%recent_searches_file%

return


get_contents_opus_recent:
	fileread,files,%opus_recent_file%
	searchfiles=%A_ScriptDir%\%A_Scriptname%.txt	
	stringreplace,files,files,<?xml version="1.0" encoding="UTF-8"?>,,all
	stringreplace,files,files,<recent>,,all
	stringreplace,files,files,</recent>,,all
	stringreplace,files,files,<path>,,all
	stringreplace,files,files,</path>,,all
	stringreplace,files,files,<dir>,,all
	stringreplace,files,files,</dir>,,all
	stringreplace,files,files,<pathstring>,,all
	stringreplace,files,files,</pathstring>,,all
	stringreplace,files,files,<path label=",,all
	stringreplace,files,files,">,,all
	stringreplace,files,files,</pathstring>,,all
	stringreplace,files,files,<tree>128</tree>,,all
	opus_recents := RegExReplace(files, "im)^\s+|\s+$")
return


get_iconnumber:

SplitPath, FileName,,, FileExt  ; Get the file's extension.
if FileExt in EXE,ICO,ANI,CUR
{
	ExtID := FileExt  ; Special ID as a placeholder.
	IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
}
else  ; Some other extension/file-type, so calculate its unique ID.
{
	ExtID = 0  ; Initialize to handle extensions that are shorter than others.
	Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
	{
		StringMid, ExtChar, FileExt, A_Index, 1
		if not ExtChar  ; No more characters.
			break
		; Derive a Unique ID by assigning a different bit position to each character:
		ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
	}

	; Check if this file extension already has an icon in the ImageLists. If it does,
	; several calls can be avoided and loading performance is greatly improved,
	; especially for a folder containing hundreds of files:
	IconNumber := IconArray%ExtID%
	; msgbox,%FileName% %IconNumber%
}
if not IconNumber  ; There is not yet any icon for this extension, so load it.
{
	; Get the high-quality small-icon associated with this file extension:
	if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str", FileName, "uint", 0, "str", sfi, "uint", sfi_size, "uint", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
		IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
	else ; Icon successfully loaded.
	{
		; Extract the hIcon member from the structure:
		hIcon := NumGet(sfi, 0)
		; Add the HICON directly to the small-icon and large-icon lists.
		; Below uses +1 to convert the returned index from zero-based to one-based:
		IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", ImageListID1, "int", -1, "ptr", hIcon) + 1
		DllCall("ImageList_ReplaceIcon", "ptr", ImageListID2, "int", -1, "ptr", hIcon)
		; Now that it's been copied into the ImageLists, the original should be destroyed:
		DllCall("DestroyIcon", "ptr", hIcon)
		; Cache the icon to save memory and improve loading performance:
		IconArray%ExtID% := IconNumber
		; msgbox,%ExtID%
	}
}
return



Receive_WM_COPYDATA(wParam, lParam)
{
	global CopyOfData,searchInFolder,searchInDir,run_mode,NewKeyPhrase
	; msgbox, Message %msg% arrived:`nWPARAM: %wParam%`nLPARAM: %lParam%
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
	CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
	CopyOfData:=regexreplace(CopyOfData,"^\n","")
	stringreplace,CopyOfData,CopyOfData,",,all
	; msgbox,=%CopyOfData%=
	run_mode:=1
	searchInFolder:=CopyOfData
	gosub,searchInFolder_Index
	NewKeyPhrase=
	searchInDir:=1
	gosub,disp_gui
	; gosub,get_contents_dynamic
	; gosub,append_static
	; gosub,index
	return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

update_db:
	filecopy,%quicksearch_db_file%,%A_ScriptDir%\pathlist.txt,1
	gosub,get_contents_static

return

get_recent_used_files:
	fileread,all,%recently_used_file%
	all := remove_duplicates(all)
	sort,all,all,R
	gosub,index
return

find_suggestions:
suggestions_to_show:=6
; msgbox,%A_GuiControl%
		WinActive("A") ; sets last found window
		ControlGetFocus, ctrl
		if (RegExMatch(ctrl, "A)Edit\d+"))
		ControlGet, seltext, Selected,, %ctrl%
		; tooltip,sel=%seltext%
		; sleep,1500
	reg = i)(%seltext%)$
	schstr_without_selected:= regexreplace(visibleSchStr,reg)
	
	if ( last_checked_string != schstr_without_selected)
	{
	
		suggestion_count:=0
		stringsplit,suggestions,matchlist,`n,`r
		last_checked_string := SchStr
		; tooltip, reset
		; sleep,500
	}
	if ( suggestion_count < suggestions0)
		suggestion_count++
	else
		suggestion_count:=1
	suggestions_now := suggestions%suggestion_count%
	n:=suggestion_count+suggestions_to_show-1
	msg =
	suggestions_actually_shown:= ( suggestions0 > suggestions_to_show)? suggestions_to_show : suggestions0
	suggestions_actually_shown:= suggestions_actually_shown - suggestion_count + 1
	loop, %suggestions_actually_shown%
	{	
		n:= suggestion_count + suggestions_actually_shown - a_index 
		msg .= suggestions%n% . "`n"
		; tooltip, n= %n% suggestions_to_show = %suggestions_to_show% suggestions0=%suggestions0%`n%msg%
		; sleep,2000
		; n--
	}
	stringtrimright,msg,msg,1
	
	CoordMode, ToolTip, Screen
	CoordMode, Caret, Screen
	tmp_y:= a_caretY-(25 * ( suggestions_actually_shown + 1))
	ToolTip , %msg% (%suggestions0%), a_caretX, tmp_y
	; msgbox,%matchlist%
return

apply_suggestions:

	GuiControlGet, visibleSchStr,1: , visibleSchStr 
	StringLen, length, visibleSchStr
	cursorPos:=0
	ControlGet, cursorPos, CurrentCol,, %visibleSchStr%, A ; Get current cursor position

	; SendMessage, 0x157,,,,ahk_id %Ed1%         ;CB_GETDROPPEDSTATE
	needle:=visibleSchStr

	SetControlDelay, -1 
	SetWinDelay, -1 
	GuiControlGet, h, Hwnd, %visibleSchStr% 
	sleep,1000
	loop,parse,visibleSchStr,%a_space%
		last_word := a_loopfield
	reg = i)^(%last_word%)
	a:= regexreplace(suggestions_now,reg)
	new_schstr:= schstr_without_selected . a
	GuiControl,1: Text, visibleSchStr, %new_schstr%
	; msgbox,%visibleSchStr%
	SendMessage, 0xB1, StrLen(schstr_without_selected), StrLen(new_schstr),, ahk_id %Ed1%
	; ControlSend, , % "{Right " . StrLen(needle) . "}+^{End}", ahk_id %h% 	;	%

return