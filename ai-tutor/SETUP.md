# Setup and GUI-to-terminal workflow

**The learner runs setup commands.** This file records the audit and explains
proposed actions. It does not authorize automatic installation or flashing.

**Current board, confirmed 2026-10-07:** NUCLEO-N657X0-Q, an N6/Cortex-M55
board. [N657-SETUP.md](N657-SETUP.md) defines the actual first RAM-debug lab;
the general workflows below require its boot/memory choices for this target.

## Installed tool inventory

| Tool | Observed version/location | Verification |
|---|---|---|
| Ubuntu | 26.04.1 LTS, x86-64 | `/etc/os-release` |
| CubeIDE | 2.2.0, `/opt/st/stm32cubeide_2.2.0/stm32cubeide` | Installation metadata and the learner's version confirmation |
| CubeMX | `/usr/local/STMicroelectronics/STM32Cube/STM32CubeMX/STM32CubeMX` | Executable present; installer metadata says 6.18.1; check Help/About |
| System Arm GCC | 14.2.1, `/usr/bin/arm-none-eabi-gcc` | `--version` succeeds |
| IDE Arm GCC | 14.3.1 | `--version` succeeds |
| GNU Make | 4.4.1, `/usr/bin/make` | `--version` succeeds |
| CubeProgrammer CLI | Bundled in IDE; not on current PATH | Binary present; runtime/USB not tested |
| GDB / ST-LINK GDB server / OpenOCD | Bundled in IDE; not on current PATH | Binaries present; debugging not tested |

There is no evidence that the tools need reinstalling. Establish a working
baseline before changing versions. Record the versions actually used per lab.

## First host checks

Run these in the learner's terminal. They identify versions and USB enumeration;
they do not program the board.

```sh
arm-none-eabi-gcc --version
make --version
lsusb
```

Open the installed GUIs and read Help/About:

```sh
/opt/st/stm32cubeide_2.2.0/stm32cubeide
/usr/local/STMicroelectronics/STM32Cube/STM32CubeMX/STM32CubeMX
```

Launch one command at a time or use the desktop launchers. Select a fresh
workspace outside the supplied instructor `Workspace/`. Its location and the
learner project layout are still to be chosen. If a command fails, preserve its
exact output before trying fixes.

Inside this session `lsusb` failed to initialize libusb and `/dev/bus/usb` was
not visible. That does not establish a host driver or board problem. A successful
USB listing alone also does not verify permission to debug the target.

## Translate the older course workflow

| Course operation | Installed-tool equivalent | What the learner should understand |
|---|---|---|
| Create bare-metal/empty project in IDE | Use CubeIDE's empty STM32 project flow with the exact target | Startup, linker script, device selection and compiler flags |
| Open integrated `.ioc` editor | Open the `.ioc` in standalone CubeMX | Configuration file versus generated source |
| Generate initialization in IDE | In CubeMX choose STM32CubeIDE output, generate, then import into IDE | Which tool generates files and which builds/debugs |
| Press Build | IDE invokes compiler/linker and its chosen build system | Read the console before adding a terminal wrapper |
| Press Debug | IDE starts a debug server and GDB through the probe | Programming, reset, halt, and stepping are distinct operations |
| View SWV `printf` output | Check target/probe/SWO routing and clock settings first | SWV is a separate trace path; DFU cannot replace it |

The first course lab appears to use an **empty project**; do not generate a HAL
application as its substitute. When a later lab needs CubeMX, use it deliberately
for configuration/clock inspection or agreed scaffolding. Decide which generated
initialization is retained before adding learner register code; two independent
initializers can overwrite each other's settings.

[ST's separation announcement](https://community.st.com/stm32cubeide-mcus-28/stm32cubeide-2-0-0-released-159542)
confirms standalone CubeMX and IDE empty-project support. The UI details should
be checked against the actual installed GUI when creating the first project.

## Compiler consistency

The currently installed IDE compiler directory is:

```text
/opt/st/stm32cubeide_2.2.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.14.3.rel1.linux64_1.0.100.202602081740/tools/bin
```

Inspect the IDE build console to confirm the compiler selected for the project.
For terminal builds, use that same compiler. A proposed terminal-only PATH
change, after that confirmation, is:

```sh
export PATH="/opt/st/stm32cubeide_2.2.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.14.3.rel1.linux64_1.0.100.202602081740/tools/bin:$PATH"
arm-none-eabi-gcc --version
```

This affects the current shell only; do not add it to shell startup files yet.
The plugin path is installation-specific and may change on an IDE update.

## Make progression

For the first project, select a Make-based IDE build so it matches the intended
learning path. After a successful GUI build, inspect its generated makefile and
actual build directory. If the project instead uses CMake/Ninja, confirm the
desired build system before trying Make commands.

For a confirmed Make project, the generic operation is:

```text
make -C <actual-project-build-directory> all
```

This is a command pattern, not a runnable command until the real path is known.
The compiler flags, source files, linker script, and optimization should match
the GUI build. Later, the learner writes a small Makefile and explains each rule;
the tutor reviews it. Do not maintain two independently generated versions of
the same application simply to obtain Make support.

## Programming and debugging

- Prefer ST-LINK/SWD for course debugging. DFU transfers firmware through the
  system bootloader; it does not provide breakpoints, stepping, or register views.
- The bundled programmer is currently at:

```text
/opt/st/stm32cubeide_2.2.0/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_2.2.500.202603051304/tools/bin/STM32_Programmer_CLI
```

- No flash command is proposed until the board, image, connection method and
  target memory are verified. A standalone CubeProgrammer installation may be
  useful later; the missing PATH entry alone does not require one.
- If using a Nucleo's debugger for the WeAct, inspect that exact board manual
  for external-target wiring and jumpers first. Do not guess from another board.
- Confirm DFU boot pins/interface using the H723 bootloader documentation and
  physical board revision before treating USB-C as a programming interface.

Use CMSIS where the lesson calls for it. Do not add CMSIS-DSP or unrelated
middleware to the initial driver-learning project.
