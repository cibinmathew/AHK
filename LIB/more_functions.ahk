dummy()
{
msgbox,dddd
return
}

download_Youtube_url()
{
	send,!d
	send,^c
	sleep,50
	clip_url:=clipboard
	stringreplace,clip_url,clip_url,/,`%2F,all
	stringreplace,clip_url,clip_url,:,`%3A,all
	stringreplace,clip_url,clip_url,?,`%3F,all	;	%

	url=http://keepvid.com/?url=%clip_url%

	run,%url%

return

}
download_clipB_url()
{
	tooltip, transferring to  IDM
	run,C:\Program Files (x86)\Internet Download Manager\IDMan.exe /d "%clipboard%"
settimer,removetooltip,-1000
	tooltip
	/*
	DetectHiddenWindows, On   
	winactivate,  Internet Download Manager 6.15 ahk_class #32770

	sleep,100
	; CoordMode, Mouse,Screen

	ifwinactive,  Internet Download Manager 6.15 ahk_class #32770
		{
		Click 50 ,80	;	click
		SoundBeep, 3050, 70  ; Play 
		sleep,300
		Click 517 ,51,0	;move w/o	click
		}
	else
		{
			tooltip,IDM not running
			sleep,1200
			tooltip
		}
	*/	
return
}

run_CA_environment()
{
	run,"C:\Program Files (x86)\Cisco Systems\Cisco Jabber\CiscoJabber.exe"
	run,"C:\Program Files (x86)\VMware\VMware Horizon View Client\vmware-view.exe" vmware-view://nb.ved.eng.netapp.com/?
	DetectHiddenWindows, On
	If !WinExist("ahk_class rctrl_renwnd32")
		{
		msgbox,not
		run,C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Outlook 2010.lnk
		}
return
}

toggle_autohide_taskbar()
{
	Run, RunDLL32.EXE shell32.dll`,Options_RunDLL 1
	; WinWait,Taskbar and Navigation properties	; win 8
	WinWait,Taskbar and Start Menu Properties
	Send, ua{ESC}
return
}

disable_Mouse_auto_focus()
{
run,C:\users\%A_UserName%\Desktop\Change how your mouse works - Shortcut.lnk
	WinWait,Make the mouse easier to use
; sleep,1000
	Send, !w
	Send, !o
sleep,400
	Winclose,Ease of Access Center
	return
}