module carrysaveadder #(
    parameter N=32
)(
    input logic [N-1:0] a,b,c,
    output logic [N-1:0] carry, sum
);

always_comb
begin
    carry[0] = 0;
    for(int i = 0; i < N-1; i++)
    begin
        sum[i] = a[i] ^ b[i] ^ c[i];
        carry[i+1] = ((a[i] ^ b[i]) & c[i]) | (a[i] & b[i]);
    end
    sum[N-1] = a[N-1] ^ b[N-1] ^ c[N-1];
end

endmodule