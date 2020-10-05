library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PC is
generic (number_bit : integer := 32);

port ( pc_clk : in std_logic;
		 pc	  : out std_logic_vector(number_bit-1 downto 0);
		 br_offset : in std_logic_vector(number_bit-1 downto 0);
		 branch : in std_logic;
		 instruc_count_reset : out std_logic := '0';
		 pcEn, reset	  : in std_logic;
		 pcMode : in std_logic_vector(2 downto 0));
end PC;

architecture rtl of PC is
signal pc_value : std_logic_vector(number_bit-1 downto 0):= (others => '0');
begin
process (pc_clk, pcEn, reset) 
begin
	if (pcEn = '1') then
		instruc_count_reset <= '1';
	else instruc_count_reset <= '0';
	end if;
	if (reset = '0') then
		pc_value <= (others => '0');
	elsif (rising_edge(pc_clk)) then
		if (pcEn = '1') then
			if (pcMode = "010") then 
				pc_value <= br_offset;
			else
				if (branch = '0') then
					pc_value <= pc_value + "100";
				elsif (branch = '1') then
					pc_value <= pc_value + br_offset;
				end if;
			end if;
		end if;
	end if;
end process;
pc <= pc_value;

end rtl;