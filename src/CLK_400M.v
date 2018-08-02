`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:20:12
// Design Name: 
// Module Name: CLK_400M
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


module CLK_400M(
    input wire sys_clk,
    input wire rst_n,
    output wire clk_400MHz
    );
    wire clk_200MHz;
    
     CLKING_manager clk_400_gen(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_200MHz(clk_200MHz),
        .clk_400MHz(clk_400MHz)
    );
endmodule

//module CLKING_manager(
//    input wire sys_clk,
//    input wire rst_n,
//    output reg clk_200MHz,
//    output wire clk_400MHz
//    );