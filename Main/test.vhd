--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:30:57 06/30/2022
-- Design Name:   
-- Module Name:   E:/University/term 6/logic labratory/Project_Final/Main/test.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Main
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         slct : IN  std_logic_vector(3 downto 0);
         clk : IN  std_logic;
         async : IN  std_logic;
         sync : IN  std_logic;
         en : IN  std_logic;
         flag : OUT  std_logic_vector(3 downto 0);
         C : OUT  std_logic_vector(7 downto 0);
         R1_seg1 : OUT  std_logic_vector(6 downto 0);
         R1_seg2 : OUT  std_logic_vector(6 downto 0);
         R2_seg1 : OUT  std_logic_vector(6 downto 0);
         R2_seg2 : OUT  std_logic_vector(6 downto 0);
         R3_seg1 : OUT  std_logic_vector(6 downto 0);
         R3_seg2 : OUT  std_logic_vector(6 downto 0);
         R4_seg1 : OUT  std_logic_vector(6 downto 0);
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal slct : std_logic_vector(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal async : std_logic := '0';
   signal sync : std_logic := '0';
   signal en : std_logic := '0';

 	--Outputs
   signal flag : std_logic_vector(3 downto 0);
   signal C : std_logic_vector(7 downto 0);
   signal R1_seg1 : std_logic_vector(6 downto 0);
   signal R1_seg2 : std_logic_vector(6 downto 0);
   signal R2_seg1 : std_logic_vector(6 downto 0);
   signal R2_seg2 : std_logic_vector(6 downto 0);
   signal R3_seg1 : std_logic_vector(6 downto 0);
   signal R3_seg2 : std_logic_vector(6 downto 0);
   signal R4_seg1 : std_logic_vector(6 downto 0);
   signal Cout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Main PORT MAP (
          A => A,
          B => B,
          slct => slct,
          clk => clk,
          async => async,
          sync => sync,
          en => en,
          flag => flag,
          C => C,
          R1_seg1 => R1_seg1,
          R1_seg2 => R1_seg2,
          R2_seg1 => R2_seg1,
          R2_seg2 => R2_seg2,
          R3_seg1 => R3_seg1,
          R3_seg2 => R3_seg2,
          R4_seg1 => R4_seg1,
          Cout => Cout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		en <= '1';
		A <= X"20";
		B <= X"02";
		sync <= '0';
		async <= '0';
		slct <= "0000";
		wait for 100 ns;
		slct <= "0001";
		wait for 100 ns;
		slct <= "0010";
		wait for 100 ns;
		slct <= "0011";
		wait for 100 ns;
		slct <= "0100";
		wait for 100 ns;
		slct <= "0101";
		wait for 100 ns;
		slct <= "0110";
		wait for 100 ns;
		slct <= "0111";
		wait for 100 ns;
		slct <= "1000"; 
		wait for 100 ns;
		slct <= "1001";
		wait for 100 ns;
			
		async <= '1'; -- check the async
		wait for 100 ns;
		async <= '0';
		wait for 100 ns;
		slct <= "0001";
		wait for 100 ns;
		slct <= "0010";
		wait for 100 ns;
		sync <= '1'; -- check the sync
		wait for 100 ns;
		sync <= '0';
		wait for 100 ns;
		A <= X"02";  -- check the negetive flag
		B <= X"20";
		slct <= "0000";
		wait for 100 ns;
		A <= X"20"; -- check the zero flag
		B <= X"20";
		slct <= "0000";
		wait for 100 ns;
		
      wait;
   end process;

END;
