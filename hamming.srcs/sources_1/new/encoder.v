`timescale 1ns / 1ps

module encoder;
parameter data_bits=4;
parameter parity_bits=4;
parameter all_bits=data_bits+parity_bits;

reg [0:data_bits-1] data;

reg [0:data_bits-1] input_data [0:2];
reg [0:all_bits-1] correct_output [0:2];

integer parity_position = 1;
integer data_counter = 5'b00000;
integer sum = 5'b00000;
integer output_data_counter = 5'b00000;
integer i = 0;
integer k = 0;

integer offset = 0;
reg [0:all_bits-1] encoder_output = 0;

initial begin

    input_data[0]=4'b0011;
    input_data[1]=4'b1011;
    input_data[2]=4'b0010;
    correct_output[0]=8'b11000011;
    correct_output[1]=8'b00110011;
    correct_output[2]=8'b10101010;
    
    for (k=0; k < 3; k=k+1) begin
        parity_position=1;
        data_counter=0;
        output_data_counter=0;
        sum=0;
        encoder_output=0;
        data=input_data[k];
        
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
        $display("Expected value: %b", correct_output[k]);
        if (encoder_output == correct_output[k])
            $display("Test passed");
        else
            $display("Test failed");
       
     end   
end
endmodule
