module top #(
    parameter num_inputs = 256,
    parameter num_outputs = 10,
    parameter num_hidden_layers = 4
) (
    input logic clk, n_reset,
    input logic [63:0] inputs [num_inputs-1:0],
    output logic [63:0] out [num_outputs-1:0]
);

parameter int num_neurons_hidden [num_hidden_layers-1:0] = {64, 48, 32, 16};

endmodule