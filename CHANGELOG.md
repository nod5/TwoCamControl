# Change Log  
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [2018-11-13] - 2018-11-13
### Fix
- Fix: F8 F9 global hotkeys.
- Fix: skip get_zoom() in connect cameras step if "alt zoom" option is enabled.

## [2018-11-07] - 2018-11-07
### Changed
- After Shoot focus TwoCamControl window. Prevents accidental user input to cmd windows.

### Fixed
- Fix: Made F8 F9 hotkeys global. Overrides native cmd window F8 command history shortcut. (github issue #6)

## [2018-10-21] - 2018-10-21
### Added
- docs/notes_on_character_errors.md (old: GitHub issue #1)

## [2018-10-03] - 2018-10-03
### Added
- Require ASCII characters in directory path edit field. Prevents path error in chdkptp rsint.
- "Alt zoom" option: use click('zoom_in') for all zoom actions instead of the default set_zoom and set_zoom_relative.
- docs/notes_on_zoom_methods.md

### Changed
- Default value for Wait is 0 (old: 400).
- Minimal zoom step is +2 for cameras with >60 zoom range steps (old: >100).
- "PC Save" option in Setup (old: "No PC Save" option)

## [2018-08-26] - 2018-08-26
### Added
- Hotkey/button to toggle camera LCD display on/off (saves battery)
- Menu with zoom actions: Save current zooms as auto zoom setting, Zoom out completely, Apply zoom from previous projects

### Changed
- Zoom with the more exact set_zoom() and set_zoom_rel() chdkptp commands (github issue #3 )
- Zoom big (5% of zoom range) or small (minimal zoom step) amount
- Auto zoom setting uses zoom range steps as unit (old unit: clicks)
- Auto zoom setting is separate for right/left camera
- White background color (old: grey)
- Right click Pause for option to cancel project (old: right click New Project button)
- UTF-8 BOM encoding
- Simpler hotkey and button disable/enable code: handles modifiers with getkey() checks, not separate hotkeys
- Do not show a second cmd window during single camera use
- Readme/help expanded
- Code cleanup

### Fixed
- Fix: Some local hotkeys were by mistake global
- Fix: cmd window activation failure froze TwoCamControl (github issue #4 ). acti() now retries 1 second and activation failure does not freeze TwoCamControl
- Fix: next filename count displayed incorrectly in GUI

### Removed
- Saved button (replaced by Menu)

## [2018-01-12] - 2018-01-12
### Changed
- fix character errors in chdkptp cmd window ( #1 )

## [2017-08-25] - 2017-08-25
### Added
- Option Space button to shoot
- Option "No PC save"; saves on camera SD card only
- Right click Preview button to show same preview again
- Right click Project button to cancel current project but keep cameras on
- Right click Shoot button to save 0004.txt type marker file
- GitHub repo

### Changed
- Green text wait time cycle includes 0
- Fix bug with "Saved" button
- Fix bug with numpad hotkeys enabled even when set to be off
- Help text explains cmdwait parameter
- Help text points user to CHDK development/alpha version
- Fix: send special chars to cmd windows as ansi codes to avoid send error in non-english Win10
- Close/cancel uses quicker rsint q (quit) command
- Code cleanup

## [2015-11-21] - 2015-11-21
### Added
- Setup and help tabs
- Preview during zoom/focus lock setup
- Keyboard shortcuts
- Option: zoom steps on camera connect
- Option: set rsint parameters
- Option: use mouse wheel to shoot
- Option: run external process on project start
- Compatible with latest CHDK and chdkptp

## [2014-10-01] - 2014-10-01
### Added
- First release
