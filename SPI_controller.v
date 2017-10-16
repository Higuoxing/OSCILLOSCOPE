`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/29 02:49:04
// Design Name: 
// Module Name: SPI_controller
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


module SPI_controller(
    input wire sys_clk,
    input wire rst_n,
    input wire [7:0] AD_digits_in,
    input wire [7:0] trigger_voltage,
    input wire [31:0] std_freq_cnt,
    input wire [31:0] sig_freq_cnt,
    input wire CS_N,
    input wire SCK,
    input wire MOSI,
    output wire MISO,
    output wire [7:0] rxd_data
    );
    
    reg [7:0] txd_data;
    wire txd_flag;
    wire rxd_flag;
    
    reg [31:0] data_cnt;
    initial begin
        data_cnt <= 32'd0;
        txd_data <= 8'd0;
    end
    
    SPI_slave spi_transmitter(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .CS_N(CS_N),
        .SCK(SCK),
        .MOSI(MOSI),
        .txd_data(txd_data),
        .MISO(MISO),
        .rxd_data(rxd_data),
        .rxd_flag(rxd_flag),
        .txd_flag(txd_flag)
    );
    
    // -- data_counter
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            data_cnt <= 32'd0;
        end
        else if (rxd_flag && data_cnt != 210) begin
            data_cnt <= data_cnt + 1;
        end
        else if (rxd_flag && data_cnt == 210) begin
            data_cnt <= 32'd0;
        end
    end
    
    // -- SPI_FSM
    always @ (*) begin
        case (data_cnt) 
            32'd0   : txd_data <= 8'h55;
            32'd1   : txd_data <= 8'hAA;
            32'd2   : txd_data <= trigger_voltage;
            32'd203 : txd_data <= std_freq_cnt[31  :  24];
            32'd204 : txd_data <= std_freq_cnt[23  :  16];
            32'd205 : txd_data <= std_freq_cnt[15  :   8];
            32'd206 : txd_data <= std_freq_cnt[7   :   0];
            32'd207 : txd_data <= sig_freq_cnt[31  :  24];
            32'd208 : txd_data <= sig_freq_cnt[23  :  16];
            32'd209 : txd_data <= sig_freq_cnt[15  :   8];
            32'd210 : txd_data <= sig_freq_cnt[7   :   0];
            32'd211 : txd_data <= 8'hAA;
            32'd212 : txd_data <= 8'h55;
            default : txd_data <= AD_digits_in;
        endcase
    end
    
endmodule

//module SPI_slave(
//	input    wire    sys_clk,       // -- sys_clk = 100MHz
//	input    wire    rst_n,
//	input    wire    CS_N,
//	input    wire    SCK,
//	input    wire    MOSI,
//	input    wire    [7:0] txd_data,
//	output   reg     MISO,
//	output   reg     [7:0] rxd_data,
//	output   wire    rxd_flag,
//	output   wire    txd_flag
//    );