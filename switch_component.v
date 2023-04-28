`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 01:03:37 AM
// Design Name: 
// Module Name: switch_component
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Switches inputs through 2 muxes then introduces slight delay by inverting, 
//              then inverting output again to return to original value.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module switch_component(out0, out1, sel, in0, in1);
    input sel, in0, in1;
    output out0, out1;
    
    wire mux_0_out, mux_1_out, not_0_out, not_1_out;
    
    mux2to1 Mux0(mux_0_out, in0, in1, sel);
    mux2to1 Mux1(mux_1_out, in1, in0, sel);
    
    not NOT0(not_0_out, mux_0_out);
    not NOT1(not_1_out, mux_1_out);
    
    not NOT0_undo(out0, not_0_out);
    not NOT1_undo(out1, not_1_out);
    
endmodule
