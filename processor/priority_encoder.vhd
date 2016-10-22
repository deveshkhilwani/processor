library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity priority_encoder is
   port(input: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(2 downto 0);
	modify_en,input_sel,clk: in std_logic;
	flag: out std_logic);
end entity;

architecture arrange of priority_encoder is
  signal x:std_logic_vector(2 downto 0);
  signal y,a,input_modifier,new_ip:std_logic_vector(7 downto 0);

begin
	x(2) <= a(4) or a(5) or a(6) or a(7);
	x(1) <= a(2) or a(3) or a(6) or a(7);
	x(0) <= a(1) or a(3) or a(5) or a(7);
	output(2) <= x(2);
	output(1) <= x(1);
	output(0) <= x(0);

	flag <= a(0) or x(0) or x(1) or x(2);

	y(7) <= y(6) or y(5) or y(4) or y(3) or y(2) or y(1) or y(0);
	y(6) <= y(5) or y(4) or y(3) or y(2) or y(1) or y(0);
	y(5) <= y(4) or y(3) or y(2) or y(1) or y(0);
	y(4) <= y(3) or y(2) or y(1) or y(0);
	y(3) <= y(2) or y(1) or y(0);
	y(2) <= y(1) or y(0);
	y(1) <= y(0);
	y(0) <= '0';
	input_modifier <= a and y;
--y(i) is '0' if y(0) to y(i-1) are all '0'
--Thus, input_modifier(i) is unchanged if there is at least one less significant position with a '1'
	new_ip<=input_modifier when input_sel='1' else
		input;
	store: DataRegister generic map(data_width=>1) port map(Din=>new_ip , Dout=>a , Enable=>modify_en , clk=>clk);

end arrange;





