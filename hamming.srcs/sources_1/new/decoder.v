`timescale 1ns / 1ps

module decoder(
input clk,
input [31:0] hamming_in,
input rst,
output reg [31:0] data_out,
output reg [1:0] status_out  //00 -correct; 01 -single error, corrected; 10 -double error, detected

);
parameter data_bits=26;
parameter parity_bits=6;
parameter all_bits=data_bits+parity_bits;

integer syndrome= 0;
integer parity_position = 1;
integer input_data_counter =0;
integer data_counter =0;
integer i = 0;
integer offset = 0;
integer extra_parity =  1'b0;
integer sum = 0 ;

reg [all_bits-1:0] hamming_error;
reg [data_bits-1:0] data;
reg [1:0] status;


always@(posedge clk) begin
   if(rst) begin
    data_out  <= 0;
    status_out <= 0;
    hamming_error <= 0;
   end
   else begin
        hamming_error <=  hamming_in;
        
        extra_parity=0;
        parity_position = 1;
        sum=0;
        syndrome=0;
        while (parity_position<all_bits) begin
            offset=parity_position-1;
            input_data_counter=1+offset;
            sum=0;
            while(input_data_counter<all_bits) begin
                for (i=0; i<parity_position; i=i+1) begin
                    if(input_data_counter < all_bits) begin
                        sum=sum+hamming_error[input_data_counter]; //suma odpowiednich bitów danych
                        input_data_counter=input_data_counter+1;
                    end
                end
                input_data_counter=input_data_counter+parity_position; //bity danych nie branych do oblicznia parity  
            end
            if(sum%2!=0) begin
                syndrome=syndrome+parity_position;
            end
            parity_position=parity_position<<1;    
        end
        sum=0;
        for( i=0; i< all_bits; i=i+1) begin
            sum = sum + hamming_error[i];
        end
        
        extra_parity=sum%2;    
       
        if(extra_parity==0 && syndrome!=0) begin
            status = 2'b10;  //00 -correct; 01 -single error, corrected; 10 -double error, detected
            //$display("Double error detected in %b", hamming_error);
        end
        else begin
            if(syndrome!=0) begin
                status = 2'b01;
                //$display("Single error detected on position: %0d, in %b", syndrome, hamming_error);
                hamming_error[syndrome] = ~hamming_error[syndrome];
                //$display("Corrected: %b", hamming_error);
                //$display("Data out: %b", data);
            end
            else begin
                status = 2'b00;
                //$display("No error detected in %b", hamming_error);
                //$display("Data out: %b", data);
            end
            
        parity_position = 1;
        data_counter=0;
        for( i=1; i< all_bits; i=i+1) begin
            if(i!==parity_position)begin
                data[data_counter]=hamming_error[i];
                data_counter=data_counter+1;
            end
            else
                parity_position=parity_position<<1;    
        end
                

        end
        
    data_out <= data;
    status_out <= status;
    end
end
    
endmodule
