`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 04:22:48 AM
// Design Name: 
// Module Name: Top_tb
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


module Top_tb;

    reg clk; 
    wire rxd;
    wire [127:0] challenge;
    wire txd;
    
    assign challenge = 128'h2d95031a235ae849a6e2668f5f906753; //random hex value
    
    Top uut (clk, rxd, txd);
    genvar i;
    initial clk = 0;
    always #5 clk <= !clk;
    
        for(i=0; i<127; i = i+1) begin
            assign rxd = challenge[i];
        end//gor
      
endmodule
