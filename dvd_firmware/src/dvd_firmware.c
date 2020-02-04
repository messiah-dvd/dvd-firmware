#include "dvd_firmware.h"
#include <stdio.h>
#include "xil_printf.h"

int main() {
//    init_platform();
//    init_interrupts();
	print("Hello World1\n\r");
	init_screen();
	print("Hello World\n\r");
	home_page(lv_scr_act());

//	draw_buttons(lv_scr_act());
	unsigned int c = 0;
	while (1) {
		lv_tick_inc(1);
		TimerDelay(1000);
		if (c % 5) {
			lv_task_handler();
		}
		c++;
	}
	return 0;
}


void timer_h(void* CallBackRef) {
	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer ClearInterruptStatus( TimerInstancePtr);

}
