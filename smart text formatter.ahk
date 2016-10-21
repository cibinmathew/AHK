; http://www.cibinmathew.com
; github.com/cibinmathew

SetWorkingDir %A_ScriptDir%
SplitPath, A_ScriptDir , , , , , A_Script_Drive

ifexist,smart text formatter.ico
	menu, Tray, Icon,smart text formatter.ico
#SingleInstance Force 
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk
hotkey,^q,off	;	start disabled
hotkey,^w,off	;	start disabled
; hotkey,^r,off	;	start disabled
hotkey,^+w,off
; hotkey,^+r,off
hotkey,<^+t,off
hotkey,^t,off

id=1

all_chars=([{"<)]}">
left_chars=([{"<
StringSplit , pair1_, left_chars
right_chars=)]}">
StringSplit , pair2_, right_chars

; all=(alb),(bbn),(cbn),(dijo),(eldhose)
; all=[alb],[bbn],[cbn],[dijo],[eldhose]
	; all=(alb),(bbn),(cbn),(dijo),(eldhose)
	; all=helo ('alb mathew'),helo ('bbn mathew'),helo ('cbn mathew'),helo ('dijo andrews'),helo ('eldhose paul')
	; all:=regexreplace(all,"(^\s+)|(\s+$)", "")
	; all=$_POST['alb'],$_POST['bbn'],$_POST['cbn'],$_POST['dijo'],$_POST['eldhose']
	; all=['alb']$_POST,['bbn']$_POST,['cbn']$_POST,['dijo']$_POST,['eldhose']$_POST
	; all=['alb'],['bbn'],['cbn'],['dijo'],['eldhose']
	
	
; clipboard=(alb),(bbn),(cbn),(dijo),(eldhose)
; clipboard=arun,`%cibin mathew`%,bibin
return

removetooltip:
	settimer ,removetooltip,off
	tooltip
return

$^t::	; na
if (Smart_Trim_HK)
{
	settimer, cancelSmart_Trim_HK, -3000	
	Smart_Trim_HK_count:=0
	if (Smart_Trim_HK_2_count=0)
	{
		output=
		reg1=im)"(.*)"
		loop,%maxEntry%
		{
			; M_%A_Index%:=a_loopfield
			M_%A_Index%:=regexreplace(M_%A_Index%,reg1,"$1")
			output .= M_%A_Index% . "`n"
			; maxEntry:=a_index
		}
		stringtrimright ,output,output,1
		msg=smart csv`n`n%output%
		
	}			
	else if (Smart_Trim_HK_2_count=1)
	{
		msg=a
		
	}			
	else if (Smart_Trim_HK_2_count=2)
	{
		msg=cancel
		Smart_Trim_HK_2_count:=-1
		settimer,cancelSmart_Trim_HK, -1000
	}
	Smart_Trim_HK_2_count++		
	settimer,removetooltip,-3000
	tooltip,smart extract`n%Smart_Trim_HK_2_count% %msg%
}

return

<^+t::	; na

if (make_Csv_HK)	;	if hotkey is currently not in cycle mode 
{
	settimer,cancelmake_Csv_HK, -3000
	setTimer,make_Csv_HK,100	
	if (make_Csv_HK_3_count=0)
	{
		output=
		loop,parse,all,`n,`r
		{
			output .="'" . a_loopfield . "',`n"
		}
		stringtrimright,output,output,1
		settimer,removetooltip,-3000
		tooltip,csv presets`n%output%
				
	}
	else if (make_Csv_HK_3_count=1)
	{
		tooltip,advanced		
		settimer,removetooltip,-3000
	}
	else if (make_Csv_HK_3_count=2)
	{
	
		output=
		loop,parse,all,`n,`r
		{
			output=%output%"%a_loopfield%",`n
		}
		stringtrimright,output,output,1
		settimer,removetooltip,-3000
		tooltip,csv presets`n%output%
		
	}
	else if (make_Csv_HK_3_count=3)
	{
	
		output=
		loop,parse,all,`n,`r
		{
			output .="(" . a_loopfield . "),`n"
		}
		stringtrimright,output,output,1
		settimer,removetooltip,-3000
		tooltip,csv presets`n%output%
		
	}
	else if (make_Csv_HK_3_count=4)
	{
		settimer,removetooltip,-1500
		settimer,cancelmake_Csv_HK, -1400
		tooltip,cancel
		make_Csv_HK_3_count=-1
	}
	make_Csv_HK_3_count++
}
else if (	Extract_col_HK) ;	append csv column to clipboard	
{
	tooltip,removing field encapsulator
	settimer,removetooltip,-600
}

return


$^+w::	; na
if (Extract_col_HK)	
	{
	
		tooltip,changing delimiter
		settimer,removetooltip,-600	
		
	}
else if (make_Csv_HK)	
	{
	
		; settimer,cancelmake_Csv_HK, -3000	
		make_Csv_HK_count:=0
	if (make_Csv_HK_2_count=0)
	{
		msg=""
		
	}			
	else if (make_Csv_HK_2_count=1)
	{
		msg=''
		
	}			
	else if (make_Csv_HK_2_count=2)
	{
		msg=[[
		
	}
	
	if ( make_Csv_HK_2_count=3 )	;	to check for 2 (it was incremented once)
	{
		make_Csv_HK_2_count:=0
		msg=cancel
		settimer,removetooltip,-700
		tooltip,%make_Csv_HK_2_count% %msg%
				
	}
	else
	{
		if ( make_Csv_HK_2_count=0 )
		{
	
			loop,parse,all,`n,`r
			{
				t="%a_loopfield%"
				M_%A_Index%:=t
				maxEntry:=a_index
			}
		}
		else if ( make_Csv_HK_2_count=1 )
		{
			loop,parse,all,`n,`r
				{
					t='%a_loopfield%'
					M_%A_Index%:=t
					maxEntry:=a_index
				}
		}
		else
		{
			loop,parse,all,`n,`r
				{
					t=[%a_loopfield%]
					M_%A_Index%:=t
					maxEntry:=a_index
				}
		}
		output=
		loop %maxEntry% {
		output .= M_%A_Index% . "`n"
		}	
		Sleep 0
		StringTrimright, output, output,1	
		all_now:=output
		; all:=output
		text:=truncated_text(output,520)
		
		tooltip,%make_Csv_HK_2_count% %msg% `tcsv maker`n^+w::  add on both ends`n^+r::  one side `n^+e:: update`n<^+t:: advanced`n`n`n%text%
		; settimer,removetooltip,-4500	
		setTimer,make_Csv_HK,100	
		; settimer,cancelmake_Csv_HK,off		; allow to cycle from first action again

		make_Csv_HK_2_count++		
		make_Csv_HK:=1

	}
}
return

