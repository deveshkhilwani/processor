library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;

entity pe_test is
end entity;
architecture Behave of pe_test is
component priority_encoder is
   port(input: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(2 downto 0);
	modify_en,input_sel,clk: in std_logic;
	flag: out std_logic);
end component;

  signal a: std_logic_vector(7 downto 0);
  signal b: std_logic_vector(2 downto 0);
  signal flag, en, sel: std_logic;
  signal clk: std_logic := '0';

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : std_logic_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;

begin
  clk <= not clk after 10 ns; -- assume 20ns clock.


  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "divider_tracefile.txt";
    FILE OUTFILE: text  open write_mode is "div_OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable a_var: bit_vector ( 7 downto 0);
    variable en_var,sel_var: bit_vector ( 0 downto 0);
    variable flag_var: bit_vector ( 0 downto 0);
    variable b_var: bit_vector (2 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin

    wait until clk = '1';

   
    while not endfile(INFILE) loop 
    	  wait until clk = '0';

          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, a_var);
          read (INPUT_LINE, en_var);
          read (INPUT_LINE, sel_var);
          read (INPUT_LINE, flag_var);
          read (INPUT_LINE, b_var);

          --------------------------------------
          -- from input-vector to DUT inputs
	  a <= to_std_logic_vector(a_var);
	  en <= to_std_logic_vector(en_var);
	  sel <= to_std_logic_vector(sel_var);
          --------------------------------------

          wait until clk = '1';
          --------------------------------------
	  -- check outputs.
	  if (q /= to_std_logic_vector(q_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             write(OUTPUT_LINE,to_string(" in q "));
             write(OUTPUT_LINE, to_bitvector(q));
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;

	  if (r /= to_std_logic_vector(r_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             write(OUTPUT_LINE,to_string(" in r "));
             write(OUTPUT_LINE, to_bitvector(r));
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          --------------------------------------
	  wait until clk = '1';
  	  output_ack <= '1';
	  wait until clk = '1';
          
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: divider
     port map(dvnd,dvsr,q,r,done,input_ack,clk,reset,start,output_ack);

end Behave;

