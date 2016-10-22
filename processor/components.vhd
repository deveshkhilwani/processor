library std;
library ieee;
use ieee.std_logic_1164.all;

package components is
component decoder is
   port (x: in std_logic_vector(2 downto 0); y: out std_logic_vector(7 downto 0));
end component;
component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
end component;
component nander is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
end component;
component xorer is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
end component;
component adder is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(16 downto 0));
end component;
component alu is
   port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0);
	carry,zero: out std_logic;
	--control signals
	op_code:in std_logic_vector(1 downto 0));
end component;
component reg_file is
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
	R7_write: in std_logic);
end component;
component shift7 is
   port(x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector(15 downto 0));
end component;
component sign_ext6 is
   port(x: in std_logic_vector(5 downto 0);
	y: out std_logic_vector(15 downto 0));
end component;
component sign_ext9 is
   port(x: in std_logic_vector(8 downto 0);
	y: out std_logic_vector(15 downto 0));
end component;
component priority_encoder is
   port(input: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(2 downto 0);
	modify_en,input_sel,clk: in std_logic;
	flag: out std_logic);
end component;
component bram is
port (clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        we : in std_logic;
        data_i : in std_logic_vector(15 downto 0);
        data_o : out std_logic_vector(15 downto 0)
     );
end component;
end package;

