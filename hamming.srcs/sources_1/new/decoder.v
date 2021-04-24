`timescale 1ns / 1ps

module decoder;

parameter data_bits=4;
parameter parity_bits=4;
parameter all_bits=data_bits+parity_bits;
reg [0:data_bits-1] data_out;
reg [0:7] hamming_in = 'b00110011;

integer syndrome= 0;
integer parity_position = 1;
integer input_data_counter =0;
integer data_counter =0;
integer i = 0;
integer k = 0;
integer offset = 0;
integer extra_parity =  1'b0;
integer sum = 0 ;
reg [0:7] hamming_error_in[0:2];
reg [0:7] hamming_error;


initial begin

    hamming_error_in[0]=8'b11000011;
    hamming_error_in[1]=8'b00100011;
    hamming_error_in[2]=8'b00100001;
    
    //parity check
    for (k=0; k<3; k=k+1) begin
        hamming_error =  hamming_error_in[k];
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
                data_out[data_counter]=hamming_error[i];
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
                $display("Data out: %b", data_out);
            end
            else begin
                $display("No error detected in %b", hamming_error);
                $display("Data out: %b", data_out);
            end
        end
        
        
    end
end
endmodule
