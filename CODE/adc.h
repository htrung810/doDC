#ifndef __ADC_H
#define __ADC_H

#include <main.h>
#include <adc.c>

unsigned int read_adc(unsigned char adc_input);
// Ham hien thi so ra LCD1602
void lcd_putnum(unsigned int N);
// Ham doc va hien thi gia tri ADC len LCD1602
void lcd_hienthi();

#endif 