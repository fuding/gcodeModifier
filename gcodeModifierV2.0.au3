#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Marvin Baral

 Script Function:
	Modify values in gcode

#ce ----------------------------------------------------------------------------
#include-once
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <GUIConstants.au3>

Global $fileNameAndPath = "C:\Users\Marvin\Documents\3D-Druck\gcodeModifier\test\test1.gcode"
Global $saveFileNameAndPath = "C:\Users\Marvin\Documents\3D-Druck\gcodeModifier\test\test2.gcode"
Global $values[3] ;0 = x, 1 = y, 2 = z
$values[0] = 0
$values[1] = 0
$values[2] = 0

Global $labelsAxis[3]
$labelsAxis[0] = "X"
$labelsAxis[1] = "Y"
$labelsAxis[2] = "Z"
Global $doModify[3]

Func exitableMsgBox($ids, $caption, $text)
   $msgBoxResponse = MsgBox($ids, $caption, $text)
   If $msgBoxResponse = $IDCANCEL Then
	  Exit
   EndIf
EndFunc

Func clearFile($logfile)
   $handle = FileOpen($logfile, 2)
   FileClose($handle)
EndFunc

Func updateAndCheckInputContent($fileString, $inp)
   $fileString = GUICtrlRead($inp)
   If $fileString = "" Then
	  MsgBox($MB_OK + $MB_ICONERROR, "Error", "Please enter a valid content into the input with the ID " & $inp &  ".")
	  Return False
   Else
	  Return True
   EndIf
EndFunc

$width = 500
$height = 500
$fileButtonWidth = 50
$axisLabelWidth = 20
$objHeight = 20
$paddingX = 5
$top = 5

Opt("GUIOnEventMode", 1)
$gui = GUICreate("gcodeModifier", $width, $height)
GUISetState(@SW_SHOW, $gui)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
Func _Exit()
   Exit
EndFunc
GUICtrlCreateLabel("input file", $paddingX, $top + 5)
$top += $objHeight
$inpInpFile = GUICtrlCreateInput($fileNameAndPath, $paddingX, $top, $width - 2* $paddingX - $fileButtonWidth, $objHeight)
$btnInpFile = GUICtrlCreateButton("Browse", $width - $fileButtonWidth - $paddingX, $top, $fileButtonWidth, $objHeight)
GUICtrlSetOnEvent($btnInpFile, "addInpFile")
   Func addInpFile()
	  Do
		 $fileNameAndPath = FileOpenDialog("load gcode file", "C:\Users\Marvin\Documents\3D-Druck", "Gcode-files (*.gcode)| All (*.*)")
		 If $fileNameAndPath == "" Then
			If MsgBox($MB_OKCANCEL + $MB_ICONERROR, "Error", "Please choose a valid file.") = $IDCANCEL Then
			   ExitLoop
			EndIf
		 EndIf
		 GUICtrlSetData($inpInpFile, $fileNameAndPath)
	  Until $fileNameAndPath <> ""
   EndFunc
$top += $objHeight
GUICtrlCreateLabel("output file", $paddingX, $top + 5)
$top += $objHeight
$inpOutpFile = GUICtrlCreateInput($saveFileNameAndPath, $paddingX, $top, $width - 2* $paddingX - $fileButtonWidth, $objHeight)
$btnOutpFile = GUICtrlCreateButton("Browse", $width - $fileButtonWidth - $paddingX, $top, $fileButtonWidth, $objHeight)
$top += $objHeight
GUICtrlSetOnEvent($btnOutpFile, "addOutpFile")
   Func addOutpFile()
	  Do
		 $saveFileNameAndPath = FileSaveDialog("choose file to save modified content", "C:\Users\Marvin\Documents\3D-Druck","Gcode-files (*.gcode)| All (*.*)",  $FD_PROMPTOVERWRITE)
		 If $saveFileNameAndPath == "" Then
			If MsgBox($MB_OKCANCEL + $MB_ICONERROR, "Error", "Please choose a valid file.") = $IDCANCEL Then
			   ExitLoop
			EndIf
		 EndIf
		 GUICtrlSetData($inpOutpFile, $saveFileNameAndPath)
	  Until $saveFileNameAndPath <> ""
   EndFunc
