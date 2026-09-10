module sampler (
    input wire clk,
    input wire rst_n,
    input wire [3:0] prescale,
    input wire RX_IN,
    input wire dat_samp_en,
    input wire [2:0] edge_cnt,
    output reg sampled_bit
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) sampled_bit <= 'd0;
        else begin 
            if (dat_samp_en) begin 
                if (edge_cnt == (prescale / 2)) sampled_bit <= RX_IN;
            end
            else sampled_bit <= 'd0;
        end
    end

endmodule