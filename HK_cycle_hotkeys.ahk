#SingleInstance Force
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
#include C:\cbn_gits\AHK\LIB\HK_cycle.ahk
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\contextmenu.ahk
Menu, Tray, Icon, Shell32.dll, 36

; settimer, test,500
		
fileread,folder_list,fav_folder_list.txt
; folder_list = C:\users\%a_username%\configadvisordata`nC:\users\%a_username%\ca_cabling\depot.corduroy.com`nC:\users\%a_username%\ca_cabling\depot.corduroy.com\corduroy\resources\visualizer`nC:\users\%a_username%\configadvisordata\recent_results
sorted_folder_list :=folder_list

; stringsplit, sorted_folder_list, sorted_folder_list,`n,`r


config =
(
copy file as base64,paste here from base64
,
,
FileFullpathname:=get_selected_filepath(),
,
copy_file_as_base64(FileFullpathname),
,paste_base64_asFile
,
)
HK_cycle_register("<#=","Copy_Paste_base64_HK",2,3000,"Lwin", "$#q",config)


config =
(
mon 1+2, mon 2, mon 1,left of 1+2
,,,
,,,
,,,
,,,
"MoveWindow(""0"",""32"",2880,875)","MoveWindow(""1610"",""0"",""1280"",1024)",,"MoveWindow(""0"",""38"",800,1000)",
MoveWindow2,,,
,,,
)
HK_cycle_register("<#3","multi_monitor_HK",4,3000,"Lwin", "$#q",config)


config =
(
copy get_current_filepath_from_active_window,open 
,,,
,,,
,,,
,,,
clipboard:=get_current_filepath_from_active_window(),,clipboard:=get_parent_filepath(),clipboard:=get_parent_filepath()
,open_in_fileManager,,
,,,
)
HK_cycle_register("<#0","Copy_current_filepath_from_active_window_HK",2,3000,"Lwin", "$#q",config)



config =
(
copy full pathnames,parent,names only,copy names only without ext
,,,
,,,
,,,
,,,
clipboard:=get_selected_filepath(),clipboard:=get_parent_filepath(),,clipboard:=get_parent_filepath()
,,extract_basenames,
,,,
)
HK_cycle_register("<#1","Copy_Path_HK",4,3000,"Lwin", "$#q",config)


config =
(
AOT esc,AOT hold,AOT OFF
,
,
,
,
,
,
,
)
; HK_cycle_register(">^+t","AOT_tooltip_HK",3,4000,"RCtrl", "$^q",config)


config =
(
power save,power save OFF,bright
,
,
,
,
,
power_save_options,power_save_options
,
)
HK_cycle_register("<^F12","power_save_HK",3,4000,"LCtrl", "$^q",config)


config =
(
SLEEP,HIBERNATE
,
,
,
,
,
sleep_computer,hibernate_computer
,
)
HK_cycle_register("<^F1","power_options_HK",2,4000,"LCtrl", "$^q",config)


config =
(
sel text in N++,open in quick note
,
,
,
,
,
sel_in_Npp,sel_in_Notepad
,
)
HK_cycle_register("<^F8","open_sel_text_HK",2,4000,"LCtrl", "$^q",config)


config =
(
google search,python search,map search,multi search
,
,
,
,
,
search_google,search_google_python,google_map_search,test2,multi_search
,
)
HK_cycle_register(">^g","google_search_HK",4,4000,"RCtrl", "$^q",config)


config =
(
My computer,desktop,Downloads,Home directory
,
,
,
,
,"menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\desktop"")","menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\Downloads"")","menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%"")"
open_mycomputer,
,
)
HK_cycle_register("<#e","open_fav_folders3_HK",4,4000,"Lwin", "$#q",config)


config =
(
download youtube url,download clipb url in IDM,
,
,
,
,
,
,
,
)
HK_cycle_register("<^f6","download_HK",2,4000,"LCtrl", "$^q",config)


config =
(
miscnotes.txt,! python task.txt
,
,
,
,
"menuEvent_function(""N++"",""C:\users\%a_username%\downloads\text\miscnotes.txt"")","menuEvent_function(""N++"",""C:\users\%a_username%\downloads\text\! python task.txt"")",
,
,
)
HK_cycle_register("<#4","open_fav_files_HK",2,4000,"Lwin", "$#q",config)




config =
(
f1,f2,f3,add clipb path to list and open
get_fav_folder_list,get_fav_folder_list,get_fav_folder_list
,
,
open_folder,open_folder,open_folder,add_to_list_open_folder
,
,
,
)
HK_cycle_register("<#7","tmp_fav_folders_HK",4,4000,"Lwin", "$#q",config) 

config =
(
C:\users\%a_username%\configadvisordata,C:\users\%a_username%\ca_cabling\depot.corduroy.com,C:\users\%a_username%\ca_cabling\depot.corduroy.com\corduroy\resources\visualizer,C:\users\%a_username%\configadvisordata\recent_results
,
,
,
,
"menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\configadvisordata"")","menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\ca_cabling\depot.corduroy.com"")","menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\ca_cabling\depot.corduroy.com\corduroy\visualizer"")","menuEvent_function(""OpenIfFolder_SelectIfFile"",""C:\users\%a_username%\configadvisordata\recent_results"")"
,
,
)
HK_cycle_register("<#8","open_fav_folders2_HK",4,4000,"Lwin", "$#q",config) 

; runs cmd console
config =
(
cmd here,bash here,on sel path,clipb
,
,
sourcepath:=get_parent_filepath(),sourcepath:=get_parent_filepath(),
,
"run_cmd_prompt(sourcepath)","run_bash_prompt(sourcepath)",
,
,
)
HK_cycle_register("<#2","run_cmd_HK",4,4000,"Lwin", "$#q",config) 
return

test:
tooltip,HK_cycle_id=%HK_cycle_id%`nCopy_Path_HK=%Copy_Path_HK%  HK_cycle_id_action=%HK_cycle_id_action% HK_cycle_id_count=%HK_cycle_id_count%`ncopy_paste_base64_HK=%copy_paste_base64_HK%  HK_cycle_id_action=%HK_cycle_id_action% HK_cycle_id_count=%HK_cycle_id_count%,800,700,8
return


; $^k::
	; HK_cycle_abort_onCancel_key(a_thishotkey)
; Return

/*

^i::
	HK_cycle_id = OpenFavFolder_HK
	if (!%HK_cycle_id%)
	{
		HK_msgs =C:\cbn,C:\cbn_gits\AHK\LIB
		HK_actions_onRelease=open_folder,open_folder
		HK_actions_before_msg= ; empty if not reqd. it modifies the global variable 'HK_custom_disp_msg' for truncated message preview and 'HK_cycled_output'
		extra_params= ,,,
		input_param= ; like selected text or sourcepath or clipb
		HK_cycle_tot_steps= 2 ; excluding cancel
		release_checking_key :="ctrl"
		idle_stop_after = 7000
		%HK_cycle_id%_release_Pre_action=path
		HK_cycle_id_count = %HK_cycle_id%_count
		HK_cycle_before_cycling()
	}
	HK_cycle_next( %HK_cycle_id%, %HK_cycle_id_count%, HK_cycle_tot_steps, HK_msgs, HK_actions_onRelease, extra_params, input_param, HK_cycle_id_action, idle_stop_after, HK_actions_before_msg)
	; keywait,i
return

path:
	; msgbox,%HK_cycle_id_count%
	c:= %HK_cycle_id_count%
	FileFullpath := HK_msgs%c%
return

copy:
	; clipboard := HK_cycled_output
	enterToSend_EscToCancel_ElseCopy(HK_cycled_output)
return

*/

open_folder(FileFullpath)
{
global
	msgbox,opening =%FileFullpath%=
	menuEvent_function("OpenIfFolder_SelectIfFile", FileFullpath)
}
return


/*
		HK_msgs =copy as base64,paste here from clipb
		HK_actions_onRelease=copy_file_as_base64,paste_base64_asFile
		HK_actions_before_msg= ;
		extra_params= ,,,
		input_param= 
		HK_cycle_tot_steps= 2  
		release_checking_key ="Lwin"
		idle_stop_after = 7000
		%HK_cycle_id%_release_Pre_action=
*/		



copy_file_as_base64: ; copy as base64
	FileFullpathname := get_selected_filepath()
	copy_file_as_base64(FileFullpathname)
Return     
          
paste_base64_asFile:	; paste base64 data here

	sourcepath := get_parent_filepath()	
	paste_base64_asFile(sourcepath)
Return

copy_file_as_base64(FileFullpathname)
{
	FileGetSize, Size, %FileFullpathname%
	FileRead, Bin, *c %FileFullpathname%
	Base64enc( PNGDATA, Bin, Size )
	; 1234567890 is a token to communicate
	Clipboard := "1234567890" . FileFullpathname . "`n" . PNGDATA
	len := strlen(clipboard)
	stringleft,a,clipboard,400
	settimer,removetooltip,1500
	tooltip,length=%len%`n%a%
}
	
	
paste_base64_asFile(sourcepath)
	{
		; clipboard content first line is fullpathname of copied file
		FullDATA:=clipboard
		DATA =
		loop,parse,FullDATA,`n,`r
		{
			if a_index =1
				File := a_loopfield
			else
				DATA .= a_loopfield			
		}
		if ( Substr(File,1,10) != "1234567890" )
		{
			settimer,removetooltip,1500
			tooltip, not filedata
			return
		}
		stringtrimleft,File,File,10
		splitpath,File,Filename
		target_file := sourcepath . "\" . Filename
		target_file := get_next_filename(target_file,10)
		if (!target_File)
		{
			settimer,removetooltip,1500
			tooltip,error
			return
		}	
		Bytes := Base64Dec( BIN, DATA )
		VarZ_Save( BIN, Bytes, target_file )
		VarSetcapacity( DATA, 0 )
		settimer,removetooltip,1500
		tooltip,%target_file%
	}
MoveWindow2:

	WinMove,A,,0,38,A_Screenwidth-18, A_ScreenHeight-38
return
	MoveWindow(x,y,width, height)
{
	WinMove, A, , x, y, width, height
	ToolTip, %width%x%height%
	Sleep, 500
	ToolTip,
	Return
}

WinMove,A,,0,38,2880, 862
extract_basenames:
; msgbox
	all := get_selected_filepath()
	output:= regexreplace(all,"im)(*ANYCRLF)^(.*)\\([^\\]*)$","$2")
	clipboard := output
return

extract_basenames_noext:

	all := get_selected_filepath()
	; all :=clipboard
	output:= regexreplace(all,"im)(*ANYCRLF)^(.*)\\([^\\]*?)\.?([^\.]*)$","$2")
	; msgbox,%output%
return


get_fav_folder_list:

	msgbox,a%sorted_folder_list%
	stringsplit,sorted_folder_list, sorted_folder_list,`n,`r
	FileFullpathname := sorted_folder_list%HK_cycle_id_count%
	msgbox,c%sorted_folder_list1%
	; tooltip,%HK_cycle_id_count% %FileFullpathname%
	; sleep,500
	HK_custom_disp_msg := FileFullpathname
return

open_folder:
	msgbox,q%FileFullpathname%
	FileFullpathname:= 
	menuEvent_function("OpenIfFolder_SelectIfFile",FileFullpathname)
return

add_to_list_open_folder:
	Filedelete,C:\cbn_gits\AHK\fav_folder_list.txt
	sorted_folder_list:= clipboard . "`n"
	loop,3
	{
		sorted_folder_list .= sorted_folder_list%a_index% . "`n"
	}
	Fileappend,%sorted_folder_list%,C:\cbn_gits\AHK\fav_folder_list.txt
