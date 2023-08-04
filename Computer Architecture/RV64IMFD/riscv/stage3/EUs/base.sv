`include "instr_op.sv"

module base(input logic [63:0] op1, op2,
            input logic [] select,
            output logic [63:0] result);

logic temp, car;
logic [63:0] cseladd_result, inp1, inp2, bs_result;

cseladd #(64) u1(inp1, inp2, car, cseladd_result, temp);
barrel_shifter u2(inp1, inp2, car, bs_result);

always_comb
begin
    car = 0;
    inp1 = 0;
    inp2 = 0;
    case(select)
        `LUI: begin
        end
        `AUIPC: begin
            inp1 = op1;
            inp2 = {op2[19:0], 12'b0};
            result = cseladd_result; // op1 is pc, op2 is 20 bit immediate
        end
        `ADD: begin
            inp1 = op1;
            inp2 = op2;
            result = cseladd_result;
        end
        `SUB: begin
            inp1 = op1;
            inp2 = (!op2);
            car = 1;
            result = cseladd_result;
        end
        `SLL: begin
            inp1 = op1;
            inp2 = op2;
            car = 1;
            result = bs_result;
        end
        `SLT:
        `SLTU:
        `XOR:
        `SRL: begin
            inp1 = op1;
            inp2 = op2;
            car = 0;
            result = bs_result;
        end
        `SRA:
        `OR:
        `AND:
        `FENCE:
        `FENCE_TSO:
        `PAUSE:
        `ECALL:
        `EBREAK:
        `SLLI
        `SRLI
        `SRAI
        `ADDIW
        `SLLIW
        `SRLIW
        `SRAIW
        `ADDW
        `SUBW
        `SLLW
        `SRLW
        `SRAW
    endcase
end

endmodule