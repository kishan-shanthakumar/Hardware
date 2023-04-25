module bp( input logic [31:0] addr,
            input logic train,
            output logic valid,
            output logic [31:0] paddr,
            input logic [31:0] t_addr,
            input logic [31:0] t_paddr,
            input clk, rst
);

logic [10:0] index;
logic enc_valid;

enc_n #(11) u1(index, enc_valid, validn);

typedef struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic valid;
    logic match;
} btb_ele;

btb_ele btb [2047:0];
logic present;
logic [2047:0] validn;

// Prediction phase
always_comb
begin
    for(integer i = 0; i < 2048; i++)
    begin
        validn[i] = btb[i].valid;
    end
end

always_comb
begin
    valid = 0;
    for(integer i = 0; i < 2048; i++)
    begin
        valid |= btb[i].valid;
        btb[i].valid = btb[i].address == addr;
    end
end

assign paddr = (enc_valid == 1) ? btb[index].pred_address : 'z;

//Training phase
always_comb
begin 
    present = 0;
    for (integer i = 0; i < 2048; i = i + 1)
    begin
        present |= btb[i].match;
    end
    for(integer i = 0; i < 2048; i++)
    begin
        btb[i].match = btb[i].address == t_addr;
    end
end

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
    begin
        for(integer i = 0; i < 2048; i++)
        begin
            btb[i].address <= 32'b0;
            btb[i].pred_address <= 32'b0;
            btb[i].counter <= 2'b0;
        end
    end
    else
    begin
        if(train)
        begin
            if (present)
            begin
                for(integer i = 0; i < 2048; i++)
                begin
                    if (btb[i].match)
                    begin
                        if (btb[i].counter != 0)
                        begin
                            btb[i].counter <= btb[i].counter - 1;
                        end
                    end
                end
            end
            else
            begin
                // Inserting new addresses
                // Potential replacement for existing addresses
            end
        end
    end
end

endmodule