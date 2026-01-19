library ieee
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp is
    port(
        clk   : in std_logic;
        reset : in std_logic;

        inst_adderss : in  std_logic_vector(31 downto 0);
        bp_out       : out std_logic;  --输出跳转还是不跳转

        jump_adderss : in  std_logic_vector(31 downto 0);
        jump_to      : in  std_logic
        jump_start   : in  std_logic
    )

    architecture rtl of example is
        --BHT寻址
        signal bht_adderss : array (0 to 31) of std_logic_vector(31 downto 0);
        --BHT存储结果
        signal bht_data    : array (0 to 31) of std_logic_vector(3 downto 0);
        --BHT存储指针
        signal bht_pc      :                    std_logic_vector(5 downto 0);
    begin

        --BHT寻址输出
        process(all)
        begin
            for d in 0 to 31 loop
                if bht_adderss(d) = inst_adderss then  --检测内容
                    bp_out <= bht_data(1);             --赋值bp结果
                    d <= 32;
                else
                    bp_out <= '0'                      --不跳转        
                end if;
            end loop;
        end process;
    
        --BHT写入
        process(clk, reset)
        begin
              if reset = '1' then
                bht_pc <= (others => '0');

                for i in 0 to 31 loop
                    bht_adderss(i) <= (others => '0');
                    bht_data(i) <= (others => '0');
                end loop;
                elsif rising_edge(clk) then     --留空，因为后面要写jump
                    if condition then
                        
                    end if;
                end if;
        end process;
        

    end architecture;



    