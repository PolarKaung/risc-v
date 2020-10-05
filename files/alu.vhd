library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
generic ( number_bit : integer := 32);
port( port1, port2 : in std_logic_vector(number_bit-1 downto 0);
		brFunc		 : in std_logic_vector(2 downto 0);
		aluFunc 		 : in std_logic_vector(4 downto 0);
		aluOut		 : out std_logic_vector(number_bit-1 downto 0);
		branch		 : out std_logic);
end alu;

architecture rtl of alu is
signal less_signed, less_unsigned : std_logic;
begin
compare : process (port1, port2) is
begin
	if (unsigned(port1) < unsigned(port2)) then
		less_unsigned <= '1';
	else less_unsigned <= '0';
	end if;
	
	if (signed(port1) < signed(port2)) then
		less_signed <= '1';
	else less_signed <= '0';
	end if;
end process;

alu_func: process (aluFunc, port1, port2) is
begin
	case aluFunc is
		when b"00000" => aluOut <= port1 + port2; -- add
		when b"00001" => aluOut <= port1 - port2; -- sub
		when b"00010" => aluOut <= std_logic_vector(shift_left(unsigned(port1), to_integer(unsigned(port2)))); -- shift left logical
		when b"00011" => aluOut <= std_logic_vector(shift_right(unsigned(port1), to_integer(unsigned(port2)))); --shift right logical
		when b"00100" => aluOut <= x"0000000" & b"000" & less_unsigned; -- set if unsigned less
		when b"00101" => aluOut <= x"0000000" & b"000" & less_signed; -- set if unsigned less
		when b"00110" => aluOut <= port1 and port2; -- and
		when b"00111" => aluOut <= port1 or port2; -- or
		when b"01000" => aluOut <= port1 xor port2; -- xor
		when b"01001" => aluOut <= std_logic_vector(shift_right(signed(port1), to_integer(unsigned(port2)))); -- shift right arithematic
		when others => aluOut <= port1 + port2;
	end case;
end process;

branch_func: process (brFunc, port1, port2) is
begin
	if (brFunc = "000") then
		branch <= '0';
	elsif (brFunc = "001") then
		if (signed(port1) = signed(port2)) then
			branch <= '1';
		elsif (signed(port1) /= signed(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "010") then
		if (signed(port1) /= signed(port2)) then
			branch <= '1';
		elsif (signed(port1) = signed(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "011") then
		if (signed(port1) < signed(port2)) then
			branch <= '1';
		elsif (signed(port1) > signed(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "100") then
		if (signed(port1) > signed(port2)) then
			branch <= '1';
		elsif (signed(port1) < signed(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "101") then
		if (unsigned(port1) < unsigned(port2)) then
			branch <= '1';
		elsif (unsigned(port1) > unsigned(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "110") then
		if (unsigned(port1) > unsigned(port2)) then
			branch <= '1';
		elsif (unsigned(port1) < unsigned(port2)) then
			branch <= '0';
		else branch <= '0';
		end if;
	elsif (brFunc = "111") then
		branch <= '1';
	end if;
end process;

end rtl;