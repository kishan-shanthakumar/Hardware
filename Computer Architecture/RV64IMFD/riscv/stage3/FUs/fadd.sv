// qnan 7fc00000
// snan 7fa00000
// addition of +inf -inf = qnan
// addition of inf nan = 

// 000 -> RNE Round to Nearest, ties to Even
// 001 -> RTZ Round to Zero
// 010 -> RDN Round Down
// 011 -> RUP Round Up
// 100 -> RMM Round to Nearest, ties to Max Magnitude

// of -> overflow
// uf -> underflow
// nx -> inexact
// inv -> invalid

'define snan 32'h7fa00000
'define qnan 32'h7fc00000

module fadd #(
    parameter N = 32,
    parameter pipe = 1
) (
    input logic [N-1:0] a, b,
    input logic [2:0] frm,
    input logic valid,
    output logic [N-1:0] out.
    output logic of, uf, nx, inv
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
logic [N:0] ff1a, ff1b, ff1a_pipe, ff1b_pipe;
logic sub;
logic [N+1:0] ff2, ff2_pipe;
logic [man+2:0] ff2_ans;
logic [man:0] ff3_man;
logic [N-1:0] ff3, ff3_pipe;
logic [2:0] frm_d1, frm_d2;

cseladd #(exp_len) u1(a[exp:man+1],~b[exp:man+1],1,shft_amtab);
cseladd #(exp_len) u2(b[exp:man+1],~a[exp:man+1],1,shft_amtba);
cseladd #(man+2) u3(ff1a_pipe[man+1:0], ff1b_pipe[man+1:0], sub, ff2[man+2:0]);

assign sub = a[N-1] ^ b[N-1];

always_comb
begin
    if (a[exp:man+1] == b[exp:man+1])
    begin
        if(a[man:0] > b[man:0])
        begin
            ff1a = {a[N-1:man+1], 1'b1, a[man:0]};
            ff1b = {a[N-1], b[exp:man+1], {{1'b1, b[man:0]} ^ {(man+1){sub}}}};
        end
        else
        begin
            ff1a = {b[N-1:man+1], 1'b1, b[man:0]};
            ff1b = {b[N-1], a[exp:man+1], {{1'b1, a[man:0]} ^ {(man+1){sub}}}};
        end
    end
    else if ($signed(a[exp:man+1]-(2**(exp_len-1)-1)) > $signed(b[exp:man+1]-(2**(exp_len-1)-1)))
    begin
        ff1a = {a[N-1:man+1], 1'b1, a[man:0]};
        ff1b[N:man+2] = {a[N-1], b[exp:man+1]};
        ff1b[man+1:0] = {{1'b1, b[man:0]} >> shft_amtab} ^ {(man+1){sub}};
    end
    else
    begin
        ff1b[N:man+2] = {b[N-1], a[exp:man+1]};
        ff1b[man+1:0] = {{1'b1, a[man:0]} >> shft_amtba} ^ {(man+1){sub}};
        ff1a = {b[N-1:man+1], 1'b1, b[man:0]};
    end
    if ((ff1a[exp:0] == ff1b[exp:0]) && (ff1a[N-1] != ff1b[N-1]))
    begin
        ff2 = '0;
    end
    else
    begin
        ff2[man+2:0] = ff2_ans;
        ff2[N+1:man+3] = ff1a[N:man+2];
    end
    ff3[N-1] = ff2[N-1];
    if(ff2[man+2] == 1'b1)
    begin
        if(ff2[N+1:man+3] == 8'b254)
        begin
            ff3[exp:man+1] = '1;
            ff3[man:0] = '0;
        end
        else
        begin
            ff3[exp:man+1] = ff2[N+1:man+3]-1;
            ff3[man:1] = ff2[man+1:2];
            case(frm_d2)
            3'b000 ff3[0] = ; break
            3'b001 ff3[0] = ; break
            3'b010 ff3[0] = ; break
            3'b011 ff3[0] = ; break
            3'b100 ff3[0] = ; break
            endcase
        end
    end
    else if(ff2[man+1] == 1'b1)
    begin
        ff3[exp:man+1] = ff2[N+1:man+3];
        ff3[man:0] = ff2[man:0];
    end
    else
    begin
        if ((ff2[N+1:man+3] == 8'b1) && (ff3[man:-2] == 2'b0) | (ff2 == '0))
        begin
            ff3 = '0;
        end
    end
    out = ff3;
end

`ifdef pipe
always_ff @(posedge clk)
begin
    ff1a_pipe <= ff1a;
    ff1b_pipe <= ff1b;
    ff2_pipe <= ff2;
    ff3_pipe <= ff3;
    frm_d1 <= frm;
    frm_d2 <= frm_d1;
end
`endif

`ifndef pipe
always_comb
begin
    ff1a_pipe = ff1a;
    ff1b_pipe = ff1b;
    ff2_pipe = ff2;
    ff3_pipe = ff3;
    frm_d1 = frm;
    frm_d2 = frm_d1;
end
`endif


endmodule