`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2019 08:57:34 AM
// Design Name: 
// Module Name: niBlock_s_PL
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


module niBlock_s_PL #(parameter NIBUSWIDTH=23,parameter NI_WIDTH = 16, parameter NUM_CHANS = 8,parameter CNT_SIZE = 32,parameter BLOCK_HALF = 2)(
    input sys_clk,
    input smpl_clk,
    input rst,
    input risingEdge,
    input [CNT_SIZE-1:0] presentTime,
    output [0:NUM_CHANS][NIBUSWIDTH-1:0] niCC,
    input updateComplete,
    output updateFlag,
    input cntFinished
     );
        
    wire [CNT_SIZE-1:0] deltaT; //difference in timing
    wire dataIn; //wire from time-stamper to let know new data has arrived from time stamper
    wire niRdy; //wire to the time-stamp to let know that data is ready to be received
    reg [0:2*NUM_CHANS][NI_WIDTH-1:0] ni;
    reg [0:NUM_CHANS][NIBUSWIDTH-1:0] niCC_d,niCC_q; //carbon copy when time to display
    reg updateFlag_d,updateFlag_q; //use flip-flop if using niCC flip flop
    reg [CNT_SIZE-1:0] shift; //bit shift for deltaT
    reg toggle; //toggle is to allow calculation of bit shift
    reg forceLast; //forces last readout at end of acquisition
    assign niCC = niCC_q;
    assign updateFlag = updateFlag_q;
    assign niRdy = !toggle && !dataIn;
 integer j;
 
//main block
 always @(posedge sys_clk)begin
    if (rst) begin
        ni <= '{default:'0};
        niCC_d <= '{default:'0};
        updateFlag_d <=0;
        toggle <=0;
        forceLast <=0;
    end else begin
        if (dataIn || forceLast) begin //if new data received
            if (deltaT==0 && !forceLast) begin //if deltaT = 0;
                ni[0] <= ni[0]+1; //accumulate in 0 bin
                if (updateComplete) begin
                    updateFlag_d <=0; //check for update
                end 
            end else begin //deltaT>0
                //post data to output
                niCC_d[0] <= ni[0];  //post to output
                
                //post blcok to update
                if (BLOCK_HALF==2)begin
                    for (j=1;j<=NUM_CHANS;j++)begin
                        niCC_d[j] <= ni[NUM_CHANS+j]; 
                    end
                end else if (BLOCK_HALF==1) begin
                    for (j=1;j<=NUM_CHANS;j++)begin
                        niCC_d[j] <= ni[j];       
                    end
                end
                updateFlag_d <=1;      //post update flag
                
                if (deltaT<=2*NUM_CHANS)begin
                    shift <= deltaT*NI_WIDTH; //compute amount to shift by
                    toggle <=1; //set toggle to update next clock cycle
                end else begin //if shift is larger than single bin
                    shift <=0; 
                    ni[0] <=1;
                    ni[1:2*NUM_CHANS] <=0;
                end
            end //end deltaT magnitude loop
        end else begin //if not new data 
            if (updateComplete) begin
                updateFlag_d <=0; //check for update
            end           
        end //end new data loop     
    end //end reset loop
    
    if (toggle) begin //complete bit shift
        toggle <=0;
        ni[0] <=1;
        ni[1:2*NUM_CHANS] <= ni >> shift;
    end
    if (cntFinished && !forceLast)begin //force final readout of data, but do so only once
        forceLast <=1;
    end else begin
        forceLast <=0;
    end
    
    niCC_q <= niCC_d;
    updateFlag_q <= updateFlag_d;
end //end always block


    
tdc_PL #(.CNTSIZE(CNT_SIZE),.MIN_DELAY(50)) tdc_pl(
    .risingEdge(risingEdge),      //detector channel 1
    .presentTime(presentTime),// time from binary counter
    .sys_clk(sys_clk),
    .smpl_clk(smpl_clk),
    .rst(rst),
    .niRdy(niRdy),
    .newData(dataIn), //newData to port
    .delay(deltaT) //interphoton timing delay
  );



endmodule
