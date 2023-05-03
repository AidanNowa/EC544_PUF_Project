`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 07:28:58 PM
// Design Name: 
// Module Name: UART_RXD
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


module UART_RXD(clk, rx_Serial, rx_DV_out, rx_Byte_out);

    parameter clks_per_Bit = 867;

    input clk, rx_Serial;
    output rx_DV_out;
    output [7:0] rx_Byte_out;
    
    parameter IDLE = 3'b000;
    parameter rx_Start_Bit = 3'b001;
    parameter rx_Data_Bit = 3'b010;
    parameter rx_Stop_Bit = 3'b011;
    parameter cleanup = 3'b100;
    
    reg rx_Data_R = 1'b1;
    reg rx_Data = 1'b1;
    
    reg [7:0] clk_Count = 0;
    reg [2:0] bit_Index = 0;
    reg [7:0] rx_Byte = 0;
    reg rx_DV = 0;
    reg [2:0] sm_Main = 0;
    
    //create a double register for the incoming data.
    always @(posedge clk) begin
        rx_Data_R <= rx_Serial;
        rx_Data <= rx_Data_R;
    end //always
    
    //control state machine
    always @(posedge clk) begin
        case(sm_Main)
            IDLE: begin
                rx_DV <= 1'b0;
                clk_Count <= 0;
                bit_Index <= 0;
                
                if(rx_Data == 1'b0) //start bit detected
                    sm_Main <= rx_Start_Bit;
                else
                    sm_Main <= IDLE;
            end
            
            // check middle of start bit
            rx_Start_Bit: begin
                if(clk_Count == 433) begin // halfway
                    if(rx_Data == 1'b0) begin
                        clk_Count <= 0;
                        sm_Main <= rx_Data_Bit;
                    end //if
                    else
                    sm_Main <= IDLE;
                end //if
                else begin
                    clk_Count <= clk_Count + 1;
                    sm_Main <= rx_Start_Bit;
                end //else
            end 
            
            // Wait clks_per_Bit-1 clock cycles to sample serial data
            rx_Data_Bit: begin    
                if(clk_Count < 866) begin
                    clk_Count <= clk_Count + 1;
                    sm_Main <= rx_Data_Bit;
                end //if
                else begin
                    clk_Count <= 0;
                    rx_Byte[bit_Index] <= rx_Data;
                    
                    //check all bits have been recieved
                    if(bit_Index < 7) begin
                        bit_Index <= bit_Index + 1;
                        sm_Main <= rx_Data_Bit;
                    end //if
                    else begin
                        bit_Index <= 0;
                        sm_Main <= rx_Stop_Bit;
                    end //else
                end //else
            end    
            
            //receive stop bit
            rx_Stop_Bit: begin
                if(clk_Count < 866) begin
                    clk_Count <= clk_Count + 1;
                    sm_Main <= rx_Stop_Bit;
                end //if
                else begin
                    rx_DV <= 1'b1;
                    clk_Count <= 0;
                    sm_Main <= cleanup;
                end // else
            end
            
            cleanup: begin
                sm_Main <= IDLE;
                rx_DV <= 1'b0;
            end
            
            default:
                sm_Main <= IDLE;
        endcase
    end //always
    
    assign rx_DV_out = rx_DV;
    assign rx_Byte_out = rx_Byte;                 
                        
endmodule



