
module PC(
    input logic clk,
    input logic rst,
    input logic branch_en,
    input logic loop_en,
    input logic [3:0] repetation_count,
    input logic [3:0] line_count,
    input logic [3:0] target_address,
    output logic [3:0] pc
);

    // Internal signals
    logic [3:0] count;
    logic [3:0] main_count;
    logic [3:0] loop_start_pc;
    logic in_loop;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 4'd0;
            count <= 4'd0;
            main_count <= 4'd0;
            loop_start_pc <= 4'd0;
            in_loop <= 1'b0;
        end 
        else begin
            if (branch_en) begin
                pc <= target_address;
                in_loop <= 1'b0;
                count <= 4'd0;
                main_count <= 4'd0;
            end 
            else if (loop_en && !in_loop) begin
                // First time entering loop: capture NEXT instruction (pc+1)
                loop_start_pc <= pc + 1;
                in_loop <= 1'b1;
                pc <= pc + 1;
                count <= 4'd1;
                main_count <= 4'd0;
            end 
            else if (in_loop) begin
                if (count < line_count) begin
                    pc <= pc + 1;
                    count <= count + 1;
                end 
                else begin
                    main_count <= main_count + 1;
                    if (main_count + 1 < repetation_count) begin
                        pc <= loop_start_pc;
                        count <= 4'd1;
                    end 
                    else begin
                        pc <= loop_start_pc + line_count;
                        in_loop <= 1'b0;
                        count <= 4'd0;
                        main_count <= 4'd0;
                    end
                end
            end 
            else begin
                pc <= pc + 1;
            end
        end
    end

endmodule
