# Notes on zoom methods in TwoCamControl

https://github.com/nod5/TwoCamControl

Updated 2018-10-03

**TwoCamControl uses chdkptp which supports two different zoom commands**
- `set_zoom` (and set_zoom_relative which uses set_zoom and get_zoom)
- `click('zoom_in')`

set_zoom is the default method in TwoCamControl.  
An option let users switch to the click('zoom_in') method.

**Advantages with set_zoom**
- Can zoom smaller steps, for better fine tuning of the zoom position.
- Can zoom to a specific position in one go.
- Can zoom more exactly. In contrast, click('zoom_in') may not zoom the same exact same distance every time.

**Disadvantages with set_zoom**
- May not zoom more exactly in all cameras.
- May not work in all cameras.
- Will in some cameras cause an error where the saved jpg have a fisheye lens like distortion i.e. straight lines are slightly curved.

**Recommendation to users**  
Stick to the default zoom, unless you notice the jpg distortion problem  with your specific camera. In that case use the non-default click('zoom_in') method.

**Request for help from users**  
If you do notice the jpg distortion problem with your camera then you can help out by posting about it in a new TwoCamControl [github issue](https://github.com/nod5/TwoCamControl/issues) and/or in [this CHDK forum thread](https://chdk.setepontos.com/index.php?topic=13540.msg). Describe the camera model and CHDK/chdkptp versions you use. The CHDK developers might then be able to to fix the problem for that camera.

**Further reading**
- [CHDK forum thread](https://chdk.setepontos.com/index.php?topic=13540.msg) about zoom_set and the distortion problem, with links to additional threads.
- comments in TwoCamControl source code
- TwoCamControl GitHub [issue #3](https://github.com/nod5/TwoCamControl/issues/3)
- CHDK site man page for commands [set_zoom](http://chdk.wikia.com/wiki/CHDK_scripting#set_zoom_.2F_set_zoom_rel_.2F_get_zoom_.2F_set_zoom_speed) and [click('zoom_in')](http://chdk.wikia.com/wiki/CHDK_scripting#Camera_Button_Commands)


**History**
- TwoCamControl 2018-01-18 and older use click('zoom_in').
- TwoCamControl 2018-08-30 use set_zoom.
- TwoCamControl 2018-10-03 use set_zoom as default and  click('zoom_in') as an option.
