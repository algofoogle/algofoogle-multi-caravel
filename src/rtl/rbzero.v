`default_nettype none
`timescale 1ns / 1ps

module rbzero(
  input clk,
  input reset,
  output wire hsync_n, vsync_n,
  output wire [5:0] rgb,
  output wire [9:0] hpos,
  output wire [9:0] vpos
);

  // VGA sync driver:
  wire hsync, vsync;
  wire visible;
  assign hsync_n = ~hsync;
  assign vsync_n = ~vsync;
  // wire [9:0] hpos;
  // wire [9:0] vpos;
  vga_sync vga_sync(
    .clk      (clk),
    .reset    (reset),
    .hsync    (hsync),
    .vsync    (vsync),
    .hpos     (hpos),
    .vpos     (vpos),
    .visible  (visible)
  );

  wire wall_en;
  wire [5:0] wall_rgb;

  row_render row_render(
    .side     (vpos[3]),
    .size     ({1'b0,vpos}),
    .hpos     (hpos),
    .rgb      (wall_rgb),
    .hit      (wall_en)
  );

  wire [5:0] bg = hpos < 320 ? 6'b10_10_10 : 6'b01_01_01;
  
  vga_mux vga_mux(
    .out      (rgb),
    .visible  (visible),
    .bg_rgb   (bg),
    .wall_rgb (wall_rgb),
    .wall_en  (wall_en)
  );

endmodule