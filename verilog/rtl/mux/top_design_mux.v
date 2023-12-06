`default_nettype none

// This is a mux macro that is to be used to select the desired design and connect it
// to the IO pads.

module top_design_mux (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
    // Ultimately may not end up being used:
    input wb_clk_i,
    input wb_rst_i,

    // Main IO pad connections:
    // input  [`MPRJ_IO_PADS-1:0] io_in, // We're not going to mux io_in, because it can go directly to each design. HOWEVER, would it be good as a bridge anyway?
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // LA pins clock in the selection of the active design...
    // i.e. assert sel_id, then pulse sel_clk (where rising edge captures sel_id):
    input sel_clk,
    input [3:0] sel_id,

    // Ports for top_raybox_zero_fsm:
    input [`MPRJ_IO_PADS-1:0] trzf_io_out,
    input [`MPRJ_IO_PADS-1:0] trzf_io_oeb

);

    reg [3:0] selected_design;
    always @(posedge sel_clk) selected_design <= sel_id;

    io_out =
        sel_id == 0 ?   trzf_io_out:
                        {`MPRJ_IO_PADS{1'b0}};
    
    io_oeb =
        sel_id == 0 ?   trzf_io_oeb:
                        {`MPRJ_IO_PADS{1'b1}}; // Default all to inputs.

endmodule
