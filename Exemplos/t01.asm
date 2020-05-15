; programa C++ equivalente:
; int main()
; {
;     int n1, n2, m;
;     cin >> n1 >> n2;
;     if(n1>n2) m = n1;
;     else m = n2;
;     cout << m << endl;
; }

%include	'../util.asm'
section		.text
global		_start

_start:
    call    readint
    mov     rbx, rax    ; RBX=N1
    call    readint
    mov     r14, rax    ; R14=N2
    cmp     rbx, r14
    jl      else
    mov     r12, rbx    ; r12=M
    jmp     fim
else:
    mov     r12, r14
fim:
    mov     rdi, r12
    call    printint
    call    endl
    call    exit


