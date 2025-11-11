

connect_debug_port u_ila_0/probe8 [get_nets [list {memcon/iram/mem_data_wdata_reg[15][0]} {memcon/iram/mem_data_wdata_reg[15][1]} {memcon/iram/mem_data_wdata_reg[15][2]} {memcon/iram/mem_data_wdata_reg[15][3]} {memcon/iram/mem_data_wdata_reg[15][4]} {memcon/iram/mem_data_wdata_reg[15][5]} {memcon/iram/mem_data_wdata_reg[15][6]} {memcon/iram/mem_data_wdata_reg[15][7]} {memcon/iram/mem_data_wdata_reg[15][8]} {memcon/iram/mem_data_wdata_reg[15][9]} {memcon/iram/mem_data_wdata_reg[15][10]} {memcon/iram/mem_data_wdata_reg[15][11]} {memcon/iram/mem_data_wdata_reg[15][12]} {memcon/iram/mem_data_wdata_reg[15][13]} {memcon/iram/mem_data_wdata_reg[15][14]} {memcon/iram/mem_data_wdata_reg[15][15]}]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list s_clk_OBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {gpio_OBUF[0]} {gpio_OBUF[1]} {gpio_OBUF[2]} {gpio_OBUF[3]} {gpio_OBUF[4]} {gpio_OBUF[5]} {gpio_OBUF[6]} {gpio_OBUF[7]} {gpio_OBUF[8]} {gpio_OBUF[9]} {gpio_OBUF[10]} {gpio_OBUF[11]} {gpio_OBUF[12]} {gpio_OBUF[13]} {gpio_OBUF[14]} {gpio_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 13 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {memcon/ram/activeRow[1]_6[0]} {memcon/ram/activeRow[1]_6[1]} {memcon/ram/activeRow[1]_6[2]} {memcon/ram/activeRow[1]_6[3]} {memcon/ram/activeRow[1]_6[4]} {memcon/ram/activeRow[1]_6[5]} {memcon/ram/activeRow[1]_6[6]} {memcon/ram/activeRow[1]_6[7]} {memcon/ram/activeRow[1]_6[8]} {memcon/ram/activeRow[1]_6[9]} {memcon/ram/activeRow[1]_6[10]} {memcon/ram/activeRow[1]_6[11]} {memcon/ram/activeRow[1]_6[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {memcon/ram/activeBankTimeout[3]__0[0]} {memcon/ram/activeBankTimeout[3]__0[1]} {memcon/ram/activeBankTimeout[3]__0[2]} {memcon/ram/activeBankTimeout[3]__0[3]} {memcon/ram/activeBankTimeout[3]__0[4]} {memcon/ram/activeBankTimeout[3]__0[5]} {memcon/ram/activeBankTimeout[3]__0[6]} {memcon/ram/activeBankTimeout[3]__0[7]} {memcon/ram/activeBankTimeout[3]__0[8]} {memcon/ram/activeBankTimeout[3]__0[9]} {memcon/ram/activeBankTimeout[3]__0[10]} {memcon/ram/activeBankTimeout[3]__0[11]} {memcon/ram/activeBankTimeout[3]__0[12]} {memcon/ram/activeBankTimeout[3]__0[13]} {memcon/ram/activeBankTimeout[3]__0[14]} {memcon/ram/activeBankTimeout[3]__0[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 9 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {memcon/ram/targetColumn[0]} {memcon/ram/targetColumn[1]} {memcon/ram/targetColumn[2]} {memcon/ram/targetColumn[3]} {memcon/ram/targetColumn[4]} {memcon/ram/targetColumn[5]} {memcon/ram/targetColumn[6]} {memcon/ram/targetColumn[7]} {memcon/ram/targetColumn[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 13 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {memcon/ram/activeRow[3]_4[0]} {memcon/ram/activeRow[3]_4[1]} {memcon/ram/activeRow[3]_4[2]} {memcon/ram/activeRow[3]_4[3]} {memcon/ram/activeRow[3]_4[4]} {memcon/ram/activeRow[3]_4[5]} {memcon/ram/activeRow[3]_4[6]} {memcon/ram/activeRow[3]_4[7]} {memcon/ram/activeRow[3]_4[8]} {memcon/ram/activeRow[3]_4[9]} {memcon/ram/activeRow[3]_4[10]} {memcon/ram/activeRow[3]_4[11]} {memcon/ram/activeRow[3]_4[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {memcon/ram/activeBankTimeout[1]__0[0]} {memcon/ram/activeBankTimeout[1]__0[1]} {memcon/ram/activeBankTimeout[1]__0[2]} {memcon/ram/activeBankTimeout[1]__0[3]} {memcon/ram/activeBankTimeout[1]__0[4]} {memcon/ram/activeBankTimeout[1]__0[5]} {memcon/ram/activeBankTimeout[1]__0[6]} {memcon/ram/activeBankTimeout[1]__0[7]} {memcon/ram/activeBankTimeout[1]__0[8]} {memcon/ram/activeBankTimeout[1]__0[9]} {memcon/ram/activeBankTimeout[1]__0[10]} {memcon/ram/activeBankTimeout[1]__0[11]} {memcon/ram/activeBankTimeout[1]__0[12]} {memcon/ram/activeBankTimeout[1]__0[13]} {memcon/ram/activeBankTimeout[1]__0[14]} {memcon/ram/activeBankTimeout[1]__0[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {memcon/ram/activeBankTimeout[0]__0[0]} {memcon/ram/activeBankTimeout[0]__0[1]} {memcon/ram/activeBankTimeout[0]__0[2]} {memcon/ram/activeBankTimeout[0]__0[3]} {memcon/ram/activeBankTimeout[0]__0[4]} {memcon/ram/activeBankTimeout[0]__0[5]} {memcon/ram/activeBankTimeout[0]__0[6]} {memcon/ram/activeBankTimeout[0]__0[7]} {memcon/ram/activeBankTimeout[0]__0[8]} {memcon/ram/activeBankTimeout[0]__0[9]} {memcon/ram/activeBankTimeout[0]__0[10]} {memcon/ram/activeBankTimeout[0]__0[11]} {memcon/ram/activeBankTimeout[0]__0[12]} {memcon/ram/activeBankTimeout[0]__0[13]} {memcon/ram/activeBankTimeout[0]__0[14]} {memcon/ram/activeBankTimeout[0]__0[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 13 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {memcon/ram/activeRow[0]_7[0]} {memcon/ram/activeRow[0]_7[1]} {memcon/ram/activeRow[0]_7[2]} {memcon/ram/activeRow[0]_7[3]} {memcon/ram/activeRow[0]_7[4]} {memcon/ram/activeRow[0]_7[5]} {memcon/ram/activeRow[0]_7[6]} {memcon/ram/activeRow[0]_7[7]} {memcon/ram/activeRow[0]_7[8]} {memcon/ram/activeRow[0]_7[9]} {memcon/ram/activeRow[0]_7[10]} {memcon/ram/activeRow[0]_7[11]} {memcon/ram/activeRow[0]_7[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 16 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {memcon/ram/activeBankTimeout[2]__0[0]} {memcon/ram/activeBankTimeout[2]__0[1]} {memcon/ram/activeBankTimeout[2]__0[2]} {memcon/ram/activeBankTimeout[2]__0[3]} {memcon/ram/activeBankTimeout[2]__0[4]} {memcon/ram/activeBankTimeout[2]__0[5]} {memcon/ram/activeBankTimeout[2]__0[6]} {memcon/ram/activeBankTimeout[2]__0[7]} {memcon/ram/activeBankTimeout[2]__0[8]} {memcon/ram/activeBankTimeout[2]__0[9]} {memcon/ram/activeBankTimeout[2]__0[10]} {memcon/ram/activeBankTimeout[2]__0[11]} {memcon/ram/activeBankTimeout[2]__0[12]} {memcon/ram/activeBankTimeout[2]__0[13]} {memcon/ram/activeBankTimeout[2]__0[14]} {memcon/ram/activeBankTimeout[2]__0[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 2 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {memcon/ram/targetBank[0]} {memcon/ram/targetBank[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 13 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {memcon/ram/targetRow[0]} {memcon/ram/targetRow[1]} {memcon/ram/targetRow[2]} {memcon/ram/targetRow[3]} {memcon/ram/targetRow[4]} {memcon/ram/targetRow[5]} {memcon/ram/targetRow[6]} {memcon/ram/targetRow[7]} {memcon/ram/targetRow[8]} {memcon/ram/targetRow[9]} {memcon/ram/targetRow[10]} {memcon/ram/targetRow[11]} {memcon/ram/targetRow[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 13 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {memcon/ram/activeRow[2]_5[0]} {memcon/ram/activeRow[2]_5[1]} {memcon/ram/activeRow[2]_5[2]} {memcon/ram/activeRow[2]_5[3]} {memcon/ram/activeRow[2]_5[4]} {memcon/ram/activeRow[2]_5[5]} {memcon/ram/activeRow[2]_5[6]} {memcon/ram/activeRow[2]_5[7]} {memcon/ram/activeRow[2]_5[8]} {memcon/ram/activeRow[2]_5[9]} {memcon/ram/activeRow[2]_5[10]} {memcon/ram/activeRow[2]_5[11]} {memcon/ram/activeRow[2]_5[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {memcon/ram/activeBank[0]_0}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {memcon/ram/activeBank[1]_1}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {memcon/ram/activeBank[2]_2}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {memcon/ram/activeBank[3]_3}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list memcon/ram/targetUL]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets s_clk_OBUF_BUFG]
