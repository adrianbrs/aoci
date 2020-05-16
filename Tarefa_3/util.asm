;*********************************************************************
; util.asm 
; Author: Marcos José Brusso
; Version: 1.0.0
; Licensed under the MIT license (see "license.txt"). 
;*********************************************************************

section .text
global	exit, endl, strlen, printstr, readstr, printint, readint, printf	; public symbols

;*********************************************************************
; exit
;
; Quit program
; Arguments: 
;		None
; Returns: 
; 		This function does not return
;*********************************************************************
exit:
        mov		rax, 60                 ; rax: system call number (60=exit)
        xor     rdi, rdi                ; rdi: exit code (0)
        syscall    
;*********************************************************************

;*********************************************************************
; endl
;
; prints a newline character
; Arguments: 
;		None
; Returns: 
;		Nothing
;*********************************************************************
endl:
	mov		rdi, util.endl
	call	printstr
	ret
   
;*********************************************************************

;*********************************************************************
; strlen
;
; Calculates the length of string s
; Arguments:
; 		rdi: address of a null-terminated string (array of chars terminated by 0)
; Returns:
;		rax: string size
;*********************************************************************
strlen:				
		xor		rax, rax			; rax=0			// reset count
.loop:								; do{
		cmp		byte [rdi], 0		;   if (*s==0)	// If zero, skip loop
		je		strlen.end			;     break
		inc		rax					;   rax++ 		// increment count
		inc		rdi					; 	s++ 		// advance to the next char
		jmp		strlen.loop			; }while(true)
.end:
		ret							; return rax
;*********************************************************************


;*********************************************************************
; printstr
;
; Print a string
; Arguments:
; 		rdi: address of a null-terminated string (array of chars terminated by 0)
; Returns: 
;		Nothing
;*********************************************************************
printstr:
		push 	rdi			; save copy (rdi should be caller saved)
		call 	strlen
		mov     rdx, rax	; string size
		pop     rsi		    ; string
        mov		rax, 1		; system call number (1=sys_write)
        mov     rdi, 1      ; file descriptor (1=stdout)       
        syscall				; system call            
		ret
;*********************************************************************


;*********************************************************************
; readstr
;
; Read up to max_size chars from standard input into a string.
; Arguments:
; 		rdi: address of a string (array of chars)
; 		rsi: max_size - limit input size
; Returns:
;		rax: the number of bytes read
;*********************************************************************
readstr:
		mov		r8, rdi				; copy of buffer address
		mov		rax, 0				; system call number (0=sys_read)
		mov 	rdx, rsi			; pointer to buffer
		mov 	rsi, rdi			; max size
		mov 	rdi, 0				; file descriptor (0=stdin)		
		syscall						; system call 
		dec 	rax					; removing trailing newline char
		mov		byte [r8+rax], 0	; replace with '\0'
		ret
;*********************************************************************
	


;*********************************************************************
; printint
;
; Print a integer number (decimal)
; Arguments:
; 		rdi: 	number (n)
; Returns: 
;		Nothing
;*********************************************************************
printint:
		call 	itoa                ; convert number to string
		mov 	rdi, rax
		call 	printstr			; print number
		ret
;*********************************************************************	
	 
	

;*********************************************************************
; readint
;
; Read a int64 from standard input
; Arguments: 
;		None
; Returns:
;		rax: The value entered
;*********************************************************************
readint:
		mov 	rdi, util.temps				; temp string address	
		mov 	rsi, 20						; max input size
		call 	readstr						; read number as string
		lea 	rdi, [rax+util.temps-1]		; char *p = &s[strlen(string)];  //scans string backward
		xor 	rax, rax					; result value
		mov 	rdx, 1						; multiplier
.beginloop:		
		cmp		rdi, util.temps				; while(p>=s){
		jl		readint.end					;
		xor		rcx, rcx					;	
		mov 	cl, byte [rdi] 				; 	 cl = current char
		cmp 	cl, '-'						;	 if(cl=='-')
		jne		readint.notneg				;
		neg		rax							;		rax=-rax
		jmp		readint.end					;
.notneg:					
		cmp		cl, '9'						;	 if(!isdigit(cl)) continue
		jg		readint.endloop				;
		sub		cl, '0'						;
		jl		readint.endloop				;
		imul	rcx, rdx					;	 digit_value = current_char * multiplier
		add		rax, rcx					;	 result += digit_value
		imul	rdx, 10						;	 multiplier *= 10
.endloop:
		dec		rdi							;	 previous char //scans string backward
		jmp		readint.beginloop			; }
.end:		
		ret



;*********************************************************************
; printf
;
; Prints a formated string to stdout
; Arguments: 
;		rdi: The template string
;       rsi: List with arguments
; Returns:
;       Nothing
; Avaialble formats:
;       %d: int64
;       %s: null-terminated string
;*********************************************************************
printf:
	xor 	r8, r8                ; Args counter
	mov		r9, rsi               ; Args pointer

	mov		rsi, util.tmpstr
	call	rplstr
	mov		rdi, rsi
	push	rdi

	lea     rdx, [rdi-1]

