// SPDX-FileCopyrightText: 2024 Anton Maurovic <anton@maurovic.com>
// SPDX-License-Identifier: Apache-2.0

// This test:
// - Enables clock debug, i.e. wb_clk_i output on GPIO14, user_clock2 output on GPIO15
// - Enables the DLL and configures the clock for 2.5x speed (25MHz from 10MHz source)
// - Goes into a blink loop at the end

#include <defs.h>
#include <stub.h>


void pulse_gpio()
{
    reg_gpio_out = 1;
    reg_gpio_out = 0;
}


void delay(const int d)
{
    // Configure timer for a single-shot countdown:
    reg_timer0_config = 0;
    reg_timer0_data = d;
    reg_timer0_config = 1;
    // Loop, waiting for value to reach zero:
    reg_timer0_update = 1;  // latch current value
    while (reg_timer0_value > 0) {
        reg_timer0_update = 1;
    }
}


void main()
{
    // Signal via the SoC's single 'gpio' pin that we're starting our main code execution...
    // Start with gpio=0:
    reg_gpio_out = 0;
    // Enable gpio OUTPUT:
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0; // reg_gpio_oe = 1;

    pulse_gpio();

    // Enable clock debug output feature for GPIO[15:14]:
    reg_clk_out_dest = 0b110;           // HKSPI 0x1b: [1]:1=wb_clk_i out; [2]:1=user_clock2 out.

    // Multiply clock by 5, to get 50MHz internally:
    reg_hkspi_pll_divider = 5;          // HKSPI 0x12: 5x
    //NOTE: On my chip/board, the DCO seems to max out around 54MHz, per these measurements:
    // I got these core clock measurements:
    // ~26.15MHz * 2 = 52.3MHz
    // ~18MHz * 3 = 54MHz
    // ~13.5MHz * 4 = 54MHz

    // Divide clocks by 2, to get 25MHz on each of wb_clk_i and user_clock2
    reg_hkspi_pll_source = 0b010010;    // HKSPI 0x11: [2:0]:2=div-2; [5:3]:2=div-2

    // Enable DLL, with auto trim:
    reg_hkspi_pll_ena = 0b01;           // HKSPI 0x08: [0]:1=Enable DLL; [1]:0=Use DLL.

    // Disable DLL bypass, i.e. select DLL outputs for clocks:
    reg_hkspi_pll_bypass = 0b0;         // HKSPI 0x09: [0]:0=Disable bypass

    // Clock debug output on GPIO[15:14] requires they are set to MGMT OUTPUT:
    reg_mprj_io_14  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_15  = GPIO_MODE_MGMT_STD_OUTPUT;

    // Apply the above GPIO configuration:
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    while (1) {
        reg_gpio_out = 1;   // LED D3 OFF
        delay(1000000);
        reg_gpio_out = 0;   // LED D3 ON
        delay(1000000);
    }
}

