; http://www.cibinmathew.com
; github.com/cibinmathew

#include C:\cbn_gits\AHK\LIB\contextmenu.ahk

source_root=%1%
#SingleInstance force
if isfile(source_root)
{
	FileGetSize, FileSize, %source_root%,k
	if ( FileSize > 1000 )
	{
		run, notepad.exe %source_root%,max
		; msgbox
		return
	}
}

#include C:\cbn_gits\AHK\LIB\HK_cycle.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk

config =
(
open here,open here Recurse,open gui
,
,
,
,
,
open_here,open_here_recurse,open_gui,
,
)

HK_cycle_register("<^F7","txtExplorer_launcher_HK",4,4000,"LCtrl", "$^q",config) 

ifexist, iMac.ico
	Menu, Tray, Icon,iMac.ico
#include LIB\cbn.ahk
#NoEnv  ; R
SendMode Input
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FileEncoding,UTF-8
appname=%Win_Title% - txt explorer
autoclose:=1
file_tree:=1
gui,1:+resize +alwaysontop
Gui,1: +LastFound 
GUI_ID:=WinExist()

gui,1:font,s10 verdana
gui, 1:add,button,x0 y0 w50 h40 gShrink,O

Gui, 1:Add, edit, x+2 y5 w80 h30 vvisibleSchStr hWndEd1  +0x100, ; -WantReturn
Gui, 1:Add, checkbox, x+0 yp w30 h30 vsearch_locations gsearch_locations_toggle , all
gui, 1:add,button,x+0 y0 w40 h40 gfile_tree,>
Gui, 1:Add, Button, x+2 yp w40 h40  gcopy_all,^a c
Gui, 1:Add, Button, x+2 yp w40 h40  gcopy_sel,^c
Gui, 1:Add, Button, x+2 yp w40 h40  gopen_in_clipGui,gui
Gui, 1:Add, Button, x+2 yp w50 h40 gopenInEditor,EDIT
Gui, 1:Add, Button, x+0 yp w50 h40 gprev, <<
Gui, 1:Add, Button, x+0 yp w50 h40 gnext, >>
Gui, 1:Add, Button, x+5 yp w60 h40 gclipPath, clipPath
Gui, 1:Add, Button, x+5 yp w60 h40 gfavmenu2, favpaths
Gui, 1:Add, Button, x+0 yp w60 h40 gfavmenu, favmenu
Gui, 1:Add, Button, x+5 yp w20 h20,-
Gui, 1:Add, Button, x+0 yp w20 h20,+
Gui, 1:Add, Button, x0 y45 w120 h30 gin_alphasearch vsearch2 , in alphasearch
Gui, 1:Add, Button, x2 y630 w95 h45 +Center vhide_btn ghide,Hide
Gui, 1:Add, Button, x+0 yp w95 h45 vbutton2 gHoldapp,HOLD

gui,1:font,s9 verdana

Gui, 1:Add, ListView, x2 y76 w200 h540 vResultList gLVEvents r10 AltSubmit -Multi, File|path|size|occurence

gui,1:font,s10 verdana
Gui, 1:Add, Edit, x202 y40 w485 h410 vedit1 hwndCBedit, Edit

Gui, 1:Add, StatusBar, x12 y+0 w600 h20 , 
Gui, 1:Show,hide x191 y5 h675 w710, txt explorer

menu,mymenu2,add,fav1,favSelect2
Menu, mymenu2, Icon,fav1,Shell32.dll, 45,32
menu,mymenu2,add,fav2,favSelect2
Menu, mymenu2, Icon,fav2,Shell32.dll, 43,32


menu,mymenu,add,fav1,favSelect

Menu, mymenu, Icon,fav1,Shell32.dll, 45,32
menu,mymenu,add,fav2,favSelect
Menu, mymenu, Icon,fav2,Shell32.dll, 43,32

menu,mymenu,add,fav3,favSelect
Menu, mymenu, Icon,fav3,Shell32.dll, 40,32

menu,mymenu,add,fav4,favSelect
Menu, mymenu, Icon,fav4,Shell32.dll, 44,32
Folder_recurse:=0
Gosub, open_files
Return

