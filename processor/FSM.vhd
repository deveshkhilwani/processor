library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity FSM is
	port (
	clk,reset: in std_logic;
	opcode1:in std_logic_vector(3 downto 0);
	opcode2:in std_logic_vector(1 downto 0);
	--alu
	alu_a_sel,alu_b_sel:out std_logic_vector(1 downto 0);
	alu_op: out std_logic;
	--registers
	c_en,z_en,t1_en,t2_en,t3_en,tp_en,t1_sel,t2_sel,tp_sel:out std_logic;
	--RF
	A2_sel:out std_logic;
	A3_sel:out std_logic_vector(1 downto 0);
	data_sel: out std_logic_vector(2 downto 0); 
	D3_sel: out std_logic_vector(2 downto 0);
	RF_write: out std_logic;
	R7_write: out std_logic;
	--IR
	ir_en: out std_logic;
	pe_sel: out std_logic;
	pe_en: out std_logic; 
	--memory
	mem_write_enable: out std_logic;
	address_sel: out std_logic_vector(1 downto 0);
	mem_in_sel:out std_logic;

	--input 
	pe_flag,carry,zero: in std_logic); -- pe_flag is 0 if the string is 0 
	
end entity;

architecture hardon of FSM is
   type FSM_State is (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17);
   signal S: FSM_State;
begin
process(S,opcode1,opcode2,pe_flag,carry,zero,clk, reset)
      variable next_state: FSM_State;
      variable control: std_logic_vector(31 downto 0);
      
   begin
	 -- defaults
       control := (others => '0');
       next_state := S;  

    case S is 
          when S1=>
                  next_state := S2;
                  control := "01110000001000001000000001000000";  
              
          when S2 =>
                  control := "01010001110000000000000000010000";
                  if (opcode1="0000" or opcode1="0010") then 
			if (opcode2="00") then 
                  		next_state := S3;
			elsif (opcode2="10") then
				if (carry='1') then 
					next_state := S3; 
				else    next_state := S1; 
  				end if; 
                        elsif (opcode2="01") then
				if (zero='1') then 
					next_state := S3; 
				else    next_state := S1;
				end if; 
			end if; 
                  elsif (opcode1="0001") then                    -- occurs in state ADI 
			next_state:= S5; 
            	  elsif (opcode1="0011") then                    -- occurs in state LHI 
 			next_state := S14;  
	     	  elsif (opcode1="0100" or opcode1="0101") then  --occurs in LW/SW
			next_state := S7; 
		  elsif (opcode1="0110") then                    --occurs in LM 
			if (pe_flag='0') then 
				next_state := S1; 
			else next_state := S12;   
			end if;   
		  elsif (opcode1="0111") then                    --occurs in SM
			if (pe_flag='0') then 
				next_state := S1; 
			else next_state := S17;
			end if; 
                  elsif (opcode1="1100") then                   --occurs in BEQ			
		        next_state := S10; 
		  elsif (opcode1="1000") then                   --occurs in JAL 		
		        next_state := S12; 
	          elsif (opcode1="1001") then                   --occurs in BEQ			
		        next_state := S11; 
                  end if; 
 
          when S3=>
                 
                  control := "00101110010000000000000000000000"; 
		  if (opcode1="0000" or opcode1="0010") then    --ADD or NAND instructions 
			next_state:= S4;                               
            	   
		  elsif (opcode1="0111") then                   --occurs in SM
			next_state:= S16;              
                  end if; 
	  
	  when S4=> 
		  next_state:= S1;
		  control := "00000000000000010100000100000000"; 
          when S5=> 
		  control :="00010000011001000000000000000100"; 
		  if ( opcode1="0001") then                      -- ADI 
			next_state:= S6; 
                  elsif (opcode1="0100") then                    -- LW
			next_state:=S8; 
                  end if; 
	  when S6=> 
		  control:= "00010110000000010010000100000000"; 
		  next_state:= S1; 
          when S7=>
		  control:= "10010000010000000000000000000000"; 
		  if ( opcode1="0100") then                      -- LW 
		 	next_state:= S5; 
		  elsif (opcode1="0101") then                    -- SW 
			next_state:=S9;                         
		  end if; 
          when S8=> 
		  control:= "00000000000000010000000110000000";
		  next_state:= S1;  
	  when S9=> 
		  control:= "00000000000000000000000000001100";
		  next_state:= S1; 
	  when S10=> 
		  control:= "00000000000000000000000000001100"; 
		  next_state:= S1; 
          when S11=> 
		  control:= "00000000000000011000100100000000"; 
		  next_state:= S1;
	  when S12=> 
		  control:= "11000000110010000000000000000010";
                  if (opcode1="0110") then                      --LM
		  next_state:= S15; 
                  elsif ( opcode1="1000") then                  --JAL 
		  next_state:= S13; 
                  end if; 
          when S13=> 
		  control:= "00000000000000011000111110000000"; 
		  next_state:=S1; 
	  when S14=> 
		  control:= "00000000000000010000000000000000"; 
		  next_state:=S1; 
	  when S15=> 
                  control:= "00110001000100010110000010110000"; 
		  if( pe_flag='1') then 
		  	next_state:= S12; 
		  else 
			next_state:=S1; 
                  end if; 
          when S16=> 
		  control:= "00110001000100000000000000111011"; 
                  if( pe_flag='1') then 
		  	next_state:= S17; 
		  else 
			next_state:=S1; 
                  end if; 
	  when S17=> 
		  control:= "00000000100000100000000000000000"; 
                  next_state:=S16; 
              
    end case; 
alu_a_sel <= control(31 downto 30); alu_b_sel<= control(29 downto 28);alu_op <= control(27);c_en <= control(26);z_en <= control(25);t1_en<= control(24);
t2_en <= control(23);t3_en <= control(22);Tp_en <= control(21);t1_sel <= control(20);t2_sel <= control(19);Tp_sel <= control(18);
A2_sel <= control(17);RF_write <= control(16);R7_write <= control(15);A3_sel <= control(14 downto 13);data_sel <= control(12 downto 10);D3_sel <= control(9 downto 7);
IR_en<=control(6);PE_sel<= control(5);PE_en <= control(4);mem_write_enable <= control(3);address_sel <= control(2 downto 1);mem_in_sel <= control(0);     

                  
                  
	if(clk'event and (clk = '1')) then
		if(reset = '1') then
             	   S <= S1;
        	else
                   S <= next_state;
        	end if;	
	end if;
   end process;
end hardon;

