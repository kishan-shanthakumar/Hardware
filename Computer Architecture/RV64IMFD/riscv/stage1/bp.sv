`define RET 32'h00008067
`define JUM 32'h00000067

module bp #(parameter bp_size = 11, parameter ras_size = 16)
            (input logic [63:0] addr,
            output logic hit, taken,
            output logic [63:0] paddr,
            input logic mispred,
            input logic [63:0] t_addr,
            input logic [63:0] tp_addr,
            input logic [31:0] instr,
            input logic clk, rst
);
logic [63:0] idata, odata;
logic full, empty, push, pop, valid;

endmodule