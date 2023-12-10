`default_nettype none `timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // wire up the inputs and outputs
  reg clk;
  reg rst;

  wire [37:0] io_in;
  wire [37:0] io_out;
  wire [37:0] io_oeb;

  reg [3:0] btn;
  reg seginv;
  wire [3:0] led = io_out[15:12] & ~io_oeb[15:12];
  wire speaker = io_out[16] & ~io_oeb[16];
  wire [6:0] seg = io_out[23:17] & ~io_oeb[23:17];
  wire [1:0] dig = io_out[25:24] & ~io_oeb[25:24];
  wire dig1 = dig[0];
  wire dig2 = dig[1];

  assign io_in[11:8] = btn;
  assign io_in[26]   = seginv;

  urish_simon_says #(
      .CLK_KHZ(16'd100)
  ) simon (
      // include power ports for the Gate Level test
`ifdef GL_TEST
      .vdd     (1'b1),
      .vss     (1'b0),
`endif
      .wb_rst_i(rst),     // reset
      .wb_clk_i(clk),     // clock
      .io_in   (io_in),   // IOs: Input path
      .io_out  (io_out),  // IOs: Output path
      .io_oeb  (io_oeb)   // IOs: Enable path (active low = 0=input, 1=output)
  );

endmodule
