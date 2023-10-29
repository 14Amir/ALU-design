----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:31:43 06/29/2022 
-- Design Name: 
-- Module Name:    Main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0); -- first input
           B : in  STD_LOGIC_VECTOR (7 downto 0); -- second input
			  slct : in STD_LOGIC_VECTOR(3 downto 0); -- selector
           clk : in  STD_LOGIC; -- clock
           async : in  STD_LOGIC; -- async reset
           sync : in  STD_LOGIC; -- sync reset
           en : in  STD_LOGIC; -- enable
			  flag : out STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- flags
           C : out  STD_LOGIC_VECTOR (7 downto 0); -- output
			  R1_seg1 , R1_seg2 : out std_logic_vector(6 downto 0); -- two 7 segment for first input
			  R2_seg1 , R2_seg2 : out std_logic_vector(6 downto 0); -- two 7 segment for second input
			  R3_seg1 , R3_seg2 : out std_logic_vector(6 downto 0); -- two 7 segment for output
			  R4_seg1 : out std_logic_vector(6 downto 0); -- 7 segment for flag
			  Cout : out std_logic);
			  
end Main;

architecture Behavioral of Main is
	-- define the state machine
	type t_state is (S1 , S2 , S3 , S4);
	signal state : t_state;
	signal rslt : std_logic_vector(7 downto 0); -- temp register 
	signal rslt2 : std_logic_vector(15 downto 0); -- temp register
	signal flg_s : std_logic_vector(3 downto 0) := "0000"; -- temp register to store the flag
	
