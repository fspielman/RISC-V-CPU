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
		1 => x"0003A283",  -- x7=5, loads from byte address 5 -> ram[1]=13 index: 5/4=1 -> x5=13

		-- add x4, x5, x6
		2 => x"00628233", -- x4 = 13 + 4 = 17
		
		-- add x7, x4, x8 -- x7 = 17 + 10 = 27
		3 => x"008203b3",
		
		-- add x3, x4, x5
		4 => x"005201b3", -- x3 = 17 + 13 = 30
		
		-- add x16, x17, x18
		5 => x"01288833", -- x16 = 12 + 6 = 18
		
		-- add x15, x19, x16
		6 => x"010987b3", -- x15 = 7 + 18 = 25
		
		-- add x21, x20, x16
		7 => x"010a0ab3", -- x21 = 8 + 18 = 26
		
		-- beq x30, x31, -32
		8 => x"ffff00e3", -- x30 = x31 = 15 -> branch taken (jumps back 7 instructions) -> control hazard
		
		-- add x15, x19, x16
		9 => x"010987b3",	-- control hazard -> gets flushed
		
		-- add x21, x20, x16
		10 => x"010a0ab3", -- control hazard -> gets flushed 
		
		others => (others => '0')
	);

begin

  -- divide by 4 for word alligned (byte alligned pc -> word aligned)
  -- (6 to 2 for 32 instructions => 2^5=32) 
  instruction <= rom(to_integer(unsigned(address(6 downto 2))));

end architecture instr_mem_arch;

