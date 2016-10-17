; @cibin.mathew
#include C:\cbn_gits\AHK\LIB\tf.ahk
/*
WinActive("A") ; sets last found window
ControlGetFocus, ctrl
if (RegExMatch(ctrl, "A)Edit\d+"))
    ControlGet, text, Selected,, %ctrl%
else {
    clipboardOld := Clipboard
    Send, ^c
    if (Clipboard != clipboardOld) {
        text := Clipboard
        Clipboard := clipboardOld
    }space & a
}
MsgBox % text
*/	
Get_Selected_Text()  
{
; msgbox,kk
   WinGetActiveTitle, OutputVar 
   If OutputVar is space   
   {
		seltext =
		Return , seltext
   }
/*
	clipboardOld := Clipboard
	Send, ^c
	if (Clipboard != clipboardOld)
	{
		seltext := Clipboard
		Clipboard := clipboardOld
	}
	
*/	


   ClipSaved := ClipboardAll   ; Save clipboard content for later restore
   sleep , 100      ; Delays required else it can be unreliable
   Clipboard =      ; Flush clipboard
   Sleep, 40
   ; SendEvent, ^c   ; Save highlighted text to clipboard. 
   send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")
   sleep , 80
   seltext := Clipboard
   Sleep, 20
   Clipboard := ClipSaved   ; Restore Clipboard content  
   ClipSaved =            ; and free the memory
    
 
   Return , seltext      ; Search term now stored and ready
}

Get_Selected_Text_fast()  
{
   WinGetActiveTitle, OutputVar 
   If OutputVar is space   
   {
		seltext =
		Return , seltext
   }
   ClipSaved := ClipboardAll   ; Save clipboard content for later restore
   sleep , 10      ; Delays required else it can be unreliable
   Clipboard =      ; Flush clipboard
   Sleep, 10
   ; SendEvent, ^c   ; Save highlighted text to clipboard. 
   send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")
   sleep , 10
   seltext := Clipboard
   Sleep, 10
   Clipboard := ClipSaved   ; Restore Clipboard content  
   ClipSaved =            ; and free the memory
    
   Return , seltext      ; Search term now stored and ready
}

Get_Selected_Text_slow()  
{
   WinGetActiveTitle, OutputVar 
   If OutputVar is space   
   {
      seltext =
      Return , seltext
   }
   ClipSaved := ClipboardAll   ; Save clipboard content for later restore
   sleep , 100      ; Delays required else it can be unreliable
   Clipboard =      ; Flush clipboard
   Sleep, 100
   ; SendEvent, ^c   ; Save highlighted text to clipboard. 
   send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")
   sleep , 200
   seltext := Clipboard
   Sleep, 100
   Clipboard := ClipSaved   ; Restore Clipboard content  
   ClipSaved =            ; and free the memory
    
   
   Return , seltext      ; Search term now stored and ready
}
 
convert2volatile(query)
{
;	case=  ;i)
	volQuery=
	volQuery=%query%
	;volQuery:= RegExReplace(volQuery,  "[\\\.\*?+[{|()^$]", "\s*\$0\s*")  ;regex chars
	volQuery:= RegExReplace(volQuery,  "([a-z])\1{1,}", "$1*")  ;repeated chars
	volQuery:= RegExReplace(volQuery,  "[:,\/\=]", "\s*$0\s*")	;other chars

	volQuery:= RegExReplace(volQuery,  "\s{2,}", " ") ;space
	volQuery:= RegExReplace(volQuery,  " ", "\s*") ;space
	volQuery:= RegExReplace(volQuery,  "\\s\*{2,}", "\s*") ;space
;	stringreplace, volQuery, volQuery, %a_space%, (\s)*, all
;	stringreplace, volQuery, volQuery, `,, (\s)*`,(\s)*, all
volQuery=i)%volQuery%
 Return , volQuery
}

invert(x)
{
	if x
		x=0
	else
		x=1
return , x		
}

cleanFilePath()
{}

FilterVariable(source,searchStr,match=1,regex=0,Sourcedelimiter="`n`r",SearchStrDelimiter="`n`r")
{
	output=
	if match
	{
		Loop,parse,source,%SourceDelimiter%
		{
			searchin:=A_LoopField
			loop,parse,searchStr,%SearchStrDelimiter%
			{	
				if regex
				{
					if ( RegExMatch(searchin, searchStr) )
						output=%output%%Sourcedelimiter%%A_LoopField%
				}
				else
				{
					IfInString,searchin ,%searchStr%
						output=%output%%Sourcedelimiter%%A_LoopField%
				}
					
			}
		}
	}
	else 
	{
		Loop,parse,source,%Sourcedelimiter%
		{
			ifnotinstring,A_LoopField ,%searchStr%
				output=%output%%Sourcedelimiter%%A_LoopField%
		}		 
	}  
	return , output
}

