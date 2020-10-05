library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity signExtend is
generic ( number_bit : integer := 32;
			 fromExtend	: integer := 12;
			 toExtend	: integer := 32;
			 shift		: integer := 0);
port ( a : in std_logic_vector(fromExtend-1 downto 0);
		 signExtended : out std_logic_vector(number_bit-1 downto 0));
end signExtend;

architecture rtl of signExtend is
signal mask : std_logic_vector(toExtend - fromExtend -1 downto 0);
begin
	mask <= (others => a(11));
	signExtended <= std_logic_vector(shift_left(signed(mask & a), shift));
end rtl;