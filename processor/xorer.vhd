library ieee;
use ieee.std_logic_1164.all;
entity xorer is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
end entity;

architecture waddup of xorer is
begin
	z<=x xor y;
end waddup;
