set_property top controller [current_fileset]
set_property top_file {/home/raiku/Git/Benzaiten/src/controller.sv} [current_fileset]

# Ports
set_property PACKAGE_PIN C8 [get_ports led_1]
set_property IOSTANDARD LVCMOS33 [get_ports led_1]

# set_property PACKAGE_PIN D8 [get_ports led_2]
# set_property IOSTANDARD LVCMOS33 [get_ports led_2]

# button 0
set_property PACKAGE_PIN H18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# set_property PACKAGE_PIN H17 [get_ports button_1]
# set_property IOSTANDARD LVCMOS33 [get_ports button_1]

set_property PACKAGE_PIN R2 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN U7 [get_ports sd_dat0]
set_property IOSTANDARD LVCMOS33 [get_ports sd_dat0]

set_property PACKAGE_PIN T7 [get_ports sd_dat1]
set_property IOSTANDARD LVCMOS33 [get_ports sd_dat1]

set_property PACKAGE_PIN R6 [get_ports sd_dat2]
set_property IOSTANDARD LVCMOS33 [get_ports sd_dat2]

set_property PACKAGE_PIN R5 [get_ports sd_dat3]
set_property IOSTANDARD LVCMOS33 [get_ports sd_dat3]

set_property PACKAGE_PIN U6 [get_ports sd_cmd]
set_property IOSTANDARD LVCMOS33 [get_ports sd_cmd]

set_property PACKAGE_PIN V4 [get_ports sd_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sd_clk]
