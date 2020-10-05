library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_p1_mux is
generic ( number_bit : integer := 32);
port ( a, b: in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(1 downto 0);
		 muxOut : out std_logic_vector(number_bit-1 downto 0));
end alu_p1_mux;

architecture rtl of alu_p1_mux is

begin
alu_p1_mux : process (sel, a, b) is
begin
	case sel is
		when "00" => muxOut <= a;
		when "01" => muxOut <= b;
		when others => muxOut <= a;
	end case;
end process;
end rtl;