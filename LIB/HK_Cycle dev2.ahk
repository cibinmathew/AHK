HKC_Group_register(HK, HKC_group_name, idle_stop_after, release_checking_key="", Cancel_key="" )
{
	; cancel key will be turned off globally, so to use 'esc' in other places enable it manually
	global
	StringReplace, HKC_name, HK, ^, Ctrl_, All
	StringReplace, HKC_name, HKC_name, #, Win_, All
	StringReplace, HKC_name, HKC_name, !, Alt_, All
	StringReplace, HKC_name, HKC_name, +,Shift_, All
	StringReplace, HKC_name, HKC_name, <, Langular_, All
	StringReplace, HKC_name, HKC_name, >, Rangular_, All
	StringReplace, HKC_name, HKC_name,., dot_, All
	StringReplace, HKC_name, HKC_name,/, f_slash, All
	; MsgBox, %HKC_name%
	HKC_keyId := HKC_name 
	HKC_groupId := HKC_group_name 

	last_HKC_keyId=
	%HKC_groupId%_trigger_HKey := HK
	%HKC_groupId%_idle_stop_after := idle_stop_after
	%HKC_groupId%_release_checking_key := release_checking_key
	%HKC_groupId%_abort_Cancel_key := Cancel_key
	func_ref_abort =

	%HKC_groupId%_%HKC_keyId%_func_ref_each_Cycle := Func("HKC_each_Cycle").bind(HKC_groupId, HKC_keyId)
	func_ref_each_Cycle := %HKC_groupId%_%HKC_keyId%_func_ref_each_Cycle
	Hotkey,%HK%,%func_ref_each_Cycle%
	Hotkey,%HK%,on

	%HKC_groupId%_func_ref_abort2 := Func( "HKC_abort").bind(HKC_groupId)

	%HKC_groupId%_func_ref_release_check_timer := Func("HKC_release_check_timer").bind(HKC_groupId,%HKC_groupId%_release_checking_key)
	if %HKC_groupId%_func_ref_abort_onCancel_key
	%HKC_groupId%_func_ref_abort_onCancel_key:= Func("HKC_abort_onCancel_key").bind(HKC_groupId)
}

HKC_Key_register(HK,HKC_group_name,config,Hkey_type,sticky_count=0,show_all_options=0)
{
	;sticky_count = 1 starts the counter from the last executed count
	global
	StringReplace, HKC_name, HK, ^, Ctrl_, All
	StringReplace, HKC_name, HKC_name, #, Win_, All
	StringReplace, HKC_name, HKC_name, !, Alt_, All
	StringReplace, HKC_name, HKC_name, +,Shift_, All
	StringReplace, HKC_name, HKC_name, <, Langular_, All
	StringReplace, HKC_name, HKC_name, >, Rangular_, All
	StringReplace, HKC_name, HKC_name,., dot_, All
	StringReplace, HKC_name, HKC_name,/, f_slash, All
	HKC_keyId := HKC_name 
	HKC_groupId := HKC_group_name 
	; HKC_list .= HKC_name . "," ; global variable with all HK cycle names
	%HKC_groupId%_all_HKC_keyIds .= HKC_name . "," 
	%HKC_keyId%_config := config
	%HKC_keyId% := 0
	%HKC_keyId%_count := 1
	%HKC_groupId%_%HKC_keyId%_Hkey := HK
	%HKC_groupId%_%HKC_keyId%_Hkey_type := Hkey_type
	%HKC_groupId%_%HKC_keyId%_sticky_count := sticky_count
	%HKC_groupId%_%HKC_keyId%_show_all_options := show_all_options
	
	; if (%HKC_groupId%_%HKC_keyId%_Hkey_type ="same_category")
	; {

	; }
	; else 
	if (%HKC_groupId%_%HKC_keyId%_Hkey != %HKC_groupId%_trigger_HKey)
	{
		; Hotkey,%HK%,off
		%HKC_groupId%_aux_keys .= HK ","
		%HKC_groupId%_aux_HKC_keyId .= HKC_keyId ","
	}
	; a:=%HKC_groupId%_%HKC_keyId%_Hkey_type
	; msgbox,%HKC_groupId%_%HKC_keyId%_Hkey_type %a%
	if (%HKC_groupId%_%HKC_keyId%_Hkey_type != "category_changer")
		HKC_initialise_configuration(HKC_groupId, HKC_keyId)
}

