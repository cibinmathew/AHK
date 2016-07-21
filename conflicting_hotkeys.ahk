menu, Tray, Icon, Shell32.dll, 90
#SingleInstance Force
#InstallKeybdHook
#UseHook On
<+capslock::	;	send, {del}
	send, {del}
return
>+capslock::
SetCapsLockState, % GetKeyState("CapsLock", "T")? "Off":"On"
	GetKeyState, CapState, CapsLock, T
	
	settimer,removetooltip,400
	If CapState=U
	{
		tooltip,caps off
		SetCapsLockState, off
	}
	Else if CapState=D
	{
		tooltip,CAPS ON
		SetCapsLockState, on
	}
return

; CapsLock::	; na
	;GetKeyState, state, CapsLock, P
	;if (state="D")
CapsLock up::	; na
	state := GetKeyState("Space" , "P")

	if !state
	{
			Send, {BackSpace}
			settimer,removetooltip,-400
			tooltip,CapsLock & p/n/f/b
	}
return

removetooltip:
	settimer,removetooltip,off
	tooltip
return

CapsLock & i::send +{up}
CapsLock & k::send +{down}
CapsLock & l::send ^+{right}
CapsLock & j::send ^+{left}
CapsLock & ,::send +{home}
CapsLock & .::send +{end}


