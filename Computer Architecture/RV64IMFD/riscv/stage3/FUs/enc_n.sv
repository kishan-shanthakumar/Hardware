module enc_n #(parameter N = 5)
			    (output logic [N-1:0] out,
				output logic valid,
				input logic [2**N-1:0] inp);

always_comb
begin
	valid = 0;
	out = 0;
	for (int i = 2**N-1; i >= 0; i--)
		if (inp[i] == 1)
		begin
			out = i;
			valid = 1;
			break;
		end
end

endmodule
