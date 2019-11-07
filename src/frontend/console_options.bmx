' ------------------------------------------------------------------------------
' -- src/frontend/console_options.bmx
' --
' -- Command line options used by the simulator.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import sodaware.Console_Color
Import sodaware.Console_CommandLine

Type ConsoleOptions Extends CommandLineOptions
	Field File:String   = ""                { Description="Optional input file to load" LongName="file" ShortName="f"  }
	Field LoadTo:String = ""                { Description="The address to load input file into" LongName="address" ShortName="a" }
	Field Verbose:Byte  = False             { Description="Enable verbose output" LongName="verbose" ShortName="v" }
	Field Help:Byte     = False

	Method ShowHelp()

		PrintC "%_Usage%n: 6502-max [options] [--file=file] [--address=mem ]"
		PrintC ""
		PrintC "Load a file and run the simulator."
		PrintC ""

		' Args: Column Width, Use Colours
		PrintC "%YCommands:%n "
		PrintC(Super.createHelp(80, True))

	End Method

	' sorry :(
	Method New()
		Super.init(AppArgs)
	End Method
End Type
