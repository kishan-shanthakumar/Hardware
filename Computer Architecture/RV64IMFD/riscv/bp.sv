module bp #(parameter N)
            (input logic [31:0] addr,
            output logic hit, taken,
            output logic [31:0] paddr,
            input logic mispred,
            input logic [31:0] t_addr,
            input logic [31:0] tp_addr,
            input clk, rst
);

logic [N-1:0] index_free, index;
logic enc_valid, gfree;
genvar i, j;
logic present;
logic [((2**N)-1):0] validn;
logic [((2**N)-1):0] freen;

enc_n #(N) u1(index, enc_valid, validn);
enc_n #(N) u2(index_free, gfree, freen);

typedef struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic [1:0] prev_counter;
    logic valid;
    logic match;
    logic free;
} btb_ele;

btb_ele btb [((2**N)-1):0];

// Prediction phase
generate
for(j = 0; j < 2**N; j++)
begin : predictor
    assign validn[j] = btb[j].valid;
    assign freen[j] = btb[j].free;
    assign btb[j].valid = (btb[j].address == addr) ? 1 : 0;
end
endgenerate

assign paddr = btb[index].pred_address;
assign taken = (btb[index].counter > 1) ? 1 : 0;
assign hit = |validn;

//misprediction phase
always_comb
begin 
    present = 0;
    for (integer k = 0; k < 2**N; k = k + 1)
    begin
        present |= btb[k].match;
    end
end

generate
for(j = 0; j < 2**N; j++)
begin : matcher
    assign btb[j].match = (btb[j].address == t_addr) ? 1 : 0;
end
endgenerate

generate
for(i = 0; i < 2**N; i++)
begin : training
    always_ff @(posedge clk, negedge rst)
    begin
        if (!rst)
        begin
            btb[i].address <= 32'b0;
            btb[i].pred_address <= 32'b0;
            btb[i].counter <= 2'b0;
            btb[i].prev_counter <= 2'b0;
            btb[i].free <= 1'b0;
        end
        else
        begin
            if (mispred)
            begin
                if (present)
                begin
                    if (btb[i].match == 1)
                    begin
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
                else
                begin
                    if (gfree == 1)
                    begin
                        if (i == index_free)
                        begin
                            btb[i].address <= t_addr;
                            btb[i].pred_address <= tp_addr;
                            btb[i].free <= 0;
                        end
                    end
                end
            end
            else
            begin
                if (hit == 1)
                begin
                    if (btb[i].valid == 1)
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
endgenerate

endmodule