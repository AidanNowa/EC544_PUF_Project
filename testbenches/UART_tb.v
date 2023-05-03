`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 08:45:55 PM
// Design Name: 
// Module Name: UART_tb
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


module UART_tb;

    parameter clk_period_ns = 40; //clk on board is 100MHz
    parameter clks_per_bit = 217; //based off 115200 baud
    parameter bit_period = 8600; //based off 115200 baud
    
    reg clk = 0;
    reg tx_DV = 0;
    wire tx_Done;
    reg [7:0] tx_Byte = 0;
    reg rx_Serial = 1;
    wire [7:0] rx_Byte;
    
    task UART_Write_Byte;
    input [7:0] i_Data;
    integer i;
    begin
        //send start bit
        rx_Serial <= 1'b0;
        #(bit_period)
        #1000;
        
        //Send Data byte
        for (i = 0; i < 8; i = i + 1) begin
            rx_Serial <= i_Data[i];
            #(bit_period);
        end //for
    end //begin
    endtask
    
    UART_RXD UART_RX_INST (.clk(clk), .rx_Serial(rx_Serial), .rx_DV_out(), .rx_Byte_out(rx_Byte));
    
    UART_TXD UART_TX_INST(.clk(clk), .tx_DV(tx_DV), .tx_Byte(tx_Byte), .tx_Active_out(),
                          .tx_Serial_out(), .tx_Done_out(tx_Done));
    
    always
    #(clk_period_ns/2) clk <= !clk;   
    
    
    initial begin
        //tell UART to send command through TXD
        @(posedge clk);
            tx_DV <= 1'b1;
            tx_Byte <= 8'hAB;
        @(posedge clk);
            tx_DV <= 1'b1;
        @(posedge tx_Done);
        //Send command to UART through RXD
        @(posedge clk);
            UART_Write_Byte(8'h3F);
        @(posedge clk);
        //check for correctness
        if(rx_Byte == 8'h3F)
            $display("Correct Byte Received");
        else
            $display("Incorrect Byte Received");
        
    end
        
endmodule
