' ------------------------------------------------------------------------------
' -- src/simulator/simulator.bmx
' --
' -- Main simulator class. Ties memory, cpu and display in a single place. Adds
' -- file loading and handles running the processor.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import "../core/cpu.bmx"
Import "display.bmx"

Type Simulator
	Field _ram:TBank
	Field _processor:CPU
	Field _vdu:Display
	Field _isFinished:Byte = False


	' ----------------------------------------------------------------------
	' -- Running
	' ----------------------------------------------------------------------

	Method run()
		Repeat
			' Quit on ESC
			If KeyDown(KEY_ESCAPE) Then Self._isFinished = True

			For Local i:int = 0 To 255
				Self.runProcessorTick()
			Next

			Self.drawScreen()
		Until Not Self.isRunning()

		Print "Simulation has finished"

		WaitKey()
		End
	End Method


	' ----------------------------------------------------------------------
	' -- Status checks
	' ----------------------------------------------------------------------

	Method isRunning:Byte()
		Return Not Self._isFinished
	End Method


	' ----------------------------------------------------------------------
	' -- State management
	' ----------------------------------------------------------------------

	Method reset()
		Self._processor.reset()
	End Method


	' ----------------------------------------------------------------------
	' -- Loading
	' ----------------------------------------------------------------------

	' Load a program into memory.
	Method loadFile(url:Object)
		' TODO: This should be settable from the command line.
		Local programStart:Short = $0600

		Local fileIn:TStream = ReadFile(url)
		Local offset:Int = programStart
		While Not fileIn.Eof()
			Self._ram.PokeByte(offset, fileIn.ReadByte())
			offset :+ 1
		WEnd

		Self._processor.programCounter = programStart
	End Method


	' ----------------------------------------------------------------------
	' -- Internal running
	' ----------------------------------------------------------------------

	Method runProcessorTick()
		' Set memory $FF to last key press.
		Self._ram.PokeByte($FF, GetChar())

		' Put a random byte in $FE.
		Self._ram.pokeByte($FE, Rand(0, 255))

		If Self._processor.breakFlag = 0 Then
			Self._processor.executeInstruction()
		Else
			' TODO: Does this work correctly?
			Self._isFinished = True
		EndIf
	End Method

	Method drawScreen()
		Cls()
		Self._vdu.render()
	End Method


	' ----------------------------------------------------------------------
	' -- Construction
	' ----------------------------------------------------------------------

	Function Create:Simulator(memorySize:Short = $FFFF)
		Local this:Simulator = New Simulator

		' Create an initialize RAM.
		this._ram = TBank.Create(memorySize)
		For Local i:Int = 0 To memorySize - 1
			this._ram.PokeByte(i, 0)
		Next

		' Create a CPU and allow it to read memory.
		this._processor = CPU.Create(this._ram)

		' Create a new display and hookup to ram.
		this._vdu = Display.Create(this._ram, $0200)

		Return this
	End Function
End Type
