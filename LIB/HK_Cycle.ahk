
HK_cycle_register(HK,HK_cycle_name,tot_steps,idle_stop_after,release_checking_key,Cancel_key,config)
{
	global
	HK_cycle_list .= HK_cycle_name . "," ; global variable with all HK cycle names
	HK_cycle_id := HK_cycle_name 
	%HK_cycle_id%_config := config
	%HK_cycle_id% := 0
	%HK_cycle_id%_tot_steps := tot_steps
	%HK_cycle_id%_idle_stop_after := idle_stop_after
	%HK_cycle_id%_release_checking_key := release_checking_key
	%HK_cycle_id%_abort_Cancel_key := Cancel_key
	func_ref_abort =
	%HK_cycle_id%_func_ref_each_Cycle := Func("HK_cycle_each_Cycle").bind(HK_cycle_id)
	func_ref_each_Cycle := %HK_cycle_id%_func_ref_each_Cycle
	Hotkey,%HK%,%func_ref_each_Cycle%
	Hotkey,%HK%,on
	%HK_cycle_id%_func_ref_abort2 := Func( "HK_cycle_abort").bind(HK_cycle_id)
		
	%HK_cycle_id%_func_ref_release_check_timer := Func("HK_cycle_release_check_timer").bind(HK_cycle_id,%HK_cycle_id%_release_checking_key)
	%HK_cycle_id%_func_ref_abort_onCancel_key:= Func("HK_cycle_abort_onCancel_key").bind(HK_cycle_id)
}

HK_cycle_each_Cycle(HK_cycle_id_local)
{
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable
; msgbox,%a%
a :=%HK_cycle_id% ;_config
	a :=%HK_cycle_id%_config
	; msgbox,HK_cycle_id=%HK_cycle_id%`n%a%
	
	
; <#=:: ; copy_paste_base64_HK
	; HK_cycle_id = copy_paste_base64_HK
	if (!%HK_cycle_id%)
	{
		HK_cycle_id_count = %HK_cycle_id%_count
		release_checking_key := %HK_cycle_id%_release_checking_key
		idle_stop_after := %HK_cycle_id%_idle_stop_after
		HK_cycle_tot_steps := %HK_cycle_id%_tot_steps
	; msgbox,%HK_cycle_id%
		HK_cycle_initialise_if_not_initialised(HK_cycle_id)
	}
	HK_cycle_next( HK_cycle_id,HK_cycle_tot_steps, HK_msgs, HK_actions_onRelease, extra_params, input_param, HK_cycle_id_action, idle_stop_after, HK_actions_before_msg)
	; keywait,i
}

HK_cycle_initialise_if_not_initialised(HK_cycle_id_local)
{
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable

	; msgbox,%HK_cycle_id%
	variable_list=HK_msgs,HK_funcs_before_msg,HK_actions_before_msg,HK_cycle_id_release_Pre_func,HK_cycle_id_release_Pre_action,HK_funcs_onRelease,HK_actions_onRelease,HK_cycle_id_release_Post_func,HK_cycle_id_release_Post_action,input_param
	stringsplit, variable_list,variable_list,`, 
	config :=%HK_cycle_id%_config
	loop,parse,config,`n,`r
	{
		var := variable_list%a_index%
		%var% := a_loopfield
		}	
	; loop,parse,parameter_containers,CSV
	loop,parse,variable_list,CSV
		; stringsplit,%a_loopfield%,%a_loopfield%,CSV
	{
		root := a_loopfield
		a:= %a_loopfield%
		; msgbox,%root%= %a%
		loop,parse,%a_loopfield%,CSV
			%root%%a_index% := a_loopfield
	}
	; a:=HK_funcs_onRelease1
	; a := input_param2
	; msgbox,%a%
	%HK_cycle_id_count% :=0	
	func_ref_release_check_timer:= %HK_cycle_id%_func_ref_release_check_timer

	SetTimer, %func_ref_release_check_timer%, 100
	; tooltip,func_ref_release_check_timer running,100,,3
	local hk = %HK_cycle_id%_abort_Cancel_key

	func_ref_abort_onCancel_key:= %HK_cycle_id%_func_ref_abort_onCancel_key
; name := func_ref_abort_onCancel_key.name
; msgbox,w%name%
	Hotkey,%hk%,%func_ref_abort_onCancel_key%
	Hotkey,%hk%,on
}

