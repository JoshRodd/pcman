

		mov	si,[font_tbl_1_ptr]
		mov	ax,[si]
		cmp	al,-1
		je	font_done
		dec	ah
		mov	byte ptr [si+1],ah
		or	ah,ah
		jnz	font_repeated
		mov	si,2
		add	word ptr [font_tbl_1_ptr],si
font_repeated:	mov	si,font_tbl_2
		xor	ah,ah
		add	si,ax
		stosw
		stosw
		stosw
		stosw
		stosb
font_done:

font_tbl_1_ptr:	dw	offset font_tbl_1

; Consists of index into table 2 and # of repeats
font_tbl_1:
		db	40,1
		db	36,1
		db	32,1
		db	17,2
		db	8,2
		db	0,4
		db	8,2
		db	10,1
		db	11,2
		db	26,1
		db	28,1
		db	6,5
		db	24,1
		db	22,1
		db	19,1
		db	12,1
		db	5,2
		db	7,1
		db	16,1
		db	4,3
		db	25,1
		db	4,3
		db	16,1
		db	7,1
		db	5,2
		db	12,1
		db	19,1
		db	22,1
		db	24,1
		db	1,7
		db	3,8
		db	1,8
		db	41,1
		db	23,2
		db	39,1
		db	37,1
		db	21,2
		db	35,1
		db	20,2
		db	33,1
		db	12,1
		db	5,2
		db	7,2
		db	9,3
		db	14,2
		db	13,2
		db	42,1
		db	38,1
		db	34,1
		db	18,2
		db	30,1
		db	31,1
		db	0,4
		db	2,6
		db	0,6
		db	29,1
		db	27,1
		db	11,1
		db	10,2
		db	15,2
		db	2,4
		db	0,12
		db	-1,-1
; 9-byte rows
font_tbl_2:
		db	003h,0ffh,0ffh,0cfh,0ffh,0ffh,000h,000h,000h
		db	000h,000h,000h,000h,000h,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,000h
		db	0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h
		db	00fh,0ffh,0ffh,0ffh,03fh,0ffh,0ffh,0fch,000h
		db	000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,000h
		db	003h,0ffh,0ffh,0c0h,000h,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,000h
		db	003h,0ffh,0ffh,0cfh,0ffh,0fch,000h,000h,000h
		db	00fh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0fch,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h
		db	000h,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h
		db	0ffh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0ffh,0c0h
		db	03fh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0ffh,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,03fh,0ffh,0ffh,0f0h,000h
		db	000h,0ffh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h
		db	000h,03fh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h
		db	000h,00fh,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h
		db	000h,00fh,0ffh,0fch,00fh,0ffh,0fch,000h,000h
		db	000h,003h,0ffh,0c0h,000h,0ffh,0f0h,000h,000h
		db	000h,000h,0ffh,0ffh,0ffh,0ffh,0c0h,000h,000h
		db	000h,000h,0fch,000h,000h,00fh,0c0h,000h,000h
		db	000h,000h,003h,0ffh,0ffh,0f0h,000h,000h,000h
		db	00fh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0fch,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,0c0h,000h,000h,000h,000h
		db	003h,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h
		db	000h,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,000h
		db	000h,0ffh,0ffh,0cfh,0ffh,0fch,000h,000h,000h
		db	000h,03fh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h
		db	000h,03fh,0ffh,0ffh,03fh,0ffh,0ffh,000h,000h
		db	000h,00fh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h
		db	000h,00fh,0ffh,0f0h,003h,0ffh,0fch,000h,000h
		db	000h,003h,0ffh,0ffh,0ffh,000h,000h,000h,000h
		db	000h,003h,0ffh,000h,000h,03fh,0f0h,000h,000h
		db	000h,000h,0ffh,0ffh,0fch,000h,000h,000h,000h
		db	000h,000h,0ffh,000h,000h,03fh,0c0h,000h,000h
		db	000h,000h,03fh,0ffh,0f0h,000h,000h,000h,000h
		db	000h,000h,030h,000h,000h,003h,000h,000h,000h
		db	000h,000h,00fh,0ffh,0c0h,000h,000h,000h,000h
