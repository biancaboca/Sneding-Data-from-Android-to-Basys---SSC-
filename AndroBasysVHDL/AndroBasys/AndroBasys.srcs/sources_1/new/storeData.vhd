----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/10/2022 11:58:19 PM
-- Design Name:
-- Module Name: storeData - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity storeData is
	port (
		En : in STD_LOGIC;
		DataIn : in STD_LOGIC_VECTOR (7 downto 0);
		DataOut : out STD_LOGIC_VECTOR (31 downto 0));
 
end storeData;

architecture Behavioral of storeData is
	signal data : std_logic_vector(31 downto 0);
	signal cnt : std_logic_vector(1 downto 0) := b"00";
	signal flag : std_logic_vector(1 downto 0)  := b"00";
begin
	process (En)
	begin
		if rising_edge(En) then
			cnt <= cnt + 1;
		end if;
	end process;
	process (en, cnt, flag)
		begin
			if rising_edge(En) then
				if cnt = "00" then
					data(31 downto 24) <= DataIn;
					flag <= flag + '1';

				elsif cnt = "01" then
					data(23 downto 16) <= DataIn;
					flag <= flag + '1';
					
				elsif cnt = "10" then
                    data(15 downto 8) <= DataIn;
                    flag <= flag + '1';
                    
				elsif cnt = "11" then
                        data(7 downto 0) <= DataIn;
                        flag <= flag + '1';
                        
				end if;
			end if;
		end process;
		
		process (en, flag)
			begin
				if falling_edge(En) then
					if flag = "00" then
						DataOut <= data;
					end if;
				end if;
			end process;

end Behavioral;