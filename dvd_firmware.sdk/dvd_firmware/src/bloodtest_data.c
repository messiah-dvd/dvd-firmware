#include "bloodtest_data.h"

void add_data(lv_obj_t * autocorrelation_chart, lv_obj_t * viral_load_label){
	printf("Waiting... \n");
	sleep(2);
	printf("Done! \n");
	Xil_Out32(ACF_CORE_BASE_ADDR+8, 1);
	Xil_Out32(ACF_CORE_BASE_ADDR+8, 0);

	/*Add two data series*/
	lv_chart_series_t * ser2 = lv_chart_add_series(autocorrelation_chart, LV_COLOR_GREEN);
	int points[64];
	int i;
//	for (i = 0; i < 192; i++) {
//
//		ser2->points[i] = points[i] / 1e7;
//	}


	print("reading values:\r\n");
//    int acf_data[240];
    uint32_t photon_cnt = Xil_In32(ACF_CORE_BASE_ADDR);
    printf("photon count: %u\r\n", photon_cnt);
    printf("ACF array: \r\n");
    for (int i=1; i<60; i++) {
    	ser2->points[i-1] = Xil_In32(ACF_CORE_BASE_ADDR+i*4);
    	printf("\t[%X,%X]", ser2->points[i-1], i);
    }
    printf("\n");
	lv_label_set_text(viral_load_label, "Viral Load: \n 5000 / ml");
	lv_chart_refresh(autocorrelation_chart);
	lv_chart_set_series_opa(autocorrelation_chart, LV_OPA_100);
}

void reset(lv_obj_t * autocorrelation_chart, lv_obj_t * viral_load_label) {
	lv_label_set_text(viral_load_label, "");
	lv_chart_set_series_opa(autocorrelation_chart, LV_OPA_0);
}
