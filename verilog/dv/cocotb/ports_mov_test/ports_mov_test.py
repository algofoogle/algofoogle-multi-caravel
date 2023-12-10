from caravel_cocotb.caravel_interfaces import * # import python APIs
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

# Instructions organized in 16 bytes blocks
instructions = [132, 255, 80, 132, 0, 81, 61, 72, 65, 0, 0, 0, 0, 0, # Movlw 255, MovWR0, Movlw 0, MovWR1, PorstCfg, PortsCfg, MovP0W, MovWp1
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 127] # Program ends

@cocotb.test()
@report_test # wrapper for configure test reporting files
async def ports_mov_test(dut):
   caravelEnv = await test_configure(dut) #configure, start up and reset caravel
   await caravelEnv.wait_mgmt_gpio(1)

   dut.gpio6_en.value = 1 # rst
   dut.gpio7_en.value = 1 # external interrupt

   dut.gpio8_en.value = 1 # data bus
   dut.gpio9_en.value = 1
   dut.gpio10_en.value = 1
   dut.gpio11_en.value = 1
   dut.gpio12_en.value = 1
   dut.gpio13_en.value = 1
   dut.gpio14_en.value = 1
   dut.gpio15_en.value = 1

   # P0 and P1 are bidirectional and configured from inside the CPU
   # dut.gpio16_en.value = 0 # P0
   # dut.gpio17_en.value = 0
   # dut.gpio18_en.value = 0
   # dut.gpio19_en.value = 0
   # dut.gpio20_en.value = 0
   # dut.gpio21_en.value = 0
   # dut.gpio22_en.value = 0
   # dut.gpio23_en.value = 0

   # dut.gpio24_en.value = 0 #P1
   # dut.gpio25_en.value = 0
   # dut.gpio26_en.value = 0
   # dut.gpio27_en.value = 0

   dut.gpio28_en.value = 1 # Address bus
   dut.gpio29_en.value = 1
   dut.gpio30_en.value = 1
   dut.gpio31_en.value = 1
   dut.gpio32_en.value = 1
   dut.gpio33_en.value = 1
   dut.gpio34_en.value = 1
   dut.gpio35_en.value = 1
   dut.gpio36_en.value = 1
   dut.gpio37_en.value = 1

   dut.gpio7.value = 0 # ext interrupt

   dut.gpio6.value = 1 # rst
   await ClockCycles(caravelEnv.clk, 2)
   dut.gpio6.value = 0

   await ClockCycles(caravelEnv.clk, 1)
   caravelEnv.drive_gpio_in((15, 8), instructions[0]) # data bus
   caravelEnv.drive_gpio_in((23, 16), 12) # data bus
   await ClockCycles(caravelEnv.clk, 1)

   while True:
      if (instructions[caravelEnv.monitor_gpio(37, 28).value] == 127):
         break

      caravelEnv.drive_gpio_in((15, 8), instructions[caravelEnv.monitor_gpio(37, 28).value]) # data bus
      await ClockCycles(caravelEnv.clk, 1)
      await Timer(10, units="ns");
   
   assert caravelEnv.monitor_gpio(27, 24) == 12, f"Unexpected P1: desired 12, got {caravelEnv.monitor_gpio(27, 24)}";
