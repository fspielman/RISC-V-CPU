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
    port (
           clk: in std_logic;
           address: in std_logic_vector(31 downto 0);
           write_en: in std_logic;
           write_data: in std_logic_vector(31 downto 0);

           read_data: out std_logic_vector(31 downto 0)
         );
  end component;

  component program_counter is
    port (
           clk: in std_logic;
           pc_src: in std_logic;
           pc_target: in std_logic_vector(31 downto 0); 
           pc_plus4: in std_logic_vector(31 downto 0); 

           pc: out std_logic_vector(31 downto 0)
         );
  end component;

  component alu_decoder is
    port (
           alu_op: in std_logic_vector(1 downto 0);
           funct3: in std_logic_vector(2 downto 0);
           funct7: in std_logic_vector(6 downto 0);
           branch: in std_logic;

           alu_ctrl: out std_logic_vector(3 downto 0)
         );
  end component;

  component main_decoder is
    port (
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

  component write_back_mux is
    port(
          result_src: in std_logic_vector(1 downto 0); -- select
          alu_result: in std_logic_vector(31 downto 0);
          read_data_mem: in std_logic_vector(31 downto 0);
          pc_plus4: in std_logic_vector(31 downto 0);

          write_back: out std_logic_vector(31 downto 0)
        );
  end component;

  component cpu is
    port(
          clk: in std_logic	
        );
  end component cpu;

end package;

