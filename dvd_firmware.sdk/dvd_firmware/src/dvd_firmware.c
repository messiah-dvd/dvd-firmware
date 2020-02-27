#include "dvd_firmware.h"
#include <stdio.h>
#include "xil_printf.h"
#include <stdlib.h>

int main() {
//    init_platform();
//    init_interrupts();
	init_sdcard();
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

#define MINREQ      0xFFF
void test_mem(){
    unsigned int required = (unsigned int)-1; // adapt to native uint
    char *mem = NULL;
    while (mem == NULL) {
        printf ("Required %X\n", required);
        mem = malloc (required);
        if ((required >>= 1) < MINREQ) {
            if (mem) free (mem);
            printf ("Cannot allocate enough memory\n");
            return (1);
        }
    }

    free (mem);
    mem = malloc (required);
    if (mem == NULL) {
        printf ("Cannot enough allocate memory\n");
        return (1);
    }
    printf ("Memory size allocated = %X\n", required);
    free (mem);
}


void timer_h(void* CallBackRef) {
	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer ClearInterruptStatus( TimerInstancePtr);

}