begin

	
	process(clk  ,en , async , sync, state ) is
	begin
		if en = '1' then -- check enable is on
			
			if (async = '1') then -- check the async reset
				
				state <= S1; -- go to first state
				C <= "00000000"; -- initialize the output
				flag <= "0000"; -- initialize the flags
		
			elsif (rising_edge(clk)) then -- check the clock
				
				if (sync = '1') then -- check the sync reset
					state <= S1; -- go to first state
					C <= "00000000"; -- initialize the output
					flag <= "0000"; -- initialize the flags
				else
					case state is
						when S1 => 
							state <= S2;
						when S2 =>
							state <= S3;
						when S3 => 
							state <= S4;
						when S4 =>
							state <= S1;
							
					end case;
				
				end if;
				-- doing operation on rigester when we is third state
				if (state = S3) then
					
					case slct is 
						when "0000" =>   -- sub operatoin
							if (B > A) then
								flg_s <= "0001";
							elsif( A = B) then 
								flg_s <= "1000";
							end if;
							rslt <= A-B;
														
						when "0001" =>   -- and operatoin
							rslt <= A and B;
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;
							
						when "0010" =>   -- sum operatoin
							rslt<= A+B;
							if((A(7) and B(7)) = '1') then  -- check caryy and overflow
								flg_s <= "0010";
							elsif((A or B) = "00000000") then
								flg_s <= "1000";
							end if;
							
						when "0011" =>  -- or operation
							rslt <= A or B;
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;
							
						when "0100" =>  -- multipling operation
							rslt <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),8));
							rslt2 <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),16));
							if( (rslt2 and "1111111100000000") = "0000000000000000" ) then
								flg_s <= "0000";
							else
								flg_s <= "0010";
							end if;
							if ((A or B) = "00000000") then
								flg_s <= "1000";
							end if;
							
							
						when "0101" => -- xor operation
							rslt <= A xor B;
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;

						when "0110" => -- right shift operation
							flg_s(1) <= B(0);
							rslt(0) <= B(1);
							rslt(1) <= B(2);
							rslt(2) <= B(3);
							rslt(3) <= B(4);
							rslt(4) <= B(5);
							rslt(5) <= B(6);
							rslt(6) <= B(7);
							rslt(7) <= '0';
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;
							
						
						when "0111" =>  -- left shift operation
							flg_s(1) <= B(7);
							rslt(7) <= B(6);
							rslt(6) <= B(5);
							rslt(5) <= B(4);
							rslt(4) <= B(3);
							rslt(3) <= B(2);
							rslt(2) <= B(1);
							rslt(1) <= B(0);
							rslt(0) <= '0';
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;
						when "1000" =>  -- pass the input
							rslt <= B;
							if(rslt = "00000000") then
								flg_s <= "1000";
							end if;
						when others =>
							
					end case;

				end if;
				-----------------------------show the output -----------------------------------
				if (state = S4) then
					C <= rslt;
					flag <= flg_s;
					case rslt(3 downto 0) is
						when "0000" =>
							R3_seg1 <= "1111110";
						when "0001" =>
							R3_seg1 <= "0110000";
						when "0010" =>
							R3_seg1 <= "1101101";
						when "0011" =>
							R3_seg1 <= "1111001";
						when "0100" => 
							R3_seg1 <= "0110011";
						when "0101" =>
							R3_seg1 <= "1011011";
						when "0110" =>
							R3_seg1 <= "1011111";
						when "0111" =>
							R3_seg1 <= "1110000";
						when "1000" =>
							R3_seg1 <= "1111111";
						when "1001" =>
							R3_seg1 <= "1111011";
						when "1010" =>
							R3_seg1 <= "1111101";
						when "1011" =>
							R3_seg1 <= "0011111";
						when "1100" =>
							R3_seg1 <= "1001110";
						when "1101" =>
							R3_seg1 <= "0111101";
						when "1110" =>
							R3_seg1 <= "1001111";
						when "1111" =>
							R3_seg1 <= "1000111";
						when others =>
							R3_seg1 <= "0000000";
					end case;
					
					case rslt(7 downto 4) is
						when "0000" =>
							R3_seg2 <= "1111110";
						when "0001" =>
							R3_seg2 <= "0110000";
						when "0010" =>
							R3_seg2 <= "1101101";
						when "0011" =>
							R3_seg2 <= "1111001";
						when "0100" => 
							R3_seg2 <= "0110011";
						when "0101" =>
							R3_seg2 <= "1011011";
						when "0110" =>
							R3_seg2 <= "1011111";
						when "0111" =>
							R3_seg2 <= "1110000";
						when "1000" =>
							R3_seg2 <= "1111111";
						when "1001" =>
							R3_seg2 <= "1111011";
						when "1010" =>
							R3_seg2 <= "1111101";
						when "1011" =>
							R3_seg2 <= "0011111";
						when "1100" =>
							R3_seg2 <= "1001110";
						when "1101" =>
							R3_seg2 <= "0111101";
						when "1110" =>
							R3_seg2 <= "1001111";
						when "1111" =>
							R3_seg2 <= "1000111";
						when others =>
							R3_seg2 <= "0000000";
					end case;
					
					case flg_s is
						when "0000" =>
							R4_seg1 <= "1111110";
						when "0001" =>
							R4_seg1 <= "0110000";
						when "0010" =>
							R4_seg1 <= "1101101";
						when "0011" =>
							R4_seg1 <= "1111001";
						when "0100" => 
							R4_seg1 <= "0110011";
						when "0101" =>
							R4_seg1 <= "1011011";
						when "0110" =>
							R4_seg1 <= "1011111";
						when "0111" =>
							R4_seg1 <= "1110000";
						when "1000" =>
							R4_seg1 <= "1111111";
						when "1001" =>
							R4_seg1 <= "1111011";
						when "1010" =>
							R4_seg1 <= "1111101";
						when "1011" =>
							R4_seg1 <= "0011111";
						when "1100" =>
							R4_seg1 <= "1001110";
						when "1101" =>
							R4_seg1 <= "0111101";
						when "1110" =>
							R4_seg1 <= "1001111";
						when "1111" =>
							R4_seg1 <= "1000111";
						when others =>
							R4_seg1 <= "0000000";
					end case;
					flg_s <= "0000";
					
				end if;
			end if;
			
				-----------------------7 segment -------------------------------------------
			case A(3 downto 0) is
				when "0000" =>
					R1_seg1 <= "1111110";
				when "0001" =>
					R1_seg1 <= "0110000";
				when "0010" =>
					R1_seg1 <= "1101101";
				when "0011" =>
					R1_seg1 <= "1111001";
			   when "0100" => 
					R1_seg1 <= "0110011";
				when "0101" =>
					R1_seg1 <= "1011011";
				when "0110" =>
					R1_seg1 <= "1011111";
				when "0111" =>
					R1_seg1 <= "1110000";
				when "1000" =>
					R1_seg1 <= "1111111";
				when "1001" =>
					R1_seg1 <= "1111011";
				when "1010" =>
					R1_seg1 <= "1111101";
				when "1011" =>
					R1_seg1 <= "0011111";
				when "1100" =>
					R1_seg1 <= "1001110";
				when "1101" =>
					R1_seg1 <= "0111101";
				when "1110" =>
					R1_seg1 <= "1001111";
				when "1111" =>
					R1_seg1 <= "1000111";
				when others =>
					R1_seg1 <= "0000000";
			end case;
			
			case A(7 downto 4) is
				when "0000" =>
					R1_seg2 <= "1111110";
				when "0001" =>
					R1_seg2 <= "0110000";
				when "0010" =>
					R1_seg2 <= "1101101";
				when "0011" =>
					R1_seg2 <= "1111001";
			   when "0100" => 
					R1_seg2 <= "0110011";
				when "0101" =>
					R1_seg2 <= "1011011";
				when "0110" =>
					R1_seg2 <= "1011111";
				when "0111" =>
					R1_seg2 <= "1110000";
				when "1000" =>
					R1_seg2 <= "1111111";
				when "1001" =>
					R1_seg2 <= "1111011";
				when "1010" =>
					R1_seg2 <= "1111101";
				when "1011" =>
					R1_seg2 <= "0011111";
				when "1100" =>
					R1_seg2 <= "1001110";
				when "1101" =>
					R1_seg2 <= "0111101";
				when "1110" =>
					R1_seg2 <= "1001111";
				when "1111" =>
					R1_seg2 <= "1000111";
				when others =>
					R1_seg2 <= "0000000";
			end case;

			
			----------------------------------------------
			case B(3 downto 0) is
				when "0000" =>
					R2_seg1 <= "1111110";
				when "0001" =>
					R2_seg1 <= "0110000";
				when "0010" =>
					R2_seg1 <= "1101101";
				when "0011" =>
					R2_seg1 <= "1111001";
			   when "0100" => 
					R2_seg1 <= "0110011";
				when "0101" =>
					R2_seg1 <= "1011011";
				when "0110" =>
					R2_seg1 <= "1011111";
				when "0111" =>
					R2_seg1 <= "1110000";
				when "1000" =>
					R2_seg1 <= "1111111";
				when "1001" =>
					R2_seg1 <= "1111011";
				when "1010" =>
					R2_seg1 <= "1111101";
				when "1011" =>
					R2_seg1 <= "0011111";
				when "1100" =>
					R2_seg1 <= "1001110";
				when "1101" =>
					R2_seg1 <= "0111101";
				when "1110" =>
					R2_seg1 <= "1001111";
				when "1111" =>
					R2_seg1 <= "1000111";
				when others =>
					R2_seg1 <= "0000000";
			end case;
			
			case B(7 downto 4) is
				when "0000" =>
					R2_seg2 <= "1111110";
				when "0001" =>
					R2_seg2 <= "0110000";
				when "0010" =>
					R2_seg2 <= "1101101";
				when "0011" =>
					R2_seg2 <= "1111001";
			   when "0100" => 
					R2_seg2 <= "0110011";
				when "0101" =>
					R2_seg2 <= "1011011";
				when "0110" =>
					R2_seg2 <= "1011111";
				when "0111" =>
					R2_seg2 <= "1110000";
				when "1000" =>
					R2_seg2 <= "1111111";
				when "1001" =>
					R2_seg2 <= "1111011";
				when "1010" =>
					R2_seg2 <= "1111101";
				when "1011" =>
					R2_seg2 <= "0011111";
				when "1100" =>
					R2_seg2 <= "1001110";
				when "1101" =>
					R2_seg2 <= "0111101";
				when "1110" =>
					R2_seg2 <= "1001111";
				when "1111" =>
					R2_seg2 <= "1000111";
				when others =>
					R2_seg2 <= "0000000";
			end case;

		end if;
		
		
	end process;

end Behavioral;

