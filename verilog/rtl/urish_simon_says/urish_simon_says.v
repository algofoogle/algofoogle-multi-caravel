`default_nettype none

module urish_simon_says #(parameter CLK_KHZ = 16'd10_000) (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
    input wb_clk_i,
    input wb_rst_i,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb
);

  assign io_out[7:0] = 8'b0000000;
  assign io_oeb[7:0] = 8'b11111111;

  wire [3:0] btn = io_in[11:8];
  assign io_out[11:8] = 4'b0000;
  assign io_oeb[11:8] = 4'b1111;

  wire [3:0] led;
  assign io_out[15:12] = led;
  assign io_oeb[15:12] = 4'b0000;

  wire sound;
  assign io_out[16] = sound;
  assign io_oeb[16] = 1'b0;

  wire [6:0] segments;
  assign io_out[23:17] = segments;
  assign io_oeb[23:17] = 7'b0000000;

  wire [1:0] segment_digits;
  assign io_out[25:24] = segment_digits;
  assign io_oeb[25:24] = 2'b00;

  wire segments_invert = io_in[26];
  assign io_out[26] = 1'b0;
  assign io_oeb[26] = 1'b1;

  wire slow_clk = io_in[27];
  assign io_out[27] = 1'b0;
  assign io_oeb[27] = 1'b1;

  assign io_out[`MPRJ_IO_PADS-1:28] = 11'b0000000000;
  assign io_oeb[`MPRJ_IO_PADS-1:28] = 11'b1111111111;


  simon simon1 (
      .clk   (wb_clk_i),
      .rst   (wb_rst_i),
      .ticks_per_milli (slow_clk ? 16'd100 : CLK_KHZ),
      .btn   (btn),
      .led   (led),
      .segments(segments),
      .segment_digits(segment_digits),
      .segments_invert(segments_invert),
      .sound (sound)
  );

endmodule
