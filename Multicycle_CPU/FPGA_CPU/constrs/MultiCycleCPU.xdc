set_property PACKAGE_PIN T18 [get_ports reset]
set_property PACKAGE_PIN W5 [get_ports sysclk]
# reset
set_property PACKAGE_PIN U17 [get_ports BTND]

# SW1
set_property PACKAGE_PIN V16 [get_ports {display[1]}]
# SW0
set_property PACKAGE_PIN V17 [get_ports {display[0]}]

# choose bcd to display
set_property PACKAGE_PIN W4 [get_ports {bcd_choose[0]}]
set_property PACKAGE_PIN V4 [get_ports {bcd_choose[1]}]
set_property PACKAGE_PIN U4 [get_ports {bcd_choose[2]}]
set_property PACKAGE_PIN U2 [get_ports {bcd_choose[3]}]

# display bcd
set_property PACKAGE_PIN W7 [get_ports {bcd_display[0]}]
set_property PACKAGE_PIN W6 [get_ports {bcd_display[1]}]
set_property PACKAGE_PIN U8 [get_ports {bcd_display[2]}]
set_property PACKAGE_PIN V8 [get_ports {bcd_display[3]}]
set_property PACKAGE_PIN U5 [get_ports {bcd_display[4]}]
set_property PACKAGE_PIN V5 [get_ports {bcd_display[5]}]
set_property PACKAGE_PIN U7 [get_ports {bcd_display[6]}]
set_property PACKAGE_PIN V7 [get_ports {bcd_display[7]}]

# display pc
set_property PACKAGE_PIN V14 [get_ports {pc_display[7]}]
set_property PACKAGE_PIN U14 [get_ports {pc_display[6]}]
set_property PACKAGE_PIN U15 [get_ports {pc_display[5]}]
set_property PACKAGE_PIN W18 [get_ports {pc_display[4]}]
set_property PACKAGE_PIN V19 [get_ports {pc_display[3]}]
set_property PACKAGE_PIN U19 [get_ports {pc_display[2]}]
set_property PACKAGE_PIN E19 [get_ports {pc_display[1]}]
set_property PACKAGE_PIN U16 [get_ports {pc_display[0]}]






set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
set_property IOSTANDARD LVCMOS33 [get_ports BTND]
set_property IOSTANDARD LVCMOS33 [get_ports {display[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_choose[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_choose[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_choose[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_choose[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bcd_display[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pc_display[0]}]








create_clock -period 10.000 -name sysclk -waveform {0.000 5.000} -add [get_ports sysclk]
