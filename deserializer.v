module deserializer #(parameter WIDTH = 8)(
    input wire clk,
    input wire rst_n,
    input wire sampled_bit,
    input wire deser_en,
    output reg [WIDTH - 1 : 0] P_DATA
);

    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) P_DATA <= 'd0;
        else begin 
            if (deser_en) P_DATA <= {P_DATA[WIDTH - 2 : 0], sampled_bit};
        end
    end

endmodule


