library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity debug_output is
generic ( number_bit : integer := 32);
port ( data1 : in std_logic_vector(number_bit-1 downto 0);
		 data2 : in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(1 downto 0);
		 clk_in : in std_logic;
		 debugOut : out std_logic_vector(number_bit-1 downto 0);
		 en	: in std_logic);
end debug_output;

architecture rtl of debug_output is

component output_mux is
port ( a, b : in std_logic_vector(number_bit-1 downto 0);
		 sel	: in std_logic_vector(1 downto 0);
		 muxOut : out std_logic_vector(number_bit-1 downto 0));
end component;

signal a, b : std_logic_vector(number_bit-1 downto 0);
signal muxOut : std_logic_vector(number_bit-1 downto 0);
signal s_debugOut : std_logic_vector(number_bit-1 downto 0);

begin
a <= data1;
b <= data2;

u0: output_mux
port map( a => a, b=> b, sel=>sel, muxOut=>muxOut);

process (clk_in) is
begin
	if (rising_edge(clk_in)) then 
		if ( en = '1') then
			s_debugOut <= data1;
		else
			s_debugOut <= s_debugOut;
		end if;
	end if;
end process;
debugOut <= s_debugOut;
end rtl;