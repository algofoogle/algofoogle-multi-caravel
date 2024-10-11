#NOTE: This assumes your RISC-V toolchain is set up per:
# https://github.com/algofoogle/journal/blob/master/0218-2024-10-05.md#testing-the-caravel-cpu-with-basic-blink-firmware

#NOTE: This is designed to be run within a subdirectory of firmware/gf180/, within a clone of the
# caravel_board repo (https://github.com/efabless/caravel_board). This is because it relies on
# ../sections.lds and ../crt0_vex.S -- without those two files, and likewise ../isr.c and ../stub.c,
# it can't build the .elf, which in turn means that if you ran just "make" (or "make flash") you would
# likely get the error:
# make: *** No rule to make target 'blink.hex', needed by 'hex'.  Stop. 

# TOOLCHAIN_PATH=/usr/bin/
# TOOLCHAIN_PATH=/opt/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14/bin/
# TOOLCHAIN_PATH=/opt/riscv32imc/bin/
# TOOLCHAIN_PATH=/ef/apps/bin/
TOOLCHAIN_PATH=/opt/riscv-toolchain/bin/

# Set the prefix for `riscvXX-unknown-elf-*`
# On installations using `multilib`, this will be `riscv64` even for compiling to 32-bit targets
TOOLCHAIN_PREFIX=riscv64-unknown-elf
#TOOLCHAIN_PREFIX=riscv32
ARCH=rv32i
#ARCH=rv32i_zicsr

.SUFFIXES:

PATTERN = trzf_test

hex:  ${PATTERN:=.hex}

%.elf: %.c ../sections.lds ../crt0_vex.S
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-gcc -I../ -I../generated/ -O0 -mabi=ilp32 -march=$(ARCH) -D__vexriscv__ -Wl,-Bstatic,-T,../sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ ../crt0_vex.S ../isr.c ../stub.c $<
	${TOOLCHAIN_PATH}$(TOOLCHAIN_PREFIX)-objdump -D $(PATTERN).elf > $(PATTERN).lst

%.hex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O verilog $< $@
	sed -i -e 's/@1000/@0000/g' $@

%.bin: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O binary $< $@

flash: $(PATTERN).hex
	python3 ../util/caravel_hkflash.py $(PATTERN).hex

show_projectid:
	python3 ../util/caravel_projectid.py

hk_debug:
	python3 ../util/caravel_hkdebug.py

monitor:
	miniterm.py /dev/serial/by-id/usb-FTDI_Single_RS232-HS-if00-port0

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.lst

.PHONY: clean hex all flash

