`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 06:56:57 PM
// Design Name: 
// Module Name: PUF_tb
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


module PUF_tb;
    // Inputs
    reg signal, clk;
    reg [127:0] challenge;
    
    // Output
    wire [127:0] response;
    
    PUF puf_test(.response(response), .signal(signal), .challenge(challenge), .clk(clk));
    
    
    initial clk = 0;
    always #5 clk <= !clk;
    
    initial begin
        signal = 0;
        challenge = 0;
        
        #10;
        signal = 1;
        challenge = 128'h2d95031a235ae849a6e2668f5f906753; //random hex value
    end

endmodule
