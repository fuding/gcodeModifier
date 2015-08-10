# gcodeModifier
This program modifies gcode (from RepRap software with slic3r) by alterating position-values of one whole gcode-file of a certain axis by a certain value.
This is usefull to change the position of your model after slicing or when you have problems with the positioning system of your printer (reason why i build this).
In this case you can give your printer a model with an integrated offset so that he prints correctly.

This program is only tested with gcode generated from "slic3r" by the reprap-software.

AutoIt is only for Windows. Im sorry for Linuxusers. Maybe i do find the enthusiasm to write this programm with Qt (when i know, sb. uses my script).
gcode is a list of commands for a 3d-printer which is generated out of .stl or other 3d-files.
