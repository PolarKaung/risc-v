library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity control_unit is
generic ( controlBit:integer := 21);
port( opcode, func7 : in std_logic_vector(6 downto 0);
		func3	 : in std_logic_vector(2 downto 0);
		counter: in std_logic_vector(2 downto 0);
		clk_in : in std_logic;
		controlWord : out std_logic_vector(controlBit-1 downto 0));
end control_unit;

architecture rtl of control_unit is
signal s_wREn, s_pcEn : std_logic;
signal s_aluFunc : std_logic_vector(4 downto 0);
signal control : std_logic_vector(13 downto 0);

signal s_contorlWord : std_logic_vector(controlBit-1 downto 0);

begin
control <= func7(5) & func3 & counter & opcode;
process (opcode,func7,clk_in)
begin
	if (falling_edge(clk_in)) then
		if (counter = "000") then
			s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00000";
		else
-- controlWord	25-21		20-19		18-17		16-14		13-11		10		9-7	6		5		4 - 0
-- meaning		custom	p1sel		brImmsel	brFunc	wDsel		MRW	p2sel	pcEn  wREn  aluFunc
			case? (control) is
			-- two registers alu functions contorlWord <= b"0_0_0_00000" 
				--add
				when b"0_000_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00000";
				when b"0_000_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00000";
				when b"0_000_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--sub
				when b"1_000_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00001";
				when b"1_000_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00001";
				when b"1_000_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--sll
				when b"0_001_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00010";
				when b"0_001_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00010";
				when b"0_001_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--srl
				when b"0_101_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00011";
				when b"0_101_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00011";
				when b"0_101_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--sltu - set if unsigned less than
				when b"0_011_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00100";
				when b"0_011_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00100";
				when b"0_011_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--slt - set if signed less than
				when b"0_010_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00101";
				when b"0_010_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00101";
				when b"0_010_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--and
				when b"0_111_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00110";
				when b"0_111_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00110";
				when b"0_111_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--or
				when b"0_110_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00111";
				when b"0_110_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_00111";
				when b"0_110_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--xor
				when b"0_100_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_01000";
				when b"0_100_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_01000";
				when b"0_100_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--sra
				when b"1_101_001_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_01001";
				when b"1_101_010_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_0_1_01001";
				when b"1_101_011_0110011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
				-- instructions with one intermediate
				--addi - add intermediate
				when b"-_000_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00000";
				when b"-_000_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00000";
				when b"-_000_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
				--when b"-_001_001_0010000" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00001";
				--when b"-_001_010_0010000" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00001";
				--when b"-_001_011_0010000" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
				--slli
				when b"0_001_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00010";
				when b"0_001_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00010";
				when b"0_001_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--srli
				when b"0_101_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00011";
				when b"0_101_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00011";
				when b"0_101_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--sltiu
				when b"-_011_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00100";
				when b"-_011_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00100";
				when b"-_011_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--slti
				when b"-_010_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00101";
				when b"-_010_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00101";
				when b"-_010_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--andi
				when b"-_111_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00110";
				when b"-_111_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00110";
				when b"-_111_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--ori
				when b"-_110_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_00111";
				when b"-_110_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_00111";
				when b"-_110_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--xori
				when b"-_100_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_01000";
				when b"-_100_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_01000";
				when b"-_100_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				--srai
				when b"1_101_001_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_0_01001";
				when b"1_101_010_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_001_0_1_01001";
				when b"1_101_011_0010011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
-- controlWord	25-21		20-19		18-17		16-14		13-11		10		9-7	6		5		4 - 0
-- meaning		custom	p1sel		brImmsel	brFunc	wDsel		MRW	p2sel	pcEn  wREn  aluFunc
				-- load and store instructions
				--sw -store word(32 bit) to data memory
				when b"-_010_001_0100011" => s_contorlWord <= b"00000_00_00_000_001_0_010_0_0_00000";
				when b"-_010_010_0100011" => s_contorlWord <= b"00000_00_00_000_001_1_010_0_0_00000";
				when b"-_010_011_0100011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				-- lw - load from memory to register
				when b"-_010_001_0000011" => s_contorlWord <= b"00000_00_00_000_010_0_001_0_0_00000";
				when b"-_010_010_0000011" => s_contorlWord <= b"00000_00_00_000_010_0_001_0_1_00000";
				when b"-_010_011_0000011" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
