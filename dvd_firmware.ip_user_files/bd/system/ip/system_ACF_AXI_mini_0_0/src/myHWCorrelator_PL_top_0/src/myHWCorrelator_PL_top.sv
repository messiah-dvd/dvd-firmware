`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2019 10:48:00 PM
// Design Name: 
// Module Name: myHWCorrelator_PL_top
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


module myHWCorrelator_PL_top #(parameter PRECNTSHIFT = 6, parameter MIN_NI_WIDTH=3,parameter NIBUSWIDTH=23,parameter NUM_CHANS=8,parameter S_BLOCKS=19)(
    input sys_clk,      //system clock 100 MHz design
    input smpl_clk,     //sample clock 200 MHz design
    input rst,          //reset signal
    input CH1,          //async input signal
    input [34:0] maxCnt, //maximum counter variable
    input CE,           //clock enable signal
    input initTx,       //signal to initialize print out to FIFO
    output wrEn,        //FIFO write enable
    output cntFinished, //flag that elapsed tiem has been reached
    output [63:0] acfEl //acf element to print,
    );
    localparam CNT_SIZE =35;
    localparam wrDelay =  S_BLOCKS+1-4;
    localparam rdDelay = 0;
    localparam muxDelay = 0;
    wire zeroOutput;                        ///wire for clearing BRAM
    wire risingEdge;                         //synchronized input signal
    wire [0:NUM_CHANS][NIBUSWIDTH-1:0] niOut; //ni bus Out
    wire [0:S_BLOCKS+1][NIBUSWIDTH*(NUM_CHANS+1)-1:0] niIn; //ni bus In
    wire [CNT_SIZE-1:0] presentTime;        //timer output
    wire [0:NUM_CHANS-1][63:0]acaNew,acaOld; //aca bus
    wire [S_BLOCKS+1:0] updateFlag,updateFlagSync;         //update aca flag
    wire bramWrEn,bramRdEn;                          //write/read enable
    wire [4:0] wrAddr,rdAddr,blckAddr;                      //write address
    wire newPhoton;                         //new photon detected
    wire cntFinished_smpl;
    reg CE_smpl;                            //clock crossing domain
    reg [31:0] photonCount_d,photonCount_q; //photon counters
    reg [S_BLOCKS+1:0] updateComplete;       //set to de-select update flag
    reg [4:0] wrAddr_d,wrAddr_q;            //blockram write address
    reg [4:0] rdAddr_d,rdAddr_q;            //blockram read address
    reg [4:0] blckAddr_d,blckAddr_q;        //block updat eaddress
    reg bramWrEn_d,bramWrEn_q;              //blockRAM write enable
    reg bramRdEn_d,bramRdEn_q;              //blockRAM read enable
    reg cntFinished_d,cntFinished_q;
    reg [4:0] rstCntr_d,rstCntr_q;
    assign cntFinished = cntFinished_q;
    assign bramWrEn = bramWrEn_q;
    assign wrAddr = wrAddr_q;
    assign bramRdEn = bramRdEn_q;
    assign rdAddr = rdAddr_q;
    assign blckAddr = blckAddr_q;
    assign cntFinished_smpl = (presentTime>=maxCnt) && (maxCnt >0);
    assign zeroOutput =  (rstCntr_q <=S_BLOCKS+1);
//Main always block    
always @(posedge sys_clk) begin
    if (rst) begin
        blckAddr_d <=muxDelay;   
        rdAddr_d <= rdDelay;
        wrAddr_d <= wrDelay;
        bramRdEn_d <=0;
        bramWrEn_d <= 0;
        photonCount_d <=0;
        updateComplete <=0;
        rstCntr_d <=0;
    end else begin
                if (rstCntr_q<=S_BLOCKS+1)begin
                    rstCntr_d <= rstCntr_q+1;
                    bramWrEn_d <=1;
                end else begin
                    bramWrEn_d <= updateFlagSync[wrAddr_d] && !bramWrEn_d;
                end
                blckAddr_d <= blckAddr_q < S_BLOCKS+1 ? blckAddr_q+1:0;
                rdAddr_d <= rdAddr_q < S_BLOCKS+1 ? rdAddr_q +1:0;
                bramRdEn_d <=1;  
                wrAddr_d <= wrAddr_q < S_BLOCKS+1 ? wrAddr_q + 1:0;
                updateComplete[wrAddr_d] <= updateFlagSync[wrAddr_d];
                updateComplete[wrAddr_q] <=0;
                //increment photon count
                if (newPhoton)begin
                    photonCount_d <= photonCount_q+!zeroOutput; //only increment if clock enabled
                end
             
        end     //end reset block
        
    photonCount_q <= photonCount_d;
    bramWrEn_q <= bramWrEn_d;
    wrAddr_q <= wrAddr_d;
    rdAddr_q <= rdAddr_d;
    blckAddr_q <= blckAddr_d;
    bramRdEn_q <= bramRdEn_d;
    cntFinished_d <= cntFinished_smpl;
    cntFinished_q <= cntFinished_d;
    rstCntr_q <= rstCntr_d;
end //end always block
 
always @(posedge smpl_clk)begin
    CE_smpl <= CE;
end 
 
tdc_PL #(.CNTSIZE(1),.MIN_DELAY(1)) photonCounter(
    .risingEdge(risingEdge),      //detector channel 1
    .presentTime(),// time from binary counter
    .sys_clk(sys_clk),
    .smpl_clk(smpl_clk),
    .rst(rst),
    .newData(newPhoton), //newData to port
    .delay() //interphoton timing delay
 );

//FIFO writer 
streamToFIFO #(.NUM_CHANS(NUM_CHANS), .S_BLOCKS(S_BLOCKS)) fifoWriter(
    .sys_clk(sys_clk),
    .rst(rst),
    .initTx(initTx),
    .photonCount(photonCount_q),
    .acfOld(acaOld),
    .rdAddr(rdAddr), 
    .wrEn(wrEn),
    .dataOut(acfEl)
    );


//bin multiplexer
 binMultiplexer_PL #(.NIBUSWIDTH(NIBUSWIDTH),.NUM_CHANS(NUM_CHANS),.S_BLOCKS(S_BLOCKS)) mux(
    .sys_clk(sys_clk),
    .rst(rst),
    .updateFlag(updateFlag),
    .rdAddr(rdAddr), //block address
    .niIn(niIn),
    .niOut(niOut),
    .updateFlagSync(updateFlagSync)
 );

genvar i;
genvar j;

//niBlocks
generate
    for(i=0;i<=S_BLOCKS+1;i++)begin 
        if (i==0)begin
            wire [CNT_SIZE-1:0] cntWire;
            assign cntWire = presentTime[CNT_SIZE-1:PRECNTSHIFT];
            niBlock_s_PL #(.NIBUSWIDTH(NIBUSWIDTH),.NI_WIDTH(MIN_NI_WIDTH+i), .NUM_CHANS(NUM_CHANS),.CNT_SIZE(CNT_SIZE),.BLOCK_HALF(1)) niblock(
                .sys_clk(sys_clk),
                .smpl_clk(smpl_clk),
                .rst(rst),
                .risingEdge(risingEdge),
                .presentTime(cntWire),
                .niCC(niIn[i]),
                .updateComplete(updateComplete[i]),
                .updateFlag(updateFlag[i]),
                .cntFinished(cntFinished)
            );
        end else begin
            wire [CNT_SIZE-i:0] cntWire;
            assign cntWire = presentTime[CNT_SIZE-1:(i-1)+PRECNTSHIFT];
             niBlock_s_PL #(.NIBUSWIDTH(NIBUSWIDTH),.NI_WIDTH(MIN_NI_WIDTH+(i-1)), .NUM_CHANS(NUM_CHANS),.CNT_SIZE(CNT_SIZE-(i-1)),.BLOCK_HALF(2)) niblock(
                .sys_clk(sys_clk),
                .smpl_clk(smpl_clk),
                .rst(rst),
                .risingEdge(risingEdge),
                .presentTime(cntWire),
                .niCC(niIn[i]),
                .updateComplete(updateComplete[i]),
                .updateFlag(updateFlag[i]),
                .cntFinished(cntFinished)
            );
        end //end if statement
   end  //end for block  
endgenerate 

//block RAMS
generate
    for(i=0;i<NUM_CHANS;i++)begin
        blk_mem_gen_0 brams (
            .clka(sys_clk),    // input wire clka
            .wea(bramWrEn),      // input wire [0 : 0] wea
            .addra(wrAddr),  // input wire [4 : 0] addra
            .dina(acaNew[i]),    // input wire [63 : 0] dina
            .clkb(sys_clk),    // input wire clkb
            .rstb(rst),    // input wire rstb
            .enb(bramRdEn),      // input wire enb
            .addrb(rdAddr),  // input wire [4 : 0] addrb
            .doutb(acaOld[i])  // output wire [63 : 0] doutb
        );
     end
endgenerate
         
//multiply adders
generate
    for (i=0;i<NUM_CHANS;i++)begin   
     myMultAdder multAdd(
        .sys_clk(sys_clk),
        .rst(rst),
        .zeroOutput(zeroOutput),
        .A(niOut[0]),
        .B(niOut[i+1]),
        .C(acaOld[i]),
        .D(acaNew[i])
    ); 
    end
endgenerate
         
//edge detector
edge_Detect edgeDetect(
        .async_sig(CH1),
        .smpl_clk(smpl_clk),
        .CE(CE_smpl),
        .rise(risingEdge),
        .fall()
        );    
    
//main clock counter
c_counter_binary_0 mainTimer (
    .CLK(smpl_clk),          // input wire CLK
    .CE(CE_smpl),            // input wire CE
    .SCLR(rst),             // input wire SCLR
    .Q(presentTime)        // output wire [34 : 0] Q
);
    
endmodule
