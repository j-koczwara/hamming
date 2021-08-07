`timescale 1ns / 1ps
module testbench();

wire clk;
reg rst;
reg [25:0] data_from_file;
reg [31:0] expected_data;

reg [25:0] to_encode_beh, to_encode_rtl;
wire [31:0] encoded_beh, encoded_rtl;
reg [31:0] to_decode_beh, to_decode_rtl;
reg [31:0] temp;
wire [25:0] data_out_beh, data_out_rtl;
wire [1:0] status_beh, status_rtl;
integer file_in, file_out, data;
integer i=0;
  
encoder ebh (clk, to_encode_beh, rst, encoded_beh);
decoder dbh (clk, to_decode_beh, rst, data_out_beh, status_beh);
encoder_rtl ert1 (.clk(clk), .data_in(to_encode_rtl), .rst(rst), .data_out(encoded_rtl));
decoder_rtl drt1 (.clk(clk), .hamming_in(to_decode_rtl), .rst(rst), .data_out(data_out_rtl), .status_out(status_rtl));
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
            to_encode_beh = data_from_file;
            #20
            if(encoded_beh==expected_data) begin
                $fwrite(file_out, "Test %0d for encoder passed\n", i);
                
                to_decode_beh=encoded_beh;
                #20
                if(data_out_beh==to_encode_beh && status_beh==2'b00) 
                    $fwrite(file_out, "Test %0d for decoder passed, status %b\n", i, status_beh);
                else
                    $fwrite(file_out, "Test %0d for decoder failed, status %b\n", i, status_beh);
                
                temp=encoded_beh;
                temp[10]=~temp[10];
                to_decode_beh=temp;
                #20
                if(data_out_beh==to_encode_beh && status_beh==2'b01) 
                    $fwrite(file_out, "Test %0d for decoder one error passed, status %b\n", i, status_beh);
                else
                    $fwrite(file_out, "Test %0d for decoder one error failed, status %b\n", i, status_beh); 
                                    
                temp=encoded_beh;
                temp[12]=~temp[12];
                temp[10]=~temp[10];
                to_decode_beh=temp;
                #30
                if(status_beh==2'b10) 
                    $fwrite(file_out, "Test %0d for decoder double error passed, status %b\n", i, status_beh);
                else
                    $fwrite(file_out, "Test %0d for decoder double error failed, status %b\n", i, status_beh);

                end
            else
                $fwrite(file_out, "Test %0d for encoder failed %b, expected %b\n", i, encoded_beh, expected_data);
            
            to_encode_rtl = data_from_file;
            #20
            if(encoded_rtl==expected_data) begin
                $fwrite(file_out, "Test %0d for encoder rtl passed\n", i);
                
                to_decode_rtl=encoded_rtl;
                #20
                if(data_out_rtl==to_encode_rtl && status_rtl==2'b00) 
                    $fwrite(file_out, "Test %0d for decoder rtl passed, status %b\n", i, status_rtl);
                else
                    $fwrite(file_out, "Test %0d for decoder rtl failed, status %b\n", i, status_rtl);
                
                temp=encoded_rtl;
                temp[10]=~temp[10];
                to_decode_rtl=temp;
                #20
                if(data_out_rtl==to_encode_rtl && status_rtl==2'b01) 
                    $fwrite(file_out, "Test %0d for decoder one error rtl passed, status %b\n", i, status_rtl);
                else
                    $fwrite(file_out, "Test %0d for decoder one error rtl  failed, status %b\n", i, status_rtl);
                                    
                temp=encoded_rtl;
                temp[10]=~temp[10];
                temp[5]=~temp[5];
                to_decode_rtl=temp;
                #20
                if(status_rtl==2'b10) 
                    $fwrite(file_out, "Test %0d for decoder double error rtl passed, status %b\n", i, status_rtl);
                else
                    $fwrite(file_out, "Test %0d for decoder double error rtl failed, status %b\n", i, status_rtl);

                end
            else
                $fwrite(file_out, "Test %0d for encoder rtl failed %b, expected %b\n", i, encoded_rtl, expected_data);       
              
        i=i+1;  
        end
            
    $fclose(file_in);
    $fclose(file_out);

    #10 
    $display("Finished ");

    $finish;
end


endmodule