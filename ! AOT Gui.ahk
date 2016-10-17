; http://cibinmathew.com

#SingleInstance Force
menu, Tray, Icon, Shell32.dll, 20
SplitPath, A_ScriptDir , , , , , A_Script_Drive
#include LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk
AOTScreenCycleHK_active:=0
AOTScreenCycleHK_count:=0

SetWorkingDir %A_ScriptDir%
AOT_screenshot_img_File = C:\users\%a_username%\Downloads\AOT Clipboard Image.png
AOT_hold := 0
gosub, create_aot_gui
Gui, 5: Show, x0 y%GUI5Y% w%PicW% h%PicH%	; inset
; msgbox,%GUI5X%
; gosub,show_AOT_screenshot
return

check_active:
	GetKeyState,state_c,CTRL
	GetKeyState,state_s,shift
	If ((state_c ="U") && (state_s="U"))
	{
		if (AOT_hold=0)
		{
			gosub, hide
			; break
		}
	}
	else If ((state_c="D") && (state_s="D"))
	{
		if !(gui4shown)
		{
			gui4shown:=1
			gui, 4: show
			tooltip,AOT image		
			sleep,450
			tooltip
		}
	}
	else If ((state_c="D") && (state_s="U"))
	{
		if (AOT_hold=0)
		{
			gui, 4: hide
			gui4shown:=0
			sleep,450
		}
	}
; keywait Ctrl
return

show_AOT_screenshot:
	; gui, 4: destroy
	; sleep , 1000
	Gui, 4: Show, w%GUI4W% h350, Picture GUI - Click & Drag
	; Gui, 5: Show, x%GUI5X% y%GUI5Y% w%PicW% h%PicH%	; inset
	gui4shown :=1
	gosub,change_pic
	AOT_hold:=0
	sleep,1500
	keywait Shift
	if (AOT_hold=0)
	{
		gui, 4: hide
		gui4shown :=0
	}
	; tooltip,check
	settimer,check_active,150
return

capture_show_AOT_screenshot:
	MouseGetPos, xpos, ypos 
	gosub,hide
	gosub,capture_AOT_screenshot
	; Runwait, %comspec% /c ""C:\cbn_gits\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "%AOT_screenshot_img_File%" ,,Hide
	sleep,100
	; gui, 4: destroy
	gosub, change_pic
	AOT_hold := 0
	gosub , AOT_hold
	gosub , gui4full4
	gui4shown :=1
	tmp_y := 50 - ypos
	; tmp_x := 

	; reposition the inset image to mouse
	Gui, 5: Show, x%GUI5X% y%tmp_y% w%PicW% h%PicH%
	keywait Shift
	if (AOT_hold=0)
	{
		gui, 4: hide
		gui4shown :=0
	}
	
	settimer,check_active,150
return
change_pic:
	; GuiControl, 5: -Redraw, Pic
	GuiControl, 5: , Pic, %AOT_screenshot_img_File%
	; GuiControl, 5: +Redraw, Pic 
return
create_aot_gui:
	GUI4W := 1352
	GUI4H := 720
	Gui, 4: Color, Black
	Gui, 4: +AlwaysOnTop +ToolWindow  +resize -border
	Gui, 4: Margin, 0, 0

	Gui, 4: Add, button, x3 y2 w25 h40 gAOT_hold,O
	Gui, 4: Add, button, x3 y+0 w25 h30 ggui4full1,|..|
	Gui, 4: Add, button, x3 y+0 w25 h30 ggui4full2,--
	Gui, 4: Add, button, x3 y+0 w25 h30 ggui4full3, ..|
	Gui, 4: Add, button, x3 y+0 w25 h30 ggui4full4,__
	Gui, 4: Add, button, x3 y220 w25 h200 gAOT_hold,O
	Gui, 4: Add, Text, x30 y2 w1355 h700 +E0x01 HwndHParent
	; Picture GUI
	Gui, 5: +HwndHGUI5 +Parent%HParent%
	Gui, 5: Margin, 0, 0
	Gui, 5: Add, Pic, vPic gClicked_AOT_Image, %AOT_screenshot_img_File%
	GuiControlGet, Pic, 5:Pos
	GUI5X := (GUI4W - PicW) // 2 + 30
	GUI5Y := (GUI4H - PicH) // 2
	; Gui, 4: Show, w%GUI4W% h350, Picture GUI - Click & Drag

	AOT_hold:=0
return
AOT_hold:

	AOT_hold:=!AOT_hold
	if (AOT_hold)
		gui, 4: Color, 00ff00
	else
		gui, 4: Color, ffffff
	; tooltip,%AOT_hold%
	; sleep,500
	; tooltip
