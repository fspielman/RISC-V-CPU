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

		-- lw x5, 0(x7)
		1 => x"0003A283",

		-- add x4, x5, x6
		2 => x"00628233", 
		
		-- add x7, x4, x8
		3 => x"008203b3",
		
		-- add x3, x4, x5
		4 => x"005201b3",
		
		-- add x16, x17, x18
		5 => x"01288833",
		
		-- add x15, x19, x16
		6 => x"010987b3",
		
		-- add x21, x20, x16
		7 => x"010a0ab3",
		
		-- beq x30, x31, -32
		8 => x"ffff00e3",
		
		-- add x15, x19, x16
		9 => x"010987b3",
		
		-- add x21, x20, x16
		10 => x"010a0ab3",
		
		others => (others => '0')
	);

begin

  -- divide by 4 for word alligned (byte alligned pc -> word aligned)
  -- (6 to 2 for 32 instructions => 2^5=32) 
  instruction <= rom(to_integer(unsigned(address(6 downto 2))));

end architecture instr_mem_arch;

