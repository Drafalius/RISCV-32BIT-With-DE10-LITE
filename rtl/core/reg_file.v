module reg_file (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write,   
    input  wire [4:0]  rs1_addr,    
    input  wire [4:0]  rs2_addr,   
    input  wire [4:0]  rd_addr,     
    input  wire [31:0] write_data,  
    output wire [31:0] rs1_data,    
    output wire [31:0] rs2_data     
);


    reg [31:0] registers [31:0];
    integer i;
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= write_data;
        end
    end

endmodule