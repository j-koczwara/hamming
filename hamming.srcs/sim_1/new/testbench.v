`timescale 1ns / 1ps
module testbench();
reg reset, reset_n;
// Reset stimulus
initial
begin
reset = 1'b1;
reset_n = 1'b0;
#10 reset = 1'b0;
reset_n = 1'b1;
end

reg [0:7] hamming_in;
wire [0:3] data_decoded;
wire [0:7] hamming_out;
reg [0:3] data_in;
  
encoder encoder_inst (reset, data_in, hamming_out);
decoder decoder_inst (reset, hamming_in, data_decoded);

initial begin
    #10
    $display("First test");
    data_in = 4'b1011;
    hamming_in = 8'b00110011;
    #5
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("First test failed");
    #5
    $display("Second test");
    data_in = 4'b0011;
    hamming_in = 8'b11000011;
    #5
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("Second test failed");
    #5
    $display("Third test");
    data_in = 4'b0010;
    hamming_in = 8'b10101010;
    #5
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("Third test failed");
    #5
    $display("Fourth test");
    hamming_in = 8'b00100011; //with single error
    #5
    $display("Fifth test");
    hamming_in = 8'b00100001; //with double error
    #5

    $finish;
end


endmodule