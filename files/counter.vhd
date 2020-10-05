library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
port ( clk_in : in std_logic;
		 counter_reset : in std_logic;
		 count  : out std_logic_vector(2 downto 0) );
end counter;

architecture rtl of counter is
signal cu_counter : std_logic_vector(2 downto 0) := (others => '0');
begin
process (clk_in, counter_reset)
begin
	if (counter_reset = '1') then
			cu_counter <= (others => '0');
	elsif (rising_edge(clk_in)) then
			cu_counter <= cu_counter + '1';
	end if;
end process;
count <= cu_counter;
end rtl;