// 0010111 imm          auipc
// 1100011 reg op       branch
// 1010011 reg op       float op
// 1001111 reg op       fused add
// 0011011 imm          word op
// 0110011 reg op       int op
// 1001011 reg op       fused sub
// 0000111 imm          float load
// 1110011 no op        call
// 0100011 imm          int store
// 0010011 imm          int op
// 0000011 imm          int load
// 0100111 imm          float store
// 1000111 reg op       fused sub
// 1000011 reg op       fused add
// 1101111 imm          jal
// 1100111 imm          jalr
// 0111011 reg op       word op
// 0001111 fence/pause
// 0110111 lui

// 0010011, 0110111, (0010111)auipc -> Imm operation
// 0110011 -> register operation
// 0000011 int load
// 0100011 int store
// 0100111 float store
// 0000111 float load

module stage2(
    input logic clk, n_reset,
    input logic [47:0] pc,
    input logic [31:0] instr,
    output logic [4:0] type_op_mem_dec,
    output logic [3:0] op_funct_dec,
    output logic [4:0] rs1_dec, rs2_dec, rs3_dec, rd_dec,
    input logic [63:0] op1_reg, op2_reg, op3_reg,
    output logic [63:0] op1_dec, op2_dec, op3_dec,
    output logic reg_type_dec,
    input logic trap_if,
    output logic trap_if_dec, trap_dec
);

always_ff @(posedge clk, negedge n_reset)
begin
    if(!n_reset)
    begin
        op1_dec <= 0;
        op2_dec <= 0;
        op3_dec <= 0;
    end
    else
    begin
        case(instr[6:0])
        7'b0110011: begin
            op1_dec <= op1_reg;
            op2_dec <= op2_reg;
            op3_dec <= op3_reg;
        end
        7'b0010011: begin
            op1_dec <= op1_reg;
            op2_dec <= instr[31:15];
            op3_dec <= op3_reg;
        end
        7'b0110111: begin
            op1_dec <= op1_reg;
            op2_dec <= instr[31:12];
            op3_dec <= op3_reg;
        end
        7'b0010111: begin
            op1_dec <= pc;
            op2_dec <= instr[31:7];
            op3_dec <= op3_reg;
        end
        default: begin
            op1_dec <= '0;
            op2_dec <= '0;
            op3_dec <= '0;
        end
        endcase
    end
end

endmodule