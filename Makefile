# Toolchain
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# Source files
SRC = \
  Core/main.c \
  CMSIS/system_n32g031.c \
  CMSIS/startup_n32g031_gcc.s \
  Device/n32g031_rcc.c \
  Device/n32g031_usart.c \
  Device/n32g031_gpio.c \
  Device/n32g031_adc.c

# Output settings
TARGET = main
OUTDIR = build
ELF = $(OUTDIR)/$(TARGET).elf
HEX = $(OUTDIR)/$(TARGET).hex

# Compiler flags
CFLAGS = -mcpu=cortex-m0 -mthumb -O0 -g -Wall \
  -ICore \
  -ICMSIS \
  -IDevice

# Linker flags and script
LDFLAGS = -TLinker/n32g031_flash.ld -Wl,--gc-sections
LIBS = -lc -lm -lnosys

# Default target
all: $(HEX)

# Create build directory if not exist
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Compile and link
$(ELF): $(SRC) | $(OUTDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# Convert ELF to HEX and show size
$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@
	$(SIZE) $<
OPENOCD_DIR = /c/Users/ASUS/Downloads/Test_N32_Makefile/openocd-v0.12

WIN_PATH = C:/Users/ASUS/Downloads/Test_N32_Makefile/build/main.elf

flash:
	$(OPENOCD_DIR)/bin/openocd.exe \
	-f $(OPENOCD_DIR)/share/openocd/scripts/interface/cmsis-dap.cfg \
	-f $(OPENOCD_DIR)/share/openocd/scripts/target/n32g03x.cfg \
	-c "program $(WIN_PATH) verify reset exit"



# Clean build outputs
clean:
	rm -rf $(OUTDIR)
