`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2021 22:59:13
// Design Name: 
// Module Name: parity_extra_rtl_tb
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


module parity_extra_rtl_tb();

    reg [30:0] data_in;
    wire parity_extra;
    reg [30:0] data;
    reg unsigned [30:0] test_data[0:4] = { 31'b0101101001110100101000111011111, 31'b1101011101100101001100001000110, 31'b0011011001010011110110001110011,
31'b1111001011101010001010101010100, 31'b1101011010011101001110110001101};
    reg unsigned parity_expected[0:4] = {1'b0,1'b1,1'b1,1'b0,1'b0 };
    
    parity_extra_rtl p1 (.data_in(data), .parity_extra(parity_extra));
    
    
    integer i;
    initial begin
        for(i=0;i<5;i=i+1) begin
            data=test_data[i];
            #5;
            if(parity_extra==parity_expected[i])
                $display("Parity %d ok", i);
            else
                $display("Parity %d fail %b, expected %b", i, parity_extra, parity_expected[i]);
        end
    
    
    end
    
    
    
    
    
endmodule
