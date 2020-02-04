`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 12:10:20 AM
// Design Name: 
// Module Name: binMultiplexer_PL
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


module binMultiplexer_PL #(parameter NIBUSWIDTH=23, parameter NUM_CHANS = 8,parameter S_BLOCKS = 20)(
    input sys_clk,
    input rst,
    input [S_BLOCKS+1:0] updateFlag,
    input [4:0] rdAddr, //block address
    input [0:S_BLOCKS+1][(NUM_CHANS+1)*NIBUSWIDTH-1:0] niIn,
    output [0:NUM_CHANS][NIBUSWIDTH-1:0] niOut,
    output [S_BLOCKS+1:0] updateFlagSync
    );
    
    reg [0:NUM_CHANS][NIBUSWIDTH-1:0] niOut_d,niOut_q;
    reg [S_BLOCKS+1:0] updateFlag_d,updateFlag_q;
    assign niOut = niOut_q;
    assign updateFlagSync = updateFlag_q;

    always @(posedge sys_clk)begin
        if (rst) begin
            niOut_d = '{default:'0};
            updateFlag_d <=0; //reset all blocks to 0
        end else begin
            niOut_d <= niIn[rdAddr];
            updateFlag_d[rdAddr] <= updateFlag[rdAddr]; //sync updateFlag
        end
        niOut_q <= niOut_d;    
        updateFlag_q <= updateFlag_d;
    end
    
    
endmodule
