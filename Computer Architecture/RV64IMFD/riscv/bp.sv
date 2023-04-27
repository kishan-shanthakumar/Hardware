module bp( input logic [31:0] addr,
            output logic hit, taken
            output logic [31:0] paddr,
            input logic mispred,
            input logic [31:0] t_addr,
            input clk, rst
);

logic [10:0] index;
logic enc_valid;

enc_n #(11) u1(index, enc_valid, validn);

typedef struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic [1:0] prev_counter;
    logic valid;
    logic match;
} btb_ele;

btb_ele btb [2047:0];
logic present;
logic [2047:0] validn;

// Prediction phase
always_comb
begin
    hit = 0;
    validn = 0;
    if (!mispred)
    begin
        for(integer i = 0; i < 2048; i++)
        begin
            validn[i] = btb[i].valid;
            hit |= btb[i].valid;
        end
    end
end

always_comb
begin
    for(integer i = 0; i < 2048; i++)
    begin
        btb[i].valid = btb[i].address == addr;
    end
end

assign paddr = btb[index].pred_address;
assign taken = (counter > 1) ? 1 : 0;

//misprediction phase
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
            btb[i].prev_counter <= 2'b0;
        end
    end
    else
    begin
        if(mispred)
        begin
            if (present)
            begin
                for(integer i = 0; i < 2048; i++)
                begin
                    if (btb[i].match)
                    begin
                        btb[i].prev_counter <= btb[i].counter;
                        if (btb[i].prev_counter == 0)
                        begin
                            btb[i].counter <= 1;
                        end
                        else if (btb[i].prev_counter == 1)
                        begin
                            btb[i].counter <= 2;
                        end
                        else if (btb[i].prev_counter == 2)
                        begin
                            btb[i].counter <= 1;
                        end
                        else
                        begin
                            btb[i].counter <= 2;
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
        else
        begin
            if (hit)
            begin
                for(integer i = 0; i < 2048; i++)
                begin
                    if (btb[i].valid)
                    begin
                        btb[i].prev_counter <= btb[i].counter;
                        if (btb[i].counter == 0)
                        begin
                            btb[i].counter <= 0;
                        end
                        else if (btb[i].counter == 1)
                        begin
                            btb[i].counter <= 0;
                        end
                        else if (btb[i].prev_counter == 2)
                        begin
                            btb[i].counter <= 3;
                        end
                        else
                        begin
                            btb[i].counter <= 3;
                        end
                    end
                end
            end
        end
    end
end

endmodule