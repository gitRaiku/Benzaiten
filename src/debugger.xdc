



connect_debug_port u_ila_0/probe1 [get_nets [list {s_dq_OBUF[0]} {s_dq_OBUF[1]} {s_dq_OBUF[2]} {s_dq_OBUF[3]} {s_dq_OBUF[4]} {s_dq_OBUF[5]} {s_dq_OBUF[6]} {s_dq_OBUF[7]} {s_dq_OBUF[8]} {s_dq_OBUF[9]} {s_dq_OBUF[10]} {s_dq_OBUF[11]} {s_dq_OBUF[12]} {s_dq_OBUF[13]} {s_dq_OBUF[14]} {s_dq_OBUF[15]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list s_cke_OBUF]]




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
connect_debug_port u_ila_0/clk [get_nets [list clankka/s_clk_OBUF]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {s_addr_OBUF[0]} {s_addr_OBUF[3]} {s_addr_OBUF[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 7 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {sukondez/powerupState_reg[0]} {sukondez/powerupState_reg[1]} {sukondez/powerupState_reg[2]} {sukondez/powerupState_reg[3]} {sukondez/powerupState_reg[4]} {sukondez/powerupState_reg[5]} {sukondez/powerupState_reg[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {s_dq_OBUF[0]} {s_dq_OBUF[1]} {s_dq_OBUF[2]} {s_dq_OBUF[3]} {s_dq_OBUF[4]} {s_dq_OBUF[5]} {s_dq_OBUF[6]} {s_dq_OBUF[7]} {s_dq_OBUF[8]} {s_dq_OBUF[9]} {s_dq_OBUF[10]} {s_dq_OBUF[11]} {s_dq_OBUF[12]} {s_dq_OBUF[13]} {s_dq_OBUF[14]} {s_dq_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {s_dq_IBUF[0]} {s_dq_IBUF[1]} {s_dq_IBUF[2]} {s_dq_IBUF[3]} {s_dq_IBUF[4]} {s_dq_IBUF[5]} {s_dq_IBUF[6]} {s_dq_IBUF[7]} {s_dq_IBUF[8]} {s_dq_IBUF[9]} {s_dq_IBUF[10]} {s_dq_IBUF[11]} {s_dq_IBUF[12]} {s_dq_IBUF[13]} {s_dq_IBUF[14]} {s_dq_IBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list s_cas_n_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {s_dq_TRI[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list s_ras_n_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list s_we_n_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets s_clk_OBUF]
