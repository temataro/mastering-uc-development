# Current target: NUCLEO-N657X0-Q

Confirmed by the learner on 2026-10-07. This corrects the earlier assumption that
the borrowed board was an F4 Nucleo. It carries an STM32N657X0H3Q Cortex-M55
application MCU and an onboard STLINK-V3EC debugger implemented by another MCU.
The learner identified that second MCU as an STM32F723 (Cortex-M7).

## Two processors, separate jobs

```text
PC: CubeIDE/GDB ── USB CN10 ── F723 running ST-LINK ── SWD ── N657 debug hardware
PC: terminal   ── USB CN10 ── F723 UART bridge      ── USART1 ── N657 application
PC/device      ── USB CN8  ───────────────────────── USB peripheral in N657
```

The F723 handles PC-facing debug communication, target reset/control, serial
bridging and ST-LINK power/status management. GDB runs on the PC; the N657's
own debug hardware halts/steps its CPU. The N657 executes the learner's firmware
and operates its peripheral registers. F723 performance does not make its
ST-LINK firmware a second application processor for the learner's project.

The VCP bridge connects to N657 USART1 on PE5/PE6. A firmware UART configuration
is still needed before application messages can appear in a terminal. CN8 USB
behavior also depends on application firmware or the selected ROM boot mode.
No external J-Link is needed for the first SWD debug session. SWO is a trace
signal, distinct from SWD; SWV setup remains a later, unverified checkpoint.

