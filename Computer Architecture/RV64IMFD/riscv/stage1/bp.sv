module bp (
    input logic clk, n_reset,
    input logic [47:0] pc,
    input logic [31:0] instr,
    input logic mispred,
    input logic [47:0] correct_pc,
    input logic [47:0] index_pc,
    output logic [47:0] pred_pc,
    output logic valid
);

endmodule