#include C:\cbn_gits\AHK\LIB\HK_cycle.ahk
SetWorkingDir %A_ScriptDir%
; ifexist,control.ico
	; Menu, Tray, Icon, control.ico
; else
	menu, Tray, Icon, Shell32.dll, 28
; #include C:\cbn_gits\AHK\lib\ini.ahk
#include C:\cbn_gits\AHK\lib\cbn.ahk
#include C:\cbn_gits\AHK\LIB\AddGraphicButton.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
suspend_if_VMwareHorizonClient()
#SingleInstance, Force
AddMenuTrayAutostart()

config =
(
disp_gui,cbn1,cbn ved2,demo ved3
,
,
,
disp_gui,launch,launch,launch,launch
,
,,
,
)

HK_cycle_register("^+F10","Control_launcher_HK",4,4000,"LCtrl", "$^q",config) 




x1:=30
x2:=x1+25
x3:=x2+25
x4:=x3+35
x5:=x4+145
x6 :=x5+45
x7 :=x6+45
y1:=100
hold =0
Gui,1: +AlwaysOnTop  +border +toolwindow -caption +LastFound
Gui,1: font,  s22 comic sans

Gui,1:Add, Picture, x20 y3 w48 h48 grefresh_run2,  refresh.ico
no_of_launchers:=4
name_of_launchers=cbn,ved,demo,non conflicting
x:=80
loop,%no_of_launchers%
{
	Gui,1:Add, button, x%x% yp w48 h48 vlaunch%a_index%_V  glaunch%a_index%, %a_index%
	x+=50
}


Gui,1:Add, button, x+10 yp w75 h48 gBut_Exit_all vBut_Exit_V_all, exit all
Gui,1:Add, button, x+5 yp w75 h48 gBut_Exit_allF , force exit


SysGet, MonSize, Monitor,
tooltip,loading...
Gui,1: font,  s20 comic sans

mainTabNames=- - - F A V - - -|- - - M O R E - - -
Gui, 1: Add, Tab2,x10 y55 w800 h620 vMyTab  gTabSubSwitch  hwndTabID TCS_BUTTONS TCS_HOTTRACK , %mainTabNames% 
;;;;tab height
TCM_GETITEMRECT = 0x130A
TCM_SETITEMSIZE = 0x1329
TCS_HOTTRACK 	= 0x40 
VarSetCapacity(Rect, 16, 0)
SendMessage, TCM_GETITEMRECT, 0, &Rect,, ahk_id %TabID%
H := NumGet(Rect, 12) - NumGet(Rect, 4)
Height = 35
SendMessage, TCM_SETITEMSIZE, 0, Height << 16,, ahk_id %TabID%
; preselects
Gui 1: +LastFound  ; Avoids the need to specify 
SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 0, 1, , ahk_id %TabID%
SendMessage, TCS_HOTTRACK , 0,0,
Gui, 1: Tab,- - - M O R E - - -

 
x1:=30
x2:=x1+25
x3:=x2+25
x4:=x3+40
x5:=x4+35
x6:=x5+35
x7:=x6+35
x8:=x7+160
x9:=x8+45
y1:=100
hold =0
Gui, 1: Tab,- - - F A V - - -
gosub,autostart2
fileread,ini_All,control_AllScripts.ini

