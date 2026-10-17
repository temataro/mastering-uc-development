# Milestones and preparation

This is a learning map, not a fabricated lecture-by-lecture syllabus. The
[public course page](https://www.udemy.com/course/mastering-microcontroller-with-peripheral-driver-development/)
reported 76 sections, 278 lectures, and 28h 34m on 2026-10-04. Only its first
10 sections were expanded in the accessible page. Later groupings below follow
the course's stated GPIO/SPI/I2C/USART scope and supplied exercise files; exact
lecture titles/order will be recorded as the learner reaches them.

Video duration excludes reading, implementation, debugging, and lab time. Use
understanding and experimental evidence as the pace rather than a completion date.

| ID | Milestone | Evidence of understanding | Prepare before starting |
|---|---|---|---|
| M0 | Target, documents, tools | Identify MCU, debug path, and which document answers a pin/register/board question | Exact board model, USB data cable, board schematic, MCU datasheet/reference manual/errata |
| M1 | First GUI build and debug | Build an empty project; halt at `main`; explain ELF, flash, RAM, and the probe's role | Working ST-LINK/SWD connection; IDE console |
| M2 | Debugger literacy | Predict and inspect variables, memory, disassembly, call stack, a breakpoint and a watchpoint | M1; a tiny learner-written C program; SWO only if supported/routed |
| M3 | Memory map, buses, clocks | Trace a peripheral address and clock path; predict a register change; distinguish clock calculation from measurement | Exact MCU reference manual; scope access for MCO measurement if following that lab |
| M4 | GPIO driver | Implement a small output/input experiment; explain mode, pull resistors, output type and bit operations | LED plus current-limiting resistor if needed, button, breadboard/jumpers, multimeter |
| M5 | EXTI and NVIC | Trace an edge to the ISR; explain mask, trigger, pending-bit clearing, shared state and bounce | Button/circuit from M4; vector table and EXTI/NVIC docs |
| M6 | SPI polling, then interrupts | Predict CPOL/CPHA and byte flow; demonstrate exchange; explain flags and completion | Suitable SPI peer and agreed protocol, wires, scope/analyzer plan |
| M7 | I2C polling, then interrupts/slave | Explain open-drain pull-ups, address representation, ACK/NACK and transaction completion; demonstrate exchange | 3.3 V-compatible peer, suitable pull-ups, multimeter, scope/analyzer plan |
| M8 | USART polling, then interrupts | Calculate baud timing; demonstrate TX/RX; explain framing and receive/error handling | Board VCP if wired appropriately, or 3.3 V USB-UART/Pico peer; terminal program |
| M9 | Integration and independence | Diagnose a seeded fault, adapt an exercise without copying, explain observed behavior | Reuse tested drivers and one simple application |
| M10 | H723 transfer exercise, optional | Identify register/IP differences and port one learned peripheral deliberately | H723 docs and schematic, suitable SWD probe; separate target project |

No milestone has verified completion. M0 has a partial tool/resource audit;
The learner has started the section 5 Hello World lecture corresponding to M1.
Complete M4 before moving to M5; learn each serial protocol first with polling,
then with interrupts. Check the actual lectures before fixing later ordering.

## Build understanding, alongside M1–M4

1. **GUI first:** read the build console and identify compiler, assembler,
   linker, target flags, source list and linker script.
2. **Terminal next:** run the existing generated Make build with the same
   toolchain. Explain `make -C` and why a build directory exists.
3. **Small Makefile later:** the learner writes a minimal version with guidance,
   including dependencies, link inputs, and clean behavior.
4. **Convenience targets only when requested:** decide whether to automate
   `build`, `flash`, or `debug` after understanding the underlying commands.

Use CMSIS core/device definitions deliberately. CMSIS-DSP is not a prerequisite
for GPIO/SPI/I2C/USART. DMA, caches, maximum clock tuning, RTOS, and DSP are later
topics unless an actual lesson needs them.

## Equipment timing

- **Now:** follow `N657-SETUP.md` for the confirmed NUCLEO-N657X0-Q; identify
  the boot/power selectors, connect CN10, and check USB enumeration.
- **Before GPIO/EXTI:** inventory LED/resistor/button/wires and inspect the
  relevant board circuits. An onboard LED/button may cover early exercises.
- **Before clock measurement:** arrange scope access and derive the expected
  MCO frequency first. A debugger register value is not a physical measurement.
- **Before SPI/I2C:** decide whether a Pico, another STM32, or an existing
  peripheral is the peer. Adapt the test protocol to the course exercise;
  a Pico needs separate peer firmware. Ask whether to automate that firmware.
- **Before trace exercises:** choose a borrowed instrument, a suitable analyzer,
  or a separately evaluated Pico capture option. Peer responses verify data
  exchange but do not provide a bus waveform. A scope's protocol decoding
  capability is instrument-dependent.
- **Later supplied examples:** the DS1307 and character-LCD examples may need
  additional modules and voltage-level checks. Confirm their lecture relevance
  before preparing parts. The equipment PDF also covers MCU2; its CAN hardware
  is not an MCU1 requirement.

## Current primary target

The learner selected the available **NUCLEO-N657X0-Q** on 2026-10-07. It is
N6/Cortex-M55, not F4. The first lab will use the onboard ST-LINK to load a
minimal program into SRAM in development boot mode. Persistent external-flash
boot is a separate later task. The course's F407/Cortex-M4 concepts still apply,
but register layouts, startup, memory, clocks and trace details need adaptation.
See [N657-SETUP.md](N657-SETUP.md) for the guided checkpoints.

Use the **H723 later to demonstrate transfer of understanding**, if desired.
It is Cortex-M7, and its clock/bus organization and peripheral implementations
need their own documentation. Copying F407 register layouts into an H723 target
is not a valid port. Even a GPIO port requires verification; serial peripherals
can differ much more substantially.

Sources: [course description](https://www.udemy.com/course/mastering-microcontroller-with-peripheral-driver-development/),
[N657 board manual](https://www.st.com/resource/en/user_manual/um3417-stm32n6-nucleo144-board-mb1940-stmicroelectronics.pdf),
[WeAct board](https://github.com/WeActStudio/WeActStudio.MiniSTM32H723),
[H723 reference manual RM0468](https://www.st.com/resource/en/reference_manual/dm00603761.pdf).
