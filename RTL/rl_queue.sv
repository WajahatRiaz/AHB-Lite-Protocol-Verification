
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//    RISC-V                                                       //
//    Fall-through Queue                                           //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2018 ROA Logic BV                     //
//             www.roalogic.com                                    //
//                                                                 //
//     Unless specifically agreed in writing, this software is     //
//   licensed under the RoaLogic Non-Commercial License            //
//   version-1.0 (the "License"), a copy of which is included      //
//   with this file or may be found on the RoaLogic website        //
//   http://www.roalogic.com. You may not use the file except      //
//   in compliance with the License.                               //
//                                                                 //
//     THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY           //
//   EXPRESS OF IMPLIED WARRANTIES OF ANY KIND.                    //
//   See the License for permissions and limitations under the     //
//   License.                                                      //
//                                                                 //
/////////////////////////////////////////////////////////////////////

// +FHDR -  Semiconductor Reuse Standard File Header Section  -------
// FILE NAME      : rl_queue.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2018-07-27  rherveille  initial release
// ------------------------------------------------------------------
// KEYWORDS : QUEUE
// ------------------------------------------------------------------
// PURPOSE  : Parameterized fall-through queue
// ------------------------------------------------------------------
// PARAMETERS
//  PARAM NAME             RANGE       DESCRIPTION                DEFAULT UNITS
//  DEPTH                   1+         Number of queue entries    2       words
//  DBITS                   1+         Number of data bits        32      bits
//  ALMOST_EMPTY_THRESHOLD [1,DEPTH  ] Threshold for almost_empty DEPTH   words
//  ALMOST_FULL_THRESHOLD  [0,DETPH-1] Threshold for almost_full  0       words
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : rstn_i; asynchronous, active low
//                         clr_i; synchronous active high
//   Clock Domains       : clk_i; rising edge
//   Critical Timing     : 
//   Test Features       : 
//   Asynchronous I/F    : none
//   Scan Methodology    : na
//   Instantiations      : none
//   Synthesizable (y/n) : Yes
//   Other               : 
// -FHDR-------------------------------------------------------------


/*
 * Parameterized Fall-Through Queue
 * This is a stack of registers of level 'DEPTH'.
 * The output always points to level 0
 * As new data is written to the next higher available stack level
 * As data is read, the old data 'falls-through' to the next lower level
 *
 * 'almost_empty_o' is a user configurable 'empty' signal.
 * 'almost_full_o' is a user configurable 'full' signal.
 * Their thresholds are set by the ALMOST_EMPTY/FULL_THRESHOLD parameters
 */

