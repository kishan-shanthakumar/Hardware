module regfile (input [4:0] r1_addr, r2_addr, w1_addr,
                input [31:0] inp_data,
                output [31:0] r1_data, r2_data,
                input clk, rst, write);

logic [31:0] base_reg [0:31];

always_comb
begin
    r1_data = base_reg[r1_addr];
    r2_data = base_reg[r2_addr];
end

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
    begin
        for(integer i = 0; i < 32; i++)
        begin
            base_reg[i] <= 0;
        end
    end
    else if(write)
        base_reg[w1_addr] <= inp_data;
end

endmodule