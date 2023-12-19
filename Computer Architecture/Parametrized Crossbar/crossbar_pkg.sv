package crossbar;
    typedef struct {
        logic awready,

        logic wready,

        logic bresp,
        logic bvalid,

        logic arready,

        logic [63:0] rdata,
        logic rvalid,
        logic rresp
    } axi4lite_MISO_t;
    typedef struct {
        logic awvalid,
        logic [63:0] awaddr,
        logic [2:0] awprot,

        logic wvalid,
        logic [63:0] wdata,
        logic [7:0] wstrb,

        logic bready,

        logic arvalid,
        logic [63:0] araddr,
        logic [2:0] arprot,

        logic rready
    } axi4lite_MOSI_t;
endpackage