#include "dvd_firmware.h"
#include <stdio.h>
#include "xil_printf.h"
//#include <sys/sysinfo.h>

int main() {
//    init_platform();
//    init_interrupts();
	print("Hello World1\n\r");
	init_screen();
	print("Hello World\n\r");
	lv_obj_t * cont = lv_cont_create(lv_scr_act(), NULL);
	lv_obj_align(cont, lv_scr_act(), LV_ALIGN_OUT_TOP_LEFT, 0, 0);
	lv_obj_set_size(cont, LV_HOR_RES, LV_VER_RES - 75);
	draw_buttons(lv_scr_act());
	home_page(cont);

//	draw_buttons(lv_scr_act());
	unsigned int c = 0;
	while (1) {
		lv_tick_inc(1);
		TimerDelay(1000);
		if (c % 5) {
			lv_task_handler();
		}
		/*if (c % 5000){
			sysinfo();
		}*/
		c++;
	}
	return 0;
}


void timer_h(void* CallBackRef) {
	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer ClearInterruptStatus( TimerInstancePtr);

}
