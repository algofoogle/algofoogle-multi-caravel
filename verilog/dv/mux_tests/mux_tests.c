// SPDX-FileCopyrightText: 2023 Anton Maurovic <anton@maurovic.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

#include <defs.h>
#include <stub.c>

/*
IO Control Registers

| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
|--------|-------|-------|--------|--------|-------|---------|---------|-------|-------|---------|
| Output: GPIO_MODE_USER_STD_OUTPUT         = 0000_0110_0000_1110 (0x1808)                       |
| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
| Input:  GPIO_MODE_USER_STD_INPUT_NOPULL   = 0000_0001_0000_1111 (0x0402)                       |
| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |
*/

void pulse_gpio()
{
    reg_gpio_out = 1;
    reg_gpio_out = 0;
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
    reg_gpio_oe = 1;

    pulse_gpio();

    // We'll start with mux design 13, then 14, for a simple test of selectable outputs.

    // I'm basing this code on my earlier instructions here:
    // https://docs.google.com/spreadsheets/d/1kkF1woJQolN3wrGOXv8A0mNClVp3Keje3pYb4Swyta0/edit#gid=1173864902&range=44:44

    // Let's start by selecting design 13, which should:
    // - Make GPIO[31:16] present 0x55AA
    // - Make all other GPIOs inputs

    // Configure 2nd LA bank for 'input'
    // (i.e. output from SoC, input to the user project area):
    reg_la1_oenb = reg_la1_iena = 0xffffffff;
    // la_data_in[63:32] are now writable.

    // Prepare the values that WILL be written into the
    // mux registers after 2 mux_conf_clk rising edges:
    uint32_t la1;
    reg_la1_data = la1 =
     0b01111111101110110000000000000000;
    // 0-------------------------------     mux_conf_clk: Start with mux configuration clock low
    // -11111111-----------------------     i_design_reset[7:0]: All asserted
    // ---------0----------------------     i_mux_auto_reset_enb: 0=auto-reset non-selected designs
    // ----------1---------------------     i_mux_sys_reset_enb: 1=do not use wb_rst_i as a reset
    // -----------1101-----------------     i_mux_sel[3:0]=1101: We'll select design 13
    // ---------------1----------------     i_mux_io5_reset_enb: 1=Do not use io[5] as a reset
    // ----------------XXXXXXXXXXXXXXXX     Unused.

    // Pulse mux_conf_clk once...
    reg_la1_data = (la1 |= 0x80000000);
    reg_la1_data = (la1 ^= 0x80000000);
    // ...and again:
    reg_la1_data = (la1 |= 0x80000000);
    reg_la1_data = (la1 ^= 0x80000000);

    // Design 13 should now be selected, but note that All GPIOs start in
    // INPUT mode by default (per user_defines), so we won't see the
    // intended output until the GPIO modes are reconfigured...

    // Let's set GPIO[37:8] to BIDIRECTIONAL mode, since our OEBs should
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

    // Hopefully now we should see 0x55AA presenting on GPIO[31:16].

    // Pulse gpio again to show that the firmware completed its first task:
    pulse_gpio();

    // Now we'll set up to select design 14:

    reg_la1_data = la1 =
     0b01111111101111010000000000000000;
    // -----------1110-----------------     // Design 14.

    // Pulse mux_conf_clk once...
    reg_la1_data = (la1 |= 0x80000000);
    reg_la1_data = (la1 ^= 0x80000000);
    // ...and again:
    reg_la1_data = (la1 |= 0x80000000);
    reg_la1_data = (la1 ^= 0x80000000);

    // Pulse gpio again to show we're now finished:
    pulse_gpio();

    // No need for anything else as this design is free running and the
    // SoC knows to halt at the exit of main().

}
