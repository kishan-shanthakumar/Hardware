module riscv (
    parameter bht_size = 256,
    parameter num_occurences = 4,
    parameter ras_size = 8,
    parameter start_pc = '0
) (
    input logic clk, n_reset,
    input logic [31:0] instr,
    input logic i_ready,
    output logic [47:0] pc,
    input logic [63:0] mem_data_mem_in,
    input logic d_ready,
    output logic [47:0] mem_addr_mem,
    output logic we_rd_mem,
    output logic [63:0] mem_data_mem_out
)

endmodule