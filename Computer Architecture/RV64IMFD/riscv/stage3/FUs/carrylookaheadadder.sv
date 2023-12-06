module carrylookaheadadder #(
    parameter N = 64
) (
    input logic [N-1:0] a,b,
    output logic [N:0] out
);

logic [N-1:0] gen, prop;
logic [N:0] carry;
logic tempj;
logic tempk;

always_comb begin : cla
    carry = '0;
    for(int i = 0; i < N; i++)
    begin
        gen[i] = a[i] & b[i];
        prop[i] = a[i] | b[i];
    end
    for(int i = 1; i < N; i++)
    begin
        tempj = gen[i-1];
        for(int j = 0; j < i; j++)
        begin
            tempk = (j==0) ? carry[0] : gen[j-1];
            for(int k = j; k < i; k++)
            begin
                tempk = tempk & prop[k];
            end
            tempj = tempj | tempk;
        end
        carry[i] = tempj;
    end
    for(int i = 0; i < N; i++)
    begin
        out[i] = a[i] ^ b[i] ^ carry[i];
    end
    out[N] = carry[N];
end

endmodule