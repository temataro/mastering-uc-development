# Current state

Last updated: 2026-10-09, Asia/Dubai.

**Current milestone:** M1 — first GUI build/debug, with M0 target checks pending.
**Course position:** learner reports roughly 28 lectures covered in `NOTES.md`;
debugging, buses/clocks, and vector-table concepts discussed. Exact current
lecture remains unconfirmed; earlier section-5 position is historical.
**Learning evidence:** build/flash/debug notebook checkpoint reported completed;
explanation not reviewed. FSBL compilation successful and debug connection error
resolved, both reported by the learner. A halt at `main` is not yet confirmed.
**Current target:** NUCLEO-N657X0-Q (STM32N6/Cortex-M55), correcting the earlier
F4 assumption. Follow [N657-SETUP.md](N657-SETUP.md).

## Confirmed preferences and background

- Objective: learn peripheral driver development independently.
- Comfortable with compilers, digital hardware, and microcontrollers; most of the
  course's peripheral concepts are new.
- Linux, separate current CubeMX/CubeIDE, GUI build/debug first, terminal and Make
  after understanding the GUI operation.
- Tutor shows setup commands; the learner runs them. Tutor may maintain these notes.
- The learner keeps a notebook here and on paper. Its location is not yet selected.

## Equipment

| Item | State | Preparation needed |
|---|---|---|
| WeAct MiniSTM32H723 | Owned; vendor identifies STM32H723VGT6 | Confirm board revision and debug probe before use |
| NUCLEO-N657X0-Q | Board now available; STM32N657X0H3Q Cortex-M55 | Use N6 docs and development-mode RAM project |
| Debugger | Onboard STLINK-V3EC, implemented with the F723 the learner identified; no separate J-Link | Verify CN10 USB enumeration, then actual N657 SWD connection |
| Raspberry Pi Picos | Several available; exact variants unknown | Reserve a protocol peer later; identify model before firmware work |
| Multimeter | Available | Use for continuity and supply/pull-up checks |
| Oscilloscope | Accessible when needed | Check probes, bandwidth, and decoding features for the specific lab |
| Logic analyzer | Not available | Revisit before protocol timing/capture exercises |
| Components, wires, breadboard | Assortment available; inventory not detailed | Check only the parts needed for the upcoming milestone |

## Audit results

- Ubuntu 26.04.1 LTS, x86-64.
- CubeIDE 2.2.0 found in `/opt/st/stm32cubeide_2.2.0`; installation metadata
  confirms the version; the learner confirmed 2.2.0 on 2026-10-07.
- CubeMX executable found under `/usr/local/STMicroelectronics/STM32Cube/`;
  installer metadata contains version 6.18.1. Confirm in Help/About.
- System Arm GCC 14.2.1 and GNU Make 4.4.1 execute successfully.
- IDE-bundled Arm GCC 14.3.1 executes successfully. GDB, CubeProgrammer CLI,
  ST-LINK GDB server, and OpenOCD binaries found; their runtime/device access
  has not been verified.
- `lsusb` failed here with `unable to initialize libusb: -99` and no
  `/dev/bus/usb` was visible. Host USB detection remains unknown.
- Course resources are in the separate `MasteringMCU/` Git checkout, clean at
  audit time; its latest commit is dated 2024-06-18.
- The workspace root is not recognized as a Git repository in this session.
  No repository initialization or commits performed.
- CubeN6 was not found in the local package repository on 2026-10-07.
- Direct PDF downloading failed because the terminal could not resolve
  `st.com`; elevated network access was rejected by the approval policy.
  `docs/download.sh` is prepared for the learner's terminal; no PDFs saved yet.

## Hurdles and decisions

| Item | Status | Next evidence needed |
|---|---|---|
| Primary board | NUCLEO-N657X0-Q confirmed; N6 requires adaptation from course F407 | USB detection and first RAM debug result |
| H723 porting | Deferred proposal; not a chosen requirement | Confirm whether the learner wants a later transfer exercise |
| Old integrated CubeMX workflow | Translation documented in `SETUP.md` | First actual project creation |
| Compiler differences | System GCC differs from IDE GCC | Capture build console; use one compiler for both paths |
| Full curriculum | Public page exposes first 10 sections; remaining 66 collapsed | Track exact later titles from the learner's course view as reached |
| Reference documents | N6 URLs indexed; downloads pending | the learner runs `bash docs/download.sh`; verify PDF revisions |
| N6 boot/memory | Flashless MCU; first lab uses development boot and SRAM | BOOT1 selector, RAM linker/startup/debug settings |
| Debug connection | Error 32 resolved after moving the reported JP1 to pins 2–3 | Confirm jumper silkscreen: manual identifies JP1 as BOOT0 and JP2 as BOOT1; then confirm halt at `main` |
| Protocol measurements | No logic analyzer; scope access available | Decide capture method when protocol labs approach |

## Next actions

1. Confirm whether the successful jumper change was physically labelled JP1 or
   JP2. Preserve the reported observation until that distinction is resolved.
2. Confirm the debugger halts at `main`; inspect the generated FSBL startup and
   RAM image placement, then practice stepping.
3. Documentation downloads still await host-side `bash docs/download.sh`.
4. Diagnose ITM/SWV output: start capture before the single print, verify `_write`
   is reached, and distinguish stdout buffering from trace configuration.