Loop, Parse, ini_All, `n,`r
{
	tot_files:=a_index
	Loop, Parse, a_loopfield, `,
	{
		field%a_index%:=a_loopfield
	}
	%a_index%_path :=field1
	splitpath,field1,%a_index%_name
	name :=%a_index%_name
	%a_index%_autostart := field2
	%a_index%_icon :=field3
	n:=4
	Gui, 1:Add,button ,x%x5% y%y1% w260 h25 BackGroundTrans gBut_RUN_%A_index% vtext_%a_index%, %a_index%.%name%
	n:=a_index
	x:=x1
	K:=4
;msgbox,% %a_index%_path
	loop,%no_of_launchers%
	{
		%n%_launch%a_index% := field%k%
		k++
		img := "refresh.ico"
		img := "shell32.dll, 34"
		Gui,1:Add, Picture, x%x% y%y1% w22 h22 gBut_launch%a_index%_%n%  vBut_launch%a_index%_V_%n% Icon5, %A_WinDir%\system32\SHELL32.dll
		x+=30
	}
	
	img := %a_index%_icon
	if ( img<>"" )
		Gui, 1:Add, Picture, x%x4% y%y1% w32 h32   gBut_RUN_%A_index% vBut_RUN_V_%a_index% , %img%
    y1 :=y1+26
	
	if a_index=21
	{
		x1+=390
		x2+=390
		x3+=390
		x4+=390
		x5+=390
		x6+=390
		x7+=390
		x8+=390
		x9+=390
		y1:=100
	}
	  
}
tooltip,

return

autostart2:	; from txt file
	fileread,autostart2List,control_autostart2.txt
	Loop, Parse, autostart2List, `,
	{
		ifexist,%a_loopfield%
		{
			splitpath,a_loopfield,,outdir
			Run "%a_loopfield%","%outdir%"	;default run
		}
	}
	Gui, 1: +LastFoundExist
	GUI_ID:=WinExist() 
	Gui,1: Show, hide x200 ycenter ;noactivate  
	tooltip,loaded
	sleep,600
	tooltip,
return
 
delayed_start:
	fileread,delayed_startList,delayed_startList.txt
	Loop, Parse, delayed_startList, `,
	{
		ifexist,%a_loopfield%
			run,%a_loopfield%
	}
	 
return


launch1:
launch2:
launch3:
launch4:
launch5:
Stringtrimleft, tmp , A_Thislabel, 6
Loop, %tot_files%
{	

	if (%a_index%_launch%tmp%=1)  
	{
		f_path := %a_index%_path 
		DetectHiddenWindows, On   
		ifwinNotExist, %f_path% ahk_class AutoHotkey
		{
			splitpath,f_path,,outdir
			ifexist,%f_path%
				Run "%f_path%","%outdir%"	;default run

		}		
	}
}
gosub, refresh_run2	
return


But_RUN_1:
But_RUN_2:
But_RUN_3:
But_RUN_4:
But_RUN_5:
But_RUN_6:
But_RUN_7:
But_RUN_8:
But_RUN_9:
But_RUN_10: 
But_RUN_11:
But_RUN_12:
But_RUN_13:
But_RUN_14:
But_RUN_15:
But_RUN_16:
But_RUN_17:
But_RUN_18:
But_RUN_19:
But_RUN_20:
But_RUN_21:
But_RUN_22:
But_RUN_23:
But_RUN_24:
But_RUN_25:
But_RUN_26:
But_RUN_27:
But_RUN_28:
But_RUN_29:
But_RUN_30:
But_RUN_31:
But_RUN_32:
But_RUN_33:
But_RUN_34:
But_RUN_35:
But_RUN_36:
But_RUN_37:
But_RUN_38:
But_RUN_39:
But_RUN_40:
But_RUN_41:
	Stringtrimleft, Button , A_Thislabel, 8
	SetTitleMatchMode, 2
	DetectHiddenWindows, On 
	f_path:=%button%_path
		; msgbox,%button%_path
	
	ifwinexist, %f_path% ahk_class AutoHotkey
	{ 
	
		WinClose,  %f_path% ahk_class AutoHotkey		
		Gui,1: Font, s12 normal,		
	}
	else ifexist,%f_path%
	{
		tooltip, %f_path%
		settimer,removetooltip,-1000
		splitpath,f_path,,outdir
		Run "%f_path%",%outdir%	;default run
		Gui,1: Font, s12 bold, 		 
	}
	;tooltip,%f_path% `n%text%	 
	GuiControl, 1: Font  , text_%Button%
	text :=%Button%_name	
	GuiControl, 1:, text_%Button%, %Button%.%text% 	 
	SetTitleMatchMode, 1
return	

nil:
return

^+!esc::	
but_exit_all:
tooltip, closing all
sleep,500
	SetTitleMatchMode, 2
	Loop, %tot_files%
	{
		DetectHiddenWindows, On 
		f_path :=%a_index%_path 
		WinClose, %f_path% ahk_class AutoHotkey		 
	}
	SetTitleMatchMode, 1
	gosub, refresh_run2	
settimer,removetooltip,500
tooltip, closed
return

but_exit_allF:
	

return


But_launch1_1:
But_launch1_2:
But_launch1_3:
But_launch1_4:
But_launch1_5:
But_launch1_6:
But_launch1_7:
But_launch1_8:
But_launch1_9:
But_launch1_10:
But_launch1_11:
But_launch1_12:
But_launch1_13:
But_launch1_14:
But_launch1_15:
But_launch1_16:
But_launch1_17:
But_launch1_18:
But_launch1_19:
But_launch1_20:
But_launch1_21:
But_launch1_22:
But_launch1_23:
But_launch1_24:
But_launch1_25:
But_launch1_26:
But_launch1_27:
But_launch1_28:
But_launch1_29:
But_launch1_30:
But_launch1_31:
But_launch1_32:
But_launch1_33:
But_launch1_34:
But_launch1_35:
But_launch1_36:
But_launch1_37:
But_launch1_38:
But_launch1_39:
But_launch1_40:
But_launch1_41:

But_launch2_1:
But_launch2_2:
But_launch2_3:
But_launch2_4:
But_launch2_5:
But_launch2_6:
But_launch2_7:
But_launch2_8:
But_launch2_9:
But_launch2_10:
But_launch2_11:
But_launch2_12:
But_launch2_13:
But_launch2_14:
But_launch2_15:
But_launch2_16:
But_launch2_17:
But_launch2_18:
But_launch2_19:
But_launch2_20:
But_launch2_21:
But_launch2_22:
But_launch2_23:
But_launch2_24:
But_launch2_25:
But_launch2_26:
But_launch2_27:
But_launch2_28:
But_launch2_29:
But_launch2_30:
But_launch2_31:
But_launch2_32:
But_launch2_33:
But_launch2_34:
But_launch2_35:
But_launch2_36:
But_launch2_37:
But_launch2_38:
But_launch2_39:
But_launch2_40:
But_launch2_41:

But_launch3_1:
But_launch3_2:
But_launch3_3:
But_launch3_4:
But_launch3_5:
But_launch3_6:
But_launch3_7:
But_launch3_8:
But_launch3_9:
But_launch3_10:
But_launch3_11:
But_launch3_12:
But_launch3_13:
But_launch3_14:
But_launch3_15:
But_launch3_16:
But_launch3_17:
But_launch3_18:
But_launch3_19:
But_launch3_20:
But_launch3_21:
But_launch3_22:
But_launch3_23:
But_launch3_24:
But_launch3_25:
But_launch3_26:
But_launch3_27:
But_launch3_28:
But_launch3_29:
But_launch3_30:
But_launch3_31:
But_launch3_32:
But_launch3_33:
But_launch3_34:
But_launch3_35:
But_launch3_36:
But_launch3_37:
But_launch3_38:
But_launch3_39:
But_launch3_40:
But_launch3_41:

But_launch4_1:
But_launch4_2:
But_launch4_3:
But_launch4_4:
But_launch4_5:
But_launch4_6:
But_launch4_7:
But_launch4_8:
But_launch4_9:
But_launch4_10:
But_launch4_11:
But_launch4_12:
But_launch4_13:
But_launch4_14:
But_launch4_15:
But_launch4_16:
But_launch4_17:
But_launch4_18:
But_launch4_19:
But_launch4_20:
But_launch4_21:
But_launch4_22:
But_launch4_23:
But_launch4_24:
But_launch4_25:
But_launch4_26:
But_launch4_27:
But_launch4_28:
But_launch4_29:
But_launch4_30:
But_launch4_31:
But_launch4_32:
But_launch4_33:
But_launch4_34:
But_launch4_35:
But_launch4_36:
But_launch4_37:
But_launch4_38:
But_launch4_39:
But_launch4_40:
But_launch4_41:

	Stringtrimleft, tmp1 , A_Thislabel, 10
	Stringleft, tmp1 , tmp1, 1
	Stringtrimleft, Button , A_Thislabel, 12
	; msgbox,%tmp1%=%Button%
	; section := %Button%_2_section	
	if (%Button%_launch%tmp1%=1)
	{
		%Button%_launch%tmp1% :=0
		img :="add.ico"
		; img := "shell32.dll, 34"	
		; iniwrite, 0, control_AllScripts.ini, %section%, launch%tmp1%  
	}
	else
	{
		%Button%_launch%tmp1% :=1
		img :="yellow.ico"
		; img := "shell32.dll, 34"
		; iniwrite, 1, control_AllScripts.ini, %section%, launch%tmp1%
	}		
	GuiControl,, But_launch%tmp1%_V_%Button% , %img% 

 
return

refresh_run2:
	Loop, %tot_files%
	{
		SetTitleMatchMode, 2
		DetectHiddenWindows, On 
		f_path :=%a_index%_path 
		; msgbox,%f_path%
		ifWinexist,  %f_path% ahk_class AutoHotkey		
		{
			%a_index%_running:=1		 
			Gui,1: Font, s12 bold , 			
		}
		else 
		{
			%a_index%_running:=0
			Gui,1: Font, s12 normal, 
		} 
		GuiControl,1: Font ,  text_%a_index%
		text :=%a_index%_name			
		GuiControl,1: , text_%a_index%, %a_index%.%text%
		n:=a_index	
		loop,%no_of_launchers%
		{	
			if (%n%_launch%a_index%=1)
			{ 
				img := "shell32.dll, 34"
			}
			else
			{			 
				img := "shell32.dll, 35"			 
			}		 
			GuiControl,, But_launch%a_index%_V_%n% , %img% 		
		}		
	}	
	SetTitleMatchMode,1
return


launch:
; msgbox
	sleep,500
	tooltip
	gosub,launch%HK_cycle_id_count%
	; settimer,delayed_start,-15000
return


 
disp_gui:
	; gosub, refresh_run
	gosub, refresh_run2
	/*
	MouseGetPos, MouseX, MouseY
	if (mouseX<100)
		mouseX:=100
	if (mouseX>550)
		mouseX:=550
	if (mousey<50)
		mouseX:=50
	if (mousey>550)
		mousey:=550
		*/
	;if (mouseX-350>%MonSizeright%)
	;	mouseX:=mouseX-100 
	; mouseX:=mouseX-100 
	; Gui,1: Show, x%MouseX% ycenter ;noactivate  
	 DllCall("AnimateWindow","UInt",  GUI_ID  ,"Int", 200,"UInt", 0xC0004) 
	 winactivate,ahk_class AutoHotkeyGUI
	 Gui, 1: +LastFound
		Winset, Redraw, , ;%Name%
	;Mousemove, 140, 100,r 3 ; move to default position on startup
	sleep 500
	loop
	{
		if (hold)
			continue
		IfWinNotActive, ahk_class AutoHotkeyGUI
		{
			; Gui,1: hide
			 DllCall("AnimateWindow","UInt",  GUI_ID  ,"Int", 300,"UInt", 0x90004) 
			return
		}
	sleep 100
	}
return	


removetooltip:
	tooltip,
return

TabSubSwitch:
	Gui, Submit, Nohide
	GuiControlGet, whichSubTabName,, %A_GuiControl%
	TabMain:=whichSubTabName
	loop,parse,mainTabNames,|
	{
		if (a_loopfield=whichSubTabName)
			SendMessage, TCM_HIGHLIGHTITEM := 0x1333, % A_index-1, 1, , ahk_id %TabID%
		else
			SendMessage, TCM_HIGHLIGHTITEM := 0x1333, % A_index-1, 0, , ahk_id %TabID%
	}
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 1, 1, , ahk_id %TabID%
	Winset, Redraw, , %Name%
	tooltip,%whichSubTabName%
	sleep,300
	tooltip,
	Gui, Show,
return

~esc::	; na
	gui,hide
return