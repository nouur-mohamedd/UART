module check #(parameter expected_bit = 0)(
    input wire clk,
    input wire rst_n,
    input wire chk_en,
    input wire sampled_bit,
    output reg flag
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) flag <= 'd0;
        else begin 
            if (chk_en) begin 
                if (sampled_bit == expected_bit) flag <= 'd0;
                else flag <= 'd1;
            end

            else flag <= 'd0;
        end
    end


endmodule