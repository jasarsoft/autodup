#cs ----------------------------------------------------------------------------

	  Name:			AutoDuplicate Creator Functions
	  Type:			Include Functions
	  Version:		1.0
	  Developer:	Edin Jašareviæ
	  Last Update:	13.12.2015.

#ce ----------------------------------------------------------------------------

Func Marked ($strLine)
   Local $intCommaPosition = StringInStr ($strLine, ',""')
   Local $intMarkedValue = StringMid ($strLine, 2, $intCommaPosition - 2)
   ;MsgBox(0, "Marked", $intMarkedValue)
   Return $intMarkedValue
EndFunc

Func FileName ($strLine)
   Local $intCommaPosition = StringInStr ($strLine, ',""') + 3
   Local $strFileName = StringMid ($strLine, $intCommaPosition)
   $intCommaPosition = StringInStr ($strFileName, '"",') - 1
   $strFileName = StringMid ($strFileName, 1, $intCommaPosition)
   ;MsgBox(0, "FileName", $strFileName)
   Return $strFileName
EndFunc

Func Path ($strLine)
   Local $intCommaPosition = 0
   Local $strPath = $strLine
   For $i = 1 To 2
	  $intCommaPosition = StringInStr($strPath, ',""') + 2
	  $strPath = StringMid($strPath, $intCommaPosition)
   Next
   $intCommaPosition = StringInStr($strPath, '"",') - 2
   $strPath = StringMid($strPath, 2, $intCommaPosition)
   ;MsgBox(0, "Path", $strPath)
   Return $strPath
EndFunc


Func Group ($strLine)
   Local $intCommaPosition = 0
   Local $intGroup = $strLine
   For $i = 1 To 6
	  $intCommaPosition = StringInStr($intGroup, '",') + 2
	  $intGroup = StringMid($intGroup, $intCommaPosition)
   Next
   $intCommaPosition = StringInStr($intGroup, ',')
   $intGroup = StringMid($intGroup, 1, $intCommaPosition)
   Return Number($intGroup)
EndFunc

Func ErrorWrite($txtLine)
	Local $hErrorFile = FileOpen ("autodup_error.log", $FO_APPEND)
	If @error = -1 Then
		MsgBox($MB_ICONERROR, "Error Open File", "Can not opet file!")
		FileClose($hErrorFile)
		Return 1
	EndIf

	If Not FileWriteLine($hErrorFile, $txtLine) Then
		MsgBox($MB_ICONERROR, "Error File Write", "Can not write to file!")
		Return 2
	EndIf

	Return 0
EndFunc