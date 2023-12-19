// qnan 7fc00000
// snan 7fa00000
// addition of +inf -inf = qnan
// addition of inf nan = 

// 000 -> RNE Round to Nearest, ties to Even
// 001 -> RTZ Round to Zero
// 010 -> RDN Round Down
// 011 -> RUP Round Up
// 100 -> RMM Round to Nearest, ties to Max Magnitude

module fadd #(
    parameter N = 32,
    parameter pipe = 1
) (
    input logic [N-1:0] a, b,
    input logic [2:0] frm,
    input logic valid,
    output logic [N-1:0] out
);

`ifdef N == 64
    parameter exp = 62;
    parameter man = 51;
    parameter exp_len = 11;
    parameter enc_len = 6;
`else
    parameter exp = 30;
    parameter man = 22;
    parameter exp_len = 8;
    parameter enc_len = 5;
`endif

logic [exp_len-1:0] shft_amtab, shft_amtba;
logic [N:0] ff1a, ff1b;
logic sub;
logic [N+1:0] ff2;
logic [man+2:0] ff2_ans;

cseladd #(exp_len) u1(a[exp:man+1],~b[exp:man+1],1,shft_amtab);
cseladd #(exp_len) u2(b[exp:man+1],~a[exp:man+1],1,shft_amtba);
cseladd #(man+2) u3(ff1a[man+1:0], ff1b[man+1:0], sub, ff2[man+2:0]);

assign sub = a[N-1] ^ b[N-1];

always_comb
begin
    if (a[exp:man+1] == b[exp:man+1])
    begin
        ff1a = {a[N-1:man+1], 1'b1, a[man:0]};
        ff1b = {b[N-1:man+1], 1'b1, b[man:0]};
    end
    else if ($signed(a[exp:man+1]-(2**(exp_len-1)-1)) > $signed(b[exp:man+1]-(2**(exp_len-1)-1)))
    begin
        ff1a = {a[N-1:man+1], 1'b1, a[man:0]};
        ff1b[N:man+1] = {a[N-1], b[exp:man+1], 1'b0};
        ff1b[man:0] = {{1'b1, b[man:0]} >> shft_amtab} ^ {man{sub}};
    end
    else
    begin
        ff1b[N:man+1] = {b[N-1], a[exp:man+1], 1'b0};
        ff1b[man:0] = {{1'b1, a[man:0]} >> shft_amtba} ^ {man{sub}};
        ff1a = {b[N-1:man+1], 1'b1, b[man:0]};
    end
    ff2[man+2:0] = ff2_ans;
    ff2[N-1:man+3] = ff1a[N-1:man+2];
end

endmodule