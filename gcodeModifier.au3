#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Marvin Baral

 Script Function:
	Modify z-values in gcode

#ce ----------------------------------------------------------------------------
#include <Constants.au3>
#include <MsgBoxConstants.au3>

;init
$fileNameAndPath = FileOpenDialog("load gcode file", "C:\Users\Marvin\Documents\3D-Druck", "Gcode-files (*.gcode)| All (*.*)")
If @error Then
   Exit
EndIf
$saveFileNameAndPath = FileSaveDialog("choose file to save modified content", "C:\Users\Marvin\Documents\3D-Druck","Gcode-files (*.gcode)| All (*.*)",  $FD_PROMPTOVERWRITE)
If @error Then
   Exit
EndIf
$array = FileReadToArray($fileNameAndPath)
$distance = InputBox("z-modification value", "Please enter the value in how far you want to alter the z-values in the gcodefile.")
If @error Then
   Exit
EndIf

;program
$msgBoxResponse = MsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, "Process starts", "Now the content of the file" & @CRLF & '"' & $fileNameAndPath & '"' & @CRLF &  "will be pasted into the file" & @CRLF & '"' & $saveFileNameAndPath & '"' & @CRLF & "with z-values modified by " & $distance & " mm"  & @CRLF & @CRLF & "This will take several minutes depending on how big your object is." )
If $msgBoxResponse = $IDCANCEL Then
   Exit
EndIf

For $i = 0 To UBound($array) - 1
   $line = $array[$i]
   $matches = StringRegExp($line, "G1\sZ([0-9]+.[0-9]+)", $STR_REGEXPARRAYMATCH)
   If $matches <> 0 Then ;when there is a occurence of z-values
	  $oldValue = $matches[0]
	  $newValue = Round($oldValue - $distance, 3)
	  ;MsgBox(0, $newValue, $oldValue)
	  $oldLine = $line
	  $newLine = StringReplace($oldLine, $oldValue, $newValue)
	  $line = $newLine
	  ;MsgBox(0, $newLine, $oldLine)
   EndIf
   FileWriteLine($saveFileNameAndPath, $line)
Next