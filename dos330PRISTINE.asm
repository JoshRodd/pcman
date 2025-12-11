		name	dos330

_IBMBIO_COM_SEG	segment	at 70h
		org	0
_ibmbio_com	proc	far
_ibmbio_com	endp
_IBMBIO_COM_SEG	ends

_BOOTSECT	segment	para public 'CODE'
		assume	cs:_BOOTSECT,ds:nothing,es:nothing,ss:nothing

		org	1eh*4
_int_1eh_v	label	dword

		org	7c00h

_bootstrap	proc	near
		jmp	_bootmain	; 07c00 EB34
		nop			; 07c02 90
_bootstrap	endp

system_id		db	"IBM  3.3"	; 07c03 9049424D2020332E33
bytes_per_sector	dw	512		; 07c0b 0002
sectors_per_cluster	db	1		; 07c0d 01
reserved_sector_cnt	dw	1		; 07c0e 0100
fat_copy_cnt		db	2		; 07c10 02  
root_dir_entries	dw	64		; 07c11 4000
disk_sector_cnt		dw	320		; 07c13 4001
format_id		db	0feh		; 07c15 FE
sectors_per_fat		dw	1		; 07c16 0100 
sectors_per_track	dw	8		; 07c18 0800
heads			dw	1		; 07c1a 0100
special_reserved_sector_cnt dw	0		; 07c1c 0000
dx_disk_head		label	word
dl_disk			db	0	; A:	; 07c1e 00
dh_head			db	0		; 07c1f 00
			db	11 dup (0)	; 07c20 00 X0B
b7c2b			dw	0		; 07c2b 0000
b7c2d			db	0		; 07c2d 00
b7c2e			db	0		; 07c2e 00
b7c2f			db	12h		; 07c2f 12
			dw	2 dup (0)	; 07c30 00000000
b7c34			dw	1		; 07c34 01

_bootmain	proc	near

b7c36:		cli			; 07c36 FA
b7c37:		xor	ax,ax		; 07c37 33C0
b7c39:		mov	ss,ax		; 07c39 8ED0
		assume	ss:_BOOTSECT
b7c3b:		mov	sp,7c00h		; 07c3b BC007C
b7c3e:		push	ss		; 07c3e 16
b7c3f:		pop	es		; 07c3f 07
		assume	es:_BOOTSECT
b7c40:		mov	bx,offset _int_1eh_v		; 07c40 BB7800
b7c43:		lds	si,dword ptr ss:[bx]		; 07c43 36C537
b7c46:		push	ds		; 07c46 1E
b7c47:		push	si		; 07c47 56
b7c48:		push	ss		; 07c48 16
b7c49:		push	bx		; 07c49 53
b7c4a:		mov	di,7c2bh		; 07c4a BF2B7C
b7c4d:		mov	cx,0bh		; 07c4d B90B00
b7c50:		cld			; 07c50 FC
b7c51:		lodsb			; 07c51 AC
b7c52:		cmp	byte ptr es:[di],0		; 07c52 26803D00
b7c56:		jz	b7c5b		; 07c56 7403
b7c58:		mov	al,es:[di]		; 07c58 268A05
b7c5b:		stosb			; 07c5b AA
b7c5c:		mov	al,ah		; 07c5c 8AC4
b7c5e:		loop	b7c51		; 07c5e E2F1
b7c60:		push	es		; 07c60 06
b7c61:		pop	ds		; 07c61 1F
		assume	ds:_BOOTSECT
b7c62:		mov	[bx+2],ax		; 07c62 894702
b7c65:		mov	word ptr [bx],7c2bh		; 07c65 C7072B7C
b7c69:		sti			; 07c69 FB
b7c6a:		int	13h		; 07c6a CD13
b7c6c:		jc	print_fail		; 07c6c 7267
b7c6e:		mov	al,fat_copy_cnt		; 07c6e A0107C
b7c71:		cbw			; 07c71 98
b7c72:		mul	sectors_per_fat		; 07c72 F726167C
b7c76:		add	ax,special_reserved_sector_cnt		; 07c76 03061C7C
b7c7a:		add	ax,reserved_sector_cnt	; 07c7a 03060E7C
b7c7e:		mov	[7c3fh],ax		; 07c7e A33F7C
b7c81:		mov	[7c37h],ax		; 07c81 A3377C
b7c84:		mov	ax,20h		; 07c84 B82000
b7c87:		mul	word ptr root_dir_entries		; 07c87 F726117C
b7c8b:		mov	bx,bytes_per_sector		; 07c8b 8B1E0B7C
b7c8f:		add	ax,bx		; 07c8f 03C3
b7c91:		dec	ax		; 07c91 48
b7c92:		div	bx		; 07c92 F7F3
b7c94:		add	[7c37h],ax		; 07c94 0106377C
b7c98:		mov	bx,500h		; 07c98 BB0005
b7c9b:		mov	ax,[7c3fh]		; 07c9b A13F7C
b7c9e:		call	compute_chs		; 07c9e E89F00
b7ca1:		mov	ax,201h		; 07ca1 B80102
b7ca4:		call	load_sectors		; 07ca4 E8B300
b7ca7:		jc	files_missing	; 07ca7 7219
b7ca9:		mov	di,bx		; 07ca9 8BFB
b7cab:		mov	cx,0bh		; 07cab B90B00
b7cae:		mov	si,offset ibmbio_str		; 07cae BED67D
b7cb1:		repe	cmpsb		; 07cb1 F3A6
b7cb3:		jnz	files_missing		; 07cb3 750D
b7cb5:		lea	di,[bx+20h]		; 07cb5 8D7F20
b7cb8:		mov	si,offset ibmdos_str		; 07cb8 BEE17D
b7cbb:		mov	cx,0bh		; 07cbb B90B00
b7cbe:		repe	cmpsb		; 07cbe F3A6
b7cc0:		jz	files_found		; 07cc0 7418
files_missing:	mov	si,offset non_sys_disk		; 07cc2 BE777D
jmp_print_msg:	call	print_msg	; 07cc5 E86A00
b7cc8:		xor	ah,ah		; 07cc8 32E4
b7cca:		int	16h		; 07cca CD16
b7ccc:		pop	si		; 07ccc 5E
b7ccd:		pop	ds		; 07ccd 1F
		assume	ds:_BOOTSECT
