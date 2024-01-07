module  arbiter #(
    parameter num_masters = 4
) (
    input logic clk, n_reset,
    input axi4lite_MOSI_t slave_in [num_masters-1:0],
    output axi4lite_MISO_t master_in [num_masters-1:0]
    input axi4lite_MISO_t slave_out,
    output axi4lite_MOSI_t slave_in
);

logic [$clog2(num_masters)-1:0] priority_read [num_masters-1:0];
logic [$clog2(num_masters)-1:0] priority_write [num_masters-1:0];

always_ff @( posedge clk, negedge n_reset )
begin
    if (!n_reset)
    begin
        for (int i = 0; i < num_masters; i++)
        begin
            priority_read[i] = i;
            priority_write[i] = i;
        end
    end
    else
    begin
        
    end
end

endmodule