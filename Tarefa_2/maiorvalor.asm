; Adrian Cerbaro
; 178304

%include "./util.asm"
%include "./funcoes.asm"

section .text
global _start

_start:                      ; int main() {
    call readgt              ;     int rax = ler_maior();
    mov rdi, rax             ;     int rdi = rax;
    call printint            ;     cout << rdi;
    call endl                ;     cout << endl;
    call exit                ;     return 0;
                             ; }

readgt:                      ; ler_maior() {
    xor     rbx, rbx         ;     int rbx = 0   // Inicializa acumulador do maior
    xor     rdx, rdx         ;     int rdx = 0   // Inicializa o contador
.loop:                       ;     do {
    call    readint          ;         cin >> rax;    // Le um inteiro
    cmp     rax, 0           ;     
    je      readgt.return    ;         if(rax == 0) break;  // Se o inteiro lido for 0, sai do laço
    cmp rdx, 0               ;       
    cmove rbx, rax           ;         if(rdx == 0) rbx = rax;  // Se o contador for 0, inicializa rbx
    mov     rdi, rbx         ;         rdi = rbx;
    mov     rsi, rax         ;         rsi = rax;
    call    maior            ;         rax = max(rdi, rsi);    // rax recebe o maior entre rdi e rsi
    mov     rbx, rax         ;         rbx = rax               // rbx recebe o maior (rax)
    inc     rdx              ;         rdx++                   // Incrementa contador
    jmp     readgt.loop      ;     } while(true);
.return:
    mov rax, rbx             ;     return rax = rbx;
    ret                      ; }