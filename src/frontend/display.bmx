' ------------------------------------------------------------------------------
' -- src/simulator/display.bmx
' --
' -- Basic graphical display for the simulator. Renders a chunk of memory to a
' -- BlitzMax display using a possible 16 colours.
' --
' -- Default settings are a 32 * 32 screen with 10 * 10 pixels.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import brl.max2d
Import brl.glmax2d

Import "../core/util.bmx"

Type Display
	Field _start:Short              '< Start address of the screen in RAM.
	Field _width:Byte       = 32    '< Width of the screen in virtual pixels.
	Field _height:Byte      = 32    '< Height of the screen in virtual pixels.
	Field _pixelWidth:Byte  = 10    '< Width of screen pixel in real pixels.
	Field _pixelHeight:Byte = 10    '< Height of screen pixel in real pixels.

	Field _memory:TBank             '< Memory bank to render from.
	Field _driver:TGraphics         '< BlitMax renderer.


	' ----------------------------------------------------------------------
	' -- Rendering
	' ----------------------------------------------------------------------

	''' <summary>
	''' Render the contents of memory and flip buffers.
	'''
	''' Optionally wait for a VBL.
	''' </summary>
	''' <param name="waitVbl">If true, will wait for the next VBL after flipping.</param>
	Method render(waitVbl:Byte = True)
		Local offset:Short = Self._start

		For Local yPos:Byte = 0 To Self._height - 1
			For Local xPos:Byte = 0 To Self._width - 1
				Self._setColor(Self._memory.PeekByte(offset))
				DrawRect xPos * Self._pixelWidth, yPos * Self._pixelHeight, Self._pixelWidth, Self._pixelHeight

				offset :+ 1
			Next
		Next

		Flip(waitVbl)
	End Method


	' ----------------------------------------------------------------------
	' -- Internal Helpers
	' ----------------------------------------------------------------------

	Method _setColor(color:Byte)
		' Clamp color byte.
		color = $0F & color

		Select color
			Case $0 ; SetColor(0, 0, 0)       ' Black
			Case $1 ; SetColor(255, 255, 255) ' White
			Case $2 ; SetColor(128, 0, 0)     ' Red
			Case $3 ; SetColor(0, 128, 128)   ' Cyan
			Case $4 ; SetColor(128, 0, 128)   ' Purple
			Case $5 ; SetColor(0, 128, 0)     ' Green
			Case $6 ; SetColor(0, 0, 128)     ' Blue
			Case $7 ; SetColor(128, 128, 0)   ' Yellow
			Case $8 ; SetColor(128, 64, 0)    ' Orange
			Case $9 ; SetColor(128, 64, 64)   ' Brown
			Case $A ; SetColor(255, 0, 0)     ' Light red
			Case $B ; SetColor(64, 64, 64)    ' Dark grey
			Case $C ; SetColor(128, 128, 128) ' Grey
			Case $D ; SetColor(0, 255, 0)     ' Light green
			Case $E ; SetColor(0, 0, 255)     ' Light blue
			Case $F ; SetColor(192, 192, 192) ' Light grey
		End Select
	End Method


	' ----------------------------------------------------------------------
	' -- Debug Helpers
	' ----------------------------------------------------------------------

	Method dumpScreen()
		Local offset:Short = Self._start

		For Local y:Int = 0 To 31
			Local line:String = ""
			For Local x:Int = 0 To 31
				line :+ bytetohex(Self._memory.PeekByte(offset)) + " "
				offset :+ 1
			Next

			Print line
		Next
	End Method


	' ----------------------------------------------------------------------
	' -- Construction
	' ----------------------------------------------------------------------

	''' <summary>Create and initialize a new display.</summary>
	''' <param name="memory">The memory bank to read the screen from.</param>
	''' <param name="start">The start address in memory to read from.</param>
	Function Create:Display(memory:TBank, start:Short)
		Local this:Display = New Display

		this._memory = memory
		this._start  = start

		' Create the actual display.
		GLShareContexts()
		SetGraphicsDriver(GLMax2DDriver())

		this._driver = CreateGraphics(this._width * this._pixelWidth, this._height * this._pixelHeight, 0, 60, GRAPHICS_BACKBUFFER)

		SetGraphics(this._driver)

		' Enable input.
		EnablePolledInput()

		Return this
	End Function

End Type
