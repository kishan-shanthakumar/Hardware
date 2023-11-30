module stage1 (
    parameter bht_size = 256,
    parameter num_occurences = 4,
    parameter ras_size = 8,
    parameter start_pc = '0
) (
    input logic clk, n_reset,
    input logic mispred_ex, ready,
    input logic [47:0] correct_pc_ex, index_pc_ex,
    input logic [31:0] instr,
    output logic [47:0] pc,
    output logic valid,
    output logic trap_if
);

logic [47:0] pred_pc;

bp #(
    .bht_size(bht_size),
    .num_occurences(num_occurences),
    .ras_size(ras_size)
) u1
(
    .clk, .n_reset,
    .pc,
    .instr,
    .mispred_ex, .flush,
    .correct_pc_ex,
    .index_pc_ex,
    .pred_pc,
    .valid
);

always_ff @(posedge clk, negedge n_reset)
begin
    if (!n_reset)
        pc <= start_pc;
    else if (!trap_if)
    begin
        if (mispred_ex)
            pc <= correct_pc_ex;
        else if (ready)
        begin
            if(valid)
                pc = pred_pc;
            else
                pc = pc + 4;
        end
    end
end

assign trap_if = pc[0] | pc[1];

endmodule
