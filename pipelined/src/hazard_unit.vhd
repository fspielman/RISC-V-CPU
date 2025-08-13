library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
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
end entity hazard_unit;

architecture hazard_unit_arch of hazard_unit is
  
	signal flush_id_stall: std_logic;
	signal flush_id_control: std_logic;
	
begin
  
	-- setting mux select for forward handling (1st source)
  process(source1_ex, reg_write_mem, reg_write_wb, dest_mem, dest_wb)
  begin
		-- forward from mem reg
    if(source1_ex = dest_mem and reg_write_mem = '1' and dest_mem /= b"00000") then
      forward_1 <= "01";
		-- forward from wb reg
    elsif(source1_ex = dest_wb and reg_write_wb = '1' and dest_wb /= b"00000") then
      forward_1 <= "10";
		-- no forwarding (ex reg)
    else
      forward_1 <= "00";
		end if;
  end process;
  
	--  setting mux select for forward handling (2nd source)
  process(source2_ex, reg_write_mem, reg_write_wb, dest_mem, dest_wb)
  begin
		-- forward from mem reg
    if(source2_ex = dest_mem and reg_write_mem = '1' and dest_mem /= b"00000") then
      forward_2 <= "01";
		-- forward from wb reg
    elsif(source2_ex = dest_wb and reg_write_wb = '1' and dest_wb /= b"00000") then
      forward_2 <= "10";
		-- no forwarding (ex reg)
    else
      forward_2 <= "00";
    end if;
  end process;
	
	-- stall (lw data hazard)
	process(source1_id, source2_id, result_src_ex, dest_ex)
	begin
		if((source1_id = dest_ex or source2_id = dest_ex) and result_src_ex = "01") then
			stall_pc <= '1';
			stall_if <= '1';
			flush_id_stall <= '1';
		else
			stall_pc <= '0';
			stall_if <= '0';
			flush_id_stall <= '0';		
		end if;
	end process;
	
	-- control hazard (branch)
	process(pc_src_ex)
	begin
		if pc_src_ex = '1' then
			flush_if <= '1';
			flush_id_control <= '1';
		else
			flush_if <= '0';
			flush_id_control <= '0';
		end if;
	end process;
	
	flush_id <= flush_id_stall or flush_id_control;

end architecture hazard_unit_arch;
