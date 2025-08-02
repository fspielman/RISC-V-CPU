library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity instruction_fetch_register is
  port(
    clk: in std_logic;
		stall: in std_logic;
		flush: in std_logic;
    instruction: in std_logic_vector(31 downto 0);
    pc_plus4: in std_logic_vector(31 downto 0);

    instruction_id: out std_logic_vector(31 downto 0);
    pc_plus4_id: out std_logic_vector(31 downto 0)
  );
end entity instruction_fetch_register;

architecture if_arch of instruction_fetch_register is
  
begin
  process(clk)
  begin
    if rising_edge(clk) then
			if flush = '1' then
				instruction_id <= (others => '0');
				pc_plus4_id <= (others => '0');
			elsif stall = '0' then
				instruction_id <= instruction;
				pc_plus4_id <= pc_plus4;
			end if;
		end if; 
  end process;

end architecture if_arch;