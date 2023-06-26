`include "instr_op.sv"

module mul(input logic clk, rst,
            input logic [63:0] op1, op2,
            input logic [2:0] select,
            input logic start,
            output logic ready,
            output logic [63:0] result);

logic [63:0] inp1, inp2;
logic [127:0] int_mul_out;

int_mul u1(.*);

always_comb
begin
    inp1 = 0;
    inp2 = 0;
    case(select)
        `MUL: begin
            inp1 = $signed(op1);
            inp2 = $signed(op2);
        end
        `MULH: begin
            inp1 = $signed(op1);
            inp2 = $signed(op2);
        end
        `MULHSU: begin
            inp1 = $signed(op1);
            inp2 = op2;
        end
        `MULHU: begin
            inp1 = op1;
            inp2 = op2;
        end
        `MULW: begin
            inp1 = $signed(op1[31:0]);
            inp2 = $signed(op2[31:0]);
        end
    endcase
end

always_latch
begin
    if (clk & ready)
        result <= int_mul_out;
end

endmodule