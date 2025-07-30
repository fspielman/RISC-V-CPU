library ieee;
use ieee.std_logic_1164.all;

entity mux3to1  is
  port(
		sel: in std_logic_vector(1 downto 0);
		d0: in std_logic_vector(31 downto 0);
    d1: in std_logic_vector(31 downto 0);
    d2: in std_logic_vector(31 downto 0);

    y: out std_logic_vector(31 downto 0)
	);
end entity mux3to1; 

architecture mux3to1_arch of mux3to1  is 
begin
  with sel select 
		y <= d0 when "00",
				 d1 when "01",
				 d2 when "10",
				 (others => '0') when others;
				 
end architecture mux3to1_arch; 
