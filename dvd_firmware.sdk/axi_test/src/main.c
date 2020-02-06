#include "xparameters.h"
#include "xil_io.h"

#define ACF_CORE_BASE_ADDR XPAR_AUTOCORRELATIONFUNCT_0_BASEADDR
int init_acf_core();
int main() {
//    init_platform();
//    init_interrupts();
	print("Hello World1\n\r");
//	init_screen();
	print("Hello World\n\r");
//	home_page(lv_scr_act());
	init_acf_core();
	print("reading values:\r\n");

	int acf_data[64];
	for (int i=0; i<64; i++) {
		acf_data[i] = Xil_In32(ACF_CORE_BASE_ADDR+i*4);
		printf("\t%i", acf_data[i]);
	}
}

int init_acf_core() {
	print("Configuring ACF core...");
	print("maxCount...");

	Xil_Out32(ACF_CORE_BASE_ADDR, 1000); // maxCount = 1000
	print("CE...");
	Xil_Out32(ACF_CORE_BASE_ADDR + 4, 1); // CE = 1
	print("initTx...");
	Xil_Out32(ACF_CORE_BASE_ADDR + 8, 1); // initTx = 1
	Xil_Out32(ACF_CORE_BASE_ADDR + 8, 0); // initTx = 0
	print("done.\r\n");
	return 0;
}
