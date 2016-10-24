library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity alu is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0);
	carry,zero: out std_logic;
	--control signals
	op_code:in std_logic_vector(1 downto 0));
end entity;

architecture paratha of alu is
	signal nand_out,xor_out: std_logic_vector(15 downto 0);
	signal add_out: std_logic_vector(16 downto 0);
	signal alu_out: std_logic_vector(15 downto 0);
	constant c0: std_logic_vector(15 downto 0):=(others=>'0');
begin
	op1: adder port map (x=>x, y=>y, z=>add_out);
	op2: nander port map (x=>x, y=>y, z=>nand_out);
	op3: xorer port map (x=>x, y=>y, z=>xor_out);

	alu_out<=add_out(15 downto 0) when op_code="00" else
	   nand_out when op_code="01" else
	   xor_out;
	
	z<=alu_out;
--output to flags
	carry<=x(15) xor y(15) xor add_out(16);
	zero<='1' when alu_out=c0 else '0';
end paratha;