return

4guiclose:
hide:
	gui,4:hide
	gui4shown:=0
	AOT_hold:=0
	gui, 4: color,ffffff
	settimer,check_active,off
return

Clicked_AOT_Image:
   PostMessage, WM_NCLBUTTONDOWN := 0x00A1, 2, 0, , ahk_id %HGUI5%
Return

gui4full1:
Gui, 4: Show,  x0  w%GUI4W% h900 y50, Picture GUI - Click & Drag
; Gui, 5: Show, x%GUI5X% y%GUI5Y% w1300 h900
return

gui4full2:
Gui, 4: Show, x0  w%GUI4W% h350 y380, Picture GUI - Click & Drag
; Gui, 5: Show, x%GUI5X% y%GUI5Y% w1300 h350

return

gui4full3:
Gui, 4: Show,x850 w500 h750 y5 , Picture GUI - Click & Drag
; Gui, 5: Show, x%GUI5X% y%GUI5Y% w500 h700

return

gui4full4:
Gui, 4: Show, x0 w%GUI4W% h250  y500, Picture GUI - Click & Drag
; Gui, 5: Show, x%GUI5X% y%GUI5Y% w1300 h200

return


<^+5::	; AOT ScreenCycle HK
settimer,cancelAOTScreenCycleHK,off	
if !(AOTScreenCycleHK_active)	;	if hotkey is currently not in cycle mode 
{
	AOTScreenCycleHK_count:=0
}
	; settimer,cancelAOTScreenCycleHK,-2500	

if (AOTScreenCycleHK_count=0)
{	
	AOTScreenCycleHK_count++
	msg=show_AOT_screenshot
	settimer,removetooltip,-2600
	tooltip,%AOTScreenCycleHK_count% %msg%
	AOTScreenCycleHK_action = show_AOT_screenshot
}
else if (AOTScreenCycleHK_count=1)
{	
	AOTScreenCycleHK_count++
	msg=capture_show_AOT_screenshot
	settimer,removetooltip,-2600
	tooltip,%AOTScreenCycleHK_count% %msg%
	AOTScreenCycleHK_action = capture_show_AOT_screenshot	
}
else if (AOTScreenCycleHK_count=2)
{	
	AOTScreenCycleHK_count++
	msg=capture_AOT_screenshot
	settimer,removetooltip,-2600
	tooltip,%AOTScreenCycleHK_count% %msg%	
	AOTScreenCycleHK_action = capture_AOT_screenshot	
}
else
{	
	AOTScreenCycleHK_count:=0
	msg=cancel
	settimer,removetooltip,-1600
	tooltip,%AOTScreenCycleHK_count% %msg%	
}
	
AOTScreenCycleHK_active:=1
hotkey,^q,on
setTimer,AOTScreenCycleHK,70
sleep,10

return

AOTScreenCycleHK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		gosub,cancelAOTScreenCycleHK
		if (AOTScreenCycleHK_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%AOTScreenCycleHK_count% cancelled
			
		}
		else if (AOTScreenCycleHK_count=1)
		{		
			gosub,%AOTScreenCycleHK_action%
		}
		else if (AOTScreenCycleHK_count=2)
		{
			gosub,%AOTScreenCycleHK_action%
		}
		else if (AOTScreenCycleHK_count=3)
		{
			gosub,%AOTScreenCycleHK_action%
		}
	}
return

cancelAOTScreenCycleHK:	;	cancel without action
	setTimer,AOTScreenCycleHK,off
	AOTScreenCycleHK_active:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return

removetooltip:
	settimer ,removetooltip,off
	tooltip
return

$^q::	; na
	send ^q
Return

capture_AOT_screenshot:
	; Runwait, %comspec% /c ""C:\cbn_gits\opus\apps\nircmd\nircmd.exe" cmdwait 100 savescreenshot "%AOT_screenshot_img_File%" ,,Hide
	Runwait, %comspec% /c ""C:\users\%A_UserName%\Downloads\boxcutter-1.5\boxcutter-1.5\boxcutter.exe" -f "%AOT_screenshot_img_File%" ,,Hide
	tooltip,saved
	sleep,500
	tooltip
return


>^+t::	; show sel as AOT tooltip, Critical  ,off

	MC_OwnChange:=1
	selText:=Get_Selected_Text()
	MC_OwnChange:=0
	if selText<>
		preview_text:=selText
	tooltip,%preview_text%`n[esc to close or 20s],,,7
	sleep,1000
	settimer,close_AOT_tooltip,-1
	keywait ctrl
return

close_AOT_tooltip:
	KeyWait ,esc,D,T20
	tooltip,,,,7
return
