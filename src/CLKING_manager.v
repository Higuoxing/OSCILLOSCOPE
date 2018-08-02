`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 17:38:45
// Design Name: 
// Module Name: CLKING_manager
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


module CLKING_manager(
    input wire sys_clk,
    input wire rst_n,
    output reg clk_200MHz,
    output wire clk_400MHz
    );
    
    initial begin
        clk_200MHz <= 1'b0;
    end
    
    always @ (posedge clk_400MHz or negedge rst_n) begin
        if (!rst_n) begin
            clk_200MHz <= 1'b0;
        end
        else clk_200MHz <= ~ clk_200MHz;
    end
    
    clk_wiz_0 clk_400M_gen(
        .clk_out1(clk_400MHz),
        .resetn(rst_n),
        .clk_in1(sys_clk)
    );
    
endmodule

//module clk_wiz_0(clk_out1, resetn, clk_in1)
///* synthesis syn_black_box black_box_pad_pin="clk_out1,resetn,clk_in1" */;
//  output clk_out1;
//  input resetn;
//  input clk_in1;
//endmodule