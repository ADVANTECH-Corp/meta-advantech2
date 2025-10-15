#i!/bin/sh
#this shell is for spi flash test for rsb4220

#!/bin/bash
 
echo "[Copy adv_boot.bin]"
mtd_debug read /dev/mtd0 0x1D000 0x1000 mac
flash_eraseall /dev/mtd0
dd if=../image/adv_boot.bin of=/dev/mtd0 bs=512 1>/dev/null 2>/dev/null;sync
mtd_debug erase /dev/mtd0 0x1D000 0x1000
mtd_debug write /dev/mtd0 0x1D000 0x1000 mac
rm -rf mac
sync

echo "[Done]"
