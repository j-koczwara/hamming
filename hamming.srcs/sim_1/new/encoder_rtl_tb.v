`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2021 18:00:20
// Design Name: 
// Module Name: encoder_rtl_tb
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


module encoder_rtl_tb();
wire clk;
reg rst;
reg [25:0] data_in;
reg [31:0] data_out;
reg unsigned [25:0] test_data[0:2] = { 26'b11111010011101010100011011,26'b11011010011110110100011011,26'b11011010011110101001011011};
reg unsigned [31:0] out_expected[0:2] = {32'b11111010011101001010001110111011,32'b11011010011110101010001010101000,32'b11011010011110100100101010111111 };
    
encoder_rtl e1 (.clk(clk), .data_in(data_in), .rst(rst), .data_out(data_out));
clk c1 (.clk(clk));
integer i;

initial begin
    rst=1;
    #10
    rst=0;
    for (i=0;i<3;i=i+1) begin
        data_in = test_data[i];
        #20
        if(data_out==out_expected[i])
            $display("Test %d ok", i);
        else
            $display("Test %d fail %b, expected %b", i, data_out, out_expected[i]);
        
    end
    
    #10 $display("%0t: Finished TPG.", $time);
    $stop;

end



endmodule
