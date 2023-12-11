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


module top_vga_spi_rom(
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif

    input           clk,
    input           rst,
    // input           ena, // Not actually used.

    input   [7:0]   ui_in,  // Part of overall io_in
    input   [7:0]   uio_in, // Part of overall io_in
    output  [7:0]   uo_out,
    output  [7:0]   uio_out,
    output  [7:0]   uio_oe
);

    wire rst_n = !rst; // AH reset; we change it to AL for the TT05 design.

    // This module is implemented in tt05_top.v
    tt_um_algofoogle_vga_spi_rom tt_um_algofoogle_vga_spi_rom(
        .clk            (clk),
        .rst_n          (rst_n),
        .ena            (1'b1), // Not used by the design.
        .ui_in          (ui_in),
        .uo_out         (uo_out),
        .uio_in         (uio_in),
        .uio_out        (uio_out),
        .uio_oe         (uio_oe)
    );

endmodule
