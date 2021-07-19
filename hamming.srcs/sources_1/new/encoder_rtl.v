`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2021 19:41:04
// Design Name: 
// Module Name: encoder_rtl
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


module encoder_rtl(input clk, input [25:0] data_in, input rst, output reg [31:0] data_out);
    reg [25:0] parity_in;
    wire [5:0] parity;
    wire [30:0] extra_parity_in;
    wire parity_extra;
    wire [31:0] encoded;
    
    parity_extra_rtl p1 (.data_in(extra_parity_in), .parity_extra(parity_extra));
    
    genvar j;
    generate 
        for(j=1; j<6; j=j+1) begin: gencord
            parity_rtl #(.parity_bit(j)) p1 (.data (parity_in), .parity (parity[j-1]));
        end
    endgenerate
    
    assign extra_parity_in[1:0]=parity[1:0];
    assign extra_parity_in[2]=parity_in[0];
    assign extra_parity_in[3]=parity[2];
    assign extra_parity_in[6:4]=parity_in[3:1];
    assign extra_parity_in[7]=parity[3];
    assign extra_parity_in[14:8]=parity_in[10:4];
    assign extra_parity_in[15]=parity[4];
    assign extra_parity_in[30:16]=parity_in[25:11];
    
    assign encoded={parity_extra,extra_parity_in};    
    
    always@(posedge clk) begin
        if(rst) begin
            data_out  <= 0;
            parity_in <= 0;
        end
        else begin
            data_out  <= encoded;
            parity_in <= data_in;
        end
    end
    
    
    
    
    
endmodule
