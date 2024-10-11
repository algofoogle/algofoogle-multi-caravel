# Firmware examples for algofoogle-multi-caravel (ztoa-team-group-caravel) GFMPW-1 ASIC

This directory contains self-contained [caravel-gf180mcu](https://github.com/efabless/caravel-gf180mcu) ([caravel_mgmt_soc_gf180mcu](https://github.com/efabless/caravel_mgmt_soc_gf180mcu)) firmware exmaples (and Makefiles) that exercise features of the GFMPW-1 ASIC we submitted and got fabbed.

Most of these just handle mux control, and support various other external tests of the chip.

Each subdirectory in here can/should be copied into `firmware/gf180/` of the [caravel_board](https://github.com/efabless/caravel_board) repo, and then you can do `make clean flash` in there to write to the Caravel eval board's firmware Flash ROM.

This goes hand-in-hand with my [0219](https://github.com/algofoogle/journal/blob/master/0219-2024-10-07.md) journal entry.

Firmware examples include:
*   [basic_blink](./basic_blink/):
    *   Simply sets up mgmt gpio for output, then blinks it (LED D3) at about 2.5Hz
*   [mux_test](./mux_test/):
    *   Tells mux to select design 13, configures GPIO[37:6] as BIDIR, then enters blink loop.
    *   Bit pattern measured on GPIO[31:16] should be `0101010110101010` -- verified.
    *   Override which design to write by doing (say): `MUX_DESIGN=14 make clean flash`
    *   NOTE: The basic mux config in this file always keeps all designs in reset.
*   [clk_test](./clk_test/):
    *   Enables clock debug, i.e. `wb_clk_i` output on GPIO14, user_clock2 output on GPIO15
    *   Enables the DLL and configures the clock for 2.5x speed (25MHz from 10MHz source)
    *   Goes into a blink loop at the end
*   [trzf_test](./trzf_test/):
    *   Selects design 0 ("trzf", or "top_raybox_zero_fsm"), configures GPIO[37:8] as BIDIR, resets the design, and selects gpout[2:0] as follows:
        *   gpout[0] = 3 (clk/4)
        *   gpout[1] = 4 (hpos[0] = clk/2)
        *   gpout[2] = 1 (clk)
