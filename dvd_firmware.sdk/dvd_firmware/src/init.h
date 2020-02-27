#ifndef SRC_INIT_H_
#define SRC_INIT_H_

#include <stdlib.h>

#include "xscugic.h"
#include <xgpio.h>

#include "xparameters.h"
#include "xil_io.h"

#define ACF_CORE_BASE_ADDR XPAR_AUTOCORRELATIONFUNCT_0_BASEADDR


void init_screen();
void init_hardware();
void init_graphics();
void disp_flush();

bool button_read();


XScuGic ScuGicInst;
XGpio btn_input;


#define DEMO_PATTERN_0 0
#define DEMO_PATTERN_1 1

#define DEMO_MAX_FRAME (1920*1080*3)
#define DEMO_STRIDE (1920 * 3)


int init_acf_core();

#endif /* SRC_INIT_H_ */
