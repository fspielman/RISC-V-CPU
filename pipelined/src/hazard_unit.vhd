library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
  port (
    read_source1: in std_logic_vector(4 downto 0);
    read_source2: in std_logic_vector(4 downto 0);
    reg_write_wb: in std_logic;
    dest_mem: in std_logic_vector(4 downto 0);
    dest_wb: in std_logic_vector(4 downto 0);
    
    forward_1: out std_logic_vector(1 downto 0);
    forward_2: out std_logic_vector(1 downto 0)
  );
end entity hazard_unit;

architecture hazard_unit_arch of hazard_unit is
  
begin
  
	-- setting mux select for forward handling (1st source)
  process(read_source1, reg_write_wb, dest_mem, dest_wb)
  begin
		-- forward from mem reg
    if(read_source1 = dest_mem and reg_write_wb = '1' and dest_mem /= b"00000") then
      forward_1 <= "01";
		-- forward from wb reg
    elsif(read_source1 = dest_wb and reg_write_wb = '1' and dest_wb /= b"00000") then
      forward_1 <= "10";
		-- no forwarding (ex reg)
    else
      forward_1 <= "00";
		end if;
  end process;
  
	--  setting mux select for forward handling (2nd source)
  process(read_source2, reg_write_wb, dest_mem, dest_wb)
  begin
		-- forward from mem reg
    if(read_source2 = dest_mem and reg_write_wb = '1' and dest_mem /= b"00000") then
      forward_2 <= "01";
		-- forward from wb reg
    elsif(read_source2 = dest_wb and reg_write_wb = '1' and dest_wb /= b"00000") then
      forward_2 <= "10";
		-- no forwarding (ex reg)
    else
      forward_2 <= "00";
    end if;
  end process;

end architecture hazard_unit_arch;
