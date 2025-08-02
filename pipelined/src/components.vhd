library ieee;
use ieee.std_logic_1164.all;

package components is

  component instruction_mem is
    port(
			address: in std_logic_vector(31 downto 0);

      instruction: out std_logic_vector(31 downto 0)
		);
  end component;

  component register_file is
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
  end component;

  component control_unit is
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
  end component;

  component alu is
    port(
			sourceA: in std_logic_vector(31 downto 0);
			sourceB: in std_logic_vector(31 downto 0);
			alu_ctrl: in std_logic_vector(3 downto 0);

      alu_result: out std_logic_vector(31 downto 0);
      zero: out std_logic
		);
  end component;

  component sign_extender is
    port(
			instruction: in std_logic_vector(31 downto 7);
			imm_src: in std_logic_vector(1 downto 0);

			extend: out std_logic_vector(31 downto 0)
		);
  end component;

  component data_memory is
    port(
			clk: in std_logic;
			address: in std_logic_vector(31 downto 0);
			write_en: in std_logic;
			write_data: in std_logic_vector(31 downto 0);

      read_data: out std_logic_vector(31 downto 0)
		);
  end component;

  component program_counter is
    port(
			clk: in std_logic;
			stall: in std_logic;
			pc_src: in std_logic;
			pc_target: in std_logic_vector(31 downto 0); 
			pc_plus4: in std_logic_vector(31 downto 0); 

			pc: out std_logic_vector(31 downto 0)
		);
  end component;

  component alu_decoder is
    port(
			alu_op: in std_logic_vector(1 downto 0);
			funct3: in std_logic_vector(2 downto 0);
			funct7: in std_logic_vector(6 downto 0);
			branch: in std_logic;

			alu_ctrl: out std_logic_vector(3 downto 0)
		);
  end component;

  component main_decoder is
    port(
			opcode: in std_logic_vector(6 downto 0);

			branch: out std_logic;
			jump: out std_logic;
			result_src: out std_logic_vector(1 downto 0);
			mem_write: out std_logic;
			alu_src: out std_logic;
			imm_src: out std_logic_vector(1 downto 0);
			reg_write: out std_logic;
			alu_op: out std_logic_vector(1 downto 0)
		);
  end component;

	component mux3to1  is
		port(
			sel: in std_logic_vector(1 downto 0);
			d0: in std_logic_vector(31 downto 0);
			d1: in std_logic_vector(31 downto 0);
			d2: in std_logic_vector(31 downto 0);

			y: out std_logic_vector(31 downto 0)
		);
	end component mux3to1;

  component cpu is
    port(
			clk: in std_logic	
		);
  end component cpu;
	
	component instruction_fetch_register is
		port(
			clk: in std_logic;
			stall: in std_logic;
			flush: in std_logic;
			instruction: in std_logic_vector(31 downto 0);
			pc_plus4: in std_logic_vector(31 downto 0);

			instruction_id: out std_logic_vector(31 downto 0);
			pc_plus4_id: out std_logic_vector(31 downto 0)
		);
	end component instruction_fetch_register;
	
	component instruction_decode_register is
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
	end component instruction_decode_register;
	
	component execute_register is
		port(
			clk: in std_logic;
			alu_result: in std_logic_vector(31 downto 0);
			write_data: in std_logic_vector(31 downto 0);
			pc_plus4: in std_logic_vector(31 downto 0);
			dest_ex: in std_logic_vector(4 downto 0);
		 
			result_src_ex: in std_logic_vector(1 downto 0);
			mem_write_ex: in std_logic;
			reg_write_ex: in std_logic;
			
			alu_result_mem: out std_logic_vector(31 downto 0);
			write_data_mem: out std_logic_vector(31 downto 0);
			pc_plus4_mem: out std_logic_vector(31 downto 0);
			dest_mem: out std_logic_vector(4 downto 0);
		 
			result_src_mem: out std_logic_vector(1 downto 0);
			mem_write_mem: out std_logic;
			reg_write_mem: out std_logic
		);
	end component execute_register;

	
	component write_back_register is
		port(
			clk: in std_logic;
			alu_result: in std_logic_vector(31 downto 0);
			read_data_mem: in std_logic_vector(31 downto 0);
			pc_plus4: in std_logic_vector(31 downto 0);
			dest_mem: in std_logic_vector(4 downto 0);
		 
			result_src_mem: in std_logic_vector(1 downto 0);
			mem_write_mem: in std_logic;
			reg_write_mem: in std_logic;
			
			alu_result_wb: out std_logic_vector(31 downto 0);
			read_data_mem_wb: out std_logic_vector(31 downto 0);
			pc_plus4_wb: out std_logic_vector(31 downto 0);
			dest_wb: out std_logic_vector(4 downto 0);
		 
			result_src_wb: out std_logic_vector(1 downto 0);
			reg_write_wb: out std_logic
		);
	end component write_back_register;
	
	component hazard_unit is
		port (
			source1_id: in std_logic_vector(4 downto 0);
			source2_id: in std_logic_vector(4 downto 0);
			source1_ex: in std_logic_vector(4 downto 0);
			source2_ex: in std_logic_vector(4 downto 0);
			dest_ex: in std_logic_vector(4 downto 0);
			result_src_ex: in std_logic_vector(1 downto 0);
			pc_src_ex: in std_logic;
			reg_write_mem: in std_logic;
			reg_write_wb: in std_logic;
			dest_mem: in std_logic_vector(4 downto 0);
			dest_wb: in std_logic_vector(4 downto 0);
			
			forward_1: out std_logic_vector(1 downto 0);
			forward_2: out std_logic_vector(1 downto 0);
			stall_if: out std_logic;
			flush_if: out std_logic;
			flush_id: out std_logic;
			stall_pc: out std_logic
		);
	end component hazard_unit;

end package;

