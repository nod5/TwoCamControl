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
version 2018-01-12
by Nod5 -- github.com/nod5/TwoCamControl
Free Software -- GPL3
Tested in Win10 x64

**********************
FEATURES
Shoots two cameras at (almost) the same time and quickly.
Saves each photo directly to the PC.
Very quick (thanks to the chdkptp rsint command).
Trigger cameras with a GUI button, keyboard shortcut or mouse wheel.
Autonames files in sequence 0001L.jpg 0001R.jpg 0002L.jpg ...

CONTROLS - BASIC WORKFLOW
1. Connect cameras. 
2. Adjust Zoom and Focus. Preview shots with current settings. 
3. When the settings are good start a New Project and Shoot. 

DEPENDENCIES
1. Two Canon cameras with CHDK installed  
Use the latest development version of CHDK  
http://chdk.wikia.com/wiki/CHDK_in_Brief  
http://chdk.wikia.com/wiki/Downloads  
2. The cameras must have filewrite support  
http://chdk.wikia.com/wiki/CameraFeatureTable , see FWT column  
3. Libusb drivers installed for both cameras on PC
http://chdk.wikia.com/wiki/PTP_Extension#LibUSB_Driver_for_Windows  
4. chdkptp downloaded and unzipped  
https://www.assembla.com/spaces/chdkptp/wiki  
5. Only if you wish to run/build TwoCamControl from source: install Autohotkey,  https://autohotkey.com/  

REQUIRED SETUP
- set workdirectory path
- set chdkptp path
- set right camera serial

OPTIONAL SETUP (DEFAULT VALUE)
- Zoom steps (0): Auto zoom in this number of steps when cameras connect
- Wait (400): Wait this number of miliseconds before the camera shoots. Use this to add a delay in a hardware setup where shoots are triggered by a mousewheel that the platen touches on its way down. Set to 0 for no delay.
- Mousewheel (off): Mouse wheel down triggers a shoot
- Numpad keys (off): Activate numpad key controls (see below)
- Space (off): Space button triggers a shoot
- No PC Save (off): Saves shots to camera SD cards (not to PC). Uses chdkptp "shoot" command with parameters set by user in the rsint options field. Try parameter raw=1 for raw shoot.
- rsint options (-cmdwait=600 -tv=1/160): parameters for the rsint command. See usage.txt in chdkptp for details. Cmdwait is number of seconds until rsint times out.
- extraprocess (blank): Path to some external tool to run at project start. Example: C:\folder\program.exe . TwoCamControl sends the project name as a command line parameter. The project name is a timestamp (YYYYMMDDhhmmss).

To reset to default values delete TwoCamControl.ini and restart TwoCamControl.

CONTROLS - TIPS AND TRICKS
- Hold shift/control to apply zoom or focus command only to right/left side camera.
- Mouse wheel down: Shoot photo. Useful with a wireless mouse.
- Space button: Shoot photo.
- Numpad keys: useful with wireless numpad
 4 = connect cameras
 5 = zoom
 6 = focus lock
 7 = new project
 8 = shoot photo
 9 = pause
 hold 1 + 5 = zoom only left side camera
 hold 2 + 6 = focus only right side camera
 hold 0 + 5/6 = zoom out/focus unlock
 hold 0 & 1 + 5 = zoom out left side camera
- Right click on Preview: show the same preview again.
- Right click on Project: cancel current project but keep cameras on.
- Click on green text for a single session change of that setting.
- Right click Shoot button or press NumpadEnter: save a textfile with current count 0004.txt . Useful as a reminder for post shoot file check for example when a page was accidentally shot twice.
- Close TwoCamControl: also powers off cameras.

FEEDBACK
GitHub , https://github.com/nod5/TwoCamControl
DIY Book Scanner forum , https://forum.diybookscanner.org/viewtopic.php?f=20&t=3082

