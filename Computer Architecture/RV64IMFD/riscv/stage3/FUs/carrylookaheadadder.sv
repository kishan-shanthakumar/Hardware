module carrylookaheadadder #(
    parameter N = 32
) (
    input logic [N-1:0] a,b,
    output logic [N:0] out
);

logic [N-1:0] gen, prop;
logic [N:0] carry;

always_comb begin : cla
    carry = '0;
    for(int i = 0; i < N; i++)
    {
        gen[i] = a[i] & b[i];
        prop[i] = a[i] | b[i];
    }
    for(int i = 1; i < N; i++)
    {
        logic tempj;
        tempj = gen[i-1];
        for(int j = 0; j < i; j++)
        {
            logic tempk;
            tempk = (j==0) ? carry[0] : gen[j-1];
            for(int k = j; k < i; k++)
            {
                tempk = tempk & prop[k];
            }
            tempj = tempj | tempk;
        }
        carry[i] = tempj;
    }
    for(int i = 0; i < N; i++)
    {
        out[i] = a[i] ^ b[i] ^ carry[i];
    }
    out[N] = carry[N];
end

endmodule