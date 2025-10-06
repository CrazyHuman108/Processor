`include "INST_mem.sv"
`include "decoder.sv"
`include "RAM.sv"
`include "decRAM2ROM.sv"
`include "ROM.sv"
`include "GPR.sv"
`include "ALU.sv"
`include "decGPR2ROM.sv"
`include "pc.sv"

module PICOMIPS(
  input logic clk, rst,
  input logic [7:0] index,
  output logic sign,
  output logic [7:0] out
);

  // Wires
  logic [5:0] INST_mem_address; // Updated to match PC output size
  logic RAM_rd_en;
  logic RAM_wr_en;
  logic ROM_rst_n;
  logic ROM_rd_en;
  logic ROM_kernal_en;
  logic GPR_wr_en;
  logic GPR_rd_en;
  logic GPR_alu_en;
  logic alu_en;
  logic [1:0] GPR_2_ROM_sel;
  logic [2:0] alu_code;
  logic [1:0] RAM_address;
  logic [1:0] sel_decR2R;
  logic [2:0] ROM_kernal_address_decoder;
  logic [2:0] ROM_kernal_address_r2r;
  logic [2:0] ROM_kernal_address;
  logic [2:0] GPR_address;
  logic [7:0] data_out_RAM;
  logic [7:0] main_ROM_address;
  logic [7:0] ROM_data_out;
  logic [7:0] inst_to_decoder;
  logic [7:0] GPR_out;
  logic [7:0] ALU_output_1;
  logic [7:0] ALU_input_2_from_GPR;
  logic [7:0] ALU_input_2_from_DEC2;
  logic [7:0] ALU_output_2;
  logic [7:0] ALU_out;
  logic branch_en;
  logic [3:0] target_address;

  // Output assignment
  assign out = ALU_out;

  // Program Counter
  PC P(
    .clk(clk),
    .rst(rst),
    .branch_en(branch_en),
    .target_address(target_address),
    .pc(INST_mem_address)
  );

  // Instruction Memory (using only 4 bits of address)
  INST_MEM IM (
    .clk(clk),
    .address(INST_mem_address[3:0]),
    .data(inst_to_decoder)
  );

  // Decoder
  decoder DEC(
    .clk(clk),
    .instruction(inst_to_decoder),
    .RAM_rd_en(RAM_rd_en),
    .RAM_wr_en(RAM_wr_en),
    .RAM_address(RAM_address),
    .sel_decR2R(sel_decR2R),
    .ROM_rst_n(ROM_rst_n),
    .ROM_rd_en(ROM_rd_en),
    .ROM_kernal_en(ROM_kernal_en),
    .GPR_wr_en(GPR_wr_en),
    .GPR_rd_en(GPR_rd_en),
    .GPR_alu_en(GPR_alu_en),
    .GPR_address(GPR_address),
    .alu_en(alu_en),
    .alu_code(alu_code),
    .GPR_2_ROM_sel(GPR_2_ROM_sel),
    .ROM_kernal_address(ROM_kernal_address_decoder)
  );

  // RAM
  RAM RMEM(
    .clk(clk),
    .rd_en(RAM_rd_en),
    .wr_en(RAM_wr_en),
    .address(RAM_address),
    .data_in(index),
    .data_out(data_out_RAM)
  );

  // decRAM2ROM
  decRAM2ROM DECR2R(
    .sel(sel_decR2R),
    .RAM_output(data_out_RAM),
    .main_ROM_address(main_ROM_address),
    .ROM_kernal_address(ROM_kernal_address_r2r)
  );

  // Select ROM kernel address from decoder or RAM logic
  assign ROM_kernal_address = ROM_kernal_en ? ROM_kernal_address_r2r : ROM_kernal_address_decoder;

  // ROM
  ROM ROM_inst(
    .clk(clk),
    .rst_n(ROM_rst_n),
    .rd_en(ROM_rd_en),
    .kernal_en(ROM_kernal_en),
    .address(main_ROM_address),
    .kernal_addr(ROM_kernal_address),
    .d_out(ROM_data_out)
  );

  // GPR
  GPR G (
    .clk(clk),
    .data_in(ROM_data_out),
    .address(GPR_address),
    .write_enable(GPR_wr_en),
    .read_enable(GPR_rd_en),
    .alu_en(GPR_alu_en),
    .data_out(GPR_out),
    .ALU_output_1(ALU_output_1),
    .ALU_output_2(ALU_input_2_from_GPR)
  );

  // decGPR2ROM
  decGPR2ROM DEC2(
    .GPR_2_ROM_sel(GPR_2_ROM_sel),
    .ROM_output(ROM_data_out),
    .ALU_out_1(ALU_output_1),
    .ALU_in(ALU_input_2_from_DEC2)
  );

  // MUX for ALU input 2
  assign ALU_output_2 = GPR_alu_en ? ALU_input_2_from_GPR : ALU_input_2_from_DEC2;

  // ALU
  ALU A (
    .alu_enable(alu_en),
    .ALU_code(alu_code),
    .ALU_input_1(ALU_output_1),
    .ALU_input_2(ALU_output_2),
    .ALU_output(ALU_out),
    .sign(sign)
  );

endmodule
