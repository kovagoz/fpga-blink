// Frequencies and their corresponding number of clock cycles at 25MHz
`define ONE_HZ  12500000
`define TWO_HZ  6250000
`define FOUR_HZ 3125000
`define FIVE_HZ 2500000

// This module recieves a high frequency clock signal and
// outputs a clock signal at lower frequency.
module clock_down #(
  parameter CYCLES = `ONE_HZ
) (
  input  clock_i, // Go Board's built-in clock signal (25MHz)
  output clock_o  // Slowed down clock signal
);

  reg [23:0] counter = 0; // 24 bits = can count max 16.7 million clock cycles
  reg        toggle  = 1'b0; // Signal level of the output clock (high or low)

  always @(posedge clock_i) begin
    if (counter == CYCLES - 1) begin
      toggle  <= !toggle; // Flip the output signal level if the desired number
                          // of clock cycles has been reached.
      counter <= 0;
    end else
      counter <= counter + 1;
  end

  assign clock_o = toggle; // Modul output follows the value of the clock register.

endmodule

// Like the main function in C
module main (
  input  i_Clk,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4
);

// Set the desired frequencies and assign the clock signals to LEDs.
clock_down #(`ONE_HZ) led1 (i_Clk, o_LED_1);
clock_down #(`TWO_HZ) led2 (i_Clk, o_LED_2);
clock_down #(`FOUR_HZ) led3 (i_Clk, o_LED_3);
clock_down #(`FIVE_HZ) led4 (i_Clk, o_LED_4);

endmodule
