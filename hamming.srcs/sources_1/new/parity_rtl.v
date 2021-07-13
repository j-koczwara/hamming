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
            1: parity=^(data&26'b11011010101101010101010101);
            2: parity=^(data&26'b10110110011011001100110011);
            3: parity=^(data&26'b01110001111000111100001111);
            4: parity=^(data&26'b00001111111000000011111111);
            5: parity=^(data&26'b00000000000111111111111111);       
        endcase
                
    
endmodule
