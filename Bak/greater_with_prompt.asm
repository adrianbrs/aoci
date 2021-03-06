; Adrian Cerbaro
; 178304

%include "./util.asm"

; Seção de instruções
section .text
global _start

; Entry point da aplicação
_start:
    mov rdi, promptN1     ; Carrega a msg prompt do primeiro valor
    call printstr         ; Exibe a msg
    call readint          ; Lê o primeiro inteiro
    mov [n1], rax         ; Move o inteiro lido para [n1]
    mov rdi, promptN2     ; Carrega a msg prompt do segundo valor
    call printstr         ; Exibe a msg
    call readint          ; Lê o segundo inteiro
    mov [n2], rax         ; Move o segundo inteiro lido para [n2]
    cmp [n1], rax         ; Compara [n1] com [n2]
    jg _greater           ; Pula para _greater se [n1] for maior que [n2]
    mov r8, n2            ; Senão... Move o endereço de [n2] para rdi (parâmetro para posterior chamada ao printint)
    jmp _done             ; Pula para o fim da execução do programa

; É chamado se o primeiro valor lido for maior que o segundo (n1 > n2)
_greater:
    mov r8, n1         ; Move [n1] para rdi (parametro para posterior chamada ao printint)
    jmp _done             ; Pula para o fim da execução do programa

; Exibe o resultado do maior (presente em rdi) e termina a execução
_done:
    call endl
    mov rdi, msgMaior
    call printstr
    mov rdi, [r8]
    call printint         ; Chama a função printint para exibir o maior numero
    call endl             ; Chama a função endl para exibir uma linha em branco
    call exit             ; Chama a função exit para terminar a execução do programa

; Seção de dados
section .data
n1: dq  0                 ; Inteiro de 64 bits
n2: dq  0                 ; Inteiro de 64 bits
promptN1: db 'Informe o primeiro número: ', 0
promptN2: db 'Informe o segundo número: ', 0
msgMaior: db 'O maior número é: ', 0