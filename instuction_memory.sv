/**
 * Instruction memory - hardcoded instructions.
 */
module instrmem (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output [31:0] instr);
	 
	 //instrmem_test_7segment_draw_8 instrmem_program(addr, instr);
	 instrmem_test_7segment_draw_1 instrmem_program(addr, instr);
	 //instrmem_test_beq_input instrmem_program(addr, instr);
	 //instrmem_test_sw_lw instrmem_program(addr, instr);
	 //instrmem_test_input_4bits instrmem_program(addr, instr);	 
	 //instrmem_test_io_calc instrmem_program(addr, instr);
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Plain instruction memory with not program loaded (not used for tests here).
 */
module instrmem_plain (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output [31:0] instr);
	 
	 // instruction memory data with loaded program instructions
    reg [31:0] ROM [63:0];
	 // addr is divided by 4 (just move away 2 lower bits) 
	 // as instr data chunks are word aligned (each word is 32bits)
	 assign instr = ROM[addr[31:2]]; // word aligned
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Test 7-segment display output (v at 0xf000) - run the following program:
 *
 *     // put 11111111 value (8 with dot 'on') to s0 (switch on all display segments)
 *     addi $s0, $0, b0000000011111111
 *     // send value to video memory (7-segment display) device at 0xf000
 *     sw $s0, 0x0000f000 ($0)
 * 
 */
module instrmem_test_7segment_draw_8 (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
        32'h00000000: instr <= 32'b001000_00000_10000_0000000011100011; // addi $s0, $0, b0000000011111111
		  32'h00000004: instr <= 32'b101011_00000_10000_1111000000000000; // sw $s0, 0xf000 ($0)
		  
		  default: instr <= 0;

	     endcase
endmodule

/**
 * Instruction memory - contains program instructions.
 * Test 7-segment display output (v at 0xf000) - run the following program:
 *
 *     // put 11111111 (5 with dot off) value to s0 (switch on all display segments)
 *     addi $s0, $0, b0000000011100110
 *     // send value to video memory (7-segment display) device at 0xf000
 *     sw $s0, 0x0000f000 ($0)
 * 
 */
module instrmem_test_7segment_draw_1 (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
        32'h00000004: instr <= 32'b001000_00000_10001_0000000000111111; // addi $s1, $0, b01111111
		  32'h00000008: instr <= 32'b101011_00000_10001_1111000000000000;
		  
		  default: instr <= 0;

	     endcase
endmodule

/**
 * Instruction memory - contains program instructions.
 * Test 1-bit button switch input (bsf at 0xf008) and beq conditional branching
 * - run the following program:
 *
 *   loop:
 *     // load value from 1-bit input (button switch) device at 0xf008
 *     lw $s0, 0xf008 ($0)
 *     // go to 'display_0' if input bit is 0
 *     beq $s0, $0, display_0 // 0x0014
 *   display_1:
 *     // display "1" on 7-segment display (if input is 1)
 *     addi $s1, $0, b00011100
 *     sw $s1, 0xf000 ($0)
 *     // jump to beginning
 *     j loop // 0x0000
 *   display_0:
 *     // display "0" on 7-segment display (if input is 0)
 *     addi $s1, $0, b01111111
 *     sw $s1, 0xf000 ($0)
 *     // jump to beginning
 *     j loop // 0x0000
 */
module instrmem_test_beq_input (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
// loop:
//0111111
        32'h00000000: instr <= 32'b100011_00000_10000_1111000000001000; // lw $s0, 0xf008 ($0)
		  32'h00000004: instr <= 32'b000100_10000_00000_0000000000010100; // beq $s0, $0, display_0 // 0x0014
// display_1:
		  32'h00000008: instr <= 32'b001000_00000_10001_0000000000000110; // addi $s1, $0, b00011100
		  32'h0000000c: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  32'h00000010: instr <= 32'b000010_00000000000000000000000000;   // j loop // 0x0000
// display_0:
		  32'h00000014: instr <= 32'b001000_00000_10001_0000000000111111; // addi $s1, $0, b01111111
		  32'h00000018: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  32'h0000001c: instr <= 32'b000010_00000000000000000000000000;   // j loop // 0x0000
		  default: instr <= 0;

	     endcase
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Test sw (store word) and lw (load word) instructions - 
 * store bitwise representation of "5" digit for 7segment display
 * to memory, then load it from memory to register, 
 * then display loaded value on 7segment display:
 *
 *   addi $s0, $0, b0000000011100110		  
 *   sw $s0, 0 ($0)
 *   lw $s1, 0 ($0) 
 *   sw $s1, 0xf000 ($0)
 */
module instrmem_test_sw_lw (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
		  32'h00000000: instr <= 32'b001000_00000_10000_0000000011100110; // addi $s0, $0, b0000000011100110		  
		  32'h00000004: instr <= 32'b101011_00000_10000_0000000000000000; // sw $s0, 0 ($0)
		  32'h00000008: instr <= 32'b100011_00000_10001_0000000000000000; // lw $s1, 0 ($0) 
		  32'h0000000c: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  
		  default: instr <= 0;

	     endcase
endmodule
