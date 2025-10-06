module GPR (
  input  logic        clk,
  input  logic [7:0]  data_in,
  input  logic [2:0]  address,
  input  logic        write_enable,
  input  logic        read_enable,
  input  logic        alu_en,
  output logic [7:0]  data_out,
  output logic [7:0]  ALU_output_1,
  output logic [7:0]  ALU_output_2
);

  // 16 General Purpose Registers (8-bit)
  reg [7:0] GPR [0:7];

 

  always_ff @(posedge clk) begin
    // Write to register file
    if (write_enable) begin
      GPR[address] <= data_in;
    end

    // Read logic
    if (read_enable) begin
      data_out <= GPR[address];
    end else begin
      data_out <= 8'h00;
    end

    // ALU register output logic
    if (alu_en) begin
      ALU_output_1 <= GPR[0]; // Assume operands stored in GPR[0] and GPR[1]
      ALU_output_2 <= GPR[1];
    end else begin
      ALU_output_1 <= 8'h00;
      ALU_output_2 <= 8'h00;
    end
  end

endmodule
