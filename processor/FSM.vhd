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
	alu_b_sel_3:out std_logic; 
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
      variable control: std_logic_vector(32 downto 0);
      
   begin
	 -- defaults
       control := (others => '0');
       next_state := S;  

    case S is 
          when S1=>
                  next_state := S2;
                  control := "011100000010000010000000010000000";  
              
          when S2 =>
                  control := "010100011100000000000000000100000";
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
			next_state := S12; 
		  elsif (opcode1="0111") then                    --occurs in SM
			next_state := S17; 
                  elsif (opcode1="1100") then                   --occurs in BEQ			
		        next_state := S10; 
		  elsif (opcode1="1000") then                   --occurs in JAL 		
		        next_state := S12; 
	          elsif (opcode1="1001") then                   --occurs in BEQ			
		        next_state := S11; 
                  end if; 
 
          when S3=>
                 
                  control := "001011100100000000000000000000000"; 
		  if (opcode1="0000" or opcode1="0010") then    --ADD or NAND instructions 
			next_state:= S4;                               
            	   
		  elsif (opcode1="0111") then                   --occurs in SM
			next_state:= S16;              
                  end if; 
	  
	  when S4=> 
		  next_state:= S1;
		  control := "000000000000000101000001000000000"; 
          when S5=> 
		  control :="000100000110010000000000000001000"; 
		  if ( opcode1="0001") then                      -- ADI 
			next_state:= S6; 
                  elsif (opcode1="0100") then                    -- LW
			next_state:=S8; 
                  end if; 
	  when S6=> 
		  control:= "000101100000000100100001000000000"; 
		  next_state:= S1; 
          when S7=>
		  control:= "100100000100000000000000000000000"; 
		  if ( opcode1="0100") then                      -- LW 
		 	next_state:= S5; 
		  elsif (opcode1="0101") then                    -- SW 
			next_state:=S9;                         
		  end if; 
          when S8=> 
		  control:= "000000100000000100000001100000001";
		  next_state:= S1;  
	  when S9=> 
		  control:= "000000000000000000000000000011000";
		  next_state:= S1; 
	  when S10=> 
		  control:= "001010000000000010010000000000000"; 
		  next_state:= S1; 
          when S11=> 
		  control:= "000000000000000110001001000000000"; 
		  next_state:= S1;
	  when S12=> 
		  control:= "110000001100100000000000000000100";
                  if (opcode1="0110") then                      --LM
			if (pe_flag='1') then
		  		next_state:= S15;
			else
				next_state:= S1;
			end if; 
                  elsif ( opcode1="1000") then                  --JAL 
		  next_state:= S13; 
                  end if; 
          when S13=> 
		  control:= "000000000000000110001111100000000"; 
		  next_state:=S1; 
	  when S14=> 
		  control:= "000000000000000100000000000000000"; 
		  next_state:=S1; 
	  when S15=> 
                  control:= "001100010001000101100000101100000"; 
	  	  next_state:= S12; 
          when S16=> 
		  control:= "001100010001000000000000001110110"; 
                  if( pe_flag='1') then 
		  	next_state:= S17; 
		  else 
			next_state:=S1; 
                  end if; 
	  when S17=> 						--SM
		  control:= "000000001000001000000000000000000"; 
		  if (pe_flag='1') then
		  	next_state:= S16;
		  else
			next_state:= S1;
		  end if; 
              
    end case; 
alu_a_sel <= control(32 downto 31); alu_b_sel<= control(30 downto 29);alu_op <= control(28);c_en <= control(27);z_en <= control(26);t1_en<= control(25);
t2_en <= control(24);t3_en <= control(23);Tp_en <= control(22);t1_sel <= control(21);t2_sel <= control(20);Tp_sel <= control(19);
A2_sel <= control(18);RF_write <= control(17);R7_write <= control(16);A3_sel <= control(15 downto 14);data_sel <= control(13 downto 11);D3_sel <= control(10 downto 8);
IR_en<=control(7);PE_sel<= control(6);PE_en <= control(5);mem_write_enable <= control(4);address_sel <= control(3 downto 2);mem_in_sel <= control(1);alu_b_sel_3<=control(0);      

                  
                  
	if(clk'event and (clk = '1')) then
		if(reset = '1') then
             	   S <= S1;
        	else
                   S <= next_state;
        	end if;	
	end if;
   end process;
end hardon;

