`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 09:52:50 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: top module used to pass data over the UART system to the Board and recieve the response
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(clk, rxd, txd);
    input clk;
    input rxd;
    output txd;

    //regs and wires required for UART comm
    reg [127:0] txd_data;
    reg [127:0] rxd_data;
    reg txd_valid = 0;
    reg prev_txd_active = 0;
    reg prev_rxd_valid = 0;
    reg  rxd_ready =1;
    reg [3:0] byte_in_count = 0;
    reg [3:0] byte_out_count = 0;
    
    wire [7:0] txd_output;
    wire [7:0] rxd_input;
    wire txd_active;
    wire txd_ready;
    wire rxd_valid;
    
    assign txd_output = txd_data[7:0];
    
    UART_RX URX (clk, rxd, rx_valid, rx_input);
    UART_TX UTX (clk, txd_valid, txd_output, txd_active, txd, txd_ready);
    
    //reg and wires required for PUF
    reg [127:0] challenge;
    reg [31:0] response_counter;
    reg preset = 0;
    reg signal = 0;
    
    wire [127:0] response;
    
    PUF arbiterPUF(response, signal, challenge);
    
    always @ (posedge clk) begin
        // load bye when rxd is valid
        if(!prev_rxd_valid && rxd_valid)begin
            rxd_data <= (rxd_data << 8) | rxd_input;
            byte_in_count <= byte_in_count + 1;
            
            //run data through the PUF when 16 bytes (128 bits) have been received 
            if(byte_in_count == 15) begin
                challenge <= rxd_data;
                response_counter <= 0;
                preset <=1;
                signal <= 0;
            end//if
        end//if
        
        prev_rxd_valid <= rxd_valid;
        
        //Send byte over th txd when txd is not active
        if(prev_txd_active && !txd_active)begin
            txd_data <= (txd_data >> 8) + 1;
            byte_out_count <= byte_out_count - 1;
            
            if(byte_out_count == 0)begin
                txd_valid <= 0;
            end//if
        end//if
        
        prev_txd_active <= txd_active;
        
        if(preset) begin
            response_counter <= response_counter + 1;
            
            if(response_counter == 32'hFFFFFFFF) begin
                response_counter <= 0;
                signal <= 1;
                preset <= 0;
            end //if
        end //if
        
        if(signal) begin
            response_counter <= response_counter +1;
            
            if(response_counter == 32'hFFFFFFFF) begin
                txd_data <= response;
                signal <= 0;
                byte_out_count <= 7;
                txd_valid <= 1;
            end//if
        end//if
    end//always    

endmodule
