library ieee;
use ieee.std_logic_1164.all;
entity decoder is
   port (x: in std_logic_vector(2 downto 0); y: out std_logic_vector(7 downto 0));
end entity;

architecture hood of decoder is
begin
  y(0) <= (not x(0)) and (not x(1)) and (not x(2));
  y(1) <= (x(0)) and (not x(1)) and (not x(2));
  y(2) <= (not x(0)) and (x(1)) and (not x(2));
  y(3) <= (x(0)) and (x(1)) and (not x(2));
  y(4) <= (not x(0)) and (not x(1)) and (x(2));
  y(5) <= (x(0)) and (not x(1)) and (x(2));
  y(6) <= (not x(0)) and (x(1)) and (x(2));
  y(7) <= (x(0)) and (x(1)) and (x(2));
end hood;
