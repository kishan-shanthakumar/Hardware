module stage4(
    input logic clk, n_reset,
    input logic [47:0] mem_addr_ex,
    input logic [4:0] type_op_mem_ex,
    input logic we_rd_ex,
    input logic [63:0] op_ex,
    input logic [4:0] rd_ex,
    input logic reg_type_ex,
    output logic [47:0] mem_addr_mem,
    output logic [63:0] mem_data_mem_out,
    input logic [63:0] mem_data_mem_in,
    output logic [4:0] rd_mem,
    output logic [63:0] op_mem,
    output logic we_rd_mem,
    output logic reg_type_mem,
    input logic trap_if_dec_ex, trap_dec_ex, trap_ex,
    output logic trap_if_dec_ex_mem, trap_dec_ex_mem, trap_ex_mem, trap_mem
);

endmodule