#SingleInstance force
SetTitleMatchMode, 2 ;string anywhere
SetKeyDelay, -1
SetBatchLines, -1
Process, Priority,, High
SetWorkingDir %A_ScriptDir%

helptext =
(
TwoCamControl
**********************
Windows frontend for chdkptp with two cameras.

**********************
version 2018-11-13
by Nod5
https://www.github.com/nod5/TwoCamControl
Free Software GPLv3

**********************
FEATURES  
Shoot two cameras at (almost) the same time and quickly.  
Save each photo directly to the PC.  
Trigger cameras with a GUI button, keyboard or mouse wheel.  
Autoname files in sequence 0001L.jpg 0001R.jpg 0002L.jpg ...  

CONTROLS - BASIC WORKFLOW  
1. Connect cameras.  
2. Adjust Zoom and Focus. Preview.  
3. When the settings are good start a New Project and Shoot.  

DEPENDENCIES  
1. Two Canon cameras with CHDK installed. Use the latest development version of CHDK.  
http://chdk.wikia.com/wiki/CHDK_in_Brief  
http://chdk.wikia.com/wiki/Downloads  
2. The cameras must have filewrite support. See FWT column here:  
http://chdk.wikia.com/wiki/CameraFeatureTable  
3. LibUSB drivers installed for both cameras on PC.  
http://chdk.wikia.com/wiki/PTP_Extension#LibUSB_Driver_for_Windows  
4. chdkptp downloaded and unzipped.  
https://www.assembla.com/spaces/chdkptp/wiki  
5. Only if you want to run/build TwoCamControl from source:  
Install AutoHotkey https://autohotkey.com and save the .ahk with UTF-8 BOM encoding  

REQUIRED SETUP IN TWOCAMCONTROL  
- Set workdirectory path  
- Set path to chdkptp.exe  
- Set right camera serial  

OPTIONAL SETTINGS (DEFAULT VALUE)  
- Auto zoom (0): Auto zoom this number of steps when right/left camera connects.  
- Wait (0): Wait this number of miliseconds before the camera shoots. Use this to add a delay in a hardware setup where shoots are triggered by a mousewheel that the platen touches on its way down. Set to 0 for no delay.  
- Mousewheel (off): Mouse wheel down triggers a shoot.  
- Numpad keys (off): Activate numpad key controls (see below).  
- Space (off): Space button triggers a shoot.  
- PC Save (on): Save images directly to PC. Uncheck to save to camera SD cards (not to PC). Save to SD mode uses chdkptp "shoot" command with parameters set by user in the rsint options field. Try parameter raw=1 for raw shoot.  
- Alt Zoom (off): Use click('zoom_in') method instead of the default set_zoom method. If this is checked then the numbers in the auto zoom settings are interpreted as the number of click zoom actions to auto perform on connect.
- rsint options (-cmdwait=600 -tv=1/160): parameters for the rsint command. See file USAGE.TXT in chdkptp for details. Cmdwait is the number of seconds until rsint times out.  
- extraprocess (blank): Path to some external tool to run at project start. Example: C:\folder\program.exe . TwoCamControl sends the project name as a command line parameter. The project name is a timestamp (YYYYMMDDhhmmss).  

On Main tab: Click on green text for a single session change of that setting.  

Reset to default settings: delete TwoCamControl.ini and restart TwoCamControl.  

CONTROLS - TIPS AND TRICKS  
- Hold Shift / Control to apply zoom or focus command only to right/left side camera.  
- Mouse wheel down: Shoot photo. Useful with a wireless mouse.  
- Space: Shoot photo.  
- Numpad keys: useful with a wireless numpad  
  - 3 = camera LCD display on/off (save battery)  
  - 4 = connect cameras  
  - 5 = zoom in 5`%  
  - + = zoom in minimal step  
  - - = zoom out minimal step  
  - 6 = focus lock  
  - 7 = new project  
  - 8 = shoot photo  
  - 9 = pause  
  - Numpad 0 1 2 are modifier keys:  
    - 1 = only apply to left camera  
    - 2 = only apply to right camera  
    - 0 = reverse action (zoom out, focus unlock)  
  - Numpad modifier examples:  
    - 1 & 5 = zoom in 5`% left camera  
    - 2 & 6 = focus lock right camera  
    - 0 & 5 = zoom out 5`%  
    - 0 & 6 = focus unlock  
    - 0 & 1 & 5 = zoom out 5`% left camera  
- Right click on Zoom In / Zoom Out: zoom in/out minimal step. Useful for fine tuning zoom position.  
- Right click on Preview: menu to show the same preview again.  
- Right click on Pause: menu to cancel current project but keep cameras connected.  
- Click on green text for a single session change of that setting.  
- Right click on Shoot or press NumpadEnter: save a textfile with current page count, for example 0004.txt . Useful as a reminder for post shoot file check. For example when a page was accidentally shot twice.  
- Close TwoCamControl: also powers off cameras.  

FEEDBACK  
GitHub , https://github.com/nod5/TwoCamControl  
DIY Book Scanner forum , https://forum.diybookscanner.org/viewtopic.php?f=20&t=3082  

FAQ  
Q  What if camera serial setup step fails?  
A  Set camera serial manually: plug in and power on camera, open a cmd window in the chdkptp.exe folder, run the command "chdkptp.exe -elist" and look for the serial. It looks something like this: DC3E13D4111234B2A23CC31F2E3AA5 . TwoCamControl uses the serial to identify which camera is which.  

Q  What if the above manual command "chdkptp.exe -elist" returns no serial?  
A  Reinstall LibUSB for that camera. Also double-check that the camera is on, plugged in, and that the cmd window path is in the chdkptp folder.  

Q  How to solve "ERROR: not in continous mode"?  
A  Power on the camera with CHDK on the SD card without connecting it to the PC, press "func" button on the camera, go to the menu item that allows setting continuous mode and turn it on. Power off the camera. Then try TwoCamControl again.  

Q  What if the chkdptp cmd window shows error about filepath or incorrect characters?  
A  Try changing workdirectory path to not include special or non-english characters. Test with only a-z 0-9 space.  

Q  What if chkdptp cmd window still shows error about filepath or incorrect characters?  
A  See notes_on_character_errors.md at  https://github.com/nod5/TwoCamControl/blob/master/docs/notes_on_character_errors.md  

Q  Can I use TwoCamControl with only one camera?  
A  Yes.  

Q  What Windows version does TwoCamControl require?  
A  TwoCamControl is only tested in Windows 10 x64. It might work in earlier Windows.  

Q  How does zoom work in TwoCamControl?  
A  In default mode there are two zoom actions. You can zoom in/out a big amount (5 percent of the camera's zoom range) or a minimal amount (2 steps if the camera has a 60+ zoom range, otherwise 1 step). This is done using the chdkptp commands zoom_set and zoom_set_rel. The non-default "Alt Zoom" mode can be enabled in Setup. There TwoCamControl uses the chdkptp command click('zoom_in'). Use the non-default mode if the default mode causes errors or causes distortion in the .jpg files where lines become curved similar to a fish lens effect. Only some cameras have that problem. Read notes_on_zoom_methods.md on GitHub for more.  

Q  What if my question/issue/suggestion is not in this FAQ?  
A  Open an issue at GitHub and describe the problem. Include these details: Your camera model, the version of CHDK, chdkptp and TwoCamControl and Windows version and language.  
)

FileEncoding, UTF-16
;Set UTF-16 before each iniwrite/iniread instance
;to enable special characters (non ASCII) in .ini variables
;for work directory path, chdkptp path, extraprocess path
;
;However chdkptp only supports ASCII characters in the rsint command path
;For we require ASCII in the work directory edit field, until chdkptp adds unicode support
;Background
;https://chdk.setepontos.com/index.php?topic=6231.msg138156#msg138156
;https://en.wikipedia.org/wiki/ASCII


checkini()
FileEncoding, UTF-8
;reset to UTF-8 immediately afterwards, otherwise other .txt file I/O get garbled text

checkini() {
global
ini = %A_scriptdir%\TwoCamControl.ini

ifnotexist, %ini% 
{
chdkptp := FileExist(A_ScriptDir "\chdkptp.exe") ? A_ScriptDir "\chdkptp.exe" : ""
ini_txt = 
(
[options]
workdir=%A_ScriptDir%
chdkptp=%chdkptp%
rightcamserial=
auto_zoom_right=
auto_zoom_left=
previous_zooms=
wait=0
mousewheelshoot=0
numpadkeys=0
spaceshoot=0
pcsave=1
alt_zoom_method=0
rsintoptions=-cmdwait=600 -tv=1/160
extraprocess=
)
FileAppend, %ini_txt%, %ini%  ;create default ini
}

setup_items = workdir,chdkptp,setup_button,rightcamserial,auto_zoom_right,auto_zoom_left,previous_zooms,wait,mousewheelshoot,numpadkeys,spaceshoot,pcsave,alt_zoom_method,rsintoptions,extraprocess

FileEncoding, UTF-16
Loop, Parse, setup_items,`,
  IniRead, %A_LoopField%, %ini%, options, %A_LoopField%, %A_space%  ;read ini data
FileEncoding, UTF-8

if !mousewheelshoot
  mousewheelshoot = 0
if !numpadkeys
  numpadkeys = 0
if !spaceshoot
  spaceshoot = 0
if !pcsave
  pcsave = 1
if !alt_zoom_method
  alt_zoom_method = 0
if extraprocess
  proc = 1
screenstate = 1
if !RegExMatch(wait,"^\d+$") ;not digits
  wait = 0
previous_array := StrSplit(previous_zooms, "|")
}

;prepare variables
enum := 0000, counter := 1, pau := 0
workdir := SubStr(workdir,0) = "\" ? SubStr(workdir,1,StrLen(workdir)-1) : workdir ;trim end slash
workdirfrontslash := StrReplace(workdir, "\","/") ;chdkptp uses frontslashes

;hotkey/buttons list, use to first disable all and then selectively enable
;- local hotkeys when preparing session
;- global hotkeys when shooting
all_hotkeys := "*F4,*F5,*F6,F7"
all_numpad_hotkeys := "*Numpad4,*Numpad5,*Numpad6,NumpadAdd,NumpadSub,Numpad7"
all_global_hotkeys := "F8,F9,WheelDown,Space,Numpad8,Numpad9,NumpadEnter,Numpad3"
all_buttons := "bf4,bf5,bf5b,bmenu,bf6,bf6b,bf6c,bf7,bf8,bf9"


;Create Gui
gui_width := 330 , gui_height := 500
Gui, Add, Tab3, x0 y0 w%gui_width% h%gui_height%, Main|Setup|Help
Gui, Color, ffffff  ;white

;Gui Main tab
Gui, font, s12 bold
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf4 gbf4 Default,(F4) Connect Cameras
GuiControl, -default, bf4
Gui, Add, Button, vbf5 gbf5,(F5) Zoom In
Gui, Add, Button, vbf5b gbf5b yp x+10,Out
Gui, Add, Button, vbmenu gbmenu yp x+20,Menu
Gui, Add, Button, vbf6 gbf6 y+6 xm,(F6) Focus Lock 
Gui, Add, Button, vbf6b gbf6b yp x+8,Unlock 
Gui, Add, Button, vbf6c gbf6c yp x+8,Preview
Gui, Add, text,,%A_space%
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf7 gbf7 y+0 xm,(F7) New Project
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf8 gbf8,(F8) Shoot
Gui, Add, Button, vbf9 gbf9,(F9) Pause

;disable all hotkeys/buttons
hotoff(all_hotkeys "," all_numpad_hotkeys)
hotoffglobal(all_global_hotkeys)
dis(all_buttons)
;enable connect cameras
ena("bf4")
hoton("*F4")
if (numpadkeys = 1)
  hoton("*Numpad4")

;single session settings in green text
Gui, font, normal cgreen 
Gui, add, text,vfileenum gfileenum w160,next filename 0001
Gui, add, text,vsleeptime gsleeptime yp+20 w80, wait %wait%
Gui, add, text,vproc gproc yp+20 w100,extraprocess
Gui, add, text,vscreenstate gscreenstate yp+20 w140, camera LCD on
Gui, font, s10 cblack 
Gui, add, text,vproj yp+20 w300,
Gui, font, cgray
Gui, Add, text,vapply xm+2 y174 w300,both cameras
Gui, Add, GroupBox, w2 h150 y40 x7,

;Gui Setup tab 
Gui, Tab, 2
setup_width := gui_width-15
Gui, font, s10 normal black
Gui, Add, text,x8 y33,Read DEPENDENCIES in Help first.
Gui, font, s12 bold black
Gui, Add, text,yp+25,projects work directory
Gui, font, s10 normal
Gui, Add, edit, w300 h20 yp+20 vworkdir gworkdir,%workdir%
Gui, Add, text,w%setup_width%,Path to folder where each project subfolder is created and photos saved. Example: C:\test\folder

Gui, font, s12 bold
Gui, Add, text,yp+36,chdkptp path
Gui, font, s10 normal
Gui, Add, edit, w300 h20 vchdkptp gchdkptp yp+21,%chdkptp%
Gui, Add, text,w%setup_width% yp+22,Example: C:\some folder\chdkptp\chdkptp.exe 

txtser = A special serial number (not printed on the camera). Take the camera you will later place to the right of the book. Plug it in to the PC with USB. Power on the camera. Then click the Setup button. 

Gui, font, s12 bold
Gui, Add, text,,Right cam serial
Gui, font, s10 normal
Gui, Add, button, yp-4 xp+140 vsetup_button gsetup_button,Setup
Gui, Add, edit, xp-140 yp+29 w300 h20 vrightcamserial grightcamserial,%rightcamserial%
Gui, Add, text,yp+22 w%setup_width%,%txtser%

;auto zoom
Gui, font, s10 bold
Gui, Add, text,y+30 x16,Auto zoom
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+9 w28 h20 Limit3 Number vauto_zoom_left gauto_zoom_left,%auto_zoom_left%
Gui, Add, text, yp+2 x+4 w60, left cam
Gui, Add, edit, yp-2 x+2 w28 h20 Limit3 Number vauto_zoom_right gauto_zoom_right,%auto_zoom_right%
Gui, Add, text, yp+2 x+5 w100, right cam

;wait = 400
Gui, font, s10 bold
Gui, Add, text,x56 yp+21,Wait
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+9 w45 Limit Number h20 vwait gwait,%wait%
Gui, Add, text, yp+2 x+5 w170, before shoot (in ms)

;mousewheelshoot
Gui, font, s10 bold
Gui, Add, text,x3 yp+25,Mousewheel
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w17 h20 Checked%mousewheelshoot% vmousewheelshoot gmousewheelshoot

;numpadkeys
Gui, font, s10 bold
Gui, Add, text,xp+27 yp,Numpad
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w17 h20 Checked%numpadkeys% vnumpadkeys gnumpadkeys

;spaceshoot
Gui, font, s10 bold
Gui, Add, text,x44 yp+25,Space
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w17 h20 Checked%spaceshoot% vspaceshoot gspaceshoot

;pcsave
Gui, font, s10 bold
Gui, Add, text,xp+25 yp,PC Save
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w15 h20 Checked%pcsave% vpcsave gpcsave

;alternative zoom method
Gui, font, s10 bold
Gui, Add, text,xp+27 yp,Alt Zoom
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w17 h20 Checked%alt_zoom_method% valt_zoom_method galt_zoom_method


;rsintoptions = -cmdwait=600 -tv=1/160
Gui, font, s10 bold
Gui, Add, text,x7 yp+27,rsint options
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+10 w205 h20 vrsintoptions grsintoptions,%rsintoptions%

;extraprocess
Gui, font, s10 bold
Gui, Add, text,x6 yp+23,Extraprocess
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+4 w205 h20 vextraprocess gextraprocess,%extraprocess%

;Gui Help tab
Gui, Tab, 3
help_width := gui_width-10 , helph = gui_height-25
Gui, Add, Edit, ReadOnly x5 y22 w%help_width% h%helph%  vMyEdit, %helptext%

Gui, Tab, 1 ;default tab

Gui, Show, w%gui_width% h%gui_height% x0 y0, TwoCamControl
WinSet, AlwaysOnTop, On, TwoCamControl

SetTimer, modifier_key_check, 50
return

;save to ini on editbox/checkbox change
alt_zoom_method:
workdir:
chdkptp:
rightcamserial:
auto_zoom_right:
auto_zoom_left:
wait:
mousewheelshoot:
rsintoptions:
numpadkeys:
spaceshoot:
pcsave:
extraprocess:
gui,submit,nohide
tempkey := a_thislabel      ;wait
tempedit := %a_thislabel%   ;400

FileEncoding, UTF-16
IniWrite, %tempedit%, %ini%, options, %tempkey%
FileEncoding, UTF-8

if (a_thislabel = "wait")
  GuiControl,, sleeptime, wait %tempedit%
if (a_thislabel = "workdir")
{
  ;trim end slash
  workdir := SubStr(workdir,0) = "\" ? SubStr(workdir,1,StrLen(workdir)-1) : workdir

  ;path must be ascii, otherwise chdkptp will save to incorrect folder
  if !isAscii(workdir)
  {
    ascii_error = `n Error:`nThe work directory path must be ASCII characters.`nTry a path with only A-Z 0-9 Space \ `n `n
    ToolTip, % ascii_error, % A_CaretX, % A_CaretY

    ;clear ini value
    FileEncoding, UTF-16
    IniWrite, %A_Space% , %ini%, options, %tempkey%
    FileEncoding, UTF-8
    
    sleep 2500
    ToolTip
    GuiControl,, workdir,
  }

  ;chdkptp uses frontslashes
  workdirfrontslash := StrReplace(workdir, "\","/")
}
return


;function: check if string is ASCII
;https://en.wikipedia.org/wiki/ASCII
isAscii(string){
return RegExMatch(string, "[^[:ascii:]]") = 0 ? 1 : 0
}


;use chdkptp to read connected camera serial number
setup_button:
if !FileExist(chdkptp) or (SubStr(chdkptp, -10) != "chdkptp.exe")
  msg_and_reload("Error: set chdkptp.exe path first.")
FileDelete, %A_ScriptDir%\twocamcontrol_tempcam.txt
RunWait %comspec% /c ""%chdkptp%" -elist > "%A_ScriptDir%\twocamcontrol_tempcam.txt"", , Hide
FileRead, tempcam,  %A_ScriptDir%\twocamcontrol_tempcam.txt
FileDelete, %A_ScriptDir%\twocamcontrol_tempcam.txt
RegExMatch(tempcam, "s=(\w+)",match)
rightcamserial := match1
GuiControl,, rightcamserial, %rightcamserial%
return


;Preview  Shoot preview pictures and show in default image viewer
bf6c:
FileDelete, %workdir%\TCC_temppreviewL.jpg
FileDelete, %workdir%\TCC_temppreviewR.jpg
tempoptions := RegExReplace(rsintoptions,  "-cmdwait=\d+", "")
;enclose path for rs
if acti(leftcam)
  xs("rs '" workdir "/TCC_temppreviewL' " tempoptions,leftcam), sleep(200)
if acti(rightcam)
  xs("rs '" workdir "/TCC_temppreviewR' " tempoptions,rightcam)
actiscript()

show_preview_again:
Loop
{
  ;wait until one picture is saved
  if FileExist(workdir "\TCC_temppreview*.jpg")
    break
  sleep 100
  if (a_index = 60)
    ;abort after 6 secs
    return
}
LR := FileExist(workdir "\TCC_temppreviewL.jpg") ? "L" : "R"
Run %workdir%\TCC_temppreview%LR%.jpg ;preview in default image viewer
return


;timer:
;Hold Control/Shift or Numpad1/2: apply command (zoom, focus, connect) only to L/R camera
;Hold Numpad0: reverse numpad5/6 command (zoom out/focus unlock)
modifier_key_check:
;GetKeyState returns 1 if down, 0 if up
ckey  := GetKeyState("Control")
ckey2 := GetKeyState("Numpad1")
skey  := GetKeyState("Shift")
skey2 := GetKeyState("Numpad2")
nkey  := GetKeyState("Numpad0")
wkey  := GetKeyState("Lwin")
wkey2 := GetKeyState("Rwin")
akey  := GetKeyState("Alt")

ckey := ckey2 = 1 ? 1 : ckey
skey := skey2 = 1 ? 1 : skey
wkey := wkey2 = 1 ? 1 : wkey

GuiControl,,apply, % skey = ckey ? "both cameras" : skey = 1 ? "right side camera" : "left side camera"
return


;functions: enable/disable comma separated list of hotkeys/buttons
dis(d) {
  Loop, Parse, d,`,
    GuiControl, disable, %A_LoopField% 
}
ena(d) {
  Loop, Parse, d,`,
    GuiControl, enable, %A_LoopField% 
}
hotoff(h) {
  Hotkey,IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
  Loop, Parse, h,`,
    Hotkey, %A_LoopField%, Off
}
hoton(h) {
  Hotkey, IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
  Loop, Parse, h,`,
    Hotkey, %A_LoopField%, On
}
hotoffglobal(h) {
  Hotkey, IfWinActive
  Loop, Parse, h,`,
    Hotkey, %A_LoopField%, Off
}
hotonglobal(h) {
  Hotkey, IfWinActive
  Loop, Parse, h,`,
    Hotkey, %A_LoopField%, On
}


GuiClose: 
;if proj has started: exit rsint mode
if proj && pcsave
{
  if acti(leftcam)
    xs("q",leftcam)
  if acti(rightcam)
    xs("q",rightcam)
  sleep(2000)
}
;if cameras are connected: shut down cameras
if (pid1 or pid2)
{
  if acti(leftcam)
    xs("luar shut_down()",leftcam)
  if acti(rightcam)
    xs("luar shut_down()",rightcam)
  sleep(2000)
}
Process, Close, chdkptp.exe
sleep 200
Process, Close, chdkptp.exe
sleep 200
loop, 2
  WinClose, ahk_exe cmd.exe
;clean temp preview images
FileDelete, %workdir%\TCC_temppreview*.jpg
ExitApp


;right click in gui
GuiContextMenu:
GuiControlGet, PreviewButEnabled, Enabled, bf6c
menu, twocam_menu, add
Menu, twocam_menu, Delete ;clear old

if (proj and A_GuiControl = "bf9")
{
  ;right click button (F9) Pause
  Menu, twocam_menu, Add,Cancel Project, cancel_project
  Menu, twocam_menu, Show
}
else if (proj and !pau and A_GuiControl = "bf8")
{
  ;right click button (F8) Shoot
  ;save blank 0004.txt for troubleshooting
  Menu, twocam_menu, Add,Save %count_string%.txt, save_txt_count
  Menu, twocam_menu, Show
}
else if (PreviewButEnabled and A_GuiControl = "bf6c")
{
  ;right click button Preview
  Menu, twocam_menu, Add,Show same preview again, show_preview_again
  Menu, twocam_menu, Show
}
else if (!proj and A_GuiControl = "bf5")
{
  ;right click Zoom in before project start
  gosub zoom_in_mini
}
else if (!proj and A_GuiControl = "bf5b")
{
  ;right click Zoom out before project start
  gosub zoom_out_mini
}
return


;exit rsint, clear vars, unlock focus, ready cameras
cancel_project:
if proj
{
  ;enable camera LCD backlight
  if !screenstate
    gosub screenstate
  ;exit rsint
  if acti(leftcam)
    xs("q",leftcam)
  if acti(rightcam)
    xs("q",rightcam)
  sleep(1000)
}
enum := 0000, counter := 1, proj := ""
gosub bf6b  ;focus unlock cameras
;no need to update other variables since (F7) New project will set them

;disable all hotkeys/buttons
hotoff(all_hotkeys "," all_numpad_hotkeys)
hotoffglobal(all_global_hotkeys)
dis(all_buttons)
;enable configuration hotkeys/buttons
ena("bf5,bf5b,bmenu,bf6,bf6b,bf6c,bf7")
hoton("*F5,*F6,F7")
if (numpadkeys = 1)
  hoton("*Numpad4,*Numpad5,*Numpad6,NumpadAdd,NumpadSub,Numpad7")

return


;function: activate script main window
actiscript() {
  WinActivate, TwoCamControl ahk_class AutoHotkeyGUI
}


;function: activate cmd window based on device num (d=0001 or d=00002) in win title
;note: y = rightcam/leftcam variable = blank if the camera was not connected
acti(y) {
  If !y or !WinExist("d=" y " ahk_exe cmd.exe")
    return
  Loop, 10
  {
    ;try for 1 second (10 times 60+40 ms)
    WinActivate, d=%y% ahk_exe cmd.exe  ;makes six attempts during 60 ms
    If WinActive("d=" y " ahk_exe cmd.exe")
      break
    sleep 40
  }
  If WinActive("d=" y " ahk_exe cmd.exe")
    Return true
}


;function: send command x string to camera y's cmd window
xs(x,y) {
  x := unicodify(x)
  If WinActive("d=" y " ahk_exe cmd.exe")
    SendInput,%x%{enter}
}


;function: send command x string as unicode to camera y's cmd window after modifier key release
xsif(x,y) {
  x := unicodify(x)
  If !WinActive("d=" y " ahk_exe cmd.exe")
    return
  ;wait for control/shift modifier key release
  ;use for connect/zoom/focus commands where user may press modifier
  ;because sendinput can mess up string to cmd if modifier is down
  if GetKeyState("Control")
    KeyWait, Control
  if GetKeyState("Shift")
    KeyWait, Shift
  SendInput,%x%{enter}
}


;function: convert string to unicode values
unicodify(x) {
  ;necessary to prevent sendinput char error in chdkptp interactive CLI with win10 non-eng
  ;for example the ! in !file in get_zoom() will not appear unless unicodify() is used
  ;note: in unicode scripts asc() returns unicode value
  ;note: Setformat can make asc() output hex, for SendInput {U+nnnn} use
  ;old TwoCamControl ansify() method was flawed: sent ascii {ASC nnnn} and only for some chars
  ; https://autohotkey.com/docs/commands/Asc.htm
  ; https://autohotkey.com/docs/commands/SetFormat.htm
  ; https://autohotkey.com/docs/commands/Send.htm
  ;note: special keys like {enter} fail if passed through unicodify() so send them as is
  SetFormat, IntegerFast, Hex
  Loop, Parse, x
    uni .= "{U+" Asc(A_LoopField) "}"
  SetFormat, IntegerFast, Decimal
  return uni
}


;function: link cameras to left/right side based on right camera serial number
; note: chdkptp list command returns list of PTP devices in this format (from USAGE.TXT):
;<status><num>:<modelname> b=<bus> d=<device> v=<usb vendor> p=<usb pid> s=<serial number>
; first identify the right camera using its serial number (previously setup)
; next get the enumeration part of the device strings (0001/0002)
;later used to correctly activate/send to the right/left camera cmd window
checkcams() {
  global
  if (pid1 or pid2)
    ;already checked this session, avoid camera error on second -elist run
    return
  filedelete, %workdir%\twocamcontrol_tempcam.txt
  RunWait, %comspec% /c ""%chdkptp%" -elist > "%workdir%\twocamcontrol_tempcam.txt"",,Hide
  sleep 100
  FileReadLine, xline1, %workdir%\twocamcontrol_tempcam.txt, 1
  FileReadLine, xline2, %workdir%\twocamcontrol_tempcam.txt, 2
  filedelete, %workdir%\twocamcontrol_tempcam.txt
  if !xline1
    ;no cameras found
    return

  rightcam := InStr(xline1,rightcamserial) ? "0001" 
           :  InStr(xline2,rightcamserial) ? "0002" 
           :  ""

  leftcam  := xline1 and !InStr(xline1,rightcamserial) ? "0001" 
          :   xline2 and !InStr(xline2,rightcamserial) ? "0002" 
          :   ""
}



;CONNECT CAMERAS, ENABLE PHOTO MODE, APPLY AUTO ZOOM
#IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
*Numpad4::
*F4::
bf4:

if wkey or akey
  return

left_only   := ckey and !skey ? 1 : 0   ;connect only left cam
right_only  := !ckey and skey ? 1 : 0   ;connect only right cam

;verify setup workdir, cam serial, chdkptp path
if !InStr(FileExist(workdir), "D")
  msg_and_reload("Error: working directory does not exist.")
SplitPath, chdkptp,xname,xdir
if !FileExist(chdkptp) or (xname != "chdkptp.exe")
  msg_and_reload("Error: chdkptp path incorrect.")
if !rightcamserial
  msg_and_reload("Error: rightcamserial setting missing.")

;disable setup tab during project
loop,parse,setup_items,`,
  dis(a_loopfield)  ;disable setup tab items
dis("Setup")        ;disable setup tab

;check and connect cameras -> sets variables rightcam and leftcam
checkcams()

if !rightcam and !leftcam ;no cameras detected
  msg_and_reload("Error: could not detect cameras.")

if leftcam and !right_only and !left_connected
  pid1 := connect_cam(chdkptp, leftcam, gui_width, 38)
if rightcam and !left_only and !right_connected
  pid2 := connect_cam(chdkptp, rightcam, gui_width, 367)
sleep(500)

;get zoom step range for each camera, returns blank if fail
if !right_only and !left_connected
  if acti(leftcam) and !alt_zoom_method
    left_zoom_range   := get_zoom("left", "return get_zoom_steps()") , sleep(500)

if !left_only and !right_connected
  if acti(rightcam) and !alt_zoom_method
    right_zoom_range  := get_zoom("right", "return get_zoom_steps()")

;calculate 5% zoom in steps for each camera, at minimum 1 step
;examples: 128 range camera -> 6 steps , 9 range camera -> 1 step
zp := 0.05
right_percentage_steps  := return_largest( round(right_zoom_range  * zp) , 1)
left_percentage_steps   := return_largest( round(left_zoom_range   * zp) , 1)

;auto zoom using Setup/ini values
if (auto_zoom_left > 0)
  if !right_only and !left_connected
    if acti(leftcam)
      if !alt_zoom_method
        zoom_set("left", auto_zoom_left)
      else
        ;use alternative zoom click method
        Loop, % auto_zoom_left
          zoom_click("left", "zoom_in"), sleep(300)

if (auto_zoom_right > 0)
  if !left_only and !right_connected
    if acti(rightcam)
      if !alt_zoom_method
        zoom_set("right", auto_zoom_right)
      else
        ;use alternative zoom click method
        Loop, % auto_zoom_right
          zoom_click("right", "zoom_in"), sleep(300)


;mark camera as connected
;avoids error from chdkptp connecting an already connected camera
left_connected  := !right_only ? 1 : left_connected
right_connected := !left_only  ? 1 : right_connected

actiscript()

;disable all hotkeys/buttons
hotoff(all_hotkeys "," all_numpad_hotkeys)
hotoffglobal(all_global_hotkeys)
dis(all_buttons)
;enable configuration hotkeys/buttons
ena("bf5,bf5b,bmenu,bf6,bf6b,bf6c,bf7")
hoton("*F5,*F6,F7")
if (numpadkeys = 1)
  hoton("*Numpad5,*Numpad6,Numpad7,NumpadAdd,NumpadSub")
return


;function: connect camera 
;use enumeration part of the device id string (0001 or 0002)
connect_cam(chdkptp, thiscam, xpos, ypos)
{
  sleep 500
  Run, %comspec% /k ""%chdkptp%" -c"-d=%thiscam%" -i -e"luar switch_mode_usb(1)"" ,,,campid
  sleep 500
  Process, Priority, %campid%, High
  Winwait, %thiscam% ahk_exe cmd.exe,,2
  WinMove,%thiscam% ahk_exe cmd.exe,, %xpos%, %ypos%,,332
  return campid
}


;function: get zoom range or current zoom position from a camera
; returns from chdkptp's get_zoom_range() or get_zoom() on the camera
; returns blank on fail
; note: chdkptp file writes to a_ScriptDir
get_zoom(which, command)
{
  FileDelete, % A_ScriptDir "\twocamcontrol_zoom_temp.txt"
  xsif("!var = con:execwait('" command "')",%which%cam)
  xsif("!file = io.open('twocamcontrol_zoom_temp.txt', 'w')",%which%cam)
  xsif("!file:write(tostring(var))",%which%cam)
  xsif("!file:close()",%which%cam)
  Loop, 20
  {
    ;wait for file write
    if FileExist(A_ScriptDir "\twocamcontrol_zoom_temp.txt")
      break
    sleep 50
  }
  FileRead, zoom, % A_ScriptDir "\twocamcontrol_zoom_temp.txt"
  return zoom
}


;function: return the largest of two inputs
return_largest(a, b) 
{
  return a < b ? b : a
}



;ZOOM
#IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
*F5::
*Numpad5::
NumpadSub::
NumpadAdd::
bf5:
bf5b: ;out
zoom_in_mini:
zoom_out_mini:

if wkey or akey
  return

;zoom which cameras?
left_only   := ckey and !skey ? 1 : 0   ;connect only left cam 
right_only  := !ckey and skey ? 1 : 0   ;connect only right cam

;zoom in or out? (+ = in, - = out)
in_out := InStr("|bf5b|NumpadSub|zoom_out_mini|", "|" A_ThisLabel "|") or (A_ThisLabel = "*Numpad5" and nkey) ? "-" : "+"

;zoom big (5%) or small (a minimal step) amount?

; 2018-08-26: Notes from test on cameras with 128 zoom step range
; Zooming one step (+1) only works once in a row, we must zoom out
; or zoom in more for (+1) to work again.
; Zooming two steps (+2) always works.
; Therefore consider two steps minimal on 128 zoom step range cameras.
; 2018-09-24: CHDK cameras vary in zoom step range from 8 to 202.
; For now use two steps if zoom step range >60 and otherwise one step.
; >60 is a guesstimate after chdkptp forum discussion.

minimal_left   := left_zoom_range  > 60 ? 2 : 1
minimal_right  := right_zoom_range > 60 ? 2 : 1

left_zoom_size  := InStr("|*F5|*Numpad5|bf5|bf5b|", "|" A_ThisLabel "|") ? left_percentage_steps  : minimal_left
right_zoom_size := InStr("|*F5|*Numpad5|bf5|bf5b|", "|" A_ThisLabel "|") ? right_percentage_steps : minimal_right

;If user enables "Alt Zoom" in Setup then alt_zoom_method=1 and we use the zoom_click method.
;Also use zoom_click method if left_zoom_range/right_zoom_range is false because get_zoom failed.

sleep(200)
if !right_only
  if left_zoom_range and !alt_zoom_method
    zoom_steps("left", in_out, left_zoom_size)
  else
    zoom_click("left", in_out = "+" ? "zoom_in" : "zoom_out")

if !left_only
  if right_zoom_range and !alt_zoom_method
    zoom_steps("right", in_out, right_zoom_size)
  else
    zoom_click("right", in_out = "+" ? "zoom_in" : "zoom_out")
actiscript()
return


;function: click zoom
;used by alternative zoom method
zoom_click(which, in_out){
  if acti(%which%cam)
    xsif("luar click('" in_out "')",%which%cam)
}


;function: zoom X steps
zoom_steps(which, in_out, steps){
  if acti(%which%cam)
    xsif("luar set_zoom_rel('" in_out steps "')",%which%cam)
}


;function: set zoom position
zoom_set(which, zoom_position){
  if acti(%which%cam)
    xsif("luar set_zoom('" zoom_position "')",%which%cam)
}


;zoom menu: options to store current zoom as autozoom or restore zoom from previous projects
bmenu:
if alt_zoom_method
  ;disable menu when user has chosen the alternative zoom mode
  return

menu, twocam_zoom_menu, add
Menu, twocam_zoom_menu, Delete ;clear old

Menu, twocam_zoom_menu, Add, Store current zooms as auto zooms, store_to_auto_zoom
Menu, twocam_zoom_menu, Add, zoom out completely, zoom_out_completely

menu, twocam_previous, add
Menu, twocam_previous, Delete ;clear old
menu, twocam_previous, add

For Key, Val in previous_array
  Menu, twocam_previous, Add, % Val, apply_previous_zoom

;submenu for reuse of zoom from previous projects
Menu, twocam_zoom_menu, Add, reuse previous project zooms, :twocam_previous
Menu, twocam_zoom_menu, Show
return


;store current zoom as auto zoom
store_to_auto_zoom:
sleep(500)
  if acti(leftcam)
    auto_zoom_left  := get_zoom("left", "return get_zoom()") , sleep(500)
  if acti(rightcam)
    auto_zoom_right := get_zoom("right", "return get_zoom()")
sleep(200)
actiscript()

if !isDigit(auto_zoom_left) and !isDigit(auto_zoom_right)
{
  msgbox, error: cannot read current zoom
  actiscript()
  return
}

FileEncoding, UTF-16
if isDigit(auto_zoom_left)
{
  GuiControl, , auto_zoom_left , % auto_zoom_left
  IniWrite, %auto_zoom_left% , %ini%, options, auto_zoom_left
}

if isDigit(auto_zoom_right)
{
  GuiControl, , auto_zoom_right, % auto_zoom_right
  IniWrite, %auto_zoom_right%, %ini%, options, auto_zoom_right
}
FileEncoding, UTF-8
return


;zoom out completely
zoom_out_completely:
zoom_set("left" , 0)
zoom_set("right", 0)
actiscript()
return


;function: apply zoom from previous project
;itemName format: YYYYMMDDhhmmss L85 R120
apply_previous_zoom(ItemName, ItemPos)
{
RegExMatch(ItemName, "^\d+ L(\d+) "   , zoom_left_temp)
RegExMatch(ItemName, "^\d+ .* R(\d+)$", zoom_right_temp)
if isDigit(zoom_left_temp1)
  zoom_set("left", zoom_left_temp1)
if isDigit(zoom_right_temp1)
  zoom_set("right", zoom_right_temp1)
actiscript()
}



;FOCUS LOCK 
#IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
*Numpad6::
*F6::
bf6:
bf6b:  ;off

if wkey or akey
  return

;focus action on which camera?
left_only   := ckey and !skey ? 1 : 0   ;connect only left cam
right_only  := !ckey and skey ? 1 : 0   ;connect only right cam

;focus lock or unlock? (0 = unlock , 1 = lock)
lock_unlock := A_ThisLabel = "bf6b" or (A_ThisLabel = "*Numpad6" and nkey) ? 0 : 1

sleep(500)

if !right_only
  if acti(leftcam)
    xsif("luar set_aflock(" lock_unlock ")",leftcam)
if !left_only
  if acti(rightcam)
    xsif("luar set_aflock(" lock_unlock ")",rightcam)
actiscript()
return


;NEW PROJECT + PREPARE RSINT
#IfWinActive, TwoCamControl ahk_class AutoHotkeyGUI
Numpad7::
F7::
bf7:

if wkey or akey
  return

proj := A_now
GuiControl,, proj, %workdir%\%proj% 
FileCreateDir, %workdir%\%proj%\
If !FileExist(workdir "\" proj "\")
  msg_and_reload("Error: could not create %workdir%\%proj%\ .")
;clear temp preview images
FileDelete, %workdir%\TCC_temppreview*.jpg

;add current zooms to zoom history array and ini
;format: YYYYMMDDhhmmss L30 R45|YYYYMMDDhhmmss L20 R20|...

if acti(leftcam)
  zoom_left  := get_zoom("left", "return get_zoom()"), sleep(500)
if acti(rightcam)
  zoom_right := get_zoom("right", "return get_zoom()")
 actiscript()

if !isDigit(zoom_left)
  zoom_left := 0
if !isDigit(zoom_right)
  zoom_right := 0
previous_array.InsertAt(1, proj " L" zoom_left " R" zoom_right)
;keep at most 5 zooms
if ( previous_array.MaxIndex() > 5 )
  previous_array.Pop()
;write to ini
previous_zooms := ""
For Key, Val in previous_array
  previous_zooms .= key = previous_array.MaxIndex() ? Val : Val "|"

FileEncoding, UTF-16
IniWrite, %previous_zooms% , %ini%, options, previous_zooms
FileEncoding, UTF-8

;apply rsintoptions
if pcsave
{
  if acti(leftcam)
    xsif("rsint " rsintoptions,leftcam), sleep(200)
  if acti(rightcam)
    xsif("rsint " rsintoptions,rightcam)
  actiscript()
}

;disable all hotkeys/buttons
hotoff(all_hotkeys "," all_numpad_hotkeys)
hotoffglobal(all_global_hotkeys)
dis(all_buttons)
;enable project hotkeys/buttons
ena("bf8,bf9")
hotonglobal("F8,F9")
if numpadkeys
  hotonglobal("Numpad8,Numpad9,NumpadEnter,Numpad3")
if mousewheelshoot
  hotonglobal("WheelDown")
if spaceshoot
  hotonglobal("Space")

;run extra process at project start with project name timestamp (YYYYMMDDhhmmss) param
if ( proc = 1 and FileExist(extraprocess) )
  Run, "%extraprocess%" %proj%

return


;GREEN TEXT BUTTONS

;toggle first file name enumeration for this session
fileenum:
enum := enum > 9000 ? 0000 : enum + 1000
count_string := SubStr("000000000000" . counter+enum, -3) ;pad 1 to 0001
GuiControl,, fileenum, next filename %count_string%
return


;toggle sleep time for this session
sleeptime:
wait += wait = 1500 ? -1500 : 100
GuiControl,, sleeptime, wait %wait%  ;temp change, don't save to ini
return


;toggle extraprocess for this session
proc:
GuiControl,, proc, % proc ? "only save" : "extraprocess"
proc := !proc
return


;toggle camera LCD display on/off (saves battery)
#IfWinActive
Numpad3::
screenstate:
if !proj
  return
;only toggle after a project is created
GuiControl,, screenstate, % screenstate ? "camera LCD off" : "camera LCD on"
screenstate := !screenstate
if acti(leftcam)
  xs("exec set_lcd_display(" screenstate ")",leftcam), sleep(200)
if acti(rightcam)
  xs("exec set_lcd_display(" screenstate ")",rightcam)
actiscript()
return


;PAUSE: disable shoot hotkeys, temp change GUI background color
#IfWinActive
F9::
bf9:
Numpad9::

if wkey or akey
  return
if !proj
  return

Gui, 1:Default  ;operate on first gui
pau := !pau   ;pau var starts at 0
col := pau = 1 ? "F6CECE" : "ffffff"  ;red or white
Gui, Color, %col%
toggle := pau ? "off" : "on"
;hot%toggle%("F8")
hot%toggle%global("F8")
if (mousewheelshoot = 1)
  hot%toggle%global("WheelDown")
if (spaceshoot = 1)
  hot%toggle%global("Space")
if (numpadkeys = 1)
  hot%toggle%global("Numpad8")
pmode := pau ? "dis" : "ena"
%pmode%("bf8")
return


;SHOOT
#IfWinActive
F8::
bf8:
Numpad8::
WheelDown::
Space::
if wkey or akey
  return
if (pau = 1) or !proj
  return

pau := 1
counter := !counter ? 1 : counter
count_string := SubStr("000000000000" . counter+enum, -3) ;pad 1 to 0001
Gui, Color, silver
sleep(wait)
if pcsave  ;do *not* enclose path in rsint mode
{
  if acti(leftcam)
    xs("path " workdirfrontslash "/" proj "/" count_string "R",leftcam),  xs("s", leftcam)
  if acti(rightcam)
    xs("path " workdirfrontslash "/" proj "/" count_string "L",rightcam), xs("s", rightcam)
}
if !pcsave
{
  if acti(leftcam)
    xs("shoot " rsintoptions,leftcam)
  if acti(rightcam)
    xs("shoot " rsintoptions,rightcam)
}
actiscript()

pau := 0
Gui, Color, D3E3D3 ;green
counter++
count_string := SubStr("000000000000" . counter+enum, -3) ;pad 1 to 0001
GuiControl,, fileenum, next filename %count_string%
Gui, Submit, NoHide
return


#IfWinActive
NumpadEnter:: ;save blank txt, for troubleshooting
save_txt_count:
fileappend,,%workdir%\%proj%\%count_string%.txt  ;0003.txt  = count of last saved images
return


;numpad modifier keys
;also prevents sending 012 chars accidentally to cmd window
#IfWinActive, ahk_Exe cmd.exe
Numpad0:: nkey := 1
Numpad1:: ckey := 1
Numpad2:: skey := 1
return


;function: return 1 if input is non-empty and contains only 0123456789 chars
isDigit(x){
if (x != "")      ;not empty
  if x is digit   ;only 0123456789 chars
    return 1
}


;function: sleep
sleep(x) {
  sleep %x%
}


;function: msgbox errormessage and reload script
msg_and_reload(x) {
  msgbox, %x% 
  reload
}
