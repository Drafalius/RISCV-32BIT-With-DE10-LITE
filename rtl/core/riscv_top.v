module riscv_top (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] pc_out,
    input  wire [31:0] instr,
    output wire [31:0] alu_result,
    output wire [31:0] mem_data_write,
    input  wire [31:0] mem_data_read,
    output wire        mem_read,
    output wire        mem_write
);
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] reg_write_data;
    wire [31:0] alu_b;
    wire [31:0] imm;
    wire        reg_write, alu_src, mem_to_reg, branch, zero;
    wire [3:0]  alu_ctrl;
    assign pc_plus_4 = pc_current + 32'd4;
    assign pc_branch = pc_current + imm;
    assign pc_next   = (branch && zero) ? pc_branch : pc_plus_4;
    assign pc_out    = pc_current;
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(pc_next),
        .pc(pc_current)
    );
    control_unit control_inst (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .alu_ctrl(alu_ctrl)
    );
    assign reg_write_data = mem_to_reg ? mem_data_read : alu_result;
    reg_file reg_file_inst (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .write_data(reg_write_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    imm_gen imm_gen_inst (
        .instr(instr),
        .imm(imm)
    );
    assign alu_b = alu_src ? imm : rs2_data;
    assign mem_data_write = rs2_data; 
    alu alu_inst (
        .a(rs1_data),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );
endmodule