HKC_initialise_configuration(HKC_groupId_local,HKC_keyId_local)
{
global


	HKC_keyId := HKC_keyId_local	
	HKC_groupId := HKC_groupId_local	


	variable_list=HKC_msgs,HKC_actions_before_msg,HKC_funcs_onRelease,HKC_actions_onRelease,HKC_params1,HKC_params2
	HKC_func_before_first_trigger_%HKC_groupId%:=HKC_func_before_first_trigger
	HKC_func_after_off_%HKC_groupId%:=HKC_func_after_off
	HKC_action_after_off_%HKC_groupId%:=HKC_action_after_off
	HKC_action_after_if_used_cancel_key_%HKC_groupId%:=HKC_action_after_if_used_cancel_key
	HKC_func_after_if_used_cancel_key_%HKC_groupId%:=HKC_func_after_if_used_cancel_key

	if (%HKC_groupId%_%HKC_keyId%_Hkey_type = "same_category")
	{
		list = category
		loop,parse,variable_list,CSV
			; stringsplit,%a_loopfield%,%a_loopfield%,CSV
		{
			m:=1
			root := a_loopfield
			loop, parse, %root%, `n, `r
			{
				n:=1
				HKC_category := a_index
				if (root ="HKC_msgs")
					%HKC_groupId%_max_categories := a_index
				loop,parse,a_loopfield,CSV
				{
				; msgbox, d%a_loopfield%
					if (root ="HKC_msgs")
						%HKC_groupId%_max_in_category_%m% := n
					; %HKC_groupId%_max_in_category_%n% := m

					%root%_%HKC_groupId%_%list%_%m%_%n% := a_loopfield
					; a:= %root%_%HKC_groupId%_%list%_%m%_%n%
					; msgbox,%root%_%HKC_groupId%_%list%_%m%_%n% %a%
					; HKC_msgs_%HKC_groupId%_%list%_%n%_%m% := a_loopfield
					; MsgBox, %a_loopfield%
					; HKC_actions_before_msg_%HKC_groupId%_%HKC_keyId%_%HKC_category%_%a_index%=
					n++
				}
				m++
			}
		}
	}
	else
	{
		; variable_list=HKC_msgs
		stringsplit, variable_list,variable_list,`, 
		
		loop,parse,	%HKC_keyId%_config,`n,`r
		{
			var := variable_list%a_index%
			; msgbox,zz%HKC_keyId%_config`n%var%
			%var% := a_loopfield
		}	
		; loop,parse,parameter_containers,CSV
		HKC_category:=1
		loop,parse,variable_list,CSV
			; stringsplit,%a_loopfield%,%a_loopfield%,CSV
		{
			root := a_loopfield
			; a:= %a_loopfield%
			; msgbox, %root%= %a%
			loop,parse,%a_loopfield%,CSV
				{
					; %root%_%HKC_keyId%_%a_index% := a_loopfield
					%root%_%HKC_groupId%_%HKC_keyId%_%HKC_category%_%a_index% := a_loopfield
					if (root ="HKC_msgs")
						%HKC_groupId%_%HKC_keyId%_max:= A_Index

			}
				; MsgBox, %HKC_groupId%_%HKC_keyId%_max

		}
		; a :=HKC_funcs_onRelease1
		; a := input_param2
		; msgbox,%a%
	}
}

