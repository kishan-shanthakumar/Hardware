// Fence flush
// BP for jump and branch
// Send address and instruction to next stage

module stage1 (input logic [31:0] instr, paddr,
            input logic clk, rst, ready, mispred, valid,
            output logic [31:0] addr);

always_ff @(posedge clk. negedge rst)
begin
    if(!rst)
        addr <= 0;
    if (ready)
        addr <= paddr;
end

endmodule