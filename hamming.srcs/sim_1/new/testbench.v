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

//parameter data_bits=26;
//parameter parity_bits=6;
//parameter all_bits=data_bits+parity_bits;


reg [31:0] hamming_in;
wire [25:0] data_decoded;
wire [31:0] hamming_out;
reg [25:0] data_in;
  
encoder encoder_inst (reset, data_in, hamming_out);
decoder decoder_inst (reset, hamming_in, data_decoded);

initial begin
    #10
    $display("First test");
    data_in = 26'b11111010011101010100011011;
    hamming_in = 32'b11111010011101001010001110111011; 
    #1
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("First test failed");
    #1
    $display("Second test");
    data_in = 'b11011010011110110100011011; 
    hamming_in = 'b11011010011110101010001010101000;
    #1
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("Second test failed");
    #1
    $display("Third test");
    data_in = 'b11011010011110101001011011; 
    hamming_in = 'b11011010011110100100101010111111; 
    #1
    if (data_in==data_decoded && hamming_out==hamming_in)
         $display("Test passed!");
    else $display("Third test failed");
    #1
    $display("Fourth test");
    hamming_in = 'b11011010011110100100101011111111; //with single error
    #1
    $display("Fifth test");
    hamming_in = 'b11011010011110100100101010110011; //with double error
    #5
    $display("Completed");
    hamming_in = 'b0;
    
    $finish;
end


endmodule