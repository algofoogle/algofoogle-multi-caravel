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

from caravel_cocotb.caravel_interfaces import *  # import python APIs
import cocotb
from cocotb.triggers import ClockCycles
from .simon_driver import SimonDriver


@cocotb.test()  # cocotb test marker
@report_test  # wrapper for configure test reporting files
async def simon_test(dut):
    caravelEnv = await test_configure(dut)  # configure, start up and reset caravel
    simon = SimonDriver(caravelEnv, caravelEnv.clk)
    caravelEnv.drive_gpio_in(5, 1)  # Start with reset HIGH

    # Setup the GPIOs

    cocotb.log.info("Waiting for first GPIO pulse...")

    # This just gets us to the system being powered on...
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info("GPIO is high...")
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info("GPIO pulse: Firmware is starting")

    await caravelEnv.wait_mgmt_gpio(1)
    await caravelEnv.wait_mgmt_gpio(0)
    cocotb.log.info("GPIO pulse: Initial mux state has been set")

    cocotb.log.info("Reseting design...")
    caravelEnv.drive_gpio_in(5, 1)
    await ClockCycles(caravelEnv.clk, 10)
    caravelEnv.drive_gpio_in(5, 0)
    await ClockCycles(caravelEnv.clk, 10)

    # Should display empty score before game starts
    assert await simon.read_segments() == "  "

    cocotb.log.info("Pressing a button to start the game...")
    await simon.press_button(0)

    # Wait 510ms for the game to be started
    await ClockCycles(caravelEnv.clk, 51000)

    cocotb.log.info(f"Score value: {await simon.read_segments()}")
    assert await simon.read_segments() == "00"
    assert await simon.read_one_led() == 0

    # Wait 300ms for the LED to go off
    await ClockCycles(caravelEnv.clk, 30000)
    assert await simon.read_one_led() is None

    # Wait another 100ms for the game to be ready for input
    await ClockCycles(caravelEnv.clk, 10000)

    # Press the correct button, check the the LED is lit
    cocotb.log.info("Pressing the correct button...")
    await simon.press_button(0)
    assert await simon.read_one_led() == 0

    # Wait for 310ms for the input to be registered
    await ClockCycles(caravelEnv.clk, 31000)
    assert await simon.read_one_led() is None

    # Check that the score is updated
    cocotb.log.info(f"Score value: {await simon.read_segments()}")
    assert await simon.read_segments() == "01"

    cocotb.log.info("All good!")
