module bp( input logic [31:0] addr,
            input logic train,
            output logic valid,
            output logic [31:0] paddr,
            input logic [31:0] taddr,
            input clk, rst
);

struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic valid;
    logic match;
} btb_ele;

btb_ele [2047:0] btb;
logic present;

always_comb
begin 
    present = '0;
    for (i = 0; i < 2048; i = i + 1)
    begin
        present |= btb_ele[i].match;
    end
end

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
        btb <= {2048{32'b0, 32'b0, 2'b0, 1'b0}};
    else
        if(train)
        begin
            for(integer i = 0; i < 2048; i++)
            begin
                if (btb[i].match)
                begin
                    if (btb[i].counter != 0)
                    begin
                        btb[i].counter <= btb[i][counter] - 1;
                    end
                end
            end
        end
        for(integer i = 0; i < 2048; i++)
        begin
            btb[i].match <= addr == taddr;
            btb[i].valid <= addr == addr;
        end
end

endmodule