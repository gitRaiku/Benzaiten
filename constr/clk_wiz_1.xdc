create_clock -period 20.000 [get_ports clk_50_in]
set_input_jitter [get_clocks -of_objects [get_ports clk_50_in]] 0.200