buttontoggle(buttoncontrol)	;toggle and make bold
{
invert(butonconrol_v)
}



buttonBold(buttoncontrol,text="")
{

}


autoByteFormat(size, decimalPlaces = 2)
{
    static size1 = "KB", size2 = "MB", size3 = "GB", size4 = "TB"

    sizeIndex := 0

    while (size >= 1024)
    {
        sizeIndex++
        size /= 1024.0

        if (sizeIndex = 4)
            break
    }

    return (sizeIndex = 0) ? size " byte" . (size != 1 ? "s" : "")
        : round(size, decimalPlaces) . " " . size%sizeIndex%
}

isfile(file)	;	checks only online files
{

	If InStr( FileExist( file ), "D" ) 
		return 2
	else If FileExist( file ) 
		return 1
	else 
		return 0
}
		
		
CBN_TF_Find(Text, StartLine = 1, EndLine = 0, SearchText = "", ReturnFirst = 1, ReturnText = 0,returnmatch=1)
{ ; complete rewrite for 3.1




	; TF_GetData(OW, Text, FileName)		; if filename
	If (RegExMatch(Text, SearchText) < 1)
		Return "0" ; SearchText not in file or error, do nothing
	TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine) ; create MatchList
	
	Loop, Parse, Text, `n
	{
	 If A_Index in %TF_MatchList%
		{
		if (returnmatch)
			{
				  If (RegExMatch(A_LoopField, SearchText,match) > 0)
					{
					 If (ReturnText = 0)
						Lines .= A_Index "," ; line number
					 Else If (ReturnText = 1)
						Lines .= A_LoopField "`n" ; text of line 
					 Else If (ReturnText = 2)
						Lines .= A_Index ": " A_LoopField "`n" ; add line number
					 Else If (ReturnText = 3) ; match text
						Lines .= match "`n" ; text of line 
					 If (ReturnFirst = 1) ; only return first occurence
						Break
					}
			}
			else
			{
			 If (!RegExMatch(A_LoopField, SearchText,match) > 0)
				{
					If (ReturnText = 0)
						Lines .= A_Index "," ; line number
					 Else If (ReturnText = 1)
						Lines .= A_LoopField "`n" ; text of line 
					 Else If (ReturnText = 2)
						Lines .= A_Index ": " A_LoopField "`n" ; add line number
					 Else If (ReturnText = 3) ; match text
						Lines .= match "`n" ; text of line 
					 If (ReturnFirst = 1) ; only return first occurence
						Break
				}
			}
			
		}	
	}
	If (Lines <> "")
		StringTrimRight, Lines, Lines, 1 ; trim trailing , or `n
	Else
		Lines = 0 ; make sure we return 0
	Return Lines
}
 
	
Findstr_Find_In_files(SearchText,searchfilelist="",findRegEx=1,findLiteral=1,findCase=0)
; returns lines
{
	findOptions:                                                         ; Sets command line options for EveryStr.exe.

	If (findLiteral)                                                     ; Search string is literal, eg. "good dog" rather than
	   findLiteral := "/C:"                                              ; "good" AND "dog".
	Else
	   findLiteral=
	If (findCase) ;|| (findLiteral)                                       ; Default condition is "case sensitive" for the search
	   findCase=                                                         ; query.  Adding /I make the query NOT case sensitive.
	Else
	   findCase := "/I "

	If (findRegEx) {                                                     ; RegEx.
	   findRegex := "/R "
	 
	   }
	Else {
	   findRegEx=
		}
	findSearchOptions :=  findCase . findRegEx . findLiteral  ; The completed  options string.



	if SearchText = 
		return

	if searchfilelist = 
		return

	
	Runwait, %comspec% /c ""%A_WinDir%\system32\findstr.exe"  /C:"%SearchText%" /N  /F:"%searchfilelist%"  > "%A_ScriptDir%\preview1.txt"", , hide

	sleep,100
	fileread, results, %A_ScriptDir%\preview1.txt
	;msgbox,%results%
	return results

}	

 	/*
Findstr_Find(SearchText,searchfile="",searchfilelist="" )
; returns lines
{
msgbox,%SearchText%

	if SearchText = 
		return
	if searchfile = 
	{
		Runwait, %comspec% /c ""%A_WinDir%\system32\findstr.exe"  /F:"%searchfilelist%"  /C:"%SearchText%"  > "%A_ScriptDir%\preview1.txt"", , hide
	}
	else
	{
		Runwait, %comspec% /c ""%A_WinDir%\system32\findstr.exe"  /C:"%SearchText%"  "%searchfile%"    > "%A_ScriptDir%\preview1.txt"", , hide
	}
	 sleep,100
	fileread, results, %A_ScriptDir%\preview1.txt
msgbox,%results%
	return results

}	

 */
Find_files(Text,  SearchText = "",match_path=0)		; find matching filenames 
	{ 
	 Loop, Parse, Text, `n
		{
		splitpath,A_LoopField,name,dir
	   If (RegExMatch(name, SearchText,match) > 0)
		{
	 
		 
			Lines .= A_LoopField "`n" ; text of line 
 ; msgbox,%A_LoopField%
		  
		}
	}
	 
