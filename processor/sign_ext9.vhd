library ieee;
use ieee.std_logic_1164.all;
entity sign_ext9 is
   port(x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector(15 downto 0));
end entity;

architecture taes of sign_ext9 is
begin
  process(x)
  begin
  for i in 9 to 15 loop
	y(i)<=x(8);
  end loop;
  y(8 downto 0)<=x;
  end process;
end taes;