return

open_mycomputer:
	Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
return

google_map_search: 
	SearchTerms:=Get_Selected_Text()
	if ( SearchTerms !="" )
		Run,http://maps.google.com/?q=%SearchTerms%

return

search_google: ; google SEARCH
	SearchTerms:=Get_Selected_Text()
	if ( SearchTerms !="" )
		Run, http://www.google.com/search?q=%SearchTerms%

return

search_google_python: ; google SEARCH
	SearchTerms:=Get_Selected_Text()
	if ( SearchTerms !="" )
		Run, http://www.google.com/search?q=python`%20%SearchTerms%

return

sel_in_Notepad:
	file=%A_ScriptDir%\tmp_sel-text-45.txt
	ifexist,%file%
		filedelete,%file%
	fileappend,%selText%,%file%
	run ,notepad.exe "%file%"
return


sel_in_Npp:
	file=%A_ScriptDir%\tmp_sel-text-45.txt
	if selText <>
	{
		ifexist,%file%
		{
			filedelete,%file%
			sleep,50
		}
		fileappend,%selText%,%file%
		sleep,50
	}
	else
	{
		tooltip,opening previous	
	}
	menuEvent_function("N++",file)
	sleep,600
	tooltip
return


sleep_computer:
	alertcmd=%A_Script_Drive%\cbn\ahk\batterydeley\source\audio\beep2.wav
	Progress, b    w280  fs24 zh0 CT222222 CW00FF00, SLEEP........, , , Calibri

	SoundPlay,%alertcmd%
	Sleep, 400
	Progress, off

	Sleep, 200
	Progress, b    w280  fs24 zh0 CT222222 CW00FF00, SLEEP........, , , Calibri
	Sleep, 400
	Progress, off

	Sleep, 200
	; SoundPlay,%alertcmd%
	Progress, b  w280  fs24 zh0 CT222222 CW00FF00, SLEEP........, , , Calibri
	Sleep, 200
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0) ; DLL call to sleep
	sleep, 400
	Progress, off

