`include "instr_op.sv"

module base(input logic [31:0] op1, op2,
            input logic [] select,
            output logic [31:0] result);

always_comb
begin
    case(select)
        `LUI:
        `AUIPC:
        `ADD:
        `SUB:
        `SLL:
        `SLT:
        `SLTU:
        `XOR:
        `SRL:
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