TROUBLESHOOTING
Q  What if camera serial setup step fails?
A  Set camera serial manually: plug in and power on camera, open a cmd window in the chdkptp.exe folder, run the command "chdkptp.exe -elist" and look for the serial. It looks something like this: DC3E13D4111234B2A23CC31F2E3AA5 . TwoCamControl uses the serial to identify which camera is which.

Q  How to solve "ERROR: not in continous mode"?
A  Power on the camera with CHDK on the SD card without connecting it to the PC, press "func" button on the camera, go to the menu item that allows setting continuous mode and turn it on. Power off the camera and try TwoCamControl again.

Q  What if Chkdptp cmd win shows error about filepath?
A  Try changing workdirectory path to not include special or non-english characters. Test with only a-z 0-9 space.

Q  Can I use TwoCamControl with only one camera?
A  Yes. Two cmd windows will still show, one with error messages, but the single camera will shoot and download photos successfully.
)

checkini()

checkini() {
global
ini = %A_scriptdir%\TwoCamControl.ini

ifnotexist, %ini% 
{
chdkptp := FileExist(A_ScriptDir "\chdkptp.exe") ? A_ScriptDir "\chdkptp.exe" : ""
initxt = 
(
[options]
workdir=%A_ScriptDir%
chdkptp=%chdkptp%
rightcamserial=
zoomsteps=
wait=400
mousewheelshoot=0
numpadkeys=0
spaceshoot=0
nopcsave=0
rsintoptions=-cmdwait=600 -tv=1/160
extraprocess=
savedzoom=
)
FileAppend, %initxt%, %ini%  ;create default ini
}

setupitems = workdir,chdkptp,rightcamserial,zoomsteps,wait,mousewheelshoot,numpadkeys,spaceshoot,nopcsave,rsintoptions,extraprocess,savedzoom
Loop, Parse, setupitems,`,
 IniRead, %A_LoopField%, %ini%, options, %A_LoopField%, %A_space%  ;read ini data
if !mousewheelshoot
 mousewheelshoot = 0
if !numpadkeys
 numpadkeys = 0
if !spaceshoot
 spaceshoot = 0
if !nopcsave
 nopcsave = 0
if extraprocess
 proc = 1
if !RegExMatch(wait,"^\d+$") ;not digits
 wait = 0
}

;prepare variables   ;zoomleft/zoomright track zoom level this session
scriptname := "TwoCamControl", enum := 0000, count := 1, pau := zoomleft := zoomright := 0
workdir := SubStr(workdir,0) == "\" ? SubStr(workdir,1,StrLen(workdir)-1) : workdir ;trim end slash
workdirfrontslash := StrReplace(workdir, "\","/") ;chdkptp uses frontslashes

;Create Gui
xwidth := 330 , xheight := 500
Gui, Add, Tab2, x0 y0 w%xwidth% h%xheight%, Main|Setup|Help

;Gui Main tab
Gui, font, s12 bold
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf4 gbf4 Default,(F4) Connect Cameras
GuiControl, -default, bf4
Gui, Add, Button, vbf5 gbf5,(F5) Zoom In
Gui, Add, Button, vbf5b gbf5b yp x+10,Out
Gui, Add, Button, vbsz gbsz yp x+20,saved
Gui, Add, Button, vbf6 gbf6 y+6 xm,(F6) Focus Lock 
Gui, Add, Button, vbf6b gbf6b yp x+8,Unlock 
Gui, Add, Button, vbf6c gbf6c yp x+8,Preview
Gui, Add, text,,%A_space%
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf7 gbf7 y+0 xm,(F7) New Project
Gui, Add, text,,%A_space%
Gui, Add, Button, vbf8 gbf8,(F8) Shoot
Gui, Add, Button, vbf9 gbf9,(F9) Pause
;disable/enable buttons and hotkeys
dis("bsz,bf5,bf6,bf5b,bf6b,bf6c,bf7,bf8,bf9")
hotoff("F4,+F4,^F4,F5,+F5,^F5,+#F5,^#F5,F6,+F6,^F6,+#F6,^#F6,F7,F8,F9,WheelDown,Space")
hotoff("Numpad4,Numpad1 & Numpad4,Numpad2 & Numpad4,Numpad5,Numpad1 & Numpad5,Numpad2 & Numpad5,Numpad0 & Numpad6,Numpad6,Numpad1 & Numpad6,Numpad2 & Numpad6,Numpad0 & Numpad6,Numpad7,Numpad8,Numpad9,NumpadEnter")
hoton("F4,+F4,^F4") ;enable only connect camera commands at start
if (numpadkeys == 1)
 hoton("Numpad4,Numpad1 & Numpad4,Numpad2 & Numpad4")
Gui, font, normal cgreen 
Gui, add, text,vfileenum gfileenum w160,filename count 0001
Gui, add, text,vsleeptime gsleeptime yp+20 w80, wait %wait%
Gui, add, text,vproc gproc yp+20 w100,extraprocess
Gui, font, s10 cblack 
Gui, add, text,vproj yp+20 w300,
Gui, font, cgray
Gui, Add, text,vapply xm+2 y174 w300,both cameras
Gui, Add, GroupBox, w2 h150 y40 x7,

;Gui Setup tab 
Gui, Tab, 2
setupw := xwidth-15
Gui, font, s10 normal black
Gui, Add, text,x8 y33,Note: see REQUIREMENTS in Help first.
Gui, font, s12 bold black
Gui, Add, text,yp+25,projects work directory
Gui, font, s10 normal
Gui, Add, edit, w300 h20 yp+20 vworkdir gworkdir,%workdir%
Gui, Add, text,w%setupw%,Path to folder where each project subfolder is created and photos saved. Example: C:\test\folder

Gui, font, s12 bold
Gui, Add, text,yp+36,chdkptp path
Gui, font, s10 normal
Gui, Add, edit, w300 h20 vchdkptp gchdkptp yp+21,%chdkptp%
Gui, Add, text,w%setupw% yp+22,Example: C:\some folder\chdkptp\chdkptp.exe 

txtser = A special serial number (not printed on the camera). Take the camera you will later place to the right of the book. Plug in that camera to the PC with USB. Power on the camera. Then click the Setup button. 

Gui, font, s12 bold
Gui, Add, text,,Right cam serial
Gui, font, s10 normal
Gui, Add, button, yp-4 xp+140 vsetup gsetup,Setup
Gui, Add, edit, xp-140 yp+29 w300 h20 vrightcamserial grightcamserial,%rightcamserial%
Gui, Add, text,yp+22 w%setupw%,%txtser%

Gui, font, s10 bold
Gui, Add, text,y+30 ,Zoom steps
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+9 w25 h20 vzoomsteps gzoomsteps,%zoomsteps%
Gui, Add, text, yp+2 x+5 w160, when cameras connect

;wait = 400
Gui, font, s10 bold
Gui, Add, text,x56 yp+20,Wait
Gui, font, s10 normal
Gui, Add, edit, yp-2 x+9 w45 h20 vwait gwait,%wait%
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

;nopcsave
Gui, font, s10 bold
Gui, Add, text,xp+27 yp,No PC Save
Gui, font, s10 normal
Gui, Add, Checkbox, yp x+7 w17 h20 Checked%nopcsave% vnopcsave gnopcsave

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
helpw := xwidth-10 , helph = xheight-25
Gui, Add, Edit, ReadOnly x5 y22 w%helpw% h%helph%  vMyEdit, %helptext%

Gui, Tab, 1 ;default tab

Gui, Show, w%xwidth% h%xheight% x0 y0, %scriptname%
WinSet, AlwaysOnTop, On, %scriptname%

SetTimer, modkeycheck, 50
return

;save to ini on editbox change
workdir:
chdkptp:
rightcamserial:
zoomsteps:
wait:
mousewheelshoot:
rsintoptions:
numpadkeys:
spaceshoot:
nopcsave:
extraprocess:
gui,submit,nohide
tempkey := a_thislabel      ;wait
tempedit := %a_thislabel%   ;400
IniWrite, %tempedit%, %ini%, options, %tempkey%
if (a_thislabel == "wait")
 GuiControl,, sleeptime, wait %tempedit%
if (a_thislabel == "workdir")
{
workdir := SubStr(workdir,0) == "\" ? SubStr(workdir,1,StrLen(workdir)-1) : workdir ;trim end slash
workdirfrontslash := StrReplace(workdir, "\","/") ;chdkptp uses frontslashes
}
return

;use chdkptp to read connected camera serial number
setup:
if !FileExist(chdkptp) or (SubStr(chdkptp, -10) != "chdkptp.exe")
 msg_and_reload("Error: set chdkptp.exe path first.")
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
acti(leftcam),  xs("rs '" workdir "/TCC_temppreviewL' " tempoptions,leftcam), sleep(200)
acti(rightcam), xs("rs '" workdir "/TCC_temppreviewR' " tempoptions,rightcam), actiscript()

ShowPreviewAgain:
Loop ;wait for one pic saved
{
if FileExist(workdir "\TCC_temppreview*.jpg")
 break
sleep 100
if a_index = 60  ;abort after 6 secs
 return
}
LR := FileExist(workdir "\TCC_temppreviewL.jpg") ? "L" : "R"
Run %workdir%\TCC_temppreview%LR%.jpg ;preview in default image viewer
return

;Hold Control/Shift to apply hotkey command only to L/R camera
modkeycheck:
GetKeyState, skey, Shift
GetKeyState, ckey, Control
GuiControl,,apply, % skey == ckey ? "both cameras" : skey == "D" ? "right side camera" : "left side camera"
return

;hotkey/button enable/disable functions
dis(d) {
Loop, Parse, d,`,
 GuiControl, disable, %A_LoopField% 
}
ena(d) {
Loop, Parse, d,`,
 GuiControl, enable, %A_LoopField% 
}
hotoff(h) {
Loop, Parse, h,`,
Hotkey, %A_LoopField%, Off
}
hoton(h) {
Hotkey, IfWinActive, %scriptname%
Loop, Parse, h,`,
 Hotkey, %A_LoopField%, On
}
hotonglobal(h) {
Hotkey, IfWinActive
Loop, Parse, h,`,
 Hotkey, %A_LoopField%, On
}

