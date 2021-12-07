library ieee;
use ieee.std_logic_1164.all;
entity Full_Adder_Structural_VHDL is
  port(
  X1,X2,Cin : in std_logic;
  S, Cout : out std_logic
);
end Full_Adder_Structural_VHDL;

architecture structural of Full_Adder_Structural_VHDL is
signal a1, a2, a3: std_logic;
begin
  a1 <= x1 xor x2;
  a2 <= x1 and x2;
  a3 <= x1 and Cin;
  Cout <= a2 or a3;
  S <= a1 xor Cin;
end structural;