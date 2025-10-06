module INST_MEM (
  input clk,
  input logic [3:0] address,  // 4-bit address (2^4 = 16 locations)
  output logic [7:0] data    // 16-bit data output
);

    // Memory array declaration
    logic [7:0] program_mem [0:15];
  
  initial begin
    $readmemh("instruction.hex", program_mem);
  end
  
  always_ff@(posedge clk)
    begin
      data <= program_mem[address];
    end
    

    

endmodule