; TEXT
segment	.text
; ALIGN
align	4
; LABEL f
f:
; ENTER 4
	push	ebp
	mov	ebp, esp
	sub	esp, 4
; LOCAL 8
	lea	eax, [ebp+8]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; JZ _L1
	pop	eax
	cmp	eax, byte 0
	je	near _L1
; LOCAL 12
	lea	eax, [ebp+12]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; DUP32
	push	dword [esp]
; INT 5
	push	dword 5
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
; DOUBLE 61.0000
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL _L1_cdk_emitter_internal
_L1_cdk_emitter_internal:
; SDOUBLE 61.0000
	dq	61.0000
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
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL _L2
_L2:
; SSTRING (value omitted -- see below)
	db	"string1", 0
; TEXT
segment	.text
; ADDR _L2
	push	dword $_L2
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
; LEAVE
	leave
; RET
	ret
; JMP _L3
	jmp	dword _L3
; LABEL _L1
_L1:
; LOCAL 12
	lea	eax, [ebp+12]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; DUP32
	push	dword [esp]
; INT 6
	push	dword 6
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
; DOUBLE 62.0000
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL _L2_cdk_emitter_internal
_L2_cdk_emitter_internal:
; SDOUBLE 62.0000
	dq	62.0000
; TEXT
segment	.text
; ADDR _L2_cdk_emitter_internal
	push	dword $_L2_cdk_emitter_internal
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
; RODATA
segment	.rodata
; ALIGN
align	4
; LABEL _L4
_L4:
; SSTRING (value omitted -- see below)
	db	"string2", 0
; TEXT
segment	.text
; ADDR _L4
	push	dword $_L4
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
; LEAVE
	leave
; RET
	ret
; LABEL _L3
_L3:
; LEAVE
	leave
; RET
	ret
; TEXT
segment	.text
; ALIGN
align	4
; GLOBAL _main, :function
global	_main:function
; LABEL _main
_main:
; ENTER 20
	push	ebp
	mov	ebp, esp
	sub	esp, 20
; INT 16
	push	dword 16
; ALLOC
	pop	eax
	sub	esp, eax
; SP
	push	esp
; INT 1
	push	dword 1
; CALL f
	call	f
; TRASH 4
	add	esp, 4
; DUP32
	push	dword [esp]
; INT 0
	push	dword 0
; ADD
	pop	eax
	add	dword [esp], eax
; LDINT
	pop	eax
	push	dword [eax]
; LOCAL -8
	lea	eax, [ebp+-8]
	push	eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; DUP32
	push	dword [esp]
; INT 4
	push	dword 4
; ADD
	pop	eax
	add	dword [esp], eax
; LDDOUBLE
	pop	eax
	push	dword [eax+4]
	push	dword [eax]
; LOCAL -16
	lea	eax, [ebp+-16]
	push	eax
; DSTORE
	pop	ecx
	pop	eax
	mov	[ecx], eax
	pop	eax
	mov	[ecx+4], eax
; DUP32
	push	dword [esp]
; INT 12
	push	dword 12
; ADD
	pop	eax
	add	dword [esp], eax
; LDINT
	pop	eax
	push	dword [eax]
; LOCAL -20
	lea	eax, [ebp+-20]
	push	eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; TRASH 4
	add	esp, 4
; LOCAL -8
	lea	eax, [ebp+-8]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; CALL printi
	call	printi
; TRASH 4
	add	esp, 4
; LOCAL -16
	lea	eax, [ebp+-16]
	push	eax
; LDDOUBLE
	pop	eax
	push	dword [eax+4]
	push	dword [eax]
; CALL printd
	call	printd
; TRASH 8
	add	esp, 8
; LOCAL -20
	lea	eax, [ebp+-20]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; CALL prints
	call	prints
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
; EXTERN printd
extern	printd
; EXTERN printi
extern	printi
; EXTERN prints
extern	prints