b7cce:		pop	word ptr [si]		; 07cce 8F04
b7cd0:		pop	word ptr [si+2]		; 07cd0 8F4402
b7cd3:		int	19h		; 07cd3 CD19
print_fail:	mov	si,offset disk_boot_fail		; 07cd5 BEC07D
b7cd8:		jmp	jmp_print_msg		; 07cd8 EBEB
files_found:	mov	ax,[51ch]		; 07cda A11C05
b7cdd:		xor	dx,dx		; 07cdd 33D2
b7cdf:		div	word ptr bytes_per_sector		; 07cdf F7360B7C
b7ce3:		inc	al		; 07ce3 FEC0
b7ce5:		mov	[7c3ch],al		; 07ce5 A23C7C
b7ce8:		mov	ax,[7c37h]		; 07ce8 A1377C
b7ceb:		mov	[7c3dh],ax		; 07ceb A33D7C
b7cee:		mov	bx,700h		; 07cee BB0007

read_loop:	mov	ax,[7c37h]		; 07cf1 A1377C
b7cf4:		call	compute_chs		; 07cf4 E84900
b7cf7:		mov	ax,sectors_per_track		; 07cf7 A1187C
b7cfa:		sub	al,[7c3bh]		; 07cfa 2A063B7C
b7cfe:		inc	ax		; 07cfe 40
b7cff:		cmp	[7c3ch],al		; 07cff 38063C7C
b7d03:		jnc	b7d08		; 07d03 7303
b7d05:		mov	al,[7c3ch]		; 07d05 A03C7C
b7d08:		push	ax		; 07d08 50
b7d09:		call	load_sectors		; 07d09 E84E00
b7d0c:		pop	ax		; 07d0c 58
b7d0d:		jc	print_fail		; 07d0d 72C6
b7d0f:		sub	[7c3ch],al		; 07d0f 28063C7C
b7d13:		jz	b7d21		; 07d13 740C
b7d15:		add	[7c37h],ax		; 07d15 0106377C
b7d19:		mul	word ptr bytes_per_sector		; 07d19 F7260B7C
b7d1d:		add	bx,ax		; 07d1d 03D8
b7d1f:		jmp	read_loop		; 07d1f EBD0

b7d21:		mov	ch,format_id		; 07d21 8A2E157C
b7d25:		mov	dl,[7dfdh]		; 07d25 8A16FD7D
b7d29:		mov	bx,[7c3dh]		; 07d29 8B1E3D7C
b7d2d:		jmp	_ibmbio_com	; 07d2d EA00007000

_bootmain	endp

print_msg	proc	near

b7d32:		lodsb			; 07d32 AC
b7d33:		or	al,al		; 07d33 0AC0
b7d35:		jz	jmp_ret		; 07d35 7422
b7d37:		mov	ah,0eh		; 07d37 B40E
b7d39:		mov	bx,7		; 07d39 BB0700
b7d3c:		int	10h		; 07d3c CD10
b7d3e:		jmp	b7d32		; 07d3e EBF2

compute_chs	label	near

		xor	dx,dx		; 07d40 33D2
b7d42:		div	word ptr sectors_per_track		; 07d42 F736187C
b7d46:		inc	dl		; 07d46 FEC2
b7d48:		mov	[7c3bh],dl		; 07d48 88163B7C
b7d4c:		xor	dx,dx		; 07d4c 33D2
b7d4e:		div	heads		; 07d4e F7361A7C
b7d52:		mov	[7c2ah],dl		; 07d52 88162A7C
b7d56:		mov	[7c39h],ax		; 07d56 A3397C
jmp_ret:	ret			; 07d59 C3

print_msg	endp

load_sectors	proc	near

		mov	ah,2		; 07d5a B402
b7d5c:		mov	dx,[7c39h]		; 07d5c 8B16397C
b7d60:		mov	cl,6		; 07d60 B106
b7d62:		shl	dh,cl		; 07d62 D2E6
b7d64:		or	dh,[7c3bh]		; 07d64 0A363B7C
b7d68:		mov	cx,dx		; 07d68 8BCA
b7d6a:		xchg	ch,cl		; 07d6a 86E9
b7d6c:		mov	dl,[7dfdh]		; 07d6c 8A16FD7D
b7d70:		mov	dh,[7c2ah]		; 07d70 8A362A7C
b7d74:		int	13h		; 07d74 CD13
b7d76:		ret			; 07d76 C3

load_sectors	endp

non_sys_disk	db	13,10		; 07d77 0D0A4E
b7d7a		db	'Non-System disk or disk error',13,10
b7d98		db	'Replace and strike any key when ready',13,10,0
disk_boot_fail	db	13,10
b7dc2		db	'Disk Boot failure',13,10,0
ibmbio_str	db	'IBMBIO  COM'
ibmdos_str	db	'IBMDOS  COM'
b7dec		dw	9 dup (0)	; 07dec 00 X09
b7dfe		dw	0aa55h		; 07dfe 55AA

_BOOTSECT	ends

		;end	_bootstrap