.loop:
	inc		rdx
    mov     cl, byte [rdx]
    test	cl, cl
    jz     	.end

	cmp		cl, '%'
	jne		.loop

	mov		cl, byte [rdx+1]
	cmp		cl, 'd'
	jne		.stype

	mov		rdi, [r9]      ;     int value = *rsi
	add		r9, 8                ;     *rsi += 8;
	push	rdx                   ; Backup rdx
	call 	itoa               ;     string str_value = to_string(value);
	pop 	rdx                   ; Restore rdx

	mov 	r12, rax              ; r12 = *itoaValue
	mov		rdi, r12
	call	strlen
	mov		r13, rax              ; r13 = str_value.length

.put:
	lea		rdi, [rdx+2]
	lea		rsi, [r13-2]
	call	shstr

	mov		rdi, r12
	mov		rsi, rdx
	call	cpstr

	lea 	rdx, [rdx+r13-1]
	inc		r8                   ; Increment args counter
	jmp 	.loop

.stype:
	mov		cl, byte [rdx+1]
	cmp		cl, 's'
	jne		.loop

	mov		rdi, r9
	mov		rsi, util.tmpstrval
	call	cpstr

	mov		rdi, util.tmpstrval
	call	strlen
	mov		r13, rax

	mov		r12, util.tmpstrval

	jmp		.put

.end:
	pop 	rdi
	call	printstr
	ret



;*********************************************************************
; rplstr
;
; Replace a null-terminated string
; Arguments: 
;		rdi: Source string pointer
;       rsi: Target string pointer
; Returns:
;       Nothing
;*********************************************************************
rplstr:
	push rdi
	push rsi
.loop:
	mov		cl, byte[rdi]
	mov 	byte[rsi], cl
	test	cl, cl
	jz		.end
	inc 	rdi
	inc		rsi
	jmp 	.loop
.end:
	pop		rsi
	pop		rdi
	ret


;*********************************************************************
; cpstr
;
; Copy a null-terminated string from source to target wihtout null ending char
; Arguments: 
;		rdi: Source string pointer
;       rsi: Target string pointer
; Returns:
;       Nothing
;*********************************************************************
cpstr:
	push rdi
	push rsi
.loop:
	mov		cl, byte[rdi]
	test	cl, cl
	jz		.end
	mov 	byte[rsi], cl
	inc 	rdi
	inc		rsi
	jmp 	.loop
.end:
	pop		rsi
	pop		rdi
	ret



;*********************************************************************
; itoa
;
; Convert int64 to null-terminated string
; Arguments: 
;		rdi: The int64 to convert
; Returns:
;       rax: Pointer to null-terminated converted string
;*********************************************************************
itoa:
		mov		rax, rdi			; rax = n	
		xor 	rcx, rcx			; is_neg = false
		cmp 	rax, 0				;
		jge		itoa.nn  		; if(n<0)	  
		not 	rcx					; 		is_neg = true
		neg 	rax					;     	n = -n
.nn:	
		mov 	r10, 10				; r10 = 10
		mov 	rdi, util.temps+20	; char *p = &s[10]
.loop:								; do{
		xor 	rdx, rdx			;		rdx=0 
		div 	r10					; 		rdx=rdx:rax%10; rax=rdx:rax/10
		add 	dl, '0'				;		decimal digit
		mov 	byte [rdi], dl		;		*p = digit in dl
		dec 	rdi					; 		p--
		cmp 	rax, 0				; 
		jg 		itoa.loop		; }while (n>0)

		test 	rcx, rcx			; if(is_neg)
		jz		itoa.notneg	;   	// Prepend minus sign	
		mov 	byte [rdi], '-'		; 		*p = '-'
		dec 	rdi					;		p--
.notneg:		
		inc 	rdi					; p++
		mov		rax, rdi
		ret



;*********************************************************************
; shstr
;
; Shifts a null-terminated string
; Arguments: 
;		rdi: The length to be shifted (use negative to shift left)
; Returns:
;       Nithing
;*********************************************************************
shstr:
	push 	rbx
	cmp		rsi, 0
	jg		.shiftr
	je		.end

.loop_l:
	mov 	cl, byte [rdi]
	mov		rax, rdi
	add		rax, rsi
	mov		byte [rax], cl
	inc 	rdi
	cmp		cl, 0
	jg		.loop_l
	jmp 	.end

.shiftr:
	push 	rdi
	call 	strlen
	pop		rdi
	lea		rbx, [rax+rdi]
	test 	rax, rax
	jz		.end
.loop_r:
	mov 	cl, byte [rbx]
	mov		byte [rbx+rsi], cl
	mov		byte[rbx], 32
	dec		rbx
	cmp		rbx, rdi
	jge		.loop_r
.end:
	pop 	rbx
	ret


section	.data
    util.temps	db	'000000000000000000000',0    	; char util.temps[]="000000000000000000000"
    util.endl   db 	10,0							; char util.endl[]="\n"

section .bss
	util.tmpstr 	resb 5000
	util.tmpstrval 	resb 5000
