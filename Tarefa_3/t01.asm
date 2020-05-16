; Adrian Cerbaro
; 178304

%include "./util.asm"

section .text
global _start

_start:
    xor     r14, r14
.loop_read:
    inc     qword [input_msg_args]
    mov     rdi, [max_nums]
    mov     [input_msg_args+8], rdi
    mov     rdi, input_msg
    mov     rsi, input_msg_args
    call    printf
    call    readint

    mov     [array+r14*8], rax
    inc     r14
    cmp     r14, [max_nums]
    jl      .loop_read
.loop_show:
    dec     r14
    cmp     r14, 0
    jl      .end
    mov     rdi, [array+r14*8]
    mov     rsi, [multiple_of]
    call    is_mul
    jne     .loop_show
    mov     rdi, rax
    call    printint
.end:
    call    endl
    call    exit

is_mul:
    xor     edx, edx
    mov     rax, rdi
    div     rsi
    mov     rax, rdi
    cmp     edx, 0
    ret

section .data
    max_nums:           dq  8
    multiple_of:        dq  3
    input_msg:          db  'Informe o número %d de %d: ', 0
    input_msg_args:     dq  1, 0
    output_msg:         db  'Último divisível por 3 informado é: ', 0

section .bss
    array:  resq 8