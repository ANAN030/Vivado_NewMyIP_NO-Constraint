`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/14 20:05:39
// Design Name: 
// Module Name: MyIP_Adder8bit
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


module MyIP_Adder8bit(
    input CLK,
    input [7:0] A,
    input [7:0] B,
    output reg [8:0] S
    );
    
    always @ (posedge CLK) begin
        S = A + B;
    end
    
endmodule
