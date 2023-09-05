//NOTE: This is based on this:
// https://github.com/algofoogle/raybox/blob/main/src/rtl/lzc_b.v
//...in this case, hard-coded for 19-bit inputs, i.e. Q9.10.

`default_nettype none
`timescale 1ns / 1ps

`include "fixed_point_params.v"

`define INRANGE [`Qm-1:-`Qn]

module lzc(
  input `INRANGE i_data,
  output [4:0] o_lzc      // 0..18 is normal.
);

  function [4:0] f_lzc(input `INRANGE data);
    casez (i_data)
      //SMELL: This is probably a sloppy way to do this, and it is currently hard-coded for 19-bit inputs only:
      18'b1?????????????????:  f_lzc =  0;
      18'b01????????????????:  f_lzc =  1;
      18'b001???????????????:  f_lzc =  2;
      18'b0001??????????????:  f_lzc =  3;
      18'b00001?????????????:  f_lzc =  4;
      18'b000001????????????:  f_lzc =  5;
      18'b0000001???????????:  f_lzc =  6;
      18'b00000001??????????:  f_lzc =  7;
      18'b000000001?????????:  f_lzc =  8;
      18'b0000000001????????:  f_lzc =  9;
      18'b00000000001???????:  f_lzc = 10;
      18'b000000000001??????:  f_lzc = 11;
      18'b0000000000001?????:  f_lzc = 12;
      18'b00000000000001????:  f_lzc = 13;
      18'b000000000000001???:  f_lzc = 14;
      18'b0000000000000001??:  f_lzc = 15;
      18'b00000000000000001?:  f_lzc = 16;
      18'b000000000000000001:  f_lzc = 17;
      18'b000000000000000000:  f_lzc = 18;
    endcase

  endfunction

  assign o_lzc = f_lzc(i_data);

endmodule
