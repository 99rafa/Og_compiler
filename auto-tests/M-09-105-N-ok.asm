; TEXT
segment	.text
; ALIGN
align	4
; GLOBAL _main, :function
global	_main:function
; LABEL _main
_main:
; ENTER 12
	push	ebp
	mov	ebp, esp
	sub	esp, 12
; INT 16
	push	dword 16
; ALLOC
	pop	eax
	sub	esp, eax
; SP
	push	esp
; DUP32
	push	dword [esp]
; INT 1
	push	dword 1
; SWAP32
	pop	eax
	pop	ecx
	push	eax
	push	ecx
; INT 0
	push	dword 0
; ADD
	pop	eax
	add	dword [esp], eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; DUP32
	push	dword [esp]
; DUP32
	push	dword [esp]
; DOUBLE 3.00000
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL _L1_cdk_emitter_internal
_L1_cdk_emitter_internal:
; SDOUBLE 3.00000
	dq	3.00000
; TEXT
segment	.text
; ADDR _L1_cdk_emitter_internal
	push	dword $_L1_cdk_emitter_internal
; LDDOUBLE
	pop	eax
	push	dword [eax+4]
	push	dword [eax]
; SWAP64
	pop	eax
	pop	ebx
	pop	ecx
	pop	edx
	push	ebx
	push	eax
	push	edx
	push	ecx
; TRASH 4
	add	esp, 4
; INT 4
	push	dword 4
; ADD
	pop	eax
	add	dword [esp], eax
; DSTORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
	pop	eax
	mov	[ecx+4], eax
; DUP32
	push	dword [esp]
; LOCAL -8
	lea	eax, [ebp+-8]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; SWAP32
	pop	eax
	pop	ecx
	push	eax
	push	ecx
; INT 12
	push	dword 12
; ADD
	pop	eax
	add	dword [esp], eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; LOCAL -12
	lea	eax, [ebp+-12]
	push	eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; INT 16
	push	dword 16
; CALL printi
	call	printi
; TRASH 4
	add	esp, 4
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
