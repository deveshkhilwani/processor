library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.components.all;


entity RF_Testbench is
end entity;
architecture Behave of RF_Testbench is
  signal A1,A2,A3: std_logic_vector(2 downto 0);
  signal D1,D2,D3,alu_out,T2,T3,R7_data: std_logic_vector(15 downto 0); 
 signal data_sel: std_logic_vector(1 downto 0);
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
signal R7_write, RF_write: std_logic;

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
  
   function to_std_logic(x: bit) return std_logic is
      variable ret_val: std_logic;
  begin  
      if (x = '1') then
        ret_val := '1';
      else 
        ret_val := '0';
      end if;
      return(ret_val);
  end to_std_logic;

begin
  clk <= not clk after 10 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
     reset <= '0';
     wait;
  end process;

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE_RF.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable A1_var, A2_var, A3_var: bit_vector ( 2 downto 0);
    variable D1_var,D2_var,D3_var,alu_out_var,T2_var,T3_var,R7_data_var: bit_vector ( 15 downto 0);
    variable data_sel_var: bit_vector (1 downto 0);
    variable RF_write_var, R7_write_var: bit;
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
          read (INPUT_LINE, A1_var);
	  read (INPUT_LINE, A2_var);
          read (INPUT_LINE, A3_var);
	  read (INPUT_LINE, D1_var);
          read (INPUT_LINE, D2_var);
          read (INPUT_LINE, D3_var);
          read (INPUT_LINE, alu_out_var);
          read (INPUT_LINE, T2_var);
          read (INPUT_LINE, T3_var);
          read (INPUT_LINE, R7_data_var);
          read (INPUT_LINE, data_sel_var);
          read (INPUT_LINE, RF_write_var);
          read (INPUT_LINE, R7_write_var);


          --------------------------------------
          -- from input-vector to DUT inputs
	  A1 <= to_std_logic_vector(A1_var);
	  A2 <= to_std_logic_vector(A2_var);
	  A3 <= to_std_logic_vector(A3_var);
	  D3 <= to_std_logic_vector(D3_var);
	  alu_out <= to_std_logic_vector(alu_out_var);
	  T2 <= to_std_logic_vector(T2_var);
	  T3 <= to_std_logic_vector(T3_var);
	  data_sel <= to_std_logic_vector(data_sel_var);
	  RF_write <= to_std_logic(RF_write_var);
	  R7_write <= to_std_logic(R7_write_var);

          --------------------------------------

          -- spin waiting for done
      --    while (true) loop
             wait until clk = '1';
           --  start <= '0';
       --      if(done = '1') then
        --        exit;
        --     end if;
        --  end loop;

          --------------------------------------
	  -- check outputs.
	  	  if (D1 /= to_std_logic_vector(D1_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in D1, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          	  if (D2 /= to_std_logic_vector(D2_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in D2, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          	  if (R7_data /= to_std_logic_vector(R7_data_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in R7_data, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          	 
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: reg_file 
     port map(A1 => A1,
              A2 => A2,
              A3 => A3,
              clk => clk,
              reset => reset,
	      D1=>D1, D2=>D2, D3=>D3, alu_out=>alu_out, t3_out=>T3, t2_out=>T2, R7_Data=>R7_Data, data_sel=>data_sel, RF_write=>RF_write, R7_write=>R7_write);

end Behave;

