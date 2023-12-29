module  arbiter #(
    parameter num_masters = 4
) (
    input axi4lite_MOSI_t slave_in [num_slaves-1:0],
    output axi4lite_MISO_t slave_out [num_slaves-1:0]
);



endmodule