# NUCLEO-N657X0-Q documentation

**PDF downloads are pending.** This session cannot resolve `st.com` from its
terminal. Its approval policy also rejected elevated network access. Web tools
could read several documents, but they cannot save the original PDFs here.

Run from the workspace root in your own terminal:

```sh
bash docs/download.sh
```

Requires `curl` and `pdfinfo` (both were found on this machine). The script
downloads nine official ST PDFs. It saves beside itself, skips existing files,
and validates new PDFs before renaming them. A failed download remains `.part`;
rerun to retry. No firmware or hardware configuration is changed.

| Document | Purpose | Read now? |
|---|---|---|
| UM3417 | This board's layout, debugger, power, USB, and boot selectors | Sections 7.3, 7.4.1, 7.6, 7.13, 8.1–8.2 |
| MB1940 C02 schematic | Electrical connections between chips and connectors | Follow CN10, ST-LINK and USART1 connections |
| DS14791 | N657 pins, electrical characteristics and capabilities | Overview; use pin/electrical tables when wiring |
| RM0486 | N6 peripheral registers and memory/clock architecture | Selected sections for each lab, not cover-to-cover |
| PM0273 | Cortex-M55 programming, exceptions and debug facilities | Selected sections as needed |
| ES0620 | Silicon behavior that differs from the manuals | Check applicable peripherals and silicon revision |
| UM3234 | Boot ROM and development/flash/serial boot | Development boot explanation |
| UM3249 | CubeN6 package layout and template workflows | Package overview; distinguish FSBL from application |
| AN6265 | N6 project creation and debugging in CubeIDE | Empty-project section and RAM/FSBL debugging guidance |

The source URLs are in [download.sh](download.sh). They target ST's maintained
documents; record the revision printed in each actual download. On 2026-10-07,
the web reader returned UM3417 Rev 4, ES0620 Rev 5, UM3234 Rev 5 and AN6265
Rev 1. The schematic and full reference manual exceeded web-reader limits.
AN6265 contains older integrated-CubeMX GUI screenshots; adapt them to IDE 2.2.0.

[Board page](https://www.st.com/en/evaluation-tools/nucleo-n657x0-q.html) ·
[N657 MCU page](https://www.st.com/en/microcontrollers-microprocessors/stm32n657x0.html) ·
[F723 MCU page](https://www.st.com/en/microcontrollers-microprocessors/stm32f723ie.html).
