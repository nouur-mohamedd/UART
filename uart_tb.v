module uart_tb;
    parameter WIDTH = 8;
    parameter prescale = 8;

    reg clk;
    reg rst_n;
    reg [WIDTH-1:0] P_DATA;
    reg DATA_VALID;
    reg PAR_EN;
    reg PAR_TYP;
    wire TX_OUT;
    wire busy;
    wire [WIDTH-1:0] RX_P_DATA;
    wire RX_DATA_VALID;

    uart #(.WIDTH(WIDTH), .prescale(prescale)) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .P_DATA(P_DATA),
        .DATA_VALID(DATA_VALID),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .TX_OUT(TX_OUT),
        .busy(busy),
        .RX_P_DATA(RX_P_DATA),
        .RX_DATA_VALID(RX_DATA_VALID)
    );

    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end

    initial begin
        rst_n = 'b0;
        P_DATA = 'b0;
        DATA_VALID = 'b0;
        PAR_EN = 'b0;
        PAR_TYP = 'b0;

        repeat(2) @(negedge clk);
        rst_n = 'b1;


        //test1 (par_en = 0)
        repeat(2) @(negedge clk);
        $display ("TEST 1 : PAR_EN = 0");

        P_DATA = 'b10010011;
        DATA_VALID = 'b1;

        @(negedge DUT.tx_clk);
        DATA_VALID = 'b0;

        @(posedge RX_DATA_VALID);
        $display ("TX_DATA = %b, RX_DATA = %b", P_DATA, RX_P_DATA);

        if (RX_P_DATA == 8'b10010011) $display("TEST 1 PASS");
        else $display("TEST 1 FAIL");

        wait (busy == 'b0);


        //test2 (data valid while busy)
        repeat(2) @(negedge clk);
        $display("TEST 2 : DATA_VALID while busy");

        PAR_EN = 'b1;
        PAR_TYP = 'b0;
        P_DATA = 'b10100101;
        DATA_VALID = 'b1;

        @(posedge DUT.tx_clk);
        DATA_VALID = 'b0;

        wait (busy == 'b1);

        P_DATA = 8'b00111100;
        DATA_VALID = 'b1;

        @(posedge DUT.tx_clk);
        DATA_VALID = 'b0;

        @(posedge RX_DATA_VALID);
        $display("EXPECTED DATA = %b, RX_DATA = %b", 8'b10100101, RX_P_DATA);

        if (RX_P_DATA == 8'b10100101) $display("TEST 2 PASS");
        else $display("TEST 2 FAIL");


        wait(busy == 'b0);



    
        // test3 : ODD PARITY
        repeat(2) @(negedge clk);
        $display("TEST 3 : ODD PARITY");

        PAR_EN = 'b1;
        PAR_TYP = 'b1;
        P_DATA = 'b11100110;
        DATA_VALID = 'b1;

        @(posedge DUT.tx_clk);
        DATA_VALID = 'b0;

        @(posedge RX_DATA_VALID);
        $display("TX_DATA = %b, RX_DATA = %b", 8'b11100110, RX_P_DATA);

        if (RX_P_DATA == 8'b11100110) $display("TEST 3 PASS");
        else $display("TEST 3 FAIL");

        $stop;
    end

endmodule