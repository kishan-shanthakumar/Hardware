// EUs
// Basic arithmetic and boolean for integer and floating
// Multiply for integer and floating point
// Divide for integer and floating point
// Branch/Jump unit

module stage2(input logic [31:0] instr,
            input logic ready,
            input logic pipeline_valid,
            output [4:0] r1_addr, r2_addr, r3_addr, w1_addr,
            output [3:0] reg_write,
            output [20:0] imm,
            output [1:0] eu_type,
            input logic clk, rst);

enum logic [2:0] { basic, muldiv, jumpbranch } eu; // Basic Arithmetic, Mul-Div, Jump-Branch

logic [31:0] instruction;

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
        instruction <= 32'h13;
    else if (ready)
        instruction <= instr;
end

always_comb
begin
    case(instruction[1:0])
    endcase
end

endmodule