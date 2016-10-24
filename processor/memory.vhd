library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram is
port (clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        we : in std_logic;
        data_i : in std_logic_vector(15 downto 0);
        data_o : out std_logic_vector(15 downto 0)
     );
end entity;

architecture Behavioral of bram is

--Declaration of type and signal of a 256 element RAM
--with each element being 8 bit wide.
type ram_t is array (0 to 65535) of std_logic_vector(15 downto 0);
signal ram : ram_t := (
0 => "1000000000001000",
1 => "0000000000001000",
2 => "0000000000000001",
3 => "0000000000000001",
4 => "0000000000000011",
5 => "0000000000000100",
6 => "0000000000000101",
7 => "0000000000000110",
8 => "0110001001111100",
--9 => "1100100101001010",
9 => "1001001100000000",
others=>"0000000111010010"
);--(others => '0'));

begin

--process for read and write operation.
process(clk)
begin
    data_o <= ram(to_integer(unsigned(address)));
    if(rising_edge(clk)) then
        if(we='1') then
            ram(to_integer(unsigned(address))) <= data_i;
        end if;
    end if; 
end process;

end Behavioral;

