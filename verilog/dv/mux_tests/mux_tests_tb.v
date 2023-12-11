`default_nettype none

`timescale 1 ns / 1 ps

module mux_tests_tb;
    initial begin
        $dumpfile ("mux_tests.vcd");
        $dumpvars (0, mux_tests_tb);
        #1;
    end

    reg clk; // SoC main clock.
    reg RSTB;
    reg power;

    // // GL design loses the reset signal name, also doesn't keep la1_data_in
    // wire design_reset = uut.mprj.anton_o_reset; //uut.mprj.la_data_in[32];

    wire gpio; // Caravel SoC's own (single) gpio pin which we can use to sync our tests.
    wire [37:0] mprj_io;

    // // Convenience signals that match what the cocotb test modules are looking for:
    // //SMELL: Should these be regs instead?
    // assign            mprj_io[11] = anton_clock;
    // wire o_hsync    = mprj_io[18];
    // wire o_vsync    = mprj_io[19];
    // wire o_tex_csb  = mprj_io[20];
    // wire o_tex_sclk = mprj_io[21];
    // wire io_tex_io0 = mprj_io[22]; // BIDIRECTIONAL!
    // wire o_gpout0   = mprj_io[23];
    // wire o_gpout1   = mprj_io[24];
    // wire o_gpout2   = mprj_io[25];
    // wire o_gpout3   = mprj_io[26];
    // wire [3:0] o_gpout = {mprj_io[26:23]}; // All gpouts as a handy vector.
    // // Shared INPUT pads 31,32, (skip 33), 34, (unused: 35)
    // assign            mprj_io[31] = i_tex_in1;
    // assign            mprj_io[32] = i_tex_in2;
    // assign            mprj_io[34] = i_tex_in3;

    // Interface to XIP firmware ROM:
    wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;

    // Power control:
    wire VDD = power;
    wire VSS = 1'b0;

    // Main Caravel instantiation which instantiates
    // user_project_wrapper and in turn our design:
    caravel uut (
        .VDD        (VDD),
        .VSS        (VSS),
        .gpio       (gpio),
        .mprj_io    (mprj_io),
        .clock      (clk),
        .resetb     (RSTB),
        .flash_csb  (flash_csb),
        .flash_clk  (flash_clk),
        .flash_io0  (flash_io0),
        .flash_io1  (flash_io1)
    );

    // Connect Caravel SoC pads to the firmware SPI flash ROM:
    spiflash #(
        .FILENAME("mux_tests.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

endmodule

`default_nettype wire
