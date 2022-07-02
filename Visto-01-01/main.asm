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

EXP1:		MOV			#MSG,R5			;Coloca o vetor MSG em R5
			MOV			#GSM,R6			;Coloca o vetor GSM em R6
			MOV			#MSG_DECIF,R8
			MOV.B		#'A',R11
			MOV.B		#'Z',R12
			CALL		#ENIGMA1		;Chama a sub-rotina ENIGMA1
			MOV			#GSM,R9
			CALL		#DECIF1
				JMP			$

ENIGMA1:	MOV.B		@R5,R7			;Coloca o primeiro byte o vetor de R5 em R7
			TST.B		R7				;Verifica se o byte de R7 é 0
			JNZ			EN1				;Se a FLAG 0 não estiver levantada chama a sub-rotina EN1
			RET							;Return

EN1:		MOV.B		R7,R10
			CMP.B		R12,R10
			JHS			ESP1
			CMP.B		R11,R10
			JLO			ESP1
			SUB.B		#'A',R7			;Subtrai o valor de A do byte de R7
			MOV.B		RT3(R7),R7		;Pega o byte de RT1 na posição do valor de R7 e coloca em R7
			ADD.B		#'A',R7			;Soma A no byte de R7
ESP1:		MOV.B		R7,0(R6)		;Coloca R7 no vetor de R6
			INC			R5				;Anda uma posição no vetor R5
			INC			R6				;Anda uma posição no vetor R6
			JMP 		ENIGMA1			;Chama a sub-rotina ENIGMA1

DECIF1:		MOV.B		@R6,R9
			TST.B		R9
			JNZ			EN2
			RET

EN2:		SUB.B		#'A',R9
			MOV.B		RT3(R9),R9
			ADD.B		#'A',R9
			MOV.B		R9,0(R8)
ESP2:		INC			R8
			INC			R6
			JMP 		DECIF1

			.data
MSG:		.byte		"QUE EU CONHECO DE VISTA E DE CHAPEU.@MACHADO\ASSIS",0
GSM:		.byte		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
MSG_DECIF:	.byte		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
RT3: 		.byte 		23, 21, 18, 2, 15, 14, 0, 25, 3, 8, 4, 17, 7
 			.byte 		24, 5, 10, 11, 20, 22, 1, 12, 9, 16, 6, 19, 13
                                            

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
            
