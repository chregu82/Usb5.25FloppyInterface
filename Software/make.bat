@echo off

if "%1" == "clean" goto CLEAN

:: get path to compiler
del tmp.txt 2>NUL
arm-none-eabi-gcc -print-sysroot -> tmp.txt
set /p TOOLCHAIN=<tmp.txt
set TOOLCHAIN="%TOOLCHAIN%
set CC=arm-none-eabi-gcc
set CXX=arm-none-eabi-g++
set OBJCOPY=arm-none-eabi-objcopy
set SIZE=arm-none-eabi-size

:: set paths
set CURDIR=%CD%
set TARGET=main
set SRC=src
set BUILD=build
set BIN=bin
set INCLUDE=include
set DEPENDS=depends
set CORES=%DEPENDS%\cores-master-20160302\teensy3
set CORES_INC=%CORES%
set CORES_SRC=%CORES%
set LINKER_SCRIPT=%CORES%\mk20dx256.ld
set SD=%DEPENDS%\adafruit-SD-master-20131105\utility
set SD_INC=%SD%
set SD_SRC=%SD%
set SPI=%DEPENDS%\spi-master-20150403
set SPI_INC=%SPI%
set SPI_SRC=%SPI%

:: Teensy 3.2 Options
set OPTIONS=-DF_CPU=48000000 -D__MK20DX256__ 
:: required for SPI.h
set OPTIONS=%OPTIONS% -DTEENSYDUINO=121
:: Enable logging to be tx'd on the hardware serial 1, comment out to disable
set OPTIONS=%OPTIONS% -DDEBUG -DSERIAL_BAUD=115200

set INCLUDES= -I%TOOLCHAIN%\include" -I%INCLUDE% -I%CORES_INC% -I%SD_INC% -I%SPI_INC%

:: C/C++ Preprocessor flags
set CPPFLAGS= -Wall -Wextra -mcpu=cortex-m4 -mthumb -nostdlib -MMD 
set CPPFLAGS= %CPPFLAGS% %OPTIONS% %INCLUDES% -Os -mapcs-frame

set CFLAGS= -ffunction-sections -fdata-sections -Wno-old-style-declaration

:: C++ Flags
set CXXFLAGS= -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti

:: Linker Flags
set LDFLAGS= -Wl,--gc-sections,--defsym=__rtc_localtime=0 --specs=nano.specs 
set LDFLAGS= %LDFLAGS% -mcpu=cortex-m4 -mthumb -T%LINKER_SCRIPT% -Os 

:: What to link
set OBJS= %BUILD%\chs.o %BUILD%\fault.o %BUILD%\main.o %BUILD%\scsi_sd.o %BUILD%\sd.o %BUILD%\serialize.o %BUILD%\usb_desc.o %BUILD%\usb_dev.o %BUILD%\usb_msd.o %BUILD%\analog.o %BUILD%\avr_emulation.o %BUILD%\memcpy-armv7m.o %BUILD%\mk20dx128.o %BUILD%\nonstd.o %BUILD%\pins_teensy.o %BUILD%\serial1.o %BUILD%\sd2card.o %BUILD%\spi.o       

:: compile
del *.o /Q /S 2>NUL
del *.d /Q /S 2>NUL
del *.hex /Q 2>NUL
del *.elf /Q 2>NUL
for /R "%CURDIR%" %%c in (*.c) do %CC% %%c %CPPFLAGS% %CFLAGS% %INCLUDES% -c -o build\%%~nc.o
for /R "%CURDIR%" %%c in (*.cpp) do %CC% %%c %CPPFLAGS% %CXXFLAGS% %INCLUDES% -c -o build\%%~nc.o
for /R "%CURDIR%" %%s in (*.s) do %CC% %%s %CPPFLAGS% %CFLAGS% %INCLUDES% -c -o build\%%~ns.o

:: linking files
%CC% %LDFLAGS% -o %BUILD%\floppy.elf %OBJS%

:: generate hex file
md build 2>NUL
%OBJCOPY% -O ihex -R .eeprom %BUILD%\floppy.elf %BIN%\floppy.hex 

del tmp.txt 2>NUL

goto end

:: Cleanup files
:CLEAN
del *.o /Q /S 2>NUL
del *.d /Q /S 2>NUL
del *.hex /Q 2>NUL
del *.elf /Q 2>NUL
del *.img /Q 2>NUL
del *.dump /Q 2>NUL
goto end

:END