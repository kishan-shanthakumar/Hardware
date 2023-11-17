// Fence flush
// BP for jump and branch
// Send address and instruction to next stage
// TODO: trap handling
// TODO: interrupts

module stage1 (
    input logic clk, n_reset,
    input logic mispred, ready,
    input logic [47:0] correct_pc, index_pc,
    input logic [31:0] instr,
    output logic [47:0] pc,
    output logic valid
);

endmodule
