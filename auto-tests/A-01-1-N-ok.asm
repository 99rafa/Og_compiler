; DATA
segment	.data
; ALIGN
align	4
; LABEL ix
ix:
; SINT 0
	dd	0
; TEXT
segment	.text
; ALIGN
align	4
; GLOBAL _main, :function
global	_main:function
; LABEL _main
_main:
; ENTER 4
	push	ebp
	mov	ebp, esp
	sub	esp, 4
; INT 0
	push	dword 0
; DUP32
	push	dword [esp]
; ADDR ix
	push	dword $ix
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; ALIGN
align	4
; LABEL _L1
_L1:
; ADDR ix
	push	dword $ix
; LDINT
	pop	eax
	push	dword [eax]
; INT 10
	push	dword 10
; LT
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setl	cl
	mov	[esp], ecx
; JZ _L3
	pop	eax
	cmp	eax, byte 0
	je	near _L3
; ADDR ix
	push	dword $ix
; LDINT
	pop	eax
	push	dword [eax]
; CALL printi
	call	printi
; TRASH 4
	add	esp, 4
; ALIGN
align	4
; LABEL _L2
_L2:
; ADDR ix
	push	dword $ix
; LDINT
	pop	eax
	push	dword [eax]
; INT 1
	push	dword 1
; ADD
	pop	eax
	add	dword [esp], eax
; DUP32
	push	dword [esp]
; ADDR ix
	push	dword $ix
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; JMP _L1
	jmp	dword _L1
; ALIGN
align	4
; LABEL _L3
_L3:
; INT 0
	push	dword 0
; STFVAL32
	pop	eax
; LEAVE
	leave
; RET
	ret
; LEAVE
	leave
; RET
	ret
; EXTERN printi
extern	printi