return

hibernate_computer:

	alertcmd=%A_ScriptDir%\audio\2beep1.wav
	Progress, b    w380 h250  fs24 zh0 CTFFFFFF CWFF0000, HIBERNATING........, , , Calibri

	SoundPlay,%alertcmd%
	Sleep, 600
	Progress, off

	Sleep, 200
	Progress, b w380 h250 fs24 zh0 CTFFFFFF CWFF0000, HIBERNATING........, , , Calibri
	Sleep, 400
	Progress, off

	Sleep, 200
	; SoundPlay,%alertcmd%
	Progress, b  w380 h250 fs24 zh0 CTFFFFFF CWFF0000, HIBERNATING........, , , Calibri
	Sleep, 200
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 1, "int", 1)
	sleep, 400
	Progress, off

return



multi_search:
	tooltip, launching multi search
	settimer,removetooltip,-500
	SearchTerms:=Get_Selected_Text()
	Run, http://www.google.com/search?q=%SearchTerms%
	Run, http://www.google.com/search?q=%SearchTerms%&tbm=isch
	; Run, http://en.wikipedia.org/wiki/%SearchTerms%
	; Run, http://en.wikipedia.org/wiki/Special:Search/%SearchTerms%
	Run, http://www.bing.com/search?q=%SearchTerms%

return


power_save_options:
	power_save:=!power_save
	; battery low mode
	;brightness 
	
		If ( power_save ) 
			{
				br := 45 
				msg=power save mode
			}		  
		else
		   {
		   br := 90  
		   msg=power save mode OFF
		   }
		   
			VarSetCapacity(gr, 512*3) 
			Loop, 256 
			{ 
			   If  (nValue:=(br+128)*(A_Index-1))>65535 
					nValue:=65535 
			   NumPut(nValue, gr,      2*(A_Index-1), "Ushort") 
			   NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort") 
			   NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort") 
			} 
			hDC := DllCall("GetDC", "Uint", 0) ;NULL for entire screen 
			DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gr) 
			DllCall("ReleaseDC", "Uint", 0, "Uint", hDC) 
			
			tooltip,%msg%
			settimer,removetooltip,-400	
return

open_in_fileManager:
	file_path:=get_current_filepath_from_active_window()
	; RegExMatch(file_path, "\*?\K(.*)\\[^\\]+(?= [-*] )", file_path)
	
	if FileExist(file_path)
		Run explorer.exe /select`,"%file_path%"
	

return

test2:
msgbox,tessst
return