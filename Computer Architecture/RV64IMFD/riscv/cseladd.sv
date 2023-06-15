module cseladd #(parameter N = 32)
		(input logic [N-1:0] a,b,
		input logic cin,
		output logic [N:0] out);

logic [N-1:0] carry1;
logic [N-1:0] sum1;
logic [N-1:0] carry0;
logic [N-1:0] sum0;
logic [N:0] carry;

always_comb
begin
    carry[0] = cin;
    
    for(int i = 0; i < N ; i++)
    begin
        sum0[i] = a[i] ^ b[i];
        carry0[i] = a[i] & b[i];
        sum1[i] = a[i] ^ b[i] ^ 1;
        carry1[i] = (a[i] & b[i]) + (a[i] ^ b[i]);
    end

    for(int i = 0; i < N ; i++)
    begin
        out[i] = carry[i] ? sum1[i] : sum0[i];
        carry[i+1] = carry[i] ? carry1[i] : carry0[i];
    end
    out[N] = carry[N];
end

endmodule
