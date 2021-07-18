`timescale 1ns / 1ps

module encoder(rst, data_in, hamming_out);
parameter data_bits=26;
parameter parity_bits=6;
parameter all_bits=data_bits+parity_bits;

input rst;
input [data_bits-1:0] data_in ;
output reg [all_bits-1:0] hamming_out;

reg [data_bits-1:0] data;
//reg [0:all_bits-1] correct_output [0:2];

integer parity_position = 1;
integer data_counter = 0;
time sum = 0;
integer output_data_counter = 0;
integer i = 0;
integer k = 0;
integer offset = 0;
reg [all_bits-1:0] encoder_output = 0;

always @* begin
    if (~rst) begin

        parity_position=1;
        data_counter=0;
        output_data_counter=0;
        sum=0;
        encoder_output=0;
        data=data_in;
        
        for (i=1; i < all_bits; i=i+1) begin  //add parity bits
            if ( i == parity_position )begin 
                encoder_output[i] = 0;
                parity_position = parity_position<<1;
            end
            else begin
                encoder_output[i] = data[data_counter];
                data_counter=data_counter+1;
            end
        end
        
        parity_position=1;
                    
        while ( parity_position < all_bits) begin //parity value
            offset = parity_position-1;
            output_data_counter = 1 + offset;
            sum=0;
            while (output_data_counter < all_bits) begin
                for (i=0; i < parity_position; i=i+1) begin                    
                    sum=sum+encoder_output[output_data_counter];
                    output_data_counter=output_data_counter+1;                    
                end              
                output_data_counter=output_data_counter+parity_position;                
            end 
            encoder_output[parity_position] = sum%2;
            parity_position = parity_position<<1;            
        end
        sum=0;
        for(i=0; i< all_bits; i=i+1) begin //extra parity bit
            sum = sum + encoder_output[i];
        end
        encoder_output[0] = sum%2;   
        
        $display("Input data %b", data);
        $display("Encoded: %b",encoder_output);

     hamming_out = encoder_output;
    end
end
endmodule