HKC_each_Cycle(HKC_groupId_local,HKC_keyId_local)
{
	global
	HKC_keyId := HKC_keyId_local	
	HKC_groupId := HKC_groupId_local	
	; a =%HKC_keyId% ;_config
	; msgbox,%a%
	; a :=%HKC_keyId%_config
	; msgbox,HKC_keyId=%HKC_keyId%`n%a%


	; <#=:: ; copy_paste_base64_HK
	; HKC_keyId = copy_paste_base64_HK
	if (!%HKC_groupId%)
	{
		HKC_keyId_count := %HKC_keyId%_count
		
		idle_stop_after := %HKC_groupId%_idle_stop_after
		release_checking_key := %HKC_groupId%_release_checking_key
		; a := %HKC_groupId%_all_HKC_keyIds
		; msgbox,a%idle_stop_after%
		HKC_keyId_backup := HKC_keyId
		loop,parse,%HKC_groupId%_all_HKC_keyIds,`,
		{
			if (a_loopfield="")
				continue
			HKC_initialise_if_not_initialised(HKC_groupId,a_loopfield)
		}
		; msgbox,HKC_func_before_first_trigger_%HKC_groupId%
		if (HKC_func_before_first_trigger_%HKC_groupId%)
		{
			call_func_from_string(HKC_func_before_first_trigger_%HKC_groupId%)
		}
		; %HKC_groupId%_aux_HKC_keyId
		loop,parse,%HKC_groupId%_aux_HKC_keyId,`,
			{
; %HKC_groupId%_%HKC_keyId%_Hkey
	local hk := %HKC_groupId%_%a_loopfield%_Hkey
				; MsgBox,%a_loopfield%
				if (a_loopfield ="")
					continue
				%HKC_groupId%_%a_loopfield%_func_ref_each_Cycle := Func("HKC_each_Cycle").bind(HKC_groupId, a_loopfield)
				func_ref_each_Cycle := %HKC_groupId%_%a_loopfield%_func_ref_each_Cycle	
				Hotkey,%hk%,%func_ref_each_Cycle%
				Hotkey,%hk%,on,p0
			}
		HKC_keyId := HKC_keyId_backup 
	}
	func_ref_release_check_timer:= %HKC_groupId%_func_ref_release_check_timer
if (%HKC_groupId%_release_checking_key ="")
{
	 ; msgbox,aa
	idle_stop_after := %HKC_groupId%_idle_stop_after
	settimer, execute_after_delay,%idle_stop_after%
}
else
{
	; msgbox,%a_thishotkey%
	SetTimer, %func_ref_release_check_timer%, 100
}
	; tooltip,func_ref_release_check_timer running,100,,3
	local hk = %HKC_groupId%_abort_Cancel_key

	func_ref_abort_onCancel_key:= %HKC_groupId%_func_ref_abort_onCancel_key
; name := func_ref_abort_onCancel_key.name
; msgbox,w%name%
if %HKC_groupId%_func_ref_abort_onCancel_key
{
	Hotkey,%hk%,%func_ref_abort_onCancel_key%
	Hotkey,%hk%,on
}
	HKC_tot_steps := %HKC_keyId%_tot_steps
	HKC_next( HKC_groupId,HKC_keyId,HKC_tot_steps, HKC_actions_onRelease, extra_params, input_param, HKC_keyId_action, idle_stop_after, HKC_actions_before_msg)
	; keywait,i
}


HKC_initialise_if_not_initialised(HKC_groupId_local,HKC_keyId_local)
{
global
HKC_keyId := HKC_keyId_local	
HKC_groupId := HKC_groupId_local	


	HKC_category:= 1
	; %HKC_keyId_count% :=1
	; msgbox,%HKC_keyId_count% 
}

HKC_next(HKC_groupId_local,HKC_keyId_local,HKC_tot_steps,HKC_actions_onRelease,extra_params,input_param,ByRef HKC_keyId_action, idle_stop_after=7000,custom_disp_message_prepare="")
{
	global
	HKC_keyId := HKC_keyId_local	; making it a global variable
	HKC_groupId := HKC_groupId_local	; making it a global variable
	; limitations: No simultaneous HK cycle threads because of Byref
	; tooltip,%HKC_keyId% last=%last_HKC_keyId%, ,333,7
	this_hotkey := a_thishotkey
	if (%HKC_groupId%_release_checking_key ="")
	{
		 ; msgbox,aa
		idle_stop_after := %HKC_groupId%_idle_stop_after
		settimer, execute_after_delay,%idle_stop_after%
	}
	
	if (idle_stop_after)
	{
		; %HKC_keyId%_func_ref_abort2 := Func( "HKC_abort").bind(HKC_keyId)
		func_ref_abort2 := %HKC_groupId%_func_ref_abort2
		SetTimer, %func_ref_abort2%, -%idle_stop_after%
		; tooltip,-abort running,100,,2
	}
	if !(%HKC_groupId%)
	{
		%HKC_groupId% := 1
		if !(%HKC_groupId%_%HKC_keyId%_sticky_count)
			HKC_keyId_count := 1
		HKC_category := 1
		
	}
	else if (%HKC_groupId%_%HKC_keyId%_Hkey_type = "same_category" )
	{	
		HKC_category++
		HKC_category:= reset_counter_if_out_of_bound(HKC_category,1,%HKC_groupId%_max_categories)
		if !(%HKC_groupId%_%HKC_keyId%_sticky_count)
			HKC_keyId_count:=1
	}
	else if ((%HKC_groupId%_%HKC_keyId%_Hkey_type = "category_changer") AND  (%HKC_groupId%_%last_HKC_keyId%_Hkey_type= "same_category" ))
	{	
		; no reset
		; msgbox
		HKC_keyId_count++
	}
	else if (last_HKC_keyId != HKC_keyId)
		HKC_keyId_count := 1
	else
	{
		HKC_keyId_count++
	}
	; a:=%HKC_groupId%_%HKC_keyId%_Hkey_type
	; sleep,500
	if (%HKC_groupId%_%HKC_keyId%_Hkey_type ="same_category" OR %HKC_groupId%_%HKC_keyId%_Hkey_type = "category_changer")
	{
	; tooltip,%HKC_groupId%_%HKC_keyId%_Hkey_type=%a%,500,,4
		HKC_tot_steps := %HKC_groupId%_max_in_category_%HKC_category%
	}
	else if (%HKC_groupId%_%HKC_keyId%_Hkey_type ="aux")
	{
		HKC_tot_steps := %HKC_groupId%_%HKC_keyId%_max
	}
	if (%HKC_groupId%)	
	{
		if (HKC_keyId_count<= HKC_tot_steps)
		{	
	
			msg := get_entry("HKC_msgs",HKC_groupId,HKC_keyId,HKC_category,HKC_keyId_count)
			if (%HKC_groupId%_%HKC_keyId%_show_all_options)
			{
				;msg =
				loop,%HKC_tot_steps%
					msg .= "`n" . a_index . "/" . HKC_tot_steps . get_entry("HKC_msgs",HKC_groupId,HKC_keyId,HKC_category,A_Index)
			}

			if (get_entry("HKC_actions_before_msg",HKC_groupId,HKC_keyId,HKC_category,HKC_keyId_count)!="")
			{
				execute_if_action_exists(HKC_groupId, HKC_keyId,"HKC_actions_before_msg")
				msg .= "`n`n" . HKC_custom_disp_msg
			}
			; else

			tooltip_delay:=idle_stop_after
		}	
		else
		{
			HKC_keyId_count:=0
			msg = cancel
			tooltip_delay:=1000	
		}
		HKC_keyId_action :=HKC_actions_onRelease%HKC_keyId_count%
		tooltip,%HKC_keyId_count%/%HKC_tot_steps% %msg%
		settimer,removetooltip,-%tooltip_delay%
	}