$<^+e::	;	make csv
if (Extract_col_HK)
{

		gosub,cancelExtract_col_HK		
		clipboard .= "`n" .output
		sleep,100
		tooltip,adding`n%clipboard%
		settimer,removetooltip,-600
}
else  if (make_Csv_HK)
{
		; settimer,removetooltip,-3000
		text:=truncated_text(output,520)
		tooltip,csv maker`n^+w::  add on both ends`n^+r::  one side `n^+e:: update`n<^+t:: advanced`nupdated`n`n%text%
		; clipboard:=output
			
		all:=output
		; settimer,cancelmake_Csv_HK,-3000
		make_Csv_HK_count:=0
		make_Csv_HK_2_count:=0
}
else if !(make_Csv_HK)	;	if hotkey is currently not in cycle mode 
	{
		

		selText:=clipboard
		all:=selText
		all_now:=selText	; present state of selected text
		output:=all
		text:=truncated_text(selText,520)
		tooltip,csv maker`n^+w::  add on both ends`n^+r::  one side `n^+e:: update`n<^+t:: advanced`n`n`n%text%
		; settimer,removetooltip,-3500	
	
		make_Csv_HK:=1
		make_Csv_HK_count:=0
		make_Csv_HK_2_count:=0
		hotkey,^q,on
		hotkey,<^+t,on
		hotkey,^+w,on
		hotkey,<^+r,on
		; settimer,cancelmake_Csv_HK,-3000
		setTimer,make_Csv_HK,100
		make_Csv_HK_3_count:=0
}

return

$<^+r::	;	extract csv
if (make_Csv_HK)	;	if hotkey is currently  in cycle mode 
{
	; settimer,cancelmake_Csv_HK,-3000
	make_Csv_HK_2_count:=0
	if (make_Csv_HK_count=0)
	{
		msg=make csv		
	}			
	else if (make_Csv_HK_count=1)
	{
		msg=ordered pair		
	}			
	else if (make_Csv_HK_count=2)
	{
		msg=asdfasfd		
	}

	if ( make_Csv_HK_count=3 )	;	to check for 2 (it was incremented once)
	{
		make_Csv_HK_count:=0		
		msg=cancel
		settimer,removetooltip,-1500
		text:=truncated_text(all,520)
		output:=all
		tooltip,%make_Csv_HK_count% %msg% `tcsv maker`n^+w::  add on both ends`n^+r::  one side `n^+e:: update`n<^+t:: advanced`n`n`n%text%
		; settimer,cancelmake_Csv_HK,-680		
		; all:=selText
	}
	else
	{
		if ( make_Csv_HK_count=0 )
		{
	
			loop,parse,all,`n,`r
			{
				t=%a_loopfield%,
				M_%A_Index%:=t
				maxEntry:=a_index
			}
		}
		else if ( make_Csv_HK_count=1 )
		{
			loop,parse,all,`n,`r
			{
				t=%a_loopfield%+
				M_%A_Index%:=t
				maxEntry:=a_index
			}
		}
		else
		{
			loop,parse,all,`n,`r
			{
				t=%a_loopfield%=
				M_%A_Index%:=t
				maxEntry:=a_index
			}
		}
		
		output=
		loop %maxEntry%
		{
			output .= M_%A_Index% . "`n"
		}
		
		StringTrimright, output, output,2
		Sleep 0
		
		all_now:=output
		; all:=output
		
		text:=truncated_text(output,520)

		tooltip,%make_Csv_HK_count% %msg% `tcsv maker`n^+w::  add on both ends`n^+r::  one side `n^+e:: update`n<^+t:: advanced`n`n`n%text%
		; settimer,removetooltip,-4500	
		setTimer,make_Csv_HK,100	
		; settimer,cancelmake_Csv_HK,off		; allow to cycle from first action again

		make_Csv_HK_count++		
		make_Csv_HK:=1
		; hotkey,^q,on
		; hotkey,^w,on
		; hotkey,^r,on
		
	}
	
}
else
{
	settimer,cancelExtract_col_HK,off		
	output=
	if !(Extract_col_HK)	;	if hotkey is currently not in cycle mode 
	{
		all:=clipboard
		; all=albn,mechatronics,singapore`ncbn,computer science,TN`nbbn,ece,bangalore
		Extract_col_HK_count:=0
		; tooltip,triggered
		; sleep,200
		field_delimiter=`,`%\%A_Space%`%+:=
		delimiter_used=
		field_count:=0
		line=

		line:=get_first_non_empty_line(all)
			; msgbox,=%line%
		loop,parse,field_delimiter
		{
			ifinstring,line,%a_loopfield%
			{
				delimiter_used:=a_loopfield
				break
			}
		}
			; msgbox,line=%line%`n==%delimiter_used%
		loop,parse,line,%delimiter_used%
			field_count++
			

	}
	if (Extract_col_HK_count=0)
	{	; open sel in csvqf viewer

		tooltip, field_count=%field_count%`nopening in csv quick filter`n`n^+e: appending`n<^+t:delimiter
		settimer,removetooltip,-4000			
		Extract_col_HK_count++
		

	}
	else if (Extract_col_HK_count=1)
	{	; open sel in csvqf viewer

		tooltip,field_count=%field_count% Delim= %delimiter_used%`nopening in csvED.exe
		settimer,removetooltip,-4000			
		Extract_col_HK_count++
		

	}
	else if ( Extract_col_HK_count=field_count+2 )	;	to check for 2 (it was incremented once)
	{
		Extract_col_HK_count:=0
		msg=CANCEL
		settimer,removetooltip,-800
		tooltip,%Extract_col_HK_count% %msg%
		settimer,cancelExtract_col_HK,-800				
	}
	else
	{
	
		
		loop,parse,all,`n,`r
		{
			loop,parse,a_loopfield,%delimiter_used%
			{
				if ( a_index =Extract_col_HK_count-1 )
					output.= a_loopfield . "`n"
			}
		}
		stringtrimright,output,output,1
		; output_tmp:=output
		stringreplace,output_tmp,output,`n,,all
		msg=Delim= %delimiter_used%
		if output_tmp=
			text=%output_tmp%
		else
		{
			text:=truncated_text(output,520)
		}
		t:=Extract_col_HK_count-1
		tooltip,field = %t%/ %field_count% Delim= %delimiter_used%`n`n%text%`n`n^+e: appending`n<^+t:delimiter
		settimer,removetooltip,-4500			
		Extract_col_HK:=1
		hotkey,^q,on 
		Extract_col_HK_count++
	}

	Extract_col_HK:=1
	hotkey,^q,on
	hotkey,<^+e,on
	hotkey,^+w,on
	hotkey,<^+t,on
	setTimer,Extract_col_HK,70
	sleep,10
}
return

