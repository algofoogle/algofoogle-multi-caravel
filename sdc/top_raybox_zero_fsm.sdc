###############################################################################
# Created by write_sdc
# Sun Dec 10 07:17:53 2023
###############################################################################
current_design top_raybox_zero_fsm
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 39.0000 [get_ports {i_clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout0_sel[0]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout0_sel[0]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout0_sel[1]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout0_sel[1]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout0_sel[2]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout0_sel[2]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout0_sel[3]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout0_sel[3]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout1_sel[0]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout1_sel[0]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout1_sel[1]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout1_sel[1]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout1_sel[2]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout1_sel[2]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout1_sel[3]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout1_sel[3]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout2_sel[0]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout2_sel[0]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout2_sel[1]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout2_sel[1]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout2_sel[2]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout2_sel[2]}]
set_input_delay 0.1800 -clock [get_clocks {clk}] -min -add_delay [get_ports {i_gpout2_sel[3]}]
set_input_delay 1.8700 -clock [get_clocks {clk}] -max -add_delay [get_ports {i_gpout2_sel[3]}]
set_input_delay 21.5000 -clock [get_clocks {clk}] -add_delay [get_ports {i_reset}]
set_multicycle_path -hold\
    -through [list [get_ports {i_gpout0_sel[0]}]\
           [get_ports {i_gpout0_sel[1]}]\
           [get_ports {i_gpout0_sel[2]}]\
           [get_ports {i_gpout0_sel[3]}]\
           [get_ports {i_gpout1_sel[0]}]\
           [get_ports {i_gpout1_sel[1]}]\
           [get_ports {i_gpout1_sel[2]}]\
           [get_ports {i_gpout1_sel[3]}]\
           [get_ports {i_gpout2_sel[0]}]\
           [get_ports {i_gpout2_sel[1]}]\
           [get_ports {i_gpout2_sel[2]}]\
           [get_ports {i_gpout2_sel[3]}]] 1
