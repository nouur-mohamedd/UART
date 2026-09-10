module edge_bit_counter (
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg [3:0] bit_cnt,
    output reg [2:0] edge_cnt
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            bit_cnt <= 'd0;
            edge_cnt <= 'd0;
        end

        else begin 
            if (enable) begin
                if (edge_cnt == 7) begin 
                    edge_cnt <= 'd0;
                    bit_cnt <= bit_cnt + 1;
                end
                
                else edge_cnt <= edge_cnt + 1;
            end
            
            else begin 
                bit_cnt <= 'd0;
                edge_cnt <= 'd0;
            end
        end
    end



endmodule