onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xilinx_vip -L xpm -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xil_defaultlib -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L axi_lite_ipif_v3_0_4 -L v_tc_v6_1_13 -L v_vid_in_axi4s_v4_0_9 -L v_axi4s_vid_out_v4_0_10 -L xlconcat_v2_1_3 -L v_tc_v6_2_0 -L lib_pkg_v1_0_2 -L fifo_generator_v13_2_5 -L lib_fifo_v1_0_14 -L blk_mem_gen_v8_4_4 -L lib_bmg_v1_0_13 -L lib_srl_fifo_v1_0_2 -L axi_datamover_v5_1_22 -L axi_vdma_v6_3_8 -L axis_infrastructure_v1_1_0 -L axis_register_slice_v1_1_20 -L axis_subset_converter_v1_1_20 -L xlconstant_v1_1_6 -L interrupt_control_v3_1_4 -L axi_gpio_v2_0_22 -L generic_baseblocks_v2_1_0 -L axi_register_slice_v2_1_20 -L axi_data_fifo_v2_1_19 -L axi_crossbar_v2_1_21 -L xbip_utils_v3_0_10 -L c_reg_fd_v12_0_6 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_6 -L xbip_dsp48_addsub_v3_0_6 -L xbip_addsub_v3_0_6 -L c_addsub_v12_0_14 -L c_gate_bit_v12_0_6 -L xbip_counter_v3_0_6 -L c_counter_binary_v12_0_14 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L xbip_dsp48_multadd_v3_0_6 -L xbip_multadd_v3_0_15 -L axi_protocol_converter_v2_1_20 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.system xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {system.udo}

run -all

quit -force
