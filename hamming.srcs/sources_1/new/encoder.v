`timescale 1ns / 1ps


module encoder;
parameter length=8;
parameter data_bits=4;
parameter parity_bits=3;
parameter all_bits=data_bits+parity_bits+1;

reg [0:3] data = 'b1011;

integer n = 1;
integer t = 5'b00000;
integer s = 5'b00000;
integer d = 5'b00000;
integer i = 0;

integer offset = 0;

reg [0:all_bits-1] sum = 0 ;
reg [0:all_bits-1] h = 0;

initial begin

for (i=1; i<all_bits; i=i+1) begin
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
            
while ( n < all_bits) begin
    offset = n-1;
    d = 1 + offset;
    s=0;
    
    while (d < all_bits) begin
        for (i=0; i<n; i=i+1) begin
            if (d < all_bits) begin
                s=s+h[d];
                d=d+1;
            end
        end
        d=d+n;
        
    end
    if (s%2 == 1 ) begin 
        h[n] = 1;
    end
    
n = n<<<1;
    
end

//reg [WORDLEN - 1:0] tmp [SIZE - 1:0];
for( i=0; i< all_bits; i=i+1) begin
    sum = sum + h[i];
end
h[0] = sum%2;   
 


$display("Input data %b", data);
$display("Encoded: %b",h);
if (data == 'b1011) begin
 $display("Expected value: 00110011");
end
end
endmodule
