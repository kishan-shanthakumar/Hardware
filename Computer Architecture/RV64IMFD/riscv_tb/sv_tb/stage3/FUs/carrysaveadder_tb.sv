class packet;

rand bit [63:0] a_bit;
rand bit [63:0] b_bit;
rand bit [63:0] c_bit;

endclass

module carrysaveadder_tb();

parameter N = 74;

logic [N-1:0] a,b,c,carry,sum;

int check;
logic [N-1:0] reala, realb, realc, realsum, realcarry;

carrysaveadder #(N) u1(a,b,c,carry, sum);

initial begin
    packet pkt1;
    $display("start");
    for(int i = 0; i < 2048; i += 1)
    begin
        if ((((sum-realsum)/realsum)*100) <-1.0 | (((sum-realsum)/realsum)*100)>1.0 | (((carry-realcarry)/realcarry)*100) <-1.0 | (((carry-realcarry)/realcarry)*100)>1.0)
        begin
            $display("a is %f", reala);
            $display("%h", a);
            $display("b is %f", realb);
            $display("%h", b);
            $display("b is %f", realc);
            $display("%h", c);
            $display("Recieved sum is %f", realsum);
            $display("Expected sum is %f", sum);
            $display("Recieved carry is %f", realcarry);
            $display("Expected carry is %f", carry);
            $display("%h", sum);
            $display("Error %f", (((sum-realsum)/realsum)*100));
            $display("%h", carry);
            $display("Error %f", (((carry-realcarry)/realcarry)*100));
        end

        pkt1 = new();

        check = pkt1.randomize();
        reala = pkt1.a_bit;
        a = reala;

        check = pkt1.randomize();
        realb = pkt1.b_bit;
        b = realb;

        check = pkt1.randomize();
        realc = pkt1.c_bit;
        c = realc;

        realsum = reala ^ realb ^ realc;
        realcarry = ((( reala ^ realb) & realc) | (reala & realb)) << 1;

        #5 ;
    end
end

endmodule