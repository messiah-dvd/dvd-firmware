
#include "dvd_firmware.h"


void init_screen()
{
	print("Init hardware\n");
	init_hardware();
	print("Init graphics\n");
	init_graphics();

	return;
}

void init_hardware(){
	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;

	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}

	/*
	 * Initialize a timer used for a simple delay
	 */
	TimerInitialize(SCU_TIMER_ID);
	/*
	 * Initialize VDMA driver
	 */
	vdmaConfig = XAxiVdma_LookupConfig(VGA_VDMA_ID);
	if (!vdmaConfig)
	{
		xil_printf("No video DMA found for ID %d\r\n", VGA_VDMA_ID);
		return;
	}
	Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);
		return;
	}

	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, &vdma, DISP_VTC_ID, DYNCLK_BASEADDR, pFrames, SCREEN_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);
		return;
	}
	DisplaySetMode(&dispCtrl, &VMODE_800x600);

	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);
		return;
	}

	xil_printf("DisplayCtrl Init\n");
	init_btns();


	init_acf_core();
}


int init_acf_core() {
	print("\r\nConfiguring ACF core...");
	print("maxCount...");
	Xil_Out32(ACF_CORE_BASE_ADDR, 100); // maxCount = 100
	print("CE...");
	Xil_Out32(ACF_CORE_BASE_ADDR+4, 1); // CE = 1
	print("initTx...");
	print("done.\r\n");
}

bool button_read(lv_indev_data_t*data){
    static uint32_t last_btn = 0;   /*Store the last pressed button*/
    int btn_pr = XGpio_DiscreteRead(&btn_input, 1);     /*Get the ID (0,1,2...) of the pressed button*/


    if(btn_pr == 0b0001) {
    	xil_printf("Button 1 pressed\n");
		last_btn = 1;
	} else if(btn_pr == 0b0010) {
		last_btn = 2;
	} else if (btn_pr == 0b0100) {
		last_btn = 3;
	} else if (btn_pr == 0b1000) {
		last_btn = 4;
	}
    if(btn_pr > 0) {               /*Is there a button press?*/
    	data->state = LV_INDEV_STATE_PR;  /*Set the pressed state*/
    } else {
       data->state = LV_INDEV_STATE_REL; /*Set the released state*/
    }

    data->btn = last_btn;

    return false;                    /*No buffering so no more data read*/
}

lv_point_t points_array[] = {{10,10},{700, 440}, {500, 440}, {300, 440}, {100, 440}};
void init_graphics(){
	lv_init();
	lv_disp_drv_t disp_drv;
	lv_disp_drv_init(&disp_drv);     /*Basic initialization*/
	disp_drv.disp_flush = disp_flush;
	lv_disp_drv_register(&disp_drv);
	xil_printf("Driver Init\n");

	lv_indev_drv_t indev_drv;
	lv_indev_drv_init(&indev_drv);  /*Basic initialization*/
	indev_drv.type = LV_INDEV_TYPE_BUTTON;
	indev_drv.read = button_read;
	lv_indev_set_button_points(lv_indev_drv_register(&indev_drv), points_array);

}

void disp_flush(int32_t x1, int32_t y1, int32_t x2, int32_t y2, const lv_color_t* color_p) {
	u8 *frame = pFrames[dispCtrl.curFrame];
	u32 row_offset = y1 * dispCtrl.stride;
	u32 x,y;
	u32 pixel_addr;
	for (y = y1; y <= y2; y++){
		pixel_addr = row_offset + x1 * 4;
		for (x = x1; x <= x2; x++) {
			frame[pixel_addr] = (*color_p).red;
			frame[pixel_addr + 1] = (*color_p).green;
			frame[pixel_addr + 2] = (*color_p).blue;
			color_p++;
			pixel_addr += 3;
		}
		row_offset += dispCtrl.stride;
	}
	Xil_DCacheFlushRange((unsigned int) pFrames[dispCtrl.curFrame], SCREEN_FRAME_SIZE);
	lv_flush_ready();
}

void init_btns(){
	XGpio_Initialize(&btn_input, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&btn_input, 1, 0xF);
}


void init_interrupts(){
	XScuGic_Config *IntcConfig;
	Xil_ExceptionInit();
	IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
	XScuGic_CfgInitialize(&ScuGicInst, IntcConfig, IntcConfig->CpuBaseAddress);
		    //connect to the hardware
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
						(Xil_ExceptionHandler)XScuGic_InterruptHandler,
						&ScuGicInst);
	XScuGic_Enable(&ScuGicInst, XPAR_SCUTIMER_INTR);
	// Enable interrupts in the Processor.
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
}
