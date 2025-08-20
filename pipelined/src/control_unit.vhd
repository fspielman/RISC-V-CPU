library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity control_unit is
  port(
		opcode: in std_logic_vector(6 downto 0);
      funct3: in  std_logic_vector(2 downto 0);
		funct7: in  std_logic_vector(6 downto 0);

		branch: out std_logic;
		jump: out std_logic;
		result_src: out std_logic_vector(1 downto 0);
		mem_write: out std_logic;
		alu_ctrl: out std_logic_vector(3 downto 0);
		alu_src: out std_logic;
		imm_src: out std_logic_vector(1 downto 0);
		reg_write: out std_logic
	);
end entity control_unit;

architecture control_unit_arch of control_unit is

  signal branch_sig: std_logic;
  signal alu_op: std_logic_vector(1 downto 0);
	
begin

  m_dec: main_decoder port map(
		opcode,
		branch_sig,
		jump,
		result_src,
		mem_write,
		alu_src,
		imm_src,
		reg_write,
		alu_op
	);
	
	alu_dec: alu_decoder port map(
		alu_op,
		funct3,
		funct7,
		branch_sig,
		alu_ctrl
	);		

  branch <= branch_sig;

end architecture control_unit_arch;
