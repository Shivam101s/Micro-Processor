section .text
 
	rec_fact:
	mov bl,byte[no]
	cmp bl,1
	jle recstop
 
	sub byte[no],1
	call rec_fact
	 
	add byte[no],1
	mov bl,byte[no]
	movzx ebx,bl
	 
	mov rax,rcx
	mul ebx
	mov rcx,rax
	jmp exit
 
recstop:
	mov rcx,1
 
exit:
	ret 
	input:
	mov ax,3
	mov rbx,0
	int 0x80
 
	mov rcx,garbage
	mov rdx,1
	mov rax,3
	mov rbx,0
	int 0x80
	ret
 
output:
	mov rax,4
	mov rbx,1
	int 0x80
	ret
	 
convert:
	sub cl,30h
	sub ch,30h
	mov al,cl
	mov bl,10
	mul bl
	add al,ch
	ret
	 
global _start
_start: 
	mov rcx,inputn
	mov rdx,linputn
	call output	 
	mov rcx,temp
	mov rdx,2
	call input
	 
	mov cx,word[temp]
	call convert
	mov byte[no],al
	 
	mov rax,1
	mov rbx,0
	call rec_fact
	mov rax,rcx
	 
	push 29h
	mov ebx,10
break:
	mov rdx,0
	idiv ebx
	push dx
	cmp rax,0
	jnle break
 
	mov rcx,outmsg
	mov rdx,loutmsg
	mov rax,4
	mov rbx,1
	int 0x80
	 
	mov rdx,0
	pop dx	 
print:
	add dl,30h
	mov byte[printdata],dl 
	mov rcx,printdata
	mov rdx,1
	call output 
	pop dx
	cmp edx,29h
	jne print
	 
	mov rcx,newline
	mov rdx,1
	call output
	 
	mov rax,1
	mov rbx,0
	int 0x80
	 
section .bss
	printdata resb 1
	garbage resb 1
	temp resw 1
	no resb 1
 
section .data
	inputn db "INPUT THE NO.(0single_digit) : ",0
	linputn equ $-inputn
	outmsg db "FACTORIAL = ",32
	loutmsg equ $-outmsg
	newline db 10
