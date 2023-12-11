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


void pulse_gpio()
{
    ManagmentGpio_write(1);
    ManagmentGpio_write(0);
}

void main()
{
    // Set up the SoC's single 'gpio' pin so we can toggle it to sync tests:
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    pulse_gpio();

    // Make all LA[63:32] outputs INTO the user design:
    LogicAnalyzer_outputEnable(LA_REG_1, 0);

    // Prepare the values that WILL be written into the
    // mux registers after 2 mux_conf_clk rising edges:
    uint32_t la1 =
     0b01110111101010000000000000000000;
    // 0-------------------------------     mux_conf_clk: Start with mux configuration clock low
    // -11101111-----------------------     i_design_reset[7:0]: All asserted except 4
    // ---------0----------------------     i_mux_auto_reset_enb: 0=auto-reset non-selected designs
    // ----------1---------------------     i_mux_sys_reset_enb: 1=do not use wb_rst_i as a reset
    // -----------0100-----------------     i_mux_sel[3:0]=0100: We'll select design 4
    // ---------------0----------------     i_mux_io5_reset_enb: 0=Use io[5] as a reset
    // ----------------XXXXXXXXXXXXXXXX     Unused.
    LogicAnalyzer_write(LA_REG_1, la1);

    // Pulse mux_conf_clk once...
    LogicAnalyzer_write(LA_REG_1, la1 |= 0x80000000);
    LogicAnalyzer_write(LA_REG_1, la1 ^= 0x80000000);
    // ...and again:
    LogicAnalyzer_write(LA_REG_1, la1 |= 0x80000000);
    LogicAnalyzer_write(LA_REG_1, la1 ^= 0x80000000);

    // Design 4 should now be selected, but note that All GPIOs start in
    // INPUT mode by default (per user_defines), so we won't see the
    // intended output until the GPIO modes are reconfigured...

    // Let's set GPIO[37:8] to BIDIRECTIONAL mode, since our OEBs should
    // be driven by the mux...
    GPIOs_configureAll(GPIO_MODE_USER_STD_BIDIRECTIONAL); // Set all...
    // ...but then change our mind for just the first 8:
    GPIOs_configure(0, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(1, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(2, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(3, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(4, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(5, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(6, GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(7, GPIO_MODE_MGMT_STD_INPUT_NOPULL);

    // Apply the above configuration:
    GPIOs_loadConfigs();

    // Pulse gpio again to show that the firmware completed the setup
    pulse_gpio();
}
