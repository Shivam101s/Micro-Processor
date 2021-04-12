%include	"macro.asm"

section .data
	nline		db	10
	nline_len	equ	$-nline


	filemsg	db	10,"Enter filename of input data	: "
	filemsg_len	equ	$-filemsg	

	omsg		db	10,"Sorting using bubble sort Operation successful."
			db	10,"Output stored in same file...",10,10
	omsg_len	equ	$-omsg
  
	errmsg	db	10,"ERROR in opening/reading/writing File...",10
	errmsg_len	equ	$-errmsg

	ermsg		db	10,"ERROR in writing File...",10
	ermsg_len	equ	$-ermsg

	exitmsg	db	10,10,"Exit from program...",10,10
	exitmsg_len	equ	$-exitmsg


section .bss
	buf			resb	1024
	buf_len		equ	$-buf		

	filename		resb	50	

	filehandle		resq	1
	abuf_len		resq	1		

	array			resb	10
	n			resq	1

section .text
	global _start
		
_start:				

		print	filemsg,filemsg_len		
		read 	filename,50
		dec	rax
		mov	byte[filename + rax],0		

		fopen	filename				
		cmp	rax,-1H				
		je	Error
		mov	[filehandle],rax	

		fread	[filehandle],buf, buf_len
		dec	rax					
		mov	[abuf_len],rax

		call	bsort
		jmp	Exit

Error:	print	errmsg, errmsg_len

Exit:		print	exitmsg,exitmsg_len
		exit
 
bsort:							
		call	buf_array

		xor	rax,rax
		mov	rbp,[n]
		dec	rbp

		xor	rcx,rcx
		xor	rdx,rdx
		xor	rsi,rsi
		xor	rdi,rdi

		mov	rcx,0				

oloop:	mov	rbx,0				

		mov	rsi,array			

iloop:	mov	rdi,rsi			
		inc	rdi

		mov	al,[rsi]
		cmp	al,[rdi]
		jbe	next

		mov	dl,0
		mov	dl,[rdi]			
		mov	[rdi],al
		mov	[rsi],dl

next:		inc	rsi
		inc	rbx				
		cmp	rbx,rbp
		jb	iloop
		
		inc	rcx
		cmp	rcx,rbp
		jb	oloop

	fwrite	[filehandle],omsg, omsg_len
	fwrite	[filehandle],array,[n]

	fclose [filehandle]	

	print	omsg, omsg_len
	print	array,[n]	

	RET

Error1:
	print	ermsg, ermsg_len
	RET

buf_array:
	xor	rcx,rcx
	xor	rsi,rsi
	xor	rdi,rdi

	mov	rcx,[abuf_len]
	mov	rsi,buf
	mov	rdi,array

next_num:
	mov	al,[rsi]
	mov	[rdi],al

	inc	rsi		
	inc	rsi		
	inc	rdi

	inc	byte[n]	; counter
	
	dec	rcx		
	dec	rcx		
	jnz	next_num
ret

