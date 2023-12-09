`default_nettype none

// This is a mux macro that is to be used to select the desired design and connect it
// to the IO pads.

module top_design_mux (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
    input               wb_clk_i,
    input               wb_rst_i,

    // Main IO pad connections:
    input       [37:0]  io_in,  // These are not muxed, but instead repeated/buffered to all designs.
    output reg  [37:0]  io_out, // Driver is selected by mux.
    output reg  [37:0]  io_oeb, // Driver is selected by mux.
    input       [15:0]  la_in,  // Subset of LA inputs (SoC out => design in); typically la_data_in[23:8]

    // Mux control input signals, to be driven by LA...
    // For more info, see:
    // https://github.com/algofoogle/journal/blob/master/0187-2023-12-09.md#using-la-pins-to-control-the-mux
    input               mux_conf_clk,
    input       [3:0]   i_mux_sel,
    input               i_mux_sys_reset_enb,
    input               i_mux_auto_reset_enb,
    input       [7:0]   i_design_reset,

    // === NOTE: For the following design interfaces, outputs from the design ===
    // === become INPUTS to the mux, and vice versa. Hence, io_in becomes an  ===
    // === output that goes into the design, and io_out and io_oeb come out   ===
    // === from the design and INTO the mux (which then sends them back out   ===
    // === via io_out and io_oeb above.                                       ===

    // --- DESIGN interface: top_raybox_zero_fsm ---
    // Outputs to be mapped to IO pads:
    output              trzf_clk,
    output              trzf_rst,
    output              trzf_ena,
    input               trzf_o_hsync,
    input               trzf_o_vsync,
    input       [5:0]   trzf_o_rgb,
    input               trzf_o_tex_csb,
    input               trzf_o_tex_sclk,
    input               trzf_o_tex_out0,
    input               trzf_o_tex_oeb0, // OEB line for 1 of the IO pads.
    input       [2:0]   trzf_o_gpout,
    output      [12:0]  trzf_la_in, // Only 13 needed.
    output      [37:0]  trzf_io_in,  // Inputs repeated/buffered from IO pads to the design:

    // --- DESIGN interface: SECOND top_raybox_zero_fsm ---
    // Outputs to be mapped to IO pads:
    output              trzf2_clk,
    output              trzf2_rst,
    output              trzf2_ena,
    input               trzf2_o_hsync,
    input               trzf2_o_vsync,
    input       [5:0]   trzf2_o_rgb,
    input               trzf2_o_tex_csb,
    input               trzf2_o_tex_sclk,
    input               trzf2_o_tex_out0,
    input               trzf2_o_tex_oeb0, // OEB line for 1 of the IO pads.
    input       [2:0]   trzf2_o_gpout,
    output      [12:0]  trzf2_la_in, // Only 13 needed.
    output      [37:0]  trzf2_io_in,  // Inputs repeated/buffered from IO pads to the design:

    // --- DESIGN interface: Pawel's macro (TBC) ---
    output              pawel_clk,
    output              pawel_rst,
    output              pawel_ena,
    input       [12:0]  pawel_io_out,   //TODO: Replace with Pawel's actual ports/needs.
    input       [12:0]  pawel_io_oeb,   //TODO: Replace with Pawel's actual ports/needs.
    output      [15:0]  pawel_la_in,
    output      [37:0]  pawel_io_in,  // Inputs repeated/buffered from IO pads to the design:

    // --- DESIGN interface: Diego's macro (TBC) ---
    output              diego_clk,
    output              diego_rst,
    output              diego_ena,
    input       [31:0]  diego_io_out,   //TODO: Replace with Diego's actual ports/needs.
    input       [31:0]  diego_io_oeb,   //TODO: Replace with Diego's actual ports/needs.
    // output      [15:0]  diego_la_in, // No LA needed?
    output      [37:0]  diego_io_in  // Inputs repeated/buffered from IO pads to the design:

);
    // Mux control registers, 2xDFF deep for each to avoid possible LA glitches...
    //NOTE: No reset on these regs, so they can persist across full system resets.
    reg [1:0] r_mux_sel0, r_mux_sel1, r_mux_sel2, r_mux_sel3;
    reg [1:0] r_mux_sys_reset_enb;
    reg [1:0] r_mux_auto_reset_enb;
    always @(posedge mux_conf_clk) begin
        r_mux_sel0           <= {          r_mux_sel0[0], i_mux_sel[0]};
        r_mux_sel1           <= {          r_mux_sel1[0], i_mux_sel[1]};
        r_mux_sel2           <= {          r_mux_sel2[0], i_mux_sel[2]};
        r_mux_sel3           <= {          r_mux_sel3[0], i_mux_sel[3]};
        r_mux_sys_reset_enb  <= { r_mux_sys_reset_enb[0], i_mux_sys_reset_enb};
        r_mux_auto_reset_enb <= {r_mux_auto_reset_enb[0], i_mux_auto_reset_enb};
    end
    wire [3:0] mux_sel = {r_mux_sel3[1], r_mux_sel2[1], r_mux_sel1[1], r_mux_sel0[1]};
    wire mux_sys_reset_ena  = !r_mux_sys_reset_enb[1];  // NOTE: enb (active-LOW) becomes ena (active-HIGH).
    wire mux_auto_reset_ena = !r_mux_auto_reset_enb[1]; // NOTE: enb (active-LOW) becomes ena (active-HIGH).
    wire sys_reset = mux_sys_reset_ena & wb_rst_i;

    // *_rst: Combinatorial reset lines:
    //                 Direct design rst | Auto reset lock if design not active    | wb_rst_i applied?
    //                 ------------------|-----------------------------------------|------------------
    assign trzf_rst  = i_design_reset[0] | (mux_auto_reset_ena && mux_sel != 4'd0) | sys_reset;
    assign trzf2_rst = i_design_reset[1] | (mux_auto_reset_ena && mux_sel != 4'd1) | sys_reset;
    assign pawel_rst = i_design_reset[2] | (mux_auto_reset_ena && mux_sel != 4'd2) | sys_reset;
    assign diego_rst = i_design_reset[3] | (mux_auto_reset_ena && mux_sel != 4'd3) | sys_reset;

    // *_ena: Enable lines, for active design:
    assign trzf_ena  = mux_sel == 4'd0;
    assign trzf2_ena = mux_sel == 4'd1;
    assign pawel_ena = mux_sel == 4'd2;
    assign diego_ena = mux_sel == 4'd3;

    // *_clk: Clock (wb_clk_i) repeated to each design:
    wire clk = wb_clk_i;
    assign trzf_clk     = clk;
    assign trzf2_clk    = clk;
    assign pawel_clk    = clk;
    assign diego_clk    = clk;

    // Repeaters/buffers for INPUTS to each design (io_in and la_in)...
    assign trzf_io_in   = io_in; // Repeat/buffer IO inputs, to pass them on to the design(s)
    assign trzf_la_in   = la_in[12:0]; // Only 13 needed.

    assign trzf2_io_in  = io_in; // Repeat/buffer IO inputs, to pass them on to the design(s)
    assign trzf2_la_in  = la_in[12:0]; // Only 13 needed.

    assign pawel_io_in  = io_in;
    assign pawel_la_in  = la_in; // All 16 needed.

    assign diego_io_in  = io_in;
    //assign pawel_la_in  = la_in; // None needed?



    always @(*) begin
        case (mux_sel)
            // top_raybox_zero_fsm:
            0: begin
                // io_oeb = 0001111111111111111*000000000011111111 where *=tex_io0 dir.
                io_oeb = {
                    3'h0,
                    16'hFFFF,
                    trzf_o_tex_oeb0,
                    10'h000,
                    8'hFF
                };
                io_out = {
                    trzf_o_gpout,       //  3 IO[37:35] dedicated   OUTPUTS
                    16'hFFFF,           // 16 IO[34:19] dedicated   inputs
                    trzf_o_tex_out0,    //  1 IO[18]                BIDIR
                    trzf_o_tex_sclk,    //  1 IO[17]    dedicated   OUTPUT
                    trzf_o_tex_csb,     //  1 IO[16]    dedicated   OUTPUT
                    trzf_o_rgb,         //  6 IO[15:10] dedicated   OUTPUT
                    trzf_o_vsync,       //  1 IO[9]     dedicated   OUTPUT
                    trzf_o_hsync,       //  1 IO[8]     dedicated   OUTPUT
                    8'hFF               //  8 IO[7:0]   (unused)    inputs
                };
            end

            // top_raybox_zero_fsm2:
            1: begin
                // io_oeb = 0001111111111111111*000000000011111111 where *=tex_io0 dir.
                io_oeb = {
                    3'h0,
                    16'hFFFF,
                    trzf2_o_tex_oeb0,
                    10'h000,
                    8'hFF
                };
                io_out = {
                    trzf2_o_gpout,      //  3 IO[37:35] dedicated   OUTPUTS
                    16'hFFFF,           // 16 IO[34:19] dedicated   inputs
                    trzf2_o_tex_out0,   //  1 IO[18]                BIDIR
                    trzf2_o_tex_sclk,   //  1 IO[17]    dedicated   OUTPUT
                    trzf2_o_tex_csb,    //  1 IO[16]    dedicated   OUTPUT
                    trzf2_o_rgb,        //  6 IO[15:10] dedicated   OUTPUT
                    trzf2_o_vsync,      //  1 IO[9]     dedicated   OUTPUT
                    trzf2_o_hsync,      //  1 IO[8]     dedicated   OUTPUT
                    8'hFF               //  8 IO[7:0]   (unused)    inputs
                };
            end

            // Pawel's design:
            2: begin
                //TODO: DEFINE THIS CORRECTLY FOR PAWEL'S DESIGN!
                // io_oeb = ?
                io_oeb = {
                    pawel_io_oeb,
                    25'h1FF_FFFF
                };
                io_out = {
                    pawel_io_out,       // 13 IO[37:25] dir controlled by design.
                    25'h1FF_FFFF        // 25 IO[24:0]  (unused) inputs
                };
            end

            // Diego's design:
            3: begin
                //TODO: DEFINE THIS CORRECTLY FOR DIEGO'S DESIGN!
                // io_oeb = ?
                io_oeb = {
                    diego_io_oeb,
                    6'h3F
                };
                io_out = {
                    diego_io_out,       // 32 IO[37:6]  dir controlled by design.
                    6'h3F               //  6 IO[5:0]   (unused) inputs
                };
            end

            // *** Other people's designs would slot in here, up to ID 7 ***

            //TODO: *** Put other test implementations in IDs 8..15 ***

            // Loopback design LA lines and some io_ins:
            11: begin
                io_oeb = {
                    7'h7F,
                    23'h000000,
                    8'hFF
                };
                io_out = {
                    7'h7F,                  //  7 IO[37:31] dedicated   inputs
                    io_in[37:31],           //  7 IO[30:24] dedicated   OUTPUTS
                    la_in,                  // 16 IO[23:8]  dedicated   OUTPUTS
                    8'hFF                   //  8 IO[7:0]   (unused)    inputs
                };
            end

            // Loopback all reset lines and contents of mux control registers:
            12: begin
                io_oeb = {
                    9'h1FF,
                    21'h000000,
                    8'hFF
                };
                io_out = {
                    9'h1FF,                 //  9 IO[37:29] (unused)    inputs
                    sys_reset,              //  1 IO[28]    dedicated   OUTPUTS
                    r_mux_sel0,             //  2 IO[26]    dedicated   OUTPUTS
                    r_mux_sel1,             //  2 IO[24]    dedicated   OUTPUTS
                    r_mux_sel2,             //  2 IO[22]    dedicated   OUTPUTS
                    r_mux_sel3,             //  2 IO[20]    dedicated   OUTPUTS
                    r_mux_sys_reset_enb,    //  2 IO[18]    dedicated   OUTPUTS
                    r_mux_auto_reset_enb,   //  2 IO[17:16] dedicated   OUTPUTS
                    i_design_reset,         //  8 IO[15:8]  dedicated   OUTPUTS
                    8'hFF                   //  8 IO[7:0]   (unused)    inputs
                };
            end

            // Fixed test pattern:
            13: begin
                io_oeb = {
                     6'h3F,
                    16'h0000,
                    16'hFFFF
                };
                io_out = {
                    6'h3F,              //  6 IO[37:32] (unused)    inputs
                    12'h55AA,           // 12 IO[31:16] dedicated   OUTPUTS
                    16'hFFFF            // 16 IO[15:0]  (unused)    inputs
                };
            end

            // INVERTED version of ID 13.
            14: begin
                io_oeb = {
                     6'h3F,
                    16'h0000,
                    16'hFFFF
                };
                io_out = {
                    6'h3F,              //  6 IO[37:32] (unused)    inputs
                    12'hAA55,           // 12 IO[31:16] dedicated   OUTPUTS
                    16'hFFFF            // 16 IO[15:0]  (unused)    inputs
                };
            end
        
            default: begin
                io_out = 38'h3F_FFFF_FFFF; // Unused.
                io_oeb = 38'h3F_FFFF_FFFF; // All inputs.
            end
        endcase
    end

endmodule
