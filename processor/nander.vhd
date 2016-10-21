library ieee;
use ieee.std_logic_1164.all;
entity nander is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
end entity;

architecture waddup of nander is
begin
	z<=x nand y;
end waddup;
