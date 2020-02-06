
#include "xil_types.h"
#include "xscutimer.h"
#include "Xscugic.h"
#include <xparameters.h>

#include "display_ctrl/display_ctrl.h"
#include "lv_conf.h"
/*
 * Display configuration
 */
#define SCREEN_WIDTH LV_HOR_RES
#define SCREEN_HEIGHT LV_VER_RES
#define SCREEN_FRAME_SIZE (SCREEN_WIDTH * SCREEN_HEIGHT * 4)
#define SCREEN_STRIDE SCREEN_WIDTH * 4

/*
 * XPAR redefines
 */
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#define VGA_VDMA_ID XPAR_AXIVDMA_0_DEVICE_ID
#define DISP_VTC_ID XPAR_V_TC_OUT_DEVICE_ID
#define VID_VTC_IRPT_ID XPS_FPGA3_INT_ID
#define VID_GPIO_IRPT_ID XPS_FPGA4_INT_ID
#define SCU_TIMER_ID XPAR_SCUTIMER_DEVICE_ID
#define UART_BASEADDR XPAR_PS7_UART_1_BASEADDR
#define ACF_CORE_BASE_ADDR XPAR_ACF_AXI_MINI_0_BASEADDR

/*
 * Display Driver variables
 */
DisplayCtrl dispCtrl;
XAxiVdma vdma;
u8  frameBuf[DISPLAY_NUM_FRAMES][SCREEN_FRAME_SIZE] __attribute__((aligned(0x20)));
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers

#include "lvgl/lvgl.h"


#include "init.h"
#include "timer_ps/timer_ps.h"
#include "xparameters.h"
#include "pages.h"
#include "oi_ui.h"


int main();
static lv_res_t btn_click_action(lv_obj_t * btn);
