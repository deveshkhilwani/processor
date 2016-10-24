library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.ShiftAddMulComponents.all;

entity Testbench is
end entity;
architecture Behave of testbench is 
  
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';

 begin
  clk <= not clk after 5 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
     reset <= '0';
     wait;
  end process;

  dut: toplevel  
     port map(clk => clk,reset => reset);
end Behave;

