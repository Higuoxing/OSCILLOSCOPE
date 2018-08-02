`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/27 21:13:42
// Design Name: 
// Module Name: Vrms_calc
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


module Vrms_calc(
	input wire sys_clk,
	input wire rst_n
    );
    
    initial begin
    
    end
    
    always @ (posedge sys_clk or negedge rst_n) begin
    	if (!rst_n) begin
    	
    	end
    end
    
endmodule
