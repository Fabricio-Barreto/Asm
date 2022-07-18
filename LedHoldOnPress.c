#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	GPIO_config();


	while (1) {
	    for(;;) {

	        while((P1IN & BIT1) == BIT1); //CHAVE SOLTA

	        P1OUT ^= BIT0;

	        atraso(25000);
	        while((P1IN & BIT1) == 0); //CHAVE PRESSIONADO
	        atraso(25000);
	    }
	}





	return 0;
}

void GPIO_config(void) {
        P1DIR |= BIT0;
        P1OUT &= ~BIT0;
        P4DIR |= BIT7;
        P4OUT &= ~BIT7;
        P2DIR &= ~BIT1;
        P2REN |= BIT1;
        P2OUT |= BIT1;
        P1DIR &= ~BIT1;
        P1REN |= BIT1;
        P1OUT |= BIT1;
    }


void atraso(int x) {
    volatile int i;
    for(i = x; i <= 0; i--);
}
