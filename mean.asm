



%macro print 2
mov rax, 01
mov rdi, 01
mov rsi, %1
mov rdx, %2
syscall
%endmacro



section .data

m0 db 10,13,"80387 Coprocessor to calculate Mean, Variance and Standard Deviation",10
l0 equ $-m0

m1 db 10,13,"Array Elements: 102.59, 198.21, 100.67",10
l1 equ $-m1

m2 db 10,13,"Mean :"
l2 equ $-m2

m3 db 10,13,"Variance :"
l3 equ $-m3

m4 db 10,13,"Standard Deviation :"
l4 equ $-m4

newline db 0xa

num1 dd 102.59
num2 dd 198.21
num3 dd 100.67

num4 dd 03.00

dpoint db "."

hdec dq 100


section .bss

dispbuff resb 1

resbuff resb 10

mean resd 1

variance resd 1


section .text
global _start
_start:


print m0,l0

print m1,l1

finit
fldz

;MEAN


fld dword[num1]	
fld dword[num2]	

fadd st0,st1	

fld dword[num3]	

fadd st0,st1		

fdiv dword[num4]  

fst dword[mean]		
 
print m2,l2

call disp_result

print newline,01

;Variance = (num - mean)^2

mov rsi,num1
call cal_diff_sqr

mov rsi,num2
call cal_diff_sqr

fadd st0,st1		

mov rsi,num3
call cal_diff_sqr

fadd st0,st1		

fdiv dword[num4]	

fst dword[variance]	

print m3,l3
call disp_result

print newline,01

;Standard Deviation

fld dword[variance]
fsqrt

print m4,l4
call disp_result

print newline,01



mov rax,60
xor rdi,rdi
syscall



disp_result:
	fimul dword[hdec]
	fbstp [resbuff]		

	mov rcx,00
	mov rcx,09h
	mov rsi,resbuff+09	


up2:
	push rcx
	push rsi

	mov bl,[rsi]
	call disp8_proc

	print dispbuff,02

	pop rsi
	dec rsi
	pop rcx
	loop up2

	print dpoint,01

	mov bl,[resbuff]
	call disp8_proc

    print dispbuff,02

ret



disp8_proc:

mov rdi,dispbuff
mov rcx,02

back:
rol bl,04
mov dl,bl
and dl,0Fh
cmp dl,09h
jbe skip
add dl,07h



skip:
add dl,30h

mov [rdi],dl
inc rdi
loop back

ret




cal_diff_sqr:

fld dword[rsi]
fsub dword[mean]
fmul st0,st0
ret





