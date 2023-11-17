module regfile (
    input logic clk, n_reset,
    input logic [4:0] rs1_dec, rs2_dec, rs3_dec, rd_wb,
    input logic reg_type_dec, reg_type_wb,
    input logic [63:0] op_wb,
    input logic we_rd_wb,
    output logic [63:0] op1_dec, op2_dec, op3_dec
);

endmodule