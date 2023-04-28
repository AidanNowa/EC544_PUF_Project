`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 12:46:49 AM
// Design Name: 
// Module Name: mux2to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 2 to 1 mux used to select in1 when sel = 1 and in0 when sel = 0.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2to1(out, in0, in1, sel);
    input in0, in1, sel;
    output reg out;
    
    always @ (in0, in1, sel)
        out = sel ? in1: in0;
    
endmodule