cancelmake_Csv_HK:
	setTimer,make_Csv_HK,off
	make_Csv_HK:=0
	settimer,removetooltip,-300
	tooltip,cancelled 17
	hotkey,^q,off
	hotkey,<^+t,off
	; hotkey,^+r,off
Return

make_Csv_HK:
	GetKeyState,state,CTRL
	If state=u
	{
		; gosub,cancelmake_Csv_HK
		if (make_Csv_HK_3_count=2)
		{
			line:=get_first_non_empty_line(all)
			InputBox, UserInput, enter pattern, --  *  --`n* = %line%, , 80,150,,,,,(*)
			if ErrorLevel
			{
				tooltip,cancelleddd
				settimer,removetooltip,-1000
			}
			else
			{
				StringSplit, UserInput, UserInput, *			

				output=
				loop,parse,all,`n,`r
				{
					output .=UserInput1 . a_loopfield . UserInput2 "`n"
				}
				stringtrimright,output,output,1
				tooltip,advanced`n%output%
				clipboard:=output				
				settimer,removetooltip,-1500
			}
		}
		else if (make_Csv_HK_2_count=0)
		{
			gosub,cancelmake_Csv_HK
			settimer,removetooltip,-300
			tooltip,copied
			clipboard:=output	
		}
		else if (make_Csv_HK_3_count=0)
		{
			gosub,cancelmake_Csv_HK
			settimer,removetooltip,-300
		}
		else 
		{
			settimer,removetooltip,-300
			tooltip,copied
			clipboard:=output				
			; all:=output
		}
	}

return


Extract_col_HK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (Extract_col_HK_count=1)
		{	
			gosub,cancelExtract_col_HK
			settimer,removetooltip,-1000	
			; open sel in csvqf viewer
			selText:=all
			temp_CSVfile=%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\~temp.csv
			filedelete,%temp_CSVfile%
			fileappend,%selText%,%temp_CSVfile%
			run,%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\CSVQF.ahk "%temp_CSVfile%" "`,"
			
		}
		else if (Extract_col_HK_count=2)
		{	
			gosub,cancelExtract_col_HK
			settimer,removetooltip,-1000	
			; open sel in csvqf viewer
			selText:=all
			temp_CSVfile=%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\~temp.csv
			filedelete,%temp_CSVfile%
			fileappend,%selText%,%temp_CSVfile%
			run,C:\users\%A_UserName%\Downloads\CSVed\CSVed.exe "%temp_CSVfile%" "`,"
		}
		else
		{
			gosub,cancelExtract_col_HK
			text:=truncated_text(output,420)
			tooltip,%msg%`n%text%`ncopied
			settimer,removetooltip,-600
			clipboard:=output
		}
	}
