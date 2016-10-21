; ******************************************************************* 
; AGB.ahk
; updated: June 22, 2008
; by corrupt
; ******************************************************************* 
; - these functions can optionally be used to pre-load 
; images to avoid loading them from file each time (useful for 
; creating image rollovers). Specify the variable used in the 
; function as ImgPath instead (note: an existing image object will 
; not get deleted when a path is not specified. Use 
; DllCall("DeleteObject", VariableName_img) manually first before 
; using a pre-loaded image if an image path was used previously to 
; free memory used by loading the image (or use the AGB_DelImage() 
; function. 
; ******************************************************************* 
; 
; ******************************************************************* 
; Preload images for use with the AddGraphicButton() function 
; Version: 2.21 Updated: June 22, 2008 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the loaded image resource 
; ImgPath = Path to the image to be displayed 
; bHeight = Image height (default = 32) 
; bWidth = Image width (default = 32) 
; ******************************************************************* 
AGB_LoadImage(ByRef VariableName, ImgPath, bHeight=32, bWidth=32) { 
Global 
Local ImgType, ImgType1, LR_LOADFROMFILE, NULL 
Static LR_LOADFROMFILE := 16 
Static NULL 
SplitPath, ImgPath,,, ImgType1 
ImgType := (ImgType1 = "bmp") ? 0 : 1 
If (%VariableName%_img != "") 
  DllCall("DeleteObject", "UInt", %VariableName%_img)  
VariableName := ImgType . "." . DllCall("LoadImage", "UInt", NULL, "Str", ImgPath, "UInt", ImgType, "Int", bWidth, "Int", bHeight, "UInt", LR_LOADFROMFILE, "UInt") 
Return ErrorLevel 
}

; ******************************************************************* 
; Preload icons from a dll for use with the AddGraphicButton() function
; uses a function in the dll to extract the images
; likely supports: BMP, GIF, JPG, WMF, EMF, ICO
; note: add the images using resource type: RCDATA
; Version: 2.21 Updated: July 2, 2008 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the loaded image resource
; dllfile = Path to the dll file that contains the image(s) 
; resID = the ID# of the  
; nHeight = Image height (default = 32) 
; nWidth = Image width (default = 32) 
; ******************************************************************* 
AGB_LoadImgDll(ByRef VariableName, dllfile, resID, nheight=0, nwidth=0) { 
Global 
Local hModule
If (%VariableName%_img != "") 
  DllCall("DeleteObject", "UInt", %VariableName%_img)
hModule := DllCall("LoadLibrary", "Str", dllfile)
variablename := "0." . DllCall(dllfile . "\LoadDllImage", "UInt", resID, "UInt", nwidth, "UInt", nheight, "UInt")
DllCall("FreeLibrary", "UInt", hModule)
Return ErrorLevel 
} 

; ******************************************************************* 
; Preload bitmaps from a dll for use with the AddGraphicButton() function 
; Version: 2.21 Updated: June 22, 2008 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the loaded image resource
; dllfile = Path to the dll file that contains the image(s) 
; resID = the name or ID of the bitmap (or icon? - not currently tested) 
; bHeight = Image height (default = 32) 
; bWidth = Image width (default = 32) 
; ImgType1 = "bmp" for bitmaps, "ico" for icons
; ******************************************************************* 
AGB_LoadBmpDll(ByRef VariableName, dllfile, resID, bHeight=32, bWidth=32, ImgType1="bmp") { 
Global 
Local ImgType,LR_SHARED, NULL, bmps, IDtype
Static LR_SHARED := 32768 
Static NULL 
If resID is integer
  IDtype = 1
bmps := DllCall("LoadLibrary", "Str", dllfile)
ImgType := (ImgType1 = "bmp") ? 0 : 1 ; future use?
If (%VariableName%_img != "") 
  DllCall("DeleteObject", "UInt", %VariableName%_img) 
VariableName := ImgType . "." . DllCall("LoadImage", "UInt", bmps, (IDtype ? "UInt" : "Str"), resID, "UInt", ImgType, "Int", bWidth, "Int", bHeight, "UInt", LR_SHARED, "UInt") 
DllCall("FreeLibrary", "Uint", bmps)
Return ErrorLevel 
}

; ******************************************************************* 
; Preload icons from a dll for use with the AddGraphicButton() function 
; Version: 2.21 Updated: June 22, 2008 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the loaded image resource
; dllfile = Path to the dll file that contains the image(s) 
; nindex = the index of the icon to load 
; ******************************************************************* 
AGB_LoadIconDll(ByRef VariableName, dllfile, nindex) { 
Global 
Local spid
spid := DllCall("GetCurrentProcessId")
If (%VariableName%_img != "")
  DllCall("DeleteObject", "UInt", %VariableName%_img) 
VariableName := "1." . DllCall("shell32.dll\ExtractIconA", "UInt", spid, "Str", dllfile, "UInt", nindex)
Return ErrorLevel
}

; ******************************************************************* 
; Destroy loaded images
; Version: 2.21 Updated: June 22, 2008 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the loaded image resource
; ******************************************************************* 
AGB_DelImage(ByRef VariableName) { 
Global 
Local ImgPath0, ImgPath1, ImgPath2
If (%VariableName%_img != "") 
  DllCall("DeleteObject", "UInt", %VariableName%_img)
Else 
{ 
  StringSplit, ImgPath, ImgPath,`. 
  %VariableName%_img := ImgPath2 
  DllCall("DeleteObject", "UInt", %VariableName%_img)
}
variablename=
Return ErrorLevel 
} 




