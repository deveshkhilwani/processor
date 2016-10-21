library ieee;
use ieee.std_logic_1164.all;
entity adder is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(16 downto 0));
end entity;
architecture Serial of adder is
begin
   process(x,y)
     variable carry: std_logic;
   begin
     carry := '0';
     for I in 0 to 15 loop
        z(I) <= (x(I) xor y(I)) xor carry;
        carry := (carry and (x(I) or y(I))) or (x(I) and y(I));
     end loop;
     z(16) <= carry;
   end process;
end Serial;

