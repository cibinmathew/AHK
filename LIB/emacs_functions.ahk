
send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor(HK)
{
; input is normal keycombo like c-v for paste
	
	If (is_in_an_emacs_window())
	{
		send_key(HK)
		
	}
	else
	{
		HK := translate_emacsCombo_to_Normal_combo_and_send(HK)
	}
	
	; msgbox,%HK%
}



encode_key_combo(HK)
{
	if regexmatch(HK,"^space & .*")
	{
		StringtrimLeft, HK, HK, 8
		HK = Spc-%HK%
	}
	else if regexmatch(HK,"^!.*")
	{
		StringtrimLeft, HK, HK, 1
		HK = A-%HK%
	}
	else if regexmatch(HK,"^\^.*")
	{
		StringtrimLeft, HK, HK, 1
		HK = C-%HK%
	}
	else if regexmatch(HK,"^\+.*")
	{
		StringtrimLeft, HK, HK, 1
		HK = S-%HK%
	}
	
	return HK
}

send_key(HK)
{
	if regexmatch(HK,"^C-.")
	{
		;tooltip,%HK%
		stringtrimleft,key,HK,2
		modifier=^
	}
	else if regexmatch(HK,"^A-.")
	{
		stringtrimleft,key,HK,2
		modifier=!
	}
		
	else if regexmatch(HK,"^S-.")
	{
		stringtrimleft,key,HK,2
		modifier=+
	}
	else
	{
		key := HK
		modifier=
	}
	
	send,%modifier%%key%
	;msgbox,%modifier%%key%
	return
}
 

translate_emacsCombo_to_Normal_combo_and_send(HK)
{
	emacs_mapping_C_a={Home}
	emacs_mapping_C_b={Left}
	emacs_mapping_C_c=C-c
	emacs_mapping_C_d=key_combo_C_d
	emacs_mapping_C_e={End}
	emacs_mapping_C_f={Right}
	emacs_mapping_C_g=key_combo_C_g
	emacs_mapping_C_h=C-h
	emacs_mapping_C_i=C-i
	emacs_mapping_C_j=C-j
	emacs_mapping_C_k=C-k
	emacs_mapping_C_l=C-l
	emacs_mapping_C_m=C-m
	emacs_mapping_C_n={Down}
	emacs_mapping_C_o=C-o
	emacs_mapping_C_p={Up}
	emacs_mapping_C_q=C-q
	emacs_mapping_C_r=C-r
	emacs_mapping_C_s=C-f
	emacs_mapping_C_t=C-t
	emacs_mapping_C_u=C-u
	emacs_mapping_C_v={PgDn}
	emacs_mapping_C_w=C-x
	emacs_mapping_C_x=key_combo_C_x
	emacs_mapping_C_y=C-v
	emacs_mapping_C_z=C-z
	emacs_mapping_A_b=key_combo_A_b
	emacs_mapping_A_d=key_combo_A_d
	emacs_mapping_A_f=key_combo_A_f
	emacs_mapping_A_w=C-c
	emacs_mapping_A_v={PgUp}
	
	key_combos_map_to_function=C-x,C-g,C-d,A-f,A-d,A-b
	if HK in %key_combos_map_to_function%
		maps_to_function := 1
	else
		maps_to_function := 0

	StringReplace, HK, HK,-,_, All
	; msgbox,%HK% %maps_to_function% emacs_mapping_%HK%

	
	
	if (maps_to_function)
	{
		gosub, key_combo_%HK%
	}
	else
	{
		HK:= emacs_mapping_%HK%
		send_key(HK)
	}
	return HK

}

is_in_an_emacs_window()
{
	If WinActive("ahk_exe eclipse.exe") Or WinActive("ahk_exe emacs.exe")  Or WinActive("ahk_exe sublime_text.exe") ; Or WinActive("ahk_exe firefox.exe")
		return true
	else
		return false
}

trigger_if_triggered_by_emacs_script_else_proceed(key_to_check)
{
	if !(GetKeyState(key_to_check,"P"))
	{
		stringreplace,HK, a_thishotkey,$
		stringreplace,HK, HK,>,,all
		stringreplace,HK, HK,<,,all
		send, %HK%
		return 1
	}
	else
		return 0
}