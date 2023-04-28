`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 01:12:22 AM
// Design Name: 
// Module Name: arbiter
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


module arbiter(in0, in1, control, out, out_inv);
    
    parameter n = 128;
    
    input in0, in1;
    input [n-1:0] control;
    output out, out_inv;
    
    wire [n-1:0] wire0, wire1;
    
    switch_component InitialSwitch(wire0[0], wire1[0], control[0], in0, in1);
    
    genvar i;
    
    generate
    for(i=1; i < n; i = i + 1) begin
        switch_component Switch1Bit(wire0[i], wire1[i], control[i], wire0[i-1], wire1[i-1]);
    end
    endgenerate
    
    SR_latch SRL(out, out_inv, wire0[n-1], wire1[n-1]);
    
endmodule
