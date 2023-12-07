module wallace_tree_addition #(
    parameter N = 32
) (
    input logic [2*N-1:0] inps [N-1:0],
    output logic [2*N-1:0] out
);

int iter_max = $clog2(N)/$clog2(1.5);
logic [2*N-1:0] step_values [N-1:0][iter_max:0];
int index;

genvar i;
generate
    step_values[0] = inps;
    for(int iter = 0; iter < iter_max; iter++)
    begin
        int c = 0;
        for(int i = 0; i < (int)(N/$pow(1.5,iter)); i += 3)
        begin
            index = i / 3;
            carrysaveadder #(64) u1(step_values[iter][i], step_values[iter][i], step_values[iter][i],
                                    step_values[iter+1][c], step_values[iter+1][c+1]);
            c += 2;
        end
        for(int i = (int)(N/$pow(1.5,iter)); i < N; i++)
        begin
            step_values[iter+1][c] = step_values[iter][i];
            c++;
        end
    end
endgenerate

carrylookaheadadder #(64) u1(step_values[iter_max][0], step_values[iter_max][1], out);

endmodule