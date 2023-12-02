function [127:0] add (input [127:0] inp1, input [127:0] inp2);
    logic [127:0] cseladd_result;
    cseladd #(128) u1(inp1, inp2, 0, cseladd_result);
    add = cseladd_result;
endfunction

module sub_mul #(
	parameter mul_size = 8,
	parameter use_dsp = 0
) (
	input logic [mul_size-1:0] a,b,
	output logic [2*mul_size-1:0] out
);

logic [2*mul_size-1:0] temp_loop_product;
logic [mul_size-1:0] iter_temp_product;
logic [2*mul_size-1:0] product;

always_comb
begin
	temp_loop_product = '0;
	for(int i = 0; i < mul_size; i++)
	{
		for(int j = 0; j < mul_size; j++)
		{
			iter_temp_product[j] = a[j]&b[i];
		}
		temp_loop_product = add(temp_loop_product, {iter_temp_product,{i{1'b0}}});
	}
	product = temp_loop_product;
end

always_comb
begin
	if (use_dsp == 1)
		out = a * b;
	else
		out = product;
end

endmodule

module int_mul #(
	parameter N = 32,
	parameter mul_size = 8,
	parameter use_dsp = 0
) (
    input logic [N-1:0] a,b,
	output logic [N-1:0] mul,
	output logic [N-1:0] mulh
);

genvar i,j;
generate
	for(i = 0; i < (int)(N/mul_size); i++)
	{
		for(j = 0; j < mul_size-1; j++)
		{
			// calculate partial products
		}
	}
endgenerate

// add partial products in hierarchical fashion

endmodule