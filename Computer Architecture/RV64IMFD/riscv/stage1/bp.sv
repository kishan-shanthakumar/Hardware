// JAL Push only if rd = x1/x5
// JALR hints
//  rd      rs1     rs1=rd      RAS Action
//  !link   !link   ----        none
//  !link   link    ----        pop
//  link    !link   ----        push
//  link    link    0           replace
//  link    link    1           push

`define     JAL     7'h6f
`define     JALR    7'h67

module bp #(
    parameter bht_size = 256,
    parameter num_occurences = 4,
    parameter ras_size = 8
)
(
    input logic clk, n_reset,
    input logic [47:0] pc,
    input logic [31:0] instr,
    input logic mispred, flush
    input logic [47:0] correct_pc,
    input logic [47:0] index_pc,
    output logic [47:0] pred_pc,
    output logic valid
);

typedef struct packed {
    logic [47:0] inp_pc,
    logic [47:0] pred_pc,
    logic [1:0] counter [num_occurences-1:0],
    logic [$clog2(num_occurences)-1:0] counter_index,
    logic valid
} bht_t;

bht_t bht [bht_size-1:0];
logic match [bht_size-1:0];
logic [$clog2(bht_size)-1:0] match_pointer;
logic match_valid;
logic [$clog2(bht_size)-1:0] global_counter;

logic push, pop, replace;
logic [47:0] idata, odata;

assign idata = pc + 4;

always_comb begin : RAS_action
    push = 0;
    pop = 0;
    replace = 0;
    case (instr[6:0])
        7'h6f: begin
            if ( instr[11:7] == 5'h1 | instr[11:7] == 5'h5 )
                push = 1;
        end
        7'h67: begin
            if ( instr[14:12] == 0 )
            begin
                case (instr[6:0])
                    5'h1: begin
                        case (instr[19:15])
                            5'h1:push = 1;
                            5'h5: replace = 1;
                            default: push = 1;
                        endcase
                    end
                    5'h5: begin
                        case (instr[19:15])
                            5'h1: replace;
                            5'h5: push = 1;
                            default: push = 1;
                        endcase
                    end
                    default: begin
                        if ( instr[19:15] == 5'h1 | instr[19:15] == 5'h5 )
                            pop = 1;
                    end
                endcase
            end
        end
        default: begin
            pop = 0;
            push = 0;
            replace = 0;
        end
    endcase
end

ras #(ras_size)(
    .clk, .n_reset,
    .idata,
    .odata,
    .push, .pop, .replace, .flush
);

always_comb
begin : pred_pc_assignment
    if (pop == 1)
        pred_pc = odata;
    else if(valid)
        pred_pc = bht[match_pointer].pred_pc;
    else
        pred_pc = pc + 4;
end

always_comb
begin : matching_logic
    if (mispred)
    begin
        for (int i = 0; i < bht_size; i++) begin
            match[i] = (pc == bht[i].inp_pc);
        end
    end
    else
    begin
        for (int i = 0; i < bht_size; i++) begin
            match[i] = (index_pc == bht[i].inp_pc);
        end
    end
end

always_comb
begin : valid_logic
    if(match_valid)
        valid = bht[match_pointer].valid;
    else
        valid = 0;
end

enc_n #($clog2(bht_size)) u1 (
    .out(match_pointer), .valid(match_valid), .inp(match)
);

always_ff @( posedge clk, negedge n_reset ) begin : bht_logic
    if (!n_reset)
    begin
        for (int i = 0; i < bht_size; i++) begin
            bht[i].valid <= '0;
            bht[i].counter_index <= '0;
        end
        global_counter <= '0;
    end
    else
    begin
        if(mispred)
            if(match_valid)
            begin
                bht[match_pointer].counter[counter_index-1] <= '{!bht[match_pointer].counter[counter_index][1], !bht[match_pointer].counter[counter_index][0]};
            end
            else
            begin
                bht[global_counter].pc <= index_pc;
                bht[global_counter].pred_pc <= correct_pc;
                bht[global_counter].counter[0] <= 2;
                bht[global_counter].counter_index <= 1;
                bht[global_counter].valid <= '1;
            end
        else
        begin
            bht[match_pointer].counter_index <= bht[match_pointer].counter_index + 1;
            bht[match_pointer].counter[counter_index] <= '{bht[match_pointer].counter[counter_index][1], !bht[match_pointer].counter[counter_index][0]};
        end
    end
end
endmodule