-- controlWord	25-21		20-19		18-17		16-14		13-11		10		9-7	6		5		4 - 0
-- meaning		custom	p1sel		brImmsel	brFunc	wDsel		MRW	p2sel	pcEn  wREn  aluFunc
				--branch instructions
				-- beq - sign equal
				when b"-_000_001_1100011" => s_contorlWord <= b"00000_00_00_001_001_0_000_0_0_00000";
				when b"-_000_010_1100011" => s_contorlWord <= b"00000_00_00_001_001_0_000_1_0_00000";
				-- bne - sign not equal
				when b"-_001_001_1100011" => s_contorlWord <= b"00000_00_00_010_001_0_000_0_0_00000";
				when b"-_001_010_1100011" => s_contorlWord <= b"00000_00_00_010_001_0_000_1_0_00000";
				-- blt - sign less than
				when b"-_100_001_1100011" => s_contorlWord <= b"00000_00_00_011_001_0_000_0_0_00000";
				when b"-_100_010_1100011" => s_contorlWord <= b"00000_00_00_011_001_0_000_1_0_00000";
				-- bge - sign greater than
				when b"-_101_001_1100011" => s_contorlWord <= b"00000_00_00_100_001_0_000_0_0_00000";
				when b"-_101_010_1100011" => s_contorlWord <= b"00000_00_00_100_001_0_000_1_0_00000";
				-- bltu - unsign less than
				when b"-_110_001_1100011" => s_contorlWord <= b"00000_00_00_101_001_0_000_0_0_00000";
				when b"-_110_010_1100011" => s_contorlWord <= b"00000_00_00_101_001_0_000_1_0_00000";
				-- bgeu - unsign greater than
				when b"-_111_001_1100011" => s_contorlWord <= b"00000_00_00_110_001_0_000_0_0_00000";
				when b"-_111_010_1100011" => s_contorlWord <= b"00000_00_00_110_001_0_000_1_0_00000";
				
				--jump instructions
				-- jal - jump and link
				when b"-_---_001_1101111" => s_contorlWord <= b"00000_00_01_111_000_0_000_0_1_00000";
				when b"-_---_010_1101111" => s_contorlWord <= b"00000_00_01_111_001_0_000_1_0_00000";
				-- jalr - jump and link register ( intermediate value)
				when b"-_000_001_1100111" => s_contorlWord <= b"00000_00_10_000_000_0_001_0_1_00000";
				when b"-_000_010_1100111" => s_contorlWord <= b"00000_00_10_000_001_0_001_1_0_00000";
-- controlWord	25-21		20-19		18-17		16-14		13-11		10		9-7	6		5		4 - 0
-- meaning		custom	p1sel		brImmsel	brFunc	wDsel		MRW	p2sel	pcEn  wREn  aluFunc
				-- load upper instructions
				-- auipc - add upper immediate to pc
				when b"-_---_001_0010111" => s_contorlWord <= b"00000_01_00_000_001_0_100_0_0_00000";
				when b"-_---_010_0010111" => s_contorlWord <= b"00000_01_00_000_001_0_100_0_1_00000";
				when b"-_---_011_0010111" => s_contorlWord <= b"00000_00_00_000_001_0_100_1_0_00000";
				-- lui - add upper immediate to register
				when b"-_---_001_0110111" => s_contorlWord <= b"00000_00_00_000_011_0_000_0_1_00000";
				when b"-_---_010_0110111" => s_contorlWord <= b"00000_00_00_000_011_0_000_1_0_00000";
				
				-- custom instructions
				-- out - output value to outside world
				when b"-_---_001_1011010" => s_contorlWord <= b"00100_00_00_000_001_0_000_0_0_00000";
				when b"-_---_010_1011010" => s_contorlWord <= b"00000_00_00_000_001_0_000_1_0_00000";
				
				when others			 	 	  => s_contorlWord <= b"00000_00_00_000_001_0_000_0_0_00000";
			end case?;
		end if;
	end if;
end process;
controlWord <= s_contorlWord;
end rtl;