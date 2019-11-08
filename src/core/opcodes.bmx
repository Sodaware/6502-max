' ------------------------------------------------------------------------------
' -- src/frontend/opcodes.bmx
' --
' -- Opcode constants.
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Const OP_ADC_ABS:Byte  = $6D
Const OP_ADC_ABSX:Byte = $7D
Const OP_ADC_ABSY:Byte = $79
Const OP_ADC_IMM:Byte  = $69
Const OP_ADC_INDX:Byte = $61
Const OP_ADC_INDY:Byte = $71
Const OP_ADC_ZP:Byte   = $65
Const OP_ADC_ZPX:Byte  = $75
Const OP_AND_ABS:Byte  = $2D
Const OP_AND_ABSX:Byte = $3D
Const OP_AND_ABSY:Byte = $39
Const OP_AND_IMM:Byte  = $29
Const OP_AND_INDX:Byte = $21
Const OP_AND_INDY:Byte = $31
Const OP_AND_ZP:Byte   = $25
Const OP_AND_ZPX:Byte  = $35
Const OP_ASL_ABS:Byte  = $0E
Const OP_ASL_ABSX:Byte = $1E
Const OP_ASL_ACC:Byte  = $0A
Const OP_ASL_ZP:Byte   = $06
Const OP_ASL_ZPX:Byte  = $16
Const OP_BCC:Byte      = $90
Const OP_BCS:Byte      = $B0
Const OP_BEQ:Byte      = $F0
Const OP_BIT_ABS:Byte  = $2C
Const OP_BIT_ZP:Byte   = $24
Const OP_BMI:Byte      = $30
Const OP_BNE:Byte      = $D0
Const OP_BPL:Byte      = $10
Const OP_BRK:Byte      = $00
Const OP_BVC:Byte      = $50
Const OP_BVS:Byte      = $70
Const OP_CLC:Byte      = $18
Const OP_CLD:Byte      = $D8
Const OP_CLI:Byte      = $58
Const OP_CLV:Byte      = $B8
Const OP_CMP_ABS:Byte  = $CD
Const OP_CMP_ABSX:Byte = $DD
Const OP_CMP_ABSY:Byte = $D9
Const OP_CMP_IMM:Byte  = $C9
Const OP_CMP_INDX:Byte = $C1
Const OP_CMP_INDY:Byte = $D1
Const OP_CMP_ZP:Byte   = $C5
Const OP_CMP_ZPX:Byte  = $D5
Const OP_CPX_ABS:Byte  = $EC
Const OP_CPX_IMM:Byte  = $E0
Const OP_CPX_ZP:Byte   = $E4
Const OP_CPY_ABS:Byte  = $CC
Const OP_CPY_IMM:Byte  = $C0
Const OP_CPY_ZP:Byte   = $C4
Const OP_DEX:Byte      = $CA
Const OP_DEY:Byte      = $88
Const OP_INC_ABS:Byte  = $EE
Const OP_INC_ABSX:Byte = $FE
Const OP_INC_ZP:Byte   = $E6
Const OP_INC_ZPX:Byte  = $F6
Const OP_INX:Byte      = $E8
Const OP_INY:Byte      = $C8
Const OP_JMP_ABS:Byte  = $4C
Const OP_JMP_IND:Byte  = $6C
Const OP_JSR:Byte      = $20
Const OP_LDA_ABS:Byte  = $AD
Const OP_LDA_ABSX:Byte = $BD
Const OP_LDA_ABSY:Byte = $D9
Const OP_LDA_IMM:Byte  = $A9
Const OP_LDA_INDX:Byte = $A1
Const OP_LDA_INDY:Byte = $B1
Const OP_LDA_ZP:Byte   = $A5
Const OP_LDA_ZPX:Byte  = $B5
Const OP_LDX_ABS:Byte  = $AE
Const OP_LDX_ABSY:Byte = $BE
Const OP_LDX_IMM:Byte  = $A2
Const OP_LDX_ZP:Byte   = $A6
Const OP_LDX_ZPY:Byte  = $B6
Const OP_LDY_ABS:Byte  = $AC
Const OP_LDY_ABSX:Byte = $BC
Const OP_LDY_IMM:Byte  = $A0
Const OP_LDY_ZP:Byte   = $A4
Const OP_LDY_ZPX:Byte  = $B4
Const OP_NOP:Byte      = $EA
Const OP_PHA:Byte      = $48
Const OP_PHP:Byte      = $08
Const OP_PLA:Byte      = $68
Const OP_PLP:Byte      = $28
Const OP_ROL_ABS:Byte  = $2E
Const OP_ROL_ABSX:Byte = $3E
Const OP_ROL_ACC:Byte  = $2A
Const OP_ROL_ZP:Byte   = $26
Const OP_ROL_ZPX:Byte  = $36
Const OP_RTS:Byte      = $60
Const OP_SBC_ABS:Byte  = $ED
Const OP_SBC_ABSX:Byte = $FD
Const OP_SBC_ABSY:Byte = $F9
Const OP_SBC_IMM:Byte  = $E9
Const OP_SBC_INDX:Byte = $E1
Const OP_SBC_INDY:Byte = $F1
Const OP_SBC_ZP:Byte   = $E5
Const OP_SBC_ZPX:Byte  = $F5
Const OP_SEC:Byte      = $38
Const OP_SED:Byte      = $F8
Const OP_SEI:Byte      = $78
Const OP_STA_ABS:Byte  = $8D
Const OP_STA_ABSX:Byte = $9D
Const OP_STA_ABSY:Byte = $99
Const OP_STA_INDX:Byte = $81
Const OP_STA_INDY:Byte = $91
Const OP_STA_ZP:Byte   = $85
Const OP_STA_ZPX:Byte  = $95
Const OP_STX_ABS:Byte  = $8E
Const OP_STX_ZP:Byte   = $86
Const OP_STX_ZPY:Byte  = $96
Const OP_STY_ABS:Byte  = $8C
Const OP_STY_ZP:Byte   = $84
Const OP_STY_ZPX:Byte  = $94
Const OP_TAX:Byte      = $AA
Const OP_TAY:Byte      = $A8
Const OP_TSX:Byte      = $BA
Const OP_TXA:Byte      = $8A
Const OP_TXS:Byte      = $9A
Const OP_TYA:Byte      = $98
