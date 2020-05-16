; Adrian Cerbaro
; 178304

%include "./util.asm"
%include "./funcoes.asm"

section .text
global _start

_start:                      ; int main() {
    mov     rdi, help_msg
    call    printstr         ;     cout << help_msg;
    call    endl             ;     cout << endl;
    call    readgt
    mov     r15, rax         ;     int r15 = ler_maior();
    mov     rdi, biggest_msg
    call    printstr         ;     cout << biggest_msg;
    mov     rdi, r15
    call    printint         ;     cout << rax;
    call    endl             ;     cout << endl;
    call    exit             ;     return 0;
                             ; }

readgt:                      ; ler_maior() {
    xor     rbx, rbx         ;     int rbx = 0   // Inicializa acumulador do maior
    xor     r14, r14         ;     int r14 = 0   // Inicializa o contador
.loop:                       ;     do {
    mov     rdi, input_msg
    call    printstr         ;         cout << input_msg;
    call    readint          ;         cin >> rax;    // Le um inteiro
    cmp     rax, 0           ;     
    je      readgt.return    ;         if(rax == 0) break;  // Se o inteiro lido for 0, sai do laço
    cmp     r14, 0           ;       
    cmove   rbx, rax         ;         if(r14 == 0) rbx = rax;  // Se o contador for 0, inicializa rbx
    mov     rdi, rbx         ;         rdi = rbx;
    mov     rsi, rax         ;         rsi = rax;
    call    maior            ;         rax = max(rdi, rsi);    // rax recebe o maior entre rdi e rsi
    mov     rbx, rax         ;         rbx = rax               // rbx recebe o maior (rax)
    inc     r14              ;         r14++                   // Incrementa contador
    jmp     readgt.loop      ;     } while(true);
.return:
    mov rax, rbx             ;     return rax = rbx;
    ret                      ; }


section .data
    help_msg        db  '- Informe o número 0 para encerrar o programa.', 0
    input_msg       db  'Informe um numero: ', 0
    biggest_msg     db  'Maior valor informado: ', 0