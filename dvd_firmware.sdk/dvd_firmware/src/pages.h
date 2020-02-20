#ifndef SRC_PAGES_H_
#define SRC_PAGES_H_

#include "lvgl/lvgl.h"
#include "bloodtest_data.h"
#include "scientific_plot.h"

lv_obj_t * chart;
lv_obj_t * viral_load;

/*Create a chart*/
int home_page(lv_obj_t * parent);

#endif /* SRC_PAGES_H_ */
