library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity cpu_tb is
  end entity cpu_tb;

architecture behavioral of cpu_tb is

  signal clk: std_logic := '0';

begin

  dut: cpu port map(
		clk
	);

	clock: process
	begin
		wait for 10 ns; -- nop instruction (pc=0)
		loop
			clk <= '1';
			wait for 5 ns;
			clk <= '0';
			wait for 5 ns;
		end loop;
	end process clock;

	process
	begin
		wait for 500 ns; -- run code for 500ns
		assert false report "Simulation finished at 500ns" severity failure;
		wait;
	end process;

end architecture behavioral;
