// SPDX-FileCopyrightText: 2023 Diego Satizabal
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
 * user_proj_cpu
 *
 *-------------------------------------------------------------
 */

module user_proj_cpu #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,

    // IOs
    input  [BITS - 1:0] io_in,
    output [BITS - 1:0] io_out,
    output [BITS - 1:0] io_oeb
);

    cpuy cpu(
        .clk (wb_clk_i),
        .rst (io_in[0]),
        .ext_int (io_in[1]),
        .data_bus (io_in[9:2]),
        .p0in (io_in[17:10]),
        .p1in (io_in[21:18]),
        .addr_bus (io_out[31:22]),
        .p0out (io_out[17:10]),
        .p1out (io_out[21:18]),
        .p0cfg (port_0_oeb),
        .p1cfg (port_1_oeb)
    );

    reg [7:0] port_0_oeb;
    reg [3:0] port_1_oeb;

    assign io_out[9:0] = 10'b00_0000_0000;

    // assign io_oeb = 32'b0000_0000_0000_0000_0000_0011_1111_1111; // { 10'b00_0000_0000, port_1_oeb, port_0_oeb, 10'b11_1111_1111  };
    assign io_oeb[31:22] = 10'b00_0000_0000;
    assign io_oeb[21:18] = port_1_oeb;
    assign io_oeb[17:10] = port_0_oeb;
    assign io_oeb[9:0] = 10'b11_1111_1111;

endmodule

`default_nettype wire
