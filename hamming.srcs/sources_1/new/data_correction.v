`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2021 18:04:46
// Design Name: 
// Module Name: data_correction
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


module data_correction_rtl(
    input [31:0] data_in,
    input [5:0] syndrome,
    output reg [25:0] data_corrected,
    output reg [1:0] status //00 -correct; 01 -single error, corrected; 10 -double error, detected
    );
    
    reg [5:0] error_pos;
    reg [31:0] temp;
    always@* begin
        if(syndrome[5:1]!=5'b00000) 
            if(syndrome[0]==0)begin
                status=2'b10;
                data_corrected=data_in;
            end
            else begin
            error_pos = syndrome[1]+syndrome[2]<<1+syndrome[3]<<2 + syndrome[4]<<3 + syndrome[5]<<4;  
            temp=data_in;
            temp[error_pos]= ~temp[error_pos];
            data_corrected=temp;
            status = 2'b01;
            end
        else begin
            status=2'b00;
            data_corrected=data_in;
        end        
    end
    
    
    
endmodule
