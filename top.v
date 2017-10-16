`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/27 10:56:33
// Design Name: 
// Module Name: top
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


module top(
    input wire sys_clk,
    input wire rst_n,
    input wire CS_N,
    input wire SCK,
    input wire MOSI,
    input wire sig_in,
    input wire [7:0] JA,
    output wire MISO,
    output wire AD_clk,
    output wire [7:0] led,
    input wire [7:0] sw,
    output wire DA_clk,
    output wire [7:0] DA_digits
    );
    
    wire [7:0] rxd_data;
    wire [7:0] AD_digits_out;
    wire rxd_flag;
    wire txd_flag;
    reg [31:0] AD_clk_cnt;
    wire [7:0] AD_digits_buffer;
    reg samp_clk;
    
    
    wire AD_clk_4;
    wire AD_clk_3;
    wire AD_clk_2;
    wire AD_clk_1;
    wire AD_clk_0;
    
    wire [31:0] sig_freq_cnt_buf;
    wire [31:0] ref_clk_cnt_buf;
    
    wire EN_detect;
    assign led = rxd_data;
    initial begin
        AD_clk_cnt <= 32'd0;
        samp_clk <= 1'b0;
    end
    
    CACHE_controller fifo_test(
        .sys_clk(sys_clk),
        .samp_clk(AD_clk),
        .rst_n(rst_n),
        .CS_N(CS_N),
        .AD_digits_in(JA),
        .AD_digits_out(AD_digits_out)  
    );

    ANALOG_sampl_4 samp_4clk_gen (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .samp_clk(AD_clk_4)
    );
    
    ANALOG_sampl_3 samp_3clk_gen (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .samp_clk(AD_clk_3)
    );
    
    ANALOG_sampl_2 samp_2clk_gen(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .samp_clk(AD_clk_2)
    );
    
    ANALOG_sampl_1 samp_1clk_gen(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .samp_clk(AD_clk_1)
    );
    
    ANALOG_sampl_0 samp_0clk_gen(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .samp_clk(AD_clk_0)
    );
    
    AD_clk_mux AD_clk_mux_0 (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .AD_clk_in({AD_clk_4, AD_clk_3, AD_clk_2, AD_clk_1, AD_clk_0}),
        .EN(rxd_data),
        .AD_clk_out(AD_clk),
        .EN_detect(EN_detect)
    );
    
    FREQ_counter FREQ_meter (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .sig_in(sig_in),
        .sig_freq_cnt_buf(sig_freq_cnt_buf)
    );

    SPI_controller spi_trans(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .AD_digits_in(AD_digits_out),
        .trigger_voltage(sw),
        .std_freq_cnt(sig_freq_cnt_buf),
        .sig_freq_cnt(8'hff),
        .CS_N(CS_N),
        .SCK(SCK),
        .MOSI(MOSI),
        .MISO(MISO),
        .rxd_data(rxd_data)
    );
    
    SQUARE_wav_gen sq_wav_gen (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .DA_clk(DA_clk),
        .DA_digits(DA_digits)
    );
endmodule

//module SQUARE_wav_gen(
//    input wire sys_clk,
//    input wire rst_n,
//    output reg DA_clk,
//    output reg DA_digits
//    );