module rl_queue #(
  parameter DEPTH                  = 2,
  parameter DBITS                  = 32,
  parameter ALMOST_EMPTY_THRESHOLD = 0,
  parameter ALMOST_FULL_THRESHOLD  = DEPTH
)
(
  input  logic             rst_ni,         //asynchronous, active low reset
  input  logic             clk_i,          //rising edge triggered clock

  input  logic             clr_i,          //clear all queue entries (synchronous reset)
  input  logic             ena_i,          //clock enable

  //Queue Write
  input  logic             we_i,           //Queue write enable
  input  logic [DBITS-1:0] d_i,            //Queue write data

  //Queue Read
  input  logic             re_i,           //Queue read enable
  output logic [DBITS-1:0] q_o,            //Queue read data

  //Status signals
  output logic             empty_o,        //Queue is empty
                           full_o,         //Queue is full
                           almost_empty_o, //Programmable almost empty
                           almost_full_o   //Programmable almost full
);

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  localparam EMPTY_THRESHOLD = 1;
  localparam FULL_THRESHOLD  = DEPTH -2;
  localparam ALMOST_EMPTY_THRESHOLD_CHECK = ALMOST_EMPTY_THRESHOLD <= 0     ? EMPTY_THRESHOLD : ALMOST_EMPTY_THRESHOLD +1;
  localparam ALMOST_FULL_THRESHOLD_CHECK  = ALMOST_FULL_THRESHOLD  >= DEPTH ? FULL_THRESHOLD  : ALMOST_FULL_THRESHOLD -2;


  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic [DBITS        -1:0] queue_data[DEPTH];
  logic [$clog2(DEPTH)-1:0] queue_wadr;


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Write Address
  always @(posedge clk_i,negedge rst_ni)
    if      (!rst_ni) queue_wadr <= 'h0;
    else if ( clr_i ) queue_wadr <= 'h0;
    else if ( ena_i )
      unique case ({we_i,re_i})
         2'b01 : queue_wadr <= queue_wadr -1;
         2'b10 : queue_wadr <= queue_wadr +1;
         default: ;
      endcase


  //Queue Data
  always @(posedge clk_i,negedge rst_ni)
    if (!rst_ni)
      for (int n=0; n<DEPTH; n++) queue_data[n] <= 'h0;
    else if (clr_i)
      for (int n=0; n<DEPTH; n++) queue_data[n] <= 'h0;
    else if (ena_i)
    unique case ({we_i,re_i})
       2'b01  : begin
                    for (int n=0; n<DEPTH-1; n++)
                      queue_data[n] <= queue_data[n+1];

                    queue_data[DEPTH-1] <= 'h0;
                end

       2'b10  : begin
                    queue_data[queue_wadr] <= d_i;
                end

       2'b11  : begin
                    for (int n=0; n<DEPTH-1; n++)
                      queue_data[n] <= queue_data[n+1];

                    queue_data[DEPTH-1] <= 'h0;

                    queue_data[~|queue_wadr ? DEPTH-1 : queue_wadr-1] <= d_i;
                end

       default: ;
    endcase


  //Queue Almost Empty
  always @(posedge clk_i, negedge rst_ni)
    if      (!rst_ni) almost_empty_o <= 1'b1;
    else if ( clr_i ) almost_empty_o <= 1'b1;
    else if ( ena_i )
      unique case ({we_i,re_i})
         2'b01  : almost_empty_o <= (queue_wadr <= ALMOST_EMPTY_THRESHOLD_CHECK);
         2'b10  : almost_empty_o <=~(queue_wadr >  ALMOST_EMPTY_THRESHOLD_CHECK);
         default: ;
      endcase


  //Queue Empty
  always @(posedge clk_i, negedge rst_ni)
    if      (!rst_ni) empty_o <= 1'b1;
    else if ( clr_i ) empty_o <= 1'b1;
    else if ( ena_i )
      unique case ({we_i,re_i})
         2'b01  : empty_o <= (queue_wadr == EMPTY_THRESHOLD);
         2'b10  : empty_o <= 1'b0;
         default: ;
      endcase


  //Queue Almost Full
  always @(posedge clk_i, negedge rst_ni)
    if      (!rst_ni) almost_full_o <= 1'b0;
    else if ( clr_i ) almost_full_o <= 1'b0;
    else if ( ena_i )
      unique case ({we_i,re_i})
         2'b01  : almost_full_o <=~(queue_wadr <  ALMOST_FULL_THRESHOLD_CHECK);
         2'b10  : almost_full_o <= (queue_wadr >= ALMOST_FULL_THRESHOLD_CHECK);
         default: ;
      endcase


  //Queue Full
  always @(posedge clk_i, negedge rst_ni)
    if      (!rst_ni) full_o <= 1'b0;
    else if ( clr_i ) full_o <= 1'b0;
    else if ( ena_i )
      unique case ({we_i,re_i})
         2'b01  : full_o <= 1'b0;
         2'b10  : full_o <= (queue_wadr == FULL_THRESHOLD);
         default: ;
      endcase



  //Queue output data
  assign q_o = queue_data[0];


`ifdef RL_QUEUE_WARNINGS
  always @(posedge clk_i)
    begin
        if (empty_o && !we_i &&  re_i) $display("rl_queue (%m): underflow @%0t", $time);
        if (full_o  &&  we_i && !re_i) $display("rl_queue (%m): overflow @%0t", $time);
    end
`endif

endmodule