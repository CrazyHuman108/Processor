module decoder(
  input logic clk,
  input logic [7:0] instruction,
  
  output logic RAM_rd_en,
  output logic RAM_wr_en,
  output logic [1:0] RAM_address,
  
  output logic ROM_rd_en,
  output logic ROM_kernal_en,
  output logic ROM_rst_n,
  
  output logic GPR_wr_en,
  output logic GPR_rd_en,
  output logic GPR_alu_en,
  output logic [2:0] GPR_address,
  
  output logic [1:0] sel_decR2R,
  
  output logic alu_en,
  output logic [2:0] alu_code
  
);
  
  logic RAM_rd_en_signal = 0;
  logic RAM_wr_en_signal = 0;
  logic [1:0] RAM_address_signal = 0;
  
  logic ROM_rd_en_signal = 0;
  logic ROM_kernal_en_signal = 0;
  logic ROM_rst_n_signal = 0;
  
  logic [1:0] ROM_counter = 0;
  logic RAM_counter = 0;
  
  logic GPR_rd_en_signal = 0;
  logic GPR_wr_en_signal = 0;
  logic GPR_alu_en_signal = 0;
  logic [2:0] GPR_address_signal = 0;
  logic [1:0] sel_decR2R_signal = 0;
  
  always_ff @(posedge clk)
    begin
      if (instruction[7:5] == 3'b001)
        begin
          ROM_counter <= ROM_counter + 1;
        end
      else 
        ROM_counter <= 0;
      
      if (instruction[7:5] == 3'b010)
        begin
          RAM_counter = ~RAM_counter;
        end
    end
  
  always_ff @(posedge clk)
    begin
      case(instruction[7:5])
        3'b000: begin
          RAM_wr_en_signal <= 1;
          RAM_rd_en_signal <= 0;
          RAM_address_signal <= instruction[1:0];
        end
        
        3'b001: begin
          case(ROM_counter)
            2'b01: begin  // read index from RAM
              sel_decR2R_signal <= 2'b00;
              RAM_rd_en_signal <= 1;
              RAM_wr_en_signal <= 0;
              RAM_address_signal <= instruction[1:0];
            end
           
            2'b10: begin // pass it to ROM
              ROM_rst_n_signal <= 1;
              ROM_rd_en_signal <= 1;
              ROM_kernal_en_signal <= 0;
            end
            
            2'b11: begin // write in GPR
              GPR_rd_en_signal <= 0;
              GPR_wr_en_signal <= 1;
              GPR_alu_en_signal <= 0;
              GPR_address_signal <= instruction[4:2];
            end
            default: begin
              // Handle unexpected values
              RAM_rd_en_signal <= 0;
              RAM_wr_en_signal <= 0;
              ROM_rd_en_signal <= 0;
              ROM_kernal_en_signal <= 0;
              ROM_rst_n_signal <= 0;
              GPR_rd_en_signal <= 0;
              GPR_wr_en_signal <= 0;
              GPR_alu_en_signal <= 0;
              sel_decR2R_signal <= 0;
            end
          endcase
        end
        
        // RMOV GPR address RAM address
        3'b010: begin
          if(instruction[1:0] !=  00)
            begin
              case(RAM_counter)
                1: begin // reading from RAM
                  RAM_rd_en_signal <= 1;
                  RAM_wr_en_signal <= 0;
                  RAM_address_signal <= instruction[1:0];
                end
                0: begin // Writing to GPR
                  GPR_rd_en_signal <= 0;
                  GPR_wr_en_signal <= 1;
                  GPR_address_signal <= instruction[4:2];
                end
              endcase
              
            end
          
          3'b011: begin
            alu_en <= 1;
            alu_code <= instruction[7:5];
          end

        end
        default: begin
          // Handle unexpected values
          RAM_rd_en_signal <= 0;
          RAM_wr_en_signal <= 0;
          ROM_rd_en_signal <= 0;
          ROM_kernal_en_signal <= 0;
          ROM_rst_n_signal <= 0;
          GPR_rd_en_signal <= 0;
          GPR_wr_en_signal <= 0;
          GPR_alu_en_signal <= 0;
          sel_decR2R_signal <= 0;
        end
      endcase
    end
  
  assign RAM_rd_en = RAM_rd_en_signal;
  assign RAM_wr_en = RAM_wr_en_signal;
  assign RAM_address = RAM_address_signal;
  assign ROM_rd_en = ROM_rd_en_signal;
  assign ROM_kernal_en = ROM_kernal_en_signal;
  assign ROM_rst_n = ROM_rst_n_signal;
  assign GPR_rd_en = GPR_rd_en_signal;
  assign GPR_wr_en = GPR_wr_en_signal;
  assign GPR_address = GPR_address_signal;
  assign sel_decR2R = sel_decR2R_signal;
  
endmodule
