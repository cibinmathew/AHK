SplitPath, A_ScriptDir , , , , , A_Script_Drive
SetWorkingDir %A_ScriptDir%
#include C:\cbn_gits\AHK\LIB\cbn.ahk
#include C:\cbn_gits\AHK\LIB\misc functions.ahk

#include C:\cbn_gits\AHK\LIB\emacs_functions.ahk

; Menu, Tray, Icon, Shell32.dll, 36
SetBatchLines,-1
ifexist,Play.ico
	Menu, Tray, Icon, Play.ico 
else
	menu, Tray, Icon, Shell32.dll,63
#SingleInstance, Force
#InstallKeybdHook
OnMessage(0x5555, "MsgMonitor")
OnMessage(0x5556, "MsgMonitor")



OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA

MC_OwnChange:=0
; Hotkey, <^w, , p1
; Hotkey, <^r, , p1
hotkey,<^s,off
hotkey,<^f,off
hotkey,<#a,off
hotkey,esc,off
add_to_fav_also=0
hotkey,esc,off

HotkeySTEP_history_active:=0
HotkeySTEP_history_count:=0

HotkeySTEP17:=0
HotkeySTEP17_count:=0


HotkeySTEP22:=0
HotkeySTEP22_count:=0

HotkeySTEP29:=0
HotkeySTEP29_count:=0

HotkeySTEP55:=0
HotkeySTEP55_count:=0

Gui 48: +LastFound +AlwaysOnTop -Caption +ToolWindow
gui,48:  add, picture,x0 y0 w400 h300 vimagepreview,

hotkey,^q,off	;	start disabled
; =================================
;;;;;;;;;	CLIPSTEP	;;;;;;;;;;;
; =================================
tmp_fav_collector:=3
tot_clip_containers:=tmp_fav_collector+3
MCF_MAX_Clips:=100 ;total clips allowd
MCF_clips_present:=0 ;	total clips present now
Clips_shown=15	;	shown in menu
MC_MAX_Clips:=100 
MC_Clips_present :=0

change:=1
fav_data_f =fav_data ; save location
HIST_data_f =fav_data ; save location  
MC_MaxLen := 55
contPaste=1

activeclip=1
MCF_activeclip=0
paste=no
paste2=no
delete=no
delete2=no

ClipStep_Keys:=0	;if clipstep tooltips are triggered

Gosub,INDEX

gosub, clipselect_gui
OnExit, ExitSub

gosub,clipboardManager

line:=1
prevHKey=
menu,more,add,set n,nil
menu,more,add,view all,view_all
max=0

MCF_MAX_Clips:=16
 
;	load saved favclips on last exit
loop, %tot_clip_containers%
{
	t_id:=a_index
	Loop %MCF_MAX_Clips%
		{
		FSaveClip%A_Index% := MCF_Clip%t_id%_%A_Index%

		;	load saved favclips on last exit
		FileRead, MCF_Clip%t_id%_%A_Index%, %fav_data_f%\%t_id%_%A_Index%.clip



		}
}
get_maxEntry()


readall:
Loop, %A_ScriptDir%\coll\*.txt
{
	n:=a_index
	Menu, misc%n%, Add, ALL, nil
		Menu, misc%n%, Add,
	Loop, Read, %A_LoopFileFullPath%
	{ 
		StringLeft, MyText, A_LoopReadLine,65
		Menu, misc%n%, Add, %A_Index%.%MyText%, nil
		max:=A_Index
	}
		Menu, misc, add, %a_index%, :misc%a_index%
}


menu,misc,add,date,nil
menu,misc,add,date time,nil
menu,misc,add, time,nil
Menu, mc3, Add,

tooltip,running selectData
  sleep,200
totalbuttons:=250
gosub, selectData
tooltip,paster coll loaded
sleep,900
tooltip
return

+#wheelup::	;	menu,misc,show
menu,misc,show
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Menu:

Menu, mc3, Add, c:  S:enter #:	^3=prev ^4=next,nil
;Menu, mc3, disable, c:  S:enter #:	^3=prev ^4=next

Menu, mc3, Add, add sel,addSel
Menu, mc3, Add, add ClipB,addClipB
Menu, mc3, Add, edit,nil
Menu, mc3, Add,more ,:more
Menu, mc3, Add, 



return



view_all:
	FileRead,source, collector.txt
tooltip,%source%
keywait, Lbutton, D ,t3
tooltip
return

nil:
gui,submit,nohide

return

addClipB:
	Contents:=clipboard
	gosub,add
	return



addSel:

	Contents:=Get_Selected_Text_slow()
	if contents = 
		contents:=clipboard
	gosub,add
return

add:

	Contents:=regexreplace(Contents,"^\n","")
	Contents:=regexreplace(Contents,"^(\s)*\n","") 
	Contents:=regexreplace(Contents,"\n\r", "")
	Contents:=regexreplace(Contents, "(\n\n)+", "$1")
	Contents:=regexreplace(Contents, "(\n)+", "$1")
	StringReplace, Contents, Contents, %A_TAB%, %A_SPACE%%A_SPACE%%A_SPACE%, All
	StringSplit, word_array, Contents, %delimiter%

	line:=1
	Filedelete, collector.txt
	FileAppend,
	(
	%Contents%
	), collector.txt
	tooltip,adding..
	sleep,400
	tooltip,adding..`n`n%Contents%
	sleep,600
	tooltip,
return
 
<^!n::	; contPaste from first
contPaste:=1
<^n::	;	contpaste
<^+n::	;	contpaste with enter
	if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
	GetKeyState, state_s, Shift
	MC_OwnChange:=1
	clip := MC_Clip%contPaste%
	if contPaste >= %MC_Clips_present%
	{
		tooltip,%contPaste% LAST`n%clip%
		sleep,300
	}
	else
	{
		tooltip,%contPaste%/%MC_Clips_present%`n%clip%
		sleep,300
		contPaste++
		
	}
	sleep,10
	clipboard := clip
	Gosub, MC_Paste
	sleep,50
	MC_OwnChange:=0	
	tooltip
	if (state_s = D ) 
	{
		send {enter}
	}
return 

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	tooltip
return		

+#wheeldown::	;	menu clipboard parse
	Menu, mc3,deleteall
	gosub,menu
	if clipboard !=
	{
		mytext:=clipboard
		if(StrLen(clipboard)>800)
			{
			StringLeft, MyText, clipboard,800
			}

		Menu, clipb, Add, a, mc3_Select2 ;dummy
		Menu, clipb,deleteall	

		Loop, parse,MyText, %delimiter%
		{
			if A_Index>25
				break
			clipb%A_Index%:=A_Loopfield
			StringLeft, Text, A_Loopfield ,75
			Menu, clipb, Add, %A_Index%.    %Text%, mc3_Select2
		}
	}
	Menu, mc3, Add,clipb ,:clipb
	Menu, mc3, Add,

fileRead,MyText,collector.txt
Loop, parse,MyText, %delimiter%
{
	StringLeft, Text, A_Loopfield ,75
	Menu, mc3, Add, %A_Index%.    %Text%, mc3_Select
	maxEntry:=A_Index
}

menu,mc3 ,show
return

mc3_Select:
	MC_OwnChange:=1
	item:=A_ThisMenuItemPos-8

		next:=word_array%line%
		; FileReadLine, next, collector.txt,%item%

	cliptmp := clipboardAll
	clipboard := next
	sleep,100
	;Send, ^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	clipboard := cliptmp
line:=item+1
		  	sleep,150	
	MC_OwnChange:=0	
return

mc3_Select2:
	MC_OwnChange:=1
	item:=A_ThisMenuItemPos	;-5

	;FileReadLine, next, collector.txt,%item%

	cliptmp := clipboardAll
	clipboard := clipb%item%
	sleep,100
	; Send, ^v
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	clipboard := cliptmp
;line:=item+1
		  	sleep,150	
	MC_OwnChange:=0	
return


 ; =======================select Data===========================================
SELECTDATA:

; OnMessage(0x115, "OnScroll") ; WM_VSCROLL
; OnMessage(0x114, "OnScroll") ; WM_HSCROLL



column:=2
buttonHeight:=50
buttonwidth:=1300/column

SetBatchLines,-1
SetWinDelay,0
SetKeyDelay,0
CoordMode,Mouse,Screen
applicationname=MyGui



gui_width:=1300

Gui, +AlwaysOnTop    +LastFound    +border  +resize
Gui, Margin,0,0
Gui, +0x300000 ; WS_VSCROLL | WS_HSCROLL
; Gui, +Resize +0x300000 ; WS_VSCROLL | WS_HSCROLL
; Gui, +LastFound
; GroupAdd, MyGui, % "ahk_id " . WinExist()		;%

Gui, Color, White

AddMenuTrayguishow()
Shrink=0

gui,add,button,x5 y5 w35 h35 vshrinkbutton gShrink,O
gui,add,button, x+2 yp w70 h35 hwndbutton2 ghide,HIDE
ILButton(button2, "shell32.dll:" 131, 32, 32, 5)	
; gui,add,button, x+2 yp w70 h35 ghide,UId
gui,add,button, x+2 yp w70 h35 grefresh_gui,re fresh
; gui,add,button, x+2 yp w70 h35 grefresh_gui,refresh

Gui, font ,  s13 cred, verdana
Gui, Add, text, x+15  yp h40 w80 cred  vselected,0000
Gui, font ,  s10 cred, verdana

Gui, Add, Button, x+0  yp w70 h35 gselectall,all
Gui, Add, Button, x+0  yp w70 h35 gselectnone,none
Gui, Add, Button, x+0  yp w70 h35 gselectinvert,invert
Gui, Add, Button, x+5  yp w50 h35 gclipboardT,clipb

Gui, Add, edit, x+10  yp h25 w45 Number vbuttonHeight gsetColumnHeight,35
Gui, Add, UpDown,    Range1-100, 35
Gui, Add, Button, x+0  yp w25 h25 gsetColumn_height_up,^
Gui, Add, Button, x+0  yp w25 h25 gsetColumn_height_down,v

Gui, Add, edit, x+10  yp h25 w40 Number vcolumn gsetColumn,%column%
Gui, Add, UpDown,    Range1-30, %column%
Gui, Add, Button, x+0  yp w25 h25 gsetColumn1,1
Gui, Add, Button, x+0  yp w25 h25 gsetColumn2,2
Gui, Add, Button, x+0  yp w25 h25 gsetColumn3,3
Gui, Add, Button, x+0  yp w25 h25 gsetColumn4,4
; Gui, Add, Button, x+0  yp w25 h25 gsetColumn5,5
; Gui, Add, Button, x+0  yp w25 h25 gsetColumn6,6
; Gui, Add, Button, x+0  yp w25 h25 gsetColumn7,7
; Gui, Add, Button, x+0  yp w25 h25 gsetColumn8,8


Gui, Add, CheckBox, checked cred  x+10 w35 yp gnil vshow_text_1,1 
Gui, Add, CheckBox,checked cred x+0 w35 yp gnil vshow_text_2,2
Gui, Add, CheckBox,checked cred x+0 w35 yp gnil vshow_text_3,3
Gui, Add, CheckBox,checked cred x+0 w35 yp gnil vshow_text_4,4
Gui, Add, CheckBox,checked cred x+0 w35 yp gnil vshow_text_5,5
Gui, Add, CheckBox,checked cred x+0 w35 yp gnil vshow_text_6,6

Gui, Add, Button,x+0   yp gopen_in_csvQF ,in csvQF

Gui, Add, Button, x+8  yp w25 h25 gselectrandomA,1
Gui, Add, Button, x+0  yp w60 h25 gselectrandomN,Random
Gui, Add, edit, x+1  yp w35 h25 Number vselectrandomN gselectrandomN,0
Gui, Add, UpDown,   vMyUpDown Range1-100, 5
gosub , initializeData

; unique_name:=0
; f_name:=0
; nickname:=0
; ph_no:=0
; mail_id:=0
; FB_id:=0

Gui, font ,  s9 cred, verdana
gui,add,button, x10 y+10 h40 ghide vhide ,HIDE
gui,add,button, x+10 yp h40 goutput vrender ,RENDER
gui,add,button, x+10 yp h40 goutput_hide vrender2 ,RENDER& hide
gui,show,hide,MyGui
 
return
 
line_1:
line_2:
line_3:
line_4:
line_5:
line_6:
line_7:
line_8:
line_9:
line_10:
line_11:
line_12:
line_13:
line_14:
line_15:
line_16:
line_17:
line_18:
line_19:
line_20:
line_21:
line_22:
line_23:
line_24:
line_25:
line_26:
line_27:
line_28:
line_29:
line_30:
line_31:
line_32:
line_33:
line_34:
line_35:
line_36:
line_37:
line_38:
line_39:
line_40:
line_41:
line_42:
line_43:
line_44:
line_45:
line_46:
line_47:
line_48:
line_49:
line_50:
line_51:
line_52:
line_53:
line_54:
line_55:
line_56:
line_57:
line_58:
line_59:
line_60:
line_61:
line_62:
line_63:
line_64:
line_65:
line_66:
line_67:
line_68:
line_69:
line_70:
line_71:
line_72:
line_73:
line_74:
line_75:
line_76:
line_77:
line_78:
line_79:
line_80:
line_81:
line_82:
line_83:
line_84:
line_85:
line_86:
line_87:
line_88:
line_89:
line_90:
line_91:
line_92:
line_93:
line_94:
line_95:
line_96:
line_97:
line_98:
line_99:
line_100:
line_101:
line_102:
line_103:
line_104:
line_105:
line_106:
line_107:
line_108:
line_109:
line_110:
line_111:
line_112:
line_113:
line_114:
line_115:
line_116:
line_117:
line_118:
line_119:
line_120:
line_121:
line_122:
line_123:
line_124:
line_125:
line_126:
line_127:
line_128:
line_129:
line_130:
line_131:
line_132:
line_133:
line_134:
line_135:
line_136:
line_137:
line_138:
line_139:
line_140:
line_141:
line_142:
line_143:
line_144:
line_145:
line_146:
line_147:
line_148:
line_149:
line_150:
line_151:
line_152:
line_153:
line_154:
line_155:
line_156:
line_157:
line_158:
line_159:
line_160:
line_161:
line_162:
line_163:
line_164:
line_165:
line_166:
line_167:
line_168:
line_169:
line_170:
line_171:
line_172:
line_173:
line_174:
line_175:
line_176:
line_177:
line_178:
line_179:
line_180:
line_181:
line_182:
line_183:
line_184:
line_185:
line_186:
line_187:
line_188:
line_189:
line_190:
line_191:
line_192:
line_193:
line_194:
line_195:
line_196:
line_197:
line_198:
line_199:
line_200:
line_201:
line_202:
line_203:
line_204:
line_205:
line_206:
line_207:
line_208:
line_209:
line_210:
line_211:
line_212:
line_213:
line_214:
line_215:
line_216:
line_217:
line_218:
line_219:
line_220:
line_221:
line_222:
line_223:
line_224:
line_225:
line_226:
line_227:
line_228:
line_229:
line_230:
line_231:
line_232:
line_233:
line_234:
line_235:
line_236:
line_237:
line_238:
line_239:
line_240:
line_241:
line_242:
line_243:
line_244:
line_245:
line_246:
line_247:
line_248:
line_249:
line_250:
line_251:
line_252:
line_253:
line_254:
line_255:
line_256:
line_257:
line_258:
line_259:
line_260:
line_261:
line_262:
line_263:
line_264:
line_265:
line_266:
line_267:
line_268:
line_269:
line_270:
line_271:
line_272:
line_273:
line_274:
line_275:
line_276:
line_277:
line_278:
line_279:
line_280:
line_281:
line_282:
line_283:
line_284:
line_285:
line_286:
line_287:
line_288:
line_289:
line_290:
line_291:
line_292:
line_293:
line_294:
line_295:
line_296:
line_297:
line_298:
line_299:
line_300:
line_301:
line_302:
line_303:
line_304:
line_305:
line_306:
line_307:
line_308:
line_309:
line_310:
line_311:
line_312:
line_313:
line_314:
line_315:
line_316:
line_317:
line_318:
line_319:
line_320:
line_321:
line_322:
line_323:
line_324:
line_325:
line_326:
line_327:
line_328:
line_329:
line_330:
line_331:
line_332:
line_333:
line_334:
line_335:
line_336:
line_337:
line_338:
line_339:
line_340:
line_341:
line_342:
line_343:
line_344:
line_345:
line_346:
line_347:
line_348:
line_349:
line_350:
line_351:
line_352:
line_353:
line_354:
line_355:
line_356:
line_357:
line_358:
line_359:
line_360:
line_361:
line_362:
line_363:
line_364:
line_365:
line_366:
line_367:
line_368:
line_369:
line_370:
line_371:
line_372:
line_373:
line_374:
line_375:
line_376:
line_377:
line_378:
line_379:
line_380:
line_381:
line_382:
line_383:
line_384:
line_385:
line_386:
line_387:
line_388:
line_389:
line_390:
line_391:
line_392:
line_393:
line_394:
line_395:
line_396:
line_397:
line_398:
line_399:
line_400:
line_401:
line_402:
line_403:
line_404:
line_405:
line_406:
line_407:
line_408:
line_409:
line_410:
line_411:
line_412:
line_413:
line_414:
line_415:
line_416:
line_417:
line_418:
line_419:
line_420:
line_421:
line_422:
line_423:
line_424:
line_425:
line_426:
line_427:
line_428:
line_429:
line_430:
line_431:
line_432:
line_433:
line_434:
line_435:
line_436:
line_437:
line_438:
line_439:
line_440:
line_441:
line_442:
line_443:
line_444:
line_445:
line_446:
line_447:
line_448:
line_449:
line_450:
line_451:
line_452:
line_453:
line_454:
line_455:
line_456:
line_457:
line_458:
line_459:
line_460:
line_461:
line_462:
line_463:
line_464:
line_465:
line_466:
line_467:
line_468:
line_469:
line_470:
line_471:
line_472:
line_473:
line_474:
line_475:
line_476:
line_477:
line_478:
line_479:
line_480:
line_481:
line_482:
line_483:
line_484:
line_485:
line_486:
line_487:
line_488:
line_489:
line_490:
line_491:
line_492:
line_493:
line_494:
line_495:
line_496:
line_497:
line_498:
line_499:
line_500:
line_501:


