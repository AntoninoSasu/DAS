---------------------------------------------------------------------
--
--  Fichero:
--    lab2.vhd  07/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 2
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab2 is
  port
    (
      clk       : in  std_logic;
      clear     : in  std_logic;
      startStop : in  std_logic;
      lap       : in  std_logic;
      leds      : out std_logic_vector(15 downto 0)
      );
end lab2;

---------------------------------------------------------------------

use work.common.all;

architecture syn of lab2 is

  component modCounter
    generic(MAXVAL : natural);
    port
      (
        clk   : in std_logic;
        rst   : in  std_logic;
        ce    : in  std_logic;
        tc    : out std_logic;
        count : out std_logic_vector
        );  
  end component;
  
  component synchronizer
    generic (
      STAGES : natural;
      XPOL   : std_logic
    );
    port (
      clk   : in  std_logic;
      x     : in  std_logic;
      xSync : out std_logic
    );
  end component;

  component debouncer
    generic (
      FREQ_KHZ  : natural;
      BOUNCE_MS : natural;
      XPOL      : std_logic
    );
    port (
      clk  : in  std_logic;
      rst  : in  std_logic;
      x    : in  std_logic;
      xdeb : out std_logic
    );
  end component;
  
  component edgeDetector
    generic (
      XPOL : std_logic
    );
    port (
      clk   : in  std_logic;
      x     : in  std_logic;
      xFall : out std_logic;
      xRise : out std_logic
    );
  end component;

  constant FREQ_KHZ  : natural := 100_000;  -- frecuencia de operacion en KHz
  constant BOUNCE_MS : natural := 50;  -- tiempo de rebote de los pulsadores en ms

  -- Registros  

  signal lapTFF, startStopTFF : std_logic := '0';

  signal secLowReg  : std_logic_vector(3 downto 0) := (others => '0');
  signal secHighReg : std_logic_vector(2 downto 0) := (others => '0');

  -- Conexiones

  signal clearSync                                  : std_logic;
  signal startStopSync, startStopDeb, startStopRise : std_logic;
  signal lapSync, lapDeb, lapRise                   : std_logic;

  signal cycleCntTC, decCntTC, secLowCntTC : std_logic;

  signal decCnt, secLowCnt : std_logic_vector(3 downto 0);
  signal secHighCnt        : std_logic_vector(2 downto 0);

  signal secLowMux, secHighMux : std_logic_vector(3 downto 0);

begin

  clearSynchronizer : synchronizer
    generic map (STAGES => 2, XPOL => '0')
    port map (clk => clk, x => clear, xSync => clearSync);

  ------------------  

  startStopSynchronizer : synchronizer
    generic map (STAGES => 2, XPOL => '0')
    port map (clk => clk, x => startStop, xSync => startStopSync);

  startStopDebouncer : debouncer
    generic map (FREQ_KHZ => FREQ_KHZ, BOUNCE_MS => BOUNCE_MS, XPOL => '0')
    port map (...);

  startStopEdgeDetector : edgeDetector
    generic map (XPOL    => '0')
    port map (..., xFall => open);

  ------------------  

  lapSynchronizer : synchronizer
    generic map (...)
    port map (...);

  lapDebouncer : debouncer
    generic map (...)
    port map (...);

  lapEdgeDetector : edgeDetector
    generic map (...)
    port map (...);

  ------------------  

  toggleFFs :
  process (clk)
  begin
    if rising_edge(clk) then
      if clearSync = '1' then
        startStopTFF <= ...;
      lapTFF <= ...;
    else
      if ... then
        startStopTFF <= ...;
      end if;
      if ... then
        lapTFF <= ...;
      end if;
    end if;
  end if;
end process;

cycleCounter : modCounter
  generic map (MAXVAL => ms2cycles(FREQ_KHZ, 100)-1)
  port map (...);

decCounter : modCounter
  generic map (MAXVAL => 9)
  port map (...);

secLowCounter : modCounter
  generic map (...)
  port map (...);

secHighCounter : modCounter
  generic map (...)
  port map (...);

lapRegisters :
process (clk)
begin
  if rising_edge(clk) then
    if clearSync = '1' then
        secLowReg <= ...;
    secHighReg <= ...;
  elsif ... then
    secLowReg  <= ...;
    secHighReg <= ...;
  end if;
end if;
end process;

leftMux :
  secHighMux <= ... when ... else ...;

rigthMux :
  secLowMux <= ... when ... else ...;

leds <= ...;

end syn;
