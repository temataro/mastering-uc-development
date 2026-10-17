# Resource index

Supplied resources inspected on 2026-10-04. On 2026-10-07 the available board
was confirmed as NUCLEO-N657X0-Q. Its documentation is indexed in
[docs/README.md](../docs/README.md); actual PDF downloads are pending host-side
execution of `bash docs/download.sh`. Keep instructor resources as references;
create learner projects separately.

## Supplied files

| Path, relative to the workspace root | Use | Qualification |
|---|---|---|
| `Hardware+and+software+used+in+MCU1.pdf` | Hardware/software checklist | Includes a separate MCU2 checklist; do not buy everything listed |
| `MasteringMCU/Resources/Documents/RM407.pdf` | F407 peripheral register reference | Actually RM0090 Rev 17, June 2018; covers F405/407/415/417/427/429/437/439, not F446 or H723 |
| `MasteringMCU/Resources/Documents/Datasheet_stm32f407x.pdf` | F407 electrical limits, pinout, alternate functions | Match the actual package and part |
| `MasteringMCU/Resources/Documents/Datasheet_stm32f446re.pdf` | F446 electrical/pin information | Does not replace F446 reference manual RM0390 |
| `MasteringMCU/Resources/Documents/User manual Discovery.pdf` | Course board wiring/features | Board-specific; not the Nucleo or WeAct manual |
| `MasteringMCU/Resources/Documents/User manual Nucleo-64.pdf` | Older Nucleo-64 board information | UM1724 Rev 12, December 2017; not authoritative for a Nucleo-144 |
| `MasteringMCU/Resources/Documents/Nucleo schematics.pdf` | Supplied Nucleo wiring reference | Confirm exact board/model/revision before using |
| `MasteringMCU/Resources/Documents/UM10204.pdf` | I2C protocol reference | Verify revision when needed; MCU register details come from its own manual |
| `MasteringMCU/Resources/Source_code/Workspace/stm32f4xx_drivers/` | Instructor's driver project | F407 reference solutions; do not import as the learner's starting project |
| `MasteringMCU/Resources/Arduino/` | Course SPI/I2C/UART peer examples | Arduino peer behavior must be adapted for a Pico; not a direct firmware substitute |
| `MasteringMCU/Resources/Source_code/Legacy/` | Older code and wiring slides | Keil-era project metadata; consult only if relevant |
| `MasteringMCU/Resources/Eclipse-ARM-Cortex-M/demo/` | Older Eclipse/Make F446 demo | Includes generated build artifacts; historical reference |

No standalone course lecture slide deck was found. Three wiring presentations
exist under the legacy SPI/I2C/UART directories. The old workspace also contains
Eclipse `.metadata` and Windows-era paths. Use a fresh IDE workspace.

## Reference solutions: map without copying

Directory: `MasteringMCU/Resources/Source_code/Workspace/stm32f4xx_drivers/`.

| Topic | Supplied reference location |
|---|---|
| GPIO and button | `src/001led_toggle.c` through `src/004gpio_freq.c` |
| Button interrupt | `src/005button_interrupt.c` |
| SPI | `src/006spi_tx_testing.c` through `src/009spi_message_rcv_it.c` |
| I2C | `src/010i2c_master_tx_testing.c` through `src/014i2c_slave_tx_string2.c` |
| USART | `src/015uart_tx.c`, `src/016uart_case.c` |
| RTC/LCD application | `src/017rtc_lcd.c`, `bsp/` |
| Driver implementations and register headers | `drivers/src/`, `drivers/inc/` |
| Startup/runtime/linker examples | `autogen/`, root `.ld` files |

Use this map to find relevant comparisons after a learner attempt. Filenames
establish supplied examples, not exact current lecture numbering.

## Documents to choose after identifying the board

Use the MCU datasheet for **pins and electrical constraints**, the reference
manual for **peripheral behavior and registers**, the programming/core manual
for **CPU/NVIC/debug behavior**, and the board schematic for **actual connections**.
Check errata for silicon exceptions.

- **F407/F429 and related parts:** supplied RM0090 may be a useful course
  companion, but obtain the current applicable revision and errata from ST.
- **F446:** use [ST's F446 documentation, including RM0390](https://www.st.com/en/microcontrollers-microprocessors/stm32f446/documentation.html).
- **Other F4 Nucleo:** select by the exact part rather than assuming RM0090 applies.
- **H723:** [ST part page](https://www.st.com/en/microcontrollers-microprocessors/stm32h723vg.html)
  and [RM0468](https://www.st.com/resource/en/reference_manual/dm00603761.pdf).
  The full RM0468 PDF exceeded this session's web reader size limit; it has not
  been reviewed in detail or downloaded into this workspace.
- **WeAct board:** [vendor repository](https://github.com/WeActStudio/WeActStudio.MiniSTM32H723)
  and [hardware/schematic directory](https://github.com/WeActStudio/WeActStudio.MiniSTM32H723/tree/master/Hardware).
  Match the physical revision; the repository exposes V1.2 hardware files.
- **Pico peers:** [official hardware APIs](https://www.raspberrypi.com/documentation/pico-sdk/hardware.html)
  and [I2C slave helper](https://www.raspberrypi.com/documentation/pico-sdk/high_level.html).
  Confirm Pico variant and SDK path when the peer is needed.

## Course and tool sources

- [Udemy course](https://www.udemy.com/course/mastering-microcontroller-with-peripheral-driver-development/):
  public page lists an August 2026 update and an F407 Discovery target. Its visible
  install guidance recommends IDE 1.18/1.19 to avoid the changed CubeMX workflow.
- [ST: CubeIDE 2.0 separation announcement](https://community.st.com/stm32cubeide-mcus-28/stm32cubeide-2-0-0-released-159542):
  standalone CubeMX generates projects; IDE also supports empty projects.
- [CubeIDE release notes](https://www.st.com/resource/en/release_note/rn0114-stm32cubeide-release-v210-stmicroelectronics.pdf):
  retrieved PDF identifies v2.2.0, Rev 39, June 2026 despite the older filename.
  Lists Ubuntu 26.04 support and bundled command-line tools.
- [CubeMX 6.18.0 release information](https://dev.st.com/stm32cube-docs/stm32cubemx/6.18.0/en/docs/markup/CubeMX_RelaseNotes/CubeMX_Release_Information.html):
  lists Ubuntu 26.04 support. This is not a verification of every change in the
  locally observed 6.18.1 patch release.