open_files:
path=%source_root%
Gui, 1:ListView,ResultList
filepaths=	
if source_root =
{

}
else if (isfile(path)=1)
{
	; msgbox,asfs
	LV_Delete()
	splitpath,path,outfilename,outdir,this_FileExt
	filepaths :=indexfiles( outdir,,,,,Folder_recurse,,".*\.(txt|c|ahk|py|%this_FileExt%)$")
	file_now:= get_present_match_pos(filepaths,"`n",path)
	source_text=
	files:=0
	add_files_to_list(filepaths)

		
		FilePath:=path

		guicontrol,1:hide,ResultList
		guicontrol,1:hide,search
		; guicontrol,1:hide,search_locations
		guicontrol,1:hide,search2
		; guicontrol,1:hide,visibleSchStr
		guicontrol,1: move,edit1,h569 w680 x2 
		file_tree:=0
}
else
{	

	LV_Delete()
	filepaths :=indexfiles( path,,,,,Folder_recurse,,".*\.(txt|c|ahk|py)$")
	add_files_to_list(filepaths)

}	
; msgbox,%filepaths%	
Gui, 1:ListView,ResultList

if LV_GetCount()
{
	LV_ModifyCol(1)
	LV_ModifyCol(2)
	LV_ModifyCol(3)
	LV_GetNext()
	FocusedRowNumber:=file_now
	GuiControl, Focus, ResultList
	LV_Modify(FocusedRowNumber, "+Select +Focus")
	LV_Modify(FocusedRowNumber, "Vis")
}
LV_GetText(FilePath,FocusedRowNumber,2)
gosub,update_window
sleep,50
tooltip,
	
	
Coordmode, Mouse, screen
MouseGetPos,mx,my
if mx>600
	x:=50
else
	x:=620
Gui, 1:show,x%x% hide	noactivate
SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	; preselects the text
; gosub,GuiSize
; GuiResize(500,600)
guicontrol,1: focus,visibleSchStr
SetTimer, tIncrementalSearch, 500
; gui,1: show
instance_running:=1
keywait,lbutton,d
settimer,checkactive,500
Return

add_files_to_list(filepaths)
{
	global
	Loop,parse,filepaths,`n ,`r
	{
		splitpath,A_LoopField,tmp_name
		LV_Add("",tmp_name,A_LoopField)
		; filepaths .= A_LoopFileFullPath . "`n" 
		fileread,source_text_%a_index%, %A_LoopField%
		source_text .= "`n" . source_text_%a_index%	
		tot_files:=A_Index
	}
}	

LVEvents:
	selected := LV_GetNext()	
	if (A_GuiEvent = "normal")
	{
		sleep,100
		if ( selected >0)
		{
			file_now := LV_GetNext()
			LV_GetText(FilePath,LV_GetNext(),2)
			gosub,update_window
			sleep,100
			gosub, gotosel	
			; tooltip,%FilePath%			
			; settimer,removetooltip,-800		
		 }	
	}
return

#ifwinactive, `%Win_Title`% - txt explorer
^wheelup::	; na
#ifwinactive

prev:
if (file_now-1<1)
	file_now:=tot_files
else
	file_now--
	FocusedRowNumber := file_now ; LV_GetNext(0, "F") 
	tooltip,%FocusedRowNumber%/%tot_files%
	; FocusedRowNumber--
	GuiControl, Focus, ResultList
	LV_Modify(FocusedRowNumber, "+Select +Focus")
	LV_Modify(FocusedRowNumber, "Vis")
	LV_GetText(FilePath,FocusedRowNumber,2)
	gosub,update_window
	
	settimer,removetooltip,-150

	
return

#ifwinactive, `%Win_Title`% - txt explorer
^wheeldown::	; na
#ifwinactive

next:
if (file_now+1>tot_files)
	file_now:=1
else
	file_now++
	FocusedRowNumber :=file_now ; LV_GetNext(0, "F") 
	tooltip,%FocusedRowNumber%/%tot_files%
	; FocusedRowNumber++
	GuiControl, Focus, ResultList
	LV_Modify(FocusedRowNumber, "+Select +Focus")
	LV_Modify(FocusedRowNumber, "Vis")
	LV_GetText(FilePath,FocusedRowNumber,2)
	gosub,update_window
	
	settimer,removetooltip,-150

