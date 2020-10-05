library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity reg_file_wD_mux is
generic ( number_bit : integer := 32);
port ( a, b , c, d: in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(2 downto 0);
		 muxOut : out std_logic_vector(number_bit-1 downto 0));
end reg_file_wD_mux;

architecture rtl of reg_file_wD_mux is

begin
reg_file_wD_mux : process (sel, a, b, c) is
begin
	case sel is
		when "000" => muxOut <= a+"100";
		when "001" => muxOut <= b;
		when "010" => muxOut <= c;
		when "011" => muxOut <= d;
		when others => muxOut <= b;
	end case;
end process;
end rtl;