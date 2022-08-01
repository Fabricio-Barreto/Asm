#include <msp430.h> 

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	Aa1_config();
	
	while(1) {
	    TA1CCTL1 = CM_1 | SCS | CAP;
	    while((TA1CCTL1 & CCIFG) == 0);
	    TA1CCTL1 &= ~CCIFG;
	    x1 = TA1CCR1;
	    TA1CCTL1 = CM_2 |SCS | CAP;
	    while((TA1CCTL1 & CCIFG) == 0);
	    TA1CCTL1 &= ~CCIFG;
	    x2 = TA1CCR1;
	    dif = x2 - x1;
	}

	


	return 0;
}


void Aa1_config(void) {
    TA1CTL = TASSEL_2 | MC_2;
    TA1CCTL1 = CM_1 | SCS | CAP;
}
