; @cibin.mathew
SplitPath, A_ScriptDir , , , , , A_Script_Drive
xyplorer_installed:=0
dopus_installed:=0
notepadPP_path = C:\Program Files (x86)\Notepad++\notepad++.exe
Sublime_path = C:\Program Files\Sublime Text 3\sublime_text.exe
ifexist , C:\users\%a_username%\Downloads\xyplorer_free_noinstall\XYplorerFree.exe
	xyplorer_installed:=1
ifexist , C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
	dopus_installed:=1
FileManagerPath=C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
FileManagerPath2=C:\users\%a_username%\Downloads\xyplorer_free_noinstall\XYplorerFree.exe
FileManagerPathArgs=
ifexist , %notepadPP%
	textEditor_app := notepadPP_path
else ifexist, %Sublime_path%
	textEditor_app := Sublime_path
else
	textEditor_app= notepad.exe
TextEditorName=Notepadplus
FileMan_app=C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
FileManArgs=
splitpath,A_LineFile,,includefolder

/*
setupMenuXtras()
{ 
	global	; all global variables
	dopus_installed:=0
	ifexist , C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
	; msgbox
		dopus_installed:=1
	FileManagerPath=C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
	FileManagerPathArgs=
	textEditor_app=F:\cbn\opus\apps\notepad++\notepad++.exe
	TextEditorName=Notepadplus
	FileMan_app=C:\Program Files\GPSoFtware\Directory Opus\dopus.exe
	FileManArgs=
	Return
}
*/
setupMenu(menu="Context1")
{
	global
	; setupMenuXtras()
splitpath,A_LineFile,,includefolder
	
	Menu %menu%, Add, Open , menuEvent
	;Menu %menu%, Add, Open &directory, menuEvent
	Menu %menu%, Add, Open &parent, menuEvent
	Menu %menu%, Add
		Menu %menu%open in, Add,N++, menuEvent
	Menu %menu%, Add, open in, :%menu%open in
	; %A_Script_Drive%\cbn\ahk\NEW\quick search alphasearch\
	Menu %menu%, Add, Open &with %TextEditorName%, menuEvent
	
	Menu %menu%, Add,
	Menu %menu%, Add,copy Path, menuEvent
	if (menu="Context1_icons")
		Menu %menu%, Icon,copy Path, %includefolder%\circle Green.ico,,15
		
	Menu %menu%, Add,copy parent path, menuEvent
	if (menu="Context1_icons")
		Menu %menu%, Icon,copy parent path, %includefolder%\default.ico,,15
		
	Menu %menu%, Add,
	Menu %menu%, Add,copy, menuEvent
	Menu %menu%, Add, &Properties, menuEvent
	Menu %menu%, Add
	Menu %menu%, Add, Save &sel, menuEvent
	Menu %menu%, Add, Save &list, menuEvent
	Menu %menu%, Add
	Menu %menu%, Add, &Options, menuEvent
	Menu %menu%Help, Add,google, menuEvent	
	Menu %menu%, Add, Help, :%menu%Help
   Return
}

