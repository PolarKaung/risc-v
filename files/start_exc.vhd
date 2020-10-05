library ieee;
use ieee.std_logic_1164.all;

entity start_exc is
port ( key, reset : in std_logic;
		 start : out std_logic);
end entity;

architecture rtl of start_exc is
signal s_start : std_logic := '0';
begin
process (key, reset) is
begin
	if (key = '0') then
		s_start <= '1';
	elsif (reset = '0') then
		s_start <= '0';
	end if;
end process;

start <= s_start;
end rtl;