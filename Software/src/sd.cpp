/* simple c interface for the c++ Sd2Card class */

#include <kinetis.h>

#include "sd.h"
#include "serialize.h"
#include "string.h"

/* NOTE
 * `sd_init()` needs to be called after hardware intialization. First attempt
 * called the function right after calling `usb_init()` in pins_teensy.c, this
 * led to a weird bug where Sd2Card.type_ would be reset to 0 the moment
 * `usb_isr()` was called. The odd thing was this field was the only one
 * changed. Once `sd_init()` was moved to once the usb driver recieves a
 * SET CONFIGURATION setup command everything worked fine.
 */

 unsigned char memory[32768];

int sd_init(void)
{
    return 0;
}

uint32_t sd_max_lba(void)
{
    return 64;
}

int sd_read_block(void *dest, uint32_t lba)
{
    memcpy(dest, &memory[lba*512], 512);
    LOGINFO("read from %04x", lba);
    return 0;
}

int sd_write_block(uint32_t lba, const void *src)
{
    memcpy(&memory[lba*512], src, 512);
    LOGINFO("write to %04x", lba);
    return 0;
}