return

f12:: ; txtexplorer fav
	Gui, 1:ListView,ResultList
	LV_Delete()
	Loop, F:\cbn\tmp\*.txt, ,
		LV_Add("",A_LoopFilename,A_LoopFileFullPath)

	Gui, 1:ListView,ResultList
	fileread,contents,%FilePath%
	guicontrol,,edit1, %contents%
	if LV_GetCount()
		{
		LV_ModifyCol(1)
		LV_ModifyCol(2)
		LV_ModifyCol(3)
		}
	LV_GetNext()


return


GuiClose:
	gosub,hide
	ExitApp
return


favSelect2:

	fileread,path, favpath%A_ThisMenuItemPos%.txt
	LV_Delete()
	Loop, %path%\*.txt, ,
		LV_Add("",A_LoopFilename,A_LoopFileFullPath)

	Gui, 1:ListView,ResultList
	fileread,contents,%FilePath%
	guicontrol,,edit1, %contents%
	if LV_GetCount()
		{
		LV_ModifyCol(1)
		LV_ModifyCol(2)
		LV_ModifyCol(3)
		}
	LV_GetNext()

return

favmenu2:
menu,mymenu2,show
return
favSelect:


fileread,fav, fav%A_ThisMenuItemPos%.txt
LV_Delete()
	Loop, parse,fav,`n,`r 
	{
		splitpath,A_Loopfield,name
		LV_Add("",name,A_Loopfield)
	}

	Gui, 1:ListView,ResultList
	LV_ModifyCol()

return

favmenu:
menu,mymenu,show
return

clipPath:
	Gui, 1:ListView,ResultList
	
	if isfile(clipboard)
	{
		LV_Delete()
		Loop, parse,clipboard,`n,`r 
			{
				splitpath,A_Loopfield,name
				LV_Add("",name,A_Loopfield)
			}
	}
	else
	{
		path=%clipboard%

		LV_Delete()
		a:=indexfiles( path,,,,,,,".*\.(txt|ini|csv)$")
		Loop,parse,a,`n,`r
		{
			splitpath,a_loopfield,fname
				LV_Add("",fname,A_LoopField)
		}
	}
	Gui, 1:ListView,ResultList
	fileread,contents,%FilePath%
	guicontrol,,edit1, %contents%
	if LV_GetCount()
	{	
		LV_ModifyCol(1)
		LV_ModifyCol(2)
		LV_ModifyCol(3)
	}
	LV_GetNext()

return


Hide:
; gui,1: hide
	DllCall("AnimateWindow","UInt",  GUI_ID  ,"Int", 250,"UInt", 0x90004) 
	settimer,checkactive,off
	SetTimer, tIncrementalSearch, off
; exitapp
return
open_here_recurse:
	Folder_recurse:=1
	goto, index_and_open
Return

open_here:
	Folder_recurse:=0
	goto, index_and_open
Return

index_and_open:
	filepath:=get_current_filepath_from_active_window()
	SplitPath, filepath, OutFileName, OutDir, 
	if (!filepath)
	{
		OutDir := get_parent_filepath()
	}
		; msgbox, %OutDir%
	if (!OutDir)
		return
	source_root := OutDir
	; msgbox,%OutDir%
	gosub, open_files
	Return

open_gui:
	gui,1: show
	SetTimer, tIncrementalSearch, 500
	autoclose:=1
	guicontrol,1: ,button2,HOLD
	gui,1: Color, ffffff
	keywait,lbutton,d
	settimer,checkactive,500
return


Shrink:
shrink:=!shrink
if shrink
	{
	winset,region, 17-31 w50 h45
	settimer,checkactive,off
	;gosub,hide
	}
else
{
	;if hidden
		;gosub,show
	winset,region, 0-0 w1400 h950
	keywait,lbutton,d
	settimer,checkactive,500
	}
return


checkactive:
	if (!autoclose)
	{
		; sleep,500
		return
	}
	; keywait,lbutton,d,T.5
	sleep,50
	; WinGetActiveTitle, Title

	IfWinNotActive, %Win_Title% - txt explorer	; .exe
		{
			sleep,250
			IfWinNotActive, %Win_Title% - txt explorer	; .exe
			{	
				; tooltip,hiding %Title%
				; sleep,80
				gosub,hide
				; tooltip,
			}
	}
	