Stringtrimleft, Button , A_Thislabel, 5
text:=button_text_%Button%
line_checked_%Button%:=!line_checked_%Button%
if (line_checked_%Button%)

	{  	
		Gui,  Font, s12 cred, Comic Sans MS		 
		GuiControl,  Font  ,  line_v_%Button%
		GuiControl,  , line_v_%Button%,%text%
	ILButton( img_Btn_%Button%, "circle green.ico:0" , 32, 32, 0)


	}
	else
	{
		Gui, Font, s10 cblack,verdana		


		GuiControl,  Font  ,  line_v_%Button%
		GuiControl,  , line_v_%Button%,%text%
		ILButton( img_Btn_%Button%, "" , 32, 32, 0)

	}
	
; gosub,updateslected_no	
; msgbox,%Button%
return


selectall:
	selectlist:=all
	gosub,select
return

selectinvert:
	gui,submit, nohide
	selectlist2=
	loop,parse,all,`n,`r
	{
		if( ! line_checked_%A_index%)
		{
			selectlist2=%selectlist2%`n%A_Loopfield%
		}
	}
	selectlist:=selectlist2
	gosub,select
return

selectnone:
	selectlist=
	gosub,select
return
 
selectrandomA:
	selectN:=1
	gosub,selectrandom
return


selectrandomN:
	gui,submit,nohide
	selectN:=selectrandomN
	; selectN:=MyUpDown
	gosub,selectrandom
return

selectrandom:
	gosub,selectnone

	loop,%selectN% 
	{
		Random, rand, 1, %lncnt%
		t:=line_%rand%
		selectlist=%t%`n%selectlist%

	}
	gosub,select

return

select:
	loop,parse,all,`n,`r
	{
		text:=button_text_%A_index%
		IfInString, selectlist, %A_Loopfield%
		{
			line_checked_%A_index%:=1
			Gui,  Font, s12 cred, Comic Sans MS 	 
			GuiControl,  Font  ,  line_v_%A_index%
			; GuiControl,  , line_v_%A_index%,¢ %text%¢
			GuiControl,  , line_v_%A_index%,%text%
			ILButton( img_Btn_%A_index%, "circle green.ico:0" , 32, 32, 0)
		}
	else	
		{  
			line_checked_%A_index%:=0
			Gui, Font, s10 cblack, verdana
			GuiControl,  Font  ,  line_v_%A_index%
			GuiControl,  , line_v_%A_index%,%text%	
			ILButton( img_Btn_%A_index%, "" , 32, 32, 0)
		}
	}
	gosub,updateslected_no
return

refresh:

return

output_hide:
	gosub,output
	gosub,hide
return

output:

	gui,submit,nohide
	tmp_output=

	loop,parse,all,`n,`r
	{  
	
		if (line_checked_%A_index%)
		{
			tmp_output=%tmp_output%`n%A_Loopfield%
		}
		
	}	
	 If (tmp_output <> "")
			StringTrimleft, tmp_output, tmp_output, 1 ; trim leading delimiter

	; reg=^%userdelim%
	; tmp_output:=regexreplace(tmp_output,reg,"")		;remove first delimite
	; reg=m)^%userdelimLINE%
	; tmp_output:=regexreplace(tmp_output,reg,"")		 

	; tmp_output:=regexreplace(tmp_output,"^(\s)*","")		;remove first blank spaces
	tmp_output:=regexreplace(tmp_output,"^(\s)*\n","")		;remove first blank line
	clipboard:=tmp_output
	; msgbox,%tmp_output%
	settimer,removetooltip,-1200
	tooltip,%clipboard%
return

updateslected_no:

	gui,submit,nohide
	n:=0
	n1:=0
	n2:=0
	loop,%lncnt%
	{
		if (line_checked_%A_index%)
		{
			n++
		}
	}
	guicontrol,,selected,%n%/%lncnt%

return

; removetooltip:
; tooltip,
; return
hide:
	gui,hide

return

randomClipb:
	gosub,output
	sort,clipboard,Random
	settimer,removetooltip,-800
	tooltip,%clipboard%

return

menuTrayguishowToggle:
	menuTrayguishowToggle()
return


INITIALIZEDATA:
	
	all=
	loop, %totalbuttons%
	{
		all=%all%`n%A_index%
	}
INITIALIZEBUTTONS:

	Gui, Font, s10 cred,verdana
	loop %totalbuttons%
	{  
	
		; line_%A_index%:=A_Loopfield 
		line_checked_%A_index%:=0
	
		 
		; name:=line_%A_index%
		transform,remainder,Mod, %A_index%,%column%
		if (A_index==1)
			Gui, Add, Button, x5  y+10 w%buttonwidth% h%buttonHeight% vline_v_%A_index%  gline_%A_index% hwndimg_Btn_%A_index%,	;	%name%	  
		else if (remainder==1)
			Gui, Add, Button, x10 y+4 w%buttonwidth% h%buttonHeight% vline_v_%A_index%  gline_%A_index% hwndimg_Btn_%A_index%,%name%	 
		 else	 
		Gui, Add, Button, x+1  yp w%buttonwidth% h%buttonHeight% vline_v_%A_index% gline_%A_index% hwndimg_Btn_%A_index%,%name%	  
	}

return

#IfWinNotActive, ahk_class dopus.viewpicframe ; conflict in opus picture viewer
<^f10::	; shows GUI - paste Selected_Text line by line
	settimer,cancelHotkeySTEP22,off	

	if !(HotkeySTEP22)	;	if hotkey is currently not in cycle mode 
	{
		sel_text:=Get_Selected_Text()
		HotkeySTEP22_count:=0
	}
	if (HotkeySTEP22_count=0)
	{	
		; open sel in csvqf viewer
		msg=shows GUI
		settimer,removetooltip,-3500	
		tooltip,%msg%
		settimer,cancelHotkeySTEP22,-3500					
	}
	else if ( HotkeySTEP22_count=1 )	
	{
		msg=sorted list
		settimer,removetooltip,-3500	
		tooltip,%msg%
		settimer,cancelHotkeySTEP22,-3500				
	}
	else if ( HotkeySTEP22_count=2 )	
	{
		msg=open hist entries in gui
		settimer,removetooltip,-3500	
		tooltip,%msg%
		settimer,cancelHotkeySTEP22,-3500				
	}
	else if ( HotkeySTEP22_count=3 )	
	{
		msg=CANCEL
		settimer,removetooltip,-1900
		tooltip,%msg%
		settimer,cancelHotkeySTEP22,-2000
		HotkeySTEP22_count:=-1		
	}
	
	HotkeySTEP22_count++
	HotkeySTEP22:=1
	hotkey,^q,on
	setTimer,HotkeySTEP22,70
	sleep,10
return

HotkeySTEP22:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (HotkeySTEP22_count=0)
		{	
			settimer,removetooltip,-800
			tooltip,%HotkeySTEP22_count% cancelled
		}
		else if (HotkeySTEP22_count=1)
		{	
			if sel_text<>
			{
				all:=sel_text
				prev_sel:=sel_text
				gosub,updateButtons
				gosub,POSITION_BOTTOM_BUTTONS
				updateButtons_needed:=0
				gosub,gui_height
				gosub,selectnone
			}
			else
			{
				gosub,gui_height
			}			
		}
		else if (HotkeySTEP22_count=2)
		{	
			sort,all
			gosub,updateButtons
			gui,show,,MyGui			
		}
		else if (HotkeySTEP22_count=3)
		{	
				all=
				lncnt:=0
				Loop %MC_Clips_present%
				{
					t:=MC_Clip%A_Index%
					if t=
					{
					}
					else
					{
						lncnt++
						; line_v_%lncnt%:=t 
						guicontrol,,line_v_%lncnt%,%t%
						; line_v_%lncnt%:=t
						line_%lncnt%:=t
					}
					updatedbuttons:=lncnt
				}
				loop, %lncnt%
				{

				guicontrol,show,line_v_%A_index%


				n:=totalbuttons-lncnt
				; msgbox,%all%
				}
				loop, %n%
				{

				n1:=lncnt+A_index
				guicontrol,hide,line_v_%n1%
				}
					
				if (totalbuttons > updatedbuttons)	
				n:=totalbuttons-updatedbuttons
				; msgbox,%totalbuttons% %updatedbuttons%  %n%
					loop,%n%
					{
					item:=updatedbuttons+A_index
					name=-
					; msgbox,%
					guicontrol,,line_v_%item%,%name%	 
					
					
					}

				if (lncnt<50)
					{
						h:=400
					}
					else if (lncnt<100)
					{
						h:=500
					}
					else if (lncnt<150)
					{
						h:=700
					}
					else
						h:=800			
				gui,show,h%h%
		}
	}
return

cancelHotkeySTEP22:	;	cancel without action

	setTimer,HotkeySTEP22,off
	HotkeySTEP22:=0
	; tooltip,cancel
	settimer,removetooltip,-300
	hotkey,^q,off

	
return


History_In_select_gui: ;open hist entries in gui
	all=
	lncnt:=0
	Loop %MC_Clips_present%
	{
		t:=MC_Clip%A_Index%
		if t=
		{

		}
		else
		{
			lncnt++
			; line_v_%lncnt%:=t 
			guicontrol,,line_v_%lncnt%,%t%
			; line_v_%lncnt%:=t
			line_%lncnt%:=t
		}
		updatedbuttons:=lncnt
	}
	loop, %lncnt%
	{

	guicontrol,show,line_v_%A_index%


	n:=totalbuttons-lncnt
	; msgbox,%all%
	}
	loop, %n%
	{

	n1:=lncnt+A_index
	guicontrol,hide,line_v_%n1%
	}
		
	if (totalbuttons > updatedbuttons)	
	n:=totalbuttons-updatedbuttons
	; msgbox,%totalbuttons% %updatedbuttons%  %n%
		loop,%n%
		{
		item:=updatedbuttons+A_index
		name=-
		; msgbox,%
		guicontrol,,line_v_%item%,%name%	 
		
		
		}

	if (lncnt<50)
		{
			h:=400
		}
		else if (lncnt<100)
		{
			h:=500
		}
		else if (lncnt<150)
		{
			h:=700
		}
		else
			h:=800			
	gui,show,h%h%

return

<^w::	;	paste Selected Text line by line as FAV
	
if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
	settimer,cancelHotkeySTEP29,off	
	if !(HotkeySTEP29)	;	if hotkey is currently not in cycle mode 
	{
		HotkeySTEP29_count:=0
	}
	settimer,removetooltip,-1600
	if (HotkeySTEP29_count=0)
	{	; open sel in csvqf viewer
		msg=paste Selected Text line by line as FAV clips
	}
	else if ( HotkeySTEP29_count=1 )	
	{
		msg=clipB		
	}
	else if ( HotkeySTEP29_count=2 )	
	{
		msg=last
	}
	else if ( HotkeySTEP29_count=3 )	
	{
		msg=CANCEL
		HotkeySTEP29_count:=-1	
	}
	HotkeySTEP29_count++
	tooltip,%HotkeySTEP29_count%. %msg%	
	settimer,cancelHotkeySTEP29,-1500
	HotkeySTEP29:=1
	hotkey,^q,on
	setTimer,HotkeySTEP29,70
	sleep,10
return

HotkeySTEP29:	;	cancel checking status of ctrl key
	GetKeyState,state,CTRL
	If state=u
	{
		if (HotkeySTEP29_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%HotkeySTEP29_count% cancelled
		}
		else if (HotkeySTEP29_count=1)
		{		
			add_to_fav_also:=0
			MC_OwnChange:=1
			all:=Get_Selected_Text()
			sleep,30
			MC_OwnChange:=0
			if all<>
			{
				; tooltip,paste Selected Text
				gosub,create_array
				; sleep,300				
				if(StrLen(all)>300)
				{
					; StringLeft, all_tmp, all,300
					all_tmp=%all_tmp%`n`n.........`n.........`n.........`n.........
				}
				tooltip,%HotkeySTEP29_count%. paste Selected Text %delimiter% by %delimiter% as FAV clips
				sleep,250
				tooltip,%HotkeySTEP29_count%. paste Selected Text %delimiter% by %delimiter% as FAV clips`n%MCF_clips_present% items
				sleep,150
				settimer,removetooltip,-2700
				tooltip,%HotkeySTEP29_count%. paste Selected Text %delimiter% by %delimiter% as FAV clips`n%MCF_clips_present% items`n`n%all_tmp%
			}
			else 
			{
				settimer,removetooltip,-2000
				tooltip,selected text empty. cannot add to fav clips
			}
			keywait, Lbutton, D ,t1.8
			settimer,removetooltip,off
			tooltip,
		}
		else if (HotkeySTEP29_count=2)
		{
			add_to_fav_also:=0
			all:=clipboard
			sleep,100
			gosub,create_array
			tooltip,paste  clipboard by %delimiter%
			sleep,300
			StringLeft, all_tmp, all, 300  
			tooltip,paste last clipboard by %delimiter%`n`n%MCF_clips_present% items
			sleep,250
			settimer,removetooltip,-2500
			tooltip,paste last clipboard by %delimiter%`n`n%MCF_clips_present% items`n%all_tmp%

		}
		else if (HotkeySTEP29_count=3)
		{
			settimer,removetooltip,-1500
			tooltip,last

		}
		gosub,cancelHotkeySTEP29
	}
return

cancelHotkeySTEP29:	;	cancel without action
	setTimer,HotkeySTEP29,off
	HotkeySTEP29:=0
	; tooltip,cancelling
	; settimer,removetooltip,-300
	hotkey,^q,off
	
return

/*
add_to_fav_also:=0
	MC_OwnChange:=1
	all:=Get_Selected_Text()
	MC_OwnChange:=0

if all<>
	{
		tooltip,paste Selected Text
		gosub,create_array
		; sleep,300
		
		if(StrLen(all)>300)
		{
			StringLeft, all_tmp, all,300
			all_tmp=%all_tmp%`n`n.........`n.........`n.........`n.........
		}
		else
			 all_tmp := all
		tooltip,paste Selected Text by %delimiter%
		sleep,250
		tooltip,paste Selected Text by %delimiter%`n%MCF_clips_present% items
		sleep,150
		settimer,removetooltip,-1700
		tooltip,paste Selected Text by %delimiter%`n%MCF_clips_present% items`n`n%all_tmp%
	}
else 
	{
		settimer,removetooltip,-2000
		tooltip,selected text empty. cannot add to fav clips
	}
	keywait, Lbutton, D ,t1.8
	settimer,removetooltip,off
	tooltip,
return

; <^+w::	;	paste  clipboard line by line as FAV
add_to_fav_also:=0

	all:=clipboard
	sleep,100
	gosub,create_array
	tooltip,paste  clipboard by %delimiter%
	sleep,300
	StringLeft, all_tmp, all, 300  
	tooltip,paste last clipboard by %delimiter%`n`n%MCF_clips_present% items
	sleep,250
	settimer,removetooltip,-1500
	tooltip,paste last clipboard by %delimiter%`n`n%MCF_clips_present% items`n%all_tmp%
return
*/
create_array:

	all:=regexreplace(all,"(*ANYCRLF)(^\s+)|(\s+$)", "")
	
	newline:=0
	ignore_delimiter=
	Loop, Parse, all, `n,`r
		newline++
	sleep,10
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
	id:=next_tmp_fav_collector(id)
	all_tmp=
	loop,parse,all,%item_delimiter%,%ignore_delimiter%
	{
		
		MCF_Clip%id%_%A_Index%:=a_loopfield
		MCF_clips_present:=a_index
		StringLeft, MyText, MCF_Clip%id%_%A_Index%, 35 ;MCF_MaxLength
		all_tmp.= a_loopfield . "`n"
	}
	stringtrimright,all_tmp,all_tmp,1
loop ,% MCF_MAX_Clips-MCF_clips_present 	;	%
{
	n:=A_Index+MCF_clips_present
	MCF_Clip%id%_%n%=
}
	updateButtons_needed:=1
	; gosub,gui_height
	MCF_activeclip:=0	;	nothing is pasted
return


gui_height:
	if (lncnt<50)
		{
			h:=450
		}
		else if (lncnt<100)
		{
			h:=500
		}
		else 
		{
			h:=700
		}
	if (updateButtons_needed)
		{
			gosub,updateButtons
			updateButtons_needed := 0
		}
	gui,show, h%h% ;  w600  ; AutoSize
	; gui,show, h%h%  w1300 Maximize ; AutoSize
	; Winset, Redraw, , mygui
return

updateButtons:
; msgbox,=%all%=
	all:=regexreplace(all,"(^\s+)|(\s+$)","")
	loop, parse, all, `n,`r
	{	
		lncnt:=A_Index
	}

	; hide unused buttons

	loop, %lncnt%
	{
		guicontrol,show,line_v_%A_index%
		; msgbox,%all%
	}

	n:=totalbuttons-lncnt
	; msgbox,%lncnt%
	loop, %n%
	{
		n1:=lncnt+A_index
		guicontrol,hide,line_v_%n1%
	}

	; field_delimiter_All=`,,A_space,`",\,\n\n,\n,`n`r,`n,.,`:
	field_delimiter_All=,|A_space|"|\|\n\n|\n|`n`r|`n|.|:		;"
	; msgbox,%field_delimiter_All%

	loop,parse,field_delimiter_All,|
	{
		; msgbox,%a_index% = %A_Loopfield%
		; ifinstring,
		IfInString, all,%A_Loopfield%
		{
			field_delimiter:=A_Loopfield
			;userdelim:=field_delimiter
			; stringreplace,
			guicontrol,,userdelim,\n\n|\n|`n`r|`n|`,|.||`:
			break
		}
		
	}
	; msgbox,%field_delimiter%
	if field_delimiter=
		field_delimiter=,
	
	loop,parse,all,`n,`r
	{  
		line_%A_index%:=A_Loopfield 
		line_checked_%A_index%:=0
		IfInString, A_Loopfield, %field_delimiter%
		{
			loop %lineArray0%
			{
				lineArray%A_index%=
			}
			StringSplit, lineArray, A_Loopfield, %field_delimiter%
			loop %lineArray0%
			{
				line_field_1_%A_index%:=lineArray%A_index%
			}
		}	
		name:=lineArray1
		MyText=
		Gui, Font, s10 cred,verdana
		;  transform,remainder,Mod, %A_index%,6
		textwidth:=(800/column/6)*(buttonHeight/25)	; button width
		IfInString, A_Loopfield, %field_delimiter%
		{
			if(show_text_1)
				MyText .= lineArray1
			if(show_text_2)
				MyText .=field_delimiter . lineArray2
			if(show_text_3)
				MyText .=field_delimiter . lineArray3
			if(show_text_4)
				MyText .=field_delimiter . lineArray4
			if(show_text_5)
				MyText .=field_delimiter . lineArray5
			if(show_text_6)
				MyText .=field_delimiter . lineArray6
			
			if(StrLen(name)>textwidth)
				{
					StringLeft, MyText, name,%textwidth%
					MyText=%MyText%......	
					guicontrol,,line_v_%A_index%,%MyText%
					; guicontrol,,line_v_%A_index%,MyText
				}
				else
					guicontrol,,line_v_%A_index%,%MyText%
			; msgbox,%MyText% 					
		}		
		else
		{	
			 MyText:=A_Loopfield
			if(StrLen(A_Loopfield)>textwidth)
				{
					StringLeft, MyText, A_Loopfield,%textwidth%
					MyText=%MyText%......	
					guicontrol,,line_v_%A_index%,%MyText%
				}
				else
					guicontrol,,line_v_%A_index%,%MyText%					
		}	
		button_text_%A_index%:=MyText

		/*
		if A_index=1
			Gui, Add, Button, x10  y+20 w120 h30 vline_v_%A_index%  gline_%A_index%,%name%	  
			
		; else if ((A_index=6) |  (A_index=11) | (A_index=16) | (A_index=21) | (A_index=26))
		else if (remainder==1)
			Gui, Add, Button, x10 y+4 w120 h30 vline_v_%A_index%  gline_%A_index%,%name%	 
		 else	 
		Gui, Add, Button, x+1  w120 h30 vline_v_%A_index% gline_%A_index% ,%name%	  
	*/
	
	updatedbuttons:=A_index
	}

	if (totalbuttons > updatedbuttons)	
	n:=totalbuttons-updatedbuttons
	; msgbox,%totalbuttons% %updatedbuttons%  %n%
	loop,%n%
	{
		item:=updatedbuttons+A_index
		name=
		; msgbox,%
		guicontrol,,line_v_%item%,%name%	 
	}
		
return

refresh_gui:
	gosub,updateButtons
	gosub,POSITION_BOTTOM_BUTTONS
	gosub,gui_height
	; gosub,selectnone
	winset,redraw


return

/*
guiresize:
column:=3
guicontrol,,column,3
gosub,setColumn
return
*/

Shrink:
shrink:=!shrink
if shrink
	{
	; guicontrol,move,shrinkbutton ,h60
	winset,region, 8-8 w40 h60
	;gosub,hide
	}
else
{
	;if hidden
		;gosub,show
		; guicontrol,move,shrinkbutton ,h250
	winset,region, 0-0 w1368 h900
}
return


;scrollable gui


;---------------------------------------------------------------
;put all of the below code at the bottom of your script or after any return, you probably will want to edit the GuiClose label to fit your needs.
GuiSize:
	UpdateScrollBars( A_Gui, A_GuiWidth, A_GuiHeight)
	gui_width:=A_GuiWidth
	; column:=5
	; guicontrol,, column,5
	gosub, setColumn
return


#IfWinActive, MyGui
WheelUp::	; na
WheelDown::	; na
+WheelUp::	; na
+WheelDown::	; na
	tooltip,wheel
    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
    OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, GetKeyState("Shift") ? 0x114 : 0x115, WinExist())
return

#IfWinActive

UpdateScrollBars(GuiNum, GuiWidth, GuiHeight)
{
    static SIF_RANGE=0x1, SIF_PAGE=0x2, SIF_DISABLENOSCROLL=0x8, SB_HORZ=0, SB_VERT=1
   
    Gui, %GuiNum%:Default
    Gui, +LastFound
   
    ; Calculate scrolling area.
    Left := Top := 9999
    Right := Bottom := 0
    WinGet, ControlList, ControlList
    Loop, Parse, ControlList, `n
    {
        GuiControlGet, c, Pos, %A_LoopField%
        if (cX < Left)
            Left := cX
        if (cY < Top)
            Top := cY
        if (cX + cW > Right)
            Right := cX + cW
        if (cY + cH > Bottom)
            Bottom := cY + cH
    }
    Left -= 8
    Top -= 8
    Right += 8
    Bottom += 8
    ScrollWidth := Right-Left
    ScrollHeight := Bottom-Top
   
    ; Initialize SCROLLINFO.
    VarSetCapacity(si, 28, 0)
    NumPut(28, si) ; cbSize
    NumPut(SIF_RANGE | SIF_PAGE, si, 4) ; fMask
   
    ; Update horizontal scroll bar.
    NumPut(ScrollWidth, si, 12) ; nMax
    NumPut(GuiWidth, si, 16) ; nPage
    DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_HORZ, "uint", &si, "int", 1)
   
    ; Update vertical scroll bar.
    ; NumPut(SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, si, 4) ; fMask
    NumPut(ScrollHeight, si, 12) ; nMax
    NumPut(GuiHeight, si, 16) ; nPage
    DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_VERT, "uint", &si, "int", 1)
   
    if (Left < 0 && Right < GuiWidth)
        x := Abs(Left) > GuiWidth-Right ? GuiWidth-Right : Abs(Left)
    if (Top < 0 && Bottom < GuiHeight)
        y := Abs(Top) > GuiHeight-Bottom ? GuiHeight-Bottom : Abs(Top)
    if (x || y)
        DllCall("ScrollWindow", "uint", WinExist(), "int", x, "int", y, "uint", 0, "uint", 0)
}

OnScroll(wParam, lParam, msg, hwnd)
{

    static SIF_ALL=0x17, SCROLL_STEP=100
   
    bar := msg=0x115 ; SB_HORZ=0, SB_VERT=1
   
    VarSetCapacity(si, 28, 0)
    NumPut(28, si) ; cbSize
    NumPut(SIF_ALL, si, 4) ; fMask
    if !DllCall("GetScrollInfo", "uint", hwnd, "int", bar, "uint", &si)
        return
   
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "uint", hwnd, "uint", &rect)
   
    new_pos := NumGet(si, 20) ; nPos
   
    action := wParam & 0xFFFF
    if action = 0 ; SB_LINEUP
        new_pos -= SCROLL_STEP
    else if action = 1 ; SB_LINEDOWN
        new_pos += SCROLL_STEP
    else if action = 2 ; SB_PAGEUP
        new_pos -= NumGet(rect, 12, "int") - SCROLL_STEP
    else if action = 3 ; SB_PAGEDOWN
        new_pos += NumGet(rect, 12, "int") - SCROLL_STEP
    else if action = 5 ; SB_THUMBTRACK
        new_pos := NumGet(si, 24, "int") ; nTrackPos
    else if action = 6 ; SB_TOP
        new_pos := NumGet(si, 8, "int") ; nMin
    else if action = 7 ; SB_BOTTOM
        new_pos := NumGet(si, 12, "int") ; nMax
    else
        return
   
    min := NumGet(si, 8, "int") ; nMin
    max := NumGet(si, 12, "int") - NumGet(si, 16) ; nMax-nPage
    new_pos := new_pos > max ? max : new_pos
    new_pos := new_pos < min ? min : new_pos
   
    old_pos := NumGet(si, 20, "int") ; nPos
   
    x := y := 0
    if bar = 0 ; SB_HORZ
        x := old_pos-new_pos
    else
        y := old_pos-new_pos
    ; Scroll contents of window and invalidate uncovered area.
    DllCall("ScrollWindow", "uint", hwnd, "int", x, "int", y, "uint", 0, "uint", 0)
   
    ; Update scroll bar.
    NumPut(new_pos, si, 20, "int") ; nPos
    DllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", &si, "int", 1)
}



setColumn1:
setColumn2:
setColumn3:
setColumn4:
setColumn5:
setColumn6:
setColumn7:
setColumn8:
setColumn9:
setColumn10:
Stringtrimleft, column , A_Thislabel, 9

guicontrol,,column,%column%
gosub,setColumn
return

setColumn_height_up:
	buttonHeight+=30
	guicontrol,,buttonHeight,%buttonHeight%
	gosub,setColumnHeight
	return

setColumn_height_down:
	buttonHeight-=30
	guicontrol,,buttonHeight,%buttonHeight%
	gosub,setColumnHeight
	return
setColumnHeight:
; return

setColumn:
gui,submit,nohide
x:=10
y:=70

Gui,+LastFound
WinGetPos,gui_x,gui_y,width,height
; msgbox,%width%

; gui_width:=width

buttonwidth:=(gui_width-25)/column
startx:=20
x:=startx
loop, %totalbuttons%
{
	transform,remainder,Mod, %A_index%,%column%

	if (A_index==1)
		{
			GuiControl, Move,line_v_%A_index%,   x%startx%  y%y% w%buttonwidth% h%buttonHeight%
		}
		else if (remainder==1 OR column==1)
		{			
			x:=startx
			y:=y+buttonHeight+1
			GuiControl, Move,line_v_%A_index%,    x%startx%  y%y%	 w%buttonwidth% h%buttonHeight%
		
		}
		else
		{
			x:=x+buttonwidth+1
			GuiControl, Move,line_v_%A_index% ,  x%x%  y%y% w%buttonwidth% h%buttonHeight%
			
		}
}

POSITION_BOTTOM_BUTTONS:

	rows:=lncnt/column
	transform,rows,ceil,rows
	t:=rows*(buttonHeight+1)+100
	; msgbox,%rows%

	GuiControl, Move,hide ,  y%t% 
	GuiControl, Move,render ,  y%t%
	GuiControl, Move,render2 ,  y%t%


return

clipboardT:
all:=clipboard
; sort,all
gosub,updateButtons
gui,show

return

 
	



; =================== clipboardManager ===========================================
clipboardManager:


; menu, Tray, Icon, Shell32.dll, 43
; #persistent
; #SingleInstance force

MC_NullMenu := " "

IniRead,id0,pastecollector_favclipList.ini,0,id
IniRead,id,pastecollector_favclipList.ini,now,id
if (id=="")
{
	id=1
	id0=id
	; msgbox,%id%
}
loop, %tot_clip_containers%
{
		IniRead,source%a_index%,pastecollector_favclipList.ini,source,%a_index%
		a:=source%a_index%
		Menu, select, Add,%a%,select_clipcollector
		; id%a_index%=%a_index%
 
	} 
source:=source%id%
	Menu, more, Add,select,:select
return

select_clipcollector:

		
id:= A_ThisMenuItemPos 
source:=source%id%
Iniwrite,%id%,pastecollector_favclipList.ini,now,id
return

#IfWinnotActive, ahk_class dopus.lister
; <#4:: ; fav collector
<#wheelup::	; na
#IfWinnotActive,
		FShow := false

		Loop %MCF_MAX_Clips%
		{
		FSaveClip%A_Index% := MCF_Clip%id%_%A_Index%
		

		;	load saved favclips on last exit
		; FileRead, MCF_Clip%id%_%A_Index%, %fav_data_f%\%id%_%A_Index%.clip
		}
		Menu, MCF_Temp, Add
		Menu, MCF_Temp, Delete
		Menu, MCF_Temp, Add, &hide, MFhide
		Menu, MCF_Temp, Color,88DDDD,single
		;Menu, MCF_Temp, Icon, hide, Shell32.dll, 292,22
		Menu, MCF_Temp, Add,toggle source ,toggle_source
		a:=source%id%
		Menu, MCF_Temp, Add,c:  s:  #:  n=%MCF_activeclip% id=%id%.%a% tot=%MCF_clips_present%,nil
		Menu, MCF_Temp,disable,c:  s:  #:  n=%MCF_activeclip% id=%id%.%a% tot=%MCF_clips_present%
		Menu, MCF_Temp, Add
		Loop  %Clips_shown%
		  {
			; Get the next entry.  Display at most MCF_MaxLen if it's a long clipboard.
			StringLeft, MyText, MCF_Clip%id%_%A_Index%,50 ;MCF_MaxLength

			stringreplace,MyText,MyText,%A_Tab%,%A_Space%%A_Space%%A_Space%,All
			if (MyText <> "") ; Add this clip to the menu if it isn't blank.
			{
			  Menu, MCF_Temp, Add, %A_Index%.     %MyText%, MCF_Select
			  if (A_index =MCF_activeclip)
				Menu, MCF_Temp, Icon, %A_Index%.     %MyText%, Shell32.dll, 297,22
			  else
				Menu, MCF_Temp, Icon, %A_Index%.     %MyText%, Shell32.dll, 294,20
			} 
		  }
		Menu, more, Delete
		Menu, more, Add,select,:select
		Menu, more, Add,
		Loop  %MCF_MAX_Clips% 
		{  
			Menu, more, Add, add_to  %A_Index%, add_to 
			Menu, more, Icon, add_to  %A_Index%, Shell32.dll, 129 ,15
		}
		Menu, more, Add,
		Menu, more, Add,delete all,del_Fav_clips


		Menu, MCF_Temp, Add,
		Menu, MCF_Temp, Add,Copy all,copy_all_fav_clips
		Menu, MCF_Temp, Add,paste all,paste_all_fav_clips
		
		StringLeft, MyText2, clipboard, 20
		StringReplace, MyText2, MyText2,%A_Tab%, %A_SPACE%, All
		Menu, MCF_Temp, Add,add  `"  %MyText2%`  "  to free slot, MCF_next_slot_clipb
		Menu, MCF_Temp, Add,add  `"  %MyText2%`  "  to first  slot, Ffirst_slot_clipb
		Menu, MCF_Temp, Icon,add  `"  %MyText2%`  "  to free slot, Shell32.dll, 222,22
		

		Menu, MCF_Temp, Add, 
		StringLeft, MyText, clipboard, 35 
		StringReplace, MyText, MyText,%A_Tab%, %A_SPACE%, All
		Menu, MCF_Temp, Add,export to file,export_to_file
		Menu, MCF_Temp, Add,clipb : %MyText%, nil
		Menu, MCF_Temp, Icon,clipb : %MyText%, Shell32.dll, 135 ,22
		Menu, MCF_Temp, Add,more, :more
		Menu, MCF_Temp, Icon,more,Shell32.dll, 284,24
		/*
		FileRead, copieddata, %HIST_data_f%\append.txt
		StringLeft, MyText, copieddata, MC_MaxLen
		Menu, MCF_Temp, Add
		if (MyText ="")
		{
			mytext=EMPTY
			Menu, MCF_Temp, Add,  %MyText%, append
			;Menu, MC_Temp, Icon, %MyText%, Shell32.dll, 149 ,28
		}
		else 
	    {
			Menu, MCF_Temp, Add,  view appended: %MyText%, append
			Menu, MCF_Temp, Icon, view appended: %MyText%, Shell32.dll, 149 ,28
		}
		  ; Now show the menu, provided there's at least one thing on it.
		 */ 
		Menu, MCF_Temp, Show
return 	

Ffirst_slot_clipb:
	selText := clipboard
	; msgbox,%selText%
	gosub,Ffirst_slot
return

<^5::	;to first slot in fav
	add_to_fav_also:=0
	selText := Get_Selected_Text()
	gosub,Ffirst_slot
return

Ffirst_slot:

if selText<>
	{
	if (selText!=MCF_Clip%id%_1)
		{
			Loop  %MCF_MAX_Clips%
			{
				n:=MCF_MAX_Clips-A_Index+1
				n2:=n-1
				MCF_Clip%id%_%n%:=MCF_Clip%id%_%n2% 
			}		  
			MCF_Clip%id%_1:= selText
			a:= MCF_Clip%id%_1
			MCF_clips_present++  
			settimer,removetooltip,-1000
			tooltip, added to 1( MCF_Clip%id%_1)
		}
		else 
		{
			settimer,removetooltip,-1200
			tooltip,selected same
		}
		
	}
else 
	{
	settimer,removetooltip,-1200
	tooltip,selected text empty. cannot add to fav clips
	}
return
	

MCF_next_slot_clipb:
	selText := clipboard
	gosub,MCF_next_slot

return

$<#a::	; na
	if  (HotkeySTEP55) 
	{
		setTimer,HotkeySTEP55,off
		HotkeySTEP55:=0
		HotkeySTEP55_count:=0
		settimer,removetooltip,-600
		tooltip,cancelled
		
			hotkey,<#a,off
	}
	else
	{
		send #a
	}
return


<#s:: ; cycle see,paste all fav clips
	hotkey,<#a,on
	setTimer,HotkeySTEP55,70
	if !(HotkeySTEP55)	;	if hotkey is currently not in cycle mode 
	{
		HotkeySTEP55_count:=0
	}
	if (HotkeySTEP55_count=0)
	{	
		HotkeySTEP55_count++
		settimer,removetooltip,-10000
		msg=Copy all_fav_clips
		tooltip,%HotkeySTEP55_count% %msg%`n#a:: cancel
		fav_clips_all_dir=0
		fav_clips_all_delimiter=0
		gosub,get_all_fav_clips
		settimer,removetooltip,-10000
		tooltip,%HotkeySTEP55_count% %msg%: %MCF_clips_present% clips`n#a:: cancel`n%truncated_text%
	}
	else if ( HotkeySTEP55_count=1 )	
	{	
		HotkeySTEP55_count++
		settimer,removetooltip,-10000
		msg=paste all_fav_clips
		tooltip,%HotkeySTEP55_count% %msg%`n#a:: cancel
		fav_clips_all_dir=0
		fav_clips_all_delimiter=0
		gosub,get_all_fav_clips
		settimer,removetooltip,-10000
		tooltip,%HotkeySTEP55_count% %msg%: %MCF_clips_present% clips`n#a:: cancel`n%truncated_text%
		
	}
	else if ( HotkeySTEP55_count=2 )	
	{
		settimer,removetooltip,-10000			
		msg=paste_all_fav_clips_reversed
		HotkeySTEP55_count++		
		tooltip,%HotkeySTEP55_count% %msg%
		fav_clips_all_dir=1
		fav_clips_all_delimiter=0
		gosub,get_all_fav_clips
		settimer,removetooltip,-10000
		tooltip,%HotkeySTEP55_count% %msg%: %MCF_clips_present% clips`n#a:: cancel`n%truncated_text%
	}
	else if ( HotkeySTEP55_count=3 )	
	{
		settimer,removetooltip,-10000
		msg=paste_all_fav_clips with blank separator
		HotkeySTEP55_count++
		tooltip,%HotkeySTEP55_count% %msg%
		fav_clips_all_dir=0
		fav_clips_all_delimiter=1
		settimer,removetooltip,-10000
		gosub,get_all_fav_clips
		tooltip,%HotkeySTEP55_count% %msg%: %MCF_clips_present% clips`n#a:: cancel`n%truncated_text%
		
	}
	else if ( HotkeySTEP55_count=4 )	
	{
		HotkeySTEP55_count++
		settimer,removetooltip,-10000
		msg=paste_all_fav_clips  blank separator REV
		tooltip,%HotkeySTEP55_count% %msg%
		fav_clips_all_dir=1
		fav_clips_all_delimiter=1
		settimer,removetooltip,-10000
		gosub,get_all_fav_clips
		tooltip,%HotkeySTEP55_count% %msg%: %MCF_clips_present% clips`n#a:: cancel`n`n%truncated_text%
		
	}
	else if ( HotkeySTEP55_count=5)	
	{
		HotkeySTEP55_count:=0
		settimer,removetooltip,-800
		msg=CANCEL
		tooltip,%HotkeySTEP55_count% %msg%			
	}
	HotkeySTEP55:=1

return

HotkeySTEP55:	
	GetKeyState,state,CTRL
	GetKeyState,state_w,lwin

	If ((state="U") && (state_w="U"))
	{
			setTimer,HotkeySTEP55,off
			HotkeySTEP55:=0
		if (HotkeySTEP55_count=1)
		{	
			settimer,removetooltip,-1000	
			MC_OwnChange:=1
			;	paste_all_fav_clips
			gosub,copy_all_fav_clips
			sleep,150	
			MC_OwnChange:=0	
		}
		else if (HotkeySTEP55_count=2)
		{	
			settimer,removetooltip,-1000	
			;	paste_all_fav_clips
			gosub,paste_all_fav_clips
		}
		else if (HotkeySTEP55_count=3)
		{	
			settimer,removetooltip,-1000				
			gosub,paste_all_fav_clips
			
		}
		else if (HotkeySTEP55_count=4)
		{	
			settimer,removetooltip,-1000			
			gosub,paste_all_fav_clips
		}
		else if (HotkeySTEP55_count=5)
		{	
			settimer,removetooltip,-1000	
			gosub,paste_all_fav_clips
		}
		else
		{
			tooltip,cancel
		}
		HotkeySTEP55_count:=0
		settimer,removetooltip,-600
		tooltip,%msg% done!!
	}
return
; ========================
#d:: ; favclips sync


	setTimer,HotkeySTEP17,70
	if !(HotkeySTEP17)	;	if hotkey is currently not in cycle mode 
	{
		HotkeySTEP17_count:=0
	}
	if (HotkeySTEP17_count=0)
	{	
		settimer,removetooltip,-4000			
		msg=clip auto copy last is last
		HotkeySTEP17_count++
		tooltip,%HotkeySTEP17_count% %msg%
		
	}
	else if ( HotkeySTEP17_count=1 )	
	{
		settimer,removetooltip,-4000			
		msg=add to fav on clipchange
		HotkeySTEP17_count++		
		tooltip,%HotkeySTEP17_count% %msg%
	}
	else if ( HotkeySTEP17_count=2)	
	{
		settimer,removetooltip,-3000
		msg=No sync
		HotkeySTEP17_count++	
		tooltip,%HotkeySTEP17_count% %msg%			
	}
	else if ( HotkeySTEP17_count=3)	
	{
		HotkeySTEP17_count:=0
		settimer,removetooltip,-3000
		msg=CANCEL
		tooltip,%HotkeySTEP17_count% %msg%			
	}
	HotkeySTEP17:=1

return


HotkeySTEP17:	
	GetKeyState,state,CTRL
	GetKeyState,state_w,lwin
	
	If ((state="U") && (state_w="U"))
	{
			setTimer,HotkeySTEP17,off
			HotkeySTEP17:=0
		if (HotkeySTEP17_count=1)
		{	
			; add to fav on clipchange
			settimer,removetooltip,-1000	
			
			MC_OwnChange:=1
			selText =
			add_to_fav_also:=0
			add_to_fav_also_pos:=0
			selText := Get_Selected_Text()
			gosub,del_Fav_clips
			sleep,40
			MCF_Clip%id%_1:=selText
			get_maxEntry()
			MCF_clips_present :=1
			MCF_activeclip:=0	
			add_to_fav_also:=1
			msg=clip auto copy last is last`nadded to MCF_Clip_1
			MC_OwnChange:=0
			tooltip,%HotkeySTEP17_count% %msg%
			sleep,500
			msg=clip auto copy last is last`nadded to MCF_Clip_1`n%selText%
			settimer,removetooltip,-1000
		}
		else if (HotkeySTEP17_count=2)
		{	
			
			settimer,removetooltip,-1000	
			
			MC_OwnChange:=1
			selText =
			add_to_fav_also:=0
			add_to_fav_also_pos:=1
			selText := Get_Selected_Text()
			gosub,del_Fav_clips
			sleep,50
			MCF_Clip%id%_1:=selText
			get_maxEntry()
			MCF_clips_present :=1
			MCF_activeclip:=0
			add_to_fav_also:=1
			msg=add to fav on clipchange`nadding to MCF_Clip_1
			MC_OwnChange:=0
			tooltip,%HotkeySTEP17_count% %msg%
			sleep,500
			msg=add to fav on clipchange`nadding to MCF_Clip_1`n%selText%
			settimer,removetooltip,-1000
		}
		else if (HotkeySTEP17_count=3)
		{	
			settimer,removetooltip,-1000	
			add_to_fav_also:=0			
		}
		else
		{
			settimer,removetooltip,-500
			tooltip,cancel
		}
		tooltip,%HotkeySTEP17_count% %msg%
		HotkeySTEP17_count:=0
	}
return

#!lbutton::  ;	append as fresh | next
#!d:: ;	append as fresh | next

	if !(HotkeySTEP21)	;	if hotkey is currently not in cycle mode 
	{
		HotkeySTEP21_count:=0
		
		HotkeySTEP21:=1
	}
	if (HotkeySTEP21_count=0)
	{	
		settimer,removetooltip,-4000			
		tooltip,add to fav next
		HotkeySTEP21_count++
	}
	else if ( HotkeySTEP21_count=1 )	
	{
		settimer,removetooltip,-4000			
		tooltip,add to fav FRESH
		HotkeySTEP21_count++		
	}
	else if ( HotkeySTEP21_count=2)	
	{
		HotkeySTEP21_count:=0
		settimer,removetooltip,-4000
		msg=CANCEL
		tooltip,%HotkeySTEP21_count% %msg%			
	}
	setTimer,HotkeySTEP21,70

return

HotkeySTEP21:	
	GetKeyState,state,ALT
	GetKeyState,state_w,lwin

	If ((state="U") && (state_w="U"))
	{
			MC_OwnChange:=1
			selText := Get_Selected_Text()
			sleep,100
			MC_OwnChange:=0
			settimer,removetooltip,-500	
			setTimer,HotkeySTEP21,off
			HotkeySTEP21:=0
		if (HotkeySTEP21_count=1)
		{
			settimer,removetooltip,-1000	
			; msgbox
			gosub,MCF_next_slot
		}
		else if (HotkeySTEP21_count=2)
		{
			settimer,removetooltip,-1200	
			gosub,del_Fav_clips
			sleep,50
			MCF_Clip%id%_1:=selText	
			a:=MCF_Clip%id%_1
			MCF_clips_present++			
			tooltip,add to fav FRESH added to 1`n%a%
			; sleep,700			
			; tooltip
		}
		else
		{
			tooltip,cancel
		}
		HotkeySTEP21_count:=0
	}
