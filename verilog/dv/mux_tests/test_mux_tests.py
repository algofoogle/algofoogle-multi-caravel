import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer, with_timeout
from cocotb.types import Logic
import random
import re

CLOCK_PERIOD = 40.0 # ns

async def gpio_pulse_sense(dut):
    await RisingEdge(dut.gpio)
    await FallingEdge(dut.gpio)

# Startup: Wait for the design to pulse gpio (to show firmware has started running)
# and then wait for our design's reset to be released to know it is starting from
# its known initial state.
@cocotb.test()
async def test_start(dut):
    # dut.VGND <= 0
    # dut.VPWR <= 1

    # Clock for SoC:
    clk = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clk.start())

    # Clock for Anton's design:
    anton_clock = Clock(dut.anton_clock, 40, units="ns")
    cocotb.start_soon(anton_clock.start())

    print("Clocks started")
    
    # Start up with SOC reset asserted, and the power off:
    dut.RSTB.value = 0
    dut.power.value = 0

    print("Powering up")

    # Bring up system power after 8 clock cycles:
    await ClockCycles(dut.clk, 8)
    dut.power.value = 1

    print("Powered up")

    # Keep SOC reset asserted for another 20 cycles, then release:
    await ClockCycles(dut.clk, 20)
    dut.RSTB.value = 1

    print("Coming out of reset")

    # SOC should now be running...

    # Wait for 1st gpio pulse:
    await gpio_pulse_sense(dut)

    print("Firmware is running (selecting mux design 13 now...)")

    # Wait for 2nd gpio pulse:
    await gpio_pulse_sense(dut)

    print("Mux design 13 selected and GPIOs configured")
    print("Now awaiting selection of design 14...")

    # Wait for final gpio pulse:
    await gpio_pulse_sense(dut)

    print("DONE")


# # Basic test, follows test_start above.
# # Renders 1 full frame (800x525 clocks) +1 clock to show
# # that hpos/vpos reset.
# @cocotb.test()
# async def test_all(dut):
#     hrange = 800
#     vrange = 525*4 #NOTE: Can multiply this by number of frames desired.
#     hres = HIGH_RES or 1

#     print("Rendering first full frame...")

#     # Clock for SoC:
#     clk = Clock(dut.clk, 40, units="ns")
#     cocotb.start_soon(clk.start())

#     # Clock for Anton's design:
#     anton_clock = Clock(dut.anton_clock, 40, units="ns")
#     cocotb.start_soon(anton_clock.start())

#     # Create PPM file to visualise the frame, and write its header:
#     img = open("rbz_basic_frame0.ppm", "w")
#     img.write("P3\n")
#     img.write(f"{int(hrange*hres)} {vrange:d}\n")
#     img.write("255\n")

#     for n in range(vrange): # 525 lines
#         print(f"Rendering line {n}")
#         for n in range(int(hrange*hres)): # 800 pixel clocks per line.
#             if n % 100 == 0:
#                 print('.', end='')
#             if 'x' in dut.o_gpout.value.binstr:
#                 # Output is unknown; make it green:
#                 r = 0
#                 g = 255
#                 b = 0
#             else:
#                 b0 = dut.o_gpout0.value  # LA-overridden gpout0 is Blue low bit.
#                 b1 = dut.o_gpout1.value  # LA-overridden gpout1 is Blue high bit.
#                 r0 = dut.o_gpout2.value  # LA-overridden gpout2 is Red low bit.
#                 r1 = dut.o_gpout3.value  # LA-overridden gpout3 is Red high bit.
#                 hsyncb = 255 if dut.o_hsync.value.binstr=='x' else (0==dut.o_hsync.value)*0b110000
#                 vsyncb = 128 if dut.o_vsync.value.binstr=='x' else (0==dut.o_vsync.value)*0b110000
#                 r = (r1<<7) | (r0<<6) | hsyncb
#                 g = 0 | vsyncb
#                 b = (b1<<7) | (b0<<6)
#             img.write(f"{r} {g} {b}\n")
#             if HIGH_RES is None:
#                 await ClockCycles(dut.anton_clock, 1) 
#             else:
#                 await Timer(CLOCK_PERIOD/hres, units='ns')
#     print("Waiting 1 more clock, for start of next line...")
#     await ClockCycles(dut.anton_clock, 1)
#     img.close()
#     print("DONE")