return

cancelExtract_col_HK:	 ; cancel without action

	setTimer,Extract_col_HK,off
	Extract_col_HK:=0
	tooltip,cancel
	settimer,removetooltip,-300
	hotkey,^q,off
	hotkey,^+w,off
	hotkey,<^+t,off

return

$<^e::	; split

if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
	if !( Smart_Trim_HK )	;	if hotkey is currently not in cycle mode 
	{
		all:=clipboard
		Smart_Trim_HK_count:=0
		Smart_Trim_HK_2_count:=0
		tooltip,triggered
		sleep,200
	}
	if (Smart_Trim_HK_count=0)
	{
		msg=blank lines
		newline:=0
		Loop, Parse, all, `n,`r
			newline++
		if (newline<2)
		{
			ifinstring,all,`,
			{
				item_delimiter=`,
				delimiter=comma
			}
			else 	;	ifinstring ,all,%A_Space% 
			{
				item_delimiter=`%%A_Space%`%
				delimiter=space
			}
		}
		else
		{
			item_delimiter=`n
			ignore_delimiter=`r
			delimiter=line			
		}
	}
	else if (Smart_Trim_HK_count=1)
	{
		msg=next
		item_delimiter=`%%A_Space%`%
		delimiter=space
	}			
	else if (Smart_Trim_HK_count = 2)
	{
		msg=next
		item_delimiter=`,
		delimiter=comma
		
		; reg=[^()]*+(\((?:[^()]++|(?1))*\))[^()]*+
		; replace=$1
		; all:=regexreplace(all,reg,replace)
	}		
	if ( Smart_Trim_HK_count = 3 )	;	to check for 2 (it was incremented once)
	{
		Smart_Trim_HK_count:=0
		msg=cancel
		item_delimiter=
		delimiter=
		settimer,removetooltip,-700
		tooltip,%Smart_Trim_HK_count% %msg%
		settimer,cancelSmart_Trim_HK,-680				
	}
	else
	{
		Smart_Trim_HK_count++
		loop,parse,all,%item_delimiter%,%ignore_delimiter%
		{
			M_%A_Index%:=a_loopfield
			maxEntry:=a_index
		}
		output=
		loop %maxEntry% {
		output .= M_%A_Index% . "`n"
		}		
		Sleep 0
		text:=truncated_text(output,520)
		tooltip,%Smart_Trim_HK_count% %msg% (%delimiter%)`n^w:: trim on one side`n^r::  both side trim`n`n%text%
		; settimer,removetooltip,-4500	
		setTimer,Smart_Trim_HK,100	
		settimer,cancelSmart_Trim_HK,off		; allow to cycle from first action again	
		Smart_Trim_HK:=1
		hotkey,^q,on
		hotkey,^w,on
		hotkey,^w,,p0
		hotkey,^r,on
		hotkey,^r,,p0
		hotkey,^t,on
	}
