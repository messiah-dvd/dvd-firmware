`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2019 10:48:24 PM
// Design Name: 
// Module Name: Z_Block
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


module Z_Block #(parameter NUM_PTS = 16,parameter CNT_SIZE = 32,parameter ACA_WIDTH=32)(
    input sys_clk,
    input smpl_clk,
    input rst,
    input CE,
    input risingEdge,
    input initTx,
    input [CNT_SIZE-1:0] presentTime,
    output reg zTx,
    output reg sTx,
    output [63:0] acaOut
    );

wire dataIn;
wire [CNT_SIZE-1:0] deltaT;
reg [0:NUM_PTS-1][ACA_WIDTH-1:0] aca_d,aca_q;
reg [63:0] acaOut_d,acaOut_q;
reg [NUM_PTS:0] UA_d,UA_q;
reg toggle;
reg [4:0] txCnt_d,txCnt_q;

assign acaOut = acaOut_q;


integer j;
always @(posedge sys_clk)begin
    if (rst) begin
        UA_d <=0;
        aca_d <= '{default:'0};
    end else begin
        if (dataIn)begin
            if (deltaT>NUM_PTS)begin
                UA_d <= 0;
            end else begin
                UA_d <= UA_q << deltaT; 
                UA_d[deltaT] <=1;  //not sure if this is ok
            end    
            for(j=0;j<NUM_PTS;j++)begin
                aca_d[j] <= aca_q[j]+UA_q[j+1];
            end            
        end  //end data in   
    end
    aca_q <= aca_d;
    UA_q <= UA_d;
 end
    
 always @(posedge sys_clk) begin
    if (rst) begin
        zTx <=0; 
        sTx <=0;
        acaOut_d <= 0;
        txCnt_d <=0;
    end else begin
        if (initTx) begin
            zTx <=1; //initiate transmission
        end else begin
            if (zTx)begin
                if (txCnt_q <NUM_PTS)begin
                    acaOut_d <= aca_q[txCnt_q];
                    txCnt_d <= txCnt_q+1;
                    zTx <=1;
                end else begin
                    zTx <=0;
                    sTx <=1;
                end
            end else begin
                sTx <=0;
            end             
        end
    end
    acaOut_q <= acaOut_d;
    txCnt_q <= txCnt_q;
 end           
              
tdc_PL #(.CNTSIZE(CNT_SIZE)) tdc_pl(
    .risingEdge(risingEdge),      //detector channel 1
    .presentTime(presentTime),// time from binary counter
    .sys_clk(sys_clk),
    .smpl_clk(smpl_clk),
    .rst(rst),
    .newData(dataIn), //newData to port
    .delay(deltaT) //interphoton timing delay
  );    
    
endmodule
