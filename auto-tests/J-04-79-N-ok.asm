; TEXT
segment	.text
; ALIGN
align	4
; GLOBAL f, :function
global	f:function
; LABEL f
f:
; ENTER 4
	push	ebp
	mov	ebp, esp
	sub	esp, 4
; INT 3
	push	dword 3
; LOCAL -4
	lea	eax, [ebp+-4]
	push	eax
; STINT
	pop	ecx
	pop	eax
	mov	[ecx], eax
; LOCAL -4
	lea	eax, [ebp+-4]
	push	eax
; LDINT
	pop	eax
	push	dword [eax]
; CALL printi
	call	printi
; TRASH 4
	add	esp, 4
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
; ENTER 4
	push	ebp
	mov	ebp, esp
	sub	esp, 4
; CALL f
	call	f
; LDFVAL32
	push	eax
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