## Session log

### 2026-10-04 — learning agreement and baseline

- Created tutor agreement, milestone map, resource index, and setup notes.
- Inspected local course resources and public Udemy/ST/WeAct documentation.
- Confirmed manual execution of setup commands, F4 Nucleo loan possibility,
  multimeter availability, and oscilloscope access.
- The learner reported just starting section 5's Hello World lecture. Watching,
  successful build, debugger connection, and output remain separate checkpoints.
- No learner firmware generated, no hardware flashed, and no packages installed.

### 2026-10-07 — exact board and pre-printf setup

- The learner reported completing the notebook checkpoint and confirmed IDE 2.2.0.
- Identified the available board as NUCLEO-N657X0-Q, not the anticipated F4.
- Explained the F723/ST-LINK role versus N657 application execution, and the
  distinction between CN10 debug/VCP and CN8 application USB.
- Prepared official-document downloader/index and guided N6 setup checkpoints.
  Shell syntax checked; actual PDF downloads and board detection remain pending.
- Project generation, package installation, hardware writes, and `printf`
  implementation have not been performed.

### 2026-10-07 — first FSBL debug attempt

- CN10 connected to the PC; successful compilation reported.
- Project launch: `sections/FSBL/005-01HelloWorld_FSBL.launch`.
- Inspected launch and `sections/FSBL/Debug/st-link_gdbserver_log.txt`.
  Launch uses SWD, access port 1, automatic frequency and connect-under-reset.
  Connection fails from 24000 kHz down to 5 kHz, ending with error 32.
- SWV is enabled with a configured 16 MHz trace clock; this does not explain
  the initial target-connection failure. Trace setup remains a later check.
- Generated linker script targets N657 SRAM, not F407 flash. No firmware or
  launch settings modified. Development-boot/power checks are pending.

### 2026-10-07 — debug connection error resolved

- The learner reports: moving **JP1 to pins 2–3** fixed the debug error.
- Record this as the observed intervention and successful result, not as proof
  of a specific boot mode. The documented development-mode selector is
  JP2/BOOT1; JP1 is BOOT0. Jumper identification and the other selector's
  position remain unconfirmed.
- No source or launch configuration change was reported. Connection success
  does not yet establish that the application reached `main`.

### 2026-10-07 — ITM/SWV output diagnosis

- Latest server log confirms ST-LINK initialization, 3.30 V target voltage,
  SWD connection, an SWV client connection, and RUN_MODE. Reaching `main`
  and receiving application trace text remain unconfirmed.
- Pasted output is GDB-server diagnostics, not decoded application ITM text.
- Learner's `main.c` prints once without a newline, then loops forever.
  Buffering is a hypothesis; a breakpoint at `_write` plus an explicit
  `fflush(stdout)` experiment can distinguish it from downstream failures.
- `_write` routes characters through the course's register-level ITM function.
  The code targets the course's M3/M4 context; N6 portability remains to check
  if execution reaches that function but trace remains absent.
- Launch config specifies a 16 MHz trace clock. Its correctness for the actual
  N6 trace source is unverified; do not substitute a guessed clock value.
- Tutor inspected code and launch settings; no learner firmware was changed.

### 2026-10-09 — written understanding reviewed

- Reviewed learner-owned `NOTES.md` without editing it. Written evidence shows
  familiarity with debugging views, memory-mapped registers, clock sources,
  and interrupt concepts, with gaps in firmware loading/startup and linkage.
- Created [notes-review.html](notes-review.html): a standalone illustrated lesson,
  explicit corrections, F407/N657 distinctions, interactive clock/vector
  explorers, prediction questions, and independent learning checkpoints.
- Key corrections: SWD versus SWO, bare-metal `_write` versus a kernel syscall,
  firmware image versus FPGA bitstream, hardware map versus linker allocation,
  active call stack versus history, per-peripheral gating, initial-SP vector
  entry, weak-symbol resolution, and TrustZone versus boot authentication.
- Inspected existing Hello World ELF read-only: vector table at 0x34180400,
  code at 0x3418074C, `.data` VMA 0x341C0000 / LMA 0x34181324. The linker
  region called ROM is SRAM. Startup's undefined weak SystemInit call appears
  as a NOP in this ELF; do not infer clock or VTOR initialization from comments.
- Found local RM0486 Rev 2 in `docs/84466479.pdf`. Its presence supersedes
  the earlier statement that no reference PDF was locally available; the
  downloader's full document set has not been audited again.
- Checked local/internal HTML links, unique IDs, titled diagrams, JavaScript
  syntax, clock/timer calculations, bus-limit warning, and vector-offset input
  handling. Browser preview could not run because the installed Chromium snap
  rejected startup; browser layout remains unverified.
- No firmware/source/settings changed, builds run, hardware writes, or course
  milestones marked complete. Self-assessment controls are not completion proof.
- Next learner checkpoint: inspect the ELF with readelf/objdump/nm, explain
  vector/code/data placement and initialization, then return that explanation
  for review before the GPIO exercise. SWV and actual-clock/VTOR hurdles remain.

## Lab record template

Use this for tutor summaries; the learner's personal notebook remains separate.

```text
Date / lecture:
Objective:
Prediction:
Attempt / code location:
Observed result / evidence:
Explanation in the learner's own words:
Open question / hurdle:
Next action / equipment needed:
```
