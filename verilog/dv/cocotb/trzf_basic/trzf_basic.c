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

// ####################
// ## If you want to know how to use the mux properly, consider checking out:
// ## https://github.com/algofoogle/journal/blob/master/0187-2023-12-09.md#using-la-pins-to-control-the-mux
// ## ...and read about the different reset options that you can register.

#include <firmware_apis.h> // include required APIs

uint32_t la1 = 0;

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
    ManagmentGpio_write(1);
    ManagmentGpio_write(0);
}

void load_mux_state(uint32_t state)
{
    LogicAnalyzer_write(LA_REG_1, state & ~MUX_CLK); // Assert state with clk low.
    // Pulse mux_conf_clk once...
    LogicAnalyzer_write(LA_REG_1, state |  MUX_CLK); // Raise clk.
    LogicAnalyzer_write(LA_REG_1, state & ~MUX_CLK); // Lower clk.
    // ...and again:
    LogicAnalyzer_write(LA_REG_1, state |  MUX_CLK); // Raise clk.
    LogicAnalyzer_write(LA_REG_1, state & ~MUX_CLK); // Lower clk.
}

void main()
{
    // Set up the SoC's single 'gpio' pin so we can toggle it to sync tests:
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    pulse_gpio();

    // We'll start with mux design 13, then 14, for a simple test of selectable outputs.

    // I'm basing this code on my earlier instructions here:
    // https://docs.google.com/spreadsheets/d/1kkF1woJQolN3wrGOXv8A0mNClVp3Keje3pYb4Swyta0/edit#gid=1173864902&range=44:44

    // Make all LA[63:32] outputs INTO the user design:
    LogicAnalyzer_outputEnable(LA_REG_1, 0);

    // // Prepare the values that WILL be written into the
    // // mux registers after 2 mux_conf_clk rising edges:
    // la1 =
    //  0b01111111001000010000000000000000;
    // // 0-------------------------------     mux_conf_clk: Start with mux configuration clock low
    // // -11111110-----------------------     i_design_reset[7:0]: All asserted
    // // ---------0----------------------     i_mux_auto_reset_enb: 0=auto-reset non-selected designs
    // // ----------1---------------------     i_mux_sys_reset_enb: 1=do not use wb_rst_i as a reset
    // // -----------0000-----------------     i_mux_sel[3:0]=0000: We'll select design 0
    // // ---------------1----------------     i_mux_io5_reset_enb: 1=Do not use io[5] as a reset
    // // ----------------XXXXXXXXXXXXXXXX     Unused.

    la1 = MUX_SEL(0)        // Select design 0.
        | MUX_NORESET(0)    // Assert reset for all but design 0.
        | MUX_IO5R_DIS      // Disable resetting via io_in[5]
        | MUX_SYSR_DIS      // Disable resetting via wb_rst_i
        | MUX_AUTOR_ENA;    // Enable auto-reset; i.e. automatically hold all designs in reset (except for the selected one)
    //NOTE: la1 should now be 0x7F210000
    
    load_mux_state(la1);

    // Design 0 should now be selected, but note that All GPIOs start in
    // INPUT mode by default (per user_defines), so we won't see the
    // intended output until the GPIO modes are reconfigured...

    // Let's set GPIO[37:8] to BIDIRECTIONAL mode, since our OEBs should
    // be driven by the mux...
    GPIOs_configureAll(GPIO_MODE_USER_STD_BIDIRECTIONAL); // Set all...
    // ...but then change our mind for just the first 8:
    for (int i=0; i<8; ++i)
        GPIOs_configure(i, GPIO_MODE_MGMT_STD_INPUT_NOPULL);

    // Apply the above configuration:
    GPIOs_loadConfigs();

    // Pulse gpio again to show that the firmware completed its first task:
    pulse_gpio();

    // Now pulse reset for design 0...
    LogicAnalyzer_write(LA_REG_1, la1 |  MUX_RESET(0));
    LogicAnalyzer_write(LA_REG_1, la1 & ~MUX_RESET(0));

    // Final gpio pulse to show that we're done:
    pulse_gpio();

    // No need for anything else as this design is free running and the
    // SoC knows to halt at the exit of main().

}
