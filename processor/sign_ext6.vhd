library ieee;
use ieee.std_logic_1164.all;
entity sign_ext6 is
   port(x: in std_logic_vector(5 downto 0);
	y: out std_logic_vector(15 downto 0));
end entity;

architecture taes of sign_ext6 is
begin
  process(x)
  begin
  for i in 6 to 15 loop
	y(i)<=x(5);
  end loop;
  y(5 downto 0)<=x;
  end process;
end taes;
