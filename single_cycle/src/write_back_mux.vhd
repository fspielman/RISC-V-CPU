library ieee;
use ieee.std_logic_1164.all;

entity write_back_mux  is
  port(
        result_src: in std_logic_vector(1 downto 0); -- select
        alu_result: in std_logic_vector(31 downto 0);
        read_data_mem: in std_logic_vector(31 downto 0);
        pc_plus4: in std_logic_vector(31 downto 0);

        write_back: out std_logic_vector(31 downto 0)
      );
end entity write_back_mux ; 

architecture mux_arch of write_back_mux  is 
begin
  with result_src select 
    write_back <=  alu_result when "00",
                   read_data_mem when "01",
                   pc_plus4 when "10",
                   (others => '0') when others;
end architecture mux_arch; 
