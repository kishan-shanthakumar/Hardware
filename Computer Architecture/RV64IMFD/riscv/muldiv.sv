`include "instr_op.sv"

module muldiv(input logic [31:0] op1, op2,
            input logic [] select,
            output logic [31:0] result);

always_comb
begin
    case(select)
        `MUL
        `MULH
        `MULHSU
        `MULHU
        `DIV
        `DIVU
        `REM
        `REMU
        `MULW
        `DIVW
        `DIVUW
        `REMW
        `REMUW
    endcase
end

endmodule