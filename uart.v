module uart #(
    parameter WIDTH = 8,
    parameter prescale = 8
)(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] P_DATA,
    input wire DATA_VALID,
    input wire PAR_EN,
    input wire PAR_TYP,
    output wire TX_OUT,
    output wire busy,
    output wire [WIDTH-1:0] RX_P_DATA,
    output wire RX_DATA_VALID
);

    
    reg [2:0] div_cnt;
    reg tx_clk;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt <= 'd0;
            tx_clk <= 'b0;
        end
        else begin
            if (div_cnt == 'd3) begin
                div_cnt <= 'd0;
                tx_clk <= ~tx_clk;
            end
            
            else div_cnt <= div_cnt + 1'b1;
        end
    end

    tx #(.WIDTH(WIDTH)) u1 (
        .clk(tx_clk),
        .rst_n(rst_n),
        .P_DATA(P_DATA),
        .DATA_VALID(DATA_VALID),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .TX_OUT(TX_OUT),
        .busy(busy)
    );

    rx #(.WIDTH(WIDTH), .prescale(prescale)) u2 (
        .RX_IN(TX_OUT),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .clk(clk),
        .rst_n(rst_n),
        .P_DATA(RX_P_DATA),
        .DATA_VALID(RX_DATA_VALID)
    );

endmodule