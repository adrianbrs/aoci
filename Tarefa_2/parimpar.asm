; Adrian Cerbaro
; 178304

%include "util.asm"
%include "funcoes.asm"

section .text
global _start

_start:                             ; int main() {
    xor     r12, r12                ;     r12 = 0;       // Contagem de pares
    xor     r13, r13                ;     r13 = 0;       // Contagem de impares
    mov     rbx, 1                  ;     int rbx = 1;   // Inicializa contador
.loop:                              ;     do {
    cmp     rbx, 10
    jg      _start.end              ;         if(rbx == 0) break;
    mov     rdi, input_msg_prefix
    call    printstr                ;         cout << input_msg_prefix;
    mov     rdi, rbx
    call    printint                ;         cout << rbx;
    mov     rdi, input_msg_suffix
    call    printstr                ;         cout << input_msg_suffix;
    call    readint                 ;         cin >> rax;   // Le um dos 10 valores
    mov     rdi, rax                ;         rdi = rax;
    call    check_parity            ;         check_parity(&rdi, &r12, &r13);
    inc     rbx                     ;         rbx++;
    jmp     _start.loop             ;     } while(true);
.end:
    mov     rdi, even_msg
    call    printstr                ;     cout << even_msg;
    mov     rdi, r12
    call    printint                ;     cout << r12;         // Exibe a quantia de numeros pares
    call    endl                    ;     cout << endl;
    mov     rdi, odd_msg
    call    printstr                ;     cout << odd_msg;
    mov     rdi, r13
    call    printint                ;     cout << r13;         // Exibe a quantia de numeros ímpares
    call    endl                    ;     cout << endl;
    call    exit                    ;     return 0;
                                    ; }

check_parity:                       ; void check_parity(int *rdi, int *r12, int *r13) {
    and     rdi, 0b1                ;     *rdi &= 0b1;
    cmp     rdi, 0                  ;     if(*rdi == 0)
    je      check_parity.inc_even   ;         *r12++; 
    inc     r13                     ;     else *r13++;
    ret                             ; }
.inc_even:
    inc     r12                     ; ... *r12++;
    ret

section .data
    input_msg_prefix   db      'Informe o ', 0          ; string input_msg_prefix = "Informe o ";
    input_msg_suffix   db      'º número: ', 0          ; string input_msg_suffix = "º número: ";
    even_msg           db      'Números pares: ',0      ; string even_msg = "Números pares: ";
    odd_msg            db      'Números ímpares: ',0    ; string odd_msg = "Números ímpares: ";