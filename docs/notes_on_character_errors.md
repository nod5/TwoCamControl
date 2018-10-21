# Notes on character errors, encoding and cmd windows in TwoCamControl

Users have in the past reported issues where certain characters are sent incorrectly to the cmd windows.  

## Advice to users

If you notice a problem with character errors

- Make sure you use the latest version of TwoCamControl.
- If you use `TwoCamControl.ahk` instead of the `TwoCamControl.exe` then make sure your .ahk is saved with UTF-8 BOM encoding.
- If the problem is still there [create an issue](https://github.com/nod5/TwoCamControl/issues) and describe what characters show up incorrectly. Also describe what camera model, CHDK/chdkptp versions and Windows version and locale (system language) you use.

## Technical notes

TwoCamControl sends strings to cmd windows where chdkptp.exe in rsint mode sends commands USB connected Canon cameras with CHDK firmware to take photos and save to the PC.  

Character errors can happen at different steps in that chain.

**Relevant factors**
- Windows version and locale  
- chdkptp version  
- CHDK version  
- camera model  
- AutoHotkey version  
- Encoding TwoCamControl.ahk is saved with.  
- Encoding TwoCamControl sets before read/write/send operations.  
- How TwoCamControl formats and sends strings.  

The following sections describe some different character errors and how to handle them.

### Save TwoCamControl.ahk with encoding UTF-8 BOM

AutoHotkey scripts can display or send non-ASCII characters incorrectly unless saved as UTF-8 with byte order mark.  
https://autohotkey.com/docs/FAQ.htm#nonascii  

If you use `TwoCamControl.ahk` directly then make sure it is saved with UTF-8 BOM.  

`TwoCamControl.exe` github releases have UTF-8 BOM encoding.  

### Use FileEncoding UTF-16 before IniWrite/IniRead

The AutoHotkey commands IniWrite and IniRead only support UTF-16 or ANSI. Not UTF-8.  

Workaround: TwoCamControl sets fileencoding before/after each IniWrite and IniRead command.

```
FileEncoding, UTF-16
IniWrite
FileEncoding, UTF-8
```

This allows for non-ASCII characters in file paths to chdkptp and extraprocess.  

https://autohotkey.com/docs/commands/IniWrite.htm  
https://autohotkey.com/docs/commands/FileEncoding.htm

### unicodify() characters before send to chdkptp rsint

AutoHotkey command Send can send incorrect characters to the chdkptp interactive CLI in cmd windows when the operating system is Windows 10 with a non-english locale.

For example the character `!` in `!file` command may not be sent.  

Workaround: TwoCamControl uses its unicodify() function to convert strings to unicode values before sending.

Each character in the string is converted to the format {U+nnnn} where nnnn is HEX. Special characters strings like `{enter}` break if passed through unicodify() so they are sent separately.  

https://autohotkey.com/docs/commands/Asc.htm  
https://autohotkey.com/docs/commands/SetFormat.htm  
https://autohotkey.com/docs/commands/Send.htm  

### Only ASCII characters in work directory path

chdkptp [lacks unicode support](https://chdk.setepontos.com/index.php?topic=13540.msg138156#msg138156). Characters other than [ASCII non-extended](https://en.wikipedia.org/wiki/ASCII) can make the rsint path command save photos to a different folder than intended or not save photos at all.  

Workaround: TwoCamControl only allows ASCII non-extended characters in the work directory path setup field. Photos then save as expected to datestamped subfolders in the work directory.  

https://chdk.setepontos.com/index.php?topic=13540.msg138156#msg138156
https://en.wikipedia.org/wiki/ASCII
