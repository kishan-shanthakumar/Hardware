`define RET 32'h00008067
`define JUM 32'h00000067

module bp #(parameter N = 11)
            (input logic [63:0] addr,
            output logic hit, taken,
            output logic [63:0] paddr,
            input logic mispred,
            input logic [63:0] t_addr,
            input logic [63:0] tp_addr,
            input logic [31:0] instr,
            input logic clk, rst
);

logic [63:0] ras [15:0];

typedef struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic [1:0] prev_counter;
    logic free;
} btb_ele;

btb_ele btb [((2**N)-1):0];
logic [1:0] next_counter [((2**N)-1):0];

logic [N-1:0] index_counter;

logic [3:0] ras_pointer;
logic [3:0] next_ras_pointer;
logic ras_empty;
logic ras_full;

always_ff @(posedge clk, negedge rst)
begin
    if(!rst)
    begin
        ras_pointer <= 0;
        index_counter <= 0;
        ras_empty <= 1;
        ras_full <= 0;
        for(int i = 0; i < 2**N; i++)
        begin
            btb[i].address <= 0;
            btb[i].pred_address <= 0;
            btb[i].counter <= 0;
            btb[i].prev_counter <= 0;
            btb[i].free <= 0;
        end
    end
    else
    begin
        if(instr == `RET & ras_pointer == 0 & !ras_empty)
        begin
            ras_empty <= 1;
        end
        if(mispred)
    end
end

always_comb
begin
    pred_address = addr + 4;
    if(instr == `RET & !ras_empty)
    begin
        pred_address = ras[ras_pointer];
        next_ras_pointer = ras_pointer - 1;
    end

end

endmodule