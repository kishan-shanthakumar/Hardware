module regfile (
    input logic clk, n_reset,
    input logic [4:0] rs1_dec, rs2_dec, rs3_dec, rd_wb,
    input logic reg_type_dec, reg_type_wb,
    input logic [63:0] op_wb,
    input logic we_rd_wb,
    output logic [63:0] op1_dec, op2_dec, op3_dec
);

logic [63:0] reg_int [31:0];
logic [63:0] reg_float [31:0];

always_ff @( posedge clk, negedge n_reset ) begin : ff_op
    if (!n_reset)
    begin
        for (int i = 0; i < 32; i++) begin
            reg_int[i] <= 0;
            reg_float[i] <= 0;
        end
    end
    else if (we_rd_wb)
    begin
        if (reg_type_wb)
        begin
            reg_float[rd_wb] <= op_wb;
        end
        else
        begin
            reg_int[rd_wb] <= op_wb;
        end
    end
end

always_comb begin : regfile_op_logic
    if (reg_type_dec)
    begin
        op1_dec = reg_float[rs1_dec];
        op2_dec = reg_float[rs2_dec];
        op3_dec = reg_float[rs3_dec];
    end
    else
    begin
        op1_dec = reg_int[rs1_dec];
        op2_dec = reg_int[rs2_dec];
        op3_dec = reg_int[rs3_dec];
    end
end

endmodule