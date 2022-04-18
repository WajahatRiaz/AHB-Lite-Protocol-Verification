
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   eASIC Nextreme-3 1R1W RAM Block Wrapper                       //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2015-2018 Roa Logic BV                //
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
// FILE NAME      : rl_ram_1r1w_easic_n3x.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2018-07-27  rherveille  initial release with new logo
// ------------------------------------------------------------------
// KEYWORDS : eASIC Nextreme3 MEMORY RAM 1R1W
// ------------------------------------------------------------------
// PURPOSE  : Wrapper for eASIC Nextreme-3 1R1W RAM Blocks
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


module rl_ram_1r1w_easic_n3x #(
  parameter ABITS      = 10,
  parameter DBITS      = 32
)
(
  input                        rst_ni,
  input                        clk_i,

  //Write side
  input      [ ABITS     -1:0] waddr_i,
  input      [ DBITS     -1:0] din_i,
  input                        we_i,
  input      [(DBITS+7)/8-1:0] be_i,

  //Read side
  input      [ ABITS     -1:0] raddr_i,
  input                        re_i,
  output reg [ DBITS     -1:0] dout_o
);

  logic [DBITS-1:0] biten;
  genvar i;


generate
  for (i=0;i<DBITS;i++)
  begin: gen_bitena
      assign biten[i] = be_i[i/8];
  end
endgenerate

  eip_n3x_bram_array #(
    .WIDTHA        ( DBITS    ),
    .WIDTHB        ( DBITS    ),
    .DEPTHA        ( 2**ABITS ),
    .DEPTHB        ( 2**ABITS ),
    .REG_OUTA      ( "NO"     ),
    .REG_OUTB      ( "NO"     ),
    .INIT_ON       ( "NO"     ),
    .NINE_BIT_MODE ( "AUTO"   ),
    .TARGET        ( "POWER"  ) )
  ram_inst (
    .CLKA   ( clk_i         ),
    .AA     ( raddr_i       ),
    .DA     ( {DBITS{1'b0}} ),
    .QA     ( dout_o        ),
    .MEA    ( re_i          ),
    .WEA    ( 1'b0          ),
    .BEA    ( {DBITS{1'b1}} ),
    .RSTA_N ( 1'b1          ),

    .CLKB   ( clk_i         ),
    .AB     ( waddr_i       ),
    .DB     ( din_i         ),
    .QB     (               ),
    .MEB    ( 1'b1          ),
    .WEB    ( we_i          ),
    .BEB    ( biten         ),
    .RSTB_N ( 1'b1          ),

    .SD     ( 1'b0          ),
    .DS     ( 1'b0          ),
    .LS     ( 1'b0          ) );
endmodule

