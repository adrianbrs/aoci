; Adrian Cerbaro
; 178304

%include "./util.asm"

section .text
global _start

_start:
    xor     rbx, rbx
.loop:
    mov     rdi, rbx
    call    fibonacci
    mov     [vet+rbx*8], rax
    inc     rbx
    cmp     rbx, 10
    jl      .loop
.end:
    mov     rdi, vet
    call    showvet
    call    exit


showvet:
    push    rbx
    xor     rbx, rbx
.loop:
    mov     rdi, [vet+rbx*8]
    call    printint
    call    endl
    inc     rbx
    cmp     rbx, 10
    jl      .loop
.end:
    pop     rbx
    ret


fibonacci:
    xor     rax, rax
    xor     rsi, rsi
    inc     rsi
.loop:
    test    rdi, rdi
    jz      .end
    dec     rdi
    push    rax
    add     rax, rsi
    pop     rsi
    jmp     .loop
.end:
    ret



section .bss
    vet:        resq      10