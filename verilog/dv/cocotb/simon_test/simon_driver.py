from cocotb.triggers import ClockCycles

# Pinout:
i_btn = (11, 8)
o_led = (15, 12)
o_speaker = 16
o_seg = (23, 17)
o_dig_1 = 24
o_dig_2 = 25
i_seginv = 26
i_slow_clk = 27


def decode_7seg(value: int):
    """Decode a 7-segment value to a digit"""
    decode_map = {
        0x3F: "0",
        0x06: "1",
        0x5B: "2",
        0x4F: "3",
        0x66: "4",
        0x6D: "5",
        0x7D: "6",
        0x07: "7",
        0x7F: "8",
        0x6F: "9",
        0x00: " ",
    }
    if value in decode_map:
        return decode_map[value]
    return "?"


class SimonDriver:
    def __init__(self, caravel, clock):
        self._caravel = caravel
        self._clock = clock
        self._caravel.drive_gpio_in(i_btn, 0)
        self._caravel.drive_gpio_in(i_seginv, 0)
        self._caravel.drive_gpio_in(i_slow_clk, 1)

    async def press_button(self, index):
        """Press a button for 100 clock cycle, index is zero based"""
        self._caravel.drive_gpio_in(i_btn, 1 << index)
        await ClockCycles(self._clock, 100)
        self._caravel.drive_gpio_in(i_btn, 0)
        await ClockCycles(self._clock, 100)

    async def read_one_led(self):
        """Returns the index of the currently lit LED, or None if no LED is lit"""
        leds = self._caravel.monitor_gpio(*o_led).integer
        if leds == 0b0000:
            return None
        elif leds == 0b0001:
            return 0
        elif leds == 0b0010:
            return 1
        elif leds == 0b0100:
            return 2
        elif leds == 0b1000:
            return 3
        raise ValueError(f"Unexpected value for leds: {self._dut.led.value}")

    async def _wait_for_dig(self, pin, value):
        while True:
            if self._caravel.monitor_gpio(pin).integer == value:
                break
            await ClockCycles(self._caravel.clk, 1)

    async def read_segments(self):
        """Read the current segment value"""
        seginv = self._caravel.monitor_gpio(i_seginv).integer
        diginv = 0x7F if seginv else 0
        await self._wait_for_dig(o_dig_1, 1 if seginv else 0)
        dig1 = decode_7seg(self._caravel.monitor_gpio(o_seg).integer ^ diginv)
        await self._wait_for_dig(o_dig_2, 1 if seginv else 0)
        dig2 = decode_7seg(self._caravel.monitor_gpio(o_seg).integer ^ diginv)
        return f"{dig1}{dig2}"
