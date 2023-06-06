COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_BLUE=\033[0;34m
END_COLOR=\033[0m

start:
	@clear
	@echo "$(COLOUR_GREEN)[MAKEFILE]: Building Assemblies$(END_COLOR)"
	-nasm -f bin src/boot/boot.asm -o bin/boot.bin
	

	@echo "$(COLOUR_GREEN)[MAKEFILE]: Running QEMU$(END_COLOR)"
	@echo "\n\n"
	-qemu-system-x86_64 -hda ./bin/boot.bin

	@make clean

clean:
	@echo "$(COLOUR_RED)[MAKEFILE]: Cleaning$(END_COLOR)"
	-rm -rf bin/boot.bin
