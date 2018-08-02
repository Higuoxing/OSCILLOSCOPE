`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:16:12
// Design Name: 
// Module Name: ANALOG_sampl_400M
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ANALOG_sampl_0 (
    input wire sys_clk,
    input wire rst_n,
    output reg samp_clk
    );
    
    parameter max_delay_target = 99;
    
    wire clk_400M;
    reg [31:0] clk_1M_cnt;
    
    reg clk_1M;
    reg clk_1M_pos_detect_r0;
    reg clk_1M_pos_detect_r1;
    wire clk_1M_pos_detect;
    wire clk_1M_neg_detect;
    
    reg delay_done;
    reg [31:0] delay_cnt;
    reg [31:0] delay_target;
    
    initial begin
        clk_1M_cnt <= 32'd0;
        clk_1M <= 1'b0;
        clk_1M_pos_detect_r0 <= 1'b0;
        clk_1M_pos_detect_r1 <= 1'b0;
        samp_clk <= 1'b0;
        delay_done <= 1'b0;
        delay_cnt <= 32'd0;
        delay_target <= 32'd0;
    end
    
    // -- 400MHz clock generator
    CLK_400M clk_400MHz (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_400MHz(clk_400M)
    );
    
    // -- 1MHz clock generator
    always @ (posedge clk_400M or negedge rst_n) begin
        if (!rst_n) begin
            clk_1M <= 1'b0;
        end
        else if (clk_1M_cnt == 99) begin
            clk_1M <= ~ clk_1M;
            clk_1M_cnt <= 32'd0;
        end
        else clk_1M_cnt <= clk_1M_cnt + 1;
    end
    
    // -- samp_clk generator
    always @ (posedge clk_400M or negedge rst_n) begin
        if (!rst_n) begin
            samp_clk <= 1'b0;
        end
        else if (clk_1M && delay_done) begin
            samp_clk <= 1'b1;
        end
        else samp_clk <= 1'b0;
    end
    
    // -- detect the posedge& negedge of clk_1M
    assign clk_1M_pos_detect = (clk_1M_pos_detect_r0 &&
                                !clk_1M_pos_detect_r1) ? 1'b1: 1'b0;
    assign clk_1M_neg_detect = (!clk_1M_pos_detect_r0 &&
                                 clk_1M_pos_detect_r1) ? 1'b1: 1'b0;
    always @ (posedge clk_400M or negedge rst_n) begin
        if (!rst_n) begin
            clk_1M_pos_detect_r0 <= 1'b0;
            clk_1M_pos_detect_r1 <= 1'b0;
        end
        else begin
            clk_1M_pos_detect_r0 <= clk_1M;
            clk_1M_pos_detect_r1 <= clk_1M_pos_detect_r0;
        end
    end
    
    // -- set delay_done flag
    always @ (posedge clk_400M or negedge rst_n) begin
        if (!rst_n) begin
            delay_done <= 1'b0;
        end
        else if (clk_1M && delay_cnt == delay_target) begin
            delay_done <= 1'b1;
            delay_cnt <= delay_cnt;
        end
        else if (clk_1M && delay_cnt != delay_target) begin
            delay_done <= delay_done;
            delay_cnt <= delay_cnt + 1;
        end
        else if (clk_1M_neg_detect) begin
            delay_done <= 1'b0;
            delay_cnt <= 32'd0;
        end
        else begin
            delay_done <= delay_done;
            delay_cnt <= delay_cnt;
        end
    end
    
    // -- delay_target counter
    always @ (posedge clk_400M or negedge rst_n) begin
        if (!rst_n) begin
            delay_target <= 32'd0;
        end
        else if (clk_1M_neg_detect && delay_target == max_delay_target) begin
            delay_target <= 32'd0;
        end
        else if (clk_1M_neg_detect && delay_target != max_delay_target) begin
            delay_target <= delay_target + 1;
        end
        else delay_target <= delay_target;
    end

endmodule