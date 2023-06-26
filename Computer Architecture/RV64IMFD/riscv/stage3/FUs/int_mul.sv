function [127:0] add (input [127:0] inp1, input [127:0] inp2);
    logic [127:0] cseladd_result;
    cseladd #(128) u1(inp1, inp2, 0, cseladd_result);
    add = cseladd_result;
endfunction

module int_mul(input logic clk, rst,
                input logic [63:0] inp1, inp2,
                input logic start,
                output logic ready,
                output logic [127:0] int_mul_out);

logic [127:0] product;
logic [2:0] counter, cseladd_result;
logic count_en;
logic [63:0] inp1_reg, inp2_reg;

cseladd #(3) u1(counter, 1'b1, 1'b0, cseladd_result);

always_ff @(posedge clk, negedge rst)
begin
    if(!rst)
    begin
        ready <= 0;
        int_mul_out <= 0;
        counter <= 0;
        count_en <= 0;
    end
    else
    begin
        if(count_en == 1)
            counter <= cseladd_result;
        if(start)
        begin
            count_en <= 1;
            ready <= 0;
        end
        if(counter == 3'h7)
        begin
            count_en <= 0;
            ready <= 1;
            int_mul_out <= product;
        end
    end
end

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
        product <= 0;
    else
    begin
        if (start)
        begin
            inp1_reg <= inp1;
            inp2_reg <= inp2;
        end
        if(count_en == 1'b1)
        begin
            product[127:60] <= add( add( add( (inp2_reg[3])?inp2_reg<<3:'0 , (inp2_reg[2])?inp2_reg<<2:'0 ) , add( (inp2_reg[1])?inp2_reg<<1:'0 , (inp2_reg[0])?inp2_reg:'0 ) ) , product[123:60] );
            inp2_reg = {4'b0, inp2_reg[59:0]};
        end
    end
end

endmodule