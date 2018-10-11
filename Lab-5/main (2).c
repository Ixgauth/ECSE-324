#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include <stdio.h>
#include <math.h>

//int keyValues[] = {0,0,0,0,0,0,0,0};


//helper class which performed mod operation with doubles as this is not possible with the simple mod instruction in c
double modulous (double numerator, int modValue)
{
	double division = numerator / modValue;
	int truncateDivision = (int)division;
	double multiply = truncateDivision*modValue; 
	double modEnd = numerator - multiply;
	return modEnd;
}

//should take in the time frequency and amplitude and output the correct value of the signal input at that time
//uses the mathematical method included in the lab procedure to find the values to be input into the sine function and then add those into signal at t and return
double getSignalAtT (double time, double frequency, double amplitude)
{
	double fByT = (frequency * time);
	double index = modulous(fByT, 48000);
	double signalAtT;
		
	int indexBase = (int)index;
	double indexDecimal = index - (double)indexBase;
	double fullTable[] = {0,0,0};
	if(indexDecimal == 0)
	{
		fullTable[0] = index;
		fullTable[1] = 1;
		fullTable[2] = 0;
		signalAtT = amplitude*(sine[indexBase]*fullTable[1]);
	}
	else
	{
		fullTable[0] = indexBase;
		fullTable[1] = 1 - indexDecimal;
		fullTable[2] = indexDecimal;
		signalAtT = amplitude*(sine[indexBase]*fullTable[1] + sine[indexBase+1]*fullTable[2]);
	}
	return signalAtT;
}


//old display wave implementation which should partition the screen and then for all 320 x values get the corresponding y value and print them all to the screen
//did not work, kept for clarity and reference in report
void displayWave(double frequency, double amplitude)
{
	double pi = 3.14159265;
	int colour = 0;
	VGA_clear_pixelbuff_ASM();
	double xValue = 0;
	int xValueTruncated;
	double yValue = 0;
	double screenSizeInXDimension = .01; //this should be the size of the screen in x (should be a bit over 1 period of wave with smallest frequency)
	double screenSizeInRads = screenSizeInXDimension*2*pi;
	double screenSizeInYDimension = 12; // total screen size = 20 (ten above 0 and ten below)thus each y value corresponds to 12 x values in pixel buffer
	int xOutput;
	double yOutput;
	int yOutputTruncated;

	int i;
	for(i =0; i < 320; i++)
	{
		xValue = i/320*screenSizeInRads;
		xValueTruncated = (int)xValue;
		yValue = sine[xValueTruncated];
		xOutput = i;
		yOutput = 120 + screenSizeInYDimension*yValue;
		yOutputTruncated = (int)yOutput;
		VGA_draw_point_ASM(xOutput, yOutputTruncated, colour++);
	} 
	i = 0;
}

//should get freqeuncy of the input key if one of the applicable keys is pressed. 1 key corresponds to volume up 2 to colume down
double getFrequency(char c)
{
	double frequency = 0;
	char data;
	int setPointer = 0;
	switch(c) {
		case 0x1C:
			frequency =  130.813;
			break;
		case 0x1B:
			frequency = 146.832;
			break;
		case 0x23:
			frequency = 164.814;
			break;
		case 0x2B:
			frequency = 174.614;
			break;
		case 0x3B:
			frequency = 195.998;
			break;
		case 0x42:
			frequency = 220.000;
			break;
		case 0x4B:
			frequency = 246.942;
			break;
		case 0x4C:
			frequency = 261.626;
			break;
		case 0x16:
			frequency = 1;
			break;
		case 0x1E:
			frequency = -1;
			break;
	}
	return frequency;
}