Return Lines
}

Findstr_Find(SearchText,searchfile="",findRegEx=0,findLiteral=1,findCase=0)
;returns lines
{
 
 
	If (findLiteral)                                                     ; Search string is literal, eg. "good dog" rather than
	   findLiteral := "/C:"                                              ; "good" AND "dog".
	Else
	   findLiteral=
	If (findCase) ;|| (findLiteral)                                       ; Default condition is "case sensitive" for the search
	   findCase=                                                         ; query.  Adding /I make the query NOT case sensitive.
	Else
	   findCase := "/I "

	If (findRegEx) {                                                     ; RegEx.
	   findRegex := "/R "
	 
	   }
	Else {
	   findRegEx=
		}
	findSearchOptions :=  findCase . findRegEx . findLiteral  ; The completed  options string.

 
if SearchText =
	return

Runwait, %comspec% /c ""%A_WinDir%\system32\findstr.exe" %findSearchOptions%"%SearchText%"  "%searchfile%"    > "%A_ScriptDir%\preview1.txt"", , hide
;sleep,100
fileread, results, %A_ScriptDir%\preview1.txt

return results
}


populate_file_list(results,max=50)
{
	results:=regexreplace(results,"m)^\n", "")	
	results:=regexreplace(results,"^\n", "")	
	results:=regexreplace(results,"\n$", "")
	Loop,parse,results,`n,`r
	{	
		if a_index>%max%
			break
			
		;f_name := a_loopfield
		splitpath, a_loopfield,name,,ext
		LV_Add("",name,A_LoopField,ext)			
; A_INDEX,SIZE
;LV_ModifyCol(1,100)
;LV_ModifyCol(1,"140 Integer")

	}
}



sortfilepathsonFilename(scripts)
{

	
	loop,parse,scripts,`n,`r
	{  
	SplitPath, A_Loopfield, name, dir, , ,
	scripts2=%scripts2%`n%name%@@@@@%A_Loopfield%	
	}
	
	sort,scripts2, 
	
	
	scripts=
	loop,parse,scripts2,`n,`r
	{  
		
		tmp:=regexreplace(A_Loopfield, "^(.*)@@@@@", "")
		scripts=%scripts%`n%tmp%
	}
	scripts:=regexreplace(scripts,"\n\n", "")
	scripts:=regexreplace(scripts,"\n\r", "")

	scripts:=regexreplace(scripts, "(\n)+", "$1")
	return scripts
	
}
 

 
AddMenuTrayAutostart()
{
	Menu, Tray, Add,
	Menu, Tray, Add, Autostart, menuTrayAutostartToggle
	file=%A_Startup%\%A_ScriptNAME%.lnk
	If FileExist(file)
		Menu Tray, Check, AutoStart
	;msgbox,%A_Startup%\%A_ScriptNAME%.lnk
return
}


 
menuTrayAutostartToggle()
{
   file=%A_Startup%\%A_ScriptNAME%.lnk
    If FileExist(file)
   {
      Menu Tray, Uncheck, AutoStart
      FileDelete %A_Startup%\%A_ScriptNAME%.lnk
   }
   Else
   {
      Menu Tray, Check, AutoStart ;%A_ScriptNAME%
      FileCreateShortcut %A_ScriptFullPath%, %A_StartUp%\%A_ScriptNAME%.lnk,WD,Arg,Manages multiple AutoHotkey scripts
   }
return
}
 
 
AddMenuTrayguishow()
{
	Menu, Tray, Add,
	Menu, Tray, Add, show gui, menuTrayguishowToggle
	 
return
}
 
 
menuTrayguishowToggle()
{
gui,show

return 
}
 

insert2array(item,array,max,position,replace=1)
{
  global 
  Loop %max% 
  {
	  n:=max-a_index
	  if (n=position)
		{
			array%n%:=item
			
			break
		}
	  n2:=n-1
	  array%n%:=array%n2%
	  ; if (a_index=position)
  }
  item:=array%4%
			
			 msgbox,%item%
  ; msgbox,%array%
  
return array
}

