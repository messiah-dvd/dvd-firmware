/*
 * scientific_plot.h
 *
 *  Created on: Mar 26, 2019
 *      Author: Nathan CZH
 */

#ifndef SRC_SCIENTIFIC_PLOT_H_
#define SRC_SCIENTIFIC_PLOT_H_

#define AXIS_SIZE 50

#include "lvgl/lvgl.h"
#include "bloodtest_data.h"

typedef struct {
	double ver_upper;
	double ver_lower;
	double hor_upper;
	double hor_lower;
} ScPlotRange;

typedef struct {
	lv_obj_t * container_obj;
	lv_obj_t * chart_obj;
	lv_obj_t * ver_axis_obj;
	lv_obj_t * hor_axis_obj;
	ScPlotRange range;
	int height;
	int width;
	double ver_tick_freq;
	double hor_tick_freq;
} ScPlot;

ScPlot scplot_create(lv_obj_t * par, const lv_obj_t * copy);
ScPlot scplot_set_size(ScPlot scplot, int height, int width);

#endif /* SRC_SCIENTIFIC_PLOT_H_ */
