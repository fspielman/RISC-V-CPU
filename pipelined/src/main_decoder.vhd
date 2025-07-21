library ieee;
use ieee.std_logic_1164.all;

entity main_decoder is
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
end entity main_decoder;

architecture main_decoder_arch of main_decoder is

begin
  -- main decoder
  process(opcode)
  begin
    case opcode is
    -- lw
      when "0000011" =>
        reg_write <= '1';
        imm_src <= "00";
        alu_src <= '1';
        mem_write <= '0';
        result_src <= "01";
        branch <= '0';
        jump <= '0';
        alu_op <= "00";

    -- sw
      when "0100011" =>
        reg_write <= '0';
        imm_src <= "01";
        alu_src <= '1';
        mem_write <= '1';
        result_src <= "00"; -- dont care (no wb)
        branch <= '0';
        jump <= '0';
        alu_op <= "00";

      -- R type
      when "0110011" =>
        reg_write <= '1';
        imm_src <= "00"; -- dont care (no immediate used)
        alu_src <= '0';
        mem_write <= '0';
        result_src <= "00";
        branch <= '0';
        jump <= '0';
        alu_op <= "10";

      -- I type ALU
      when "0010011" =>
        reg_write <= '1';
        imm_src <= "00"; 
        alu_src <= '1';
        mem_write <= '0';
        result_src <= "00";
        branch <= '0';
        jump <= '0';
        alu_op <= "10";

      -- J Type (jal)
      when "1101111" =>
        reg_write <= '1';
        imm_src <= "11"; 
        alu_src <= '1'; -- dont care (no wb)
        mem_write <= '0';
        result_src <= "10"; -- 10 for jal (add two bits - mux for wb rd=pc+4)
        branch <= '0';
        jump <= '1';
        alu_op <= "00"; -- dont care (no alu operation)

      -- B Type (beq)
      when "1100011" => 
        reg_write <= '0';
        imm_src <= "10"; 
        alu_src <= '0';
        mem_write <= '0';
        result_src <= "00"; -- dont care (no wb)
        branch <= '1';
        jump <= '0';
        alu_op <= "01";			

      -- defaults to all 0s
      when others =>
        reg_write <= '0';
        imm_src <= "00";
        alu_src <= '0';
        mem_write <= '0';
        result_src <= "00";
        branch <= '0';
        jump <= '0';
        alu_op <= "10";
    end case;	
  end process;

end architecture main_decoder_arch;
