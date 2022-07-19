create_clock -period 20.0 [get_ports clk]
derive_pll_clocks
derive_clock_uncertainty

create_generated_clock -source PLL_inst|altpll_component|pll|clk[2] -name mem_clk [get_ports sdram_clk]

set_false_path -from * -to [get_ports {ledr* ledg* txd ps2_clk ps2_data hex0_d* hex1_d* hex2_d* hex3_d*}]
#set_false_path -from * -to [get_ports {vga_r* vga_g* vga_b* vga_hsync vga_vsync}]

set_false_path -from [get_ports {switch* button* rxd ps2_clk ps2_data}] -to *

# board delay + Tco(max) of external devices (memory)
set_input_delay -clock mem_clk -max 6.0 [get_ports {sdram_dq[*]}]

# board delay + Tco(min) of external devices
set_input_delay -clock mem_clk -min 2.5 [get_ports {sdram_dq[*]}]

# board delay + Tsu of external devices
set_output_delay -clock mem_clk -max 1.5 [get_ports {sdram_cke sdram_cs_n sdram_wre_n sdram_cas_n sdram_ras_n sdram_a* sdram_ba* sdram_dqm* sdram_dq[*]}]

# board delay - Th of external devices
set_output_delay -clock mem_clk -min -0.8 [get_ports {sdram_cke sdram_cs_n sdram_wre_n sdram_cas_n sdram_ras_n sdram_a* sdram_ba* sdram_dqm* sdram_dq[*]}]

set_input_delay -clock PLL_inst|altpll_component|pll|clk[1] -max 5.0 [get_ports {flash_d[*]}]
set_input_delay -clock PLL_inst|altpll_component|pll|clk[1] -min 4.0 [get_ports {flash_d[*]}]
set_output_delay -clock PLL_inst|altpll_component|pll|clk[1] -max 5.0 [get_ports {flash_d[*] flash_a* flash_we_n flash_reset_n flash_ce_n flash_oe_n}]
set_output_delay -clock PLL_inst|altpll_component|pll|clk[1] -min 0.0 [get_ports {flash_d[*] flash_a* flash_we_n flash_reset_n flash_ce_n flash_oe_n}]

set_input_delay -clock PLL_inst|altpll_component|pll|clk[1] -max 5.0 [get_ports {sram_d[*]}]
set_input_delay -clock PLL_inst|altpll_component|pll|clk[1] -min 4.0 [get_ports {sram_d[*]}]
set_output_delay -clock PLL_inst|altpll_component|pll|clk[1] -max 5.0 [get_ports {sram_d[*] sram_a* sram_we_n sram_ce_n sram_oe_n sram_lb_n sram_ub_n}]
set_output_delay -clock PLL_inst|altpll_component|pll|clk[1] -min 0.0 [get_ports {sram_d[*] sram_a* sram_we_n sram_ce_n sram_oe_n sram_lb_n sram_ub_n}]
