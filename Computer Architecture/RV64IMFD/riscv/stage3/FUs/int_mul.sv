module int_mul #(
	parameter N = 32,
	parameter mul_size = 8,
	parameter use_dsp = 0
) (
    input logic [N-1:0] a,b,
	output logic [N-1:0] mul,
	output logic [N-1:0] mulh
);


parameter int num_mul = N/mul_size;
parameter int tot = (num_mul * num_mul) / 3;
parameter int num_pp = (tot + 1) * 3;

logic [2*mul_size-1:0] partial_products [num_mul-1:0][num_mul-1:0];
logic [2*N-1:0] product;
logic [2*N-1:0] partial_products_wallace [num_pp-1:0];

genvar i,j;
generate
	for(i = 0; i < num_mul; i++)
	begin
		for(j = 0; j < num_mul; j++)
		begin
			sub_mul #(mul_size, use_dsp) u1 (a[(i*mul_size)+:mul_size], b[(j*mul_size)+:mul_size], partial_products[i][j]);
		end
	end
endgenerate

genvar k,l,m;
generate
	for(k = 0; k < num_mul; k++)
	begin
		for(l = 0; l < num_mul; l++)
		begin
			assign partial_products_wallace[(num_mul*k)+l] = '0;
			assign partial_products_wallace[(num_mul*k)+l][((k+l)*mul_size)+:(2*mul_size)] = partial_products[k][l];
		end
	end
	for(m = tot*3; m < num_pp; m++)
	begin
		assign partial_products_wallace[m] = '0;
	end
endgenerate

wallace_tree_addition #((num_pp),2*N) u1(partial_products_wallace, product);
assign {mulh, mul} = product;

endmodule