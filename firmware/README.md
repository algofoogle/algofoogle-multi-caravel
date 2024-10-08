# Firmware examples for algofoogle-multi-caravel (ztoa-team-group-caravel) GFMPW-1 ASIC

This directory contains self-contained [caravel-gf180mcu](https://github.com/efabless/caravel-gf180mcu) ([caravel_mgmt_soc_gf180mcu](https://github.com/efabless/caravel_mgmt_soc_gf180mcu)) firmware exmaples (and Makefiles) that exercise features of the GFMPW-1 ASIC we submitted and got fabbed.

Most of these just handle mux control, and support various other external tests of the chip.

Each subdirectory in here can/should be copied into `firmware/gf180/` of the [caravel_board](https://github.com/efabless/caravel_board) repo, and then you can do `make clean flash` in there to write to the Caravel eval board's firmware Flash ROM.

This goes hand-in-hand with my [0219](https://github.com/algofoogle/journal/blob/master/0219-2024-10-07.md) journal entry.

Firmware examples include:
*   [basic_blink](./basic_blink/):
    *   Simply sets up mgmt gpio for output, then blinks it (LED D3) at about 2.5Hz
*   [mux_test](./mux_test/):
    *   Tells mux to select design 13, configures GPIO[37:8] as BIDIR, then enters blink loop.
    *   Bit pattern measured on GPIO[31:16] should be `0101010110101010` -- verified.
    *   Override which design to write by doing (say): `MUX_DESIGN=14 make clean flash`
    *   NOTE: The basic mux config in this file always keeps all designs in reset.
