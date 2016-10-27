library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity reg_file is
   port(A1: in std_logic_vector(2 downto 0);
	A2: in std_logic_vector(2 downto 0);
	A3: in std_logic_vector(2 downto 0);
	D3: in std_logic_vector(15 downto 0);
	D1: out std_logic_vector(15 downto 0);
	D2: out std_logic_vector(15 downto 0);
	clk,reset: in std_logic;
	--R7 specific functionalities 
	alu_out: in std_logic_vector(15 downto 0);
	t2_out: in std_logic_vector(15 downto 0);
	t3_out: in std_logic_vector(15 downto 0);
	R7_data: out std_logic_vector(15 downto 0);
	z:in std_logic;
	--control signals
	data_sel: in std_logic_vector(2 downto 0);
	RF_write: in std_logic;
	R7_write: in std_logic;
	rout_0,rout_1,rout_2,rout_3,rout_4,rout_5,rout_6,rout_7: out std_logic_vector(15 downto 0));
end entity;

architecture mudi of reg_file is
	signal r_en,r_sel: std_logic_vector(7 downto 0);
	type a_vector is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal r_out: a_vector;
	signal D_in,R7_in,zero_t3_out: std_logic_vector(15 downto 0);
	constant c0: std_logic_vector(15 downto 0):=(others=>'0');
begin
	R0: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(0) , Enable=>r_en(0) , clk=>clk);
	R1: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(1) , Enable=>r_en(1) , clk=>clk);
	R2: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(2) , Enable=>r_en(2) , clk=>clk);
	R3: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(3) , Enable=>r_en(3) , clk=>clk);
	R4: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(4) , Enable=>r_en(4) , clk=>clk);
	R5: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(5) , Enable=>r_en(5) , clk=>clk);
	R6: DataRegister generic map(data_width=>16) port map(Din=>D_in , Dout=>r_out(6) , Enable=>r_en(6) , clk=>clk);
	R7: DataRegister generic map(data_width=>16) port map(Din=>R7_in , Dout=>r_out(7) , Enable=>r_en(7) , clk=>clk);

--enable signals
	dec: decoder port map(x=>A3, y=>r_sel);
	r_en(0)<=(r_sel(0) and RF_write) or reset;
	r_en(1)<=(r_sel(1) and RF_write) or reset;
	r_en(2)<=(r_sel(2) and RF_write) or reset;
	r_en(3)<=(r_sel(3) and RF_write) or reset;
	r_en(4)<=(r_sel(4) and RF_write) or reset;
	r_en(5)<=(r_sel(5) and RF_write) or reset;
	r_en(6)<=(r_sel(6) and RF_write) or reset;
	r_en(7)<=(r_sel(7) and RF_write) or R7_write or reset;

--ouput data
	D1<=r_out(0) when A1="000" else
	    r_out(1) when A1="001" else
	    r_out(2) when A1="010" else
	    r_out(3) when A1="011" else
	    r_out(4) when A1="100" else
	    r_out(5) when A1="101" else
	    r_out(6) when A1="110" else
	    r_out(7) when A1="111";

	D2<=r_out(0) when A2="000" else
	    r_out(1) when A2="001" else
	    r_out(2) when A2="010" else
	    r_out(3) when A2="011" else
	    r_out(4) when A2="100" else
	    r_out(5) when A2="101" else
	    r_out(6) when A2="110" else
	    r_out(7) when A2="111";

	R7_data <= r_out(7);

--input data
	D_in<=c0 when reset='1' else D3;

	zero_t3_out<=t3_out when z='1' else
			r_out(7);
	R7_in<= c0 when reset='1' else
		alu_out when data_sel="000" else
	        D3 when data_sel="001" else
	        t2_out when data_sel="010" else
	        t3_out when data_sel="011" else
		zero_t3_out;
	rout_0<=r_out(0);
	rout_1<=r_out(1);
	rout_2<=r_out(2);
	rout_3<=r_out(3);
	rout_4<=r_out(4);
	rout_5<=r_out(5);
	rout_6<=r_out(6);
	rout_7<=r_out(7);
end mudi;

