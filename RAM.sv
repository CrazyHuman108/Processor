module RAM(
  input logic clk,
  input logic rd_en,
  input logic wr_en,
  input logic [1:0] address,
  input logic [7:0] data_in,
  output logic [7:0] data_out
);
  logic [7:0] RAM [0:3];

  always_ff @(posedge clk) begin
    if (wr_en) begin
      RAM[address] <= data_in;
    end

    if (rd_en) begin
      data_out <= RAM[address];
    end 
  end
endmodule
