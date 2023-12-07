module int_mul #(
	parameter N = 32,
	parameter mul_size = 8,
	parameter use_dsp = 0
) (
    input logic [N-1:0] a,b,
	output logic [N-1:0] mul,
	output logic [N-1:0] mulh
);

logic [2*mul_size-1:0] partial_products [(int)(N/mul_size)][(int)(N/mul_size)];
logic [2*N-1:0] product;
logic [2*N-1:0] partial_products_wallace [N-1:0];

genvar i,j;
generate
	for(i = 0; i < (int)(N/mul_size); i++)
	begin
		for(j = 0; j < (int)(N/mul_size); j++)
		begin
			sub_mul #{mul_size, use_dsp} u1 {a[(i*mul_size)+:mul_size], b[(j*mul_size)+:mul_size], partial_products[i][j]};
		end
	end
endgenerate

always_comb
begin
	for(int i = 0; i < (int)(N/mul_size); i++)
	begin
		for(int j = 0; j < (int)(N/mul_size); j++)
		begin
			partial_products_wallace[i][j*mul_size:+mul_size] = partial_products[i][j];
		end
	end
end

wallace_tree_addition #(64) u1(partial_products_wallace, product);
assign {mulh, mul} = product;

endmodule