determine_text(input)
{

type=no_Match
	
pattern_names=
(
url
file_folder
relative_path
email
numbers
math_operation
url
url
date
)
 ; 127.0.0.1:5000
 ; 127.0.0.1
 ; 127.0.0.1/download
 ; http://127.0.0.1:5000/
 ; http://127.0.0.1:5000/echo
 ; http://localhost/s
 ; http://www.abc.Com
 ;www.abc.Com
 ;abc.com
 
; i)^http(s?)://(((2[0-5]{2}|1[0-9]{2}|[0-9]{1,2})\.){3}(2[0-5]{2}|1[0-9]{2}|[0-9]{1,2}))(:\d+)?(/)?([a-zA-Z0-9\-\.]+)?$
; i)^(https?\://|www\.)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$
pattern_list=
(
i)^((https?|ftp|file)://|www\.)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$
i)^([a-zA-Z]:)(\\[^\\/:\*"<>]+)+\\?$
i)^\\?[^\\/:\*"<>]+(\\[^\\/:\*"<>]+)+\\?$
i)^(mailto:)?([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$
^\d+$
^(\d+[\+\-\/\*])$
i)^(http(s?)://)?(((2[0-5]{2}|1[0-9]{2}|[0-9]{1,2})\.){3}(2[0-5]{2}|1[0-9]{2}|[0-9]{1,2}))(:\d+)?(/)?([a-zA-Z0-9\-\._\?&]+)?$
i)^(https?\://)?localhost(:\d+)?(/\S*)?$
^((0[1-9])|(1[0-2]))[\/-]((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))[\/-](\d{4})$
)
; "

type := check_if_match_pattern_from_list(input,pattern_list,pattern_names)
if (type="")
	type=no_Match
	
return type
}

check_if_match_pattern_from_list(source_text,pattern_list,pattern_names="")
{
	; returns matching pattern or pattern name
	if (pattern_names)
		StringSplit, pattern_names, pattern_names, `n
	StringSplit, pattern_list, pattern_list, `n

	; ^(?:[\w]\:|\\)(\\[a-z_\-\s0-9\.]+)+\.(?i)(txt|gif|pdf|doc|docx|xls|xlsx)$
	; ^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$
	
	; msgbox,%pattern_list0%
	result=
	loop,%pattern_list0%
	{
		FoundPos := RegExMatch(source_text,pattern_list%a_index%) 
		if ((FoundPos) >0)
		{
			if (pattern_names)
				result:=pattern_names%a_index%
			else
				result := pattern_list%a_index%
			break
		}			
	}
	return result
}

