module tx #(parameter WIDTH = 8)(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH - 1 : 0] P_DATA,
    input wire DATA_VALID,
    input wire PAR_EN,
    input wire PAR_TYP,
    output wire TX_OUT,
    output wire busy
);

    wire ser_done, ser_en, par_bit, ser_data;
    wire [1:0] mux_sel;

    //tool ma busy=1 stay on the same old data
    wire accepted_DATA_VALID;
    assign accepted_DATA_VALID = DATA_VALID && !busy;

    reg [WIDTH - 1:0] P_DATA_reg;
    always @ (posedge clk or negedge rst_n) begin 
        if (!rst_n) P_DATA_reg <= 'b0;
        else begin 
            if (DATA_VALID && !busy) P_DATA_reg <= P_DATA;
        end
    end


    serializer #(.WIDTH(WIDTH)) u1 (
        .clk(clk),
        .rst_n(rst_n),
        .P_DATA(P_DATA_reg),
        .ser_en(ser_en),
        .ser_data(ser_data),
        .ser_done (ser_done)
    );


    fsm_tx u2 (
        .PAR_EN(PAR_EN),
        .DATA_VALID(accepted_DATA_VALID),
        .ser_done(ser_done),
        .clk(clk),
        .rst_n(rst_n),
        .mux_sel(mux_sel),
        .ser_en(ser_en),
        .busy(busy)
    );

    parity_calc #(.WIDTH(WIDTH)) u3 (
        .P_DATA(P_DATA),
        .DATA_VALID(accepted_DATA_VALID),
        .PAR_TYP(PAR_TYP),
        .clk(clk),
        .rst_n(rst_n),
        .par_bit(par_bit)
    );

    mux u4 (
        .start_bit(1'b0),
        .stop_bit(1'b1),
        .ser_data(ser_data),
        .par_bit(par_bit),
        .mux_sel(mux_sel),
        .TX_OUT(TX_OUT)
    );

endmodule