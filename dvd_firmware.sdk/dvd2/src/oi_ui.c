#include "oi_ui.h"

void draw_buttons(lv_obj_t * parent){
	lv_obj_t * label;
	lv_obj_t * btn1 = lv_btn_create(parent, NULL);
	lv_obj_set_size(btn1, 150, 75);
	lv_obj_align(btn1, parent, LV_ALIGN_IN_BOTTOM_LEFT, 25, -25);
	lv_obj_set_free_num(btn1, 1);   /*Set a unique number for the button*/
	lv_btn_set_action(btn1, LV_BTN_ACTION_CLICK, on_btn_click);

	label = lv_label_create(btn1, NULL);
	lv_label_set_text(label, "1st Button");

	lv_obj_t * btn2 = lv_btn_create(parent, NULL);
	lv_obj_set_size(btn2, 150, 75);
	lv_obj_align(btn2, parent, LV_ALIGN_IN_BOTTOM_LEFT, 225, -25);
	lv_obj_set_free_num(btn2, 2);   /*Set a unique number for the button*/
	lv_btn_set_action(btn2, LV_BTN_ACTION_CLICK, on_btn_click);

	label = lv_label_create(btn2, NULL);
	lv_label_set_text(label, "2nd Button");

	lv_obj_t * btn3 = lv_btn_create(parent, NULL);
	lv_obj_set_size(btn3, 150, 75);
	lv_obj_align(btn3, parent, LV_ALIGN_IN_BOTTOM_LEFT, 425, -25);
	lv_obj_set_free_num(btn3, 3);   /*Set a unique number for the button*/
	lv_btn_set_action(btn3, LV_BTN_ACTION_CLICK, on_btn_click);

	label = lv_label_create(btn3, NULL);
	lv_label_set_text(label, "3rd Button");

	lv_obj_t * btn4 = lv_btn_create(parent, NULL);
	lv_obj_set_size(btn4, 150, 75);
	lv_obj_align(btn4, parent, LV_ALIGN_IN_BOTTOM_LEFT, 625, -25);
	lv_obj_set_free_num(btn4, 4);   /*Set a unique number for the button*/
	lv_btn_set_action(btn4, LV_BTN_ACTION_CLICK, on_btn_click);

	label = lv_label_create(btn4, NULL);
	lv_label_set_text(label, "4th Button");

}

static lv_res_t on_btn_click(lv_obj_t * btn)
{
    uint8_t id = lv_obj_get_free_num(btn);
    printf("Button %d pressed\n", id);

    /* The button is released.
     * Make something here */

    return LV_RES_OK; /*Return OK if the button is not deleted*/
}
