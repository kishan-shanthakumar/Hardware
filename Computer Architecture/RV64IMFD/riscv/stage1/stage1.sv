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

logic [47:0] pred_pc;

bp #(
    parameter bht_size = 256,
    parameter num_occurences = 4,
    parameter ras_size = 8
) u1
(
    .clk, .n_reset,
    .pc,
    .instr,
    .mispred, .flush,
    .correct_pc,
    .index_pc,
    .pred_pc,
    .valid
);

always_ff @(posedge clk, negedge n_reset)
begin
    if (!n_reset)
        pc <= '0;
    else if (mispred)
        pc <= correct_pc;
    else if (ready)
    begin
        if(valid)
            pc = pred_pc;
        else
            pc = pc + 4;
    end
end

endmodule
