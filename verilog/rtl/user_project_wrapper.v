// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * Instantiated in this UPW you will find:
 *  -   The mux (top_design_mux) that connects each of the designs
 *      with IO pads.
 *  -   Our main top design macros:
 *      -   top_raybox_zero_fsm
 *      -   top_raybox_zero_fsm (2nd instance)
 *      -   Pawel's macro (TBC)
 *      -   Diego's macro (TBC)
 *      -   Anton's 3rd, 4th, and 5th macros (TBC)
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vdd,      // User area 5.0V supply
    inout vss,      // User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

    //NOTE: LA pins [63:49] are used by the mux.
    //NOTE: LA pins [23:8] are muxed between some designs.
    wire [15:0] design_la_in = la_data_in[23:8]; // Can be remapped if desired.


/*----------------------------------------------*/
/* MUX for sharing IOs/LAs is instantiated here */
/*----------------------------------------------*/

    //// BEGIN: INSTANTIATION OF top_design_mux -------------------

    top_design_mux top_design_mux(
    `ifdef USE_POWER_PINS
        .vdd(vdd),        // User area 1 1.8V power
        .vss(vss),        // User area 1 digital ground
    `endif
        .wb_clk_i               (wb_clk_i),
        .wb_rst_i               (wb_rst_i),

        .io_in                  (io_in),
        .io_out                 (io_out),
        .io_oeb                 (io_oeb),
        .la_in                  (design_la_in),

        //NOTE: Mapping of LAs to mux control signals is described here:
        // https://github.com/algofoogle/journal/blob/master/0187-2023-12-09.md#summary-of-la-to-mux-control-mapping
        .i_mux_io5_reset_enb    (la_data_in[48]),
        .i_mux_sel              (la_data_in[52:49]),
        .i_mux_sys_reset_enb    (la_data_in[53]),
        .i_mux_auto_reset_enb   (la_data_in[54]),
        .i_design_reset         (la_data_in[62:55]),
        .mux_conf_clk           (la_data_in[63]),

        // top_raybox_zero_fsm:
        .trzf_clk               (trzf_clk),
        .trzf_rst               (trzf_rst),
        .trzf_ena               (trzf_ena),
        .trzf_la_in             (trzf_la_in),
        .trzf_o_hsync           (trzf_o_hsync),
        .trzf_o_vsync           (trzf_o_vsync),
        .trzf_o_rgb             (trzf_o_rgb),
        .trzf_o_tex_csb         (trzf_o_tex_csb),
        .trzf_o_tex_sclk        (trzf_o_tex_sclk),
        .trzf_o_tex_out0        (trzf_o_tex_out0),
        .trzf_o_tex_oeb0        (trzf_o_tex_oeb0),
        .trzf_o_gpout           (trzf_o_gpout),
        .trzf_io_in             (trzf_io_in), // The mux repeats/buffers these from the IO inputs into our design.

        // SECOND top_raybox_zero_fsm:
        .trzf2_clk              (trzf2_clk),
        .trzf2_rst              (trzf2_rst),
        .trzf2_ena              (trzf2_ena),
        .trzf2_la_in            (trzf2_la_in),
        .trzf2_o_hsync          (trzf2_o_hsync),
        .trzf2_o_vsync          (trzf2_o_vsync),
        .trzf2_o_rgb            (trzf2_o_rgb),
        .trzf2_o_tex_csb        (trzf2_o_tex_csb),
        .trzf2_o_tex_sclk       (trzf2_o_tex_sclk),
        .trzf2_o_tex_out0       (trzf2_o_tex_out0),
        .trzf2_o_tex_oeb0       (trzf2_o_tex_oeb0),
        .trzf2_o_gpout          (trzf2_o_gpout),
        .trzf2_io_in            (trzf2_io_in), // The mux repeats/buffers these from the IO inputs into our design.

        // Diego's user_proj_cpu:
        .diego_clk              (diego_clk),
        // .diego_rst              (diego_rst), // Not required: Diego's using io_in[6] as reset.
        // .diego_ena              (diego_ena), // Unused.
        .diego_io_out           (diego_io_out),
        .diego_io_oeb           (diego_io_oeb),
        .diego_io_in            (diego_io_in)

        //TODO: PUT IN INTERFACES FOR PAWEL AND DIEGO'S DESIGNS!
    );

    //// END: INSTANTIATION OF top_design_mux -------------------


