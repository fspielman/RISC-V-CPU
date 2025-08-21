library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_mem is
  port(
        address: in std_logic_vector(31 downto 0);

        instruction: out std_logic_vector(31 downto 0)
      );
end entity instruction_mem;

architecture instr_mem_arch of instruction_mem is 

  type memory is array(0 to 31) of std_logic_vector(31 downto 0);

  signal rom : memory := (
		-- addi x0, x0, 0
		0 => x"00000013", -- nop

		-- or x4, x5, x6 
		1 => x"0062E233",

		-- add x18,x19,x20 
		2 => x"01498933",

		-- sub x5, x6, x7 
		3 => x"407302B3",

		-- jal (instruction 8) jumps back here
		-- addi x4 x5 23 
		4 => x"01728213",

		-- andi x0, x0, 0 
		5 => x"00007013",

		-- lw   x5, 0(x7)
		6 => x"0003A283",

		-- sw   x4, 4(x7) 
		7 => x"0043a223",

		-- beq x7, x4, 4 
		8 => x"00438263",

		-- jal  x1, -20 
		9 => x"fedff0ef",

		-- beq x8, x9, -12 
		-- 9 => x"fe940ae3",

		others => (others => '0')
	);

begin

  -- divide by 4 for word alligned (byte alligned pc -> word aligned)
  -- (6 to 2 for 32 instructions => 2^5=32) 
  instruction <= rom(to_integer(unsigned(address(6 downto 2))));

end architecture instr_mem_arch;

