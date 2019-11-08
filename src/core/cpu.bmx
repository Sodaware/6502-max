' ------------------------------------------------------------------------------
' -- src/core/cpu.bmx
' --
' -- The main CPU simulator. Handles all 6502 opcodes.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import brl.bank

Import "opcodes.bmx"
Import "util.bmx"

Type CPU
	Const STACK_START:Short = $100

	' TODO: Wrap this in a CpuMemory type?
	' Memory for IO.
	Field memory:TBank

	' Registers.
	Field accumulator:Short
	Field xRegister:Byte
	Field yRegister:Byte

	' Flags.
	Field breakFlag:Byte     = 0
	Field carryFlag:Byte     = 0
	Field decimalFlag:Byte   = 0
	Field interruptFlag:Byte = 0
	Field overflowFlag:Byte  = 0
	Field negativeFlag:Byte  = 0
	Field zeroFlag:Byte      = 0

	' Internal CPU values.
	Field programCounter:Short
	Field stackPointer:Byte


	' ----------------------------------------------------------------------
	' -- Execution
	' ----------------------------------------------------------------------

	' Execute a single instruction.
	Method executeInstruction()

		' Read the opcode and move to the next position.
		Local opcode:Byte = Self.readNextByte()

		' Print "RUN: " + ByteToHex(opcode) + " " + ByteToHex(Self.peekByteAt(Self.programCounter))

		' Execute the opcode.
		Select opcode

			' --------------------------------
			' -- ADC

			Case OP_ADC_IMM
				Self.addWithCarry(Self.getImmediateValue())

			Case OP_ADC_ZP
				Self.addWithCarry(Self.getZeroPageValue())

			Case OP_ADC_ZPX
				Self.addWithCarry(Self.getZeroPageValueX())

			Case OP_ADC_ABS
				Self.addWithCarry(Self.getAbsoluteValue())

			Case OP_ADC_ABSX
				Self.addWithCarry(Self.getAbsoluteValueX())

			Case OP_ADC_ABSY
				Self.addWithCarry(Self.getAbsoluteValueY())

			Case OP_ADC_INDX
				Self.addWithCarry(Self.getIndirectValueX())

			Case OP_ADC_INDY
				Self.addWithCarry(Self.getIndirectValueY())


			' --------------------------------
			' -- AND

			Case OP_AND_IMM
				Self.accumulator = Self.accumulator & Self.getImmediateValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_ZP
				Self.accumulator = Self.accumulator & Self.getZeroPageValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_ZPX
				Self.accumulator = Self.accumulator & Self.getZeroPageValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_ABS
				Self.accumulator = Self.accumulator & Self.getAbsoluteValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_ABSX
				Self.accumulator = Self.accumulator & Self.getAbsoluteValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_ABSY
				Self.accumulator = Self.accumulator & Self.getAbsoluteValueY()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_INDX
				Self.accumulator = Self.accumulator & Self.getIndirectValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_AND_INDY
				Self.accumulator = Self.accumulator & Self.getIndirectValueY()
				Self.updateNzFlags(Self.accumulator)


			' --------------------------------
			' -- ASL

			Case OP_ASL_ACC
				Self.accumulator = Self.arithmeticShiftLeft(Self.accumulator)

			Case OP_ASL_ZP
				Self.accumulator = Self.arithmeticShiftLeft(Self.getZeroPageValue())

			Case OP_ASL_ZPX
				Self.accumulator = Self.arithmeticShiftLeft(Self.getZeroPageValueX())

			Case OP_ASL_ABS
				Self.accumulator = Self.arithmeticShiftLeft(Self.getAbsoluteValue())

			Case OP_ASL_ABSX
				Self.accumulator = Self.arithmeticShiftLeft(Self.getAbsoluteValueX())


			' --------------------------------
			' -- BIT

			Case OP_BIT_ABS
				Local value:Byte = Self.getAbsoluteValue()
				Self.updateNVFlags(value)
				Self.zeroFlag = (0 = (Self.accumulator & value))

			Case OP_BIT_ZP
				Local value:Byte = Self.getZeroPageValue()
				Self.updateNVFlags(value)
				Self.zeroFlag = (0 = (Self.accumulator & value))


			' --------------------------------
			' -- CMP

			Case OP_CMP_IMM
				Self.compareRegister(Self.accumulator, Self.getImmediateValue())

			Case OP_CMP_ZP
				Self.compareRegister(Self.accumulator, Self.getZeroPageValue())

			Case OP_CMP_ZPX
				Self.compareRegister(Self.accumulator, Self.getZeroPageValueX())

			Case OP_CMP_ABS
				Self.compareRegister(Self.accumulator, Self.getAbsoluteValue())

			Case OP_CMP_ABSX
				Self.compareRegister(Self.accumulator, Self.getAbsoluteValueX())

			Case OP_CMP_ABSY
				Self.compareRegister(Self.accumulator, Self.getAbsoluteValueY())

			Case OP_CMP_INDX
				Self.compareRegister(Self.accumulator, Self.getIndirectValueX())

			Case OP_CMP_INDY
				Self.compareRegister(Self.accumulator, Self.getIndirectValueY())


			' --------------------------------
			' -- CPX

			Case OP_CPX_IMM
				Self.compareRegister(Self.xRegister, Self.getImmediateValue())

			Case OP_CPX_ZP
				Self.compareRegister(Self.xRegister, Self.getZeroPageValue())

			Case OP_CPX_ABS
				Self.compareRegister(Self.xRegister, Self.getAbsoluteValue())


			' --------------------------------
			' -- CPY

			Case OP_CPY_IMM
				Self.compareRegister(Self.yRegister, Self.getImmediateValue())

			Case OP_CPY_ZP
				Self.compareRegister(Self.yRegister, Self.getZeroPageValue())

			Case OP_CPY_ABS
				Self.compareRegister(Self.yRegister, Self.getAbsoluteValue())


			' --------------------------------
			' -- DEC

			Case OP_DEC_ZP
				Self.decreaseMemoryAt(Self.readNextByte())

			Case OP_DEC_ZPX
				Self.decreaseMemoryAt(Self.readNextByte() + Self.xRegister)

			Case OP_DEC_ABS
				Self.decreaseMemoryAt(Self.readNextWord())

			Case OP_DEC_ABSX
				Self.decreaseMemoryAt(Self.readNextWord() + Self.xRegister)


			' --------------------------------
			' -- EOR

			Case OP_EOR_IMM
				Self.exclusiveOr(Self.getImmediateValue())

			Case OP_EOR_ZP
				Self.exclusiveOr(Self.getZeroPageValue())

			Case OP_EOR_ZPX
				Self.exclusiveOr(Self.getZeroPageValueX())

			Case OP_EOR_ABS
				Self.exclusiveOr(Self.getAbsoluteValue())

			Case OP_EOR_ABSX
				Self.exclusiveOr(Self.getAbsoluteValueX())

			Case OP_EOR_ABSY
				Self.exclusiveOr(Self.getAbsoluteValueY())

			Case OP_EOR_INDX
				Self.exclusiveOr(Self.getIndirectValueX())

			Case OP_EOR_INDY
				Self.exclusiveOr(Self.getIndirectValueY())


			' --------------------------------
			' -- INC

			Case OP_INC_ZP
				Self.increaseMemoryAt(Self.readNextByte())

			Case OP_INC_ZPX
				Self.increaseMemoryAt(Self.readNextByte() + Self.xRegister)

			Case OP_INC_ABS
				Self.increaseMemoryAt(Self.readNextWord())

			Case OP_INC_ABSX
				Self.increaseMemoryAt(Self.readNextWord() + Self.xRegister)


			' --------------------------------
			' -- JMP

			Case OP_JMP_ABS
				Self.programCounter = Self.readNextWord()

			Case OP_JMP_IND
				Self.programCounter = Self.peekWrappedWordAt(Self.readNextWord())


			' --------------------------------
			' -- JSR

			Case OP_JSR
				Self.pushWordToStack(Self.programCounter - 1)
				Self.programCounter = Self.readNextWord()


			' --------------------------------
			' -- RTS

			Case OP_RTS
				Self.programCounter = Self.popWordFromStack() + 1


			' --------------------------------
			' -- ROL

			Case OP_ROL_ACC
				Self.accumulator = Self.arithmeticShiftLeft(Self.accumulator)

			Case OP_ROL_ZP
				Self.rolMemoryAt(Self.readNextByte())

			Case OP_ROL_ZPX
				Self.rolMemoryAt(Self.readNextByte() + Self.xRegister)

			Case OP_ROL_ABS
				Self.rolMemoryAt(Self.readNextWord())

			Case OP_ROL_ABSX
				Self.rolMemoryAt(Self.readNextWord() + Self.xRegister)


			' --------------------------------
			' -- ROR

			Case OP_ROR_ACC
				Self.accumulator = Self.arithmeticShiftLeft(Self.accumulator)

			Case OP_ROR_ZP
				Self.rorMemoryAt(Self.readNextByte())

			Case OP_ROR_ZPX
				Self.rorMemoryAt(Self.readNextByte() + Self.xRegister)

			Case OP_ROR_ABS
				Self.rorMemoryAt(Self.readNextWord())

			Case OP_ROR_ABSX
				Self.rorMemoryAt(Self.readNextWord() + Self.xRegister)


			' --------------------------------
			' -- LDA

			Case OP_LDA_IMM
				Self.accumulator = Self.readNextByte()
				Self.updateNzFlags(Self.accumulator)

			Case OP_LDA_ZP
				Self.accumulator = Self.peekZeroPageByte(Self.readNextByte())
				Self.updateNzFlags(Self.accumulator)

			Case OP_LDA_ZPX
				Self.accumulator = Self.peekZeroPageByte(Self.readNextByte() + Self.xRegister)
				Self.updateNZFlags(Self.accumulator)

			Case OP_LDA_ABS
				Self.accumulator = Self.peekByteAt(Self.readNextWord())
				Self.updateNZFlags(Self.accumulator)

			Case OP_LDA_ABSX
				Self.accumulator = Self.peekByteAt(Self.readNextWord() + Self.xRegister)
				Self.updateNZFlags(Self.accumulator)

			Case OP_LDA_ABSY
				Self.accumulator = Self.peekByteAt(Self.readNextWord() + Self.yRegister)
				Self.updateNZFlags(Self.accumulator)

			Case OP_LDA_INDX
				' 1. Read a byte from PC and add X register to it.
				' 2. Read a ZP byte from the address in #1
				' 3. Read a word from the address at #2
				' 4. Load a byte from the address in #3 into the ACC
				Self.accumulator = Self.peekByteAt(Self.peekZeroPageWord(Self.readNextByte() + Self.xRegister))
				Self.updateNZFlags(Self.accumulator)

			Case OP_LDA_INDY
				' 1. Read a byte from PC
				' 2. Read a Word from the ZP address in #1
				' 3. Add Y register from word in #2
				' 4. Load a byte from the address in #3 into the ACC
				Self.accumulator = Self.peekByteAt(Self.peekZeroPageWord(Self.readNextByte()) + Self.yRegister)
				Self.updateNZFlags(Self.accumulator)


			' --------------------------------
			' -- LDX

			Case OP_LDX_IMM
				Self.xRegister = Self.readNextByte()
				Self.updateNZFlags(Self.xRegister)

			Case OP_LDX_ZP
				Self.xRegister = Self.peekZeroPageByte(Self.readNextByte())
				Self.updateNZFlags(Self.xRegister)

			Case OP_LDX_ZPY
				Self.xRegister = Self.peekZeroPageByte(Self.readNextByte() + Self.yRegister)
				Self.updateNZFlags(Self.xRegister)

			Case OP_LDX_ABS
				Self.xRegister = Self.peekByteAt(Self.readNextWord())
				Self.updateNZFlags(Self.xRegister)

			Case OP_LDX_ABSY
				Self.xRegister = Self.peekByteAt(Self.readNextWord() + Self.yRegister)
				Self.updateNZFlags(Self.xRegister)


			' --------------------------------
			' -- LDY

			Case OP_LDY_IMM
				Self.yRegister = Self.readNextByte()
				Self.updateNZFlags(Self.yRegister)

			Case OP_LDY_ZP
				Self.yRegister = Self.peekZeroPageByte(Self.readNextByte())
				Self.updateNzFlags(Self.yRegister)

			Case OP_LDY_ZPX
				Self.yRegister = Self.peekZeroPageByte(Self.readNextByte() + Self.xRegister)
				Self.updateNzFlags(Self.yRegister)

			Case OP_LDY_ABS
				Self.yRegister = Self.peekByteAt(Self.readNextWord())
				Self.updateNzFlags(Self.yRegister)

			Case OP_LDY_ABSX
				Self.yRegister = Self.peekByteAt(Self.readNextWord() + Self.xRegister)
				Self.updateNzFlags(Self.yRegister)


			' --------------------------------
			' -- LSR

			Case OP_LSR_ACC
				Self.accumulator = Self.arithmeticShiftRight(Self.accumulator)

			Case OP_LSR_ZP
				Self.accumulator = Self.arithmeticShiftRight(Self.getZeroPageValue())

			Case OP_LSR_ZPX
				Self.accumulator = Self.arithmeticShiftRight(Self.getZeroPageValueX())

			Case OP_LSR_ABS
				Self.accumulator = Self.arithmeticShiftRight(Self.getAbsoluteValue())

			Case OP_LSR_ABSX
				Self.accumulator = Self.arithmeticShiftRight(Self.getAbsoluteValueX())


			' --------------------------------
			' -- SBC

			' TODO: Fix this
			Case OP_SBC_ZPX
				Local value1:Byte  = Self.accumulator
				Local value2:Byte  = Self.peekZeroPageByte(Self.readNextByte() + Self.xRegister)

				Local result:Short = value1 - value2 - (Not Self.carryFlag)
				Local value:Byte   = result ' Truncated

				Self.updateOverflowFlag(value1, value2, result)
				' TODO: Use `updateOverflowFlag` here
