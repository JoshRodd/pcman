  79 00
   6 ff
   1 fc
   1 f0
   1 cf
   1 c0
   1 3f
   1 30
   1 0f
   1 03

 533 00
 475 ff
  71 03
  38 cf
  35 fc
  27 c0
  21 3f
  21 0f
  20 f0
   1 30

low 4 bits:
0xxx: 08: 00 - low 3 bits # of times to repeat (0 - 6)
0111: 09: ff - repeat 3 times
1000: 08: 03
1001: 09: 0f
1010: 0a: f0
1011: 0b: 3f
1100: 0c: c0
1101: 0d: cf
1110: 0e: fc
1111: 0f: ff

Note: repeats must emit in even 9 byte chunks.
A 0 must be used to indicate the end of the 9 byte
chunk. If you would encode a 0 in the low nibble,
encode a 0 in the high nibble too.

Call function to emit 9 bytes with compressed data
in DS:SI and destination in ES:DI.

Encodings of a 0 won't actually emit anything and
will just advance DI.

		push	dx
		push	bx

		; Allow ourselves the flexibility to add DX or AX to DI
		xor	ah,ah
		xor	dh,dh

		; Use XLATB with BX as base. Offset everything by 8 to save
		; us the trouble of AND'ing off bit 3
		mov	bx,offset xlat_table-8

		jmp	next_byte

xlat_table:	db	3,0fh,f0h,3fh,0c0h,0cfh,0fch,0ffh
		jmp	done_zero_low

3x_ff_low:	mov	al,0ffh
		stosb
		stosb
		stosb
		jmp	done_zero_low

3x_ff_high:	mov	al,0ffh
		stosb
		stosb
		stosb
		jmp	next_byte

not_zero_low:	xlatb	; Equivalent to MOV AL,[BX+AL]
		stosb

not_zero_high:	mov	al,dl
		xlatb
		stosb

next_byte:	lodsb
		mov	dl,al
		and	al,0fh
		test	al,8
		jnz	not_zero_low
		cmp	al,7
		jz	3x_ff_low
		add	di,ax
done_zero_low:	shr	dl,1
		shr	dl,1
		shr	dl,1
		shr	dl,1
		test	dl,8
		jnz	not_zero_high
		cmp	al,7
		jz	3x_ff_high
		add	di,dx
		or	dl,dl
		jnz	next_byte
		pop	bx
		pop	dx
		;ret

