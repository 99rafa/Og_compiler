; BSS
segment	.bss
; ALIGN
align	4
; LABEL x
x:
; SALLOC 4
	resb	4
; BSS
segment	.bss
; ALIGN
align	4
; LABEL y
y:
; SALLOC 4
	resb	4
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
; INT 1
	push	dword 1
; DUP32
	push	dword [esp]
; ADDR y
	push	dword $y
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; ALIGN
align	4
; LABEL _L1
_L1:
; ADDR y
	push	dword $y
; LDINT
	pop	eax
	push	dword [eax]
; INT 3
	push	dword 3
; LE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setle	cl
	mov	[esp], ecx
; JZ _L3
	pop	eax
	cmp	eax, byte 0
	je	near _L3
; INT 1
	push	dword 1
; DUP32
	push	dword [esp]
; ADDR x
	push	dword $x
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; ALIGN
align	4
; LABEL _L4
_L4:
; ADDR x
	push	dword $x
; LDINT
	pop	eax
	push	dword [eax]
; INT 6
	push	dword 6
; LE
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	setle	cl
	mov	[esp], ecx
; JZ _L6
	pop	eax
	cmp	eax, byte 0
	je	near _L6
; ADDR x
	push	dword $x
; LDINT
	pop	eax
	push	dword [eax]
; INT 2
	push	dword 2
; MOD
	pop	ecx
	pop	eax
	cdq
	idiv	ecx
	push	edx
; INT 1
	push	dword 1
; EQ
	pop	eax
	xor	ecx, ecx
	cmp	[esp], eax
	sete	cl
	mov	[esp], ecx
; JZ _L7
	pop	eax
	cmp	eax, byte 0
	je	near _L7
; JMP _L5
	jmp	dword _L5
; JMP _L8
	jmp	dword _L8
; LABEL _L7
_L7:
; ADDR x
	push	dword $x
; LDINT
	pop	eax
	push	dword [eax]
; CALL printi
	call	printi
; TRASH 4
	add	esp, 4
; LABEL _L8
_L8:
; ALIGN
align	4
; LABEL _L5
_L5:
; ADDR x
	push	dword $x
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
; ADDR x
	push	dword $x
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; JMP _L4
	jmp	dword _L4
; ALIGN
align	4
; LABEL _L6
_L6:
; ALIGN
align	4
; LABEL _L2
_L2:
; ADDR y
	push	dword $y
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
; ADDR y
	push	dword $y
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
