module stage4(
    input logic clk, n_reset,
    input logic [47:0] mem_addr,
    input logic [] type_op_mem,
    input logic we_rd,
    input logic [63:0] op_ex,
    input logic [4:0] rd_ex,
    input logic reg_type_ex,
    output logic [4:0] rd_mem,
    output logic [63:0] op_mem,
    output logic ready,
    output logic we_rd_mem,
    output logic reg_type_mem
);

endmodule