`include "instr_op.sv"

module div(input logic clk, rst,
            input logic [63:0] op1, op2,
            input logic [2:0] select,
            input logic start,
            output logic ready,
            output logic [63:0] result);

int_div u1(.*);
logic [63:0] inp1, inp2, int_div_quo, int_div_rem;

always_comb
begin
    case(select)
        `DIV: begin
            inp1 = $signed(op1);
            inp2 = $signed(op2);
        end
        `DIVU: begin
            inp1 = op1;
            inp2 = op2;
        end
        `REM: begin
            inp1 = $signed(op1);
            inp2 = $signed(op2);
        end
        `REMU: begin
            inp1 = op1;
            inp2 = op2;
        end
        `DIVW: begin
            inp1 = $signed(op1[31:0]);
            inp2 = $signed(op2[31:0]);
        end
        `DIVUW: begin
            inp1 = op1[31:0];
            inp2 = op2[31:0];
        end
        `REMW: begin
            inp1 = $signed(op1[31:0]);
            inp2 = $signed(op2[31:0]);
        end
        `REMUW: begin
            inp1 = op1[31:0];
            inp2 = op2[31:0];
        end
    endcase
end

always_ff @(posedge clk)
begin
    if (ready)
    begin
        if (select == `DIV | select == `DIVU | select == `DIVW | select == `DIVUW)
            result <= int_div_quo;
        else if(select == `REM | select == `REMU | select == `REMW | select == `REMUW)
            result <= int_div_rem;
    end
end

endmodule