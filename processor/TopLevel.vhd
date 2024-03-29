library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity TopLevel is
   port(clk,reset: in std_logic;
	rout_0,rout_1,rout_2,rout_3,rout_4,rout_5,rout_6,rout_7: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of TopLevel is 

	signal opcode1:std_logic_vector(3 downto 0);
	signal opcode2:std_logic_vector(1 downto 0);
	signal alu_a_sel:std_logic_vector(1 downto 0);
	signal alu_b_sel:std_logic_vector(2 downto 0);
	signal alu_op: std_logic;
	signal c_en,z_en,t1_en,t2_en,t3_en,tp_en,t1_sel,t2_sel,tp_sel:std_logic;
	signal A2_sel: std_logic;
	signal address_sel,A3_sel:std_logic_vector(1 downto 0);
	signal data_sel,D3_sel:std_logic_vector(2 downto 0);
	signal RF_write,R7_write,ir_en,pe_sel,pe_en,mem_write_enable,mem_in_sel,pe_flag,carry,zero: std_logic;
begin
Processor:FSM
port map (
	clk=>clk,
	reset=>reset,
	opcode1=>opcode1, 
	opcode2=>opcode2,
	--alu
	alu_a_sel=>alu_a_sel,alu_b_sel=>alu_b_sel(1 downto 0),
	alu_b_sel_3=>alu_b_sel(2),
	alu_op=>alu_op,
	--registers
	c_en=>c_en,z_en=>z_en,t1_en=>t1_en,t2_en=>t2_en,t3_en=>t3_en,tp_en=>tp_en,t1_sel=>t1_sel,t2_sel=>t2_sel,tp_sel=>tp_sel,
	--RF
	A2_sel=>A2_sel,
	A3_sel=>A3_sel,
	data_sel=>data_sel , 
	D3_sel=>D3_sel,
	RF_write=>RF_write,
	R7_write=>R7_write,
	--IR
	ir_en=>ir_en,
	pe_sel=>pe_sel,
	pe_en=>pe_en, 
	--memory
	mem_write_enable=>mem_write_enable,
	address_sel=>address_sel,
	mem_in_sel=>mem_in_sel,

	--input 
	pe_flag=>pe_flag,carry=>carry,zero=>zero); -- pe_flag is 0 if the string is 0 


DataPath_Processor:datapath
port map(
	clk=>clk,reset=>reset,
	--alu
	op_code_sel=>alu_op,
	alu_a_sel=>alu_a_sel,alu_b_sel=>alu_b_sel,
	--registers
	c_en=>c_en,z_en=>z_en,t1_en=>t1_en,t2_en=>t2_en,t3_en=>t3_en,tp_en=>tp_en,t1_sel=>t1_sel,t2_sel=>t2_sel,tp_sel=>tp_sel,
	A2_sel=>A2_sel,
	A3_sel=>A3_sel,
	D3_sel=>D3_sel,data_sel=>data_sel,
	RF_write=>RF_write,
	R7_write=>R7_write,
	--IR
	ir_en=>ir_en,
	--memory
	mem_write_en=>mem_write_enable,
	adrs_sel=>address_sel,
	mem_in_sel=>mem_in_sel,
	--priority_encoder
	pe_en=>pe_en,pe_sel=>pe_sel,

	--output
	instruction_part1=>opcode1,
	instruction_part2=>opcode2,
	pe_flag=>pe_flag,carry=>carry,zero=>zero,
	rout_0=>rout_0,rout_1=>rout_1,rout_2=>rout_2,rout_3=>rout_3,rout_4=>rout_4,rout_5=>rout_5,rout_6=>rout_6,rout_7=>rout_7);

end Behave;
