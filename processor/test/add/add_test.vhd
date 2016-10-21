library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

entity add_test is
end entity;
architecture Behave of add_test is
  component adder is
   port(x,y: in std_logic_vector(15 downto 0);
        --o: in std_logic_vector(1 downto 0);
        z: out std_logic_vector(16 downto 0));
  end component;

  signal x,y: std_logic_vector(15 downto 0) := (others=>'0');
  signal s: std_logic_vector(16 downto 0) := (others=>'0');

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;
  
  function to_bite(x: std_logic) return bit is
	variable b: bit;
  begin
	if (x='1') then
		b:='1';
	else
		b:='0';
	end if;
	return(b);
  end to_bite;

begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "add_tracefile.txt";
    FILE OUTFILE: text  open write_mode is "add_outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    --variable operation: bit_vector ( 1 downto 0);
    variable input_vector_1: bit_vector ( 15 downto 0);
    variable input_vector_2: bit_vector ( 15 downto 0);
    variable output_vector: bit_vector ( 16 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
	  --read (INPUT_LINE, operation);
	  read (INPUT_LINE, input_vector_1);
          read (INPUT_LINE, input_vector_2);
          read (INPUT_LINE, output_vector);

          --------------------------------------
          -- from input-vector to DUT inputs
	  --o <= to_stdlogicvector(operation);
	  x <= to_stdlogicvector(input_vector_1);
	  y <= to_stdlogicvector(input_vector_2);
	  s <= to_stdlogicvector(output_vector);
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
	  if (s /= to_stdlogicvector(output_vector)) then
             write(OUTPUT_LINE,to_string("ERROR: in line "));
             write(OUTPUT_LINE, LINE_COUNT);
             write(OUTPUT_LINE,to_string(" "));
	     write(OUTPUT_LINE, to_bite(s(0)));
	     --write(OUTPUT_LINE, output_vector);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: adder 
     port map(x => x,
              y => y,
              z => s);
             
end Behave;
