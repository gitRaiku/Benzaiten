

connect_debug_port u_ila_0/clk [get_nets [list s_clk_OBUF_BUFG]]
connect_debug_port dbg_hub/clk [get_nets s_clk_OBUF_BUFG]









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
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {memcon/card/inter/nnstate[0]} {memcon/card/inter/nnstate[1]} {memcon/card/inter/nnstate[2]} {memcon/card/inter/nnstate[3]} {memcon/card/inter/nnstate[4]} {memcon/card/inter/nnstate[5]} {memcon/card/inter/nnstate[6]} {memcon/card/inter/nnstate[7]} {memcon/card/inter/nnstate[8]} {memcon/card/inter/nnstate[9]} {memcon/card/inter/nnstate[10]} {memcon/card/inter/nnstate[11]} {memcon/card/inter/nnstate[12]} {memcon/card/inter/nnstate[13]} {memcon/card/inter/nnstate[14]} {memcon/card/inter/nnstate[15]} {memcon/card/inter/nnstate[16]} {memcon/card/inter/nnstate[17]} {memcon/card/inter/nnstate[18]} {memcon/card/inter/nnstate[19]} {memcon/card/inter/nnstate[20]} {memcon/card/inter/nnstate[21]} {memcon/card/inter/nnstate[22]} {memcon/card/inter/nnstate[23]} {memcon/card/inter/nnstate[24]} {memcon/card/inter/nnstate[25]} {memcon/card/inter/nnstate[26]} {memcon/card/inter/nnstate[27]} {memcon/card/inter/nnstate[28]} {memcon/card/inter/nnstate[29]} {memcon/card/inter/nnstate[30]} {memcon/card/inter/nnstate[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 7 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {memcon/card/inter/debug_clk[0]} {memcon/card/inter/debug_clk[1]} {memcon/card/inter/debug_clk[2]} {memcon/card/inter/debug_clk[3]} {memcon/card/inter/debug_clk[4]} {memcon/card/inter/debug_clk[5]} {memcon/card/inter/debug_clk[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {memcon/card/inter/state_timeout[0]} {memcon/card/inter/state_timeout[1]} {memcon/card/inter/state_timeout[2]} {memcon/card/inter/state_timeout[3]} {memcon/card/inter/state_timeout[4]} {memcon/card/inter/state_timeout[5]} {memcon/card/inter/state_timeout[6]} {memcon/card/inter/state_timeout[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {memcon/card/inter/last_rec_byte[0]} {memcon/card/inter/last_rec_byte[1]} {memcon/card/inter/last_rec_byte[2]} {memcon/card/inter/last_rec_byte[3]} {memcon/card/inter/last_rec_byte[4]} {memcon/card/inter/last_rec_byte[5]} {memcon/card/inter/last_rec_byte[6]} {memcon/card/inter/last_rec_byte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {memcon/card/inter/state[0]} {memcon/card/inter/state[1]} {memcon/card/inter/state[2]} {memcon/card/inter/state[3]} {memcon/card/inter/state[4]} {memcon/card/inter/state[5]} {memcon/card/inter/state[6]} {memcon/card/inter/state[7]} {memcon/card/inter/state[8]} {memcon/card/inter/state[9]} {memcon/card/inter/state[10]} {memcon/card/inter/state[11]} {memcon/card/inter/state[12]} {memcon/card/inter/state[13]} {memcon/card/inter/state[14]} {memcon/card/inter/state[15]} {memcon/card/inter/state[16]} {memcon/card/inter/state[17]} {memcon/card/inter/state[18]} {memcon/card/inter/state[19]} {memcon/card/inter/state[20]} {memcon/card/inter/state[21]} {memcon/card/inter/state[22]} {memcon/card/inter/state[23]} {memcon/card/inter/state[24]} {memcon/card/inter/state[25]} {memcon/card/inter/state[26]} {memcon/card/inter/state[27]} {memcon/card/inter/state[28]} {memcon/card/inter/state[29]} {memcon/card/inter/state[30]} {memcon/card/inter/state[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {memcon/card/inter/state_timeout1[0]} {memcon/card/inter/state_timeout1[1]} {memcon/card/inter/state_timeout1[2]} {memcon/card/inter/state_timeout1[3]} {memcon/card/inter/state_timeout1[4]} {memcon/card/inter/state_timeout1[5]} {memcon/card/inter/state_timeout1[6]} {memcon/card/inter/state_timeout1[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {memcon/card/inter/send_buffer_len[0]} {memcon/card/inter/send_buffer_len[1]} {memcon/card/inter/send_buffer_len[2]} {memcon/card/inter/send_buffer_len[3]} {memcon/card/inter/send_buffer_len[4]} {memcon/card/inter/send_buffer_len[5]} {memcon/card/inter/send_buffer_len[6]} {memcon/card/inter/send_buffer_len[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {memcon/card/inter/send_curbufpos[0]} {memcon/card/inter/send_curbufpos[1]} {memcon/card/inter/send_curbufpos[2]} {memcon/card/inter/send_curbufpos[3]} {memcon/card/inter/send_curbufpos[4]} {memcon/card/inter/send_curbufpos[5]} {memcon/card/inter/send_curbufpos[6]} {memcon/card/inter/send_curbufpos[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 6 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {memcon/card/inter/sdspi/cpos[0]} {memcon/card/inter/sdspi/cpos[1]} {memcon/card/inter/sdspi/cpos[2]} {memcon/card/inter/sdspi/cpos[3]} {memcon/card/inter/sdspi/cpos[4]} {memcon/card/inter/sdspi/cpos[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {memcon/card/inter/sdspi/ibuf[0]} {memcon/card/inter/sdspi/ibuf[1]} {memcon/card/inter/sdspi/ibuf[2]} {memcon/card/inter/sdspi/ibuf[3]} {memcon/card/inter/sdspi/ibuf[4]} {memcon/card/inter/sdspi/ibuf[5]} {memcon/card/inter/sdspi/ibuf[6]} {memcon/card/inter/sdspi/ibuf[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 10 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {memcon/card/inter/read_blockpos[0]} {memcon/card/inter/read_blockpos[1]} {memcon/card/inter/read_blockpos[2]} {memcon/card/inter/read_blockpos[3]} {memcon/card/inter/read_blockpos[4]} {memcon/card/inter/read_blockpos[5]} {memcon/card/inter/read_blockpos[6]} {memcon/card/inter/read_blockpos[7]} {memcon/card/inter/read_blockpos[8]} {memcon/card/inter/read_blockpos[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {memcon/card/inter/nstate[0]} {memcon/card/inter/nstate[1]} {memcon/card/inter/nstate[2]} {memcon/card/inter/nstate[3]} {memcon/card/inter/nstate[4]} {memcon/card/inter/nstate[5]} {memcon/card/inter/nstate[6]} {memcon/card/inter/nstate[7]} {memcon/card/inter/nstate[8]} {memcon/card/inter/nstate[9]} {memcon/card/inter/nstate[10]} {memcon/card/inter/nstate[11]} {memcon/card/inter/nstate[12]} {memcon/card/inter/nstate[13]} {memcon/card/inter/nstate[14]} {memcon/card/inter/nstate[15]} {memcon/card/inter/nstate[16]} {memcon/card/inter/nstate[17]} {memcon/card/inter/nstate[18]} {memcon/card/inter/nstate[19]} {memcon/card/inter/nstate[20]} {memcon/card/inter/nstate[21]} {memcon/card/inter/nstate[22]} {memcon/card/inter/nstate[23]} {memcon/card/inter/nstate[24]} {memcon/card/inter/nstate[25]} {memcon/card/inter/nstate[26]} {memcon/card/inter/nstate[27]} {memcon/card/inter/nstate[28]} {memcon/card/inter/nstate[29]} {memcon/card/inter/nstate[30]} {memcon/card/inter/nstate[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {memcon/card/inter/sdspi/obuf[0]} {memcon/card/inter/sdspi/obuf[1]} {memcon/card/inter/sdspi/obuf[2]} {memcon/card/inter/sdspi/obuf[3]} {memcon/card/inter/sdspi/obuf[4]} {memcon/card/inter/sdspi/obuf[5]} {memcon/card/inter/sdspi/obuf[6]} {memcon/card/inter/sdspi/obuf[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list memcon/card/inter/sdspi/enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list memcon/card/inter/sdspi/miso]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list memcon/card/inter/sdspi/mosi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list memcon/card/inter/sdspi/sclk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list memcon/card/inter/send_cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list memcon/card/inter/send_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list memcon/card/inter/send_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list memcon/card/inter/spi_clk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list memcon/card/inter/sdspi/ss_n]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list memcon/card/inter/sdspi/valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_50_in_IBUF_BUFG]
