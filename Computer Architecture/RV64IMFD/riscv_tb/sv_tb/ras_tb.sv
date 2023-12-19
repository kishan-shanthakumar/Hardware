class packet;

rand bit [63:0] idata;
rand bit push_pop;

endclass

module ras_tb();
logic clk, rst;
logic [63:0] idata;
logic [63:0] odata;
logic push, pop;
logic check;

ras u1(.*);

initial begin
    packet pkt1;
    clk = 0;
    rst = 1;
    idata = 0;
    push = 0;
    pop = 0;
    #5 rst = 0;
    #10 rst = 1;
    $display("Start");
    for(int i = 0; i < 100000; i += 1)
    begin
        #10;
        pkt1 = new();
        check = pkt1.randomize();
        push = pkt1.push_pop;
        pop = !pkt1.push_pop;
        idata = pkt1.idata;
    end
    $display("End");
end

always #5 clk = ~clk;

endmodule