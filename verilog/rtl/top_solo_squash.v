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

// This is meant to be a little adapter, based on solo_squash_caravel.v,
// that can hold extra wiring logic so that our main design can
// conveniently be used inside a CUP (caravel_user_project),
// i.e. instantiated within user_project_wrapper, without mucking up
// use of the design also on an FPGA. Caravel needs this, because it
// doesn't allow extra logic to be synthesised in user_project_wrapper;
// it only allows wire assignments.

`default_nettype none


module top_solo_squash(
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif

    input           clk,
    input           rst,

    output  [12:0]  io_out,         // These IOs get remapped to suitable caravel GPIO pads.
    input   [12:0]  io_in,          // Remapped, as above.
    input           gpio_ready      // input   la_data_in[8] in ztoa-team-group-caravel; feedback to debug_gpio_ready via GPIO[20].
);

    // These are convenience wires to map IOs above to the signals
    // they represent...
    wire wb_clk_i = clk;     // input from mux-issued clk
    wire wb_rst_i = rst;     // input from mux-issued rst
    wire ext_reset_n;        // input   GPIO[8]
    wire pause_n;            // input   GPIO[9]
    wire new_game_n;         // input   GPIO[10]
    wire down_key_n;         // input   GPIO[11]
    wire up_key_n;           // input   GPIO[12]
    wire red;                // output  GPIO[13]
    wire green;              // output  GPIO[14]
    wire blue;               // output  GPIO[15]
    wire hsync;              // output  GPIO[16]
    wire vsync;              // output  GPIO[17]
    wire speaker;            // output  GPIO[18]
    wire debug_design_reset; // output  GPIO[19]
    wire debug_gpio_ready;   // output  GPIO[20]
    // wire [5:0]  design_oeb;         // output  io_oeb[18:13]
    // wire [1:0]  debug_oeb;          // output  Usually io_oeb[20:19]

    assign ext_reset_n  = io_in[0];
    assign pause_n      = io_in[1];
    assign new_game_n   = io_in[2];
    assign down_key_n   = io_in[3];
    assign up_key_n     = io_in[4];

    assign io_out[ 5]   = red;
    assign io_out[ 6]   = green;
    assign io_out[ 7]   = blue;
    assign io_out[ 8]   = hsync;
    assign io_out[ 9]   = vsync;
    assign io_out[10]   = speaker;
    assign io_out[11]   = debug_design_reset;
    assign io_out[12]   = debug_gpio_ready;

    // Our design can be reset either by mux-issued reset or GPIO externally.
    // If using external reset (typically called ext_reset_n), note that it
    // is active-low and normally expected to be pulled high
    // (but brought low by a pushbutton):
    wire design_reset = wb_rst_i | ~ext_reset_n;
    //SMELL: ext_reset_n could be indeterminate before GPIOs are initialised!
    //SMELL: ext_reset_n, coming from io_in[8], if driven by a button,
    // lacks metastability mitigation.
    // Maybe we should put a double DFF buffer in here, for it?

    // NOT USED IN THIS IMPLEMENTATION:
    // // Output enables are active-low. During reset, we want them hi-Z,
    // // so set corresponding io_oeb lines high.
    // assign design_oeb = {6{design_reset}};
    // // IO[20:19] are always outputting, because they're test pins:
    // assign debug_oeb = 2'b00;

    // For testing purposes, we expose our internal "design_reset" and
    // our internal LA-based "gpio_ready" signal as GPIO outputs 19 and 20 respectively.
    // We could've targeted them directly on the RTL tests, but they'd then
    // be inaccessible via GL tests if we didn't bring them out as GPIOs.
    assign debug_design_reset = design_reset;
    // This signal is for testing, and is pulsed by our firmware, to tell us
    // when GPIOs have finished being set up. Externally we refer to it as gpio_ready:
    assign debug_gpio_ready = gpio_ready;

    solo_squash solo_squash(
    `ifdef USE_POWER_PINS
        .vdd        (vdd),
        .vss        (vss),
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
    );

endmodule	// wrapped_wb_hyperram

`default_nettype wire
