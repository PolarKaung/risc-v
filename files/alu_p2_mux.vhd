library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_p2_mux is
generic ( number_bit : integer := 32);
port ( a, b , c, d, e: in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(2 downto 0);
		 muxOut : out std_logic_vector(number_bit-1 downto 0));
end alu_p2_mux;

architecture rtl of alu_p2_mux is

begin
alu_p2_mux : process (sel, a, b, c, d, e) is
begin
	case sel is
		when "000" => muxOut <= a;
		when "001" => muxOut <= b;
		when "010" => muxOut <= c;
		when "011" => muxOut <= d;
		when "100" => muxOut <= e;
		when others => muxOut <= b;
	end case;
end process;
end rtl;