# SPDX-FileCopyrightText: 2023 Anton Maurovic <anton@maurovic.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SPDX-License-Identifier: Apache-2.0

####################
## If you want to know how to use the mux properly, consider checking out:
## https://github.com/algofoogle/journal/blob/master/0187-2023-12-09.md#using-la-pins-to-control-the-mux
## ...and read about the different reset options that you can register.

from caravel_cocotb.caravel_interfaces import * # import python APIs
import cocotb
from cocotb.triggers import ClockCycles

# Pinout:
o_nrst = 25
o_ncs = 26
o_clk = 27
o_nclk = 28
io_rwds = 29
io_data = (37, 36, 35, 34, 33, 32, 31, 30)

async def wait_for_gpio(caravel, gpio, value):
    while True:
        if caravel.monitor_gpio(gpio).integer == value:
            break;
        await ClockCycles(caravel.clk, 1)


@cocotb.test() # cocotb test marker
@report_test # wrapper for configure test reporting files
async def hyperram_test(dut):
    caravelEnv = await test_configure(dut) #configure, start up and reset caravel
    
    cocotb.log.info('Waiting for first GPIO pulse...')

    # This just gets us to the system being powered on...
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info('GPIO is high...')
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Firmware is starting')

    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Initial setup done')

    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Design is activated')

    # wait for external reset to be released
    await wait_for_gpio(caravelEnv, o_nrst, 1)
    cocotb.log.info('Design released nRST output')

    # wait for CS to be activated
    await wait_for_gpio(caravelEnv, o_ncs, 0)
    cocotb.log.info('HyperRAM is selected')

    # wait for CS to be deactivated
    await wait_for_gpio(caravelEnv, o_ncs, 1)
    cocotb.log.info('HyperRAM is deselected')

    # await ClockCycles(caravelEnv.clk, 100)
    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('Simulation finished')

    await ClockCycles(caravelEnv.clk, 10)
