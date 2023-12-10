`default_nettype none

module wrapped_wb_hyperram(
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // IOs
    input  [12:0] io_in,
    output [12:0] io_out,
    output [12:0] io_oeb,

    // Additional
    input rst_i
);

wb_hyperram wb_hyperram 
(
    .wb_clk_i       (wb_clk_i),
    .wb_rst_i       (wb_rst_i),

    .wbs_stb_i      (wbs_stb_i),
    .wbs_cyc_i      (wbs_cyc_i),
    .wbs_we_i       (wbs_we_i),
    .wbs_sel_i      (wbs_sel_i[3:0]),
    .wbs_dat_i      (wbs_dat_i[31:0]),
    .wbs_adr_i      (wbs_adr_i[31:0]),
    .wbs_ack_o      (wbs_ack_o),
    .wbs_dat_o      (wbs_dat_o[31:0]),

    .rst_i          (rst_i),

    .hb_rstn_o      (io_out[0]),
    .hb_csn_o       (io_out[1]),
    .hb_clk_o       (io_out[2]),
    .hb_clkn_o      (io_out[3]),
    .hb_rwds_o      (io_out[4]),
    .hb_rwds_oen    (io_oeb[4]),
    .hb_rwds_i      (io_in[4]),        
    .hb_dq_o        (io_out[12:5]),
    .hb_dq_oen      (io_oeb[12:5]),
    .hb_dq_i        (io_in[12:5])
);

// enable outputs for rst, csn, clk, clkn 
assign io_oeb[3:0] = 4'h0;

endmodule	// wrapped_wb_hyperram

`default_nettype wire
