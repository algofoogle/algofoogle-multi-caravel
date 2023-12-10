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

 wire diego_clk;
 wire \diego_io_in_all38[0] ;
 wire \diego_io_in_all38[10] ;
 wire \diego_io_in_all38[11] ;
 wire \diego_io_in_all38[12] ;
 wire \diego_io_in_all38[13] ;
 wire \diego_io_in_all38[14] ;
 wire \diego_io_in_all38[15] ;
 wire \diego_io_in_all38[16] ;
 wire \diego_io_in_all38[17] ;
 wire \diego_io_in_all38[18] ;
 wire \diego_io_in_all38[19] ;
 wire \diego_io_in_all38[1] ;
 wire \diego_io_in_all38[20] ;
 wire \diego_io_in_all38[21] ;
 wire \diego_io_in_all38[22] ;
 wire \diego_io_in_all38[23] ;
 wire \diego_io_in_all38[24] ;
 wire \diego_io_in_all38[25] ;
 wire \diego_io_in_all38[26] ;
 wire \diego_io_in_all38[27] ;
 wire \diego_io_in_all38[28] ;
 wire \diego_io_in_all38[29] ;
 wire \diego_io_in_all38[2] ;
 wire \diego_io_in_all38[30] ;
 wire \diego_io_in_all38[31] ;
 wire \diego_io_in_all38[32] ;
 wire \diego_io_in_all38[33] ;
 wire \diego_io_in_all38[34] ;
 wire \diego_io_in_all38[35] ;
 wire \diego_io_in_all38[36] ;
 wire \diego_io_in_all38[37] ;
 wire \diego_io_in_all38[3] ;
 wire \diego_io_in_all38[4] ;
 wire \diego_io_in_all38[5] ;
 wire \diego_io_in_all38[6] ;
 wire \diego_io_in_all38[7] ;
 wire \diego_io_in_all38[8] ;
 wire \diego_io_in_all38[9] ;
 wire \diego_io_oeb[0] ;
 wire \diego_io_oeb[10] ;
 wire \diego_io_oeb[11] ;
 wire \diego_io_oeb[12] ;
 wire \diego_io_oeb[13] ;
 wire \diego_io_oeb[14] ;
 wire \diego_io_oeb[15] ;
 wire \diego_io_oeb[16] ;
 wire \diego_io_oeb[17] ;
 wire \diego_io_oeb[18] ;
 wire \diego_io_oeb[19] ;
 wire \diego_io_oeb[1] ;
 wire \diego_io_oeb[20] ;
 wire \diego_io_oeb[21] ;
 wire \diego_io_oeb[22] ;
 wire \diego_io_oeb[23] ;
 wire \diego_io_oeb[24] ;
 wire \diego_io_oeb[25] ;
 wire \diego_io_oeb[26] ;
 wire \diego_io_oeb[27] ;
 wire \diego_io_oeb[28] ;
 wire \diego_io_oeb[29] ;
 wire \diego_io_oeb[2] ;
 wire \diego_io_oeb[30] ;
 wire \diego_io_oeb[31] ;
 wire \diego_io_oeb[3] ;
 wire \diego_io_oeb[4] ;
 wire \diego_io_oeb[5] ;
 wire \diego_io_oeb[6] ;
 wire \diego_io_oeb[7] ;
 wire \diego_io_oeb[8] ;
 wire \diego_io_oeb[9] ;
 wire \diego_io_out[0] ;
 wire \diego_io_out[10] ;
 wire \diego_io_out[11] ;
 wire \diego_io_out[12] ;
 wire \diego_io_out[13] ;
 wire \diego_io_out[14] ;
 wire \diego_io_out[15] ;
 wire \diego_io_out[16] ;
 wire \diego_io_out[17] ;
 wire \diego_io_out[18] ;
 wire \diego_io_out[19] ;
 wire \diego_io_out[1] ;
 wire \diego_io_out[20] ;
 wire \diego_io_out[21] ;
 wire \diego_io_out[22] ;
 wire \diego_io_out[23] ;
 wire \diego_io_out[24] ;
 wire \diego_io_out[25] ;
 wire \diego_io_out[26] ;
 wire \diego_io_out[27] ;
 wire \diego_io_out[28] ;
 wire \diego_io_out[29] ;
 wire \diego_io_out[2] ;
 wire \diego_io_out[30] ;
 wire \diego_io_out[31] ;
 wire \diego_io_out[3] ;
 wire \diego_io_out[4] ;
 wire \diego_io_out[5] ;
 wire \diego_io_out[6] ;
 wire \diego_io_out[7] ;
 wire \diego_io_out[8] ;
 wire \diego_io_out[9] ;
 wire pawel_clk;
 wire \pawel_io_in_all38[0] ;
 wire \pawel_io_in_all38[10] ;
 wire \pawel_io_in_all38[11] ;
 wire \pawel_io_in_all38[12] ;
 wire \pawel_io_in_all38[13] ;
 wire \pawel_io_in_all38[14] ;
 wire \pawel_io_in_all38[15] ;
 wire \pawel_io_in_all38[16] ;
 wire \pawel_io_in_all38[17] ;
 wire \pawel_io_in_all38[18] ;
 wire \pawel_io_in_all38[19] ;
 wire \pawel_io_in_all38[1] ;
 wire \pawel_io_in_all38[20] ;
 wire \pawel_io_in_all38[21] ;
 wire \pawel_io_in_all38[22] ;
 wire \pawel_io_in_all38[23] ;
 wire \pawel_io_in_all38[24] ;
 wire \pawel_io_in_all38[25] ;
 wire \pawel_io_in_all38[26] ;
 wire \pawel_io_in_all38[27] ;
 wire \pawel_io_in_all38[28] ;
 wire \pawel_io_in_all38[29] ;
 wire \pawel_io_in_all38[2] ;
 wire \pawel_io_in_all38[30] ;
 wire \pawel_io_in_all38[31] ;
 wire \pawel_io_in_all38[32] ;
 wire \pawel_io_in_all38[33] ;
 wire \pawel_io_in_all38[34] ;
 wire \pawel_io_in_all38[35] ;
 wire \pawel_io_in_all38[36] ;
 wire \pawel_io_in_all38[37] ;
 wire \pawel_io_in_all38[3] ;
 wire \pawel_io_in_all38[4] ;
 wire \pawel_io_in_all38[5] ;
 wire \pawel_io_in_all38[6] ;
 wire \pawel_io_in_all38[7] ;
 wire \pawel_io_in_all38[8] ;
 wire \pawel_io_in_all38[9] ;
 wire \pawel_io_oeb[0] ;
 wire \pawel_io_oeb[10] ;
 wire \pawel_io_oeb[11] ;
 wire \pawel_io_oeb[12] ;
 wire \pawel_io_oeb[1] ;
 wire \pawel_io_oeb[2] ;
 wire \pawel_io_oeb[3] ;
 wire \pawel_io_oeb[4] ;
 wire \pawel_io_oeb[5] ;
 wire \pawel_io_oeb[6] ;
 wire \pawel_io_oeb[7] ;
 wire \pawel_io_oeb[8] ;
 wire \pawel_io_oeb[9] ;
 wire \pawel_io_out[0] ;
 wire \pawel_io_out[10] ;
 wire \pawel_io_out[11] ;
 wire \pawel_io_out[12] ;
 wire \pawel_io_out[1] ;
 wire \pawel_io_out[2] ;
 wire \pawel_io_out[3] ;
 wire \pawel_io_out[4] ;
 wire \pawel_io_out[5] ;
 wire \pawel_io_out[6] ;
 wire \pawel_io_out[7] ;
 wire \pawel_io_out[8] ;
 wire \pawel_io_out[9] ;
 wire \pawel_la_in[0] ;
 wire \pawel_la_in[10] ;
 wire \pawel_la_in[11] ;
 wire \pawel_la_in[12] ;
 wire \pawel_la_in[13] ;
 wire \pawel_la_in[14] ;
 wire \pawel_la_in[15] ;
 wire \pawel_la_in[1] ;
 wire \pawel_la_in[2] ;
 wire \pawel_la_in[3] ;
 wire \pawel_la_in[4] ;
 wire \pawel_la_in[5] ;
 wire \pawel_la_in[6] ;
 wire \pawel_la_in[7] ;
 wire \pawel_la_in[8] ;
 wire \pawel_la_in[9] ;
 wire pawel_mux_rst;
 wire trzf2_clk;
 wire trzf2_ena;
 wire \trzf2_io_in[0] ;
 wire \trzf2_io_in[10] ;
 wire \trzf2_io_in[11] ;
 wire \trzf2_io_in[12] ;
 wire \trzf2_io_in[13] ;
 wire \trzf2_io_in[14] ;
 wire \trzf2_io_in[15] ;
 wire \trzf2_io_in[16] ;
 wire \trzf2_io_in[17] ;
 wire \trzf2_io_in[18] ;
 wire \trzf2_io_in[19] ;
 wire \trzf2_io_in[1] ;
 wire \trzf2_io_in[20] ;
 wire \trzf2_io_in[21] ;
 wire \trzf2_io_in[22] ;
 wire \trzf2_io_in[23] ;
 wire \trzf2_io_in[24] ;
 wire \trzf2_io_in[25] ;
 wire \trzf2_io_in[26] ;
 wire \trzf2_io_in[27] ;
 wire \trzf2_io_in[28] ;
 wire \trzf2_io_in[29] ;
 wire \trzf2_io_in[2] ;
 wire \trzf2_io_in[30] ;
 wire \trzf2_io_in[31] ;
 wire \trzf2_io_in[32] ;
 wire \trzf2_io_in[33] ;
 wire \trzf2_io_in[34] ;
 wire \trzf2_io_in[35] ;
 wire \trzf2_io_in[36] ;
 wire \trzf2_io_in[37] ;
 wire \trzf2_io_in[3] ;
 wire \trzf2_io_in[4] ;
 wire \trzf2_io_in[5] ;
 wire \trzf2_io_in[6] ;
 wire \trzf2_io_in[7] ;
 wire \trzf2_io_in[8] ;
 wire \trzf2_io_in[9] ;
 wire \trzf2_la_in[0] ;
 wire \trzf2_la_in[10] ;
 wire \trzf2_la_in[11] ;
 wire \trzf2_la_in[12] ;
 wire \trzf2_la_in[1] ;
 wire \trzf2_la_in[2] ;
 wire \trzf2_la_in[3] ;
 wire \trzf2_la_in[4] ;
 wire \trzf2_la_in[5] ;
 wire \trzf2_la_in[6] ;
 wire \trzf2_la_in[7] ;
 wire \trzf2_la_in[8] ;
 wire \trzf2_la_in[9] ;
 wire \trzf2_o_gpout[0] ;
 wire \trzf2_o_gpout[1] ;
 wire \trzf2_o_gpout[2] ;
 wire trzf2_o_hsync;
 wire \trzf2_o_rgb[0] ;
 wire \trzf2_o_rgb[1] ;
 wire \trzf2_o_rgb[2] ;
 wire \trzf2_o_rgb[3] ;
 wire \trzf2_o_rgb[4] ;
 wire \trzf2_o_rgb[5] ;
 wire trzf2_o_tex_csb;
 wire trzf2_o_tex_oeb0;
 wire trzf2_o_tex_out0;
 wire trzf2_o_tex_sclk;
 wire trzf2_o_vsync;
 wire trzf2_rst;
 wire trzf_clk;
 wire trzf_ena;
 wire \trzf_io_in[0] ;
 wire \trzf_io_in[10] ;
 wire \trzf_io_in[11] ;
 wire \trzf_io_in[12] ;
 wire \trzf_io_in[13] ;
 wire \trzf_io_in[14] ;
 wire \trzf_io_in[15] ;
 wire \trzf_io_in[16] ;
 wire \trzf_io_in[17] ;
 wire \trzf_io_in[18] ;
 wire \trzf_io_in[19] ;
 wire \trzf_io_in[1] ;
 wire \trzf_io_in[20] ;
 wire \trzf_io_in[21] ;
 wire \trzf_io_in[22] ;
 wire \trzf_io_in[23] ;
 wire \trzf_io_in[24] ;
 wire \trzf_io_in[25] ;
 wire \trzf_io_in[26] ;
 wire \trzf_io_in[27] ;
 wire \trzf_io_in[28] ;
 wire \trzf_io_in[29] ;
 wire \trzf_io_in[2] ;
 wire \trzf_io_in[30] ;
 wire \trzf_io_in[31] ;
 wire \trzf_io_in[32] ;
 wire \trzf_io_in[33] ;
 wire \trzf_io_in[34] ;
 wire \trzf_io_in[35] ;
 wire \trzf_io_in[36] ;
 wire \trzf_io_in[37] ;
 wire \trzf_io_in[3] ;
 wire \trzf_io_in[4] ;
 wire \trzf_io_in[5] ;
 wire \trzf_io_in[6] ;
 wire \trzf_io_in[7] ;
 wire \trzf_io_in[8] ;
 wire \trzf_io_in[9] ;
 wire \trzf_la_in[0] ;
 wire \trzf_la_in[10] ;
 wire \trzf_la_in[11] ;
 wire \trzf_la_in[12] ;
 wire \trzf_la_in[1] ;
 wire \trzf_la_in[2] ;
 wire \trzf_la_in[3] ;
 wire \trzf_la_in[4] ;
 wire \trzf_la_in[5] ;
 wire \trzf_la_in[6] ;
 wire \trzf_la_in[7] ;
 wire \trzf_la_in[8] ;
 wire \trzf_la_in[9] ;
 wire \trzf_o_gpout[0] ;
 wire \trzf_o_gpout[1] ;
 wire \trzf_o_gpout[2] ;
 wire trzf_o_hsync;
 wire \trzf_o_rgb[0] ;
 wire \trzf_o_rgb[1] ;
 wire \trzf_o_rgb[2] ;
 wire \trzf_o_rgb[3] ;
 wire \trzf_o_rgb[4] ;
 wire \trzf_o_rgb[5] ;
 wire trzf_o_tex_csb;
 wire trzf_o_tex_oeb0;
 wire trzf_o_tex_out0;
 wire trzf_o_tex_sclk;
 wire trzf_o_vsync;
 wire trzf_rst;
 wire uri_clk;
 wire \uri_io_in[0] ;
 wire \uri_io_in[10] ;
 wire \uri_io_in[11] ;
 wire \uri_io_in[12] ;
 wire \uri_io_in[13] ;
 wire \uri_io_in[14] ;
 wire \uri_io_in[15] ;
 wire \uri_io_in[16] ;
 wire \uri_io_in[17] ;
 wire \uri_io_in[18] ;
 wire \uri_io_in[19] ;
 wire \uri_io_in[1] ;
 wire \uri_io_in[20] ;
 wire \uri_io_in[21] ;
 wire \uri_io_in[22] ;
 wire \uri_io_in[23] ;
 wire \uri_io_in[24] ;
 wire \uri_io_in[25] ;
 wire \uri_io_in[26] ;
 wire \uri_io_in[27] ;
 wire \uri_io_in[28] ;
 wire \uri_io_in[29] ;
 wire \uri_io_in[2] ;
 wire \uri_io_in[30] ;
 wire \uri_io_in[31] ;
 wire \uri_io_in[32] ;
 wire \uri_io_in[33] ;
 wire \uri_io_in[34] ;
 wire \uri_io_in[35] ;
 wire \uri_io_in[36] ;
 wire \uri_io_in[37] ;
 wire \uri_io_in[3] ;
 wire \uri_io_in[4] ;
 wire \uri_io_in[5] ;
 wire \uri_io_in[6] ;
 wire \uri_io_in[7] ;
 wire \uri_io_in[8] ;
 wire \uri_io_in[9] ;
 wire \uri_io_oeb[0] ;
 wire \uri_io_oeb[10] ;
 wire \uri_io_oeb[11] ;
 wire \uri_io_oeb[12] ;
 wire \uri_io_oeb[13] ;
 wire \uri_io_oeb[14] ;
 wire \uri_io_oeb[15] ;
 wire \uri_io_oeb[16] ;
 wire \uri_io_oeb[17] ;
 wire \uri_io_oeb[18] ;
 wire \uri_io_oeb[19] ;
 wire \uri_io_oeb[1] ;
 wire \uri_io_oeb[20] ;
 wire \uri_io_oeb[21] ;
 wire \uri_io_oeb[22] ;
 wire \uri_io_oeb[23] ;
 wire \uri_io_oeb[24] ;
 wire \uri_io_oeb[25] ;
 wire \uri_io_oeb[26] ;
 wire \uri_io_oeb[27] ;
 wire \uri_io_oeb[28] ;
 wire \uri_io_oeb[29] ;
 wire \uri_io_oeb[2] ;
 wire \uri_io_oeb[30] ;
 wire \uri_io_oeb[31] ;
 wire \uri_io_oeb[32] ;
 wire \uri_io_oeb[33] ;
 wire \uri_io_oeb[34] ;
 wire \uri_io_oeb[35] ;
 wire \uri_io_oeb[36] ;
 wire \uri_io_oeb[37] ;
 wire \uri_io_oeb[3] ;
 wire \uri_io_oeb[4] ;
 wire \uri_io_oeb[5] ;
 wire \uri_io_oeb[6] ;
 wire \uri_io_oeb[7] ;
 wire \uri_io_oeb[8] ;
 wire \uri_io_oeb[9] ;
 wire \uri_io_out[0] ;
 wire \uri_io_out[10] ;
 wire \uri_io_out[11] ;
 wire \uri_io_out[12] ;
 wire \uri_io_out[13] ;
 wire \uri_io_out[14] ;
 wire \uri_io_out[15] ;
 wire \uri_io_out[16] ;
 wire \uri_io_out[17] ;
 wire \uri_io_out[18] ;
 wire \uri_io_out[19] ;
 wire \uri_io_out[1] ;
 wire \uri_io_out[20] ;
 wire \uri_io_out[21] ;
 wire \uri_io_out[22] ;
 wire \uri_io_out[23] ;
 wire \uri_io_out[24] ;
 wire \uri_io_out[25] ;
 wire \uri_io_out[26] ;
 wire \uri_io_out[27] ;
 wire \uri_io_out[28] ;
 wire \uri_io_out[29] ;
 wire \uri_io_out[2] ;
 wire \uri_io_out[30] ;
 wire \uri_io_out[31] ;
 wire \uri_io_out[32] ;
 wire \uri_io_out[33] ;
 wire \uri_io_out[34] ;
 wire \uri_io_out[35] ;
 wire \uri_io_out[36] ;
 wire \uri_io_out[37] ;
 wire \uri_io_out[3] ;
 wire \uri_io_out[4] ;
 wire \uri_io_out[5] ;
 wire \uri_io_out[6] ;
 wire \uri_io_out[7] ;
 wire \uri_io_out[8] ;
 wire \uri_io_out[9] ;
 wire uri_rst;

 top_design_mux top_design_mux (.diego_clk(diego_clk),
    .i_mux_auto_reset_enb(la_data_in[54]),
    .i_mux_io5_reset_enb(la_data_in[48]),
    .i_mux_sys_reset_enb(la_data_in[53]),
    .mux_conf_clk(la_data_in[63]),
    .pawel_clk(pawel_clk),
    .pawel_rst(pawel_mux_rst),
    .trzf2_clk(trzf2_clk),
    .trzf2_ena(trzf2_ena),
    .trzf2_o_hsync(trzf2_o_hsync),
    .trzf2_o_tex_csb(trzf2_o_tex_csb),
    .trzf2_o_tex_oeb0(trzf2_o_tex_oeb0),
    .trzf2_o_tex_out0(trzf2_o_tex_out0),
    .trzf2_o_tex_sclk(trzf2_o_tex_sclk),
    .trzf2_o_vsync(trzf2_o_vsync),
    .trzf2_rst(trzf2_rst),
    .trzf_clk(trzf_clk),
    .trzf_ena(trzf_ena),
    .trzf_o_hsync(trzf_o_hsync),
    .trzf_o_tex_csb(trzf_o_tex_csb),
    .trzf_o_tex_oeb0(trzf_o_tex_oeb0),
    .trzf_o_tex_out0(trzf_o_tex_out0),
    .trzf_o_tex_sclk(trzf_o_tex_sclk),
    .trzf_o_vsync(trzf_o_vsync),
    .trzf_rst(trzf_rst),
    .uri_clk(uri_clk),
    .uri_rst(uri_rst),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .diego_io_in({\diego_io_in_all38[37] ,
    \diego_io_in_all38[36] ,
    \diego_io_in_all38[35] ,
    \diego_io_in_all38[34] ,
    \diego_io_in_all38[33] ,
    \diego_io_in_all38[32] ,
    \diego_io_in_all38[31] ,
    \diego_io_in_all38[30] ,
    \diego_io_in_all38[29] ,
    \diego_io_in_all38[28] ,
    \diego_io_in_all38[27] ,
    \diego_io_in_all38[26] ,
    \diego_io_in_all38[25] ,
    \diego_io_in_all38[24] ,
    \diego_io_in_all38[23] ,
    \diego_io_in_all38[22] ,
    \diego_io_in_all38[21] ,
    \diego_io_in_all38[20] ,
    \diego_io_in_all38[19] ,
    \diego_io_in_all38[18] ,
    \diego_io_in_all38[17] ,
    \diego_io_in_all38[16] ,
    \diego_io_in_all38[15] ,
    \diego_io_in_all38[14] ,
    \diego_io_in_all38[13] ,
    \diego_io_in_all38[12] ,
    \diego_io_in_all38[11] ,
    \diego_io_in_all38[10] ,
    \diego_io_in_all38[9] ,
    \diego_io_in_all38[8] ,
    \diego_io_in_all38[7] ,
    \diego_io_in_all38[6] ,
    \diego_io_in_all38[5] ,
    \diego_io_in_all38[4] ,
    \diego_io_in_all38[3] ,
    \diego_io_in_all38[2] ,
    \diego_io_in_all38[1] ,
    \diego_io_in_all38[0] }),
    .diego_io_oeb({\diego_io_oeb[31] ,
    \diego_io_oeb[30] ,
    \diego_io_oeb[29] ,
    \diego_io_oeb[28] ,
    \diego_io_oeb[27] ,
    \diego_io_oeb[26] ,
    \diego_io_oeb[25] ,
    \diego_io_oeb[24] ,
    \diego_io_oeb[23] ,
    \diego_io_oeb[22] ,
    \diego_io_oeb[21] ,
    \diego_io_oeb[20] ,
    \diego_io_oeb[19] ,
    \diego_io_oeb[18] ,
    \diego_io_oeb[17] ,
    \diego_io_oeb[16] ,
    \diego_io_oeb[15] ,
    \diego_io_oeb[14] ,
    \diego_io_oeb[13] ,
    \diego_io_oeb[12] ,
    \diego_io_oeb[11] ,
    \diego_io_oeb[10] ,
    \diego_io_oeb[9] ,
    \diego_io_oeb[8] ,
    \diego_io_oeb[7] ,
    \diego_io_oeb[6] ,
    \diego_io_oeb[5] ,
    \diego_io_oeb[4] ,
    \diego_io_oeb[3] ,
    \diego_io_oeb[2] ,
    \diego_io_oeb[1] ,
    \diego_io_oeb[0] }),
    .diego_io_out({\diego_io_out[31] ,
    \diego_io_out[30] ,
    \diego_io_out[29] ,
    \diego_io_out[28] ,
    \diego_io_out[27] ,
    \diego_io_out[26] ,
    \diego_io_out[25] ,
    \diego_io_out[24] ,
    \diego_io_out[23] ,
    \diego_io_out[22] ,
    \diego_io_out[21] ,
    \diego_io_out[20] ,
    \diego_io_out[19] ,
    \diego_io_out[18] ,
    \diego_io_out[17] ,
    \diego_io_out[16] ,
    \diego_io_out[15] ,
    \diego_io_out[14] ,
    \diego_io_out[13] ,
    \diego_io_out[12] ,
    \diego_io_out[11] ,
    \diego_io_out[10] ,
    \diego_io_out[9] ,
    \diego_io_out[8] ,
    \diego_io_out[7] ,
    \diego_io_out[6] ,
    \diego_io_out[5] ,
    \diego_io_out[4] ,
    \diego_io_out[3] ,
    \diego_io_out[2] ,
    \diego_io_out[1] ,
    \diego_io_out[0] }),
    .i_design_reset({la_data_in[62],
    la_data_in[61],
    la_data_in[60],
    la_data_in[59],
    la_data_in[58],
    la_data_in[57],
    la_data_in[56],
    la_data_in[55]}),
    .i_mux_sel({la_data_in[52],
    la_data_in[51],
    la_data_in[50],
    la_data_in[49]}),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5],
    io_in[4],
    io_in[3],
    io_in[2],
    io_in[1],
    io_in[0]}),
    .io_oeb({io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .io_out({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}),
    .la_in({la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13],
    la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8]}),
    .pawel_io_in({\pawel_io_in_all38[37] ,
    \pawel_io_in_all38[36] ,
    \pawel_io_in_all38[35] ,
    \pawel_io_in_all38[34] ,
    \pawel_io_in_all38[33] ,
    \pawel_io_in_all38[32] ,
    \pawel_io_in_all38[31] ,
    \pawel_io_in_all38[30] ,
    \pawel_io_in_all38[29] ,
    \pawel_io_in_all38[28] ,
    \pawel_io_in_all38[27] ,
    \pawel_io_in_all38[26] ,
    \pawel_io_in_all38[25] ,
    \pawel_io_in_all38[24] ,
    \pawel_io_in_all38[23] ,
    \pawel_io_in_all38[22] ,
    \pawel_io_in_all38[21] ,
    \pawel_io_in_all38[20] ,
    \pawel_io_in_all38[19] ,
    \pawel_io_in_all38[18] ,
    \pawel_io_in_all38[17] ,
    \pawel_io_in_all38[16] ,
    \pawel_io_in_all38[15] ,
    \pawel_io_in_all38[14] ,
    \pawel_io_in_all38[13] ,
    \pawel_io_in_all38[12] ,
    \pawel_io_in_all38[11] ,
    \pawel_io_in_all38[10] ,
    \pawel_io_in_all38[9] ,
    \pawel_io_in_all38[8] ,
    \pawel_io_in_all38[7] ,
    \pawel_io_in_all38[6] ,
    \pawel_io_in_all38[5] ,
    \pawel_io_in_all38[4] ,
    \pawel_io_in_all38[3] ,
    \pawel_io_in_all38[2] ,
    \pawel_io_in_all38[1] ,
    \pawel_io_in_all38[0] }),
    .pawel_io_oeb({\pawel_io_oeb[12] ,
    \pawel_io_oeb[11] ,
    \pawel_io_oeb[10] ,
    \pawel_io_oeb[9] ,
    \pawel_io_oeb[8] ,
    \pawel_io_oeb[7] ,
    \pawel_io_oeb[6] ,
    \pawel_io_oeb[5] ,
    \pawel_io_oeb[4] ,
    \pawel_io_oeb[3] ,
    \pawel_io_oeb[2] ,
    \pawel_io_oeb[1] ,
    \pawel_io_oeb[0] }),
    .pawel_io_out({\pawel_io_out[12] ,
    \pawel_io_out[11] ,
    \pawel_io_out[10] ,
    \pawel_io_out[9] ,
    \pawel_io_out[8] ,
    \pawel_io_out[7] ,
    \pawel_io_out[6] ,
    \pawel_io_out[5] ,
    \pawel_io_out[4] ,
    \pawel_io_out[3] ,
    \pawel_io_out[2] ,
    \pawel_io_out[1] ,
    \pawel_io_out[0] }),
    .pawel_la_in({\pawel_la_in[15] ,
    \pawel_la_in[14] ,
    \pawel_la_in[13] ,
    \pawel_la_in[12] ,
    \pawel_la_in[11] ,
    \pawel_la_in[10] ,
    \pawel_la_in[9] ,
    \pawel_la_in[8] ,
    \pawel_la_in[7] ,
    \pawel_la_in[6] ,
    \pawel_la_in[5] ,
    \pawel_la_in[4] ,
    \pawel_la_in[3] ,
    \pawel_la_in[2] ,
    \pawel_la_in[1] ,
    \pawel_la_in[0] }),
    .solos_io_in({_NC1,
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
    _NC24,
    _NC25,
    _NC26,
    _NC27,
    _NC28,
    _NC29,
    _NC30,
    _NC31,
    _NC32,
    _NC33,
    _NC34,
    _NC35,
    _NC36,
    _NC37,
    _NC38}),
    .solos_io_out({_NC39,
    _NC40,
    _NC41,
    _NC42,
    _NC43,
    _NC44,
    _NC45,
    _NC46,
    _NC47,
    _NC48,
    _NC49,
    _NC50,
    _NC51}),
    .trzf2_io_in({\trzf2_io_in[37] ,
    \trzf2_io_in[36] ,
    \trzf2_io_in[35] ,
    \trzf2_io_in[34] ,
    \trzf2_io_in[33] ,
    \trzf2_io_in[32] ,
    \trzf2_io_in[31] ,
    \trzf2_io_in[30] ,
    \trzf2_io_in[29] ,
    \trzf2_io_in[28] ,
    \trzf2_io_in[27] ,
    \trzf2_io_in[26] ,
    \trzf2_io_in[25] ,
    \trzf2_io_in[24] ,
    \trzf2_io_in[23] ,
    \trzf2_io_in[22] ,
    \trzf2_io_in[21] ,
    \trzf2_io_in[20] ,
    \trzf2_io_in[19] ,
    \trzf2_io_in[18] ,
    \trzf2_io_in[17] ,
    \trzf2_io_in[16] ,
    \trzf2_io_in[15] ,
    \trzf2_io_in[14] ,
    \trzf2_io_in[13] ,
    \trzf2_io_in[12] ,
    \trzf2_io_in[11] ,
    \trzf2_io_in[10] ,
    \trzf2_io_in[9] ,
    \trzf2_io_in[8] ,
    \trzf2_io_in[7] ,
    \trzf2_io_in[6] ,
    \trzf2_io_in[5] ,
    \trzf2_io_in[4] ,
    \trzf2_io_in[3] ,
    \trzf2_io_in[2] ,
    \trzf2_io_in[1] ,
    \trzf2_io_in[0] }),
    .trzf2_la_in({\trzf2_la_in[12] ,
    \trzf2_la_in[11] ,
    \trzf2_la_in[10] ,
    \trzf2_la_in[9] ,
    \trzf2_la_in[8] ,
    \trzf2_la_in[7] ,
    \trzf2_la_in[6] ,
    \trzf2_la_in[5] ,
    \trzf2_la_in[4] ,
    \trzf2_la_in[3] ,
    \trzf2_la_in[2] ,
    \trzf2_la_in[1] ,
    \trzf2_la_in[0] }),
    .trzf2_o_gpout({\trzf2_o_gpout[2] ,
    \trzf2_o_gpout[1] ,
    \trzf2_o_gpout[0] }),
    .trzf2_o_rgb({\trzf2_o_rgb[5] ,
    \trzf2_o_rgb[4] ,
    \trzf2_o_rgb[3] ,
    \trzf2_o_rgb[2] ,
    \trzf2_o_rgb[1] ,
    \trzf2_o_rgb[0] }),
    .trzf_io_in({\trzf_io_in[37] ,
    \trzf_io_in[36] ,
    \trzf_io_in[35] ,
    \trzf_io_in[34] ,
    \trzf_io_in[33] ,
    \trzf_io_in[32] ,
    \trzf_io_in[31] ,
    \trzf_io_in[30] ,
    \trzf_io_in[29] ,
    \trzf_io_in[28] ,
    \trzf_io_in[27] ,
    \trzf_io_in[26] ,
    \trzf_io_in[25] ,
    \trzf_io_in[24] ,
    \trzf_io_in[23] ,
    \trzf_io_in[22] ,
    \trzf_io_in[21] ,
    \trzf_io_in[20] ,
    \trzf_io_in[19] ,
    \trzf_io_in[18] ,
    \trzf_io_in[17] ,
    \trzf_io_in[16] ,
    \trzf_io_in[15] ,
    \trzf_io_in[14] ,
    \trzf_io_in[13] ,
    \trzf_io_in[12] ,
    \trzf_io_in[11] ,
    \trzf_io_in[10] ,
    \trzf_io_in[9] ,
    \trzf_io_in[8] ,
    \trzf_io_in[7] ,
    \trzf_io_in[6] ,
    \trzf_io_in[5] ,
    \trzf_io_in[4] ,
    \trzf_io_in[3] ,
    \trzf_io_in[2] ,
    \trzf_io_in[1] ,
    \trzf_io_in[0] }),
    .trzf_la_in({\trzf_la_in[12] ,
    \trzf_la_in[11] ,
    \trzf_la_in[10] ,
    \trzf_la_in[9] ,
    \trzf_la_in[8] ,
    \trzf_la_in[7] ,
    \trzf_la_in[6] ,
    \trzf_la_in[5] ,
    \trzf_la_in[4] ,
    \trzf_la_in[3] ,
    \trzf_la_in[2] ,
    \trzf_la_in[1] ,
    \trzf_la_in[0] }),
    .trzf_o_gpout({\trzf_o_gpout[2] ,
    \trzf_o_gpout[1] ,
    \trzf_o_gpout[0] }),
    .trzf_o_rgb({\trzf_o_rgb[5] ,
    \trzf_o_rgb[4] ,
    \trzf_o_rgb[3] ,
    \trzf_o_rgb[2] ,
    \trzf_o_rgb[1] ,
    \trzf_o_rgb[0] }),
    .uri_io_in({\uri_io_in[37] ,
    \uri_io_in[36] ,
    \uri_io_in[35] ,
    \uri_io_in[34] ,
    \uri_io_in[33] ,
    \uri_io_in[32] ,
    \uri_io_in[31] ,
    \uri_io_in[30] ,
    \uri_io_in[29] ,
    \uri_io_in[28] ,
    \uri_io_in[27] ,
    \uri_io_in[26] ,
    \uri_io_in[25] ,
    \uri_io_in[24] ,
    \uri_io_in[23] ,
    \uri_io_in[22] ,
    \uri_io_in[21] ,
    \uri_io_in[20] ,
    \uri_io_in[19] ,
    \uri_io_in[18] ,
    \uri_io_in[17] ,
    \uri_io_in[16] ,
    \uri_io_in[15] ,
    \uri_io_in[14] ,
    \uri_io_in[13] ,
    \uri_io_in[12] ,
    \uri_io_in[11] ,
    \uri_io_in[10] ,
    \uri_io_in[9] ,
    \uri_io_in[8] ,
    \uri_io_in[7] ,
    \uri_io_in[6] ,
    \uri_io_in[5] ,
    \uri_io_in[4] ,
    \uri_io_in[3] ,
    \uri_io_in[2] ,
    \uri_io_in[1] ,
    \uri_io_in[0] }),
    .uri_io_oeb({\uri_io_oeb[26] ,
    \uri_io_oeb[25] ,
    \uri_io_oeb[24] ,
    \uri_io_oeb[23] ,
    \uri_io_oeb[22] ,
    \uri_io_oeb[21] ,
    \uri_io_oeb[20] ,
    \uri_io_oeb[19] ,
    \uri_io_oeb[18] ,
    \uri_io_oeb[17] ,
    \uri_io_oeb[16] ,
    \uri_io_oeb[15] ,
    \uri_io_oeb[14] ,
    \uri_io_oeb[13] ,
    \uri_io_oeb[12] ,
    \uri_io_oeb[11] ,
    \uri_io_oeb[10] ,
    \uri_io_oeb[9] ,
    \uri_io_oeb[8] }),
    .uri_io_out({\uri_io_out[26] ,
    \uri_io_out[25] ,
    \uri_io_out[24] ,
    \uri_io_out[23] ,
    \uri_io_out[22] ,
    \uri_io_out[21] ,
    \uri_io_out[20] ,
    \uri_io_out[19] ,
    \uri_io_out[18] ,
    \uri_io_out[17] ,
    \uri_io_out[16] ,
    \uri_io_out[15] ,
    \uri_io_out[14] ,
    \uri_io_out[13] ,
    \uri_io_out[12] ,
    \uri_io_out[11] ,
    \uri_io_out[10] ,
    \uri_io_out[9] ,
    \uri_io_out[8] }),
    .vgasp_io_in({_NC52,
    _NC53,
    _NC54,
    _NC55,
    _NC56,
    _NC57,
    _NC58,
    _NC59,
    _NC60,
    _NC61,
    _NC62,
    _NC63,
    _NC64,
    _NC65,
    _NC66,
    _NC67,
    _NC68,
    _NC69,
    _NC70,
    _NC71,
    _NC72,
    _NC73,
    _NC74,
    _NC75,
    _NC76,
    _NC77,
    _NC78,
    _NC79,
    _NC80,
    _NC81,
    _NC82,
    _NC83,
    _NC84,
    _NC85,
    _NC86,
    _NC87,
    _NC88,
    _NC89}),
    .vgasp_uio_oe({_NC90,
    _NC91,
    _NC92,
    _NC93,
    _NC94,
    _NC95,
    _NC96,
    _NC97}),
    .vgasp_uio_out({_NC98,
    _NC99,
    _NC100,
    _NC101,
    _NC102,
    _NC103,
    _NC104,
    _NC105}),
    .vgasp_uo_out({_NC106,
    _NC107,
    _NC108,
    _NC109,
    _NC110,
    _NC111,
    _NC112,
    _NC113}));
 top_raybox_zero_fsm top_raybox_zero_fsm (.i_clk(trzf_clk),
    .i_debug_map_overlay(\trzf_io_in[29] ),
    .i_debug_trace_overlay(\trzf_io_in[30] ),
    .i_debug_vec_overlay(\trzf_io_in[28] ),
    .i_reg_csb(\trzf_io_in[25] ),
    .i_reg_mosi(\trzf_io_in[27] ),
    .i_reg_outs_enb(\trzf_io_in[31] ),
    .i_reg_sclk(\trzf_io_in[26] ),
    .i_reset(trzf_rst),
    .i_vec_csb(\trzf_io_in[22] ),
    .i_vec_mosi(\trzf_io_in[24] ),
    .i_vec_sclk(\trzf_io_in[23] ),
    .o_hsync(trzf_o_hsync),
    .o_tex_csb(trzf_o_tex_csb),
    .o_tex_oeb0(trzf_o_tex_oeb0),
    .o_tex_out0(trzf_o_tex_out0),
    .o_tex_sclk(trzf_o_tex_sclk),
    .o_vsync(trzf_o_vsync),
    .vdd(vdd),
    .vss(vss),
    .i_gpout0_sel({\trzf_la_in[4] ,
    \trzf_la_in[3] ,
    \trzf_la_in[2] ,
    \trzf_la_in[1] }),
    .i_gpout1_sel({\trzf_la_in[8] ,
    \trzf_la_in[7] ,
    \trzf_la_in[6] ,
    \trzf_la_in[5] }),
    .i_gpout2_sel({\trzf_la_in[12] ,
    \trzf_la_in[11] ,
    \trzf_la_in[10] ,
    \trzf_la_in[9] }),
    .i_mode({\trzf_io_in[34] ,
    \trzf_io_in[33] ,
    \trzf_io_in[32] }),
    .i_tex_in({\trzf_io_in[21] ,
    \trzf_io_in[20] ,
    \trzf_io_in[19] ,
    \trzf_io_in[18] }),
    .o_gpout({\trzf_o_gpout[2] ,
    \trzf_o_gpout[1] ,
    \trzf_o_gpout[0] }),
    .o_rgb({\trzf_o_rgb[5] ,
    \trzf_o_rgb[4] ,
    \trzf_o_rgb[3] ,
    \trzf_o_rgb[2] ,
    \trzf_o_rgb[1] ,
    \trzf_o_rgb[0] }));
 top_raybox_zero_fsm top_raybox_zero_fsm2 (.i_clk(trzf2_clk),
    .i_debug_map_overlay(\trzf2_io_in[29] ),
    .i_debug_trace_overlay(\trzf2_io_in[30] ),
    .i_debug_vec_overlay(\trzf2_io_in[28] ),
    .i_reg_csb(\trzf2_io_in[25] ),
    .i_reg_mosi(\trzf2_io_in[27] ),
    .i_reg_outs_enb(\trzf2_io_in[31] ),
    .i_reg_sclk(\trzf2_io_in[26] ),
    .i_reset(trzf2_rst),
    .i_vec_csb(\trzf2_io_in[22] ),
    .i_vec_mosi(\trzf2_io_in[24] ),
    .i_vec_sclk(\trzf2_io_in[23] ),
    .o_hsync(trzf2_o_hsync),
    .o_tex_csb(trzf2_o_tex_csb),
    .o_tex_oeb0(trzf2_o_tex_oeb0),
    .o_tex_out0(trzf2_o_tex_out0),
    .o_tex_sclk(trzf2_o_tex_sclk),
    .o_vsync(trzf2_o_vsync),
    .vdd(vdd),
    .vss(vss),
    .i_gpout0_sel({\trzf2_la_in[4] ,
    \trzf2_la_in[3] ,
    \trzf2_la_in[2] ,
    \trzf2_la_in[1] }),
    .i_gpout1_sel({\trzf2_la_in[8] ,
    \trzf2_la_in[7] ,
    \trzf2_la_in[6] ,
    \trzf2_la_in[5] }),
    .i_gpout2_sel({\trzf2_la_in[12] ,
    \trzf2_la_in[11] ,
    \trzf2_la_in[10] ,
    \trzf2_la_in[9] }),
    .i_mode({\trzf2_io_in[34] ,
    \trzf2_io_in[33] ,
    \trzf2_io_in[32] }),
    .i_tex_in({\trzf2_io_in[21] ,
    \trzf2_io_in[20] ,
    \trzf2_io_in[19] ,
    \trzf2_io_in[18] }),
    .o_gpout({\trzf2_o_gpout[2] ,
    \trzf2_o_gpout[1] ,
    \trzf2_o_gpout[0] }),
    .o_rgb({\trzf2_o_rgb[5] ,
    \trzf2_o_rgb[4] ,
    \trzf2_o_rgb[3] ,
    \trzf2_o_rgb[2] ,
    \trzf2_o_rgb[1] ,
    \trzf2_o_rgb[0] }));
 urish_simon_says urish_simon_says (.vdd(vdd),
    .vss(vss),
    .wb_clk_i(uri_clk),
    .wb_rst_i(uri_rst),
    .io_in({\uri_io_in[37] ,
    \uri_io_in[36] ,
    \uri_io_in[35] ,
    \uri_io_in[34] ,
    \uri_io_in[33] ,
    \uri_io_in[32] ,
    \uri_io_in[31] ,
    \uri_io_in[30] ,
    \uri_io_in[29] ,
    \uri_io_in[28] ,
    \uri_io_in[27] ,
    \uri_io_in[26] ,
    \uri_io_in[25] ,
    \uri_io_in[24] ,
    \uri_io_in[23] ,
    \uri_io_in[22] ,
    \uri_io_in[21] ,
    \uri_io_in[20] ,
    \uri_io_in[19] ,
    \uri_io_in[18] ,
    \uri_io_in[17] ,
    \uri_io_in[16] ,
    \uri_io_in[15] ,
    \uri_io_in[14] ,
    \uri_io_in[13] ,
    \uri_io_in[12] ,
    \uri_io_in[11] ,
    \uri_io_in[10] ,
    \uri_io_in[9] ,
    \uri_io_in[8] ,
    \uri_io_in[7] ,
    \uri_io_in[6] ,
    \uri_io_in[5] ,
    \uri_io_in[4] ,
    \uri_io_in[3] ,
    \uri_io_in[2] ,
    \uri_io_in[1] ,
    \uri_io_in[0] }),
    .io_oeb({\uri_io_oeb[37] ,
    \uri_io_oeb[36] ,
    \uri_io_oeb[35] ,
    \uri_io_oeb[34] ,
    \uri_io_oeb[33] ,
    \uri_io_oeb[32] ,
    \uri_io_oeb[31] ,
    \uri_io_oeb[30] ,
    \uri_io_oeb[29] ,
    \uri_io_oeb[28] ,
    \uri_io_oeb[27] ,
    \uri_io_oeb[26] ,
    \uri_io_oeb[25] ,
    \uri_io_oeb[24] ,
    \uri_io_oeb[23] ,
    \uri_io_oeb[22] ,
    \uri_io_oeb[21] ,
    \uri_io_oeb[20] ,
    \uri_io_oeb[19] ,
    \uri_io_oeb[18] ,
    \uri_io_oeb[17] ,
    \uri_io_oeb[16] ,
    \uri_io_oeb[15] ,
    \uri_io_oeb[14] ,
    \uri_io_oeb[13] ,
    \uri_io_oeb[12] ,
    \uri_io_oeb[11] ,
    \uri_io_oeb[10] ,
    \uri_io_oeb[9] ,
    \uri_io_oeb[8] ,
    \uri_io_oeb[7] ,
    \uri_io_oeb[6] ,
    \uri_io_oeb[5] ,
    \uri_io_oeb[4] ,
    \uri_io_oeb[3] ,
    \uri_io_oeb[2] ,
    \uri_io_oeb[1] ,
    \uri_io_oeb[0] }),
    .io_out({\uri_io_out[37] ,
    \uri_io_out[36] ,
    \uri_io_out[35] ,
    \uri_io_out[34] ,
    \uri_io_out[33] ,
    \uri_io_out[32] ,
    \uri_io_out[31] ,
    \uri_io_out[30] ,
    \uri_io_out[29] ,
    \uri_io_out[28] ,
    \uri_io_out[27] ,
    \uri_io_out[26] ,
    \uri_io_out[25] ,
    \uri_io_out[24] ,
    \uri_io_out[23] ,
    \uri_io_out[22] ,
    \uri_io_out[21] ,
    \uri_io_out[20] ,
    \uri_io_out[19] ,
    \uri_io_out[18] ,
    \uri_io_out[17] ,
    \uri_io_out[16] ,
    \uri_io_out[15] ,
    \uri_io_out[14] ,
    \uri_io_out[13] ,
    \uri_io_out[12] ,
    \uri_io_out[11] ,
    \uri_io_out[10] ,
    \uri_io_out[9] ,
    \uri_io_out[8] ,
    \uri_io_out[7] ,
    \uri_io_out[6] ,
    \uri_io_out[5] ,
    \uri_io_out[4] ,
    \uri_io_out[3] ,
    \uri_io_out[2] ,
    \uri_io_out[1] ,
    \uri_io_out[0] }));
 user_proj_cpu user_proj_cpu (.vdd(vdd),
    .vss(vss),
    .wb_clk_i(diego_clk),
    .io_in({\diego_io_in_all38[37] ,
    \diego_io_in_all38[36] ,
    \diego_io_in_all38[35] ,
    \diego_io_in_all38[34] ,
    \diego_io_in_all38[33] ,
    \diego_io_in_all38[32] ,
    \diego_io_in_all38[31] ,
    \diego_io_in_all38[30] ,
    \diego_io_in_all38[29] ,
    \diego_io_in_all38[28] ,
    \diego_io_in_all38[27] ,
    \diego_io_in_all38[26] ,
    \diego_io_in_all38[25] ,
    \diego_io_in_all38[24] ,
    \diego_io_in_all38[23] ,
    \diego_io_in_all38[22] ,
    \diego_io_in_all38[21] ,
    \diego_io_in_all38[20] ,
    \diego_io_in_all38[19] ,
    \diego_io_in_all38[18] ,
    \diego_io_in_all38[17] ,
    \diego_io_in_all38[16] ,
    \diego_io_in_all38[15] ,
    \diego_io_in_all38[14] ,
    \diego_io_in_all38[13] ,
    \diego_io_in_all38[12] ,
    \diego_io_in_all38[11] ,
    \diego_io_in_all38[10] ,
    \diego_io_in_all38[9] ,
    \diego_io_in_all38[8] ,
    \diego_io_in_all38[7] ,
    \diego_io_in_all38[6] }),
    .io_oeb({\diego_io_oeb[31] ,
    \diego_io_oeb[30] ,
    \diego_io_oeb[29] ,
    \diego_io_oeb[28] ,
    \diego_io_oeb[27] ,
    \diego_io_oeb[26] ,
    \diego_io_oeb[25] ,
    \diego_io_oeb[24] ,
    \diego_io_oeb[23] ,
    \diego_io_oeb[22] ,
    \diego_io_oeb[21] ,
    \diego_io_oeb[20] ,
    \diego_io_oeb[19] ,
    \diego_io_oeb[18] ,
    \diego_io_oeb[17] ,
    \diego_io_oeb[16] ,
    \diego_io_oeb[15] ,
    \diego_io_oeb[14] ,
    \diego_io_oeb[13] ,
    \diego_io_oeb[12] ,
    \diego_io_oeb[11] ,
    \diego_io_oeb[10] ,
    \diego_io_oeb[9] ,
    \diego_io_oeb[8] ,
    \diego_io_oeb[7] ,
    \diego_io_oeb[6] ,
    \diego_io_oeb[5] ,
    \diego_io_oeb[4] ,
    \diego_io_oeb[3] ,
    \diego_io_oeb[2] ,
    \diego_io_oeb[1] ,
    \diego_io_oeb[0] }),
    .io_out({\diego_io_out[31] ,
    \diego_io_out[30] ,
    \diego_io_out[29] ,
    \diego_io_out[28] ,
    \diego_io_out[27] ,
    \diego_io_out[26] ,
    \diego_io_out[25] ,
    \diego_io_out[24] ,
    \diego_io_out[23] ,
    \diego_io_out[22] ,
    \diego_io_out[21] ,
    \diego_io_out[20] ,
    \diego_io_out[19] ,
    \diego_io_out[18] ,
    \diego_io_out[17] ,
    \diego_io_out[16] ,
    \diego_io_out[15] ,
    \diego_io_out[14] ,
    \diego_io_out[13] ,
    \diego_io_out[12] ,
    \diego_io_out[11] ,
    \diego_io_out[10] ,
    \diego_io_out[9] ,
    \diego_io_out[8] ,
    \diego_io_out[7] ,
    \diego_io_out[6] ,
    \diego_io_out[5] ,
    \diego_io_out[4] ,
    \diego_io_out[3] ,
    \diego_io_out[2] ,
    \diego_io_out[1] ,
    \diego_io_out[0] }));
 wrapped_wb_hyperram wrapped_wb_hyperram (.rst_i(pawel_mux_rst),
    .vdd(vdd),
    .vss(vss),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .io_in({\pawel_io_in_all38[37] ,
    \pawel_io_in_all38[36] ,
    \pawel_io_in_all38[35] ,
    \pawel_io_in_all38[34] ,
    \pawel_io_in_all38[33] ,
    \pawel_io_in_all38[32] ,
    \pawel_io_in_all38[31] ,
    \pawel_io_in_all38[30] ,
    \pawel_io_in_all38[29] ,
    \pawel_io_in_all38[28] ,
    \pawel_io_in_all38[27] ,
    \pawel_io_in_all38[26] ,
    \pawel_io_in_all38[25] }),
    .io_oeb({\pawel_io_oeb[12] ,
    \pawel_io_oeb[11] ,
    \pawel_io_oeb[10] ,
    \pawel_io_oeb[9] ,
    \pawel_io_oeb[8] ,
    \pawel_io_oeb[7] ,
    \pawel_io_oeb[6] ,
    \pawel_io_oeb[5] ,
    \pawel_io_oeb[4] ,
    \pawel_io_oeb[3] ,
    \pawel_io_oeb[2] ,
    \pawel_io_oeb[1] ,
    \pawel_io_oeb[0] }),
    .io_out({\pawel_io_out[12] ,
    \pawel_io_out[11] ,
    \pawel_io_out[10] ,
    \pawel_io_out[9] ,
    \pawel_io_out[8] ,
    \pawel_io_out[7] ,
    \pawel_io_out[6] ,
    \pawel_io_out[5] ,
    \pawel_io_out[4] ,
    \pawel_io_out[3] ,
    \pawel_io_out[2] ,
    \pawel_io_out[1] ,
    \pawel_io_out[0] }),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_dat_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wbs_sel_i({wbs_sel_i[3],
    wbs_sel_i[2],
    wbs_sel_i[1],
    wbs_sel_i[0]}));
endmodule
