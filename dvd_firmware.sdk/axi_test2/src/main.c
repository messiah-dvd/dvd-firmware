/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW designw
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "xil_io.h"

#define ACF_CORE_BASE_ADDR XPAR_ACF_AXI_MINI_0_BASEADDR

int init_acf_core() {
	print("\r\nConfiguring ACF core...");
	print("maxCount...");
	Xil_Out32(ACF_CORE_BASE_ADDR, 100); // maxCount = 100
	print("CE...");
	Xil_Out32(ACF_CORE_BASE_ADDR+4, 1); // CE = 1
	print("initTx...");
	sleep(3);
	Xil_Out32(ACF_CORE_BASE_ADDR+8, 1); // initTx = 1
	sleep(3);
	Xil_Out32(ACF_CORE_BASE_ADDR+8, 0); // initTx = 0
	print("done.\r\n");
	return 0;
}

int main()
{
    init_platform();
    init_acf_core();

    print("reading values:\r\n");

    int acf_data[240];
    uint32_t photon_cnt = Xil_In32(ACF_CORE_BASE_ADDR);
    printf("photon count: %u\r\n", photon_cnt);
    printf("ACF array: \r\n");
    for (int i=1; i<60; i++) {
    	acf_data[i-1] = Xil_In32(ACF_CORE_BASE_ADDR+i*4);
    	printf("\t%u", acf_data[i]);
    }

    print("finished\r\n");

    cleanup_platform();
    return 0;
}