Return
	
	
$^w::	; na

if (Smart_Trim_HK)
{

	stringleft,left_c1,M_1,1
	stringright,right_c1,M_1,1
	ifnotinstring,all_chars,%right_c1%
		ifnotinstring,all_chars,%left_c1%
		{	
			tooltip,NO trimming chars found on sides of  %M_1%`n`n^w:: trim on one side`n^r::  both side trim`n`n%output%

			; settimer,removetooltip,-4500
			return
		}
		loop %pair1_0%
		{
			if (left_c1=pair1_%a_index%)
				left_c1_pair:=pair2_%a_index%
			if (right_c1=pair2_%a_index%)
				right_c1_pair:=pair1_%a_index%
		}

		tmpleft_c1:= RegExReplace(left_c1,"[\\\.\*?+[{|()^$]", "\$0")
		tmpleft_c1_pair:= RegExReplace(left_c1_pair,"[\\\.\*?+[{|()^$]", "\$0")
		tmpright_c1:= RegExReplace(right_c1,"[\\\.\*?+[{|()^$]", "\$0")
		tmpright_c1_pair:= RegExReplace(right_c1_pair,"[\\\.\*?+[{|()^$]", "\$0")

			reg1=i)(.+)(%tmpright_c1_pair%|%tmpright_c1%)(.+)(%tmpright_c1%)
			reg2=i)(%tmpleft_c1%)(.+)(%tmpleft_c1_pair%|%tmpleft_c1%)(.+)
		; msgbox,%right_c1_pair% %left_c1_pair%
		if ( (regexmatch(M_1,reg1))  && (right_c1_pair<>"" ) )
		{
			output=
			trimmed=
			trimmed:=regexreplace(M_1,reg1,"$1")
			loop %maxEntry% {

				M_%A_Index%:=regexreplace(M_%A_Index%,reg1,"$2$3$4")
				output .= M_%A_Index% . "`n"
			}
			Sleep 0
			tooltip,trimmed  %trimmed%  from left`n^w:: trim on one side`n^r::  both side trim`n`n%output%
			; settimer,removetooltip,-4500
		}
		else if ( (regexmatch(M_1,reg2))  && (left_c1_pair!="" ) )
		{
			output=
			trimmed=
			trimmed:=regexreplace(M_1,reg2,"$4")
			loop %maxEntry% {

				M_%A_Index%:=regexreplace(M_%A_Index%,reg2,"$1$2$3")
				output .= M_%A_Index% . "`n"
			}
			stringtrimright ,output,output,1
			Sleep 0
			tooltip,trimmed  %trimmed%  from right`n^w:: trim on one side`n^r::  both side trim`n`n%output%
			; settimer,removetooltip,-4500
		}
		else
		{	
			tooltip,NO trimming possible from  any sides of %M_1%`n`n^w:: trim on one side`n^r::  both side trim`n%output%
			settimer,removetooltip,-4500
		}
}
Return

