library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instruction_reg is
generic ( number_bit : integer := 32);
port ( inst : out std_logic_vector(number_bit -1 downto 0) := (others => '0');
		 pc	: in std_logic_vector(number_bit -1 downto 0);
		 clk_in : in std_logic;
		 address : in std_logic_vector(7 downto 0);
		 data : in std_logic_vector(7 downto 0);
		 test_data : out std_logic_vector(7 downto 0);
		 program, start, reset : in std_logic);
end instruction_reg;

architecture rtl of instruction_reg is
type reg_type is array(0 to (2**8)-1) of std_logic_vector((number_bit/4) -1 downto 0);
signal inst_reg : reg_type := (others =>(others=>'0'));
--// instruction => 31 - 25 --- 24 - 20 --- 19 - 15 --- 14 - 12 --- 11 - 7 --- 6 - 0
--//  reg-reg        func7        rs2          rs1        func3      rd        opcode
--//  one immediate      imm[11:0]			     rs1        func3      rd        opcode
--//    load				 imm[11:0]				  rs1		    func3		rd		    opcode
--//    store			imm[11:5]	 rs2			  rs1		 	 func3	  imm[4:0]	 opcode
--//     branch   imm[12|10:5]	 rs2			  rs1		    func3	imm[4:1|11]  opcode

--signal inst1 : std_logic_vector(31 downto 0) := b"00000000101000001000000010010011";
--signal inst2 : std_logic_vector(31 downto 0) := b"00000000001000001000000101100111";
--signal inst3 : std_logic_vector(31 downto 0) := b"00000000000100010001000110010011";
--signal inst4 : std_logic_vector(31 downto 0) := b"00000000101000011000000110010011";
--signal inst5 : std_logic_vector(31 downto 0) := b"00000000000100001000010001100011";
--signal inst6 : std_logic_vector(31 downto 0) := b"00000000010100001010001000000011";
--signal inst7 : std_logic_vector(31 downto 0) := b"00000000101000001010001000000011";
--signal inst8 : std_logic_vector(31 downto 0) := b"00000000000000001010001000000011";
--signal inst9 : std_logic_vector(31 downto 0) := b"00000000000000001010001000000011";
--signal inst10 : std_logic_vector(31 downto 0) := b"00000000000000001010001000000011";
--signal inst11 : std_logic_vector(31 downto 0) := b"00000000000000001010001000000011";
--signal inst12 : std_logic_vector(31 downto 0) := b"00000000000000001010001000000011";
begin
--alu instruction 2 registors opcode = 0110000, alu function = func7[30]+func3
--alu instruction 1 reg and 1 immediate opcode = 0010000 , alu function = func3(for shift, fun7[30]+func3)
--load instruction opcode = 0000011 , func3 = 010,
--store instruction opcode = 0100011, func3 = 010,
--branch instruction opcode = 1100011, branch condition = func3
--inst_reg(0) <= inst1(7 downto 0); inst_reg(1) <= inst1(15 downto 8);
--inst_reg(2) <= inst1(23 downto 16); inst_reg(3) <= inst1(31 downto 24);

--inst_reg(4) <= inst2(7 downto 0); inst_reg(5) <= inst2(15 downto 8);
--inst_reg(6) <= inst2(23 downto 16); inst_reg(7) <= inst2(31 downto 24);

--inst_reg(8) <= inst3(7 downto 0); inst_reg(9) <= inst3(15 downto 8);
--inst_reg(10) <= inst3(23 downto 16); inst_reg(11) <= inst3(31 downto 24);

--inst_reg(12) <= inst4(7 downto 0); inst_reg(13) <= inst4(15 downto 8);
--inst_reg(14) <= inst4(23 downto 16); inst_reg(15) <= inst4(31 downto 24);

--inst_reg(16) <= inst5(7 downto 0); inst_reg(17) <= inst5(15 downto 8);
--inst_reg(18) <= inst5(23 downto 16); inst_reg(19) <= inst5(31 downto 24);

--inst_reg(20) <= inst6(7 downto 0); inst_reg(21) <= inst6(15 downto 8);
--inst_reg(22) <= inst6(23 downto 16); inst_reg(23) <= inst6(31 downto 24);

--inst_reg(24) <= inst7(7 downto 0); inst_reg(25) <= inst7(15 downto 8);
--inst_reg(26) <= inst7(23 downto 16); inst_reg(27) <= inst7(31 downto 24);

--inst_reg(28) <= inst8(7 downto 0); inst_reg(29) <= inst8(15 downto 8);
--inst_reg(30) <= inst8(23 downto 16); inst_reg(31) <= inst8(31 downto 24);

--inst_reg(32) <= inst9(7 downto 0); inst_reg(33) <= inst9(15 downto 8);
--inst_reg(34) <= inst9(23 downto 16); inst_reg(35) <= inst9(31 downto 24);

--inst_reg(36) <= inst10(7 downto 0); inst_reg(37) <= inst10(15 downto 8);
--inst_reg(38) <= inst10(23 downto 16); inst_reg(39) <= inst10(31 downto 24);

--inst_reg(40) <= inst11(7 downto 0); inst_reg(41) <= inst11(15 downto 8);
--inst_reg(42) <= inst11(23 downto 16); inst_reg(43) <= inst11(31 downto 24);

--inst_reg(44) <= inst12(7 downto 0); inst_reg(45) <= inst12(15 downto 8);
--inst_reg(46) <= inst12(23 downto 16); inst_reg(47) <= inst12(31 downto 24);

program_proc : process (program, reset) is
begin
	if (reset = '0') then
		inst_reg <= (others => (others => '0'));
	elsif (rising_edge(program)) then
		inst_reg(to_integer(unsigned(address))) <= data;
	end if;
end process;
test_data <= inst_reg(0);
process (clk_in, start) is
begin
	if (start = '1') then
		if (rising_edge(clk_in)) then
			inst <= inst_reg(to_integer(unsigned(pc+"11"))) & inst_reg(to_integer(unsigned(pc+"10"))) & inst_reg(to_integer(unsigned(pc + '1'))) & inst_reg(to_integer(unsigned(pc)));
		end if;
	else inst <= (others => '0');
	end if;
end process;
end rtl;