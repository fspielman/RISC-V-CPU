library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity main_decoder_tb is
  end entity main_decoder_tb;

architecture main_dec_tb_arch of main_decoder_tb is

  signal opcode: std_logic_vector(6 downto 0);
  signal branch: std_logic;
  signal jump: std_logic;
  signal result_src: std_logic_vector(1 downto 0);
  signal mem_write: std_logic;
  signal alu_src: std_logic;
  signal imm_src: std_logic_vector(1 downto 0);
  signal reg_write: std_logic;
  signal alu_op: std_logic_vector(1 downto 0);


  procedure signal_check(
		sig_reg_write: std_logic;
		sig_imm_src: std_logic_vector(1 downto 0);
		sig_alu_src: std_logic;
		sig_mem_write: std_logic;
		sig_result_src: std_logic_vector(1 downto 0);
		sig_branch: std_logic;
		sig_jump: std_logic;
		sig_alu_op: std_logic_vector(1 downto 0);
		lbl: string
	) is
  begin
    assert reg_write = sig_reg_write report lbl & " reg_write error" severity error;
    assert imm_src = sig_imm_src report lbl & " imm_src error" severity error;
    assert alu_src = sig_alu_src report lbl & " alu_src error" severity error;
    assert mem_write = sig_mem_write report lbl & " mem_write error" severity error;
    assert result_src = sig_result_src report lbl & " result_src error" severity error;
    assert branch = sig_branch report lbl & " branch error" severity error;
    assert jump = sig_jump report lbl & " jump error" severity error;
    assert alu_op = sig_alu_op report lbl & " alu_op error" severity error; 
  end procedure signal_check;

begin

  main_dec : main_decoder port map(
		opcode,
		branch,
		jump,
		result_src,
		mem_write,
		alu_src,
		imm_src,
		reg_write,
		alu_op
	);

	process
	begin
		-- lw
		opcode <= "0000011";
		wait for 10 ns;
		signal_check('1', "00", '1', '0', "01", '0', '0', "00", "lw");

		-- sw
		opcode <= "0100011";
		wait for 10 ns;
		signal_check('0', "01", '1', '1', "00", '0', '0', "00", "sw");

		-- R-type
		opcode <= "0110011";
		wait for 10 ns;
		signal_check('1', "00", '0', '0', "00", '0', '0', "10", "R-type");

		-- I-type ALU
		opcode <= "0010011";
		wait for 10 ns;
		signal_check('1', "00", '1', '0', "00", '0', '0', "10", "I-type ALU");

		-- jal
		opcode <= "1101111";
		wait for 10 ns;
		signal_check('1', "11", '1', '0', "10", '0', '1', "00", "jal");

		-- beq
		opcode <= "1100011";
		wait for 10 ns;
		signal_check('0', "10", '0', '0', "00", '1', '0', "01", "beq");

		-- Default / unknown opcode
		opcode <= "1111111"; -- unknown opcode
		wait for 10 ns;
		signal_check('0', "00", '0', '0', "00", '0', '0', "10", "default");
	end process;

end architecture main_dec_tb_arch;
