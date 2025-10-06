module ROM(
  input logic clk,
  input logic rst_n,
  input logic rd_en,
  input logic kernal_en,       // Kernel enable signal
  input logic [7:0] address,   // Main memory address
  input logic [2:0] kernal_addr, // Kernel address (0-4)
  output logic [7:0] d_out     // Data output
);
  
  // Main memory with 256 bytes
  logic [7:0] mem [0:255] = '{
    8'hF6, 8'h02, 8'h0F, 8'h1A, 8'h10, 8'h13, 8'h2A, 8'h1F, 8'h2C, 8'h2C, 8'h3B, 8'h2D, 8'h2F, 8'h43, 8'h3C, 8'h50,
    8'h4F, 8'h40, 8'h55, 8'h4A, 8'h61, 8'h53, 8'h61, 8'h57, 8'h5D, 8'h61, 8'h6D, 8'h70, 8'h62, 8'h69, 8'h65, 8'h5E,
    8'h73, 8'h68, 8'h5D, 8'h65, 8'h62, 8'h65, 8'h55, 8'h5F, 8'h53, 8'h58, 8'h51, 8'h4F, 8'h58, 8'h5D, 8'h48, 8'h45,
    8'h41, 8'h50, 8'h49, 8'h3A, 8'h2C, 8'h3C, 8'h28, 8'h30, 8'h31, 8'h1A, 8'h13, 8'h13, 8'h0B, 8'h04, 8'h10, 8'h09,
    8'h06, 8'h02, 8'hED, 8'hEA, 8'hE2, 8'hEF, 8'hD6, 8'hD5, 8'hDC, 8'hDB, 8'hCB, 8'hCE, 8'hCC, 8'hC1, 8'hB4, 8'hBE,
    8'hBD, 8'hB9, 8'hA8, 8'hB6, 8'hB5, 8'h9E, 8'hB1, 8'hA8, 8'hA6, 8'hA1, 8'hAA, 8'hA6, 8'hA5, 8'hA2, 8'h99, 8'h94,
    8'h9F, 8'hA0, 8'hA6, 8'hA0, 8'hA2, 8'hA6, 8'hAA, 8'h9C, 8'hAD, 8'hAC, 8'hA6, 8'hAA, 8'hAF, 8'hA7, 8'hA4, 8'hBB,
    8'hAC, 8'hB7, 8'hCA, 8'hBB, 8'hD3, 8'hD5, 8'hD2, 8'hD5, 8'hE6, 8'hDA, 8'hD9, 8'hEC, 8'hF8, 8'hE7, 8'hEC, 8'hFE,
    8'h0A, 8'hFF, 8'h06, 8'h08, 8'h09, 8'h1C, 8'h21, 8'h2D, 8'h1D, 8'h2D, 8'h33, 8'h3F, 8'h41, 8'h3C, 8'h4C, 8'h49,
    8'h48, 8'h45, 8'h4E, 8'h59, 8'h54, 8'h63, 8'h5D, 8'h58, 8'h65, 8'h6C, 8'h6D, 8'h6D, 8'h66, 8'h70, 8'h5B, 8'h5B,
    8'h6F, 8'h71, 8'h68, 8'h5F, 8'h6F, 8'h63, 8'h6A, 8'h5F, 8'h58, 8'h5B, 8'h5D, 8'h5C, 8'h4E, 8'h50, 8'h4E, 8'h4F,
    8'h49, 8'h4A, 8'h48, 8'h40, 8'h3E, 8'h40, 8'h2B, 8'h2A, 8'h24, 8'h22, 8'h16, 8'h24, 8'h18, 8'h03, 8'h11, 8'hFC,
    8'h03, 8'hF9, 8'h02, 8'hF0, 8'hF0, 8'hF2, 8'hEA, 8'hD7, 8'hDA, 8'hCD, 8'hC6, 8'hD7, 8'hC3, 8'hBD, 8'hBA, 8'hB4,
    8'hC0, 8'hC1, 8'hAD, 8'hAA, 8'hB1, 8'hA6, 8'hB2, 8'hA1, 8'hA1, 8'h99, 8'hAB, 8'h97, 8'h9C, 8'hA4, 8'h98, 8'hA3,
    8'h8D, 8'h97, 8'hA1, 8'hA0, 8'h9C, 8'hA1, 8'h9E, 8'hA1, 8'hA3, 8'hAF, 8'hB1, 8'hB2, 8'hB4, 8'hA2, 8'hA9, 8'hB0,
    8'hB1, 8'hBA, 8'hBE, 8'hC4, 8'hD1, 8'hD2, 8'hD9, 8'hDC, 8'hE2, 8'hD1, 8'hE5, 8'hE0, 8'hED, 8'hFC, 8'hF4, 8'hEF
  };
  
  // Kernel memory with values [17, 29, 35, 29, 17]
  logic [7:0] kernal_mem [0:4] = '{8'd17, 8'd29, 8'd35, 8'd29, 8'd17};
  
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      d_out <= 8'h00;
    end
    else if (kernal_en) begin
      // Kernel memory access
      d_out <= kernal_mem[kernal_addr];
    end
    else if (rd_en) begin
      // Main memory access
      d_out <= mem[address];
    end
  end
  
endmodule