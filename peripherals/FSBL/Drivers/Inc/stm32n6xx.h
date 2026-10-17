/*
 * stm32n6xx.h
 *
 *  Created on: Oct 10, 2026
 *      Author: Temesgen Ataro
 */

// We'll be using the reserved peripheral secure addresses for this uC
// pp. 164 of RM0486 Reference Manual for STM32N647/657xx MCUs

#ifndef INC_STM32N6XX_H_
#define INC_STM32N6XX_H_


#define FLASH_BASEARDDR             0x00000000UL
#define SRAM1_BASEADDR              0x
#define SRAM                        SRAM1_BASEADDR
#define SDRAM1_NONSECURE            0xC0000000UL
#define SDRAM2_NONSECURE            0xD0000000UL
#endif /* INC_STM32N6XX_H_ */
