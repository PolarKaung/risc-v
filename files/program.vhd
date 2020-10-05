library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity program is
port ( valid1, valid2, reset : in std_logic;
		 data	 : in std_logic_vector(7 downto 0);
		 address : out std_logic_vector(7 downto 0);
		 dataOut : out std_logic_vector(7 downto 0);
		 program : out std_logic);
end program;

architecture rtl of program is
signal one : std_logic := '1';
signal zero : std_logic := '0';
signal s_address : std_logic_vector(7 downto 0):= (others=>'0');
signal s_data	  : std_logic_vector(7 downto 0):= (others=> '0');
signal s_program : std_logic:= '0';
begin
process (valid1) is
begin
	if (valid1 = '1') then
		s_program <= '1';
		s_data <= data;
	else
		s_program <= '0';
	end if;
end process;
process(valid2, reset) is
begin
	if (reset ='0') then
		s_address <= (others=>'0');
	elsif (rising_edge(valid2)) then
		s_address <= s_address + '1';
	end if;
end process;

program <= s_program;
address <= s_address;
dataOut <= s_data;
end rtl;