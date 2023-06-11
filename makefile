COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_BLUE=\033[0;34m
END_COLOR=\033[0m

FILES= ./build/kernel.asm.o ./build/kernel.o ./build/idt/idt.asm.o ./build/idt/idt.o ./build/memory/memory.o ./build/io/io.asm.o

INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

start: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin
	@make launch

start_no_launch: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	@echo "$(COLOUR_GREEN)[MAKEFILE]: Building OS Binary$(END_COLOR)"
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin
	

./bin/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./bin/boot.bin: ./src/boot/boot.asm
	@echo "$(COLOUR_GREEN)[MAKEFILE]: Building Assemblies$(END_COLOR)"
	-nasm -f bin src/boot/boot.asm -o bin/boot.bin
	-nasm -f bin src/boot/boot.asm -o build/boot.o

./build/kernel.asm.o: ./src/kernel.asm
	-nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o
	
./build/kernel.o: ./src/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o

./build/idt/idt.asm.o: ./src/idt/idt.asm
	-nasm -f elf -g ./src/idt/idt.asm -o ./build/idt/idt.asm.o

./build/idt/idt.o: ./src/idt/idt.c
	i686-elf-gcc $(INCLUDES) -I./src/idt $(FLAGS) -std=gnu99 -c ./src/idt/idt.c -o ./build/idt/idt.o

./build/memory/memory.o: ./src/memory/memory.c
	i686-elf-gcc $(INCLUDES) -I./src/memory $(FLAGS) -std=gnu99 -c ./src/memory/memory.c -o ./build/memory/memory.o

./build/io/io.asm.o: ./src/io/io.asm
	-nasm -f elf -g ./src/io/io.asm -o ./build/io/io.asm.o


Debug:
	@make start_no_launch
	gdb 

launch:
	@echo "$(COLOUR_GREEN)[MAKEFILE]: Running QEMU$(END_COLOR)"
	@echo "\n"
	-qemu-system-x86_64 -hda ./bin/os.bin

	@make clean

clean:
	@echo "$(COLOUR_RED)[MAKEFILE]: Cleaning$(END_COLOR)"
	-rm -rf bin/boot.bin
	-rm -rf bin/kernel.bin
	-rm -rf bin/os.bin
	-rm -rf $(FILES)
	-rm -rf build/kernelfull.o
	-rm -rf build/boot.o
	-rm -rf build/idt.o