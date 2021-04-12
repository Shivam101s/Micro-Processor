section .data

mline db 10d,13d,"no of lines are:"
mlinel equ $-mline

mspace db 10d,13d,"no of spaces are:"
mspacel equ $-mspace

mchar db 10d,13d,"no of charaters are:"
mcharl equ $-mchar

;--------------------------------------------

section .bss

	lcount resq 1
	scount resq 1
	ccount resq 1
	result resb 16
	
global far_procedure
extern filehandle,char,buff,abuff_len
%include "macro.asm"
;--------------------------------------------
section .txt
global _main
_main:


far_procedure:

 	xor rax,rax
	 xor rbx,rbx
	 	xor rcx,rcx
 	xor rsi,rsi
	mov rcx,[abuff_len]
	mov rsi,buff
	mov bl,[char]

again:
	mov al,[rsi]
cnt_s:
	cmp al,20h
	jne cnt_l
	inc qword[scount]
	jmp next

cnt_l:
	cmp al,0Ah
	jne cnt_c
	inc qword[lcount]
	jmp next

cnt_c:
	cmp al,bl
	jne next
	inc qword[ccount]
	
next:inc rsi
dec rcx
jnz again


print mspace,mspacel
mov rbx,[scount]
call hex_to_ascii

print mline,mlinel
mov rbx,[lcount]
call hex_to_ascii

print mchar,mcharl
mov rbx,[ccount]
call hex_to_ascii

fclose [filehandle]

ret

;-----------------------------------------
hex_to_ascii:
	mov rdi,result
	mov rcx,2
disp2:
	rol bl,04
	mov dl,bl
	and dl,0fh
	add dl,30h
	cmp dl,39h
	jbe skip2
	add dl,07h
skip2:
	mov [rdi],dl
	inc rdi
	loop disp2
print result,2
ret
