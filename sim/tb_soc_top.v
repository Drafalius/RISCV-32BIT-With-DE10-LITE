`timescale 1ns / 1ps

module tb_soc_top;

    reg        MAX10_CLK1_50;
    reg  [1:0] KEY;
    reg  [9:0] SW;
    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;

    soc_top uut (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1)
    );
    always #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_soc_top);

        MAX10_CLK1_50 = 0;
        KEY = 2'b10;
        SW  = 10'b0;
        #40;
        KEY[0] = 1; 
        #5000;
        $finish;
    end

endmodule