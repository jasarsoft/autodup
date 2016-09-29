#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include "functions.au3"

Const $appName = "autodup.exe"
Const $appTitle = "AutoDuplicate Creator"
Const $appVersion = "1.0"
Const $appDeveloper = "Edin Jašareviæ"

Global $Result
Global $DefaultPath
Global $DefaultPathLenght = 0
Global $InputFile
Global $OutputFile
Global $LineNumber = 2
Global $GroupNumber = 1

$Result = FileExists ("input.txt")
If $Result = 0 Then
   MsgBox ($MB_ICONWARNING, $appTitle, "Input file does not exist!")
   Local $file = FileOpen ("input.txt", 1)
   FileClose ($file)
   Exit
EndIf

While 1
   Local $msgText = "Enter part of the path that will be removed." & @CRLF & "For example: C:\Program Files\CryTek\Far Cry"
   $DefaultPath = InputBox ($appTitle, $msgText, "", "", 320, 160)
   If @error = 1 Then
	  Exit
   ElseIf $DefaultPath = "" Then
     MsgBox($MB_ICONERROR, $appTitle, "You did not enter path to continue...")
     ContinueLoop
   Else
	  $DefaultPath = $DefaultPath & "\"
	  $DefaultPathLenght = StringLen($DefaultPath)
	  ExitLoop
   EndIf
WEnd

$InputFile = FileOpen ("input.txt", $FO_READ)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The input file can not be opened!")
   Exit
EndIf

$OutputFile = FileOpen ("output.txt", $FO_OVERWRITE)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The output file can not be opened!")
   Exit
EndIf

While 1
   Local $LineText = FileReadLine ($InputFile, $LineNumber)
   If @error = -1 Then
	  FileClose($InputFile)
	  FileClose($OutputFile)
	  ExitLoop
   EndIf

   Local $StringContains = StringInStr(Path($LineText), $DefaultPath, 0, 1, 1, $DefaultPathLenght)
   If $StringContains = 0 Then
	  MsgBox($MB_ICONERROR, "Error", "Default path is not exist: " & $LineNumber)
   elseif @error = 1 Then
	  MsgBox($MB_ICONERROR, "Error", "Other error for default path." & @CRLF & "Line number: " & $LineNumber)
   EndIf


   If Marked($LineText) = "0" Then
	  If Not Group($LineText) = $GroupNumber Then
		 MsgBox($MB_ICONERROR, "Group Number Error", "Line number: " & $LineNumber & @CRLF & "Group Line: " & Group($LineText) & @CRLF & "Group Number: " & $GroupNumber)
		 Exit
	  EndIf

	  FileWriteLine($OutputFile, ';Group: ' & $GroupNumber)
	  FileWriteLine($OutputFile, '$file = "' & StringTrimLeft(Path($LineText), StringLen($DefaultPath)) & FileName($LineText) & '"')
	  FileWriteLine($OutputFile, '$result = FileExists($File)')
	  FileWriteLine($OutputFile, 'If $result = 0 Then')
	  FileWriteLine($OutputFile, '  MsgBox(0, "AutoDuplicate Creator", "File does not exist!" & @CRLF & $file)')
	  FileWriteLine($OutputFile, 'EndIf')
	  $GroupNumber = $GroupNumber + 1
   Else
	  FileWriteLine($OutputFile, '$copy = "' & StringTrimLeft(Path($LineText), StringLen($DefaultPath)) & FileName($LineText) & '"')
	  FileWriteLine($OutputFile, '$result = FileCopy($file, $copy, 9)')
	  FileWriteLine($OutputFile, 'If $result = 0 Then')
	  FileWriteLine($OutputFile, '  MsgBox(0, "AutoDuplicate Creator", "The file was not copied." & @CRLF & $copy)')
	  FileWriteLine($OutputFile, 'EndIf')
	  FileWriteLine($OutputFile, '')
   EndIf
   $LineNumber = $LineNumber + 1
WEnd

MsgBox($MB_ICONINFORMATION, $appTitle, "Finished successfully!")
Exit