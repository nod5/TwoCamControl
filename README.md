# TwoCamControl

TwoCamControl.ahk -- version 2018-01-12 -- by Nod5 -- GPLv3

Windows frontend for chdkptp with two cameras.

[Download TwoCamControl binary](https://github.com/nod5/TwoCamControl/releases)


![Alt text](images/TwoCamControl1.PNG?raw=true)

![Alt text](images/TwoCamControl2.PNG?raw=true)

## Features
Shoots two cameras at (almost) the same time and quickly.  
Saves each photo directly to the PC.  
Very quick (thanks to the chdkptp rsint command).  
Trigger cameras with a GUI button, keyboard shortcut or mouse wheel.  
Autonames files in sequence 0001L.jpg 0001R.jpg 0002L.jpg ...  

## Controls - Basic Workflow
1. Connect cameras.  
2. Adjust Zoom and Focus. Preview shots with current settings.  
3. When the settings are good start a New Project and Shoot.  

## Dependencies
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

## Required Setup in TwoCamControl
- set workdirectory path
- set chdkptp path
- set right camera serial

## Optional Setup (Default Value)
- Zoom steps (0): Auto zoom in this number of steps when cameras connect
- Wait (400): Wait this number of miliseconds before the camera shoots. Use this to add a delay in a hardware setup where shoots are triggered by a mousewheel that the platen touches on its way down. Set to 0 for no delay.
- Mousewheel (off): Mouse wheel down triggers a shoot
- Numpad keys (off): Activate numpad key controls (see below)
- Space (off): Space button triggers a shoot
- No PC Save (off): Saves shots to camera SD cards (not to PC). Uses chdkptp "shoot" command with parameters set by user in the rsint options field. Try parameter raw=1 for raw shoot.
- rsint options (-cmdwait=600 -tv=1/160): parameters for the rsint command. See usage.txt in chdkptp for details. Cmdwait is number of seconds until rsint times out.
- extraprocess (blank): Path to some external tool to run at project start. Example: C:\folder\program.exe . TwoCamControl sends the project name as a command line parameter. The project name is a timestamp (YYYYMMDDhhmmss).

To reset to default values delete TwoCamControl.ini and restart the program.

## Controls - Tips and Tricks
- Hold shift/control to apply zoom or focus command only to right/left side camera.
- Mouse wheel down: Shoot photo. Useful with a wireless mouse.
- Space button: Shoot photo.
- Numpad keys: useful with wireless numpad
  - 4 = connect cameras
  - 5 = zoom
  - 6 = focus lock
  - 7 = new project
  - 8 = shoot photo
  - 9 = pause
  - hold 1 + 5 = zoom only left side camera
  - hold 2 + 6 = focus only right side camera
  - hold 0 + 5/6 = zoom out/focus unlock
  - hold 0 & 1 + 5 = zoom out left side camera
- Right click on Preview: show the same preview again.
- Right click on Project: cancel current project but keep cameras on.
- Click on green text for a single session change of that setting.
- Right click Shoot button or press NumpadEnter: save a textfile with current count 0004.txt . Useful as a reminder for post shoot file check for example when a page was accidentally shot twice.
- Close TwoCamControl: also powers off cameras.

## Feedback
GitHub , https://github.com/nod5/TwoCamControl  

## Troubleshooting
**Q**  What if camera serial setup step fails?  
**A**  Set camera serial manually: plug in and power on camera, open a cmd window in the chdkptp.exe folder, run the command "chdkptp.exe -elist" and look for the serial. It looks something like this: DC3E13D4111234B2A23CC31F2E3AA5 . TwoCamControl uses the serial to identify which camera is which.

**Q**  How to solve "ERROR: not in continous mode"?  
**A**  Power on the camera with CHDK on the SD card without connecting it to the PC, press "func" button on the camera, go to the menu item that allows setting continuous mode and turn it on. Power off the camera and try TwoCamControl again.

**Q**  What if chkdptp cmd window shows error about filepath or incorrect characters?  
**A**  Try changing workdirectory path to not include special or non-english characters. Test with only a-z 0-9 space.

**Q**  What if chkdptp cmd window *still* shows error about filepath or incorrect characters?  
**A**  See https://github.com/nod5/TwoCamControl/issues/1

**Q**  Can I use TwoCamControl with only one camera?  
**A**  Yes. Two cmd windows will still show, one with error messages, but the single camera will shoot and download photos successfully.