return

MCF_next_slot:

	if ( selText=MCF_Clip%id%_%MCF_clips_present% )
	{
		tooltip,add to fav next added already`n`n%selText%
		return
	}
		;check for free slot
	
	/*
	Loop  %MCF_MAX_Clips%
	{
		;StringLeft, MyText, MCF_Clip%id%_%A_Index%, 35 ;MCF_MaxLength
		MCF_clips_present :=a_index
		MCF_clips_present:=a_index
		if (MCF_Clip%id%_%A_Index% = "") 
			break
	}
	*/
	MCF_clips_present++
	MCF_Clip%id%_%MCF_clips_present% := selText  
	FileDelete, %fav_data_f%\%id%_%MCF_clips_present%.clip 
	FileAppend, %selText%, %fav_data_f%\%id%_%MCF_clips_present%.clip 
	settimer,removetooltip,-2200
	tooltip,add to fav next to %MCF_clips_present%
	sleep,450
	tmp_text=
	n:=MCF_clips_present
	loop,3
	{
		if (n<1)
			break
		stringleft,a,MCF_Clip%id%_%n%,80
		tmp_text .= n . ". " . a . "`n`n"
		n--
	}
	; tooltip,add to fav next to %MCF_clips_present%`n`n%selText%
	tooltip,add to fav next to %MCF_clips_present%`n`n%tmp_text%
