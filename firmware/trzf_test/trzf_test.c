// SPDX-FileCopyrightText: 2024 Anton Maurovic <anton@maurovic.com>
// SPDX-License-Identifier: Apache-2.0

#include <defs.h>
#include <stub.h>

// These are abstractions of the GFMPW (gf180) LA registers, since they have weird naming.
// Direction is inferred in the name: OEB (Output Enable Bar), IE (Input Enable), IN, OUT,
// but whose *perspective* the direction is in "UPW" vs "CPU".
// GFMPW LA bank 0:
#define LA0_UPW_OEB reg_la2_oenb    // 0 bit means Output Enable from UPW, input to CPU.
#define LA0_UPW_IE  reg_la2_iena    // 1 bit means Input Enable into UPW, output from CPU.
#define LA0_CPU_OUT reg_la2_data    // CPU outputs to UPW via this register.
#define LA0_CPU_IN  reg_la2_data_in // CPU inputs from UPW via this register.
// GFMPW LA bank 1:
#define LA1_UPW_OEB reg_la3_oenb
#define LA1_UPW_IE  reg_la3_iena
#define LA1_CPU_OUT reg_la3_data
#define LA1_CPU_IN  reg_la3_data_in

// Mux control bitfield per 2nd LA bank (LA[63:32]):
// 3322|2222|2222|1111|1111|1100|0000|0000
// 1098|7654|3210|9876|5432|1098|7654|3210
// c---|----|----|----|----|----|----|----     mux_conf_clk: Clocks on rising edge
// -rrr|rrrr|r---|----|----|----|----|----     i_design_reset[7:0]: Active-high reset lines per each of the first 8 design IDs
// ----|----|-a--|----|----|----|----|----     i_mux_auto_reset_enb: 0=auto-reset non-selected designs; 1=disable auto-reset
// ----|----|--s-|----|----|----|----|----     i_mux_sys_reset_enb: 0=propagate wb_rst_i to all designs; 1=do not use wb_rst_i as a reset
// ----|----|---d|ddd-|----|----|----|----     i_mux_sel[3:0]: Design ID to select (upper 8 are tests of the mux itself)
// ----|----|----|---i|----|----|----|----     i_mux_io5_reset_enb: 0=external input from io_in[5] is active-high reset for all designs; 1=Do not use io[5] as a reset
// ----|----|----|----|XXXX|XXXX|XXXX|XXXX     Unused.

#define MUX_SEL(d)              (((d)&0xF)<<17)                     // Pattern to select a specific 4-bit design
#define MUX_IO5R_ENA            0
#define MUX_IO5R_DIS            0x10000                             // Disable io_in[5] reset propagation
#define MUX_SYSR_ENA            0
#define MUX_SYSR_DIS            0x200000                            // Disable wb_rst_i reset propagation
#define MUX_AUTOR_ENA           0
#define MUX_AUTOR_DIS           0x400000                            // Do not auto-reset non-selected designs
#define MUX_RESETS_MASK         0x7F800000
#define MUX_RESET(d)            (1<<(23+(d&7)))                     // Pattern to assert reset for 1 specific design (0..7 input)
#define MUX_NORESET(d)          ((~MUX_RESET(d))&MUX_RESETS_MASK)   // Inverse of above; pattern to reset all BUT 1 specific design (0..7 input)
#define MUX_RESETS(m)           (((m)&0xF)<<23)                     // Takes a specific pattern of resets
#define MUX_CLK                 0x80000000

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


void load_mux_state(uint32_t state)
{
    LA1_CPU_OUT = state & ~MUX_CLK; // Assert state with clk low.
    // Pulse mux_conf_clk once...
    LA1_CPU_OUT = state |  MUX_CLK; // Raise clk.
    LA1_CPU_OUT = state & ~MUX_CLK; // Lower clk.
    // ...and again:
    LA1_CPU_OUT = state |  MUX_CLK; // Raise clk.
    LA1_CPU_OUT = state & ~MUX_CLK; // Lower clk.
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

    // Use DLL to set core clock to 25MHz:
    // Multiply clock by 5, to get 50MHz internally:
    reg_hkspi_pll_divider = 5;          // HKSPI 0x12: 5x
    // Divide clocks by 2, to get 25MHz on each of wb_clk_i and user_clock2
    reg_hkspi_pll_source = 0b010010;    // HKSPI 0x11: [2:0]:2=div-2; [5:3]:2=div-2
    // Enable DLL, with auto trim:
    reg_hkspi_pll_ena = 0b01;           // HKSPI 0x08: [0]:1=Enable DLL; [1]:0=Use DLL.
    // Disable DLL bypass, i.e. select DLL outputs for clocks:
    reg_hkspi_pll_bypass = 0b0;         // HKSPI 0x09: [0]:0=Disable bypass

    // Configure 1st & 2nd LA bank for UPW 'input'
    // (i.e. output from SoC, input to the user project area):
    LA0_UPW_OEB = LA0_UPW_IE = 0xffffffff;  // LA bank 0; for all: disable OEb, enable IE.
    LA1_UPW_OEB = LA1_UPW_IE = 0xffffffff;  // LA bank 1; for all: disable OEb, enable IE.
    // la_data_in[63:0] are now writable via LA0_CPU_OUT and LA1_CPU_OUT

    // Set la_data_in[31:0] all 0:
    LA0_CPU_OUT = 0;

    uint32_t la1
        = MUX_SEL(0)        // Select design 0.
        | MUX_NORESET(0)    // Assert reset for all but design 0.
        | MUX_IO5R_DIS      // Disable resetting via io_in[5]
        | MUX_SYSR_DIS      // Disable resetting via wb_rst_i
        | MUX_AUTOR_ENA;    // Enable auto-reset; i.e. automatically hold all designs in reset (except for the selected one)
    //NOTE: la1 should now be 0x7F210000
    load_mux_state(la1);

    // Set GPIO[37:8] to BIDIRECTIONAL mode, since the GPIO OEBs should
    // be driven by the mux:
    //NOTE: Leave [7:0] with default config; not used by the raybox-zero design.
    reg_mprj_io_8   = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_9   = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_10  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_11  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_12  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_13  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_14  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_15  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_16  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_17  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_18  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_19  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_20  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_21  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_22  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_23  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_24  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_25  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_26  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_27  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_28  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_29  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_30  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_31  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_32  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_33  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_34  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_35  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_36  = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_37  = GPIO_MODE_USER_STD_BIDIRECTIONAL;

    // Apply the above configuration:
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // Now pulse reset for design 0...
    LA1_CPU_OUT = (la1 |=  MUX_RESET(0));
    LA1_CPU_OUT = (la1 &= ~MUX_RESET(0));

    // Select the gpouts that we want:
    // gpout[0] = 3 (clk/4)
    // gpout[1] = 4 (hpos[0] = clk/2)
    // gpout[2] = 1 (clk)
    LA0_CPU_OUT =
        0b0001010000110 << 8;
    //    0001--------- gpout[2] = 1 (clk)
    //    ----0100----- gpout[1] = 4 (hpos[0] = clk/2)
    //    --------0011- gpout[0] = 3 (clk/4)
    //    ------------X unused

    // Now blink the gpio endlessly at about 12.5Hz to show we're done:
    while (1) {
        reg_gpio_out = 1;   // LED D3 OFF
        delay(1000000);
        reg_gpio_out = 0;   // LED D3 ON
        delay(1000000);
    }

}

