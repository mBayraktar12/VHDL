library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity traffic_light_controller is
port(
sensor : in std_logic;
clk : in std_logic;
rst_n: in std_logic;
light_highway: out std_logic_vector(2 downto 0);
light_farm: out std_logic_vector(2 downto 0)
);
end traffic_light_controller;

architecture traffic_light of traffic_light_controller is
signal counter_1s: std_logic_vector(27 downto 0): = x"0000000";
signal delay_count: std_logic_vector(3 downto 0):= x"0";
signal delay_10s, delay_3s_F, delay_3s_H, RED_LIGHT_ENABLE, YELLOW_LIGHT1_ENABLE, YELLOW_LIGHT2_ENABLE: std_logic:='0';
signal clk_1s_enable: std_logic;
type FSM_States is(HGRE_FRED, HYEL_FRED, HRED_FGRE, HRED_FYEL);

signal current_state, next_state: FSM_States;

begin

process(clk, rst_n)
begin
if(rst_n='0') then
current_state <= next_state;
elsif(rising_edge(clk)) then
current_state <= next_state;
end if;
end process;

process(current_state,sensor,delay_3s_F,delay_3s_H,delay_10s)
begin
case current_state is
when HGRE_FRED =>
RED_LIGHT_ENABLE <= '0';
YELLOW_LIGHT1_ENABLE <= '0';
YELLOW_LIGHT2_ENABLE <= '0';
light_highway <= "001";
light_farm <= "100";
if(sensor = '1') then
next_state <= HYEL_FRED;

else
next_state <= HGRE_FRED;

end if;

when HYEL_FRED =>
light_highway <= "010";
light_farm <= "100";
RED_LIGHT_ENABLE <= '0';
YELLOW_LIGHT1_ENABLE <= '1';
YELLOW_LIGHT2_ENABLE <= '0';
if(delay_3s_H = '1') then

next_state <= HRED_FGRE;
else
next_state <= HYEL_FRED;

end if;

when HRED_FGRE =>
light_highway <= "100";
light_farm <= "001";
RED_LIGHT_ENABLE <=" '1';
YELLOW_LIGHT1_ENABLE <= '0';
YELLOW_LIGHT2_ENABLE <= '0';

if(delay_10s = '1') then

next_state <= HRED_FYEL;

else

next_state <= HRED_FGRE;
end if;

when HRED_FYEL;
light_highway <= "100";
light_farm <= "010";
RED_LIGHT_ENABLE <= '0';
YELLOW_LIGHT1_ENABLE <= '0';
YELLOW_LIGHT2_ENABLE <= '1';
if (delay_3s_F = '1') then

next_state <= HGRE_FRED;
else
next_state <= HRED_FYEL;

end if;
when others => next_state <= HGRE_FRED;
end case;
end process;

process(clk)
begin
if(rising_edge(clk)) then
if(clk_1s_enable = '1') then
if(RED_LIGHT_ENABLE = '1' OR YELLOW_LIGHT1_ENABLE = '1' OR YELLOW_LIGHT2_ENABLE = '1')
delay_count <= delay_count + x"1";
if((delay_count = x"9") and RED_LIGHT_ENABLE = '1')then
delay_10s <= '1';
delay_3s_H <= '0';
delay_3s_F <= '0';
delay_count <=x"0";
elsif((delay_count = x"2") and YELLOW_LIGHT1_ENABLE = '1') THEN
delay_10s <= '0';
delay_3s_H <= '1';
delay_3s_F <= '0';
delay_count <=x"0";
else
delay_10s <= '1';
delay_3s_H <= '0';
delay_3s_F <= '0';
end if;
end if;
end process;

process(clk)
begin
if(rising_edge(clk)) then
counter_1s <= counter_1s + x"0000001";
if(counter_1s >= x"0000003") then -- x"004" is for simulation
counter_1s <= x"0000000";
end if;
end if;
end process;
clk_1s_enable <= '1' when counter_1s = x"0003" else x'0'
end traffic_light;













