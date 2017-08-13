#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=autodup.exe
#AutoIt3Wrapper_Res_Comment=https://github.com/jasarsoft/autodup
#AutoIt3Wrapper_Res_Description=AutoDuplicate Creator
#AutoIt3Wrapper_Res_Fileversion=0.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Edin Jašarević (jasarsoft)
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include "functions.au3"

AutoItSetOption("MustDeclareVars", 1)

Const $appName = "autodup.exe"
Const $appTitle = "AutoDuplicate Creator"
Const $appVersion = "0.2"
Const $appDeveloper = "Edin Jašarević"

Global $Result
Global $DefaultPath
Global $DefaultPathLenght = 0
Global $InputFile
Global $OutputFile
Global $LineNumber = 2
Global $GroupNumber = 0

Global $OriginalFile = ""
Global $DuplicateFile = ""

$Result = FileExists ("duplicate.txt")
If $Result = 0 Then
   MsgBox ($MB_ICONWARNING, $appTitle, "Input file does not exist!")
   Local $file = FileOpen ("duplicate.txt", 1)
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

$InputFile = FileOpen ("duplicate.txt", $FO_READ)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The input file can not be opened!")
   Exit
EndIf

$OutputFile = FileOpen ("output.txt", $FO_OVERWRITE)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The output file can not be opened!")
   Exit
EndIf

FileWriteLine($OutputFile, '#NoTrayIcon')
FileWriteLine($OutputFile, '')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Outfile=autodup.exe')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Compression=0')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Res_Description=AutoDuplicate Creator')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Res_Fileversion=0.2.0.0')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Res_LegalCopyright=Edin Jašarevic (jasarsoft)')
FileWriteLine($OutputFile, '#AutoIt3Wrapper_Add_Constants=n')
FileWriteLine($OutputFile, '')
FileWriteLine($OutputFile, 'Global $GroupMax = 0')
FileWriteLine($OutputFile, 'Global $GroupError = -1')
FileWriteLine($OutputFile, 'Global $Step = Ceiling($GroupMax/100)')
FileWriteLine($OutputFile, 'Global $Value = 0')
FileWriteLine($OutputFile, 'Global $Percent = 0')
FileWriteLine($OutputFile, 'Global $Title = "AutoDuplicate Creator"')
FileWriteLine($OutputFile, 'Global $Message = "Creating duplicate files..."')
FileWriteLine($OutputFile, '')
FileWriteLine($OutputFile, 'Func OriginalFile($Group, $File)')
FileWriteLine($OutputFile, '	$Value += 1')
FileWriteLine($OutputFile, '	If $Value = $Step Then')
FileWriteLine($OutputFile, '		$Value = 0')
FileWriteLine($OutputFile, '		$Percent += 1')
FileWriteLine($OutputFile, '	EndIf')
FileWriteLine($OutputFile, '	ProgressSet($Percent, $Group & "/" & $GroupMax & " | " & StringTrimLeft($File, 25))')
FileWriteLine($OutputFile, '	If Not FileExists($File) Then ')
FileWriteLine($OutputFile, '		ProgressOff()')
FileWriteLine($OutputFile, '		$GroupError = $Group')
FileWriteLine($OutputFile, '		MsgBox(0, $Title, "File does not exist!" & @CRLF & $File)')
FileWriteLine($OutputFile, '		ProgressOn($Title, $Message, $Group & "/" & $GroupMax & " | " & StringTrimLeft($File, 25))')
FileWriteLine($OutputFile, '	EndIf')
FileWriteLine($OutputFile, 'EndFunc')
FileWriteLine($OutputFile, '')
FileWriteLine($OutputFile, 'Func DuplicateFile($Group, $File, $Duplicate)')
FileWriteLine($OutputFile, '	If $Group <> $GroupError And Not FileCopy($File, $Duplicate, 9) Then')
FileWriteLine($OutputFile, '		ProgressOff()')
FileWriteLine($OutputFile, '		MsgBox(0, $Title, "The file was not copied!" & @CRLF & "Original: " & $File & @CRLF & "Duplicate: " & $Duplicate)')
FileWriteLine($OutputFile, '		ProgressOn($Title, $Message, $Group & "/" & $GroupMax & " | " & StringTrimLeft($File, 25))')
FileWriteLine($OutputFile, '	EndIf')
FileWriteLine($OutputFile, 'EndFunc')
FileWriteLine($OutputFile, '')
FileWriteLine($OutputFile, 'ProgressOn($Title, $Message, 0 & "/" & $GroupMax & " | ")')
FileWriteLine($OutputFile, '')

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
	  $GroupNumber += 1
		If Not Group($LineText) = $GroupNumber Then
			MsgBox($MB_ICONERROR, "Group Number Error", "Line number: " & $LineNumber & @CRLF & "Group Line: " & Group($LineText) & @CRLF & "Group Number: " & $GroupNumber)
		EndIf
		$OriginalFile = StringTrimLeft(Path($LineText), StringLen($DefaultPath)) & FileName($LineText)
		FileWriteLine($OutputFile, '')
		FileWriteLine($OutputFile, 'OriginalFile(' & $GroupNumber & ', "' & $OriginalFile & '")')
	Else
		$DuplicateFile = StringTrimLeft(Path($LineText), StringLen($DefaultPath)) & FileName($LineText)
		FileWriteLine($OutputFile, 'DuplicateFile(' & $GroupNumber & ', "' & $OriginalFile & '", "' & $DuplicateFile & '")')
   EndIf
   $LineNumber = $LineNumber + 1
WEnd

$InputFile = FileOpen ("output.txt", $FO_READ)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The input file can not be opened!")
   Exit
EndIf

$OutputFile = FileOpen ("autodup.au3", $FO_OVERWRITE)
If @error = -1 Then
   MsgBox($MB_ICONERROR, $appTitle, "The output file can not be opened!")
   Exit
EndIf

$LineNumber = 1
While 1
	Local $LineText = FileReadLine ($InputFile, $LineNumber)
	If @error = -1 Then
		FileClose($InputFile)
		FileClose($OutputFile)
		ExitLoop
	EndIf
	If StringInStr($LineText, "Global $GroupMax = 0") Then
		FileWriteLine($OutputFile, 'Global $GroupMax = ' & $GroupNumber)
	Else
		FileWriteLine($OutputFile, $LineText)
	EndIf
	$LineNumber += 1
WEnd
MsgBox($MB_ICONINFORMATION, $appTitle, "Finished successfully!" & @CRLF & "Group: " & $GroupNumber)
Exit