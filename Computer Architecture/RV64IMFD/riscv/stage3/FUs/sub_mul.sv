module sub_mul #(
	parameter mul_size = 8,
	parameter use_dsp = 0
) (
	input logic [mul_size-1:0] a,b,
	output logic [2*mul_size-1:0] out
);

logic [2*mul_size-1:0] temp_loop_product[mul_size:0];
logic [2*mul_size-1:0] iter_temp_product[mul_size-1:0];
logic [2*mul_size-1:0] product;

genvar i, j;
generate
	assign temp_loop_product[0] = '0;
	for(i = 0; i < mul_size; i++)
	begin
		for(j = 0; j < mul_size; j++)
		begin
			assign iter_temp_product[i][j] = a[j]&b[i];
		end
		assign iter_temp_product[i][2*mul_size-1:mul_size] = '0;
		cseladd #(2*mul_size) u1(temp_loop_product[i], (iter_temp_product[i]<<i), 0, temp_loop_product[i+1]);
	end
endgenerate

assign product = temp_loop_product[mul_size];

always_comb
begin
	if (use_dsp == 1)
		out = a * b;
	else
		out = product;
end

endmodule

