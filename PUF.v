`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 01:42:21 AM
// Design Name: 
// Module Name: PUF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PUF(response, signal, challenge, clk);

    parameter n = 128;
    
    input signal, clk;
    input [n-1:0] challenge;
    output [n-1:0] response;
    
    wire [n-1:0]arbiter_out;
    reg [n-1:0] key;
    reg test;
    
    wire [n-1:0] response_temp;
    //genvar i;
    
   // generate
   // for(i = 0; i < n; i = i + 1) begin 
//        arbiter Ar1bit (signal, signal, challenge, arbiter_out[i]);
//        always @ (posedge clk) begin
//            key[i] <= arbiter_out[i];
//        end //always  
        //dff DFF (response[i], arbiter_out, clk);
   // end//for
   genvar i;
    for(i = 0; i < n; i = i + 1) begin
        arbiter Ar1bit (signal, signal, challenge, response_temp[i]);
        assign response[i] = response_temp[i];   
    end//for
    //assign response = key;
    
   // endgenerate
    
    
    
    

endmodule
