`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/15 15:00:58
// Design Name: 
// Module Name: MyIP_Adder8bit_tb
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


module MyIP_Adder8bit_tb();

    reg CLK_tb;
    reg [7:0] A_tb;
    reg [7:0] B_tb;
    wire [8:0] S_tb;
    
    MyIP_Adder8bit U1(.CLK(CLK_tb), .A(A_tb), .B(B_tb), .S(S_tb));
    
    initial begin
        CLK_tb = 0;
        A_tb = 0;
        B_tb = 0;
        
        #35;
        
        A_tb = 3;
        B_tb = 4;
        
        #26;
                
        A_tb = 7;
        B_tb = 2;

    end
    
    always #10 CLK_tb <= ~CLK_tb;

endmodule
