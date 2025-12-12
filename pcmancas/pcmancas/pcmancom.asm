;	name	pcmancom

; This is a stub loader for a program which makes the following assumptions:
;
; This is a .COM executable (loaded at 100h).
; This code will be exactly 1 paragraph in length.
; Immediately following this is 4,096 bytes of code (256 paragraphs).
; Immediately following that is data.
;
; The code segment has an origin at 0.
; The first 3 bytes of the code will be skipped.

;_TEXT	segment	para public 'CODE'
	org	100h

;_start	proc	far

	mov	ax,cs
	;add	ax,10h
	db	5	; add ax,immediate word
	dw	10h	; ... add ax,10h
	push	ax
	;add	ax,100h
	db	5	; add ax,immediate word
	dw	100h	; ... add ax,10h
	mov	ds,ax
	mov	ax,13h
	push	ax
	retf

;_start	endp

;_TEXT	ends

;	end	_start
