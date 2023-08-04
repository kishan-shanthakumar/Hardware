// 32 base XLEN registers
// 32 fp 64 bit registers since D is added in the ISA

module regfile (input logic [4:0] r1_addr, r2_addr, r3_addr, w1_addr,
                input logic [63:0] inp_data,
                output logic [63:0] r1_data, r2_data, r3_addr,
                input logic sel_i_f,
                input logic clk, rst, write);

logic [63:0] base_reg [0:31];
logic [63:0] fp_reg [0:31];

always_comb
begin
    r1_data = (sel_i_f == 1'b1) ? fp_reg[r1_addr] : base_reg[r1_addr];
    r2_data = (sel_i_f == 1'b1) ? fp_reg[r2_addr] : base_reg[r2_addr];
    r3_data = (sel_i_f == 1'b1) ? fp_reg[r3_addr] : base_reg[r3_addr];
end

always_ff @(posedge clk, negedge rst)
begin
    if (!rst)
    begin
        for(integer i = 0; i < 32; i++)
        begin
            base_reg[i] <= 0;
            fp_reg[i] <= 0;
        end
    end
    else if(write)
    begin
        if(sel_i_f == 1'b1)
            fp_reg[w1_addr] <= inp;
        else
            base_reg[w1_addr] <= inp_data;
    end
end

endmodule