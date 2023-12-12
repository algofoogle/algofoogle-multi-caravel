#ifndef HYPERRAM_H
#define HYPERRAM_H

#include <stdint.h>

// HyperRAM is mapped to 0x30xx_xxxx address space on Wishbone bus
#define HYPERRAM_MEM_SIZE			((8ul*1024ul*1024ul))
#define HYPERRAM_MEM_SIZE_WORDS		((HYPERRAM_MEM_SIZE / 4))
// HyperRAM has 8MB -> mask is 0x007fffff
// 0x3000_0000 till 307f_ffff -> RAM / MEM inisde chip
#define HYPERRAM_MEM_BASE_ADDRESS	0x30000000
#define HYPERRAM_MEM_MASK			0x007ffffc
#define hyperram_mem(offset)		(*(volatile uint32_t*)(HYPERRAM_MEM_BASE_ADDRESS + (offset & HYPERRAM_MEM_MASK)))
// 0x3080_xxxx -> register space inside chip
#define HYPERRAM_REG_BASE_ADDRESS	0x30800000
#define HYPERRAM_REG_MASK			0x0000ffff
#define hyperram_reg(num)			(*(volatile uint16_t*)(HYPERRAM_REG_BASE_ADDRESS + ((2 * num) & HYPERRAM_REG_MASK)))
// 0x3081_xxxx -> CSR space for driver / peripheral configuration
#define HYPERRAM_CSR_BASE_ADDRESS	0x30c00000
#define HYPERRAM_CSR_MASK			0x0000ffff
#define hyperram_csr_latency		(*(volatile uint32_t*)(HYPERRAM_CSR_BASE_ADDRESS + 0x00))
#define hyperram_csr_tpre_tpost		(*(volatile uint32_t*)(HYPERRAM_CSR_BASE_ADDRESS + 0x04))
#define hyperram_csr_tcsh			(*(volatile uint32_t*)(HYPERRAM_CSR_BASE_ADDRESS + 0x08))
#define hyperram_csr_trmax			(*(volatile uint32_t*)(HYPERRAM_CSR_BASE_ADDRESS + 0x0c))
#define hyperram_csr_status			(*(volatile uint32_t*)(HYPERRAM_CSR_BASE_ADDRESS + 0x10))

#define HYPERRAM_CHIP_ID0			(0)
#define HYPERRAM_CHIP_ID1			(1)
#define HYPERRAM_CHIP_CFG0			(0x800)
#define HYPERRAM_CHIP_CFG1			(0x801)




#endif // HYPERRAM_H