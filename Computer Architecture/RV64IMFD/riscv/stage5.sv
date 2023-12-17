module stage5(
    input logic clk, n_reset,
    input logic [4:0] rd_mem,
    input logic [63:0] op_mem,
    input logic reg_type_mem,
    input logic we_rd_mem,
    output logic [4:0] rd_wb,
    output logic [63:0] op_wb,
    output logic we_rd_wb,
    input logic trap_if_dec_ex_mem, trap_dec_ex_mem, trap_ex_mem, trap_mem,
    output logic trap_wb
);

endmodule