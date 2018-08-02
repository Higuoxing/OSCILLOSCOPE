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


module ANALOG_sampl_4 (
    input wire sys_clk,
    input wire rst_n,
    output reg samp_clk
    );

    reg [31:0] samp_clk_cnt;
    
    initial begin
        samp_clk_cnt <= 32'd0;
        samp_clk <= 1'b0;
    end
    
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            samp_clk <= 1'b0;
            samp_clk_cnt <= 32'd0;
        end
        else if (samp_clk_cnt == 49) begin
            samp_clk <= ~ samp_clk;
            samp_clk_cnt <= 32'd0;
        end
        else samp_clk_cnt <= samp_clk_cnt + 1;
    end

endmodule