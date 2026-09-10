module fsm_rx (
    input wire clk,
    input wire rst_n,
    input wire RX_IN,
    input wire [2:0] edge_cnt,
    input wire [3:0] bit_cnt,
    input wire PAR_EN,
    input wire par_err,
    input wire strt_glitch,
    input wire stp_err,
    output reg dat_samp_en,
    output reg enable,
    output reg par_chk_en,
    output reg strt_chk_en,
    output reg stp_chk_en,
    output reg deser_en,
    output reg DATA_VALID
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
                if (!RX_IN) ns = START;
                else ns = IDLE;
            end

            START : begin 
                if (strt_glitch) ns = IDLE;
                else if (edge_cnt == 'd7) ns = DATA;
                else ns = START;
            end

            DATA : begin 
                if ((bit_cnt == 'd8) && (edge_cnt == 'd7)) begin 
                    if (PAR_EN) ns = PARITY;
                    else ns = STOP;
                end
                else ns = DATA;
            end

            PARITY : begin 
                if (par_err) ns = IDLE;
                else if (edge_cnt == 'd7) ns = STOP;
                else ns = PARITY;
            end

            STOP : begin 
                if (stp_err) ns = IDLE;
                else if (edge_cnt == 'd7) ns = IDLE;
                else ns = STOP;
            end
            
            default : ns = IDLE;
        endcase
     end

    //output logic
    always @ (*) begin 
        case (cs)
            IDLE: begin 
                dat_samp_en = 'd0;
                enable = 'd0;
                par_chk_en = 'd0;
                strt_chk_en = 'd0;
                stp_chk_en = 'd0;
                deser_en = 'd0;
                DATA_VALID = 'd0;
            end

            START: begin 
                dat_samp_en = 'd1;
                enable = 'd1;
                par_chk_en = 'd0;

                if (edge_cnt == 'd5) strt_chk_en = 'd1;
                else strt_chk_en = 'd0;

                stp_chk_en = 'd0;
                deser_en = 'd0;
                DATA_VALID = 'd0;
            end

            DATA: begin 
                dat_samp_en = 'd1;
                enable = 'd1;
                par_chk_en = 'd0;
                strt_chk_en = 'd0;
                stp_chk_en = 'd0;

                if (edge_cnt == 'd5) deser_en = 'd1;
                else deser_en = 'd0;

                DATA_VALID = 'd0;
            end


            PARITY: begin 
                dat_samp_en = 'd1;
                enable = 'd1;

                if (edge_cnt == 'd5) par_chk_en = 'd1;
                else par_chk_en = 'd0;

                strt_chk_en = 'd0;
                stp_chk_en = 'd0;
                deser_en = 'd0;
                DATA_VALID = 'd0;
            end

            STOP : begin 
                dat_samp_en = 'd1;
                enable = 'd1;
                par_chk_en = 'd0;
                strt_chk_en = 'd0;

                if (edge_cnt == 'd5) stp_chk_en = 'd1;
                else stp_chk_en = 'd0;

                deser_en = 'd0;

                if ((edge_cnt == 'd6) && (!stp_err) && (!par_err)) DATA_VALID = 'd1;
                else DATA_VALID = 'd0;

            end

            default : begin 
                dat_samp_en = 'd0;
                enable = 'd0;
                par_chk_en = 'd0;
                strt_chk_en = 'd0;
                stp_chk_en = 'd0;
                deser_en = 'd0;
                DATA_VALID = 'd0;
            end

        endcase
    end

endmodule