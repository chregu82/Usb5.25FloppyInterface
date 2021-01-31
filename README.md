# Usb5.25FloppyInterface
A teensy 3.2 based USB to 5.25" Floppy interface for reading and writing from modern machines which use the USB Mass Storage Protocol and understand FAT12.

## Origin
The project is based on the [teensy-3.2-msd by damonearp](https://github.com/damonearp/teensy-3.2-msd). This project used an SD card instead of a floppy drive.

## Build on Windows
I'm using the Code::Blocks IDE on Windows to develop the code. Almost every Text Editor is suitable.

To compile on Windows you will need to install a [GNU ARM cross compiler toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads) and
ensure that  ```arm-none-eabi-gcc```, ```arm-none-eabi-as```
```arm-none-eabi-ld``` and ```arm-none-eabi-objcopy``` are in your PATH.

At this point, just run:

```
> make
```

## Build on Linux / Mac
At the moment there's no makefile for Linux / Mac.

## Program the Teensy
Simply use the [Loader App](https://www.pjrc.com/teensy/loader_win10.html) to load the floppy.hex from the bin folder to your Teensy 3.2.




