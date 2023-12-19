import crossbar::axi4lite_MISO_t;
import crossbar::axi4lite_MOSI_t;

module axi4lite_crossbar #(
    parameter num_masters = 4,
    parameter num_slaves = 4,
) (
    input axi4lite_MOSI_t proc_out [num_masters-1:0],
    output axi4lite_MISO_t proc_in [num_masters-1:0],
    output axi4lite_MOSI_t slave_in [num_slaves-1:0],
    input axi4lite_MISO_t slave_out [num_slaves-1:0]
);

endmodule