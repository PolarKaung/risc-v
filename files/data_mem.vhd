library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity data_mem is
generic ( number_bit : integer := 32);
port ( clk_in : in std_logic;
		 wrAddr : in std_logic_vector(number_bit-1 downto 0);
		 wD	  : in std_logic_vector(number_bit -1 downto 0);
		 MRW	  : in std_logic;
		 rD	  : out std_logic_vector(number_bit-1 downto 0));
end data_mem;

architecture rtl of data_mem is
type memory is array ( 0 to (2**8) -1) of std_logic_vector(number_bit-1 downto 0);
signal d_memory : memory := (others =>(others => '0'));
begin
read_write : process ( clk_in ) is
begin
	if (rising_edge(clk_in)) then
		if (MRW = '0') then
			rD <= d_memory(to_integer(unsigned(wrAddr)));
		elsif (MRW = '1') then
			d_memory(to_integer(unsigned(wrAddr))) <= wD;
		end if;
	end if;
end process;
end rtl;