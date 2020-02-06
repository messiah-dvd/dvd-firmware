/*
 * scientific_plot.c
 *
 *  Created on: Mar 26, 2019
 *      Author: Nathan CZH
 */

#include "scientific_plot.h"

ScPlot scplot_create(lv_obj_t * par, const lv_obj_t * copy) {

	ScPlot scplot;
	xil_printf("Hi\n");
	scplot.container_obj = lv_cont_create(par, NULL);
	scplot.chart_obj = lv_chart_create(scplot.container_obj, NULL);
	scplot.ver_axis_obj = lv_cont_create(scplot.container_obj, NULL);
	scplot.hor_axis_obj = lv_cont_create(scplot.container_obj, NULL);
	scplot.hor_tick_freq = .5;
	scplot.ver_tick_freq = .5;
	scplot_set_size(scplot, 800, 480);
	lv_chart_set_type(scplot.chart_obj, LV_CHART_TYPE_POINT | LV_CHART_TYPE_LINE);   /*Show lines and points too*/
	lv_chart_set_series_opa(scplot.chart_obj, LV_OPA_70);                            /*Opacity of the data series*/
	lv_chart_set_series_width(scplot.chart_obj, 4);                                  /*Line width and point radious*/
	lv_chart_set_div_line_count(scplot.chart_obj, 0,0);
	lv_chart_set_range(scplot.chart_obj, 0, scplot.height);
	lv_chart_set_point_count(scplot.chart_obj, 150);
	add_data(scplot.chart_obj);

//	lv_obj_t * label = lv_label_create(scplot.ver_axis_obj, NULL);
//	lv_obj_align(label, NULL, LV_ALIGN_CENTER, 0,0);
//	lv_label_set_text(label, "Vertical");
//
//
//	lv_obj_t * label1 = lv_label_create(scplot.hor_axis_obj, NULL);
//	lv_obj_align(label1, NULL, LV_ALIGN_CENTER, 0,0);
//	lv_label_set_text(label1, "Horizontal");

	return scplot;
}

ScPlot scplot_set_size(ScPlot scplot, int width, int height){
	scplot.height = height;
	scplot.width = width;
	lv_obj_set_size(scplot.container_obj, scplot.width, scplot.height);
	lv_obj_set_size(scplot.chart_obj, scplot.width - AXIS_SIZE, scplot.height - AXIS_SIZE);
	lv_obj_set_size(scplot.ver_axis_obj, AXIS_SIZE, scplot.height - AXIS_SIZE);
	lv_obj_set_size(scplot.hor_axis_obj, scplot.width - AXIS_SIZE, AXIS_SIZE);

	lv_obj_align(scplot.container_obj, scplot.container_obj, LV_ALIGN_IN_TOP_LEFT, 0, 0);
	lv_obj_align(scplot.chart_obj, scplot.container_obj, LV_ALIGN_IN_TOP_LEFT, AXIS_SIZE, 0);
	xil_printf("%d\n", scplot.height);// - AXIS_SIZE);
	lv_obj_align(scplot.hor_axis_obj, scplot.container_obj, LV_ALIGN_IN_TOP_LEFT, AXIS_SIZE, scplot.height - AXIS_SIZE);
	lv_obj_align(scplot.ver_axis_obj, scplot.container_obj, LV_ALIGN_IN_TOP_LEFT, 0, 0);

	return scplot;
}

ScPlot scplot_draw_ticks(ScPlot scplot){
	if ( scplot.range.ver_upper > 0 ){

	}
	int ver_tick_number = scplot.range.ver_upper - scplot.range.ver_lower;



	return scplot;
}
