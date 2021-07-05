`timescale 1ns / 1ps

module decoder(rst, hamming_in, data_out);

parameter data_bits=26;
parameter parity_bits=6;
parameter all_bits=data_bits+parity_bits;

input rst;
input [0:all_bits-1] hamming_in ;
output reg [0:data_bits-1] data_out;

integer syndrome= 0;
integer parity_position = 1;
integer input_data_counter =0;
integer data_counter =0;
integer i = 0;
integer offset = 0;
integer extra_parity =  1'b0;
integer sum = 0 ;
reg [0:all_bits-1] hamming_error;
reg [0:data_bits-1] data;


always @* begin
    if (~rst) begin
        hamming_error =  hamming_in;
        
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
                
        if(extra_parity==0 && syndrome!=0) begin
            $display("Double error detected in %b", hamming_error);
        end
        else begin
            if(syndrome!=0) begin
                $display("Single error detected on position: %0d, in %b", syndrome, hamming_error);
                hamming_error[syndrome] = ~hamming_error[syndrome];
                $display("Corrected: %b", hamming_error);
                $display("Data out: %b", data);
            end
            else begin
                $display("No error detected in %b", hamming_error);
                $display("Data out: %b", data);
            end
        end
        
    data_out = data;
    end
end
    
endmodule
