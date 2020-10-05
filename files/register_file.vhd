library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_file is
generic ( number_bit : integer := 32);
port ( wAddr : in std_logic_vector(4 downto 0);
		 wEn	 : in std_logic;
		 wD	 : in std_logic_vector(number_bit-1 downto 0);
		 rD	 : in std_logic_vector(number_bit-1 downto 0);
		 rAddr1, rAddr2: in std_logic_vector(4 downto 0);
		 port1, port2 : out std_logic_vector(number_bit-1 downto 0);
		 clk_in, reset: in std_logic;
		 test_out : out std_logic_vector(number_bit-1 downto 0));
end register_file;

architecture rtl of register_file is
type registers_type is array(0 to number_bit-1) of std_logic_vector(number_bit-1 downto 0);
signal registers : registers_type := (others => (others => '0'));
begin

write_proc : process (clk_in, reset)
begin
	if (reset = '0') then
		registers <= (others => (others=>'0'));
	elsif (rising_edge(clk_in)) then
		if (wEn = '1') then
			if (wAddr = "00000") then
				registers(to_integer(unsigned(wAddr))) <= (others => '0');
			else
				registers(to_integer(unsigned(wAddr))) <= wD;
			end if;
		end if;
	end if;
end process;

--read
port1 <= registers(to_integer(unsigned(rAddr1)));
port2 <= registers(to_integer(unsigned(rAddr2)));
test_out <= registers(1);

end rtl;