HK_cycle_next(HK_cycle_id_local,HK_cycle_tot_steps,HK_msgs,HK_actions_onRelease,extra_params,input_param,ByRef HK_cycle_id_action, idle_stop_after=7000,custom_disp_message_prepare="")
{
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable
	; limitations: No simultaneous HK cycle threads because of Byref
	
	; msgbox, h%HK_cycle_id%
	this_hotkey := a_thishotkey
	if (idle_stop_after)
	{
		; %HK_cycle_id%_func_ref_abort2 := Func( "HK_cycle_abort").bind(HK_cycle_id)
		func_ref_abort2 := %HK_cycle_id%_func_ref_abort2
		SetTimer, %func_ref_abort2%, -%idle_stop_after%
		; tooltip,-abort running,100,,2
	}
	; a := %HK_cycle_id%
	; msgbox,%HK_cycle_id% %a%
	if !(%HK_cycle_id%)
	{
		%HK_cycle_id% := 1
		HK_cycle_id_count := 1
		; hotkey,^q,on
	}
	else
		HK_cycle_id_count++
	if (%HK_cycle_id%)	
	{
		if (HK_cycle_id_count<= HK_cycle_tot_steps)
		{	
			
			if (HK_actions_before_msg%HK_cycle_id_count%="")
				msg := HK_msgs%HK_cycle_id_count%
			else
			{
				goto_label := HK_actions_before_msg%HK_cycle_id_count%
				gosub,%goto_label%
				msg := HK_custom_disp_msg
			}
			tooltip_delay:=idle_stop_after
		}	
		else
		{
			HK_cycle_id_count:=0
			msg = cancel
			tooltip_delay:=1000	
		}
		HK_cycle_id_action :=HK_actions_onRelease%HK_cycle_id_count%
		tooltip,%HK_cycle_id_count%/%HK_cycle_tot_steps% %msg%
		settimer,removetooltip,-%tooltip_delay%
	}
return
}

HK_cycle_abort(HK_cycle_id_local) ; ByRef HK_cycle_id)
{
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable
; msgbox,d%HK_cycle_id%
	; %HK_cycle_id%_func_ref_release_check_timer := Func("HK_cycle_release_check_timer").bind(HK_cycle_id,%HK_cycle_id%_release_checking_key)
	
	func_ref_release_check_timer := %HK_cycle_id%_func_ref_release_check_timer	
	; name := func_ref_release_check_timer.name
	; msgbox,n%name%
	setTimer,%func_ref_release_check_timer%,off
	; setTimer,%func_ref_release_check_timer%,delete

	
	; %HK_cycle_id%_func_ref_abort := Func( "HK_cycle_abort" ).bind(HK_cycle_id)
	; func_ref_abort := %HK_cycle_id%_func_ref_abort
	; name := func_ref_abort.name

	; setTimer,%func_ref_abort%,off
	; setTimer,%func_ref_abort%,delete
	
	; %HK_cycle_id%_func_ref_abort2 := Func( "HK_cycle_abort" ).bind(HK_cycle_id)
	func_ref_abort2 := %HK_cycle_id%_func_ref_abort2
	name := func_ref_abort.name

	setTimer,%func_ref_abort2%,off
	; setTimer,%func_ref_abort2%,delete
	; tooltip,func_ref_abort2 turned off,,250,6
	%HK_cycle_id% := 0
	; hotkey,^q,off
	; tooltip,cancelled,400,,4
	; a:= %HK_cycle_id%
	; tooltip,aborted HK_cycle_id:%HK_cycle_id%=%a%,,350,5
	; tooltip,cancelleddd %idle_stop_after%s %HK_cycle_id% ,800,,9
	tooltip,%HK_cycle_id_count%/%HK_cycle_tot_steps% %msg% cancelled
	settimer,removetooltip,300
	; tooltip,,,,2
	; tooltip,,,,3
	; tooltip,,,,4
}


HK_cycle_release_check_timer(HK_cycle_id_local,release_checking_key)
{
global

; msgbox,e%release_checking_key%
	; global HK_cycle_id_action, HK_cycle_id, HK_cycle_id_count, func_ref_abort
	HK_cycle_id := HK_cycle_id_local	; making it a global variable
	GetKeyState,state,%release_checking_key%
	; tooltip,%state%state,,400,4
	If state=u
	{
	; msgbox,rel %HK_cycle_id%
		HK_cycle_abort(HK_cycle_id) 
		HK_cycle_release_execute(HK_cycle_id)
	}
	a := %HK_cycle_id%
	; tooltip,timer %HK_cycle_id% %a%,,500,3
}

HK_cycle_release_execute(HK_cycle_id_local)
{
	
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable
; msgbox,%HK_cycle_id_count%

	if (HK_cycle_id_count)
	{
		
		count := HK_cycle_id_count
		; msgbox, count=%count%
		function_string :=HK_cycle_id_release_Pre_func%count%
		if (function_string!="")
			call_func_from_string(function_string)
		local label_name := HK_cycle_id_release_Pre_action%count%
		if ( label_name!="" )
			gosub, %label_name%
			
			
		function_string :=HK_funcs_onRelease%count%
		if (function_string!="")
			call_func_from_string(function_string)
		local label_name := HK_actions_onRelease%count%
		if ( label_name!="" )
			gosub, %label_name%			
			
		function_string :=HK_cycle_id_release_Post_func%count%
		if (function_string!="")
			call_func_from_string(function_string)
		local label_name := HK_cycle_id_release_Post_action%count%
		if ( label_name!="" )
			gosub, %label_name%
			
	}
	%HK_cycle_id_count% := 0
}

HK_cycle_abort_onCancel_key(HK_cycle_id_local)
{
global
HK_cycle_id := HK_cycle_id_local	; making it a global variable
; msgbox,z%HK_cycle_id%

	local cancelled := 0
	; loop,parse,HK_cycle_list,`,
	{
		; if  (%a_loopfield%) 
		if  (%HK_cycle_id%) 
		{
			HK_cycle_abort(HK_cycle_id) 
			local hk := %HK_cycle_id%_abort_Cancel_key
			hotkey,%hk%,off
			cancelled :=1
		}
	}
	if (!cancelled)
	{
		send {%a_thishotkey%}
	}
}
