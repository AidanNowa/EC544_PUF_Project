`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 11:00:01 PM
// Design Name: 
// Module Name: arbiter_tb
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


module arbiter_tb;
    reg in0, in1;
    reg [127:0] control;
    
    wire out, out_inv;
    
    arbiter arbit(in0, in1, control, out, out_inv);
    
    initial begin
        in0 = 0; 
        in1 = 0;
        control = 0;
        
        #10;
        in0 = 1;
        in1 = 1;
        control = 128'hc71f2e46cc9dc3bfdd47048bc4bdce79; //random hex value
    end

endmodule
