; http://www.cibinmathew.com
; github.com/cibinmathew

Menu, Tray, Icon, Shell32.dll, 37
#SingleInstance force 
settimer, reminder, 1200000
; settimer, Battery_Check, 1200000
; settimer,scheduler,-1 
settimer,scheduler,600000
#include LIB\misc functions.ahk

count:=0	;every alternate count triggers monitor off

Gui, +AlwaysOnTop   border -caption
gui,font,s50
Gui,Add, Text,x230 y50 w300 BackGroundTrans,  BREAK 
gui,font,s40
Gui, Add, Button, x100 y200 w350 h70 vok gOK, CLOSE
Gui, Add, Button, x+30 y200 w150 h70  gMonitorOff, OFF
gui,font,s16
Gui, Add, text, x30 y+20 w350 cred vtips_text, 
;gosub,reminder

return

OK:
objection=1
gui,cancel

return

nil:
return

reminder:
gosub, help_tips
timer:=5
objection=0
gui,show
loop 5
{
guicontrol, ,ok ,CLOSE (%timer%)
sleep,600
timer:=timer-1
}

if (objection=0 AND count=1)
{
count:=0 
SendMessage,0x112,0xF170,2,,Program Manager
sleep,1000
gui,cancel
return
}
count:=1

return
 
Battery_Check:
	VarSetCapacity(powerstatus, 1+1+1+1+4+4)
	success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

	acLineStatus:=Battery_Check_ReadInteger(&powerstatus,0,1,false)
	batteryFlag:=Battery_Check_ReadInteger(&powerstatus,1,1,false)
	batteryLifePercent:=Battery_Check_ReadInteger(&powerstatus,2,1,false)
	batteryLifeTime:=Battery_Check_ReadInteger(&powerstatus,4,4,false)
	batteryFullLifeTime:=Battery_Check_ReadInteger(&powerstatus,8,4,false)

	output=AC Status: %acLineStatus%`nBattery Flag: %batteryFlag%`nBattery Life (percent): %batteryLifePercent%`nBattery Life (time): %batteryLifeTime%`nBattery Life (full time): %batteryFullLifeTime%
	; MsgBox, %output%
	batteryLifeTime_2:=GetFormatedTime(batteryLifeTime)
	if (batteryLifePercent<95)
	MsgBox, Battery Life (percent): %batteryLifePercent%`nBattery Life (time): %batteryLifeTime_2%
return

Battery_Check_ReadInteger( p_address, p_offset, p_size, p_hex=true )
{
  value = 0
  old_FormatInteger := a_FormatInteger
  if ( p_hex )
    SetFormat, integer, hex
  else
    SetFormat, integer, dec
  loop, %p_size%
    value := value+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  SetFormat, integer, %old_FormatInteger%
  return, value
}


MonitorOff:
sleep,300
SendMessage,0x112,0xF170,2,,Program Manager
return

help_tips:
	FileRead, text, C:\users\%A_UserName%\Desktop\all hotkeys.txt 
	max := no_of_lines(text)

	Random, rand_no ,0 ,Max
	FileReadLine, text, C:\users\%A_UserName%\Desktop\all hotkeys.txt , %rand_no%
	guicontrol,,tips_text,%text%

return


scheduler:
;command,file|url|...,time
tasks=
(
https://www.youtube.com/watch?v=vsQf9OHU35s&list=PLssi8O1SK6QIXfWuaHApOmTDWbVqegZr5,url,1455
https://www.youtube.com/watch?v=FNQxxpM1yOs,url,1855
C:\users\%A_UserName%\Desktop\naukri_auto_updater.py,file,1100
C:\users\%A_UserName%\Desktop\naukri_auto_updater.py,file,1430
http://www.naukri.com/walk-in-jobs-in-bangalore,1450
C:\Program Files (x86)\Windows Media Player\wmplayer.exe,file,1410
)
FormatTime, Time_now, T12,  hhmm


loop,parse,tasks,`n,`r
{
	loop,parse,a_loopfield,CSV
	{
		if a_index=1
			command := a_loopfield
		else if a_index=2
			type := a_loopfield
		else if a_index=3
			time := a_loopfield
	}
	;msgbox,% Time_now-time ;time%-%Time_now%
	if (Time_now-time<10 and Time_now-time>0) ; in last 10min
	{
		MsgBox, 4, ,%command%`n%time%`nRun??
		IfMsgBox No
			continue
		run,%command%
	}
}		

return

