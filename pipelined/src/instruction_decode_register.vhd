library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode_register is
  port(
    clk: in std_logic;
	 flush: in std_logic;
    read_data1: in std_logic_vector(31 downto 0);
    read_data2: in std_logic_vector(31 downto 0);
    pc: in std_logic_vector(31 downto 0);
    imm_ext: in std_logic_vector(31 downto 0);
    pc_plus4: in std_logic_vector(31 downto 0);
	 source1: in std_logic_vector(4 downto 0);
	 source2: in std_logic_vector(4 downto 0);
	 dest: in std_logic_vector(4 downto 0);

    branch: in std_logic;
    jump: in std_logic;
    result_src: in std_logic_vector(1 downto 0);
    mem_write: in std_logic;
    alu_ctrl: in std_logic_vector(3 downto 0);
    alu_src: in std_logic;
    imm_src: in std_logic_vector(1 downto 0);
    reg_write: in std_logic;

    read_data1_ex: out std_logic_vector(31 downto 0);
    read_data2_ex: out std_logic_vector(31 downto 0);
    pc_ex: out std_logic_vector(31 downto 0);
    imm_ext_ex: out std_logic_vector(31 downto 0);
    pc_plus4_ex: out std_logic_vector(31 downto 0);
	 source1_ex: out std_logic_vector(4 downto 0);
	 source2_ex: out std_logic_vector(4 downto 0);
	 dest_ex: out std_logic_vector(4 downto 0);
    
    branch_ex: out std_logic;
    jump_ex: out std_logic;
    result_src_ex: out std_logic_vector(1 downto 0);
    mem_write_ex: out std_logic;
    alu_ctrl_ex: out std_logic_vector(3 downto 0);
    alu_src_ex: out std_logic;
    reg_write_ex: out std_logic
  );
end entity instruction_decode_register;

architecture id_reg_arch of instruction_decode_register is
  
begin
  process(clk)
  begin
    if rising_edge(clk) then
			if flush = '1' then
				read_data1_ex <= (others => '0');
				read_data2_ex <= (others => '0');
				pc_ex <= (others => '0');
				imm_ext_ex <= (others => '0');
				pc_plus4_ex <= (others => '0');
				source1_ex <= (others => '0');
				source2_ex <= (others => '0');
				dest_ex <= (others => '0');

				branch_ex <= '0';
				jump_ex <= '0';
				result_src_ex <= (others => '0');
				mem_write_ex <= '0';
				alu_ctrl_ex <= (others => '0');
				alu_src_ex <= '0';
				reg_write_ex <= '0';
			else 
				read_data1_ex <= read_data1;
				read_data2_ex <= read_data2;
				pc_ex <= pc;
				imm_ext_ex <= imm_ext;
				pc_plus4_ex <= pc_plus4;
				source1_ex <= source1;
				source2_ex <= source2;
				dest_ex <= dest;

				branch_ex <= branch;
				jump_ex <= jump;
				result_src_ex <= result_src;
				mem_write_ex <= mem_write;
				alu_ctrl_ex <= alu_ctrl;
				alu_src_ex <= alu_src;
				reg_write_ex <= reg_write;
			end if;
    end if;
  end process;
  
end architecture id_reg_arch;