$^r::	; na

	setTimer,Smart_Trim_HK,100
	; Smart_Trim_HK:=1	;	 if not checking clipstepkeys2 ( direct trigger)
	if (Smart_Trim_HK)
	{
		stringleft,left_c1,M_1,1
		stringright,right_c1,M_1,1
		if (regexmatch(left_c1,"\W"))
		{
			trim:=0
			if (left_c1=right_c1)
			{
				trim:=1
			}
			else 
			{
				loop %pair1_0%
				{
						
					if (left_c1=pair1_%a_index% && right_c1=pair2_%a_index%)
						{
							trim:=1
							break
						}
				}
			}
			if (trim)
			{
				output=
				loop %maxEntry% {
					stringtrimleft,M_%A_Index%,M_%A_Index%,1
					stringtrimright,M_%A_Index%,M_%A_Index%,1
					output .= M_%A_Index% . "`n"
				}
				stringtrimright ,output,output,1
				Sleep 0
				tooltip,%left_c1%  %right_c1%`n^w:: trim on one side`n^r::  both side trim`n`n%output%
				settimer,removetooltip,-4500
			}
			else
			{	tooltip,no trimming %left_c1% != %right_c1%`n^w:: trim on one side`n^r::  both side trim`n`n%output%
				settimer,removetooltip,-4500
			}
			
		}
		else
		{	
			tooltip,NO trimming %left_c1% != %right_c1%`n`n^w:: trim on one side`n^r::  both side trim`n`n%output%
			settimer,removetooltip,-4500
		}	
	
	}
Return

cancelSmart_Trim_HK:
	setTimer,Smart_Trim_HK,off
	Smart_Trim_HK:=0
	hotkey,^q,off
	hotkey,^w,off
	hotkey,^r,off

Return

Smart_Trim_HK:

	GetKeyState,state,CTRL
	If state=u
	{
		gosub,cancelSmart_Trim_HK
		settimer,removetooltip,-300
		tooltip,copied
		clipboard:=output
	}
return

>^\::	;	text generator
	settimer,cancelText_Generator_HK,off	
	if !(Text_Generator_HK)	;	if hotkey is currently not in cycle mode 
	{
		Text_Generator_HK_count:=0		
	}
	
	if (Text_Generator_HK_count=0)
	{	; open sel in csvqf viewer

		msg=1 2 3
		settimer,removetooltip,-1600
		tooltip,%Text_Generator_HK_count% %msg%
		settimer,cancelText_Generator_HK,-1500					
	}
	else if ( Text_Generator_HK_count=1 )	
	{

		msg=A B C 
		settimer,removetooltip,-1600
		tooltip,%Text_Generator_HK_count% %msg%
		settimer,cancelText_Generator_HK,-1500				
	}
	else if ( Text_Generator_HK_count=2 )	
	{

		msg=a b c
		settimer,removetooltip,-1600
		tooltip,%Text_Generator_HK_count% %msg%
		settimer,cancelText_Generator_HK,-1500				
	}
	else if ( Text_Generator_HK_count=3 )	
	{

		msg=lorem ipsum
		settimer,removetooltip,-1600
		tooltip,%Text_Generator_HK_count% %msg%
		settimer,cancelText_Generator_HK,-1500			
	}
	else if ( Text_Generator_HK_count=4 )	
	{

		msg=CANCEL
		settimer,removetooltip,-1600
		tooltip,%Text_Generator_HK_count% %msg%
		settimer,cancelText_Generator_HK,-1500
		Text_Generator_HK_count:=-1		
	}

	Text_Generator_HK_count++
	Text_Generator_HK:=1
	hotkey,^q,on
	setTimer,Text_Generator_HK,70
	sleep,10
return

Text_Generator_HK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (Text_Generator_HK_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%Text_Generator_HK_count% cancelled
			
		}
		else if (Text_Generator_HK_count=1)
		{
		
				inputbox,tmp,text generator,enter source to destination,,,,,,,,25
				list = 
				loop,%tmp%
				{
					list.= A_index . " "
				}
				clipboard=%list%
			
			
		}
		else if (Text_Generator_HK_count=2)
		{	
			list = A`r`nB`r`nC`r`nD`r`nE`r`nF`r`nG`r`nH`r`nI`r`nJ`r`nK`r`nL`r`nM`r`nN`r`nO`r`nP`r`nQ`r`nR`r`nS`r`nT`r`nU`r`nV`r`nW`r`nX`r`nY`r`nZ
			clipboard=%list%			
			
		}
		else if (Text_Generator_HK_count=3)
		{
			list = a`r`nb`r`nc`r`nd`r`ne`r`nf`r`ng`r`nh`r`ni`r`nj`r`nk`r`nl`r`nm`r`nn`r`no`r`np`r`nq`r`nr`r`ns`r`nt`r`nu`r`nv`r`nw`r`nx`r`ny`r`nz

			clipboard=%list%
			
		}
		else if (Text_Generator_HK_count=4)
		{
		inputbox,tmp2,text generator,enter length,,,,,,,,650
		tmp =Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis euismod, dolor id euismod gravida, justo ligula ullamcorper nibh, in aliquam mauris elit non velit. Sed quis leo ipsum, nec sollicitudin justo. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae Curabitur nec magna tempor turpis aliquet ullamcorper. Duis lacus arcu, sollicitudin sit amet aliquam vitae, malesuada non lorem. Etiam eu nisi ante. Etiam elit nunc, facilisis sed convallis ac, auctor ut mauris. Mauris at urna ligula, ut lobortis urna. Nullam scelerisque dapibus nunc in blandit. Donec lobortis dapibus felis, ut sagittis erat sodales vel.
		
			stringleft,tmp,tmp,%tmp2%
			tooltip,%tmp%
			clipboard:=tmp
			sleep,100
			settimer,removetooltip,-1000
			
		}
		gosub,cancelText_Generator_HK
	}
return

cancelText_Generator_HK:	;	cancel without action
	setTimer,Text_Generator_HK,off
	Text_Generator_HK:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return

<^+f5::	;	time generator
	settimer,cancelTime_Generator_HK,off	

	if !(Time_Generator_HK)	;	if hotkey is currently not in cycle mode 
	{
		Time_Generator_HK_count:=0
		
	}
	
	if (Time_Generator_HK_count=0)
	{
		Clock_Pattern = dd MMM yyyy		
		FormatTime time,,%Clock_Pattern%
		msg=%time%
		settimer,removetooltip,-1600
		tooltip,%Time_Generator_HK_count%`n%msg%
		settimer,cancelTime_Generator_HK,-2500					
	}
	else if ( Time_Generator_HK_count=1 )	
	{
		Clock_Pattern = yyyy MMM dd HH:mm
		FormatTime time,,%Clock_Pattern%
		msg=%time%
		settimer,removetooltip,-1600
		tooltip,%Time_Generator_HK_count%`n%msg%
		settimer,cancelTime_Generator_HK,-2500				
	}
	else if ( Time_Generator_HK_count=2 )	
	{
		Clock_Pattern = dd MMM yyyy HH:mm
		FormatTime time,,%Clock_Pattern%
		msg=%time%
		settimer,removetooltip,-1600
		tooltip,%Time_Generator_HK_count%`n%msg%
		settimer,cancelTime_Generator_HK,-2500				
	}
	else if ( Time_Generator_HK_count=3 )	
	{
		msg=empty slot
		settimer,removetooltip,-1600
		tooltip,%Time_Generator_HK_count%`n%msg%
		settimer,cancelTime_Generator_HK,-2500			
	}
	else if ( Time_Generator_HK_count=4 )	
	{
		msg = CANCEL
		settimer,removetooltip,-1600
		tooltip,%Time_Generator_HK_count%`n%msg%
		settimer,cancelTime_Generator_HK,-2500
		Time_Generator_HK_count:=-1		
	}

	Time_Generator_HK_count++
	Time_Generator_HK:=1
	hotkey,^q,on
	setTimer,Time_Generator_HK,70
	sleep,10
return

Time_Generator_HK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (Time_Generator_HK_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%Time_Generator_HK_count% cancelled
		}
		else if (Time_Generator_HK_count=1 OR Time_Generator_HK_count=2 )
		{
			clipboard := time
			Send ^v			
		}
		else if (Time_Generator_HK_count=2)
		{				

		}		
		else if (Time_Generator_HK_count=4)
		{

		}
		gosub,cancelTime_Generator_HK
	}
