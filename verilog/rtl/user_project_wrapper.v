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
 *      -   Anton's top_raybox_zero_fsm
 *      -   Anton's top_raybox_zero_fsm (2nd instance)
 *      -   Pawel's wrapped_wb_hyperram
 *      -   Diego's user_proj_cpu
 *      -   Uri's   urish_simon_says
 *      -   Anton's top_vga_spi_rom
 *      -   Anton's top_solo_squash
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

    // NONE of our designs use io_out[7:0] (while only Diego's uses io_in[7:6])
    // so to keep LVS precheck happy, we leave io_out[7:0] disconnected:
    wire [37:0] io_out_slice; // This gets all 38 io_out lines from the mux...
    assign io_out[37:8] = io_out_slice[37:8]; // ...and this connects only the top 30 of them.
    //NOTE: We should now be confident that io_out[7:0] are not connected at all.

    top_design_mux top_design_mux(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif
        .wb_clk_i               (wb_clk_i),
        .wb_rst_i               (wb_rst_i),

        .io_in                  (io_in),
        .io_out                 (io_out_slice),
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

        // Pawel's wrapped_wb_hyperram:
        .pawel_clk              (pawel_clk),
        .pawel_rst              (pawel_mux_rst),
        .pawel_io_out           (pawel_io_out),
        .pawel_io_oeb           (pawel_io_oeb),
        .pawel_io_in            (pawel_io_in_all38),
        // .pawel_la_in            (pawel_la_in), // Unused.

        // Diego's user_proj_cpu:
        .diego_clk              (diego_clk),
        .diego_io_out           (diego_io_out),
        .diego_io_oeb           (diego_io_oeb),
        .diego_io_in            (diego_io_in_all38),
        // .diego_rst              (diego_rst), // Not required: Diego's using io_in[6] as reset.
        // .diego_ena              (diego_ena), // Unused.

        // Uri's urish_simon_says:
        .uri_clk                (uri_clk),
        .uri_rst                (uri_rst),
        .uri_io_out             (uri_io_out[26:8]),
        .uri_io_oeb             (uri_io_oeb[26:8]),
        .uri_io_in              (uri_io_in),
        // .uri_ena                (uri_ena),  // Unused.

        // Anton's top_solo_squash:
        .solos_clk              (solos_clk),
        .solos_rst              (solos_rst),
        .solos_io_out           (solos_io_out),
        .solos_io_in            (solos_io_in_all38),
        .solos_gpio_ready       (solos_gpio_ready),
        // .solos_ena              (solos_ena), // Unused.

        .vgasp_clk              (vgasp_clk),
        .vgasp_rst              (vgasp_rst),
        .vgasp_uo_out           (vgasp_uo_out),
        .vgasp_uio_out          (vgasp_uio_out),
        .vgasp_uio_oe           (vgasp_uio_oe),
        .vgasp_io_in            (vgasp_io_in)
        // .vgasp_ena              (vgasp_ena), // Unused.

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

        .i_clk                  (trzf2_clk),
        .i_reset                (trzf2_rst),

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
    wire [37:0] diego_io_in_all38;

    user_proj_cpu user_proj_cpu(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif
        .wb_clk_i               (diego_clk),
        .io_in                  (diego_io_in_all38[37:6]), // Mux gives all 38; we use upper 32.
        .io_out                 (diego_io_out),
        .io_oeb                 (diego_io_oeb)
    );

    //// END: INSTANTIATION OF DEIGO'S user_proj_cpu -------------------


    //// BEGIN: INSTANTIATION OF PAWEL'S wrapped_wb_hyperram -------------------

    // wrapped_wb_hyperram uses wb_rst_i directly, but this is an alternate reset to respect the mux:
    wire        pawel_clk;      // Unused.
    wire        pawel_mux_rst;
    wire [12:0] pawel_io_out;
    wire [12:0] pawel_io_oeb;
    wire [37:0] pawel_io_in_all38;
    // wire [15:0] pawel_la_in;    // Unused.

    wrapped_wb_hyperram wrapped_wb_hyperram (
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        .wb_clk_i               (wb_clk_i),     // Connect directly to Wishbone clock (bypass mux)
        .wb_rst_i               (wb_rst_i),     // Connect directly to Wishbone reset (bypass mux)

        // MGMT SoC Wishbone Slave
        .wbs_cyc_i              (wbs_cyc_i),
        .wbs_stb_i              (wbs_stb_i),
        .wbs_we_i               (wbs_we_i),
        .wbs_sel_i              (wbs_sel_i),
        .wbs_adr_i              (wbs_adr_i),
        .wbs_dat_i              (wbs_dat_i),
        .wbs_ack_o              (wbs_ack_o),
        .wbs_dat_o              (wbs_dat_o),

        // IO Pads
        .io_in                  (pawel_io_in_all38[37:25]), // Mux gives all 38; we use upper 13.
        .io_out                 (pawel_io_out),
        .io_oeb                 (pawel_io_oeb),

        // Additional
        .rst_i                  (pawel_mux_rst)
    );

    //// END: INSTANTIATION OF PAWEL'S wrapped_wb_hyperram -------------------


    //// BEGIN: INSTANTIATION OF URI'S urish_simon_says -------------------

    wire            uri_clk;
    wire            uri_rst;
    wire    [37:0]  uri_io_out; // NOTE: Only a subset of these get passed to mux.
    wire    [37:0]  uri_io_oeb; // NOTE: Only a subset of these get passed to mux.
    wire    [37:0]  uri_io_in;  // Inputs repeated/buffered from IO pads to the design.
    // wire            uri_ena;    // Unused.

    urish_simon_says urish_simon_says (
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        .wb_clk_i               (uri_clk),
        .wb_rst_i               (uri_rst),

        .io_in                  (uri_io_in), //NOTE: many of these are unused. Can we make them Z?
        .io_out                 (uri_io_out),
        .io_oeb                 (uri_io_oeb)
    );

    //// END: INSTANTIATION OF URI'S urish_simon_says -------------------


    //// BEGIN: INSTANTIATION OF ANTON'S top_solo_squash -------------------

    wire            solos_clk;
    wire            solos_rst;
    wire    [12:0]  solos_io_out;
    wire    [37:0]  solos_io_in_all38;
    wire            solos_gpio_ready;   // From la_data_in[8]

    top_solo_squash top_solo_squash(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif
        .clk        (solos_clk),
        .rst        (solos_rst),
        .io_out     (solos_io_out),
        .io_in      (solos_io_in_all38[20:8]),
        .gpio_ready (solos_gpio_ready)
    );

    //// END: INSTANTIATION OF ANTON'S top_solo_squash -------------------


    //// BEGIN: INSTANTIATION OF ANTON'S top_vga_spi_rom -------------------

    wire            vgasp_clk;
    wire            vgasp_rst;
    wire  [7:0]     vgasp_uo_out;
    wire  [7:0]     vgasp_uio_out;
    wire  [7:0]     vgasp_uio_oe;   //NOTE: Design gives [0=in, 1=out] and mux inverts for us.
    wire  [37:0]    vgasp_io_in;
    // wire            vgasp_ena;   // Unused.

    // This is a bit weird, but trust me... :)
    // This horrid mapping is because I wanted to save on macro pins,
    // while also accommodating the specific way my TT05 design was
    // arranged (where not all "uio"s are bi-dir).
    //SMELL: This sort of thing should be in the mux instead...?
    wire  [7:0]     vgasp_mapped_ui_in = {
        vgasp_io_in[27:25],
        vgasp_io_in[29:28], // Unused, so could be unassigned instead??
        vgasp_io_in[24:22]
    };
    wire  [7:0]     vgasp_mapped_uio_in = {
        vgasp_io_in[21:20],
        vgasp_io_in[37],
        vgasp_io_in[31:30], //Unused, so could be unassigned instead??
        vgasp_io_in[19:18],
        vgasp_io_in[32] //Unused, so could be unassigned instead??
    };

    top_vga_spi_rom top_vga_spi_rom(
    `ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
    `endif

        //REMEMBER: These go into the mux, then the mux decides
        // which pins they get, but because we get ALL 38 io_ins,
        // we need to try and match them to what the mux does for
        // bidirectional ones (uio pairs)...
        .clk        (vgasp_clk),
        .rst        (vgasp_rst),
        .ui_in      (vgasp_mapped_ui_in),
        .uio_in     (vgasp_mapped_uio_in),
        .uo_out     (vgasp_uo_out),
        .uio_out    (vgasp_uio_out),
        .uio_oe     (vgasp_uio_oe)

    );

    //// END: INSTANTIATION OF ANTON'S top_vga_spi_rom -------------------


endmodule	// user_project_wrapper

`default_nettype wire
