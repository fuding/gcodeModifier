#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Marvin Baral

 Script Function:
	Modify z-values in gcode

#ce ----------------------------------------------------------------------------
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>

Func checkForErrorDoBadExit($input)
   If @error Or $input = "" Then
	  MsgBox($MB_OK + $MB_ICONERROR, "Error", "Program ends now")
	  Exit
   EndIf
EndFunc

Func exitableMsgBox($ids, $caption, $text)
   $msgBoxResponse = MsgBox($ids, $caption, $text)
   If $msgBoxResponse = $IDCANCEL Then
	  Exit
   EndIf
EndFunc


exitableMsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, "What this program does", "You are now asked about filepaths and values. From this information this program copies a .gcode-file and modifies a certain axis value in all coordinate-values. This is usefull when you have problems with a 3d-printer concerning positioning")

;init
$fileNameAndPath = FileOpenDialog("load gcode file", "C:\Users\Marvin\Documents\3D-Druck", "Gcode-files (*.gcode)| All (*.*)")
checkForErrorDoBadExit($fileNameAndPath)
$saveFileNameAndPath = FileSaveDialog("choose file to save modified content", "C:\Users\Marvin\Documents\3D-Druck","Gcode-files (*.gcode)| All (*.*)",  $FD_PROMPTOVERWRITE)
checkForErrorDoBadExit($saveFileNameAndPath)
$axis = InputBox("choose the axis", "Please enter the axis in what you want to alterate the position of the model which is represented by your gcode." & @CRLF & "!!! Do use tall letters !!!")
checkForErrorDoBadExit($axis)
$distance = InputBox($axis & "-modification value", "Please enter the value in how far you want to alter the " & $axis & "-values of you model in the gcode-file." & @CRLF & "!!! Do use a point as seperator !!!")
checkForErrorDoBadExit($distance)
$array = FileReadToArray($fileNameAndPath)
checkForErrorDoBadExit($array)


;program
exitableMsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, "Process starts", "Now the content of the file" & @CRLF & '"' & $fileNameAndPath & '"' & @CRLF &  "will be pasted into the file" & @CRLF & '"' & $saveFileNameAndPath & '"' & @CRLF & "with " & $axis & "-values modified by " & $distance & " mm"  & @CRLF & @CRLF & "This will take several minutes depending on how big your object is." )

$timeOld = _NowCalc()

$arraySize = UBound($array)
For $i = 0 To $arraySize - 1
   $line = $array[$i]
   $matches = StringRegExp($line, "G1.*" & $axis & "([0-9]+.[0-9]+)", $STR_REGEXPARRAYMATCH)
   If $matches <> 0 Then ;when there is a occurence of axis-values
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

$timeNew = _NowCalc()
$neededTime = _DateDiff("s", $timeOld, $timeNew)


MsgBox($MB_OK, "Finished", "Process finished after " & $neededTime & " seconds." & @CRLF & $arraySize & " lines have been copied/modified.")