function [63:0] add (input [63:0] inp1, input [63:0] inp2);
    logic [63:0] cseladd_result;
    cseladd #(64) u1(inp1, inp2, 0, cseladd_result);
    add = cseladd_result;
endfunction

module int_mul(input logic clk, rst,
                input logic [63:0] op1, op2,
                input logic start,
                output logic ready, valid,
                output logic [63:0] int_div_quo, int_div_rem);

logic [6:0] count;
logic [63:0] A, M, Q;
logic [63:0] A_wire, Q_wire;

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
    begin
        count <= 0;
        A <= 0;
        M <= 0;
        Q <= 0;
        ready <= 1;
        int_div_quo <= 0;
        int_div_rem <= 0;
    end
    else
    begin
        if(start)
        begin
            count <= 64;
            A <= 0;
            Q <= op1;
            M <= op2;
            ready <= 0;
        end
        if(count == 0)
        begin
            ready <= 0;
            int_div_quo <= Q;
            int_div_rem <= A + M;
        end
        if(count > 0)
        begin
            A <= A_wire;
            Q <= Q_wire;
            count <= add(add(count,1),!(64'b1));
        end
    end
end

always_comb
begin
    A_wire = A;
    Q_wire = Q;
    {A_wire,Q_wire} = {A_wire,Q_wire}<<1;
    if($signed(A_wire) < 0)
        A_wire = add(A_wire, M);
    else
        A_wire = add(add(A_wire,1), !M);
    if($signed(A_wire) < 0)
        Q_wire[0] = 0;
    else
        Q_wire[0] = 1;
end

assign valid = (|int_div_quo) | (|int_div_rem);

endmodule