return

cancelTime_Generator_HK:	;	cancel without action
	setTimer,Time_Generator_HK,off
	Time_Generator_HK:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
	
return


$^q::	;	na
if  (Smart_Trim_HK) 
{

	Smart_Trim_HK:=0
	setTimer,Smart_Trim_HK,off
	hotkey,^q,off
	hotkey,^w,off
	hotkey,^r,off
	settimer,removetooltip,-200
	tooltip,cancelled
}
else if  (make_Csv_HK) 
{

	make_Csv_HK:=0
	setTimer,make_Csv_HK,off	
	hotkey,^q,off
	hotkey,^t,off
	hotkey,^e,off
	settimer,removetooltip,-200
	tooltip,cancelled
}
else if  (Extract_col_HK) 
{
	setTimer,Extract_col_HK,off
	Extract_col_HK:=0
	hotkey,^q,off
	hotkey,^+w,off
	hotkey,^+r,off
	hotkey,<^+t,off
	settimer,removetooltip,-200
	tooltip,cancelled
}
else
{
	send ^q
}
Return

; ^+j::	; smart splitter
	all:=Get_Selected_Text()
	text:=regexreplace(all,"[:=\+-]","`,")
	text:=regexreplace(text,"([`,])+","`,")
	preview_text:=truncated_text(all,520)
	tooltip,smart splitter`n%preview_text%
	sleep,800
	settimer,removetooltip,-1200
	preview_text:=truncated_text(text,520)
	tooltip,smart splitter`n%preview_text%
	clipboard:=text
