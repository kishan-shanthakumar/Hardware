module ras
#(parameter ras_size = 8)
(
    input logic clk, rst,
    input logic [63:0] idata,
    output logic [63:0] odata,
    input logic push, pop,
    output logic valid,
    output logic empty, full
);

logic [63:0] stack [N-1:0];

logic [$clog2(N)-1:0] ras_addr;

always_ff @(posedge clk, negedge rst)
begin
    if(!rst)
    begin
        ras_addr <= 0;
        empty <= 1;
        full <= 0;
    end
    else
    begin
        if(push & !full)
        begin
            empty <= 0;
            stack[ras_addr] <= idata;
            if(ras_addr != '1)
                ras_addr <= ras_addr + 1;
            else
                full <= 1;
        end
        else if(pop & !empty)
        begin
            full <= 0;
            if(ras_addr != 0 | full != 1)
                ras_addr <= ras_addr - 1;
            else
                empty <= 1;
        end
    end
end

always_comb
begin
    valid = 0;
    odata = 0;
    if(pop & !empty)
    begin
        valid = 1;
        odata = (ras_addr == 0 ! full == 1) ? stack[ras_addr] : stack[ras_addr-1];
    end
end

endmodule