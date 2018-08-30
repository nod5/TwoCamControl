# TwoCamControl

TwoCamControl.ahk  -  version 2018-08-30  -  by Nod5  -  GPLv3

Windows frontend for chdkptp with two cameras.

[Download latest TwoCamControl binary release](https://github.com/nod5/TwoCamControl/releases)


![Alt text](images/TwoCamControl1.PNG?raw=true)

![Alt text](images/TwoCamControl2.PNG?raw=true)

## Features
Shoot two cameras at (almost) the same time and quickly.  
Save each photo directly to the PC.  
Trigger cameras with a GUI button, keyboard or mouse wheel.  
Autonames files in sequence `0001L.jpg` `0001R.jpg` `0002L.jpg` ...  

## Controls - Basic Workflow
1. `Connect` cameras.  
2. Adjust `Zoom` and `Focus`. `Preview`.  
3. When the settings are good start a `New Project` and `Shoot`.  

## Dependencies
1. Two Canon cameras with **CHDK** installed. Use the latest development version of CHDK.
http://chdk.wikia.com/wiki/CHDK_in_Brief  
http://chdk.wikia.com/wiki/Downloads  
2. The cameras must have filewrite support. See FWT column here:  
http://chdk.wikia.com/wiki/CameraFeatureTable  
3. **LibUSB** drivers installed for both cameras on PC.  
http://chdk.wikia.com/wiki/PTP_Extension#LibUSB_Driver_for_Windows  
4. **chdkptp** downloaded and unzipped.  
https://www.assembla.com/spaces/chdkptp/wiki  
5. Only if you want to run/build TwoCamControl from source:  
Install AutoHotkey https://autohotkey.com and save the .ahk with UTF-8 BOM encoding  

## Required Setup in TwoCamControl  
- Set workdirectory path  
- Set path to `chdkptp.exe`  
- Set right camera serial  

## Optional Settings (Default Value)
- **Auto zoom (0)** Auto zoom this number of steps when right/left camera connects.  
- **Wait (400)** Wait this number of miliseconds before the camera shoots. Use this to add a delay in a hardware setup where shoots are triggered by a mousewheel that the platen touches on its way down. Set to 0 for no delay.  
- **Mousewheel (off)** Mouse wheel down triggers a shoot.  
- **Numpad keys (off)** Activate numpad key controls (see below).  
- **Space (off)** Space button triggers a shoot.  
- **No PC Save (off)** Saves shots to camera SD cards (not to PC). Uses chdkptp `shoot` command with parameters set by user in the rsint options field. Try parameter raw=1 for raw shoot.  
- **rsint options (-cmdwait=600 -tv=1/160)** parameters for the `rsint` command. See file `USAGE.TXT` in chdkptp for more. `cmdwait` is the number of seconds until rsint times out.  
- **extraprocess ()** Path to some external tool to run at project start. Example: `C:\folder\program.exe` . TwoCamControl sends the project name as a command line parameter. The project name is a timestamp (YYYYMMDDhhmmss).  

On Main tab: Click on green text for a single session change of that setting.  

Reset to default settings: delete `TwoCamControl.ini` and restart TwoCamControl.  

## Controls - Tips and Tricks
- Hold `Shift` / `Control` to apply zoom or focus command only to right/left side camera.  
- `Mouse wheel` down: Shoot photo. Useful with a wireless mouse.  
- `Space`: Shoot photo.  
- `Numpad` keys. Useful with a wireless numpad.
  - `3` = camera LCD display on/off (save battery)  
  - `4` = connect cameras  
  - `5` = zoom in 5%  
  - `+` = zoom in minimal step  
  - `-` = zoom out minimal step  
  - `6` = focus lock  
  - `7` = new project  
  - `8` = shoot photo  
  - `9` = pause  
  - Numpad `0` `1` `2` are modifier keys:  
    - `1` = only apply to left camera  
    - `2` = only apply to right camera  
    - `0` = reverse action (zoom out, focus unlock)  
  - Numpad modifier examples:  
    - `1` & `5` = zoom in 5% left camera  
    - `2` & `6` = focus lock right camera  
    - `0` & `5` = zoom out 5%  
    - `0` & `6` = focus unlock  
    - `0` & `1` & `5` = zoom out 5% left camera  
- `Right click` on `Zoom In`/ `Zoom Out`: zoom in/out minimal step. Useful for fine tuning zoom position.  
- `Right click` on `Preview`: menu to show the same preview again.  
- `Right click` on `Pause`: menu to cancel current project but keep cameras connected.  
- `Click` on green text for a single session change of that setting.  
- `Right click` on `Shoot` or press `NumpadEnter`: save a textfile with current page count, for example `0004.txt`. Useful as a reminder for post shoot file check. For example when a page was accidentally shot twice.  
- `Close` TwoCamControl: also powers off cameras.  

## Feedback
GitHub , https://github.com/nod5/TwoCamControl  
DIY Book Scanner forum , https://forum.diybookscanner.org/viewtopic.php?f=20&t=3082  

## FAQ
**Q**  What if camera serial setup step fails?  
**A**  Set camera serial manually: plug in and power on camera, open a cmd window in the chdkptp folder, run the command `chdkptp.exe -elist` and look for the serial. It looks something like this: DC3E13D4111234B2A23CC31F2E3AA5 . TwoCamControl uses the serial to identify which camera is which.  

**Q**  What if the above manual command `chdkptp.exe -elist` returns no serial?  
**A**  Reinstall LibUSB for that camera. Also double-check that the camera is on, plugged in, and that the cmd window path is in the chdkptp folder.  

**Q**  How to solve `ERROR: not in continous mode`?  
**A**  Power on the camera with CHDK on the SD card without connecting it to the PC, press `func` button on the camera, go to the menu item that allows setting continuous mode and turn it on. Power off the camera. Then try TwoCamControl again.  

**Q**  What if the chdkptp cmd window shows error about filepath or incorrect characters?  
**A**  Try changing workdirectory path to not include special or non-english characters. Test with only a-z 0-9 space.  

**Q**  What if chkdptp cmd window *still* shows error about filepath or incorrect characters?  
**A**  See GitHub issue #1  

**Q**  Can I use TwoCamControl with only one camera?  
**A**  Yes.  

**Q**  What Windows version does TwoCamControl require?
**A**  TwoCamControl is only tested in Windows 10 x64. It might work in earlier Windows.

**Q**  What if my question/issue/suggestion is not in this FAQ?  
**A**  Open an issue at GitHub and describe the problem. Include these details: Your camera model, the version of CHDK, chdkptp and TwoCamControl, and Windows version and language.  
