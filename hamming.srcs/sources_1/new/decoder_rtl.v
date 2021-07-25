`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2021 19:10:50
// Design Name: 
// Module Name: decoder_rtl
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


module decoder_rtl(
    input [31:0] hamming_in,
    input clk,
    input rst,
    output reg [1:0] status_out,  //00 -correct; 01 -single error, corrected; 10 -double error, detected
    output reg [25:0] data_out
    );
    
    reg [31:0] data_in;
    wire [25:0] data_corrected;
    wire [25:0] data;
    wire [5:0] parity_bits, parity_bits_dec;
    wire [5:0] syndrome;
    wire [1:0] status;
    
    
    parity_extra_rtl p1 (.data_in(data_in[31:1]), .parity_extra(parity_bits_dec[0]));
    
    genvar j;
    generate 
        for(j=1; j<6; j=j+1) begin: gencord
            parity_rtl #(.parity_bit(j)) p1 (.data (data), .parity (parity_bits_dec[j]));
        end
    endgenerate
    
    data_correction_rtl(.data_in(data_in), .syndrome(syndrome), .data_corrected(data_corrected), .status(status));
    
    assign parity_bits[1:0]=data_in[2:0]  ;
    assign data[0]         =data_in[3]    ;
    assign parity_bits[2]  =data_in[4]    ;
    assign data[3:1]       =data_in[7:5]  ;
    assign parity_bits[3]  =data_in[8]    ;
    assign data[10:4]      =data_in[15:9] ;
    assign parity_bits[4]  =data_in[16]   ;
    assign data[25:11]     =data_in[31:15];
    
    assign syndrome=parity_bits_dec^parity_bits;

    always@(posedge clk) begin
        if(rst) begin
            data_out  <= 0;
            status_out <= 0;
            data_in <= 0;
        end
        else begin
            data_out  <= data_corrected;
            status_out <= status;
            data_in <= hamming_in;
        end
    end
    
    
endmodule