menuEvent_function(MenuItem,FileFullpath,params="")
{
	global
	
	/*IF ( !ThisMenuItem )
		ThisMenuItem = %A_ThisMenuItem%
		*/
	; stringreplace,FileFullpath,FileFullpath,",,ALL
	FileFullpath := RegExReplace(FileFullpath, "m`n)^[ \t]+", "")	;leading 
	FileFullpath := RegExReplace(FileFullpath, "m`n)[ \t]+$","")		;trailing
	FileFullpath := regexreplace(FileFullpath,"^""(.*)""$","$1")
	IF (MenuItem = "Open &directory") 
			Gosub openDirectory				
		else IF (MenuItem = "Open &parent") 
			Gosub openparent				
		else IF (MenuItem = "OpenIfFolder_SelectIfFile") 
			Gosub OpenIfFolder_SelectIfFile					
		else IF (MenuItem = "openInExplorer") 
			Gosub openInExplorer					
		else IF (MenuItem = "openInDopusColl") 
			Gosub openInDopusColl	  
		else IF (MenuItem = "Open &with "textEditorName)
			Gosub openInTextEditor
		else IF (MenuItem = "Open") 
			Gosub command_run
		else IF (MenuItem = "copy Path")
			Gosub copypath
		else IF (MenuItem = "copy parent path")
			Gosub copy_parent_path
		else IF (MenuItem = "copy")
			Gosub FileToClipboard
		else IF (MenuItem = "Save &sel")
			Gosub Save_Sel
		else IF (MenuItem = "Save &list")
			Gosub Save_List
		else IF (MenuItem = "&Properties")
			Run properties "%FileFullpath%",, UseErrorLevel
		else If (MenuItem = "N++")
			gosub,open_in_npp
		else If (MenuItem = "open_in_texteditor")
			gosub,open_in_texteditor
		else If (MenuItem = "open_in_sublime")
			gosub,open_in_sublime
		
		else If (MenuItem = "google")
			Run http://www.google.com/  
		MenuItem=
	Return

	Save_List:
		clipboard:=FileFullpath
		tooltip,%clipboard%
		sleep,450
		tooltip,
	return

	Save_Sel:
		txt=
		Loop % LV_GetCount("selected")
		{
			LV_GetText(RetrievedText, A_Index, 2)
			txt=%txt%`n%RetrievedText%
		}
		clipboard:=txt
		; clipboard:=FileFullpath
		tooltip,%clipboard%
		sleep,450
		tooltip,			
	return

	openInExplorer:
		filex="%FileFullpath%"
		If InStr( FileExist(FileFullpath), "D" )
		{
			run,explorer %Filex%			
		}
		else If ( FileExist(FileFullpath))
		{
			splitpath,FileFullpath,,outdir		
			Run %COMSPEC% /c explorer.exe /select`, %filex%,, Hide		
		}
		else
			gosub,file_not_found
		Gosub error_check
		; msgbox
		Return
		
	OpenIfFolder_SelectIfFile:
		filex="%FileFullpath%"
		If InStr( FileExist(FileFullpath), "D" )
		{
				; msgbox,%FileFullpath%
			;if folder ,open in opus
			if (dopus_installed)
			{
				run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH %Filex% 
				winactivate,ahk_class dopus.lister
			}
			else if (xyplorer_installed)
			{
				run, "%FileManagerPath2%" %Filex% 
				winactivate,ahk_class ThunderRT6FormDC
			}
			else
			{
				run,explorer %Filex%				
			}
		}
		else If ( FileExist(FileFullpath))
		{
			splitpath,FileFullpath,,outdir
			if (dopus_installed)
				{
					run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH %Filex% 
					winactivate,ahk_class dopus.lister
				}
				else if (xyplorer_installed)
				{
					run, "%FileManagerPath2%" %FileFullpath% 
					winactivate,ahk_class ThunderRT6FormDC
				}
				else
				{	
					Run %COMSPEC% /c explorer.exe /select`, %filex%,, Hide
				}
		}
		else
			gosub,file_not_found
		Gosub error_check
		; msgbox
		Return
; C:\Program Files (x86)\Google\Chrome\Application\chrome.exe

	openInDopusColl:
	if (dopus_installed)
	{
		file=%A_Script_Drive%\cbn\opus\opus_scripts\filelist collection_2.txt
		filedelete,%file%
		fileappend,%FileFullpath%,%file%
		sleep,50
		run ,"C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /col import "coll://collection/basket"   "%A_Script_Drive%\cbn\opus\opus_scripts\filelist collection_2.txt"
		run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH "coll://collection/basket"  OPENINDUAL
		winactivate,ahk_class dopus.lister
	}
	else
		msgbox,no dopus installed. Open the first file only??
	Return

	command_run: 	; Run the selected File.
		If InStr( FileExist(FileFullpath), "D" )
		{
			;if folder ,open in opus
			filex="%FileFullpath%"
			if (dopus_installed)
			{
				run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH %Filex% 
				winactivate,ahk_class dopus.lister
			}
			else
			{
				run,explorer %Filex% 
			}
			; default open ie in explorer			
			; in xyplorer	
			; run, "C:\Users\welcome\Desktop\xyplorer_full_noinstall\XYplorer.exe"  "%FileFullpath%"   
		}
		else If ( FileExist(FileFullpath))
		{
			splitpath,FileFullpath,,outdir
			Run "%FileFullpath%",%outdir%	;default run
			Gosub error_check
		}
		else
			gosub,file_not_found			
		Return

	openDirectory:
		; Open selected Files Folder. in File manager
		lines=0
		Loop, Parse, FileFullpath, `n,`r
		lines++
		if (lines<2)
		{
			IFExist %FileFullpath%
			{
				;default explorer
				;Run %FileMan_app% %FileManArgs%"%FileFullpath%",  , UseErrorLevel
				if (dopus_installed)
				{
					run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH "%FileFullpath%"    
					winactivate,ahk_class dopus.lister
				}
				else
				{
					Run %COMSPEC% /c explorer.exe /select`, "%FileFullpath%",, Hide
				}
			}
			else
				gosub,file_not_found
		}
		else	; multi lines
		{

			if (dopus_installed)
			{
				gosub,openInDopusColl
				
			}
			
		}	

		Gosub error_check
		Return

	openParent:                                                       ; Open selected Files Folder. in File manager
		IFExist %FileFullpath%
		 {
			 ;Run %FileMan_app% %FileManArgs%"%FileFullpath%",  , UseErrorLevel
			splitpath,FileFullpath,,Folder
					;folder=%path%\%folder%
			
			; in opus
			if (dopus_installed)
			{
				run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go PATH "%Folder%"    
				winactivate,ahk_class dopus.lister
			}
			else			
			Run %COMSPEC% /c explorer.exe /select`, "%Folder%",, Hide
			
			;in XYplorer
			; run, "C:\Users\welcome\Desktop\xyplorer_full_noinstall\XYplorer.exe"  "%Folder%"    	
			Gosub error_check	
		}
		else
			gosub,file_not_found
		Return
	open_in_sublime:
		Run   "%Sublime_path%" "%FileFullpath%"
		winactivate,ahk_class PX_WINDOW_CLASS
		return
		
	open_in_npp:
	
		Run   "%notepadPP_path%" "%FileFullpath%" %params%
		winactivate,ahk_class Notepad++
		return
		
	open_in_texteditor:		
		Run "%textEditor_app%" "%FileFullpath%"
		Return
		
	copypath:
		clipboard=%FileFullpath%
		tooltip,%clipboard%
		sleep,450
		tooltip,
		return	
		
	copy_parent_path:
		splitpath,FileFullpath,,Folder
		clipboard=%Folder%
		tooltip,%clipboard%
		sleep,450
		tooltip,
		return	
		
	FileToClipboard:
		Return

	openInTextEditor:                                                    ; Open File in a text editor.
		Run %textEditor_app% %FileFullpath%, %lvDirName%, UseErrorLevel
		Gosub error_check
		Return
	
	file_not_found:
		tooltip,	;	remove other tooltips
		tooltip,%FileFullpath%`nfile_not_found,,,2
		sleep,1000
		tooltip,,,,2
		return
		
	error_check:  ; IF there's an error opening a File, show the reason.
	IF (A_LastError <> 0) 
	{
	   thisError := returnLastError()
	   if (thisError <> )
		MsgBox,, %app_name% - Oops ..., error=%thisError%`nFile: %FileFullpath%
	}
	Return
	
Return	
 
}


returnLastError() {
	Global
	IFEqual A_LastError, 2, Return, "Error " %A_LastError% ": The system cannot Find the File speciFied."
	IFEqual A_LastError, 3, Return, "Error " %A_LastError% ": The system cannot Find the path speciFied."
	IFEqual A_LastError, 4, Return, "Error " %A_LastError% ": The system cannot open the File."
	IFEqual A_LastError, 5, Return, "Error " %A_LastError% ": Access is denied."
	IFEqual A_LastError, 15, Return, "Error " %A_LastError% ": The system cannot Find the drive speciFied."
	IFEqual A_LastError, 21, Return, "Error " %A_LastError% ": The device is not ready."
	IFEqual A_LastError, 25, Return, "Error " %A_LastError% ": Windows cannot Find the network path.`nVeriFy that the network path is correct and the destination computer is not busy or turned oFF.`nIF Windows still cannot Find the network path, contact your network administrator."
	IFEqual A_LastError, 1155, Return, "Error " %A_LastError% ": No application is associated with the speciFied File For this operation."
}

	
