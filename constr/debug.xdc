


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_50_in_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 7 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {debug_clk[0]} {debug_clk[1]} {debug_clk[2]} {debug_clk[3]} {debug_clk[4]} {debug_clk[5]} {debug_clk[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pc[0]} {pc[1]} {pc[2]} {pc[3]} {pc[4]} {pc[5]} {pc[6]} {pc[7]} {pc[8]} {pc[9]} {pc[10]} {pc[11]} {pc[12]} {pc[13]} {pc[14]} {pc[15]} {pc[16]} {pc[17]} {pc[18]} {pc[19]} {pc[20]} {pc[21]} {pc[22]} {pc[23]} {pc[24]} {pc[25]} {pc[26]} {pc[27]} {pc[28]} {pc[29]} {pc[30]} {pc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {memcon/card/inter/state[0]} {memcon/card/inter/state[1]} {memcon/card/inter/state[2]} {memcon/card/inter/state[3]} {memcon/card/inter/state[4]} {memcon/card/inter/state[5]} {memcon/card/inter/state[6]} {memcon/card/inter/state[7]} {memcon/card/inter/state[8]} {memcon/card/inter/state[9]} {memcon/card/inter/state[10]} {memcon/card/inter/state[11]} {memcon/card/inter/state[12]} {memcon/card/inter/state[13]} {memcon/card/inter/state[14]} {memcon/card/inter/state[15]} {memcon/card/inter/state[16]} {memcon/card/inter/state[17]} {memcon/card/inter/state[18]} {memcon/card/inter/state[19]} {memcon/card/inter/state[20]} {memcon/card/inter/state[21]} {memcon/card/inter/state[22]} {memcon/card/inter/state[23]} {memcon/card/inter/state[24]} {memcon/card/inter/state[25]} {memcon/card/inter/state[26]} {memcon/card/inter/state[27]} {memcon/card/inter/state[28]} {memcon/card/inter/state[29]} {memcon/card/inter/state[30]} {memcon/card/inter/state[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 7 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {state[0]} {state[1]} {state[2]} {state[3]} {state[4]} {state[5]} {state[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {memcon/state[0]} {memcon/state[1]} {memcon/state[2]} {memcon/state[3]} {memcon/state[4]} {memcon/state[5]} {memcon/state[6]} {memcon/state[7]} {memcon/state[8]} {memcon/state[9]} {memcon/state[10]} {memcon/state[11]} {memcon/state[12]} {memcon/state[13]} {memcon/state[14]} {memcon/state[15]} {memcon/state[16]} {memcon/state[17]} {memcon/state[18]} {memcon/state[19]} {memcon/state[20]} {memcon/state[21]} {memcon/state[22]} {memcon/state[23]} {memcon/state[24]} {memcon/state[25]} {memcon/state[26]} {memcon/state[27]} {memcon/state[28]} {memcon/state[29]} {memcon/state[30]} {memcon/state[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {instrcounter[0]} {instrcounter[1]} {instrcounter[2]} {instrcounter[3]} {instrcounter[4]} {instrcounter[5]} {instrcounter[6]} {instrcounter[7]} {instrcounter[8]} {instrcounter[9]} {instrcounter[10]} {instrcounter[11]} {instrcounter[12]} {instrcounter[13]} {instrcounter[14]} {instrcounter[15]} {instrcounter[16]} {instrcounter[17]} {instrcounter[18]} {instrcounter[19]} {instrcounter[20]} {instrcounter[21]} {instrcounter[22]} {instrcounter[23]} {instrcounter[24]} {instrcounter[25]} {instrcounter[26]} {instrcounter[27]} {instrcounter[28]} {instrcounter[29]} {instrcounter[30]} {instrcounter[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {instruction[0]} {instruction[1]} {instruction[2]} {instruction[3]} {instruction[4]} {instruction[5]} {instruction[6]} {instruction[7]} {instruction[8]} {instruction[9]} {instruction[10]} {instruction[11]} {instruction[12]} {instruction[13]} {instruction[14]} {instruction[15]} {instruction[16]} {instruction[17]} {instruction[18]} {instruction[19]} {instruction[20]} {instruction[21]} {instruction[22]} {instruction[23]} {instruction[24]} {instruction[25]} {instruction[26]} {instruction[27]} {instruction[28]} {instruction[29]} {instruction[30]} {instruction[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {gpio_OBUF[0]} {gpio_OBUF[1]} {gpio_OBUF[2]} {gpio_OBUF[3]} {gpio_OBUF[4]} {gpio_OBUF[5]} {gpio_OBUF[6]} {gpio_OBUF[7]} {gpio_OBUF[8]} {gpio_OBUF[9]} {gpio_OBUF[10]} {gpio_OBUF[11]} {gpio_OBUF[12]} {gpio_OBUF[13]} {gpio_OBUF[14]} {gpio_OBUF[15]} {gpio_OBUF[16]} {gpio_OBUF[17]} {gpio_OBUF[18]} {gpio_OBUF[19]} {gpio_OBUF[20]} {gpio_OBUF[21]} {gpio_OBUF[22]} {gpio_OBUF[23]} {gpio_OBUF[24]} {gpio_OBUF[25]} {gpio_OBUF[26]} {gpio_OBUF[27]} {gpio_OBUF[28]} {gpio_OBUF[29]} {gpio_OBUF[30]} {gpio_OBUF[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {mem_in[0]} {mem_in[1]} {mem_in[2]} {mem_in[3]} {mem_in[4]} {mem_in[5]} {mem_in[6]} {mem_in[7]} {mem_in[8]} {mem_in[9]} {mem_in[10]} {mem_in[11]} {mem_in[12]} {mem_in[13]} {mem_in[14]} {mem_in[15]} {mem_in[16]} {mem_in[17]} {mem_in[18]} {mem_in[19]} {mem_in[20]} {mem_in[21]} {mem_in[22]} {mem_in[23]} {mem_in[24]} {mem_in[25]} {mem_in[26]} {mem_in[27]} {mem_in[28]} {mem_in[29]} {mem_in[30]} {mem_in[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {mem_addr[0]} {mem_addr[1]} {mem_addr[2]} {mem_addr[3]} {mem_addr[4]} {mem_addr[5]} {mem_addr[6]} {mem_addr[7]} {mem_addr[8]} {mem_addr[9]} {mem_addr[10]} {mem_addr[11]} {mem_addr[12]} {mem_addr[13]} {mem_addr[14]} {mem_addr[15]} {mem_addr[16]} {mem_addr[17]} {mem_addr[18]} {mem_addr[19]} {mem_addr[20]} {mem_addr[21]} {mem_addr[22]} {mem_addr[23]} {mem_addr[24]} {mem_addr[25]} {mem_addr[26]} {mem_addr[27]} {mem_addr[28]} {mem_addr[29]} {mem_addr[30]} {mem_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {mem_out[0]} {mem_out[1]} {mem_out[2]} {mem_out[3]} {mem_out[4]} {mem_out[5]} {mem_out[6]} {mem_out[7]} {mem_out[8]} {mem_out[9]} {mem_out[10]} {mem_out[11]} {mem_out[12]} {mem_out[13]} {mem_out[14]} {mem_out[15]} {mem_out[16]} {mem_out[17]} {mem_out[18]} {mem_out[19]} {mem_out[20]} {mem_out[21]} {mem_out[22]} {mem_out[23]} {mem_out[24]} {mem_out[25]} {mem_out[26]} {mem_out[27]} {mem_out[28]} {mem_out[29]} {mem_out[30]} {mem_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list mem_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list mem_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list mem_we]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list uart_in_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list uart_out_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_50_in_IBUF_BUFG]
