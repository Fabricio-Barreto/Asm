#include <msp430.h> 

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	GPIO_config();

	TA2CTL = TASSEL_2 |
	        MC_1;
	TA2CCR0 = 20971;
	TA2CCTL2 = OUTMOD_6;
	TA2CCR2 = 1572;

	while(1) {
	    if((P2IN & BIT1) == 0){
	        TA2CCR2 = 524;
	    } else if ((P1IN & BIT1) == 0){
	        TA2CCR2 = 2621;
	    } else {
	        TA2CCR2 = 1572;
	    }

	}


	return 0;
}

void GPIO_config(void) {
    P2DIR |= ~BIT5;
    P2REN |= BIT5;

    P2DIR &= ~BIT1;
    P2REN |= BIT1;
    P2IN |= BIT1;

    P1DIR &= ~BIT1;
    P1REN |= BIT1;
    P1IN |= BIT1;

}
