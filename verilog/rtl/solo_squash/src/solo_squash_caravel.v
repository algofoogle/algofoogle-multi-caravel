// SPDX-FileCopyrightText: 2023 Anton Maurovic <anton@maurovic.com>
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


// This is meant to be a little adapter that
// can hold extra wiring logic so that our main
// design can conveniently be used inside a CUP
// (caravel_user_project), i.e. instantiated
// within user_project_wrapper, without mucking
// up use of the design also on an FPGA.
// Caravel needs this, because it doesn't allow
// extra logic to be synthesised in
// user_project_wrapper;
// it only allows wire assignments.

//SMELL: In the same way that I would normally make separate
// "fpga" and "cpld" directories, to target different devices,
// should this file belong to an "asic" or "caravel" dir?

`default_nettype none
`timescale 1ns / 1ps

//NOTE: This would typically be instantiated to replace `mprj`
// inside user_project_wrapper.v (UPW), but would be given the
// name `adapter`.
module solo_squash_caravel (
`ifdef USE_POWER_PINS
    inout vccd1,      // User area 1 1.8V supply
    inout vssd1,      // User area 1 digital ground
`endif
    // Wishbone Slave ports (WB MI A)
    input           wb_clk_i,
    input           wb_rst_i,

    input           gpio_ready, // Typically la_data_in[32] and feeds back out to debug_gpio_ready via GPIO[20].

    input           ext_reset_n,    // Usually IO[8]
    input           pause_n,        // Usually IO[9]
    input           new_game_n,     // Usually IO[10]
    input           down_key_n,     // Usually IO[11]
    input           up_key_n,       // Usually IO[12]

    output          red,            // Usually IO[13]
    output          green,          // Usually IO[14]
    output          blue,           // Usually IO[15]
    output          hsync,          // Usually IO[16]
    output          vsync,          // Usually IO[17]
    output          speaker,        // Usually IO[18]

    output          debug_design_reset, // Usually IO[19]
    output          debug_gpio_ready,   // Usually IO[20]

    output [5:0]    design_oeb,     // Usually io_oeb[18:13]
    output [1:0]    debug_oeb       // Usually io_oeb[20:19]
);

    //NOTE: Our design avoids using IO[7:0] because mgmt core uses this.

    // Our design can be reset either by Wishbone reset or GPIO externally.
    // If using external reset (typically called ext_reset_n), note that it
    // is active-low and normally expected to be pulled high
    // (but brought low by a pushbutton):
    wire design_reset = wb_rst_i | ~ext_reset_n;
    //SMELL: ext_reset_n could be indeterminate before GPIOs are initialised!
    //SMELL: ext_reset_n, coming from io_in[8], if driven by a button,
    // lacks metastability mitigation.
    // Maybe we should put a double DFF buffer in here, for it?

    // Output enables are active-low. During reset, we want them hi-Z,
    // so set corresponding io_oeb lines high.
    assign design_oeb = {6{design_reset}};
    // IO[20:19] are always outputting, because they're test pins:
    assign debug_oeb = 2'b00;

    // For testing purposes, we expose our internal "design_reset" and
    // our internal LA-based "gpio_ready" signal as GPIO outputs 19 and 20 respectively.
    // We could've targeted them directly on the RTL tests, but they'd then
    // be inaccessible via GL tests if we didn't bring them out as GPIOs.
    assign debug_design_reset = design_reset;
    // This signal is for testing, and is pulsed by our firmware, to tell us
    // when GPIOs have finished being set up. Externally we refer to it as gpio_ready:
    assign debug_gpio_ready = gpio_ready; // gpio_ready.


    solo_squash game(
`ifdef USE_POWER_PINS
        .vccd1      (vccd1),    // User area 1 1.8V power
        .vssd1      (vssd1),    // User area 1 digital ground
`endif
        // --- Inputs ---
        // Our design's main clock comes directly from Wishbone bus clock:
        .clk        (wb_clk_i),
        .reset      (design_reset),
        // Active-low buttons (pulled high by default):
        .pause_n    (pause_n),
        .new_game_n (new_game_n),
        .down_key_n (down_key_n),
        .up_key_n   (up_key_n),

        // --- Outputs ---
        .red        (red),
        .green      (green),
        .blue       (blue),
        .hsync      (hsync),
        .vsync      (vsync),
        .speaker    (speaker)

        // The following stuff is not (yet) needed for our design:
        // // MGMT SoC Wishbone Slave
        // .wbs_cyc_i(wbs_cyc_i),
        // .wbs_stb_i(wbs_stb_i),
        // .wbs_we_i(wbs_we_i),
        // .wbs_sel_i(wbs_sel_i),
        // .wbs_adr_i(wbs_adr_i),
        // .wbs_dat_i(wbs_dat_i),
        // .wbs_ack_o(wbs_ack_o),
        // .wbs_dat_o(wbs_dat_o),
        // // Logic Analyzer
        // .la_data_in(la_data_in),
        // .la_data_out(la_data_out),
        // .la_oenb (la_oenb),
        // // IRQ
        // .irq(user_irq)
    );



endmodule
