
// These modules represent components for a MIPS-like datapath.
// -----------------------------------------------------------------


// Figure 1: The code instantiated for all 'regular' 32-bit registers.
module register_32bit(
 input wire clock,
 input wire enable,
 input wire [31:0] D,
 output reg [31:0] Q);

//making it an actual
//register
//clock, and write/enable functionality
always @ (posedge clock) begin
 if (enable) begin
  Q[31:0] <= D[31:0];
 end
end
endmodule


// Figure 2: The code instantiated for 64-bit registers, specifically the Z register.
module register_64bit(
 input clock,
 input enable,
 input [63:0] ALU_out,
 output reg [31:0] out_HI,
 output reg [31:0] out_LO
 );
always @ (posedge clock) begin
 if (enable) begin
  out_LO <= ALU_out [31:0];
  out_HI <= ALU_out [63:32];
 end
end
endmodule


// Figure 3: specialized Register R0 with additional input
module register_r0(
 input clock,
 input clear,
 input enable,
 input BAOut,
 input wire [31:0] D,
 output reg [31:0] Q
 );
reg [31:0] temp;
always @(posedge clock) begin
 if (enable && clear) begin
  temp [31:0] <= D[31:0];
 end
 Q <= ! BAOut && temp;
end
endmodule


// Figure 4: Module code for the Program Counter, which has additional functionality.
module ProgramCounter(
 input clock,
 input enable,
 output reg [31:0] PC,
 output reg PCinc
 );
always @ (posedge clock) begin
 if (enable) begin
  PC <= PC + 4;
  PCinc <= 1;
 end
end
endmodule


// Figure 5: Module code for the Instruction Register, which has additional functionality.
module Instruction_register(
 input clock,
 input IRin, //enable WRITE
 input MDRout, //control READ
 input PCinc, //if current instruction changes
 input wire [31:0] IR_in,
 output reg [31:0] IR_out
 );
always @ (posedge clock) begin
 if (clear) begin
  IR_out <= 32'b0;
 end
 if((IRin || MDRout) && PCinc) begin //write
  IR_out [31:0] <= IR_in [31:0]; //put the current instruction into the IR from MDR
 end
end
endmodule


// Figure 6: Code for the 32-to-8 encoder used for selecting the source register for the Bus.
// Note: This module appears to be an unrolled 32-to-5 encoder where the input 'enable_regs' is a one-hot vector.
module encode_acode_32to5_32to5 (
 output reg [4:0] sel,
 input [31:0] enable_regs
 );
always @ (enable_regs)
 casex (enable_regs)
  32'h8xxxxxxx: sel <= 5'd31;
  32'h4xxxxxxx: sel <= 5'd30;
  32'h2xxxxxxx: sel <= 5'd29;
  32'h1xxxxxxx: sel <= 5'd28;
  32'h08xxxxxx: sel <= 5'd27;
  32'h04xxxxxx: sel <= 5'd26;
  32'h02xxxxxx: sel <= 5'd25;
  32'h01xxxxxx: sel <= 5'd24;
  32'h008xxxxx: sel <= 5'd23;
  32'h004xxxxx: sel <= 5'd22;
  32'h002xxxxx: sel <= 5'd21;
  32'h001xxxxx: sel <= 5'd20;
  32'h0008xxxx: sel <= 5'd19;
  32'h0004xxxx: sel <= 5'd18;
  32'h0002xxxx: sel <= 5'd17;
  32'h0001xxxx: sel <= 5'd16;
  32'h00008xxx: sel <= 5'd15;
  32'h00004xxx: sel <= 5'd14;
  32'h00002xxx: sel <= 5'd13;
  32'h00001xxx: sel <= 5'd12;
  32'h000004xx: sel <= 5'd10;
  32'h000002xx: sel <= 5'd9;
  32'h000001xx: sel <= 5'd8;
  32'h0000008x: sel <= 5'd7;
  32'h0000004x: sel <= 5'd6;
  32'h0000002x: sel <= 5'd5;
  32'h0000001x: sel <= 5'd4;
  32'h00000008: sel <= 5'd3;
  32'h00000004: sel <= 5'd2;
  32'h00000002: sel <= 5'd1;
  32'h00000001: sel <= 5'd0;
  default: sel <= 5'dx;
 endcase
