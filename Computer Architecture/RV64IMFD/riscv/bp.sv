module bp #(parameter N = 11)
            (input logic [31:0] addr,
            output logic hit, taken,
            output logic [31:0] paddr,
            input logic mispred,
            input logic [31:0] t_addr,
            input logic [31:0] tp_addr,
            input clk, rst
);

logic [N-1:0] index_free, index, index_match;
logic enc_valid, gfree;
genvar j;
logic present;
logic [((2**N)-1):0] validn;
logic [((2**N)-1):0] freen;
logic [((2**N)-1):0] match;

typedef struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic [1:0] prev_counter;
    logic valid;
    logic free;
} btb_ele;

btb_ele btb [((2**N)-1):0];

// Prediction phase
generate
for(j = 0; j < 2**N; j++)
begin : predictor
    assign validn[j] =(btb[j].address == addr) ? 1 : 0;
    assign freen[j] = btb[j].free;
    assign btb[j].valid = (btb[j].address == addr) ? 1 : 0;
end
endgenerate

enc_n #(N) u1(index, enc_valid, validn);
enc_n #(N) u2(index_free, gfree, freen);
enc_n #(N) u3(index_match, present, match);

assign paddr = btb[index].pred_address;
assign taken = (btb[index].counter > 1) ? 1 : 0;
assign hit = enc_valid;

//misprediction phase
generate
for(j = 0; j < 2**N; j++)
begin : matcher
    assign match[j] = (btb[j].address == t_addr) ? 1 : 0;
end
endgenerate

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
    begin
        for(int i = 0; i < 2**N; i++)
        begin
            btb[i].address <= 0;
            btb[i].pred_address <= 0;
            btb[i].counter <= 0;
            btb[i].prev_counter <= 0;
            btb[i].free <= 1;
        end
    end
    else
    begin
        if (gfree & !present & mispred)
        begin
            btb[index_free].address <= t_addr;
            btb[index_free].pred_address <= tp_addr;
            btb[index_free].free <= 0;
        end
        if (hit)
        begin
            btb[index].prev_counter <= btb[index].counter;
            if (btb[index].counter == 0)
            begin
                btb[index].counter <= 0;
            end
            else if (btb[index].counter == 1)
            begin
                btb[index].counter <= 0;
            end
            else if (btb[index].prev_counter == 2)
            begin
                btb[index].counter <= 3;
            end
            else
            begin
                btb[index].counter <= 3;
            end
        end
        if (mispred & present)
        begin
            btb[index_match].prev_counter <= btb[index_match].counter;
            if (btb[index_match].counter == 0)
            begin
                btb[index_match].counter <= 0;
            end
            else if (btb[index_match].counter == 1)
            begin
                btb[index_match].counter <= 0;
            end
            else if (btb[index_match].prev_counter == 2)
            begin
                btb[index_match].counter <= 3;
            end
            else
            begin
                btb[index_match].counter <= 3;
            end
        end
    end
end

endmodule