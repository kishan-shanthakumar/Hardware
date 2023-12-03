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

genvar i,j;
generate
	for(i = 0; i < (int)(N/mul_size); i++)
	{
		for(j = 0; j < (int)(N/mul_size); j++)
		{
			sub_mul #{mul_size, use_dsp} u1 {a[(i*mul_size)+:mul_size], b[(j*mul_size)+:mul_size], partial_products[i][j]};
		}
	}
endgenerate

// add partial products in hierarchical fashion

endmodule