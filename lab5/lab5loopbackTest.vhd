----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2026 11:02:01
-- Design Name: 
-- Module Name: lab5loopbackTest - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab5loopbackTest is
end lab5loopbackTest;


library ieee;
use ieee.numeric_std.all;
use work.common.all;


architecture Behavioral of lab5loopbackTest is 

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
  
 component rs232transmitter is
  generic (
    FREQ_KHZ : natural;  
    BAUDRATE : natural   
  );
  port (

    clk     : in  std_logic;   
    rst     : in  std_logic;   
    dataRdy : in  std_logic;  
    data    : in  std_logic_vector (7 downto 0);
    busy    : out std_logic;   

    TxD     : out std_logic   
  );
  end component;
  
  component rs232receiver is
  generic (
    FREQ_KHZ : natural;  
    BAUDRATE : natural  
  );
  port (
    -- host side
    clk     : in  std_logic;  
    rst     : in  std_logic;
    dataRdy : out std_logic; 
    data    : out std_logic_vector (7 downto 0); 
    -- RS232 side
    RxD     : in  std_logic 
  );
  end component;

    constant clkPeriod : time := 10 ns;
    --Se�ales
    --In
    signal clk: std_logic := '1';
    signal rst: std_logic := '1';
    signal RxD: std_logic := '1';
    --Out
    signal Txd: std_logic := '1';
    
    --Se�ales internas
    constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
    constant BAUDRATE : natural := 1200;     -- velocidad de transmisión
    
    signal rstSync : std_logic;
    
    signal data    : std_logic_vector (7 downto 0);
    signal dataRdy : std_logic;
    

    constant Dstimuli: std_logic_vector(1 to 10):= "0101110011";


begin
    
    rstSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );
    
    receiver: rs232receiver
    generic map ( FREQ_KHZ => FREQ_KHZ, BAUDRATE => BAUDRATE )
    port map ( clk => clk, rst => rstSync, dataRdy => dataRdy, data => data, RxD => RxD );
    
    transmitter: rs232transmitter 
    generic map ( FREQ_KHZ => FREQ_KHZ, BAUDRATE => BAUDRATE )
    port map ( clk => clk, rst => rstSync, dataRdy => dataRdy, data => data, busy => open, TxD => TxD );
    
    --Generacion de las se�ales de reloj
    clkGen :
      clk <= not clk after clkPeriod/2;
    
    --Generacion de la se�al de reset
    rstGen:
      rst <= 
        '0' after (50 us + 5 ns);
    
    stimuliGen :
    process
    begin
    
        assert false
            report "Comienza la simulacion..."
            severity note;  
           
        wait for 5 ns;  -- Evita que coincidan los flancos de clk y de los est?mulos
        loop
        
        wait for 20 ms;               
        for i in Dstimuli'range loop       --Generar un codigo
            RxD <= Dstimuli(i);
            wait for 833 us;
        end loop;
--        data <= "00111000";
--        dataRdy <= '1';         
        
        end loop;
    end process;
    
    



end Behavioral;
