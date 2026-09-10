module parity_calc #(parameter WIDTH = 8) (
    input wire [WIDTH - 1 : 0] P_DATA,
    input wire DATA_VALID,
    input wire PAR_TYP,
    input wire clk,
    input wire rst_n,
    output reg par_bit
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) par_bit <= 'b0;

        else begin
            if (DATA_VALID) begin 
                if (!PAR_TYP) par_bit <= ^ P_DATA;
                else par_bit <= ~^ P_DATA;
            end
            else par_bit <= par_bit;
        end
        
    end


endmodule