last_HKC_keyId := HKC_keyId
return
}

execute_after_delay()
{
	global
	; msgbox,execute_after_delay
	HKC_release_execute(HKC_groupId,HKC_keyId)
	setTimer,execute_after_delay,off
}

HKC_abort(HKC_groupId_local) ; ByRef HKC_keyId)
{
global
HKC_groupId := HKC_groupId_local	; making it a global variable
; msgbox,d%HKC_keyId%
	; %HKC_keyId%_func_ref_release_check_timer := Func("HKC_release_check_timer").bind(HKC_keyId,%HKC_keyId%_release_checking_key)
	
	func_ref_release_check_timer := %HKC_groupId%_func_ref_release_check_timer	
	; name := func_ref_release_check_timer.name
	; msgbox,n%name%
	setTimer,%func_ref_release_check_timer%,off
	; setTimer,%func_ref_release_check_timer%,delete

	
	; %HKC_groupId%_func_ref_abort := Func( "HKC_abort" ).bind(HKC_groupId)
	; func_ref_abort := %HKC_groupId%_func_ref_abort
	; name := func_ref_abort.name

	; setTimer,%func_ref_abort%,off
	; setTimer,%func_ref_abort%,delete
	
	; %HKC_groupId%_func_ref_abort2 := Func( "HKC_abort" ).bind(HKC_groupId)
	func_ref_abort2 := %HKC_groupId%_func_ref_abort2
	name := func_ref_abort.name
	loop,parse,%HKC_groupId%_aux_HKC_keyId,`,
	{
		if (a_loopfield ="")
			continue
		; %HKC_groupId%_%HKC_keyId%_func_ref_each_Cycle := Func("HKC_each_Cycle").bind(HKC_groupId, HKC_keyId)
		func_ref_each_Cycle := %HKC_groupId%_%a_loopfield%_func_ref_each_Cycle		
		local hk := %HKC_groupId%_%a_loopfield%_Hkey
		Hotkey,%hk%,%func_ref_each_Cycle%,Off
	}
	setTimer,%func_ref_abort2%,off
	; setTimer,%func_ref_abort2%,delete
	; tooltip,func_ref_abort2 turned off,,250,6
	%HKC_groupId% := 0
	; hotkey,^q,off
	; tooltip,cancelled,400,,4
	; a:= %HKC_keyId%
	; tooltip,aborted HKC_keyId:%HKC_keyId%=%a%,,350,5
	; tooltip,cancelleddd %idle_stop_after%s %HKC_keyId% ,800,,9
	tooltip,%HKC_keyId_count%/%HKC_tot_steps% %msg% cancelled
	settimer,removetooltip,300
	if (%HKC_groupId%_release_checking_key ="" )
	{	
		settimer, execute_after_delay,off
	}
	if %HKC_groupId%_func_ref_abort_onCancel_key
	{
		local hk := %HKC_groupId%_abort_Cancel_key
		hotkey,%hk%,off
	}
	if (HKC_func_after_off_%HKC_groupId%)
			call_func_from_string(HKC_func_after_off_%HKC_groupId%)
		
	if (HKC_action_after_off_%HKC_groupId%)
	{
		label_name := HKC_action_after_off_%HKC_groupId%
		gosub,%label_name% 
		; msgbox,%label_name% 
	}
		
	; msgbox,%hk% hk turned off
		
		
	; tooltip,,,,2
	; tooltip,,,,3
	; tooltip,,,,4
	
}


HKC_release_check_timer(HKC_groupId_local,release_checking_key)
{
global

; msgbox,e%release_checking_key%
	; global HKC_keyId_action, HKC_keyId, HKC_keyId_count, func_ref_abort
	HKC_groupId := HKC_groupId_local	; making it a global variable
	GetKeyState,state,%release_checking_key%
	; tooltip,%state%state,,400,4
	If state=u
	{
	; msgbox,rel %HKC_keyId%
		HKC_abort(HKC_groupId) 
		HKC_release_execute(HKC_groupId,HKC_keyId)
	}
	a := %HKC_groupId%
	; tooltip,timer %HKC_keyId% %a%,,500,3
	%HKC_keyId%_count := HKC_keyId_count ; store value for future trigger
}

HKC_release_execute(HKC_groupId_local,HKC_keyId_local)
{
	
global
HKC_groupId := HKC_groupId_local	; making it a global variable
HKC_keyId := HKC_keyId_local	; making it a global variable
; msgbox,%HKC_keyId%

	if (HKC_keyId_count)
	{
		
		count := HKC_keyId_count
		; msgbox, count=%count%

		/*		function_string :=HKC_keyId_release_Pre_func_%HKC_keyId%_%count%
		if (function_string!="")
			call_func_from_string(function_string)
		local label_name := HKC_keyId_release_Pre_action_%HKC_keyId%_%count%
		if ( label_name!="" )
			gosub, %label_name%
			
			
		function_string :=HKC_funcs_onRelease_%HKC_keyId%_%count%
		if (function_string!="")
			call_func_from_string(function_string)
		local label_name := HKC_actions_onRelease_%HKC_keyId%_%count%
		if ( label_name!="" )
			gosub, %label_name%			
			
		function_string :=HKC_keyId_release_Post_func_%HKC_keyId%_%count%
		if (function_string!="")
			call_func_from_string(function_string)
			*/
		; a:=HKC_funcs_onRelease_%HKC_groupId%_%list%_%HKC_category%_%HKC_keyId_count%
		; msgbox, %a%	
		execute_if_func_exists(HKC_groupId, HKC_keyId,"HKC_funcs_onRelease")
		execute_if_action_exists( HKC_groupId, HKC_keyId,"HKC_actions_onRelease")
	}

}

HKC_abort_onCancel_key(HKC_groupId_local)
{
	global
	HKC_groupId := HKC_groupId_local	; making it a global variable
	; msgbox,z%HKC_keyId%
	local cancelled := 0
	; loop,parse,HKC_list,`,
	{
		; if  (%a_loopfield%) 
		if  (%HKC_groupId%) 
		{
			HKC_abort(HKC_groupId) 
			cancelled :=1
			if (HKC_func_after_if_used_cancel_key_%HKC_groupId%)
				call_func_from_string(HKC_func_after_if_used_cancel_key_%HKC_groupId%)

			if (HKC_action_after_if_used_cancel_key_%HKC_groupId%)
			{
				label_name := HKC_action_after_if_used_cancel_key_%HKC_groupId%
				gosub,%label_name% 
				; msgbox,%label_name% 
			}
	
		}
	}
	if (!cancelled)
	{
		send {%a_thishotkey%}
	}
}


