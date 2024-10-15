library IEEE;
use IEEE.Std_logic_1164.all;

entity dFlipFlop is
	port (
		Clk : in std_logic; 
		sync_reset : in std_logic; 
		D : in std_logic;
		Q : out std_logic 
	);
end dFlipFlop;
architecture Behavioral of dFlipFlop is 
begin
	process (Clk)
	begin
		if rising_edge(Clk) then
		 if sync_reset = '1' then
			Q <= '0';
		 end if;
		 if D ='1' then
        Q <= '1';
end if;
end if;
	end process; 
end Behavioral;