set_multicycle_path -setup\
    -through [list [get_ports {i_gpout0_sel[0]}]\
           [get_ports {i_gpout0_sel[1]}]\
           [get_ports {i_gpout0_sel[2]}]\
           [get_ports {i_gpout0_sel[3]}]\
           [get_ports {i_gpout1_sel[0]}]\
           [get_ports {i_gpout1_sel[1]}]\
           [get_ports {i_gpout1_sel[2]}]\
           [get_ports {i_gpout1_sel[3]}]\
           [get_ports {i_gpout2_sel[0]}]\
           [get_ports {i_gpout2_sel[1]}]\
           [get_ports {i_gpout2_sel[2]}]\
           [get_ports {i_gpout2_sel[3]}]] 2
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {o_hsync}]
set_load -pin_load 0.1900 [get_ports {o_tex_csb}]
set_load -pin_load 0.1900 [get_ports {o_tex_oeb0}]
set_load -pin_load 0.1900 [get_ports {o_tex_out0}]
set_load -pin_load 0.1900 [get_ports {o_tex_sclk}]
set_load -pin_load 0.1900 [get_ports {o_vsync}]
set_load -pin_load 0.1900 [get_ports {o_gpout[2]}]
set_load -pin_load 0.1900 [get_ports {o_gpout[1]}]
set_load -pin_load 0.1900 [get_ports {o_gpout[0]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[5]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[4]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[3]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[2]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[1]}]
set_load -pin_load 0.1900 [get_ports {o_rgb[0]}]
set_input_transition 0.6100 [get_ports {i_clk}]
set_input_transition -min 0.0500 [get_ports {i_debug_map_overlay}]
set_input_transition -max 0.3800 [get_ports {i_debug_map_overlay}]
set_input_transition -min 0.0500 [get_ports {i_debug_trace_overlay}]
set_input_transition -max 0.3800 [get_ports {i_debug_trace_overlay}]
set_input_transition -min 0.0500 [get_ports {i_debug_vec_overlay}]
set_input_transition -max 0.3800 [get_ports {i_debug_vec_overlay}]
set_input_transition -min 0.0500 [get_ports {i_reg_csb}]
set_input_transition -max 0.3800 [get_ports {i_reg_csb}]
set_input_transition -min 0.0500 [get_ports {i_reg_mosi}]
set_input_transition -max 0.3800 [get_ports {i_reg_mosi}]
set_input_transition -min 0.0500 [get_ports {i_reg_outs_enb}]
set_input_transition -max 0.3800 [get_ports {i_reg_outs_enb}]
set_input_transition -min 0.0500 [get_ports {i_reg_sclk}]
set_input_transition -max 0.3800 [get_ports {i_reg_sclk}]
set_input_transition -min 0.0500 [get_ports {i_vec_csb}]
set_input_transition -max 0.3800 [get_ports {i_vec_csb}]
set_input_transition -min 0.0500 [get_ports {i_vec_mosi}]
set_input_transition -max 0.3800 [get_ports {i_vec_mosi}]
set_input_transition -min 0.0500 [get_ports {i_vec_sclk}]
set_input_transition -max 0.3800 [get_ports {i_vec_sclk}]
set_input_transition -min 0.0700 [get_ports {i_gpout0_sel[3]}]
set_input_transition -max 0.8600 [get_ports {i_gpout0_sel[3]}]
set_input_transition -min 0.0700 [get_ports {i_gpout0_sel[2]}]
set_input_transition -max 0.8600 [get_ports {i_gpout0_sel[2]}]
set_input_transition -min 0.0700 [get_ports {i_gpout0_sel[1]}]
set_input_transition -max 0.8600 [get_ports {i_gpout0_sel[1]}]
set_input_transition -min 0.0700 [get_ports {i_gpout0_sel[0]}]
set_input_transition -max 0.8600 [get_ports {i_gpout0_sel[0]}]
set_input_transition -min 0.0700 [get_ports {i_gpout1_sel[3]}]
set_input_transition -max 0.8600 [get_ports {i_gpout1_sel[3]}]
set_input_transition -min 0.0700 [get_ports {i_gpout1_sel[2]}]
set_input_transition -max 0.8600 [get_ports {i_gpout1_sel[2]}]
set_input_transition -min 0.0700 [get_ports {i_gpout1_sel[1]}]
set_input_transition -max 0.8600 [get_ports {i_gpout1_sel[1]}]
set_input_transition -min 0.0700 [get_ports {i_gpout1_sel[0]}]
set_input_transition -max 0.8600 [get_ports {i_gpout1_sel[0]}]
set_input_transition -min 0.0700 [get_ports {i_gpout2_sel[3]}]
set_input_transition -max 0.8600 [get_ports {i_gpout2_sel[3]}]
set_input_transition -min 0.0700 [get_ports {i_gpout2_sel[2]}]
set_input_transition -max 0.8600 [get_ports {i_gpout2_sel[2]}]
set_input_transition -min 0.0700 [get_ports {i_gpout2_sel[1]}]
set_input_transition -max 0.8600 [get_ports {i_gpout2_sel[1]}]
set_input_transition -min 0.0700 [get_ports {i_gpout2_sel[0]}]
set_input_transition -max 0.8600 [get_ports {i_gpout2_sel[0]}]
set_input_transition -min 0.0500 [get_ports {i_mode[2]}]
set_input_transition -max 0.3800 [get_ports {i_mode[2]}]
set_input_transition -min 0.0500 [get_ports {i_mode[1]}]
set_input_transition -max 0.3800 [get_ports {i_mode[1]}]
set_input_transition -min 0.0500 [get_ports {i_mode[0]}]
set_input_transition -max 0.3800 [get_ports {i_mode[0]}]
set_input_transition -min 0.0500 [get_ports {i_tex_in[3]}]
set_input_transition -max 0.3800 [get_ports {i_tex_in[3]}]
set_input_transition -min 0.0500 [get_ports {i_tex_in[2]}]
set_input_transition -max 0.3800 [get_ports {i_tex_in[2]}]
set_input_transition -min 0.0500 [get_ports {i_tex_in[1]}]
set_input_transition -max 0.3800 [get_ports {i_tex_in[1]}]
set_input_transition -min 0.0500 [get_ports {i_tex_in[0]}]
set_input_transition -max 0.3800 [get_ports {i_tex_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 4.0000 [current_design]
