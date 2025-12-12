		name	cas

_TEXT		segment	para public 'CODE'
		assume	cs:_TEXT,ds:nothing,es:nothing,ss:nothing

_start		proc	far

		cli
		xor	ax,ax
		mov	dx,400h
		mov	ss,ax
		mov	sp,dx
		sti

		mov	ax,seg _DATA
		mov	ds,ax
		assume	ds:_DATA

		mov	ax,4
		int	10h

		mov	ax,1301h
		xor	bh,bh
		mov	cx,message_len
		mov	dx,1020h
		push	ds
		pop	es
		assume	es:_DATA
		lea	bp,message
		int	10h

_l1:		hlt
		jmp	_l1

_start		endp

lz4_data:	db	4,22h,4dh,18h,64h,40h,0a7h,0,0,0,0,5,5dh,0cch,2

_TEXT		ends

_DATA		segment	para public '_DATA'

data_offset	proc	near
data_offset	endp

_DATA		ends

CONST		segment	para public 'CONST'

message		db	'hello world',13,10
message_len	equ	$-message

CONST		ends

_BSS		segment	para public 'BSS'
_BSS		ends

STACK		segment	para public 'STACK'

		dw	8 dup (?)
_stack		label	word
_stack_offset	proc	near
_stack_offset	endp

STACK		ends

		end	_start
