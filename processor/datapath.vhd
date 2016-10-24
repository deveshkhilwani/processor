library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity datapath is
   port(clk,reset: in std_logic;
	--alu
	op_code_sel:in std_logic;
	alu_a_sel,alu_b_sel:in std_logic_vector(1 downto 0);
	--registers
	c_en,z_en,t1_en,t2_en,t3_en,tp_en,t1_sel,t2_sel,tp_sel:in std_logic;
	--RF
	A2_sel:in std_logic;
	A3_sel:in std_logic_vector(1 downto 0);
	D3_sel,data_sel: in std_logic_vector(2 downto 0);
	RF_write: in std_logic;
	R7_write: in std_logic;
	--IR
	ir_en: in std_logic;
	--memory
	mem_write_en: in std_logic;
	adrs_sel: in std_logic_vector(1 downto 0);
	mem_in_sel:in std_logic;
	--priority_encoder
	pe_en,pe_sel:in std_logic;

	--output
	instruction_part1:out std_logic_vector(3 downto 0);
	instruction_part2:out std_logic_vector(1 downto 0);
	pe_flag,carry,zero: out std_logic);
end entity;

architecture fullon of datapath is
	signal alu_a,alu_b,alu_out,t1_in,t2_in,t3_in,tp_in,t1_out,t2_out,t3_out,tp_out,R7_out,D1,D2,D3_in,adrs,mem_in, 	 
		mem_out,ls_out,se9_out,se6_out,ir_in,ir_out,ir_modified:std_logic_vector(15 downto 0);
	signal ir_new: std_logic_vector(7 downto 0);
	signal pe_out,A2_in,A3_in: std_logic_vector(2 downto 0);
	signal flag: std_logic;
	signal op_code: std_logic_vector(1 downto 0);
	signal c_in,c_out,z_in,z_out: std_logic_vector(0 downto 0);
	constant c1: std_logic_vector(15 downto 0):=(0=>'1',others=>'0');
begin
	instruction_part1<=ir_out(15 downto 12);
	instruction_part2<=ir_out(1 downto 0);
--registers
	t1: DataRegister generic map(data_width=>16) port map(Din=>t1_in , Dout=>t1_out , Enable=>t1_en , clk=>clk);
	t2: DataRegister generic map(data_width=>16) port map(Din=>t2_in , Dout=>t2_out , Enable=>t2_en , clk=>clk);
	t3: DataRegister generic map(data_width=>16) port map(Din=>t3_in , Dout=>t3_out , Enable=>t3_en , clk=>clk);
	tp: DataRegister generic map(data_width=>16) port map(Din=>tp_in , Dout=>tp_out , Enable=>tp_en , clk=>clk);
	ir: DataRegister generic map(data_width=>16) port map(Din=>ir_in , Dout=>ir_out , Enable=>ir_en , clk=>clk);
	c: DataRegister generic map(data_width=>1) port map(Din=>c_in , Dout=>c_out , Enable=>c_en , clk=>clk);
	carry<=c_out(0);
	z: DataRegister generic map(data_width=>1) port map(Din=>z_in , Dout=>z_out , Enable=>z_en , clk=>clk);
	zero<=z_out(0);

--alu related
	alu_a<= t1_out when alu_a_sel="00" else
		R7_out when alu_a_sel="01" else
		t2_out when alu_a_sel="10" else
		tp_out when alu_a_sel="11";

	alu_b<= se9_out when alu_b_sel="00" else
		se6_out when alu_b_sel="01" else
		t2_out when alu_b_sel="10" else
		c1 when alu_b_sel="11";
	op_code<= "00" when op_code_sel='0' else
		  ir_out(14 downto 13);			
	--instruction opcode for add is 0000 => op_code is"00" i.e. addition
	--instruction opcode for nand is 0010 => op_code is"01" i.e. nand
	--instruction opcode for beq is 0100 => op_code is"10" i.e. xor


	alu_instance: alu port map(alu_a,alu_b,alu_out,c_in(0),z_in(0),op_code);

--registers
	t1_in<= D1 when t1_sel='0' else
		alu_out;

	t2_in<= D2 when t2_sel='0' else
		mem_out;

	tp_in<= R7_out when tp_sel='0' else
		mem_out;

	t3_in<=alu_out;

	ir_modified<= ir_out(15 downto 8) & ir_new;
	ir_in<= mem_out;

--shift7
	ls7: shift7 port map(x=>ir_out(8 downto 0),y=>ls_out);
--se9
	se9: sign_ext9 port map(x=>ir_out(8 downto 0),y=>se9_out);
--se6
	se6: sign_ext6 port map(x=>ir_out(5 downto 0),y=>se6_out);
--reg_file
	A2_in<= ir_out(8 downto 6) when A2_sel='0' else
		pe_out;
	A3_in<= ir_out(11 downto 9) when A3_sel="00" else
		ir_out(8 downto 6) when A3_sel="01" else
		ir_out(5 downto 3) when A3_sel="10" else
		pe_out;
	D3_in<= ls_out when D3_sel="000" else
		t2_out when D3_sel="001" else
		t3_out when D3_sel="010" else
		tp_out when D3_sel="011" else
		R7_out;
	
	RF: reg_file port map(ir_out(11 downto 9),A2_in,A3_in,D3_in,D1,D2,
				 clk,reset,alu_out,t2_out,t3_out,R7_out,z_in(0),data_sel,RF_write,R7_write);

--	R7_in<= c0 when reset='1' else
--		alu_out when data_sel="000" else
--	        D3 when data_sel="001" else
--	        t2_out when data_sel="010" else
--	        t3_out when data_sel="011" else
--		zero_t3_out;

--pe
	pe:priority_encoder port map(ir_out(7 downto 0),pe_out,pe_en,pe_sel,clk,pe_flag);
--mem
	adrs <= t1_out when adrs_sel="01" else
		t3_out when adrs_sel="10" else
		R7_out;
	mem_in<=t1_out when mem_in_sel='0' else
		t2_out;
	memory:bram port map(clk,adrs,mem_write_en,mem_in,mem_out);
end fullon;

