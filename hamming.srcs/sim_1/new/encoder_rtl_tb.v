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
reg unsigned [25:0] test_data;//[0:2] = { 26'b11111010011101010100011011,26'b11011010011110110100011011,26'b11011010011110101001011011};
reg unsigned [31:0] out_expected;//[0:2] = {32'b11111010011101001010001110111011,32'b11011010011110101010001010101000,32'b11011010011110100100101010111111 };
    
encoder_rtl e1 (.clk(clk), .data_in(data_in), .rst(rst), .data_out(data_out));
clk c1 (.clk(clk));

integer i=0;
integer file, out_file, data;

initial begin
    rst=1;
    #10
    rst=0;
    
    file = $fopen("D:/ham/encoder.TXT", "r");
    out_file = $fopen("D:/ham/encoder_out.TXT", "w");
    
        while(!$feof(file)) 
        begin
            data =  $fscanf(file, "%b %b %b\n", test_data, out_expected);
            data_in = test_data;
            #20
            if(data_out==out_expected)
                $fwrite(out_file, "Test %0d ok\n", i);
                //$display("Test %d ok, status %b", i, status);
            else
                $fwrite(out_file, "Test %d fail %b, expected %b", i, data_out, out_expected);
                //$display("Test %d fail %b, expected %b, status %b", i, data_out, out_expected, status);
            i=i+1;
            end
            
    $fclose(file);
    $fclose(out_file);
    
    #10 $display("%0t: Finished TPG.", $time);
    $stop;

end



endmodule
