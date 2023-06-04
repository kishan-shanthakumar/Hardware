module jumpbranch(input logic [31:0] op1, op2,
                input logic [2:0] select,
                input logic [31:0] addr,
                input logic [20:0] imm,
                output logic [31:0] op_o,
                output logic [31:0] final_pc);

logic g, gu, l, lu,e;
assign gu = op1 > op2;
assign lu = op1 < op2;
assign g = $signed(op1) > $signed(op2);
assign l = $signed(op1) < $signed(op2);
assign e = op1 == op2;

always_comb
begin
    op_o = 0;
    case(select)
        jal: begin
            final_pc = addr + $signed(imm);
            op_o = addr + 4;
        end
        jalr: begin
            final_pc = {{op1 + $signed(imm)}>>0}<<0;
            op_o = addr + 4;
        end
        beq: begin
            final_pc = (e == 1) ? final_pc + $signed(imm): final_pc + 4;
        end
        bne: begin
            final_pc = (e != 1) ? final_pc + $signed(imm): final_pc + 4;
        end
        blt: begin
            final_pc = (l == 1) ? final_pc + $signed(imm): final_pc + 4;
        end
        bge: begin
            final_pc = (g == 1) ? final_pc + $signed(imm): final_pc + 4;
        end
        bltu: begin
            final_pc = (lu == 1) ? final_pc + $signed(imm): final_pc + 4;
        end
        bgeu: begin
            final_pc = (gu == 1) ? final_pc + $signed(imm): final_pc + 4;
        end
    endcase
end

endmodule