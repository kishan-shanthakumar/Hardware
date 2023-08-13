module ras
#(parameter ras_size = 8)
(
    input logic clk, rst,
    input logic [31:0] idata,
    output logic [31:0] odata,
    input logic push, pop,
    output logic valid,
    output logic empty, full
);

logic [31:0] stack [N-1:0];

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
            stack[ras_addr] <= idata;
            if(ras_addr != '1)
                ras_addr <= ras_addr + 1;
            else
                full <= 1;
        end
        else if(pop & !empty)
        begin
            if(ras_addr != 0)
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
        odata = stack[ras_addr];
    end
end

endmodule