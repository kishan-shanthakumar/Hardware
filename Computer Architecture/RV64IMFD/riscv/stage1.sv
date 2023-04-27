// Fence flush
// BP for jump and branch
// Send address and instruction to next stage

module stage1 (input logic [31:0] instr_i, r_addr, t_addr, tp_addr,
            input logic clk, rst, mispred,
            output logic [31:0] addr, instr_o);

logic hit, taken;
logic [31:0] paddr;

bp u1(.*);

always_ff @(posedge clk. negedge rst)
begin
    if(!rst)
        addr <= 0;
    else
    begin
        if (mispred)
            addr <= r_addr;
        else
            if (taken)
                addr <= paddr;
            else
                addr <= addr + 4;
    end

end

endmodule
