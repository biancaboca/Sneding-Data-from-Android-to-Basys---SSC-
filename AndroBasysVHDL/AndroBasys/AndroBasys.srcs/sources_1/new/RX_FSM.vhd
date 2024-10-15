----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/31/2022 04:09:24 PM
-- Design Name:
-- Module Name: RX_FSM - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RX_FSM is
	port (
		CLK : in STD_LOGIC;
		RX : in STD_LOGIC;
		BAUD_EN : in STD_LOGIC;
		RST : in STD_LOGIC;
		RX_RDY : out STD_LOGIC;
		RX_DATA : out STD_LOGIC_VECTOR (7 downto 0)
	);
end RX_FSM;

architecture Behavioral of RX_FSM is

	type state_type is(idle, start, bits, stop, waits);
	signal state : state_type;
 
	signal BAUD_CNT : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	signal BIT_CNT : STD_LOGIC_VECTOR(2 downto 0) := "000";
	signal data : STD_LOGIC_VECTOR(7 downto 0);
	signal pos : integer;
 
 

begin
	process1 : process (CLK, RST, BAUD_EN, BAUD_CNT)
	begin
		if RST = '1' then
			state <= idle;
		elsif rising_edge(CLK) and BAUD_EN = '1' then
			case state is
				when idle => 
					RX_RDY <= '0';
					BAUD_CNT <= b"0000";
					if RX = '0' then
						state <= start;
					end if;
				when start => 
					RX_RDY <= '0';
					BAUD_CNT <= BAUD_CNT + 1;
					 
					if RX = '1' then
						state <= idle;
					end if;
 
					if (BAUD_CNT < b"0111") then
						state <= start;
						-- aduna la baud cnt
					elsif (RX = '0' and BAUD_CNT = b"0111") then
						BAUD_CNT <= b"0000";
						state <= bits;
					end if;
				when bits => 
					--aduna bitcnt
					RX_RDY <= '0';
					BAUD_CNT <= BAUD_CNT + 1;
					if BAUD_CNT = x"F" then
						--pos<=conv_integer(BIT_CNT);
						RX_DATA(conv_integer(BIT_CNT)) <= RX;
						BAUD_CNT <= x"0";
						BIT_CNT <= BIT_CNT + 1;
					end if;
					if BIT_CNT = b"111" and BAUD_CNT = x"F" then
						BIT_CNT <= b"000";
						BAUD_CNT <= x"0";
					end if;
					if BIT_CNT < b"111" then
						state <= bits;
					elsif (BIT_CNT = b"111" and BAUD_CNT = X"F") then
						state <= stop;
					end if;
				when stop => 
					--inc baudcnt
					RX_RDY <= '0';
 
					--if rising_edge(CLK) then
					BAUD_CNT <= BAUD_CNT + 1;
					--end if;
					if BAUD_CNT = x"F" then
						BAUD_CNT <= x"0";
					end if;
 
					if BAUD_CNT < x"F" then
						state <= stop;
					elsif BAUD_CNT = x"F" then
						state <= waits;
					end if;
				when waits => 
					-- if rising_edge(CLK) then
					BAUD_CNT <= BAUD_CNT + 1;
					-- end if;
					RX_RDY <= '1';
					if BAUD_CNT < b"0111" then
						state <= waits;
					elsif BAUD_CNT = B"0111" then
						state <= idle;
					end if;
			end case;
		end if;
	end process process1;
 
	-- process2 :process (state,CLK,BAUD_CNT,BIT_CNT,RX)
	-- begin
	-- case state is
	-- when idle => RX_RDY <= '0'; BAUD_CNT<=b"0000";
	-- when start => 
	-- RX_RDY <= '0';
	-- if rising_edge(CLK) then
	-- BAUD_CNT<=BAUD_CNT+1;
	-- end if;
	-- when bits => RX_RDY <= '0';
	-- BAUD_CNT<=BAUD_CNT+1;
	-- if BAUD_CNT = x"F" then
	-- --pos<=conv_integer(BIT_CNT);
	-- RX_DATA(conv_integer(BIT_CNT)) <= RX;
	-- BAUD_CNT<=x"0";
	-- BIT_CNT<=BIT_CNT+1;
	-- end if;
	-- iF BIT_CNT=b"111" and BAUD_CNT =x"F" then
	-- BIT_CNT<=b"000";
	-- BAUD_CNT<=x"0";
	-- end if;
 
	-- when stop =>
	-- RX_RDY <= '0';
 
	-- if rising_edge(CLK) then
	-- BAUD_CNT<=BAUD_CNT+1;
	-- end if;
	-- if BAUD_CNT = x"F" then
	-- BAUD_CNT<=x"0";
	-- end if;
 
	-- when waits =>
	-- if rising_edge(CLK) then
	-- BAUD_CNT<=BAUD_CNT+1;
	-- end if;
	-- RX_RDY <= '1';
	-- end case;
	-- end process process2;
end Behavioral;