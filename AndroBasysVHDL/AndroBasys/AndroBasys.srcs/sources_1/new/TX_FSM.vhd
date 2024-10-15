----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/31/2022 04:09:24 PM
-- Design Name:
-- Module Name: TX_FSM - Behavioral
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

entity TX_FSM is
	port (
		CLK : in STD_LOGIC;
		TX_DATA : in STD_LOGIC_VECTOR (7 downto 0);
		TX_EN : in STD_LOGIC;
		RST : in STD_LOGIC;
		BAUD_EN : in STD_LOGIC;
		TX : out STD_LOGIC;
		TX_RDY : out STD_LOGIC
	);
end TX_FSM;

architecture Behavioral of TX_FSM is

	type state_type is(idle, start, bits, stop);
	signal state : state_type;
	signal BIT_CNT : STD_LOGIC_VECTOR(2 downto 0) := "000";

begin
	process1 : process (CLK, RST, BIT_CNT, BAUD_EN,TX_EN)
	begin
		if RST = '1' then
			state <= idle;
		elsif rising_edge(CLK) and BAUD_EN = '1' then
			case state is
				when idle => 
					TX <= '1';
					TX_RDY <= '1';
					BIT_CNT <= "000";
					if TX_EN = '1' then
						state <= start;
					end if;
				when start => 
					TX <= '0';
					TX_RDY <= '0';
					state <= bits;
 
				when bits => 
					--aduna bitcnt
					TX_RDY <= '0';
					if BIT_CNT <= b"111" then
                        TX <= TX_DATA(conv_integer(BIT_CNT));
                        BIT_CNT <= BIT_CNT + 1;

                    end if;
 
					if BIT_CNT < b"111" then
						state <= bits;
					elsif (BIT_CNT = b"111") then
						state <= stop;
					end if;
                    BIT_CNT <= BIT_CNT + 1;
				when stop => 
					TX_RDY <= '0';
					TX <= '1'; 
					state <= idle;
			end case;
		end if;
	end process process1;
end Behavioral;