;==============================================================================================================================================
$top += 30
$saveTop = $top
$width = $width * 0.5
GUICtrlCreateLabel("modify position of model (in mm):", $paddingX, $top, $width - $paddingX, $objHeight)
$top += $objHeight

Global $inptsAxis[3]
For $i = 0 To 2
   GUICtrlCreateLabel($labelsAxis[$i] & ':', $paddingX, $top, $axisLabelWidth, $objHeight)
   $inptsAxis[$i] = GUICtrlCreateInput($values[$i], $paddingX + $axisLabelWidth, $top, $width - 1.5 * $paddingX - $axisLabelWidth, $objHeight)
   GUICtrlCreateUpdown($inptsAxis[$i])
   GUICtrlSetOnEvent($inptsAxis[$i], "updateAndChecValues")
   $top += $objHeight
Next
   Func updateAndChecValues()
	  $success = True
	  For $index = 0 To 2
		 $values[$index] = GUICtrlRead($inptsAxis[$index])
		 If $values[$index] = "" Then
			MsgBox($MB_OK + $MB_ICONERROR, "Error", "Please enter a valid content into the input with the ID " & $inp &  ".")
			$success = False
		 EndIf
	  Next

	  Return $success
   EndFunc
;===============================================================================================================================================

$saveObjHeight = $objHeight
$objHeight = 50
$top = $height - $paddingX - $objHeight
GUISetFont(14)
$btnStart = GUICtrlCreateButton("Start with displayed values", $paddingX, $top, $width - 1.5 * $paddingX, $objHeight)
GUICtrlSetOnEvent($btnStart, "main")
$btnHelp = GUICtrlCreateButton("Info / Help", $width, $top, $width - 1.5 * $paddingX, $objHeight)
GUICtrlSetOnEvent($btnHelp, "showHelp")
   Func showHelp()
	  $readmeFile = "README.md"
	  If MsgBox($MB_YESNO + $MB_ICONINFORMATION, "What this program does", "You are asked about filepaths and values. From this information this program copies a .gcode-file and modifies certain axis values in all G1-commands (G1 - go to position)." & @CRLF & @CRLF & "Do you want to read the content of " & '"' & $readmeFile & '"' &" ?") = $IDYES Then
		 $content = FileRead($readmeFile)
		 MsgBox($MB_OK, "content of " & $readmeFile, $content)
	  EndIf
   EndFunc
;===============================================================================================================================================
GUISetFont(8.5)
$top = $saveTop
$objHeight = $saveObjHeight
GUICtrlCreateLabel("modify code", 0.5*$paddingX + $width, $top, $width - $paddingX, $objHeight)
$top += $objHeight
$chbCutZ = GUICtrlCreateCheckbox("cut off (G1)-code until Z = ", 0.5*$paddingX + $width, $top)
$inpWidth = 100
$inpCutZ = GUICtrlCreateInput("0", 0.5*$paddingX + 2 * $width - $inpWidth, $top, $inpWidth - $paddingX, $objHeight)
GUICtrlCreateUpdown($inpCutZ)
GUICtrlSetState($inpCutZ, $GUI_DISABLE)
GUICtrlSetOnEvent($chbCutZ, "ungreyOrGreyChb")
GUICtrlSetState($inpCutZ, $GUI_ENABLE)
   Func ungreyOrGreyChb()
	  $state = GUICtrlRead($chbCutZ)
	  MsgBox(0, "Debug", $state)
	  Switch $state
	  Case $state = 1: GUICtrlSetState($inpCutZ, $GUI_ENABLE)
	  Case $state = 4: GUICtrlSetState($inpCutZ, $GUI_DISABLE)
	  Case Else
		 MsgBox($MB_OK + $MB_ICONERROR, "Error", "Unknown value of checkboxstate occured in switch expression: " & $state)
		 GUICtrlSetState($inpCutZ, $GUI_DISABLE)
	  EndSwitch
   EndFunc