/*--------------------------------------*/
/* User projects are instantiated below */
/*--------------------------------------*/

    //// BEGIN: INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------

    wire        trzf_clk;
    wire        trzf_rst;
    wire        trzf_ena;   // Unused.
    wire        trzf_o_hsync;
    wire        trzf_o_vsync;
    wire [5:0]  trzf_o_rgb;
    wire        trzf_o_tex_csb;
    wire        trzf_o_tex_sclk;
    wire [2:0]  trzf_o_gpout;
    wire        trzf_o_tex_out0;
    wire        trzf_o_tex_oeb0;
    wire [12:0] trzf_la_in; // The mux repeats/buffers these from the LA...
    wire [37:0] trzf_io_in; // ...and IO inputs into our design.

    //SMELL: trzf_la_in[0] is currently unused. Renumber?

    top_raybox_zero_fsm top_raybox_zero_fsm(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        .i_clk                  (trzf_clk),
        .i_reset                (trzf_rst),

        .o_hsync                (trzf_o_hsync),
        .o_vsync                (trzf_o_vsync),
        .o_rgb                  (trzf_o_rgb),

        .o_tex_csb              (trzf_o_tex_csb),
        .o_tex_sclk             (trzf_o_tex_sclk),
        .o_tex_oeb0             (trzf_o_tex_oeb0), // My only bidirectional pad.
        .o_tex_out0             (trzf_o_tex_out0),
        .i_tex_in               (trzf_io_in[21:18]),

        .i_vec_csb              (trzf_io_in[22]),
        .i_vec_sclk             (trzf_io_in[23]),
        .i_vec_mosi             (trzf_io_in[24]),

        .i_reg_csb              (trzf_io_in[25]),
        .i_reg_sclk             (trzf_io_in[26]),
        .i_reg_mosi             (trzf_io_in[27]),

        .i_debug_vec_overlay    (trzf_io_in[28]),
        .i_debug_map_overlay    (trzf_io_in[29]),
        .i_debug_trace_overlay  (trzf_io_in[30]),
        .i_reg_outs_enb         (trzf_io_in[31]),
        .i_mode                 (trzf_io_in[34:32]),

        .o_gpout                (trzf_o_gpout),
        .i_gpout0_sel           (trzf_la_in[4:1]),  //TODO: Renumber?
        .i_gpout1_sel           (trzf_la_in[8:5]),  //TODO: Renumber?
        .i_gpout2_sel           (trzf_la_in[12:9])  //TODO: Renumber?
    );

    //// END: INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------


    //// BEGIN: SECOND INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------

    wire        trzf2_clk;
    wire        trzf2_rst;
    wire        trzf2_ena;   // Unused.
    wire        trzf2_o_hsync;
    wire        trzf2_o_vsync;
    wire [5:0]  trzf2_o_rgb;
    wire        trzf2_o_tex_csb;
    wire        trzf2_o_tex_sclk;
    wire [2:0]  trzf2_o_gpout;
    wire        trzf2_o_tex_out0;
    wire        trzf2_o_tex_oeb0;
    wire [12:0] trzf2_la_in; // The mux repeats/buffers these from the LA...
    wire [37:0] trzf2_io_in; // ...and IO inputs into our design.

    //SMELL: trzf2_la_in[0] is currently unused. Renumber?

    top_raybox_zero_fsm top_raybox_zero_fsm2(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        .i_clk                  (trzf2_clock_in),
        .i_reset                (trzf2_reset),

        .o_hsync                (trzf2_o_hsync),
        .o_vsync                (trzf2_o_vsync),
        .o_rgb                  (trzf2_o_rgb),

        .o_tex_csb              (trzf2_o_tex_csb),
        .o_tex_sclk             (trzf2_o_tex_sclk),
        .o_tex_oeb0             (trzf2_o_tex_oeb0), // My only bidirectional pad.
        .o_tex_out0             (trzf2_o_tex_out0),
        .i_tex_in               (trzf2_io_in[21:18]),

        .i_vec_csb              (trzf2_io_in[22]),
        .i_vec_sclk             (trzf2_io_in[23]),
        .i_vec_mosi             (trzf2_io_in[24]),

        .i_reg_csb              (trzf2_io_in[25]),
        .i_reg_sclk             (trzf2_io_in[26]),
        .i_reg_mosi             (trzf2_io_in[27]),

        .i_debug_vec_overlay    (trzf2_io_in[28]),
        .i_debug_map_overlay    (trzf2_io_in[29]),
        .i_debug_trace_overlay  (trzf2_io_in[30]),
        .i_reg_outs_enb         (trzf2_io_in[31]),
        .i_mode                 (trzf2_io_in[34:32]),

        .o_gpout                (trzf2_o_gpout),
        .i_gpout0_sel           (trzf2_la_in[4:1]),  //TODO: Renumber?
        .i_gpout1_sel           (trzf2_la_in[8:5]),  //TODO: Renumber?
        .i_gpout2_sel           (trzf2_la_in[12:9])  //TODO: Renumber?
    );

    //// END: SECOND INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------


    //// BEGIN: INSTANTIATION OF DEIGO'S user_proj_cpu -------------------

    wire        diego_clk;
    wire [31:0] diego_io_out;
    wire [31:0] diego_io_oeb;
    wire [31:0] diego_io_in;

    user_proj_cpu user_proj_cpu(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif
        .wb_clk_i               (diego_clk),
        .io_out                 (diego_io_out),
        .io_oeb                 (diego_io_oeb),
        .io_in                  (diego_io_in)
    );

    //// END: INSTANTIATION OF DEIGO'S user_proj_cpu -------------------


    //// BEGIN: INSTANTIATION OF PAWEL'S wrapped_wb_hyperram -------------------

    wrapped_wb_hyperram wrapped_wb_hyperram (
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        .wb_clk_i               (wb_clk_i),     // Connect directly to Wishbone clock (bypass mux)
        .wb_rst_i               (wb_rst_i),     // Connect directly to Wishbone reset (bypass mux)

        // IO Pads
        .io_in                  (io_in[20:12]),
        .io_out                 (io_out[20:12]),
        .io_oeb                 (io_oeb[20:12]),

        // Additional
        .rst_i                  (pawel_mux_rst)
    );

    //// END: INSTANTIATION OF PAWEL'S wrapped_wb_hyperram -------------------


endmodule	// user_project_wrapper

`default_nettype wire
