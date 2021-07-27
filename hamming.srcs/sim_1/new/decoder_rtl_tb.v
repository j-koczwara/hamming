`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2021 20:04:56
// Design Name: 
// Module Name: decoder_rtl_tb
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


module decoder_rtl_tb();
wire clk;
reg rst;
reg [25:0] data_out;
reg [31:0] data_in;
reg [1:0] status;
reg unsigned [31:0] test_data;//[0:2] = { 32'b11011010011110100100101011111111,32'b11011010011110100100101010110011,32'b01011010011101001010001110111110};
reg unsigned [25:0] out_expected;//[0:2] = {26'b11011010011110101001011111,26'b11011010011110101001011010, 26'b01011010011101010100011011 };
reg unsigned [1:0] status_expected;//[0:2] = {2'b01,2'b10,2'b00};   
 
integer file, out_file, data;
integer i=0;
 
decoder_rtl e1 (.clk(clk), .hamming_in(data_in), .rst(rst), .data_out(data_out), .status_out(status));

clk c1 (.clk(clk));

initial begin
    rst=1;
    #10
    rst=0;
    
    file = $fopen("D:/ham/decoder.TXT", "r");
    out_file = $fopen("D:/ham/decoder_out.TXT", "w");
    
    while(!$feof(file)) 
        begin
            data =  $fscanf(file, "%b %b %b\n", test_data, out_expected, status_expected);
            data_in = test_data;
            #20
            if(data_out==out_expected && status==status_expected)
                $fwrite(out_file, "Test %0d ok, status %b\n", i, status);
                //$display("Test %d ok, status %b", i, status);
            else
                $fwrite(out_file, "Test %0d fail %b, expected %b, status %b\n",i,data_out, out_expected, status);
                //$display("Test %d fail %b, expected %b, status %b", i, data_out, out_expected, status);
            i=i+1;
            end
            
    $fclose(file);
    $fclose(out_file);

    #10 $display("Finished ");
    $stop;

end
endmodule
