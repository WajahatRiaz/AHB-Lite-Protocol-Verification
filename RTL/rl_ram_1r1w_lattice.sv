
/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   Lattice Technology Specefic 1R1W RAM Memory                   //
//   Requires Lattice PMI library to simulate                      //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2021 Roa Logic BV                     //
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
// FILE NAME      : rl_ram_1r1w_lattice.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2021-11-02  rherveille  initial release with new logo
// ------------------------------------------------------------------
// KEYWORDS : Lattice MEMORY RAM 1R1W
// ------------------------------------------------------------------
// PURPOSE  : Wrapper for inferrable 1R1W RAM Blocks
// ------------------------------------------------------------------
// PARAMETERS
//  PARAM NAME      RANGE  DESCRIPTION                  DEFAULT UNITS
//  ABITS           1+     Number of address bits       10      bits
//  DBITS           1+     Number of data bits          32      bits
//  INIT_FILE              Path to initialisation file  ""
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : rstn_i; asynchronous, active low
//   Clock Domains       : clk_i; rising edge
//   Critical Timing     : 
//   Test Features       : 
//   Asynchronous I/F    : none                     
//   Scan Methodology    : na
//   Instantiations      : Yes; pmi_ram_dp_be
//   Synthesizable (y/n) : Yes
//   Other               : 
// -FHDR-------------------------------------------------------------


module rl_ram_1r1w_lattice #(
  parameter ABITS      = 10,
  parameter DBITS      = 32,
  parameter INIT_FILE  = ""
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
  output     [ DBITS     -1:0] dout_o
);

  /*
   * Instantiate Lattice DPRAM PMI Module (with BE)
   */
  pmi_ram_dp_be #(
    .pmi_wr_addr_depth    ( 2**ABITS        ),
    .pmi_wr_addr_width    ( ABITS           ),
    .pmi_wr_data_width    ( DBITS           ),
    .pmi_rd_addr_depth    ( 2**ABITS        ),
    .pmi_rd_addr_width    ( ABITS           ),
    .pmi_rd_data_width    ( DBITS           ),
    .pmi_regmode          ( "noreg"         ),
    .pmi_gsr              ( "disable"       ),
    .pmi_resetmode        ( "sync"          ),
    .pmi_optimization     ( "speed"         ),
    .pmi_init_file        ( INIT_FILE       ),
    .pmi_init_file_format ( "hex"           ),
    .pmi_byte_size        ( 8               ),
    .pmi_family           ( "ECP5"          ),
    .module_type          ( "pmi_ram_dp_be" ) )
  ram_inst (
    .Reset                ( 1'b0            ),
    .WrClock              ( clk_i           ),
    .WrClockEn            ( 1'b1            ),
    .WrAddress            ( waddr_i         ),
    .WE                   ( we_i            ),
    .ByteEn               ( be_i            ),
    .Data                 ( din_i           ),

    .RdClock              ( clk_i           ),
    .RdClockEn            ( 1'b1            ),
    .RdAddress            ( raddr_i         ),
    .Q                    ( dout_o          ) );
 
endmodule



/* Technlogy Specific Implementation for Lattice
 * This allows changing RAM contents without recompiling RTL
 */
module pmi_ram_dp_be #(
  parameter pmi_wr_addr_depth    = 512,
  parameter pmi_wr_addr_width    = 9,
  parameter pmi_wr_data_width    = 18,
  parameter pmi_rd_addr_depth    = 512,
  parameter pmi_rd_addr_width    = 9,
  parameter pmi_rd_data_width    = 18,
  parameter pmi_regmode          = "reg",
  parameter pmi_gsr              = "disable",
  parameter pmi_resetmode        = "sync",
  parameter pmi_optimization     = "speed",
  parameter pmi_init_file        = "none",
  parameter pmi_init_file_format = "binary",
  parameter pmi_byte_size        = 9,
  parameter pmi_family           = "ECP2",
  parameter module_type          = "pmi_ram_dp_be",

  localparam byteen_width        = (pmi_wr_data_width + pmi_byte_size -1)/pmi_byte_size
)
(
  input [pmi_wr_data_width -1:0] Data,
  input [pmi_wr_addr_width -1:0] WrAddress,
  input [pmi_rd_addr_width -1:0] RdAddress,
  input                          WrClock,
  input                          RdClock,
  input                          WrClockEn,
  input                          RdClockEn,
  input                          WE,
  input                          Reset,
  input  [    byteen_width -1:0] ByteEn,
  output [pmi_rd_data_width-1:0] Q) /*synthesis syn_black_box*/;
endmodule // pmi_ram_dp
