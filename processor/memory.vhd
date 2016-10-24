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
0 => "0001111000111110",
1=>"0000000111111000",
others=>"0000000111010010"
);--(others => '0'));

begin

--process for read and write operation.
process(clk)
begin
    if(rising_edge(clk)) then
        if(we='1') then
            ram(to_integer(unsigned(address))) <= data_i;
        end if;
        data_o <= ram(to_integer(unsigned(address)));
    end if; 
end process;

end Behavioral;

