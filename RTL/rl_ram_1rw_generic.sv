
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   Technology Independent (Inferrable) 1RW RAM Memory            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2014-2018 Roa Logic BV                //
//             www.roalogic.com                                    //
//                                                                 //
//   This source file may be used and distributed without          //
//   restriction provided that this copyright statement is not     //
//   removed from the file and that any derivative work contains   //
//   the original copyright notice and the associated disclaimer.  //
//                                                                 //
//      THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY        //
//   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED     //
//   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS     //
//   FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR OR     //
//   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,  //
//   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT  //
//   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;  //
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)      //
//   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     //
//   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  //
//   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS          //
//   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  //
//                                                                 //
/////////////////////////////////////////////////////////////////////

// +FHDR -  Semiconductor Reuse Standard File Header Section  -------
// FILE NAME      : rl_ram_1rw_generic.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2018-07-27  rherveille  initial release with new logo
// ------------------------------------------------------------------
// KEYWORDS : Generic Inferrable (FPGA) MEMORY RAM 1RW
// ------------------------------------------------------------------
// PURPOSE  : Wrapper for inferrable 1RW RAM Blocks
// ------------------------------------------------------------------
// PARAMETERS
//  PARAM NAME        RANGE  DESCRIPTION              DEFAULT UNITS
//  ABITS             1+     Number of address bits   10      bits
//  DBITS             1+     Number of data bits      32      bits
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : rstn_i; asynchronous, active low
//   Clock Domains       : clk_i; rising edge
//   Critical Timing     : 
//   Test Features       : 
//   Asynchronous I/F    : none                     
//   Scan Methodology    : na
//   Instantiations      : Yes; eip_n3x_bram_array
//   Synthesizable (y/n) : Yes
//   Other               : 
// -FHDR-------------------------------------------------------------


module rl_ram_1rw_generic #(
  parameter ABITS      = 10,
  parameter DBITS      = 32,
  parameter INIT_FILE  = ""
)
(
  input                        rst_ni,
  input                        clk_i,

  input      [ ABITS     -1:0] addr_i,
  input                        we_i,
  input      [(DBITS+7)/8-1:0] be_i,
  input      [ DBITS     -1:0] din_i,
  output reg [ DBITS     -1:0] dout_o
);

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  genvar i;

  reg [DBITS-1:0] mem_array [2**ABITS -1:0];  //memory array
  reg [ABITS-1:0] addr_reg;                   //latched read address


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //preload memory
  //This seems to be synthesizable in FPGAs
  initial
    if (INIT_FILE != "")
    begin
        $display ("INFO   : Loading %s (%m)", INIT_FILE);
        $readmemh(INIT_FILE, mem_array);
    end


  //write side
generate
  for (i=0; i<(DBITS+7)/8; i++)
  begin: write
     if (i*8 +8 > DBITS)
     begin
         always @(posedge clk_i)
           if (we_i && be_i[i]) mem_array[ addr_i ] [DBITS-1:i*8] <= din_i[DBITS-1:i*8];
     end
     else
     begin
         always @(posedge clk_i)
           if (we_i && be_i[i]) mem_array[ addr_i ][i*8+:8] <= din_i[i*8+:8];
     end
  end
endgenerate

  //read side
  //per Altera's recommendations; avoids bypass logic
  always @(posedge clk_i)
    dout_o <= mem_array[ addr_i ];
endmodule

