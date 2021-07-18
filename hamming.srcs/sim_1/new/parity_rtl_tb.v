`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2021 19:43:28
// Design Name: 
// Module Name: parity_rtl_tb
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


module parity_rtl_tb();
 wire out[0:4];
 reg [25:0] data [0:4];
 integer i = 0;
 genvar j;
 generate 
    for(j=1; j<6; j=j+1) begin: gencord
        parity_rtl #(.parity_bit(j)) p1 (.data (data[j-1]), .parity (out[j-1]));
    end
 endgenerate
    initial 
        begin
            for(i=0; i<5; i=i+1) begin
                data[i]='b01011010011101010100011011;    
            end
            #10
            if(out[0]==1)
                $display("Parity 1 ok");
            else
                $display("Parity 1 fail %b, expected 1", out[0]);
            if(out[1]==1)
                $display("Parity 2 ok");
            else
                $display("Parity 2 fail %b, expected 1", out[1]);
            if(out[2]==1)
                $display("Parity 3 ok");
            else
                $display("Parity 3 fail %b, expected 1", out[2]);
            if(out[3]==1)
                $display("Parity 4 ok");
            else
                $display("Parity 4 fail %b, expected 1", out[3]);
            if(out[4]==0)
                $display("Parity 5 ok");
            else
                $display("Parity 5 fail %b, expected 0", out[4]);
            $finish;
        end

endmodule
