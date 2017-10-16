`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 00:55:53
// Design Name: 
// Module Name: CACHE_controller
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


module CACHE_controller(
    input wire sys_clk,    // -- sys_clk = 100MHz
    input wire samp_clk,
    input wire rst_n,
    input wire CS_N,
    input wire [7:0] AD_digits_in,
    output reg [7:0] AD_digits_out
    );
    
    wire full;
    wire empty;
    wire rd_en;
    
    wire CS_N_pos_detect;
    wire CS_N_neg_detect;
    reg CS_N_pos_detect_r0;
    reg CS_N_pos_detect_r1;
    
    wire samp_clk_pos_detect;
    reg samp_clk_pos_detect_r0;
    reg samp_clk_pos_detect_r1;
    
    wire [7:0] AD_digits_out_temp;
    
    initial begin
        AD_digits_out <= 8'd0;
        
        CS_N_pos_detect_r0 <= 1'b0;
        CS_N_pos_detect_r1 <= 1'b0;
        
        samp_clk_pos_detect_r0 <= 1'b0;
        samp_clk_pos_detect_r1 <= 1'b0;
    end
    
    // -- TODO: detect the posedge of CS_N
    assign CS_N_pos_detect = (CS_N_pos_detect_r0 && 
                             !CS_N_pos_detect_r1) ? 1'b1: 1'b0;
    assign CS_N_neg_detect = (!CS_N_pos_detect_r0 && 
                             CS_N_pos_detect_r1) ? 1'b1: 1'b0;
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            CS_N_pos_detect_r0 <= 1'b1;
            CS_N_pos_detect_r1 <= 1'b1;
        end
        else begin
            CS_N_pos_detect_r0 <= CS_N;
            CS_N_pos_detect_r1 <= CS_N_pos_detect_r0;
        end
    end
    
    // -- TODO: detect the posedge of samp_clk
    assign samp_clk_pos_detect = (samp_clk_pos_detect_r0 && 
                             !samp_clk_pos_detect_r1) ? 1'b1: 1'b0;
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            samp_clk_pos_detect_r0 <= 1'b1;
           samp_clk_pos_detect_r1 <= 1'b1;
        end
        else begin
            samp_clk_pos_detect_r0 <= samp_clk;
            samp_clk_pos_detect_r1 <= samp_clk_pos_detect_r0;
        end
    end
    
    // -- TODO: set rd_en flag
    assign rd_en = CS_N_pos_detect;
    
    // -- AD_digits buffer
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            AD_digits_out <= 8'd0;
        end
        else if (CS_N_neg_detect) begin
            AD_digits_out <= AD_digits_out_temp;
        end
        else AD_digits_out <= AD_digits_out;
    end
    
    // -- FIFO generator IP Core 
    FIFO_cache cache_stage0(
        .clk(sys_clk),
        .srst(full),
        .din(AD_digits_in),
        .wr_en(samp_clk_pos_detect),
        .rd_en(rd_en),
        .dout(AD_digits_out_temp),
        .full(full),
        .empty(empty)
    );
    
endmodule