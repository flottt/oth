--------------------------------------------------------------------------------
-- HEIG-VD, institute REDS, 1400 Yverdon-les-Bains
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity MUX32 is
  port(
  ------------------------------------------------------------------------------
  --Insert input ports below
    enabled    : in  std_logic := 1;               
    x0         : in  std_logic_vector(31 downto 0); 
  ------------------------------------------------------------------------------
  --Insert output ports below
    result     : out std_logic_Vector(31 downto 0)
    );
end MUX32;

--------------------------------------------------------------------------------
--Complete your VHDL description below
architecture MUXING32 of MUX32 is


begin
  result <= x0 when enabled = 1 else '0'; 

end MUXING32;
