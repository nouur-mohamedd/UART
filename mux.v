module mux (
    input wire start_bit,
    input wire stop_bit,
    input wire ser_data,
    input wire par_bit,
    input wire [1:0] mux_sel,
    output reg TX_OUT
);

    always @ (*) begin 
        case (mux_sel)
            'b00 : TX_OUT = start_bit;
            'b01 : TX_OUT = stop_bit;
            'b10 : TX_OUT = ser_data;
            'b11 : TX_OUT = par_bit;
            default : TX_OUT = stop_bit;
        endcase
    end
endmodule