return

exitapp:
	DllCall("AnimateWindow","UInt",  GUI_ID  ,"Int", 250,"UInt", 0x90004) 
	exitapp
return

Holdapp:
	autoclose:=0
	guicontrol,1: ,button2, H  O  L  D
	gui,1: Color, ffdddd
	settimer,checkactive,off
	
return

copy_all:
	gui,submit,nohide
	clipboard:=edit1
return
	
copy_sel:
	; guicontrol,focus,edit1

	; send ,^c
	; sleep,150
	; tooltip,%clipboard%
	; sleep,700
	; tooltip

return

openInEditor:
	FocusedRowNumber := LV_GetNext(0, "F") 
	LV_GetText(SelectedFile,FocusedRowNumber,2)
	IfWinExist, %SelectedFile% - Notepad
		WinActivate ; use the window found above
	else
	  
		; param=-n%lineNo%
		menuEvent_function("N++",SelectedFile) ;,param)
  ; gosub,exitapp
  return
  
removetooltip:
	settimer ,removetooltip,off
	tooltip
return

file_tree:
	guicontrol,1: move,edit1,h640 w500 x202 
	guicontrol,1:show,search
	guicontrol,1:show,visibleSchStr
	guicontrol,1:show,search_locations
	guicontrol,1:show,search2
	guicontrol,1:show,ResultList
	file_tree:=1
return


update_window:
	; file:=files%file_now%
	; splitpath,file,outfilename,outdir
	FileGetSize, FileSize, %FilePath%,k
		if (FileSize > 1000)
		{
		  ; run,notepad.exe %source_root%,max
			tooltip,> 1 mB
			sleep,250
			tooltip,
			guicontrol,,edit1,%FilePath%`n > 1 mB
			return
		}
	fileread,contents,%FilePath%
	if contents=
		{
			contents=%FilePath%`nEMPTY
			Gui,1: Font, cred	s14
			GuiControl,1: Font ,  edit1
		}
		else
		{
			
			Gui,1: Font, cblack  s10
			GuiControl,1: Font,  edit1
		}
	guicontrol,,edit1, %contents% 
	; guicontrol,,file_name,  %file_now%/%files0%  %outdir%\   %outfilename%
	; guicontrol,,file_name2, %file% 
	lncnt:=15	;	default
	
	
	; h:=700
	; h2:=h+50

	; w:=500
	; GuiResize(w,h)
	tmp_123=%file_now%/%tot_files% %FilePath%
	SB_SetText(tmp_123)
	splitpath,FilePath,f_name
	Win_Title=%f_name%
	Gui,1: +LastFound 
	WinSetTitle,%Win_Title% - txt explorer

return

GuiSize:
	GuiResize(A_GuiWidth,A_GuiHeight)
return

GuiResize(w,h)
{	
	global
	if (file_tree)
	{
		h2:=h-66
		w1:=w-203
		h1:=h-156
		h3:=h1+85
		guicontrol,1: move,ResultList,h%h1%
		guicontrol,1: move,button2,y%h3%
		guicontrol,1: move,hide_btn,y%h3%
		guicontrol,1: move,edit1,h%h2% w%w1%
	}
	else
	{		
		w1:=w-3
		h1:=h-96
		h2:=h-116
		h3:=h-76
		guicontrol,1: move,button2,y%h3%
		guicontrol,1: move,hide_btn,y%h3%
		guicontrol,1: move,edit1,h%h2% w%w1%
	}	
}

in_alphasearch:
	run, "c:\cbn\opus\opus_scripts\alpha search in sel\alpha search in sel.ahk" %FilePath%
return

open_in_clipGui:
	GuiControlGet, edit1, , edit1
	clipboard:=edit1
	sleep,200
	send +{F6}
return


SetTimer, tIncrementalSearch, 500
return

tIncrementalSearch:
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

