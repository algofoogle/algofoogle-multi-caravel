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
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge, Timer

HIGH_RES = 10.0 # If not None, scale H res by this, and step by CLOCK_PERIOD/HIGH_RES instead of unit clock cycles.


# TRZF pinout:
"""
| GPIO | Dir | Name            |
| ----:|-----|-----------------|
|    8 | O   | o_hsync         |
|    9 | O   | o_vsync         |
|   10 | O   | o_rgb[0]        |
|   11 | O   | o_rgb[1]        |
|   12 | O   | o_rgb[2]        |
|   13 | O   | o_rgb[3]        |
|   14 | O   | o_rgb[4]        |
|   15 | O   | o_rgb[5]        |
|   16 | O   | o_tex_csb       |
|   17 | O   | o_tex_sclk      |
|   18 | IO  | io_tex_io[0]    |
|   19 | I   | i_tex_in[1]     |
|   20 | I   | i_tex_in[2]     |
|   21 | I   | i_tex_in[3]     |
|   22 | I   | i_vec_csb       |
|   23 | I   | i_vec_sclk      |
|   24 | I   | i_vec_mosi      |
|   25 | I   | i_reg_csb       |
|   26 | I   | i_reg_sclk      |
|   27 | I   | i_reg_mosi      |
|   28 | I   | i_debug_vec     |
|   29 | I   | i_debug_map     |
|   30 | I   | i_debug_trace   |
|   31 | I   | i_reg_outs_enb  |
|   32 | I   | i_mode[0]       |
|   33 | I   | i_mode[1]       |
|   34 | I   | i_mode[2]       |
|   35 | O   | o_gpout[0]      |
|   36 | O   | o_gpout[1]      |
|   37 | O   | o_gpout[2]      |
"""


async def mgmt_gpio_pulse(ce, marker = None):
    await ce.wait_mgmt_gpio(1)
    if marker is None: cocotb.log.info('GPIO is high...')
    await ce.wait_mgmt_gpio(0)
    cocotb.log.info('GPIO is low again: PULSE!' if marker is None else marker)


@cocotb.test() # cocotb test marker
@report_test # wrapper for configure test reporting files
async def trzf_basic(dut):
    # Configure, start up and reset caravel:
    chip = await test_configure(
        dut,
        timeout_cycles = 1_000_000 # Should be enough for start-up time, plus 2 full frames.
    ) 

    # mode[2:0]:
    chip.drive_gpio_in((34,32), 0b000)
    # reg_outs_enb:
    chip.drive_gpio_in(    31 , 0b1) # 1=UNregistered outputs
    # debug_trace_overlay
    chip.drive_gpio_in(    30 , 0b1)
    # debug_map_overlay
    chip.drive_gpio_in(    29 , 0b1)
    # debug_vec_overlay
    chip.drive_gpio_in(    28 , 0b1)
    # reg_mosi:
    chip.drive_gpio_in(    27 , 0b0)
    # reg_sclk:
    chip.drive_gpio_in(    26 , 0b0)
    # reg_csb:
    chip.drive_gpio_in(    25 , 0b1) # Disabled.
    # vec_mosi:
    chip.drive_gpio_in(    24 , 0b0)
    # vec_sclk:
    chip.drive_gpio_in(    23 , 0b0)
    # vec_csb:
    chip.drive_gpio_in(    22 , 0b1) # Disabled.
    # tex_in[3:0]:
    chip.drive_gpio_in((21,18), 0b0000)

    period = float(chip.get_clock_period())

    clk = chip.clk
    #await chip.release_csb()
    
    cocotb.log.info('Waiting for first GPIO pulse...')

    # This just gets us to the system being powered on...
    # 1st gpio pulse:
    await mgmt_gpio_pulse(chip)

    # OK, firmware is starting to select the design and configure GPIOs...
    # 2nd gpio pulse:
    await mgmt_gpio_pulse(chip, 'GPIO pulse: Initial mux state has been set');

    # OK, design is selected and GPIOs are configured...
    gpios_value_str = chip.monitor_gpio(37, 8).binstr
    cocotb.log.info (f"All gpios '{gpios_value_str}'")

    # Now await design reset falling edge, which should be fed back via gpout[2]
    # if the LAs are set correctly (i.e. all 0):
    # await FallingEdge(chip.monitor_gpio(37))
    await FallingEdge(chip.dut.gpio37_monitor)
    cocotb.log.info("Design reset falling edge detected via gpout[2]")

    # Now await design reset...
    cocotb.log.info("Parallel wait for GPIO confirmation pulse...")
    cocotb.start_soon(mgmt_gpio_pulse(chip, 'Confirmation: GPIO pulse detected')) # Parallel watcher for next GPIO pulse.
    cocotb.log.info("Rendering first frame...")

    hrange = 800
    vrange = 525 #NOTE: Can multiply this by an integer number of frames, if desired.
    hres = HIGH_RES or 1

    # Create PPM file to visualise the frame, and write its header:
    img = open("trzf_basic_frame0.ppm", "w")
    img.write("P3\n")
    img.write(f"{int(hrange*hres)} {vrange:d}\n")
    img.write("255\n")

    for n in range(vrange): # 525 lines
        print(f"Rendering line {n}")
        for n in range(int(hrange*hres)): # 800 pixel clocks per line.
            rgb = chip.monitor_gpio(15,10)
            if n % 100 == 0:
                print('.', end='')
            if 'x' in rgb.binstr:
                # Output is unknown; make it green:
                r = 0
                g = 255
                b = 0
            else:
                hsyncb = 255 if chip.monitor_gpio(8).binstr=='x' else (0==chip.monitor_gpio(8).integer)*0b110000
                vsyncb = 128 if chip.monitor_gpio(9).binstr=='x' else (0==chip.monitor_gpio(9).integer)*0b110000
                rgb = rgb.integer
                r = ((rgb & 0b000011) << 6) | hsyncb
                g = ((rgb & 0b001100) << 4) | vsyncb
                b = ((rgb & 0b110000) << 2)
            img.write(f"{r} {g} {b}\n")
            if HIGH_RES is None:
                await ClockCycles(clk, 1) 
            else:
                await Timer(period/hres, units='ns')

    print("Waiting 1 more clock, for start of next line...")
    await ClockCycles(clk, 1)
    img.close()
    print("DONE")