indexfiles( PathList, pathdelimiter="|", ListFile="",size=0,mod_time=0,recurse=0,filepattern="", regexpattern="" )
{
; wildcard operates first
	list =
	all_list=
	PathListN=
	if regexpattern=
	{
		regex_pattern_check:=0
	}
	else
		regex_pattern_check:=1
	if filepattern=
		filepattern=*.*
	if pathdelimiter =  ;if driveletters
	{
		Loop, Parse, PathList 
		{
			PathListN=%PathListN%%A_LoopField%:\|
		}
		PathList:=PathListN
	}
	if ( ListFile !="" )
		filedelete %ListFile%_temp 
	Loop, Parse, PathList,%pathdelimiter%
	{
	

		IfNotExist, %A_LoopField%
			Continue
				; msgbox,filepattern%filepattern% %A_LoopFileLongPath% regex_pattern_check%regex_pattern_check%
		Loop, %A_LoopField%\%filepattern%, 1,%recurse%
		{
			entry:=A_LoopFileLongPath
			if (regex_pattern_check)
				if !(regexmatch(entry,regexpattern))
					{
					; msgbox,%entry%
					continue
					}
			if (size)
			{
			FileGetSize, filesize, %A_LoopFileLongPath%

			entry .= "," . filesize
			}
			if ( mod_time )
			{
			FileGetTime, file_modTime, %A_LoopFileLongPath%
			entry .= "," . file_modTime
			}
			list .= entry .  "`n" 
			if (n>10000)
			{
				stringtrimright ,list,list,1
				if (ListFile !="")
					FileAppend, %list%`n,%ListFile%_temp
				else 
					all_list .= list
				list=
				n:=0
			}
			n++
		}
		if (n<10001)	; if reached last xxxx files
		{
			stringtrimright ,list,list,1
			if (ListFile !="")
				FileAppend, %list%,%ListFile%_temp
			else 
				all_list .= list
			list=
			n:=0
		}
	}
if (ListFile !="")
{
	filedelete %ListFile%
	FileCopy,%ListFile%_temp , %ListFile%
	sleep,50 
	filedelete %ListFile%_temp 
}
else 
	return all_list
}

truncated_text(text,length=200,lines=20)
{
	MyText:= Text
	if(StrLen(text)>length)
	{
		StringLeft, MyText, text,%length%
		MyText=%MyText%`n`n.........`n.........`n.........`n.........
	}
	Mytext2=
	loop,parse,Mytext,`n,`r
	{
		if (a_index <= lines)
			Mytext2 .= a_loopfield . "`n"
	}
	return MyText2

}

truncated_tooltip(text,length=200,delay=500)
{

	MyText=%Text%
	if(StrLen(text)>length)
	{
		StringLeft, MyText, text,%length%
		MyText=%MyText%`n`n.........`n.........`n.........`n.........
	}
	tooltip, %MyText%
	sleep, %delay%
	tooltip
}

thousand_separator(floor_value)
{
result=
tmp_n:=3	; for thoudands  grouping 3,2,2,2.....
	while (StrLen(floor_value)>0)
	{
		StringRight, OutputVar, floor_value, %tmp_n% 
		StringTrimRight, floor_value, floor_value, %tmp_n% 
		result=%OutputVar% %result% 
		if (tmp_n=3)
			tmp_n:=2
	}
return	result 
}		
make_lookarounds(text,delimiter="+")	; replaces + with lookarounds		
{
	ifinstring,text,%delimiter%
	{
		tmp3=		 
		loop,parse,text,%delimiter%
		{
			tmp3.= "(?=.*" . a_loopfield . ")"			
		}			
		text:=tmp3
	}
	; msgbox,%text%
	return text
}

remove_duplicates(text,delimiter="`n")	;	without sorting
{
; msgbox,before=%text%
	if (delimiter="`n")
		text:=regexreplace(text,"\R","`n")
	text=%delimiter%%text%%delimiter%
; msgbox,before=%text%
	StringCaseSense, Off
	Output_tmp := delimiter
	Output_tmp = 
	loop, parse, text,%delimiter%
	{
	   If Output_tmp not contains %delimiter%%A_Loopfield%%delimiter%
		  Output_tmp .= A_Loopfield . delimiter
	}
	stringtrimleft,Output_tmp,Output_tmp,1
	stringtrimright,Output_tmp,Output_tmp,1
	text:=Output_tmp
; msgbox,aftter=%text%
return text
}

make_text_search_smart(source,level=0,space=0)
{
	names_volatile:=regexreplace( source,"[\(\)-\.]*","" )
	if (space)
		stringreplace,names_volatile,names_volatile,%A_space%,,All
	stringreplace,names_volatile,names_volatile,_,,All
	text=
	loop,parse,names_volatile,`n,`r
	{
		t:=regexreplace(a_loopfield,"im)([\w])\1+","$1")
		if (level=2)
			t:=regexreplace(t,"im)([aeiou])+","a")
		text .= t "`n"
	}
	stringtrimright,text,text,1
return text
}

no_of_lines(text,blanks_also=1)
{
	count_without_blanks:=0
	count:=0
	loop,parse,text,`n,`r
	{
		if ( regexmatch(a_loopfield,"^(\s*)$") =0 )
			count_without_blanks++
		count++
	}
	if (blanks_also)
		return count
	else
		return count_without_blanks
}
update_recently_used_files(FileFullpath)
{
	global A_Script_Drive
	
	file=%A_Script_Drive%\cbn\ahk\search_paths\recently_used_files.txt
	fileread,recent_searches,%file%
/*
	stringreplace,a,FileFullpath,\,\\,All
	reg=im)(*ANYCRLF)^%a%$
	msgbox,=%reg%=%recent_searches%=
	; ifnotinstring, recent_searches ,%FileFullpath%`r
	if (regexmatch(recent_searches,reg))	
	{
		fileappend,`n%FileFullpath%,%file%
		msgbox
	}
	else
	{
		recent_searches := regexreplace(recent_searches,reg)
		; stringreplace,recent_searches,recent_searches,%FileFullpath%`r,,All
	}
	msgbox,=%recent_searches%=
	*/
	recent_searches:=add_if_not_existing(recent_searches,FileFullpath)
	filedelete,%file%
	fileappend,%recent_searches%,%file%

}

add_if_not_existing(haystack,needle,delimiter="`n")
{
	; add to top if not existing else moves it to top
	haystack := needle . delimiter . haystack	
	haystack := remove_duplicates( haystack,delimiter)
	return haystack
}