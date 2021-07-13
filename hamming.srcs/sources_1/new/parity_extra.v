`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2021 21:36:10
// Design Name: 
// Module Name: parity_extra
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


module parity_extra_rtl(
    input [30:0] data_in,
    output reg parity_extra
    );
    
    always@* begin
    parity_extra=^data_in;    
    end
    
endmodule
