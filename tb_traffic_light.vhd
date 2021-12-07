library ieee;
use ieee.std_logic_1164.all;

entity tb_traffic_light_controller is
end tb_traffic_light_controller;

architecture behavior of tb_traffic_light_controller is

component traffic_light_controller is
port(
sensor : in std_logic;
clk : in std_logic;
rst_n: in std_logic;
light_highway: out std_logic_vector(2 downto 0);
light_farm: out std_logic_vector(2 downto 0)
);
end component;

signal sensor : std_logic := '0';
signal clk : std_logic := '0';
signal rst_n : std_logic := '0';

signal light_highway : std_logic_vector(2 downto 0);
signal light_farm : std_logic_vector(2 downto 0);
constant clk_period : time:= 10 ns;

begin

trafficlightcontroller : traffic_light_controller port map(
sensor => sensor,
clk => clk,
rst_n => rst_n,
light_highway => light_highway,
light_farm => light_farm
);

clk_process : process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

stim_proc: process
begin
rst_n <= '0';
sensor <= '0';
wait for clk_period*10;
rst_n <= '1';
wait for clk_period*20;
sensor <= '1';
wait for clk_period*100;
sensor <= '0';
wait;
end process;
end;
