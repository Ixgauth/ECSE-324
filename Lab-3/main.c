#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"

int main() {
	/*int count0 = 0;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0|TIM1|TIM2|TIM3;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

	while(1)
	{
		if(HPS_TIM_read_INT_ASM(TIM0))
		{
			HPS_TIM_clear_INT_ASM(TIM0);
			if(++count0 == 16)
			{
				count0 = 0;
			}
		HEX_write_ASM(HEX0, count0);
		}

		if(HPS_TIM_read_INT_ASM(TIM1))
		{
			HPS_TIM_clear_INT_ASM(TIM1);
			if(++count1 == 16)
			{
				count1 = 0;
			}
		HEX_write_ASM(HEX1, count1);
		}

		if(HPS_TIM_read_INT_ASM(TIM2))
		{
			HPS_TIM_clear_INT_ASM(TIM2);
			if(++count2 == 16)
			{
				count2 = 0;
			}
		HEX_write_ASM(HEX2, count2);
		}

		if(HPS_TIM_read_INT_ASM(TIM3))
		{
			HPS_TIM_clear_INT_ASM(TIM3);
			if(++count3 == 16)
			{
				count3 = 0;
			}
		HEX_write_ASM(HEX3, count3);
		}


	}
	return 0;
}*/

	int sliderValues = 0;
	int pushValues = 0;
	int buttonInput = 0;
	int buttons[4] = {0,0,0,0};
	enable_PB_int_ASM(PB0 | PB1 | PB2 | PB3);
	while(1) {
		write_LEDs_ASM(read_slider_switches_ASM());
		sliderValues = read_slider_switches_ASM()/512;
		buttonInput = read_PB_edgecap_ASM();
		if(sliderValues == 1)
		{
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
		}
		else 
		{
			
			sliderValues = read_slider_switches_ASM()%16;
			printf("SliderValues: %d\n", sliderValues);
			HEX_write_ASM(read_PB_data_ASM(), sliderValues);
			HEX_flood_ASM(HEX4 | HEX5);
		}

	}
	return 0;
}
