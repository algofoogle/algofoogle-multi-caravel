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
    input               i_mux_io5_reset_enb,
    input               i_mux_auto_reset_enb,
    input       [7:0]   i_design_reset,

    // === NOTE: For the following design interfaces, outputs from the design ===
    // === become INPUTS to the mux, and vice versa. Hence, io_in becomes an  ===
    // === output that goes into the design, and io_out and io_oeb come out   ===
    // === from the design and INTO the mux (which then sends them back out   ===
    // === via io_out and io_oeb above).                                      ===

    // --- DESIGN 0 interface: top_raybox_zero_fsm ---
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

    // --- DESIGN 1 interface: SECOND top_raybox_zero_fsm ---
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

    // --- DESIGN 2 interface: Pawel's wrapped_wb_hyperram ---
    output              pawel_clk,      // Unused; design uses wb_clk_i directly.
    output              pawel_rst,      // Unused; design uses wb_rst_i directly.
    output              pawel_ena,
    input       [12:0]  pawel_io_out,
    input       [12:0]  pawel_io_oeb,
    output      [15:0]  pawel_la_in,    //NOTE: Unused now, but I'll keep them for now to avoid reshaping the mux macro.
    output      [37:0]  pawel_io_in,  // Inputs repeated/buffered from IO pads to the design:

    // --- DESIGN 3 interface: Diego's user_proj_cpu ---
    output              diego_clk,
    output              diego_rst,      // Unused; design has its own external reset.
    output              diego_ena,
    input       [31:0]  diego_io_out,
    input       [31:0]  diego_io_oeb,
    // output      [15:0]  diego_la_in, // No LA needed?
    output      [37:0]  diego_io_in,  // Inputs repeated/buffered from IO pads to the design.

    // --- DESIGN 4 interface: Uri's urish_simon_says ---
    output              uri_clk,
    output              uri_rst,      // Unused; design has its own external reset.
    output              uri_ena,
    input       [18:0]  uri_io_out,
    input       [18:0]  uri_io_oeb,
    output      [37:0]  uri_io_in,  // Inputs repeated/buffered from IO pads to the design.

    // --- DESIGN 5 interface: Anton's solo_squash_caravel_gf180 ---
    output              solos_clk,
    output              solos_rst,
    output              solos_ena,
    input       [12:0]  solos_io_out,
    output      [37:0]  solos_io_in,
    output              solos_gpio_ready,   // Controlled by 1 LA pin

    // --- DESIGN 6 interface: Anton's vga_spi_rom_gf180 (a TT05 design) ---
    output              vgasp_clk,
    output              vgasp_rst,
    output              vgasp_ena,
    output      [7:0]   vgasp_uio_in,
    input       [7:0]   vgasp_uo_out,
    input       [7:0]   vgasp_uio_out,
    input       [7:0]   vgasp_uio_oe,   //NOTE: For this, 0=in, 1=out
    output      [37:0]  vgasp_io_in

);
    // Mux control registers, 2xDFF deep for each to avoid possible LA glitches...
    //NOTE: No reset on these regs, so they can persist across full system resets.
    reg [1:0] r_mux_sel0, r_mux_sel1, r_mux_sel2, r_mux_sel3;
    reg [1:0] r_mux_sys_reset_enb;
    reg [1:0] r_mux_io5_reset_enb;
    reg [1:0] r_mux_auto_reset_enb;
    always @(posedge mux_conf_clk) begin
        r_mux_sel0           <= {          r_mux_sel0[0], i_mux_sel[0]};
        r_mux_sel1           <= {          r_mux_sel1[0], i_mux_sel[1]};
        r_mux_sel2           <= {          r_mux_sel2[0], i_mux_sel[2]};
        r_mux_sel3           <= {          r_mux_sel3[0], i_mux_sel[3]};
        r_mux_sys_reset_enb  <= { r_mux_sys_reset_enb[0], i_mux_sys_reset_enb};
        r_mux_io5_reset_enb  <= { r_mux_io5_reset_enb[0], i_mux_io5_reset_enb};
        r_mux_auto_reset_enb <= {r_mux_auto_reset_enb[0], i_mux_auto_reset_enb};
    end
    wire [3:0] mux_sel = {r_mux_sel3[1], r_mux_sel2[1], r_mux_sel1[1], r_mux_sel0[1]};
    wire mux_sys_reset_ena  = !r_mux_sys_reset_enb[1];  // NOTE: enb (active-LOW) becomes ena (active-HIGH).
    wire mux_io5_reset_ena  = !r_mux_io5_reset_enb[1];  // NOTE: enb (active-LOW) becomes ena (active-HIGH).
    wire mux_auto_reset_ena = !r_mux_auto_reset_enb[1]; // NOTE: enb (active-LOW) becomes ena (active-HIGH).
    wire sys_reset = mux_sys_reset_ena & wb_rst_i;
    wire io5_reset = mux_io5_reset_ena & io_in[5];

    // *_rst: Combinatorial reset lines:
    //                 Direct design rst | Auto reset lock if design not active    | wb_rst_i? | io5?
    //                 ------------------|-----------------------------------------|-----------|-----------
    assign trzf_rst  = i_design_reset[0] | (mux_auto_reset_ena && mux_sel != 4'd0) | sys_reset | io5_reset;
    assign trzf2_rst = i_design_reset[1] | (mux_auto_reset_ena && mux_sel != 4'd1) | sys_reset | io5_reset;
    assign pawel_rst = i_design_reset[2] | (mux_auto_reset_ena && mux_sel != 4'd2) | sys_reset | io5_reset;
    assign diego_rst = i_design_reset[3] | (mux_auto_reset_ena && mux_sel != 4'd3) | sys_reset | io5_reset;
    assign uri_rst   = i_design_reset[4] | (mux_auto_reset_ena && mux_sel != 4'd4) | sys_reset | io5_reset;
    assign solos_rst = i_design_reset[5] | (mux_auto_reset_ena && mux_sel != 4'd5) | sys_reset | io5_reset;
    assign vgasp_rst = i_design_reset[6] | (mux_auto_reset_ena && mux_sel != 4'd6) | sys_reset | io5_reset;

    // *_ena: Enable lines, for active design:
    assign trzf_ena  = mux_sel == 4'd0;
    assign trzf2_ena = mux_sel == 4'd1;
    assign pawel_ena = mux_sel == 4'd2;
    assign diego_ena = mux_sel == 4'd3;
    assign uri_ena   = mux_sel == 4'd4;
    assign solos_ena = mux_sel == 4'd5;
    assign vgasp_ena = mux_sel == 4'd6;

    // *_clk: Clock (wb_clk_i) repeated to each design:
    wire clk = wb_clk_i;
    assign trzf_clk     = clk;
    assign trzf2_clk    = clk;
    assign pawel_clk    = clk;
    assign diego_clk    = clk;
    assign uri_clk      = clk;
    assign solos_clk    = clk;
    assign vgasp_clk    = clk;

    // Repeaters/buffers for INPUTS to each design (io_in and la_in)...
    assign trzf_io_in   = io_in; // Repeat/buffer IO inputs, to pass them on to the design(s)
    assign trzf_la_in   = la_in[12:0]; // Only 13 needed.

    assign trzf2_io_in  = io_in; // Repeat/buffer IO inputs, to pass them on to the design(s)
    assign trzf2_la_in  = la_in[12:0]; // Only 13 needed.

    assign pawel_io_in  = io_in;
    assign pawel_la_in  = la_in; // All 16 WERE needed, but not anymore, so this is unused.

    assign diego_io_in  = io_in;

    assign uri_io_in    = io_in;

    assign solos_io_in  = io_in;
    assign solos_gpio_ready = la_in[0];

    assign vgasp_io_in  = io_in;


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
                // io_oeb = ?????????????1111111111111111111111111
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
                // io_oeb = ????????????????????????????????111111
                io_oeb = {
                    diego_io_oeb,
                    6'h3F
                };
                io_out = {
                    diego_io_out,       // 32 IO[37:6]  dir controlled by design.
                    6'h3F               //  6 IO[5:0]   (unused) inputs
                };
            end

            // Uri's design:
            4: begin
                io_oeb = {
                    11'h7FF,
                    uri_io_oeb,
                    8'hFF
                };
                io_out = {
                    11'h7FF,            // 11 IO[37:27] (unused) inputs
                    uri_io_out,         // 19 IO[26:8]  dir controlled by design.
                    8'hFF               //  8 IO[7:0]   (unused) inputs
                };
            end

            // Anton's solo_squash design:
            5: begin
                io_oeb = {
                    17'h1FFFF,          // 17 IO[37:21] (unused) inputs
                    8'h00,              //  8 IO[20:13] dedicated OUTPUTS
                    5'h1F,              //  5 IO[12:8]  dedicated INPUTS
                    8'hFF               //  8 IO[7:0]   (unused) inputs
                };
                io_out = {
                    17'h1FFFF,          // 17 IO[37:21] (unused) inputs
                    solos_io_out,       // 13 IO[20:8]  a mix of inputs and outputs as hardcoded into io_oeb above.
                };
            end

            // Anton's vga_spi_rom_gf180 design:
            //NOTE: I've tried to match these to the VGA and SPI memory pins of TRZF.
            6: begin
                io_oeb = {
                    ~vgasp_uio_oe[5],   //  1 IO[37]    BIDIR (SPI /RST)
                    1'b0,               //  1 IO[36]    dedicated OUTPUT (Test_out)
                    8'hFF,              //  8 IO[35:28] (unused) inputs
                    6'h3F,              //  6 IO[27:22] dedicated inputs for various other things
                    3'h7,               //  3 IO[21:19] dedicated inputs (spi_in[3:1])
                    ~vgasp_uio_oe[1],   //  1 IO[18]    BIDIR (spi_oeb0)
                    10'h000,            // 10 IO[17:8]  dedicated OUTPUTS
                    8'hFF               //  8 IO[7:0]   (unused) inputs.
                };
                io_out = {
                    vgasp_uio_out[5],   //  1 IO[37]    BIDIR (SPI /RST)
                    vgasp_uio_out[4],   //  1 IO[36]    dedicated OUTPUT (Test_out)
                    8'hFF,              //  8 IO[35:28] (unused) inputs
                    6'h3F,              //  6 IO[27:22] dedicated inputs for various other things
                    3'h7,               //  3 IO[21:19] inputs (spi_in[3:1])
                    vgasp_uio_out[1],   //  1 IO[18]    BIDIR:  spi_out0
                    vgasp_uio_out[3],   //  1 IO[17]    OUT:    spi_sclk
                    vgasp_uio_out[0],   //  1 IO[16]    OUT:    spi_csb
                    vgasp_uo_out[2],    //  1 IO[15]    OUT:    b1
                    vgasp_uo_out[6],    //  1 IO[14]    OUT:    b0
                    vgasp_uo_out[1],    //  1 IO[13]    OUT:    g1
                    vgasp_uo_out[5],    //  1 IO[12]    OUT:    g0
                    vgasp_uo_out[0],    //  1 IO[11]    OUT:    r1
                    vgasp_uo_out[4],    //  1 IO[10]    OUT:    r0
                    vgasp_uo_out[3],    //  1 IO[9]     OUT:    vsync
                    vgasp_uo_out[7],    //  1 IO[8]     OUT:    hsync
                    8'hFF               //  8 IO[7:0]   (unused) inputs.
                };
            end

            // *** Other people's designs would slot in here, up to ID 7 ***

            //TODO: *** Put other test implementations in IDs 8..15 ***

            //TODO: What about loopback of user_clock2?

            // Loopback design: LA lines and some io_ins:
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
                    6'h3F,                  //  8 IO[37:32] (unused)    inputs
                    r_mux_io5_reset_enb,    //  2 IO[31:30] dedicated   OUTPUTS
                    io5_reset,              //  1 IO[29]    dedicated   OUTPUT
                    sys_reset,              //  1 IO[28]    dedicated   OUTPUT
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
                    16'h55AA,           // 16 IO[31:16] dedicated   OUTPUTS
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
                    16'hAA55,           // 16 IO[31:16] dedicated   OUTPUTS
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
