library ieee;
use ieee.std_logic_1164.all;

entity execute_register is
  port(
    clk: in std_logic;
    alu_result: in std_logic_vector(31 downto 0);
    write_data: in std_logic_vector(31 downto 0);
    pc_plus4: in std_logic_vector(31 downto 0);
	 
    result_src_ex: in std_logic_vector(1 downto 0);
    mem_write_ex: in std_logic;
    reg_write_ex: in std_logic;
    
    alu_result_mem: out std_logic_vector(31 downto 0);
    write_data_mem: out std_logic_vector(31 downto 0);
    pc_plus4_mem: out std_logic_vector(31 downto 0);
	 
		result_src_mem: out std_logic_vector(1 downto 0);
    mem_write_mem: out std_logic;
    reg_write_mem: out std_logic
  );
end entity execute_register;

architecture ex_reg_arch of execute_register is
  
begin
  process(clk)
  begin
    if rising_edge(clk) then
      alu_result_mem <= alu_result;
      write_data_mem <= write_data;
      pc_plus4_mem <= pc_plus4;
		
			result_src_mem <= result_src_ex;
			mem_write_mem <= mem_write_ex;
			reg_write_mem <= reg_write_ex;
    end if;
  end process;

end architecture ex_reg_arch;