return	

copy_all_fav_clips:
		fav_clips_all_dir=0
		fav_clips_all_delimiter=0
		gosub,get_all_fav_clips
		
	MC_OwnChange:=1
	clipboard := full_text
	sleep,150	
	MC_OwnChange:=0	
	tooltip,%truncated_text%
	sleep,400
	tooltip
return

paste_all_fav_clips:
		fav_clips_all_dir=0
		fav_clips_all_delimiter=0
		gosub,get_all_fav_clips
		
	MC_OwnChange:=1
	clipboard := full_text
	Gosub, MC_Paste
	sleep,150	
	MC_OwnChange:=0	
return



get_all_fav_clips:

	full_text =
	full_text2 =
	text2=
	if (fav_clips_all_delimiter)
		delimiter=`r`n`r`n
	else
		delimiter=`r`n
	
	Loop %MCF_clips_present%
	{	
		if (fav_clips_all_dir=1)
			n:=MCF_clips_present-a_index+1
		else
			n:=a_index
		text2 := MCF_Clip%id%_%n%
		full_text .=  text2 . delimiter
		
		stringleft,tmp_text,text2,100
		full_text2 .= n . " " . tmp_text . "..`n..`n" . delimiter
	}
	
stringtrimright,full_text,full_text,2
stringtrimright,full_text2,full_text2,2
truncated_text:=truncated_text(full_text2,700)

