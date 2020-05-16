; Adrian Cerbaro
; 178304

%include "./util.asm"

section .text
global _start

_start:
    xor     r14, r14
    
    mov     r13, [max_nums]
    mov     [input_args+1*8], r13

    mov     r12, [multiple_of]
    mov     [output_args], r12

.loop_read:
    inc     qword [input_args]
    mov     rdi, input_msg
    mov     rsi, input_args
    call    printf
    call    readint

    mov     [array+r14*8], rax
    inc     r14
    cmp     r14, [max_nums]
    jl      .loop_read

.loop_show:
    test    r14, r14
    jz      .end
    dec     r14

    mov     rbx, [array+r14*8]
    
    mov     rdi, rbx
    mov     rsi, [multiple_of]
    call    restof
    jnz     .loop_show

    mov     [output_args+1*8], rbx
    mov     rdi, output_msg
    mov     rsi, output_args
    call    printf

.end:
    call    endl
    call    exit

restof:
    xor     edx, edx
    mov     rax, rdi
    div     rsi
    test    edx, edx
    ret

section .data
    max_nums:           dq  8
    multiple_of:        dq  3
    
    input_msg:          db  'Informe um número (%d/%d): ', 0
    input_args:         dq  0, 0
    
    output_msg:         db  'Último divisivel por %d informado eh: %d', 0
    output_args:        dq  0, 0

section .bss
    array:  resq 8