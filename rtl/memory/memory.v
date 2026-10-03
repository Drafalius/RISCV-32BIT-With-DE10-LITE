module memory (
    input  wire        clk,
    input  wire        write_en,      
    input  wire [31:0] addr,          
    input  wire [31:0] write_data,    
    output wire [31:0] read_data      
);
    reg [31:0] ram [0:1023];        
    initial begin
        $readmemh("../firmware/program.hex", ram);
    end
    assign read_data = ram[addr[11:2]];
    always @(posedge clk) begin
        if (write_en) begin
            ram[addr[11:2]] <= write_data;
        end
    end

endmodule