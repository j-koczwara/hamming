`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2021 21:24:37
// Design Name: 
// Module Name: parity_rtl
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


module parity_rtl(
    input [25:0] data,
    output reg parity
    );
    parameter parity_bit=1;
    
    always@*
        case(parity_bit)
            1: parity=^(data&26'b10101010101010110101011011);
            2: parity=^(data&26'b11001100110011011001101101);
            3: parity=^(data&26'b11110000111100011110001110);
            4: parity=^(data&26'b11111111000000011111110000);
            5: parity=^(data&26'b11111111111111100000000000);       
        endcase
                
    
endmodule
