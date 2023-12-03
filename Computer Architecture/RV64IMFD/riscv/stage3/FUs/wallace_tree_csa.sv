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
    {
        for(int i = 0; i < N; i += 3)
        {
            index = i / 3;
            carrysaveadder #(64) u1();
        }
        for(int i = (int)(N/3); i < N; i++)
        {
            carry[i] = inps[i*3];
        }
    }
endgenerate

endmodule