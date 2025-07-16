library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port(
        sourceA: in std_logic_vector(31 downto 0);
        sourceB: in std_logic_vector(31 downto 0);
        alu_ctrl: in std_logic_vector(3 downto 0);

        alu_result: out std_logic_vector(31 downto 0);
        zero: out std_logic
      );
end entity alu;

architecture alu_arch of alu is

  signal result: std_logic_vector(31 downto 0);

begin

  process(alu_ctrl, sourceA, sourceB)
    variable shamt: integer;
  begin
    case alu_ctrl is
      -- add
      when "0000" =>
        result <= std_logic_vector(signed(sourceA) + signed(sourceB));
      -- sub
      when "0001" =>
        result <= std_logic_vector(signed(sourceA) - signed(sourceB));	  
      -- sll
      when "0010" =>
        shamt := to_integer(unsigned(sourceB(4 downto 0)));
        result <= std_logic_vector(shift_left(unsigned(sourceA), shamt));
      -- slt
      when "0011" =>
        if(signed(sourceA) < signed(sourceB)) then
          result <= x"00000001";
        else
          result <= x"00000000"; 
        end if;
      -- sltu
      when "0100" => 
        if(unsigned(sourceA) < unsigned(sourceB)) then
          result <= x"00000001";
        else
          result <= x"00000000";
        end if;	
      -- xor
      when "0101" =>
        result <= sourceA xor sourceB;
      -- srl
      when "0110" =>
        shamt := to_integer(unsigned(sourceB(4 downto 0)));
        result <= std_logic_vector(shift_right(unsigned(sourceA), shamt));
      --sra 
      when "0111" =>
        shamt := to_integer(unsigned(sourceB(4 downto 0)));
        result <= std_logic_vector(shift_right(signed(sourceA), shamt));
      --- or
      when "1000" =>
        result <= sourceA or sourceB;
      -- and
      when "1001" =>
        result <= sourceA and sourceB;

      when others =>
        result <= (others => 'U');
    end case;
  end process;

  alu_result <= result;
  zero <= '1' when result = x"00000000" else '0';

end architecture alu_arch;
