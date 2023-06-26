function [127:0] add (input [127:0] inp1, input [127:0] inp2);
    logic [127:0] cseladd_result;
    cseladd #(128) u1(inp1, inp2, 0, cseladd_result);
    add = cseladd_result;
endfunction

module int_mul(input logic clk, rst,
                input logic [63:0] op1, op2,
                input logic sel, start,
                output logic ready,
                output logic [63:0] int_mul_out);

logic [127:0] product;
logic [2:0] counter, cseladd_result;
logic count_en;
logic [63:0] op1_reg, op2_reg;

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
            int_mul_out <= (sel == 1'b1) ? product[127:64] : product[63:0];
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
            op1_reg <= op1;
            op2_reg <= op2;
        end
        if(count_en == 1'b1)
        begin
            product[127:60] <= add( add( add( (op2_reg[3])?op2_reg<<3:'0 , (op2_reg[2])?op2_reg<<2:'0 ) , add( (op2_reg[1])?op2_reg<<1:'0 , (op2_reg[0])?op2_reg:'0 ) ) , product[123:60] );
            op2_reg = {4'b0, op2_reg[59:0]};
        end
    end
end

endmodule