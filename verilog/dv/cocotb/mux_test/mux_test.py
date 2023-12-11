# SPDX-FileCopyrightText: 2023 Efabless Corporation

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

from caravel_cocotb.caravel_interfaces import * # import python APIs
import cocotb

@cocotb.test() # cocotb test marker
@report_test # wrapper for configure test reporting files
async def mux_test(dut):
    caravelEnv = await test_configure(dut) #configure, start up and reset caravel
    #await caravelEnv.release_csb()
    
    cocotb.log.info('Waiting for first GPIO pulse...')

    # This just gets us to the system being powered on...
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info('GPIO is high...')
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Firmware is starting')

    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Initial mux state has been set')
    gpios_value_str = caravelEnv.monitor_gpio(37, 8).binstr
    cocotb.log.info (f"All gpios '{gpios_value_str}'")
    gpio_value_int = caravelEnv.monitor_gpio(31, 16).integer
    expected = 0x55AA
    if (gpio_value_int == expected):
        cocotb.log.info (f"[TEST] Pass the gpio value is '{hex(gpio_value_int)}'")
    else:
        cocotb.log.error (f"[TEST] Fail the gpio value is :'{hex(gpio_value_int)}' expected {hex(expected)}")

    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO pulse: Final mux state has been set')
    gpios_value_str = caravelEnv.monitor_gpio(37, 8).binstr
    cocotb.log.info (f"All gpios '{gpios_value_str}'")
    gpio_value_int = caravelEnv.monitor_gpio(31, 16).integer
    expected = 0xAA55
    if (gpio_value_int == expected):
        cocotb.log.info (f"[TEST] Pass the gpio value is '{hex(gpio_value_int)}'")
    else:
        cocotb.log.error (f"[TEST] Fail the gpio value is :'{hex(gpio_value_int)}' expected {hex(expected)}")


