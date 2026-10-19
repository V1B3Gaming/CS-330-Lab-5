# CS-330-Lab-5

gcc -m64 -Wall -Wextra -O0 asgn5.c -o asgn5_c
./asgn5_c

gcc -m64 -O0 -masm=att -S asgn5.c -o asgn5.s

gcc -m64 asgn5.s -o asgn5_asm

./asgn5_asm

