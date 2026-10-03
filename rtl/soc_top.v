module soc_top (
    input  wire        MAX10_CLK1_50, 
    input  wire [1:0]  KEY,          
    input  wire [9:0]  SW,            
    output wire [9:0]  LEDR,       
    output wire [6:0]  HEX0,          
    output wire [6:0]  HEX1           
);

    wire clk = MAX10_CLK1_50;
    wire rst = ~KEY[0];
    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire [31:0] mem_read_data;
    wire        mem_write_en;
    wire        mem_read_en;
    reg [9:0]  reg_leds;
    reg [31:0] reg_hex;

    assign LEDR = reg_leds;
    riscv_top cpu (
        .clk(clk),
        .rst(rst),
        .pc_out(pc),
        .instr(instr),
        .alu_result(mem_addr),             
        .mem_data_write(mem_write_data),  
        .mem_data_read(mem_read_data),    
        .mem_read(mem_read_en),           
        .mem_write(mem_write_en)         
    );
    wire is_ram_addr  = (mem_addr < 32'h0000_1000);
    wire ram_write_en = mem_write_en && is_ram_addr;
    wire [31:0] ram_read_data;
    memory ram (
        .clk(clk),
        .write_en(ram_write_en),
        .addr(mem_addr),
        .write_data(mem_write_data),
        .read_data(ram_read_data)
    );
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_leds <= 10'b0;
            reg_hex  <= 32'b0;
        end else if (mem_write_en) begin
            if (mem_addr == 32'h8000_0000)
                reg_leds <= mem_write_data[9:0];
            else if (mem_addr == 32'h8000_0004)
                reg_hex  <= mem_write_data;
        end
    end
    assign mem_read_data = (mem_addr == 32'h8000_0008) ? {22'b0, SW} : ram_read_data;
    hex_decoder hex0_inst (.hex_digit(reg_hex[3:0]), .seg(HEX0));
    hex_decoder hex1_inst (.hex_digit(reg_hex[7:4]), .seg(HEX1));

endmodule