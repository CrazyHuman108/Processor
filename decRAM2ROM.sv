module decRAM2ROM(
  input logic [1:0] sel,
  input [7:0] RAM_output,
  output logic [7:0] main_ROM_address,
  output logic [2:0] ROM_kernal_address
);
  
  always_comb
    begin
      case(sel)
        2'b00: main_ROM_address <= RAM_output;
        2'b01: ROM_kernal_address <= RAM_output[2:0];
      endcase
    end
  
endmodule