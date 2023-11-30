module stage2(
    input logic clk, n_reset,
    input logic [47:0] pc,
    input logic [31:0] instr,
    output logic [4:0] type_op_mem_dec,
    output logic [3:0] op_funct_dec,
    output logic [4:0] rs1_dec, rs2_dec, rs3_dec, rd_dec,
    output logic reg_type_dec
);

endmodule