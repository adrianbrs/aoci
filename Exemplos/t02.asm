; long long maior(long long a, long long b)
; {
;     if(a>b) m = a;
;     else m = b;
;     return m;
; }

; long long main()
; {
;     long long n1, n2, m;
;     cin >> n1 >> n2;
; 	  m = maior(n1, n2);
;     cout << m << endl;
; }

%include	'../util.asm'
%include    'funcoes.asm'

section		.text
global		_start

_start:
    call    readint
    mov     rbx, rax   
    call    readint
    mov     rsi, rax 
    mov     rdi, rbx
    call    maior
    mov     rdi, rax
    call    printint
    call    endl
    call    exit


