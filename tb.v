module tb ();
    reg clk;
    reg rst_n;
    reg [7:0] P_DATA;
    reg DATA_VALID;
    wire TX_OUT;
    wire busy;

    tx #(.WIDTH(8)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .P_DATA (P_DATA),
        .DATA_VALID(DATA_VALID),
        .PAR_EN(1'b1),
        .PAR_TYP(1'b0),
        .TX_OUT(TX_OUT),
        .busy(busy)
    );

    initial begin 
        clk = 0;
        forever #2.5 clk = ~clk;
    end

    initial begin 
        rst_n = 'b0;
        P_DATA = 'd0;
        DATA_VALID = 'd0;

        repeat (2) @(negedge clk);
        rst_n = 'd1;

        repeat (2) @(negedge clk);
        P_DATA = 8'b11100111;
        DATA_VALID = 1'd1;
        
        repeat (2) @(negedge clk);
        P_DATA = 8'b00000100;


        repeat (30) @ (negedge clk);

        $stop;
    end


endmodule