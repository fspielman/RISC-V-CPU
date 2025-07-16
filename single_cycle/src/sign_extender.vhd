library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
  port (
         instruction: in std_logic_vector(31 downto 7);
         imm_src: in std_logic_vector(1 downto 0);

         extend: out std_logic_vector(31 downto 0)
       );
end entity sign_extender;

architecture sign_ext_arch of sign_extender is

begin

  process(instruction, imm_src)
  begin
    case imm_src is 
      -- I instruction (12 bit signed imm)
      when "00" =>
        extend <= (31 downto 12 => instruction(31)) & instruction(31 downto 20);
    -- S instruction (12 bit signed imm)
      when "01" =>
        extend <= (31 downto 12 => instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7);
    -- B instruction (13 bit signed imm), 2 byte alligned -> left shift by 1 -> lsb = '0'
      when "10" =>
        extend <= (31 downto 13 => instruction(31)) & instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
    -- J instruction (21 bit signed imm), 2 byte alligned -> left shift by 1 -> lsb = '0'
      when "11" => 
        extend <= (31 downto 21 => instruction(31)) & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
      when others =>
        extend <= (others => '0'); -- defaults to 0
    end case;
  end process;

end architecture sign_ext_arch;
