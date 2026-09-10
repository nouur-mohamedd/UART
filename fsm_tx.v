module fsm_tx (
    input wire clk,
    input wire rst_n,
    input wire PAR_EN,
    input wire ser_done,
    input wire DATA_VALID,
    output reg ser_en,
    output reg [1:0] mux_sel,
    output reg busy
);

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter PARITY = 3'b011;
    parameter STOP = 3'b100;

    reg [2:0] cs, ns;

    //state register
    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) cs <= IDLE;
        else cs <= ns;
    end

    //next state
    always @ (*) begin 
        case (cs)
            IDLE : begin 
                if (DATA_VALID) ns = START;
                else ns = IDLE;
            end

            START : ns = DATA;

            DATA : begin 
                if (!ser_done) ns = DATA;
                else begin 
                    if (PAR_EN) ns = PARITY;
                    else ns = STOP;
                end
            end

            PARITY : ns = STOP;

            STOP : ns = IDLE;

            default : ns = IDLE;
        endcase
    end

    //output logic
    always @ (*) begin 
        case (cs)
            IDLE : begin 
                ser_en = 'b0;
                mux_sel = 'b01;
                busy = 'b0;
            end

            START : begin 
                ser_en = 'b1;
                mux_sel = 'b00;
                busy = 'b1;
            end
            
            DATA : begin 
                ser_en = 'b0;
                mux_sel = 'b10;
                busy = 'b1;
            end

            PARITY : begin 
                ser_en = 'b0;
                mux_sel = 'b11;
                busy = 'b1;
            end

            STOP : begin 
                ser_en = 'b0;
                mux_sel = 'b01;
                busy = 'b1;
            end

            default : begin 
                ser_en = 'b0;
                mux_sel = 'b01;
                busy = 'b0;
            end
        endcase
    end


endmodule