return

<^+l::	; smart rotator
	all:=Get_Selected_Text()
	preview_text:=truncated_text(all,520)
	tooltip,rotating sel`n`n%preview_text%
	output=
	output:=regexreplace(all,"im)^([\w_%]*)([\t ]*)([:=\+-,]*)([\t ]*)([\w_%]*)$","$5$4$3$2$1")
	sleep,350
	preview_text:=truncated_text(output,520)
	settimer,removetooltip,-1500
	msg=rotated sel
	tooltip,%msg%`n`n%preview_text%
	gosub,copy_enterToSend
return


<^+j::	; smart splitter
	settimer,cancelSplitter_HK,off	
	if !(Splitter_HK_active)	;	if hotkey is currently not in cycle mode 
	{
		Splitter_HK_count:=0
		all:=Get_Selected_Text()
		
	}
if (Splitter_HK_count=0)
{	

	Splitter_HK_count++
	msg=smart split
	text:=regexreplace(all,"[:=\+\-]","`,")
	text:=regexreplace(text,"([`,])+","`,")	
	preview_text:=truncated_text(text,520)
	settimer,removetooltip,-3600
	tooltip,%Splitter_HK_count% %msg%`n%preview_text%
	settimer,cancelSplitter_HK,-3500	
	Splitter_HK_action = nil
}
else if (Splitter_HK_count=1)
{	

	Splitter_HK_count++
	msg=smart split 2
	text:=regexreplace(all,"[:=\+\-\(\)]","`,")
	text:=regexreplace(text,"([`,])+","`,")		
	preview_text:=truncated_text(text,520)
	settimer,removetooltip,-3600
	tooltip,%Splitter_HK_count% %msg%`n%preview_text%
	settimer,cancelSplitter_HK,-3500	
	Splitter_HK_action = nil	
}
else if (Splitter_HK_count=2)
{	

	Splitter_HK_count++
	msg=smart split 3
	text:=regexreplace(all,"[:=\+\-\(\)]","`,")
	text:=regexreplace(text,"([`,])+","`,")		
	preview_text:=truncated_text(text,520)
	settimer,removetooltip,-3600
	tooltip,%Splitter_HK_count% %msg%`n%preview_text%
	settimer,cancelSplitter_HK,-3500	
	Splitter_HK_action = nil		
	Splitter_HK_action = nil	
}
else
{	

	Splitter_HK_count:=0
	msg=cancel
	settimer,removetooltip,-1600
	tooltip,%Splitter_HK_count% %msg%
	settimer,cancelSplitter_HK,-1500		
}
	
	Splitter_HK_active:=1
	hotkey,^q,on
	setTimer,Splitter_HK,70
	sleep,10



Splitter_HK:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (Splitter_HK_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%Splitter_HK_count% cancelled
			
		}
		else if (Splitter_HK_count=1)
		{
		
			clipboard:=text
			
			
		}
		else if (Splitter_HK_count=2)
		{	

			clipboard:=text
		}
		else if (Splitter_HK_count=3)
		{	

			clipboard:=text
		}
		gosub,cancelSplitter_HK
	}
return

cancelSplitter_HK:	;	cancel without action
	setTimer,Splitter_HK,off
	Splitter_HK_active:=0
	tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off
return

nil:
	return
	
copy_enterToSend:	
	tooltip,%msg%`nENTER to SEND`n%preview_text%`ncopied
	settimer,removetooltip,-3000
	Input, UserInput, T3 L1 C, {enter}{esc}{tab}
	tooltip,
	If InStr(ErrorLevel, "EndKey:enter")
	{	
		clipboard:=output
		send, ^v
	}
	else If InStr(ErrorLevel, "EndKey:esc")
	{	
		settimer,removetooltip,-150
		tooltip,cancelled
		
	}
	else
		clipboard:=output
return