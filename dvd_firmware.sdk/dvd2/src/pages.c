#include "pages.h"

int home_page(lv_obj_t * parent){
//	ScPlot plot = scplot_create(parent, NULL);
//	plot.range.ver_lower = -1;
//	plot.range.ver_upper = 3;
//	plot.range.hor_lower = -1;
//	plot.range.hor_upper = 3;
	viral_load = lv_label_create(parent, NULL);
	lv_obj_align(viral_load, NULL, LV_ALIGN_OUT_TOP_RIGHT, -60, 40);  /*Align to the top*/


	static lv_style_t style;
	lv_style_copy(&style, &lv_style_pretty);
	style.body.shadow.width = 6;
	style.body.shadow.color = LV_COLOR_GRAY;
	style.line.color = LV_COLOR_GRAY;

	chart = lv_chart_create(lv_scr_act(), NULL);
	lv_obj_set_size(chart, 600, 480);
	lv_obj_set_style(chart, &style);
	lv_obj_align(chart, NULL, LV_ALIGN_IN_TOP_LEFT, 0, 0);
	lv_chart_set_type(chart, LV_CHART_TYPE_POINT | LV_CHART_TYPE_LINE);   /*Show lines and points too*/
	lv_chart_set_series_opa(chart, LV_OPA_70);                            /*Opacity of the data series*/
	lv_chart_set_series_width(chart, 4);                                  /*Line width and point radious*/
	lv_chart_set_div_line_count(chart, 0,0);
	lv_chart_set_range(chart, -500, 1000);
	lv_chart_set_point_count(chart, 150);
	add_data(chart, viral_load);

}
