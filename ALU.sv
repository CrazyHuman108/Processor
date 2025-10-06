module ALU (
  input  logic              alu_enable,          // Enable ALU operation
  input  logic [2:0]         ALU_code,            // ALU operation selector
  input  logic signed [7:0]  ALU_input_1,         // First ALU operand
  input  logic signed [7:0]  ALU_input_2,         // Second ALU operand
  output logic [7:0]         ALU_output,          // Output magnitude (always positive if signed result)
  output logic               sign                 // 1 if result is negative, 0 if positive
);

  // Internal temporary signals
  logic signed [8:0]  temp_result;                 // 9 bits to handle addition overflow
  logic signed [15:0] multiplication_result;       // 16 bits to handle multiplication result

  always_comb begin
    // Default output values
    temp_result           = 9'sd0;
    multiplication_result = 16'sd0;
    ALU_output            = 8'd0;
    sign                  = 1'b0;

    if (alu_enable) begin
      case (ALU_code)
        3'b001: begin
          // ADDITION Operation
          temp_result = ALU_input_1 + ALU_input_2;
          
          if (temp_result < 0) begin
            ALU_output = -temp_result[7:0]; // Magnitude (positive value)
            sign       = 1'b1;              // Set sign bit
          end else begin
            ALU_output = temp_result[7:0];
            sign       = 1'b0;
          end
        end

        3'b010: begin
          // MULTIPLICATION Operation
          multiplication_result = ALU_input_1 * ALU_input_2;
          ALU_output = multiplication_result[14:7]; // Middle bits (scaling)
          sign       = multiplication_result[15];   // Sign of full result
        end

        default: begin
          // Unsupported ALU_code: Output zero
          ALU_output = 8'd0;
          sign       = 1'b0;
        end
      endcase
    end
  end

endmodule
