class packet;

rand bit [63:0] a_bit;
rand bit [63:0] b_bit;

endclass

module carrylookaheadadder_tb();

parameter N = 74;

logic [N-1:0] a,b;
logic [N:0] out;

int check;
logic [N-1:0] reala, realb;
logic [N:0] sum;

carrylookaheadadder #(N) u1(a,b,out);

initial begin
    packet pkt1;
    $display("start");
    for(int i = 0; i < 2048; i += 1)
    begin
        if ((((sum-out)/out)*100) <-1.0 | (((sum-out)/out)*100)>1.0)
        begin
            $display("a is %f", reala);
            $display("%h", a);
            $display("b is %f", realb);
            $display("%h", b);
            $display("Recieved sum is %f", out);
            $display("Expected sum is %f", sum);
            $display("%h", sum);
            $display("Error %f", (((sum-out)/out)*100));
        end

        pkt1 = new();

        check = pkt1.randomize();
        reala = pkt1.a_bit;
        a = reala;

        check = pkt1.randomize();
        realb = pkt1.b_bit;
        b = realb;

        sum = reala + realb;

        #5 ;
    end
end

endmodule