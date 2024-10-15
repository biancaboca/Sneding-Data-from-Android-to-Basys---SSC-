
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
entity test_env is
	port (
		clk : in STD_LOGIC;
		RX : in STD_LOGIC;
		btn : in STD_LOGIC_VECTOR(4 downto 0);
		sw : in STD_LOGIC_VECTOR (15 downto 0);
		TX : out STD_LOGIC;
		led : out STD_LOGIC_VECTOR (15 downto 0);
		an : out STD_LOGIC_VECTOR (3 downto 0);
		cat : out STD_LOGIC_VECTOR (6 downto 0)
	);

end test_env;

architecture Behavioral of test_env is

	signal baudraterx : std_logic_vector(9 downto 0);
	signal baudratetx : std_logic_vector(13 downto 0);
	signal RxDat : std_logic_vector(7 downto 0);
	signal RxDat1 : std_logic_vector(7 downto 0);
	--signal data : std_logic_vector(15 downto 0);
	signal dataaux : std_logic_vector(31 downto 0);
	signal dataaux1 : std_logic_vector(31 downto 0);
	signal datashow : std_logic_vector(31 downto 0);
	signal baud_ENablerx : std_logic;
	signal baud_ENabletx : std_logic;
	signal alooo : std_logic;
	--signal Reset : std_logic;
	signal rxrdy : std_logic;
	--signal rxrdy1 : std_logic;
	signal txrdy : std_logic;
	signal btnTOdflipflop : std_logic;
	signal swmode : std_logic;
	signal txEN : std_logic;
	--signal cnt : std_logic_vector (15 downto 0):=x"0000";
    signal cntmode : std_logic_vector (1 downto 0);
    signal cntssd : std_logic_vector (15 downto 0);


begin
	process (clk)
	begin
		if rising_edge(clk) then
			if baudraterx < b"10_1000_1011" then
				baud_ENablerx <= '0';
				baudraterx <= baudraterx + 1;
			elsif (baudraterx = b"10_1000_1011") then
				baud_ENablerx <= '1';
				RxDat1 <= RxDat;
				baudraterx <= b"00_0000_0000";
			end if;
		end if;
	end process;

	process (clk)
		begin
			if rising_edge(clk) then
				if baudratetx < b"10_1000_1011_0000" then
					baud_ENabletx <= '0';
					baudratetx <= baudratetx + 1;
				elsif (baudratetx = b"10_1000_1011_0000") then
					baud_ENabletx <= '1';
					baudratetx <= b"00_0000_0000_0000";
				end if;
			end if;
		end process;

 
		rxmodule : entity WORK.RX_FSM
			port map(clk, RX, baud_ENablerx, '0', rxrdy, RxDat);
			txmodule : entity WORK.TX_FSM
				port map(clk, sw(7 downto 0), txEN, '0', baud_ENabletx, TX, txrdy);
				debounceTxEn : entity WORK.debounce
					port map(btn(0), clk, btnTOdflipflop);
                        swmodelabel : entity WORK.debounce
                                            port map(btn(1), clk, swmode);
                            senddatca : entity WORK.debounce
                                                                        port map(btn(2), clk, alooo);
					dflipflop : entity WORK.dFlipFlop
						port map(clk, baud_ENabletx, btnTOdflipflop, txEN);
						ssd : entity WORK.SSD
							port map(clk, dataaux,datashow,swmode, cat,cntmode, an);
                                               storeData : entity WORK.storeData
                                                                   port map(rxrdy, RxDat,dataaux);     
                                                           sendData : entity WORK.sendData
                                                                  port map(txEN,clk, sw(7 downto 0),datashow,cntssd);
 led(7 downto 0)<=RxDat;

end Behavioral;