$top += $objHeight
$chbDelHomeZ = GUICtrlCreateCheckbox("delete 'home z-axis' commands", 0.5*$paddingX + $width, $top, $width - 1.5 * $paddingX, $objHeight)
$top += $objHeight
$chbModelToGround = GUICtrlCreateCheckbox("set model to ground (Z = 0)", 0.5*$paddingX + $width, $top, $width - 1.5 * $paddingX, $objHeight)
$top += $objHeight

;========================================================End of GUI=============================================================================
While 1
   ;endless loop where process stays and waits for commands
WEnd


   Func main()
	  If Not (updateAndChecValues() And updateAndCheckInputContent($fileNameAndPath, $inpInpFile) And updateAndCheckInputContent($saveFileNameAndPath, $inpOutpFile)) Then
		 Return False
	  EndIf

	  ;find out whether to delet home z-axis commands
	  $deleteHomeZCommands = False
	  Switch GUICtrlRead($chbDelHomeZ)
	  Case $GUI_CHECKED:
		 $deleteHomeZCommands = True
	  Case $GUI_UNCHECKED:
		 $deleteHomeZCommands = False
	  EndSwitch

	  For $i = 0 To 2
		 $doModify[$i] = $values[$i] <> 0
	  Next

	  ;check whether modification really is needed
	  If $doModify[0] Or $doModify[1] Or $doModify[2] Or $deleteHomeZCommands Then

		 ProgressOn("progress", "starting...", "reading file " & '"' & $fileNameAndPath & '"' & "into array", -1, -1, $DLG_MOVEABLE + $DLG_NOTONTOP)

		 $timeOld = _NowCalc()

		 $array = FileReadToArray($fileNameAndPath)
		 $arraySize = UBound($array)

		 clearFile($saveFileNameAndPath)

		 $status = ""
		 $saveIndex = 0
		 $step = 100
		 For $i = 0 To $arraySize - 1
			$line = $array[$i]
			For $innerIndex = 0 to 2
			   If $doModify[$innerIndex] Then
				  $matches = StringRegExp($line, "G1.*" & $labelsAxis[$innerIndex] & "(-?[0-9]+.[0-9]+)", $STR_REGEXPARRAYMATCH)
				  If $matches <> 0 Then ;when there is a occurence of axis-values
					 $oldValue = $matches[0]
					 $newValue = Round($oldValue + $values[$innerIndex], 3)
					 $oldLine = $line
					 $line = StringReplace($line, $oldValue, $newValue)
				  EndIf
			   EndIf
			Next
			If $deleteHomeZCommands Then
			   If StringRegExp($line, "G28 *[^XY]*", $STR_REGEXPMATCH) Then
				  $line = "G28 X0 ; home x-axis(added with gcodeModifier)"
				  FileWriteLine($saveFileNameAndPath, $line)
				  $line = "G28 Y0 ; home y-axis(added with gcodeModifier)"

				  Msgbox(0, "Debug", "Deleted home-z command")
			   EndIf
			EndIf
			FileWriteLine($saveFileNameAndPath, $line)
			If $i + 1 >= $saveIndex + $step Or $i + 1 = $arraySize Then
			   $progressPercent = Round($i / $arraySize * 100)
			   ProgressSet($progressPercent, "line " & $i + 1 & " of " & $arraySize & " (" & $progressPercent & "%)" , $status)
			   $saveIndex += $step
			EndIf
		 Next

		 $timeNew = _NowCalc()
		 $neededTime = _DateDiff("s", $timeOld, $timeNew)
		 $hours = Floor($neededTime/3600)
		 $minutes = Floor(($neededTime - $hours * 3600)/ 60)
		 $seconds = $neededTime - $minutes * 60 - $hours * 3600


		 MsgBox($MB_OK + $MB_ICONINFORMATION, "Finished", "Process finished after " & $hours & "h " & $minutes & "min " & $seconds & "s (" & $neededTime & "s)." & @CRLF & $arraySize & " lines have been copied/modified.")
		 ProgressOff()
	  Else
		 MsgBox($MB_OK, "no changes", "G-code doesn't need to be changed, because modifcation-values haven't been altered.")
	  EndIf
   EndFunc