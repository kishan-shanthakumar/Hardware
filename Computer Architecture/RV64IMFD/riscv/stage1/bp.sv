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
    parameter num_occurences = 4
)
(
    input logic clk, n_reset,
    input logic [47:0] pc,
    input logic [31:0] instr,
    input logic mispred,
    input logic [47:0] correct_pc,
    input logic [47:0] index_pc,
    output logic [47:0] pred_pc,
    output logic valid
);

typedef struct packed {
    logic [47:0] inp_pc,
    logic [47:0] pred_pc,
    logic [1:0] counter [3:0],
    logic match,
    logic valid
} bht;

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
                endcase
            end
            default: begin
                if ( instr[19:15] == 5'h1 | instr[19:15] == 5'h5 )
                    pop = 1;
            end
        end
        default: begin
            pop = 0;
            push = 0;
            replace = 0;
        end
    endcase
end

ras #(8)(
    .clk, .n_reset,
    .idata,
    .odata,
    .push, .pop, .replace
);

always_comb
begin
    if (pop == 1)
        pred_pc = odata;
end

endmodule