'				Self.overflowFlag = (Self.accumulator ~ value2) & (Self.accumulator ~ value)

				Self.accumulator = value
				Self.updateNegativeFlag(Self.accumulator)
				Self.updateZeroFlag(value)
				Self.carryFlag = (result <= $FF)


			' --------------------------------
			' -- STA

			Case OP_STA_ZP
				Self.writeMemory(Self.readNextByte(), Self.accumulator)

			Case OP_STA_ZPX
				Self.writeMemory(Self.readNextByte() + Self.xRegister, Self.accumulator)

			Case OP_STA_ABS
				Self.writeMemory(Self.readNextWord(), Self.accumulator)

			Case OP_STA_ABSX
				Self.writeMemory(Self.readNextWord() + Self.xRegister, Self.accumulator)

			Case OP_STA_ABSY
				Self.writeMemory(Self.readNextWord() + Self.yRegister, Self.accumulator)

			Case OP_STA_INDX
				' TODO: Fix this
				Self.writeMemory(Self.peekWordAt(Self.readNextByte()) + Self.xRegister, Self.accumulator)

			Case OP_STA_INDY
				Local address:Byte      = Self.readNextByte()
				Local fullAddress:Short = Self.peekWordAt(address) + Self.yRegister

				Self.writeMemory(fullAddress, Self.accumulator)


			' --------------------------------
			' -- STX

			Case OP_STX_ZP
				Self.writeMemory(Self.readNextByte(), Self.xRegister)

			Case OP_STX_ZPY
				Self.writeMemory(Self.readNextByte() + Self.yRegister, Self.xRegister)

			Case OP_STX_ABS
				Self.writeMemory(Self.readNextWord(), Self.xRegister)


			' --------------------------------
			' -- STY

			Case OP_STY_ZP
				Self.writeMemory(Self.readNextByte(), Self.yRegister)

			Case OP_STY_ZPX
				Self.writeMemory(Self.readNextByte() + Self.xRegister, Self.yRegister)

			Case OP_STY_ABS
				Self.writeMemory(Self.readNextWord(), Self.yRegister)


			' --------------------------------
			' -- Register Instructions

			Case OP_TAX
				Self.xRegister = Self.accumulator
				Self.updateNzFlags(Self.xRegister)

			Case OP_TXA
				Self.accumulator = Self.xRegister
				Self.updateNzFlags(Self.accumulator)

			Case OP_DEX
				Self.xRegister :- 1
				Self.updateNzFlags(Self.xRegister)

			Case OP_INX
				Self.xRegister :+ 1
				Self.updateNzFlags(Self.xRegister)

			Case OP_TAY
				Self.yRegister = Self.accumulator
				Self.updateNzFlags(Self.yRegister)

			Case OP_TYA
				Self.accumulator = Self.yRegister
				Self.updateNzFlags(Self.accumulator)

			Case OP_DEY
				Self.yRegister :- 1
				Self.updateNzFlags(Self.yRegister)

			Case OP_INY
				Self.yRegister :+ 1
				Self.updateNzFlags(Self.yRegister)


			' --------------------------------
			' -- NOP

			Case OP_NOP
				' No operation


			' --------------------------------
			' -- ORA

			Case OP_ORA_IMM
				Self.accumulator = Self.accumulator | Self.getImmediateValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_ZP
				Self.accumulator = Self.accumulator | Self.getZeroPageValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_ZPX
				Self.accumulator = Self.accumulator | Self.getZeroPageValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_ABS
				Self.accumulator = Self.accumulator | Self.getAbsoluteValue()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_ABSX
				Self.accumulator = Self.accumulator | Self.getAbsoluteValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_ABSY
				Self.accumulator = Self.accumulator | Self.getAbsoluteValueY()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_INDX
				Self.accumulator = Self.accumulator | Self.getIndirectValueX()
				Self.updateNzFlags(Self.accumulator)

			Case OP_ORA_INDY
				Self.accumulator = Self.accumulator | Self.getIndirectValueY()
				Self.updateNzFlags(Self.accumulator)


			' --------------------------------
			' -- Stack Instructions

			Case OP_TXS
				Self.stackPointer = Self.xRegister

			Case OP_TSX
				Self.xRegister = Self.stackPointer

			Case OP_PHA
				Self.pushByteToStack(Self.accumulator)

			Case OP_PLA
				Self.accumulator = Self.popByteFromStack()

			Case OP_PHP
				Self.pushByteToStack(Self.getProcessorState())

			Case OP_PLP
				Self.setProcessorState(Self.popByteFromStack())


			' --------------------------------
			' -- Flag Instructions

			Case OP_CLC
				Self.carryFlag = 0

			Case OP_SEC
				Self.carryFlag = 1

			Case OP_CLI
				Self.interruptFlag = 0

			Case OP_SEI
				Self.interruptFlag = 1

			Case OP_CLV
				Self.overflowFlag = 0

			Case OP_CLD
				Self.decimalFlag = 0

			Case OP_SED
				Self.decimalFlag = 1


			' --------------------------------
			' -- Branch Instructions

			' TODO: These can all be refactored into something like `jumpIfTrue(self.flag)`/jumpIfNotTrue
			Case OP_BPL
				Local address:Short = Self.readRelativeAddress()
				If Self.negativeFlag = 0 Then Self.programCounter = address

			Case OP_BMI
				Local address:Short = Self.readRelativeAddress()
				If Self.negativeFlag = 1 Then Self.programCounter = address

			Case OP_BVC
				Local address:Short = Self.readRelativeAddress()
				If Self.overflowFlag = 0 Then Self.programCounter = address

			Case OP_BVS
				Local address:Short = Self.readRelativeAddress()
				If Self.overflowFlag = 1 Then Self.programCounter = address

			Case OP_BCC
				Local address:Short = Self.readRelativeAddress()
				If Self.carryFlag= 0 Then Self.programCounter = address

			Case OP_BVC
				Local address:Short = Self.readRelativeAddress()
				If Self.carryFlag = 1 Then Self.programCounter = address

			Case OP_BNE
				Local address:Short = Self.readRelativeAddress()
				If Self.zeroFlag = 0 Then Self.programCounter = address

			Case OP_BEQ
				Local address:Short = Self.readRelativeAddress()
				If Self.zeroFlag = 1 Then Self.programCounter = address


			' --------------------------------
			' -- Break

			Case OP_BRK
				Self.breakFlag = 1


			' --------------------------------
			' -- Unknown opcode

			Default
				Throw "Unknown operation: " + ByteToHex(opcode)

		End Select

	End Method


	' ----------------------------------------------------------------------
	' -- State Helpers
	' ----------------------------------------------------------------------

	' Reset the internal state of the cpu.
	Method reset()
		Self.programCounter = 0
		Self.accumulator    = 0
	End Method

	' Pack the current processor state into a single byte.
	Method getProcessorState:Byte()
		Local state:Byte

		state :| Self.carryFlag Shl 0
		state :| Self.zeroFlag  Shl 1
		state :| Self.interruptFlag Shl 2
		state :| Self.decimalFlag Shl 3
		state :| 1 Shl 4 ' Break is active when using PHP
		state :| 1 Shl 5 ' Unused is always true when using PHP
		state :| Self.overflowFlag Shl 6
		state :| Self.negativeFlag Shl 7

		Return state
	End Method

	Method setProcessorState(state:Byte)
		Self.carryFlag     = state & (1 Shl 0)
		Self.zeroFlag      = state & (1 Shl 1)
		Self.interruptFlag = state & (1 Shl 2)
		Self.decimalFlag   = state & (1 Shl 3)
		Self.breakFlag     = state & (0 Shl 4)
		Self.overflowFlag  = state & (1 Shl 6)
		Self.negativeFlag  = state & (1 Shl 7)
	End Method


	' ----------------------------------------------------------------------
	' -- Memory Helpers
	' ----------------------------------------------------------------------

	' Peek a byte from Zero Page memory. BMX will automatically wrap the address.
	Method peekZeroPageByte:Byte(address:Byte)
		Return Self.memory.PeekByte(address)
	End Method

	Method peekZeroPageWord:Short(address:Byte)
		Local lowByte:Byte  = Self.peekByteAt(address)
		Local highByte:Byte = Self.peekByteAt(address + 1)

		Return (highByte Shl 8) + lowByte
	End Method

	Method peekByteAt:Byte(address:Short)
		Return Self.memory.PeekByte(address)
	End Method

	Method peekWordAt:Short(address:Short)
		Local lowByte:Byte  = Self.peekByteAt(address)
		Local highByte:Byte = Self.peekByteAt(address + 1)

		Return (highByte Shl 8) + lowByte
	End Method

	Method peekWrappedWordAt:Short(address:Short)
		Local lowByte:Byte  = Self.peekByteAt(address)
		Local highByte:Byte = Self.peekByteAt(address + 1)

		Return (highByte Shl 8) + lowByte
	End Method

	''' <summary>Read a byte from memory at the current program counter and move to the next byte.</summary>
	Method readNextByte:Byte()
		Self.programCounter :+ 1

		Return Self.memory.PeekByte(Self.programCounter - 1)
	End Method

	Method readNextWord:Short()
		Local lowByte:Byte  = Self.readNextByte()
		Local highByte:Byte = Self.readNextByte()

		Return (highByte Shl 8) + lowByte
	End Method

	' Read a value from memory and increase the program counter
	Method readMemory:Byte()
		Self.programCounter :+ 1
		Return Self.memory.PeekByte(Self.programCounter - 1)
	End Method

	' Write a value to the memory bank
	Method writeMemory(offset:Short, value:Byte)
		Self.memory.PokeByte(offset, value)
	End Method

	Method readWord:Short()
		Local highByte:Byte = Self.readMemory()
		Local lowByte:Byte  = Self.readMemory()

		Local value:Short   = (highByte Shl 8) + lowByte

		Return value
	End Method

	Method readWordWrapped:Short(address:Short)
		Throw "Not yet implemented"
	End Method

	Method readIndirectMemoryFrom:Byte(register:Byte)
		Local indirectAddress:Byte = Self.readMemory() + register
		Local address:Short        = Self.readWordWrapped(indirectAddress)

		Return Self.memory.PeekByte(address)
	End Method

	Method isNegative:Byte(value:Byte)
		' TODO: Make more blitzy
		Return ((1 Shl 7) & value) <> 0
	End Method


	' ----------------------------------------------------------------------
	' -- Memory Helpers
	' ----------------------------------------------------------------------

	Method getImmediateValue:Byte()
		Return Self.readNextByte()
	End Method

	Method getZeroPageValue:Byte()
		Return Self.peekZeroPageByte(Self.readNextByte())
	End Method

	Method getZeroPageValueX:Byte()
		Return Self.peekZeroPageByte(Self.readNextByte() + Self.xRegister)
	End Method

	Method getAbsoluteValue:Byte()
		Return Self.peekByteAt(Self.readNextWord())
	End Method

	Method getAbsoluteValueX:Byte()
		Return Self.peekByteAt(Self.readNextWord() + Self.xRegister)
	End Method

	Method getAbsoluteValueY:Byte()
		Return Self.peekByteAt(Self.readNextWord() + Self.yRegister)
	End Method

	Method getIndirectValueX:Byte()
		Return Self.peekByteAt(Self.peekZeroPageWord(Self.readNextByte() + Self.xRegister))
	End Method

	Method getIndirectValueY:Byte()
		Return Self.peekByteAt(Self.peekZeroPageWord(Self.readNextByte()) + Self.yRegister)
	End Method


	' ----------------------------------------------------------------------
	' -- Flag Functions
	' ----------------------------------------------------------------------

	Method updateCarryFlag(value:Byte)
		Self.carryFlag = ((value& $100) = $100)
	End Method

	Method updateOverflowFlag(value1:Byte, value2:Byte, result:Byte)
		Self.overflowFlag = (((value1 ~ result) & (value2 ~ result) & $80) = $80)
	End Method

	Method updateNzFlags(value:Byte)
		Self.updateZeroFlag(value)
		Self.updateNegativeFlag(value)
	End Method

	Method updateNVFlags(value:Byte)
		Self.updateNegativeFlag(value)
		Self.overflowFlag = ((1 Shl 6) & value) <> 0
	End Method

	Method updateZeroFlag(value:Byte)
		Self.zeroFlag = (0 = value)
	End Method

	Method updateNegativeFlag(value:Byte)
		Self.negativeFlag = Self.isNegative(value)
	End Method


	' ----------------------------------------------------------------------
	' -- Stack Functions
	' ----------------------------------------------------------------------

	Method pushWordToStack(value:Short)
		'Print "Pushed: " + ByteToHex(value) + " " + ByteToHex(value Shr 8)

		Self.pushByteToStack(value)
		Self.pushByteToStack(value Shr 8)
	End Method

	Method pushByteToStack(value:Byte)
		Self.writeMemory(STACK_START + Self.stackPointer, value)
		Self.stackPointer :+ 1
	End Method

	Method popByteFromStack:Byte()
		Self.stackPointer :- 1

		Return Self.peekByteAt(STACK_START + Self.stackPointer)
	End Method

	Method popWordFromStack:Short()
		Local highByte:Byte = Self.popByteFromStack()
		Local lowByte:Byte  = Self.popByteFromStack()

		' Print "Popped: " + ByteToHex(lowByte) + " " + ByteToHex(highByte)

		Return (highByte Shl 8) + lowByte
	End Method

	Method readRelativeAddress:Short()
		Local offset:Byte   = Self.readNextByte() + Self.programCounter
		Local address:Short = (Self.programCounter & $FF00) + offset

		Return address
	End Method

	Method addWithCarry:Byte(value2:Byte)
		Local value1:Byte  = Self.accumulator
		Local result:Short = value1 + value2 + Self.carryFlag

		Self.updateCarryFlag(result)
		Self.updateOverflowFlag(value1, value2, result)
		Self.updateNegativeFlag(result)

		Self.accumulator = result
	End Method

	Method arithmeticShiftLeft:Byte(value:Byte)
		Local wordResult:Short = value Shl 1 | Self.carryFlag
		Self.carryFlag = (wordResult > $FF)

		Local result:Byte = wordResult & $FF
		Self.updateNzFlags(result)

		Return result
	End Method

	Method arithmeticShiftRight:Byte(value:Byte)
		Local result:Byte = value Shr 1 | Self.carryFlag Shl 7

		Self.carryFlag = (0 <> (value & $01))
		Self.updateNzFlags(result)

		Return result
	End Method

	Method rolMemoryAt(address:Short)
		Self.writeMemory(address, Self.arithmeticShiftLeft(Self.peekByteAt(address)))
	End Method

	Method rorMemoryAt(address:Short)
		Self.writeMemory(address, Self.arithmeticShiftRight(Self.peekByteAt(address)))
	End Method

	Method compareRegister(register:Byte, value:Byte)
		Self.carryFlag    = (register >= value)
		Self.zeroFlag     = (register = value)
		Self.negativeFlag = Self.isNegative(register - value)
	End Method

	Method decreaseMemoryAt(address:Short)
		Self.writeMemory(address, Self.peekByteAt(address) - 1)
		Self.updateNzFlags(Self.peekByteAt(address))
	End Method

	Method increaseMemoryAt(address:Short)
		Self.writeMemory(address, Self.peekByteAt(address) + 1)
		Self.updateNzFlags(Self.peekByteAt(address))
	End Method

	Method exclusiveOr(value:Byte)
		Self.accumulator = Self.accumulator ~ value
		Self.updateNzFlags(Self.accumulator)
	End Method

	Method dumpState:String()
		Local output:String = ""

		output :+ "Carry      : " + Self.carryFlag
		output :+ "  | Overflow:  " + Self.overflowFlag
		output :+ "  | Negative: " + Self.negativeFlag
		output :+ "  | Zero: " + Self.zeroFlag
		output :+ "~n"
		output :+ "Accumulator: " + ByteToHex(Self.accumulator)
		output :+ " | X Reg   : " + ByteToHex(Self.xRegister)
		output :+ "  | Y Reg   : " + ByteToHex(Self.yRegister)

		Return output
	End Method

	Function Create:CPU(memory:TBank)
		Local this:CPU = New CPU
		this.memory = memory
		this.reset()
		Return this
	End Function

End Type
