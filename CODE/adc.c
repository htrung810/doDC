#include <main.h>
#include <adc.h>

unsigned int adc;
// Declare your global variables here
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
// Start the AD conversion
    ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

unsigned int N;
float gtri_bcd()
{                                                                        
    float giatri, temp, temp2;
    N = read_adc(0);   
    temp = ((float)N * 5) / 1023;
    temp2 = temp * 5.7 * 100;
    //temp2 = temp * 6.602 * 100;
    giatri = temp2 / 100;
    return giatri;
}

void lcd_putnum(unsigned int N)
{
     float temp, temp2, giatri;      
     unsigned int Nghin, Tram, Chuc, Dv, temp3;
     temp = ((float)N * 5) / 1023;
     temp2 = temp * 5.7 * 100;
     //temp2 = temp * 6.602 * 100;
     temp3 = (int)temp2;   
     Nghin = temp3/1000;
     Tram = (temp3%1000) /100;
     Chuc = (temp3%100) /10;
     Dv = temp3 % 10;
     lcd_putchar(Nghin + 48);
     lcd_putchar(Tram + 48);
     lcd_putchar(',');
     lcd_putchar(Chuc + 48);
     lcd_putchar(Dv + 48);
     lcd_putchar('V');
     giatri = temp2 / 100;
     if (giatri > 11.9)
     {  
        PORTD.7 = 0;                  
        lcd_gotoxy(1,1);
        lcd_puts("ON DINH");
        
        if(giatri>=12.7)
        {
            lcd_puts(": 100%");
        }
        else if (giatri >= 12.5)
        {
            
            lcd_puts(": 90%");
        }
        else if (giatri >= 12.42)
        {
           
            lcd_puts(": 80%");
        }    
        else if (giatri >= 12.32)
        {
           
            lcd_puts(": 70%");
        }  
        else if (giatri >= 12.20)
        {
           
            lcd_puts(": 60%");
        }            
        else if (giatri >= 12.06)
        {
           
            lcd_puts(": 50%");
        }              
        else
        {
            lcd_puts(": 40%");
        }
     }                
     else if (giatri >= 11.58)
     {  
        PORTD.7 = 1;
        lcd_gotoxy(1,1);
        lcd_puts("CANH BAO"); 
         if(giatri >= 11.75)
        {
            lcd_puts(": 30%");
        }
         else
        {  
            lcd_puts(": 20%");
        }       
        delay_ms(1000);
        PORTD.7 = 0;
     }                               
     else if(giatri < 11.58)
     {  PORTD.7 = 1;
        lcd_gotoxy(1,1);
        lcd_puts("NGUY HIEM");
         if (giatri >= 11.31)
        {
            lcd_puts(": 10%");
        }
        else
        { 
            lcd_puts(": 0%");
        } 
     }
}

void lcd_hienthi()
{
    adc = read_adc(0);    
    lcd_puts("Gia Tri: ");
    lcd_putnum(adc);
    delay_ms(1000);
    lcd_clear();
}