; sleep,1500
; keywait, Lbutton, D ,t2
; tooltip,
return
	
get_maxEntry()
{
	global 
	Loop  %MCF_MAX_Clips%
		  {
			 
			;StringLeft, MyText, MCF_Clip%id%_%A_Index%, 35 ;MCF_MaxLength

			if (MCF_Clip%id%_%A_Index% != "") 
		  		   MCF_clips_present :=a_index
			 
		  }
		  
; MCF_clips_present--
; MCF_clips_present:= MCF_clips_present
return
}


;==============
 CLIPSTEP2:
{
	GetKeyState,state_s,shift
	GetKeyState,state,CTRL
	If state=u
	{
	  If delete2=delete
	  { 
		readclip=MCF_Clip%id%_%MCF_activeclip%
		readclip:=%readclip%
		; Filedelete,%readclip%.clip
		tooltip=Deleting Clip %MCF_activeclip% / %MCF_clips_present%
		Gosub,TOOLTIP
		Gosub,INDEX
		Gosub,FINDPREV2

		
	  }
	  Else  If delete=all
	  {
		tooltip=Deleting all clips
		Gosub,TOOLTIP
		; Filedelete,*.clip
		MCF_clips_present=0
		MCF_activeclip=0
		MCF_Clip1=0
		Gosub,INDEX

		gosub,cancelCLIPSTEP2
				
	  }
	  Else If paste2=paste
	  {
		readclip=MCF_Clip%id%_%MCF_activeclip%
		readclip:=%readclip%
		StringLeft, MyText, readclip, 200
		tooltip=Pasting clip %MCF_activeclip%`n%MyText%
		Gosub,TOOLTIP
		Gosub,PASTECLIP2
		; MCF_activeclip+=clip_change
		ClipStep_Keys2:=0		
		gosub,cancelCLIPSTEP2
	  }
	  else
	  {
		settimer,removetooltip,-500
	  	tooltip,cancel
		gosub,cancelCLIPSTEP2
	  }
	  
	  delete2=no
	  paste2=no
	  
	}
	else If state_s=D
	{
		readclip=MCF_Clip%id%_%MCF_activeclip%
		readclip:=%readclip%
		StringLeft, MyText, readclip, 200
		tooltip=Copied clip %MCF_activeclip%`n%MyText%
		Gosub,TOOLTIP		
		sleep,1500
		; MCF_activeclip+=clip_change
		ClipStep_Keys2:=0		
		gosub,cancelCLIPSTEP2
	}
	
}

return
cancelCLIPSTEP2:
	ClipStep_Keys2:=0
	setTimer,CLIPSTEP2,off

	hotkey,<^s,off
	hotkey,<^f,off
	hotkey,^q,off

return


$^q::	; na
if  (ClipStep_Keys2) 
{

	tooltip=Cancel
	Gosub,TOOLTIP
	delete2=cancel
	paste2=yes

	ClipStep_Keys2:=0
	setTimer,CLIPSTEP2,off
	
	hotkey,^q,off
}
else
{
	send ^q
}
Return
		
$^g::		; na	
if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
if (ClipStep_Keys2)
{
	If paste2<>no
	{
	  If delete2=delete
	  {
		ToolTip,Delete all clips
		SetTimer,TOOLTIPOFF,Off
		delete2=all
		paste2=yes
		ClipStep_Keys2:=0
		Return
	  }
	  Else
	  If delete2=cancel
	  {
		If MCF_clips_present<1
		{
		  tooltip=No clip exists
		  Gosub,TOOLTIP
		  Return
		}
		readclip=MCF_Clip%id%_%MCF_activeclip%
		readclip:=%readclip%
		; FileRead,Clipboard,*c %readclip%.clip
		StringLeft,clip,Clipboard,100
		ToolTip,Delete Clip %MCF_activeclip% / %MCF_clips_present%`n%clip% 
		SetTimer,TOOLTIPOFF,Off
		delete2=delete
		paste2=yes
		
		Return
	  }
	  Else
	  {
		tooltip=Cancel
		Gosub,TOOLTIP
		delete2=cancel
		paste2=yes
		
		ClipStep_Keys2:=0
		
		setTimer,CLIPSTEP2,off
		Return
	  }
	}
}
else
{
;		Default action for the hotkey
}

Return

$<^f:: ; na
		tooltip=Cancel
		Gosub,TOOLTIP
	gosub,cancelCLIPSTEP2
return


;Previous
$<^s::	; na
	; MCF_clips_present:=10
	setTimer,CLIPSTEP2,100

	; ClipStep_Keys2:=1	;	 if not checking clipstepkeys2 ( direct trigger)
if (ClipStep_Keys2)
{
	; If paste<>no
	{
	  If MCF_clips_present<1
	  {
		tooltip=No clip exists
		Gosub,TOOLTIP
		delete2=no
		paste2=yes
		Return
	  }
	  Gosub,FINDPREV2
	  clip_change:=0
	  Gosub,SHOWCLIP2
	  delete2=no
	  paste2=paste
	  Return
	}
}
else
{
	;	Default action for the hotkey
	send ^s
}
Return
<^!d:: ; paste from first
GetKeyState, state_s, Shift
    GetKeyState, state_c, ctrl
    GetKeyState, state_A, alt
msgbox, %state_c% %state_S%
	MCF_activeclip:=0
	; tooltip,First
	ToolTip,1 / %MCF_clips_present%`nShift: copy F: cancel
	sleep,500
	gosub,fav_paste_next
Return

$<^d:: ; fav clipb paste next

if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
fav_paste_next:

	add_to_fav_also:=0
	setTimer,CLIPSTEP2,100
	If MCF_clips_present<1
	{
	  tooltip=No clip exists
	  Gosub,TOOLTIP
	  delete2=no
	  paste2=yes
	  Return
	}
	; If paste2<>no
	Gosub,FINDNEXT2
	Gosub,SHOWCLIP2
	delete2=no
	paste2=paste

	ClipStep_Keys2:=1

	hotkey,^q,on
	hotkey,<^s,on
	hotkey,<^f,on
Return

<^+d:: ; hist to favclips and paste
	tooltip,hist to favclips and paste
	sleep,350
	gosub,Copy_to_fav_clips
	MCF_activeclip=0
	gosub,fav_paste_next
	settimer,removetooltip,-1000

return

PASTECLIP2:
	MC_OwnChange:=1
	readclip=MCF_Clip%id%_%MCF_activeclip%
	readclip:=%readclip%
	Clipboard:=readclip
	; Send,^v
	
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	delete2=no
	paste2=no
	sleep,10
		sleep,150
	MC_OwnChange:=0
	clip_change:=1
Return

SHOWCLIP2:

	readclip=MCF_Clip%id%_%MCF_activeclip%
	readclip:=%readclip%
	clip2:=MCF_Clip%id%_%MCF_activeclip%
	If clip2=
	  clip2=... Image
	MyText=
	clip_length:=StrLen(clip2)
	stringclip_lines:=0
	loop,parse,clip2,`n,`r
		stringclip_lines++
	if(clip_length> 200)
	{
		StringLeft, MyText, clip2,200
		MyText=%MyText%...`n...
	}
	else
		MyText=%clip2%
	If ( MCF_activeclip = MCF_clips_present)	
		ToolTip,LAST %MCF_activeclip% / %MCF_clips_present%   lines: %stringclip_lines% chars: %clip_length%`nShift: copy F: cancel`n%MCF_activeclip% / %MCF_clips_present% %MyText%
	else
	{
		n := MCF_activeclip +1
		MyText .= "`n`n" . n . "/" . MCF_clips_present . ". " . SubStr(MCF_Clip%id%_%n%, 1, 100)  
		ToolTip,%MCF_activeclip% / %MCF_clips_present%    lines: %stringclip_lines% chars: %clip_length%`nShift: copy F: cancel`n%MyText%
	}
	SetTimer,TOOLTIPOFF,Off
	clip1=
	clip2=
Return

FINDNEXT2:
	If MCF_clips_present<1
	{
		tooltip=No clip exists
		Gosub,TOOLTIP
		delete2=no
		Return
	}
	MCF_activeclip+=1
	If ( MCF_activeclip > MCF_clips_present)
		MCF_activeclip:=1
Return

FINDPREV2:
	If MCF_clips_present<1
	{
		tooltip=No clip exists
		Gosub,TOOLTIP
		delete2=no
		paste2=yes
		Return
	}
MCF_activeclip-=1
If MCF_activeclip<1
  MCF_activeclip=%MCF_clips_present%
Return

;==============


 

add_to:
	 n:=A_ThisMenuItempos-1
	FileDelete, %fav_data_f%\%id%_%n%.clip 
  	FileAppend, %clipboard%, %fav_data_f%\%id%_%n%.clip 

	return
MCF_Select:
 
	GetKeyState, state_s, Shift
    GetKeyState, state_c, ctrl
    GetKeyState, state_A, alt
 
	item:=A_ThisMenuItemPos-4
	
	MCF_activeclip:=item
	MC_OwnChange:=1

	clipboard := MCF_Clip%id%_%Item%
	; msgbox,%MC_OwnChange%
  
		
	if state_s = D ; 
	{
		Gosub, MCF_Paste
		sleep,350
		MC_OwnChange:=0	
		send, {enter}
		
		return
	} 
	if state_c = D ; 
	{
			full_text =
			Loop %item%
			{
				text2 := MCF_Clip%id%_%A_Index%
				;text = %clipboard%`n%text2%
				full_text=%full_text%`n%text2%
			}
		clipboard := full_text
		Gosub, MCF_Paste
		sleep,350
		MC_OwnChange:=0	
		return
	} 
 /*	if state_s = D ;delete the file 
	{ 
		FileDelete, %fav_data_f%\%Item%.clip 	   
		return	
	}	
 */
 	if state_A = D ;copy over  the file 
	{ 
		FileDelete, %fav_data_f%\%Item%.clip  
		FileAppend, %clipboard%, %fav_data_f%\%Item%.clip 
		settimer,removetooltip,-500	
		tooltip, copied over`n`n %clipboard%
		return	
	}	

	 
	 
	  Gosub, MCF_Paste
	sleep,350
	  MC_OwnChange:=0	
	return
MCF_Paste:
	  ; Send, ^v
	  
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	return
MFhide:
 
return 

del_Fav_clips:
	Loop  %MCF_MAX_Clips%
	{
	 FileDelete, %fav_data_f%\%id%_%A_Index%.clip 
	 MCF_Clip%id%_%A_Index%=
	 }
	 MCF_clips_present:=0
	 MCF_activeclip:=0
	 
 Return 
 
 toggle_source:
 if id=id0
	id=1
 else id=id0
 Return
  

	 
;==========================================================================================
;Clipboard  history 
;========================================================================================== 


#IfWinnotActive, ahk_class dopus.lister
; <#5::
<#wheeldown:: Goto, MC_PasteMenu
#IfWinnotActive,
#PgUp:: Goto, MC_PasteAsText


MC_Paste:

	  ; Send, ^v
	  
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
return

MC_Cut:
	  ; As an example, my editor doesn't have ^x set to paste, but it does have
	  ; +{DEL}, so that's OK.
	  IfWinNotActive, Visual SlickEdit
		;Send, ^x
		
		send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-w")
	  Else
		Send, +{DEL}
return

Mhide:
	 
	return
MC_PasteMenu:
		SoundPlay %A_Windir%\Media\Windows Navigation Start.wav
		MyShow := false
		Menu, MC_Temp, Add
		Menu, MC_Temp, Delete
		Menu, MC_Temp, Add, hide C:all S: enter  CS:rev , Mhide
		Menu, MC_Temp, Add,^': clipb line by line listview , Mhide
		Menu, MC_Temp, Add,^-: open hist entries in gui , History_In_select_gui
		Menu, MC_Temp, Add,+f7:: search,clip_search_gui
		Menu, MC_Temp, Icon,+f7:: search,  Shell32.dll, 23 ,18				
		;Menu, MC_Temp, Color, C0C0C0 [, Single] 
		Menu, MC_Temp, Add
		; msgbox,MC_Clip%1%`n`n`nMC_Clip%2%`n`n`nMC_Clip%3%`n`n`nMC_Clip%4%`n`n`nMC_Clip%5%`n`n`nMC_Clip%6%`n`n`nMC_Clip%7%`n`n`nMC_Clip%8%`n`n`nMC_Clip%9%`n`n`nMC_Clip%10%`n`n`nMC_Clip%11%`n`n`nMC_Clip%12%`n`n`nMC_Clip%13%`n`n`nMC_Clip%14%`n`n`nMC_Clip%15%`n`n`n
		Loop %MC_Clips_present%
		  {
			; Get the next entry.  Display at most MC_MaxLen if it's a long clipboard.
			StringLeft, MyText, MC_Clip%A_Index%, MC_MaxLen
			stringreplace,MyText,MyText,%A_Tab%,%A_Space%%A_Space%%A_Space%,All
			; Add this clip to the menu if it isn't blank.
			
			if (MyText <> "")
			{
				if ( A_Index < Clips_shown+1 )
				{
					Menu, MC_Temp, Add, %A_Index%.    %MyText%, MC_Select	
					if (A_index =contPaste) 
						Menu, MC_Temp, Icon, %A_Index%.    %MyText%, Shell32.dll, 295,22
					else

						Menu, MC_Temp, Icon, %A_Index%.    %MyText%, Shell32.dll, 294 ,22				
				}
				MyShow := true
				MC_Clips_present:=A_Index
			}			
		  }
			  
		
		Menu, MC_Temp, Add, 
		/*
		
		StringLeft, MyText, clipboard, 35 
		
		Menu, MC_Temp, Add,clipb : %MyText%, nil
		Menu, MC_Temp, Icon,clipb : %MyText%, Shell32.dll, 135 ,28
				;;append clipB
		FileRead, copieddata, %HIST_data_f%\append.txt
		StringLeft, MyText, copieddata, MC_MaxLen
		Menu, MC_Temp, Add
		if (MyText ="")
		{
		mytext=EMPTY
		Menu, MC_Temp, Add,  %MyText%, append
		;Menu, MC_Temp, Icon, %MyText%, Shell32.dll, 149 ,28
		}
		else 
	    {
			Menu, MC_Temp, Add,  view appended: %MyText%, append
			Menu, MC_Temp, Icon, view appended: %MyText%, Shell32.dll, 149 ,28
		}
		*/
		; Now show the menu, provided there's at least one thing on it.
		Menu, MC_Temp, Add, copy to FAV clips , Copy_to_fav_clips
		Menu, MC_Temp, Icon, copy to FAV clips ,Shell32.dll, 236,22
		Menu, MC_Temp, Add, del all , del_history
		Menu, MC_Temp, Icon,del all, Shell32.dll, 110 ,18	
		Menu, MC_Temp, Color, F0ABCC,single 
		if (MyShow)
			Menu, MC_Temp, Show
		return
append:
	if(GetKeyState("CTRL" , "P")) 
	   { 	  
			settimer,removetooltip,-1000
			tooltip, ctrl
	   }
	 else  if(GetKeyState("Shift" , "P")) 
	   { 
			 settimer,removetooltip,-1000
			 tooltip, shift
		  return 
	   } 
	 else  if(GetKeyState("LWIN" , "P")) 
	   { 
			  settimer,removetooltip,-1000
			  tooltip, lwin 
		  return 
	   } 
   
    else 
      {  
		ToolTip, %copieddata%
		keywait, Lbutton, D ,t2
			ToolTip, 
	return
	} 
	MC_PasteNext: 
		  ; We need to grab the selected text.  We do this using cut.
		  ; We don't want this copy to affect the real clipboard or our ring, so turn
		  ; off tracking the clipboard.
		  MC_OwnChange := true
		  MySaveClip := ClipboardAll
		  Gosub, MC_Cut
		  MyMatchText := clipboard

		  ; The original clipboard is the "default" if we don't find anything better.
		  clipboard := MC_Clip1

		  Loop %MC_Clips_present%
		  {
			if (MC_Clip%A_Index% = MyMatchText)
			{
			  MyUseIndex := A_Index+1
			  MyText := MC_Clip%MyUseIndex%
			  if (MyText <> "")
				clipboard := MyText
			  Break
			}
		  }

		  ; Paste.  This is the next clipboard if we found one, or the original
		  ; clipboard if not.
		  Gosub, MC_Paste

		  ; Restore the first clipboard and continue tracking clipboard changes
		  clipboard := MySaveClip
		  	sleep,150	
		  MC_OwnChange := false
		return

		; Paste the current clipboard as plain text.
	MC_PasteAsText:
		MC_OwnChange:=1
		  clipboard := clipboard
		  Gosub, MC_Paste
		  		  	sleep,150	
		  	MC_OwnChange:=0	
		return

	MC_Select: 
	GetKeyState, state_s, Shift
    GetKeyState, state_c, ctrl
    GetKeyState, state_A, alt
	
	item:=A_ThisMenuItemPos-5
	contPaste:=item

 ; sleep,1000
	if ( (state_s = "D" ) &&  (state_c <> "D" ) ) ; 
	{
		Gosub, MC_Paste
		send, {enter}
		return
	} 
	else if ( (state_c = "D" ) &&  ( state_s <> "D" ) ) ; 
	{

			full_text =
			n:=item-1
			full_text:= MC_Clip1	
			Loop %n% {

					p:=a_index+1
					text2 := MC_Clip%p%
					full_text=%full_text%`n%text2%
		
					}
					; msgbox,%full_text%
		MC_OwnChange:=1
		clipboard := full_text
		Gosub, MC_Paste
				  	sleep,150	
		MC_OwnChange:=0	
		return
	}
	
	else if  ( (state_c = "D" ) &&  (state_s = "D" ) ) ; 
	{
			full_text =
			n:=item-1
			full_text:= MC_Clip1	
			Loop %n% {
					p:=a_index+1
					text2 := MC_Clip%p%
					full_text=%text2%`n%full_text%	; reversed
					}
		MC_OwnChange:=1			
		clipboard := full_text
		Gosub, MC_Paste
				  	sleep,150	
		MC_OwnChange:=0
		return
	
	}

else 
{
	MC_OwnChange:=1
	clipboard := MC_Clip%Item%
			  	sleep,150	
	MC_OwnChange:=0	
}
	Gosub, MC_Paste



ONCLIPBOARDCHANGE:
if (MC_OwnChange)		  ; Ignore the change if we made it ourself, or if the clipboard doesn't
	return

	try {
		DllCall("OpenClipboard", "int", "")
		DllCall("CloseClipboard")
	}
	catch {
		MsgBox, 16, WARNING, % "Clipjump just now encountered an Error. `nIt will try to change internal settings to avoid the error in the future.`n"	;	%
							. "Sorry for the inconvenience."
		safeSleepTime +=50
	}

	GetClipboardFormat(0)
	clipChange(A_EventInfo)
	
return


clipChange(ClipErrorlevel)
{
	If ClipErrorlevel = 1
	{	
		gosub,add_to_hist
	}
	else If ClipErrorlevel = 2
	{
		tooltip,bmp
		; thumbGenerator()	
		; showPreview()
	}
	else 
	{
		; tooltip,??
		; thumbGenerator()	
		; showPreview()
	}
	sleep, 500
	gui ,48: hide
	ToolTip
}
		
add_to_hist:
	if (add_to_fav_also)
	{
		selText :=clipboard
		if (add_to_fav_also_pos=1)
		{
			gosub,Ffirst_slot
			added_slot:=1
		}
		else
		{
			gosub,MCF_next_slot
			added_slot:=MCF_clips_present
		}
	}
	StringCaseSense on
	; msgbox,%clipboard%
 If  (MC_Clip1==Clipboard)
	{		
		; sleep,30
		tooltip,Same selection done
		settimer,removetooltip,400
		; tooltip,
	
		return
	}
	else
	{
		if (MC_Clips_present<MC_MAX_Clips)
			MC_Clips_present+=1
	}
	

	

	; if (ErrorLevel <> 1)
			; return

		  ;MsgBox % "New " . clipboard . "  Old " . MC_Clip%MC_Index%

		  ; Save the old array.
		  Loop %MC_Clips_present% {
			MySaveClip%A_Index% := MC_Clip%A_Index%
			;FileRead, MC_Clip%A_Index%, data\%id%_%A_Index%.clip    ; reads from file
			}
		  ; Put the new value af the front.
		  MC_Clip1 := clipboard

		  ; Copy the old array to the new, but exclude any duplicates of the new
		  ; entry.
		  MyNewIndex := 2
		  Loop %MC_Clips_present%
		  {
			if (MySaveClip%A_Index% <> MC_Clip1)
			{
			  MC_Clip%MyNewIndex% := MySaveClip%A_Index%
			  MyNewIndex := MyNewIndex + 1
			 /* ;;;also writing a copy to file
				  FileDelete, data\%id%_%A_Index%.clip 
				  data:=MC_Clip%A_Index%
				  FileAppend, %data%, data\%id%_%A_Index%.clip 
				  */
			  ; If we run out of space, stop - the oldest entry is lost.
			   
			  if (MyNewIndex > MC_Clips_present)
				Break
			}
		  }
		 
		  
		 MyText:=Clipboard
		t:=no_of_lines(MyText)
		t2:=strlen(MyText)
		MyText=%t2% %t%`n%MyText%
		if(StrLen(MyText)>200)
		{
			StringLeft, MyText, MyText,200
			MyText=%MyText%`n`n...`n...`n...`n...
		}
		; msgbox,%MyText%
		if (add_to_fav_also)
		{
			; MCF_clips_present++				
			settimer,removetooltip,-1600
			tooltip,[fav sync %MCF_clips_present%]`n%MyText%
		}
		else
		{
			settimer,removetooltip,-1100
			tooltip,%MyText%
		}
StringCaseSense off
return

del_history:
loop,%MC_Clips_present%
{
	MC_Clip%a_Index% =
}

return

CLIPSTEP:
{
	GetKeyState,state_s,shift
	GetKeyState,state,CTRL
	If state=u
	{
	  If delete=delete
	  { 
		readclip=MC_Clip%activeclip%
		readclip:=%readclip%
		Filedelete,%readclip%.clip
		tooltip=Deleting Clip %activeclip% / %MC_Clips_present%
		Gosub,TOOLTIP
		Gosub,INDEX
		Gosub,FINDPREV

	  }
	  Else  If delete=all
	  {
		tooltip=Deleting all clips
		Gosub,TOOLTIP
		Filedelete,*.clip
		MC_Clips_present=0
		activeclip=0
		MC_Clip1=0
		Gosub,INDEX
		activeclip=%MC_Clips_present%
		; gosub,Hotkeys_OFF
		ClipStep_Keys:=0
		
	  }
	  Else If paste=paste
	  {
		readclip=MC_Clip%activeclip%
		readclip:=%readclip%
		StringLeft, MyText, readclip, 200
		tooltip=Pasting clip %activeclip%`n%MyText%
		Gosub,TOOLTIP
		Gosub,PASTECLIP
		ClipStep_Keys:=0
		activeclip=1
		; gosub,Hotkeys_OFF
		setTimer,CLIPSTEP,off
	  }
	  delete=no
	  paste=no
	  ; ClipStep_Keys:=0
	}
	else If state_s=D
	{
		readclip=MC_Clip%activeclip%
		readclip:=%readclip%
		clipboard:=readclip
		StringLeft, MyText, readclip, 200
		tooltip=copied hist clip %activeclip%`n%MyText%
		Gosub,TOOLTIP
		sleep,1500
		ClipStep_Keys:=0
		setTimer,CLIPSTEP,off
		delete=no
		paste=no
	}
}

return

$^c::		;delete  ; na

if (ClipStep_Keys)
{
	If paste<>no
	{
	  If delete=delete
	  {
		ToolTip,Delete all clips
		SetTimer,TOOLTIPOFF,Off
		delete=all
		paste=yes
		ClipStep_Keys:=0
		Return
	  }
	  Else
	  If delete=cancel
	  {
		If MC_Clips_present<1
		{
		  tooltip=No clip exists
		  Gosub,TOOLTIP
		  Return
		}
		readclip=MC_Clip%activeclip%
		readclip:=%readclip%
		FileRead,Clipboard,*c %readclip%.clip
		StringLeft,clip,Clipboard,100
		ToolTip,Delete Clip %activeclip% / %MC_Clips_present%`n%clip% 
		SetTimer,TOOLTIPOFF,Off
		delete=delete
		paste=yes
		
		Return
	  }
	  Else
	  {
		tooltip=Cancel
		Gosub,TOOLTIP
		delete=cancel
		paste=yes
		
		ClipStep_Keys:=0
		
		setTimer,CLIPSTEP,off
		Return
	  }
	}
}
else
{

;	copy action
	; Send,^c
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("A-w")
/*
	; clip1:=ClipboardAll
	clip1:=Clipboard
	Clipboard=
	sleep,50
	
	clip2:=ClipboardAll
	If clip2=
	{
	  tooltip=Empty selection
	  Gosub,TOOLTIP
	}
	Else If clip1<>%clip2%
	{
		MyText:=Clipboard
		if(StrLen(clip2)>200)
			{
				StringLeft, MyText, MyText,200
				MyText=%MyText%`n`n...`n...`n...`n...
			}
	  tooltip=%MyText%
	  Gosub,TOOLTIP
	  Gosub,ADDCLIP
	  ; Gosub,INDEX
	}
	Else
	{
	  tooltip=Same selection
	  Gosub,TOOLTIP
	}
	clip1=
	clip2=
	
	*/
}
	/*
	;	cut command
	clip1:=ClipboardAll
	Clipboard=
	Send,^x
	ClipWait,1
	clip2:=ClipboardAll
	If clip2=
	{
	  tooltip=Empty selection
	  Gosub,TOOLTIP
	}
	Else
	If clip1<>%clip2%
	{
	  tooltip=Copying to clip 1
	  Gosub,TOOLTIP
	  Gosub,ADDCLIP
	  Gosub,INDEX
	}
	Else
	{
	  tooltip=Same selection
	  Gosub,TOOLTIP
	}

	clip1=
	clip2=
	*/
Return


 
$^v::	; na
setTimer,CLIPSTEP,100
LASTFORMAT := GetClipboardFormat(1)
if ( LASTFORMAT <>"[Text]")
	{	
		; send,^v
		
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
		return
	}
if (ClipStep_Keys)
{
	If paste<>no
	{
	  If MC_Clips_present<1
	  {
		tooltip=No clip exists
		Gosub,TOOLTIP
		delete=no
		paste=yes
		Return
	  }
	  Gosub,FINDPREV
	  Gosub,SHOWCLIP
	  delete=no
	  paste=paste
	  Return
	}
}
else
{
	;	paste action
; Send,^v
	delete=no
	paste=paste

	/*
	clip1:=ClipboardAll
	Clipboard=
	Send,^c
	clip2:=ClipboardAll
	If clip2=
	{
	  tooltip=Empty selection
	  Gosub,TOOLTIP
	}
	Else
	If clip1<>%clip2%
	{
	  tooltip=Copying to clip 1
	  Gosub,TOOLTIP
	  Gosub,ADDCLIP
	  Gosub,INDEX
	}
	Else
	{
	  tooltip=Same selection
	  Gosub,TOOLTIP
	}
	clip1=
	clip2=
	*/
}
Return

$<^b::	; na
	
	if trigger_if_triggered_by_emacs_script_else_proceed("LCtrl")
		return
	
	
	setTimer, CLIPSTEP,100
	; msgbox,%MC_Clips_present%
	If MC_Clips_present<1
	{
	  tooltip=No clip exists
	  Gosub,TOOLTIP
	  delete=no
	  paste=yes
	  Return
	}
	If paste<>no
		Gosub,FINDNEXT
	Gosub,SHOWCLIP
	delete=no
	paste=paste

	ClipStep_Keys:=1
	; hotkey,$^c,on
	; hotkey,$^v,on
Return

ADDCLIP:
	readclip=MC_Clip1
	readclip:=%readclip%
	lastclip=%readclip%
	lastclip+=1
	MC_Clips_present+=1
	activeclip=1
	/*
	IfExist,%lastclip%.clip
	  FileDelete,%lastclip%.clip
	FileAppend,%ClipboardAll%,%lastclip%.clip
	*/
	; MC_Clip1:=Clipboard
Return


SHOWCLIP:

	readclip=MC_Clip%activeclip%
	readclip:=%readclip%
	; msgbox,%readclip%

	; clip1:=ClipboardAll

	/*
	IfExist,%readclip%.clip
	  FileRead,Clipboard,*c %readclip%.clip
	  */
	; Clipboard:=readclip
	; StringLeft,clip2,Clipboard,300
	clip2:=MC_Clip%activeclip%
	If clip2=
	  clip2=empty / Image
	MyText=
	; msgbox, % StrLen(clip2)
	clip_length:=StrLen(clip2)
	stringclip_lines:=0
	loop,parse,clip2,`n,`r
		stringclip_lines++
	if(clip_length> 200)
	{
		StringLeft, MyText, clip2,200
		MyText=%MyText%...`n...
	}
	else
	MyText=%clip2%

	ToolTip, %activeclip% / %MC_Clips_present%  lines: %stringclip_lines% chars: %clip_length%`n%MyText%
	SetTimer,TOOLTIPOFF,Off
	; Clipboard:=clip1
	clip1=
	clip2=
Return
 

PASTECLIP:
	MC_OwnChange:=1
	readclip=MC_Clip%activeclip%
	readclip:=%readclip%
	/*
	IfExist,%readclip%.clip
	  FileRead,Clipboard,*c %readclip%.clip
	*/
	Clipboard:=readclip
	; Send,^v
	
	send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
	delete=no
	paste=no
			  	sleep,150	
	MC_OwnChange:=0
Return

DELETECLIP:
	delete=no
	paste=no
Return


TOOLTIP:
	ToolTip,%tooltip%
	SetTimer,TOOLTIPOFF,-900
Return


TOOLTIPOFF:
	ToolTip,
	SetTimer,TOOLTIP,Off
Return


INDEX:	;	load previous clipboard history items saved on last exit
/*
filelist=
Loop,*.clip
{
  StringTrimRight,filename,A_LoopFileName,5
  filelist=%filelist%%filename%`n
}
StringTrimRight,filelist,filelist,1
Sort,filelist,N R
StringSplit,MC_Clip,filelist,`n
MC_Clips_present=%MC_Clip0%
; read from *.clip
Loop,%MC_Clips_present%
{
fileread,MC_Clip%A_Index%,%A_Index%.clip
}
*/

Return

FINDNEXT:
  If MC_Clips_present<1
  {
    tooltip=No clip exists
    Gosub,TOOLTIP
    delete=no
    paste=yes
    Return
  }
activeclip+=1
If activeclip>%MC_Clips_present%
  activeclip=1
Return


FINDPREV:
  If MC_Clips_present<1
  {
    tooltip=No clip exists
    Gosub,TOOLTIP
    delete=no
    paste=yes
    Return
  }
	activeclip-=1
	If activeclip<1
	  activeclip=%MC_Clips_present%
Return



GetClipboardFormat(type=1){		;Thanks nnnik
	Critical, On

 	DllCall("OpenClipboard", "int", "")
 	while c := DllCall("EnumClipboardFormats","Int",c?c:0)
		x .= "," c
	DllCall("CloseClipboard")

	if type
  		if Instr(x, ",1") and Instr(x, ",13")
    		return "[Text]"
 		else If Instr(x, ",15")
    		return "[File/Folder]"
    	else
    		return ""
    else
    	return x
}

showPreview(){
	static scrnhgt := A_ScreenHeight / 2.5 , scrnwdt := A_ScreenWidth / 2 , displayH , displayW

	; if FileExist(A_ScriptDir "\" THUMBS_dir "\" TEMPSAVE ".jpg")

	; /*
	{
		GDIPToken := Gdip_Startup()
		pBM := Gdip_CreateBitmapFromFile( A_ScriptDir "\clipboard_preview2.jpg")
		widthOfThumb := Gdip_GetImageWidth( pBM )
		heightOfThumb := Gdip_GetImageHeight( pBM )
		Gdip_DisposeImage( pBM )                                         
		Gdip_Shutdown( GDIPToken )

		if heightOfThumb > %scrnHgt%
			displayH := heightOfThumb / 2
		else displayH := heightofthumb
		if widthOfThumb > %scrnWdt%
			displayW := widthOfThumb / 2
		else displayW := widthOfThumb

		GuiControl, 48: , imagepreview, *w%displayW% *h%displayH% %A_ScriptDir%\clipboard_preview2.jpg
		MouseGetPos, ax, ay
		ay := ay + (scrnHgt / 8)
		Gui, 48:  Show, x%ax% y%ay% h%displayh% w%displayw%, Display_Cj
	}
	; */
	
}

#include C:\cbn_gits\AHK\paste collector\Gdip_All.ahk

thumbGenerator() {
	ClipWait, , 1
	Gdip_CaptureClipboard(A_ScriptDir "\clipboard_preview2.jpg", 90)
}


;Gdip_CaptureClipboard()
;	Captures Clipboard to file

Gdip_CaptureClipboard(file, quality)
{
	PToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromClipboard()
	Gdip_SaveBitmaptoFile(pBitmap, file, quality)
	Gdip_DisposeImage( pBitmap )
	Gdip_Shutdown( PToken)
return
}

Hotkeys_OFF:

	hotkey,$^c,off
	hotkey,$^v,off

return

clipselect_gui:

	clipselect_gui_name=clipselect
	clipselect_gui_number := 45

	searchfiles=%A_ScriptDir%\allclips.clip

	; #include C:\cbn_gits\AHK\auto search template\auto search func.ahk

	Gui, %clipselect_gui_number%:    +AlwaysOnTop  +border +LastFound 	 +toolwindow   -caption 	;	+resize 

	Gui, %clipselect_gui_number%:   add,Edit,x0  y0 vvisibleSchStr_567 r1 h39 w200 hWndEd1  +0x100,search	; -WantReturn

	Gui, %clipselect_gui_number%:  add,Button,x+0  w40 gdel_schstr ,X
	Gui, %clipselect_gui_number%:  add,text,x+10  cgreen, Shift:: copy  Ctrl:: paste full clip entry
	Gui, %clipselect_gui_number%:  add,Button,xp+160  w40 ghide_searchGui ,X
	Gui,  %clipselect_gui_number%: font,s11 
	Gui, %clipselect_gui_number%:  Add, ListView, x0 y+0 w600 r10 h200 vResultList_567 hwndList gListEvent   AltSubmit,clip#|match|clip|line#

return

;============================================================
IncrementalSearch_567(gui_number)
{
	global
	Gui,%gui_number%: Submit, NoHide
	CurFilename = %visibleSchStr_567%

	If NewKeyPhrase <> %CurFilename%	
	{	
		SEARCH(gui_number)
		NewKeyPhrase = %CurFilename%
		;Sleep, 100 ; DON'T HOG THE CPU!
	}
	Else
	{
		; QUERY STRING HAS STOPPED CHANGING
		;Break
	}
Return
}

;=========================== SEARCH =================================
SEARCH(gui_number)
{
	global

	Gui, %gui_number%: Submit, NoHide
	Gui, %gui_number%: default
	SchStr:=visibleSchStr_567

	StopSearch=0
	search_in_progress := 1
	LV_Delete()
	if (SchStr = "")							;if empty query
	{
		Loop %tot_search_items% 
		{
			stringleft,a,%search_array%%A_Index%,100
			stringreplace,a,a,`n,%A_space%%A_space%,all
			LV_Add("",a_index,a)
		}
			Goto,StopSearch
		return
	}

	GuiControl, %gui_number%:  Show, ResultList_567
	FilesMatch=0
	SchStr=i)%SchStr%
	matchlist=
	tot_chars_searched:=0
	Loop %tot_search_items% 
	{
		; allclips.=   "`n" . MC_Clip%A_Index%		
		; Loop, Parse, searchfiles,`n`r
		; {
		; tooltip,%tot_chars_searched%
		all:=%search_array%%A_Index%
		tot_chars_searched += strlen(all)
		if (tot_chars_searched>100000)
			{
				stringleft,all,all,300
				; msgbox,zzzz %a_Index%
			}
	; msgbox,%all%
		search_index:=a_index
		loop,parse,all,`n,`r
		{
			if RegExMatch(a_loopfield,SchStr)
			{
				stringleft,a,all,100
				stringleft,b,A_LoopField,50
				stringreplace,a,a,`n,%A_space%%A_space%,all
				LV_Add("",search_index,b,a,a_index)
			}
		}		
	}
	
	tot_chars_searched=
;============;;
STOPSEARCH:  ;;
;============;;

	Oldschstr:=schstr
	/*
	matchlist:=regexreplace(matchlist,"m)^\n","")	

	Loop, Parse, matchlist,`n,`r
	{
		LV_Add("",A_LoopField)
		; msgbox,%matchlist%
	}
	*/
	Guicontrol, %gui_number%: Show, ResultList_567 
	; Guicontrol, Show, ResultList_567 
	; Guicontrol, , ResultList_567,r8
	Guicontrol, %gui_number%: , ResultList_567,r8
	LV_ModifyCol() 
	LV_ModifyCol(1,"AutoHdr")
	LV_Modify(1, "Select")

return
}

del_schstr(gui_number)
{
	Guicontrol,%gui_number%:  ,visibleSchStr_567,
	return
}

return

clip_search_gui:	;	clip hist in listview
	search_array=MC_Clip
	tot_search_items:=MC_Clips_present
	goto,search_gui
	return

fav_search:
	search_array=MCF_Clip%id%_
	tot_search_items:=MCF_clips_present
	goto,search_gui
	return
	
search_gui:
	OnMessage(0x200, "WM_MOUSEMOVE")   

	MouseGetPos, ax, ay
	ay:=ay-12
	ax:=ax-16
	if ax>900
		ax:=900
	if ay>500
		ay:=500
	ax+=10
	allclips=
	Gui, %clipselect_gui_number%: Show , x%ax% y%ay% w600 h225,%clipselect_gui_name%

	Guicontrol, %clipselect_gui_number%: Focus,visibleSchStr_567
	Guicontrol, %clipselect_gui_number%: ,visibleSchStr_567,	;	search clip history
	SendMessage, ( EM_SETSEL := 0xB1 ), 0, -1, , ahk_id %ED1%	;preselects the text
	SEARCH(clipselect_gui_number)
	SetTimer, IncrementalSearch_567, 600
	hotkey,esc,on
	settimer,checkactive,100
return
IncrementalSearch_567:

	IncrementalSearch_567(clipselect_gui_number)
	LV_Modify(1, "Select") 
	; LV_ModifyCol(1, 250)
	selected:=1	
	LV_GetText(Selected_text,LV_GetNext(),1)
return



;======================= ListEvent =====================================
ListEvent:
	GetKeyState, state_s, Shift
	GetKeyState, state_c, ctrl

	
	if (A_GuiEvent = "DoubleClick")
	{

	}
	if (A_GuiEvent = "normal")
	{
	
		Gui, %clipselect_gui_number%: Default
		Gui, %clipselect_gui_number%: ListView, List
		selected:=LV_GetNext()
		if (selected > 0 and selected !="")
		{
			LV_GetText( Selected_text , LV_GetNext(),2)			
			Gui, %clipselect_gui_number%: hide
			sleep,100 
			MC_OwnChange:=1
			if state_s= D ; 
			{	
				ClipBoard = %Selected_text% 
				settimer,removetooltip,-550
				tooltip,copied line`n`n%ClipBoard%
			}
			else if state_C= D ; 
			{
				LV_GetText(Selected_clip, LV_GetNext(),1)
				ClipBoard := %search_array%%Selected_clip%
				Selected_clip=
				; send ^v			
				send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
			}
			else
			{
				ClipBoard = %Selected_text%  
				; send ^v
				send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
			}

			MC_OwnChange:=0
		}

	}
	else If (A_GuiEvent = "K" )
	{
	

	}
Return

del_schstr:
	del_schstr(clipselect_gui_number)
Return

checkactive:
	IfWinNotActive, ahk_class AutoHotkeyGUI
	{
		settimer,checkactive,off
		gosub,hide_searchGui
	}
return

esc::	; na
	gosub,hide_searchGui
return

hide_searchGui:
	hotkey,esc,off
	Gui, %clipselect_gui_number%: hide
	Gui,3:  hide
	SetTimer, IncrementalSearch_567, off
	OnMessage(0x200, "WM_MOUSEMOVE", 0)  
return

#IfWinActive, clipselect
^enter::
+enter::
Enter::	; na
	getkeystate,state_S, shift
	getkeystate,state_C, ctrl
	; selected:=LV_GetNext()
	if (selected >0)
	{
		; guicontrol, %clipselect_gui_number%: listview,ResultList_567
		Selected_text=
		Gui, %clipselect_gui_number%: Default
		Gui, %clipselect_gui_number%: ListView, List
		LV_GetText(Selected_text, LV_GetNext(),2)
		Gui, %clipselect_gui_number%: hide
		sleep,100 
		MC_OwnChange:=1
		if state_s= D ; 
		{					
			ClipBoard = %Selected_text%  
			settimer,removetooltip,-550
			tooltip,copied line`n`n%ClipBoard%
		}
		else if state_C= D ; 
		{
			LV_GetText(Selected_clip, LV_GetNext(),1)
			ClipBoard := %search_array%%Selected_clip%
			Selected_clip=
			; send ^v			
			send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
		}
		else
		{
			settimer,removetooltip,-550
			tooltip,copied`n`n%ClipBoard%
			ClipBoard = %Selected_text% 
			; send ^v	
			send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
		}
		sleep,150	
		MC_OwnChange:=0
	}
return

up::	; na
	Gui, %clipselect_gui_number%: Default
	Gui, %clipselect_gui_number%: ListView, List
	selected:=LV_GetNext()
	if (selected=1)
		return
	selected-=1
	LV_Modify(0, "-Select")
	LV_Modify(selected, "Select")  
	LV_Modify(selected, "Vis")
	LV_GetText(FilePath,LV_GetNext(),4)
return

down::	; na
	Gui, %clipselect_gui_number%: Default
	Gui, %clipselect_gui_number%: ListView, List
	; guicontrol,%clipselect_gui_number%: focus,LVResults
	selected:=LV_GetNext()
	selected+=1
	LV_Modify(0, "-Select")
	LV_Modify(selected, "Select")  
	LV_Modify(selected, "Vis")
	LV_GetText(FilePath,LV_GetNext(),4)
return	
	
#IfWinActive

	

open_in_csvQF:

; selText:=Get_Selected_Text()
temp_CSVfile=%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\~temp.csv
filedelete,%temp_CSVfile%
fileappend,%all%,%temp_CSVfile%
run,%A_Script_Drive%\cbn\ahk\Plugins\csv quick filter\CSVQF.ahk "%temp_CSVfile%" "`,"
gui,hide
; gui,minimize
tooltip, opening in csv quick filter
sleep,500
tooltip

return


WM_MOUSEMOVE(wParam, lParam, msg, hwnd)	;	for tooltip
{
	global
	If(hwnd = List)	;	only if the mouse moved over the listview
	{	
		; Gui, %clipselect_gui_number%: default
		; Gui, %clipselect_gui_number%: ListView, List
		LV_MouseGetCellPos(LV_CurrRow, LV_CurrCol, List)
	; tooltip,aaa g:%clipselect_gui_number% c:%LV_CurrCol% r:%LV_CurrRow%
		If(oldLV_CurrRow != LV_CurrRow)	;if it has changed
		{	oldLV_CurrRow := LV_CurrRow
	msgbox
			ToolTip,,,, 20
			counter := A_TickCount + 500
			Loop	;loop for 500 ms and cancel tip if row changed
			{	LV_MouseGetCellPos(LV_CurrRow, LV_CurrCol, List)
				IfNotEqual, oldLV_CurrRow, %LV_CurrRow%
				{	SetTimer, KillNow, -1
					Return
				}
				looper := A_TickCount
				IfGreater, looper, %counter%, Break
				sleep, 150
			}
			; LV_GetText(txt1, LV_currRow, 1)
			
			LV_GetText(txt2, LV_currRow, 2)
			txt1:=MC_Clip%txt2%
			SetTimer, killTip, 500
			if(StrLen(txt1)>500)
			{
				StringLeft, MyText, txt1,500
				MyText .= "`n`n.........`n.........`n.........`n........."
			}
			else
				MyText:=txt1
			
			ToolTip,#%txt2%:`n%MyText%,,,20
		}
		Return
		killTip:
			killTipCounter++
			MouseGetPos, , , outWm, outK, 2
			If(outK != List) or (killTipCounter >= 8)	;500ms*8 = ~4 secs
			{	;this lets us kill the tooltip immediately
				KillNow:
					SetTimer, killTip, Off
					ToolTip,,,, 20
					killTipCounter=0
				Return
			}
		Return
	}
	Else	;if not over lv, destroy tip
	{	SetTimer, killTip, -1	;go now once
	}
}



GuiClose:
	gui,hide
return

ExitSub:

	; save favclips on exit
	loop, %tot_clip_containers% {
		t_id:=a_index
		Loop %MCF_MAX_Clips%
			{
				; FSaveClip%A_Index% := MCF_Clip%t_id%_%A_Index%
				;	load saved favclips on last exit
				Filedelete, %fav_data_f%\%t_id%_%A_Index%.clip
				if (MCF_Clip%t_id%_%A_Index%<>"" )
					{
						a:=MCF_Clip%t_id%_%A_Index%
						Fileappend,%a%, %fav_data_f%\%t_id%_%A_Index%.clip
					}
			}
	}
   ExitApp
Return


LV_MouseGetCellPos(ByRef LV_CurrRow, ByRef LV_CurrCol, List)
{	
	LVIR_LABEL = 0x0002					;LVM_GETSUBITEMRECT constant - get label info
	LVM_GETITEMCOUNT = 4100			;gets total number of rows
	LVM_SCROLL = 4116						;scrolls the listview
	LVM_GETTOPINDEX = 4135			;gets the first displayed row
	LVM_GETCOUNTPERPAGE = 4136	;gets number of displayed rows
	LVM_GETSUBITEMRECT = 4152		;gets cell width,height,x,y
	ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %List%	;get info on listview

	SendMessage, LVM_GETITEMCOUNT, 0, 0, , ahk_id %List%
	LV_TotalNumOfRows := ErrorLevel	;get total number of rows
	SendMessage, LVM_GETCOUNTPERPAGE, 0, 0, , ahk_id %List%
	LV_NumOfRows := ErrorLevel	;get number of displayed rows
	SendMessage, LVM_GETTOPINDEX, 0, 0, , ahk_id %List%
	LV_topIndex := ErrorLevel	;get first displayed row
	
	CoordMode, MOUSE, RELATIVE
	MouseGetPos, LV_mx, LV_my
	LV_mx -= LV_lx, LV_my -= LV_ly
	
	VarSetCapacity(LV_XYstruct, 16, 0)	;create struct
	Loop,% LV_NumOfRows + 1	;gets the current row and cell Y,H %
	{	LV_which := LV_topIndex + A_Index - 1	;loop through each displayed row
		NumPut(LVIR_LABEL, LV_XYstruct, 0)	;get label info constant
		NumPut(A_Index - 1, LV_XYstruct, 4)	;subitem index
		SendMessage, LVM_GETSUBITEMRECT, %LV_which%, &LV_XYstruct, , ahk_id %List%	;get cell coords
		LV_RowY := NumGet(LV_XYstruct,4)	;row upperleft y
		LV_RowY2 := NumGet(LV_XYstruct,12)	;row bottomright y2
		LV_currColHeight := LV_RowY2 - LV_RowY ;get cell height
		If(LV_my <= LV_RowY + LV_currColHeight)	;if mouse Y pos less than row pos + height
		{	LV_currRow  := LV_which + 1	;1-based current row
			LV_currRow0 := LV_which		;0-based current row, if needed
			;LV_currCol is not needed here, so I didn't do it! It will always be 0. See my ListviewInCellEditing function for details on finding LV_currCol if needed.
			LV_currCol=0
			Break
		}
	}
	; tooltip,aaa g:%clipselect_gui_number% c:%LV_CurrCol% r:%LV_CurrRow%
	sleep,300
}



;;;;;;;;;;;;;;;;;;;;;;;;	CLIP GUI	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clip_gui_this:
	clip_gui_item:=1
	tmp_txt:=MC_Clip%clip_gui_item%
	line:=MC_Clip%clip_gui_item%
	gosub,clip_gui
return

clip_gui_prev:
	clip_gui_item++
	tmp_txt:=MC_Clip%clip_gui_item%
	line:=MC_Clip%clip_gui_item%
	gosub,clip_gui
return

clip_gui_append:
	clip_gui_item--
	tmp_txt:=MC_Clip%clip_gui_item%
	line:=MC_Clip%clip_gui_item%
	gosub,clip_gui
return

clipboard_gui:
	tmp_txt=%clipboard%	
	line=%clipboard%	
	clip_gui_item:=1

	clip_gui:

	gui3edit2:=tmp_txt
	gui, 3: destroy
	gui, 3: font,s11
	gui, 3: +toolwindow +AlwaysOnTop  -caption  +border    -lastfound 
	Gui, 3: Add, text, x2 y2 cgray, ctrl:: paste  Shift:: append
	Gui, 3: Add, button, x+2 y1 h20 w30 gclip_search_gui hwndbutton25, 
	ILButton(button25, "shell32.dll:" 22, 18, 18, 5)	


	/*
	Gui, 3: Add, Button, x2 y2 w80 h30 gGui3_hide , HIDE
	Gui, 3: Add, Button, x+2 yp w80 h30 gGui3_close_all , ClOSE ALL
	Gui, 3: Add, Button, x+0 yp w80 h30 gcopy_line , copy  line
	Gui, 3: Add, Button, x+10 yp w80 h30 gsend_line ,^v sel line
	Gui, 3: Add, Button, x+0 yp w80 h30 gcopy_sel_line , copy sel line
	Gui, 3: Add, Button, x+0 yp w80 h30 gshow_all , show all
	Gui, 3: Add, Button, x2 y+8 w80 h35 gcopy_all , copy all
	*/
		newline:=0
		
		Loop, Parse, line, `n,`r
				newline++
				if ( newline>10 )
					height_tmp:=20
				else if ( newline>5 )
					height_tmp:=25
				else
					height_tmp:=35
					
	delimiter=`n
	delimiter_all=,`;`:`"`=.&
	loop,parse,delimiter_all
	{
	; msgbox,%a_loopfield%
		ifinstring,line,%a_loopfield%
			{
			delimiter=%a_loopfield%
			break
			}
	}
	/*
		else ifinstring,line,`;
			delimiter=`;
		else ifinstring,line,`:
			delimiter=`:
		else ifinstring,line,"
			delimiter="
			
		*/	
		x_pos:=2
		y_pos:=50
		Position := 0
		rows:=0
		line_n:=1
		Gui, 3: Add, Button, x%x_pos% y%y_pos% w29 h%height_tmp% gcopy_wordbutton1 ,1
		x_pos+=40
		loop,parse,line,`n%delimiter%
		{
			if (rows>12)
				break
			if A_index >30
				break	
			Position += StrLen(A_LoopField) + 1
			; Retrieve the delimiter found by the parsing loop.
			Delimiter := SubStr(line, Position, 1)

			item:=a_loopfield
			item := RegExReplace(item, "^\s+|\s+$") 	;trim whitespace

			skip=0
			;	check for invalid data
			; if ( RegExmatch(item, "[^\.-""']" ) )
			if item=""
				skip:=1
			if item=
				skip:=1
			if (!skip)
				{
					copy_word%a_index%:=item
					length_tmp:=strlen(item)
					if ( length_tmp>10 )
						width_tmp:=length_tmp*9
					else
						width_tmp:=length_tmp*11
					if (width_tmp<30)
						width_tmp:=30
					else if (width_tmp>600)
						width_tmp:=600
					StringLeft, item, item, 100
					Gui, 3: Add, Button, x%x_pos% y%y_pos% w%width_tmp% h%height_tmp% gcopy_wordbutton%a_index% , %item%
					x_pos+=width_tmp
					if (regexmatch(Delimiter,"\R"))		; if newline
					{
						line_n++
						x_pos:=2
						y_pos:=y_pos+height_tmp+1
						rows++
						Gui, 3: Add, Button, x%x_pos% y%y_pos% w29 h%height_tmp% gcopy_wordbutton%a_index% ,%line_n%
						x_pos+=40
					}
					else if (x_pos>600)	; if a big line
						{
						x_pos:=32
						y_pos:=y_pos+height_tmp+1
						}
					else
						x_pos+=2
				}
		}
		
	; Gui, 3: Add, edit, x10 y+5 w600 r1 vgui3edit2, %line%
	if newline>18
		h_lines:=18
	else if newline>7
		h_lines:=newline+1
	else
		h_lines:=7
	Gui, 3: Add, edit, x2 y+2 w600 r%h_lines% vgui3edit2 ,%tmp_txt%
	Gui, 3: Add, Button, x2 y+2 w100 h40 hwndbutton26 gGui3_hide ,HIDE
	ILButton(button26, "shell32.dll:" 131, 32, 32, 5)
	Gui, 3: Add, Button, x+2 yp w80 h40 gclip_gui_prev ,<<
	Gui, 3: Add, Button, x+2 yp w100 h40 gclip_gui_this ,this
	Gui, 3: Add, Button, x+2 yp w80 h40 gclip_gui_append ,>>
	; Gui, 3: Add, Button, x+2 yp w100 h40 gGui3_close_all ,ClOSE ALL
	gui, 3: show, x700 y205
	hotkey,esc,on
	settimer,checkactive,100
	Gui 3: +LastFound
	length_tmp=
	h_lines=
return

copy_wordbutton1:
copy_wordbutton2:
copy_wordbutton3:
copy_wordbutton4:
copy_wordbutton5:
copy_wordbutton6:
copy_wordbutton7:
copy_wordbutton8:
copy_wordbutton9:
copy_wordbutton10:
copy_wordbutton11:
copy_wordbutton12:
copy_wordbutton13:
copy_wordbutton14:
copy_wordbutton15:
copy_wordbutton16:
copy_wordbutton17:
copy_wordbutton18:
copy_wordbutton19:
copy_wordbutton20:
copy_wordbutton21:
copy_wordbutton22:
copy_wordbutton23:
copy_wordbutton24:
copy_wordbutton25:
copy_wordbutton26:
copy_wordbutton27:
copy_wordbutton28:
copy_wordbutton29:
copy_wordbutton30:

GetKeyState, state_C, ctrl
GetKeyState, state_S, shift

Stringtrimleft, Button , A_Thislabel, 15




if state_S = D ; 
	{
		tmp:=copy_word%Button%
		clipboard .=tmp
		settimer,removetooltip,-500
		tooltip,copied clip`n%clipboard%
	}
	else
	{
		clipboard:=copy_word%Button%
		tmp:=copy_word%Button%
		settimer,removetooltip,-700
		tooltip,%tmp%
	}
if state_C = D ; 
	{
		gui, 3: hide
		; clipboard:=copy_word%Button%
		sleep,100		
		; send ^v
		send_key_emacs_or_after_translatingTo_normal_ifNot_emacseditor("C-y")
		sleep,100
		gui, 3: show, x700 y205
	}
	/*
	else
	{
		clipboard:=copy_word%Button%
		tmp:=copy_word%Button%
		tooltip,%tmp%
		settimer,removetooltip,-500
	}
	*/
return
Gui3_hide:
Gui3_close_all:
gui,3: hide
	;	hide other also
	Gui, %clipselect_gui_number%:  hide
	SetTimer, IncrementalSearch_567, off

return


Copy_to_fav_clips:

Loop %MCF_MAX_Clips%
		  {
		   MCF_Clip%id%_%a_index% := MC_Clip%a_index% 
		  }
  	MCF_activeclip:=1
	get_maxEntry()
return

export_to_file:
t_id:=1


Loop %MCF_MAX_Clips%
{
	ifexist, %fav_data_f%\%t_id%_%A_Index%.clip
		Filedelete, %fav_data_f%\%t_id%_%A_Index%.clip
}
Loop %MCF_clips_present%
{	if (MCF_Clip%t_id%_%A_Index%<>"" )
		{
			a:=MCF_Clip%t_id%_%A_Index%
			Fileappend,%a%, %fav_data_f%\%t_id%_%A_Index%.clip
		}
		total:=A_Index
}
msgbox,exported %total% files

return



+F7::	; clipb search, gui
settimer,cancelHotkeySTEP_history,off	
if !(HotkeySTEP_history_active)	;	if hotkey is currently not in cycle mode 
{
	HotkeySTEP_history_count:=0
	
}
if (HotkeySTEP_history_count=0)
{	

	HotkeySTEP_history_count++
	msg=hist search
	settimer,removetooltip,-1600
	tooltip,%HotkeySTEP_history_count% %msg%
	settimer,cancelHotkeySTEP_history,-1500	
	HotkeySTEP_history_action = clip_search_gui
}
else if (HotkeySTEP_history_count=1)
{	

	HotkeySTEP_history_count++
	msg=fav_search
	settimer,removetooltip,-1600
	tooltip,%HotkeySTEP_history_count% %msg%
	settimer,cancelHotkeySTEP_history,-1500	
	HotkeySTEP_history_action = fav_search	
}
else if (HotkeySTEP_history_count=2)
{	

	HotkeySTEP_history_count++
	msg=clipboard_gui
	settimer,removetooltip,-1600
	tooltip,%HotkeySTEP_history_count% %msg%
	settimer,cancelHotkeySTEP_history,-1500	
	HotkeySTEP_history_action = clipboard_gui	
}
else if (HotkeySTEP_history_count=3)
{	

	HotkeySTEP_history_count++
	msg=adv
	settimer,removetooltip,-1600
	tooltip,%HotkeySTEP_history_count% %msg%
	settimer,cancelHotkeySTEP_history,-1500	
	HotkeySTEP_history_action = nil	
}
else
{	

	HotkeySTEP_history_count:=0
	msg=cancel
	settimer,removetooltip,-1600
	tooltip,%HotkeySTEP_history_count% %msg%
	settimer,cancelHotkeySTEP_history,-1500		
}
	
	HotkeySTEP_history_active:=1
	hotkey,^q,on
	setTimer,HotkeySTEP_history,70
	sleep,10



HotkeySTEP_history:	
	GetKeyState,state,SHIFT
	If state=u
	{
		if (HotkeySTEP_history_count=0)
		{	
			settimer,removetooltip,-1500
			tooltip,%HotkeySTEP_history_count% cancelled			
		}
		else if (HotkeySTEP_history_count=1)
		{
			gosub,%HotkeySTEP_history_action%		
			
		}
		else if (HotkeySTEP_history_count=2)
		{	
			gosub,%HotkeySTEP_history_action%

		}
		else if (HotkeySTEP_history_count=3)
		{
			gosub,%HotkeySTEP_history_action%
		}

		gosub,cancelHotkeySTEP_history
	}
return

cancelHotkeySTEP_history:	;	cancel without action
	setTimer,HotkeySTEP_history,off
	HotkeySTEP_history_active:=0
	; tooltip,cancelling
	settimer,removetooltip,-300
	hotkey,^q,off

Return

next_tmp_fav_collector(id)
{
global tmp_fav_collector
tooltip,%id%

	if ((id+1)>tmp_fav_collector)
		id:=0
	else
		id++
	return id
}

MsgMonitor(wParam, lParam, msg)
{
    ; Since returning quickly is often important, it is better to use a ToolTip than
    ; something like MsgBox that would prevent the function from finishing:
    ToolTip Message %msg% arrived:`nWPARAM: %wParam%`nLPARAM: %lParam%
}

Receive_WM_COPYDATA(wParam, lParam)
{

	global CopyOfData2
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
	CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
	; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
	; ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
	; ToolTip ,%CopyOfData%


	CopyOfData2:=CopyOfData
	CopyOfData2:=regexreplace(CopyOfData2,"^\n"," ")
	
	msgbox,%CopyOfData2%
	loop,parse,CopyOfData2,-
	{
		if a_loopfield<>
		{
			
			if ( RegExMatch(a_loopfield, "i)^s.*") )
			{
			StringTrimLeft, OutputVar, a_loopfield, 1
				msgbox,S=%OutputVar%
			}
			else if ( RegExMatch(a_loopfield, "i)^n.*") )
			{
			StringTrimLeft, OutputVar, a_loopfield, 1
			
				msgbox,N=%OutputVar%
			}
			else if ( RegExMatch(a_loopfield, "i)^O.*") )
			{
				StringTrimLeft, OutputVar, a_loopfield, 1			
				msgbox,O=%OutputVar%
			}
		}
	
	}
return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
	
}

