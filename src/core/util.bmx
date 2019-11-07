' ------------------------------------------------------------------------------
' -- src/core/util.bmx
' --
' -- Utility functions for working with the 6502 core. Mostly functions for
' -- formatting values and exploring memory areas.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import brl.retro

Function ByteToHex:String(val:Byte)
	Return Right(Hex(val), 2)
End Function

Function WordToHex:String(val:Short)
	Return Right(Hex(val), 4)
End Function

Function DumpBank(bank:TBank)

	Local output:String = ""
	Local x:Int = 0

	For Local i:Int = 0 To bank.Size() - 1
		output :+ ByteToHex(bank.PeekByte(i))
		output :+ " "
		x :+ 1
		If x > 40 Then
			x = 0
			output :+ "~n"
		End If
	Next

	Print output

End Function
