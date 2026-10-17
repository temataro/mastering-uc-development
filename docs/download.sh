#!/usr/bin/env bash
# =============================================================================
# download.sh — Download the NUCLEO-N657X0-Q reference documents
#
# Saves official ST PDFs beside this script. Partial downloads keep a .part
# suffix; each PDF is checked before receiving its final filename.
#
# Copyright (c) 2026 <ataro.temesgen@gmail.com>
# SPDX-License-Identifier: Apache-2.0
# =============================================================================

set -eu
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

download() {
    local filename="$1" url="$2"
    if [ -s "$filename" ]; then
        printf 'Already present: %s\n' "$filename"
        return
    fi
    printf 'Downloading: %s\n' "$filename"
    curl --fail --location --retry 2 --connect-timeout 15 --max-time 600 \
        --output "$filename.part" "$url"
    pdfinfo "$filename.part" >/dev/null
    mv -- "$filename.part" "$filename"
}

download UM3417-nucleo-n657x0-q-board-manual.pdf \
    https://www.st.com/resource/en/user_manual/um3417-stm32n6-nucleo144-board-mb1940-stmicroelectronics.pdf
download MB1940-n657x0-q-c02-schematic.pdf \
    https://www.st.com/resource/en/schematic_pack/mb1940-n657x0q-c02-schematic.pdf
download DS14791-stm32n657-datasheet.pdf \
    https://www.st.com/resource/en/datasheet/stm32n657x0.pdf
download RM0486-stm32n6-reference-manual.pdf \
    https://www.st.com/resource/en/reference_manual/rm0486-stm32n647657xx-armbased-32bit-mcus-stmicroelectronics.pdf
download PM0273-cortex-m55-programming-manual.pdf \
    https://www.st.com/resource/en/programming_manual/pm0273-stm32-cortexm55-mcus-programming-manual-stmicroelectronics.pdf
download ES0620-stm32n6-errata.pdf \
    https://www.st.com/resource/en/errata_sheet/es0620-stm32n6xxxx-device-errata-stmicroelectronics.pdf
download UM3234-stm32n6-boot-rom.pdf \
    https://www.st.com/resource/en/user_manual/um3234-how-to-proceed-with-boot-rom-on-stm32n6-mcus-stmicroelectronics.pdf
download UM3249-stm32cuben6-getting-started.pdf \
    https://www.st.com/resource/en/user_manual/um3249-getting-started-with-stm32cuben6-for-stm32n6-series-stmicroelectronics.pdf
download AN6265-stm32n6-cubeide-getting-started.pdf \
    https://www.st.com/resource/en/application_note/an6265-getting-started-with-stm32n6-mcus-in-stm32cubeide-stmicroelectronics.pdf
