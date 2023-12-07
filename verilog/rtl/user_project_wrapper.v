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
 *  -   Our main top design macro (top_raybox_zero_fsm).
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

/*-------------------------------------*/
/* User projects are instantiated here */
/*-------------------------------------*/

    //NOTE: LA pins [4:0] and [63:60] are used by the mux.

    //// BEGIN: INSTANTIATION OF ANTON'S top_design_mux -------------------

    top_design_mux top_design_mux(
    `ifdef USE_POWER_PINS
        .vdd(vdd),        // User area 1 1.8V power
        .vss(vss),        // User area 1 digital ground
    `endif
        .wb_clk_i       (wb_clk_i),
        .wb_rst_i       (wb_rst_i),

        // .io_in          (io_in),
        .io_out         (io_out),
        .io_oeb         (io_oeb),

        .sel_id         (la_data_in[3:0]),
        .sel_clk        (la_data_in[4]),
        .debug          (la_data_in[63:60]),

        // top_raybox_zero_fsm:
        .trzf_o_hsync   (trzf_o_hsync),
        .trzf_o_vsync   (trzf_o_vsync),
        .trzf_o_rgb     (trzf_o_rgb),
        .trzf_o_tex_csb (trzf_o_tex_csb),
        .trzf_o_tex_sclk(trzf_o_tex_sclk),
        .trzf_o_gpout   (trzf_o_gpout),
        .trzf_o_tex_out0(trzf_o_tex_out0),
        .trzf_o_tex_oeb0(trzf_o_tex_oeb0)
    );

    //// END: INSTANTIATION OF ANTON'S top_design_mux -------------------



    //// BEGIN: INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------

    wire        trzf_o_hsync;
    wire        trzf_o_vsync;
    wire [5:0]  trzf_o_rgb;
    wire        trzf_o_tex_csb;
    wire        trzf_o_tex_sclk;
    wire [2:0]  trzf_o_gpout;
    wire        trzf_o_tex_out0;
    wire        trzf_o_tex_oeb0;

    //NOTE: Make sure the following is fine when connected directly to io_in:
    wire [37:0] trzf_io_in = io_in;

    wire [12:0] trzf_la_in      = la_data_in[17:5]; // Can be reassigned, if desired.
    wire        trzf_clock_in   = wb_clk_i;
    wire        trzf_reset      = wb_rst_i;         // Reset by SoC...
    wire        trzf_reset_alt  = trzf_la_in[0];    // ...OR by LA.

    top_raybox_zero_fsm top_raybox_zero_fsm(
    `ifdef USE_POWER_PINS
        .vdd(vdd),        // User area 1 1.8V power
        .vss(vss),        // User area 1 digital ground
    `endif

        .i_clk                  (trzf_clock_in),
        .i_reset                (trzf_reset),
        .i_reset_alt            (trzf_reset_alt),

        // No longer needed (mux takes care of OEBs now):
        // .zeros                  (a0s),  // A source of 13 constant '0' signals.
        // .ones                   (a1s),  // A source of 24 constant '1' signals.

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
        .i_gpout0_sel           (trzf_la_in[4:1]),
        .i_gpout1_sel           (trzf_la_in[8:5]),
        .i_gpout2_sel           (trzf_la_in[12:9])
    );

    //// END: INSTANTIATION OF ANTON'S top_raybox_zero_fsm -------------------


endmodule	// user_project_wrapper

`default_nettype wire
