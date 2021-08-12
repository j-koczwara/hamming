`timescale 1ns / 1ps
module testbench();

wire clk;
reg rst;
reg [25:0] data_from_file;
reg [31:0] expected_data;

reg [25:0] to_encode;
wire [31:0] encoded;
reg [31:0] to_decode;
reg [31:0] temp;
wire [25:0] data_out;
wire [1:0] status;
integer file_in, file_out, data;
integer i=0;
  
encoder ebh (clk, to_encode, rst, encoded);
decoder dbh (clk, to_decode, rst, data_out, status);
//encoder_rtl ert1 (.clk(clk), .data_in(to_encode), .rst(rst), .data_out(encoded));
//decoder_rtl drt1 (.clk(clk), .hamming_in(to_decode), .rst(rst), .data_out(data_out), .status_out(status));
clk c1 (.clk(clk));


initial begin
    rst=1;
    #10
    rst=0;
    
        
    file_in = $fopen("D:/ham/data.TXT", "r");
    file_out = $fopen("D:/ham/result.TXT", "w");

    while(!$feof(file_in)) 
        begin
            
            data = $fscanf(file_in, "%b %b %b\n", data_from_file, expected_data);
            to_encode = data_from_file;
            #20
            if(encoded==expected_data) begin
                $fwrite(file_out, "Test %0d for encoder passed\n", i);
                
                to_decode=encoded;
                #20
                if(data_out==to_encode && status==2'b00) 
                    $fwrite(file_out, "Test %0d for decoder passed, status %b\n", i, status);
                else
                    $fwrite(file_out, "Test %0d for decoder failed, status %b\n", i, status);
                
                temp=encoded;
                temp[10]=~temp[10];
                to_decode=temp;
                #20
                if(data_out==to_encode && status==2'b01) 
                    $fwrite(file_out, "Test %0d for decoder one error passed, status %b\n", i, status);
                else
                    $fwrite(file_out, "Test %0d for decoder one error failed, status %b\n", i, status); 
                                    
                temp=encoded;
                temp[12]=~temp[12];
                temp[10]=~temp[10];
                to_decode=temp;
                #20
                if(status==2'b10) 
                    $fwrite(file_out, "Test %0d for decoder double error passed, status %b\n", i, status);
                else
                    $fwrite(file_out, "Test %0d for decoder double error failed, status %b\n", i, status);

                end
            else
                $fwrite(file_out, "Test %0d for encoder failed %b, expected %b\n", i, encoded, expected_data);
            
        i=i+1;  
        end
            
    $fclose(file_in);
    $fclose(file_out);

    #10 
    $display("Finished ");

    $finish;
end


endmodule