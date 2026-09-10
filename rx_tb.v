module rx_tb;
    parameter WIDTH = 8;
    parameter prescale = 8;

    reg clk;
    reg rst_n;
    reg RX_IN;
    reg PAR_EN;
    reg PAR_TYP;
    wire [WIDTH-1:0] P_DATA;
    wire DATA_VALID;

    rx #(.prescale(prescale), .WIDTH(WIDTH)) DUT (
        .RX_IN(RX_IN),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .clk(clk),
        .rst_n(rst_n),
        .P_DATA(P_DATA),
        .DATA_VALID(DATA_VALID)
    );

    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        RX_IN = 1;
        PAR_EN =1;
        PAR_TYP = 0;

        repeat(2) @(negedge clk);
        rst_n = 1;


        repeat(2) @(negedge clk);
        // START bit
        RX_IN = 0;

        repeat(prescale) @(negedge clk);
        // DATA = 10100101
        RX_IN = 1;

        repeat(prescale) @(negedge clk);
        RX_IN = 0;

        repeat(prescale) @(negedge clk);
        RX_IN = 1;

        repeat(prescale) @(negedge clk);
        RX_IN = 0;

        repeat(prescale) @(negedge clk);
        RX_IN = 0;

        repeat(prescale) @(negedge clk);
        RX_IN = 1;

        repeat(prescale) @(negedge clk);
        RX_IN = 0;

        repeat(prescale) @(negedge clk);
        RX_IN = 1;

        //PARITY bit
        repeat(prescale) @(negedge clk);
        RX_IN = 0;

        // STOP bit
        repeat(prescale) @(negedge clk);
        RX_IN = 1;

        repeat(prescale) @(negedge clk);

        $stop;
    end

endmodule