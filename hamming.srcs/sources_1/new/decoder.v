`timescale 1ns / 1ps

module decoder;

parameter length = 8;

reg [0:3] data = 'b1011;
reg [0:7] hamming_in = 'b00110011;

integer syndrome= 0;
integer n = 1;
integer s = 5'b00000;
integer d = 5'b00000;
integer i = 0;
integer k = 0;
integer offset = 0;
integer extra_parity =  1'b0;
integer sum = 0 ;
reg [0:7] hamming_error_in[0:2];
reg [0:7] hamming_error;


initial begin

    hamming_error_in[0]=8'b00110011;
    hamming_error_in[1]=8'b00100011;
    hamming_error_in[2]=8'b00100001;
    
    //parity check
    for (k=0; k<3; k=k+1) begin
        hamming_error =  hamming_error_in[k];
        n = 1;
        sum=0;
        while (n<length) begin
            offset=n-1;
            d=1+offset;
            s=0;
            while(d<length) begin
                for (i=0; i<n; i=i+1) begin
                    if(d < length) begin
                        s=s+hamming_error[d]; //suma odpowiednich bitów danych
                        d=d+1;
                    end
                end
                d=d+n; //bity danych nie branych do oblicznia parity  
            end
            if(s%2!=0) begin
                syndrome=syndrome+n;
            end
            n=n<<1;    
        end
        
        for( i=0; i< length; i=i+1) begin
            sum = sum + hamming_error[i];
        end
        
        extra_parity=sum%2;    
                
        if(extra_parity==0 && syndrome!=0) begin
            $display("Double error detected in %b", hamming_error);
        end
        else begin
            if(syndrome!=0) begin
                $display("Single error detected on position: %0d, in %b", syndrome, hamming_error);
                hamming_error[syndrome] = ~hamming_error[syndrome];
                $display("Corrected: %b", hamming_error);
            end
            else begin
                $display("No error detected in %b", hamming_error);
            end
        end
    end
end
endmodule