int main() {
	
	int time = 0;				//current time
	double frequency = 0;			//frequency of wave
	
	double amplitude = 5;			//amplitude of wave (volume control)
	double sampleAtT = 0;			//current wave value
	int audioSuboutineResult= 0;		//whether the write audio was successful
	int inputAudioVal;			//int value of sample at t
	int keyBeingPressed;			//check for whether key is pressed
	char data;				//pointer to keyboard

	HPS_TIM_config_t timer;			//timer config
	timer.tim = TIM0;
	timer.timeout = 21;
	timer.LD_en = 1;
	timer.INT_en = 1;
	timer.enable = 1;
	
	VGA_clear_pixelbuff_ASM();
	double yValues[320] = { 0 };
	double yValueAtT = 0;
	HPS_TIM_config_ASM(&timer);
	
	while(1) 
	{
		//	MAKE PROJECT!

//should check to see if key is pressed, if so should get the key that was pressed and set the frequency to the corresponding frequency of the key using get frequency
//should check for volume changes and perform those if applicable and if the key is corresponding to one of the waves then should output and display that wave for a full second
		keyBeingPressed = read_ps2_data_ASM(&data);
		frequency = getFrequency(data);
		if(keyBeingPressed == 1)
		{
			if(frequency == 1)
			{
				amplitude = amplitude++;
				continue;
			}
			else if(frequency == -1)
			{
				if(amplitude > 0)
				{
					amplitude = amplitude--;
				}
				continue;
			}
			else if(frequency == 0)
			{
				continue;
			}
			else
			{
//output wave for a full second using the write audio routine
//should also display the audio by using a memory state where the old point is rememberred and the new point is then calculated and drawn to the screen as shown
//should occur once every five runs through to make it more visually pleasing
				while(time < 48000)
				{
	
					sampleAtT = getSignalAtT(time, frequency, amplitude);
					inputAudioVal = (int)sampleAtT;
					audioSuboutineResult = audio_write_data_ASM(inputAudioVal, inputAudioVal);

					int xValueAtT = 0;
					int timeSplice = time%5;
					
					if((timeSplice == 0))
					{
						xValueAtT = (time/5)%320;
						yValueAtT = 120 + sampleAtT/500000;

						VGA_draw_point_ASM(xValueAtT, yValues[xValueAtT], 0);
						

						yValues[xValueAtT] = yValueAtT;

						VGA_draw_point_ASM((xValueAtT, yValueAtT, 120);		
					}
					if(audioSuboutineResult == 1)
					{
						time++;
					}
				}
				time = 0;
			}
		}
		
	}

	return 0;
}

//below is the implementation that was attempted that would be able to use timers and play two notes at once. It was never successful but was included to show
//the thought process of the attempts made which are referenced in the report.
//modulous, getSignalAtT, displayWave all have the same implementation as above

/*#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include <stdio.h>
#include <math.h>

double keyValues[] = {0,0,0,0,0,0,0,0};
int breakCodeFound = 0;


double modulous (double numerator, int modValue)
{
	double division = numerator / modValue;
	int truncateDivision = (int)division;
	double multiply = truncateDivision*modValue; 
	double modEnd = numerator - multiply;
	return modEnd;
}

double getSignalAtT (double time, double frequency, double amplitude)
{
	double fByT = (frequency * time);
	double index = modulous(fByT, 48000);
	double signalAtT;
		
	int indexBase = (int)index;
	double indexDecimal = index - (double)indexBase;
	double fullTable[] = {0,0,0};
	if(indexDecimal == 0)
	{
		fullTable[0] = index;
		fullTable[1] = 1;
		fullTable[2] = 0;
		signalAtT = amplitude*(sine[indexBase]*fullTable[1]);
	}
	else
	{
		fullTable[0] = indexBase;
		fullTable[1] = 1 - indexDecimal;
		fullTable[2] = indexDecimal;
		signalAtT = amplitude*(sine[indexBase]*fullTable[1] + sine[indexBase+1]*fullTable[2]);
	}
	return signalAtT;
}

void displayWave(double frequency, double amplitude)
{
	double pi = 3.14159265;
	int colour = 0;
	VGA_clear_pixelbuff_ASM();
	int i = 0;
	double xValue = 0;
	int xValueTruncated;
	double yValue = 0;
	double screenSizeInXDimension = .01; //this should be the size of the screen in x (should be a bit over 1 period of wave with smallest frequency)
	double screenSizeInRads = screenSizeInXDimension*2*pi;
	double screenSizeInYDimension = 12; // total screen size = 20 (ten above 0 and ten below)thus each y value corresponds to 12 x values in pixel buffer
	int xOutput;
	double yOutput;
	int yOutputTruncated;
	while(i < 320)
	{
		xValue = i/320*screenSizeInRads;
		xValueTruncated = (int)xValue;
		yValue = sine[xValueTruncated];
		xOutput = i;
		yOutput = 120 + screenSizeInYDimension*yValue;
		yOutputTruncated = (int)yOutput;
		VGA_draw_point_ASM(xOutput, yOutputTruncated, colour++);
		i++;
	} 
	i = 0;
}


int main() {
	
	double time = 0;				//time value begins at 0
	double frequency = 0;			//frequency begins at 0

	double newFrequency;	
		
	double amplitude = 5;			//starting amp is five giving freedom to increase/decrease

	double sampleAtT = 0;			//sample value to be put into audio

	int audioSuboutineResult= 0;	//check whether audio has been written to

	int inputAudioVal;				//truncation of sample value as int

	int keyBeingPressed;			//whether a key is being pressed

	int breakCodeFound = 0;			//whether last returned hex was break code

	double totalSampleAtT = 0;

	char data;						//pointer to ps2

	int_setup(1, (int []){199});
	HPS_TIM_config_t timer;			//timer configuration
	timer.tim = TIM0;
	timer.timeout = 20;
	timer.LD_en = 1;
	timer.INT_en = 1;
	timer.enable = 1;

	HPS_TIM_config_ASM(&timer);
	
	while(1) 
	{
//switch statement which should find the correct key input if applicable and then check if the former the break code found key was 1 (corresponding to a break
//code in the last read data state) and if so setting that key value to 0. If not, the code should set key value to be equal to the value of that key's corresponding
//frequency. If a break code is sent then break code found should be set to 1 meaning the next key will be set to zero as that key has been let off. For volume, a 1
//corresponded to an increase and 2 to decrease.


		//	MAKE PROJECT!
		keyBeingPressed = read_ps2_data_ASM(&data);
		if(keyBeingPressed != 0)
		{
			switch(data) {
			case 0xF0:
				breakCodeFound = 1;
				break;
			case 0x1C:
				if(breakCodeFound == 0)
				{
					keyValues[0] =  130.813;
				}
				else
				{
					keyValues[0] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x1B:
				if(breakCodeFound == 0)
				{
					keyValues[1] =  146.832;
				}
				else
				{
					keyValues[1] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x23:
				if(breakCodeFound == 0)
				{
					keyValues[2] =  164.814;
				}
				else
				{
					keyValues[2] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x2B:
				if(breakCodeFound == 0)
				{
					keyValues[3] = 174.614;
				}
				else
				{
					keyValues[3] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x3B:
				if(breakCodeFound == 0)
				{
					keyValues[4] =  195.998;
				}
				else
				{
					keyValues[4] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x42:
				if(breakCodeFound == 0)
				{
					keyValues[5] =  220.000;
				}
				else
				{
					keyValues[5] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x4B:
				if(breakCodeFound == 0)
				{
					keyValues[6] =  246.942;
				}
				else
				{
					keyValues[6] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x4C:
				if(breakCodeFound == 0)
				{
					keyValues[7] =  261.626;
				}
				else
				{
					keyValues[7] = 0;
					breakCodeFound = 0;
				}
				break;
			case 0x16:
				if(breakCodeFound == 1)
				{
					amplitude++;
				}
				break;
			case 0x1E:
				if(breakCodeFound == 1)
				{
					if(amplitude > 0)
					{
						amplitude--;
					}
				}
				break;
			default:
				breakCodeFound = 0;
		
		}
	}	
//should get the total signal by calling each key value to get signal method. If key values at that index is zero nothing will be added as frequency is 0

		int i;
		for(i = 0; i < 8; i++)
		{
			sampleAtT = getSignalAtT(time, keyValues[i], amplitude);
			totalSampleAtT += sampleAtT;
		}

		
		inputAudioVal = (int)totalSampleAtT;

// timer implementation should run through and write to audio every 20 micro seconds
		if(timer_integer_flag == 1)
		{
			timer_integer_flag = 0;
			audio_write_data_ASM(inputAudioVal, inputAudioVal);
			time++;
		}

		//should reset total sample each time and timer every 1 second

		totalSampleAtT = 0;
		if(time == 48000)
		{
			time = 0;
		}
		
		
	}

	return 0;
}
*/
