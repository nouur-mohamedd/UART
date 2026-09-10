module rx #(parameter prescale = 8, WIDTH = 8)(
    input wire RX_IN,
    input wire PAR_EN,
    input wire PAR_TYP,
    input wire clk,
    input wire rst_n,
    output wire [WIDTH - 1 : 0] P_DATA,
    output wire DATA_VALID
);

    wire dat_samp_en, enable, deser_en, strt_chk_en, stp_chk_en, par_chk_en;
    wire par_err, strt_glitch, stp_err;
    wire sampled_bit;
    wire [2:0] edge_cnt; 
    wire [3:0] bit_cnt;

    edge_bit_counter u1 (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .bit_cnt(bit_cnt),
        .edge_cnt (edge_cnt)
    );

    sampler u2 (
        .clk(clk),
        .rst_n(rst_n),
        .prescale(prescale),
        .RX_IN(RX_IN),
        .dat_samp_en(dat_samp_en),
        .edge_cnt(edge_cnt),
        .sampled_bit(sampled_bit)
    );

    deserializer #(.WIDTH(WIDTH)) u3 (
        .clk(clk),
        .rst_n(rst_n),
        .sampled_bit(sampled_bit),
        .deser_en(deser_en),
        .P_DATA(P_DATA)
    );

    check #(.expected_bit(1'b0)) u4 (
        .clk(clk),
        .rst_n(rst_n),
        .chk_en(strt_chk_en),
        .sampled_bit(sampled_bit),
        .flag(strt_glitch)
    );

    check #(.expected_bit(1'b1)) u5 (
        .clk(clk),
        .rst_n(rst_n),
        .chk_en(stp_chk_en),
        .sampled_bit(sampled_bit),
        .flag(stp_err)
    );

    parity_check #(.WIDTH(WIDTH)) u6 (
        .clk(clk),
        .rst_n(rst_n),
        .PAR_TYP(PAR_TYP),
        .par_chk_en(par_chk_en),
        .sampled_bit(sampled_bit),
        .P_DATA(P_DATA),
        .par_err(par_err)
    );

    fsm_rx u7 (
        .clk(clk),
        .rst_n(rst_n),
        .RX_IN(RX_IN),
        .edge_cnt(edge_cnt),
        .bit_cnt(bit_cnt),
        .PAR_EN(PAR_EN),
        .par_err(par_err),
        .strt_glitch(strt_glitch),
        .stp_err(stp_err),
        .dat_samp_en(dat_samp_en),
        .enable(enable),
        .par_chk_en(par_chk_en),
        .strt_chk_en(strt_chk_en),
        .stp_chk_en(stp_chk_en),
        .deser_en(deser_en),
        .DATA_VALID(DATA_VALID)
    );


endmodule