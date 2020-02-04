`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 12:26:12 AM
// Design Name: 
// Module Name: streamtoFIFO
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

module streamToFIFO #(parameter NUM_CHANS = 8, parameter S_BLOCKS = 1)(
    input sys_clk,
    input rst,
    input initTx,
    input [31:0] photonCount,
    input [0:NUM_CHANS-1][63:0] acfOld,
    input [4:0] rdAddr, 
    output wrEn,
    output [63:0] dataOut
    );
    localparam latDelay = 2;
    reg [5:0] chanCntr_d,chanCntr_q;
    reg [7:0] blckCntr_d,blckCntr_q;
    reg [63:0] dataOut_d,dataOut_q;
    reg [0:NUM_CHANS-1][63:0] acf;
    reg [2:0] latencyCntr;
    reg wrEn_d,wrEn_q;
    reg txData; //indicates that we are in a transmit block
    reg newSet_d,newSet_q; //indicates a new block has been read into memory
    
    assign dataOut = dataOut_q;
    assign wrEn = wrEn_q;
    
always @(posedge sys_clk)begin
    if (rst) begin
        dataOut_d <= 0;
        blckCntr_d <=0;
        txData <= 0;
        wrEn_d <=0;
        wrEn_q <=0;
        newSet_d <= 0;
    end else begin
        //If new transmission
        if (initTx)begin //init tx only high for 1 clock cycle
            txData <=1;
            chanCntr_d <=NUM_CHANS;
            dataOut_d <= photonCount; //write photon count
            wrEn_d <=1;
            blckCntr_d <=0 ; //rset block counter
            latencyCntr = 0;
        end else begin 
          

            //get new S_block
            if (txData && chanCntr_q==NUM_CHANS)begin //if last block readout complete
                wrEn_d <=0;
                if (rdAddr == blckCntr_q || latencyCntr>0)begin //if read address matches current block
                    if (latencyCntr>=latDelay)begin
                        latencyCntr <=0;
                        blckCntr_d <= blckCntr_q+1;
                        acf <= acfOld; //read value into local memory
                        chanCntr_d <=0; //reset to new block
                        dataOut_d <= acfOld[0];
                        newSet_d <=1;
                        txData <=1;
                    end else begin
                        latencyCntr = latencyCntr+1;
                    end                                          
                end else if(txData && chanCntr_d==NUM_CHANS) begin
                    newSet_d <=0;
                    txData <= blckCntr_d < S_BLOCKS+2;
                end    
            //print current S_block
            end else if (txData && chanCntr_q < NUM_CHANS && newSet_q)begin  
                if (wrEn_d)begin
                    wrEn_d <=0; //enable write to fifo
                end else begin //pause 1 cycle in between writes
                    wrEn_d <=chanCntr_q<(NUM_CHANS); //do not write output yet
                    dataOut_d <= acf[chanCntr_q]; //set output
                    chanCntr_d <= chanCntr_q+1; //incremment channel counter
                end
            end else begin//end print block 
             wrEn_d <=0;
            end  
         end //end if initTx High                  
    end //end reset
    blckCntr_q <= blckCntr_d;
    chanCntr_q <= chanCntr_d;
    wrEn_q <= wrEn_d;
    newSet_q <= newSet_d;
    dataOut_q <= dataOut_d;
end //end always block
endmodule    
    
    
