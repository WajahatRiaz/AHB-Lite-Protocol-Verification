
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   1R1W RAM Block                                                //
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
// FILE NAME      : rl_ram_1r1w.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2018-07-27  rherveille  initial release with new logo
// ------------------------------------------------------------------
// KEYWORDS : MEMORY RAM 1R1W
// ------------------------------------------------------------------
// PURPOSE  : Wrapper for technology specific 1R1W RAM Blocks
// ------------------------------------------------------------------
// PARAMETERS
//  PARAM NAME        RANGE  DESCRIPTION              DEFAULT UNITS
//  ABITS             1+     Number of address bits   10      bits
//  DBITS             1+     Number of data bits      32      bits
//  TECHNOLOGY               Technology Name          GENERIC
//  INIT_FILE                Initialization file      ""
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : asynchronous, active low
//   Clock Domains       : clk                      
//   Critical Timing     : 
//   Test Features       : 
//   Asynchronous I/F    : none                     
//   Scan Methodology    : na
//   Instantiations      : Yes; technology specific macros
//   Synthesizable (y/n) : Yes
//   Other               : 
// -FHDR-------------------------------------------------------------


module rl_ram_1r1w #(
  parameter ABITS         = 10,
  parameter DBITS         = 32,
  parameter TECHNOLOGY    = "GENERIC",
  parameter INIT_FILE     = "",
  parameter RW_CONTENTION = "BYPASS"
)
(
  input                    rst_ni,
  input                    clk_i,
 
  //Write side
  input  [ ABITS     -1:0] waddr_i,
  input  [ DBITS     -1:0] din_i,
  input                    we_i,
  input  [(DBITS+7)/8-1:0] be_i,

  //Read side
  input  [ ABITS     -1:0] raddr_i,
  input                    re_i,
  output [ DBITS     -1:0] dout_o
);
  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic             contention,
                    contention_reg;
  logic [DBITS-1:0] mem_dout,
                    din_dly;


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
generate
  if (TECHNOLOGY == "N3XS" ||
      TECHNOLOGY == "n3xs")
  begin
      /*
       * eASIC N3XS
       */
      rl_ram_1r1w_easic_n3xs #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS ) )
      ram_inst (
        .rst_ni  ( rst_ni     ),
        .clk_i   ( clk_i      ),

        .waddr_i ( waddr_i    ),
        .din_i   ( din_i      ),
        .we_i    ( we_i       ),
        .be_i    ( be_i       ),

        .raddr_i ( raddr_i    ),
        .re_i    (~contention ),
        .dout_o  ( mem_dout   )
      );
  end
  else
  if (TECHNOLOGY == "N3X"  ||
      TECHNOLOGY == "n3x")
  begin
      /*
       * eASIC N3X
       */
      rl_ram_1r1w_easic_n3x #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS ) )
      ram_inst (
        .rst_ni  ( rst_ni     ),
        .clk_i   ( clk_i      ),

        .waddr_i ( waddr_i    ),
        .din_i   ( din_i      ),
        .we_i    ( we_i       ),
        .be_i    ( be_i       ),

        .raddr_i ( raddr_i    ),
        .re_i    (~contention ),
        .dout_o  ( mem_dout   )
      );
  end
  else 
  if (TECHNOLOGY == "LATTICE_DPRAM")
  begin
	  
    rl_ram_1r1w_lattice #(
        .ABITS     ( ABITS    ),
        .DBITS     ( DBITS    ),
        .INIT_FILE ( INIT_FILE) )
      ram_inst (
        .rst_ni  ( rst_ni   ),
        .clk_i   ( clk_i    ),

        .waddr_i ( waddr_i  ),
        .din_i   ( din_i    ),
        .we_i    ( we_i     ),
        .be_i    ( be_i     ),

        .raddr_i ( raddr_i  ),
        .dout_o  ( mem_dout )
      );
	  
  end
  else // (TECHNOLOGY == "GENERIC")
  begin
      /*
       * GENERIC  -- inferrable memory
       */
      initial $display ("INFO   : No memory technology specified. Using generic inferred memory (%m)");

      rl_ram_1r1w_generic #(
        .ABITS     ( ABITS     ),
        .DBITS     ( DBITS     ),
        .INIT_FILE ( INIT_FILE ) )
      ram_inst (
        .rst_ni  ( rst_ni   ),
        .clk_i   ( clk_i    ),

        .waddr_i ( waddr_i  ),
        .din_i   ( din_i    ),
        .we_i    ( we_i     ),
        .be_i    ( be_i     ),

        .raddr_i ( raddr_i  ),
        .dout_o  ( mem_dout )
      );
  end
endgenerate


generate
if (RW_CONTENTION == "DONT_CARE")
begin
    assign dout_o = mem_dout;
end
else
begin
  //TODO Handle 'be' ... requires partial old, partial new data

  //now ... write-first; we'll still need some bypass logic
  assign contention = re_i & we_i & (raddr_i == waddr_i); //prevent 'x' from propagating from eASIC memories

  always @(posedge clk_i)
  begin
      contention_reg <= contention;
      din_dly        <= din_i;
  end

  assign dout_o = contention_reg ? din_dly : mem_dout;
end
endgenerate

endmodule

