
// CONFIG1L
#pragma config FEXTOSC = HS     // External Oscillator mode Selection bits (HS (crystal oscillator) above 8 MHz; PFM set to high power)
#pragma config RSTOSC = EXTOSC  // Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

// CONFIG1H
#pragma config CLKOUTEN = OFF   // Clock Out Enable bit (CLKOUT function is disabled)
#pragma config CSWEN = ON       // Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)

// CONFIG2L
#pragma config MCLRE = EXTMCLR  // Master Clear Enable bit (If LVP = 0, MCLR pin is MCLR; If LVP = 1, RE3 pin function is MCLR )
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (Power up timer disabled)
#pragma config LPBOREN = OFF    // Low-power BOR enable bit (ULPBOR disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled , SBOREN bit is ignored)

// CONFIG2H
#pragma config BORV = VBOR_2P45 // Brown Out Reset Voltage selection bits (Brown-out Reset Voltage (VBOR) set to 2.45V)
#pragma config ZCD = OFF        // ZCD Disable bit (ZCD disabled. ZCD can be enabled by setting the ZCDSEN bit of ZCDCON)
#pragma config PPS1WAY = ON     // PPSLOCK bit One-Way Set Enable bit (PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config DEBUG = OFF      // Debugger Enable bit (Background debugger disabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Extended Instruction Set and Indexed Addressing Mode disabled)

// CONFIG3L
#pragma config WDTCPS = WDTCPS_31// WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)
#pragma config WDTE = OFF       // WDT operating mode (WDT Disabled)

// CONFIG3H
#pragma config WDTCWS = WDTCWS_7// WDT Window Select bits (window always open (100%); software control; keyed access not required)
#pragma config WDTCCS = SC      // WDT input clock selector (Software Control)


#pragma config LVP = OFF        // Low Voltage Programming Enable bit (HV on MCLR/VPP must be used for programming)



#include <xc.h>
#include <stdint.h>
#include <pic18f47k40.h>

#define _XTAL_FREQ 8000000

uint8_t i;

void main() 
{
    ANSELA = 0b00000000;
    ANSELB = 0b00000000;
    ANSELC = 0b00000000;
    ANSELD = 0b00000000;
    TRISA  = 0b00000000;
    TRISB  = 0b11110000;
    TRISC  = 0b00000000;
    TRISD  = 0b00000000;
    LATA   = 0b00000000;
    LATB   = 0b00001111;
    LATC   = 0b00000000;
    LATD   = 0b00000000;
    
    
    
    while (1) {
        LATAbits.LATA0 = 1;
        
        LATD = 0b1100110;        

        __delay_us(3000);
        
        LATAbits.LATA0 = 0;
        
        LATAbits.LATA1 = 1;
                
        __delay_us(3000);
        
        LATD = 0b1100110;
        
        __delay_us(3000);
        
        LATAbits.LATA1 = 0;
        
        LATAbits.LATA2 = 1;
                
        __delay_us(3000);
        
        LATD = 0b0000110;
        
        __delay_us(3000);
        
        LATA = 0;
        
        __delay_us(3000);
    }
 
    while (1) 
    {   
        // Row 1
        i=0;
           
        while (PORTBbits.RB4 == 1) 
        {
            LATB<<=1;
            i++;
            __delay_ms(1);
        }

        LATC = 0;
        LATB = 0b00001111;
        switch (i) 
        {
            case 1:
            LATCbits.LATC0 = 1;
            break;
            case 2:
            LATCbits.LATC1 = 1;
            break;
            case 3:
            LATCbits.LATC2 = 1;
            break;
            case 4:
            LATCbits.LATC3 = 1;
            break;
        }
        
        // Row 1
        i=0;
           
        while (PORTBbits.RB5 == 1) 
        {
            LATB<<=1;
            i++;
            __delay_ms(1);
        }

        LATC = 0;
        LATB = 0b00001111;
        switch (i) 
        {
            case 1:
            LATCbits.LATC0 = 1;
            break;
            case 2:
            LATCbits.LATC1 = 1;
            break;
            case 3:
            LATCbits.LATC2 = 1;
            break;
            case 4:
            LATCbits.LATC3 = 1;
            break;
        }
        
        // Row 1
        i=0;
           
        while (PORTBbits.RB6 == 1) 
        {
            LATB<<=1;
            i++;
            __delay_ms(1);
        }

        LATC = 0;
        LATB = 0b00001111;
        switch (i) 
        {
            case 1:
            LATCbits.LATC0 = 1;
            break;
            case 2:
            LATCbits.LATC1 = 1;
            break;
            case 3:
            LATCbits.LATC2 = 1;
            break;
            case 4:
            LATCbits.LATC3 = 1;
            break;
        }
        
        // Row 1
        i=0;
           
        while (PORTBbits.RB7 == 1) 
        {
            LATB<<=1;
            i++;
            __delay_ms(1);
        }

        LATC = 0;
        LATB = 0b00001111;
        switch (i) 
        {
            case 1:
            LATCbits.LATC0 = 1;
            break;
            case 2:
            LATCbits.LATC1 = 1;
            break;
            case 3:
            LATCbits.LATC2 = 1;
            break;
            case 4:
            LATCbits.LATC3 = 1;
            break;
        }
        __delay_ms(10);
    }
}
