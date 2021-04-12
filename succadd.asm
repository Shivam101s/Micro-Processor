 
        %macro dispmsg 2              
	   mov rax,1                  
	   mov rdi,1                  
	   mov rsi,%1                 
	   mov rdx,%2                 
	   syscall                    
	%endmacro                     

	%macro exitprog 0             
	 mov rax,60                   
	 mov rdx,0                                
	 syscall                      
	%endmacro                     

	%macro gtch 1                 
	   mov rax,0                  
	   mov rdi,0                  
	   mov rsi,%1                 
	   mov rdx,1                  
	   syscall                    
	%endmacro                    
 
	section .data 
	nwline db 10 
	m0 db 10,10,"Program to multiply two numbers using successive addition and add-and-shift method" 
	l0 equ $-m0 
	m1 db 10,"1. Successive Addition method",10,"2. Add-and-Shift method",10,"3. Exit",10,10, "Enter your choice (1/2/3 <ENTER>): " 
	l1 equ $-m1 
	m2 db 10,"Enter multiplicand (2 digit HEX no) : " 
	l2 equ $-m2 
	m3 db 10,"Enter multiplier (2 digit HEX no) : " 
	l3 equ $-m3 
	m4 db 10,"The Multiplication is : " 
	l4 equ $-m4 
 
	section .bss 
	mcand   resq 1               
	mplier  resq 1               
	input   resb 1               
	output  resb 1               
	choice  resb 1               
 
	section .text 
	global _start                
	_start : 

	dispmsg m0,l0                

	back: 
	dispmsg m1,l1  	             
	gtch input                   

	mov al, byte[input]    	     
	mov byte[choice],al 

	gtch input 		     

	mov al, byte[choice] 

	cmp al, '1'                 
	je succ_add                  

	cmp al, '2'                  
	je shft_add                  

	cmp al, '3'                  
	jnz back                    
	exitprog                     
 
	; SUCCESSIVE ADDITION 
        succ_add:                    
	dispmsg m2,l2                
	call getnum                  
	mov [mcand],rax              
	gtch input                   

	dispmsg m3,l3                
	call getnum                   
	mov [mplier],rax             
	gtch input                   
	dispmsg m4,l4                

	mov rax,0                    
	cmp qword[mplier],0          
	jz ll5                      
 
	ll1:                         
	add rax,qword[mcand]         
	dec qword[mplier]            
	jnz ll1                      
 
	ll5:                           
	call disphx16   	     
	jmp back                     
 
	; ADD & SHIFT 
	shft_add:                    
	dispmsg m2,l2    	     
	call getnum                  
	mov [mcand],rax    	     
	gtch input 		     

	dispmsg m3,l3    	     
	call getnum                  
	mov [mplier],rax             
	gtch input 		     

	mov rax,0                    
	dispmsg m4,l4                

	mov rax,0                    
	mov rcx,8                    
	mov rdx,qword[mplier] 	     
	mov rbx,qword[mcand] 	     

	                             
	                             

        mov ah,0                     
	mov al,dl                    
 
	ll3:                        
	mov dh,al                    
	and dh,1                    
	jz ll8                       
	add ah, bl                   
                                     
 
	ll8:                         
	shr ax,1                     
	dec rcx                      
	jnz ll3                      
	call disphx16               
	jmp back                     
 
	getnum:                      
                                     
	mov cx,0204h                 
	mov rbx,0                    
 
	ll2:                         
	push rcx	             
	gtch input                   
	pop rcx                      
	 
        mov rax,0                              
	mov al,byte[input]           
	sub rax,30h                 
	cmp rax,09h                  
	jbe skip1                   
	sub rax,7                    
	 
        skip1:                      
	shl rbx,cl                   
	add rbx,rax                 
	dec ch                       
	jnz ll2                      
	mov rax,rbx                  
	ret                          
 
	disphx16:                    
	mov rbx,rax                  
	mov cx,1004h		     
 
	ll6:                       
	rol rbx,cl                  
	mov rdx,rbx                  
	and rdx,0fh                  
	add rdx,30h                  
	cmp rdx,039h                 
	jbe skip4                   
	add rdx,7                    
 
	skip4:                       
	mov byte[output],dl          
	push rcx                     
	dispmsg output,1             
	pop rcx                      
	dec ch                       
	jnz ll6                      
	ret                         

