---------------------------------------------------------------------
--
--  Fichero:
--    lab6.vhd  23/01/2024
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 6: Damero
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab6damero is
  port ( 
    clk     : in  std_logic;
    hSync   : out std_logic;
    vSync   : out std_logic;
    RGB     : out std_logic_vector(11 downto 0)
  );
end lab6damero;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab6damero is

component freqSynthesizer
  generic (
    FREQ_KHZ : natural;                 -- frecuencia del reloj de entrada en KHz
    MULTIPLY : natural range 1 to 64;   -- factor por el que multiplicar la frecuencia de entrada 
    DIVIDE   : natural range 1 to 128   -- divisor por el que dividir la frecuencia de entrada
  );
  port (
    clkIn  : in  std_logic;   -- reloj de entrada
    rdy    : out std_logic;   -- indica si el reloj de salida es v�lido
    clkOut : out std_logic    -- reloj de salida
  );
end component;

component vgaRefresher
  generic(
    FREQ_DIV  : natural  -- razon entre la frecuencia de reloj del sistema y 25 MHz
  );
  port ( 
    -- host side
    clk   : in  std_logic;   -- reloj del sistema
    rst   : in  std_logic;
    line  : out std_logic_vector(9 downto 0);   -- numero de linea que se esta barriendo
    pixel : out std_logic_vector(9 downto 0);   -- numero de pixel que se esta barriendo
    R     : in  std_logic_vector(3 downto 0);   -- intensidad roja del pixel que se esta barriendo
    G     : in  std_logic_vector(3 downto 0);   -- intensidad verde del pixel que se esta barriendo
    B     : in  std_logic_vector(3 downto 0);   -- intensidad azul del pixel que se esta barriendo
    -- VGA side
    hSync : out std_logic := '0';   -- sincronizacion horizontal
    vSync : out std_logic := '0';   -- sincronizacion vertical
    RGB   : out std_logic_vector(11 downto 0) := (others => '0')   -- canales de color
  );
end component;

  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant VGA_KHZ  : natural := 25_000;   -- frecuencia de envio de pixeles a la VGA en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/VGA_KHZ; 

  signal line, pixel : std_logic_vector(9 downto 0);
  signal color       : std_logic_vector(3 downto 0); 
  
  signal clk_25MHz   : std_logic;
  signal pll_rdy     : std_logic;
  signal rst         : std_logic;
  
begin
  
  rst <= not pll_rdy;
 
  clkGenerator: freqSynthesizer
    generic map (FREQ_KHZ => FREQ_KHZ, MULTIPLY => 1, DIVIDE => FREQ_DIV)
    port map ( clkIn => clk, rdy => pll_rdy, clkOut => clk_25MHz);
  
  screenInteface: vgaRefresher
    generic map ( FREQ_DIV => 1 )
    port map ( clk => clk_25MHz, rst => rst, line => line, pixel => pixel, R => color, G => color, B => color, hSync => hSync, vSync => vSync, RGB => RGB );
    
  color <= (others => pixel(4) xor line(4));

end syn;