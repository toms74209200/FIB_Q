-- ============================================================================
--  Title       : Fibonacci function quadruple calculation
--
--  File Name   : FIB.vhd
--  Project     : Sample
--  Block       :
--  Tree        :
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2019/02/05
--  Copyright   : 2019 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIB_Q is
    generic(
        DW              : integer := 64                             -- Data width
    );
    port(
    -- System --
        RESET_n         : in    std_logic;                          --(n) Reset
        CLK             : in    std_logic;                          --(p) Clock

    -- Control --
        ASI_READY       : out   std_logic;                          --(p) Avalon-ST sink data ready
        ASI_VALID       : in    std_logic;                          --(p) Avalon-ST sink data valid
        ASI_DATA        : in    std_logic_vector(DW-1 downto 0);    --(p) Avalon-ST sink data
        ASO_VALID       : out   std_logic;                          --(p) Avalon-ST source data valid
        ASO_DATA        : out   std_logic_vector(DW-1 downto 0);    --(p) Avalon-ST source data
        ASO_ERROR       : out   std_logic                           --(p) Avalon-ST source error
        );
end FIB_Q;

architecture RTL of FIB_Q is

-- Internal signals --
signal  null_i        : std_logic_vector(DW-1 downto 0);            -- null
signal  first_term    : std_logic_vector(DW-1 downto 0);            -- Fibonacci first term
signal  fnp3          : std_logic_vector(DW+1 downto 0);            -- F_n+3
signal  fnp2          : std_logic_vector(DW+1 downto 0);            -- F_n+2
signal  fnp1          : std_logic_vector(DW   downto 0);            -- F_n+1
signal  fn            : std_logic_vector(DW   downto 0);            -- F_n
signal  fnm1          : std_logic_vector(DW-1 downto 0);            -- F_n-1
signal  fnm2          : std_logic_vector(DW-1 downto 0);            -- F_n-2

signal  calc_n        : std_logic_vector(6 downto 0);               -- Calculation end count N
signal  n_over        : std_logic;                                  -- Count N overflow
signal  over_check    : std_logic_vector(DW-1 downto 0);            -- Overflow check value
signal  over_flow     : std_logic;                                  -- Bit overflow assert
signal  over_flow_reg : std_logic;                                  -- Bit overflow assert
signal  done_i        : std_logic;                                  -- Calculation done flag
signal  busy_i        : std_logic;                                  -- Calculation enable
signal  cnt           : std_logic_vector(calc_n'range);             -- Calculation count

begin
--
-- ============================================================================
--  First term definition
-- ============================================================================
null_i <= (others => '0');
first_term <= null_i + 1;


-- ============================================================================
--  Fibonacci calculation
-- ============================================================================
-- F_n+3 = 4*F_n-1 + 2*F_n-2 + F_n-1 + F_n-2
fnp3 <= (fnm1 & "00") + ('0' & fnm2 & '0') + ("00" & fnm1) + ("00" & fnm2);
-- F_n+2 = 2*F_n-1 + 2*F_n-2 + F_n-1
fnp2 <= ('0' & fnm1 & '0') + ('0' & fnm2 & '0') + ("00" & fnm1);
-- F_n+1 = 2*F_n-1 + F_n-2
fnp1 <= (fnm1 & '0') + ('0' & fnm2);
-- F_n = F_n-1 + F_n-2
fn   <= ('0' & fnm1) + ('0' & fnm2);

process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        fnm1 <= (others => '0');
        fnm2 <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (busy_i = '0' and ASI_VALID = '1') then
            fnm1 <= first_term;
            fnm2 <= first_term;
        elsif (busy_i = '1') then
            if (done_i = '1') then
                fnm1 <= fnm1;
                fnm2 <= fnm2;
            else
                fnm1 <= fnp3(fnm1'range);
                fnm2 <= fnp2(fnm2'range);
            end if;
        end if;
    end if;
end process;

ASO_DATA <= first_term           when (calc_n < 3) else
            fn(ASO_DATA'range)   when (calc_n(1 downto 0) = "11") else
            fnp1(ASO_DATA'range) when (calc_n(1 downto 0) = "00") else
            fnp2(ASO_DATA'range) when (calc_n(1 downto 0) = "01") else
            fnp3(ASO_DATA'range);


-- ============================================================================
--  Calculation end count
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        calc_n <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (busy_i = '0' and ASI_VALID = '1') then
            calc_n <= ASI_DATA(calc_n'range);
        end if;
    end if;
end process;

process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        n_over <= '0';
    elsif (CLK'event and CLK = '1') then
        if (busy_i = '0' and ASI_VALID = '1') then
            if (ASI_DATA > X"7F") then
                n_over <= '1';
            else
                n_over <= '0';
            end if;
        end if;
    end if;
end process;


-- ============================================================================
--  Bit over flow assert
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        over_flow_reg <= '0';
    elsif (CLK'event and CLK = '1') then
        if (busy_i = '1') then
            if (cnt + 3 < calc_n) then
                if (fn(fn'left) = '1') then
                    over_flow_reg <= '1';
                elsif (fnp1(fnp1'left) = '1') then
                    over_flow_reg <= '1';
                elsif (fnp2(fnp2'left downto fnp2'left-1) > 0) then
                    over_flow_reg <= '1';
                elsif (fnp3(fnp3'left downto fnp3'left-1) > 0) then
                    over_flow_reg <= '1';
                end if;
            end if;
        else
            over_flow_reg <= '0';
        end if;
    end if;
end process;

over_flow <= '1' when (calc_n(1 downto 0) = "11" and fn(fn'left) = '1') else
             '1' when (calc_n(1 downto 0) = "00" and fnp1(fnp1'left) = '1') else 
             '1' when (calc_n(1 downto 0) = "01" and fnp2(fnp2'left downto fnp2'left-1) > 0) else 
             '1' when (calc_n(1 downto 0) = "10" and fnp3(fnp3'left downto fnp3'left-1) > 0) else 
             '0';

ASO_ERROR <= over_flow or over_flow_reg or n_over;


-- ============================================================================
--  Calculation end
-- ============================================================================
done_i <= '1' when (busy_i = '1' and cnt + 3 > calc_n - 1) else
          '1' when (busy_i = '1' and calc_n < 3) else
          '0';

ASO_VALID <= done_i;


-- ============================================================================
--  Calculation enable
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        busy_i <= '0';
    elsif (CLK'event and CLK = '1') then
        if (done_i = '1') then
            busy_i <= '0';
        elsif (ASI_VALID = '1') then
            busy_i <= '1';
        end if;
    end if;
end process;

ASI_READY <= not busy_i;


-- ============================================================================
--  Calculation count
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        cnt <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (busy_i = '1') then
            if (done_i = '1') then
                cnt <= cnt;
            else
                cnt <= cnt + 4;
            end if;
        elsif (ASI_VALID = '1') then
            cnt <= B"000_0011";
        end if;
    end if;
end process;


end RTL;    -- FIB_Q
