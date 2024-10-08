// SPDX-FileCopyrightText: 2024 Anton Maurovic <anton@maurovic.com>
// SPDX-License-Identifier: Apache-2.0

#include <defs.h>
#include <stub.h>


//NOTE: MUX_DESIGN should be defined via the compiler call in the Makefile, rather than explicitly:
// i.e. "make flash" should default to 13, but override with:
// "MUX_DESIGN=12 make clean flash" or whatever.
#ifndef MUX_DESIGN
  #warning "MUX_DESIGN is not defined; using default"
  #define MUX_DESIGN 13
#endif

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

    // Tell the mux to select MUX_DESIGN...

    // I'm basing this code on my earlier instructions here:
    // https://docs.google.com/spreadsheets/d/1kkF1woJQolN3wrGOXv8A0mNClVp3Keje3pYb4Swyta0/edit#gid=1173864902&range=44:44

    // Configure 1st & 2nd LA bank for UPW 'input'
    // (i.e. output from SoC, input to the user project area):
    LA0_UPW_OEB = LA0_UPW_IE = 0xffffffff;  // LA bank 0; for all: disable OEb, enable IE.
    LA1_UPW_OEB = LA1_UPW_IE = 0xffffffff;  // LA bank 1; for all: disable OEb, enable IE.
    // la_data_in[63:0] are now writable via LA0_CPU_OUT and LA1_CPU_OUT

    // Set la_data_in[31:0] all 0:
    LA0_CPU_OUT = 0;
    // Prepare the values that WILL be written into the
    // mux registers after 2 mux_conf_clk rising edges:
    uint32_t la1;
    la1 =
     0b01111111101000010000000000000000;
    // 0-------------------------------     mux_conf_clk: Start with mux configuration clock low
    // -11111111-----------------------     i_design_reset[7:0]: All asserted
    // ---------0----------------------     i_mux_auto_reset_enb: 0=auto-reset non-selected designs
    // ----------1---------------------     i_mux_sys_reset_enb: 1=do not use wb_rst_i as a reset
    // -----------DDDD-----------------     i_mux_sel[3:0]=0000, but patched in below from MUX_DESIGN
    // ---------------1----------------     i_mux_io5_reset_enb: 1=Do not use io[5] as a reset
    // ----------------XXXXXXXXXXXXXXXX     Unused.
    la1 |=        MUX_DESIGN << 17;
    LA1_CPU_OUT = la1;

    // Pulse mux_conf_clk once...
    LA1_CPU_OUT = (la1 |=  0x80000000);
    LA1_CPU_OUT = (la1 &= ~0x80000000);
    // ...and again:
    LA1_CPU_OUT = (la1 |=  0x80000000);
    LA1_CPU_OUT = (la1 &= ~0x80000000);

    // MUX_DESIGN should now be selected on the mux, but note that All GPIOs start in
    // INPUT mode by default (per user_defines), so we won't see the
    // intended output until the GPIO modes are reconfigured...

    // Let's set GPIO[37:8] to BIDIRECTIONAL mode, since the GPIO OEBs should
    // be driven by the mux:
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

    // If MUX_DESIGN is 13, hopefully now we should see 0x55AA presenting on GPIO[31:16].

    // Now blink the gpio endlessly at about 12.5Hz to show we're done:
    uint32_t la0 = 0b10101100111000111100001111100000; // This is just a pattern we rotate through.
    while (1) {
        reg_gpio_out = 1;   // LED D3 OFF
        LA0_CPU_OUT = la0;
        la0 = (la0 << 1) | (la0 >> 31); // Rotate pattern left by 1.
        delay(400000);
        reg_gpio_out = 0;   // LED D3 ON
        delay(400000);
    }
}

