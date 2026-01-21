library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp is
    port(
        clk   : in std_logic;
        reset : in std_logic;

        inst_adderss : in  std_logic_vector(31 downto 0);
        bp_out       : out std_logic;  --输出跳转还是不跳转

        jump_adderss : in  std_logic_vector(31 downto 0);  --跳转指令的地址
        jump_to      : in  std_logic;                      --跳转方向
        jump_start   : in  std_logic                       --跳转势能
    );
end entity bp;

architecture rtl of bp is
    -- 数组类型声明
    type bht_adderss_array is array (0 to 31) of std_logic_vector(31 downto 0);
    type bht_data_array is array (0 to 31) of std_logic_vector(1 downto 0);
    
    -- BHT信号
    signal bht_adderss : bht_adderss_array;
    signal bht_data    : bht_data_array;
    signal bht_pc      : integer range 0 to 31 := 0;
begin

    -- BHT寻址输出
    process(bht_adderss, bht_data, inst_adderss)
        variable found : boolean;
    begin
        found := false;
        bp_out <= '0';  -- 默认不跳转
        
        for d in 0 to 31 loop
            if bht_adderss(d) = inst_adderss then  -- 检测内容
                -- 2位饱和计数器：高位为预测方向
                -- 00:强不跳转,01:弱不跳转,10:弱跳转,11:强跳转
                bp_out <= bht_data(d)(1);  -- 取高位作为预测
                found := true;
                exit;
            end if;
        end loop;
    end process;
    
    -- BHT写入
    process(clk, reset)
        variable updated : boolean;
    begin
        if reset = '1' then
            bht_pc <= 0;
            for i in 0 to 31 loop
                bht_adderss(i) <= (others => '0');
                bht_data(i) <= "01";  -- 初始化为弱不跳转
            end loop;
            
        elsif rising_edge(clk) then     
            if jump_start = '1' then    -- jump结果存储
                updated := false;
                
                -- 查找是否已存在
                search_loop: for i in 0 to 31 loop
                    if jump_adderss = bht_adderss(i) then
                        -- 更新现有条目
                        if jump_to = '1' then    -- 实际跳转了
                            case bht_data(i) is
                                when "00" => bht_data(i) <= "01";  -- 强不跳转 -> 弱不跳转
                                when "01" => bht_data(i) <= "10";  -- 弱不跳转 -> 弱跳转
                                when "10" => bht_data(i) <= "11";  -- 弱跳转 -> 强跳转
                                when "11" => bht_data(i) <= "11";  -- 强跳转 -> 强跳转（饱和）
                                when others => null;
                            end case;
                        else                    -- 实际没有跳转
                            case bht_data(i) is
                                when "00" => bht_data(i) <= "00";  -- 强不跳转 -> 强不跳转
                                when "01" => bht_data(i) <= "00";  -- 弱不跳转 -> 强不跳转
                                when "10" => bht_data(i) <= "01";  -- 弱跳转 -> 弱不跳转
                                when "11" => bht_data(i) <= "10";  -- 强跳转 -> 弱跳转
                                when others => null;
                            end case;
                        end if;
                        updated := true;
                        exit search_loop;
                    end if;
                end loop search_loop;
                
                -- 如果没找到，添加新条目
                if not updated then
                    if jump_to = '1' then
                        bht_data(bht_pc) <= "10";  -- 弱跳转
                    else 
                        bht_data(bht_pc) <= "01";  -- 弱不跳转
                    end if;
                    bht_adderss(bht_pc) <= jump_adderss;
                    
                    -- 更新指针
                    if bht_pc = 31 then
                        bht_pc <= 0;
                    else
                        bht_pc <= bht_pc + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
end architecture rtl;



    