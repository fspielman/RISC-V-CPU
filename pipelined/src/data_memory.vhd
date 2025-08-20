library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
  port(
    clk: in std_logic;
	 address: in std_logic_vector(31 downto 0);
	 write_en: in std_logic;
	 write_data: in std_logic_vector(31 downto 0);

    read_data: out std_logic_vector(31 downto 0)
  );
end entity data_memory;

architecture data_mem_arch of data_memory is

  type memory is array(0 to 31) of std_logic_vector(31 downto 0);
		signal ram: memory := (
		1 => std_logic_vector(to_unsigned(13,32)),
		others => (others => '0')
  );

begin
  process(clk)
  begin
    if rising_edge(clk) then 
      -- sw -> writes data from register into memory 
      if write_en = '1' then
        -- 6 downto 2 for word allignment
        ram(to_integer(unsigned(address(6 downto 2)))) <= write_data;
      end if;
    end if;
  end process;


  -- read from memory
  -- 6 downto 2 for word allignment
  read_data <= ram(to_integer(unsigned(address(6 downto 2))));

end architecture data_mem_arch;
