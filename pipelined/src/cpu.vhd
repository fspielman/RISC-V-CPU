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

  signal zero: std_logic;

  signal imm_ext: std_logic_vector(31 downto 0);
  signal sel_sourceB: std_logic_vector(31 downto 0);
  signal alu_sourceA: std_logic_vector(31 downto 0);
  signal alu_sourceB: std_logic_vector(31 downto 0);
	
  signal read_data_mem: std_logic_vector(31 downto 0);
  signal write_back: std_logic_vector(31 downto 0);

  signal pc_src: std_logic;
  signal pc_target: std_logic_vector(31 downto 0); 
  signal pc: std_logic_vector(31 downto 0) := (others => '0');

  signal pc_plus4: std_logic_vector(31 downto 0);
	
	-- pipelined signals
  signal instruction_id: std_logic_vector(31 downto 0);
  signal pc_plus4_id: std_logic_vector(31 downto 0);
	
  signal read_data1_ex: std_logic_vector(31 downto 0);
  signal read_data2_ex: std_logic_vector(31 downto 0);
  signal pc_ex: std_logic_vector(31 downto 0);
  signal imm_ext_ex: std_logic_vector(31 downto 0);
  signal pc_plus4_ex: std_logic_vector(31 downto 0);
  signal source1_ex: std_logic_vector(4 downto 0);
  signal source2_ex: std_logic_vector(4 downto 0);
  signal dest_ex: std_logic_vector(4 downto 0);
  signal branch_ex: std_logic;
  signal jump_ex: std_logic;
  signal result_src_ex: std_logic_vector(1 downto 0);
  signal mem_write_ex: std_logic;
  signal alu_ctrl_ex: std_logic_vector(3 downto 0);
  signal alu_src_ex: std_logic;
  signal reg_write_ex: std_logic;
  signal alu_result_ex: std_logic_vector(31 downto 0); 
	    
  signal alu_result_mem: std_logic_vector(31 downto 0);
  signal write_data_mem: std_logic_vector(31 downto 0);
  signal pc_plus4_mem: std_logic_vector(31 downto 0);
  signal dest_mem: std_logic_vector(4 downto 0);
  signal result_src_mem: std_logic_vector(1 downto 0);
  signal mem_write_mem: std_logic;
  signal reg_write_mem: std_logic;
	
  signal alu_result_wb: std_logic_vector(31 downto 0);
  signal read_data_mem_wb: std_logic_vector(31 downto 0);
  signal pc_plus4_wb: std_logic_vector(31 downto 0);	 
  signal dest_wb: std_logic_vector(4 downto 0);
  signal result_src_wb: std_logic_vector(1 downto 0);
  signal reg_write_wb: std_logic;
	
  -- hazard unit
  signal forward_1: std_logic_vector(1 downto 0);
  signal forward_2: std_logic_vector(1 downto 0);
  signal stall_if_id: std_logic;
  signal flush_if_id: std_logic;
  signal flush_id_ex: std_logic;
  signal stall_pc: std_logic;
		
begin

  instruction_memory: instruction_mem port map(
	  pc,
	  instruction
  );
	
	if_id_reg: if_id_register port map(
		clk,
		stall_if_id,
		flush_if_id,
		instruction,
		pc_plus4,
		instruction_id,
		pc_plus4_id
	);

	source1 <= instruction_id(19 downto 15);
	source2 <= instruction_id(24 downto 20);
	dest <= instruction_id(11 downto 7);

	reg_file: register_file port map(
		clk,
		reg_write_wb,
		source1, 
		source2, 
		dest_wb,	
		write_back,
		read_data1,
		read_data2
	);

	opcode <= instruction_id(6 downto 0);
	funct3 <= instruction_id(14 downto 12);
	funct7 <= instruction_id(31 downto 25);

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
		instruction_id(31 downto 7),
		imm_src,
		imm_ext
	);
	
	id_ex_reg: id_ex_register port map(
		clk,
		flush_id_ex,
		read_data1,
		read_data2,
		pc,
		imm_ext,
		pc_plus4_id,
		source1,
		source2,
		dest,
		branch,
		jump,
		result_src,
		mem_write,
		alu_ctrl,
		alu_src,
		imm_src,
		reg_write,
		read_data1_ex,
		read_data2_ex,
		pc_ex,
		imm_ext_ex,
		pc_plus4_ex,
		source1_ex,
		source2_ex,
		dest_ex,
		branch_ex,
		jump_ex,
		result_src_ex,
		mem_write_ex,
		alu_ctrl_ex,
		alu_src_ex,
		reg_write_ex
	);
	
	sel_sourceB <= alu_sourceB when alu_src_ex = '0' else imm_ext_ex;
	
	arithmetic_logic_unit: alu port map(
		alu_sourceA,
		sel_sourceB,
		alu_ctrl_ex,
		alu_result_ex,
		zero
	);

	ex_mem_reg: ex_mem_register port map(
		clk,
		alu_result_ex,
		read_data2_ex,
		pc_plus4_ex,
		dest_ex,
		result_src_ex,
		mem_write_ex,
		reg_write_ex,
		alu_result_mem,
		write_data_mem,
		pc_plus4_mem,
		dest_mem,
		result_src_mem,
		mem_write_mem,
		reg_write_mem
   );
	
	data_mem: data_memory port map(
		clk,
		alu_result_mem,
		mem_write_mem,
		write_data_mem,
		read_data_mem
	);

  mem_wb_reg: mem_wb_register port map(
	  clk,
	  alu_result_mem,
	  read_data_mem,
	  pc_plus4_mem,
	  dest_mem,
	  result_src_mem,
	  mem_write_mem,
	  reg_write_mem,
	  alu_result_wb,
	  read_data_mem_wb,
	  pc_plus4_wb,
	  dest_wb,
	  result_src_wb,
	  reg_write_wb
  );
	
	write_back_mux: mux3to1  port map(
		result_src_wb,
		alu_result_wb,
		read_data_mem_wb,
		pc_plus4_wb,
		write_back
	);

	pc_target <= std_logic_vector(unsigned(imm_ext_ex) + unsigned(pc_ex));

	pc_src <= (branch_ex and zero) or jump_ex;

	pc_plus4 <= std_logic_vector(unsigned(pc) + 4);

	pc_handler: program_counter port map(
		clk, 
		stall_pc,
		pc_src,
		pc_target,
		pc_plus4,
		pc
	);
	
	haz_unit: hazard_unit port map(
		source1,
		source2,
		source1_ex,
		source2_ex,
		dest_ex,
		result_src_ex,
		pc_src,
		reg_write_mem,
		reg_write_wb,
		dest_mem,
		dest_wb,
			
		forward_1,
		forward_2,
		stall_if_id,
		flush_if_id,
		flush_id_ex,
		stall_pc
	);
	
	hazard_source1_mux: mux3to1 port map(
		forward_1,
		read_data1_ex,
		alu_result_mem,
		write_back,
		alu_sourceA
	);
	
	hazard_source2_mux: mux3to1 port map(
		forward_2,
		read_data2_ex,
		alu_result_mem,
		write_back,
		alu_sourceB
	);

end architecture cpu_arch;




