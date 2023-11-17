module stage5(
    input logic clk, n_reset,
    input logic [4:0] rd_mem,
    input logic [63:0] op_mem,
    input logic reg_type_mem,
    input logic we_rd_mem,
    output logic [4:0] rd_wb,
    output logic [63:0] op_wb,
    output logic we_rd_wb
);

endmodule