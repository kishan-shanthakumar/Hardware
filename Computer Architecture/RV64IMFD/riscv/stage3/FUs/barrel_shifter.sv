module barrel_shifter (
    input [63:0] logic op1,
    input [5:0] logic op2,
    input logic dir, //1 is left 0 is right
    output [63:0] logic bs_result
);

always_comb
begin
    bs_result = 0;
    if(op[0] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[62:0],1'b0} : {1'b0,bs_result[63:1]});
    if(op[1] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[61:0],2'b0} : {2'b0,bs_result[63:2]});
    if(op[2] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[59:0],4'b0} : {4'b0,bs_result[63:4]});
    if(op[3] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[55:0],8'b0} : {8'b0,bs_result[63:8]});
    if(op[4] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[47:0],16'b0} : {16'b0,bs_result[63:16]});
    if(op[5] == 1)
        bs_result = bs_result | ((dir == 1) ? {bs_result[31:0],32'b0} : {32'b0,bs_result[63:32]});
end

endmodule