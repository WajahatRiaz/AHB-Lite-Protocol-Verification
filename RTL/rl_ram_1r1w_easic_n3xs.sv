
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   eASIC Nextreme-3S 1R1W RAM Block Wrapper                      //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2016-2018 Roa Logic BV                //
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
// FILE NAME      : rl_ram_1r1w_easic_n3xs.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2018-07-27  rherveille  initial release with new logo
// ------------------------------------------------------------------
// KEYWORDS : eASIC Nextreme3S MEMORY RAM 1R1W
// ------------------------------------------------------------------
// PURPOSE  : Wrapper for eASIC Nextreme-3S 1R1W RAM Blocks
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
//   Instantiations      : Yes; eip_n3xs_rfile_array
//                              eip_n3xs_bram_array
//   Synthesizable (y/n) : Yes
//   Other               : 
// -FHDR-------------------------------------------------------------


module rl_ram_1r1w_easic_n3xs #(
  parameter ABITS      = 8,
  parameter DBITS      = 8
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

  localparam DEPTH = 2**ABITS;
  localparam WIDTH = DBITS;


  logic [DBITS-1:0] biten;
  genvar i;

generate
  for (i=0;i<DBITS;i++)
  begin: gen_bitena
      assign biten[i] = be_i[i/8];
  end
endgenerate

generate
  /*
   * Nextreme-3S supports two types of bRAMs
   * -bRAM18k
   * -bRAM2k (aka RF)
   *
   * Configurations
   * bRAM18K        bRAM2K
   * 16k x  1        2k x  1
   *  8k x  2        1k x  2
   *  4k x  4       512 x  4
   *  2k x  8       256 x  8
   *  1k x 16       128 x 16 (sdp_array)
   * 512 x 32
   *
   *  2k x  9
   *  1k x 18
   * 512 x 36
   */
  if (DEPTH * WIDTH <= 4096)
  begin
      //bRAM2k
      eip_n3xs_rfile_array #(
        .WIDTHA    ( DBITS    ),
        .WIDTHB    ( DBITS    ),
        .DEPTHA    ( 2**ABITS ),
        .DEPTHB    ( 2**ABITS ),
        .REG_OUTB  ( "NO"     ),
        .TARGET    ( "POWER"  ) )
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
  end
  else
  begin
      //bRAM18k
      eip_n3xs_bram_array #(
        .WIDTHA    ( DBITS    ),
        .WIDTHB    ( DBITS    ),
        .DEPTHA    ( 2**ABITS ),
        .DEPTHB    ( 2**ABITS ),
        .REG_OUTB  ( "NO"     ),
        .TARGET    ( "POWER"  ) )
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
end

endgenerate

endmodule

