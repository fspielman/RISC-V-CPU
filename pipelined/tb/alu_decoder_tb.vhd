library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity alu_decoder_tb is
  end entity alu_decoder_tb;

architecture alu_dec_tb of alu_decoder_tb is

  signal alu_op: std_logic_vector(1 downto 0);
  signal funct3: std_logic_vector(2 downto 0);
  signal funct7: std_logic_vector(6 downto 0);
  signal branch: std_logic;
  signal alu_ctrl: std_logic_vector(3 downto 0);

begin

  alu_dec: alu_decoder port map(
   alu_op, 
	 funct3, 
	 funct7, 
	 branch, 
	 alu_ctrl
  );

	process
	begin

		-- branch
		branch <= '1';
		wait for 10 ns;
		assert alu_ctrl = "0001" report "branch error" severity error;

		branch <= '0';

		-- lw / sw
		alu_op <= "00";
		wait for 10 ns;
		assert alu_ctrl = "0000" report "lw / sw error" severity error;

		-- add / addi
		alu_op <= "10";
		funct3 <= "000";
		funct7(5) <= '0';
		wait for 10 ns;
		assert alu_ctrl = "0000" report "add / addi error" severity error;

		-- sub / subi
		alu_op <= "10";
		funct3 <= "000";
		funct7(5) <= '1';
		wait for 10 ns;
		assert alu_ctrl = "0001" report "sub / subi error" severity error;

		-- sll / slli
		alu_op <= "10";
		funct3 <= "001";
		wait for 10 ns;
		assert alu_ctrl = "0010" report "sll / slli error" severity error;

		-- slt / slti
		alu_op <= "10";
		funct3 <= "010";
		wait for 10 ns;
		assert alu_ctrl = "0011" report "slt / slti error" severity error;

		-- sltu / sltiu
		alu_op <= "10";
		funct3 <= "011";
		wait for 10 ns;
		assert alu_ctrl = "0100" report "sltu / sltiu error" severity error;

		-- xor / xori
		alu_op <= "10";
		funct3 <= "100";
		wait for 10 ns;
		assert alu_ctrl = "0101" report "xor / xori error" severity error;

		-- srl / srli
		alu_op <= "10";
		funct3 <= "101";
		funct7(5) <= '0';
		wait for 10 ns;
		assert alu_ctrl = "0110" report "srl / srli error" severity error;

		-- sra / srai
		alu_op <= "10";
		funct3 <= "101";
		funct7(5) <= '1';
		wait for 10 ns;
		assert alu_ctrl = "0111" report "sra / srai error" severity error;

		-- or / ori
		alu_op <= "10";
		funct3 <= "110";
		wait for 10 ns;
		assert alu_ctrl = "1000" report "or / ori error" severity error;

		-- and / andi
		alu_op <= "10";
		funct3 <= "111";
		wait for 10 ns;
		assert alu_ctrl = "1001" report "and / andi error" severity error;
	end process;

end architecture alu_dec_tb;
