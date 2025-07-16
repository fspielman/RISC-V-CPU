library ieee;
use ieee.std_logic_1164.all;

entity alu_decoder is
  port (
         alu_op: in std_logic_vector(1 downto 0);
         funct3: in std_logic_vector(2 downto 0);
         funct7: in std_logic_vector(6 downto 0);
         branch: in std_logic;

         alu_ctrl: out std_logic_vector(3 downto 0)
       );
end entity alu_decoder;

architecture alu_decoder_arch of alu_decoder is

begin

  process(alu_op, funct3, funct7, branch)
  begin
    if(branch = '1') then
      alu_ctrl <= "0001"; -- sub for branch instructions
    else
      case alu_op is
        -- lw / sw
        when "00" =>
          -- if(funct3 = "010") then
          alu_ctrl <= "0000"; -- add base + immediate offset
          -- end if;

        -- R-type operations
        when "10" => 
          case funct3 is
            when "000" =>
              if(funct7(5) = '0') then
                alu_ctrl <= "0000"; -- add / addi
              else
                alu_ctrl <= "0001"; -- sub / subi
              end if;
            when "001" =>
              alu_ctrl <= "0010"; -- sll / slli
            when "010" =>
              alu_ctrl <= "0011"; -- slt / slti
            when "011" =>
              alu_ctrl <= "0100"; -- sltu / sltiu
            when "100" => 
              alu_ctrl <= "0101"; -- xor / xori
            when "101" =>
              if(funct7(5) = '0') then
                alu_ctrl <= "0110"; -- srl / srli
              else  
                alu_ctrl <= "0111"; -- sra / srai
              end if;
            when "110" =>
              alu_ctrl <= "1000"; -- or / ori
            when "111" =>
              alu_ctrl <= "1001"; -- and / andi
            when others =>
              alu_ctrl <= "0000"; -- defaults to add / addi		 
          end case;

        -- defaults to add
        when others =>
          alu_ctrl <= "0000"; 

      end case;
    end if;
  end process;

end architecture alu_decoder_arch;
