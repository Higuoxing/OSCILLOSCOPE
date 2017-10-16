`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/30 06:10:40
// Design Name: 
// Module Name: SQUARE_wav_gen
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


module SQUARE_wav_gen(
    input wire sys_clk,
    input wire rst_n,
    output reg DA_clk,
    output reg [7:0] DA_digits
    );
    
    reg [31:0] DA_clk_cnt;
    reg clk_100K;
    reg [31:0] clk_100K_cnt;
    
    initial begin
        DA_clk <= 1'b0;
        clk_100K <= 1'b0;
        DA_clk_cnt <= 32'd0;
        clk_100K_cnt <= 32'd0;
    end
    
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            DA_clk <= 1'b0;
            DA_clk_cnt <= 32'd0;
        end
        else if (DA_clk_cnt == 4) begin
            DA_clk <= ~ DA_clk;
            DA_clk_cnt <= 32'd0;
        end
        else DA_clk_cnt <= DA_clk_cnt + 1;
    end
    
    // -- 100K clk gen
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_100K <= 1'b0;
            clk_100K_cnt <= 32'd0;
        end
        else if (clk_100K_cnt == 499) begin
            clk_100K <= ~ clk_100K;
            clk_100K_cnt <= 32'd0;
        end
        else clk_100K_cnt <= clk_100K_cnt + 1;
    end
    
    always @ (*) begin
        if (clk_100K) begin
            DA_digits <= 8'hff;
        end
        else DA_digits <= 8'h8f;
    end
    
endmodule
