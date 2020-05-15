section .text

global maior

maior:
    mov     rax, rsi
    cmp     rdi, rsi
    cmovg   rax, rdi
    ret 