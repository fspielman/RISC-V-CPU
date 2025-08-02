library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port(
		clk: in std_logic;
		reg_write: in std_logic;
		source1: in std_logic_vector(4 downto 0);
		source2: in std_logic_vector(4 downto 0);
		dest: in std_logic_vector(4 downto 0);
		write_data: in std_logic_vector(31 downto 0);

    read_data1: out std_logic_vector(31 downto 0);
		read_data2: out std_logic_vector(31 downto 0)
	);
end entity register_file;

architecture reg_file_arch of register_file is

  type registers is array(31 downto 0) of std_logic_vector(31 downto 0);
  signal reg : registers := (
		4 => std_logic_vector(to_unsigned(2, 32)),  -- x4 = 2
		6 => std_logic_vector(to_unsigned(4, 32)),  -- x6 = 4
		7 => std_logic_vector(to_unsigned(5, 32)),  -- x7 = 5
		8 => std_logic_vector(to_unsigned(10, 32)),  -- x8 = 10
		17 => std_logic_vector(to_unsigned(12, 32)), -- x17 = 12
		18 => std_logic_vector(to_unsigned(6, 32)),  -- x18 = 6
		19 => std_logic_vector(to_unsigned(7, 32)),  -- x19 = 7
		20 => std_logic_vector(to_unsigned(8, 32)),  -- x20 = 8
		30 => std_logic_vector(to_unsigned(15, 32)),  -- x30 = 15
		31 => std_logic_vector(to_unsigned(15, 32)),  -- x31 = 15	
		others => (others => '0')
	);

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- write to destination register when reg_write = 1 
      -- dont want to write to x0 (zero register)
      if(reg_write = '1' and dest /= b"00000") then
        reg(to_integer(unsigned(dest))) <= write_data;
      end if;
    end if;
  end process;

  read_data1 <= reg(to_integer(unsigned(source1)));
  read_data2 <= reg(to_integer(unsigned(source2)));

end architecture reg_file_arch;
