module ras
#(parameter ras_size = 8)
(
    input logic clk, n_reset,
    input logic [47:0] idata,
    output logic [47:0] odata,
    input logic push, pop, replace
);

logic [$clog2(ras_size)-1:0] ras_pointer;

logic [47:0] ret_addr_stack [ras_size-1:0];

always_ff @( posedge clk, negedge n_reset )
begin
    if(!n_reset)
    begin
        ras_pointer <= 0;
    end
    else if(push)
    begin
        ret_addr_stack[ras_pointer] <= idata;
        ras_pointer <= ras_pointer + 1;
    end
    else if(pop)
    begin
        ras_pointer <= ras_pointer - 1;
    end
    else if(replace)
    begin
        ret_addr_stack[ras_pointer-1] <= idata;
    end
end

assign odata = ret_addr_stack[ras_pointer-1];

endmodule