search:
	Gui, 1: Submit, NoHide
	SchStr:=visibleSchStr

	StopSearch=0

	search_in_progress := 1
	if (SchStr = "") ;if empty query
	{
		; msgbox,empty
		GuiControl, 1: Show, ResultList
		LV_Delete()
		gosub,load_file_list
		; Goto,StopSearch			
		return
	}
	else if (StrLen(SchStr) <3 )
		return
	if (!file_tree)
		gosub,file_tree
	GuiControl, 1:  Show, ResultList
	LV_Delete()
	FilesMatch=0
	SchStr=i)%SchStr%
	matchlist=
	matchlist2=
	matchlist3=
	matchlist4=
	tot_matches:=0
	if ( search_locations )
		current_search_files := filepaths
	else 
		current_search_files := filepath
	
	loop,parse,current_search_files,`n,`r
	{
		file:=A_LoopField
		splitpath,A_LoopField,fname
		count=0
		Loop, Parse, source_text_%a_index%,`n,`r
		{
			if RegExMatch(A_LoopField,SchStr)
				{
					count++
					matchlist=%matchlist%`n%A_LoopField%
					matchlist2=%matchlist2%`n%file%
					matchlist3=%matchlist3%`n%fname%
					matchlist4=%matchlist4%`n%count%
					tot_matches++
				}
		}
	}		
	; msgbox,%matchlist3%
StopSearch:
	Oldschstr:=schstr
	matchlist:=regexreplace(matchlist,"m)^\n","")	
	matchlist2:=regexreplace(matchlist2,"m)^\n","")	
	matchlist3:=regexreplace(matchlist3,"m)^\n","")	
	matchlist4:=regexreplace(matchlist4,"m)^\n","")	
	; msgbox,%matchlist%
	Loop, Parse, matchlist,`n,`r
	{
		LV_Add("",A_LoopField)
	}
	Loop, Parse, matchlist2,`n,`r
	{
		LV_Modify(a_index, "col2",A_LoopField)
	}
	Loop, Parse, matchlist3,`n,`r
	{
		LV_Modify(a_index, "col3",A_LoopField)		
	}
	Loop, Parse, matchlist4,`n,`r
	{
		LV_Modify(a_index, "col4",A_LoopField)		
	}		
	GuiControl,1:  Show, ResultList
	GuiControl, 1:, text1, %tot_matches% /
	; LV_ModifyCol() 
	LV_ModifyCol(1,"AutoHdr")
	GuiControl,1: , ResultList,r8
return

load_file_list:
	Loop,parse,filepaths,`n,`r
	{
		splitpath,A_LoopField,fname
		LV_Add( "", fname, A_LoopField )
	}
return

goTosel:
{
	GuiControl, Focus, edit1                      ; focus on main help window to show selection
	LV_GetText(postn,LV_GetNext(),4)
	StringGetPos pos, edit1, %visibleSchStr% ,l%postn%,offset            ; find the position of the search string
	if (pos = -1) 
	{
		if (offset = 0) 
		{
		}
		else 
		{
		  offset = 0
		  hits = 0
		}
	return
   }
	StringLeft __s, edit1, %pos%                        ; cut off end to count lines
	StringReplace __s,__s,`n,`n,UseErrorLevel             ; Errorlevel <- line number
	addToPos=%Errorlevel%
	visible:=addToPos+1
	SendMessage 0xB6, 0, -999, , ahk_id %CBedit%  ; Scroll to top
	SendMessage 0xB6, 0, Errorlevel, , ahk_id %CBedit% ; Scroll to visible
	SendMessage 0xB1, pos + addToPos, pos + addToPos + Strlen(SchStr), , ahk_id %CBedit% ; Select search text
	SendMessage, EM_SCROLLCARET := 0xB7, 0, 0, , ahk_id %CBedit% ; Scroll the caret into view in an edit control
}
return

#ifwinactive, `%Win_Title`% - txt explorer
^f::
#ifwinactive 
	settimer,removetooltip,800
	tooltip,type your search string
	guicontrol,1: focus,visibleSchStr
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
return

search_locations_toggle:
	settimer,removetooltip,500
	tooltip,reindexing
	loop,parse,current_search_files,`n,`r
	{
		fileread,source_text_%files%, %a_loopfield%
		source_text .= "`n" . source_text_%files%
	}
return


~esc::
 gosub, Hide
 Return
 