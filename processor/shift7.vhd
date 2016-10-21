library ieee;
use ieee.std_logic_1164.all;
entity shift7 is
   port(x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector(15 downto 0));
end entity;

architecture tittaes of shift7 is
begin
  process(x)
  begin
  for i in 0 to 6 loop
	y(i)<='0';
  end loop;
  y(15 downto 7)<=x;
  end process;
end tittaes;
