// Fence flush
// BP for jump and branch
// Send address and instruction to next stage
// TODO: trap handling
// TODO: interrupts

module stage1 (input logic [31:0] t_addr, tp_addr,
            input logic clk, rst, mispred, ready,
            output logic [31:0] addr);

logic hit, taken;
logic [31:0] paddr;

bp #(11) u1(.*);

always_ff @(posedge clk, negedge rst)
begin
    if(!rst)
        addr <= 0;
    else
        if (ready)
        begin
            if (mispred)
                addr <= tp_addr;
            else
            begin
                if (taken)
                    addr <= paddr;
                else
                    addr <= addr + 4;
            end
        end 

end

endmodule
