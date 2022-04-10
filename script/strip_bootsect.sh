#!/usr/bin/env bash
#                  1       2         3       4       5
# strip_bootsect file objcpy_exec dd_exec rm_exec ld_exec


"$2" -O binary -R .note -R .comment -R .note.gnu.property \
     -R .debug_aranges -R .debug_info -R .debug_abbrev -R .debug_line -R .debug_str \
      "$1" "$1.tmp"

"$3" if="$1.tmp" of="$1.bin" bs=512 count=1 > /dev/null 2> /dev/null
"$4" "$1.tmp"
echo "Strip finished"
