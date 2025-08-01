library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
  port(
		clk: in std_logic;
		pc_src: in std_logic;
		pc_target: in std_logic_vector(31 downto 0); 
		pc_plus4: in std_logic_vector(31 downto 0); 
		
		pc: out std_logic_vector(31 downto 0)
	);
end entity program_counter;

architecture pc_arch of program_counter is

  signal pc_reg: std_logic_vector(31 downto 0) := (others => '0');

begin
  process(clk)
  begin
    if rising_edge(clk) then
      if pc_src = '1' then
        pc_reg <= pc_target;
      else
        pc_reg <= pc_plus4;
      end if;
    end if;
  end process;

  pc <= pc_reg;

end architecture pc_arch;