endmodule


// Figure 7: The 32-to-1 Multiplexer used to get the correct output (BusMuxOut) to the Bus.
module mux32to1 (
 output [31:0] mux_out,
 input [31:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11,
 data12, data13, data14, data15, data16, data17, data18, data19, data20, data21, data22, data23, data24,
 data25, data26, data27, data28, data29, data30, data31,
 input [4:0] select,
 input enable
 );
reg [31:0] mux_temp;
assign mux_out = mux_temp; // Output assignment

always @ (select, data31, data30, data29, data28, data27, data26, data25, data24, data23,
 data22, data21, data20, data19, data18, data17, data16, data15, data14, data13, data12, data11,
 data10, data9, data8, data7, data6, data5, data4, data3, data2, data1, data0) begin
 case (select) // Note: casex from original was changed to case for safer synthesis
  5'd31: mux_temp <= data31;
  5'd30: mux_temp <= data30;
  5'd29: mux_temp <= data29;
  5'd28: mux_temp <= data28;
  5'd27: mux_temp <= data27;
  5'd26: mux_temp <= data26;
  5'd25: mux_temp <= data25;
  5'd24: mux_temp <= data24;
  5'd23: mux_temp <= data23;
  5'd22: mux_temp <= data22;
  5'd21: mux_temp <= data21;
  5'd20: mux_temp <= data20;
  5'd19: mux_temp <= data19;
  5'd18: mux_temp <= data18;
  5'd17: mux_temp <= data17;
  5'd16: mux_temp <= data16;
  5'd15: mux_temp <= data15;
  5'd14: mux_temp <= data14;
  5'd13: mux_temp <= data13;
  5'd12: mux_temp <= data12;
  5'd11: mux_temp <= data11;
  5'd10: mux_temp <= data10;
  5'd9: mux_temp <= data9;
  5'd8: mux_temp <= data8;
  5'd7: mux_temp <= data7;
  5'd6: mux_temp <= data6;
  5'd5: mux_temp <= data5;
  5'd4: mux_temp <= data4;
  5'd3: mux_temp <= data3;
  5'd2: mux_temp <= data2;
  5'd1: mux_temp <= data1;
  5'd0: mux_temp <= data0;
  default: mux_temp <= 32'bx;
 endcase
end
endmodule


// Figure 8: The 2-to-1 multiplexer used for selection for the MDR, HI register, LO register input.
module mux2to1 (
 output [31:0] out,
 input select,
 input [31:0] D0, D1
 );
assign out = select ? D1 : D0;
endmodule


// Figure 9: CON_FF logic board
// Note: This module defines 'Q' as a reg but only assigns 'D' to it combinatorially, and 'D' is computed combinatorially.
// It seems to be a combinational logic block rather than a flip-flop.
module CONFF_logic(
 input [31:0] IR,
 input CONin, // This input is unused in the logic flow.
 output reg [31:0] Q,
 input [31:0] BusMuxOut // This input is unused in the logic flow.
 );
//creating wires to add to the OR gate
wire IRone, IRtwo;
assign IRone = IR [20];
assign IRtwo = IR [19];
reg D;
//creating D for the register work
always @ (*) begin
 D <= IRone || IRtwo;
//creating a register with CONin as the enable input
//didn't use the register module bc we didn't use a clock
 if (CONin == 1) begin
 end
 Q <= {31'b0, D}; // Assuming Q is 32-bit, D is 1-bit, so D must be extended to 32 bits.
                  // Original code: Q <= D; (was incorrect as Q is 32-bit and D is 1-bit)
end
endmodule


// Figure 10: 4-to-16 Decoder for RAM decoding
module decode_4_to_16 (
 input [3:0] d_in,
 output wire [15:0] d_out
 );
parameter tmp = 16'b0000_0000_0000_0001;
assign d_out = ( d_in == 4'b0000 ) ? tmp
 : ( d_in == 4'b0001 ) ? tmp << 1
 : ( d_in == 4'b0010 ) ? tmp << 2
 : ( d_in == 4'b0011 ) ? tmp << 3
 : ( d_in == 4'b0100 ) ? tmp << 4
 : ( d_in == 4'b0101 ) ? tmp << 5
 : ( d_in == 4'b0110 ) ? tmp << 6
 : ( d_in == 4'b0111 ) ? tmp << 7
 : ( d_in == 4'b1000 ) ? tmp << 8
 : ( d_in == 4'b1001 ) ? tmp << 9
 : ( d_in == 4'b1010 ) ? tmp << 10
 : ( d_in == 4'b1011 ) ? tmp << 11
 : ( d_in == 4'b1100 ) ? tmp << 12
 : ( d_in == 4'b1101 ) ? tmp << 13
 : ( d_in == 4'b1110 ) ? tmp << 14
 : ( d_in == 4'b1111 ) ? tmp << 15
 : 16'bxxxx_xxxx_xxxx_xxxx;
endmodule


// Figure 11: Multiplexing for 8 bit values
module eightBitMux_2to1 (
 output [7:0] out,
 input select,
 input [7:0] D0, D1
 );
assign out = select ? D1 : D0;
endmodule


// Figure 12: 32-to-9 Encoder
// unrolled 32-to-5 encoder where the output is 9-bit for some reason.
// The selection logic only goes up to 5'd31 (32 states). The output size should probably be 5 bits.
module encode_32to9 (
 output reg [8:0] select_9,
 input [31:0] enable_regs_9
 );
always @ (enable_regs_9)
 casex (enable_regs_9)
  32'h8xxxxxxx: select_9 <= 9'd31;
  32'h4xxxxxxx: select_9 <= 9'd30;
  32'h2xxxxxxx: select_9 <= 9'd29;
  32'h1xxxxxxx: select_9 <= 9'd28;
  32'h08xxxxxx: select_9 <= 9'd27;
  32'h04xxxxxx: select_9 <= 9'd26;
  32'h02xxxxxx: select_9 <= 9'd25;
  32'h01xxxxxx: select_9 <= 9'd24;
  32'h008xxxxx: select_9 <= 9'd23;
  32'h004xxxxx: select_9 <= 9'd22;
  32'h002xxxxx: select_9 <= 9'd21;
  32'h001xxxxx: select_9 <= 9'd20;
  32'h0008xxxx: select_9 <= 9'd19;
  32'h0004xxxx: select_9 <= 9'd18;
  32'h0002xxxx: select_9 <= 9'd17;
  32'h0001xxxx: select_9 <= 9'd16;
  32'h00008xxx: select_9 <= 9'd15;
  32'h00004xxx: select_9 <= 9'd14;
  32'h00002xxx: select_9 <= 9'd13;
  32'h00001xxx: select_9 <= 9'd12;
  32'h000008xx: select_9 <= 9'd11;
  32'h000004xx: select_9 <= 9'd10;
  32'h000002xx: select_9 <= 9'd9;
  32'h000001xx: select_9 <= 9'd8;
  32'h0000008x: select_9 <= 9'd7;
  32'h0000004x: select_9 <= 9'd6;
  32'h0000002x: select_9 <= 9'd5;
  32'h0000001x: select_9 <= 9'd4;
  32'h00000008: select_9 <= 9'd3;
  32'h00000004: select_9 <= 9'd2;
  32'h00000002: select_9 <= 9'd1;
  32'h00000001: select_9 <= 9'd0;
  default: select_9 <= 9'dx;
 endcase
endmodule
