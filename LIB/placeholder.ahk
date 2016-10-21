

Placeholder(wParam, lParam = "`r", msg = "") 
{
	static init := OnMessage(0x111, "Placeholder"), list := []
	if (msg != 0x111) 
	{
	
		if (lParam == "`r")
			return list[wParam].shown
		list[wParam] := { placeholder: lParam, shown: false }
		if (lParam == "")
		return "", list.remove(wParam, "")
		lParam := wParam
		wParam := 0x200 << 16
	}
	
	if (wParam >> 16 == 0x200) && list.HasKey(lParam) && !list[lParam].shown ;EN_KILLFOCUS := 0x200
	{
		GuiControlGet, text, , %lParam%
		if (text == "")
		{
			Gui, Font, Ca0a0a0
			GuiControl, Font, %lParam%
			GuiControl, , %lParam%, % list[lParam].placeholder
			list[lParam].shown := true
		}
	}
	else if (wParam >> 16 == 0x100) && list.HasKey(lParam) && list[lParam].shown ;EN_SETFOCUS := 0x100
	{
		Gui, Font, cBlack
		GuiControl, Font, %lParam%
		GuiControl, , %lParam%
		list[lParam].shown := false
	}
}
