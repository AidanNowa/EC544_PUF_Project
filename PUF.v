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
    output reg [n-1:0] response;
    
    wire [n-1:0] response_temp;

   genvar i;
    for(i = 0; i < n; i = i + 1) begin
        arbiter Ar1bit (signal, signal, challenge, response_temp[i]);
        always @(posedge clk) begin
            response[i] <= response_temp[i];  
        end //always 
    end//for

    
   // endgenerate
    
    
    
    

endmodule