Sources: [UM3417](https://www.st.com/resource/en/user_manual/um3417-stm32n6-nucleo144-board-mb1940-stmicroelectronics.pdf),
[F723](https://www.st.com/en/microcontrollers-microprocessors/stm32f723ie.html),
[N657](https://www.st.com/en/microcontrollers-microprocessors/stm32n657x0.html).

## First lab scope

**Goal:** compile a minimal C project, load it into internal SRAM, and halt at
`main`. Printing, GPIO drivers and standalone power-on boot come afterward.

The N657 has no internal program flash. Development-mode RAM loading avoids
the external-flash boot workflow for this lab. The RAM image is lost when power
is removed. Persistent operation later needs a separately planned external
flash/boot arrangement. F407 addresses, register layouts and trace setup cannot
be copied directly to N6.

[ST's boot overview](https://github.com/STMicroelectronics/stm32ai-modelzoo-services/blob/main/semantic_segmentation/docs/README_DEPLOYMENT_STM32N6.md)
and [boot ROM manual](https://www.st.com/resource/en/user_manual/um3234-how-to-proceed-with-boot-rom-on-stm32n6-mcus-stmicroelectronics.pdf).

## Checkpoint A: identify and connect

The learner performs these steps:

1. Disconnect power before adjusting selectors. Identify CN10, CN8, JP1
   (BOOT0), JP2 (BOOT1) and the CN9 power selector using board labels/manual.
2. For development boot, select JP2/BOOT1 = 1 (pins 2–3). BOOT0 does not
   determine this mode; JP1/BOOT0 = 0 (pins 1–2) is a suitable initial setting.
3. For power through ST-LINK, verify CN9 selects 5V_STLK (pins 1–2).
4. Connect a USB data cable from the PC to CN10. CN8 is not needed for this lab.
5. Run the commands below and report the ST-LINK USB entry and serial device,
   if present. If no ST-LINK appears, investigate cable/port before project setup.

```sh
lsusb
ls -l /dev/serial/by-id/
```

Enumeration establishes PC-to-F723 communication, not yet an N657 debug session.
If the labels or selector layout differ, stop and resolve the physical revision.

Boot jumper pin pairs are documented in [ST's Nucleo example instructions](https://github.com/STMicroelectronics/STM32CubeN6/blob/main/Projects/NUCLEO-N657X0-Q/Examples/I2C/I2C_TwoBoards_ComDMA/README.md).

## Checkpoint B: create the minimal project together

**Observed on 2026-10-07:** the FSBL project compiles; the learner reports that
moving **JP1 to pins 2–3** resolved ST-LINK error 32. The manual assigns JP1 to
BOOT0 and JP2 to BOOT1, so confirm the physical jumper label before treating
this as a verified development-boot configuration. Project creation is already
complete; the remaining checkpoint is a successful halt at `main`.

After A succeeds, use CubeIDE 2.2.0's **empty STM32 project** flow. Target
`NUCLEO-N657X0-Q` / `STM32N657X0H3Q`, C, executable, GCC and Make-based build.
Inspect the actual N6 wizard options before completing creation. The intended
starting context is the minimal secure/FSBL project executing in internal RAM;
additional application, external-memory-loader and nonsecure contexts are not
needed for this checkpoint.

Proposed project name: `n657_hello_debug`. Proposed location: a learner-owned
`projects/` directory in this workspace, separate from instructor resources.
These folders/projects have not been created. GUI creation remains the learner's
task. Confirm the generated RAM linker script, startup file, debugger reset
behavior and ELF before the first load; do not guess addresses from F4.

The local package repository currently contains CubeH7, but CubeN6 was not
found. Determine whether the empty-project wizard supplies the required files;
if a package is requested, the learner installs STM32CubeN6 via the GUI with guidance.

Do not substitute an XIP/LRUN demo for this RAM checkpoint without reviewing it:
some N6 templates include external flash setup and irreversible OTP writes.
That is a concrete property of [ST's XIP template](https://github.com/STMicroelectronics/STM32CubeN6/blob/main/Projects/NUCLEO-N657X0-Q/Templates/Template_FSBL_XIP/README.md),
not a requirement for learning C stepping or GPIO.

[AN6265](https://www.st.com.cn/resource/en/application_note/an6265-getting-started-with-stm32n6-mcus-in-stm32cubeide-stmicroelectronics.pdf)
describes N6 empty projects and RAM FSBL debugging, but uses older IDE menus.

**Pause here:** capture the wizard's N6 project/context options before generating
or importing a more complex project. We will inspect each required choice.

## N657 course-porting note: TrustZone gateway and generated warnings

Recorded 2026-10-08 for `sections/06-017/FSBL`.

- N657's Cortex-M55 supports TrustZone: Secure and Non-secure execution states
  on the same CPU, with controlled access to memory and peripherals. This is
  absent from the course's Cortex-M4 F407, but is not exclusive to N657.
- The generated Secure project requests `--cmse-implib` and
  `--out-implib=./secure_nsclib.o`. These generate a library describing Secure
  gateways that a separate Non-secure image can link against.
- Replacing the generated source with the course's sorting example removed all
  `cmse_nonsecure_entry` functions. The observed linker error was
  `no symbol found for import library`.
- The learner restored `secure_add_one`, marked `cmse_nonsecure_entry`.
  This supplies an export for the existing import-library configuration;
  it is template scaffolding, not a function every N657 program must contain.
  Successful rebuilding after this addition has not yet been reported.
- The attribute requests compiler support for a Non-secure-callable Secure
  entry point. It does not configure memory security attribution or initialize
  a Non-secure application. Gateway veneers must reside in a correctly
  configured Non-secure Callable region for actual cross-state calls.
- Both `#warning` directives only emit build diagnostics. They do not enable
  the FPU, configure TrustZone, or resolve the import-library error. FPU access
  initialization is separate from TrustZone and relevant when FP instructions
  are executed; hard-float builds also impose ABI/startup requirements.
- A standalone Secure exercise can instead omit gateway-library generation
  while retaining Secure compilation. Do not confuse those two settings.

Sources: [N657 product documentation](https://www.st.com/en/microcontrollers-microprocessors/stm32n657x0.html),
[GCC CMSE attributes](https://gcc.gnu.org/onlinedocs/gcc/ARM-ARMv8-M-Security-Extensions.html),
[GNU linker Secure Gateway import libraries](https://www.sourceware.org/binutils/docs/ld/ARM.html).
