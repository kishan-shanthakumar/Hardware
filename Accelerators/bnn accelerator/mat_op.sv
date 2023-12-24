module mat_op #(
    parameter num_inputs = 16,
    parameter num_neurons_hidden = 16
) (
    input logic [63:0] inputs [num_inputs-1:0],
    output logic [63:0] out [num_neurons_hidden-1:0]
    input logic weights [num_neurons_hidden-1:0][num_inputs-1:0],
    input logic [63:0] bias [num_neurons_hidden-1:0]
    input logic activation [num_neurons_hidden-1:0]
);

logic [63:0] mat_1 [num_hidden_layers-1:0][num_inputs-1:0];
logic [63:0] mat_2 [num_neurons_hidden-1:0];

genvar i,j;
always_comb
begin
    for (i = 0; i < num_neurons_hidden; i++) begin
        for (j = 0; j < num_inputs; j++) begin
            if(weights[i][j] == 1)
                mat_1[i][j] = inputs[j];
            else
                mat_1[i][j] = {!inputs[j][63],inputs[j][62:0]};
        end
        out[i] = (activation[i] == 1'b1) ? mat_2[i] : 0;
    end
end

endmodule