----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2022 04:29:55 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SSD is
    Port ( clk : in STD_LOGIC;
           nr : in STD_LOGIC_VECTOR (31 downto 0);
           nr1 : in STD_LOGIC_VECTOR (31 downto 0);
           switchmode : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           cntmodem : out STD_LOGIC_VECTOR (1 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal cnt: std_logic_vector(15 downto 0);
signal cnt1: std_logic_vector(15 downto 0);
signal cntmode: std_logic_vector(1 downto 0):="00";
signal O: std_logic_vector(7 downto 0);

begin

process (switchmode,cntmode)
begin 
if rising_edge(clk) then
if switchmode='1' then 
cntmode <= cntmode +1;
end if;
end if;
end process;

process (clk)
begin 
if rising_edge(clk) then 
cnt <= cnt +1;
end if;
end process;

process (clk)
begin 
if rising_edge(clk) then 
cnt1 <= cnt1 +1;
end if;
end process;

process(cnt, nr,cntmode(0))
begin
    case cntmode(0) is
    when '0'=>
         case cnt(15 downto 14) is
         when "00" => O <= nr(7 downto 0);
         when "01"  => O <= nr(15 downto 8);
         when "10" => O <= nr(23 downto 16);
         when others => O <= nr(31 downto 24) ;
         end case;
     when '1'=>
         case cnt1(15 downto 14) is
         when "00" => O <= nr1(7 downto 0);
         when "01"  => O <= nr1(15 downto 8);
         when "10" => O <= nr1(23 downto 16);
         when others => O <= nr1(31 downto 24) ;
     end case;
  end case;
end process;

process(cnt)
begin
 case cnt(15 downto 14) is
 when "00" => an <= "1110";
 when "01"  => an <= "1101";
 when "10" => an <= "1011";
 when others => an <= "0111" ;
 end case;
end process;

with O select
    cat<= 
    "1111001" when "00110001", --1,
    "0100100" when "00110010", --2,
    "0110000" when "00110011", --3,
    "0011001" when "00110100", --4,
    "0010010" when "00110101", --5,
    "0000010" when "00110110", --6,
    "1111000" when "00110111", --7,
    "0000000" when "00111000", --8,
    "0010000" when "00111001", --9,
    "0001000" when "01000001", --A,
    "0100000" when "01100001", --a,
    "0000011" when "01100010", --b,
    "0000011" when "01000010", --B,
    "1000110" when "01000011", --C,
    "0100111" when "01100011", --c,
    "0100001" when "01100100", --d,
    "0100001" when "01000100", --D,
    "0000110" when "01000101", --E,
    "0000110" when "01100101", --e,
    "0001110" when "01000110", --F,
    "0001110" when "01100110", --f,
    "1000010" when "01000111", --G,
    "1000010" when "01100111", --g,
    "0001011" when "01001000", --H,
    "0001011" when "01101000", --h,
    "1001111" when "01001001", --I,
    "1001111" when "01101001", --i,
    "1100001" when "01001010", --J,
    "1100001" when "01101010", --j,
    "0001010" when "01101011", --k,
    "0001010" when "01001011", --K,
    "1000111" when "01001100", --L,
    "1000111" when "01101100", --l,
    "1101010" when "01101101", --m,
    "1101010" when "01001101", --M,
    "0101011" when "01101110", --n,
    "0101011" when "01001110", --N,
    "0100011" when "01101111", --o,
    "0100011" when "01001111", --O,
    "0001100" when "01010000", --P,
    "0001100" when "01110000", --p,
    "0011000" when "01110001", --q,
    "0011000" when "01010001", --Q,
    "0101111" when "01110010", --r,
    "0101111" when "01010010", --R,
    "1010010" when "01010011", --S,
    "1010010" when "01110011", --s,
    "0000111" when "01110100", --t,
    "0000111" when "01010100", --T,
    "1000001" when "01010101", --U,
    "1100011" when "01110101", --u,
    "1010001" when "01110110", --v,
    "1010001" when "01010110", --V,
    "1010101" when "01110111", --w,
    "1010101" when "01010111", --W,
    "0001001" when "01111000", --X,
    "0001001" when "01011000", --x,
    "0010001" when "01111001", --y,
    "0010001" when "01011001", --Y,
    "0110100" when "01111010", --z,
    "0110100" when "01011010", --Z,
    "1111111" when "00100000", --space,
    "1110111" when "01011111", -- _,
    "1000110" when "01011011", -- [,
    "1110000" when "01011101", -- ]
    "0101100" when "00111111", -- ?
    "0111110" when "00111010", -- :
    "1111101" when "00100111", -- '
    "1011101" when "00100010", -- ""
         "1000000" when others; 

cntmodem<=cntmode;
end Behavioral;
