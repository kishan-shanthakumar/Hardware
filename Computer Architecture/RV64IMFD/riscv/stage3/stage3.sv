module stage3(
    input logic clk, n_reset,
    input logic [63:0] op1_dec, op2_dec, op3_dec,
    input logic reg_type_dec,
    input logic [63:0] op_mem, op_wb,
    input logic [4:0] rs1_dec, rs2_dec, rs3_dec, rd_dec, rd_mem, rd_wb,
    input logic [] op_funct_dec,
    output logic [4:0] rd_ex,
    output logic [63:0] op_ex,
    output logic we_rd_ex,
    output logic [47:0] mem_addr_ex,
    output logic reg_type_ex,
    output logic mispred_ex,
    output logic [47:0] correct_pc_ex, index_pc_ex
);

endmodule