GuiClose: 
if proj && !nopcsave ;if proj has started  ;exit rsint mode
 acti(leftcam), xs("q",leftcam), acti(rightcam), xs("q",rightcam), sleep(2000)
if (pid1 or pid2) ;if cameras connected  ;shut down cameras
 acti(leftcam), xs("luar shut_down()",leftcam), acti(rightcam), xs("luar shut_down()",rightcam), sleep(2000)
Process, Close, chdkptp.exe
sleep 200
Process, Close, chdkptp.exe
sleep 200
loop, 2
 WinClose, ahk_exe cmd.exe
FileDelete, %workdir%\TCC_temppreview*.jpg ;clean temp preview images
ExitApp

GuiContextMenu:  ;right click in gui
GuiControlGet, PreviewButEnabled, Enabled, bf6c
menu, twocam_menu, add
Menu, twocam_menu, Delete ;clear old
if (proj and A_GuiControl=="bf7")  ;right click button (F7) New Project
{
 Menu, twocam_menu, Add,Cancel Project, CancelProject
 Menu, twocam_menu, Show
}
else if (proj and !pau and A_GuiControl=="bf8")  ;right click button (F8) Shoot
{
 Menu, twocam_menu, Add,Save %xc%.txt, NumpadEnter  ;save blank txt, for troubleshooting
 Menu, twocam_menu, Show
}
else if (PreviewButEnabled and A_GuiControl=="bf6c")  ;right click button Preview
{
 Menu, twocam_menu, Add,Show same preview again, ShowPreviewAgain
 Menu, twocam_menu, Show
}
return

