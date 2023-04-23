module bp( input logic [31:0] addr,
            input logic train,
            output logic valid,
            inout logic [31:0] paddr
);

struct {
    logic [31:0] address;
    logic [31:0] pred_address;
    logic [1:0] counter;
    logic valid;
} btb_ele;

btb_ele [2047:0] btb;
endmodule