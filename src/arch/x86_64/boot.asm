global start
extern long_mode_start

section .text
bits 32
start:
    mov esp, stack_top

    call check_multiboot
    call check_cpuid
    call check_long_mode

    call set_up_page_tables
    call enable_paging

    lgdt [gdt64.pointer]

    jmp gdt64.code:long_mode_start

    ; print `OK` to screen
    mov dword [0xb8000], 0x2f4b2f4f
    hlt

check_multiboot:
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret
.no_multiboot:
    mov al, "0"
    jmp error

check_cpuid:
    pushfd
    pop eax

    mov ecx, eax

    xor eax, 1 << 21

    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    cmp eax, ecx
    je .no_cpuid
    ret
.no_cpuid:
    mov al, "1"
    jmp error

check_long_mode:
    mov eax, 0x80000000    ; implicit argument for cpuid
    cpuid                  ; get highest supported argument
    cmp eax, 0x80000001    ; it needs to be at least 0x80000001
    jb .no_long_mode       ; if it's less, the CPU is too old for long mode

    mov eax, 0x80000001    ; argument for extended processor info
    cpuid                  ; returns various feature bits in ecx and edx
    test edx, 1 << 29      ; test if the LM-bit is set in the D-register
    jz .no_long_mode       ; If it's not set, there is no long mode
    ret
.no_long_mode:
    mov al, "2"
    jmp error

set_up_page_tables:
    mov eax, p3_table
    or eax, 0b11 ; present + writable
    mov [p4_table], eax

    mov eax, p2_table
    or eax, 0b11 ; present + writable
    mov [p3_table], eax

    mov ecx, 0         ; counter variable

.map_p2_table:
    mov eax, 0x200000  ; 2MiB
    mul ecx            ; start address of ecx-th page
    or eax, 0b10000011 ; present + writable + huge
    mov [p2_table + ecx * 8], eax ; map ecx-th entry

    inc ecx            ; increase counter
    cmp ecx, 512       ; if counter == 512, the whole P2 table is mapped
    jne .map_p2_table  ; else map the next entry

    ret

enable_paging:
    mov eax, p4_table
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

error:
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte  [0xb800a], al
    hlt

section .bss
align 4096
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096
stack_bottom:
    resb 64
stack_top:

section .rodata
gdt64:
    dq 0 ; zero entry
.code: equ $ - gdt64 ; new
    dq (1<<43) | (1<<44) | (1<<47) | (1<<53) ; code segment
.pointer:
    dw $ - gdt64 - 1
    dq gdt64
