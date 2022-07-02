;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
RT_TAM 		.equ 		6 					;Tamanho dos rotores
CONF1 		.equ 		1 					;Configuração do Rotor 1


EXP2:		MOV			#MSG,R5
			MOV			#GSM,R6
			MOV			#MSG_DECIF,R12
			CALL		#CONFIG
			MOV.B		#'A',R11
			MOV.B		#'Z',R12
			CALL		#ENIGMA3
			JMP			$

ENIGMA3:	MOV.B		@R5,R7
			TST.B		R7
			JNZ			EN1
			RET

EN1:		MOV.B		R7,R10
			CMP.B		R12,R10
			JHS			ESP
			CMP.B		R11,R10
			JLO			ESP
			SUB.B		#'A',R7
			MOV.B		RT3(R7),R7
			MOV.B		RF2(R7),R7
			MOV			#RT3,R8
			CALL		#RINV
			ADD.B		#'A',R7
ESP:		MOV.B		R7,0(R6)
			INC			R5
			INC			R6
			JMP			ENIGMA3

RINV:		CLR			R9
RX0:		CMP.B		R7,0(R8)
			JEQ			RX1
			INC			R8
			INC			R9
			JMP			RX0
RX1:		MOV			R9,R7
			RET

CONFIG:		MOV			#CONFI,R9
			RLA.B		#RT3

			JNZ			CONFIG
			RET

			.data
MSG:		.byte		"QUE EU CONHECO DE VISTA E DE CHAPEU.@MACHADO\ASSIS",0
GSM:		.byte		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
MSG_DECIF:	.byte		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
RT3: 		.byte 		23, 21, 18, 2, 15, 14, 0, 25, 3, 8, 4, 17, 7
 			.byte 		24, 5, 10, 11, 20, 22, 1, 12, 9, 16, 6, 19, 13
RF2: 		.byte 		1, 0, 16, 25, 6, 24, 4, 23, 14, 13, 17, 18, 19
			.byte 		9, 8, 22, 2, 10, 11, 12, 21, 20, 15, 7, 5, 3
CONFI:		.byte		1,0

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
