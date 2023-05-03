`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 07:28:58 PM
// Design Name: 
// Module Name: UART_TXD
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


module UART_TXD(clk, tx_DV, tx_Byte, tx_Active_out, tx_Serial_out, tx_Done_out);

    parameter clks_per_Bit = 867;

    input clk, tx_DV;
    input [7:0] tx_Byte;
    output tx_Active_out;
    output reg tx_Serial_out;
    output tx_Done_out;
    
    parameter IDLE = 3'b000;
    parameter tx_Start_Bit = 3'b001;
    parameter tx_Data_Bit = 3'b010;
    parameter tx_Stop_Bit = 3'b011;
    parameter cleanup = 3'b100;
    
    reg tx_Done = 1'b1;
    reg tx_Active = 1'b1;
    
    reg [7:0] clk_Count = 0;
    reg [2:0] bit_Index = 0;
    reg [7:0] tx_Data = 0;
    reg [2:0] sm_Main = 0;
    
    always @(posedge clk) begin
        case(sm_Main)
            IDLE: begin
                tx_Serial_out <= 1'b1;
                tx_Done <= 1'b0;
                clk_Count <= 0;
                bit_Index <= 0;
                
                if(tx_DV == 1'b1) begin 
                    tx_Active <= 1'b1;
                    tx_Data <= tx_Byte;
                    sm_Main <= tx_Start_Bit;
                end //if
                else
                    sm_Main <= IDLE;
            end
            
            // send start Bit bit = 0
            tx_Start_Bit: begin
                tx_Serial_out <= 1'b0;
                
                if(clk_Count < 866) begin 
                    clk_Count <= clk_Count + 1;
                    sm_Main <= tx_Start_Bit;
                end //if
                else begin
                    clk_Count <= 0;
                    sm_Main <= tx_Data_Bit;
                end
            end                    
            
            // Wait clks_per_Bit-1 clock cycles to sample serial data
            tx_Data_Bit: begin    
                tx_Serial_out <= tx_Data[bit_Index];
                
                if(clk_Count < 866) begin
                    clk_Count <= clk_Count + 1;
                    sm_Main <= tx_Data_Bit;
                end //if
                else begin
                    clk_Count <= 0;
                    //check if all bits have been sent
                    if(bit_Index < 7) begin
                        bit_Index <= bit_Index + 1;
                        sm_Main <= tx_Data_Bit;
                    end //if
                    else begin
                        bit_Index <= 0;
                        sm_Main <= tx_Stop_Bit;
                    end //else
                end //else
            end   
            
            //Send stop bit bit = 1
            tx_Stop_Bit: begin
                tx_Serial_out <= 1'b1;
                //wait for stop bit to finish
                if(clk_Count < 866) begin
                    clk_Count <= clk_Count + 1;
                    sm_Main <= tx_Stop_Bit;
                end //if
                else begin
                    tx_Done <= 1'b1;
                    clk_Count <= 0;
                    sm_Main <= cleanup;
                    tx_Active <= 1'b0;
                end // else
            end
            
            cleanup: begin
                tx_Done <= 1'b1;
                sm_Main <= IDLE;
            end
            
            default:
                sm_Main <= IDLE;
        endcase
    end //always
    
    assign tx_Active_out = tx_Active;
    assign tx_Done_out = tx_Done;                 
                        
endmodule