CancelProject: ;exit rsint, clear vars, unlock focus, ready cameras
if proj ;exit rsint
acti(leftcam), xs("q",leftcam), acti(rightcam), xs("q",rightcam), sleep(1000)
enum := 0000, count := 1, proj := "" ;reset count
gosub #F6  ;R L focus lock off
;keep other vars, since (F7) New project will set them
;enable/disable hotkeys and buttons
dis("bsz,bf5,bf6,bf5b,bf6b,bf6c,bf7,bf8,bf9")
hotoff("F4,+F4,^F4,F5,+F5,^F5,+#F5,^#F5,F6,+F6,^F6,+#F6,^#F6,F7,F8,F9,WheelDown,Space")
hotoff("Numpad4,Numpad1 & Numpad4,Numpad2 & Numpad4,Numpad5,Numpad1 & Numpad5,Numpad2 & Numpad5,Numpad0 & Numpad6,Numpad6,Numpad1 & Numpad6,Numpad2 & Numpad6,Numpad0 & Numpad6,Numpad7,Numpad8,Numpad9,NumpadEnter")
ena("bsz,bf5,bf6,bf5b,bf6b,bf6c,bf7"), hoton("F5,+F5,^F5,+#F5,^#F5,F6,+F6,^F6,+#F6,^#F6,F7")
if (numpadkeys == 1)
 hoton("Numpad5,Numpad1 & Numpad5,Numpad2 & Numpad5,Numpad0 & Numpad6,Numpad6,Numpad1 & Numpad6,Numpad2 & Numpad6,Numpad0 & Numpad6,Numpad7")
