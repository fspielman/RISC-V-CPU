library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity alu_tb is
  end alu_tb;

architecture alu_tb_arch of alu_tb is

  signal sourceA: std_logic_vector(31 downto 0);
  signal sourceB: std_logic_vector(31 downto 0);
  signal alu_ctrl: std_logic_vector(3 downto 0);
  signal alu_result: std_logic_vector(31 downto 0);
  signal zero: std_logic;

begin

  arith_log_unit: alu port map(
		sourceA,
		sourceB,
		alu_ctrl,
		alu_result,
		zero
	);

	process
	begin

		-- add
		alu_ctrl <= "0000";
		sourceA <= std_logic_vector(to_signed(3, sourceA'length));
		sourceB <= std_logic_vector(to_signed(2, sourceB'length));
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(5, alu_result'length))
		report "addition operation failed" severity error;

		-- sub
		alu_ctrl <= "0001";
		sourceA <= std_logic_vector(to_signed(3, sourceA'length));
		sourceB <= std_logic_vector(to_signed(2, sourceB'length));
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(1, alu_result'length))
		report "subtraction operation failed" severity error;

		-- sub with 0 flag
		alu_ctrl <= "0001";
		sourceA <= std_logic_vector(to_signed(2, sourceA'length));
		sourceB <= std_logic_vector(to_signed(2, sourceB'length));
		wait for 10 ns;
		assert zero = '1'
		report "zero flag failed to be set" severity error;

		-- sll
		alu_ctrl <= "0010";
		sourceA <= "00000000000000000000000000000001";
		sourceB <= "00000000000000000000000000000100";
		wait for 10 ns;
		assert alu_result = "00000000000000000000000000010000"
		report "sll operation failed" severity error;

		-- slt false
		alu_ctrl <= "0011";
		sourceA <= std_logic_vector(to_signed(3, sourceA'length));
		sourceB <= std_logic_vector(to_signed(2, sourceB'length));
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(0, alu_result'length))
		report "set less than operation set value 1, when 0 expected" severity error;

		-- slt true
		alu_ctrl <= "0011";
		sourceA <= std_logic_vector(to_signed(-6, sourceA'length));
		sourceB <= std_logic_vector(to_signed(3, sourceB'length));
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(1, alu_result'length))
		report "set less than operation set value 0, when 1 expected" severity error;

		-- sltu
		alu_ctrl <= "0100";
		sourceA <= std_logic_vector(to_signed(-6, sourceA'length));
		sourceB <= std_logic_vector(to_signed(3, sourceB'length));
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(0, alu_result'length))
		report "set less than operation set value 0, when 1 expected" severity error;

		-- xor
		alu_ctrl <= "0101";
		sourceA <= std_logic_vector(to_unsigned(10, sourceA'length)); -- 1010
		sourceB <= std_logic_vector(to_unsigned(12, sourceB'length)); -- 1100
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_unsigned(6, alu_result'length)) -- 0110
		report "xor error" severity error;

		-- srl
		alu_ctrl <= "0110";
		sourceA <= "00000000000000000000000000010000";
		sourceB <= "00000000000000000000000000000010";
		wait for 10 ns;
		assert alu_result = "00000000000000000000000000000100"
		report "srl operation failed" severity error;

		-- sra
		alu_ctrl <= "0111";
		sourceA <= "11111111111111111111111111111000";
		sourceB <= "00000000000000000000000000000010";
		wait for 10 ns;
		assert alu_result = "11111111111111111111111111111110"
		report "sra operation failed" severity error;

		-- or
		alu_ctrl <= "1000";
		sourceA <= "00000000000000000000000000000011";
		sourceB <= "00000000000000000000000000000110";
		wait for 10 ns;
		assert alu_result = "00000000000000000000000000000111"
		report "OR operation failed" severity error;

		-- and
		alu_ctrl <= "1001";    
		sourceA <= "00000000000000000000000000000011";
		sourceB <= "00000000000000000000000000000110";
		wait for 10 ns;
		assert alu_result = "00000000000000000000000000000010"
		report "AND operation failed" severity error;

	end process;


end alu_tb_arch;

