`default_nettype none

// This is a mux macro that is to be used to select the desired design and connect it
// to the IO pads.

module top_design_mux (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
    // Ultimately may not end up being used:
    input           wb_clk_i,
    input           wb_rst_i,

    // Main IO pad connections:
    // input  [`MPRJ_IO_PADS-1:0] io_in, // We're not going to mux io_in, because it can go directly to each design. HOWEVER, would it be good as a bridge anyway?
    input       [37:0]  io_in, //NOTE: For now, we will include these ports, but not necessarily use them.
    output reg  [37:0]  io_out,
    output reg  [37:0]  io_oeb,

    // LA pins clock in the selection of the active design...
    // i.e. assert sel_id, then pulse sel_clk (where rising edge captures sel_id):
    input           sel_clk,
    input [3:0]     sel_id,
    input [3:0]     debug,

    // --- top_raybox_zero_fsm interface ---
    // Outputs to be mapped to IO pads:
    input           trzf_o_hsync,
    input           trzf_o_vsync,
    input [5:0]     trzf_o_rgb,
    input           trzf_o_tex_csb,
    input           trzf_o_tex_sclk,
    input [2:0]     trzf_o_gpout,
    input           trzf_o_tex_out0,
    // OEB line for 1 of the IO pads:
    input           trzf_o_tex_oeb0
);

    //NOTE: No reset on this, so it can persist across full system resets:
    reg [3:0] selected_design;
    always @(posedge sel_clk) selected_design <= sel_id;

    always @(*) begin
        case (selected_design)
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

            // *** Other people's designs would slot in here, from ID 1 onwards... ***

            // fixed test pattern:
            15: begin
                io_oeb = {
                     6'h3F,
                    12'h000,
                     4'h0,
                    16'hFFFF
                };
                io_out = {
                    6'h3F,              //  6 IO[37:32] (unused)    inputs
                    12'hAA5,            // 12 IO[31:20] dedicated   OUTPUTS
                    debug,              //  4 IO[19:16] dedicated   OUTPUTS
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
