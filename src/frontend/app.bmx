' ------------------------------------------------------------------------------
' -- src/frontend/app.bmx
' --
' -- Main application logic. Hooks the simulator and the command line up
' -- together.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import sodaware.Console_Color
Import brl.reflection
Import brl.retro

' -- Options
Import "console_options.bmx"

' -- Main simulator.
Import "simulator.bmx"

''' <summary>Main application.</summary>
Type App
	Field _sim:Simulator                    '''< Simulator instance.
	Field _options:ConsoleOptions           '''< Command line options.
	Field _exitCode:Int                     '''< Code to return to application.


	' ------------------------------------------------------------
	' -- Main application entry
	' ------------------------------------------------------------

	''' <summary>Application entry point.</summary>
	Method run:Int()
		' Setup the app options.
		Self._setup()

		' Show help message if requested - quit afterwards
		If True = Self._options.Help Then
			Self._options.showHelp()

			Return Self._shutdown()
		End If

		' Create the simulator.
		Self._sim = Simulator.Create()

		' Load any files (if needed).
		If Self._options.File Then
			Print "Loading file: " + Self._options.File
			Self._sim.loadFile(Self._options.File)
			Print "  loaded"
		End If

		' Reset and run the simulator.
		' Self._sim.reset()
		Self._sim.run()

		' -- Cleanup and return
		Self._shutdown()

		Return Self._exitCode

	End Method

	' ------------------------------------------------------------
	' -- Application setup & shutdown
	' ------------------------------------------------------------

	Method _setup()
		' Get command line options
		Self._options = New ConsoleOptions
	End Method

	Method _shutdown:Int()

	End Method


	' ------------------------------------------------------------
	' -- Construction / destruction
	' ------------------------------------------------------------

	Function Create:App()
		Local this:App	= New App
		Return this
	End Function

End Type
