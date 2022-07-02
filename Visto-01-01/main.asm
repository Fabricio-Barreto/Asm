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
			CALL		#ENIGMA1		;Chama a sub-rotina ENIGMA1
			CALL		#DECIF1
			JMP			$

ENIGMA1:	MOV.B		@R5,R7			;Coloca o primeiro byte o vetor de R5 em R7
			TST.B		R7				;Verifica se o byte de R7 é 0
			JNZ			EN1				;Se a FLAG 0 não estiver levantada chama a sub-rotina EN1
			RET							;Return

EN1:		SUB.B		#'A',R7			;Subtrai o valor de A do byte de R7
			MOV.B		RT1(R7),R7		;Pega o byte de RT1 na posição do valor de R7 e coloca em R7
			ADD.B		#'A',R7			;Soma A no byte de R7
			MOV.B		R7,0(R6)		;Coloca R7 no vetor de R6
			INC			R5				;Anda uma posição no vetor R5
			INC			R6				;Anda uma posição no vetor R6
			JMP 		ENIGMA1			;Chama a sub-rotina ENIGMA1

DECIF1:		MOV.B		@R6,R9
			TST.B		R9
			JNZ			EN2
			RET

EN2:		SUB.B		#'A',R9
			MOV.B		RT1(R9),R9
			ADD.B		#'A',R9
			MOV.B		R9,0(R8)
			INC			R8
			INC			R6
			JMP 		DECIF1

			.data
MSG:		.byte		"ABCDEF",0
GSM:		.byte		"XXXXXX",0
MSG_DECIF:	.byte		"XXXXXX	",0
RT1:		.byte		2,4,1,5,3,0
                                            

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
            
