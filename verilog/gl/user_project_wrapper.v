module user_project_wrapper (user_clock2,
    vdd,
    vss,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vdd;
 input vss;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [63:0] la_data_in;
 output [63:0] la_data_out;
 input [63:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \anton_io_oeb[4] ;
 wire \anton_io_out[0] ;
 wire \anton_io_out[1] ;
 wire \anton_io_out[2] ;
 wire \anton_io_out[3] ;
 wire \anton_io_out[4] ;
 wire \a0s[10] ;
 wire \a0s[11] ;
 wire \a0s[12] ;
 wire \a0s[13] ;
 wire \a0s[14] ;
 wire \a0s[15] ;
 wire \a0s[9] ;
 wire \a1s[10] ;
 wire \a1s[11] ;
 wire \a1s[12] ;
 wire \a1s[13] ;
 wire \a1s[14] ;
 wire \a1s[15] ;
 wire \a1s[1] ;
 wire \a1s[2] ;
 wire \a1s[3] ;
 wire \a1s[4] ;
 wire \a1s[5] ;
 wire \a1s[6] ;
 wire \a1s[7] ;
 wire \a1s[8] ;
 wire \a1s[9] ;
 wire \anton_gpout[4] ;
 wire \anton_gpout[5] ;
 wire anton_o_reset;

 top_ew_algofoogle top_ew_algofoogle (.i_clk(io_in[11]),
    .i_debug_map_overlay(la_data_in[34]),
    .i_debug_trace_overlay(la_data_in[27]),
    .i_debug_vec_overlay(la_data_in[11]),
    .i_la_invalid(la_oenb[0]),
    .i_reg_csb(la_data_in[12]),
    .i_reg_mosi(la_data_in[14]),
    .i_reg_outs_enb(la_data_in[50]),
    .i_reg_sclk(la_data_in[13]),
    .i_reset_lock_a(la_data_in[0]),
    .i_reset_lock_b(la_data_in[1]),
    .i_spare_0(la_data_in[51]),
    .i_spare_1(io_in[35]),
    .i_test_uc2(user_clock2),
    .i_test_wci(wb_clk_i),
    .i_vec_csb(la_data_in[2]),
    .i_vec_mosi(la_data_in[4]),
    .i_vec_sclk(la_data_in[3]),
    .o_hsync(\anton_io_out[0] ),
    .o_reset(anton_o_reset),
    .o_tex_csb(\anton_io_out[2] ),
    .o_tex_oeb0(\anton_io_oeb[4] ),
    .o_tex_out0(\anton_io_out[4] ),
    .o_tex_sclk(\anton_io_out[3] ),
    .o_vsync(\anton_io_out[1] ),
    .vdd(vdd),
    .vss(vss),
    .i_gpout0_sel({la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5]}),
    .i_gpout1_sel({la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15]}),
    .i_gpout2_sel({la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21]}),
    .i_gpout3_sel({la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28]}),
    .i_gpout4_sel({la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35]}),
    .i_gpout5_sel({la_data_in[46],
    la_data_in[45],
    la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41]}),
    .i_mode({la_data_in[49],
    la_data_in[48],
    la_data_in[47]}),
    .i_tex_in({io_in[34],
    io_in[32],
    io_in[31],
    io_in[16]}),
    .o_gpout({\anton_gpout[5] ,
    \anton_gpout[4] ,
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17]}),
    .o_rgb({_NC1,
    _NC2,
    _NC3,
    _NC4,
    _NC5,
    _NC6,
    _NC7,
    _NC8,
    _NC9,
    _NC10,
    _NC11,
    _NC12,
    _NC13,
    _NC14,
    _NC15,
    _NC16,
    _NC17,
    _NC18,
    _NC19,
    _NC20,
    _NC21,
    _NC22,
    _NC23,
    _NC24}),
    .ones({\a1s[15] ,
    \a1s[14] ,
    \a1s[13] ,
    \a1s[12] ,
    \a1s[11] ,
    \a1s[10] ,
    \a1s[9] ,
    \a1s[8] ,
    \a1s[7] ,
    \a1s[6] ,
    \a1s[5] ,
    \a1s[4] ,
    \a1s[3] ,
    \a1s[2] ,
    \a1s[1] ,
    io_oeb[11]}),
    .zeros({\a0s[15] ,
    \a0s[14] ,
    \a0s[13] ,
    \a0s[12] ,
    \a0s[11] ,
    \a0s[10] ,
    \a0s[9] ,
    io_out[11],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17]}));
 assign io_oeb[16] = \anton_io_oeb[4] ;
 assign io_out[12] = \anton_io_out[0] ;
 assign io_out[13] = \anton_io_out[1] ;
 assign io_out[14] = \anton_io_out[2] ;
 assign io_out[15] = \anton_io_out[3] ;
 assign io_out[16] = \anton_io_out[4] ;
endmodule
