module base(input logic [31:0] op1, op2,
            input logic [] select,
            output logic [31:0] result);

always_comb
begin
    case(select)
    LUI:
    AUIPC:
    LB:
    LH:
    LW:
    LBU:
    LHU:
    SB:
    SH:
    SW:
    ADD:
    SUB:
    SLL:
    SLT:
    SLTU:
    XOR:
    SRL:
    SRA:
    OR:
    AND:
    FENCE:
    FENCE_TSO:
    PAUSE:
    ECALL:
    EBREAK:
    endcase
end

endmodule