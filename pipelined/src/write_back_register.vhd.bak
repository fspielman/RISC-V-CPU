library ieee;
use ieee.std_logic_1164.all;

entity write_back_register is
  port(
    clk: in std_logic;
    alu_result: in std_logic_vector(31 downto 0);
    read_data_mem: in std_logic_vector(31 downto 0);
    pc_plus4: in std_logic_vector(31 downto 0);
	 
		result_src_mem: in std_logic_vector(1 downto 0);
    mem_write_mem: in std_logic;
    reg_write_mem: in std_logic;
    
    alu_result_wb: out std_logic_vector(31 downto 0);
    read_data_mem_wb: out std_logic_vector(31 downto 0);
    pc_plus4_wb: out std_logic_vector(31 downto 0);
	 
		result_src_wb: out std_logic_vector(1 downto 0);
		reg_write_wb: out std_logic
  );
end entity write_back_register;

architecture wb_reg_arch of write_back_register is
  
begin
  process(clk)
  begin
    if rising_edge(clk) then
      alu_result_wb <= alu_result;
      read_data_mem_wb <= read_data_mem;
      pc_plus4_wb <= pc_plus4;
		
			result_src_wb <= result_src_mem;
			reg_write_wb <= reg_write_mem;
    end if;
  end process;
  
end architecture wb_reg_arch;
