`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 23:57:15
// Design Name: 
// Module Name: AD_clk_mux
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


module AD_clk_mux(
    input wire sys_clk,
    input wire rst_n,
    input wire [4:0] AD_clk_in,
    input wire [7:0] EN,
    output reg AD_clk_out,
    output wire EN_detect
    );

    reg [7:0] EN_detect_r0;
    reg [7:0] EN_detect_r1;
    
    initial begin
        EN_detect_r0 <= 8'd0;
        EN_detect_r1 <= 8'd0;
    end
    
    always @ (*) begin
        case (EN)
            8'b0000_0010 : AD_clk_out <= AD_clk_in[0];
            8'b0000_0100 : AD_clk_out <= AD_clk_in[1];
            8'b0000_1000 : AD_clk_out <= AD_clk_in[2];
            8'b0001_0000 : AD_clk_out <= AD_clk_in[3];
            8'b0010_0000 : AD_clk_out <= AD_clk_in[4];
            default      : AD_clk_out <= AD_clk_in[4];
        endcase
    end
    
    // detect changes of EN
    assign EN_detect = (EN_detect_r0 == EN_detect_r1) ? 1'b0: 1'b1;
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            EN_detect_r0 <= 8'd0;
            EN_detect_r1 <= 8'd0;
        end
        else begin
            EN_detect_r0 <= EN;
            EN_detect_r1 <= EN_detect_r0;
        end
    end
    
endmodule
