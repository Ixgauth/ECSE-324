#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"

void test_char()
{
	int x, y;
	char c = 0;
	
	for(y =0; y <= 59; y++)
	{
		for(x = 0; x <= 79; x++)
		{
			VGA_write_char_ASM(x,y,c++);
		}
	}
}

void test_byte()
{
	int x, y;
	char c = 0;
	
	for(y =0; y <= 59; y++)
	{
		for(x = 0; x <= 79; x+=3)
		{
			VGA_write_byte_ASM(x,y,c++);
		}
	}
}

void test_pixel()
{
	int x, y;
	unsigned short colour = 0;
	
	for(y =0; y <= 239; y++)
	{
		for(x = 0; x <= 319; x++)
		{
			VGA_draw_point_ASM(x,y,colour++);
		}
	}
}


int main() {
	// Audio Test!!!!!!!!!!!!!!!!!!!!
	// Sampling rate = 48 000 samples/s, frequency = 100 Hz --> 480 samples/cycle or 240 samples/half-cycle
	int sampleNumberLow;
	int sampleNumberHigh;
	int audioSuboutineResult;
	while(1)
	{
		sampleNumberLow = 0;
		sampleNumberHigh = 0;
		while(sampleNumberLow < 3400)
		{
			audioSuboutineResult = write_data_audio_ASM(0x0000000);
			if(audioSuboutineResult == 1)
			{
				sampleNumberLow++;
			}
		}
		while(sampleNumberHigh < 3400)
		{
			audioSuboutineResult = write_data_audio_ASM(0x00FFFFFF);
			if(audioSuboutineResult == 1)
			{
				sampleNumberHigh++;
			}
		}
		sampleNumberLow = 0;
		sampleNumberHigh = 0;
	}
		
	

	// Keyboard test!!!!!!!!!!!!!!!
	/*int x = 0;
	int y = 0;
	int x_max = 78;
	int y_max = 59;
	char data;

	VGA_clear_charbuff_ASM();

	while(1){
		if (read_PS2_data_ASM(&data)) {
			VGA_write_byte_ASM(x, y, data);
			x += 3;
			if (x > x_max) {
				x = 0;
				y++;
				if (y > y_max) {
					y = 0;
					VGA_clear_charbuff_ASM();
				}
			}
		}
	} */
	
	

	// VGA Test!!!!!!!!!!!!!!!!!!!!!!!!
	/*int sliderSwitches = 0;
	int buttonInput = 0;
	while(1)
	{
		
		sliderSwitches = read_slider_switches_ASM();
		buttonInput = read_PB_data_ASM();
		if(buttonInput == 1 && sliderSwitches != 0)
		{
			test_byte();
		}
		else if(buttonInput == 1)
		{
			test_char();
		}
		else if(buttonInput == 2)
		{
			test_pixel();
		}
		else if(buttonInput == 4)
		{
			VGA_clear_charbuff_ASM();
		}
		else if(buttonInput == 8)
		{
			VGA_clear_pixelbuff_ASM();
		}

	}*/

	
	return 0; 
}
