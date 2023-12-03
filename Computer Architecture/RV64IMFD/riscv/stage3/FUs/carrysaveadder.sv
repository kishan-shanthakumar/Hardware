module carrysaveadder #(
    parameter N=32
)(
    input logic [N-1:0] a,b,c,
    output logic [N-1:0] carry, sum
);

always_comb
begin
    for(int i = 0; i < N; i++)
    {
        sum[i] = a[i] ^ b[i] ^ c[i];
        carry[i] = ((a[i] ^ b[i]) & c[i]) | (a[i] & b[i]);
    }
end

endmodule