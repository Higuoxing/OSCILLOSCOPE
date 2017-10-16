`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 18:00:32
// Design Name: 
// Module Name: CLKING_manager_simu
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


module CLKING_manager_simu();

    reg sys_clk;
    wire clk_200MHz;
    wire clk_400MHz;
    
    initial begin
        sys_clk <= 1'b0;
    end
    
    always @ (*) #5 sys_clk <= ~ sys_clk;

    
    CLKING_manager test(
        .sys_clk(sys_clk),
        .rst_n(1'b1),
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
