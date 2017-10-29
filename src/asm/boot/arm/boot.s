interrupt_vector_table:
    b .
    b .
    b .
    b .
    b .
    b .
    b .
    b .

.conn stack, 0x10000
_stack:
    .globl _start
    ldr sp, =stack+0x10000
    bl kstart
1:
    b 1b