return


actiscript() { ;activate script main window
global
WinActivate, %scriptname%
}

acti(y) { ;activate cmd window based on device num (d=0001 or d=00002) in win title
If !WinExist("d=" y " ahk_exe cmd.exe")
 return
WinActivate, d=%y% ahk_exe cmd.exe
WinWaitActive, d=%y% ahk_exe cmd.exe
}

sleep(x) {
sleep %x%
}

msg_and_reload(x) {  ;msgbox errormessage and reload script
msgbox, %x% 
reload
}

xs(x,y) {  ;send command x string to camera y's cmd window
x := unicodify(x)
If WinActive("d=" y " ahk_exe cmd.exe")
 SendInput,%x%{enter}
}

xsif(x,y) {  ;send command x string to camera y's cmd window
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

unicodify(x) {
;workaround for sendinput char error in chdkptp interactive CLI with win10 non-eng
;note: in unicode scripts asc() returns unicode value
;note: Setformat can make asc() output hex, for SendInput {U+nnnn} use.
;old TwoCamControl ansify() flaw: sent ascii {ASC nnnn} and only for some chars
; https://autohotkey.com/docs/commands/Asc.htm
; https://autohotkey.com/docs/commands/SetFormat.htm
; https://autohotkey.com/docs/commands/Send.htm
;note: special key {enter} fail if passed through unicodify() so send it as is
SetFormat, IntegerFast, Hex
Loop, Parse, x
 uni .= "{U+" Asc(A_LoopField) "}"
SetFormat, IntegerFast, Decimal
return uni
}

;link cameras to left/right side based on right camera serial number
checkcams() {
global
if (pid1 or pid2) ;already checked this session, avoid camera error on second -elist run
 return
filedelete, %workdir%\chdkptptemp.txt
RunWait, %comspec% /c ""%chdkptp%" -elist > "%workdir%\chdkptptemp.txt"",,Hide
sleep 100
FileReadLine, xline, %workdir%\chdkptptemp.txt, 1
filedelete, %workdir%\chdkptptemp.txt
if !xline
 return
rightcam := InStr(xline,rightcamserial) ? "0001" : "0002"
leftcam := InStr(xline,rightcamserial) ? "0002" : "0001"
}


;CONNECT CAMERAS, ENABLE PHOTO MODE, ZOOM DEFAULT STEPS
bf4:
Gui, Submit, NoHide
mod := ckey == skey ? "" : ckey == "D" ? "^" : "+"  ;Control/Shift modifier
goto %mod%F4

Numpad4:: goto F4              ;both
Numpad1 & Numpad4:: goto ^F4  ;left only
Numpad2 & Numpad4:: goto +F4  ;right only
F4::
+F4::
^F4::

;Verify setup workdir, cam serial, chdkptp path
if !InStr(FileExist(workdir), "D")
  msg_and_reload("Error: working directory does not exist.")
SplitPath, chdkptp,xname,xdir
if !FileExist(chdkptp) or (xname != "chdkptp.exe")
 msg_and_reload("Error: chdkptp path incorrect.")
if !rightcamserial
 msg_and_reload("Error: rightcamserial setting missing.")

;Disable setup tab during project
loop,parse,setupitems,`,
 dis(a_loopfield)  ;disable setup tab items
dis("setup")       ;disable setup tab

checkcams() ;detect cameras
if !rightcam  ;no camera detected
 msg_and_reload("Error: could not start cameras.")

left_only  := SubStr(A_ThisLabel,1,1) == "^" ? 1 : 0 ;control = connect only left
right_only := SubStr(A_ThisLabel,1,1) == "+" ? 1 : 0 ;shift   = connect only right

if !right_only and !Lcon
 pid1 := connect_cam(chdkptp, leftcam, xwidth, 38)
if !left_only and !Rcon
 pid2 := connect_cam(chdkptp, rightcam, xwidth, 367)

connect_cam(chdkptp, thiscam, xpos, ypos)
{
  sleep 500
  Run, %comspec% /k ""%chdkptp%" -c"-d=%thiscam%" -i -e"luar switch_mode_usb(1)"" ,,,campid
  sleep 500
  Process, Priority, %campid%, High
  Winwait, %thiscam% ahk_exe cmd.exe,,2
  WinMove,%thiscam% ahk_exe cmd.exe,, %xpos%, %ypos%
  return campid
}

if (zoomsteps > 0)  ;apply zoom steps (var from setup/ini)
 sleep 1000
loop, %zoomsteps%
{
sleep(500)
if !right_only and !Lcon
 acti(leftcam),  xsif("luar click('zoom_in')",leftcam),  zoomleft += z(in_out)
if !left_only and !Rcon
 acti(rightcam), xsif("luar click('zoom_in')",rightcam), zoomright += z(in_out)
}
Lcon .= !right_only ? 1 :  ;connect cam only once, to avoid chdkptp error
Rcon .= !left_only  ? 1 :

actiscript()
ena("bsz,bf5,bf6,bf5b,bf6b,bf6c,bf7"), hoton("F5,+F5,^F5,+#F5,^#F5,F6,+F6,^F6,+#F6,^#F6,F7")
if (numpadkeys == 1)
 hoton("Numpad5,Numpad1 & Numpad5,Numpad2 & Numpad5,Numpad0 & Numpad6,Numpad6,Numpad1 & Numpad6,Numpad2 & Numpad6,Numpad0 & Numpad6,Numpad7")
return

;zoomlevel tracker update
z(in_out) {
return in_out == "zoom_out" ? -1 : 1
}

;ZOOM
bf5:  ;zoom in button
bf5b: ;zoom out button
mod := ckey == skey ? "" : ckey == "D" ? "^" : "+"
in_out := StrLen(A_ThisLabel) == 4 ? "#" : ""
goto %mod%%in_out%F5

Numpad5:: goto F5  ;in
Numpad1 & Numpad5:: goto ^F5 ;in left
Numpad2 & Numpad5:: goto +F5 ;in right
Numpad0 & Numpad5:: 
if GetKeyState("Numpad1","P")
 goto ^#F5  ;out left
if GetKeyState("Numpad2","P")
 goto +#F5  ;out right
goto #F5    ;out

F5::  ;in
#F5:: ;out
^#F5:: ;out left
+#F5:: ;out right
^F5::  ;in left
+F5::  ;in right

left_only  := SubStr(A_ThisLabel,1,1) == "^" ? 1 : 0 ;control = zoom only left cam
right_only := SubStr(A_ThisLabel,1,1) == "+" ? 1 : 0 ;shift   = zoom only right cam
in_out := InStr(A_ThisLabel,"#") ? "zoom_out" : "zoom_in"
sleep(1000)
if !right_only
 zoom("left", in_out)
if !left_only
 zoom("right", in_out)
actiscript()
return

bsz:  ;Saved button. Re-apply zoom levels from last project, as read from ini
StringSplit, sz, savedzoom,|    ;7|7   saved zoomleft|zoomright var
sleep 500
;calculate adjustment and apply zoom
;zoomleft/zoomright = zoom steps done already this session, pos num or neg num or zero
dif_left := sz1 - zoomleft
in_out := dif_left > 0 ? "zoom_in" : "zoom_out"
loop, % Abs(dif_left)  ;absolute value, since dif_left can be negative
 sleep(500),  zoom("left", in_out)
dif_right := sz2 - zoomright
in_out := dif_right > 0 ? "zoom_in" : "zoom_out"
loop, % Abs(dif_right)
 sleep(500), zoom("right", in_out)
actiscript()
return

zoom(which, in_out){
acti(%which%cam), xsif("luar click('" in_out "')",%which%cam), zoom%which% += z(in_out)
}

;FOCUS LOCK 
bf6:    ;on
bf6b:   ;off
mod := ckey == skey ? "" : ckey == "D" ? "^" : "+"
on_off := StrLen(A_ThisLabel) == 4 ? "#" : ""
goto %mod%%on_off%F6

Numpad6:: goto F6  ;on
Numpad1 & Numpad6:: goto ^F6  ;on left
Numpad2 & Numpad6:: goto +F6  ;on right
Numpad0 & Numpad6:: 
if GetKeyState("Numpad1","P")
 goto ^#F6  ;off left
if GetKeyState("Numpad2","P")
 goto +#F6  ;off right
goto #F6    ;off

F6::   ;on
#F6::  ;off
^F6:: ;on left
+F6:: ;on right
^#F6:: ;off left
+#F6:: ;off right

left_only  := SubStr(A_ThisLabel,1,1) == "^" ? 1 : 0 ;control = only left cam
right_only := SubStr(A_ThisLabel,1,1) == "+" ? 1 : 0 ;shift   = only right cam
afmode := InStr(A_ThisLabel, "#") ? 0 : 1   ;0 unlock , 1 lock
sleep(1000)
if !right_only
 acti(leftcam),  xsif("luar set_aflock(" afmode ")",leftcam)
if !left_only
 acti(rightcam), xsif("luar set_aflock(" afmode ")",rightcam)
actiscript()
return

;NEW PROJECT + PREPARE RSINT
bf7:
Numpad7::
F7::
proj := A_now
GuiControl,, proj, %workdir%\%proj% 
FileCreateDir, %workdir%\%proj%\
ifnotexist, %workdir%\%proj%\
msg_and_reload("Error: could not create %workdir%\%proj%\ .")
FileDelete, %workdir%\TCC_temppreview*.jpg ;clean temp preview images

if !nopcsave  ;apply rsintoptions
   acti(leftcam),  xsif("rsint " rsintoptions,leftcam), sleep(200)
 , acti(rightcam), xsif("rsint " rsintoptions,rightcam), actiscript()

counttext := enum > 8000 ? 0000+count : enum+1000+count
GuiControl,, fileenum,filename count %counttext% 

dis("bsz,bf4,bf5,bf6,bf5b,bf6b,bf6c,bf7"), hotoff("F4,+F4,^F4,F5,+F5,^F5,+#F5,^#F5,F6,+F6,^F6,+#F6,^#F6,F7")
ena("bf8,bf9"), hotonglobal("F8,F9")
hotoff("Numpad4,Numpad1 & Numpad4,Numpad2 & Numpad4,Numpad5,Numpad1 & Numpad5,Numpad2 & Numpad5,Numpad0 & Numpad5,Numpad6,Numpad1 & Numpad6,Numpad2 & Numpad6,Numpad0 & Numpad6,Numpad7") 
if (numpadkeys == 1)
 hotonglobal("Numpad8,Numpad9,NumpadEnter")
if (mousewheelshoot == 1)
 hotonglobal("WheelDown")
if (spaceshoot == 1)
 hotonglobal("Space")

;save zoom states to ini for optional reuse in next session
zoomleft := !zoomleft ? 0 : zoomleft, zoomright := !zoomright ? 0 : zoomright
IniWrite, %zoomleft%|%zoomright%, %ini%, options, savedzoom

;run extra process at project start with project name timestamp (YYYYMMDDhhmmss) param
if ( proc==1 and FileExist(extraprocess) )
 Run, "%extraprocess%" %proj%
return


fileenum: ;toggle first file name enumeration for this session
enum := enum > 8000 ? 0000 : enum + 1000
counttext := enum == 0000 ? 0001 : enum + count
GuiControl,, fileenum, filename count %counttext%
return

sleeptime: ;toggle sleep time for this session
wait += wait == 1500 ? -1500 : 100
GuiControl,, sleeptime, wait %wait%  ;temp change, don't save to ini
return

proc:  ;toggle extraprocess for this session
GuiControl,, proc, % proc ? "only save" : "extraprocess"
proc := !proc
return

;PAUSE      ;global hotkey
bf9:
Numpad9::
F9::
Gui, 1:Default  ;operate on first gui
if !proj
 return
pau := !pau   ;pau var starts at 0
col := pau == 1 ? "F6CECE" : "Default"
Gui, Color, %col%
toggle := pau ? "Off" : "On"
if (mousewheelshoot == 1)
 Hotkey, WheelDown, %toggle%
if (spaceshoot == 1)
 Hotkey, Space, %toggle%
Hotkey, F8, %toggle%
if (numpadkeys == 1)
 Hotkey, Numpad8, %toggle%
pmode := pau ? "dis" : "ena"
%pmode%("bf8")
return

;SHOOT     ;global hotkey
bf8:
Numpad8::
WheelDown::
Space::
F8::
if (pau == 1) or !proj
 return
pau := 1
count := !count ? 1 : count
xc := SubStr("000000000000" . count+enum, -3) ;pad 1 to 0001
Gui, Color, silver
sleep(wait)
if !nopcsave  ;do *not* enclose path in rsint mode
   acti(leftcam),  xs("path " workdirfrontslash "/" proj "/" xc "R",leftcam),  xs("s", leftcam)
 , acti(rightcam), xs("path " workdirfrontslash "/" proj "/" xc "L",rightcam), xs("s", rightcam)
if nopcsave
   acti(leftcam),  xs("shoot " rsintoptions,leftcam)
 , acti(rightcam), xs("shoot " rsintoptions,rightcam)
pau := 0
Gui, Color, D3E3D3
count++
counttext := enum == 0000 ? 0001 : enum + count
GuiControl,, fileenum, filename count %counttext%
return

NumpadEnter:: ;save blank txt, for troubleshooting
fileappend,,%workdir%\%proj%\%xc%.txt  ;0003.txt  = count of last saved images
return
