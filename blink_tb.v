`include "blink.v"
`timescale 1ns/1ns // Time unit and time precision

module blink_tb;
  // Variables we will inspect
  reg clk;
  wire led1;
  wire led2;
  wire led3;
  wire led4;

  // Instantiate the blink module (uut = unit under test)
  blink uut(clk, led1, led2, led3, led4);

  // Initial blocks run only once at the start of simulation
  initial begin
    $dumpfile("blink_tb.vcd"); // Write results to file
    $dumpvars(1, blink_tb); // Only variables from the blink_tb module (clk and ledx)

    // Generate the 25MHz clock signal
    forever begin
      clk = 1'b0;
      #40 // Delay for one cycle of 25MHz
      clk = ~clk; // Flip the signal level
    end
  end

  initial begin
    #1000000000 // Delay for 1 second (10^9 because time unit is 1ns)
    $finish; // Stop simulation (yeah, this stops the forever block as well)
  end
endmodule
