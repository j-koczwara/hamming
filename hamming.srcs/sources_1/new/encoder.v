`timescale 1ns / 1ps


module encoder;
parameter data_bits=4;
parameter parity_bits=3;
parameter all_bits=data_bits+parity_bits+1;

reg [0:data_bits-1] data;
reg [0:data_bits-1] input_data [0:2];
reg [0:all_bits-1] correct_output [0:2];



integer n = 1;
integer t = 5'b00000;
integer s = 5'b00000;
integer d = 5'b00000;
integer i = 0;
integer k = 0;

integer offset = 0;

reg [0:all_bits-1] sum = 0 ;
reg [0:all_bits-1] h = 0;

initial begin

    input_data[0]=4'b0011;
    input_data[1]=4'b1011;
    input_data[2]=4'b0010;
    correct_output[0]=8'b11000011;
    correct_output[1]=8'b00110011;
    correct_output[2]=8'b10101010;
    
    for (k=0; k < 3; k=k+1) begin
        n=1;
        t=0;
        d=0;
        sum=0;
        h=0;
        data=input_data[k];
        
        for (i=1; i < all_bits; i=i+1) begin  //add parity bits
            if ( i == n )begin 
                h[i] = 0;
                n = n<<<1;
            end
            else begin
                h[i] = data[t];
                t=t+1;
            end
        end
        
        n=1;
                    
        while ( n < all_bits) begin //parity value
            offset = n-1;
            d = 1 + offset;
            s=0;
            while (d < all_bits) 
                for (i=0; i < n; i=i+1) begin
                    if (d < all_bits) begin
                        s=s+h[d];
                        d=d+1;
                    end                
                d=d+n;                
            end
            
            if (s%2 == 1) begin 
                h[n] = 1;
            end
            
        n = n<<<1;
            
    end
    
        for(i=0; i< all_bits; i=i+1) begin //extra parity bit
            sum = sum + h[i];
        end
        h[0] = sum%2;   
         
        
        
        $display("Input data %b", data);
        $display("Encoded: %b",h);
        $display("Expected value: %b", correct_output[k]);
        if (h == correct_output[k])
            $display("Test passed");
        else
            $display("Test failed");
       
     end   
end
endmodule
