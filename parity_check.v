module parity_check #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst_n,
    input wire PAR_TYP,
    input wire par_chk_en,
    input wire sampled_bit,
    input wire [WIDTH - 1 : 0] P_DATA,
    output reg par_err
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) par_err <= 'd0;
        
        else begin 
            if (par_chk_en) begin 
                if (!PAR_TYP) begin
                    if (sampled_bit == ^P_DATA) par_err <= 'd0;
                    else par_err <= 'd1;
                end 
                else begin 
                    if (sampled_bit == ~^P_DATA) par_err <= 'd0;
                    else par_err <= 'd1;
                end
            end

            else par_err <= 'd0;
        end
    end

endmodule