; get_entry("HKC_msgs",HKC_groupId,HKC_keyId,HKC_category=1,HKC_keyId_count)
get_entry(key,HKC_groupId,HKC_keyId,HKC_category,HKC_keyId_count)
{
		; ToolTip, %HKC_groupId%_%HKC_keyId%_Hkey,222,,3
	if ((%HKC_groupId%_%HKC_keyId%_Hkey_type = "same_category") OR  (%HKC_groupId%_%HKC_keyId%_Hkey_type = "category_changer" ) )
	{
		
		list = category
	value := %key%_%HKC_groupId%_%list%_%HKC_category%_%HKC_keyId_count%
	}
	Else
	{
		; a:=%HKC_groupId%_%HKC_keyId%_Hkey_type
	; 	MsgBox, %HKC_groupId%_%HKC_keyId%_Hkey_type %a%
		HKC_category:=1
		value := %key%_%HKC_groupId%_%HKC_keyId%_%HKC_category%_%HKC_keyId_count%
	}
; MsgBox,  %key%_%HKC_groupId%_%HKC_keyId%_%HKC_category%_%HKC_keyId_count%
Return value
}


execute_if_func_exists(HKC_groupId, HKC_keyId,key)
{
	global
	function_string := get_entry(key,HKC_groupId,HKC_keyId,HKC_category,HKC_keyId_count)
	if (function_string !="")
	{
		call_func_from_string(function_string)
		return 1
	}
}
execute_if_action_exists(HKC_groupId, HKC_keyId,key)
{
	global
	local label_name := get_entry(key,HKC_groupId,HKC_keyId,HKC_category,HKC_keyId_count)

	; msgbox, %label_name%
	if ( label_name!="" )
	{
		gosub, %label_name%
		return 1
	}
}