riscv64-unknown-elf-gcc -march=rv64imfd -mabi=lp64d -nostartfiles -O0 -o outfiles/main.o main.c -Wl,-T,linker.ld
riscv64-unknown-elf-objdump -SD main.o > main.out
riscv64-unknown-elf-objcopy -O verilog main.o rom.vh
python3 hello_extract.py