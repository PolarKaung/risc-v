library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pc_mux is
generic ( number_bit : integer := 32);
port ( a, b: in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(2 downto 0);
		 muxOut : out std_logic_vector(number_bit-1 downto 0));
end pc_mux;

architecture rtl of pc_mux is

begin
pc_mux : process (sel, a, b) is
begin
	case sel is
		when "000" => muxOut <= a;
		when "001" => muxOut <= b;
		when others => muxOut <= a;
	end case;
end process;
end rtl;