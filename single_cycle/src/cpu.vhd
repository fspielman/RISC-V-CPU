library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity cpu is
  port(
        clk: in std_logic	
      );
end entity cpu;

architecture cpu_arch of cpu is

  signal instruction: std_logic_vector(31 downto 0);

  signal reg_write: std_logic;
  signal source1: std_logic_vector(4 downto 0);
  signal source2: std_logic_vector(4 downto 0);
  signal dest: std_logic_vector(4 downto 0);
  signal read_data1: std_logic_vector(31 downto 0);
  signal read_data2: std_logic_vector(31 downto 0);

  signal opcode: std_logic_vector(6 downto 0);
  signal funct3: std_logic_vector(2 downto 0);
  signal funct7: std_logic_vector(6 downto 0);
  signal branch: std_logic;
  signal jump: std_logic;
  signal result_src: std_logic_vector(1 downto 0);
  signal mem_write: std_logic;
  signal alu_ctrl: std_logic_vector(3 downto 0);
  signal alu_src: std_logic;
  signal imm_src: std_logic_vector(1 downto 0);

  signal alu_result: std_logic_vector(31 downto 0);
  signal zero: std_logic;

  signal imm_ext: std_logic_vector(31 downto 0);
  signal sel_sourceB: std_logic_vector(31 downto 0);

  signal read_data_mem: std_logic_vector(31 downto 0);
  signal write_back: std_logic_vector(31 downto 0);

  signal pc_src: std_logic;
  signal pc_target: std_logic_vector(31 downto 0); 
  signal pc: std_logic_vector(31 downto 0) := (others => '0');

  signal pc_plus4: std_logic_vector(31 downto 0);

begin

  instruction_memory: instruction_mem port map(
	  pc,
	  instruction
  );

	source1 <= instruction(19 downto 15);
	source2 <= instruction(24 downto 20);
	dest <= instruction(11 downto 7);

	reg_file: register_file port map(
		clk,
		reg_write,
		source1, 
		source2, 
		dest,	
		write_back,
		read_data1,
		read_data2
	);

	opcode <= instruction(6 downto 0);
	funct3 <= instruction(14 downto 12);
	funct7 <= instruction(31 downto 25);

	cntrl_unit: control_unit port map(
		opcode,
		funct3,
		funct7,
		branch,
		jump,
		result_src,
		mem_write,
		alu_ctrl,
		alu_src,
		imm_src,
		reg_write
	);

	extend: sign_extender port map(
		instruction(31 downto 7),
		imm_src,
		imm_ext
	);

	sel_sourceB <= read_data2 when alu_src = '0' else imm_ext;
	
	arithmetic_logic_unit: alu port map(
		read_data1,
		sel_sourceB,
		alu_ctrl,
		alu_result,
		zero
	);

	data_mem: data_memory port map(
		clk,
		alu_result,
		mem_write,
		read_data2,
		read_data_mem
	);

	mux: write_back_mux  port map(
		result_src,
		alu_result,
		read_data_mem,
		pc_plus4,
		write_back
	);

	pc_target <= std_logic_vector(unsigned(imm_ext) + unsigned(pc));

	pc_src <= (branch and zero) or jump;

	pc_plus4 <= std_logic_vector(unsigned(pc) + 4);

	pc_handler: program_counter port map(
		clk, 
		pc_src,
		pc_target,
		pc_plus4,
		pc
	);


end architecture cpu_arch;




