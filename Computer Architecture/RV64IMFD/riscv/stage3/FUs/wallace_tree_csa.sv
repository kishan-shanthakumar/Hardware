module wallace_tree_addition #(
    parameter num_mul = 9,
    parameter N = 32
) (
    input logic [N-1:0] inps [num_mul-1:0],
    output logic [N-1:0] out
);

parameter real iter_max_real = $log10(num_mul)/($log10(3)-$log10(2));
parameter int iter_max = iter_max_real;

logic [N-1:0] step_values [iter_max:0][num_mul-1:0];

genvar i, j, iter, c;
generate
    assign step_values[0] = inps;
    for(iter = 0; iter < iter_max-1; iter++)
    begin
        for(i = 0; i < num_mul; i++)
        begin
            assign step_values[iter+1][i] = '0;
        end
    end
    for(iter = 0; iter < iter_max; iter++)
    begin
        for(i = 0; i <= num_mul-3; i += 3)
        begin
            carrysaveadder #(N) u1(step_values[iter][i], step_values[iter][i+1], step_values[iter][i+2],
                                    step_values[iter+1][((i*2)/3)+1], step_values[iter+1][(((i*2)/3))]);
        end
    end
endgenerate

carrylookaheadadder #(N) u1(step_values[iter_max][0], step_values[iter_max][1], out);

endmodule