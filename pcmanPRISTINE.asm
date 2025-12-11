		name	pcman

_IVT		segment	at 0

		dd	1eh dup (?)
int_1eh		dd	?
		dd	0e1h dup (?)

		; Also at 0040:0000
_bios_data_area	label	byte
		db	10h dup (?)
equip_list	dw	?
		db	0eeh dup (?)
		; Also at 0050:0000
_dos_data_area	db	70h dup (?)
		; 00570
dpt_copy	dw	2 dup (?)
		; 00574
dpt_copy_spt	db	?
		db	?
		dw	5 dup (?)
		dw	80h dup (?)

_IVT		ends

_STACK1		segment	at 60h
stack1_bottom	db	200h dup (?)
stack1_top	label	word
_STACK1		ends

		; Now at 80h. Pad to B0h.
_PADDING1	segment	at 80h
padding1	db	300h dup (?)
padding1_top	label	byte
_PADDING1	ends

		; Now at B0h.
_BOOTSECT2_IMG	segment	at 0b0h

_bootstrap2_img	label	near
		db	200h dup (?)

_BOOTSECT2_IMG	ends

		; Now at D0h.
_PADDING2	segment	at 0d0h
padding2	db	3f50h dup (?)
padding2_top	label	byte
_PADDING2	ends

		; Now at 4C5h.
_LOAD_TRACKS	segment	at 04c5h
bootstrap3_img	label	far
track1		db	1000h dup (?)	; 04C50 - 05C4F
track2		db	1000h dup (?)	; 05C50 - 06C4F
track3		db	1000h dup (?)	; 06C50 - 07C4F
track4		db	1000h dup (?)	; 07C50 - 08D4F
track4_top	label	byte		; 08C50
		; Stack is placed at 08C4:0100 / 08D40.
		; This is near the end of track 4.
_LOAD_TRACKS	ends

_DATA_IMG	segment	at 5c1h
_DATA_IMG	ends

_STACK2		segment at 8c4h
stack2_bottom	db	100h dup (?)
stack2_top	label	word
_STACK2		ends

CGA_FB		segment	at 0b800h
even_lines	db	1f40h dup (?)
umb_1		db	0c0h dup (?)
odd_lines	db	1f40h dup (?)
umb_2		db	0c0h dup (?)
even_lines_dup	db	1f40h dup (?)
umb_1_dup	db	0c0h dup (?)
odd_lines_dup	db	1f40h dup (?)
umb_2_dup	db	0c0h dup (?)
CGA_FB		ends

		; The rest of this is ready to get written out sequentially to
		; the disk image. The disk image is 5 tracks, and is 9 sectors per
		; track.
		;
		; Track 0, sector 1 gets loaded to    07C0:0000 - 07C0:01FF.
		;                     Stack is set to 0060:0000 - 0060:01FF.
		; Track 0, sector 2 gets loaded to    00B0:0000 - 00B0:01FF.
		; Track 1, sectors 2-8 gets loaded to 04C5:0000 - 04C5:0FFF.
		;                      Data starts at 04C5:0FC0 - 04C5:3FEF.
		;                        DS is set to 05C1:0000 - 05C1:302F.
		; Track 2, sectors 2-8 gets loaded to 04C5:1000 - 04C5:1FFF.
		; Track 3, sectors 2-8 gets loaded to 04C5:2000 - 04C5:2FFF.
		; Track 4, sectors 2-8 gets loaded to 04C5:3000 - 04C5:3FFF.
		;                     Stack is set to 08C4:0000 - 08C4:00FF.
		;                            (same as 04C5:3FF0 - 04C5:40EF).
		;
		; The first sector of tracks 1 - 4 is not loaded.
		

		; Track 0, sector 1
;_BOOTSECT	segment	at 0
_BOOTSECT	segment	para public 'CODE'
		assume	cs:_BOOTSECT,ds:nothing,es:nothing,ss:nothing
		org	7c00h

_bootstrap	proc	far

_boot_main:

		; Install stack at 0060:0200 (00800 / 0050:0300)
l0000:		mov	sp,_STACK1		; 00000000 BC6000
l0003:		mov	ss,sp			; 00000003 8ED4
		assume	ss:_STACK1
l0005:		mov	sp,offset stack1_top	; 00000005 BC0002

		; Read from disk to 00B0:0000 (00B00 / 50:0600)
l0008:		mov	ax,_BOOTSECT2_IMG	; 00000008 B8B000
l000B:		mov	es,ax			; 0000000B 8EC0
l000D:		mov	bx,0			; 0000000D BB0000

		; Drive A:, first side
l0010:		mov	dx,0			; 00000010 BA0000

		; Sector 2, track 0.
l0013:		mov	cx,0x2			; 00000013 B90200

		; Read 1 sector
l0016:		mov	ax,201h			; 00000016 B80102
l0019:		int	13h			; 00000019 CD13 Just repeatedly try if it fails
l001B:		jc	l0016			; 0000001B 72F9

		; Jump to the sector we just loaded (00B0:0000)
l001D:		push	es			; 0000001D 06
l001E:		push	bx			; 0000001E 53
l001F:		ret				; 0000001F CB

_bootstrap	endp

vestigial1	proc	far

		; DS = 0
l0020:		;sub	ax,ax			; 00000020 2BC0
		dw	0c02bh
l0022:		mov	ds,ax			; 00000022 8ED8
		assume	ds:_IVT
		; DS:SI = load interrupt vector 1Eh (disk parameter table)
l0024:		lds	si,int_1eh		; 00000024 C5367800
		assume	ds:nothing
		; ES = 0
l0028:		mov	es,ax			; 00000028 8EC0
		assume	es:_IVT
		; ES:DI = 000570 (0050:0070)
l002A:		mov	di,offset dpt_copy	; 0000002A BF7005
		; Copy 16 bytes
l002D:		mov	cx,8			; 0000002D B90800
l0030:		cld				; 00000030 FC
l0031:		rep	movsw			; 00000031 F3A5
		; ES:DI = 000570 (again)
l0033:		sub	di,10h			; 00000033 83EF10
		; DS = ES = 0
l0036:		mov	ax,es			; 00000036 8CC0
l0038:		mov	ds,ax			; 00000038 8ED8
		assume	ds:_IVT
		; DS:SI = edit interrupt vector 1Eh
l003A:		;mov	si,1eh*4		; 0000003A BE7800
		mov	si,offset int_1eh
		; Set IVT to 000570
l003D:		mov	[si],di			; 0000003D 893C
l003F:		mov	[si+2],ax		; 0000003F 894402
		; Edit DPT:4 (byte of sectors per track)
l0042:		mov	si,offset dpt_copy_spt	; 00000042 BE7405
		; Change from 8 to 9 sectors per track
l0045:		mov	byte ptr [si],9		; 00000045 C60409
		; Set ES:BX to 04C5:3000 (04C50) - requires 32K
		; Load 16K worth of tracks from 04C50-
l0048:		mov	ax,_LOAD_TRACKS		; 00000048 B8C504
l004B:		mov	es,ax			; 0000004B 8EC0
l004D:		mov	bx,offset track4	; 0000004D BB0030
		; Drive A:, first side
l0050:		mov	dx,0			; 00000050 BA0000
		; Start at track 4, sector 2
l0053:		mov	cx,402h			; 00000053 B90204
		; Read sectors 2 - 9 (8 sectors)
		; 4,096 (1000h) bytes
l0056:		mov	ax,208h			; 00000056 B80802
l0059:		int	13h			; 00000059 CD13
		; Repeatedly retry if fails
l005B:		jc	l0056			; 0000005B 72F9
		; Descend to the next 4K block of memory
l005D:		sub	bx,1000h		; 0000005D 81EB0010
		; Go to the prior track
l0061:		dec	ch			; 00000061 FECD
		; Don't load track 0.
l0063:		jnz	l0056			; 00000063 75F1
		; Change stack to 08C4:0100 (08D40) - requires 48K
l0065:		mov	sp,_STACK2		; 00000065 BCC408
l0068:		mov	ss,sp			; 00000068 8ED4
l006A:		mov	sp,offset stack2_top	; 0000006A BC0001
		; Jump to 04C5:0000 (004C5)
		;jmp	bootstrap3_img
l006D:		mov	ax,_LOAD_TRACKS		; 0000006D B8C504
l0070:		push	ax			; 00000070 50
l0071:		;xor	ax,ax			; 00000071 33C0
		dw	0c033h
l0073:		push	ax			; 00000073 50
l0074:		ret			; 00000074 CB

vestigial1	endp

		; Pad out 5/6/7/8/9
		db	5 dup (0)		; 00000075 00 X05
		; Repeat "stak" for 260 bytes. Start at A/B/C/D alignment.
		db	64 dup ('stak') 	; 0000007A 7374616B X41
		; Pad out to 512 bytes
		db	134 dup (0)		; 00000180 00 X86
						; 00000200

_BOOTSECT	ends


;_BOOTSECT2	segment	at 0b0h
		; Track 0, sector 2
_BOOTSECT2	segment	para public 'CODE'
		assume	cs:_BOOTSECT2
		org	0

_bootstrap2	proc	far
		assume	ds:nothing,es:_BOOTSECT2_IMG,ss:_STACK1

l0200:		;sub ax,ax			; 00000200 2BC0
		dw	0c02bh
l0202:		mov	ds,ax			; 00000202 8ED8
		assume	ds:_IVT
l0204:		lds	si,int_1eh		; 00000204 C5367800
		assume	ds:nothing
l0208:		mov	es,ax			; 00000208 8EC0
		assume	es:_IVT
l020A:		mov	di,offset dpt_copy	; 0000020A BF7005
l020D:		mov	cx,8			; 0000020D B90800
l0210:		cld				; 00000210 FC
l0211:		rep	movsw			; 00000211 F3A5
l0213:		sub	di,10h			; 00000213 83EF10
l0216:		mov	ax,es			; 00000216 8CC0
l0218:		mov	ds,ax			; 00000218 8ED8
		assume	ds:_IVT
l021A:		mov	si,offset int_1eh	; 0000021A BE7800
l021D:		mov	[si],di			; 0000021D 893C
l021F:		mov	[si+2],ax		; 0000021F 894402
l0222:		mov	si,offset dpt_copy_spt	; 00000222 BE7405
l0225:		mov	byte ptr [si],9		; 00000225 C60409
l0228:		mov	ax,_LOAD_TRACKS		; 00000228 B8C504
l022B:		mov	es,ax			; 0000022B 8EC0
		assume	es:_LOAD_TRACKS
l022D:		mov	bx,offset track4	; 0000022D BB0030
l0230:		mov	dx,0			; 00000230 BA0000
l0233:		mov	cx,402h			; 00000233 B90204
l0236:		mov	ax,208h			; 00000236 B80802
l0239:		int	13h			; 00000239 CD13
l023B:		jc	l0236			; 0000023B 72F9
l023D:		sub	bx,track4-track3	; 0000023D 81EB0010
l0241:		dec	ch			; 00000241 FECD
l0243:		jnz	l0236			; 00000243 75F1
l0245:		mov	sp,_STACK2		; 00000245 BCC408
l0248:		mov	ss,sp			; 00000248 8ED4
l024A:		mov	sp,offset stack2_top	; 0000024A BC0001
l024D:		mov	ax,_LOAD_TRACKS		; 0000024D B8C504
l0250:		push	ax			; 00000250 50
l0251:		;xor	ax,ax			; 00000251 33C0
		dw	0c033h
l0253:		push	ax			; 00000253 50
l0254:		ret				; 00000254 CB

_bootstrap2	endp

		db	5 dup (0)		; 00000255 00 X5
		db	64 dup ('stak')		; 0000025A 7374616B X40
		db	166 dup (0)		; 0000035A 00 XA6
						; 00000400 
_BOOTSECT2	ends

_TRK0_SCTR3_9	segment	para public 'CODE'

		; Sector 3
		dw	0fffeh,0ffh,6 dup (0)	; 00000400
		db	28*16 dup (0)		; 00000410
		db	9 dup (0), 7 dup (246)  ; 000005D0
		db	2*16 dup (246)		; 000005E0

		; Sectors 4 - 7	(4 sectors)	; 00000600 - 000E00
		db	4*16 dup (229,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246,246)

		; Sectors 8 - 9 (2 sectors)
		db	2*512 dup (246)

_TRK0_SCTR3_9	ends

_TRK1_SCTR1	segment	para public 'CODE'
		; Sector 1			; 00001200
		db	512 dup (246)
_TRK1_SCTR1	ends

;_TRK1_TEXT	segment	at 4c5h
_TRK1_TEXT	segment	para public 'CODE'
		assume	cs:_LOAD_TRACKS,ds:_IVT,es:_LOAD_TRACKS,ss:_STACK2
		org	0

bootstrap3	proc	near

		; Push DS:0 onto stack. DS is 0, so effectively pushes a dword of 0.
l1400:		push	ds			; 00001400 1E
l1401:		;xor	ax,ax			; 00001401 33C0
		dw	0c033h
l1403:		push	ax			; 00001403 50
		; Set DS:SI to 0000:0410 (0040:0010). Setting DS is redundant.
l1404:		mov	ds,ax			; 00001404 8ED8
		assume	ds:_IVT
l1406:		mov	di,offset equip_list	; 00001406 BF1004

		; Obtain low word of equipment list
l1409:		mov al,[di]			; 00001409 8A05

		; Clear bits 4 & 5 (game adapter & unused bit)
l140B:		and al,0xcf			; 0000140B 24CF

		; Set bit 5 (force initial video mode to CGA 80x25)
l140D:		or al,0x20			; 0000140D 0C20
l140F:		mov [di],al			; 0000140F 8805

		; Change DS to 05C1
l1411:		mov ax,_DATA_IMG		; 00001411 B8C105
l1414:		mov ds,ax			; 00001414 8ED8

		; Set ES to CGA
l1416:		mov ax,CGA_FB			; 00001416 B800B8
l1419:		mov es,ax			; 00001419 8EC0

		; Prepare speaker port
l141B:		mov	al,4fh			; 0000141B B04F
l141D:		out	61h,al			; 0000141D E661
l141F:		mov	al,0b6h			; 0000141F B0B6
l1421:		out	43h,al			; 00001421 E643

		; Set video mode
l1423:		mov	ax,4			; 00001423 B80400
l1426:		int	10h			; 00001426 CD10

		; Change palette
l1428:		mov	dx,3d9h			; 00001428 BAD903
l142B:		mov	al,10h			; 0000142B B010
l142D:		out	dx,al			; 0000142D EE
l142E:		mov	dl,3			; 0000142E B203
l1430:		call	l1521			; 00001430 E8EE00
l1433:		mov	di,150h			; 00001433 BF5001
l1436:		mov	si,0			; 00001436 BE0000
l1439:		mov	bx,0fff4h			; 00001439 BBF4FF
l143C:		mov	cx,17h			; 0000143C B91700
l143F:		mov	dx,1ff7h			; 0000143F BAF71F
l1442:		mov	bp,0e047h			; 00001442 BD47E0
l1445:		cld				; 00001445 FC
l1446:		movsw				; 00001446 A5
l1447:		movsw				; 00001447 A5
l1448:		movsw				; 00001448 A5
l1449:		movsw				; 00001449 A5
l144A:		movsb				; 0000144A A4
l144B:		add	di,dx			; 0000144B 03FA
l144D:		xchg	dx,bp			; 0000144D 87D5
l144F:		loop	l1446		; 0000144F E2F5
l1451:		sub	di,2370h			; 00001451 81EF7023
l1455:		add	di,[bx+4e6h]			; 00001455 03BFE604
l1459:		add	bx,2			; 00001459 83C302
l145C:		jnz	l143c			; 0000145C 75DE
l145E:		mov	si,4e6h			; 0000145E BEE604
l1461:		mov	bp,112h			; 00001461 BD1201
l1464:		mov	ah,0			; 00001464 B400
l1466:		int	1ah			; 00001466 CD1A
l1468:		mov	bx,dx			; 00001468 8BDA
l146A:		mov	ah,0			; 0000146A B400
l146C:		int	1ah			; 0000146C CD1A
l146E:		cmp	bx,dx			; 0000146E 3BDA
l1470:		jz	l146a			; 00001470 74F8
l1472:		mov	ah,1			; 00001472 B401
l1474:		int	16h			; 00001474 CD16
l1476:		jz	l1484			; 00001476 740C
l1478:		mov	ah,0			; 00001478 B400
l147A:		int	16h			; 0000147A CD16
l147C:		cmp	al,13h			; 0000147C 3C13
l147E:		jnz	l1484			; 0000147E 7504
l1480:		neg	byte ptr [2fa0h]			; 00001480 F61EA02F
l1484:		lodsw				; 00001484 AD
l1485:		cmp	byte ptr [2fa0h],0			; 00001485 803EA02F00
l148A:		jg	l1492			; 0000148A 7F06
l148C:		call	l2360			; 0000148C E8D10E
l148F:		jmp	l1498			; 0000148F EB07
l1491:		nop				; 00001491 90
l1492:		out	42h,al			; 00001492 E642
l1494:		mov	al,ah			; 00001494 8AC4
l1496:		out	42h,al			; 00001496 E642
l1498:		sub	bp,2			; 00001498 83ED02
l149B:		jnz	l1464			; 0000149B 75C7
l149D:		mov	dl,3			; 0000149D B203
l149F:		call	l1521			; 0000149F E87F00
l14A2:		mov	cx,5			; 000014A2 B90500
l14A5:		mov	si,5f8h			; 000014A5 BEF805
l14A8:		cld				; 000014A8 FC
l14A9:		lodsw				; 000014A9 AD
l14AA:		mov	dx,ax			; 000014AA 8BD0
l14AC:		mov	bh,0			; 000014AC B700
l14AE:		mov	ah,2			; 000014AE B402
l14B0:		int	10h			; 000014B0 CD10
l14B2:		lodsb				; 000014B2 AC
l14B3:		cmp	al,0			; 000014B3 3C00
l14B5:		jz	l14c0			; 000014B5 7409
l14B7:		mov	bx,2			; 000014B7 BB0200
l14BA:		mov	ah,0eh			; 000014BA B40E
l14BC:		int	10h			; 000014BC CD10
l14BE:		jmp	l14b2			; 000014BE EBF2
l14C0:		loop	l14A8		; 000014C0 E2E6
l14C2:		mov	byte ptr [2f8fh],1			; 000014C2 C6068F2F01
l14C7:		mov	dx,201h			; 000014C7 BA0102
l14CA:		in	al,dx			; 000014CA EC
l14CB:		xor	al,30h			; 000014CB 3430
l14CD:		test	al,30h			; 000014CD A830
l14CF:		jnz	l14ee			; 000014CF 751D
l14D1:		mov	byte ptr [2f8fh],0			; 000014D1 C6068F2F00
l14D6:		mov	ah,1			; 000014D6 B401
l14D8:		int	16h			; 000014D8 CD16
l14DA:		jz	l14c2			; 000014DA 74E6
l14DC:		mov	ah,0			; 000014DC B400
l14DE:		int	16h			; 000014DE CD16
l14E0:		cmp	al,20h			; 000014E0 3C20
l14E2:		jz	l14ee			; 000014E2 740A
l14E4:		cmp	al,13h			; 000014E4 3C13
l14E6:		jnz	l14c2			; 000014E6 75DA
l14E8:		neg	byte ptr [2fa0h]			; 000014E8 F61EA02F
l14EC:		jmp	l14c2			; 000014EC EBD4
l14EE:		mov	word ptr [2d24h],0			; 000014EE C706242D0000
l14F4:		mov	byte ptr [6f0h],3			; 000014F4 C606F00603
l14F9:		mov	word ptr [6f1h],0			; 000014F9 C706F1060000
l14FF:		push	es			; 000014FF 06
l1500:		push	ds			; 00001500 1E
l1501:		pop	es			; 00001501 07
l1502:		mov	di,2f7eh			; 00001502 BF7E2F
l1505:		mov	cx,5			; 00001505 B90500
l1508:		cld				; 00001508 FC
l1509:		mov	al,0			; 00001509 B000
l150B:		rep	stosb			; 0000150B F3AA
l150D:		pop	es			; 0000150D 07
l150E:		call	l152E			; 0000150E E81D00
l1511:		mov	al,2			; 00001511 B002
l1513:		out	42h,al			; 00001513 E642
l1515:		xor	al,al			; 00001515 32C0
l1517:		out	42h,al			; 00001517 E642
l1519:		mov	si,678h			; 00001519 BE7806
l151C:		mov	cx,2			; 0000151C B90200
l151F:		jmp	l14a8			; 0000151F EB87

		; Delay  loop
l1521:		mov	cx,0			; 00001521 B90000
l1524:		loop	l1524		; 00001524 E2FE
l1526:		mov	cx,0			; 00001526 B90000
l1529:		dec	dl			; 00001529 FECA
l152B:		jnz	l1524			; 0000152B 75F7
l152D:		ret				; 0000152D C3

		; Reset video mode
l152E:		mov	ax,4			; 0000152E B80400
l1531:		int	10h			; 00001531 CD10
l1533:		mov	ah,0bh			; 00001533 B40B
l1535:		mov	bx,100h			; 00001535 BB0001
l1538:		int	10h			; 00001538 CD10
l153A:		mov	ah,0bh			; 0000153A B40B
l153C:		mov	bx,10h			; 0000153C BB1000
l153F:		int	10h			; 0000153F CD10
l1541:		mov	dh,32h			; 00001541 B632
l1543:		mov	di,0dh			; 00001543 BF0D00
l1546:		mov	bx,0a09h			; 00001546 BB090A
l1549:		mov	dl,3eh			; 00001549 B23E
l154B:		mov	al,[bx]			; 0000154B 8A07
l154D:		inc	bx			; 0000154D 43
l154E:		cmp	al,0			; 0000154E 3C00
l1550:		jz	l1573			; 00001550 7421
l1552:		mov	ah,0			; 00001552 B400
l1554:		mov	si,ax			; 00001554 8BF0
l1556:		shl	si,1			; 00001556 D1E6
l1558:		shl	si,1			; 00001558 D1E6
l155A:		add	si,991h			; 0000155A 81C69109
l155E:		mov	bp,1fffh			; 0000155E BDFF1F
l1561:		mov	cx,4			; 00001561 B90400
l1564:		cld				; 00001564 FC
l1565:		movsb				; 00001565 A4
l1566:		add	di,bp			; 00001566 03FD
l1568:		neg	bp			; 00001568 F7DD
l156A:		add	bp,4eh			; 0000156A 83C54E
l156D:		loop	l1565		; 0000156D E2F6
l156F:		sub	di,0a0h			; 0000156F 81EFA000
l1573:		inc	di			; 00001573 47
l1574:		dec	dl			; 00001574 FECA
l1576:		jnz	l154b			; 00001576 75D3
l1578:		add	di,62h			; 00001578 83C762
l157B:		dec	dh			; 0000157B FECE
l157D:		jnz	l1549			; 0000157D 75CA
l157F:		push	es			; 0000157F 06
l1580:		push	ds			; 00001580 1E
l1581:		pop	es			; 00001581 07
l1582:		mov	byte ptr [2c99h],0e6h			; 00001582 C606992CE6
l1587:		mov	si,19eah			; 00001587 BEEA19
l158A:		mov	di,1673h			; 0000158A BF7316
l158D:		mov	cx,377h			; 0000158D B97703
l1590:		cld				; 00001590 FC
l1591:		rep	movsb			; 00001591 F3A4
l1593:		pop	es			; 00001593 07
l1594:		mov	dh,18h			; 00001594 B618
l1596:		mov	di,0afh			; 00001596 BFAF00
l1599:		mov	bx,1692h			; 00001599 BB9216
l159C:		mov	dl,1dh			; 0000159C B21D
l159E:		mov	al,[bx]			; 0000159E 8A07
l15A0:		inc	bx			; 000015A0 43
l15A1:		cmp	al,2			; 000015A1 3C02
l15A3:		jc	l15ca			; 000015A3 7225
l15A5:		mov	ah,0			; 000015A5 B400
l15A7:		mov	si,ax			; 000015A7 8BF0
l15A9:		shl	si,1			; 000015A9 D1E6
l15AB:		shl	si,1			; 000015AB D1E6
l15AD:		shl	si,1			; 000015AD D1E6
l15AF:		shl	si,1			; 000015AF D1E6
l15B1:		add	si,1615h			; 000015B1 81C61516
l15B5:		mov	bp,1ffeh			; 000015B5 BDFE1F
l15B8:		mov	cx,8			; 000015B8 B90800
l15BB:		cld				; 000015BB FC
l15BC:		movsw				; 000015BC A5
l15BD:		add	di,bp			; 000015BD 03FD
l15BF:		neg	bp			; 000015BF F7DD
l15C1:		add	bp,4ch			; 000015C1 83C54C
l15C4:		loop	l15BC		; 000015C4 E2F6
l15C6:		sub	di,140h			; 000015C6 81EF4001
l15CA:		add	di,2			; 000015CA 83C702
l15CD:		dec	dl			; 000015CD FECA
l15CF:		jnz	l159e			; 000015CF 75CD
l15D1:		inc	bx			; 000015D1 43
l15D2:		add	di,106h			; 000015D2 81C70601
l15D6:		dec	dh			; 000015D6 FECE
l15D8:		jnz	l159c			; 000015D8 75C2
l15DA:		mov	ah,2			; 000015DA B402
l15DC:		mov	dx,101h			; 000015DC BA0101
l15DF:		mov	bh,0			; 000015DF B700
l15E1:		int	10h			; 000015E1 CD10
l15E3:		mov	si,6c3h			; 000015E3 BEC306
l15E6:		mov	cx,27h			; 000015E6 B92700
l15E9:		cld				; 000015E9 FC
l15EA:		lodsb				; 000015EA AC
l15EB:		mov	bx,3			; 000015EB BB0300
l15EE:		mov	ah,0eh			; 000015EE B40E
l15F0:		int	10h			; 000015F0 CD10
l15F2:		loop	l15EA		; 000015F2 E2F6
l15F4:		push	es			; 000015F4 06
l15F5:		push	ds			; 000015F5 1E
l15F6:		pop	es			; 000015F6 07
l15F7:		mov	di,2f88h			; 000015F7 BF882F
l15FA:		mov	si,2f83h			; 000015FA BE832F
l15FD:		mov	cx,5			; 000015FD B90500
l1600:		rep	movsb			; 00001600 F3A4
l1602:		pop	es			; 00001602 07
l1603:		mov	di,0a00h			; 00001603 BF000A
l1606:		call	l22C4			; 00001606 E8BB0C
l1609:		call	l2278			; 00001609 E86C0C
l160C:		mov	ax,[6f1h]			; 0000160C A1F106
l160F:		inc	ax			; 0000160F 40
l1610:		;cmp	ax,0ch			; 00001610 3D0C00
		db	3dh
		dw	0ch
l1613:		jng	l1618			; 00001613 7E03
l1615:		mov	ax,0ch			; 00001615 B80C00
l1618:		mov	[6f1h],ax			; 00001618 A3F106
l161B:		mov	si,ax			; 0000161B 8BF0
l161D:		shl	si,1			; 0000161D D1E6
l161F:		shl	si,1			; 0000161F D1E6
l1621:		lea	si,[si+6efh]			; 00001621 8DB4EF06
l1625:		cld				; 00001625 FC
l1626:		lodsb				; 00001626 AC
l1627:		mov	[2c9ah],al			; 00001627 A29A2C
l162A:		lodsb				; 0000162A AC
l162B:		mov	[2d26h],al			; 0000162B A2262D
l162E:		lodsw				; 0000162E AD
l162F:		mov	[2d27h],ax			; 0000162F A3272D
l1632:		mov	bx,[6f1h]			; 00001632 8B1EF106
l1636:		cmp	bx,8			; 00001636 83FB08
l1639:		jng	l163e			; 00001639 7E03
l163B:		mov	bx,8			; 0000163B BB0800
l163E:		mov	di,1d19h			; 0000163E BF191D
l1641:		mov	si,2d2eh			; 00001641 BE2E2D
l1644:		mov	dx,1ffch			; 00001644 BAFC1F
l1647:		mov	bp,0e04ch			; 00001647 BD4CE0
l164A:		mov	cx,0eh			; 0000164A B90E00
l164D:		add	si,3			; 0000164D 83C603
l1650:		cld				; 00001650 FC
l1651:		movsw				; 00001651 A5
l1652:		movsw				; 00001652 A5
l1653:		add	di,dx			; 00001653 03FA
l1655:		xchg	dx,bp			; 00001655 87D5
l1657:		loop	l1651		; 00001657 E2F8
l1659:		sub	di,4b0h			; 00001659 81EFB004
l165D:		dec	bx			; 0000165D 4B
l165E:		jnz	l164a			; 0000165E 75EA
l1660:		mov	bl,[6f0h]			; 00001660 8A1EF006
l1664:		mov	bh,0			; 00001664 B700
l1666:		dec	bx			; 00001666 4B
l1667:		jz	l169f			; 00001667 7436
l1669:		mov	di,bx			; 00001669 8BFB
l166B:		shl	di,1			; 0000166B D1E7
l166D:		shl	di,1			; 0000166D D1E7
l166F:		add	di,bx			; 0000166F 03FB
l1671:		shl	di,1			; 00001671 D1E7
l1673:		shl	di,1			; 00001673 D1E7
l1675:		shl	di,1			; 00001675 D1E7
l1677:		shl	di,1			; 00001677 D1E7
l1679:		shl	di,1			; 00001679 D1E7
l167B:		shl	di,1			; 0000167B D1E7
l167D:		shl	di,1			; 0000167D D1E7
l167F:		neg	di			; 0000167F F7DF
l1681:		add	di,1f3bh			; 00001681 81C73B1F
l1685:		mov	si,1f59h			; 00001685 BE591F
l1688:		mov	dx,1ffch			; 00001688 BAFC1F
l168B:		mov	bp,0e04ch			; 0000168B BD4CE0
l168E:		mov	cx,0eh			; 0000168E B90E00
l1691:		movsw				; 00001691 A5
l1692:		movsw				; 00001692 A5
l1693:		add	di,dx			; 00001693 03FA
l1695:		xchg	dx,bp			; 00001695 87D5
l1697:		loop	l1691		; 00001697 E2F8
l1699:		add	di,50h			; 00001699 83C750
l169C:		dec	bx			; 0000169C 4B
l169D:		jnz	l1685			; 0000169D 75E6
l169F:		push	es			; 0000169F 06
l16A0:		push	ds			; 000016A0 1E
l16A1:		pop	es			; 000016A1 07
l16A2:		cld				; 000016A2 FC
l16A3:		mov	di,2f90h			; 000016A3 BF902F
l16A6:		mov	cx,4			; 000016A6 B90400
l16A9:		mov	ax,0			; 000016A9 B80000
l16AC:		rep	stosw			; 000016AC F3AB
l16AE:		mov	word ptr [2c9bh],0			; 000016AE C7069B2C0000
l16B4:		mov	byte ptr [2cc9h],0			; 000016B4 C606C92C00
l16B9:		mov	byte ptr [2cbch],0			; 000016B9 C606BC2C00
l16BE:		lea	si,[725h]			; 000016BE 8D362507
l16C2:		lea	di,[2a2dh]			; 000016C2 8D3E2D2A
l16C6:		mov	cx,26ch			; 000016C6 B96C02
l16C9:		rep	movsb			; 000016C9 F3A4
l16CB:		pop	es			; 000016CB 07
l16CC:		call	l1CD9			; 000016CC E80A06
l16CF:		mov	bx,1f0h			; 000016CF BBF001
l16D2:		cld				; 000016D2 FC
l16D3:		lea	si,[bx+2a39h]			; 000016D3 8DB7392A
l16D7:		mov	di,[bx+2a2eh]			; 000016D7 8BBF2E2A
l16DB:		mov	cx,0eh			; 000016DB B90E00
l16DE:		mov	dx,0e04ch			; 000016DE BA4CE0
l16E1:		mov	bp,1ffch			; 000016E1 BDFC1F
l16E4:		movsw				; 000016E4 A5
l16E5:		movsw				; 000016E5 A5
l16E6:		add	di,dx			; 000016E6 03FA
l16E8:		xchg	dx,bp			; 000016E8 87D5
l16EA:		loop	l16E4		; 000016EA E2F8
l16EC:		sub	bx,7ch			; 000016EC 83EB7C
l16EF:		jnz	l16d3			; 000016EF 75E2
l16F1:		mov	si,1e09h			; 000016F1 BE091E
l16F4:		mov	di,[2a2eh]			; 000016F4 8B3E2E2A
l16F8:		mov	dx,0e04ch			; 000016F8 BA4CE0
l16FB:		mov	cx,0eh			; 000016FB B90E00
l16FE:		cld				; 000016FE FC
l16FF:		movsw				; 000016FF A5
l1700:		movsw				; 00001700 A5
l1701:		add	di,dx			; 00001701 03FA
l1703:		neg	dx			; 00001703 F7DA
l1705:		add	dx,48h			; 00001705 83C248
l1708:		loop	l16FF		; 00001708 E2F5
l170A:		mov	dx,0			; 0000170A BA0000
l170D:		mov	ah,2			; 0000170D B402
l170F:		mov	bh,0			; 0000170F B700
l1711:		int	10h			; 00001711 CD10
l1713:		mov	di,0c07h			; 00001713 BF070C
l1716:		mov	bp,6			; 00001716 BD0600
l1719:		mov	al,[ds:bp+6e9h]			; 00001719 3E8A86E906
l171E:		mov	cx,1			; 0000171E B90100
l1721:		mov	bx,2			; 00001721 BB0200
l1724:		mov	ah,9			; 00001724 B409
l1726:		int	10h			; 00001726 CD10
l1728:		push	ds			; 00001728 1E
l1729:		push	es			; 00001729 06
l172A:		pop	ds			; 0000172A 1F
l172B:		mov	si,0			; 0000172B BE0000
l172E:		mov	dx,1ffeh			; 0000172E BAFE1F
l1731:		mov	bx,0e04eh			; 00001731 BB4EE0
l1734:		mov	cx,8			; 00001734 B90800
l1737:		movsw				; 00001737 A5
l1738:		add	di,dx			; 00001738 03FA
l173A:		add	si,dx			; 0000173A 03F2
l173C:		xchg	dx,bx			; 0000173C 87D3
l173E:		loop	l1737		; 0000173E E2F7
l1740:		pop	ds			; 00001740 1F
l1741:		dec	bp			; 00001741 4D
l1742:		jnz	l1719			; 00001742 75D5
l1744:		mov	di,0			; 00001744 BF0000
l1747:		mov	ax,0			; 00001747 B80000
l174A:		mov	dx,1ffeh			; 0000174A BAFE1F
l174D:		mov	bp,0e04eh			; 0000174D BD4EE0
l1750:		mov	cx,8			; 00001750 B90800
l1753:		stosw				; 00001753 AB
l1754:		add	di,dx			; 00001754 03FA
l1756:		xchg	dx,bp			; 00001756 87D5
l1758:		loop	l1753		; 00001758 E2F9
l175A:		mov	dh,5			; 0000175A B605
l175C:		mov	cx,0			; 0000175C B90000
l175F:		loop	l175F		; 0000175F E2FE
l1761:		mov	cx,0			; 00001761 B90000
l1764:		dec	dh			; 00001764 FECE
l1766:		jnz	l175f			; 00001766 75F7
l1768:		mov	di,0c07h			; 00001768 BF070C
l176B:		mov	ax,0			; 0000176B B80000
l176E:		mov	cx,30h			; 0000176E B93000
l1771:		mov	dx,1ffeh			; 00001771 BAFE1F
l1774:		mov	bp,0e04eh			; 00001774 BD4EE0
l1777:		stosw				; 00001777 AB
l1778:		add	di,dx			; 00001778 03FA
l177A:		xchg	dx,bp			; 0000177A 87D5
l177C:		loop	l1777		; 0000177C E2F9
l177E:		call	l18DB			; 0000177E E85A01
l1781:		mov	al,2			; 00001781 B002
l1783:		out	42h,al			; 00001783 E642
l1785:		xor	al,al			; 00001785 32C0
l1787:		out	42h,al			; 00001787 E642
l1789:		call	l2278			; 00001789 E8EC0A
l178C:		cmp	byte ptr [2c99h],0			; 0000178C 803E992C00
l1791:		jnz	l17ac			; 00001791 7519
l1793:		mov	di,[2a2eh]			; 00001793 8B3E2E2A
l1797:		mov	si,1dd1h			; 00001797 BED11D
l179A:		mov	dx,0e04ch			; 0000179A BA4CE0
l179D:		mov	bp,1ffch			; 0000179D BDFC1F
l17A0:		mov	cx,0eh			; 000017A0 B90E00
l17A3:		cld				; 000017A3 FC
l17A4:		movsw				; 000017A4 A5
l17A5:		movsw				; 000017A5 A5
l17A6:		add	di,dx			; 000017A6 03FA
l17A8:		xchg	dx,bp			; 000017A8 87D5
l17AA:		loop	l17A4		; 000017AA E2F8
l17AC:		mov	dl,2			; 000017AC B202
l17AE:		mov	cx,0			; 000017AE B90000
l17B1:		loop	l17B1		; 000017B1 E2FE
l17B3:		mov	cx,0			; 000017B3 B90000
l17B6:		dec	dl			; 000017B6 FECA
l17B8:		jnz	l17b1			; 000017B8 75F7
l17BA:		mov	bx,26ch			; 000017BA BB6C02
l17BD:		mov	di,[bx+2a2eh]			; 000017BD 8BBF2E2A
l17C1:		mov	si,2a71h			; 000017C1 BE712A
l17C4:		add	si,bx			; 000017C4 03F3
l17C6:		mov	dx,0e04ch			; 000017C6 BA4CE0
l17C9:		mov	bp,1ffch			; 000017C9 BDFC1F
l17CC:		mov	cl,[bx+2a35h]			; 000017CC 8A8F352A
l17D0:		mov	ch,0			; 000017D0 B500
l17D2:		jcxz	l17dd			; 000017D2 E309
l17D4:		cld				; 000017D4 FC
l17D5:		movsw				; 000017D5 A5
l17D6:		movsw				; 000017D6 A5
l17D7:		add	di,dx			; 000017D7 03FA
l17D9:		xchg	dx,bp			; 000017D9 87D5
l17DB:		loop	l17D5		; 000017DB E2F8
l17DD:		sub	bx,7ch			; 000017DD 83EB7C
l17E0:		jnz	l17bd			; 000017E0 75DB
l17E2:		cmp	byte ptr [2c99h],0			; 000017E2 803E992C00
l17E7:		jz	l17ec			; 000017E7 7403
l17E9:		jmp	l180d			; 000017E9 EB22
l17EB:		nop				; 000017EB 90
l17EC:		mov	bh,7			; 000017EC B707
l17EE:		mov	dx,3d9h			; 000017EE BAD903
l17F1:		mov	al,20h			; 000017F1 B020
l17F3:		mov	ah,10h			; 000017F3 B410
l17F5:		mov	bl,2			; 000017F5 B302
l17F7:		mov	cx,0			; 000017F7 B90000
l17FA:		loop	l17FA		; 000017FA E2FE
l17FC:		mov	cx,8000h			; 000017FC B90080
l17FF:		dec	bl			; 000017FF FECB
l1801:		jnz	l17fa			; 00001801 75F7
l1803:		out	dx,al			; 00001803 EE
l1804:		xchg	al,ah			; 00001804 86C4
l1806:		dec	bh			; 00001806 FECF
l1808:		jnz	l17f5			; 00001808 75EB
l180A:		jmp	l152e			; 0000180A E921FD
l180D:		mov	bp,[2a2eh]			; 0000180D 8B2E2E2A
l1811:		mov	si,2675h			; 00001811 BE7526
l1814:		mov	ax,2cd0h			; 00001814 B8D02C
l1817:		mov	[723h],ax			; 00001817 A32307
l181A:		mov	di,2			; 0000181A BF0200
l181D:		push	si			; 0000181D 56
l181E:		mov	si,[723h]			; 0000181E 8B362307
l1822:		mov	ah,0			; 00001822 B400
l1824:		int	1ah			; 00001824 CD1A
l1826:		mov	bx,dx			; 00001826 8BDA
l1828:		mov	ah,0			; 00001828 B400
l182A:		int	1ah			; 0000182A CD1A
l182C:		cmp	dx,bx			; 0000182C 3BD3
l182E:		jz	l1828			; 0000182E 74F8
l1830:		lodsw				; 00001830 AD
l1831:		cmp	byte ptr [2fa0h],0			; 00001831 803EA02F00
l1836:		jl	l183e			; 00001836 7C06
l1838:		out	42h,al			; 00001838 E642
l183A:		mov	al,ah			; 0000183A 8AC4
l183C:		out	42h,al			; 0000183C E642
l183E:		dec	di			; 0000183E 4F
l183F:		jnz	l1822			; 0000183F 75E1
l1841:		mov	[723h],si			; 00001841 89362307
l1845:		pop	si			; 00001845 5E
l1846:		cld				; 00001846 FC
l1847:		mov	di,bp			; 00001847 8BFD
l1849:		mov	bx,1ffch			; 00001849 BBFC1F
l184C:		mov	dx,0e04ch			; 0000184C BA4CE0
l184F:		mov	cl,[2a35h]			; 0000184F 8A0E352A
l1853:		mov	ch,0			; 00001853 B500
l1855:		mov	ax,cx			; 00001855 8BC1
l1857:		neg	ax			; 00001857 F7D8
l1859:		;add	ax,0eh			; 00001859 050E00
		db	5
		dw	0eh
l185C:		shl	ax,1			; 0000185C D1E0
l185E:		shl	ax,1			; 0000185E D1E0
l1860:		jcxz	l186a			; 00001860 E308
l1862:		movsw				; 00001862 A5
l1863:		movsw				; 00001863 A5
l1864:		add	di,dx			; 00001864 03FA
l1866:		xchg	dx,bx			; 00001866 87D3
l1868:		loop	l1862		; 00001868 E2F8
l186A:		add	si,ax			; 0000186A 03F0
l186C:		cmp	si,2a2dh			; 0000186C 81FE2D2A
l1870:		jnz	l181a			; 00001870 75A8
l1872:		mov	di,bp			; 00001872 8BFD
l1874:		mov	si,2a71h			; 00001874 BE712A
l1877:		mov	dx,0e04ch			; 00001877 BA4CE0
l187A:		mov	bp,1ffch			; 0000187A BDFC1F
l187D:		mov	cl,[2a35h]			; 0000187D 8A0E352A
l1881:		mov	ch,0			; 00001881 B500
l1883:		jcxz	l188e			; 00001883 E309
l1885:		cld				; 00001885 FC
l1886:		movsw				; 00001886 A5
l1887:		movsw				; 00001887 A5
l1888:		add	di,dx			; 00001888 03FA
l188A:		xchg	dx,bp			; 0000188A 87D5
l188C:		loop	l1886		; 0000188C E2F8
l188E:		mov	al,[6f0h]			; 0000188E A0F006
l1891:		mov	ah,0			; 00001891 B400
l1893:		dec	ax			; 00001893 48
l1894:		mov	[6f0h],al			; 00001894 A2F006
l1897:		jz	l18da			; 00001897 7441
l1899:		mov	di,ax			; 00001899 8BF8
l189B:		shl	di,1			; 0000189B D1E7
l189D:		shl	di,1			; 0000189D D1E7
l189F:		add	di,ax			; 0000189F 03F8
l18A1:		shl	di,1			; 000018A1 D1E7
l18A3:		shl	di,1			; 000018A3 D1E7
l18A5:		shl	di,1			; 000018A5 D1E7
l18A7:		shl	di,1			; 000018A7 D1E7
l18A9:		shl	di,1			; 000018A9 D1E7
l18AB:		shl	di,1			; 000018AB D1E7
l18AD:		shl	di,1			; 000018AD D1E7
l18AF:		neg	di			; 000018AF F7DF
l18B1:		add	di,1f3bh			; 000018B1 81C73B1F
l18B5:		mov	ax,0			; 000018B5 B80000
l18B8:		mov	dx,1ffch			; 000018B8 BAFC1F
l18BB:		mov	bp,0e04ch			; 000018BB BD4CE0
l18BE:		mov	cx,0eh			; 000018BE B90E00
l18C1:		cld				; 000018C1 FC
l18C2:		stosw				; 000018C2 AB
l18C3:		stosw				; 000018C3 AB
l18C4:		add	di,dx			; 000018C4 03FA
l18C6:		xchg	dx,bp			; 000018C6 87D5
l18C8:		loop	l18C2		; 000018C8 E2F8
l18CA:		mov	byte ptr [2f44h],1			; 000018CA C606442F01
l18CF:		mov	byte ptr [2f43h],0			; 000018CF C606432F00
l18D4:		call	l2061			; 000018D4 E88A07
l18D7:		jmp	l1660			; 000018D7 E986FD
l18DA:		ret				; 000018DA C3
l18DB:		mov	ah,0			; 000018DB B400
l18DD:		int	1ah			; 000018DD CD1A
l18DF:		mov	bx,dx			; 000018DF 8BDA
l18E1:		mov	ah,0			; 000018E1 B400
l18E3:		int	1ah			; 000018E3 CD1A
l18E5:		cmp	bx,dx			; 000018E5 3BDA
l18E7:		jz	l18e1			; 000018E7 74F8
l18E9:		mov	word ptr [2cceh],0			; 000018E9 C706CE2C0000
l18EF:		inc	byte ptr [2ccah]			; 000018EF FE06CA2C
l18F3:		mov	al,[2c9bh]			; 000018F3 A09B2C
l18F6:		cmp	al,0			; 000018F6 3C00
l18F8:		jz	l190e			; 000018F8 7414
l18FA:		dec	al			; 000018FA FEC8
l18FC:		mov	[2c9bh],al			; 000018FC A29B2C
l18FF:		jnz	l190e			; 000018FF 750D
l1901:		mov	bx,1f0h			; 00001901 BBF001
l1904:		and	byte ptr [bx+2a38h],0feh			; 00001904 80A7382AFE
l1909:		sub	bx,7ch			; 00001909 83EB7C
l190C:		jnz	l1904			; 0000190C 75F6
l190E:		dec	byte ptr [2ccbh]			; 0000190E FE0ECB2C
l1912:		jnz	l1919			; 00001912 7505
l1914:		mov	byte ptr [2ccbh],0eh			; 00001914 C606CB2C0E
l1919:		mov	bx,8			; 00001919 BB0800
l191C:		mov	si,1645h			; 0000191C BE4516
l191F:		cmp	byte ptr [2ccbh],7			; 0000191F 803ECB2C07
l1924:		jg	l1929			; 00001924 7F03
l1926:		add	si,10h			; 00001926 83C610
l1929:		mov	di,[bx+1623h]			; 00001929 8BBF2316
l192D:		mov	al,[di]			; 0000192D 8A05
l192F:		cmp	al,3			; 0000192F 3C03
l1931:		jnz	l1954			; 00001931 7521
l1933:		mov	cx,8			; 00001933 B90800
l1936:		mov	di,[bx+162bh]			; 00001936 8BBF2B16
l193A:		mov	ax,[2a2eh]			; 0000193A A12E2A
l193D:		sub	ax,di			; 0000193D 2BC7
l193F:		cmp	ax,1f5fh			; 0000193F 3D5F1F
l1942:		jz	l1954			; 00001942 7410
l1944:		mov	dx,1ffeh			; 00001944 BAFE1F
l1947:		movsw				; 00001947 A5
l1948:		add	di,dx			; 00001948 03FA
l194A:		neg	dx			; 0000194A F7DA
l194C:		add	dx,4ch			; 0000194C 83C24C
l194F:		loop	l1947		; 0000194F E2F6
l1951:		sub	si,10h			; 00001951 83EE10
l1954:		dec	bx			; 00001954 4B
l1955:		dec	bx			; 00001955 4B
l1956:		jnz	l1929			; 00001956 75D1
l1958:		mov	bx,1f0h			; 00001958 BBF001
l195B:		mov	cx,5			; 0000195B B90500
l195E:		mov	ax,[bx+2a2eh]			; 0000195E 8B872E2A
l1962:		mov	[bx+2a33h],ax			; 00001962 8987332A
l1966:		mov	al,[bx+2a35h]			; 00001966 8A87352A
l196A:		mov	[bx+2a36h],al			; 0000196A 8887362A
l196E:		sub	bx,7ch			; 0000196E 83EB7C
l1971:		loop	l195E		; 00001971 E2EB
l1973:		call	l216D			; 00001973 E8F707
l1976:		test	byte ptr [2a31h],1			; 00001976 F606312A01
l197B:		jnz	l19be			; 0000197B 7541
l197D:		test	byte ptr [2a30h],1			; 0000197D F606302A01
l1982:		jnz	l19be			; 00001982 753A
l1984:		mov	ah,0			; 00001984 B400
l1986:		mov	al,[2a30h]			; 00001986 A0302A
l1989:		sar	ax,1			; 00001989 D1F8
l198B:		mov	dx,1eh			; 0000198B BA1E00
l198E:		mul	dx			; 0000198E F7E2
l1990:		mov	bx,ax			; 00001990 8BD8
l1992:		mov	ax,[2a31h]			; 00001992 A1312A
l1995:		sar	ax,1			; 00001995 D1F8
l1997:		add	bx,ax			; 00001997 03D8
l1999:		cmp	byte ptr [bx+1673h],1			; 00001999 80BF731601
l199E:		jg	l19db			; 0000199E 7F3B
l19A0:		mov	al,[2cbch]			; 000019A0 A0BC2C
l19A3:		mov	ah,0			; 000019A3 B400
l19A5:		mov	si,ax			; 000019A5 8BF0
l19A7:		mov	al,[si+2cbdh]			; 000019A7 8A84BD2C
l19AB:		cbw				; 000019AB 98
l19AC:		mov	si,ax			; 000019AC 8BF0
l19AE:		cmp	byte ptr [bx+si+1673h],0			; 000019AE 80B8731600
l19B3:		jz	l19c1			; 000019B3 740C
l19B5:		mov	al,[2cbch]			; 000019B5 A0BC2C
l19B8:		mov	[2a2dh],al			; 000019B8 A22D2A
l19BB:		jmp	l1a57			; 000019BB E99900
l19BE:		jmp	l1a46			; 000019BE E98500
l19C1:		mov	al,[2a2dh]			; 000019C1 A02D2A
l19C4:		mov	ah,0			; 000019C4 B400
l19C6:		mov	si,ax			; 000019C6 8BF0
l19C8:		mov	al,[si+2cbdh]			; 000019C8 8A84BD2C
l19CC:		cbw				; 000019CC 98
l19CD:		mov	si,ax			; 000019CD 8BF0
l19CF:		cmp	byte ptr [bx+si+1673h],0			; 000019CF 80B8731600
l19D4:		jnz	l19bb			; 000019D4 75E5
l19D6:		jmp	l1aaf			; 000019D6 E9D600
l19D9:		jmp	l19a0			; 000019D9 EBC5
l19DB:		mov	ax,401h			; 000019DB B80104
l19DE:		call	l223A			; 000019DE E85908
l19E1:		mov	al,1			; 000019E1 B001
l19E3:		xchg	al,[bx+1673h]			; 000019E3 86877316
l19E7:		cmp	al,3			; 000019E7 3C03
l19E9:		jnz	l1a14			; 000019E9 7529
l19EB:		mov	byte ptr [2f91h],0x19			; 000019EB C606912F19
l19F0:		mov	ax,404h			; 000019F0 B80404
l19F3:		call	l223A			; 000019F3 E84408
l19F6:		mov	word ptr [2f8dh],0			; 000019F6 C7068D2F0000
l19FC:		mov	al,[2c9ah]			; 000019FC A09A2C
l19FF:		mov	[2c9bh],al			; 000019FF A29B2C
l1A02:		mov	si,1f0h			; 00001A02 BEF001
l1A05:		or	byte ptr [si+2a38h],1			; 00001A05 808C382A01
l1A0A:		xor	byte ptr [si+2a2dh],1			; 00001A0A 80B42D2A01
l1A0F:		sub	si,7ch			; 00001A0F 83EE7C
l1A12:		jnz	l1a05			; 00001A12 75F1
l1A14:		dec	byte ptr [2c99h]			; 00001A14 FE0E992C
l1A18:		jnz	l1a1b			; 00001A18 7501
l1A1A:		ret				; 00001A1A C3
l1A1B:		cld				; 00001A1B FC
l1A1C:		push	es			; 00001A1C 06
l1A1D:		push	ds			; 00001A1D 1E
l1A1E:		pop	es			; 00001A1E 07
l1A1F:		mov	ax,0			; 00001A1F B80000
l1A22:		mov	cx,8			; 00001A22 B90800
l1A25:		mov	di,2a7eh			; 00001A25 BF7E2A
l1A28:		stosw				; 00001A28 AB
l1A29:		inc	di			; 00001A29 47
l1A2A:		inc	di			; 00001A2A 47
l1A2B:		loop	l1A28		; 00001A2B E2FB
l1A2D:		pop	es			; 00001A2D 07
l1A2E:		mov	byte ptr [2f90h],2			; 00001A2E C606902F02
l1A33:		neg	byte ptr [2ccch]			; 00001A33 F61ECC2C
l1A37:		jg	l19d9			; 00001A37 7FA0
l1A39:		inc	byte ptr [2f90h]			; 00001A39 FE06902F
l1A3D:		mov	word ptr [2cceh],0x7c			; 00001A3D C706CE2C7C00
l1A43:		jmp	l1aaf			; 00001A43 EB6A
l1A45:		nop				; 00001A45 90
l1A46:		mov	al,[2a2dh]			; 00001A46 A02D2A
l1A49:		xor	al,[2cbch]			; 00001A49 3206BC2C
l1A4D:		test	al,2			; 00001A4D A802
l1A4F:		jnz	l1a57			; 00001A4F 7506
l1A51:		mov	al,[2cbch]			; 00001A51 A0BC2C
l1A54:		mov	[2a2dh],al			; 00001A54 A22D2A
l1A57:		mov	al,[2a2dh]			; 00001A57 A02D2A
l1A5A:		mov	ah,0			; 00001A5A B400
l1A5C:		mov	si,ax			; 00001A5C 8BF0
l1A5E:		shl	si,1			; 00001A5E D1E6
l1A60:		mov	ax,[si+2cc1h]			; 00001A60 8B84C12C
l1A64:		add	ax,[2a2eh]			; 00001A64 03062E2A
l1A68:		mov	[2a2eh],ax			; 00001A68 A32E2A
l1A6B:		mov	ax,si			; 00001A6B 8BC6
l1A6D:		test	ax,4			; 00001A6D A90400
l1A70:		jnz	l1a7d			; 00001A70 750B
l1A72:		dec	ax			; 00001A72 48
l1A73:		add	al,[2a30h]			; 00001A73 0206302A
l1A77:		mov	[2a30h],al			; 00001A77 A2302A
l1A7A:		jmp	l1a84			; 00001A7A EB08
l1A7C:		nop				; 00001A7C 90
l1A7D:		;sub	ax,5			; 00001A7D 2D0500
		db	2dh
		dw	5
l1A80:		add	[2a31h],al			; 00001A80 0006312A
l1A84:		mov	al,[2cc9h]			; 00001A84 A0C92C
l1A87:		inc	al			; 00001A87 FEC0
l1A89:		and	al,3			; 00001A89 2403
l1A8B:		mov	[2cc9h],al			; 00001A8B A2C92C
l1A8E:		mov	bx,si			; 00001A8E 8BDE
l1A90:		shl	bx,1			; 00001A90 D1E3
l1A92:		mov	ah,0			; 00001A92 B400
l1A94:		add	bx,ax			; 00001A94 03D8
l1A96:		shl	bx,1			; 00001A96 D1E3
l1A98:		mov	si,[bx+2c9ch]			; 00001A98 8BB79C2C
l1A9C:		add	si,1d61h			; 00001A9C 81C6611D
l1AA0:		mov	di,2a39h			; 00001AA0 BF392A
l1AA3:		mov	cx,0eh			; 00001AA3 B90E00
l1AA6:		push	es			; 00001AA6 06
l1AA7:		push	ds			; 00001AA7 1E
l1AA8:		pop	es			; 00001AA8 07
l1AA9:		cld				; 00001AA9 FC
l1AAA:		movsw				; 00001AAA A5
l1AAB:		movsw				; 00001AAB A5
l1AAC:		loop	l1AAA		; 00001AAC E2FC
l1AAE:		pop	es			; 00001AAE 07
l1AAF:		mov	bx,1f0h			; 00001AAF BBF001
l1AB2:		cmp	byte ptr [bx+2a37h],2			; 00001AB2 80BF372A02
l1AB7:		jl	l1ac1			; 00001AB7 7C08
l1AB9:		mov	byte ptr [bx+2a37h],1			; 00001AB9 C687372A01
l1ABE:		jmp	l1b65			; 00001ABE E9A400
l1AC1:		test	byte ptr [bx+2a31h],1			; 00001AC1 F687312A01
l1AC6:		jnz	l1b10			; 00001AC6 7548
l1AC8:		test	byte ptr [bx+2a30h],1			; 00001AC8 F687302A01
l1ACD:		jnz	l1b10			; 00001ACD 7541
l1ACF:		mov	byte ptr [2ccdh],0			; 00001ACF C606CD2C00
l1AD4:		mov	ah,0			; 00001AD4 B400
l1AD6:		mov	al,[bx+2a30h]			; 00001AD6 8A87302A
l1ADA:		sar	ax,1			; 00001ADA D1F8
l1ADC:		mov	dx,1eh			; 00001ADC BA1E00
l1ADF:		mul	dx			; 00001ADF F7E2
l1AE1:		mov	bp,ax			; 00001AE1 8BE8
l1AE3:		mov	ax,[bx+2a31h]			; 00001AE3 8B87312A
l1AE7:		sar	ax,1			; 00001AE7 D1F8
l1AE9:		add	bp,ax			; 00001AE9 03E8
l1AEB:		call	l1D5A			; 00001AEB E86C02
l1AEE:		cmp	[bx+2a2dh],al			; 00001AEE 38872D2A
l1AF2:		jz	l1b19			; 00001AF2 7425
l1AF4:		mov	dl,al			; 00001AF4 8AD0
l1AF6:		xchg	dl,[bx+2a2dh]			; 00001AF6 86972D2A
l1AFA:		cmp	byte ptr [bx+2a37h],1			; 00001AFA 80BF372A01
l1AFF:		jz	l1b19			; 00001AFF 7418
l1B01:		mov	[bx+2a2dh],dl			; 00001B01 88972D2A
l1B05:		mov	byte ptr [bx+2a37h],1			; 00001B05 C687372A01
l1B0A:		jmp	l1b65			; 00001B0A EB59
l1B0C:		nop				; 00001B0C 90
l1B0D:		jmp	l1b19			; 00001B0D EB0A
l1B0F:		nop				; 00001B0F 90
l1B10:		mov	al,[bx+2a2dh]			; 00001B10 8A872D2A
l1B14:		mov	byte ptr [2ccdh],1			; 00001B14 C606CD2C01
l1B19:		mov	ah,0			; 00001B19 B400
l1B1B:		mov	si,ax			; 00001B1B 8BF0
l1B1D:		shl	si,1			; 00001B1D D1E6
l1B1F:		mov	si,[si+2cc1h]			; 00001B1F 8BB4C12C
l1B23:		add	[bx+2a2eh],si			; 00001B23 01B72E2A
l1B27:		mov	ah,al			; 00001B27 8AE0
l1B29:		sar	ax,1			; 00001B29 D1F8
l1B2B:		cbw				; 00001B2B 98
l1B2C:		shl	ah,1			; 00001B2C D0E4
l1B2E:		inc	ah			; 00001B2E FEC4
l1B30:		neg	ah			; 00001B30 F6DC
l1B32:		and	al,7fh			; 00001B32 247F
l1B34:		mov	dl,al			; 00001B34 8AD0
l1B36:		mov	al,ah			; 00001B36 8AC4
l1B38:		mov	dh,0			; 00001B38 B600
l1B3A:		mov	di,dx			; 00001B3A 8BFA
l1B3C:		add	[bx+di+2a30h],al			; 00001B3C 0081302A
l1B40:		mov	byte ptr [bx+2a37h],0			; 00001B40 C687372A00
l1B45:		cmp	byte ptr [bx+2a38h],2			; 00001B45 80BF382A02
l1B4A:		jl	l1b57			; 00001B4A 7C0B
l1B4C:		cmp	byte ptr [bx+2a38h],6			; 00001B4C 80BF382A06
l1B51:		jnl	l1b57			; 00001B51 7D04
l1B53:		sub	[bx+di+2a30h],al			; 00001B53 2881302A
l1B57:		cmp	byte ptr [2ccdh],1			; 00001B57 803ECD2C01
l1B5C:		jz	l1b65			; 00001B5C 7407
l1B5E:		cmp	byte ptr [bx+2a38h],6			; 00001B5E 80BF382A06
l1B63:		jnl	l1b10			; 00001B63 7DAB
l1B65:		sub	bx,7ch			; 00001B65 83EB7C
l1B68:		jz	l1b6d			; 00001B68 7403
l1B6A:		jmp	l1ab2			; 00001B6A E945FF
l1B6D:		call	l1CD9			; 00001B6D E86901
l1B70:		mov	cx,5			; 00001B70 B90500
l1B73:		mov	bx,0			; 00001B73 BB0000
l1B76:		mov	al,[bx+2a30h]			; 00001B76 8A87302A
l1B7A:		cmp	al,0			; 00001B7A 3C00
l1B7C:		mov	ah,3ah			; 00001B7C B43A
l1B7E:		mov	dx,2440h			; 00001B7E BA4024
l1B81:		jl	l1b8c			; 00001B81 7C09
l1B83:		cmp	al,39h			; 00001B83 3C39
l1B85:		mov	ah,0c6h			; 00001B85 B4C6
l1B87:		mov	dx,0dbc0h			; 00001B87 BAC0DB
l1B8A:		jng	l1b96			; 00001B8A 7E0A
l1B8C:		add	al,ah			; 00001B8C 02C4
l1B8E:		mov	[bx+2a30h],al			; 00001B8E 8887302A
l1B92:		add	[bx+2a2eh],dx			; 00001B92 01972E2A
l1B96:		cmp	byte ptr [bx+2a37h],1			; 00001B96 80BF372A01
l1B9B:		jz	l1bc9			; 00001B9B 742C
l1B9D:		cmp	byte ptr [bx+2a31h],0x20			; 00001B9D 80BF312A20
l1BA2:		jnz	l1bb6			; 00001BA2 7512
l1BA4:		mov	byte ptr [bx+2a37h],2			; 00001BA4 C687372A02
l1BA9:		cmp	al,0ch			; 00001BA9 3C0C
l1BAB:		jl	l1bb6			; 00001BAB 7C09
l1BAD:		cmp	al,26h			; 00001BAD 3C26
l1BAF:		jg	l1bb6			; 00001BAF 7F05
l1BB1:		mov	byte ptr [bx+2a37h],0			; 00001BB1 C687372A00
l1BB6:		cmp	byte ptr [bx+2a38h],0			; 00001BB6 80BF382A00
l1BBB:		jz	l1bc9			; 00001BBB 740C
l1BBD:		cmp	byte ptr [bx+2a38h],6			; 00001BBD 80BF382A06
l1BC2:		jnl	l1bc9			; 00001BC2 7D05
l1BC4:		mov	byte ptr [bx+2a37h],2			; 00001BC4 C687372A02
l1BC9:		mov	ah,0			; 00001BC9 B400
l1BCB:		shl	ax,1			; 00001BCB D1E0
l1BCD:		shl	ax,1			; 00001BCD D1E0
l1BCF:		neg	ax			; 00001BCF F7D8
l1BD1:		add	ax,0cfh			; 00001BD1 05CF00
l1BD4:		;cmp	ax,0			; 00001BD4 3D0000
		db	3dh
		dw	0
l1BD7:		jl	l1be4			; 00001BD7 7C0B
l1BD9:		;cmp	ax,0eh			; 00001BD9 3D0E00
		db	3dh
		dw	0eh
l1BDC:		jng	l1be7			; 00001BDC 7E09
l1BDE:		mov	ax,0eh			; 00001BDE B80E00
l1BE1:		jmp	l1be7			; 00001BE1 EB04
l1BE3:		nop				; 00001BE3 90
l1BE4:		mov	ax,0			; 00001BE4 B80000
l1BE7:		mov	[bx+2a35h],al			; 00001BE7 8887352A
l1BEB:		add	bx,7ch			; 00001BEB 83C37C
l1BEE:		loop	l1B76		; 00001BEE E286
l1BF0:		call	l2321			; 00001BF0 E82E07
l1BF3:		call	l2278			; 00001BF3 E88206
l1BF6:		call	l1F5C			; 00001BF6 E86303
l1BF9:		cld				; 00001BF9 FC
l1BFA:		mov	bx,26ch			; 00001BFA BB6C02
l1BFD:		sub	bx,7ch			; 00001BFD 83EB7C
l1C00:		mov	si,2a71h			; 00001C00 BE712A
l1C03:		add	si,bx			; 00001C03 03F3
l1C05:		mov	dx,0e04ch			; 00001C05 BA4CE0
l1C08:		mov	bp,1ffch			; 00001C08 BDFC1F
l1C0B:		mov	di,[bx+2a33h]			; 00001C0B 8BBF332A
l1C0F:		mov	cl,[bx+2a36h]			; 00001C0F 8A8F362A
l1C13:		mov	ch,0			; 00001C13 B500
l1C15:		jcxz	l1c1f			; 00001C15 E308
l1C17:		movsw				; 00001C17 A5
l1C18:		movsw				; 00001C18 A5
l1C19:		add	di,dx			; 00001C19 03FA
l1C1B:		xchg	dx,bp			; 00001C1B 87D5
l1C1D:		loop	l1C17		; 00001C1D E2F8
l1C1F:		cmp	bx,[2cceh]			; 00001C1F 3B1ECE2C
l1C23:		jnz	l1bfd			; 00001C23 75D8
l1C25:		cmp	byte ptr [2f44h],0			; 00001C25 803E442F00
l1C2A:		jz	l1c2f			; 00001C2A 7403
l1C2C:		call	l2061			; 00001C2C E83204
l1C2F:		mov	bx,[2cceh]			; 00001C2F 8B1ECE2C
l1C33:		sub	bx,26ch			; 00001C33 81EB6C02
l1C37:		mov	bp,48h			; 00001C37 BD4800
l1C3A:		add	bx,7ch			; 00001C3A 83C37C
l1C3D:		mov	si,[bx+2c1eh]			; 00001C3D 8BB71E2C
l1C41:		mov	dx,0e04ch			; 00001C41 BA4CE0
l1C44:		mov	bp,1ffch			; 00001C44 BDFC1F
l1C47:		mov	di,2c61h			; 00001C47 BF612C
l1C4A:		add	di,bx			; 00001C4A 03FB
l1C4C:		mov	cx,0eh			; 00001C4C B90E00
l1C4F:		push	es			; 00001C4F 06
l1C50:		push	ds			; 00001C50 1E
l1C51:		pop	es			; 00001C51 07
l1C52:		pop	ds			; 00001C52 1F
l1C53:		movsw				; 00001C53 A5
l1C54:		movsw				; 00001C54 A5
l1C55:		add	si,dx			; 00001C55 03F2
l1C57:		xchg	dx,bp			; 00001C57 87D5
l1C59:		loop	l1C53		; 00001C59 E2F8
l1C5B:		push	es			; 00001C5B 06
l1C5C:		push	ds			; 00001C5C 1E
l1C5D:		pop	es			; 00001C5D 07
l1C5E:		pop	ds			; 00001C5E 1F
l1C5F:		mov	si,2c29h			; 00001C5F BE292C
l1C62:		add	si,bx			; 00001C62 03F3
l1C64:		mov	dx,0e04ch			; 00001C64 BA4CE0
l1C67:		mov	bp,1ffch			; 00001C67 BDFC1F
l1C6A:		mov	di,[bx+2c1eh]			; 00001C6A 8BBF1E2C
l1C6E:		mov	cl,[bx+2c25h]			; 00001C6E 8A8F252C
l1C72:		mov	ch,0			; 00001C72 B500
l1C74:		jcxz	l1c8f			; 00001C74 E319
l1C76:		mov	al,[es:di]			; 00001C76 268A05
l1C79:		and	al,0c0h			; 00001C79 24C0
l1C7B:		or	al,[si]			; 00001C7B 0A04
l1C7D:		inc	si			; 00001C7D 46
l1C7E:		stosb				; 00001C7E AA
l1C7F:		movsw				; 00001C7F A5
l1C80:		mov	al,[es:di]			; 00001C80 268A05
l1C83:		and	al,3			; 00001C83 2403
l1C85:		or	al,[si]			; 00001C85 0A04
l1C87:		inc	si			; 00001C87 46
l1C88:		stosb				; 00001C88 AA
l1C89:		add	di,dx			; 00001C89 03FA
l1C8B:		xchg	dx,bp			; 00001C8B 87D5
l1C8D:		loop	l1C76		; 00001C8D E2E7
l1C8F:		cmp	bx,0			; 00001C8F 83FB00
l1C92:		jnz	l1c3a			; 00001C92 75A6
l1C94:		mov	bx,1f0h			; 00001C94 BBF001
l1C97:		cmp	byte ptr [bx+2a38h],2			; 00001C97 80BF382A02
l1C9C:		jnl	l1cc2			; 00001C9C 7D24
l1C9E:		mov	ax,[bx+2a30h]			; 00001C9E 8B87302A
l1CA2:		sub	al,[2a30h]			; 00001CA2 2A06302A
l1CA6:		jnl	l1caa			; 00001CA6 7D02
l1CA8:		neg	al			; 00001CA8 F6D8
l1CAA:		sub	ah,[2a31h]			; 00001CAA 2A26312A
l1CAE:		jnl	l1cb2			; 00001CAE 7D02
l1CB0:		neg	ah			; 00001CB0 F6DC
l1CB2:		add	al,ah			; 00001CB2 02C4
l1CB4:		cmp	al,2			; 00001CB4 3C02
l1CB6:		jg	l1cc2			; 00001CB6 7F0A
l1CB8:		cmp	byte ptr [bx+2a38h],0			; 00001CB8 80BF382A00
l1CBD:		jz	l1cd8			; 00001CBD 7419
l1CBF:		call	l20B6			; 00001CBF E8F403
l1CC2:		sub	bx,7ch			; 00001CC2 83EB7C
l1CC5:		jnz	l1c97			; 00001CC5 75D0
l1CC7:		mov	di,1f3ch			; 00001CC7 BF3C1F
l1CCA:		mov	ax,0			; 00001CCA B80000
l1CCD:		cld				; 00001CCD FC
l1CCE:		stosw				; 00001CCE AB
l1CCF:		stosw				; 00001CCF AB
l1CD0:		sub	di,54h			; 00001CD0 83EF54
l1CD3:		stosw				; 00001CD3 AB
l1CD4:		stosw				; 00001CD4 AB
l1CD5:		jmp	l18db			; 00001CD5 E903FC
l1CD8:		ret				; 00001CD8 C3
l1CD9:		push	es			; 00001CD9 06
l1CDA:		push	ds			; 00001CDA 1E
l1CDB:		pop	es			; 00001CDB 07
l1CDC:		mov	bx,26ch			; 00001CDC BB6C02
l1CDF:		mov	bp,280h			; 00001CDF BD8002
l1CE2:		sub	bx,7ch			; 00001CE2 83EB7C
l1CE5:		sub	bp,0a0h			; 00001CE5 81EDA000
l1CE9:		mov	cx,8			; 00001CE9 B90800
l1CEC:		mov	al,[bx+2a2dh]			; 00001CEC 8A872D2A
l1CF0:		mov	ah,0			; 00001CF0 B400
l1CF2:		mov	si,ax			; 00001CF2 8BF0
l1CF4:		shl	si,1			; 00001CF4 D1E6
l1CF6:		shl	si,1			; 00001CF6 D1E6
l1CF8:		shl	si,1			; 00001CF8 D1E6
l1CFA:		shl	si,1			; 00001CFA D1E6
l1CFC:		shl	si,1			; 00001CFC D1E6
l1CFE:		add	si,20e1h			; 00001CFE 81C6E120
l1D02:		mov	ax,3c0h			; 00001D02 B8C003
l1D05:		cmp	byte ptr [bx+2a38h],6			; 00001D05 80BF382A06
l1D0A:		jnl	l1d29			; 00001D0A 7D1D
l1D0C:		mov	ax,bp			; 00001D0C 8BC5
l1D0E:		test	byte ptr [bx+2a38h],1			; 00001D0E F687382A01
l1D13:		jz	l1d29			; 00001D13 7414
l1D15:		mov	ax,280h			; 00001D15 B88002
l1D18:		cmp	byte ptr [2c9bh],0x46			; 00001D18 803E9B2C46
l1D1D:		ja	l1d29			; 00001D1D 770A
l1D1F:		cmp	byte ptr [2ccbh],8			; 00001D1F 803ECB2C08
l1D24:		jl	l1d29			; 00001D24 7C03
l1D26:		add	ax,0a0h			; 00001D26 05A000
l1D29:		mov	di,2a39h			; 00001D29 BF392A
l1D2C:		add	di,bx			; 00001D2C 03FB
l1D2E:		call	l1F10			; 00001D2E E8DF01
l1D31:		mov	si,2161h			; 00001D31 BE6121
l1D34:		mov	cx,4			; 00001D34 B90400
l1D37:		call	l1F10			; 00001D37 E8D601
l1D3A:		mov	si,[2ccah]			; 00001D3A 8B36CA2C
l1D3E:		;and	si,2			; 00001D3E 81E60200
		dw	0e681h
		dw	2
l1D42:		shl	si,1			; 00001D42 D1E6
l1D44:		shl	si,1			; 00001D44 D1E6
l1D46:		add	si,2171h			; 00001D46 81C67121
l1D4A:		mov	cx,2			; 00001D4A B90200
l1D4D:		call	l1F10			; 00001D4D E8C001
l1D50:		cmp	bp,0			; 00001D50 83FD00
l1D53:		jnz	l1ce2			; 00001D53 758D
l1D55:		pop	es			; 00001D55 07
l1D56:		ret				; 00001D56 C3
l1D57:		jmp	l1e2b			; 00001D57 E9D100
l1D5A:		push	es			; 00001D5A 06
l1D5B:		push	ds			; 00001D5B 1E
l1D5C:		pop	es			; 00001D5C 07
l1D5D:		mov	di,2d2ah			; 00001D5D BF2A2D
l1D60:		mov	al,1			; 00001D60 B001
l1D62:		mov	cx,4			; 00001D62 B90400
l1D65:		cld				; 00001D65 FC
l1D66:		rep	stosb			; 00001D66 F3AA
l1D68:		mov	al,[bx+2a38h]			; 00001D68 8A87382A
l1D6C:		sar	al,1			; 00001D6C D0F8
l1D6E:		jz	l1d57			; 00001D6E 74E7
l1D70:		dec	al			; 00001D70 FEC8
l1D72:		jnz	l1da9			; 00001D72 7535
l1D74:		mov	ax,[bx+2a2eh]			; 00001D74 8B872E2A
l1D78:		sub	ax,2e92h			; 00001D78 2D922E
l1D7B:		jnz	l1d95			; 00001D7B 7518
l1D7D:		sub	byte ptr [bx+2a38h],2			; 00001D7D 80AF382A02
l1D82:		mov	word ptr [bx+2a30h],0x2619			; 00001D82 C787302A1926
l1D88:		call	l1F01			; 00001D88 E87601
l1D8B:		rcl	ax,1			; 00001D8B D1D0
l1D8D:		mov	ax,0			; 00001D8D B80000
l1D90:		rcl	ax,1			; 00001D90 D1D0
l1D92:		jmp	l1eff			; 00001D92 E96A01
l1D95:		;cmp	ax,-1eh			; 00001D95 3DE2FF
		db	3dh
		dw	-1eh
l1D98:		jna	l1d9f			; 00001D98 7605
l1D9A:		mov	al,3			; 00001D9A B003
l1D9C:		jmp	l1eff			; 00001D9C E96001
l1D9F:		rcl	ax,1			; 00001D9F D1D0
l1DA1:		mov	ax,0			; 00001DA1 B80000
l1DA4:		rcl	ax,1			; 00001DA4 D1D0
l1DA6:		jmp	l1eff			; 00001DA6 E95601
l1DA9:		dec	al			; 00001DA9 FEC8
l1DAB:		jnz	l1df2			; 00001DAB 7545
l1DAD:		mov	al,[bx+2a2dh]			; 00001DAD 8A872D2A
l1DB1:		mov	ah,0			; 00001DB1 B400
l1DB3:		mov	si,ax			; 00001DB3 8BF0
l1DB5:		mov	dx,bx			; 00001DB5 8BD3
l1DB7:		mov	cx,0			; 00001DB7 B90000
l1DBA:		inc	cx			; 00001DBA 41
l1DBB:		sub	dx,7ch			; 00001DBB 83EA7C
l1DBE:		jnz	l1dba			; 00001DBE 75FA
l1DC0:		shl	cx,1			; 00001DC0 D1E1
l1DC2:		add	si,cx			; 00001DC2 03F1
l1DC4:		shl	si,1			; 00001DC4 D1E6
l1DC6:		mov	dx,[bx+2a2eh]			; 00001DC6 8B972E2A
l1DCA:		cmp	dx,[si+2d0ch]			; 00001DCA 3B940C2D
l1DCE:		jnz	l1def			; 00001DCE 751F
l1DD0:		xor	al,1			; 00001DD0 3401
l1DD2:		cmp	al,3			; 00001DD2 3C03
l1DD4:		jnz	l1def			; 00001DD4 7519
l1DD6:		test	byte ptr [bx+2a38h],1			; 00001DD6 F687382A01
l1DDB:		jnz	l1def			; 00001DDB 7512
l1DDD:		call	l1F01			; 00001DDD E82101
l1DE0:		cmp	ax,[2d27h]			; 00001DE0 3B06272D
l1DE4:		mov	al,3			; 00001DE4 B003
l1DE6:		jnc	l1def			; 00001DE6 7307
l1DE8:		sub	byte ptr [bx+2a38h],2			; 00001DE8 80AF382A02
l1DED:		jmp	l1d74			; 00001DED EB85
l1DEF:		jmp	l1eff			; 00001DEF E90D01
l1DF2:		cmp	word ptr [bx+2a30h],0x261a			; 00001DF2 81BF302A1A26
l1DF8:		jnz	l1e2b			; 00001DF8 7531
l1DFA:		sub	byte ptr [bx+2a38h],2			; 00001DFA 80AF382A02
l1DFF:		mov	dx,bx			; 00001DFF 8BD3
l1E01:		mov	cx,0			; 00001E01 B90000
l1E04:		inc	cx			; 00001E04 41
l1E05:		sub	dx,7ch			; 00001E05 83EA7C
l1E08:		jnz	l1e04			; 00001E08 75FA
l1E0A:		shl	cx,1			; 00001E0A D1E1
l1E0C:		shl	cx,1			; 00001E0C D1E1
l1E0E:		mov	si,cx			; 00001E0E 8BF1
l1E10:		mov	ax,[si+2d10h]			; 00001E10 8B84102D
l1E14:		mov	[bx+2a2eh],ax			; 00001E14 89872E2A
l1E18:		cmp	cx,0ch			; 00001E18 83F90C
l1E1B:		jnz	l1e22			; 00001E1B 7505
l1E1D:		sub	byte ptr [bx+2a38h],2			; 00001E1D 80AF382A02
l1E22:		mov	al,3			; 00001E22 B003
l1E24:		mov	[bx+2a2dh],al			; 00001E24 88872D2A
l1E28:		jmp	l1eff			; 00001E28 E9D400
l1E2B:		mov	al,[2d26h]			; 00001E2B A0262D
l1E2E:		mov	[2d29h],al			; 00001E2E A2292D
l1E31:		mov	dl,[bx+2a38h]			; 00001E31 8A97382A
l1E35:		mov	cl,dl			; 00001E35 8ACA
l1E37:		;xor	cx,1			; 00001E37 81F10100
		dw	0f181h
		dw	1
l1E3B:		;and	cx,1			; 00001E3B 81E10100
		dw	0e181h
		dw	1
l1E3F:		cmp	dl,6			; 00001E3F 80FA06
l1E42:		jl	l1e4c			; 00001E42 7C08
l1E44:		mov	byte ptr [2d29h],0x3c			; 00001E44 C606292D3C
l1E49:		mov	cx,1			; 00001E49 B90100
l1E4C:		mov	al,[2a30h]			; 00001E4C A0302A
l1E4F:		cmp	dl,6			; 00001E4F 80FA06
l1E52:		jl	l1e56			; 00001E52 7C02
l1E54:		mov	al,1ah			; 00001E54 B01A
l1E56:		sub	al,[bx+2a30h]			; 00001E56 2A87302A
l1E5A:		jcxz	l1e5e			; 00001E5A E302
l1E5C:		neg	al			; 00001E5C F6D8
l1E5E:		jz	l1e70			; 00001E5E 7410
l1E60:		rcl	al,1			; 00001E60 D0D0
l1E62:		mov	ax,0			; 00001E62 B80000
l1E65:		rcl	ax,1			; 00001E65 D1D0
l1E67:		mov	di,ax			; 00001E67 8BF8
l1E69:		mov	al,[2d29h]			; 00001E69 A0292D
l1E6C:		mov	[di+2d2ah],al			; 00001E6C 88852A2D
l1E70:		mov	al,[2a31h]			; 00001E70 A0312A
l1E73:		cmp	dl,6			; 00001E73 80FA06
l1E76:		jl	l1e7a			; 00001E76 7C02
l1E78:		mov	al,26h			; 00001E78 B026
l1E7A:		sub	al,[bx+2a31h]			; 00001E7A 2A87312A
l1E7E:		jcxz	l1e82			; 00001E7E E302
l1E80:		neg	al			; 00001E80 F6D8
l1E82:		jz	l1e94			; 00001E82 7410
l1E84:		rcl	al,1			; 00001E84 D0D0
l1E86:		mov	ax,1			; 00001E86 B80100
l1E89:		rcl	ax,1			; 00001E89 D1D0
l1E8B:		mov	di,ax			; 00001E8B 8BF8
l1E8D:		mov	al,[2d29h]			; 00001E8D A0292D
l1E90:		mov	[di+2d2ah],al			; 00001E90 88852A2D
l1E94:		mov	cx,4			; 00001E94 B90400
l1E97:		mov	di,cx			; 00001E97 8BF9
l1E99:		mov	al,[di+2cbch]			; 00001E99 8A85BC2C
l1E9D:		cbw				; 00001E9D 98
l1E9E:		mov	si,ax			; 00001E9E 8BF0
l1EA0:		cmp	byte ptr [ds:bp+si+1673h],0			; 00001EA0 3E80BA731600
l1EA6:		jnz	l1ead			; 00001EA6 7505
l1EA8:		mov	byte ptr [di+2d29h],0			; 00001EA8 C685292D00
l1EAD:		loop	l1E97		; 00001EAD E2E8
l1EAF:		mov	al,[bx+2a2dh]			; 00001EAF 8A872D2A
l1EB3:		mov	ah,0			; 00001EB3 B400
l1EB5:		mov	di,ax			; 00001EB5 8BF8
l1EB7:		cmp	byte ptr [bx+2a37h],1			; 00001EB7 80BF372A01
l1EBC:		jz	l1ed0			; 00001EBC 7412
l1EBE:		mov	ax,di			; 00001EBE 8BC7
l1EC0:		mov	ah,[bx+2a31h]			; 00001EC0 8AA7312A
l1EC4:		xor	ah,20h			; 00001EC4 80F420
l1EC7:		test	ax,0fffeh			; 00001EC7 A9FEFF
l1ECA:		jz	l1ed0			; 00001ECA 7404
l1ECC:		shl	byte ptr [di+2d2ah],1			; 00001ECC D0A52A2D
l1ED0:		;xor	di,1			; 00001ED0 81F70100
		dw	0f781h
		dw	1
l1ED4:		mov	byte ptr [di+2d2ah],0			; 00001ED4 C6852A2D00
l1ED9:		mov	cx,4			; 00001ED9 B90400
l1EDC:		mov	bp,0			; 00001EDC BD0000
l1EDF:		mov	si,2d2ah			; 00001EDF BE2A2D
l1EE2:		mov	ah,0			; 00001EE2 B400
l1EE4:		lodsb				; 00001EE4 AC
l1EE5:		add	bp,ax			; 00001EE5 03E8
l1EE7:		loop	l1EE4		; 00001EE7 E2FB
l1EE9:		call	l1F01			; 00001EE9 E81500
l1EEC:		mul	bp			; 00001EEC F7E5
l1EEE:		mov	si,2d2ah			; 00001EEE BE2A2D
l1EF1:		mov	ah,0			; 00001EF1 B400
l1EF3:		lodsb				; 00001EF3 AC
l1EF4:		sub	dx,ax			; 00001EF4 2BD0
l1EF6:		jnl	l1ef3			; 00001EF6 7DFB
l1EF8:		mov	ax,2d2bh			; 00001EF8 B82B2D
l1EFB:		neg	ax			; 00001EFB F7D8
l1EFD:		add	ax,si			; 00001EFD 03C6
l1EFF:		pop	es			; 00001EFF 07
l1F00:		ret				; 00001F00 C3
l1F01:		mov	ax,[2d24h]			; 00001F01 A1242D
l1F04:		mov	dx,98ddh			; 00001F04 BADD98
l1F07:		mul	dx			; 00001F07 F7E2
l1F09:		add	ax,0d5efh			; 00001F09 05EFD5
l1F0C:		mov	[2d24h],ax			; 00001F0C A3242D
l1F0F:		ret				; 00001F0F C3
l1F10:		add	si,ax			; 00001F10 03F0
l1F12:		cld				; 00001F12 FC
l1F13:		movsw				; 00001F13 A5
l1F14:		movsw				; 00001F14 A5
l1F15:		loop	l1F13		; 00001F15 E2FC
l1F17:		ret				; 00001F17 C3
l1F18:		mov	byte ptr [2f93h],0x18			; 00001F18 C606932F18
l1F1D:		mov	al,[6f0h]			; 00001F1D A0F006
l1F20:		mov	ah,0			; 00001F20 B400
l1F22:		inc	al			; 00001F22 FEC0
l1F24:		mov	[6f0h],al			; 00001F24 A2F006
l1F27:		mov	di,ax			; 00001F27 8BF8
l1F29:		shl	di,1			; 00001F29 D1E7
l1F2B:		shl	di,1			; 00001F2B D1E7
l1F2D:		add	di,ax			; 00001F2D 03F8
l1F2F:		shl	di,1			; 00001F2F D1E7
l1F31:		shl	di,1			; 00001F31 D1E7
l1F33:		shl	di,1			; 00001F33 D1E7
l1F35:		shl	di,1			; 00001F35 D1E7
l1F37:		shl	di,1			; 00001F37 D1E7
l1F39:		shl	di,1			; 00001F39 D1E7
l1F3B:		shl	di,1			; 00001F3B D1E7
l1F3D:		neg	di			; 00001F3D F7DF
l1F3F:		add	di,21bbh			; 00001F3F 81C7BB21
l1F43:		mov	si,1f59h			; 00001F43 BE591F
l1F46:		mov	dx,1ffch			; 00001F46 BAFC1F
l1F49:		mov	bp,0e04ch			; 00001F49 BD4CE0
l1F4C:		mov	cx,0eh			; 00001F4C B90E00
l1F4F:		cld				; 00001F4F FC
l1F50:		movsw				; 00001F50 A5
l1F51:		movsw				; 00001F51 A5
l1F52:		add	di,dx			; 00001F52 03FA
l1F54:		xchg	dx,bp			; 00001F54 87D5
l1F56:		loop	l1F50		; 00001F56 E2F8
l1F58:		ret				; 00001F58 C3
l1F59:		jmp	l1fea			; 00001F59 E98E00
l1F5C:		mov	byte ptr [2f44h],0			; 00001F5C C606442F00
l1F61:		cmp	byte ptr [2f43h],2			; 00001F61 803E432F02
l1F66:		jnz	l1f59			; 00001F66 75F1
l1F68:		cmp	word ptr [2a2eh],0x2e86			; 00001F68 813E2E2A862E
l1F6E:		jnz	l1f59			; 00001F6E 75E9
l1F70:		mov	byte ptr [2f92h],9			; 00001F70 C606922F09
l1F75:		mov	byte ptr [2f43h],1			; 00001F75 C606432F01
l1F7A:		mov	word ptr [2f3eh],0x3c			; 00001F7A C7063E2F3C00
l1F80:		push	es			; 00001F80 06
l1F81:		push	ds			; 00001F81 1E
l1F82:		pop	es			; 00001F82 07
l1F83:		mov	di,2f45h			; 00001F83 BF452F
l1F86:		mov	bx,[2f41h]			; 00001F86 8B1E412F
l1F8A:		mov	bp,3			; 00001F8A BD0300
l1F8D:		cmp	byte ptr [bx],0			; 00001F8D 803F00
l1F90:		jnz	l1fa4			; 00001F90 7512
l1F92:		mov	ax,0			; 00001F92 B80000
l1F95:		cld				; 00001F95 FC
l1F96:		stosw				; 00001F96 AB
l1F97:		stosw				; 00001F97 AB
l1F98:		inc	bx			; 00001F98 43
l1F99:		dec	bp			; 00001F99 4D
l1F9A:		add	di,1eh			; 00001F9A 83C71E
l1F9D:		cld				; 00001F9D FC
l1F9E:		stosw				; 00001F9E AB
l1F9F:		stosw				; 00001F9F AB
l1FA0:		stosw				; 00001FA0 AB
l1FA1:		sub	di,24h			; 00001FA1 83EF24
l1FA4:		mov	al,[bx]			; 00001FA4 8A07
l1FA6:		inc	bx			; 00001FA6 43
l1FA7:		mov	ah,0			; 00001FA7 B400
l1FA9:		mov	si,ax			; 00001FA9 8BF0
l1FAB:		shl	si,1			; 00001FAB D1E6
l1FAD:		shl	si,1			; 00001FAD D1E6
l1FAF:		shl	si,1			; 00001FAF D1E6
l1FB1:		add	si,2f06h			; 00001FB1 81C6062F
l1FB5:		mov	cx,4			; 00001FB5 B90400
l1FB8:		rep	movsw			; 00001FB8 F3A5
l1FBA:		mov	ax,0			; 00001FBA B80000
l1FBD:		stosw				; 00001FBD AB
l1FBE:		dec	bp			; 00001FBE 4D
l1FBF:		jnz	l1fa4			; 00001FBF 75E3
l1FC1:		mov	si,2f06h			; 00001FC1 BE062F
l1FC4:		mov	cx,4			; 00001FC4 B90400
l1FC7:		rep	movsw			; 00001FC7 F3A5
l1FC9:		mov	ax,0			; 00001FC9 B80000
l1FCC:		stosw				; 00001FCC AB
l1FCD:		pop	es			; 00001FCD 07
l1FCE:		sub	bx,3			; 00001FCE 83EB03
l1FD1:		mov	dx,3			; 00001FD1 BA0300
l1FD4:		mov	ah,dl			; 00001FD4 8AE2
l1FD6:		neg	ah			; 00001FD6 F6DC
l1FD8:		add	ah,5			; 00001FD8 80C405
l1FDB:		mov	al,[bx]			; 00001FDB 8A07
l1FDD:		call	l223A			; 00001FDD E85A02
l1FE0:		inc	bx			; 00001FE0 43
l1FE1:		dec	dx			; 00001FE1 4A
l1FE2:		jnz	l1fd4			; 00001FE2 75F0
l1FE4:		mov	byte ptr [2f44h],2			; 00001FE4 C606442F02
l1FE9:		ret				; 00001FE9 C3
l1FEA:		cmp	byte ptr [2f43h],0			; 00001FEA 803E432F00
l1FEF:		jnz	l2049			; 00001FEF 7558
l1FF1:		mov	al,[2c99h]			; 00001FF1 A0992C
l1FF4:		cmp	al,[2f40h]			; 00001FF4 3A06402F
l1FF8:		jz	l2002			; 00001FF8 7408
l1FFA:		cmp	al,0aah			; 00001FFA 3CAA
l1FFC:		jz	l2003			; 00001FFC 7405
l1FFE:		cmp	al,50h			; 00001FFE 3C50
l2000:		jz	l2003			; 00002000 7401
l2002:		ret				; 00002002 C3
l2003:		mov	[2f40h],al			; 00002003 A2402F
l2006:		mov	byte ptr [2f43h],2			; 00002006 C606432F02
l200B:		mov	word ptr [2f3eh],0x87			; 0000200B C7063E2F8700
l2011:		mov	byte ptr [2f44h],3			; 00002011 C606442F03
l2016:		mov	di,2f45h			; 00002016 BF452F
l2019:		mov	ax,[6f1h]			; 00002019 A1F106
l201C:		dec	ax			; 0000201C 48
l201D:		;cmp	ax,8			; 0000201D 3D0800
		db	3dh
		dw	8
l2020:		jl	l202f			; 00002020 7C0D
l2022:		call	l1F01			; 00002022 E8DCFE
l2025:		mov	al,0			; 00002025 B000
l2027:		rol	ax,1			; 00002027 D1C0
l2029:		rol	ax,1			; 00002029 D1C0
l202B:		rol	ax,1			; 0000202B D1C0
l202D:		mov	ah,0			; 0000202D B400
l202F:		mov	dx,3bh			; 0000202F BA3B00
l2032:		mul	dx			; 00002032 F7E2
l2034:		add	ax,2d2eh			; 00002034 052E2D
l2037:		mov	[2f41h],ax			; 00002037 A3412F
l203A:		mov	si,ax			; 0000203A 8BF0
l203C:		add	si,3			; 0000203C 83C603
l203F:		mov	cx,1ch			; 0000203F B91C00
l2042:		push	es			; 00002042 06
l2043:		push	ds			; 00002043 1E
l2044:		pop	es			; 00002044 07
l2045:		rep	movsw			; 00002045 F3A5
l2047:		pop	es			; 00002047 07
l2048:		ret				; 00002048 C3
l2049:		dec	word ptr [2f3eh]			; 00002049 FF0E3E2F
l204D:		jz	l2050			; 0000204D 7401
l204F:		ret				; 0000204F C3
l2050:		mov	byte ptr [2f43h],0			; 00002050 C606432F00
l2055:		mov	word ptr [2f3eh],0x10e			; 00002055 C7063E2F0E01
l205B:		mov	byte ptr [2f44h],1			; 0000205B C606442F01
l2060:		ret				; 00002060 C3
l2061:		cld				; 00002061 FC
l2062:		cmp	byte ptr [2f44h],2			; 00002062 803E442F02
l2067:		jg	l209e			; 00002067 7F35
l2069:		jz	l2083			; 00002069 7418
l206B:		mov	di,0de6h			; 0000206B BFE60D
l206E:		mov	ax,0			; 0000206E B80000
l2071:		mov	cx,14h			; 00002071 B91400
l2074:		mov	dx,1ffch			; 00002074 BAFC1F
l2077:		mov	bp,0e04ch			; 00002077 BD4CE0
l207A:		stosw				; 0000207A AB
l207B:		stosw				; 0000207B AB
l207C:		add	di,dx			; 0000207C 03FA
l207E:		xchg	dx,bp			; 0000207E 87D5
l2080:		loop	l207A		; 00002080 E2F8
l2082:		ret				; 00002082 C3
l2083:		mov	di,0de6h			; 00002083 BFE60D
l2086:		mov	si,2f45h			; 00002086 BE452F
l2089:		mov	cx,14h			; 00002089 B91400
l208C:		mov	dx,1ffch			; 0000208C BAFC1F
l208F:		mov	bp,0e04ch			; 0000208F BD4CE0
l2092:		mov	al,0			; 00002092 B000
l2094:		stosb				; 00002094 AA
l2095:		movsw				; 00002095 A5
l2096:		stosb				; 00002096 AA
l2097:		add	di,dx			; 00002097 03FA
l2099:		xchg	dx,bp			; 00002099 87D5
l209B:		loop	l2094		; 0000209B E2F7
l209D:		ret				; 0000209D C3
l209E:		mov	di,2e86h			; 0000209E BF862E
l20A1:		mov	si,2f45h			; 000020A1 BE452F
l20A4:		mov	cx,0eh			; 000020A4 B90E00
l20A7:		mov	dx,0e04ch			; 000020A7 BA4CE0
l20AA:		mov	bp,1ffch			; 000020AA BDFC1F
l20AD:		movsw				; 000020AD A5
l20AE:		movsw				; 000020AE A5
l20AF:		add	di,dx			; 000020AF 03FA
l20B1:		xchg	dx,bp			; 000020B1 87D5
l20B3:		loop	l20AD		; 000020B3 E2F8
l20B5:		ret				; 000020B5 C3
l20B6:		cld				; 000020B6 FC
l20B7:		mov	di,[2f8dh]			; 000020B7 8B3E8D2F
l20BB:		mov	al,[di+25f1h]			; 000020BB 8A85F125
l20BF:		mov	ah,3			; 000020BF B403
l20C1:		call	l223A			; 000020C1 E87601
l20C4:		mov	byte ptr [bx+2a38h],6			; 000020C4 C687382A06
l20C9:		add	si,bx			; 000020C9 03F3
l20CB:		mov	di,[bx+2a2eh]			; 000020CB 8BBF2E2A
l20CF:		mov	cl,[bx+2a35h]			; 000020CF 8A8F352A
l20D3:		call	l2154			; 000020D3 E87E00
l20D6:		mov	di,[2a2eh]			; 000020D6 8B3E2E2A
l20DA:		mov	cl,[2a35h]			; 000020DA 8A0E352A
l20DE:		call	l2154			; 000020DE E87300
l20E1:		call	l2112			; 000020E1 E82E00
l20E4:		mov	al,2			; 000020E4 B002
l20E6:		out	42h,al			; 000020E6 E642
l20E8:		xor	al,al			; 000020E8 32C0
l20EA:		out	42h,al			; 000020EA E642
l20EC:		mov	si,2ff6h			; 000020EC BEF62F
l20EF:		mov	bp,18h			; 000020EF BD1800
l20F2:		cld				; 000020F2 FC
l20F3:		lodsw				; 000020F3 AD
l20F4:		cmp	byte ptr [2fa0h],0			; 000020F4 803EA02F00
l20F9:		jl	l2101			; 000020F9 7C06
l20FB:		out	42h,al			; 000020FB E642
l20FD:		mov	al,ah			; 000020FD 8AC4
l20FF:		out	42h,al			; 000020FF E642
l2101:		mov	cx,140ah			; 00002101 B90A14
l2104:		loop	l2104		; 00002104 E2FE
l2106:		dec	bp			; 00002106 4D
l2107:		jnz	l20f3			; 00002107 75EA
l2109:		call	l2112			; 00002109 E80600
l210C:		add	word ptr [2f8dh],21h	; 0000210C 83068D2F21
l2111:		ret				; 00002111 C3
l2112:		mov	dx,0e04ch			; 00002112 BA4CE0
l2115:		mov	bp,1ffch			; 00002115 BDFC1F
l2118:		mov	di,[2a2eh]			; 00002118 8B3E2E2A
l211C:		add	di,[bx+2a2eh]			; 0000211C 03BF2E2A
l2120:		sar	di,1			; 00002120 D1FF
l2122:		add	di,0a0h			; 00002122 81C7A000
l2126:		mov	si,25f2h			; 00002126 BEF225
l2129:		add	si,[2f8dh]			; 00002129 03368D2F
l212D:		mov	cl,[2a35h]			; 0000212D 8A0E352A
l2131:		add	cl,[bx+2a35h]			; 00002131 028F352A
l2135:		sar	cl,1			; 00002135 D0F9
l2137:		mov	ch,0			; 00002137 B500
l2139:		jcxz	l2153			; 00002139 E318
l213B:		cmp	cx,8			; 0000213B 83F908
l213E:		jng	l2143			; 0000213E 7E03
l2140:		mov	cx,8			; 00002140 B90800
l2143:		lodsw				; 00002143 AD
l2144:		xor	ax,[es:di]			; 00002144 263305
l2147:		stosw				; 00002147 AB
l2148:		lodsw				; 00002148 AD
l2149:		xor	ax,[es:di]			; 00002149 263305
l214C:		stosw				; 0000214C AB
l214D:		add	di,dx			; 0000214D 03FA
l214F:		xchg	dx,bp			; 0000214F 87D5
l2151:		loop	l2143		; 00002151 E2F0
l2153:		ret				; 00002153 C3
l2154:		mov	ax,0			; 00002154 B80000
l2157:		mov	dx,0e04ch			; 00002157 BA4CE0
l215A:		mov	bp,1ffch			; 0000215A BDFC1F
l215D:		mov	ch,0			; 0000215D B500
l215F:		jcxz	l2169			; 0000215F E308
l2161:		stosw				; 00002161 AB
l2162:		stosw				; 00002162 AB
l2163:		add	di,dx			; 00002163 03FA
l2165:		xchg	dx,bp			; 00002165 87D5
l2167:		loop	l2161		; 00002167 E2F8
l2169:		ret				; 00002169 C3
l216A:		pop	ax			; 0000216A 58
l216B:		pop	ax			; 0000216B 58
l216C:		ret				; 0000216C C3
l216D:		mov	ah,1			; 0000216D B401
l216F:		int	16h			; 0000216F CD16
l2171:		jz	l21cf			; 00002171 745C
l2173:		mov	ah,0			; 00002173 B400
l2175:		int	16h			; 00002175 CD16
l2177:		;cmp	ax,0			; 00002177 3D0000
		db	3dh
		dw	0
l217A:		jz	l216a			; 0000217A 74EE
l217C:		cmp	al,13h			; 0000217C 3C13
l217E:		jnz	l2184			; 0000217E 7504
l2180:		neg	byte ptr [2fa0h]			; 00002180 F61EA02F
l2184:		cmp	byte ptr [2f8fh],1			; 00002184 803E8F2F01
l2189:		jz	l21cf			; 00002189 7444
l218B:		and	al,0dfh			; 0000218B 24DF
l218D:		mov	bl,0			; 0000218D B300
l218F:		cmp	ah,48h			; 0000218F 80FC48
l2192:		jz	l21ca			; 00002192 7436
l2194:		cmp	al,45h			; 00002194 3C45
l2196:		jz	l21ca			; 00002196 7432
l2198:		cmp	al,49h			; 00002198 3C49
l219A:		jz	l21ca			; 0000219A 742E
l219C:		inc	bl			; 0000219C FEC3
l219E:		cmp	ah,50h			; 0000219E 80FC50
l21A1:		jz	l21ca			; 000021A1 7427
l21A3:		cmp	al,4ah			; 000021A3 3C4A
l21A5:		jz	l21ca			; 000021A5 7423
l21A7:		cmp	al,44h			; 000021A7 3C44
l21A9:		jz	l21ca			; 000021A9 741F
l21AB:		inc	bl			; 000021AB FEC3
l21AD:		cmp	ah,4bh			; 000021AD 80FC4B
l21B0:		jz	l21ca			; 000021B0 7418
l21B2:		cmp	al,41h			; 000021B2 3C41
l21B4:		jz	l21ca			; 000021B4 7414
l21B6:		cmp	al,4bh			; 000021B6 3C4B
l21B8:		jz	l21ca			; 000021B8 7410
l21BA:		inc	bl			; 000021BA FEC3
l21BC:		cmp	ah,4dh			; 000021BC 80FC4D
l21BF:		jz	l21ca			; 000021BF 7409
l21C1:		cmp	al,4ch			; 000021C1 3C4C
l21C3:		jz	l21ca			; 000021C3 7405
l21C5:		cmp	al,53h			; 000021C5 3C53
l21C7:		jz	l21ca			; 000021C7 7401
l21C9:		ret				; 000021C9 C3
l21CA:		mov	[2cbch],bl			; 000021CA 881EBC2C
l21CE:		ret				; 000021CE C3
l21CF:		cmp	byte ptr [2f8fh],1			; 000021CF 803E8F2F01
l21D4:		jnz	l21c9			; 000021D4 75F3
l21D6:		mov	al,[2a2dh]			; 000021D6 A02D2A
l21D9:		mov	[2cbch],al			; 000021D9 A2BC2C
l21DC:		cli				; 000021DC FA
l21DD:		mov	dx,201h			; 000021DD BA0102
l21E0:		mov	cx,190h			; 000021E0 B99001
l21E3:		mov	al,0ffh			; 000021E3 B0FF
l21E5:		mov	ah,1			; 000021E5 B401
l21E7:		out	dx,al			; 000021E7 EE
l21E8:		in	al,dx			; 000021E8 EC
l21E9:		and	al,ah			; 000021E9 22C4
l21EB:		loopne	l21E8			; 000021EB E0FB
l21ED:		mov	bx,cx			; 000021ED 8BD9
l21EF:		jcxz	l21f6			; 000021EF E305
l21F1:		nop				; 000021F1 90
l21F2:		nop				; 000021F2 90
l21F3:		nop				; 000021F3 90
l21F4:		loop	l21F1		; 000021F4 E2FB
l21F6:		add	bx,0fecah			; 000021F6 81C3CAFE
l21FA:		mov	cx,190h			; 000021FA B99001
l21FD:		mov	al,0ffh			; 000021FD B0FF
l21FF:		mov	ah,2			; 000021FF B402
l2201:		out	dx,al			; 00002201 EE
l2202:		in	al,dx			; 00002202 EC
l2203:		and	al,ah			; 00002203 22C4
l2205:		loopne	l2202			; 00002205 E0FB
l2207:		sti				; 00002207 FB
l2208:		add	cx,0febeh			; 00002208 81C1BEFE
l220C:		neg	cx			; 0000220C F7D9
l220E:		mov	dx,cx			; 0000220E 8BD1
l2210:		add	cx,bx			; 00002210 03CB
l2212:		mov	si,cx			; 00002212 8BF1
l2214:		jnl	l2218			; 00002214 7D02
l2216:		neg	si			; 00002216 F7DE
l2218:		sub	dx,bx			; 00002218 2BD3
l221A:		mov	di,dx			; 0000221A 8BFA
l221C:		jnl	l2220			; 0000221C 7D02
l221E:		neg	di			; 0000221E F7DF
l2220:		add	si,di			; 00002220 03F7
l2222:		cmp	si,51h			; 00002222 83FE51
l2225:		jl	l21c9			; 00002225 7CA2
l2227:		mov	ax,0			; 00002227 B80000
l222A:		rcl	cx,1			; 0000222A D1D1
l222C:		rcl	ax,1			; 0000222C D1D0
l222E:		rcl	dx,1			; 0000222E D1D2
l2230:		rcl	ax,1			; 00002230 D1D0
l2232:		inc	ax			; 00002232 40
l2233:		;and	ax,3			; 00002233 250300
		db	25h
		dw	3
l2236:		mov	[2cbch],al			; 00002236 A2BC2C
l2239:		ret				; 00002239 C3
l223A:		push	es			; 0000223A 06
l223B:		push	ds			; 0000223B 1E
l223C:		pop	es			; 0000223C 07
l223D:		std				; 0000223D FD
l223E:		lea	di,[2f7eh]			; 0000223E 8D3E7E2F
l2242:		mov	cl,ah			; 00002242 8ACC
l2244:		mov	ch,0			; 00002244 B500
l2246:		add	di,cx			; 00002246 03F9
l2248:		add	al,[di]			; 00002248 0205
l224A:		mov	ah,0ffh			; 0000224A B4FF
l224C:		inc	ah			; 0000224C FEC4
l224E:		sub	al,0ah			; 0000224E 2C0A
l2250:		jnl	l224c			; 00002250 7DFA
l2252:		add	al,0ah			; 00002252 040A
l2254:		stosb				; 00002254 AA
l2255:		mov	al,ah			; 00002255 8AC4
l2257:		cmp	al,0			; 00002257 3C00
l2259:		loopne	l2248			; 00002259 E0ED
l225B:		cld				; 0000225B FC
l225C:		pop	es			; 0000225C 07
l225D:		mov	si,di			; 0000225D 8BF7
l225F:		mov	ax,2f7eh			; 0000225F B87E2F
l2262:		sub	ax,di			; 00002262 2BC7
l2264:		jnz	l2277			; 00002264 7511
l2266:		lodsb				; 00002266 AC
l2267:		cmp	al,0			; 00002267 3C00
l2269:		jnz	l2277			; 00002269 750C
l226B:		cmp	byte ptr [si],1			; 0000226B 803C01
l226E:		jnz	l2277			; 0000226E 7507
l2270:		push	si			; 00002270 56
l2271:		push	dx			; 00002271 52
l2272:		call	l1F18			; 00002272 E8A3FC
l2275:		pop	dx			; 00002275 5A
l2276:		pop	si			; 00002276 5E
l2277:		ret				; 00002277 C3
l2278:		cld				; 00002278 FC
l2279:		push	es			; 00002279 06
l227A:		push	ds			; 0000227A 1E
l227B:		pop	es			; 0000227B 07
l227C:		lea	si,[2f7eh]			; 0000227C 8D367E2F
l2280:		lea	di,[2f88h]			; 00002280 8D3E882F
l2284:		mov	cx,5			; 00002284 B90500
l2287:		rep	movsb			; 00002287 F3A4
l2289:		pop	es			; 00002289 07
l228A:		mov	di,280h			; 0000228A BF8002
l228D:		call	l22C4			; 0000228D E83400
l2290:		push	es			; 00002290 06
l2291:		push	ds			; 00002291 1E
l2292:		pop	es			; 00002292 07
l2293:		lea	si,[2f7eh]			; 00002293 8D367E2F
l2297:		lea	di,[2f83h]			; 00002297 8D3E832F
l229B:		mov	cx,5			; 0000229B B90500
l229E:		repe	cmpsb			; 0000229E F3A6
l22A0:		jz	l22c2			; 000022A0 7420
l22A2:		dec	di			; 000022A2 4F
l22A3:		dec	si			; 000022A3 4E
l22A4:		mov	al,[di]			; 000022A4 8A05
l22A6:		cmp	al,[si]			; 000022A6 3A04
l22A8:		jg	l22c2			; 000022A8 7F18
l22AA:		inc	cx			; 000022AA 41
l22AB:		rep	movsb			; 000022AB F3A4
l22AD:		lea	si,[2f83h]			; 000022AD 8D36832F
l22B1:		lea	di,[2f88h]			; 000022B1 8D3E882F
l22B5:		mov	cx,5			; 000022B5 B90500
l22B8:		rep	movsb			; 000022B8 F3A4
l22BA:		pop	es			; 000022BA 07
l22BB:		mov	di,0a00h			; 000022BB BF000A
l22BE:		call	l22C4			; 000022BE E80300
l22C1:		ret				; 000022C1 C3
l22C2:		pop	es			; 000022C2 07
l22C3:		ret				; 000022C3 C3
l22C4:		mov	byte ptr [2f7dh],1			; 000022C4 C6067D2F01
l22C9:		mov	bx,0			; 000022C9 BB0000
l22CC:		mov	al,[bx+2f88h]			; 000022CC 8A87882F
l22D0:		cmp	al,0			; 000022D0 3C00
l22D2:		jz	l22d9			; 000022D2 7405
l22D4:		mov	byte ptr [2f7dh],0			; 000022D4 C6067D2F00
l22D9:		cmp	byte ptr [2f7dh],0			; 000022D9 803E7D2F00
l22DE:		jz	l22f6			; 000022DE 7416
l22E0:		mov	dx,1ffeh			; 000022E0 BAFE1F
l22E3:		mov	bp,0e04eh			; 000022E3 BD4EE0
l22E6:		mov	cx,8			; 000022E6 B90800
l22E9:		mov	ax,0			; 000022E9 B80000
l22EC:		stosw				; 000022EC AB
l22ED:		add	di,dx			; 000022ED 03FA
l22EF:		xchg	dx,bp			; 000022EF 87D5
l22F1:		loop	l22EC		; 000022F1 E2F9
l22F3:		jmp	l2316			; 000022F3 EB21
l22F5:		nop				; 000022F5 90
l22F6:		mov	dx,1ffeh			; 000022F6 BAFE1F
l22F9:		mov	bp,0e04eh			; 000022F9 BD4EE0
l22FC:		mov	cx,8			; 000022FC B90800
l22FF:		mov	ah,0			; 000022FF B400
l2301:		mov	si,ax			; 00002301 8BF0
l2303:		shl	si,1			; 00002303 D1E6
l2305:		shl	si,1			; 00002305 D1E6
l2307:		shl	si,1			; 00002307 D1E6
l2309:		shl	si,1			; 00002309 D1E6
l230B:		add	si,2541h			; 0000230B 81C64125
l230F:		movsw				; 0000230F A5
l2310:		add	di,dx			; 00002310 03FA
l2312:		xchg	dx,bp			; 00002312 87D5
l2314:		loop	l230F		; 00002314 E2F9
l2316:		add	di,0fec2h			; 00002316 81C7C2FE
l231A:		inc	bx			; 0000231A 43
l231B:		cmp	bx,5			; 0000231B 83FB05
l231E:		jl	l22cc			; 0000231E 7CAC
l2320:		ret				; 00002320 C3
l2321:		push	es			; 00002321 06
l2322:		mov	ax,ds			; 00002322 8CD8
l2324:		mov	es,ax			; 00002324 8EC0
l2326:		mov	cx,8			; 00002326 B90800
l2329:		mov	di,2f90h			; 00002329 BF902F
l232C:		mov	si,0			; 0000232C BE0000
l232F:		mov	ah,0			; 0000232F B400
l2331:		cld				; 00002331 FC
l2332:		mov	al,0			; 00002332 B000
l2334:		repe	scasb			; 00002334 F3AE
l2336:		jz	l2348			; 00002336 7410
l2338:		mov	al,[di-1]			; 00002338 8A45FF
l233B:		dec	al			; 0000233B FEC8
l233D:		mov	ah,al			; 0000233D 8AE0
l233F:		mov	[di-1],al			; 0000233F 8845FF
l2342:		mov	si,di			; 00002342 8BF7
l2344:		jcxz	l2348			; 00002344 E302
l2346:		jmp	l2332			; 00002346 EBEA
l2348:		pop	es			; 00002348 07
l2349:		cmp	si,0			; 00002349 83FE00
l234C:		jz	l2360			; 0000234C 7412
l234E:		mov	bx,2f90h			; 0000234E BB902F
l2351:		sub	si,bx			; 00002351 2BF3
l2353:		shl	si,1			; 00002353 D1E6
l2355:		cmp	byte ptr [2fa0h],0	; 00002355 803EA02F00
l235A:		jl	l2360			; 0000235A 7C04
l235C:		jmp	word ptr [si+2f96h]		; 0000235C FFA4962F
l2360:		mov	ax,2			; 00002360 B80200
l2363:		out	42h,al			; 00002363 E642
l2365:		mov	al,ah			; 00002365 8AC4
l2367:		out	42h,al			; 00002367 E642
l2369:		ret				; 00002369 C3
l236A:		test	ah,1			; 0000236A F6C401
l236D:		jz	l2360			; 0000236D 74F1
l236F:		mov	ax,190h			; 0000236F B89001
l2372:		out	42h,al			; 00002372 E642
l2374:		mov	al,ah			; 00002374 8AC4
l2376:		out	42h,al			; 00002376 E642
l2378:		ret				; 00002378 C3
l2379:		mov	bl,ah			; 00002379 8ADC
l237B:		mov	bh,0			; 0000237B B700
l237D:		shl	bx,1			; 0000237D D1E3
l237F:		mov	ax,[bx+2fa2h]			; 0000237F 8B87A22F
l2383:		out	42h,al			; 00002383 E642
l2385:		mov	al,ah			; 00002385 8AC4
l2387:		out	42h,al			; 00002387 E642
l2389:		ret				; 00002389 C3
l238A:		mov	bl,ah			; 0000238A 8ADC
l238C:		mov	bh,0			; 0000238C B700
l238E:		shl	bx,1			; 0000238E D1E3
l2390:		mov	ax,[bx+2fc4h]			; 00002390 8B87C42F
l2394:		out	42h,al			; 00002394 E642
l2396:		mov	al,ah			; 00002396 8AC4
l2398:		out	42h,al			; 00002398 E642
l239A:		ret				; 0000239A C3
l239B:		mov	al,[2fa1h]			; 0000239B A0A12F
l239E:		inc	al			; 0000239E FEC0
l23A0:		cmp	al,8			; 000023A0 3C08
l23A2:		jl	l23a6			; 000023A2 7C02
l23A4:		mov	al,0			; 000023A4 B000
l23A6:		mov	[2fa1h],al			; 000023A6 A2A12F
l23A9:		mov	bl,al			; 000023A9 8AD8
l23AB:		mov	bh,0			; 000023AB B700
l23AD:		shl	bx,1			; 000023AD D1E3
l23AF:		mov	ax,[bx+2fb4h]			; 000023AF 8B87B42F
l23B3:		out	42h,al			; 000023B3 E642
l23B5:		mov	al,ah			; 000023B5 8AC4
l23B7:		out	42h,al			; 000023B7 E642
l23B9:		ret				; 000023B9 C3

bootstrap3	endp

		; Align to a paragraph, but with 0's, not NOPs.
l23ba		dw	3 dup (0)		; 000023BA 00 X06

_TRK1_TEXT	ends

_TRK1_DATA	segment para public 'DATA'
		org	0

d0000		db	000h	; 00000000b . 23c0 00
d0001		db	000h	; 00000000b . 23c1 00
d0002		db	03fh	; 00111111b ? 23c2 3f
d0003		db	0ffh	; 11111111b . 23c3 ff
d0004		db	0f0h	; 11110000b . 23c4 f0
d0005		db	000h	; 00000000b . 23c5 00
d0006		db	000h	; 00000000b . 23c6 00
d0007		db	000h	; 00000000b . 23c7 00
d0008		db	000h	; 00000000b . 23c8 00
d0009		db	000h	; 00000000b . 23c9 00
d000a		db	003h	; 00000011b . 23ca 03
d000b		db	0ffh	; 11111111b . 23cb ff
d000c		db	0ffh	; 11111111b . 23cc ff
d000d		db	0ffh	; 11111111b . 23cd ff
d000e		db	000h	; 00000000b . 23ce 00
d000f		db	000h	; 00000000b . 23cf 00
d0010		db	000h	; 00000000b . 23d0 00
d0011		db	000h	; 00000000b . 23d1 00
d0012		db	000h	; 00000000b . 23d2 00
d0013		db	03fh	; 00111111b ? 23d3 3f
d0014		db	0ffh	; 11111111b . 23d4 ff
d0015		db	0ffh	; 11111111b . 23d5 ff
d0016		db	0ffh	; 11111111b . 23d6 ff
d0017		db	0c0h	; 11000000b . 23d7 c0
d0018		db	000h	; 00000000b . 23d8 00
d0019		db	000h	; 00000000b . 23d9 00
d001a		db	000h	; 00000000b . 23da 00
d001b		db	000h	; 00000000b . 23db 00
d001c		db	0ffh	; 11111111b . 23dc ff
d001d		db	0ffh	; 11111111b . 23dd ff
d001e		db	0ffh	; 11111111b . 23de ff
d001f		db	0ffh	; 11111111b . 23df ff
d0020		db	0f0h	; 11110000b . 23e0 f0
d0021		db	000h	; 00000000b . 23e1 00
d0022		db	000h	; 00000000b . 23e2 00
d0023		db	000h	; 00000000b . 23e3 00
d0024		db	000h	; 00000000b . 23e4 00
d0025		db	0ffh	; 11111111b . 23e5 ff
d0026		db	0ffh	; 11111111b . 23e6 ff
d0027		db	0ffh	; 11111111b . 23e7 ff
d0028		db	0ffh	; 11111111b . 23e8 ff
d0029		db	0f0h	; 11110000b . 23e9 f0
d002a		db	000h	; 00000000b . 23ea 00
d002b		db	000h	; 00000000b . 23eb 00
d002c		db	000h	; 00000000b . 23ec 00
d002d		db	003h	; 00000011b . 23ed 03
d002e		db	0ffh	; 11111111b . 23ee ff
d002f		db	0ffh	; 11111111b . 23ef ff
d0030		db	0cfh	; 11001111b . 23f0 cf
d0031		db	0ffh	; 11111111b . 23f1 ff
d0032		db	0fch	; 11111100b . 23f2 fc
d0033		db	000h	; 00000000b . 23f3 00
d0034		db	000h	; 00000000b . 23f4 00
d0035		db	000h	; 00000000b . 23f5 00
d0036		db	003h	; 00000011b . 23f6 03
d0037		db	0ffh	; 11111111b . 23f7 ff
d0038		db	0ffh	; 11111111b . 23f8 ff
d0039		db	0cfh	; 11001111b . 23f9 cf
d003a		db	0ffh	; 11111111b . 23fa ff
d003b		db	0fch	; 11111100b . 23fb fc
d003c		db	000h	; 00000000b . 23fc 00
d003d		db	000h	; 00000000b . 23fd 00
d003e		db	000h	; 00000000b . 23fe 00
d003f		db	003h	; 00000011b . 23ff 03

_TRK1_DATA	ends


_TRK2_SCTR1	segment	para public 'DATA'
		; Sector 1                    2400 F6 X0200
		db	512 dup (246)
_TRK2_SCTR1	ends

_TRK2_DATA	segment	para public 'DATA'
		org	40h

d0040		db	0ffh	; 11111111b . 02600 ff
d0041		db	0ffh	; 11111111b . 02601 ff
d0042		db	0cfh	; 11001111b . 02602 cf
d0043		db	0ffh	; 11111111b . 02603 ff
d0044		db	0ffh	; 11111111b . 02604 ff
d0045		db	000h	; 00000000b . 02605 00
d0046		db	000h	; 00000000b . 02606 00
d0047		db	000h	; 00000000b . 02607 00
d0048		db	003h	; 00000011b . 02608 03
d0049		db	0ffh	; 11111111b . 02609 ff
d004a		db	0ffh	; 11111111b . 0260a ff
d004b		db	0cfh	; 11001111b . 0260b cf
d004c		db	0ffh	; 11111111b . 0260c ff
d004d		db	0ffh	; 11111111b . 0260d ff
d004e		db	000h	; 00000000b . 0260e 00
d004f		db	000h	; 00000000b . 0260f 00
d0050		db	000h	; 00000000b . 02610 00
d0051		db	003h	; 00000011b . 02611 03
d0052		db	0ffh	; 11111111b . 02612 ff
d0053		db	0ffh	; 11111111b . 02613 ff
d0054		db	0cfh	; 11001111b . 02614 cf
d0055		db	0ffh	; 11111111b . 02615 ff
d0056		db	0ffh	; 11111111b . 02616 ff
d0057		db	000h	; 00000000b . 02617 00
d0058		db	000h	; 00000000b . 02618 00
d0059		db	000h	; 00000000b . 02619 00
d005a		db	003h	; 00000011b . 0261a 03
d005b		db	0ffh	; 11111111b . 0261b ff
d005c		db	0ffh	; 11111111b . 0261c ff
d005d		db	0cfh	; 11001111b . 0261d cf
d005e		db	0ffh	; 11111111b . 0261e ff
d005f		db	0ffh	; 11111111b . 0261f ff
d0060		db	000h	; 00000000b . 02620 00
d0061		db	000h	; 00000000b . 02621 00
d0062		db	000h	; 00000000b . 02622 00
d0063		db	003h	; 00000011b . 02623 03
d0064		db	0ffh	; 11111111b . 02624 ff
d0065		db	0ffh	; 11111111b . 02625 ff
d0066		db	0cfh	; 11001111b . 02626 cf
d0067		db	0ffh	; 11111111b . 02627 ff
d0068		db	0fch	; 11111100b . 02628 fc
d0069		db	000h	; 00000000b . 02629 00
d006a		db	000h	; 00000000b . 0262a 00
d006b		db	000h	; 00000000b . 0262b 00
d006c		db	003h	; 00000011b . 0262c 03
d006d		db	0ffh	; 11111111b . 0262d ff
d006e		db	0ffh	; 11111111b . 0262e ff
d006f		db	0cfh	; 11001111b . 0262f cf
d0070		db	0ffh	; 11111111b . 02630 ff
d0071		db	0fch	; 11111100b . 02631 fc
d0072		db	000h	; 00000000b . 02632 00
d0073		db	000h	; 00000000b . 02633 00
d0074		db	000h	; 00000000b . 02634 00
d0075		db	003h	; 00000011b . 02635 03
d0076		db	0ffh	; 11111111b . 02636 ff
d0077		db	0ffh	; 11111111b . 02637 ff
d0078		db	0ffh	; 11111111b . 02638 ff
d0079		db	0ffh	; 11111111b . 02639 ff
d007a		db	0f0h	; 11110000b . 0263a f0
d007b		db	000h	; 00000000b . 0263b 00
d007c		db	000h	; 00000000b . 0263c 00
d007d		db	000h	; 00000000b . 0263d 00
d007e		db	003h	; 00000011b . 0263e 03
d007f		db	0ffh	; 11111111b . 0263f ff
d0080		db	0ffh	; 11111111b . 02640 ff
d0081		db	0ffh	; 11111111b . 02641 ff
d0082		db	0ffh	; 11111111b . 02642 ff
d0083		db	0c0h	; 11000000b . 02643 c0
d0084		db	000h	; 00000000b . 02644 00
d0085		db	000h	; 00000000b . 02645 00
d0086		db	000h	; 00000000b . 02646 00
d0087		db	003h	; 00000011b . 02647 03
d0088		db	0ffh	; 11111111b . 02648 ff
d0089		db	0ffh	; 11111111b . 02649 ff
d008a		db	0ffh	; 11111111b . 0264a ff
d008b		db	0ffh	; 11111111b . 0264b ff
d008c		db	0c0h	; 11000000b . 0264c c0
d008d		db	000h	; 00000000b . 0264d 00
d008e		db	000h	; 00000000b . 0264e 00
d008f		db	000h	; 00000000b . 0264f 00
d0090		db	003h	; 00000011b . 02650 03
d0091		db	0ffh	; 11111111b . 02651 ff
d0092		db	0ffh	; 11111111b . 02652 ff
d0093		db	0ffh	; 11111111b . 02653 ff
d0094		db	0ffh	; 11111111b . 02654 ff
d0095		db	000h	; 00000000b . 02655 00
d0096		db	000h	; 00000000b . 02656 00
d0097		db	000h	; 00000000b . 02657 00
d0098		db	000h	; 00000000b . 02658 00
d0099		db	003h	; 00000011b . 02659 03
d009a		db	0ffh	; 11111111b . 0265a ff
d009b		db	0ffh	; 11111111b . 0265b ff
d009c		db	0ffh	; 11111111b . 0265c ff
d009d		db	0c0h	; 11000000b . 0265d c0
d009e		db	000h	; 00000000b . 0265e 00
d009f		db	000h	; 00000000b . 0265f 00
d00a0		db	000h	; 00000000b . 02660 00
d00a1		db	000h	; 00000000b . 02661 00
d00a2		db	003h	; 00000011b . 02662 03
d00a3		db	0ffh	; 11111111b . 02663 ff
d00a4		db	0ffh	; 11111111b . 02664 ff
d00a5		db	0c0h	; 11000000b . 02665 c0
d00a6		db	000h	; 00000000b . 02666 00
d00a7		db	000h	; 00000000b . 02667 00
d00a8		db	000h	; 00000000b . 02668 00
d00a9		db	000h	; 00000000b . 02669 00
d00aa		db	000h	; 00000000b . 0266a 00
d00ab		db	003h	; 00000011b . 0266b 03
d00ac		db	0ffh	; 11111111b . 0266c ff
d00ad		db	0ffh	; 11111111b . 0266d ff
d00ae		db	0c0h	; 11000000b . 0266e c0
d00af		db	000h	; 00000000b . 0266f 00
d00b0		db	000h	; 00000000b . 02670 00
d00b1		db	000h	; 00000000b . 02671 00
d00b2		db	000h	; 00000000b . 02672 00
d00b3		db	000h	; 00000000b . 02673 00
d00b4		db	003h	; 00000011b . 02674 03
d00b5		db	0ffh	; 11111111b . 02675 ff
d00b6		db	0ffh	; 11111111b . 02676 ff
d00b7		db	0c0h	; 11000000b . 02677 c0
d00b8		db	000h	; 00000000b . 02678 00
d00b9		db	000h	; 00000000b . 02679 00
d00ba		db	000h	; 00000000b . 0267a 00
d00bb		db	000h	; 00000000b . 0267b 00
d00bc		db	000h	; 00000000b . 0267c 00
d00bd		db	003h	; 00000011b . 0267d 03
d00be		db	0ffh	; 11111111b . 0267e ff
d00bf		db	0ffh	; 11111111b . 0267f ff
d00c0		db	0c0h	; 11000000b . 02680 c0
d00c1		db	000h	; 00000000b . 02681 00
d00c2		db	000h	; 00000000b . 02682 00
d00c3		db	000h	; 00000000b . 02683 00
d00c4		db	000h	; 00000000b . 02684 00
d00c5		db	000h	; 00000000b . 02685 00
d00c6		db	003h	; 00000011b . 02686 03
d00c7		db	0ffh	; 11111111b . 02687 ff
d00c8		db	0ffh	; 11111111b . 02688 ff
d00c9		db	0c0h	; 11000000b . 02689 c0
d00ca		db	000h	; 00000000b . 0268a 00
d00cb		db	000h	; 00000000b . 0268b 00
d00cc		db	000h	; 00000000b . 0268c 00
d00cd		db	000h	; 00000000b . 0268d 00
d00ce		db	000h	; 00000000b . 0268e 00
d00cf		db	000h	; 00000000b . 0268f 00
d00d0		db	000h	; 00000000b . 02690 00
d00d1		db	003h	; 00000011b . 02691 03
d00d2		db	0ffh	; 11111111b . 02692 ff
d00d3		db	0ffh	; 11111111b . 02693 ff
d00d4		db	0f0h	; 11110000b . 02694 f0
d00d5		db	000h	; 00000000b . 02695 00
d00d6		db	000h	; 00000000b . 02696 00
d00d7		db	000h	; 00000000b . 02697 00
d00d8		db	000h	; 00000000b . 02698 00
d00d9		db	000h	; 00000000b . 02699 00
d00da		db	0ffh	; 11111111b . 0269a ff
d00db		db	0ffh	; 11111111b . 0269b ff
d00dc		db	0ffh	; 11111111b . 0269c ff
d00dd		db	0ffh	; 11111111b . 0269d ff
d00de		db	0c0h	; 11000000b . 0269e c0
d00df		db	000h	; 00000000b . 0269f 00
d00e0		db	000h	; 00000000b . 026a0 00
d00e1		db	000h	; 00000000b . 026a1 00
d00e2		db	00fh	; 00001111b . 026a2 0f
d00e3		db	0ffh	; 11111111b . 026a3 ff
d00e4		db	0ffh	; 11111111b . 026a4 ff
d00e5		db	0ffh	; 11111111b . 026a5 ff
d00e6		db	0ffh	; 11111111b . 026a6 ff
d00e7		db	0fch	; 11111100b . 026a7 fc
d00e8		db	000h	; 00000000b . 026a8 00
d00e9		db	000h	; 00000000b . 026a9 00
d00ea		db	000h	; 00000000b . 026aa 00
d00eb		db	03fh	; 00111111b ? 026ab 3f
d00ec		db	0ffh	; 11111111b . 026ac ff
d00ed		db	0ffh	; 11111111b . 026ad ff
d00ee		db	0ffh	; 11111111b . 026ae ff
d00ef		db	0ffh	; 11111111b . 026af ff
d00f0		db	0ffh	; 11111111b . 026b0 ff
d00f1		db	000h	; 00000000b . 026b1 00
d00f2		db	000h	; 00000000b . 026b2 00
d00f3		db	000h	; 00000000b . 026b3 00
d00f4		db	0ffh	; 11111111b . 026b4 ff
d00f5		db	0ffh	; 11111111b . 026b5 ff
d00f6		db	0ffh	; 11111111b . 026b6 ff
d00f7		db	0ffh	; 11111111b . 026b7 ff
d00f8		db	0ffh	; 11111111b . 026b8 ff
d00f9		db	0ffh	; 11111111b . 026b9 ff
d00fa		db	0c0h	; 11000000b . 026ba c0
d00fb		db	000h	; 00000000b . 026bb 00
d00fc		db	000h	; 00000000b . 026bc 00
d00fd		db	0ffh	; 11111111b . 026bd ff
d00fe		db	0ffh	; 11111111b . 026be ff
d00ff		db	0ffh	; 11111111b . 026bf ff
d0100		db	0ffh	; 11111111b . 026c0 ff
d0101		db	0ffh	; 11111111b . 026c1 ff
d0102		db	0ffh	; 11111111b . 026c2 ff
d0103		db	0c0h	; 11000000b . 026c3 c0
d0104		db	000h	; 00000000b . 026c4 00
d0105		db	003h	; 00000011b . 026c5 03
d0106		db	0ffh	; 11111111b . 026c6 ff
d0107		db	0ffh	; 11111111b . 026c7 ff
d0108		db	0ffh	; 11111111b . 026c8 ff
d0109		db	0ffh	; 11111111b . 026c9 ff
d010a		db	0ffh	; 11111111b . 026ca ff
d010b		db	0ffh	; 11111111b . 026cb ff
d010c		db	0f0h	; 11110000b . 026cc f0
d010d		db	000h	; 00000000b . 026cd 00
d010e		db	003h	; 00000011b . 026ce 03
d010f		db	0ffh	; 11111111b . 026cf ff
d0110		db	0ffh	; 11111111b . 026d0 ff
d0111		db	0ffh	; 11111111b . 026d1 ff
d0112		db	03fh	; 00111111b ? 026d2 3f
d0113		db	0ffh	; 11111111b . 026d3 ff
d0114		db	0ffh	; 11111111b . 026d4 ff
d0115		db	0f0h	; 11110000b . 026d5 f0
d0116		db	000h	; 00000000b . 026d6 00
d0117		db	00fh	; 00001111b . 026d7 0f
d0118		db	0ffh	; 11111111b . 026d8 ff
d0119		db	0ffh	; 11111111b . 026d9 ff
d011a		db	0ffh	; 11111111b . 026da ff
d011b		db	03fh	; 00111111b ? 026db 3f
d011c		db	0ffh	; 11111111b . 026dc ff
d011d		db	0ffh	; 11111111b . 026dd ff
d011e		db	0fch	; 11111100b . 026de fc
d011f		db	000h	; 00000000b . 026df 00
d0120		db	00fh	; 00001111b . 026e0 0f
d0121		db	0ffh	; 11111111b . 026e1 ff
d0122		db	0ffh	; 11111111b . 026e2 ff
d0123		db	0ffh	; 11111111b . 026e3 ff
d0124		db	03fh	; 00111111b ? 026e4 3f
d0125		db	0ffh	; 11111111b . 026e5 ff
d0126		db	0ffh	; 11111111b . 026e6 ff
d0127		db	0fch	; 11111100b . 026e7 fc
d0128		db	000h	; 00000000b . 026e8 00
d0129		db	00fh	; 00001111b . 026e9 0f
d012a		db	0ffh	; 11111111b . 026ea ff
d012b		db	0ffh	; 11111111b . 026eb ff
d012c		db	0ffh	; 11111111b . 026ec ff
d012d		db	03fh	; 00111111b ? 026ed 3f
d012e		db	0ffh	; 11111111b . 026ee ff
d012f		db	0ffh	; 11111111b . 026ef ff
d0130		db	0fch	; 11111100b . 026f0 fc
d0131		db	000h	; 00000000b . 026f1 00
d0132		db	00fh	; 00001111b . 026f2 0f
d0133		db	0ffh	; 11111111b . 026f3 ff
d0134		db	0ffh	; 11111111b . 026f4 ff
d0135		db	0ffh	; 11111111b . 026f5 ff
d0136		db	000h	; 00000000b . 026f6 00
d0137		db	000h	; 00000000b . 026f7 00
d0138		db	000h	; 00000000b . 026f8 00
d0139		db	000h	; 00000000b . 026f9 00
d013a		db	000h	; 00000000b . 026fa 00
d013b		db	00fh	; 00001111b . 026fb 0f
d013c		db	0ffh	; 11111111b . 026fc ff
d013d		db	0ffh	; 11111111b . 026fd ff
d013e		db	0ffh	; 11111111b . 026fe ff
d013f		db	03fh	; 00111111b ? 026ff 3f
d0140		db	0ffh	; 11111111b . 02700 ff
d0141		db	0ffh	; 11111111b . 02701 ff
d0142		db	0fch	; 11111100b . 02702 fc
d0143		db	000h	; 00000000b . 02703 00
d0144		db	00fh	; 00001111b . 02704 0f
d0145		db	0ffh	; 11111111b . 02705 ff
d0146		db	0ffh	; 11111111b . 02706 ff
d0147		db	0ffh	; 11111111b . 02707 ff
d0148		db	03fh	; 00111111b ? 02708 3f
d0149		db	0ffh	; 11111111b . 02709 ff
d014a		db	0ffh	; 11111111b . 0270a ff
d014b		db	0fch	; 11111100b . 0270b fc
d014c		db	000h	; 00000000b . 0270c 00
d014d		db	00fh	; 00001111b . 0270d 0f
d014e		db	0ffh	; 11111111b . 0270e ff
d014f		db	0ffh	; 11111111b . 0270f ff
d0150		db	0ffh	; 11111111b . 02710 ff
d0151		db	03fh	; 00111111b ? 02711 3f
d0152		db	0ffh	; 11111111b . 02712 ff
d0153		db	0ffh	; 11111111b . 02713 ff
d0154		db	0fch	; 11111100b . 02714 fc
d0155		db	000h	; 00000000b . 02715 00
d0156		db	003h	; 00000011b . 02716 03
d0157		db	0ffh	; 11111111b . 02717 ff
d0158		db	0ffh	; 11111111b . 02718 ff
d0159		db	0ffh	; 11111111b . 02719 ff
d015a		db	03fh	; 00111111b ? 0271a 3f
d015b		db	0ffh	; 11111111b . 0271b ff
d015c		db	0ffh	; 11111111b . 0271c ff
d015d		db	0f0h	; 11110000b . 0271d f0
d015e		db	000h	; 00000000b . 0271e 00
d015f		db	003h	; 00000011b . 0271f 03
d0160		db	0ffh	; 11111111b . 02720 ff
d0161		db	0ffh	; 11111111b . 02721 ff
d0162		db	0ffh	; 11111111b . 02722 ff
d0163		db	0ffh	; 11111111b . 02723 ff
d0164		db	0ffh	; 11111111b . 02724 ff
d0165		db	0ffh	; 11111111b . 02725 ff
d0166		db	0f0h	; 11110000b . 02726 f0
d0167		db	000h	; 00000000b . 02727 00
d0168		db	000h	; 00000000b . 02728 00
d0169		db	0ffh	; 11111111b . 02729 ff
d016a		db	0ffh	; 11111111b . 0272a ff
d016b		db	0ffh	; 11111111b . 0272b ff
d016c		db	0ffh	; 11111111b . 0272c ff
d016d		db	0ffh	; 11111111b . 0272d ff
d016e		db	0ffh	; 11111111b . 0272e ff
d016f		db	0c0h	; 11000000b . 0272f c0
d0170		db	000h	; 00000000b . 02730 00
d0171		db	000h	; 00000000b . 02731 00
d0172		db	0ffh	; 11111111b . 02732 ff
d0173		db	0ffh	; 11111111b . 02733 ff
d0174		db	0ffh	; 11111111b . 02734 ff
d0175		db	0ffh	; 11111111b . 02735 ff
d0176		db	0ffh	; 11111111b . 02736 ff
d0177		db	0ffh	; 11111111b . 02737 ff
d0178		db	0c0h	; 11000000b . 02738 c0
d0179		db	000h	; 00000000b . 02739 00
d017a		db	000h	; 00000000b . 0273a 00
d017b		db	03fh	; 00111111b ? 0273b 3f
d017c		db	0ffh	; 11111111b . 0273c ff
d017d		db	0ffh	; 11111111b . 0273d ff
d017e		db	0ffh	; 11111111b . 0273e ff
d017f		db	0ffh	; 11111111b . 0273f ff
d0180		db	0ffh	; 11111111b . 02740 ff
d0181		db	000h	; 00000000b . 02741 00
d0182		db	000h	; 00000000b . 02742 00
d0183		db	000h	; 00000000b . 02743 00
d0184		db	00fh	; 00001111b . 02744 0f
d0185		db	0ffh	; 11111111b . 02745 ff
d0186		db	0ffh	; 11111111b . 02746 ff
d0187		db	0ffh	; 11111111b . 02747 ff
d0188		db	0ffh	; 11111111b . 02748 ff
d0189		db	0fch	; 11111100b . 02749 fc
d018a		db	000h	; 00000000b . 0274a 00
d018b		db	000h	; 00000000b . 0274b 00
d018c		db	000h	; 00000000b . 0274c 00
d018d		db	000h	; 00000000b . 0274d 00
d018e		db	0ffh	; 11111111b . 0274e ff
d018f		db	0ffh	; 11111111b . 0274f ff
d0190		db	0ffh	; 11111111b . 02750 ff
d0191		db	0ffh	; 11111111b . 02751 ff
d0192		db	0c0h	; 11000000b . 02752 c0
d0193		db	000h	; 00000000b . 02753 00
d0194		db	000h	; 00000000b . 02754 00
d0195		db	000h	; 00000000b . 02755 00
d0196		db	000h	; 00000000b . 02756 00
d0197		db	003h	; 00000011b . 02757 03
d0198		db	0ffh	; 11111111b . 02758 ff
d0199		db	0ffh	; 11111111b . 02759 ff
d019a		db	0f0h	; 11110000b . 0275a f0
d019b		db	000h	; 00000000b . 0275b 00
d019c		db	000h	; 00000000b . 0275c 00
d019d		db	000h	; 00000000b . 0275d 00
d019e		db	000h	; 00000000b . 0275e 00
d019f		db	000h	; 00000000b . 0275f 00
d01a0		db	000h	; 00000000b . 02760 00
d01a1		db	000h	; 00000000b . 02761 00
d01a2		db	000h	; 00000000b . 02762 00
d01a3		db	000h	; 00000000b . 02763 00
d01a4		db	000h	; 00000000b . 02764 00
d01a5		db	000h	; 00000000b . 02765 00
d01a6		db	000h	; 00000000b . 02766 00
d01a7		db	000h	; 00000000b . 02767 00
d01a8		db	000h	; 00000000b . 02768 00
d01a9		db	000h	; 00000000b . 02769 00
d01aa		db	000h	; 00000000b . 0276a 00
d01ab		db	000h	; 00000000b . 0276b 00
d01ac		db	000h	; 00000000b . 0276c 00
d01ad		db	000h	; 00000000b . 0276d 00
d01ae		db	000h	; 00000000b . 0276e 00
d01af		db	000h	; 00000000b . 0276f 00
d01b0		db	000h	; 00000000b . 02770 00
d01b1		db	000h	; 00000000b . 02771 00
d01b2		db	000h	; 00000000b . 02772 00
d01b3		db	000h	; 00000000b . 02773 00
d01b4		db	000h	; 00000000b . 02774 00
d01b5		db	000h	; 00000000b . 02775 00
d01b6		db	000h	; 00000000b . 02776 00
d01b7		db	000h	; 00000000b . 02777 00
d01b8		db	000h	; 00000000b . 02778 00
d01b9		db	000h	; 00000000b . 02779 00
d01ba		db	000h	; 00000000b . 0277a 00
d01bb		db	000h	; 00000000b . 0277b 00
d01bc		db	000h	; 00000000b . 0277c 00
d01bd		db	000h	; 00000000b . 0277d 00
d01be		db	000h	; 00000000b . 0277e 00
d01bf		db	000h	; 00000000b . 0277f 00
d01c0		db	000h	; 00000000b . 02780 00
d01c1		db	000h	; 00000000b . 02781 00
d01c2		db	000h	; 00000000b . 02782 00
d01c3		db	000h	; 00000000b . 02783 00
d01c4		db	000h	; 00000000b . 02784 00
d01c5		db	000h	; 00000000b . 02785 00
d01c6		db	000h	; 00000000b . 02786 00
d01c7		db	000h	; 00000000b . 02787 00
d01c8		db	000h	; 00000000b . 02788 00
d01c9		db	000h	; 00000000b . 02789 00
d01ca		db	000h	; 00000000b . 0278a 00
d01cb		db	000h	; 00000000b . 0278b 00
d01cc		db	000h	; 00000000b . 0278c 00
d01cd		db	000h	; 00000000b . 0278d 00
d01ce		db	000h	; 00000000b . 0278e 00
d01cf		db	000h	; 00000000b . 0278f 00
d01d0		db	000h	; 00000000b . 02790 00
d01d1		db	000h	; 00000000b . 02791 00
d01d2		db	000h	; 00000000b . 02792 00
d01d3		db	000h	; 00000000b . 02793 00
d01d4		db	000h	; 00000000b . 02794 00
d01d5		db	000h	; 00000000b . 02795 00
d01d6		db	000h	; 00000000b . 02796 00
d01d7		db	000h	; 00000000b . 02797 00
d01d8		db	000h	; 00000000b . 02798 00
d01d9		db	000h	; 00000000b . 02799 00
d01da		db	000h	; 00000000b . 0279a 00
d01db		db	000h	; 00000000b . 0279b 00
d01dc		db	000h	; 00000000b . 0279c 00
d01dd		db	0ffh	; 11111111b . 0279d ff
d01de		db	0ffh	; 11111111b . 0279e ff
d01df		db	0ffh	; 11111111b . 0279f ff
d01e0		db	0ffh	; 11111111b . 027a0 ff
d01e1		db	000h	; 00000000b . 027a1 00
d01e2		db	000h	; 00000000b . 027a2 00
d01e3		db	000h	; 00000000b . 027a3 00
d01e4		db	000h	; 00000000b . 027a4 00
d01e5		db	000h	; 00000000b . 027a5 00
d01e6		db	0ffh	; 11111111b . 027a6 ff
d01e7		db	0ffh	; 11111111b . 027a7 ff
d01e8		db	0ffh	; 11111111b . 027a8 ff
d01e9		db	0ffh	; 11111111b . 027a9 ff
d01ea		db	000h	; 00000000b . 027aa 00
d01eb		db	000h	; 00000000b . 027ab 00
d01ec		db	000h	; 00000000b . 027ac 00
d01ed		db	000h	; 00000000b . 027ad 00
d01ee		db	000h	; 00000000b . 027ae 00
d01ef		db	0ffh	; 11111111b . 027af ff
d01f0		db	0ffh	; 11111111b . 027b0 ff
d01f1		db	0ffh	; 11111111b . 027b1 ff
d01f2		db	0ffh	; 11111111b . 027b2 ff
d01f3		db	000h	; 00000000b . 027b3 00
d01f4		db	000h	; 00000000b . 027b4 00
d01f5		db	000h	; 00000000b . 027b5 00
d01f6		db	000h	; 00000000b . 027b6 00
d01f7		db	000h	; 00000000b . 027b7 00
d01f8		db	0ffh	; 11111111b . 027b8 ff
d01f9		db	0ffh	; 11111111b . 027b9 ff
d01fa		db	0ffh	; 11111111b . 027ba ff
d01fb		db	0ffh	; 11111111b . 027bb ff
d01fc		db	000h	; 00000000b . 027bc 00
d01fd		db	000h	; 00000000b . 027bd 00
d01fe		db	000h	; 00000000b . 027be 00
d01ff		db	000h	; 00000000b . 027bf 00
d0200		db	000h	; 00000000b . 027c0 00
d0201		db	0ffh	; 11111111b . 027c1 ff
d0202		db	0ffh	; 11111111b . 027c2 ff
d0203		db	0ffh	; 11111111b . 027c3 ff
d0204		db	0ffh	; 11111111b . 027c4 ff
d0205		db	000h	; 00000000b . 027c5 00
d0206		db	000h	; 00000000b . 027c6 00
d0207		db	000h	; 00000000b . 027c7 00
d0208		db	000h	; 00000000b . 027c8 00
d0209		db	000h	; 00000000b . 027c9 00
d020a		db	0ffh	; 11111111b . 027ca ff
d020b		db	0ffh	; 11111111b . 027cb ff
d020c		db	0ffh	; 11111111b . 027cc ff
d020d		db	0ffh	; 11111111b . 027cd ff
d020e		db	000h	; 00000000b . 027ce 00
d020f		db	000h	; 00000000b . 027cf 00
d0210		db	000h	; 00000000b . 027d0 00
d0211		db	000h	; 00000000b . 027d1 00
d0212		db	000h	; 00000000b . 027d2 00
d0213		db	0ffh	; 11111111b . 027d3 ff
d0214		db	0ffh	; 11111111b . 027d4 ff
d0215		db	0ffh	; 11111111b . 027d5 ff
d0216		db	0ffh	; 11111111b . 027d6 ff
d0217		db	000h	; 00000000b . 027d7 00
d0218		db	000h	; 00000000b . 027d8 00
d0219		db	000h	; 00000000b . 027d9 00
d021a		db	000h	; 00000000b . 027da 00
d021b		db	000h	; 00000000b . 027db 00
d021c		db	0ffh	; 11111111b . 027dc ff
d021d		db	0ffh	; 11111111b . 027dd ff
d021e		db	0ffh	; 11111111b . 027de ff
d021f		db	0ffh	; 11111111b . 027df ff
d0220		db	000h	; 00000000b . 027e0 00
d0221		db	000h	; 00000000b . 027e1 00
d0222		db	000h	; 00000000b . 027e2 00
d0223		db	000h	; 00000000b . 027e3 00
d0224		db	000h	; 00000000b . 027e4 00
d0225		db	000h	; 00000000b . 027e5 00
d0226		db	000h	; 00000000b . 027e6 00
d0227		db	000h	; 00000000b . 027e7 00
d0228		db	000h	; 00000000b . 027e8 00
d0229		db	000h	; 00000000b . 027e9 00
d022a		db	000h	; 00000000b . 027ea 00
d022b		db	000h	; 00000000b . 027eb 00
d022c		db	000h	; 00000000b . 027ec 00
d022d		db	000h	; 00000000b . 027ed 00
d022e		db	000h	; 00000000b . 027ee 00
d022f		db	000h	; 00000000b . 027ef 00
d0230		db	000h	; 00000000b . 027f0 00
d0231		db	000h	; 00000000b . 027f1 00
d0232		db	000h	; 00000000b . 027f2 00
d0233		db	000h	; 00000000b . 027f3 00
d0234		db	000h	; 00000000b . 027f4 00
d0235		db	000h	; 00000000b . 027f5 00
d0236		db	000h	; 00000000b . 027f6 00
d0237		db	000h	; 00000000b . 027f7 00
d0238		db	000h	; 00000000b . 027f8 00
d0239		db	000h	; 00000000b . 027f9 00
d023a		db	000h	; 00000000b . 027fa 00
d023b		db	000h	; 00000000b . 027fb 00
d023c		db	000h	; 00000000b . 027fc 00
d023d		db	000h	; 00000000b . 027fd 00
d023e		db	000h	; 00000000b . 027fe 00
d023f		db	000h	; 00000000b . 027ff 00
d0240		db	000h	; 00000000b . 02800 00
d0241		db	000h	; 00000000b . 02801 00
d0242		db	000h	; 00000000b . 02802 00
d0243		db	000h	; 00000000b . 02803 00
d0244		db	000h	; 00000000b . 02804 00
d0245		db	000h	; 00000000b . 02805 00
d0246		db	000h	; 00000000b . 02806 00
d0247		db	000h	; 00000000b . 02807 00
d0248		db	000h	; 00000000b . 02808 00
d0249		db	000h	; 00000000b . 02809 00
d024a		db	000h	; 00000000b . 0280a 00
d024b		db	000h	; 00000000b . 0280b 00
d024c		db	000h	; 00000000b . 0280c 00
d024d		db	000h	; 00000000b . 0280d 00
d024e		db	000h	; 00000000b . 0280e 00
d024f		db	000h	; 00000000b . 0280f 00
d0250		db	000h	; 00000000b . 02810 00
d0251		db	000h	; 00000000b . 02811 00
d0252		db	000h	; 00000000b . 02812 00
d0253		db	000h	; 00000000b . 02813 00
d0254		db	000h	; 00000000b . 02814 00
d0255		db	000h	; 00000000b . 02815 00
d0256		db	000h	; 00000000b . 02816 00
d0257		db	000h	; 00000000b . 02817 00
d0258		db	000h	; 00000000b . 02818 00
d0259		db	000h	; 00000000b . 02819 00
d025a		db	000h	; 00000000b . 0281a 00
d025b		db	000h	; 00000000b . 0281b 00
d025c		db	000h	; 00000000b . 0281c 00
d025d		db	000h	; 00000000b . 0281d 00
d025e		db	000h	; 00000000b . 0281e 00
d025f		db	000h	; 00000000b . 0281f 00
d0260		db	000h	; 00000000b . 02820 00
d0261		db	000h	; 00000000b . 02821 00
d0262		db	000h	; 00000000b . 02822 00
d0263		db	000h	; 00000000b . 02823 00
d0264		db	000h	; 00000000b . 02824 00
d0265		db	000h	; 00000000b . 02825 00
d0266		db	000h	; 00000000b . 02826 00
d0267		db	000h	; 00000000b . 02827 00
d0268		db	000h	; 00000000b . 02828 00
d0269		db	000h	; 00000000b . 02829 00
d026a		db	000h	; 00000000b . 0282a 00
d026b		db	000h	; 00000000b . 0282b 00
d026c		db	000h	; 00000000b . 0282c 00
d026d		db	000h	; 00000000b . 0282d 00
d026e		db	000h	; 00000000b . 0282e 00
d026f		db	030h	; 00110000b 0 0282f 30
d0270		db	000h	; 00000000b . 02830 00
d0271		db	000h	; 00000000b . 02831 00
d0272		db	003h	; 00000011b . 02832 03
d0273		db	000h	; 00000000b . 02833 00
d0274		db	000h	; 00000000b . 02834 00
d0275		db	000h	; 00000000b . 02835 00
d0276		db	000h	; 00000000b . 02836 00
d0277		db	000h	; 00000000b . 02837 00
d0278		db	0fch	; 11111100b . 02838 fc
d0279		db	000h	; 00000000b . 02839 00
d027a		db	000h	; 00000000b . 0283a 00
d027b		db	00fh	; 00001111b . 0283b 0f
d027c		db	0c0h	; 11000000b . 0283c c0
d027d		db	000h	; 00000000b . 0283d 00
d027e		db	000h	; 00000000b . 0283e 00
d027f		db	000h	; 00000000b . 0283f 00
d0280		db	000h	; 00000000b . 02840 00
d0281		db	0fch	; 11111100b . 02841 fc
d0282		db	000h	; 00000000b . 02842 00
d0283		db	000h	; 00000000b . 02843 00
d0284		db	00fh	; 00001111b . 02844 0f
d0285		db	0c0h	; 11000000b . 02845 c0
d0286		db	000h	; 00000000b . 02846 00
d0287		db	000h	; 00000000b . 02847 00
d0288		db	000h	; 00000000b . 02848 00
d0289		db	000h	; 00000000b . 02849 00
d028a		db	0ffh	; 11111111b . 0284a ff
d028b		db	000h	; 00000000b . 0284b 00
d028c		db	000h	; 00000000b . 0284c 00
d028d		db	03fh	; 00111111b ? 0284d 3f
d028e		db	0c0h	; 11000000b . 0284e c0
d028f		db	000h	; 00000000b . 0284f 00
d0290		db	000h	; 00000000b . 02850 00
d0291		db	000h	; 00000000b . 02851 00
d0292		db	003h	; 00000011b . 02852 03
d0293		db	0ffh	; 11111111b . 02853 ff
d0294		db	000h	; 00000000b . 02854 00
d0295		db	000h	; 00000000b . 02855 00
d0296		db	03fh	; 00111111b ? 02856 3f
d0297		db	0f0h	; 11110000b . 02857 f0
d0298		db	000h	; 00000000b . 02858 00
d0299		db	000h	; 00000000b . 02859 00
d029a		db	000h	; 00000000b . 0285a 00
d029b		db	003h	; 00000011b . 0285b 03
d029c		db	0ffh	; 11111111b . 0285c ff
d029d		db	0c0h	; 11000000b . 0285d c0
d029e		db	000h	; 00000000b . 0285e 00
d029f		db	0ffh	; 11111111b . 0285f ff
d02a0		db	0f0h	; 11110000b . 02860 f0
d02a1		db	000h	; 00000000b . 02861 00
d02a2		db	000h	; 00000000b . 02862 00
d02a3		db	000h	; 00000000b . 02863 00
d02a4		db	003h	; 00000011b . 02864 03
d02a5		db	0ffh	; 11111111b . 02865 ff
d02a6		db	0c0h	; 11000000b . 02866 c0
d02a7		db	000h	; 00000000b . 02867 00
d02a8		db	0ffh	; 11111111b . 02868 ff
d02a9		db	0f0h	; 11110000b . 02869 f0
d02aa		db	000h	; 00000000b . 0286a 00
d02ab		db	000h	; 00000000b . 0286b 00
d02ac		db	000h	; 00000000b . 0286c 00
d02ad		db	00fh	; 00001111b . 0286d 0f
d02ae		db	0ffh	; 11111111b . 0286e ff
d02af		db	0f0h	; 11110000b . 0286f f0
d02b0		db	003h	; 00000011b . 02870 03
d02b1		db	0ffh	; 11111111b . 02871 ff
d02b2		db	0fch	; 11111100b . 02872 fc
d02b3		db	000h	; 00000000b . 02873 00
d02b4		db	000h	; 00000000b . 02874 00
d02b5		db	000h	; 00000000b . 02875 00
d02b6		db	00fh	; 00001111b . 02876 0f
d02b7		db	0ffh	; 11111111b . 02877 ff
d02b8		db	0fch	; 11111100b . 02878 fc
d02b9		db	00fh	; 00001111b . 02879 0f
d02ba		db	0ffh	; 11111111b . 0287a ff
d02bb		db	0fch	; 11111100b . 0287b fc
d02bc		db	000h	; 00000000b . 0287c 00
d02bd		db	000h	; 00000000b . 0287d 00
d02be		db	000h	; 00000000b . 0287e 00
d02bf		db	00fh	; 00001111b . 0287f 0f
d02c0		db	0ffh	; 11111111b . 02880 ff
d02c1		db	0fch	; 11111100b . 02881 fc
d02c2		db	00fh	; 00001111b . 02882 0f
d02c3		db	0ffh	; 11111111b . 02883 ff
d02c4		db	0fch	; 11111100b . 02884 fc
d02c5		db	000h	; 00000000b . 02885 00
d02c6		db	000h	; 00000000b . 02886 00
d02c7		db	000h	; 00000000b . 02887 00
d02c8		db	03fh	; 00111111b ? 02888 3f
d02c9		db	0ffh	; 11111111b . 02889 ff
d02ca		db	0ffh	; 11111111b . 0288a ff
d02cb		db	03fh	; 00111111b ? 0288b 3f
d02cc		db	0ffh	; 11111111b . 0288c ff
d02cd		db	0ffh	; 11111111b . 0288d ff
d02ce		db	000h	; 00000000b . 0288e 00
d02cf		db	000h	; 00000000b . 0288f 00
d02d0		db	000h	; 00000000b . 02890 00
d02d1		db	03fh	; 00111111b ? 02891 3f
d02d2		db	0ffh	; 11111111b . 02892 ff
d02d3		db	0ffh	; 11111111b . 02893 ff
d02d4		db	0ffh	; 11111111b . 02894 ff
d02d5		db	0ffh	; 11111111b . 02895 ff
d02d6		db	0ffh	; 11111111b . 02896 ff
d02d7		db	000h	; 00000000b . 02897 00
d02d8		db	000h	; 00000000b . 02898 00
d02d9		db	000h	; 00000000b . 02899 00
d02da		db	0ffh	; 11111111b . 0289a ff
d02db		db	0ffh	; 11111111b . 0289b ff
d02dc		db	0ffh	; 11111111b . 0289c ff
d02dd		db	0ffh	; 11111111b . 0289d ff
d02de		db	0ffh	; 11111111b . 0289e ff
d02df		db	0ffh	; 11111111b . 0289f ff
d02e0		db	0c0h	; 11000000b . 028a0 c0
d02e1		db	000h	; 00000000b . 028a1 00
d02e2		db	000h	; 00000000b . 028a2 00
d02e3		db	0ffh	; 11111111b . 028a3 ff
d02e4		db	0ffh	; 11111111b . 028a4 ff
d02e5		db	0ffh	; 11111111b . 028a5 ff
d02e6		db	0ffh	; 11111111b . 028a6 ff
d02e7		db	0ffh	; 11111111b . 028a7 ff
d02e8		db	0ffh	; 11111111b . 028a8 ff
d02e9		db	0c0h	; 11000000b . 028a9 c0
d02ea		db	000h	; 00000000b . 028aa 00
d02eb		db	003h	; 00000011b . 028ab 03
d02ec		db	0ffh	; 11111111b . 028ac ff
d02ed		db	0ffh	; 11111111b . 028ad ff
d02ee		db	0ffh	; 11111111b . 028ae ff
d02ef		db	0ffh	; 11111111b . 028af ff
d02f0		db	0ffh	; 11111111b . 028b0 ff
d02f1		db	0ffh	; 11111111b . 028b1 ff
d02f2		db	0f0h	; 11110000b . 028b2 f0
d02f3		db	000h	; 00000000b . 028b3 00
d02f4		db	003h	; 00000011b . 028b4 03
d02f5		db	0ffh	; 11111111b . 028b5 ff
d02f6		db	0ffh	; 11111111b . 028b6 ff
d02f7		db	0ffh	; 11111111b . 028b7 ff
d02f8		db	0ffh	; 11111111b . 028b8 ff
d02f9		db	0ffh	; 11111111b . 028b9 ff
d02fa		db	0ffh	; 11111111b . 028ba ff
d02fb		db	0f0h	; 11110000b . 028bb f0
d02fc		db	000h	; 00000000b . 028bc 00
d02fd		db	00fh	; 00001111b . 028bd 0f
d02fe		db	0ffh	; 11111111b . 028be ff
d02ff		db	0fch	; 11111100b . 028bf fc
d0300		db	0ffh	; 11111111b . 028c0 ff
d0301		db	0ffh	; 11111111b . 028c1 ff
d0302		db	0cfh	; 11001111b . 028c2 cf
d0303		db	0ffh	; 11111111b . 028c3 ff
d0304		db	0fch	; 11111100b . 028c4 fc
d0305		db	000h	; 00000000b . 028c5 00
d0306		db	00fh	; 00001111b . 028c6 0f
d0307		db	0ffh	; 11111111b . 028c7 ff
d0308		db	0fch	; 11111100b . 028c8 fc
d0309		db	0ffh	; 11111111b . 028c9 ff
d030a		db	0ffh	; 11111111b . 028ca ff
d030b		db	0cfh	; 11001111b . 028cb cf
d030c		db	0ffh	; 11111111b . 028cc ff
d030d		db	0fch	; 11111100b . 028cd fc
d030e		db	000h	; 00000000b . 028ce 00
d030f		db	00fh	; 00001111b . 028cf 0f
d0310		db	0ffh	; 11111111b . 028d0 ff
d0311		db	0fch	; 11111100b . 028d1 fc
d0312		db	0ffh	; 11111111b . 028d2 ff
d0313		db	0ffh	; 11111111b . 028d3 ff
d0314		db	0cfh	; 11001111b . 028d4 cf
d0315		db	0ffh	; 11111111b . 028d5 ff
d0316		db	0fch	; 11111100b . 028d6 fc
d0317		db	000h	; 00000000b . 028d7 00
d0318		db	03fh	; 00111111b ? 028d8 3f
d0319		db	0ffh	; 11111111b . 028d9 ff
d031a		db	0fch	; 11111100b . 028da fc
d031b		db	0ffh	; 11111111b . 028db ff
d031c		db	0ffh	; 11111111b . 028dc ff
d031d		db	0cfh	; 11001111b . 028dd cf
d031e		db	0ffh	; 11111111b . 028de ff
d031f		db	0ffh	; 11111111b . 028df ff
d0320		db	000h	; 00000000b . 028e0 00
d0321		db	03fh	; 00111111b ? 028e1 3f
d0322		db	0ffh	; 11111111b . 028e2 ff
d0323		db	0fch	; 11111100b . 028e3 fc
d0324		db	0ffh	; 11111111b . 028e4 ff
d0325		db	0ffh	; 11111111b . 028e5 ff
d0326		db	0cfh	; 11001111b . 028e6 cf
d0327		db	0ffh	; 11111111b . 028e7 ff
d0328		db	0ffh	; 11111111b . 028e8 ff
d0329		db	000h	; 00000000b . 028e9 00
d032a		db	0ffh	; 11111111b . 028ea ff
d032b		db	0ffh	; 11111111b . 028eb ff
d032c		db	0fch	; 11111100b . 028ec fc
d032d		db	0ffh	; 11111111b . 028ed ff
d032e		db	0ffh	; 11111111b . 028ee ff
d032f		db	0cfh	; 11001111b . 028ef cf
d0330		db	0ffh	; 11111111b . 028f0 ff
d0331		db	0ffh	; 11111111b . 028f1 ff
d0332		db	0c0h	; 11000000b . 028f2 c0
d0333		db	0ffh	; 11111111b . 028f3 ff
d0334		db	0ffh	; 11111111b . 028f4 ff
d0335		db	0fch	; 11111100b . 028f5 fc
d0336		db	0ffh	; 11111111b . 028f6 ff
d0337		db	0ffh	; 11111111b . 028f7 ff
d0338		db	0cfh	; 11001111b . 028f8 cf
d0339		db	0ffh	; 11111111b . 028f9 ff
d033a		db	0ffh	; 11111111b . 028fa ff
d033b		db	0c0h	; 11000000b . 028fb c0
d033c		db	000h	; 00000000b . 028fc 00
d033d		db	000h	; 00000000b . 028fd 00
d033e		db	00fh	; 00001111b . 028fe 0f
d033f		db	0ffh	; 11111111b . 028ff ff
d0340		db	0c0h	; 11000000b . 02900 c0
d0341		db	000h	; 00000000b . 02901 00
d0342		db	000h	; 00000000b . 02902 00
d0343		db	000h	; 00000000b . 02903 00
d0344		db	000h	; 00000000b . 02904 00
d0345		db	000h	; 00000000b . 02905 00
d0346		db	000h	; 00000000b . 02906 00
d0347		db	0ffh	; 11111111b . 02907 ff
d0348		db	0ffh	; 11111111b . 02908 ff
d0349		db	0fch	; 11111100b . 02909 fc
d034a		db	000h	; 00000000b . 0290a 00
d034b		db	000h	; 00000000b . 0290b 00
d034c		db	000h	; 00000000b . 0290c 00
d034d		db	000h	; 00000000b . 0290d 00
d034e		db	000h	; 00000000b . 0290e 00
d034f		db	00fh	; 00001111b . 0290f 0f
d0350		db	0ffh	; 11111111b . 02910 ff
d0351		db	0ffh	; 11111111b . 02911 ff
d0352		db	0ffh	; 11111111b . 02912 ff
d0353		db	0c0h	; 11000000b . 02913 c0
d0354		db	000h	; 00000000b . 02914 00
d0355		db	000h	; 00000000b . 02915 00
d0356		db	000h	; 00000000b . 02916 00
d0357		db	000h	; 00000000b . 02917 00
d0358		db	03fh	; 00111111b ? 02918 3f
d0359		db	0ffh	; 11111111b . 02919 ff
d035a		db	0ffh	; 11111111b . 0291a ff
d035b		db	0ffh	; 11111111b . 0291b ff
d035c		db	0f0h	; 11110000b . 0291c f0
d035d		db	000h	; 00000000b . 0291d 00
d035e		db	000h	; 00000000b . 0291e 00
d035f		db	000h	; 00000000b . 0291f 00
d0360		db	000h	; 00000000b . 02920 00
d0361		db	03fh	; 00111111b ? 02921 3f
d0362		db	0ffh	; 11111111b . 02922 ff
d0363		db	0ffh	; 11111111b . 02923 ff
d0364		db	0ffh	; 11111111b . 02924 ff
d0365		db	0f0h	; 11110000b . 02925 f0
d0366		db	000h	; 00000000b . 02926 00
d0367		db	000h	; 00000000b . 02927 00
d0368		db	000h	; 00000000b . 02928 00
d0369		db	000h	; 00000000b . 02929 00
d036a		db	0ffh	; 11111111b . 0292a ff
d036b		db	0ffh	; 11111111b . 0292b ff
d036c		db	0ffh	; 11111111b . 0292c ff
d036d		db	0ffh	; 11111111b . 0292d ff
d036e		db	0fch	; 11111100b . 0292e fc
d036f		db	000h	; 00000000b . 0292f 00
d0370		db	000h	; 00000000b . 02930 00
d0371		db	000h	; 00000000b . 02931 00
d0372		db	000h	; 00000000b . 02932 00
d0373		db	0ffh	; 11111111b . 02933 ff
d0374		db	0ffh	; 11111111b . 02934 ff
d0375		db	0cfh	; 11001111b . 02935 cf
d0376		db	0ffh	; 11111111b . 02936 ff
d0377		db	0fch	; 11111100b . 02937 fc
d0378		db	000h	; 00000000b . 02938 00
d0379		db	000h	; 00000000b . 02939 00
d037a		db	000h	; 00000000b . 0293a 00
d037b		db	003h	; 00000011b . 0293b 03
d037c		db	0ffh	; 11111111b . 0293c ff
d037d		db	0ffh	; 11111111b . 0293d ff
d037e		db	0cfh	; 11001111b . 0293e cf
d037f		db	0ffh	; 11111111b . 0293f ff
d0380		db	0ffh	; 11111111b . 02940 ff
d0381		db	000h	; 00000000b . 02941 00
d0382		db	000h	; 00000000b . 02942 00
d0383		db	000h	; 00000000b . 02943 00
d0384		db	003h	; 00000011b . 02944 03
d0385		db	0ffh	; 11111111b . 02945 ff
d0386		db	0ffh	; 11111111b . 02946 ff
d0387		db	0cfh	; 11001111b . 02947 cf
d0388		db	0ffh	; 11111111b . 02948 ff
d0389		db	0ffh	; 11111111b . 02949 ff
d038a		db	000h	; 00000000b . 0294a 00
d038b		db	000h	; 00000000b . 0294b 00
d038c		db	000h	; 00000000b . 0294c 00
d038d		db	003h	; 00000011b . 0294d 03
d038e		db	0ffh	; 11111111b . 0294e ff
d038f		db	0ffh	; 11111111b . 0294f ff
d0390		db	0cfh	; 11001111b . 02950 cf
d0391		db	0ffh	; 11111111b . 02951 ff
d0392		db	0ffh	; 11111111b . 02952 ff
d0393		db	000h	; 00000000b . 02953 00
d0394		db	000h	; 00000000b . 02954 00
d0395		db	000h	; 00000000b . 02955 00
d0396		db	003h	; 00000011b . 02956 03
d0397		db	0ffh	; 11111111b . 02957 ff
d0398		db	0ffh	; 11111111b . 02958 ff
d0399		db	0cfh	; 11001111b . 02959 cf
d039a		db	0ffh	; 11111111b . 0295a ff
d039b		db	0ffh	; 11111111b . 0295b ff
d039c		db	000h	; 00000000b . 0295c 00
d039d		db	000h	; 00000000b . 0295d 00
d039e		db	000h	; 00000000b . 0295e 00
d039f		db	003h	; 00000011b . 0295f 03
d03a0		db	0ffh	; 11111111b . 02960 ff
d03a1		db	0ffh	; 11111111b . 02961 ff
d03a2		db	0ffh	; 11111111b . 02962 ff
d03a3		db	0ffh	; 11111111b . 02963 ff
d03a4		db	0ffh	; 11111111b . 02964 ff
d03a5		db	000h	; 00000000b . 02965 00
d03a6		db	000h	; 00000000b . 02966 00
d03a7		db	000h	; 00000000b . 02967 00
d03a8		db	003h	; 00000011b . 02968 03
d03a9		db	0ffh	; 11111111b . 02969 ff
d03aa		db	0ffh	; 11111111b . 0296a ff
d03ab		db	0ffh	; 11111111b . 0296b ff
d03ac		db	0ffh	; 11111111b . 0296c ff
d03ad		db	0ffh	; 11111111b . 0296d ff
d03ae		db	000h	; 00000000b . 0296e 00
d03af		db	000h	; 00000000b . 0296f 00
d03b0		db	000h	; 00000000b . 02970 00
d03b1		db	003h	; 00000011b . 02971 03
d03b2		db	0ffh	; 11111111b . 02972 ff
d03b3		db	0ffh	; 11111111b . 02973 ff
d03b4		db	0ffh	; 11111111b . 02974 ff
d03b5		db	0ffh	; 11111111b . 02975 ff
d03b6		db	0ffh	; 11111111b . 02976 ff
d03b7		db	000h	; 00000000b . 02977 00
d03b8		db	000h	; 00000000b . 02978 00
d03b9		db	000h	; 00000000b . 02979 00
d03ba		db	003h	; 00000011b . 0297a 03
d03bb		db	0ffh	; 11111111b . 0297b ff
d03bc		db	0ffh	; 11111111b . 0297c ff
d03bd		db	0ffh	; 11111111b . 0297d ff
d03be		db	0ffh	; 11111111b . 0297e ff
d03bf		db	0ffh	; 11111111b . 0297f ff
d03c0		db	000h	; 00000000b . 02980 00
d03c1		db	000h	; 00000000b . 02981 00
d03c2		db	000h	; 00000000b . 02982 00
d03c3		db	003h	; 00000011b . 02983 03
d03c4		db	0ffh	; 11111111b . 02984 ff
d03c5		db	0ffh	; 11111111b . 02985 ff
d03c6		db	0ffh	; 11111111b . 02986 ff
d03c7		db	0ffh	; 11111111b . 02987 ff
d03c8		db	0ffh	; 11111111b . 02988 ff
d03c9		db	000h	; 00000000b . 02989 00
d03ca		db	000h	; 00000000b . 0298a 00
d03cb		db	000h	; 00000000b . 0298b 00
d03cc		db	003h	; 00000011b . 0298c 03
d03cd		db	0ffh	; 11111111b . 0298d ff
d03ce		db	0ffh	; 11111111b . 0298e ff
d03cf		db	0ffh	; 11111111b . 0298f ff
d03d0		db	0ffh	; 11111111b . 02990 ff
d03d1		db	0ffh	; 11111111b . 02991 ff
d03d2		db	000h	; 00000000b . 02992 00
d03d3		db	000h	; 00000000b . 02993 00
d03d4		db	000h	; 00000000b . 02994 00
d03d5		db	003h	; 00000011b . 02995 03
d03d6		db	0ffh	; 11111111b . 02996 ff
d03d7		db	0ffh	; 11111111b . 02997 ff
d03d8		db	0cfh	; 11001111b . 02998 cf
d03d9		db	0ffh	; 11111111b . 02999 ff
d03da		db	0ffh	; 11111111b . 0299a ff
d03db		db	000h	; 00000000b . 0299b 00
d03dc		db	000h	; 00000000b . 0299c 00
d03dd		db	000h	; 00000000b . 0299d 00
d03de		db	003h	; 00000011b . 0299e 03
d03df		db	0ffh	; 11111111b . 0299f ff
d03e0		db	0ffh	; 11111111b . 029a0 ff
d03e1		db	0cfh	; 11001111b . 029a1 cf
d03e2		db	0ffh	; 11111111b . 029a2 ff
d03e3		db	0ffh	; 11111111b . 029a3 ff
d03e4		db	000h	; 00000000b . 029a4 00
d03e5		db	000h	; 00000000b . 029a5 00
d03e6		db	000h	; 00000000b . 029a6 00
d03e7		db	003h	; 00000011b . 029a7 03
d03e8		db	0ffh	; 11111111b . 029a8 ff
d03e9		db	0ffh	; 11111111b . 029a9 ff
d03ea		db	0cfh	; 11001111b . 029aa cf
d03eb		db	0ffh	; 11111111b . 029ab ff
d03ec		db	0ffh	; 11111111b . 029ac ff
d03ed		db	000h	; 00000000b . 029ad 00
d03ee		db	000h	; 00000000b . 029ae 00
d03ef		db	000h	; 00000000b . 029af 00
d03f0		db	003h	; 00000011b . 029b0 03
d03f1		db	0ffh	; 11111111b . 029b1 ff
d03f2		db	0ffh	; 11111111b . 029b2 ff
d03f3		db	0cfh	; 11001111b . 029b3 cf
d03f4		db	0ffh	; 11111111b . 029b4 ff
d03f5		db	0ffh	; 11111111b . 029b5 ff
d03f6		db	000h	; 00000000b . 029b6 00
d03f7		db	000h	; 00000000b . 029b7 00
d03f8		db	000h	; 00000000b . 029b8 00
d03f9		db	003h	; 00000011b . 029b9 03
d03fa		db	0ffh	; 11111111b . 029ba ff
d03fb		db	0ffh	; 11111111b . 029bb ff
d03fc		db	0cfh	; 11001111b . 029bc cf
d03fd		db	0ffh	; 11111111b . 029bd ff
d03fe		db	0ffh	; 11111111b . 029be ff
d03ff		db	000h	; 00000000b . 029bf 00
d0400		db	000h	; 00000000b . 029c0 00
d0401		db	000h	; 00000000b . 029c1 00
d0402		db	003h	; 00000011b . 029c2 03
d0403		db	0ffh	; 11111111b . 029c3 ff
d0404		db	0ffh	; 11111111b . 029c4 ff
d0405		db	0cfh	; 11001111b . 029c5 cf
d0406		db	0ffh	; 11111111b . 029c6 ff
d0407		db	0ffh	; 11111111b . 029c7 ff
d0408		db	000h	; 00000000b . 029c8 00
d0409		db	000h	; 00000000b . 029c9 00
d040a		db	000h	; 00000000b . 029ca 00
d040b		db	003h	; 00000011b . 029cb 03
d040c		db	0ffh	; 11111111b . 029cc ff
d040d		db	0ffh	; 11111111b . 029cd ff
d040e		db	0ffh	; 11111111b . 029ce ff
d040f		db	000h	; 00000000b . 029cf 00
d0410		db	000h	; 00000000b . 029d0 00
d0411		db	000h	; 00000000b . 029d1 00
d0412		db	000h	; 00000000b . 029d2 00
d0413		db	000h	; 00000000b . 029d3 00
d0414		db	003h	; 00000011b . 029d4 03
d0415		db	0ffh	; 11111111b . 029d5 ff
d0416		db	0ffh	; 11111111b . 029d6 ff
d0417		db	0ffh	; 11111111b . 029d7 ff
d0418		db	0fch	; 11111100b . 029d8 fc
d0419		db	000h	; 00000000b . 029d9 00
d041a		db	000h	; 00000000b . 029da 00
d041b		db	000h	; 00000000b . 029db 00
d041c		db	000h	; 00000000b . 029dc 00
d041d		db	003h	; 00000011b . 029dd 03
d041e		db	0ffh	; 11111111b . 029de ff
d041f		db	0ffh	; 11111111b . 029df ff
d0420		db	0ffh	; 11111111b . 029e0 ff
d0421		db	0ffh	; 11111111b . 029e1 ff
d0422		db	0c0h	; 11000000b . 029e2 c0
d0423		db	000h	; 00000000b . 029e3 00
d0424		db	000h	; 00000000b . 029e4 00
d0425		db	000h	; 00000000b . 029e5 00
d0426		db	003h	; 00000011b . 029e6 03
d0427		db	0ffh	; 11111111b . 029e7 ff
d0428		db	0ffh	; 11111111b . 029e8 ff
d0429		db	0ffh	; 11111111b . 029e9 ff
d042a		db	0ffh	; 11111111b . 029ea ff
d042b		db	0f0h	; 11110000b . 029eb f0
d042c		db	000h	; 00000000b . 029ec 00
d042d		db	000h	; 00000000b . 029ed 00
d042e		db	000h	; 00000000b . 029ee 00
d042f		db	003h	; 00000011b . 029ef 03
d0430		db	0ffh	; 11111111b . 029f0 ff
d0431		db	0ffh	; 11111111b . 029f1 ff
d0432		db	0ffh	; 11111111b . 029f2 ff
d0433		db	0ffh	; 11111111b . 029f3 ff
d0434		db	0f0h	; 11110000b . 029f4 f0
d0435		db	000h	; 00000000b . 029f5 00
d0436		db	000h	; 00000000b . 029f6 00
d0437		db	000h	; 00000000b . 029f7 00
d0438		db	003h	; 00000011b . 029f8 03
d0439		db	0ffh	; 11111111b . 029f9 ff
d043a		db	0ffh	; 11111111b . 029fa ff
d043b		db	0ffh	; 11111111b . 029fb ff
d043c		db	0ffh	; 11111111b . 029fc ff
d043d		db	0fch	; 11111100b . 029fd fc
d043e		db	000h	; 00000000b . 029fe 00
d043f		db	000h	; 00000000b . 029ff 00
d0440		db	000h	; 00000000b . 02a00 00
d0441		db	003h	; 00000011b . 02a01 03
d0442		db	0ffh	; 11111111b . 02a02 ff
d0443		db	0ffh	; 11111111b . 02a03 ff
d0444		db	0ffh	; 11111111b . 02a04 ff
d0445		db	0ffh	; 11111111b . 02a05 ff
d0446		db	0fch	; 11111100b . 02a06 fc
d0447		db	000h	; 00000000b . 02a07 00
d0448		db	000h	; 00000000b . 02a08 00
d0449		db	000h	; 00000000b . 02a09 00
d044a		db	003h	; 00000011b . 02a0a 03
d044b		db	0ffh	; 11111111b . 02a0b ff
d044c		db	0ffh	; 11111111b . 02a0c ff
d044d		db	0ffh	; 11111111b . 02a0d ff
d044e		db	0ffh	; 11111111b . 02a0e ff
d044f		db	0ffh	; 11111111b . 02a0f ff
d0450		db	000h	; 00000000b . 02a10 00
d0451		db	000h	; 00000000b . 02a11 00
d0452		db	000h	; 00000000b . 02a12 00
d0453		db	003h	; 00000011b . 02a13 03
d0454		db	0ffh	; 11111111b . 02a14 ff
d0455		db	0ffh	; 11111111b . 02a15 ff
d0456		db	0ffh	; 11111111b . 02a16 ff
d0457		db	0ffh	; 11111111b . 02a17 ff
d0458		db	0ffh	; 11111111b . 02a18 ff
d0459		db	000h	; 00000000b . 02a19 00
d045a		db	000h	; 00000000b . 02a1a 00
d045b		db	000h	; 00000000b . 02a1b 00
d045c		db	003h	; 00000011b . 02a1c 03
d045d		db	0ffh	; 11111111b . 02a1d ff
d045e		db	0ffh	; 11111111b . 02a1e ff
d045f		db	0ffh	; 11111111b . 02a1f ff
d0460		db	0ffh	; 11111111b . 02a20 ff
d0461		db	0ffh	; 11111111b . 02a21 ff
d0462		db	000h	; 00000000b . 02a22 00
d0463		db	000h	; 00000000b . 02a23 00
d0464		db	000h	; 00000000b . 02a24 00
d0465		db	003h	; 00000011b . 02a25 03
d0466		db	0ffh	; 11111111b . 02a26 ff
d0467		db	0ffh	; 11111111b . 02a27 ff
d0468		db	0ffh	; 11111111b . 02a28 ff
d0469		db	0ffh	; 11111111b . 02a29 ff
d046a		db	0ffh	; 11111111b . 02a2a ff
d046b		db	000h	; 00000000b . 02a2b 00
d046c		db	000h	; 00000000b . 02a2c 00
d046d		db	000h	; 00000000b . 02a2d 00
d046e		db	003h	; 00000011b . 02a2e 03
d046f		db	0ffh	; 11111111b . 02a2f ff
d0470		db	0ffh	; 11111111b . 02a30 ff
d0471		db	0cfh	; 11001111b . 02a31 cf
d0472		db	0ffh	; 11111111b . 02a32 ff
d0473		db	0ffh	; 11111111b . 02a33 ff
d0474		db	000h	; 00000000b . 02a34 00
d0475		db	000h	; 00000000b . 02a35 00
d0476		db	000h	; 00000000b . 02a36 00
d0477		db	003h	; 00000011b . 02a37 03
d0478		db	0ffh	; 11111111b . 02a38 ff
d0479		db	0ffh	; 11111111b . 02a39 ff
d047a		db	0cfh	; 11001111b . 02a3a cf
d047b		db	0ffh	; 11111111b . 02a3b ff
d047c		db	0ffh	; 11111111b . 02a3c ff
d047d		db	000h	; 00000000b . 02a3d 00
d047e		db	000h	; 00000000b . 02a3e 00
d047f		db	000h	; 00000000b . 02a3f 00
d0480		db	003h	; 00000011b . 02a40 03
d0481		db	0ffh	; 11111111b . 02a41 ff
d0482		db	0ffh	; 11111111b . 02a42 ff
d0483		db	0cfh	; 11001111b . 02a43 cf
d0484		db	0ffh	; 11111111b . 02a44 ff
d0485		db	0ffh	; 11111111b . 02a45 ff
d0486		db	000h	; 00000000b . 02a46 00
d0487		db	000h	; 00000000b . 02a47 00
d0488		db	000h	; 00000000b . 02a48 00
d0489		db	003h	; 00000011b . 02a49 03
d048a		db	0ffh	; 11111111b . 02a4a ff
d048b		db	0ffh	; 11111111b . 02a4b ff
d048c		db	0cfh	; 11001111b . 02a4c cf
d048d		db	0ffh	; 11111111b . 02a4d ff
d048e		db	0ffh	; 11111111b . 02a4e ff
d048f		db	000h	; 00000000b . 02a4f 00
d0490		db	000h	; 00000000b . 02a50 00
d0491		db	000h	; 00000000b . 02a51 00
d0492		db	003h	; 00000011b . 02a52 03
d0493		db	0ffh	; 11111111b . 02a53 ff
d0494		db	0ffh	; 11111111b . 02a54 ff
d0495		db	0cfh	; 11001111b . 02a55 cf
d0496		db	0ffh	; 11111111b . 02a56 ff
d0497		db	0ffh	; 11111111b . 02a57 ff
d0498		db	000h	; 00000000b . 02a58 00
d0499		db	000h	; 00000000b . 02a59 00
d049a		db	000h	; 00000000b . 02a5a 00
d049b		db	003h	; 00000011b . 02a5b 03
d049c		db	0ffh	; 11111111b . 02a5c ff
d049d		db	0ffh	; 11111111b . 02a5d ff
d049e		db	0cfh	; 11001111b . 02a5e cf
d049f		db	0ffh	; 11111111b . 02a5f ff
d04a0		db	0ffh	; 11111111b . 02a60 ff
d04a1		db	000h	; 00000000b . 02a61 00
d04a2		db	000h	; 00000000b . 02a62 00
d04a3		db	000h	; 00000000b . 02a63 00
d04a4		db	003h	; 00000011b . 02a64 03
d04a5		db	0ffh	; 11111111b . 02a65 ff
d04a6		db	0ffh	; 11111111b . 02a66 ff
d04a7		db	0cfh	; 11001111b . 02a67 cf
d04a8		db	0ffh	; 11111111b . 02a68 ff
d04a9		db	0ffh	; 11111111b . 02a69 ff
d04aa		db	000h	; 00000000b . 02a6a 00
d04ab		db	000h	; 00000000b . 02a6b 00
d04ac		db	000h	; 00000000b . 02a6c 00
d04ad		db	003h	; 00000011b . 02a6d 03
d04ae		db	0ffh	; 11111111b . 02a6e ff
d04af		db	0ffh	; 11111111b . 02a6f ff
d04b0		db	0cfh	; 11001111b . 02a70 cf
d04b1		db	0ffh	; 11111111b . 02a71 ff
d04b2		db	0ffh	; 11111111b . 02a72 ff
d04b3		db	000h	; 00000000b . 02a73 00
d04b4		db	000h	; 00000000b . 02a74 00
d04b5		db	000h	; 00000000b . 02a75 00
d04b6		db	003h	; 00000011b . 02a76 03
d04b7		db	0ffh	; 11111111b . 02a77 ff
d04b8		db	0ffh	; 11111111b . 02a78 ff
d04b9		db	0cfh	; 11001111b . 02a79 cf
d04ba		db	0ffh	; 11111111b . 02a7a ff
d04bb		db	0ffh	; 11111111b . 02a7b ff
d04bc		db	000h	; 00000000b . 02a7c 00
d04bd		db	000h	; 00000000b . 02a7d 00
d04be		db	000h	; 00000000b . 02a7e 00
d04bf		db	003h	; 00000011b . 02a7f 03
d04c0		db	0ffh	; 11111111b . 02a80 ff
d04c1		db	0ffh	; 11111111b . 02a81 ff
d04c2		db	0cfh	; 11001111b . 02a82 cf
d04c3		db	0ffh	; 11111111b . 02a83 ff
d04c4		db	0ffh	; 11111111b . 02a84 ff
d04c5		db	000h	; 00000000b . 02a85 00
d04c6		db	000h	; 00000000b . 02a86 00
d04c7		db	000h	; 00000000b . 02a87 00
d04c8		db	003h	; 00000011b . 02a88 03
d04c9		db	0ffh	; 11111111b . 02a89 ff
d04ca		db	0ffh	; 11111111b . 02a8a ff
d04cb		db	0cfh	; 11001111b . 02a8b cf
d04cc		db	0ffh	; 11111111b . 02a8c ff
d04cd		db	0ffh	; 11111111b . 02a8d ff
d04ce		db	000h	; 00000000b . 02a8e 00
d04cf		db	000h	; 00000000b . 02a8f 00
d04d0		db	000h	; 00000000b . 02a90 00
d04d1		db	003h	; 00000011b . 02a91 03
d04d2		db	0ffh	; 11111111b . 02a92 ff
d04d3		db	0ffh	; 11111111b . 02a93 ff
d04d4		db	0cfh	; 11001111b . 02a94 cf
d04d5		db	0ffh	; 11111111b . 02a95 ff
d04d6		db	0ffh	; 11111111b . 02a96 ff
d04d7		db	000h	; 00000000b . 02a97 00
d04d8		db	000h	; 00000000b . 02a98 00
d04d9		db	000h	; 00000000b . 02a99 00
d04da		db	007h	; 00000111b . 02a9a 07
d04db		db	000h	; 00000000b . 02a9b 00
d04dc		db	009h	; 00001001b . 02a9c 09
d04dd		db	000h	; 00000000b . 02a9d 00
d04de		db	005h	; 00000101b . 02a9e 05
d04df		db	000h	; 00000000b . 02a9f 00
d04e0		db	00ah	; 00001010b . 02aa0 0a
d04e1		db	000h	; 00000000b . 02aa1 00
d04e2		db	007h	; 00000111b . 02aa2 07
d04e3		db	000h	; 00000000b . 02aa3 00
d04e4		db	007h	; 00000111b . 02aa4 07
d04e5		db	000h	; 00000000b . 02aa5 00
d04e6		db	054h	; 01010100b T 02aa6 54
d04e7		db	003h	; 00000011b . 02aa7 03
d04e8		db	054h	; 01010100b T 02aa8 54
d04e9		db	003h	; 00000011b . 02aa9 03
d04ea		db	002h	; 00000010b . 02aaa 02
d04eb		db	000h	; 00000000b . 02aab 00
d04ec		db	002h	; 00000010b . 02aac 02
d04ed		db	000h	; 00000000b . 02aad 00
d04ee		db	087h	; 10000111b . 02aae 87
d04ef		db	003h	; 00000011b . 02aaf 03
d04f0		db	087h	; 10000111b . 02ab0 87
d04f1		db	003h	; 00000011b . 02ab1 03
d04f2		db	002h	; 00000010b . 02ab2 02
d04f3		db	000h	; 00000000b . 02ab3 00
d04f4		db	002h	; 00000010b . 02ab4 02
d04f5		db	000h	; 00000000b . 02ab5 00
d04f6		db	0bdh	; 10111101b . 02ab6 bd
d04f7		db	003h	; 00000011b . 02ab7 03
d04f8		db	0bdh	; 10111101b . 02ab8 bd
d04f9		db	003h	; 00000011b . 02ab9 03
d04fa		db	087h	; 10000111b . 02aba 87
d04fb		db	003h	; 00000011b . 02abb 03
d04fc		db	087h	; 10000111b . 02abc 87
d04fd		db	003h	; 00000011b . 02abd 03
d04fe		db	0bdh	; 10111101b . 02abe bd
d04ff		db	003h	; 00000011b . 02abf 03
d0500		db	0bdh	; 10111101b . 02ac0 bd
d0501		db	003h	; 00000011b . 02ac1 03
d0502		db	0f5h	; 11110101b . 02ac2 f5
d0503		db	003h	; 00000011b . 02ac3 03
d0504		db	0f5h	; 11110101b . 02ac4 f5
d0505		db	003h	; 00000011b . 02ac5 03
d0506		db	032h	; 00110010b 2 02ac6 32
d0507		db	004h	; 00000100b . 02ac7 04
d0508		db	032h	; 00110010b 2 02ac8 32
d0509		db	004h	; 00000100b . 02ac9 04
d050a		db	002h	; 00000010b . 02aca 02
d050b		db	000h	; 00000000b . 02acb 00
d050c		db	002h	; 00000010b . 02acc 02
d050d		db	000h	; 00000000b . 02acd 00
d050e		db	072h	; 01110010b r 02ace 72
d050f		db	004h	; 00000100b . 02acf 04
d0510		db	072h	; 01110010b r 02ad0 72
d0511		db	004h	; 00000100b . 02ad1 04
d0512		db	002h	; 00000010b . 02ad2 02
d0513		db	000h	; 00000000b . 02ad3 00
d0514		db	002h	; 00000010b . 02ad4 02
d0515		db	000h	; 00000000b . 02ad5 00
d0516		db	0b5h	; 10110101b . 02ad6 b5
d0517		db	004h	; 00000100b . 02ad7 04
d0518		db	0b5h	; 10110101b . 02ad8 b5
d0519		db	004h	; 00000100b . 02ad9 04
d051a		db	0b5h	; 10110101b . 02ada b5
d051b		db	004h	; 00000100b . 02adb 04
d051c		db	0b5h	; 10110101b . 02adc b5
d051d		db	004h	; 00000100b . 02add 04
d051e		db	072h	; 01110010b r 02ade 72
d051f		db	004h	; 00000100b . 02adf 04
d0520		db	072h	; 01110010b r 02ae0 72
d0521		db	004h	; 00000100b . 02ae1 04
d0522		db	072h	; 01110010b r 02ae2 72
d0523		db	004h	; 00000100b . 02ae3 04
d0524		db	072h	; 01110010b r 02ae4 72
d0525		db	004h	; 00000100b . 02ae5 04
d0526		db	0f5h	; 11110101b . 02ae6 f5
d0527		db	003h	; 00000011b . 02ae7 03
d0528		db	0f5h	; 11110101b . 02ae8 f5
d0529		db	003h	; 00000011b . 02ae9 03
d052a		db	002h	; 00000010b . 02aea 02
d052b		db	000h	; 00000000b . 02aeb 00
d052c		db	002h	; 00000010b . 02aec 02
d052d		db	000h	; 00000000b . 02aed 00
d052e		db	032h	; 00110010b 2 02aee 32
d052f		db	004h	; 00000100b . 02aef 04
d0530		db	032h	; 00110010b 2 02af0 32
d0531		db	004h	; 00000100b . 02af1 04
d0532		db	002h	; 00000010b . 02af2 02
d0533		db	000h	; 00000000b . 02af3 00
d0534		db	002h	; 00000010b . 02af4 02
d0535		db	000h	; 00000000b . 02af5 00
d0536		db	072h	; 01110010b r 02af6 72
d0537		db	004h	; 00000100b . 02af7 04
d0538		db	072h	; 01110010b r 02af8 72
d0539		db	004h	; 00000100b . 02af9 04
d053a		db	032h	; 00110010b 2 02afa 32
d053b		db	004h	; 00000100b . 02afb 04
d053c		db	032h	; 00110010b 2 02afc 32
d053d		db	004h	; 00000100b . 02afd 04
d053e		db	072h	; 01110010b r 02afe 72
d053f		db	004h	; 00000100b . 02aff 04
d0540		db	072h	; 01110010b r 02b00 72
d0541		db	004h	; 00000100b . 02b01 04
d0542		db	0b5h	; 10110101b . 02b02 b5
d0543		db	004h	; 00000100b . 02b03 04
d0544		db	0b5h	; 10110101b . 02b04 b5
d0545		db	004h	; 00000100b . 02b05 04
d0546		db	0fdh	; 11111101b . 02b06 fd
d0547		db	004h	; 00000100b . 02b07 04
d0548		db	0fdh	; 11111101b . 02b08 fd
d0549		db	004h	; 00000100b . 02b09 04
d054a		db	002h	; 00000010b . 02b0a 02
d054b		db	000h	; 00000000b . 02b0b 00
d054c		db	002h	; 00000010b . 02b0c 02
d054d		db	000h	; 00000000b . 02b0d 00
d054e		db	049h	; 01001001b I 02b0e 49
d054f		db	005h	; 00000101b . 02b0f 05
d0550		db	049h	; 01001001b I 02b10 49
d0551		db	005h	; 00000101b . 02b11 05
d0552		db	002h	; 00000010b . 02b12 02
d0553		db	000h	; 00000000b . 02b13 00
d0554		db	002h	; 00000010b . 02b14 02
d0555		db	000h	; 00000000b . 02b15 00
d0556		db	099h	; 10011001b . 02b16 99
d0557		db	005h	; 00000101b . 02b17 05
d0558		db	099h	; 10011001b . 02b18 99
d0559		db	005h	; 00000101b . 02b19 05
d055a		db	099h	; 10011001b . 02b1a 99
d055b		db	005h	; 00000101b . 02b1b 05
d055c		db	099h	; 10011001b . 02b1c 99
d055d		db	005h	; 00000101b . 02b1d 05
d055e		db	049h	; 01001001b I 02b1e 49
d055f		db	005h	; 00000101b . 02b1f 05
d0560		db	049h	; 01001001b I 02b20 49
d0561		db	005h	; 00000101b . 02b21 05
d0562		db	049h	; 01001001b I 02b22 49
d0563		db	005h	; 00000101b . 02b23 05
d0564		db	049h	; 01001001b I 02b24 49
d0565		db	005h	; 00000101b . 02b25 05
d0566		db	072h	; 01110010b r 02b26 72
d0567		db	004h	; 00000100b . 02b27 04
d0568		db	072h	; 01110010b r 02b28 72
d0569		db	004h	; 00000100b . 02b29 04
d056a		db	002h	; 00000010b . 02b2a 02
d056b		db	000h	; 00000000b . 02b2b 00
d056c		db	002h	; 00000010b . 02b2c 02
d056d		db	000h	; 00000000b . 02b2d 00
d056e		db	0eeh	; 11101110b . 02b2e ee
d056f		db	005h	; 00000101b . 02b2f 05
d0570		db	002h	; 00000010b . 02b30 02
d0571		db	000h	; 00000000b . 02b31 00
d0572		db	0eeh	; 11101110b . 02b32 ee
d0573		db	005h	; 00000101b . 02b33 05
d0574		db	002h	; 00000010b . 02b34 02
d0575		db	000h	; 00000000b . 02b35 00
d0576		db	049h	; 01001001b I 02b36 49
d0577		db	006h	; 00000110b . 02b37 06
d0578		db	049h	; 01001001b I 02b38 49
d0579		db	006h	; 00000110b . 02b39 06
d057a		db	049h	; 01001001b I 02b3a 49
d057b		db	006h	; 00000110b . 02b3b 06
d057c		db	049h	; 01001001b I 02b3c 49
d057d		db	006h	; 00000110b . 02b3d 06
d057e		db	0eeh	; 11101110b . 02b3e ee
d057f		db	005h	; 00000101b . 02b3f 05
d0580		db	0eeh	; 11101110b . 02b40 ee
d0581		db	005h	; 00000101b . 02b41 05
d0582		db	0eeh	; 11101110b . 02b42 ee
d0583		db	005h	; 00000101b . 02b43 05
d0584		db	0eeh	; 11101110b . 02b44 ee
d0585		db	005h	; 00000101b . 02b45 05
d0586		db	072h	; 01110010b r 02b46 72
d0587		db	004h	; 00000100b . 02b47 04
d0588		db	072h	; 01110010b r 02b48 72
d0589		db	004h	; 00000100b . 02b49 04
d058a		db	002h	; 00000010b . 02b4a 02
d058b		db	000h	; 00000000b . 02b4b 00
d058c		db	002h	; 00000010b . 02b4c 02
d058d		db	000h	; 00000000b . 02b4d 00
d058e		db	0eeh	; 11101110b . 02b4e ee
d058f		db	005h	; 00000101b . 02b4f 05
d0590		db	002h	; 00000010b . 02b50 02
d0591		db	000h	; 00000000b . 02b51 00
d0592		db	0eeh	; 11101110b . 02b52 ee
d0593		db	005h	; 00000101b . 02b53 05
d0594		db	002h	; 00000010b . 02b54 02
d0595		db	000h	; 00000000b . 02b55 00
d0596		db	049h	; 01001001b I 02b56 49
d0597		db	006h	; 00000110b . 02b57 06
d0598		db	049h	; 01001001b I 02b58 49
d0599		db	006h	; 00000110b . 02b59 06
d059a		db	049h	; 01001001b I 02b5a 49
d059b		db	006h	; 00000110b . 02b5b 06
d059c		db	049h	; 01001001b I 02b5c 49
d059d		db	006h	; 00000110b . 02b5d 06
d059e		db	0eeh	; 11101110b . 02b5e ee
d059f		db	005h	; 00000101b . 02b5f 05
d05a0		db	0eeh	; 11101110b . 02b60 ee
d05a1		db	005h	; 00000101b . 02b61 05
d05a2		db	0eeh	; 11101110b . 02b62 ee
d05a3		db	005h	; 00000101b . 02b63 05
d05a4		db	0eeh	; 11101110b . 02b64 ee
d05a5		db	005h	; 00000101b . 02b65 05
d05a6		db	00eh	; 00001110b . 02b66 0e
d05a7		db	007h	; 00000111b . 02b67 07
d05a8		db	00eh	; 00001110b . 02b68 0e
d05a9		db	007h	; 00000111b . 02b69 07
d05aa		db	0a8h	; 10101000b . 02b6a a8
d05ab		db	006h	; 00000110b . 02b6b 06
d05ac		db	0a8h	; 10101000b . 02b6c a8
d05ad		db	006h	; 00000110b . 02b6d 06
d05ae		db	049h	; 01001001b I 02b6e 49
d05af		db	006h	; 00000110b . 02b6f 06
d05b0		db	049h	; 01001001b I 02b70 49
d05b1		db	006h	; 00000110b . 02b71 06
d05b2		db	0eeh	; 11101110b . 02b72 ee
d05b3		db	005h	; 00000101b . 02b73 05
d05b4		db	0eeh	; 11101110b . 02b74 ee
d05b5		db	005h	; 00000101b . 02b75 05
d05b6		db	099h	; 10011001b . 02b76 99
d05b7		db	005h	; 00000101b . 02b77 05
d05b8		db	099h	; 10011001b . 02b78 99
d05b9		db	005h	; 00000101b . 02b79 05
d05ba		db	049h	; 01001001b I 02b7a 49
d05bb		db	005h	; 00000101b . 02b7b 05
d05bc		db	049h	; 01001001b I 02b7c 49
d05bd		db	005h	; 00000101b . 02b7d 05
d05be		db	0fdh	; 11111101b . 02b7e fd
d05bf		db	004h	; 00000100b . 02b7f 04
d05c0		db	0fdh	; 11111101b . 02b80 fd
d05c1		db	004h	; 00000100b . 02b81 04
d05c2		db	0b5h	; 10110101b . 02b82 b5
d05c3		db	004h	; 00000100b . 02b83 04
d05c4		db	0b5h	; 10110101b . 02b84 b5
d05c5		db	004h	; 00000100b . 02b85 04
d05c6		db	072h	; 01110010b r 02b86 72
d05c7		db	004h	; 00000100b . 02b87 04
d05c8		db	072h	; 01110010b r 02b88 72
d05c9		db	004h	; 00000100b . 02b89 04
d05ca		db	002h	; 00000010b . 02b8a 02
d05cb		db	000h	; 00000000b . 02b8b 00
d05cc		db	002h	; 00000010b . 02b8c 02
d05cd		db	000h	; 00000000b . 02b8d 00
d05ce		db	032h	; 00110010b 2 02b8e 32
d05cf		db	004h	; 00000100b . 02b8f 04
d05d0		db	032h	; 00110010b 2 02b90 32
d05d1		db	004h	; 00000100b . 02b91 04
d05d2		db	002h	; 00000010b . 02b92 02
d05d3		db	000h	; 00000000b . 02b93 00
d05d4		db	002h	; 00000010b . 02b94 02
d05d5		db	000h	; 00000000b . 02b95 00
d05d6		db	0f5h	; 11110101b . 02b96 f5
d05d7		db	003h	; 00000011b . 02b97 03
d05d8		db	0f5h	; 11110101b . 02b98 f5
d05d9		db	003h	; 00000011b . 02b99 03
d05da		db	002h	; 00000010b . 02b9a 02
d05db		db	000h	; 00000000b . 02b9b 00
d05dc		db	002h	; 00000010b . 02b9c 02
d05dd		db	000h	; 00000000b . 02b9d 00
d05de		db	087h	; 10000111b . 02b9e 87
d05df		db	003h	; 00000011b . 02b9f 03
d05e0		db	087h	; 10000111b . 02ba0 87
d05e1		db	003h	; 00000011b . 02ba1 03
d05e2		db	002h	; 00000010b . 02ba2 02
d05e3		db	000h	; 00000000b . 02ba3 00
d05e4		db	002h	; 00000010b . 02ba4 02
d05e5		db	000h	; 00000000b . 02ba5 00
d05e6		db	054h	; 01010100b T 02ba6 54
d05e7		db	003h	; 00000011b . 02ba7 03
d05e8		db	054h	; 01010100b T 02ba8 54
d05e9		db	003h	; 00000011b . 02ba9 03
d05ea		db	054h	; 01010100b T 02baa 54
d05eb		db	003h	; 00000011b . 02bab 03
d05ec		db	054h	; 01010100b T 02bac 54
d05ed		db	003h	; 00000011b . 02bad 03
d05ee		db	054h	; 01010100b T 02bae 54
d05ef		db	003h	; 00000011b . 02baf 03
d05f0		db	054h	; 01010100b T 02bb0 54
d05f1		db	003h	; 00000011b . 02bb1 03
d05f2		db	054h	; 01010100b T 02bb2 54
d05f3		db	003h	; 00000011b . 02bb3 03
d05f4		db	054h	; 01010100b T 02bb4 54
d05f5		db	003h	; 00000011b . 02bb5 03
d05f6		db	002h	; 00000010b . 02bb6 02
d05f7		db	000h	; 00000000b . 02bb7 00
d05f8		db	013h	; 00010011b . 02bb8 13
d05f9		db	009h	; 00001001b . 02bb9 09
d05fa		db	062h	; 01100010b b 02bba 62
d05fb		db	079h	; 01111001b y 02bbb 79
d05fc		db	000h	; 00000000b . 02bbc 00
d05fd		db	00dh	; 00001101b . 02bbd 0d
d05fe		db	00bh	; 00001011b . 02bbe 0b
d05ff		db	047h	; 01000111b G 02bbf 47
d0600		db	072h	; 01110010b r 02bc0 72
d0601		db	065h	; 01100101b e 02bc1 65
d0602		db	067h	; 01100111b g 02bc2 67
d0603		db	020h	; 00100000b   02bc3 20
d0604		db	04bh	; 01001011b K 02bc4 4b
d0605		db	075h	; 01110101b u 02bc5 75
d0606		db	070h	; 01110000b p 02bc6 70
d0607		db	065h	; 01100101b e 02bc7 65
d0608		db	072h	; 01110010b r 02bc8 72
d0609		db	062h	; 01100010b b 02bc9 62
d060a		db	065h	; 01100101b e 02bca 65
d060b		db	072h	; 01110010b r 02bcb 72
d060c		db	067h	; 01100111b g 02bcc 67
d060d		db	000h	; 00000000b . 02bcd 00
d060e		db	003h	; 00000011b . 02bce 03
d060f		db	010h	; 00010000b . 02bcf 10
d0610		db	050h	; 01010000b P 02bd0 50
d0611		db	052h	; 01010010b R 02bd1 52
d0612		db	045h	; 01000101b E 02bd2 45
d0613		db	053h	; 01010011b S 02bd3 53
d0614		db	053h	; 01010011b S 02bd4 53
d0615		db	020h	; 00100000b   02bd5 20
d0616		db	073h	; 01110011b s 02bd6 73
d0617		db	070h	; 01110000b p 02bd7 70
d0618		db	061h	; 01100001b a 02bd8 61
d0619		db	063h	; 01100011b c 02bd9 63
d061a		db	065h	; 01100101b e 02bda 65
d061b		db	020h	; 00100000b   02bdb 20
d061c		db	062h	; 01100010b b 02bdc 62
d061d		db	061h	; 01100001b a 02bdd 61
d061e		db	072h	; 01110010b r 02bde 72
d061f		db	020h	; 00100000b   02bdf 20
d0620		db	046h	; 01000110b F 02be0 46
d0621		db	04fh	; 01001111b O 02be1 4f
d0622		db	052h	; 01010010b R 02be2 52
d0623		db	020h	; 00100000b   02be3 20
d0624		db	04bh	; 01001011b K 02be4 4b
d0625		db	045h	; 01000101b E 02be5 45
d0626		db	059h	; 01011001b Y 02be6 59
d0627		db	042h	; 01000010b B 02be7 42
d0628		db	04fh	; 01001111b O 02be8 4f
d0629		db	041h	; 01000001b A 02be9 41
d062a		db	052h	; 01010010b R 02bea 52
d062b		db	044h	; 01000100b D 02beb 44
d062c		db	020h	; 00100000b   02bec 20
d062d		db	050h	; 01010000b P 02bed 50
d062e		db	04ch	; 01001100b L 02bee 4c
d062f		db	041h	; 01000001b A 02bef 41
d0630		db	059h	; 01011001b Y 02bf0 59
d0631		db	000h	; 00000000b . 02bf1 00
d0632		db	002h	; 00000010b . 02bf2 02
d0633		db	012h	; 00010010b . 02bf3 12
d0634		db	04fh	; 01001111b O 02bf4 4f
d0635		db	052h	; 01010010b R 02bf5 52
d0636		db	020h	; 00100000b   02bf6 20
d0637		db	06ah	; 01101010b j 02bf7 6a
d0638		db	06fh	; 01101111b o 02bf8 6f
d0639		db	079h	; 01111001b y 02bf9 79
d063a		db	073h	; 01110011b s 02bfa 73
d063b		db	074h	; 01110100b t 02bfb 74
d063c		db	069h	; 01101001b i 02bfc 69
d063d		db	063h	; 01100011b c 02bfd 63
d063e		db	06bh	; 01101011b k 02bfe 6b
d063f		db	020h	; 00100000b   02bff 20
d0640		db	062h	; 01100010b b 02c00 62
d0641		db	075h	; 01110101b u 02c01 75
d0642		db	074h	; 01110100b t 02c02 74
d0643		db	074h	; 01110100b t 02c03 74
d0644		db	06fh	; 01101111b o 02c04 6f
d0645		db	06eh	; 01101110b n 02c05 6e
d0646		db	020h	; 00100000b   02c06 20
d0647		db	046h	; 01000110b F 02c07 46
d0648		db	04fh	; 01001111b O 02c08 4f
d0649		db	052h	; 01010010b R 02c09 52
d064a		db	020h	; 00100000b   02c0a 20
d064b		db	04ah	; 01001010b J 02c0b 4a
d064c		db	04fh	; 01001111b O 02c0c 4f
d064d		db	059h	; 01011001b Y 02c0d 59
d064e		db	053h	; 01010011b S 02c0e 53
d064f		db	054h	; 01010100b T 02c0f 54
d0650		db	049h	; 01001001b I 02c10 49
d0651		db	043h	; 01000011b C 02c11 43
d0652		db	04bh	; 01001011b K 02c12 4b
d0653		db	020h	; 00100000b   02c13 20
d0654		db	050h	; 01010000b P 02c14 50
d0655		db	04ch	; 01001100b L 02c15 4c
d0656		db	041h	; 01000001b A 02c16 41
d0657		db	059h	; 01011001b Y 02c17 59
d0658		db	000h	; 00000000b . 02c18 00
d0659		db	006h	; 00000110b . 02c19 06
d065a		db	018h	; 00011000b . 02c1a 18
d065b		db	028h	; 00101000b ( 02c1b 28
d065c		db	043h	; 01000011b C 02c1c 43
d065d		db	029h	; 00101001b ) 02c1d 29
d065e		db	031h	; 00110001b 1 02c1e 31
d065f		db	039h	; 00111001b 9 02c1f 39
d0660		db	038h	; 00111000b 8 02c20 38
d0661		db	032h	; 00110010b 2 02c21 32
d0662		db	020h	; 00100000b   02c22 20
d0663		db	04fh	; 01001111b O 02c23 4f
d0664		db	052h	; 01010010b R 02c24 52
d0665		db	049h	; 01001001b I 02c25 49
d0666		db	04fh	; 01001111b O 02c26 4f
d0667		db	04eh	; 01001110b N 02c27 4e
d0668		db	020h	; 00100000b   02c28 20
d0669		db	053h	; 01010011b S 02c29 53
d066a		db	04fh	; 01001111b O 02c2a 4f
d066b		db	046h	; 01000110b F 02c2b 46
d066c		db	054h	; 01010100b T 02c2c 54
d066d		db	057h	; 01010111b W 02c2d 57
d066e		db	041h	; 01000001b A 02c2e 41
d066f		db	052h	; 01010010b R 02c2f 52
d0670		db	045h	; 01000101b E 02c30 45
d0671		db	02ch	; 00101100b , 02c31 2c
d0672		db	020h	; 00100000b   02c32 20
d0673		db	049h	; 01001001b I 02c33 49
d0674		db	04eh	; 01001110b N 02c34 4e
d0675		db	043h	; 01000011b C 02c35 43
d0676		db	02eh	; 00101110b . 02c36 2e
d0677		db	000h	; 00000000b . 02c37 00
d0678		db	003h	; 00000011b . 02c38 03
d0679		db	00ch	; 00001100b . 02c39 0c
d067a		db	050h	; 01010000b P 02c3a 50
d067b		db	052h	; 01010010b R 02c3b 52
d067c		db	045h	; 01000101b E 02c3c 45
d067d		db	053h	; 01010011b S 02c3d 53
d067e		db	053h	; 01010011b S 02c3e 53
d067f		db	020h	; 00100000b   02c3f 20
d0680		db	073h	; 01110011b s 02c40 73
d0681		db	070h	; 01110000b p 02c41 70
d0682		db	061h	; 01100001b a 02c42 61
d0683		db	063h	; 01100011b c 02c43 63
d0684		db	065h	; 01100101b e 02c44 65
d0685		db	020h	; 00100000b   02c45 20
d0686		db	062h	; 01100010b b 02c46 62
d0687		db	061h	; 01100001b a 02c47 61
d0688		db	072h	; 01110010b r 02c48 72
d0689		db	020h	; 00100000b   02c49 20
d068a		db	046h	; 01000110b F 02c4a 46
d068b		db	04fh	; 01001111b O 02c4b 4f
d068c		db	052h	; 01010010b R 02c4c 52
d068d		db	020h	; 00100000b   02c4d 20
d068e		db	04bh	; 01001011b K 02c4e 4b
d068f		db	045h	; 01000101b E 02c4f 45
d0690		db	059h	; 01011001b Y 02c50 59
d0691		db	042h	; 01000010b B 02c51 42
d0692		db	04fh	; 01001111b O 02c52 4f
d0693		db	041h	; 01000001b A 02c53 41
d0694		db	052h	; 01010010b R 02c54 52
d0695		db	044h	; 01000100b D 02c55 44
d0696		db	020h	; 00100000b   02c56 20
d0697		db	050h	; 01010000b P 02c57 50
d0698		db	04ch	; 01001100b L 02c58 4c
d0699		db	041h	; 01000001b A 02c59 41
d069a		db	059h	; 01011001b Y 02c5a 59
d069b		db	000h	; 00000000b . 02c5b 00
d069c		db	002h	; 00000010b . 02c5c 02
d069d		db	00eh	; 00001110b . 02c5d 0e
d069e		db	04fh	; 01001111b O 02c5e 4f
d069f		db	052h	; 01010010b R 02c5f 52
d06a0		db	020h	; 00100000b   02c60 20
d06a1		db	06ah	; 01101010b j 02c61 6a
d06a2		db	06fh	; 01101111b o 02c62 6f
d06a3		db	079h	; 01111001b y 02c63 79
d06a4		db	073h	; 01110011b s 02c64 73
d06a5		db	074h	; 01110100b t 02c65 74
d06a6		db	069h	; 01101001b i 02c66 69
d06a7		db	063h	; 01100011b c 02c67 63
d06a8		db	06bh	; 01101011b k 02c68 6b
d06a9		db	020h	; 00100000b   02c69 20
d06aa		db	062h	; 01100010b b 02c6a 62
d06ab		db	075h	; 01110101b u 02c6b 75
d06ac		db	074h	; 01110100b t 02c6c 74
d06ad		db	074h	; 01110100b t 02c6d 74
d06ae		db	06fh	; 01101111b o 02c6e 6f
d06af		db	06eh	; 01101110b n 02c6f 6e
d06b0		db	020h	; 00100000b   02c70 20
d06b1		db	046h	; 01000110b F 02c71 46
d06b2		db	04fh	; 01001111b O 02c72 4f
d06b3		db	052h	; 01010010b R 02c73 52
d06b4		db	020h	; 00100000b   02c74 20
d06b5		db	04ah	; 01001010b J 02c75 4a
d06b6		db	04fh	; 01001111b O 02c76 4f
d06b7		db	059h	; 01011001b Y 02c77 59
d06b8		db	053h	; 01010011b S 02c78 53
d06b9		db	054h	; 01010100b T 02c79 54
d06ba		db	049h	; 01001001b I 02c7a 49
d06bb		db	043h	; 01000011b C 02c7b 43
d06bc		db	04bh	; 01001011b K 02c7c 4b
d06bd		db	020h	; 00100000b   02c7d 20
d06be		db	050h	; 01010000b P 02c7e 50
d06bf		db	04ch	; 01001100b L 02c7f 4c
d06c0		db	041h	; 01000001b A 02c80 41
d06c1		db	059h	; 01011001b Y 02c81 59
d06c2		db	000h	; 00000000b . 02c82 00
d06c3		db	053h	; 01010011b S 02c83 53
d06c4		db	043h	; 01000011b C 02c84 43
d06c5		db	04fh	; 01001111b O 02c85 4f
d06c6		db	052h	; 01010010b R 02c86 52
d06c7		db	045h	; 01000101b E 02c87 45
d06c8		db	00dh	; 00001101b . 02c88 0d
d06c9		db	00ah	; 00001010b . 02c89 0a
d06ca		db	020h	; 00100000b   02c8a 20
d06cb		db	020h	; 00100000b   02c8b 20
d06cc		db	020h	; 00100000b   02c8c 20
d06cd		db	020h	; 00100000b   02c8d 20
d06ce		db	020h	; 00100000b   02c8e 20
d06cf		db	030h	; 00110000b 0 02c8f 30
d06d0		db	00dh	; 00001101b . 02c90 0d
d06d1		db	00ah	; 00001010b . 02c91 0a
d06d2		db	00ah	; 00001010b . 02c92 0a
d06d3		db	00ah	; 00001010b . 02c93 0a
d06d4		db	00ah	; 00001010b . 02c94 0a
d06d5		db	020h	; 00100000b   02c95 20
d06d6		db	048h	; 01001000b H 02c96 48
d06d7		db	049h	; 01001001b I 02c97 49
d06d8		db	047h	; 01000111b G 02c98 47
d06d9		db	048h	; 01001000b H 02c99 48
d06da		db	00dh	; 00001101b . 02c9a 0d
d06db		db	00ah	; 00001010b . 02c9b 0a
d06dc		db	020h	; 00100000b   02c9c 20
d06dd		db	053h	; 01010011b S 02c9d 53
d06de		db	043h	; 01000011b C 02c9e 43
d06df		db	04fh	; 01001111b O 02c9f 4f
d06e0		db	052h	; 01010010b R 02ca0 52
d06e1		db	045h	; 01000101b E 02ca1 45
d06e2		db	00dh	; 00001101b . 02ca2 0d
d06e3		db	00ah	; 00001010b . 02ca3 0a
d06e4		db	020h	; 00100000b   02ca4 20
d06e5		db	020h	; 00100000b   02ca5 20
d06e6		db	020h	; 00100000b   02ca6 20
d06e7		db	020h	; 00100000b   02ca7 20
d06e8		db	020h	; 00100000b   02ca8 20
d06e9		db	030h	; 00110000b 0 02ca9 30
d06ea		db	021h	; 00100001b ! 02caa 21
d06eb		db	059h	; 01011001b Y 02cab 59
d06ec		db	044h	; 01000100b D 02cac 44
d06ed		db	041h	; 01000001b A 02cad 41
d06ee		db	045h	; 01000101b E 02cae 45
d06ef		db	052h	; 01010010b R 02caf 52
d06f0		db	003h	; 00000011b . 02cb0 03
d06f1		db	000h	; 00000000b . 02cb1 00
d06f2		db	000h	; 00000000b . 02cb2 00
d06f3		db	0c8h	; 11001000b . 02cb3 c8
d06f4		db	00ch	; 00001100b . 02cb4 0c
d06f5		db	000h	; 00000000b . 02cb5 00
d06f6		db	020h	; 00100000b   02cb6 20
d06f7		db	078h	; 01111000b x 02cb7 78
d06f8		db	01ch	; 00011100b . 02cb8 1c
d06f9		db	000h	; 00000000b . 02cb9 00
d06fa		db	020h	; 00100000b   02cba 20
d06fb		db	096h	; 10010110b . 02cbb 96
d06fc		db	01ch	; 00011100b . 02cbc 1c
d06fd		db	000h	; 00000000b . 02cbd 00
d06fe		db	028h	; 00101000b ( 02cbe 28
d06ff		db	05ah	; 01011010b Z 02cbf 5a
d0700		db	01ch	; 00011100b . 02cc0 1c
d0701		db	000h	; 00000000b . 02cc1 00
d0702		db	028h	; 00101000b ( 02cc2 28
d0703		db	078h	; 01111000b x 02cc3 78
d0704		db	03ch	; 00111100b < 02cc4 3c
d0705		db	000h	; 00000000b . 02cc5 00
d0706		db	040h	; 01000000b @ 02cc6 40
d0707		db	03ch	; 00111100b < 02cc7 3c
d0708		db	03ch	; 00111100b < 02cc8 3c
d0709		db	000h	; 00000000b . 02cc9 00
d070a		db	040h	; 01000000b @ 02cca 40
d070b		db	03ch	; 00111100b < 02ccb 3c
d070c		db	03ch	; 00111100b < 02ccc 3c
d070d		db	000h	; 00000000b . 02ccd 00
d070e		db	040h	; 01000000b @ 02cce 40
d070f		db	01eh	; 00011110b . 02ccf 1e
d0710		db	03ch	; 00111100b < 02cd0 3c
d0711		db	000h	; 00000000b . 02cd1 00
d0712		db	050h	; 01010000b P 02cd2 50
d0713		db	00ah	; 00001010b . 02cd3 0a
d0714		db	03ch	; 00111100b < 02cd4 3c
d0715		db	000h	; 00000000b . 02cd5 00
d0716		db	080h	; 10000000b . 02cd6 80
d0717		db	014h	; 00010100b . 02cd7 14
d0718		db	03ch	; 00111100b < 02cd8 3c
d0719		db	000h	; 00000000b . 02cd9 00
d071a		db	080h	; 10000000b . 02cda 80
d071b		db	005h	; 00000101b . 02cdb 05
d071c		db	03ch	; 00111100b < 02cdc 3c
d071d		db	000h	; 00000000b . 02cdd 00
d071e		db	080h	; 10000000b . 02cde 80
d071f		db	005h	; 00000101b . 02cdf 05
d0720		db	03ch	; 00111100b < 02ce0 3c
d0721		db	0ffh	; 11111111b . 02ce1 ff
d0722		db	0ffh	; 11111111b . 02ce2 ff
d0723		db	000h	; 00000000b . 02ce3 00
d0724		db	000h	; 00000000b . 02ce4 00
d0725		db	000h	; 00000000b . 02ce5 00
d0726		db	07ah	; 01111010b z 02ce6 7a
d0727		db	02eh	; 00101110b . 02ce7 2e
d0728		db	019h	; 00011001b . 02ce8 19
d0729		db	00eh	; 00001110b . 02ce9 0e
d072a		db	000h	; 00000000b . 02cea 00
d072b		db	07ah	; 01111010b z 02ceb 7a
d072c		db	02eh	; 00101110b . 02cec 2e
d072d		db	00eh	; 00001110b . 02ced 0e
d072e		db	00eh	; 00001110b . 02cee 0e
d072f		db	000h	; 00000000b . 02cef 00
d0730		db	000h	; 00000000b . 02cf0 00
d0731		db	000h	; 00000000b . 02cf1 00
d0732		db	000h	; 00000000b . 02cf2 00
d0733		db	000h	; 00000000b . 02cf3 00
d0734		db	000h	; 00000000b . 02cf4 00
d0735		db	000h	; 00000000b . 02cf5 00
d0736		db	000h	; 00000000b . 02cf6 00
d0737		db	000h	; 00000000b . 02cf7 00
d0738		db	000h	; 00000000b . 02cf8 00
d0739		db	000h	; 00000000b . 02cf9 00
d073a		db	000h	; 00000000b . 02cfa 00
d073b		db	000h	; 00000000b . 02cfb 00
d073c		db	000h	; 00000000b . 02cfc 00
d073d		db	000h	; 00000000b . 02cfd 00
d073e		db	000h	; 00000000b . 02cfe 00
d073f		db	000h	; 00000000b . 02cff 00
d0740		db	000h	; 00000000b . 02d00 00
d0741		db	000h	; 00000000b . 02d01 00
d0742		db	000h	; 00000000b . 02d02 00
d0743		db	000h	; 00000000b . 02d03 00
d0744		db	000h	; 00000000b . 02d04 00
d0745		db	000h	; 00000000b . 02d05 00
d0746		db	000h	; 00000000b . 02d06 00
d0747		db	000h	; 00000000b . 02d07 00
d0748		db	000h	; 00000000b . 02d08 00
d0749		db	000h	; 00000000b . 02d09 00
d074a		db	000h	; 00000000b . 02d0a 00
d074b		db	000h	; 00000000b . 02d0b 00
d074c		db	000h	; 00000000b . 02d0c 00
d074d		db	000h	; 00000000b . 02d0d 00
d074e		db	000h	; 00000000b . 02d0e 00
d074f		db	000h	; 00000000b . 02d0f 00
d0750		db	000h	; 00000000b . 02d10 00
d0751		db	000h	; 00000000b . 02d11 00
d0752		db	000h	; 00000000b . 02d12 00
d0753		db	000h	; 00000000b . 02d13 00
d0754		db	000h	; 00000000b . 02d14 00
d0755		db	000h	; 00000000b . 02d15 00
d0756		db	000h	; 00000000b . 02d16 00
d0757		db	000h	; 00000000b . 02d17 00
d0758		db	000h	; 00000000b . 02d18 00
d0759		db	000h	; 00000000b . 02d19 00
d075a		db	000h	; 00000000b . 02d1a 00
d075b		db	000h	; 00000000b . 02d1b 00
d075c		db	000h	; 00000000b . 02d1c 00
d075d		db	000h	; 00000000b . 02d1d 00
d075e		db	000h	; 00000000b . 02d1e 00
d075f		db	000h	; 00000000b . 02d1f 00
d0760		db	000h	; 00000000b . 02d20 00
d0761		db	000h	; 00000000b . 02d21 00
d0762		db	000h	; 00000000b . 02d22 00
d0763		db	000h	; 00000000b . 02d23 00
d0764		db	000h	; 00000000b . 02d24 00
d0765		db	000h	; 00000000b . 02d25 00
d0766		db	000h	; 00000000b . 02d26 00
d0767		db	000h	; 00000000b . 02d27 00
d0768		db	000h	; 00000000b . 02d28 00
d0769		db	000h	; 00000000b . 02d29 00
d076a		db	000h	; 00000000b . 02d2a 00
d076b		db	000h	; 00000000b . 02d2b 00
d076c		db	000h	; 00000000b . 02d2c 00
d076d		db	000h	; 00000000b . 02d2d 00
d076e		db	000h	; 00000000b . 02d2e 00
d076f		db	000h	; 00000000b . 02d2f 00
d0770		db	000h	; 00000000b . 02d30 00
d0771		db	000h	; 00000000b . 02d31 00
d0772		db	000h	; 00000000b . 02d32 00
d0773		db	000h	; 00000000b . 02d33 00
d0774		db	000h	; 00000000b . 02d34 00
d0775		db	000h	; 00000000b . 02d35 00
d0776		db	000h	; 00000000b . 02d36 00
d0777		db	000h	; 00000000b . 02d37 00
d0778		db	000h	; 00000000b . 02d38 00
d0779		db	000h	; 00000000b . 02d39 00
d077a		db	000h	; 00000000b . 02d3a 00
d077b		db	000h	; 00000000b . 02d3b 00
d077c		db	000h	; 00000000b . 02d3c 00
d077d		db	000h	; 00000000b . 02d3d 00
d077e		db	000h	; 00000000b . 02d3e 00
d077f		db	000h	; 00000000b . 02d3f 00
d0780		db	000h	; 00000000b . 02d40 00
d0781		db	000h	; 00000000b . 02d41 00
d0782		db	000h	; 00000000b . 02d42 00
d0783		db	000h	; 00000000b . 02d43 00
d0784		db	000h	; 00000000b . 02d44 00
d0785		db	000h	; 00000000b . 02d45 00
d0786		db	000h	; 00000000b . 02d46 00
d0787		db	000h	; 00000000b . 02d47 00
d0788		db	000h	; 00000000b . 02d48 00
d0789		db	000h	; 00000000b . 02d49 00
d078a		db	000h	; 00000000b . 02d4a 00
d078b		db	000h	; 00000000b . 02d4b 00
d078c		db	000h	; 00000000b . 02d4c 00
d078d		db	000h	; 00000000b . 02d4d 00
d078e		db	000h	; 00000000b . 02d4e 00
d078f		db	000h	; 00000000b . 02d4f 00
d0790		db	000h	; 00000000b . 02d50 00
d0791		db	000h	; 00000000b . 02d51 00
d0792		db	000h	; 00000000b . 02d52 00
d0793		db	000h	; 00000000b . 02d53 00
d0794		db	000h	; 00000000b . 02d54 00
d0795		db	000h	; 00000000b . 02d55 00
d0796		db	000h	; 00000000b . 02d56 00
d0797		db	000h	; 00000000b . 02d57 00
d0798		db	000h	; 00000000b . 02d58 00
d0799		db	000h	; 00000000b . 02d59 00
d079a		db	000h	; 00000000b . 02d5a 00
d079b		db	000h	; 00000000b . 02d5b 00
d079c		db	000h	; 00000000b . 02d5c 00
d079d		db	000h	; 00000000b . 02d5d 00
d079e		db	000h	; 00000000b . 02d5e 00
d079f		db	000h	; 00000000b . 02d5f 00
d07a0		db	000h	; 00000000b . 02d60 00
d07a1		db	002h	; 00000010b . 02d61 02
d07a2		db	06dh	; 01101101b m 02d62 6d
d07a3		db	030h	; 00110000b 0 02d63 30
d07a4		db	01ah	; 00011010b . 02d64 1a
d07a5		db	026h	; 00100110b & 02d65 26
d07a6		db	000h	; 00000000b . 02d66 00
d07a7		db	06dh	; 01101101b m 02d67 6d
d07a8		db	030h	; 00110000b 0 02d68 30
d07a9		db	00eh	; 00001110b . 02d69 0e
d07aa		db	00eh	; 00001110b . 02d6a 0e
d07ab		db	000h	; 00000000b . 02d6b 00
d07ac		db	004h	; 00000100b . 02d6c 04
d07ad		db	000h	; 00000000b . 02d6d 00
d07ae		db	000h	; 00000000b . 02d6e 00
d07af		db	000h	; 00000000b . 02d6f 00
d07b0		db	000h	; 00000000b . 02d70 00
d07b1		db	000h	; 00000000b . 02d71 00
d07b2		db	000h	; 00000000b . 02d72 00
d07b3		db	000h	; 00000000b . 02d73 00
d07b4		db	000h	; 00000000b . 02d74 00
d07b5		db	000h	; 00000000b . 02d75 00
d07b6		db	000h	; 00000000b . 02d76 00
d07b7		db	000h	; 00000000b . 02d77 00
d07b8		db	000h	; 00000000b . 02d78 00
d07b9		db	000h	; 00000000b . 02d79 00
d07ba		db	000h	; 00000000b . 02d7a 00
d07bb		db	000h	; 00000000b . 02d7b 00
d07bc		db	000h	; 00000000b . 02d7c 00
d07bd		db	000h	; 00000000b . 02d7d 00
d07be		db	000h	; 00000000b . 02d7e 00
d07bf		db	000h	; 00000000b . 02d7f 00
d07c0		db	000h	; 00000000b . 02d80 00
d07c1		db	000h	; 00000000b . 02d81 00
d07c2		db	000h	; 00000000b . 02d82 00
d07c3		db	000h	; 00000000b . 02d83 00
d07c4		db	000h	; 00000000b . 02d84 00
d07c5		db	000h	; 00000000b . 02d85 00
d07c6		db	000h	; 00000000b . 02d86 00
d07c7		db	000h	; 00000000b . 02d87 00
d07c8		db	000h	; 00000000b . 02d88 00
d07c9		db	000h	; 00000000b . 02d89 00
d07ca		db	000h	; 00000000b . 02d8a 00
d07cb		db	000h	; 00000000b . 02d8b 00
d07cc		db	000h	; 00000000b . 02d8c 00
d07cd		db	000h	; 00000000b . 02d8d 00
d07ce		db	000h	; 00000000b . 02d8e 00
d07cf		db	000h	; 00000000b . 02d8f 00
d07d0		db	000h	; 00000000b . 02d90 00
d07d1		db	000h	; 00000000b . 02d91 00
d07d2		db	000h	; 00000000b . 02d92 00
d07d3		db	000h	; 00000000b . 02d93 00
d07d4		db	000h	; 00000000b . 02d94 00
d07d5		db	000h	; 00000000b . 02d95 00
d07d6		db	000h	; 00000000b . 02d96 00
d07d7		db	000h	; 00000000b . 02d97 00
d07d8		db	000h	; 00000000b . 02d98 00
d07d9		db	000h	; 00000000b . 02d99 00
d07da		db	000h	; 00000000b . 02d9a 00
d07db		db	000h	; 00000000b . 02d9b 00
d07dc		db	000h	; 00000000b . 02d9c 00
d07dd		db	000h	; 00000000b . 02d9d 00
d07de		db	000h	; 00000000b . 02d9e 00
d07df		db	000h	; 00000000b . 02d9f 00
d07e0		db	000h	; 00000000b . 02da0 00
d07e1		db	000h	; 00000000b . 02da1 00
d07e2		db	000h	; 00000000b . 02da2 00
d07e3		db	000h	; 00000000b . 02da3 00
d07e4		db	000h	; 00000000b . 02da4 00
d07e5		db	000h	; 00000000b . 02da5 00
d07e6		db	000h	; 00000000b . 02da6 00
d07e7		db	000h	; 00000000b . 02da7 00
d07e8		db	000h	; 00000000b . 02da8 00
d07e9		db	000h	; 00000000b . 02da9 00
d07ea		db	000h	; 00000000b . 02daa 00
d07eb		db	000h	; 00000000b . 02dab 00
d07ec		db	000h	; 00000000b . 02dac 00
d07ed		db	000h	; 00000000b . 02dad 00
d07ee		db	000h	; 00000000b . 02dae 00
d07ef		db	000h	; 00000000b . 02daf 00
d07f0		db	000h	; 00000000b . 02db0 00
d07f1		db	000h	; 00000000b . 02db1 00
d07f2		db	000h	; 00000000b . 02db2 00
d07f3		db	000h	; 00000000b . 02db3 00
d07f4		db	000h	; 00000000b . 02db4 00
d07f5		db	000h	; 00000000b . 02db5 00
d07f6		db	000h	; 00000000b . 02db6 00
d07f7		db	000h	; 00000000b . 02db7 00
d07f8		db	000h	; 00000000b . 02db8 00
d07f9		db	000h	; 00000000b . 02db9 00
d07fa		db	000h	; 00000000b . 02dba 00
d07fb		db	000h	; 00000000b . 02dbb 00
d07fc		db	000h	; 00000000b . 02dbc 00
d07fd		db	000h	; 00000000b . 02dbd 00
d07fe		db	000h	; 00000000b . 02dbe 00
d07ff		db	000h	; 00000000b . 02dbf 00
d0800		db	000h	; 00000000b . 02dc0 00
d0801		db	000h	; 00000000b . 02dc1 00
d0802		db	000h	; 00000000b . 02dc2 00
d0803		db	000h	; 00000000b . 02dc3 00
d0804		db	000h	; 00000000b . 02dc4 00
d0805		db	000h	; 00000000b . 02dc5 00
d0806		db	000h	; 00000000b . 02dc6 00
d0807		db	000h	; 00000000b . 02dc7 00
d0808		db	000h	; 00000000b . 02dc8 00
d0809		db	000h	; 00000000b . 02dc9 00
d080a		db	000h	; 00000000b . 02dca 00
d080b		db	000h	; 00000000b . 02dcb 00
d080c		db	000h	; 00000000b . 02dcc 00
d080d		db	000h	; 00000000b . 02dcd 00
d080e		db	000h	; 00000000b . 02dce 00
d080f		db	000h	; 00000000b . 02dcf 00
d0810		db	000h	; 00000000b . 02dd0 00
d0811		db	000h	; 00000000b . 02dd1 00
d0812		db	000h	; 00000000b . 02dd2 00
d0813		db	000h	; 00000000b . 02dd3 00
d0814		db	000h	; 00000000b . 02dd4 00
d0815		db	000h	; 00000000b . 02dd5 00
d0816		db	000h	; 00000000b . 02dd6 00
d0817		db	000h	; 00000000b . 02dd7 00
d0818		db	000h	; 00000000b . 02dd8 00
d0819		db	000h	; 00000000b . 02dd9 00
d081a		db	000h	; 00000000b . 02dda 00
d081b		db	000h	; 00000000b . 02ddb 00
d081c		db	000h	; 00000000b . 02ddc 00
d081d		db	003h	; 00000011b . 02ddd 03
d081e		db	08bh	; 10001011b . 02dde 8b
d081f		db	02eh	; 00101110b . 02ddf 2e
d0820		db	01ah	; 00011010b . 02de0 1a
d0821		db	026h	; 00100110b & 02de1 26
d0822		db	000h	; 00000000b . 02de2 00
d0823		db	08bh	; 10001011b . 02de3 8b
d0824		db	02eh	; 00101110b . 02de4 2e
d0825		db	00eh	; 00001110b . 02de5 0e
d0826		db	00eh	; 00001110b . 02de6 0e
d0827		db	000h	; 00000000b . 02de7 00
d0828		db	004h	; 00000100b . 02de8 04
d0829		db	000h	; 00000000b . 02de9 00
d082a		db	000h	; 00000000b . 02dea 00
d082b		db	000h	; 00000000b . 02deb 00
d082c		db	000h	; 00000000b . 02dec 00
d082d		db	000h	; 00000000b . 02ded 00
d082e		db	000h	; 00000000b . 02dee 00
d082f		db	000h	; 00000000b . 02def 00
d0830		db	000h	; 00000000b . 02df0 00
d0831		db	000h	; 00000000b . 02df1 00
d0832		db	000h	; 00000000b . 02df2 00
d0833		db	000h	; 00000000b . 02df3 00
d0834		db	000h	; 00000000b . 02df4 00
d0835		db	000h	; 00000000b . 02df5 00
d0836		db	000h	; 00000000b . 02df6 00
d0837		db	000h	; 00000000b . 02df7 00
d0838		db	000h	; 00000000b . 02df8 00
d0839		db	000h	; 00000000b . 02df9 00
d083a		db	000h	; 00000000b . 02dfa 00
d083b		db	000h	; 00000000b . 02dfb 00
d083c		db	000h	; 00000000b . 02dfc 00
d083d		db	000h	; 00000000b . 02dfd 00
d083e		db	000h	; 00000000b . 02dfe 00
d083f		db	000h	; 00000000b . 02dff 00
d0840		db	000h	; 00000000b . 02e00 00
d0841		db	000h	; 00000000b . 02e01 00
d0842		db	000h	; 00000000b . 02e02 00
d0843		db	000h	; 00000000b . 02e03 00
d0844		db	000h	; 00000000b . 02e04 00
d0845		db	000h	; 00000000b . 02e05 00
d0846		db	000h	; 00000000b . 02e06 00
d0847		db	000h	; 00000000b . 02e07 00
d0848		db	000h	; 00000000b . 02e08 00
d0849		db	000h	; 00000000b . 02e09 00
d084a		db	000h	; 00000000b . 02e0a 00
d084b		db	000h	; 00000000b . 02e0b 00
d084c		db	000h	; 00000000b . 02e0c 00
d084d		db	000h	; 00000000b . 02e0d 00
d084e		db	000h	; 00000000b . 02e0e 00
d084f		db	000h	; 00000000b . 02e0f 00
d0850		db	000h	; 00000000b . 02e10 00
d0851		db	000h	; 00000000b . 02e11 00
d0852		db	000h	; 00000000b . 02e12 00
d0853		db	000h	; 00000000b . 02e13 00
d0854		db	000h	; 00000000b . 02e14 00
d0855		db	000h	; 00000000b . 02e15 00
d0856		db	000h	; 00000000b . 02e16 00
d0857		db	000h	; 00000000b . 02e17 00
d0858		db	000h	; 00000000b . 02e18 00
d0859		db	000h	; 00000000b . 02e19 00
d085a		db	000h	; 00000000b . 02e1a 00
d085b		db	000h	; 00000000b . 02e1b 00
d085c		db	000h	; 00000000b . 02e1c 00
d085d		db	000h	; 00000000b . 02e1d 00
d085e		db	000h	; 00000000b . 02e1e 00
d085f		db	000h	; 00000000b . 02e1f 00
d0860		db	000h	; 00000000b . 02e20 00
d0861		db	000h	; 00000000b . 02e21 00
d0862		db	000h	; 00000000b . 02e22 00
d0863		db	000h	; 00000000b . 02e23 00
d0864		db	000h	; 00000000b . 02e24 00
d0865		db	000h	; 00000000b . 02e25 00
d0866		db	000h	; 00000000b . 02e26 00
d0867		db	000h	; 00000000b . 02e27 00
d0868		db	000h	; 00000000b . 02e28 00
d0869		db	000h	; 00000000b . 02e29 00
d086a		db	000h	; 00000000b . 02e2a 00
d086b		db	000h	; 00000000b . 02e2b 00
d086c		db	000h	; 00000000b . 02e2c 00
d086d		db	000h	; 00000000b . 02e2d 00
d086e		db	000h	; 00000000b . 02e2e 00
d086f		db	000h	; 00000000b . 02e2f 00
d0870		db	000h	; 00000000b . 02e30 00
d0871		db	000h	; 00000000b . 02e31 00
d0872		db	000h	; 00000000b . 02e32 00
d0873		db	000h	; 00000000b . 02e33 00
d0874		db	000h	; 00000000b . 02e34 00
d0875		db	000h	; 00000000b . 02e35 00
d0876		db	000h	; 00000000b . 02e36 00
d0877		db	000h	; 00000000b . 02e37 00
d0878		db	000h	; 00000000b . 02e38 00
d0879		db	000h	; 00000000b . 02e39 00
d087a		db	000h	; 00000000b . 02e3a 00
d087b		db	000h	; 00000000b . 02e3b 00
d087c		db	000h	; 00000000b . 02e3c 00
d087d		db	000h	; 00000000b . 02e3d 00
d087e		db	000h	; 00000000b . 02e3e 00
d087f		db	000h	; 00000000b . 02e3f 00
d0880		db	000h	; 00000000b . 02e40 00
d0881		db	000h	; 00000000b . 02e41 00
d0882		db	000h	; 00000000b . 02e42 00
d0883		db	000h	; 00000000b . 02e43 00
d0884		db	000h	; 00000000b . 02e44 00
d0885		db	000h	; 00000000b . 02e45 00
d0886		db	000h	; 00000000b . 02e46 00
d0887		db	000h	; 00000000b . 02e47 00
d0888		db	000h	; 00000000b . 02e48 00
d0889		db	000h	; 00000000b . 02e49 00
d088a		db	000h	; 00000000b . 02e4a 00
d088b		db	000h	; 00000000b . 02e4b 00
d088c		db	000h	; 00000000b . 02e4c 00
d088d		db	000h	; 00000000b . 02e4d 00
d088e		db	000h	; 00000000b . 02e4e 00
d088f		db	000h	; 00000000b . 02e4f 00
d0890		db	000h	; 00000000b . 02e50 00
d0891		db	000h	; 00000000b . 02e51 00
d0892		db	000h	; 00000000b . 02e52 00
d0893		db	000h	; 00000000b . 02e53 00
d0894		db	000h	; 00000000b . 02e54 00
d0895		db	000h	; 00000000b . 02e55 00
d0896		db	000h	; 00000000b . 02e56 00
d0897		db	000h	; 00000000b . 02e57 00
d0898		db	000h	; 00000000b . 02e58 00
d0899		db	000h	; 00000000b . 02e59 00
d089a		db	092h	; 10010010b . 02e5a 92
d089b		db	02eh	; 00101110b . 02e5b 2e
d089c		db	019h	; 00011001b . 02e5c 19
d089d		db	026h	; 00100110b & 02e5d 26
d089e		db	000h	; 00000000b . 02e5e 00
d089f		db	092h	; 10010010b . 02e5f 92
d08a0		db	02eh	; 00101110b . 02e60 2e
d08a1		db	00eh	; 00001110b . 02e61 0e
d08a2		db	00eh	; 00001110b . 02e62 0e
d08a3		db	000h	; 00000000b . 02e63 00
d08a4		db	000h	; 00000000b . 02e64 00
d08a5		db	000h	; 00000000b . 02e65 00
d08a6		db	000h	; 00000000b . 02e66 00
d08a7		db	000h	; 00000000b . 02e67 00
d08a8		db	000h	; 00000000b . 02e68 00
d08a9		db	000h	; 00000000b . 02e69 00
d08aa		db	000h	; 00000000b . 02e6a 00
d08ab		db	000h	; 00000000b . 02e6b 00
d08ac		db	000h	; 00000000b . 02e6c 00
d08ad		db	000h	; 00000000b . 02e6d 00
d08ae		db	000h	; 00000000b . 02e6e 00
d08af		db	000h	; 00000000b . 02e6f 00
d08b0		db	000h	; 00000000b . 02e70 00
d08b1		db	000h	; 00000000b . 02e71 00
d08b2		db	000h	; 00000000b . 02e72 00
d08b3		db	000h	; 00000000b . 02e73 00
d08b4		db	000h	; 00000000b . 02e74 00
d08b5		db	000h	; 00000000b . 02e75 00
d08b6		db	000h	; 00000000b . 02e76 00
d08b7		db	000h	; 00000000b . 02e77 00
d08b8		db	000h	; 00000000b . 02e78 00
d08b9		db	000h	; 00000000b . 02e79 00
d08ba		db	000h	; 00000000b . 02e7a 00
d08bb		db	000h	; 00000000b . 02e7b 00
d08bc		db	000h	; 00000000b . 02e7c 00
d08bd		db	000h	; 00000000b . 02e7d 00
d08be		db	000h	; 00000000b . 02e7e 00
d08bf		db	000h	; 00000000b . 02e7f 00
d08c0		db	000h	; 00000000b . 02e80 00
d08c1		db	000h	; 00000000b . 02e81 00
d08c2		db	000h	; 00000000b . 02e82 00
d08c3		db	000h	; 00000000b . 02e83 00
d08c4		db	000h	; 00000000b . 02e84 00
d08c5		db	000h	; 00000000b . 02e85 00
d08c6		db	000h	; 00000000b . 02e86 00
d08c7		db	000h	; 00000000b . 02e87 00
d08c8		db	000h	; 00000000b . 02e88 00
d08c9		db	000h	; 00000000b . 02e89 00
d08ca		db	000h	; 00000000b . 02e8a 00
d08cb		db	000h	; 00000000b . 02e8b 00
d08cc		db	000h	; 00000000b . 02e8c 00
d08cd		db	000h	; 00000000b . 02e8d 00
d08ce		db	000h	; 00000000b . 02e8e 00
d08cf		db	000h	; 00000000b . 02e8f 00
d08d0		db	000h	; 00000000b . 02e90 00
d08d1		db	000h	; 00000000b . 02e91 00
d08d2		db	000h	; 00000000b . 02e92 00
d08d3		db	000h	; 00000000b . 02e93 00
d08d4		db	000h	; 00000000b . 02e94 00
d08d5		db	000h	; 00000000b . 02e95 00
d08d6		db	000h	; 00000000b . 02e96 00
d08d7		db	000h	; 00000000b . 02e97 00
d08d8		db	000h	; 00000000b . 02e98 00
d08d9		db	000h	; 00000000b . 02e99 00
d08da		db	000h	; 00000000b . 02e9a 00
d08db		db	000h	; 00000000b . 02e9b 00
d08dc		db	000h	; 00000000b . 02e9c 00
d08dd		db	000h	; 00000000b . 02e9d 00
d08de		db	000h	; 00000000b . 02e9e 00
d08df		db	000h	; 00000000b . 02e9f 00
d08e0		db	000h	; 00000000b . 02ea0 00
d08e1		db	000h	; 00000000b . 02ea1 00
d08e2		db	000h	; 00000000b . 02ea2 00
d08e3		db	000h	; 00000000b . 02ea3 00
d08e4		db	000h	; 00000000b . 02ea4 00
d08e5		db	000h	; 00000000b . 02ea5 00
d08e6		db	000h	; 00000000b . 02ea6 00
d08e7		db	000h	; 00000000b . 02ea7 00
d08e8		db	000h	; 00000000b . 02ea8 00
d08e9		db	000h	; 00000000b . 02ea9 00
d08ea		db	000h	; 00000000b . 02eaa 00
d08eb		db	000h	; 00000000b . 02eab 00
d08ec		db	000h	; 00000000b . 02eac 00
d08ed		db	000h	; 00000000b . 02ead 00
d08ee		db	000h	; 00000000b . 02eae 00
d08ef		db	000h	; 00000000b . 02eaf 00
d08f0		db	000h	; 00000000b . 02eb0 00
d08f1		db	000h	; 00000000b . 02eb1 00
d08f2		db	000h	; 00000000b . 02eb2 00
d08f3		db	000h	; 00000000b . 02eb3 00
d08f4		db	000h	; 00000000b . 02eb4 00
d08f5		db	000h	; 00000000b . 02eb5 00
d08f6		db	000h	; 00000000b . 02eb6 00
d08f7		db	000h	; 00000000b . 02eb7 00
d08f8		db	000h	; 00000000b . 02eb8 00
d08f9		db	000h	; 00000000b . 02eb9 00
d08fa		db	000h	; 00000000b . 02eba 00
d08fb		db	000h	; 00000000b . 02ebb 00
d08fc		db	000h	; 00000000b . 02ebc 00
d08fd		db	000h	; 00000000b . 02ebd 00
d08fe		db	000h	; 00000000b . 02ebe 00
d08ff		db	000h	; 00000000b . 02ebf 00
d0900		db	000h	; 00000000b . 02ec0 00
d0901		db	000h	; 00000000b . 02ec1 00
d0902		db	000h	; 00000000b . 02ec2 00
d0903		db	000h	; 00000000b . 02ec3 00
d0904		db	000h	; 00000000b . 02ec4 00
d0905		db	000h	; 00000000b . 02ec5 00
d0906		db	000h	; 00000000b . 02ec6 00
d0907		db	000h	; 00000000b . 02ec7 00
d0908		db	000h	; 00000000b . 02ec8 00
d0909		db	000h	; 00000000b . 02ec9 00
d090a		db	000h	; 00000000b . 02eca 00
d090b		db	000h	; 00000000b . 02ecb 00
d090c		db	000h	; 00000000b . 02ecc 00
d090d		db	000h	; 00000000b . 02ecd 00
d090e		db	000h	; 00000000b . 02ece 00
d090f		db	000h	; 00000000b . 02ecf 00
d0910		db	000h	; 00000000b . 02ed0 00
d0911		db	000h	; 00000000b . 02ed1 00
d0912		db	000h	; 00000000b . 02ed2 00
d0913		db	000h	; 00000000b . 02ed3 00
d0914		db	000h	; 00000000b . 02ed4 00
d0915		db	002h	; 00000010b . 02ed5 02
d0916		db	0adh	; 10101101b . 02ed6 ad
d0917		db	02ch	; 00101100b , 02ed7 2c
d0918		db	01ah	; 00011010b . 02ed8 1a
d0919		db	026h	; 00100110b & 02ed9 26
d091a		db	000h	; 00000000b . 02eda 00
d091b		db	0adh	; 10101101b . 02edb ad
d091c		db	02ch	; 00101100b , 02edc 2c
d091d		db	00eh	; 00001110b . 02edd 0e
d091e		db	00eh	; 00001110b . 02ede 0e
d091f		db	000h	; 00000000b . 02edf 00
d0920		db	004h	; 00000100b . 02ee0 04
d0921		db	000h	; 00000000b . 02ee1 00
d0922		db	000h	; 00000000b . 02ee2 00
d0923		db	000h	; 00000000b . 02ee3 00
d0924		db	000h	; 00000000b . 02ee4 00
d0925		db	000h	; 00000000b . 02ee5 00
d0926		db	000h	; 00000000b . 02ee6 00
d0927		db	000h	; 00000000b . 02ee7 00
d0928		db	000h	; 00000000b . 02ee8 00
d0929		db	000h	; 00000000b . 02ee9 00
d092a		db	000h	; 00000000b . 02eea 00
d092b		db	000h	; 00000000b . 02eeb 00
d092c		db	000h	; 00000000b . 02eec 00
d092d		db	000h	; 00000000b . 02eed 00
d092e		db	000h	; 00000000b . 02eee 00
d092f		db	000h	; 00000000b . 02eef 00
d0930		db	000h	; 00000000b . 02ef0 00
d0931		db	000h	; 00000000b . 02ef1 00
d0932		db	000h	; 00000000b . 02ef2 00
d0933		db	000h	; 00000000b . 02ef3 00
d0934		db	000h	; 00000000b . 02ef4 00
d0935		db	000h	; 00000000b . 02ef5 00
d0936		db	000h	; 00000000b . 02ef6 00
d0937		db	000h	; 00000000b . 02ef7 00
d0938		db	000h	; 00000000b . 02ef8 00
d0939		db	000h	; 00000000b . 02ef9 00
d093a		db	000h	; 00000000b . 02efa 00
d093b		db	000h	; 00000000b . 02efb 00
d093c		db	000h	; 00000000b . 02efc 00
d093d		db	000h	; 00000000b . 02efd 00
d093e		db	000h	; 00000000b . 02efe 00
d093f		db	000h	; 00000000b . 02eff 00
d0940		db	000h	; 00000000b . 02f00 00
d0941		db	000h	; 00000000b . 02f01 00
d0942		db	000h	; 00000000b . 02f02 00
d0943		db	000h	; 00000000b . 02f03 00
d0944		db	000h	; 00000000b . 02f04 00
d0945		db	000h	; 00000000b . 02f05 00
d0946		db	000h	; 00000000b . 02f06 00
d0947		db	000h	; 00000000b . 02f07 00
d0948		db	000h	; 00000000b . 02f08 00
d0949		db	000h	; 00000000b . 02f09 00
d094a		db	000h	; 00000000b . 02f0a 00
d094b		db	000h	; 00000000b . 02f0b 00
d094c		db	000h	; 00000000b . 02f0c 00
d094d		db	000h	; 00000000b . 02f0d 00
d094e		db	000h	; 00000000b . 02f0e 00
d094f		db	000h	; 00000000b . 02f0f 00
d0950		db	000h	; 00000000b . 02f10 00
d0951		db	000h	; 00000000b . 02f11 00
d0952		db	000h	; 00000000b . 02f12 00
d0953		db	000h	; 00000000b . 02f13 00
d0954		db	000h	; 00000000b . 02f14 00
d0955		db	000h	; 00000000b . 02f15 00
d0956		db	000h	; 00000000b . 02f16 00
d0957		db	000h	; 00000000b . 02f17 00
d0958		db	000h	; 00000000b . 02f18 00
d0959		db	000h	; 00000000b . 02f19 00
d095a		db	000h	; 00000000b . 02f1a 00
d095b		db	000h	; 00000000b . 02f1b 00
d095c		db	000h	; 00000000b . 02f1c 00
d095d		db	000h	; 00000000b . 02f1d 00
d095e		db	000h	; 00000000b . 02f1e 00
d095f		db	000h	; 00000000b . 02f1f 00
d0960		db	000h	; 00000000b . 02f20 00
d0961		db	000h	; 00000000b . 02f21 00
d0962		db	000h	; 00000000b . 02f22 00
d0963		db	000h	; 00000000b . 02f23 00
d0964		db	000h	; 00000000b . 02f24 00
d0965		db	000h	; 00000000b . 02f25 00
d0966		db	000h	; 00000000b . 02f26 00
d0967		db	000h	; 00000000b . 02f27 00
d0968		db	000h	; 00000000b . 02f28 00
d0969		db	000h	; 00000000b . 02f29 00
d096a		db	000h	; 00000000b . 02f2a 00
d096b		db	000h	; 00000000b . 02f2b 00
d096c		db	000h	; 00000000b . 02f2c 00
d096d		db	000h	; 00000000b . 02f2d 00
d096e		db	000h	; 00000000b . 02f2e 00
d096f		db	000h	; 00000000b . 02f2f 00
d0970		db	000h	; 00000000b . 02f30 00
d0971		db	000h	; 00000000b . 02f31 00
d0972		db	000h	; 00000000b . 02f32 00
d0973		db	000h	; 00000000b . 02f33 00
d0974		db	000h	; 00000000b . 02f34 00
d0975		db	000h	; 00000000b . 02f35 00
d0976		db	000h	; 00000000b . 02f36 00
d0977		db	000h	; 00000000b . 02f37 00
d0978		db	000h	; 00000000b . 02f38 00
d0979		db	000h	; 00000000b . 02f39 00
d097a		db	000h	; 00000000b . 02f3a 00
d097b		db	000h	; 00000000b . 02f3b 00
d097c		db	000h	; 00000000b . 02f3c 00
d097d		db	000h	; 00000000b . 02f3d 00
d097e		db	000h	; 00000000b . 02f3e 00
d097f		db	000h	; 00000000b . 02f3f 00
d0980		db	000h	; 00000000b . 02f40 00
d0981		db	000h	; 00000000b . 02f41 00
d0982		db	000h	; 00000000b . 02f42 00
d0983		db	000h	; 00000000b . 02f43 00
d0984		db	000h	; 00000000b . 02f44 00
d0985		db	000h	; 00000000b . 02f45 00
d0986		db	000h	; 00000000b . 02f46 00
d0987		db	000h	; 00000000b . 02f47 00
d0988		db	000h	; 00000000b . 02f48 00
d0989		db	000h	; 00000000b . 02f49 00
d098a		db	000h	; 00000000b . 02f4a 00
d098b		db	000h	; 00000000b . 02f4b 00
d098c		db	000h	; 00000000b . 02f4c 00
d098d		db	000h	; 00000000b . 02f4d 00
d098e		db	000h	; 00000000b . 02f4e 00
d098f		db	000h	; 00000000b . 02f4f 00
d0990		db	000h	; 00000000b . 02f50 00
d0991		db	000h	; 00000000b . 02f51 00
d0992		db	000h	; 00000000b . 02f52 00
d0993		db	000h	; 00000000b . 02f53 00
d0994		db	000h	; 00000000b . 02f54 00
d0995		db	055h	; 01010101b U 02f55 55
d0996		db	000h	; 00000000b . 02f56 00
d0997		db	000h	; 00000000b . 02f57 00
d0998		db	000h	; 00000000b . 02f58 00
d0999		db	040h	; 01000000b @ 02f59 40
d099a		db	040h	; 01000000b @ 02f5a 40
d099b		db	040h	; 01000000b @ 02f5b 40
d099c		db	040h	; 01000000b @ 02f5c 40
d099d		db	001h	; 00000001b . 02f5d 01
d099e		db	001h	; 00000001b . 02f5e 01
d099f		db	001h	; 00000001b . 02f5f 01
d09a0		db	001h	; 00000001b . 02f60 01
d09a1		db	000h	; 00000000b . 02f61 00
d09a2		db	000h	; 00000000b . 02f62 00
d09a3		db	000h	; 00000000b . 02f63 00
d09a4		db	055h	; 01010101b U 02f64 55
d09a5		db	005h	; 00000101b . 02f65 05
d09a6		db	010h	; 00010000b . 02f66 10
d09a7		db	040h	; 01000000b @ 02f67 40
d09a8		db	040h	; 01000000b @ 02f68 40
d09a9		db	050h	; 01010000b P 02f69 50
d09aa		db	004h	; 00000100b . 02f6a 04
d09ab		db	001h	; 00000001b . 02f6b 01
d09ac		db	001h	; 00000001b . 02f6c 01
d09ad		db	040h	; 01000000b @ 02f6d 40
d09ae		db	040h	; 01000000b @ 02f6e 40
d09af		db	010h	; 00010000b . 02f6f 10
d09b0		db	005h	; 00000101b . 02f70 05
d09b1		db	001h	; 00000001b . 02f71 01
d09b2		db	001h	; 00000001b . 02f72 01
d09b3		db	004h	; 00000100b . 02f73 04
d09b4		db	050h	; 01010000b P 02f74 50
d09b5		db	015h	; 00010101b . 02f75 15
d09b6		db	000h	; 00000000b . 02f76 00
d09b7		db	000h	; 00000000b . 02f77 00
d09b8		db	000h	; 00000000b . 02f78 00
d09b9		db	040h	; 01000000b @ 02f79 40
d09ba		db	040h	; 01000000b @ 02f7a 40
d09bb		db	040h	; 01000000b @ 02f7b 40
d09bc		db	000h	; 00000000b . 02f7c 00
d09bd		db	000h	; 00000000b . 02f7d 00
d09be		db	001h	; 00000001b . 02f7e 01
d09bf		db	001h	; 00000001b . 02f7f 01
d09c0		db	001h	; 00000001b . 02f80 01
d09c1		db	000h	; 00000000b . 02f81 00
d09c2		db	000h	; 00000000b . 02f82 00
d09c3		db	000h	; 00000000b . 02f83 00
d09c4		db	054h	; 01010100b T 02f84 54
d09c5		db	054h	; 01010100b T 02f85 54
d09c6		db	000h	; 00000000b . 02f86 00
d09c7		db	000h	; 00000000b . 02f87 00
d09c8		db	000h	; 00000000b . 02f88 00
d09c9		db	000h	; 00000000b . 02f89 00
d09ca		db	040h	; 01000000b @ 02f8a 40
d09cb		db	040h	; 01000000b @ 02f8b 40
d09cc		db	040h	; 01000000b @ 02f8c 40
d09cd		db	001h	; 00000001b . 02f8d 01
d09ce		db	001h	; 00000001b . 02f8e 01
d09cf		db	001h	; 00000001b . 02f8f 01
d09d0		db	000h	; 00000000b . 02f90 00
d09d1		db	000h	; 00000000b . 02f91 00
d09d2		db	000h	; 00000000b . 02f92 00
d09d3		db	000h	; 00000000b . 02f93 00
d09d4		db	015h	; 00010101b . 02f94 15
d09d5		db	040h	; 01000000b @ 02f95 40
d09d6		db	000h	; 00000000b . 02f96 00
d09d7		db	000h	; 00000000b . 02f97 00
d09d8		db	000h	; 00000000b . 02f98 00
d09d9		db	001h	; 00000001b . 02f99 01
d09da		db	000h	; 00000000b . 02f9a 00
d09db		db	000h	; 00000000b . 02f9b 00
d09dc		db	000h	; 00000000b . 02f9c 00
d09dd		db	000h	; 00000000b . 02f9d 00
d09de		db	000h	; 00000000b . 02f9e 00
d09df		db	000h	; 00000000b . 02f9f 00
d09e0		db	040h	; 01000000b @ 02fa0 40
d09e1		db	000h	; 00000000b . 02fa1 00
d09e2		db	000h	; 00000000b . 02fa2 00
d09e3		db	000h	; 00000000b . 02fa3 00
d09e4		db	001h	; 00000001b . 02fa4 01
d09e5		db	015h	; 00010101b . 02fa5 15
d09e6		db	040h	; 01000000b @ 02fa6 40
d09e7		db	000h	; 00000000b . 02fa7 00
d09e8		db	000h	; 00000000b . 02fa8 00
d09e9		db	054h	; 01010100b T 02fa9 54
d09ea		db	001h	; 00000001b . 02faa 01
d09eb		db	000h	; 00000000b . 02fab 00
d09ec		db	000h	; 00000000b . 02fac 00
d09ed		db	000h	; 00000000b . 02fad 00
d09ee		db	000h	; 00000000b . 02fae 00
d09ef		db	040h	; 01000000b @ 02faf 40
d09f0		db	015h	; 00010101b . 02fb0 15
d09f1		db	000h	; 00000000b . 02fb1 00
d09f2		db	000h	; 00000000b . 02fb2 00
d09f3		db	001h	; 00000001b . 02fb3 01
d09f4		db	054h	; 01010100b T 02fb4 54
d09f5		db	000h	; 00000000b . 02fb5 00
d09f6		db	000h	; 00000000b . 02fb6 00
d09f7		db	001h	; 00000001b . 02fb7 01
d09f8		db	001h	; 00000001b . 02fb8 01
d09f9		db	000h	; 00000000b . 02fb9 00
d09fa		db	000h	; 00000000b . 02fba 00
d09fb		db	040h	; 01000000b @ 02fbb 40
d09fc		db	040h	; 01000000b @ 02fbc 40
d09fd		db	001h	; 00000001b . 02fbd 01
d09fe		db	001h	; 00000001b . 02fbe 01
d09ff		db	000h	; 00000000b . 02fbf 00
d0a00		db	000h	; 00000000b . 02fc0 00
d0a01		db	040h	; 01000000b @ 02fc1 40
d0a02		db	040h	; 01000000b @ 02fc2 40
d0a03		db	000h	; 00000000b . 02fc3 00
d0a04		db	000h	; 00000000b . 02fc4 00
d0a05		db	002h	; 00000010b . 02fc5 02
d0a06		db	002h	; 00000010b . 02fc6 02
d0a07		db	002h	; 00000010b . 02fc7 02
d0a08		db	002h	; 00000010b . 02fc8 02
d0a09		db	019h	; 00011001b . 02fc9 19
d0a0a		db	015h	; 00010101b . 02fca 15
d0a0b		db	001h	; 00000001b . 02fcb 01
d0a0c		db	001h	; 00000001b . 02fcc 01
d0a0d		db	001h	; 00000001b . 02fcd 01
d0a0e		db	001h	; 00000001b . 02fce 01
d0a0f		db	001h	; 00000001b . 02fcf 01
d0a10		db	001h	; 00000001b . 02fd0 01
d0a11		db	001h	; 00000001b . 02fd1 01
d0a12		db	001h	; 00000001b . 02fd2 01
d0a13		db	016h	; 00010110b . 02fd3 16
d0a14		db	01ah	; 00011010b . 02fd4 1a
d0a15		db	019h	; 00011001b . 02fd5 19
d0a16		db	015h	; 00010101b . 02fd6 15
d0a17		db	001h	; 00000001b . 02fd7 01
d0a18		db	001h	; 00000001b . 02fd8 01
d0a19		db	001h	; 00000001b . 02fd9 01
d0a1a		db	001h	; 00000001b . 02fda 01
d0a1b		db	001h	; 00000001b . 02fdb 01
d0a1c		db	001h	; 00000001b . 02fdc 01
d0a1d		db	001h	; 00000001b . 02fdd 01
d0a1e		db	001h	; 00000001b . 02fde 01
d0a1f		db	016h	; 00010110b . 02fdf 16
d0a20		db	01ah	; 00011010b . 02fe0 1a
d0a21		db	000h	; 00000000b . 02fe1 00
d0a22		db	000h	; 00000000b . 02fe2 00
d0a23		db	000h	; 00000000b . 02fe3 00
d0a24		db	000h	; 00000000b . 02fe4 00
d0a25		db	000h	; 00000000b . 02fe5 00
d0a26		db	000h	; 00000000b . 02fe6 00
d0a27		db	003h	; 00000011b . 02fe7 03
d0a28		db	000h	; 00000000b . 02fe8 00
d0a29		db	000h	; 00000000b . 02fe9 00
d0a2a		db	000h	; 00000000b . 02fea 00
d0a2b		db	000h	; 00000000b . 02feb 00
d0a2c		db	002h	; 00000010b . 02fec 02
d0a2d		db	000h	; 00000000b . 02fed 00
d0a2e		db	000h	; 00000000b . 02fee 00
d0a2f		db	000h	; 00000000b . 02fef 00
d0a30		db	000h	; 00000000b . 02ff0 00
d0a31		db	000h	; 00000000b . 02ff1 00
d0a32		db	000h	; 00000000b . 02ff2 00
d0a33		db	019h	; 00011001b . 02ff3 19
d0a34		db	015h	; 00010101b . 02ff4 15
d0a35		db	001h	; 00000001b . 02ff5 01
d0a36		db	001h	; 00000001b . 02ff6 01
d0a37		db	001h	; 00000001b . 02ff7 01
d0a38		db	001h	; 00000001b . 02ff8 01
d0a39		db	001h	; 00000001b . 02ff9 01
d0a3a		db	001h	; 00000001b . 02ffa 01
d0a3b		db	001h	; 00000001b . 02ffb 01
d0a3c		db	001h	; 00000001b . 02ffc 01
d0a3d		db	001h	; 00000001b . 02ffd 01
d0a3e		db	001h	; 00000001b . 02ffe 01
d0a3f		db	001h	; 00000001b . 02fff 01
d0a40		db	001h	; 00000001b . 03000 01
d0a41		db	001h	; 00000001b . 03001 01
d0a42		db	001h	; 00000001b . 03002 01
d0a43		db	001h	; 00000001b . 03003 01
d0a44		db	001h	; 00000001b . 03004 01
d0a45		db	016h	; 00010110b . 03005 16
d0a46		db	01ah	; 00011010b . 03006 1a
d0a47		db	003h	; 00000011b . 03007 03
d0a48		db	000h	; 00000000b . 03008 00
d0a49		db	000h	; 00000000b . 03009 00
d0a4a		db	000h	; 00000000b . 0300a 00
d0a4b		db	000h	; 00000000b . 0300b 00
d0a4c		db	000h	; 00000000b . 0300c 00
d0a4d		db	000h	; 00000000b . 0300d 00
d0a4e		db	000h	; 00000000b . 0300e 00
d0a4f		db	000h	; 00000000b . 0300f 00
d0a50		db	000h	; 00000000b . 03010 00
d0a51		db	000h	; 00000000b . 03011 00
d0a52		db	002h	; 00000010b . 03012 02
d0a53		db	003h	; 00000011b . 03013 03
d0a54		db	000h	; 00000000b . 03014 00
d0a55		db	000h	; 00000000b . 03015 00
d0a56		db	000h	; 00000000b . 03016 00
d0a57		db	000h	; 00000000b . 03017 00
d0a58		db	000h	; 00000000b . 03018 00
d0a59		db	000h	; 00000000b . 03019 00
d0a5a		db	000h	; 00000000b . 0301a 00
d0a5b		db	000h	; 00000000b . 0301b 00
d0a5c		db	000h	; 00000000b . 0301c 00
d0a5d		db	000h	; 00000000b . 0301d 00
d0a5e		db	002h	; 00000010b . 0301e 02
d0a5f		db	000h	; 00000000b . 0301f 00
d0a60		db	000h	; 00000000b . 03020 00
d0a61		db	000h	; 00000000b . 03021 00
d0a62		db	000h	; 00000000b . 03022 00
d0a63		db	000h	; 00000000b . 03023 00
d0a64		db	000h	; 00000000b . 03024 00
d0a65		db	003h	; 00000011b . 03025 03
d0a66		db	000h	; 00000000b . 03026 00
d0a67		db	000h	; 00000000b . 03027 00
d0a68		db	000h	; 00000000b . 03028 00
d0a69		db	000h	; 00000000b . 03029 00
d0a6a		db	002h	; 00000010b . 0302a 02
d0a6b		db	000h	; 00000000b . 0302b 00
d0a6c		db	000h	; 00000000b . 0302c 00
d0a6d		db	000h	; 00000000b . 0302d 00
d0a6e		db	000h	; 00000000b . 0302e 00
d0a6f		db	000h	; 00000000b . 0302f 00
d0a70		db	000h	; 00000000b . 03030 00
d0a71		db	003h	; 00000011b . 03031 03
d0a72		db	000h	; 00000000b . 03032 00
d0a73		db	000h	; 00000000b . 03033 00
d0a74		db	000h	; 00000000b . 03034 00
d0a75		db	000h	; 00000000b . 03035 00
d0a76		db	000h	; 00000000b . 03036 00
d0a77		db	000h	; 00000000b . 03037 00
d0a78		db	000h	; 00000000b . 03038 00
d0a79		db	000h	; 00000000b . 03039 00
d0a7a		db	000h	; 00000000b . 0303a 00
d0a7b		db	000h	; 00000000b . 0303b 00
d0a7c		db	000h	; 00000000b . 0303c 00
d0a7d		db	000h	; 00000000b . 0303d 00
d0a7e		db	000h	; 00000000b . 0303e 00
d0a7f		db	000h	; 00000000b . 0303f 00
d0a80		db	000h	; 00000000b . 03040 00
d0a81		db	000h	; 00000000b . 03041 00
d0a82		db	000h	; 00000000b . 03042 00
d0a83		db	000h	; 00000000b . 03043 00
d0a84		db	002h	; 00000010b . 03044 02
d0a85		db	003h	; 00000011b . 03045 03
d0a86		db	000h	; 00000000b . 03046 00
d0a87		db	000h	; 00000000b . 03047 00
d0a88		db	000h	; 00000000b . 03048 00
d0a89		db	000h	; 00000000b . 03049 00
d0a8a		db	000h	; 00000000b . 0304a 00
d0a8b		db	000h	; 00000000b . 0304b 00
d0a8c		db	000h	; 00000000b . 0304c 00
d0a8d		db	000h	; 00000000b . 0304d 00
d0a8e		db	000h	; 00000000b . 0304e 00
d0a8f		db	000h	; 00000000b . 0304f 00
d0a90		db	002h	; 00000010b . 03050 02
d0a91		db	003h	; 00000011b . 03051 03
d0a92		db	000h	; 00000000b . 03052 00
d0a93		db	000h	; 00000000b . 03053 00
d0a94		db	000h	; 00000000b . 03054 00
d0a95		db	000h	; 00000000b . 03055 00
d0a96		db	000h	; 00000000b . 03056 00
d0a97		db	000h	; 00000000b . 03057 00
d0a98		db	000h	; 00000000b . 03058 00
d0a99		db	000h	; 00000000b . 03059 00
d0a9a		db	000h	; 00000000b . 0305a 00
d0a9b		db	000h	; 00000000b . 0305b 00
d0a9c		db	002h	; 00000010b . 0305c 02
d0a9d		db	000h	; 00000000b . 0305d 00
d0a9e		db	000h	; 00000000b . 0305e 00
d0a9f		db	000h	; 00000000b . 0305f 00
d0aa0		db	000h	; 00000000b . 03060 00
d0aa1		db	000h	; 00000000b . 03061 00
d0aa2		db	000h	; 00000000b . 03062 00
d0aa3		db	003h	; 00000011b . 03063 03
d0aa4		db	000h	; 00000000b . 03064 00
d0aa5		db	000h	; 00000000b . 03065 00
d0aa6		db	000h	; 00000000b . 03066 00
d0aa7		db	000h	; 00000000b . 03067 00
d0aa8		db	002h	; 00000010b . 03068 02
d0aa9		db	000h	; 00000000b . 03069 00
d0aaa		db	000h	; 00000000b . 0306a 00
d0aab		db	000h	; 00000000b . 0306b 00
d0aac		db	000h	; 00000000b . 0306c 00
d0aad		db	000h	; 00000000b . 0306d 00
d0aae		db	000h	; 00000000b . 0306e 00
d0aaf		db	003h	; 00000011b . 0306f 03
d0ab0		db	000h	; 00000000b . 03070 00
d0ab1		db	000h	; 00000000b . 03071 00
d0ab2		db	000h	; 00000000b . 03072 00
d0ab3		db	000h	; 00000000b . 03073 00
d0ab4		db	000h	; 00000000b . 03074 00
d0ab5		db	000h	; 00000000b . 03075 00
d0ab6		db	000h	; 00000000b . 03076 00
d0ab7		db	000h	; 00000000b . 03077 00
d0ab8		db	000h	; 00000000b . 03078 00
d0ab9		db	000h	; 00000000b . 03079 00
d0aba		db	000h	; 00000000b . 0307a 00
d0abb		db	000h	; 00000000b . 0307b 00
d0abc		db	000h	; 00000000b . 0307c 00
d0abd		db	000h	; 00000000b . 0307d 00
d0abe		db	000h	; 00000000b . 0307e 00
d0abf		db	000h	; 00000000b . 0307f 00
d0ac0		db	000h	; 00000000b . 03080 00
d0ac1		db	000h	; 00000000b . 03081 00
d0ac2		db	002h	; 00000010b . 03082 02
d0ac3		db	003h	; 00000011b . 03083 03
d0ac4		db	000h	; 00000000b . 03084 00
d0ac5		db	000h	; 00000000b . 03085 00
d0ac6		db	000h	; 00000000b . 03086 00
d0ac7		db	000h	; 00000000b . 03087 00
d0ac8		db	000h	; 00000000b . 03088 00
d0ac9		db	000h	; 00000000b . 03089 00
d0aca		db	000h	; 00000000b . 0308a 00
d0acb		db	000h	; 00000000b . 0308b 00
d0acc		db	000h	; 00000000b . 0308c 00
d0acd		db	000h	; 00000000b . 0308d 00
d0ace		db	007h	; 00000111b . 0308e 07
d0acf		db	008h	; 00001000b . 0308f 08
d0ad0		db	000h	; 00000000b . 03090 00
d0ad1		db	000h	; 00000000b . 03091 00
d0ad2		db	000h	; 00000000b . 03092 00
d0ad3		db	000h	; 00000000b . 03093 00
d0ad4		db	000h	; 00000000b . 03094 00
d0ad5		db	000h	; 00000000b . 03095 00
d0ad6		db	000h	; 00000000b . 03096 00
d0ad7		db	000h	; 00000000b . 03097 00
d0ad8		db	000h	; 00000000b . 03098 00
d0ad9		db	000h	; 00000000b . 03099 00
d0ada		db	002h	; 00000010b . 0309a 02
d0adb		db	000h	; 00000000b . 0309b 00
d0adc		db	000h	; 00000000b . 0309c 00
d0add		db	000h	; 00000000b . 0309d 00
d0ade		db	000h	; 00000000b . 0309e 00
d0adf		db	000h	; 00000000b . 0309f 00
d0ae0		db	000h	; 00000000b . 030a0 00
d0ae1		db	003h	; 00000011b . 030a1 03
d0ae2		db	000h	; 00000000b . 030a2 00
d0ae3		db	000h	; 00000000b . 030a3 00
d0ae4		db	000h	; 00000000b . 030a4 00
d0ae5		db	000h	; 00000000b . 030a5 00
d0ae6		db	002h	; 00000010b . 030a6 02
d0ae7		db	000h	; 00000000b . 030a7 00
d0ae8		db	000h	; 00000000b . 030a8 00
d0ae9		db	000h	; 00000000b . 030a9 00
d0aea		db	000h	; 00000000b . 030aa 00
d0aeb		db	000h	; 00000000b . 030ab 00
d0aec		db	000h	; 00000000b . 030ac 00
d0aed		db	003h	; 00000011b . 030ad 03
d0aee		db	000h	; 00000000b . 030ae 00
d0aef		db	000h	; 00000000b . 030af 00
d0af0		db	000h	; 00000000b . 030b0 00
d0af1		db	000h	; 00000000b . 030b1 00
d0af2		db	000h	; 00000000b . 030b2 00
d0af3		db	000h	; 00000000b . 030b3 00
d0af4		db	000h	; 00000000b . 030b4 00
d0af5		db	000h	; 00000000b . 030b5 00
d0af6		db	000h	; 00000000b . 030b6 00
d0af7		db	000h	; 00000000b . 030b7 00
d0af8		db	000h	; 00000000b . 030b8 00
d0af9		db	000h	; 00000000b . 030b9 00
d0afa		db	000h	; 00000000b . 030ba 00
d0afb		db	000h	; 00000000b . 030bb 00
d0afc		db	000h	; 00000000b . 030bc 00
d0afd		db	000h	; 00000000b . 030bd 00
d0afe		db	000h	; 00000000b . 030be 00
d0aff		db	000h	; 00000000b . 030bf 00
d0b00		db	002h	; 00000010b . 030c0 02
d0b01		db	003h	; 00000011b . 030c1 03
d0b02		db	000h	; 00000000b . 030c2 00
d0b03		db	000h	; 00000000b . 030c3 00
d0b04		db	000h	; 00000000b . 030c4 00
d0b05		db	000h	; 00000000b . 030c5 00
d0b06		db	005h	; 00000101b . 030c6 05
d0b07		db	006h	; 00000110b . 030c7 06
d0b08		db	000h	; 00000000b . 030c8 00
d0b09		db	000h	; 00000000b . 030c9 00
d0b0a		db	000h	; 00000000b . 030ca 00
d0b0b		db	000h	; 00000000b . 030cb 00
d0b0c		db	000h	; 00000000b . 030cc 00
d0b0d		db	000h	; 00000000b . 030cd 00
d0b0e		db	000h	; 00000000b . 030ce 00
d0b0f		db	000h	; 00000000b . 030cf 00
d0b10		db	000h	; 00000000b . 030d0 00
d0b11		db	000h	; 00000000b . 030d1 00
d0b12		db	005h	; 00000101b . 030d2 05
d0b13		db	006h	; 00000110b . 030d3 06
d0b14		db	000h	; 00000000b . 030d4 00
d0b15		db	000h	; 00000000b . 030d5 00
d0b16		db	000h	; 00000000b . 030d6 00
d0b17		db	000h	; 00000000b . 030d7 00
d0b18		db	002h	; 00000010b . 030d8 02
d0b19		db	000h	; 00000000b . 030d9 00
d0b1a		db	000h	; 00000000b . 030da 00
d0b1b		db	000h	; 00000000b . 030db 00
d0b1c		db	000h	; 00000000b . 030dc 00
d0b1d		db	000h	; 00000000b . 030dd 00
d0b1e		db	000h	; 00000000b . 030de 00
d0b1f		db	003h	; 00000011b . 030df 03
d0b20		db	000h	; 00000000b . 030e0 00
d0b21		db	000h	; 00000000b . 030e1 00
d0b22		db	000h	; 00000000b . 030e2 00
d0b23		db	000h	; 00000000b . 030e3 00
d0b24		db	002h	; 00000010b . 030e4 02
d0b25		db	000h	; 00000000b . 030e5 00
d0b26		db	000h	; 00000000b . 030e6 00
d0b27		db	000h	; 00000000b . 030e7 00
d0b28		db	000h	; 00000000b . 030e8 00
d0b29		db	000h	; 00000000b . 030e9 00
d0b2a		db	000h	; 00000000b . 030ea 00
d0b2b		db	003h	; 00000011b . 030eb 03
d0b2c		db	000h	; 00000000b . 030ec 00
d0b2d		db	000h	; 00000000b . 030ed 00
d0b2e		db	000h	; 00000000b . 030ee 00
d0b2f		db	000h	; 00000000b . 030ef 00
d0b30		db	005h	; 00000101b . 030f0 05
d0b31		db	006h	; 00000110b . 030f1 06
d0b32		db	000h	; 00000000b . 030f2 00
d0b33		db	000h	; 00000000b . 030f3 00
d0b34		db	000h	; 00000000b . 030f4 00
d0b35		db	000h	; 00000000b . 030f5 00
d0b36		db	005h	; 00000101b . 030f6 05
d0b37		db	001h	; 00000001b . 030f7 01
d0b38		db	001h	; 00000001b . 030f8 01
d0b39		db	006h	; 00000110b . 030f9 06
d0b3a		db	000h	; 00000000b . 030fa 00
d0b3b		db	000h	; 00000000b . 030fb 00
d0b3c		db	000h	; 00000000b . 030fc 00
d0b3d		db	000h	; 00000000b . 030fd 00
d0b3e		db	002h	; 00000010b . 030fe 02
d0b3f		db	003h	; 00000011b . 030ff 03
d0b40		db	000h	; 00000000b . 03100 00
d0b41		db	000h	; 00000000b . 03101 00
d0b42		db	000h	; 00000000b . 03102 00
d0b43		db	000h	; 00000000b . 03103 00
d0b44		db	002h	; 00000010b . 03104 02
d0b45		db	003h	; 00000011b . 03105 03
d0b46		db	000h	; 00000000b . 03106 00
d0b47		db	000h	; 00000000b . 03107 00
d0b48		db	000h	; 00000000b . 03108 00
d0b49		db	000h	; 00000000b . 03109 00
d0b4a		db	000h	; 00000000b . 0310a 00
d0b4b		db	000h	; 00000000b . 0310b 00
d0b4c		db	000h	; 00000000b . 0310c 00
d0b4d		db	000h	; 00000000b . 0310d 00
d0b4e		db	000h	; 00000000b . 0310e 00
d0b4f		db	000h	; 00000000b . 0310f 00
d0b50		db	002h	; 00000010b . 03110 02
d0b51		db	003h	; 00000011b . 03111 03
d0b52		db	000h	; 00000000b . 03112 00
d0b53		db	000h	; 00000000b . 03113 00
d0b54		db	000h	; 00000000b . 03114 00
d0b55		db	000h	; 00000000b . 03115 00
d0b56		db	002h	; 00000010b . 03116 02
d0b57		db	000h	; 00000000b . 03117 00
d0b58		db	000h	; 00000000b . 03118 00
d0b59		db	000h	; 00000000b . 03119 00
d0b5a		db	000h	; 00000000b . 0311a 00
d0b5b		db	000h	; 00000000b . 0311b 00
d0b5c		db	000h	; 00000000b . 0311c 00
d0b5d		db	003h	; 00000011b . 0311d 03
d0b5e		db	000h	; 00000000b . 0311e 00
d0b5f		db	000h	; 00000000b . 0311f 00
d0b60		db	000h	; 00000000b . 03120 00
d0b61		db	000h	; 00000000b . 03121 00
d0b62		db	002h	; 00000010b . 03122 02
d0b63		db	000h	; 00000000b . 03123 00
d0b64		db	000h	; 00000000b . 03124 00
d0b65		db	000h	; 00000000b . 03125 00
d0b66		db	000h	; 00000000b . 03126 00
d0b67		db	000h	; 00000000b . 03127 00
d0b68		db	000h	; 00000000b . 03128 00
d0b69		db	003h	; 00000011b . 03129 03
d0b6a		db	000h	; 00000000b . 0312a 00
d0b6b		db	000h	; 00000000b . 0312b 00
d0b6c		db	000h	; 00000000b . 0312c 00
d0b6d		db	000h	; 00000000b . 0312d 00
d0b6e		db	002h	; 00000010b . 0312e 02
d0b6f		db	003h	; 00000011b . 0312f 03
d0b70		db	000h	; 00000000b . 03130 00
d0b71		db	000h	; 00000000b . 03131 00
d0b72		db	000h	; 00000000b . 03132 00
d0b73		db	000h	; 00000000b . 03133 00
d0b74		db	002h	; 00000010b . 03134 02
d0b75		db	000h	; 00000000b . 03135 00
d0b76		db	000h	; 00000000b . 03136 00
d0b77		db	003h	; 00000011b . 03137 03
d0b78		db	000h	; 00000000b . 03138 00
d0b79		db	000h	; 00000000b . 03139 00
d0b7a		db	000h	; 00000000b . 0313a 00
d0b7b		db	000h	; 00000000b . 0313b 00
d0b7c		db	002h	; 00000010b . 0313c 02
d0b7d		db	003h	; 00000011b . 0313d 03
d0b7e		db	000h	; 00000000b . 0313e 00
d0b7f		db	000h	; 00000000b . 0313f 00
d0b80		db	000h	; 00000000b . 03140 00
d0b81		db	000h	; 00000000b . 03141 00
d0b82		db	002h	; 00000010b . 03142 02
d0b83		db	003h	; 00000011b . 03143 03
d0b84		db	000h	; 00000000b . 03144 00
d0b85		db	000h	; 00000000b . 03145 00
d0b86		db	000h	; 00000000b . 03146 00
d0b87		db	000h	; 00000000b . 03147 00
d0b88		db	000h	; 00000000b . 03148 00
d0b89		db	000h	; 00000000b . 03149 00
d0b8a		db	000h	; 00000000b . 0314a 00
d0b8b		db	000h	; 00000000b . 0314b 00
d0b8c		db	000h	; 00000000b . 0314c 00
d0b8d		db	000h	; 00000000b . 0314d 00
d0b8e		db	002h	; 00000010b . 0314e 02
d0b8f		db	003h	; 00000011b . 0314f 03
d0b90		db	000h	; 00000000b . 03150 00
d0b91		db	000h	; 00000000b . 03151 00
d0b92		db	000h	; 00000000b . 03152 00
d0b93		db	000h	; 00000000b . 03153 00
d0b94		db	002h	; 00000010b . 03154 02
d0b95		db	000h	; 00000000b . 03155 00
d0b96		db	000h	; 00000000b . 03156 00
d0b97		db	000h	; 00000000b . 03157 00
d0b98		db	000h	; 00000000b . 03158 00
d0b99		db	000h	; 00000000b . 03159 00
d0b9a		db	000h	; 00000000b . 0315a 00
d0b9b		db	003h	; 00000011b . 0315b 03
d0b9c		db	000h	; 00000000b . 0315c 00
d0b9d		db	000h	; 00000000b . 0315d 00
d0b9e		db	000h	; 00000000b . 0315e 00
d0b9f		db	000h	; 00000000b . 0315f 00
d0ba0		db	002h	; 00000010b . 03160 02
d0ba1		db	000h	; 00000000b . 03161 00
d0ba2		db	000h	; 00000000b . 03162 00
d0ba3		db	000h	; 00000000b . 03163 00
d0ba4		db	000h	; 00000000b . 03164 00
d0ba5		db	000h	; 00000000b . 03165 00
d0ba6		db	000h	; 00000000b . 03166 00
d0ba7		db	003h	; 00000011b . 03167 03
d0ba8		db	000h	; 00000000b . 03168 00
d0ba9		db	000h	; 00000000b . 03169 00
d0baa		db	000h	; 00000000b . 0316a 00
d0bab		db	000h	; 00000000b . 0316b 00
d0bac		db	002h	; 00000010b . 0316c 02
d0bad		db	003h	; 00000011b . 0316d 03
d0bae		db	000h	; 00000000b . 0316e 00
d0baf		db	000h	; 00000000b . 0316f 00
d0bb0		db	000h	; 00000000b . 03170 00
d0bb1		db	000h	; 00000000b . 03171 00
d0bb2		db	002h	; 00000010b . 03172 02
d0bb3		db	000h	; 00000000b . 03173 00
d0bb4		db	000h	; 00000000b . 03174 00
d0bb5		db	003h	; 00000011b . 03175 03
d0bb6		db	000h	; 00000000b . 03176 00
d0bb7		db	000h	; 00000000b . 03177 00
d0bb8		db	000h	; 00000000b . 03178 00
d0bb9		db	000h	; 00000000b . 03179 00
d0bba		db	002h	; 00000010b . 0317a 02
d0bbb		db	003h	; 00000011b . 0317b 03
d0bbc		db	000h	; 00000000b . 0317c 00
d0bbd		db	000h	; 00000000b . 0317d 00
d0bbe		db	000h	; 00000000b . 0317e 00
d0bbf		db	000h	; 00000000b . 0317f 00
d0bc0		db	002h	; 00000010b . 03180 02
d0bc1		db	003h	; 00000011b . 03181 03
d0bc2		db	000h	; 00000000b . 03182 00
d0bc3		db	000h	; 00000000b . 03183 00
d0bc4		db	000h	; 00000000b . 03184 00
d0bc5		db	000h	; 00000000b . 03185 00
d0bc6		db	000h	; 00000000b . 03186 00
d0bc7		db	000h	; 00000000b . 03187 00
d0bc8		db	000h	; 00000000b . 03188 00
d0bc9		db	000h	; 00000000b . 03189 00
d0bca		db	000h	; 00000000b . 0318a 00
d0bcb		db	014h	; 00010100b . 0318b 14
d0bcc		db	00ah	; 00001010b . 0318c 0a
d0bcd		db	003h	; 00000011b . 0318d 03
d0bce		db	000h	; 00000000b . 0318e 00
d0bcf		db	000h	; 00000000b . 0318f 00
d0bd0		db	000h	; 00000000b . 03190 00
d0bd1		db	000h	; 00000000b . 03191 00
d0bd2		db	002h	; 00000010b . 03192 02
d0bd3		db	000h	; 00000000b . 03193 00
d0bd4		db	000h	; 00000000b . 03194 00
d0bd5		db	000h	; 00000000b . 03195 00
d0bd6		db	000h	; 00000000b . 03196 00
d0bd7		db	000h	; 00000000b . 03197 00
d0bd8		db	000h	; 00000000b . 03198 00
d0bd9		db	003h	; 00000011b . 03199 03
d0bda		db	000h	; 00000000b . 0319a 00
d0bdb		db	000h	; 00000000b . 0319b 00
d0bdc		db	000h	; 00000000b . 0319c 00
d0bdd		db	000h	; 00000000b . 0319d 00
d0bde		db	002h	; 00000010b . 0319e 02
d0bdf		db	000h	; 00000000b . 0319f 00
d0be0		db	000h	; 00000000b . 031a0 00
d0be1		db	000h	; 00000000b . 031a1 00
d0be2		db	000h	; 00000000b . 031a2 00
d0be3		db	000h	; 00000000b . 031a3 00
d0be4		db	000h	; 00000000b . 031a4 00
d0be5		db	003h	; 00000011b . 031a5 03
d0be6		db	000h	; 00000000b . 031a6 00
d0be7		db	000h	; 00000000b . 031a7 00
d0be8		db	000h	; 00000000b . 031a8 00
d0be9		db	000h	; 00000000b . 031a9 00
d0bea		db	002h	; 00000010b . 031aa 02
d0beb		db	003h	; 00000011b . 031ab 03
d0bec		db	000h	; 00000000b . 031ac 00
d0bed		db	000h	; 00000000b . 031ad 00
d0bee		db	000h	; 00000000b . 031ae 00
d0bef		db	000h	; 00000000b . 031af 00
d0bf0		db	002h	; 00000010b . 031b0 02
d0bf1		db	000h	; 00000000b . 031b1 00
d0bf2		db	000h	; 00000000b . 031b2 00
d0bf3		db	003h	; 00000011b . 031b3 03
d0bf4		db	000h	; 00000000b . 031b4 00
d0bf5		db	000h	; 00000000b . 031b5 00
d0bf6		db	000h	; 00000000b . 031b6 00
d0bf7		db	000h	; 00000000b . 031b7 00
d0bf8		db	002h	; 00000010b . 031b8 02
d0bf9		db	003h	; 00000011b . 031b9 03
d0bfa		db	000h	; 00000000b . 031ba 00
d0bfb		db	000h	; 00000000b . 031bb 00
d0bfc		db	000h	; 00000000b . 031bc 00
d0bfd		db	000h	; 00000000b . 031bd 00
d0bfe		db	002h	; 00000010b . 031be 02
d0bff		db	003h	; 00000011b . 031bf 03
d0c00		db	000h	; 00000000b . 031c0 00
d0c01		db	000h	; 00000000b . 031c1 00
d0c02		db	000h	; 00000000b . 031c2 00
d0c03		db	000h	; 00000000b . 031c3 00
d0c04		db	005h	; 00000101b . 031c4 05
d0c05		db	001h	; 00000001b . 031c5 01
d0c06		db	001h	; 00000001b . 031c6 01
d0c07		db	001h	; 00000001b . 031c7 01
d0c08		db	001h	; 00000001b . 031c8 01
d0c09		db	00dh	; 00001101b . 031c9 0d
d0c0a		db	000h	; 00000000b . 031ca 00
d0c0b		db	003h	; 00000011b . 031cb 03
d0c0c		db	000h	; 00000000b . 031cc 00
d0c0d		db	000h	; 00000000b . 031cd 00
d0c0e		db	000h	; 00000000b . 031ce 00
d0c0f		db	000h	; 00000000b . 031cf 00
d0c10		db	002h	; 00000010b . 031d0 02
d0c11		db	000h	; 00000000b . 031d1 00
d0c12		db	000h	; 00000000b . 031d2 00
d0c13		db	000h	; 00000000b . 031d3 00
d0c14		db	000h	; 00000000b . 031d4 00
d0c15		db	000h	; 00000000b . 031d5 00
d0c16		db	000h	; 00000000b . 031d6 00
d0c17		db	003h	; 00000011b . 031d7 03
d0c18		db	000h	; 00000000b . 031d8 00
d0c19		db	000h	; 00000000b . 031d9 00
d0c1a		db	000h	; 00000000b . 031da 00
d0c1b		db	000h	; 00000000b . 031db 00
d0c1c		db	002h	; 00000010b . 031dc 02
d0c1d		db	000h	; 00000000b . 031dd 00
d0c1e		db	000h	; 00000000b . 031de 00
d0c1f		db	000h	; 00000000b . 031df 00
d0c20		db	000h	; 00000000b . 031e0 00
d0c21		db	000h	; 00000000b . 031e1 00
d0c22		db	000h	; 00000000b . 031e2 00
d0c23		db	003h	; 00000011b . 031e3 03
d0c24		db	000h	; 00000000b . 031e4 00
d0c25		db	000h	; 00000000b . 031e5 00
d0c26		db	000h	; 00000000b . 031e6 00
d0c27		db	000h	; 00000000b . 031e7 00
d0c28		db	002h	; 00000010b . 031e8 02
d0c29		db	003h	; 00000011b . 031e9 03
d0c2a		db	000h	; 00000000b . 031ea 00
d0c2b		db	000h	; 00000000b . 031eb 00
d0c2c		db	000h	; 00000000b . 031ec 00
d0c2d		db	000h	; 00000000b . 031ed 00
d0c2e		db	002h	; 00000010b . 031ee 02
d0c2f		db	000h	; 00000000b . 031ef 00
d0c30		db	000h	; 00000000b . 031f0 00
d0c31		db	003h	; 00000011b . 031f1 03
d0c32		db	000h	; 00000000b . 031f2 00
d0c33		db	000h	; 00000000b . 031f3 00
d0c34		db	000h	; 00000000b . 031f4 00
d0c35		db	000h	; 00000000b . 031f5 00
d0c36		db	002h	; 00000010b . 031f6 02
d0c37		db	003h	; 00000011b . 031f7 03
d0c38		db	000h	; 00000000b . 031f8 00
d0c39		db	000h	; 00000000b . 031f9 00
d0c3a		db	000h	; 00000000b . 031fa 00
d0c3b		db	000h	; 00000000b . 031fb 00
d0c3c		db	002h	; 00000010b . 031fc 02
d0c3d		db	003h	; 00000011b . 031fd 03
d0c3e		db	000h	; 00000000b . 031fe 00
d0c3f		db	000h	; 00000000b . 031ff 00
d0c40		db	000h	; 00000000b . 03200 00
d0c41		db	000h	; 00000000b . 03201 00
d0c42		db	007h	; 00000111b . 03202 07
d0c43		db	004h	; 00000100b . 03203 04
d0c44		db	004h	; 00000100b . 03204 04
d0c45		db	004h	; 00000100b . 03205 04
d0c46		db	004h	; 00000100b . 03206 04
d0c47		db	004h	; 00000100b . 03207 04
d0c48		db	004h	; 00000100b . 03208 04
d0c49		db	008h	; 00001000b . 03209 08
d0c4a		db	000h	; 00000000b . 0320a 00
d0c4b		db	000h	; 00000000b . 0320b 00
d0c4c		db	000h	; 00000000b . 0320c 00
d0c4d		db	000h	; 00000000b . 0320d 00
d0c4e		db	007h	; 00000111b . 0320e 07
d0c4f		db	004h	; 00000100b . 0320f 04
d0c50		db	004h	; 00000100b . 03210 04
d0c51		db	004h	; 00000100b . 03211 04
d0c52		db	004h	; 00000100b . 03212 04
d0c53		db	004h	; 00000100b . 03213 04
d0c54		db	004h	; 00000100b . 03214 04
d0c55		db	008h	; 00001000b . 03215 08
d0c56		db	000h	; 00000000b . 03216 00
d0c57		db	000h	; 00000000b . 03217 00
d0c58		db	000h	; 00000000b . 03218 00
d0c59		db	000h	; 00000000b . 03219 00
d0c5a		db	007h	; 00000111b . 0321a 07
d0c5b		db	004h	; 00000100b . 0321b 04
d0c5c		db	004h	; 00000100b . 0321c 04
d0c5d		db	004h	; 00000100b . 0321d 04
d0c5e		db	004h	; 00000100b . 0321e 04
d0c5f		db	004h	; 00000100b . 0321f 04
d0c60		db	004h	; 00000100b . 03220 04
d0c61		db	008h	; 00001000b . 03221 08
d0c62		db	000h	; 00000000b . 03222 00
d0c63		db	000h	; 00000000b . 03223 00
d0c64		db	000h	; 00000000b . 03224 00
d0c65		db	000h	; 00000000b . 03225 00
d0c66		db	007h	; 00000111b . 03226 07
d0c67		db	008h	; 00001000b . 03227 08
d0c68		db	000h	; 00000000b . 03228 00
d0c69		db	000h	; 00000000b . 03229 00
d0c6a		db	000h	; 00000000b . 0322a 00
d0c6b		db	000h	; 00000000b . 0322b 00
d0c6c		db	007h	; 00000111b . 0322c 07
d0c6d		db	004h	; 00000100b . 0322d 04
d0c6e		db	004h	; 00000100b . 0322e 04
d0c6f		db	008h	; 00001000b . 0322f 08
d0c70		db	000h	; 00000000b . 03230 00
d0c71		db	000h	; 00000000b . 03231 00
d0c72		db	000h	; 00000000b . 03232 00
d0c73		db	000h	; 00000000b . 03233 00
d0c74		db	002h	; 00000010b . 03234 02
d0c75		db	003h	; 00000011b . 03235 03
d0c76		db	000h	; 00000000b . 03236 00
d0c77		db	000h	; 00000000b . 03237 00
d0c78		db	000h	; 00000000b . 03238 00
d0c79		db	000h	; 00000000b . 03239 00
d0c7a		db	002h	; 00000010b . 0323a 02
d0c7b		db	003h	; 00000011b . 0323b 03
d0c7c		db	000h	; 00000000b . 0323c 00
d0c7d		db	000h	; 00000000b . 0323d 00
d0c7e		db	000h	; 00000000b . 0323e 00
d0c7f		db	000h	; 00000000b . 0323f 00
d0c80		db	000h	; 00000000b . 03240 00
d0c81		db	000h	; 00000000b . 03241 00
d0c82		db	000h	; 00000000b . 03242 00
d0c83		db	000h	; 00000000b . 03243 00
d0c84		db	000h	; 00000000b . 03244 00
d0c85		db	000h	; 00000000b . 03245 00
d0c86		db	000h	; 00000000b . 03246 00
d0c87		db	000h	; 00000000b . 03247 00
d0c88		db	000h	; 00000000b . 03248 00
d0c89		db	000h	; 00000000b . 03249 00
d0c8a		db	000h	; 00000000b . 0324a 00
d0c8b		db	000h	; 00000000b . 0324b 00
d0c8c		db	000h	; 00000000b . 0324c 00
d0c8d		db	000h	; 00000000b . 0324d 00
d0c8e		db	000h	; 00000000b . 0324e 00
d0c8f		db	000h	; 00000000b . 0324f 00
d0c90		db	000h	; 00000000b . 03250 00
d0c91		db	000h	; 00000000b . 03251 00
d0c92		db	000h	; 00000000b . 03252 00
d0c93		db	000h	; 00000000b . 03253 00
d0c94		db	000h	; 00000000b . 03254 00
d0c95		db	000h	; 00000000b . 03255 00
d0c96		db	000h	; 00000000b . 03256 00
d0c97		db	000h	; 00000000b . 03257 00
d0c98		db	000h	; 00000000b . 03258 00
d0c99		db	000h	; 00000000b . 03259 00
d0c9a		db	000h	; 00000000b . 0325a 00
d0c9b		db	000h	; 00000000b . 0325b 00
d0c9c		db	000h	; 00000000b . 0325c 00
d0c9d		db	000h	; 00000000b . 0325d 00
d0c9e		db	000h	; 00000000b . 0325e 00
d0c9f		db	000h	; 00000000b . 0325f 00
d0ca0		db	000h	; 00000000b . 03260 00
d0ca1		db	000h	; 00000000b . 03261 00
d0ca2		db	000h	; 00000000b . 03262 00
d0ca3		db	000h	; 00000000b . 03263 00
d0ca4		db	000h	; 00000000b . 03264 00
d0ca5		db	000h	; 00000000b . 03265 00
d0ca6		db	000h	; 00000000b . 03266 00
d0ca7		db	000h	; 00000000b . 03267 00
d0ca8		db	000h	; 00000000b . 03268 00
d0ca9		db	000h	; 00000000b . 03269 00
d0caa		db	000h	; 00000000b . 0326a 00
d0cab		db	000h	; 00000000b . 0326b 00
d0cac		db	000h	; 00000000b . 0326c 00
d0cad		db	000h	; 00000000b . 0326d 00
d0cae		db	000h	; 00000000b . 0326e 00
d0caf		db	000h	; 00000000b . 0326f 00
d0cb0		db	000h	; 00000000b . 03270 00
d0cb1		db	000h	; 00000000b . 03271 00
d0cb2		db	002h	; 00000010b . 03272 02
d0cb3		db	003h	; 00000011b . 03273 03
d0cb4		db	000h	; 00000000b . 03274 00
d0cb5		db	000h	; 00000000b . 03275 00
d0cb6		db	000h	; 00000000b . 03276 00
d0cb7		db	000h	; 00000000b . 03277 00
d0cb8		db	002h	; 00000010b . 03278 02
d0cb9		db	003h	; 00000011b . 03279 03
d0cba		db	000h	; 00000000b . 0327a 00
d0cbb		db	000h	; 00000000b . 0327b 00
d0cbc		db	000h	; 00000000b . 0327c 00
d0cbd		db	000h	; 00000000b . 0327d 00
d0cbe		db	000h	; 00000000b . 0327e 00
d0cbf		db	000h	; 00000000b . 0327f 00
d0cc0		db	000h	; 00000000b . 03280 00
d0cc1		db	000h	; 00000000b . 03281 00
d0cc2		db	000h	; 00000000b . 03282 00
d0cc3		db	000h	; 00000000b . 03283 00
d0cc4		db	000h	; 00000000b . 03284 00
d0cc5		db	000h	; 00000000b . 03285 00
d0cc6		db	000h	; 00000000b . 03286 00
d0cc7		db	000h	; 00000000b . 03287 00
d0cc8		db	000h	; 00000000b . 03288 00
d0cc9		db	000h	; 00000000b . 03289 00
d0cca		db	000h	; 00000000b . 0328a 00
d0ccb		db	000h	; 00000000b . 0328b 00
d0ccc		db	000h	; 00000000b . 0328c 00
d0ccd		db	000h	; 00000000b . 0328d 00
d0cce		db	000h	; 00000000b . 0328e 00
d0ccf		db	000h	; 00000000b . 0328f 00
d0cd0		db	000h	; 00000000b . 03290 00
d0cd1		db	000h	; 00000000b . 03291 00
d0cd2		db	000h	; 00000000b . 03292 00
d0cd3		db	000h	; 00000000b . 03293 00
d0cd4		db	000h	; 00000000b . 03294 00
d0cd5		db	000h	; 00000000b . 03295 00
d0cd6		db	000h	; 00000000b . 03296 00
d0cd7		db	000h	; 00000000b . 03297 00
d0cd8		db	000h	; 00000000b . 03298 00
d0cd9		db	000h	; 00000000b . 03299 00
d0cda		db	000h	; 00000000b . 0329a 00
d0cdb		db	000h	; 00000000b . 0329b 00
d0cdc		db	000h	; 00000000b . 0329c 00
d0cdd		db	000h	; 00000000b . 0329d 00
d0cde		db	000h	; 00000000b . 0329e 00
d0cdf		db	000h	; 00000000b . 0329f 00
d0ce0		db	000h	; 00000000b . 032a0 00
d0ce1		db	000h	; 00000000b . 032a1 00
d0ce2		db	000h	; 00000000b . 032a2 00
d0ce3		db	000h	; 00000000b . 032a3 00
d0ce4		db	000h	; 00000000b . 032a4 00
d0ce5		db	000h	; 00000000b . 032a5 00
d0ce6		db	000h	; 00000000b . 032a6 00
d0ce7		db	000h	; 00000000b . 032a7 00
d0ce8		db	000h	; 00000000b . 032a8 00
d0ce9		db	000h	; 00000000b . 032a9 00
d0cea		db	000h	; 00000000b . 032aa 00
d0ceb		db	000h	; 00000000b . 032ab 00
d0cec		db	000h	; 00000000b . 032ac 00
d0ced		db	000h	; 00000000b . 032ad 00
d0cee		db	000h	; 00000000b . 032ae 00
d0cef		db	000h	; 00000000b . 032af 00
d0cf0		db	002h	; 00000010b . 032b0 02
d0cf1		db	003h	; 00000011b . 032b1 03
d0cf2		db	000h	; 00000000b . 032b2 00
d0cf3		db	000h	; 00000000b . 032b3 00
d0cf4		db	000h	; 00000000b . 032b4 00
d0cf5		db	000h	; 00000000b . 032b5 00
d0cf6		db	002h	; 00000010b . 032b6 02
d0cf7		db	003h	; 00000011b . 032b7 03
d0cf8		db	000h	; 00000000b . 032b8 00
d0cf9		db	000h	; 00000000b . 032b9 00
d0cfa		db	000h	; 00000000b . 032ba 00
d0cfb		db	000h	; 00000000b . 032bb 00
d0cfc		db	000h	; 00000000b . 032bc 00
d0cfd		db	000h	; 00000000b . 032bd 00
d0cfe		db	000h	; 00000000b . 032be 00
d0cff		db	000h	; 00000000b . 032bf 00
d0d00		db	000h	; 00000000b . 032c0 00
d0d01		db	000h	; 00000000b . 032c1 00
d0d02		db	000h	; 00000000b . 032c2 00
d0d03		db	000h	; 00000000b . 032c3 00
d0d04		db	000h	; 00000000b . 032c4 00
d0d05		db	000h	; 00000000b . 032c5 00
d0d06		db	000h	; 00000000b . 032c6 00
d0d07		db	000h	; 00000000b . 032c7 00
d0d08		db	000h	; 00000000b . 032c8 00
d0d09		db	000h	; 00000000b . 032c9 00
d0d0a		db	000h	; 00000000b . 032ca 00
d0d0b		db	000h	; 00000000b . 032cb 00
d0d0c		db	000h	; 00000000b . 032cc 00
d0d0d		db	000h	; 00000000b . 032cd 00
d0d0e		db	000h	; 00000000b . 032ce 00
d0d0f		db	000h	; 00000000b . 032cf 00
d0d10		db	000h	; 00000000b . 032d0 00
d0d11		db	000h	; 00000000b . 032d1 00
d0d12		db	000h	; 00000000b . 032d2 00
d0d13		db	000h	; 00000000b . 032d3 00
d0d14		db	000h	; 00000000b . 032d4 00
d0d15		db	000h	; 00000000b . 032d5 00
d0d16		db	000h	; 00000000b . 032d6 00
d0d17		db	000h	; 00000000b . 032d7 00
d0d18		db	000h	; 00000000b . 032d8 00
d0d19		db	000h	; 00000000b . 032d9 00
d0d1a		db	000h	; 00000000b . 032da 00
d0d1b		db	000h	; 00000000b . 032db 00
d0d1c		db	000h	; 00000000b . 032dc 00
d0d1d		db	000h	; 00000000b . 032dd 00
d0d1e		db	000h	; 00000000b . 032de 00
d0d1f		db	000h	; 00000000b . 032df 00
d0d20		db	000h	; 00000000b . 032e0 00
d0d21		db	000h	; 00000000b . 032e1 00
d0d22		db	000h	; 00000000b . 032e2 00
d0d23		db	000h	; 00000000b . 032e3 00
d0d24		db	000h	; 00000000b . 032e4 00
d0d25		db	000h	; 00000000b . 032e5 00
d0d26		db	000h	; 00000000b . 032e6 00
d0d27		db	000h	; 00000000b . 032e7 00
d0d28		db	000h	; 00000000b . 032e8 00
d0d29		db	000h	; 00000000b . 032e9 00
d0d2a		db	000h	; 00000000b . 032ea 00
d0d2b		db	000h	; 00000000b . 032eb 00
d0d2c		db	000h	; 00000000b . 032ec 00
d0d2d		db	000h	; 00000000b . 032ed 00
d0d2e		db	002h	; 00000010b . 032ee 02
d0d2f		db	003h	; 00000011b . 032ef 03
d0d30		db	000h	; 00000000b . 032f0 00
d0d31		db	000h	; 00000000b . 032f1 00
d0d32		db	000h	; 00000000b . 032f2 00
d0d33		db	000h	; 00000000b . 032f3 00
d0d34		db	002h	; 00000010b . 032f4 02
d0d35		db	00fh	; 00001111b . 032f5 0f
d0d36		db	013h	; 00010011b . 032f6 13
d0d37		db	000h	; 00000000b . 032f7 00
d0d38		db	000h	; 00000000b . 032f8 00
d0d39		db	000h	; 00000000b . 032f9 00
d0d3a		db	000h	; 00000000b . 032fa 00
d0d3b		db	000h	; 00000000b . 032fb 00
d0d3c		db	000h	; 00000000b . 032fc 00
d0d3d		db	000h	; 00000000b . 032fd 00
d0d3e		db	000h	; 00000000b . 032fe 00
d0d3f		db	000h	; 00000000b . 032ff 00
d0d40		db	000h	; 00000000b . 03300 00
d0d41		db	000h	; 00000000b . 03301 00
d0d42		db	000h	; 00000000b . 03302 00
d0d43		db	000h	; 00000000b . 03303 00
d0d44		db	000h	; 00000000b . 03304 00
d0d45		db	000h	; 00000000b . 03305 00
d0d46		db	000h	; 00000000b . 03306 00
d0d47		db	000h	; 00000000b . 03307 00
d0d48		db	000h	; 00000000b . 03308 00
d0d49		db	000h	; 00000000b . 03309 00
d0d4a		db	000h	; 00000000b . 0330a 00
d0d4b		db	000h	; 00000000b . 0330b 00
d0d4c		db	000h	; 00000000b . 0330c 00
d0d4d		db	000h	; 00000000b . 0330d 00
d0d4e		db	000h	; 00000000b . 0330e 00
d0d4f		db	000h	; 00000000b . 0330f 00
d0d50		db	000h	; 00000000b . 03310 00
d0d51		db	000h	; 00000000b . 03311 00
d0d52		db	000h	; 00000000b . 03312 00
d0d53		db	000h	; 00000000b . 03313 00
d0d54		db	000h	; 00000000b . 03314 00
d0d55		db	000h	; 00000000b . 03315 00
d0d56		db	000h	; 00000000b . 03316 00
d0d57		db	000h	; 00000000b . 03317 00
d0d58		db	000h	; 00000000b . 03318 00
d0d59		db	000h	; 00000000b . 03319 00
d0d5a		db	000h	; 00000000b . 0331a 00
d0d5b		db	000h	; 00000000b . 0331b 00
d0d5c		db	000h	; 00000000b . 0331c 00
d0d5d		db	000h	; 00000000b . 0331d 00
d0d5e		db	000h	; 00000000b . 0331e 00
d0d5f		db	000h	; 00000000b . 0331f 00
d0d60		db	000h	; 00000000b . 03320 00
d0d61		db	000h	; 00000000b . 03321 00
d0d62		db	000h	; 00000000b . 03322 00
d0d63		db	000h	; 00000000b . 03323 00
d0d64		db	000h	; 00000000b . 03324 00
d0d65		db	000h	; 00000000b . 03325 00
d0d66		db	000h	; 00000000b . 03326 00
d0d67		db	000h	; 00000000b . 03327 00
d0d68		db	000h	; 00000000b . 03328 00
d0d69		db	000h	; 00000000b . 03329 00
d0d6a		db	000h	; 00000000b . 0332a 00
d0d6b		db	000h	; 00000000b . 0332b 00
d0d6c		db	002h	; 00000010b . 0332c 02
d0d6d		db	003h	; 00000011b . 0332d 03
d0d6e		db	000h	; 00000000b . 0332e 00
d0d6f		db	000h	; 00000000b . 0332f 00
d0d70		db	000h	; 00000000b . 03330 00
d0d71		db	000h	; 00000000b . 03331 00
d0d72		db	002h	; 00000010b . 03332 02
d0d73		db	000h	; 00000000b . 03333 00
d0d74		db	009h	; 00001001b . 03334 09
d0d75		db	001h	; 00000001b . 03335 01
d0d76		db	001h	; 00000001b . 03336 01
d0d77		db	001h	; 00000001b . 03337 01
d0d78		db	001h	; 00000001b . 03338 01
d0d79		db	006h	; 00000110b . 03339 06
d0d7a		db	000h	; 00000000b . 0333a 00
d0d7b		db	000h	; 00000000b . 0333b 00
d0d7c		db	000h	; 00000000b . 0333c 00
d0d7d		db	000h	; 00000000b . 0333d 00
d0d7e		db	005h	; 00000101b . 0333e 05
d0d7f		db	006h	; 00000110b . 0333f 06
d0d80		db	000h	; 00000000b . 03340 00
d0d81		db	000h	; 00000000b . 03341 00
d0d82		db	000h	; 00000000b . 03342 00
d0d83		db	000h	; 00000000b . 03343 00
d0d84		db	005h	; 00000101b . 03344 05
d0d85		db	001h	; 00000001b . 03345 01
d0d86		db	001h	; 00000001b . 03346 01
d0d87		db	001h	; 00000001b . 03347 01
d0d88		db	001h	; 00000001b . 03348 01
d0d89		db	001h	; 00000001b . 03349 01
d0d8a		db	001h	; 00000001b . 0334a 01
d0d8b		db	006h	; 00000110b . 0334b 06
d0d8c		db	000h	; 00000000b . 0334c 00
d0d8d		db	000h	; 00000000b . 0334d 00
d0d8e		db	000h	; 00000000b . 0334e 00
d0d8f		db	000h	; 00000000b . 0334f 00
d0d90		db	005h	; 00000101b . 03350 05
d0d91		db	001h	; 00000001b . 03351 01
d0d92		db	001h	; 00000001b . 03352 01
d0d93		db	001h	; 00000001b . 03353 01
d0d94		db	001h	; 00000001b . 03354 01
d0d95		db	001h	; 00000001b . 03355 01
d0d96		db	001h	; 00000001b . 03356 01
d0d97		db	001h	; 00000001b . 03357 01
d0d98		db	001h	; 00000001b . 03358 01
d0d99		db	001h	; 00000001b . 03359 01
d0d9a		db	001h	; 00000001b . 0335a 01
d0d9b		db	001h	; 00000001b . 0335b 01
d0d9c		db	001h	; 00000001b . 0335c 01
d0d9d		db	006h	; 00000110b . 0335d 06
d0d9e		db	000h	; 00000000b . 0335e 00
d0d9f		db	000h	; 00000000b . 0335f 00
d0da0		db	000h	; 00000000b . 03360 00
d0da1		db	000h	; 00000000b . 03361 00
d0da2		db	005h	; 00000101b . 03362 05
d0da3		db	001h	; 00000001b . 03363 01
d0da4		db	001h	; 00000001b . 03364 01
d0da5		db	006h	; 00000110b . 03365 06
d0da6		db	000h	; 00000000b . 03366 00
d0da7		db	000h	; 00000000b . 03367 00
d0da8		db	000h	; 00000000b . 03368 00
d0da9		db	000h	; 00000000b . 03369 00
d0daa		db	002h	; 00000010b . 0336a 02
d0dab		db	003h	; 00000011b . 0336b 03
d0dac		db	000h	; 00000000b . 0336c 00
d0dad		db	000h	; 00000000b . 0336d 00
d0dae		db	000h	; 00000000b . 0336e 00
d0daf		db	000h	; 00000000b . 0336f 00
d0db0		db	002h	; 00000010b . 03370 02
d0db1		db	000h	; 00000000b . 03371 00
d0db2		db	010h	; 00010000b . 03372 10
d0db3		db	004h	; 00000100b . 03373 04
d0db4		db	004h	; 00000100b . 03374 04
d0db5		db	004h	; 00000100b . 03375 04
d0db6		db	004h	; 00000100b . 03376 04
d0db7		db	008h	; 00001000b . 03377 08
d0db8		db	000h	; 00000000b . 03378 00
d0db9		db	000h	; 00000000b . 03379 00
d0dba		db	000h	; 00000000b . 0337a 00
d0dbb		db	000h	; 00000000b . 0337b 00
d0dbc		db	002h	; 00000010b . 0337c 02
d0dbd		db	003h	; 00000011b . 0337d 03
d0dbe		db	000h	; 00000000b . 0337e 00
d0dbf		db	000h	; 00000000b . 0337f 00
d0dc0		db	000h	; 00000000b . 03380 00
d0dc1		db	000h	; 00000000b . 03381 00
d0dc2		db	007h	; 00000111b . 03382 07
d0dc3		db	004h	; 00000100b . 03383 04
d0dc4		db	004h	; 00000100b . 03384 04
d0dc5		db	004h	; 00000100b . 03385 04
d0dc6		db	004h	; 00000100b . 03386 04
d0dc7		db	004h	; 00000100b . 03387 04
d0dc8		db	004h	; 00000100b . 03388 04
d0dc9		db	008h	; 00001000b . 03389 08
d0dca		db	000h	; 00000000b . 0338a 00
d0dcb		db	000h	; 00000000b . 0338b 00
d0dcc		db	000h	; 00000000b . 0338c 00
d0dcd		db	000h	; 00000000b . 0338d 00
d0dce		db	007h	; 00000111b . 0338e 07
d0dcf		db	004h	; 00000100b . 0338f 04
d0dd0		db	004h	; 00000100b . 03390 04
d0dd1		db	004h	; 00000100b . 03391 04
d0dd2		db	004h	; 00000100b . 03392 04
d0dd3		db	00ch	; 00001100b . 03393 0c
d0dd4		db	000h	; 00000000b . 03394 00
d0dd5		db	000h	; 00000000b . 03395 00
d0dd6		db	010h	; 00010000b . 03396 10
d0dd7		db	004h	; 00000100b . 03397 04
d0dd8		db	004h	; 00000100b . 03398 04
d0dd9		db	004h	; 00000100b . 03399 04
d0dda		db	004h	; 00000100b . 0339a 04
d0ddb		db	008h	; 00001000b . 0339b 08
d0ddc		db	000h	; 00000000b . 0339c 00
d0ddd		db	000h	; 00000000b . 0339d 00
d0dde		db	000h	; 00000000b . 0339e 00
d0ddf		db	000h	; 00000000b . 0339f 00
d0de0		db	002h	; 00000010b . 033a0 02
d0de1		db	000h	; 00000000b . 033a1 00
d0de2		db	000h	; 00000000b . 033a2 00
d0de3		db	003h	; 00000011b . 033a3 03
d0de4		db	000h	; 00000000b . 033a4 00
d0de5		db	000h	; 00000000b . 033a5 00
d0de6		db	000h	; 00000000b . 033a6 00
d0de7		db	000h	; 00000000b . 033a7 00
d0de8		db	002h	; 00000010b . 033a8 02
d0de9		db	003h	; 00000011b . 033a9 03
d0dea		db	000h	; 00000000b . 033aa 00
d0deb		db	000h	; 00000000b . 033ab 00
d0dec		db	000h	; 00000000b . 033ac 00
d0ded		db	000h	; 00000000b . 033ad 00
d0dee		db	002h	; 00000010b . 033ae 02
d0def		db	00bh	; 00001011b . 033af 0b
d0df0		db	011h	; 00010001b . 033b0 11
d0df1		db	000h	; 00000000b . 033b1 00
d0df2		db	000h	; 00000000b . 033b2 00
d0df3		db	000h	; 00000000b . 033b3 00
d0df4		db	000h	; 00000000b . 033b4 00
d0df5		db	000h	; 00000000b . 033b5 00
d0df6		db	000h	; 00000000b . 033b6 00
d0df7		db	000h	; 00000000b . 033b7 00
d0df8		db	000h	; 00000000b . 033b8 00
d0df9		db	000h	; 00000000b . 033b9 00
d0dfa		db	002h	; 00000010b . 033ba 02
d0dfb		db	003h	; 00000011b . 033bb 03
d0dfc		db	000h	; 00000000b . 033bc 00
d0dfd		db	000h	; 00000000b . 033bd 00
d0dfe		db	000h	; 00000000b . 033be 00
d0dff		db	000h	; 00000000b . 033bf 00
d0e00		db	000h	; 00000000b . 033c0 00
d0e01		db	000h	; 00000000b . 033c1 00
d0e02		db	000h	; 00000000b . 033c2 00
d0e03		db	000h	; 00000000b . 033c3 00
d0e04		db	000h	; 00000000b . 033c4 00
d0e05		db	000h	; 00000000b . 033c5 00
d0e06		db	000h	; 00000000b . 033c6 00
d0e07		db	000h	; 00000000b . 033c7 00
d0e08		db	000h	; 00000000b . 033c8 00
d0e09		db	000h	; 00000000b . 033c9 00
d0e0a		db	000h	; 00000000b . 033ca 00
d0e0b		db	000h	; 00000000b . 033cb 00
d0e0c		db	000h	; 00000000b . 033cc 00
d0e0d		db	000h	; 00000000b . 033cd 00
d0e0e		db	000h	; 00000000b . 033ce 00
d0e0f		db	000h	; 00000000b . 033cf 00
d0e10		db	000h	; 00000000b . 033d0 00
d0e11		db	012h	; 00010010b . 033d1 12
d0e12		db	00eh	; 00001110b . 033d2 0e
d0e13		db	00bh	; 00001011b . 033d3 0b
d0e14		db	011h	; 00010001b . 033d4 11
d0e15		db	000h	; 00000000b . 033d5 00
d0e16		db	000h	; 00000000b . 033d6 00
d0e17		db	000h	; 00000000b . 033d7 00
d0e18		db	000h	; 00000000b . 033d8 00
d0e19		db	000h	; 00000000b . 033d9 00
d0e1a		db	000h	; 00000000b . 033da 00
d0e1b		db	000h	; 00000000b . 033db 00
d0e1c		db	000h	; 00000000b . 033dc 00
d0e1d		db	000h	; 00000000b . 033dd 00
d0e1e		db	002h	; 00000010b . 033de 02
d0e1f		db	000h	; 00000000b . 033df 00
d0e20		db	000h	; 00000000b . 033e0 00
d0e21		db	003h	; 00000011b . 033e1 03
d0e22		db	000h	; 00000000b . 033e2 00
d0e23		db	000h	; 00000000b . 033e3 00
d0e24		db	000h	; 00000000b . 033e4 00
d0e25		db	000h	; 00000000b . 033e5 00
d0e26		db	002h	; 00000010b . 033e6 02
d0e27		db	003h	; 00000011b . 033e7 03
d0e28		db	000h	; 00000000b . 033e8 00
d0e29		db	000h	; 00000000b . 033e9 00
d0e2a		db	000h	; 00000000b . 033ea 00
d0e2b		db	000h	; 00000000b . 033eb 00
d0e2c		db	002h	; 00000010b . 033ec 02
d0e2d		db	003h	; 00000011b . 033ed 03
d0e2e		db	000h	; 00000000b . 033ee 00
d0e2f		db	000h	; 00000000b . 033ef 00
d0e30		db	000h	; 00000000b . 033f0 00
d0e31		db	000h	; 00000000b . 033f1 00
d0e32		db	000h	; 00000000b . 033f2 00
d0e33		db	000h	; 00000000b . 033f3 00
d0e34		db	000h	; 00000000b . 033f4 00
d0e35		db	000h	; 00000000b . 033f5 00
d0e36		db	000h	; 00000000b . 033f6 00
d0e37		db	000h	; 00000000b . 033f7 00
d0e38		db	002h	; 00000010b . 033f8 02
d0e39		db	003h	; 00000011b . 033f9 03
d0e3a		db	000h	; 00000000b . 033fa 00
d0e3b		db	000h	; 00000000b . 033fb 00
d0e3c		db	000h	; 00000000b . 033fc 00
d0e3d		db	000h	; 00000000b . 033fd 00
d0e3e		db	000h	; 00000000b . 033fe 00
d0e3f		db	000h	; 00000000b . 033ff 00
d0e40		db	000h	; 00000000b . 03400 00
d0e41		db	000h	; 00000000b . 03401 00
d0e42		db	000h	; 00000000b . 03402 00
d0e43		db	000h	; 00000000b . 03403 00
d0e44		db	000h	; 00000000b . 03404 00
d0e45		db	000h	; 00000000b . 03405 00
d0e46		db	000h	; 00000000b . 03406 00
d0e47		db	000h	; 00000000b . 03407 00
d0e48		db	000h	; 00000000b . 03408 00
d0e49		db	000h	; 00000000b . 03409 00
d0e4a		db	000h	; 00000000b . 0340a 00
d0e4b		db	000h	; 00000000b . 0340b 00
d0e4c		db	000h	; 00000000b . 0340c 00
d0e4d		db	000h	; 00000000b . 0340d 00
d0e4e		db	000h	; 00000000b . 0340e 00
d0e4f		db	000h	; 00000000b . 0340f 00
d0e50		db	002h	; 00000010b . 03410 02
d0e51		db	003h	; 00000011b . 03411 03
d0e52		db	000h	; 00000000b . 03412 00
d0e53		db	000h	; 00000000b . 03413 00
d0e54		db	000h	; 00000000b . 03414 00
d0e55		db	000h	; 00000000b . 03415 00
d0e56		db	000h	; 00000000b . 03416 00
d0e57		db	000h	; 00000000b . 03417 00
d0e58		db	000h	; 00000000b . 03418 00
d0e59		db	000h	; 00000000b . 03419 00
d0e5a		db	000h	; 00000000b . 0341a 00
d0e5b		db	000h	; 00000000b . 0341b 00
d0e5c		db	002h	; 00000010b . 0341c 02
d0e5d		db	000h	; 00000000b . 0341d 00
d0e5e		db	000h	; 00000000b . 0341e 00
d0e5f		db	003h	; 00000011b . 0341f 03
d0e60		db	000h	; 00000000b . 03420 00
d0e61		db	000h	; 00000000b . 03421 00
d0e62		db	000h	; 00000000b . 03422 00
d0e63		db	000h	; 00000000b . 03423 00
d0e64		db	002h	; 00000010b . 03424 02
d0e65		db	003h	; 00000011b . 03425 03
d0e66		db	000h	; 00000000b . 03426 00
d0e67		db	000h	; 00000000b . 03427 00
d0e68		db	000h	; 00000000b . 03428 00
d0e69		db	000h	; 00000000b . 03429 00
d0e6a		db	002h	; 00000010b . 0342a 02
d0e6b		db	003h	; 00000011b . 0342b 03
d0e6c		db	000h	; 00000000b . 0342c 00
d0e6d		db	000h	; 00000000b . 0342d 00
d0e6e		db	000h	; 00000000b . 0342e 00
d0e6f		db	000h	; 00000000b . 0342f 00
d0e70		db	000h	; 00000000b . 03430 00
d0e71		db	000h	; 00000000b . 03431 00
d0e72		db	000h	; 00000000b . 03432 00
d0e73		db	000h	; 00000000b . 03433 00
d0e74		db	000h	; 00000000b . 03434 00
d0e75		db	000h	; 00000000b . 03435 00
d0e76		db	002h	; 00000010b . 03436 02
d0e77		db	003h	; 00000011b . 03437 03
d0e78		db	000h	; 00000000b . 03438 00
d0e79		db	000h	; 00000000b . 03439 00
d0e7a		db	000h	; 00000000b . 0343a 00
d0e7b		db	000h	; 00000000b . 0343b 00
d0e7c		db	000h	; 00000000b . 0343c 00
d0e7d		db	000h	; 00000000b . 0343d 00
d0e7e		db	000h	; 00000000b . 0343e 00
d0e7f		db	000h	; 00000000b . 0343f 00
d0e80		db	000h	; 00000000b . 03440 00
d0e81		db	000h	; 00000000b . 03441 00
d0e82		db	000h	; 00000000b . 03442 00
d0e83		db	000h	; 00000000b . 03443 00
d0e84		db	000h	; 00000000b . 03444 00
d0e85		db	000h	; 00000000b . 03445 00
d0e86		db	000h	; 00000000b . 03446 00
d0e87		db	000h	; 00000000b . 03447 00
d0e88		db	000h	; 00000000b . 03448 00
d0e89		db	000h	; 00000000b . 03449 00
d0e8a		db	000h	; 00000000b . 0344a 00
d0e8b		db	000h	; 00000000b . 0344b 00
d0e8c		db	000h	; 00000000b . 0344c 00
d0e8d		db	000h	; 00000000b . 0344d 00
d0e8e		db	002h	; 00000010b . 0344e 02
d0e8f		db	003h	; 00000011b . 0344f 03
d0e90		db	000h	; 00000000b . 03450 00
d0e91		db	000h	; 00000000b . 03451 00
d0e92		db	000h	; 00000000b . 03452 00
d0e93		db	000h	; 00000000b . 03453 00
d0e94		db	000h	; 00000000b . 03454 00
d0e95		db	000h	; 00000000b . 03455 00
d0e96		db	000h	; 00000000b . 03456 00
d0e97		db	000h	; 00000000b . 03457 00
d0e98		db	000h	; 00000000b . 03458 00
d0e99		db	000h	; 00000000b . 03459 00
d0e9a		db	002h	; 00000010b . 0345a 02
d0e9b		db	000h	; 00000000b . 0345b 00
d0e9c		db	000h	; 00000000b . 0345c 00
d0e9d		db	003h	; 00000011b . 0345d 03
d0e9e		db	000h	; 00000000b . 0345e 00
d0e9f		db	000h	; 00000000b . 0345f 00
d0ea0		db	000h	; 00000000b . 03460 00
d0ea1		db	000h	; 00000000b . 03461 00
d0ea2		db	002h	; 00000010b . 03462 02
d0ea3		db	003h	; 00000011b . 03463 03
d0ea4		db	000h	; 00000000b . 03464 00
d0ea5		db	000h	; 00000000b . 03465 00
d0ea6		db	000h	; 00000000b . 03466 00
d0ea7		db	000h	; 00000000b . 03467 00
d0ea8		db	007h	; 00000111b . 03468 07
d0ea9		db	008h	; 00001000b . 03469 08
d0eaa		db	000h	; 00000000b . 0346a 00
d0eab		db	000h	; 00000000b . 0346b 00
d0eac		db	000h	; 00000000b . 0346c 00
d0ead		db	000h	; 00000000b . 0346d 00
d0eae		db	000h	; 00000000b . 0346e 00
d0eaf		db	000h	; 00000000b . 0346f 00
d0eb0		db	000h	; 00000000b . 03470 00
d0eb1		db	000h	; 00000000b . 03471 00
d0eb2		db	000h	; 00000000b . 03472 00
d0eb3		db	000h	; 00000000b . 03473 00
d0eb4		db	007h	; 00000111b . 03474 07
d0eb5		db	008h	; 00001000b . 03475 08
d0eb6		db	000h	; 00000000b . 03476 00
d0eb7		db	000h	; 00000000b . 03477 00
d0eb8		db	000h	; 00000000b . 03478 00
d0eb9		db	000h	; 00000000b . 03479 00
d0eba		db	000h	; 00000000b . 0347a 00
d0ebb		db	000h	; 00000000b . 0347b 00
d0ebc		db	000h	; 00000000b . 0347c 00
d0ebd		db	000h	; 00000000b . 0347d 00
d0ebe		db	000h	; 00000000b . 0347e 00
d0ebf		db	000h	; 00000000b . 0347f 00
d0ec0		db	000h	; 00000000b . 03480 00
d0ec1		db	000h	; 00000000b . 03481 00
d0ec2		db	000h	; 00000000b . 03482 00
d0ec3		db	000h	; 00000000b . 03483 00
d0ec4		db	000h	; 00000000b . 03484 00
d0ec5		db	000h	; 00000000b . 03485 00
d0ec6		db	000h	; 00000000b . 03486 00
d0ec7		db	000h	; 00000000b . 03487 00
d0ec8		db	000h	; 00000000b . 03488 00
d0ec9		db	000h	; 00000000b . 03489 00
d0eca		db	000h	; 00000000b . 0348a 00
d0ecb		db	000h	; 00000000b . 0348b 00
d0ecc		db	007h	; 00000111b . 0348c 07
d0ecd		db	008h	; 00001000b . 0348d 08
d0ece		db	000h	; 00000000b . 0348e 00
d0ecf		db	000h	; 00000000b . 0348f 00
d0ed0		db	000h	; 00000000b . 03490 00
d0ed1		db	000h	; 00000000b . 03491 00
d0ed2		db	000h	; 00000000b . 03492 00
d0ed3		db	000h	; 00000000b . 03493 00
d0ed4		db	000h	; 00000000b . 03494 00
d0ed5		db	000h	; 00000000b . 03495 00
d0ed6		db	000h	; 00000000b . 03496 00
d0ed7		db	000h	; 00000000b . 03497 00
d0ed8		db	007h	; 00000111b . 03498 07
d0ed9		db	004h	; 00000100b . 03499 04
d0eda		db	004h	; 00000100b . 0349a 04
d0edb		db	008h	; 00001000b . 0349b 08
d0edc		db	000h	; 00000000b . 0349c 00
d0edd		db	000h	; 00000000b . 0349d 00
d0ede		db	000h	; 00000000b . 0349e 00
d0edf		db	000h	; 00000000b . 0349f 00
d0ee0		db	002h	; 00000010b . 034a0 02
d0ee1		db	003h	; 00000011b . 034a1 03
d0ee2		db	000h	; 00000000b . 034a2 00
d0ee3		db	000h	; 00000000b . 034a3 00
d0ee4		db	000h	; 00000000b . 034a4 00
d0ee5		db	000h	; 00000000b . 034a5 00
d0ee6		db	000h	; 00000000b . 034a6 00
d0ee7		db	000h	; 00000000b . 034a7 00
d0ee8		db	000h	; 00000000b . 034a8 00
d0ee9		db	000h	; 00000000b . 034a9 00
d0eea		db	000h	; 00000000b . 034aa 00
d0eeb		db	000h	; 00000000b . 034ab 00
d0eec		db	005h	; 00000101b . 034ac 05
d0eed		db	006h	; 00000110b . 034ad 06
d0eee		db	000h	; 00000000b . 034ae 00
d0eef		db	000h	; 00000000b . 034af 00
d0ef0		db	000h	; 00000000b . 034b0 00
d0ef1		db	000h	; 00000000b . 034b1 00
d0ef2		db	000h	; 00000000b . 034b2 00
d0ef3		db	000h	; 00000000b . 034b3 00
d0ef4		db	000h	; 00000000b . 034b4 00
d0ef5		db	000h	; 00000000b . 034b5 00
d0ef6		db	000h	; 00000000b . 034b6 00
d0ef7		db	000h	; 00000000b . 034b7 00
d0ef8		db	005h	; 00000101b . 034b8 05
d0ef9		db	006h	; 00000110b . 034b9 06
d0efa		db	000h	; 00000000b . 034ba 00
d0efb		db	000h	; 00000000b . 034bb 00
d0efc		db	000h	; 00000000b . 034bc 00
d0efd		db	000h	; 00000000b . 034bd 00
d0efe		db	005h	; 00000101b . 034be 05
d0eff		db	001h	; 00000001b . 034bf 01
d0f00		db	001h	; 00000001b . 034c0 01
d0f01		db	001h	; 00000001b . 034c1 01
d0f02		db	001h	; 00000001b . 034c2 01
d0f03		db	001h	; 00000001b . 034c3 01
d0f04		db	001h	; 00000001b . 034c4 01
d0f05		db	006h	; 00000110b . 034c5 06
d0f06		db	000h	; 00000000b . 034c6 00
d0f07		db	000h	; 00000000b . 034c7 00
d0f08		db	000h	; 00000000b . 034c8 00
d0f09		db	000h	; 00000000b . 034c9 00
d0f0a		db	000h	; 00000000b . 034ca 00
d0f0b		db	000h	; 00000000b . 034cb 00
d0f0c		db	000h	; 00000000b . 034cc 00
d0f0d		db	000h	; 00000000b . 034cd 00
d0f0e		db	000h	; 00000000b . 034ce 00
d0f0f		db	000h	; 00000000b . 034cf 00
d0f10		db	005h	; 00000101b . 034d0 05
d0f11		db	006h	; 00000110b . 034d1 06
d0f12		db	000h	; 00000000b . 034d2 00
d0f13		db	000h	; 00000000b . 034d3 00
d0f14		db	000h	; 00000000b . 034d4 00
d0f15		db	000h	; 00000000b . 034d5 00
d0f16		db	000h	; 00000000b . 034d6 00
d0f17		db	000h	; 00000000b . 034d7 00
d0f18		db	000h	; 00000000b . 034d8 00
d0f19		db	000h	; 00000000b . 034d9 00
d0f1a		db	000h	; 00000000b . 034da 00
d0f1b		db	000h	; 00000000b . 034db 00
d0f1c		db	000h	; 00000000b . 034dc 00
d0f1d		db	000h	; 00000000b . 034dd 00
d0f1e		db	002h	; 00000010b . 034de 02
d0f1f		db	003h	; 00000011b . 034df 03
d0f20		db	000h	; 00000000b . 034e0 00
d0f21		db	000h	; 00000000b . 034e1 00
d0f22		db	000h	; 00000000b . 034e2 00
d0f23		db	000h	; 00000000b . 034e3 00
d0f24		db	000h	; 00000000b . 034e4 00
d0f25		db	000h	; 00000000b . 034e5 00
d0f26		db	000h	; 00000000b . 034e6 00
d0f27		db	000h	; 00000000b . 034e7 00
d0f28		db	000h	; 00000000b . 034e8 00
d0f29		db	000h	; 00000000b . 034e9 00
d0f2a		db	002h	; 00000010b . 034ea 02
d0f2b		db	003h	; 00000011b . 034eb 03
d0f2c		db	000h	; 00000000b . 034ec 00
d0f2d		db	000h	; 00000000b . 034ed 00
d0f2e		db	000h	; 00000000b . 034ee 00
d0f2f		db	000h	; 00000000b . 034ef 00
d0f30		db	000h	; 00000000b . 034f0 00
d0f31		db	000h	; 00000000b . 034f1 00
d0f32		db	000h	; 00000000b . 034f2 00
d0f33		db	000h	; 00000000b . 034f3 00
d0f34		db	000h	; 00000000b . 034f4 00
d0f35		db	000h	; 00000000b . 034f5 00
d0f36		db	002h	; 00000010b . 034f6 02
d0f37		db	003h	; 00000011b . 034f7 03
d0f38		db	000h	; 00000000b . 034f8 00
d0f39		db	000h	; 00000000b . 034f9 00
d0f3a		db	000h	; 00000000b . 034fa 00
d0f3b		db	000h	; 00000000b . 034fb 00
d0f3c		db	002h	; 00000010b . 034fc 02
d0f3d		db	000h	; 00000000b . 034fd 00
d0f3e		db	000h	; 00000000b . 034fe 00
d0f3f		db	000h	; 00000000b . 034ff 00
d0f40		db	000h	; 00000000b . 03500 00
d0f41		db	000h	; 00000000b . 03501 00
d0f42		db	000h	; 00000000b . 03502 00
d0f43		db	003h	; 00000011b . 03503 03
d0f44		db	000h	; 00000000b . 03504 00
d0f45		db	000h	; 00000000b . 03505 00
d0f46		db	000h	; 00000000b . 03506 00
d0f47		db	000h	; 00000000b . 03507 00
d0f48		db	000h	; 00000000b . 03508 00
d0f49		db	000h	; 00000000b . 03509 00
d0f4a		db	000h	; 00000000b . 0350a 00
d0f4b		db	000h	; 00000000b . 0350b 00
d0f4c		db	000h	; 00000000b . 0350c 00
d0f4d		db	000h	; 00000000b . 0350d 00
d0f4e		db	002h	; 00000010b . 0350e 02
d0f4f		db	003h	; 00000011b . 0350f 03
d0f50		db	000h	; 00000000b . 03510 00
d0f51		db	000h	; 00000000b . 03511 00
d0f52		db	000h	; 00000000b . 03512 00
d0f53		db	000h	; 00000000b . 03513 00
d0f54		db	000h	; 00000000b . 03514 00
d0f55		db	000h	; 00000000b . 03515 00
d0f56		db	000h	; 00000000b . 03516 00
d0f57		db	000h	; 00000000b . 03517 00
d0f58		db	000h	; 00000000b . 03518 00
d0f59		db	000h	; 00000000b . 03519 00
d0f5a		db	000h	; 00000000b . 0351a 00
d0f5b		db	000h	; 00000000b . 0351b 00
d0f5c		db	002h	; 00000010b . 0351c 02
d0f5d		db	003h	; 00000011b . 0351d 03
d0f5e		db	000h	; 00000000b . 0351e 00
d0f5f		db	000h	; 00000000b . 0351f 00
d0f60		db	000h	; 00000000b . 03520 00
d0f61		db	000h	; 00000000b . 03521 00
d0f62		db	000h	; 00000000b . 03522 00
d0f63		db	000h	; 00000000b . 03523 00
d0f64		db	000h	; 00000000b . 03524 00
d0f65		db	000h	; 00000000b . 03525 00
d0f66		db	000h	; 00000000b . 03526 00
d0f67		db	000h	; 00000000b . 03527 00
d0f68		db	002h	; 00000010b . 03528 02
d0f69		db	003h	; 00000011b . 03529 03
d0f6a		db	000h	; 00000000b . 0352a 00
d0f6b		db	000h	; 00000000b . 0352b 00
d0f6c		db	000h	; 00000000b . 0352c 00
d0f6d		db	000h	; 00000000b . 0352d 00
d0f6e		db	000h	; 00000000b . 0352e 00
d0f6f		db	000h	; 00000000b . 0352f 00
d0f70		db	000h	; 00000000b . 03530 00
d0f71		db	000h	; 00000000b . 03531 00
d0f72		db	000h	; 00000000b . 03532 00
d0f73		db	000h	; 00000000b . 03533 00
d0f74		db	002h	; 00000010b . 03534 02
d0f75		db	003h	; 00000011b . 03535 03
d0f76		db	000h	; 00000000b . 03536 00
d0f77		db	000h	; 00000000b . 03537 00
d0f78		db	000h	; 00000000b . 03538 00
d0f79		db	000h	; 00000000b . 03539 00
d0f7a		db	002h	; 00000010b . 0353a 02
d0f7b		db	000h	; 00000000b . 0353b 00
d0f7c		db	000h	; 00000000b . 0353c 00
d0f7d		db	000h	; 00000000b . 0353d 00
d0f7e		db	000h	; 00000000b . 0353e 00
d0f7f		db	000h	; 00000000b . 0353f 00
d0f80		db	000h	; 00000000b . 03540 00
d0f81		db	003h	; 00000011b . 03541 03
d0f82		db	000h	; 00000000b . 03542 00
d0f83		db	000h	; 00000000b . 03543 00
d0f84		db	000h	; 00000000b . 03544 00
d0f85		db	000h	; 00000000b . 03545 00
d0f86		db	000h	; 00000000b . 03546 00
d0f87		db	000h	; 00000000b . 03547 00
d0f88		db	000h	; 00000000b . 03548 00
d0f89		db	000h	; 00000000b . 03549 00
d0f8a		db	000h	; 00000000b . 0354a 00
d0f8b		db	000h	; 00000000b . 0354b 00
d0f8c		db	002h	; 00000010b . 0354c 02
d0f8d		db	003h	; 00000011b . 0354d 03
d0f8e		db	000h	; 00000000b . 0354e 00
d0f8f		db	000h	; 00000000b . 0354f 00
d0f90		db	000h	; 00000000b . 03550 00
d0f91		db	000h	; 00000000b . 03551 00
d0f92		db	000h	; 00000000b . 03552 00
d0f93		db	000h	; 00000000b . 03553 00
d0f94		db	000h	; 00000000b . 03554 00
d0f95		db	000h	; 00000000b . 03555 00
d0f96		db	000h	; 00000000b . 03556 00
d0f97		db	000h	; 00000000b . 03557 00
d0f98		db	000h	; 00000000b . 03558 00
d0f99		db	000h	; 00000000b . 03559 00
d0f9a		db	002h	; 00000010b . 0355a 02
d0f9b		db	003h	; 00000011b . 0355b 03
d0f9c		db	000h	; 00000000b . 0355c 00
d0f9d		db	000h	; 00000000b . 0355d 00
d0f9e		db	000h	; 00000000b . 0355e 00
d0f9f		db	000h	; 00000000b . 0355f 00
d0fa0		db	000h	; 00000000b . 03560 00
d0fa1		db	000h	; 00000000b . 03561 00
d0fa2		db	000h	; 00000000b . 03562 00
d0fa3		db	000h	; 00000000b . 03563 00
d0fa4		db	000h	; 00000000b . 03564 00
d0fa5		db	014h	; 00010100b . 03565 14
d0fa6		db	00ah	; 00001010b . 03566 0a
d0fa7		db	003h	; 00000011b . 03567 03
d0fa8		db	000h	; 00000000b . 03568 00
d0fa9		db	000h	; 00000000b . 03569 00
d0faa		db	000h	; 00000000b . 0356a 00
d0fab		db	000h	; 00000000b . 0356b 00
d0fac		db	000h	; 00000000b . 0356c 00
d0fad		db	000h	; 00000000b . 0356d 00
d0fae		db	000h	; 00000000b . 0356e 00
d0faf		db	000h	; 00000000b . 0356f 00
d0fb0		db	000h	; 00000000b . 03570 00
d0fb1		db	014h	; 00010100b . 03571 14
d0fb2		db	00ah	; 00001010b . 03572 0a
d0fb3		db	003h	; 00000011b . 03573 03
d0fb4		db	000h	; 00000000b . 03574 00
d0fb5		db	000h	; 00000000b . 03575 00
d0fb6		db	000h	; 00000000b . 03576 00
d0fb7		db	000h	; 00000000b . 03577 00
d0fb8		db	002h	; 00000010b . 03578 02
d0fb9		db	000h	; 00000000b . 03579 00
d0fba		db	000h	; 00000000b . 0357a 00
d0fbb		db	000h	; 00000000b . 0357b 00
d0fbc		db	000h	; 00000000b . 0357c 00
d0fbd		db	000h	; 00000000b . 0357d 00
d0fbe		db	000h	; 00000000b . 0357e 00
d0fbf		db	01dh	; 00011101b . 0357f 1d
d0fc0		db	000h	; 00000000b . 03580 00
d0fc1		db	000h	; 00000000b . 03581 00
d0fc2		db	000h	; 00000000b . 03582 00
d0fc3		db	000h	; 00000000b . 03583 00
d0fc4		db	000h	; 00000000b . 03584 00
d0fc5		db	000h	; 00000000b . 03585 00
d0fc6		db	000h	; 00000000b . 03586 00
d0fc7		db	000h	; 00000000b . 03587 00
d0fc8		db	000h	; 00000000b . 03588 00
d0fc9		db	014h	; 00010100b . 03589 14
d0fca		db	00ah	; 00001010b . 0358a 0a
d0fcb		db	003h	; 00000011b . 0358b 03
d0fcc		db	000h	; 00000000b . 0358c 00
d0fcd		db	000h	; 00000000b . 0358d 00
d0fce		db	000h	; 00000000b . 0358e 00
d0fcf		db	000h	; 00000000b . 0358f 00
d0fd0		db	000h	; 00000000b . 03590 00
d0fd1		db	000h	; 00000000b . 03591 00
d0fd2		db	000h	; 00000000b . 03592 00
d0fd3		db	000h	; 00000000b . 03593 00
d0fd4		db	000h	; 00000000b . 03594 00
d0fd5		db	000h	; 00000000b . 03595 00
d0fd6		db	000h	; 00000000b . 03596 00
d0fd7		db	014h	; 00010100b . 03597 14
d0fd8		db	00ah	; 00001010b . 03598 0a
d0fd9		db	003h	; 00000011b . 03599 03
d0fda		db	000h	; 00000000b . 0359a 00
d0fdb		db	000h	; 00000000b . 0359b 00
d0fdc		db	000h	; 00000000b . 0359c 00
d0fdd		db	000h	; 00000000b . 0359d 00
d0fde		db	005h	; 00000101b . 0359e 05
d0fdf		db	001h	; 00000001b . 0359f 01
d0fe0		db	001h	; 00000001b . 035a0 01
d0fe1		db	001h	; 00000001b . 035a1 01
d0fe2		db	001h	; 00000001b . 035a2 01
d0fe3		db	00dh	; 00001101b . 035a3 0d
d0fe4		db	000h	; 00000000b . 035a4 00
d0fe5		db	003h	; 00000011b . 035a5 03
d0fe6		db	000h	; 00000000b . 035a6 00
d0fe7		db	000h	; 00000000b . 035a7 00
d0fe8		db	000h	; 00000000b . 035a8 00
d0fe9		db	000h	; 00000000b . 035a9 00
d0fea		db	005h	; 00000101b . 035aa 05
d0feb		db	001h	; 00000001b . 035ab 01
d0fec		db	001h	; 00000001b . 035ac 01
d0fed		db	001h	; 00000001b . 035ad 01
d0fee		db	001h	; 00000001b . 035ae 01
d0fef		db	00dh	; 00001101b . 035af 0d
d0ff0		db	000h	; 00000000b . 035b0 00
d0ff1		db	003h	; 00000011b . 035b1 03
d0ff2		db	000h	; 00000000b . 035b2 00
d0ff3		db	000h	; 00000000b . 035b3 00
d0ff4		db	000h	; 00000000b . 035b4 00
d0ff5		db	000h	; 00000000b . 035b5 00
d0ff6		db	002h	; 00000010b . 035b6 02
d0ff7		db	000h	; 00000000b . 035b7 00
d0ff8		db	000h	; 00000000b . 035b8 00
d0ff9		db	000h	; 00000000b . 035b9 00
d0ffa		db	000h	; 00000000b . 035ba 00
d0ffb		db	000h	; 00000000b . 035bb 00
d0ffc		db	000h	; 00000000b . 035bc 00
d0ffd		db	01dh	; 00011101b . 035bd 1d
d0ffe		db	000h	; 00000000b . 035be 00
d0fff		db	000h	; 00000000b . 035bf 00
d1000		db	000h	; 00000000b . 035c0 00
d1001		db	000h	; 00000000b . 035c1 00
d1002		db	005h	; 00000101b . 035c2 05
d1003		db	001h	; 00000001b . 035c3 01
d1004		db	001h	; 00000001b . 035c4 01
d1005		db	001h	; 00000001b . 035c5 01
d1006		db	001h	; 00000001b . 035c6 01
d1007		db	00dh	; 00001101b . 035c7 0d
d1008		db	000h	; 00000000b . 035c8 00
d1009		db	003h	; 00000011b . 035c9 03
d100a		db	000h	; 00000000b . 035ca 00
d100b		db	000h	; 00000000b . 035cb 00
d100c		db	000h	; 00000000b . 035cc 00
d100d		db	000h	; 00000000b . 035cd 00
d100e		db	005h	; 00000101b . 035ce 05
d100f		db	001h	; 00000001b . 035cf 01
d1010		db	001h	; 00000001b . 035d0 01
d1011		db	001h	; 00000001b . 035d1 01
d1012		db	001h	; 00000001b . 035d2 01
d1013		db	001h	; 00000001b . 035d3 01
d1014		db	001h	; 00000001b . 035d4 01
d1015		db	00dh	; 00001101b . 035d5 0d
d1016		db	000h	; 00000000b . 035d6 00
d1017		db	003h	; 00000011b . 035d7 03
d1018		db	000h	; 00000000b . 035d8 00
d1019		db	000h	; 00000000b . 035d9 00
d101a		db	000h	; 00000000b . 035da 00
d101b		db	000h	; 00000000b . 035db 00
d101c		db	007h	; 00000111b . 035dc 07
d101d		db	004h	; 00000100b . 035dd 04
d101e		db	004h	; 00000100b . 035de 04
d101f		db	004h	; 00000100b . 035df 04
d1020		db	004h	; 00000100b . 035e0 04
d1021		db	00ch	; 00001100b . 035e1 0c
d1022		db	000h	; 00000000b . 035e2 00
d1023		db	003h	; 00000011b . 035e3 03
d1024		db	000h	; 00000000b . 035e4 00
d1025		db	000h	; 00000000b . 035e5 00
d1026		db	000h	; 00000000b . 035e6 00
d1027		db	000h	; 00000000b . 035e7 00
d1028		db	007h	; 00000111b . 035e8 07
d1029		db	004h	; 00000100b . 035e9 04
d102a		db	004h	; 00000100b . 035ea 04
d102b		db	004h	; 00000100b . 035eb 04
d102c		db	004h	; 00000100b . 035ec 04
d102d		db	00ch	; 00001100b . 035ed 0c
d102e		db	000h	; 00000000b . 035ee 00
d102f		db	003h	; 00000011b . 035ef 03
d1030		db	000h	; 00000000b . 035f0 00
d1031		db	000h	; 00000000b . 035f1 00
d1032		db	000h	; 00000000b . 035f2 00
d1033		db	000h	; 00000000b . 035f3 00
d1034		db	002h	; 00000010b . 035f4 02
d1035		db	000h	; 00000000b . 035f5 00
d1036		db	000h	; 00000000b . 035f6 00
d1037		db	000h	; 00000000b . 035f7 00
d1038		db	000h	; 00000000b . 035f8 00
d1039		db	000h	; 00000000b . 035f9 00
d103a		db	000h	; 00000000b . 035fa 00
d103b		db	01dh	; 00011101b . 035fb 1d
d103c		db	000h	; 00000000b . 035fc 00
d103d		db	000h	; 00000000b . 035fd 00
d103e		db	000h	; 00000000b . 035fe 00
d103f		db	000h	; 00000000b . 035ff 00

_TRK2_DATA	ends

_TRK3_SCTR1	segment	para public 'DATA'
		; Sector 1                    03600 F6 X0200
		db	512 dup (246)
_TRK3_SCTR1	ends

_TRK3_DATA	segment	para public 'DATA'
		org	1040h

d1040		db	007h	; 00000111b . 03800 07
d1041		db	004h	; 00000100b . 03801 04
d1042		db	004h	; 00000100b . 03802 04
d1043		db	004h	; 00000100b . 03803 04
d1044		db	004h	; 00000100b . 03804 04
d1045		db	00ch	; 00001100b . 03805 0c
d1046		db	000h	; 00000000b . 03806 00
d1047		db	003h	; 00000011b . 03807 03
d1048		db	000h	; 00000000b . 03808 00
d1049		db	000h	; 00000000b . 03809 00
d104a		db	000h	; 00000000b . 0380a 00
d104b		db	000h	; 00000000b . 0380b 00
d104c		db	007h	; 00000111b . 0380c 07
d104d		db	004h	; 00000100b . 0380d 04
d104e		db	004h	; 00000100b . 0380e 04
d104f		db	004h	; 00000100b . 0380f 04
d1050		db	004h	; 00000100b . 03810 04
d1051		db	004h	; 00000100b . 03811 04
d1052		db	004h	; 00000100b . 03812 04
d1053		db	00ch	; 00001100b . 03813 0c
d1054		db	000h	; 00000000b . 03814 00
d1055		db	003h	; 00000011b . 03815 03
d1056		db	000h	; 00000000b . 03816 00
d1057		db	000h	; 00000000b . 03817 00
d1058		db	000h	; 00000000b . 03818 00
d1059		db	000h	; 00000000b . 03819 00
d105a		db	000h	; 00000000b . 0381a 00
d105b		db	000h	; 00000000b . 0381b 00
d105c		db	000h	; 00000000b . 0381c 00
d105d		db	000h	; 00000000b . 0381d 00
d105e		db	000h	; 00000000b . 0381e 00
d105f		db	012h	; 00010010b . 0381f 12
d1060		db	00eh	; 00001110b . 03820 0e
d1061		db	003h	; 00000011b . 03821 03
d1062		db	000h	; 00000000b . 03822 00
d1063		db	000h	; 00000000b . 03823 00
d1064		db	000h	; 00000000b . 03824 00
d1065		db	000h	; 00000000b . 03825 00
d1066		db	000h	; 00000000b . 03826 00
d1067		db	000h	; 00000000b . 03827 00
d1068		db	000h	; 00000000b . 03828 00
d1069		db	000h	; 00000000b . 03829 00
d106a		db	000h	; 00000000b . 0382a 00
d106b		db	012h	; 00010010b . 0382b 12
d106c		db	00eh	; 00001110b . 0382c 0e
d106d		db	003h	; 00000011b . 0382d 03
d106e		db	000h	; 00000000b . 0382e 00
d106f		db	000h	; 00000000b . 0382f 00
d1070		db	000h	; 00000000b . 03830 00
d1071		db	000h	; 00000000b . 03831 00
d1072		db	002h	; 00000010b . 03832 02
d1073		db	000h	; 00000000b . 03833 00
d1074		db	000h	; 00000000b . 03834 00
d1075		db	000h	; 00000000b . 03835 00
d1076		db	000h	; 00000000b . 03836 00
d1077		db	000h	; 00000000b . 03837 00
d1078		db	000h	; 00000000b . 03838 00
d1079		db	01dh	; 00011101b . 03839 1d
d107a		db	000h	; 00000000b . 0383a 00
d107b		db	000h	; 00000000b . 0383b 00
d107c		db	000h	; 00000000b . 0383c 00
d107d		db	000h	; 00000000b . 0383d 00
d107e		db	000h	; 00000000b . 0383e 00
d107f		db	000h	; 00000000b . 0383f 00
d1080		db	000h	; 00000000b . 03840 00
d1081		db	000h	; 00000000b . 03841 00
d1082		db	000h	; 00000000b . 03842 00
d1083		db	012h	; 00010010b . 03843 12
d1084		db	00eh	; 00001110b . 03844 0e
d1085		db	003h	; 00000011b . 03845 03
d1086		db	000h	; 00000000b . 03846 00
d1087		db	000h	; 00000000b . 03847 00
d1088		db	000h	; 00000000b . 03848 00
d1089		db	000h	; 00000000b . 03849 00
d108a		db	000h	; 00000000b . 0384a 00
d108b		db	000h	; 00000000b . 0384b 00
d108c		db	000h	; 00000000b . 0384c 00
d108d		db	000h	; 00000000b . 0384d 00
d108e		db	000h	; 00000000b . 0384e 00
d108f		db	000h	; 00000000b . 0384f 00
d1090		db	000h	; 00000000b . 03850 00
d1091		db	012h	; 00010010b . 03851 12
d1092		db	00eh	; 00001110b . 03852 0e
d1093		db	003h	; 00000011b . 03853 03
d1094		db	000h	; 00000000b . 03854 00
d1095		db	000h	; 00000000b . 03855 00
d1096		db	000h	; 00000000b . 03856 00
d1097		db	000h	; 00000000b . 03857 00
d1098		db	000h	; 00000000b . 03858 00
d1099		db	000h	; 00000000b . 03859 00
d109a		db	000h	; 00000000b . 0385a 00
d109b		db	000h	; 00000000b . 0385b 00
d109c		db	000h	; 00000000b . 0385c 00
d109d		db	000h	; 00000000b . 0385d 00
d109e		db	002h	; 00000010b . 0385e 02
d109f		db	003h	; 00000011b . 0385f 03
d10a0		db	000h	; 00000000b . 03860 00
d10a1		db	000h	; 00000000b . 03861 00
d10a2		db	000h	; 00000000b . 03862 00
d10a3		db	000h	; 00000000b . 03863 00
d10a4		db	000h	; 00000000b . 03864 00
d10a5		db	000h	; 00000000b . 03865 00
d10a6		db	000h	; 00000000b . 03866 00
d10a7		db	000h	; 00000000b . 03867 00
d10a8		db	000h	; 00000000b . 03868 00
d10a9		db	000h	; 00000000b . 03869 00
d10aa		db	002h	; 00000010b . 0386a 02
d10ab		db	003h	; 00000011b . 0386b 03
d10ac		db	000h	; 00000000b . 0386c 00
d10ad		db	000h	; 00000000b . 0386d 00
d10ae		db	000h	; 00000000b . 0386e 00
d10af		db	000h	; 00000000b . 0386f 00
d10b0		db	002h	; 00000010b . 03870 02
d10b1		db	000h	; 00000000b . 03871 00
d10b2		db	000h	; 00000000b . 03872 00
d10b3		db	000h	; 00000000b . 03873 00
d10b4		db	000h	; 00000000b . 03874 00
d10b5		db	000h	; 00000000b . 03875 00
d10b6		db	000h	; 00000000b . 03876 00
d10b7		db	003h	; 00000011b . 03877 03
d10b8		db	000h	; 00000000b . 03878 00
d10b9		db	000h	; 00000000b . 03879 00
d10ba		db	000h	; 00000000b . 0387a 00
d10bb		db	000h	; 00000000b . 0387b 00
d10bc		db	000h	; 00000000b . 0387c 00
d10bd		db	000h	; 00000000b . 0387d 00
d10be		db	000h	; 00000000b . 0387e 00
d10bf		db	000h	; 00000000b . 0387f 00
d10c0		db	000h	; 00000000b . 03880 00
d10c1		db	000h	; 00000000b . 03881 00
d10c2		db	002h	; 00000010b . 03882 02
d10c3		db	003h	; 00000011b . 03883 03
d10c4		db	000h	; 00000000b . 03884 00
d10c5		db	000h	; 00000000b . 03885 00
d10c6		db	000h	; 00000000b . 03886 00
d10c7		db	000h	; 00000000b . 03887 00
d10c8		db	000h	; 00000000b . 03888 00
d10c9		db	000h	; 00000000b . 03889 00
d10ca		db	000h	; 00000000b . 0388a 00
d10cb		db	000h	; 00000000b . 0388b 00
d10cc		db	000h	; 00000000b . 0388c 00
d10cd		db	000h	; 00000000b . 0388d 00
d10ce		db	000h	; 00000000b . 0388e 00
d10cf		db	000h	; 00000000b . 0388f 00
d10d0		db	002h	; 00000010b . 03890 02
d10d1		db	003h	; 00000011b . 03891 03
d10d2		db	000h	; 00000000b . 03892 00
d10d3		db	000h	; 00000000b . 03893 00
d10d4		db	000h	; 00000000b . 03894 00
d10d5		db	000h	; 00000000b . 03895 00
d10d6		db	000h	; 00000000b . 03896 00
d10d7		db	000h	; 00000000b . 03897 00
d10d8		db	000h	; 00000000b . 03898 00
d10d9		db	000h	; 00000000b . 03899 00
d10da		db	000h	; 00000000b . 0389a 00
d10db		db	000h	; 00000000b . 0389b 00
d10dc		db	002h	; 00000010b . 0389c 02
d10dd		db	003h	; 00000011b . 0389d 03
d10de		db	000h	; 00000000b . 0389e 00
d10df		db	000h	; 00000000b . 0389f 00
d10e0		db	000h	; 00000000b . 038a0 00
d10e1		db	000h	; 00000000b . 038a1 00
d10e2		db	000h	; 00000000b . 038a2 00
d10e3		db	000h	; 00000000b . 038a3 00
d10e4		db	000h	; 00000000b . 038a4 00
d10e5		db	000h	; 00000000b . 038a5 00
d10e6		db	000h	; 00000000b . 038a6 00
d10e7		db	000h	; 00000000b . 038a7 00
d10e8		db	002h	; 00000010b . 038a8 02
d10e9		db	003h	; 00000011b . 038a9 03
d10ea		db	000h	; 00000000b . 038aa 00
d10eb		db	000h	; 00000000b . 038ab 00
d10ec		db	000h	; 00000000b . 038ac 00
d10ed		db	000h	; 00000000b . 038ad 00
d10ee		db	002h	; 00000010b . 038ae 02
d10ef		db	000h	; 00000000b . 038af 00
d10f0		db	000h	; 00000000b . 038b0 00
d10f1		db	000h	; 00000000b . 038b1 00
d10f2		db	000h	; 00000000b . 038b2 00
d10f3		db	000h	; 00000000b . 038b3 00
d10f4		db	000h	; 00000000b . 038b4 00
d10f5		db	003h	; 00000011b . 038b5 03
d10f6		db	000h	; 00000000b . 038b6 00
d10f7		db	000h	; 00000000b . 038b7 00
d10f8		db	000h	; 00000000b . 038b8 00
d10f9		db	000h	; 00000000b . 038b9 00
d10fa		db	000h	; 00000000b . 038ba 00
d10fb		db	000h	; 00000000b . 038bb 00
d10fc		db	000h	; 00000000b . 038bc 00
d10fd		db	000h	; 00000000b . 038bd 00
d10fe		db	000h	; 00000000b . 038be 00
d10ff		db	000h	; 00000000b . 038bf 00
d1100		db	002h	; 00000010b . 038c0 02
d1101		db	003h	; 00000011b . 038c1 03
d1102		db	000h	; 00000000b . 038c2 00
d1103		db	000h	; 00000000b . 038c3 00
d1104		db	000h	; 00000000b . 038c4 00
d1105		db	000h	; 00000000b . 038c5 00
d1106		db	000h	; 00000000b . 038c6 00
d1107		db	000h	; 00000000b . 038c7 00
d1108		db	000h	; 00000000b . 038c8 00
d1109		db	000h	; 00000000b . 038c9 00
d110a		db	000h	; 00000000b . 038ca 00
d110b		db	000h	; 00000000b . 038cb 00
d110c		db	000h	; 00000000b . 038cc 00
d110d		db	000h	; 00000000b . 038cd 00
d110e		db	002h	; 00000010b . 038ce 02
d110f		db	003h	; 00000011b . 038cf 03
d1110		db	000h	; 00000000b . 038d0 00
d1111		db	000h	; 00000000b . 038d1 00
d1112		db	000h	; 00000000b . 038d2 00
d1113		db	000h	; 00000000b . 038d3 00
d1114		db	000h	; 00000000b . 038d4 00
d1115		db	000h	; 00000000b . 038d5 00
d1116		db	000h	; 00000000b . 038d6 00
d1117		db	000h	; 00000000b . 038d7 00
d1118		db	000h	; 00000000b . 038d8 00
d1119		db	000h	; 00000000b . 038d9 00
d111a		db	007h	; 00000111b . 038da 07
d111b		db	008h	; 00001000b . 038db 08
d111c		db	000h	; 00000000b . 038dc 00
d111d		db	000h	; 00000000b . 038dd 00
d111e		db	000h	; 00000000b . 038de 00
d111f		db	000h	; 00000000b . 038df 00
d1120		db	000h	; 00000000b . 038e0 00
d1121		db	000h	; 00000000b . 038e1 00
d1122		db	000h	; 00000000b . 038e2 00
d1123		db	000h	; 00000000b . 038e3 00
d1124		db	000h	; 00000000b . 038e4 00
d1125		db	000h	; 00000000b . 038e5 00
d1126		db	007h	; 00000111b . 038e6 07
d1127		db	008h	; 00001000b . 038e7 08
d1128		db	000h	; 00000000b . 038e8 00
d1129		db	000h	; 00000000b . 038e9 00
d112a		db	000h	; 00000000b . 038ea 00
d112b		db	000h	; 00000000b . 038eb 00
d112c		db	007h	; 00000111b . 038ec 07
d112d		db	004h	; 00000100b . 038ed 04
d112e		db	004h	; 00000100b . 038ee 04
d112f		db	004h	; 00000100b . 038ef 04
d1130		db	004h	; 00000100b . 038f0 04
d1131		db	004h	; 00000100b . 038f1 04
d1132		db	004h	; 00000100b . 038f2 04
d1133		db	008h	; 00001000b . 038f3 08
d1134		db	000h	; 00000000b . 038f4 00
d1135		db	000h	; 00000000b . 038f5 00
d1136		db	000h	; 00000000b . 038f6 00
d1137		db	000h	; 00000000b . 038f7 00
d1138		db	000h	; 00000000b . 038f8 00
d1139		db	000h	; 00000000b . 038f9 00
d113a		db	000h	; 00000000b . 038fa 00
d113b		db	000h	; 00000000b . 038fb 00
d113c		db	000h	; 00000000b . 038fc 00
d113d		db	000h	; 00000000b . 038fd 00
d113e		db	007h	; 00000111b . 038fe 07
d113f		db	008h	; 00001000b . 038ff 08
d1140		db	000h	; 00000000b . 03900 00
d1141		db	000h	; 00000000b . 03901 00
d1142		db	000h	; 00000000b . 03902 00
d1143		db	000h	; 00000000b . 03903 00
d1144		db	000h	; 00000000b . 03904 00
d1145		db	000h	; 00000000b . 03905 00
d1146		db	000h	; 00000000b . 03906 00
d1147		db	000h	; 00000000b . 03907 00
d1148		db	000h	; 00000000b . 03908 00
d1149		db	000h	; 00000000b . 03909 00
d114a		db	000h	; 00000000b . 0390a 00
d114b		db	000h	; 00000000b . 0390b 00
d114c		db	002h	; 00000010b . 0390c 02
d114d		db	003h	; 00000011b . 0390d 03
d114e		db	000h	; 00000000b . 0390e 00
d114f		db	000h	; 00000000b . 0390f 00
d1150		db	000h	; 00000000b . 03910 00
d1151		db	000h	; 00000000b . 03911 00
d1152		db	005h	; 00000101b . 03912 05
d1153		db	006h	; 00000110b . 03913 06
d1154		db	000h	; 00000000b . 03914 00
d1155		db	000h	; 00000000b . 03915 00
d1156		db	000h	; 00000000b . 03916 00
d1157		db	000h	; 00000000b . 03917 00
d1158		db	000h	; 00000000b . 03918 00
d1159		db	000h	; 00000000b . 03919 00
d115a		db	000h	; 00000000b . 0391a 00
d115b		db	000h	; 00000000b . 0391b 00
d115c		db	000h	; 00000000b . 0391c 00
d115d		db	000h	; 00000000b . 0391d 00
d115e		db	005h	; 00000101b . 0391e 05
d115f		db	006h	; 00000110b . 0391f 06
d1160		db	000h	; 00000000b . 03920 00
d1161		db	000h	; 00000000b . 03921 00
d1162		db	000h	; 00000000b . 03922 00
d1163		db	000h	; 00000000b . 03923 00
d1164		db	000h	; 00000000b . 03924 00
d1165		db	000h	; 00000000b . 03925 00
d1166		db	000h	; 00000000b . 03926 00
d1167		db	000h	; 00000000b . 03927 00
d1168		db	000h	; 00000000b . 03928 00
d1169		db	000h	; 00000000b . 03929 00
d116a		db	000h	; 00000000b . 0392a 00
d116b		db	000h	; 00000000b . 0392b 00
d116c		db	000h	; 00000000b . 0392c 00
d116d		db	000h	; 00000000b . 0392d 00
d116e		db	000h	; 00000000b . 0392e 00
d116f		db	000h	; 00000000b . 0392f 00
d1170		db	000h	; 00000000b . 03930 00
d1171		db	000h	; 00000000b . 03931 00
d1172		db	000h	; 00000000b . 03932 00
d1173		db	000h	; 00000000b . 03933 00
d1174		db	000h	; 00000000b . 03934 00
d1175		db	000h	; 00000000b . 03935 00
d1176		db	005h	; 00000101b . 03936 05
d1177		db	006h	; 00000110b . 03937 06
d1178		db	000h	; 00000000b . 03938 00
d1179		db	000h	; 00000000b . 03939 00
d117a		db	000h	; 00000000b . 0393a 00
d117b		db	000h	; 00000000b . 0393b 00
d117c		db	000h	; 00000000b . 0393c 00
d117d		db	000h	; 00000000b . 0393d 00
d117e		db	000h	; 00000000b . 0393e 00
d117f		db	000h	; 00000000b . 0393f 00
d1180		db	000h	; 00000000b . 03940 00
d1181		db	000h	; 00000000b . 03941 00
d1182		db	005h	; 00000101b . 03942 05
d1183		db	001h	; 00000001b . 03943 01
d1184		db	001h	; 00000001b . 03944 01
d1185		db	006h	; 00000110b . 03945 06
d1186		db	000h	; 00000000b . 03946 00
d1187		db	000h	; 00000000b . 03947 00
d1188		db	000h	; 00000000b . 03948 00
d1189		db	000h	; 00000000b . 03949 00
d118a		db	002h	; 00000010b . 0394a 02
d118b		db	003h	; 00000011b . 0394b 03
d118c		db	000h	; 00000000b . 0394c 00
d118d		db	000h	; 00000000b . 0394d 00
d118e		db	000h	; 00000000b . 0394e 00
d118f		db	000h	; 00000000b . 0394f 00
d1190		db	002h	; 00000010b . 03950 02
d1191		db	003h	; 00000011b . 03951 03
d1192		db	000h	; 00000000b . 03952 00
d1193		db	000h	; 00000000b . 03953 00
d1194		db	000h	; 00000000b . 03954 00
d1195		db	000h	; 00000000b . 03955 00
d1196		db	000h	; 00000000b . 03956 00
d1197		db	000h	; 00000000b . 03957 00
d1198		db	000h	; 00000000b . 03958 00
d1199		db	000h	; 00000000b . 03959 00
d119a		db	000h	; 00000000b . 0395a 00
d119b		db	000h	; 00000000b . 0395b 00
d119c		db	002h	; 00000010b . 0395c 02
d119d		db	003h	; 00000011b . 0395d 03
d119e		db	000h	; 00000000b . 0395e 00
d119f		db	000h	; 00000000b . 0395f 00
d11a0		db	000h	; 00000000b . 03960 00
d11a1		db	000h	; 00000000b . 03961 00
d11a2		db	000h	; 00000000b . 03962 00
d11a3		db	000h	; 00000000b . 03963 00
d11a4		db	000h	; 00000000b . 03964 00
d11a5		db	000h	; 00000000b . 03965 00
d11a6		db	000h	; 00000000b . 03966 00
d11a7		db	000h	; 00000000b . 03967 00
d11a8		db	000h	; 00000000b . 03968 00
d11a9		db	000h	; 00000000b . 03969 00
d11aa		db	000h	; 00000000b . 0396a 00
d11ab		db	000h	; 00000000b . 0396b 00
d11ac		db	000h	; 00000000b . 0396c 00
d11ad		db	000h	; 00000000b . 0396d 00
d11ae		db	000h	; 00000000b . 0396e 00
d11af		db	000h	; 00000000b . 0396f 00
d11b0		db	000h	; 00000000b . 03970 00
d11b1		db	000h	; 00000000b . 03971 00
d11b2		db	000h	; 00000000b . 03972 00
d11b3		db	000h	; 00000000b . 03973 00
d11b4		db	002h	; 00000010b . 03974 02
d11b5		db	003h	; 00000011b . 03975 03
d11b6		db	000h	; 00000000b . 03976 00
d11b7		db	000h	; 00000000b . 03977 00
d11b8		db	000h	; 00000000b . 03978 00
d11b9		db	000h	; 00000000b . 03979 00
d11ba		db	000h	; 00000000b . 0397a 00
d11bb		db	000h	; 00000000b . 0397b 00
d11bc		db	000h	; 00000000b . 0397c 00
d11bd		db	000h	; 00000000b . 0397d 00
d11be		db	000h	; 00000000b . 0397e 00
d11bf		db	000h	; 00000000b . 0397f 00
d11c0		db	002h	; 00000010b . 03980 02
d11c1		db	000h	; 00000000b . 03981 00
d11c2		db	000h	; 00000000b . 03982 00
d11c3		db	003h	; 00000011b . 03983 03
d11c4		db	000h	; 00000000b . 03984 00
d11c5		db	000h	; 00000000b . 03985 00
d11c6		db	000h	; 00000000b . 03986 00
d11c7		db	000h	; 00000000b . 03987 00
d11c8		db	002h	; 00000010b . 03988 02
d11c9		db	003h	; 00000011b . 03989 03
d11ca		db	000h	; 00000000b . 0398a 00
d11cb		db	000h	; 00000000b . 0398b 00
d11cc		db	000h	; 00000000b . 0398c 00
d11cd		db	000h	; 00000000b . 0398d 00
d11ce		db	002h	; 00000010b . 0398e 02
d11cf		db	003h	; 00000011b . 0398f 03
d11d0		db	000h	; 00000000b . 03990 00
d11d1		db	000h	; 00000000b . 03991 00
d11d2		db	000h	; 00000000b . 03992 00
d11d3		db	000h	; 00000000b . 03993 00
d11d4		db	000h	; 00000000b . 03994 00
d11d5		db	000h	; 00000000b . 03995 00
d11d6		db	000h	; 00000000b . 03996 00
d11d7		db	000h	; 00000000b . 03997 00
d11d8		db	000h	; 00000000b . 03998 00
d11d9		db	000h	; 00000000b . 03999 00
d11da		db	002h	; 00000010b . 0399a 02
d11db		db	003h	; 00000011b . 0399b 03
d11dc		db	000h	; 00000000b . 0399c 00
d11dd		db	000h	; 00000000b . 0399d 00
d11de		db	000h	; 00000000b . 0399e 00
d11df		db	000h	; 00000000b . 0399f 00
d11e0		db	000h	; 00000000b . 039a0 00
d11e1		db	000h	; 00000000b . 039a1 00
d11e2		db	000h	; 00000000b . 039a2 00
d11e3		db	000h	; 00000000b . 039a3 00
d11e4		db	000h	; 00000000b . 039a4 00
d11e5		db	000h	; 00000000b . 039a5 00
d11e6		db	000h	; 00000000b . 039a6 00
d11e7		db	000h	; 00000000b . 039a7 00
d11e8		db	000h	; 00000000b . 039a8 00
d11e9		db	000h	; 00000000b . 039a9 00
d11ea		db	000h	; 00000000b . 039aa 00
d11eb		db	000h	; 00000000b . 039ab 00
d11ec		db	000h	; 00000000b . 039ac 00
d11ed		db	000h	; 00000000b . 039ad 00
d11ee		db	000h	; 00000000b . 039ae 00
d11ef		db	000h	; 00000000b . 039af 00
d11f0		db	000h	; 00000000b . 039b0 00
d11f1		db	000h	; 00000000b . 039b1 00
d11f2		db	002h	; 00000010b . 039b2 02
d11f3		db	003h	; 00000011b . 039b3 03
d11f4		db	000h	; 00000000b . 039b4 00
d11f5		db	000h	; 00000000b . 039b5 00
d11f6		db	000h	; 00000000b . 039b6 00
d11f7		db	000h	; 00000000b . 039b7 00
d11f8		db	000h	; 00000000b . 039b8 00
d11f9		db	000h	; 00000000b . 039b9 00
d11fa		db	000h	; 00000000b . 039ba 00
d11fb		db	000h	; 00000000b . 039bb 00
d11fc		db	000h	; 00000000b . 039bc 00
d11fd		db	000h	; 00000000b . 039bd 00
d11fe		db	002h	; 00000010b . 039be 02
d11ff		db	000h	; 00000000b . 039bf 00
d1200		db	000h	; 00000000b . 039c0 00
d1201		db	003h	; 00000011b . 039c1 03
d1202		db	000h	; 00000000b . 039c2 00
d1203		db	000h	; 00000000b . 039c3 00
d1204		db	000h	; 00000000b . 039c4 00
d1205		db	000h	; 00000000b . 039c5 00
d1206		db	002h	; 00000010b . 039c6 02
d1207		db	003h	; 00000011b . 039c7 03
d1208		db	000h	; 00000000b . 039c8 00
d1209		db	000h	; 00000000b . 039c9 00
d120a		db	000h	; 00000000b . 039ca 00
d120b		db	000h	; 00000000b . 039cb 00
d120c		db	002h	; 00000010b . 039cc 02
d120d		db	00fh	; 00001111b . 039cd 0f
d120e		db	013h	; 00010011b . 039ce 13
d120f		db	000h	; 00000000b . 039cf 00
d1210		db	000h	; 00000000b . 039d0 00
d1211		db	000h	; 00000000b . 039d1 00
d1212		db	000h	; 00000000b . 039d2 00
d1213		db	000h	; 00000000b . 039d3 00
d1214		db	000h	; 00000000b . 039d4 00
d1215		db	000h	; 00000000b . 039d5 00
d1216		db	000h	; 00000000b . 039d6 00
d1217		db	000h	; 00000000b . 039d7 00
d1218		db	002h	; 00000010b . 039d8 02
d1219		db	003h	; 00000011b . 039d9 03
d121a		db	000h	; 00000000b . 039da 00
d121b		db	000h	; 00000000b . 039db 00
d121c		db	000h	; 00000000b . 039dc 00
d121d		db	000h	; 00000000b . 039dd 00
d121e		db	000h	; 00000000b . 039de 00
d121f		db	000h	; 00000000b . 039df 00
d1220		db	000h	; 00000000b . 039e0 00
d1221		db	000h	; 00000000b . 039e1 00
d1222		db	000h	; 00000000b . 039e2 00
d1223		db	000h	; 00000000b . 039e3 00
d1224		db	000h	; 00000000b . 039e4 00
d1225		db	000h	; 00000000b . 039e5 00
d1226		db	000h	; 00000000b . 039e6 00
d1227		db	000h	; 00000000b . 039e7 00
d1228		db	000h	; 00000000b . 039e8 00
d1229		db	000h	; 00000000b . 039e9 00
d122a		db	000h	; 00000000b . 039ea 00
d122b		db	000h	; 00000000b . 039eb 00
d122c		db	000h	; 00000000b . 039ec 00
d122d		db	000h	; 00000000b . 039ed 00
d122e		db	000h	; 00000000b . 039ee 00
d122f		db	014h	; 00010100b . 039ef 14
d1230		db	00ah	; 00001010b . 039f0 0a
d1231		db	00fh	; 00001111b . 039f1 0f
d1232		db	013h	; 00010011b . 039f2 13
d1233		db	000h	; 00000000b . 039f3 00
d1234		db	000h	; 00000000b . 039f4 00
d1235		db	000h	; 00000000b . 039f5 00
d1236		db	000h	; 00000000b . 039f6 00
d1237		db	000h	; 00000000b . 039f7 00
d1238		db	000h	; 00000000b . 039f8 00
d1239		db	000h	; 00000000b . 039f9 00
d123a		db	000h	; 00000000b . 039fa 00
d123b		db	000h	; 00000000b . 039fb 00
d123c		db	002h	; 00000010b . 039fc 02
d123d		db	000h	; 00000000b . 039fd 00
d123e		db	000h	; 00000000b . 039fe 00
d123f		db	003h	; 00000011b . 039ff 03
d1240		db	000h	; 00000000b . 03a00 00
d1241		db	000h	; 00000000b . 03a01 00
d1242		db	000h	; 00000000b . 03a02 00
d1243		db	000h	; 00000000b . 03a03 00
d1244		db	002h	; 00000010b . 03a04 02
d1245		db	003h	; 00000011b . 03a05 03
d1246		db	000h	; 00000000b . 03a06 00
d1247		db	000h	; 00000000b . 03a07 00
d1248		db	000h	; 00000000b . 03a08 00
d1249		db	000h	; 00000000b . 03a09 00
d124a		db	002h	; 00000010b . 03a0a 02
d124b		db	000h	; 00000000b . 03a0b 00
d124c		db	009h	; 00001001b . 03a0c 09
d124d		db	001h	; 00000001b . 03a0d 01
d124e		db	001h	; 00000001b . 03a0e 01
d124f		db	001h	; 00000001b . 03a0f 01
d1250		db	001h	; 00000001b . 03a10 01
d1251		db	006h	; 00000110b . 03a11 06
d1252		db	000h	; 00000000b . 03a12 00
d1253		db	000h	; 00000000b . 03a13 00
d1254		db	000h	; 00000000b . 03a14 00
d1255		db	000h	; 00000000b . 03a15 00
d1256		db	002h	; 00000010b . 03a16 02
d1257		db	003h	; 00000011b . 03a17 03
d1258		db	000h	; 00000000b . 03a18 00
d1259		db	000h	; 00000000b . 03a19 00
d125a		db	000h	; 00000000b . 03a1a 00
d125b		db	000h	; 00000000b . 03a1b 00
d125c		db	005h	; 00000101b . 03a1c 05
d125d		db	001h	; 00000001b . 03a1d 01
d125e		db	001h	; 00000001b . 03a1e 01
d125f		db	001h	; 00000001b . 03a1f 01
d1260		db	001h	; 00000001b . 03a20 01
d1261		db	001h	; 00000001b . 03a21 01
d1262		db	001h	; 00000001b . 03a22 01
d1263		db	006h	; 00000110b . 03a23 06
d1264		db	000h	; 00000000b . 03a24 00
d1265		db	000h	; 00000000b . 03a25 00
d1266		db	000h	; 00000000b . 03a26 00
d1267		db	000h	; 00000000b . 03a27 00
d1268		db	005h	; 00000101b . 03a28 05
d1269		db	001h	; 00000001b . 03a29 01
d126a		db	001h	; 00000001b . 03a2a 01
d126b		db	001h	; 00000001b . 03a2b 01
d126c		db	001h	; 00000001b . 03a2c 01
d126d		db	00dh	; 00001101b . 03a2d 0d
d126e		db	000h	; 00000000b . 03a2e 00
d126f		db	000h	; 00000000b . 03a2f 00
d1270		db	009h	; 00001001b . 03a30 09
d1271		db	001h	; 00000001b . 03a31 01
d1272		db	001h	; 00000001b . 03a32 01
d1273		db	001h	; 00000001b . 03a33 01
d1274		db	001h	; 00000001b . 03a34 01
d1275		db	006h	; 00000110b . 03a35 06
d1276		db	000h	; 00000000b . 03a36 00
d1277		db	000h	; 00000000b . 03a37 00
d1278		db	000h	; 00000000b . 03a38 00
d1279		db	000h	; 00000000b . 03a39 00
d127a		db	002h	; 00000010b . 03a3a 02
d127b		db	000h	; 00000000b . 03a3b 00
d127c		db	000h	; 00000000b . 03a3c 00
d127d		db	003h	; 00000011b . 03a3d 03
d127e		db	000h	; 00000000b . 03a3e 00
d127f		db	000h	; 00000000b . 03a3f 00
d1280		db	000h	; 00000000b . 03a40 00
d1281		db	000h	; 00000000b . 03a41 00
d1282		db	002h	; 00000010b . 03a42 02
d1283		db	003h	; 00000011b . 03a43 03
d1284		db	000h	; 00000000b . 03a44 00
d1285		db	000h	; 00000000b . 03a45 00
d1286		db	000h	; 00000000b . 03a46 00
d1287		db	000h	; 00000000b . 03a47 00
d1288		db	002h	; 00000010b . 03a48 02
d1289		db	000h	; 00000000b . 03a49 00
d128a		db	010h	; 00010000b . 03a4a 10
d128b		db	004h	; 00000100b . 03a4b 04
d128c		db	004h	; 00000100b . 03a4c 04
d128d		db	004h	; 00000100b . 03a4d 04
d128e		db	004h	; 00000100b . 03a4e 04
d128f		db	008h	; 00001000b . 03a4f 08
d1290		db	000h	; 00000000b . 03a50 00
d1291		db	000h	; 00000000b . 03a51 00
d1292		db	000h	; 00000000b . 03a52 00
d1293		db	000h	; 00000000b . 03a53 00
d1294		db	007h	; 00000111b . 03a54 07
d1295		db	008h	; 00001000b . 03a55 08
d1296		db	000h	; 00000000b . 03a56 00
d1297		db	000h	; 00000000b . 03a57 00
d1298		db	000h	; 00000000b . 03a58 00
d1299		db	000h	; 00000000b . 03a59 00
d129a		db	007h	; 00000111b . 03a5a 07
d129b		db	004h	; 00000100b . 03a5b 04
d129c		db	004h	; 00000100b . 03a5c 04
d129d		db	004h	; 00000100b . 03a5d 04
d129e		db	004h	; 00000100b . 03a5e 04
d129f		db	004h	; 00000100b . 03a5f 04
d12a0		db	004h	; 00000100b . 03a60 04
d12a1		db	008h	; 00001000b . 03a61 08
d12a2		db	000h	; 00000000b . 03a62 00
d12a3		db	000h	; 00000000b . 03a63 00
d12a4		db	000h	; 00000000b . 03a64 00
d12a5		db	000h	; 00000000b . 03a65 00
d12a6		db	007h	; 00000111b . 03a66 07
d12a7		db	004h	; 00000100b . 03a67 04
d12a8		db	004h	; 00000100b . 03a68 04
d12a9		db	004h	; 00000100b . 03a69 04
d12aa		db	004h	; 00000100b . 03a6a 04
d12ab		db	004h	; 00000100b . 03a6b 04
d12ac		db	004h	; 00000100b . 03a6c 04
d12ad		db	004h	; 00000100b . 03a6d 04
d12ae		db	004h	; 00000100b . 03a6e 04
d12af		db	004h	; 00000100b . 03a6f 04
d12b0		db	004h	; 00000100b . 03a70 04
d12b1		db	004h	; 00000100b . 03a71 04
d12b2		db	004h	; 00000100b . 03a72 04
d12b3		db	008h	; 00001000b . 03a73 08
d12b4		db	000h	; 00000000b . 03a74 00
d12b5		db	000h	; 00000000b . 03a75 00
d12b6		db	000h	; 00000000b . 03a76 00
d12b7		db	000h	; 00000000b . 03a77 00
d12b8		db	007h	; 00000111b . 03a78 07
d12b9		db	004h	; 00000100b . 03a79 04
d12ba		db	004h	; 00000100b . 03a7a 04
d12bb		db	008h	; 00001000b . 03a7b 08
d12bc		db	000h	; 00000000b . 03a7c 00
d12bd		db	000h	; 00000000b . 03a7d 00
d12be		db	000h	; 00000000b . 03a7e 00
d12bf		db	000h	; 00000000b . 03a7f 00
d12c0		db	002h	; 00000010b . 03a80 02
d12c1		db	003h	; 00000011b . 03a81 03
d12c2		db	000h	; 00000000b . 03a82 00
d12c3		db	000h	; 00000000b . 03a83 00
d12c4		db	000h	; 00000000b . 03a84 00
d12c5		db	000h	; 00000000b . 03a85 00
d12c6		db	002h	; 00000010b . 03a86 02
d12c7		db	00bh	; 00001011b . 03a87 0b
d12c8		db	011h	; 00010001b . 03a88 11
d12c9		db	000h	; 00000000b . 03a89 00
d12ca		db	000h	; 00000000b . 03a8a 00
d12cb		db	000h	; 00000000b . 03a8b 00
d12cc		db	000h	; 00000000b . 03a8c 00
d12cd		db	000h	; 00000000b . 03a8d 00
d12ce		db	000h	; 00000000b . 03a8e 00
d12cf		db	000h	; 00000000b . 03a8f 00
d12d0		db	000h	; 00000000b . 03a90 00
d12d1		db	000h	; 00000000b . 03a91 00
d12d2		db	000h	; 00000000b . 03a92 00
d12d3		db	000h	; 00000000b . 03a93 00
d12d4		db	000h	; 00000000b . 03a94 00
d12d5		db	000h	; 00000000b . 03a95 00
d12d6		db	000h	; 00000000b . 03a96 00
d12d7		db	000h	; 00000000b . 03a97 00
d12d8		db	000h	; 00000000b . 03a98 00
d12d9		db	000h	; 00000000b . 03a99 00
d12da		db	000h	; 00000000b . 03a9a 00
d12db		db	000h	; 00000000b . 03a9b 00
d12dc		db	000h	; 00000000b . 03a9c 00
d12dd		db	000h	; 00000000b . 03a9d 00
d12de		db	000h	; 00000000b . 03a9e 00
d12df		db	000h	; 00000000b . 03a9f 00
d12e0		db	000h	; 00000000b . 03aa0 00
d12e1		db	000h	; 00000000b . 03aa1 00
d12e2		db	000h	; 00000000b . 03aa2 00
d12e3		db	000h	; 00000000b . 03aa3 00
d12e4		db	000h	; 00000000b . 03aa4 00
d12e5		db	000h	; 00000000b . 03aa5 00
d12e6		db	000h	; 00000000b . 03aa6 00
d12e7		db	000h	; 00000000b . 03aa7 00
d12e8		db	000h	; 00000000b . 03aa8 00
d12e9		db	000h	; 00000000b . 03aa9 00
d12ea		db	000h	; 00000000b . 03aaa 00
d12eb		db	000h	; 00000000b . 03aab 00
d12ec		db	000h	; 00000000b . 03aac 00
d12ed		db	000h	; 00000000b . 03aad 00
d12ee		db	000h	; 00000000b . 03aae 00
d12ef		db	000h	; 00000000b . 03aaf 00
d12f0		db	000h	; 00000000b . 03ab0 00
d12f1		db	000h	; 00000000b . 03ab1 00
d12f2		db	000h	; 00000000b . 03ab2 00
d12f3		db	000h	; 00000000b . 03ab3 00
d12f4		db	000h	; 00000000b . 03ab4 00
d12f5		db	000h	; 00000000b . 03ab5 00
d12f6		db	000h	; 00000000b . 03ab6 00
d12f7		db	000h	; 00000000b . 03ab7 00
d12f8		db	000h	; 00000000b . 03ab8 00
d12f9		db	000h	; 00000000b . 03ab9 00
d12fa		db	000h	; 00000000b . 03aba 00
d12fb		db	000h	; 00000000b . 03abb 00
d12fc		db	000h	; 00000000b . 03abc 00
d12fd		db	000h	; 00000000b . 03abd 00
d12fe		db	002h	; 00000010b . 03abe 02
d12ff		db	003h	; 00000011b . 03abf 03
d1300		db	000h	; 00000000b . 03ac0 00
d1301		db	000h	; 00000000b . 03ac1 00
d1302		db	000h	; 00000000b . 03ac2 00
d1303		db	000h	; 00000000b . 03ac3 00
d1304		db	002h	; 00000010b . 03ac4 02
d1305		db	003h	; 00000011b . 03ac5 03
d1306		db	000h	; 00000000b . 03ac6 00
d1307		db	000h	; 00000000b . 03ac7 00
d1308		db	000h	; 00000000b . 03ac8 00
d1309		db	000h	; 00000000b . 03ac9 00
d130a		db	000h	; 00000000b . 03aca 00
d130b		db	000h	; 00000000b . 03acb 00
d130c		db	000h	; 00000000b . 03acc 00
d130d		db	000h	; 00000000b . 03acd 00
d130e		db	000h	; 00000000b . 03ace 00
d130f		db	000h	; 00000000b . 03acf 00
d1310		db	000h	; 00000000b . 03ad0 00
d1311		db	000h	; 00000000b . 03ad1 00
d1312		db	000h	; 00000000b . 03ad2 00
d1313		db	000h	; 00000000b . 03ad3 00
d1314		db	000h	; 00000000b . 03ad4 00
d1315		db	000h	; 00000000b . 03ad5 00
d1316		db	000h	; 00000000b . 03ad6 00
d1317		db	000h	; 00000000b . 03ad7 00
d1318		db	000h	; 00000000b . 03ad8 00
d1319		db	000h	; 00000000b . 03ad9 00
d131a		db	000h	; 00000000b . 03ada 00
d131b		db	000h	; 00000000b . 03adb 00
d131c		db	000h	; 00000000b . 03adc 00
d131d		db	000h	; 00000000b . 03add 00
d131e		db	000h	; 00000000b . 03ade 00
d131f		db	000h	; 00000000b . 03adf 00
d1320		db	000h	; 00000000b . 03ae0 00
d1321		db	000h	; 00000000b . 03ae1 00
d1322		db	000h	; 00000000b . 03ae2 00
d1323		db	000h	; 00000000b . 03ae3 00
d1324		db	000h	; 00000000b . 03ae4 00
d1325		db	000h	; 00000000b . 03ae5 00
d1326		db	000h	; 00000000b . 03ae6 00
d1327		db	000h	; 00000000b . 03ae7 00
d1328		db	000h	; 00000000b . 03ae8 00
d1329		db	000h	; 00000000b . 03ae9 00
d132a		db	000h	; 00000000b . 03aea 00
d132b		db	000h	; 00000000b . 03aeb 00
d132c		db	000h	; 00000000b . 03aec 00
d132d		db	000h	; 00000000b . 03aed 00
d132e		db	000h	; 00000000b . 03aee 00
d132f		db	000h	; 00000000b . 03aef 00
d1330		db	000h	; 00000000b . 03af0 00
d1331		db	000h	; 00000000b . 03af1 00
d1332		db	000h	; 00000000b . 03af2 00
d1333		db	000h	; 00000000b . 03af3 00
d1334		db	000h	; 00000000b . 03af4 00
d1335		db	000h	; 00000000b . 03af5 00
d1336		db	000h	; 00000000b . 03af6 00
d1337		db	000h	; 00000000b . 03af7 00
d1338		db	000h	; 00000000b . 03af8 00
d1339		db	000h	; 00000000b . 03af9 00
d133a		db	000h	; 00000000b . 03afa 00
d133b		db	000h	; 00000000b . 03afb 00
d133c		db	002h	; 00000010b . 03afc 02
d133d		db	003h	; 00000011b . 03afd 03
d133e		db	000h	; 00000000b . 03afe 00
d133f		db	000h	; 00000000b . 03aff 00
d1340		db	000h	; 00000000b . 03b00 00
d1341		db	000h	; 00000000b . 03b01 00
d1342		db	002h	; 00000010b . 03b02 02
d1343		db	003h	; 00000011b . 03b03 03
d1344		db	000h	; 00000000b . 03b04 00
d1345		db	000h	; 00000000b . 03b05 00
d1346		db	000h	; 00000000b . 03b06 00
d1347		db	000h	; 00000000b . 03b07 00
d1348		db	000h	; 00000000b . 03b08 00
d1349		db	000h	; 00000000b . 03b09 00
d134a		db	000h	; 00000000b . 03b0a 00
d134b		db	000h	; 00000000b . 03b0b 00
d134c		db	000h	; 00000000b . 03b0c 00
d134d		db	000h	; 00000000b . 03b0d 00
d134e		db	000h	; 00000000b . 03b0e 00
d134f		db	000h	; 00000000b . 03b0f 00
d1350		db	000h	; 00000000b . 03b10 00
d1351		db	000h	; 00000000b . 03b11 00
d1352		db	000h	; 00000000b . 03b12 00
d1353		db	000h	; 00000000b . 03b13 00
d1354		db	000h	; 00000000b . 03b14 00
d1355		db	000h	; 00000000b . 03b15 00
d1356		db	000h	; 00000000b . 03b16 00
d1357		db	000h	; 00000000b . 03b17 00
d1358		db	000h	; 00000000b . 03b18 00
d1359		db	000h	; 00000000b . 03b19 00
d135a		db	000h	; 00000000b . 03b1a 00
d135b		db	000h	; 00000000b . 03b1b 00
d135c		db	000h	; 00000000b . 03b1c 00
d135d		db	000h	; 00000000b . 03b1d 00
d135e		db	000h	; 00000000b . 03b1e 00
d135f		db	000h	; 00000000b . 03b1f 00
d1360		db	000h	; 00000000b . 03b20 00
d1361		db	000h	; 00000000b . 03b21 00
d1362		db	000h	; 00000000b . 03b22 00
d1363		db	000h	; 00000000b . 03b23 00
d1364		db	000h	; 00000000b . 03b24 00
d1365		db	000h	; 00000000b . 03b25 00
d1366		db	000h	; 00000000b . 03b26 00
d1367		db	000h	; 00000000b . 03b27 00
d1368		db	000h	; 00000000b . 03b28 00
d1369		db	000h	; 00000000b . 03b29 00
d136a		db	000h	; 00000000b . 03b2a 00
d136b		db	000h	; 00000000b . 03b2b 00
d136c		db	000h	; 00000000b . 03b2c 00
d136d		db	000h	; 00000000b . 03b2d 00
d136e		db	000h	; 00000000b . 03b2e 00
d136f		db	000h	; 00000000b . 03b2f 00
d1370		db	000h	; 00000000b . 03b30 00
d1371		db	000h	; 00000000b . 03b31 00
d1372		db	000h	; 00000000b . 03b32 00
d1373		db	000h	; 00000000b . 03b33 00
d1374		db	000h	; 00000000b . 03b34 00
d1375		db	000h	; 00000000b . 03b35 00
d1376		db	000h	; 00000000b . 03b36 00
d1377		db	000h	; 00000000b . 03b37 00
d1378		db	000h	; 00000000b . 03b38 00
d1379		db	000h	; 00000000b . 03b39 00
d137a		db	002h	; 00000010b . 03b3a 02
d137b		db	003h	; 00000011b . 03b3b 03
d137c		db	000h	; 00000000b . 03b3c 00
d137d		db	000h	; 00000000b . 03b3d 00
d137e		db	000h	; 00000000b . 03b3e 00
d137f		db	000h	; 00000000b . 03b3f 00
d1380		db	002h	; 00000010b . 03b40 02
d1381		db	003h	; 00000011b . 03b41 03
d1382		db	000h	; 00000000b . 03b42 00
d1383		db	000h	; 00000000b . 03b43 00
d1384		db	000h	; 00000000b . 03b44 00
d1385		db	000h	; 00000000b . 03b45 00
d1386		db	000h	; 00000000b . 03b46 00
d1387		db	000h	; 00000000b . 03b47 00
d1388		db	000h	; 00000000b . 03b48 00
d1389		db	000h	; 00000000b . 03b49 00
d138a		db	000h	; 00000000b . 03b4a 00
d138b		db	000h	; 00000000b . 03b4b 00
d138c		db	000h	; 00000000b . 03b4c 00
d138d		db	000h	; 00000000b . 03b4d 00
d138e		db	000h	; 00000000b . 03b4e 00
d138f		db	000h	; 00000000b . 03b4f 00
d1390		db	000h	; 00000000b . 03b50 00
d1391		db	000h	; 00000000b . 03b51 00
d1392		db	000h	; 00000000b . 03b52 00
d1393		db	000h	; 00000000b . 03b53 00
d1394		db	000h	; 00000000b . 03b54 00
d1395		db	000h	; 00000000b . 03b55 00
d1396		db	000h	; 00000000b . 03b56 00
d1397		db	000h	; 00000000b . 03b57 00
d1398		db	000h	; 00000000b . 03b58 00
d1399		db	000h	; 00000000b . 03b59 00
d139a		db	000h	; 00000000b . 03b5a 00
d139b		db	000h	; 00000000b . 03b5b 00
d139c		db	000h	; 00000000b . 03b5c 00
d139d		db	000h	; 00000000b . 03b5d 00
d139e		db	000h	; 00000000b . 03b5e 00
d139f		db	000h	; 00000000b . 03b5f 00
d13a0		db	000h	; 00000000b . 03b60 00
d13a1		db	000h	; 00000000b . 03b61 00
d13a2		db	000h	; 00000000b . 03b62 00
d13a3		db	000h	; 00000000b . 03b63 00
d13a4		db	000h	; 00000000b . 03b64 00
d13a5		db	000h	; 00000000b . 03b65 00
d13a6		db	000h	; 00000000b . 03b66 00
d13a7		db	000h	; 00000000b . 03b67 00
d13a8		db	000h	; 00000000b . 03b68 00
d13a9		db	000h	; 00000000b . 03b69 00
d13aa		db	000h	; 00000000b . 03b6a 00
d13ab		db	000h	; 00000000b . 03b6b 00
d13ac		db	000h	; 00000000b . 03b6c 00
d13ad		db	000h	; 00000000b . 03b6d 00
d13ae		db	000h	; 00000000b . 03b6e 00
d13af		db	000h	; 00000000b . 03b6f 00
d13b0		db	000h	; 00000000b . 03b70 00
d13b1		db	000h	; 00000000b . 03b71 00
d13b2		db	000h	; 00000000b . 03b72 00
d13b3		db	000h	; 00000000b . 03b73 00
d13b4		db	000h	; 00000000b . 03b74 00
d13b5		db	000h	; 00000000b . 03b75 00
d13b6		db	000h	; 00000000b . 03b76 00
d13b7		db	000h	; 00000000b . 03b77 00
d13b8		db	002h	; 00000010b . 03b78 02
d13b9		db	003h	; 00000011b . 03b79 03
d13ba		db	000h	; 00000000b . 03b7a 00
d13bb		db	000h	; 00000000b . 03b7b 00
d13bc		db	000h	; 00000000b . 03b7c 00
d13bd		db	000h	; 00000000b . 03b7d 00
d13be		db	002h	; 00000010b . 03b7e 02
d13bf		db	003h	; 00000011b . 03b7f 03
d13c0		db	000h	; 00000000b . 03b80 00
d13c1		db	000h	; 00000000b . 03b81 00
d13c2		db	000h	; 00000000b . 03b82 00
d13c3		db	000h	; 00000000b . 03b83 00
d13c4		db	005h	; 00000101b . 03b84 05
d13c5		db	001h	; 00000001b . 03b85 01
d13c6		db	001h	; 00000001b . 03b86 01
d13c7		db	001h	; 00000001b . 03b87 01
d13c8		db	001h	; 00000001b . 03b88 01
d13c9		db	001h	; 00000001b . 03b89 01
d13ca		db	001h	; 00000001b . 03b8a 01
d13cb		db	006h	; 00000110b . 03b8b 06
d13cc		db	000h	; 00000000b . 03b8c 00
d13cd		db	000h	; 00000000b . 03b8d 00
d13ce		db	000h	; 00000000b . 03b8e 00
d13cf		db	000h	; 00000000b . 03b8f 00
d13d0		db	005h	; 00000101b . 03b90 05
d13d1		db	001h	; 00000001b . 03b91 01
d13d2		db	001h	; 00000001b . 03b92 01
d13d3		db	001h	; 00000001b . 03b93 01
d13d4		db	001h	; 00000001b . 03b94 01
d13d5		db	001h	; 00000001b . 03b95 01
d13d6		db	001h	; 00000001b . 03b96 01
d13d7		db	006h	; 00000110b . 03b97 06
d13d8		db	000h	; 00000000b . 03b98 00
d13d9		db	000h	; 00000000b . 03b99 00
d13da		db	000h	; 00000000b . 03b9a 00
d13db		db	000h	; 00000000b . 03b9b 00
d13dc		db	005h	; 00000101b . 03b9c 05
d13dd		db	001h	; 00000001b . 03b9d 01
d13de		db	001h	; 00000001b . 03b9e 01
d13df		db	001h	; 00000001b . 03b9f 01
d13e0		db	001h	; 00000001b . 03ba0 01
d13e1		db	001h	; 00000001b . 03ba1 01
d13e2		db	001h	; 00000001b . 03ba2 01
d13e3		db	006h	; 00000110b . 03ba3 06
d13e4		db	000h	; 00000000b . 03ba4 00
d13e5		db	000h	; 00000000b . 03ba5 00
d13e6		db	000h	; 00000000b . 03ba6 00
d13e7		db	000h	; 00000000b . 03ba7 00
d13e8		db	005h	; 00000101b . 03ba8 05
d13e9		db	006h	; 00000110b . 03ba9 06
d13ea		db	000h	; 00000000b . 03baa 00
d13eb		db	000h	; 00000000b . 03bab 00
d13ec		db	000h	; 00000000b . 03bac 00
d13ed		db	000h	; 00000000b . 03bad 00
d13ee		db	005h	; 00000101b . 03bae 05
d13ef		db	001h	; 00000001b . 03baf 01
d13f0		db	001h	; 00000001b . 03bb0 01
d13f1		db	006h	; 00000110b . 03bb1 06
d13f2		db	000h	; 00000000b . 03bb2 00
d13f3		db	000h	; 00000000b . 03bb3 00
d13f4		db	000h	; 00000000b . 03bb4 00
d13f5		db	000h	; 00000000b . 03bb5 00
d13f6		db	002h	; 00000010b . 03bb6 02
d13f7		db	003h	; 00000011b . 03bb7 03
d13f8		db	000h	; 00000000b . 03bb8 00
d13f9		db	000h	; 00000000b . 03bb9 00
d13fa		db	000h	; 00000000b . 03bba 00
d13fb		db	000h	; 00000000b . 03bbb 00
d13fc		db	002h	; 00000010b . 03bbc 02
d13fd		db	003h	; 00000011b . 03bbd 03
d13fe		db	000h	; 00000000b . 03bbe 00
d13ff		db	000h	; 00000000b . 03bbf 00
d1400		db	000h	; 00000000b . 03bc0 00
d1401		db	000h	; 00000000b . 03bc1 00
d1402		db	007h	; 00000111b . 03bc2 07
d1403		db	004h	; 00000100b . 03bc3 04
d1404		db	004h	; 00000100b . 03bc4 04
d1405		db	004h	; 00000100b . 03bc5 04
d1406		db	004h	; 00000100b . 03bc6 04
d1407		db	00ch	; 00001100b . 03bc7 0c
d1408		db	000h	; 00000000b . 03bc8 00
d1409		db	003h	; 00000011b . 03bc9 03
d140a		db	000h	; 00000000b . 03bca 00
d140b		db	000h	; 00000000b . 03bcb 00
d140c		db	000h	; 00000000b . 03bcc 00
d140d		db	000h	; 00000000b . 03bcd 00
d140e		db	002h	; 00000010b . 03bce 02
d140f		db	000h	; 00000000b . 03bcf 00
d1410		db	000h	; 00000000b . 03bd0 00
d1411		db	000h	; 00000000b . 03bd1 00
d1412		db	000h	; 00000000b . 03bd2 00
d1413		db	000h	; 00000000b . 03bd3 00
d1414		db	000h	; 00000000b . 03bd4 00
d1415		db	003h	; 00000011b . 03bd5 03
d1416		db	000h	; 00000000b . 03bd6 00
d1417		db	000h	; 00000000b . 03bd7 00
d1418		db	000h	; 00000000b . 03bd8 00
d1419		db	000h	; 00000000b . 03bd9 00
d141a		db	002h	; 00000010b . 03bda 02
d141b		db	000h	; 00000000b . 03bdb 00
d141c		db	000h	; 00000000b . 03bdc 00
d141d		db	000h	; 00000000b . 03bdd 00
d141e		db	000h	; 00000000b . 03bde 00
d141f		db	000h	; 00000000b . 03bdf 00
d1420		db	000h	; 00000000b . 03be0 00
d1421		db	003h	; 00000011b . 03be1 03
d1422		db	000h	; 00000000b . 03be2 00
d1423		db	000h	; 00000000b . 03be3 00
d1424		db	000h	; 00000000b . 03be4 00
d1425		db	000h	; 00000000b . 03be5 00
d1426		db	002h	; 00000010b . 03be6 02
d1427		db	003h	; 00000011b . 03be7 03
d1428		db	000h	; 00000000b . 03be8 00
d1429		db	000h	; 00000000b . 03be9 00
d142a		db	000h	; 00000000b . 03bea 00
d142b		db	000h	; 00000000b . 03beb 00
d142c		db	002h	; 00000010b . 03bec 02
d142d		db	000h	; 00000000b . 03bed 00
d142e		db	000h	; 00000000b . 03bee 00
d142f		db	003h	; 00000011b . 03bef 03
d1430		db	000h	; 00000000b . 03bf0 00
d1431		db	000h	; 00000000b . 03bf1 00
d1432		db	000h	; 00000000b . 03bf2 00
d1433		db	000h	; 00000000b . 03bf3 00
d1434		db	002h	; 00000010b . 03bf4 02
d1435		db	003h	; 00000011b . 03bf5 03
d1436		db	000h	; 00000000b . 03bf6 00
d1437		db	000h	; 00000000b . 03bf7 00
d1438		db	000h	; 00000000b . 03bf8 00
d1439		db	000h	; 00000000b . 03bf9 00
d143a		db	002h	; 00000010b . 03bfa 02
d143b		db	003h	; 00000011b . 03bfb 03
d143c		db	000h	; 00000000b . 03bfc 00
d143d		db	000h	; 00000000b . 03bfd 00
d143e		db	000h	; 00000000b . 03bfe 00
d143f		db	000h	; 00000000b . 03bff 00
d1440		db	000h	; 00000000b . 03c00 00
d1441		db	000h	; 00000000b . 03c01 00
d1442		db	000h	; 00000000b . 03c02 00
d1443		db	000h	; 00000000b . 03c03 00
d1444		db	000h	; 00000000b . 03c04 00
d1445		db	012h	; 00010010b . 03c05 12
d1446		db	00eh	; 00001110b . 03c06 0e
d1447		db	003h	; 00000011b . 03c07 03
d1448		db	000h	; 00000000b . 03c08 00
d1449		db	000h	; 00000000b . 03c09 00
d144a		db	000h	; 00000000b . 03c0a 00
d144b		db	000h	; 00000000b . 03c0b 00
d144c		db	002h	; 00000010b . 03c0c 02
d144d		db	000h	; 00000000b . 03c0d 00
d144e		db	000h	; 00000000b . 03c0e 00
d144f		db	000h	; 00000000b . 03c0f 00
d1450		db	000h	; 00000000b . 03c10 00
d1451		db	000h	; 00000000b . 03c11 00
d1452		db	000h	; 00000000b . 03c12 00
d1453		db	003h	; 00000011b . 03c13 03
d1454		db	000h	; 00000000b . 03c14 00
d1455		db	000h	; 00000000b . 03c15 00
d1456		db	000h	; 00000000b . 03c16 00
d1457		db	000h	; 00000000b . 03c17 00
d1458		db	002h	; 00000010b . 03c18 02
d1459		db	000h	; 00000000b . 03c19 00
d145a		db	000h	; 00000000b . 03c1a 00
d145b		db	000h	; 00000000b . 03c1b 00
d145c		db	000h	; 00000000b . 03c1c 00
d145d		db	000h	; 00000000b . 03c1d 00
d145e		db	000h	; 00000000b . 03c1e 00
d145f		db	003h	; 00000011b . 03c1f 03
d1460		db	000h	; 00000000b . 03c20 00
d1461		db	000h	; 00000000b . 03c21 00
d1462		db	000h	; 00000000b . 03c22 00
d1463		db	000h	; 00000000b . 03c23 00
d1464		db	002h	; 00000010b . 03c24 02
d1465		db	003h	; 00000011b . 03c25 03
d1466		db	000h	; 00000000b . 03c26 00
d1467		db	000h	; 00000000b . 03c27 00
d1468		db	000h	; 00000000b . 03c28 00
d1469		db	000h	; 00000000b . 03c29 00
d146a		db	002h	; 00000010b . 03c2a 02
d146b		db	000h	; 00000000b . 03c2b 00
d146c		db	000h	; 00000000b . 03c2c 00
d146d		db	003h	; 00000011b . 03c2d 03
d146e		db	000h	; 00000000b . 03c2e 00
d146f		db	000h	; 00000000b . 03c2f 00
d1470		db	000h	; 00000000b . 03c30 00
d1471		db	000h	; 00000000b . 03c31 00
d1472		db	002h	; 00000010b . 03c32 02
d1473		db	003h	; 00000011b . 03c33 03
d1474		db	000h	; 00000000b . 03c34 00
d1475		db	000h	; 00000000b . 03c35 00
d1476		db	000h	; 00000000b . 03c36 00
d1477		db	000h	; 00000000b . 03c37 00
d1478		db	002h	; 00000010b . 03c38 02
d1479		db	003h	; 00000011b . 03c39 03
d147a		db	000h	; 00000000b . 03c3a 00
d147b		db	000h	; 00000000b . 03c3b 00
d147c		db	000h	; 00000000b . 03c3c 00
d147d		db	000h	; 00000000b . 03c3d 00
d147e		db	000h	; 00000000b . 03c3e 00
d147f		db	000h	; 00000000b . 03c3f 00
d1480		db	000h	; 00000000b . 03c40 00
d1481		db	000h	; 00000000b . 03c41 00
d1482		db	000h	; 00000000b . 03c42 00
d1483		db	000h	; 00000000b . 03c43 00
d1484		db	002h	; 00000010b . 03c44 02
d1485		db	003h	; 00000011b . 03c45 03
d1486		db	000h	; 00000000b . 03c46 00
d1487		db	000h	; 00000000b . 03c47 00
d1488		db	000h	; 00000000b . 03c48 00
d1489		db	000h	; 00000000b . 03c49 00
d148a		db	002h	; 00000010b . 03c4a 02
d148b		db	000h	; 00000000b . 03c4b 00
d148c		db	000h	; 00000000b . 03c4c 00
d148d		db	000h	; 00000000b . 03c4d 00
d148e		db	000h	; 00000000b . 03c4e 00
d148f		db	000h	; 00000000b . 03c4f 00
d1490		db	000h	; 00000000b . 03c50 00
d1491		db	003h	; 00000011b . 03c51 03
d1492		db	000h	; 00000000b . 03c52 00
d1493		db	000h	; 00000000b . 03c53 00
d1494		db	000h	; 00000000b . 03c54 00
d1495		db	000h	; 00000000b . 03c55 00
d1496		db	002h	; 00000010b . 03c56 02
d1497		db	000h	; 00000000b . 03c57 00
d1498		db	000h	; 00000000b . 03c58 00
d1499		db	000h	; 00000000b . 03c59 00
d149a		db	000h	; 00000000b . 03c5a 00
d149b		db	000h	; 00000000b . 03c5b 00
d149c		db	000h	; 00000000b . 03c5c 00
d149d		db	003h	; 00000011b . 03c5d 03
d149e		db	000h	; 00000000b . 03c5e 00
d149f		db	000h	; 00000000b . 03c5f 00
d14a0		db	000h	; 00000000b . 03c60 00
d14a1		db	000h	; 00000000b . 03c61 00
d14a2		db	002h	; 00000010b . 03c62 02
d14a3		db	003h	; 00000011b . 03c63 03
d14a4		db	000h	; 00000000b . 03c64 00
d14a5		db	000h	; 00000000b . 03c65 00
d14a6		db	000h	; 00000000b . 03c66 00
d14a7		db	000h	; 00000000b . 03c67 00
d14a8		db	002h	; 00000010b . 03c68 02
d14a9		db	000h	; 00000000b . 03c69 00
d14aa		db	000h	; 00000000b . 03c6a 00
d14ab		db	003h	; 00000011b . 03c6b 03
d14ac		db	000h	; 00000000b . 03c6c 00
d14ad		db	000h	; 00000000b . 03c6d 00
d14ae		db	000h	; 00000000b . 03c6e 00
d14af		db	000h	; 00000000b . 03c6f 00
d14b0		db	002h	; 00000010b . 03c70 02
d14b1		db	003h	; 00000011b . 03c71 03
d14b2		db	000h	; 00000000b . 03c72 00
d14b3		db	000h	; 00000000b . 03c73 00
d14b4		db	000h	; 00000000b . 03c74 00
d14b5		db	000h	; 00000000b . 03c75 00
d14b6		db	002h	; 00000010b . 03c76 02
d14b7		db	003h	; 00000011b . 03c77 03
d14b8		db	000h	; 00000000b . 03c78 00
d14b9		db	000h	; 00000000b . 03c79 00
d14ba		db	000h	; 00000000b . 03c7a 00
d14bb		db	000h	; 00000000b . 03c7b 00
d14bc		db	000h	; 00000000b . 03c7c 00
d14bd		db	000h	; 00000000b . 03c7d 00
d14be		db	000h	; 00000000b . 03c7e 00
d14bf		db	000h	; 00000000b . 03c7f 00
d14c0		db	000h	; 00000000b . 03c80 00
d14c1		db	000h	; 00000000b . 03c81 00
d14c2		db	002h	; 00000010b . 03c82 02
d14c3		db	003h	; 00000011b . 03c83 03
d14c4		db	000h	; 00000000b . 03c84 00
d14c5		db	000h	; 00000000b . 03c85 00
d14c6		db	000h	; 00000000b . 03c86 00
d14c7		db	000h	; 00000000b . 03c87 00
d14c8		db	002h	; 00000010b . 03c88 02
d14c9		db	000h	; 00000000b . 03c89 00
d14ca		db	000h	; 00000000b . 03c8a 00
d14cb		db	000h	; 00000000b . 03c8b 00
d14cc		db	000h	; 00000000b . 03c8c 00
d14cd		db	000h	; 00000000b . 03c8d 00
d14ce		db	000h	; 00000000b . 03c8e 00
d14cf		db	003h	; 00000011b . 03c8f 03
d14d0		db	000h	; 00000000b . 03c90 00
d14d1		db	000h	; 00000000b . 03c91 00
d14d2		db	000h	; 00000000b . 03c92 00
d14d3		db	000h	; 00000000b . 03c93 00
d14d4		db	002h	; 00000010b . 03c94 02
d14d5		db	000h	; 00000000b . 03c95 00
d14d6		db	000h	; 00000000b . 03c96 00
d14d7		db	000h	; 00000000b . 03c97 00
d14d8		db	000h	; 00000000b . 03c98 00
d14d9		db	000h	; 00000000b . 03c99 00
d14da		db	000h	; 00000000b . 03c9a 00
d14db		db	003h	; 00000011b . 03c9b 03
d14dc		db	000h	; 00000000b . 03c9c 00
d14dd		db	000h	; 00000000b . 03c9d 00
d14de		db	000h	; 00000000b . 03c9e 00
d14df		db	000h	; 00000000b . 03c9f 00
d14e0		db	002h	; 00000010b . 03ca0 02
d14e1		db	003h	; 00000011b . 03ca1 03
d14e2		db	000h	; 00000000b . 03ca2 00
d14e3		db	000h	; 00000000b . 03ca3 00
d14e4		db	000h	; 00000000b . 03ca4 00
d14e5		db	000h	; 00000000b . 03ca5 00
d14e6		db	002h	; 00000010b . 03ca6 02
d14e7		db	000h	; 00000000b . 03ca7 00
d14e8		db	000h	; 00000000b . 03ca8 00
d14e9		db	003h	; 00000011b . 03ca9 03
d14ea		db	000h	; 00000000b . 03caa 00
d14eb		db	000h	; 00000000b . 03cab 00
d14ec		db	000h	; 00000000b . 03cac 00
d14ed		db	000h	; 00000000b . 03cad 00
d14ee		db	002h	; 00000010b . 03cae 02
d14ef		db	003h	; 00000011b . 03caf 03
d14f0		db	000h	; 00000000b . 03cb0 00
d14f1		db	000h	; 00000000b . 03cb1 00
d14f2		db	000h	; 00000000b . 03cb2 00
d14f3		db	000h	; 00000000b . 03cb3 00
d14f4		db	007h	; 00000111b . 03cb4 07
d14f5		db	008h	; 00001000b . 03cb5 08
d14f6		db	000h	; 00000000b . 03cb6 00
d14f7		db	000h	; 00000000b . 03cb7 00
d14f8		db	000h	; 00000000b . 03cb8 00
d14f9		db	000h	; 00000000b . 03cb9 00
d14fa		db	000h	; 00000000b . 03cba 00
d14fb		db	000h	; 00000000b . 03cbb 00
d14fc		db	000h	; 00000000b . 03cbc 00
d14fd		db	000h	; 00000000b . 03cbd 00
d14fe		db	000h	; 00000000b . 03cbe 00
d14ff		db	000h	; 00000000b . 03cbf 00
d1500		db	007h	; 00000111b . 03cc0 07
d1501		db	008h	; 00001000b . 03cc1 08
d1502		db	000h	; 00000000b . 03cc2 00
d1503		db	000h	; 00000000b . 03cc3 00
d1504		db	000h	; 00000000b . 03cc4 00
d1505		db	000h	; 00000000b . 03cc5 00
d1506		db	002h	; 00000010b . 03cc6 02
d1507		db	000h	; 00000000b . 03cc7 00
d1508		db	000h	; 00000000b . 03cc8 00
d1509		db	000h	; 00000000b . 03cc9 00
d150a		db	000h	; 00000000b . 03cca 00
d150b		db	000h	; 00000000b . 03ccb 00
d150c		db	000h	; 00000000b . 03ccc 00
d150d		db	003h	; 00000011b . 03ccd 03
d150e		db	000h	; 00000000b . 03cce 00
d150f		db	000h	; 00000000b . 03ccf 00
d1510		db	000h	; 00000000b . 03cd0 00
d1511		db	000h	; 00000000b . 03cd1 00
d1512		db	002h	; 00000010b . 03cd2 02
d1513		db	000h	; 00000000b . 03cd3 00
d1514		db	000h	; 00000000b . 03cd4 00
d1515		db	000h	; 00000000b . 03cd5 00
d1516		db	000h	; 00000000b . 03cd6 00
d1517		db	000h	; 00000000b . 03cd7 00
d1518		db	000h	; 00000000b . 03cd8 00
d1519		db	003h	; 00000011b . 03cd9 03
d151a		db	000h	; 00000000b . 03cda 00
d151b		db	000h	; 00000000b . 03cdb 00
d151c		db	000h	; 00000000b . 03cdc 00
d151d		db	000h	; 00000000b . 03cdd 00
d151e		db	007h	; 00000111b . 03cde 07
d151f		db	008h	; 00001000b . 03cdf 08
d1520		db	000h	; 00000000b . 03ce0 00
d1521		db	000h	; 00000000b . 03ce1 00
d1522		db	000h	; 00000000b . 03ce2 00
d1523		db	000h	; 00000000b . 03ce3 00
d1524		db	007h	; 00000111b . 03ce4 07
d1525		db	004h	; 00000100b . 03ce5 04
d1526		db	004h	; 00000100b . 03ce6 04
d1527		db	008h	; 00001000b . 03ce7 08
d1528		db	000h	; 00000000b . 03ce8 00
d1529		db	000h	; 00000000b . 03ce9 00
d152a		db	000h	; 00000000b . 03cea 00
d152b		db	000h	; 00000000b . 03ceb 00
d152c		db	002h	; 00000010b . 03cec 02
d152d		db	003h	; 00000011b . 03ced 03
d152e		db	000h	; 00000000b . 03cee 00
d152f		db	000h	; 00000000b . 03cef 00
d1530		db	000h	; 00000000b . 03cf0 00
d1531		db	000h	; 00000000b . 03cf1 00
d1532		db	000h	; 00000000b . 03cf2 00
d1533		db	000h	; 00000000b . 03cf3 00
d1534		db	000h	; 00000000b . 03cf4 00
d1535		db	000h	; 00000000b . 03cf5 00
d1536		db	000h	; 00000000b . 03cf6 00
d1537		db	000h	; 00000000b . 03cf7 00
d1538		db	005h	; 00000101b . 03cf8 05
d1539		db	006h	; 00000110b . 03cf9 06
d153a		db	000h	; 00000000b . 03cfa 00
d153b		db	000h	; 00000000b . 03cfb 00
d153c		db	000h	; 00000000b . 03cfc 00
d153d		db	000h	; 00000000b . 03cfd 00
d153e		db	000h	; 00000000b . 03cfe 00
d153f		db	000h	; 00000000b . 03cff 00
d1540		db	000h	; 00000000b . 03d00 00
d1541		db	000h	; 00000000b . 03d01 00
d1542		db	000h	; 00000000b . 03d02 00
d1543		db	000h	; 00000000b . 03d03 00
d1544		db	002h	; 00000010b . 03d04 02
d1545		db	000h	; 00000000b . 03d05 00
d1546		db	000h	; 00000000b . 03d06 00
d1547		db	000h	; 00000000b . 03d07 00
d1548		db	000h	; 00000000b . 03d08 00
d1549		db	000h	; 00000000b . 03d09 00
d154a		db	000h	; 00000000b . 03d0a 00
d154b		db	003h	; 00000011b . 03d0b 03
d154c		db	000h	; 00000000b . 03d0c 00
d154d		db	000h	; 00000000b . 03d0d 00
d154e		db	000h	; 00000000b . 03d0e 00
d154f		db	000h	; 00000000b . 03d0f 00
d1550		db	002h	; 00000010b . 03d10 02
d1551		db	000h	; 00000000b . 03d11 00
d1552		db	000h	; 00000000b . 03d12 00
d1553		db	000h	; 00000000b . 03d13 00
d1554		db	000h	; 00000000b . 03d14 00
d1555		db	000h	; 00000000b . 03d15 00
d1556		db	000h	; 00000000b . 03d16 00
d1557		db	003h	; 00000011b . 03d17 03
d1558		db	000h	; 00000000b . 03d18 00
d1559		db	000h	; 00000000b . 03d19 00
d155a		db	000h	; 00000000b . 03d1a 00
d155b		db	000h	; 00000000b . 03d1b 00
d155c		db	000h	; 00000000b . 03d1c 00
d155d		db	000h	; 00000000b . 03d1d 00
d155e		db	000h	; 00000000b . 03d1e 00
d155f		db	000h	; 00000000b . 03d1f 00
d1560		db	000h	; 00000000b . 03d20 00
d1561		db	000h	; 00000000b . 03d21 00
d1562		db	000h	; 00000000b . 03d22 00
d1563		db	000h	; 00000000b . 03d23 00
d1564		db	000h	; 00000000b . 03d24 00
d1565		db	000h	; 00000000b . 03d25 00
d1566		db	000h	; 00000000b . 03d26 00
d1567		db	000h	; 00000000b . 03d27 00
d1568		db	000h	; 00000000b . 03d28 00
d1569		db	000h	; 00000000b . 03d29 00
d156a		db	002h	; 00000010b . 03d2a 02
d156b		db	003h	; 00000011b . 03d2b 03
d156c		db	000h	; 00000000b . 03d2c 00
d156d		db	000h	; 00000000b . 03d2d 00
d156e		db	000h	; 00000000b . 03d2e 00
d156f		db	000h	; 00000000b . 03d2f 00
d1570		db	000h	; 00000000b . 03d30 00
d1571		db	000h	; 00000000b . 03d31 00
d1572		db	000h	; 00000000b . 03d32 00
d1573		db	000h	; 00000000b . 03d33 00
d1574		db	000h	; 00000000b . 03d34 00
d1575		db	000h	; 00000000b . 03d35 00
d1576		db	002h	; 00000010b . 03d36 02
d1577		db	003h	; 00000011b . 03d37 03
d1578		db	000h	; 00000000b . 03d38 00
d1579		db	000h	; 00000000b . 03d39 00
d157a		db	000h	; 00000000b . 03d3a 00
d157b		db	000h	; 00000000b . 03d3b 00
d157c		db	000h	; 00000000b . 03d3c 00
d157d		db	000h	; 00000000b . 03d3d 00
d157e		db	000h	; 00000000b . 03d3e 00
d157f		db	000h	; 00000000b . 03d3f 00
d1580		db	000h	; 00000000b . 03d40 00
d1581		db	000h	; 00000000b . 03d41 00
d1582		db	002h	; 00000010b . 03d42 02
d1583		db	000h	; 00000000b . 03d43 00
d1584		db	000h	; 00000000b . 03d44 00
d1585		db	000h	; 00000000b . 03d45 00
d1586		db	000h	; 00000000b . 03d46 00
d1587		db	000h	; 00000000b . 03d47 00
d1588		db	000h	; 00000000b . 03d48 00
d1589		db	003h	; 00000011b . 03d49 03
d158a		db	000h	; 00000000b . 03d4a 00
d158b		db	000h	; 00000000b . 03d4b 00
d158c		db	000h	; 00000000b . 03d4c 00
d158d		db	000h	; 00000000b . 03d4d 00
d158e		db	002h	; 00000010b . 03d4e 02
d158f		db	000h	; 00000000b . 03d4f 00
d1590		db	000h	; 00000000b . 03d50 00
d1591		db	000h	; 00000000b . 03d51 00
d1592		db	000h	; 00000000b . 03d52 00
d1593		db	000h	; 00000000b . 03d53 00
d1594		db	000h	; 00000000b . 03d54 00
d1595		db	003h	; 00000011b . 03d55 03
d1596		db	000h	; 00000000b . 03d56 00
d1597		db	000h	; 00000000b . 03d57 00
d1598		db	000h	; 00000000b . 03d58 00
d1599		db	000h	; 00000000b . 03d59 00
d159a		db	000h	; 00000000b . 03d5a 00
d159b		db	000h	; 00000000b . 03d5b 00
d159c		db	000h	; 00000000b . 03d5c 00
d159d		db	000h	; 00000000b . 03d5d 00
d159e		db	000h	; 00000000b . 03d5e 00
d159f		db	000h	; 00000000b . 03d5f 00
d15a0		db	000h	; 00000000b . 03d60 00
d15a1		db	000h	; 00000000b . 03d61 00
d15a2		db	000h	; 00000000b . 03d62 00
d15a3		db	000h	; 00000000b . 03d63 00
d15a4		db	000h	; 00000000b . 03d64 00
d15a5		db	000h	; 00000000b . 03d65 00
d15a6		db	000h	; 00000000b . 03d66 00
d15a7		db	000h	; 00000000b . 03d67 00
d15a8		db	002h	; 00000010b . 03d68 02
d15a9		db	003h	; 00000011b . 03d69 03
d15aa		db	000h	; 00000000b . 03d6a 00
d15ab		db	000h	; 00000000b . 03d6b 00
d15ac		db	000h	; 00000000b . 03d6c 00
d15ad		db	000h	; 00000000b . 03d6d 00
d15ae		db	000h	; 00000000b . 03d6e 00
d15af		db	000h	; 00000000b . 03d6f 00
d15b0		db	000h	; 00000000b . 03d70 00
d15b1		db	000h	; 00000000b . 03d71 00
d15b2		db	000h	; 00000000b . 03d72 00
d15b3		db	000h	; 00000000b . 03d73 00
d15b4		db	002h	; 00000010b . 03d74 02
d15b5		db	003h	; 00000011b . 03d75 03
d15b6		db	000h	; 00000000b . 03d76 00
d15b7		db	000h	; 00000000b . 03d77 00
d15b8		db	000h	; 00000000b . 03d78 00
d15b9		db	000h	; 00000000b . 03d79 00
d15ba		db	000h	; 00000000b . 03d7a 00
d15bb		db	000h	; 00000000b . 03d7b 00
d15bc		db	000h	; 00000000b . 03d7c 00
d15bd		db	000h	; 00000000b . 03d7d 00
d15be		db	000h	; 00000000b . 03d7e 00
d15bf		db	000h	; 00000000b . 03d7f 00
d15c0		db	002h	; 00000010b . 03d80 02
d15c1		db	000h	; 00000000b . 03d81 00
d15c2		db	000h	; 00000000b . 03d82 00
d15c3		db	000h	; 00000000b . 03d83 00
d15c4		db	000h	; 00000000b . 03d84 00
d15c5		db	000h	; 00000000b . 03d85 00
d15c6		db	000h	; 00000000b . 03d86 00
d15c7		db	003h	; 00000011b . 03d87 03
d15c8		db	000h	; 00000000b . 03d88 00
d15c9		db	000h	; 00000000b . 03d89 00
d15ca		db	000h	; 00000000b . 03d8a 00
d15cb		db	000h	; 00000000b . 03d8b 00
d15cc		db	002h	; 00000010b . 03d8c 02
d15cd		db	000h	; 00000000b . 03d8d 00
d15ce		db	000h	; 00000000b . 03d8e 00
d15cf		db	000h	; 00000000b . 03d8f 00
d15d0		db	000h	; 00000000b . 03d90 00
d15d1		db	000h	; 00000000b . 03d91 00
d15d2		db	000h	; 00000000b . 03d92 00
d15d3		db	003h	; 00000011b . 03d93 03
d15d4		db	000h	; 00000000b . 03d94 00
d15d5		db	000h	; 00000000b . 03d95 00
d15d6		db	000h	; 00000000b . 03d96 00
d15d7		db	000h	; 00000000b . 03d97 00
d15d8		db	000h	; 00000000b . 03d98 00
d15d9		db	000h	; 00000000b . 03d99 00
d15da		db	000h	; 00000000b . 03d9a 00
d15db		db	000h	; 00000000b . 03d9b 00
d15dc		db	000h	; 00000000b . 03d9c 00
d15dd		db	000h	; 00000000b . 03d9d 00
d15de		db	000h	; 00000000b . 03d9e 00
d15df		db	000h	; 00000000b . 03d9f 00
d15e0		db	000h	; 00000000b . 03da0 00
d15e1		db	000h	; 00000000b . 03da1 00
d15e2		db	000h	; 00000000b . 03da2 00
d15e3		db	000h	; 00000000b . 03da3 00
d15e4		db	000h	; 00000000b . 03da4 00
d15e5		db	000h	; 00000000b . 03da5 00
d15e6		db	002h	; 00000010b . 03da6 02
d15e7		db	01bh	; 00011011b . 03da7 1b
d15e8		db	017h	; 00010111b . 03da8 17
d15e9		db	004h	; 00000100b . 03da9 04
d15ea		db	004h	; 00000100b . 03daa 04
d15eb		db	004h	; 00000100b . 03dab 04
d15ec		db	004h	; 00000100b . 03dac 04
d15ed		db	004h	; 00000100b . 03dad 04
d15ee		db	004h	; 00000100b . 03dae 04
d15ef		db	004h	; 00000100b . 03daf 04
d15f0		db	004h	; 00000100b . 03db0 04
d15f1		db	018h	; 00011000b . 03db1 18
d15f2		db	01ch	; 00011100b . 03db2 1c
d15f3		db	01bh	; 00011011b . 03db3 1b
d15f4		db	017h	; 00010111b . 03db4 17
d15f5		db	004h	; 00000100b . 03db5 04
d15f6		db	004h	; 00000100b . 03db6 04
d15f7		db	004h	; 00000100b . 03db7 04
d15f8		db	004h	; 00000100b . 03db8 04
d15f9		db	004h	; 00000100b . 03db9 04
d15fa		db	004h	; 00000100b . 03dba 04
d15fb		db	004h	; 00000100b . 03dbb 04
d15fc		db	004h	; 00000100b . 03dbc 04
d15fd		db	018h	; 00011000b . 03dbd 18
d15fe		db	01ch	; 00011100b . 03dbe 1c
d15ff		db	000h	; 00000000b . 03dbf 00
d1600		db	000h	; 00000000b . 03dc0 00
d1601		db	000h	; 00000000b . 03dc1 00
d1602		db	000h	; 00000000b . 03dc2 00
d1603		db	000h	; 00000000b . 03dc3 00
d1604		db	000h	; 00000000b . 03dc4 00
d1605		db	003h	; 00000011b . 03dc5 03
d1606		db	000h	; 00000000b . 03dc6 00
d1607		db	000h	; 00000000b . 03dc7 00
d1608		db	000h	; 00000000b . 03dc8 00
d1609		db	000h	; 00000000b . 03dc9 00
d160a		db	002h	; 00000010b . 03dca 02
d160b		db	000h	; 00000000b . 03dcb 00
d160c		db	000h	; 00000000b . 03dcc 00
d160d		db	000h	; 00000000b . 03dcd 00
d160e		db	000h	; 00000000b . 03dce 00
d160f		db	000h	; 00000000b . 03dcf 00
d1610		db	000h	; 00000000b . 03dd0 00
d1611		db	01bh	; 00011011b . 03dd1 1b
d1612		db	017h	; 00010111b . 03dd2 17
d1613		db	004h	; 00000100b . 03dd3 04
d1614		db	004h	; 00000100b . 03dd4 04
d1615		db	004h	; 00000100b . 03dd5 04
d1616		db	004h	; 00000100b . 03dd6 04
d1617		db	004h	; 00000100b . 03dd7 04
d1618		db	004h	; 00000100b . 03dd8 04
d1619		db	004h	; 00000100b . 03dd9 04
d161a		db	004h	; 00000100b . 03dda 04
d161b		db	004h	; 00000100b . 03ddb 04
d161c		db	004h	; 00000100b . 03ddc 04
d161d		db	004h	; 00000100b . 03ddd 04
d161e		db	004h	; 00000100b . 03dde 04
d161f		db	004h	; 00000100b . 03ddf 04
d1620		db	004h	; 00000100b . 03de0 04
d1621		db	004h	; 00000100b . 03de1 04
d1622		db	004h	; 00000100b . 03de2 04
d1623		db	018h	; 00011000b . 03de3 18
d1624		db	01ch	; 00011100b . 03de4 1c
d1625		db	098h	; 10011000b . 03de5 98
d1626		db	016h	; 00010110b . 03de6 16
d1627		db	0ach	; 10101100b . 03de7 ac
d1628		db	016h	; 00010110b . 03de8 16
d1629		db	04ah	; 01001010b J 03de9 4a
d162a		db	019h	; 00011001b . 03dea 19
d162b		db	05eh	; 01011110b ^ 03deb 5e
d162c		db	019h	; 00011001b . 03dec 19
d162d		db	0bbh	; 10111011b . 03ded bb
d162e		db	000h	; 00000000b . 03dee 00
d162f		db	0e3h	; 11100011b . 03def e3
d1630		db	000h	; 00000000b . 03df0 00
d1631		db	07bh	; 01111011b { 03df1 7b
d1632		db	01dh	; 00011101b . 03df2 1d
d1633		db	0a3h	; 10100011b . 03df3 a3
d1634		db	01dh	; 00011101b . 03df4 1d
d1635		db	000h	; 00000000b . 03df5 00
d1636		db	000h	; 00000000b . 03df6 00
d1637		db	000h	; 00000000b . 03df7 00
d1638		db	000h	; 00000000b . 03df8 00
d1639		db	000h	; 00000000b . 03df9 00
d163a		db	000h	; 00000000b . 03dfa 00
d163b		db	003h	; 00000011b . 03dfb 03
d163c		db	0c0h	; 11000000b . 03dfc c0
d163d		db	003h	; 00000011b . 03dfd 03
d163e		db	0c0h	; 11000000b . 03dfe c0
d163f		db	000h	; 00000000b . 03dff 00
d1640		db	000h	; 00000000b . 03e00 00
d1641		db	000h	; 00000000b . 03e01 00
d1642		db	000h	; 00000000b . 03e02 00
d1643		db	000h	; 00000000b . 03e03 00
d1644		db	000h	; 00000000b . 03e04 00
d1645		db	00fh	; 00001111b . 03e05 0f
d1646		db	0f0h	; 11110000b . 03e06 f0
d1647		db	03fh	; 00111111b ? 03e07 3f
d1648		db	0fch	; 11111100b . 03e08 fc
d1649		db	0ffh	; 11111111b . 03e09 ff
d164a		db	0ffh	; 11111111b . 03e0a ff
d164b		db	0ffh	; 11111111b . 03e0b ff
d164c		db	0ffh	; 11111111b . 03e0c ff
d164d		db	0ffh	; 11111111b . 03e0d ff
d164e		db	0ffh	; 11111111b . 03e0e ff
d164f		db	0ffh	; 11111111b . 03e0f ff
d1650		db	0ffh	; 11111111b . 03e10 ff
d1651		db	03fh	; 00111111b ? 03e11 3f
d1652		db	0fch	; 11111100b . 03e12 fc
d1653		db	00fh	; 00001111b . 03e13 0f
d1654		db	0f0h	; 11110000b . 03e14 f0
d1655		db	000h	; 00000000b . 03e15 00
d1656		db	000h	; 00000000b . 03e16 00
d1657		db	000h	; 00000000b . 03e17 00
d1658		db	000h	; 00000000b . 03e18 00
d1659		db	000h	; 00000000b . 03e19 00
d165a		db	000h	; 00000000b . 03e1a 00
d165b		db	000h	; 00000000b . 03e1b 00
d165c		db	000h	; 00000000b . 03e1c 00
d165d		db	000h	; 00000000b . 03e1d 00
d165e		db	000h	; 00000000b . 03e1e 00
d165f		db	000h	; 00000000b . 03e1f 00
d1660		db	000h	; 00000000b . 03e20 00
d1661		db	000h	; 00000000b . 03e21 00
d1662		db	000h	; 00000000b . 03e22 00
d1663		db	000h	; 00000000b . 03e23 00
d1664		db	000h	; 00000000b . 03e24 00
d1665		db	001h	; 00000001b . 03e25 01
d1666		db	000h	; 00000000b . 03e26 00
d1667		db	000h	; 00000000b . 03e27 00
d1668		db	000h	; 00000000b . 03e28 00
d1669		db	000h	; 00000000b . 03e29 00
d166a		db	000h	; 00000000b . 03e2a 00
d166b		db	000h	; 00000000b . 03e2b 00
d166c		db	000h	; 00000000b . 03e2c 00
d166d		db	000h	; 00000000b . 03e2d 00
d166e		db	000h	; 00000000b . 03e2e 00
d166f		db	000h	; 00000000b . 03e2f 00
d1670		db	000h	; 00000000b . 03e30 00
d1671		db	000h	; 00000000b . 03e31 00
d1672		db	000h	; 00000000b . 03e32 00
d1673		db	000h	; 00000000b . 03e33 00
d1674		db	000h	; 00000000b . 03e34 00
d1675		db	000h	; 00000000b . 03e35 00
d1676		db	000h	; 00000000b . 03e36 00
d1677		db	000h	; 00000000b . 03e37 00
d1678		db	000h	; 00000000b . 03e38 00
d1679		db	000h	; 00000000b . 03e39 00
d167a		db	000h	; 00000000b . 03e3a 00
d167b		db	000h	; 00000000b . 03e3b 00
d167c		db	000h	; 00000000b . 03e3c 00
d167d		db	000h	; 00000000b . 03e3d 00
d167e		db	000h	; 00000000b . 03e3e 00
d167f		db	000h	; 00000000b . 03e3f 00
d1680		db	000h	; 00000000b . 03e40 00
d1681		db	000h	; 00000000b . 03e41 00
d1682		db	000h	; 00000000b . 03e42 00
d1683		db	000h	; 00000000b . 03e43 00
d1684		db	000h	; 00000000b . 03e44 00
d1685		db	000h	; 00000000b . 03e45 00
d1686		db	000h	; 00000000b . 03e46 00
d1687		db	000h	; 00000000b . 03e47 00
d1688		db	000h	; 00000000b . 03e48 00
d1689		db	000h	; 00000000b . 03e49 00
d168a		db	000h	; 00000000b . 03e4a 00
d168b		db	000h	; 00000000b . 03e4b 00
d168c		db	000h	; 00000000b . 03e4c 00
d168d		db	000h	; 00000000b . 03e4d 00
d168e		db	000h	; 00000000b . 03e4e 00
d168f		db	000h	; 00000000b . 03e4f 00
d1690		db	000h	; 00000000b . 03e50 00
d1691		db	000h	; 00000000b . 03e51 00
d1692		db	000h	; 00000000b . 03e52 00
d1693		db	000h	; 00000000b . 03e53 00
d1694		db	000h	; 00000000b . 03e54 00
d1695		db	000h	; 00000000b . 03e55 00
d1696		db	000h	; 00000000b . 03e56 00
d1697		db	000h	; 00000000b . 03e57 00
d1698		db	000h	; 00000000b . 03e58 00
d1699		db	000h	; 00000000b . 03e59 00
d169a		db	000h	; 00000000b . 03e5a 00
d169b		db	000h	; 00000000b . 03e5b 00
d169c		db	000h	; 00000000b . 03e5c 00
d169d		db	000h	; 00000000b . 03e5d 00
d169e		db	000h	; 00000000b . 03e5e 00
d169f		db	000h	; 00000000b . 03e5f 00
d16a0		db	000h	; 00000000b . 03e60 00
d16a1		db	000h	; 00000000b . 03e61 00
d16a2		db	000h	; 00000000b . 03e62 00
d16a3		db	000h	; 00000000b . 03e63 00
d16a4		db	000h	; 00000000b . 03e64 00
d16a5		db	000h	; 00000000b . 03e65 00
d16a6		db	000h	; 00000000b . 03e66 00
d16a7		db	000h	; 00000000b . 03e67 00
d16a8		db	000h	; 00000000b . 03e68 00
d16a9		db	000h	; 00000000b . 03e69 00
d16aa		db	000h	; 00000000b . 03e6a 00
d16ab		db	000h	; 00000000b . 03e6b 00
d16ac		db	000h	; 00000000b . 03e6c 00
d16ad		db	000h	; 00000000b . 03e6d 00
d16ae		db	000h	; 00000000b . 03e6e 00
d16af		db	000h	; 00000000b . 03e6f 00
d16b0		db	000h	; 00000000b . 03e70 00
d16b1		db	000h	; 00000000b . 03e71 00
d16b2		db	000h	; 00000000b . 03e72 00
d16b3		db	000h	; 00000000b . 03e73 00
d16b4		db	000h	; 00000000b . 03e74 00
d16b5		db	000h	; 00000000b . 03e75 00
d16b6		db	000h	; 00000000b . 03e76 00
d16b7		db	000h	; 00000000b . 03e77 00
d16b8		db	000h	; 00000000b . 03e78 00
d16b9		db	000h	; 00000000b . 03e79 00
d16ba		db	000h	; 00000000b . 03e7a 00
d16bb		db	000h	; 00000000b . 03e7b 00
d16bc		db	000h	; 00000000b . 03e7c 00
d16bd		db	000h	; 00000000b . 03e7d 00
d16be		db	000h	; 00000000b . 03e7e 00
d16bf		db	000h	; 00000000b . 03e7f 00
d16c0		db	000h	; 00000000b . 03e80 00
d16c1		db	000h	; 00000000b . 03e81 00
d16c2		db	000h	; 00000000b . 03e82 00
d16c3		db	000h	; 00000000b . 03e83 00
d16c4		db	000h	; 00000000b . 03e84 00
d16c5		db	000h	; 00000000b . 03e85 00
d16c6		db	000h	; 00000000b . 03e86 00
d16c7		db	000h	; 00000000b . 03e87 00
d16c8		db	000h	; 00000000b . 03e88 00
d16c9		db	000h	; 00000000b . 03e89 00
d16ca		db	000h	; 00000000b . 03e8a 00
d16cb		db	000h	; 00000000b . 03e8b 00
d16cc		db	000h	; 00000000b . 03e8c 00
d16cd		db	000h	; 00000000b . 03e8d 00
d16ce		db	000h	; 00000000b . 03e8e 00
d16cf		db	000h	; 00000000b . 03e8f 00
d16d0		db	000h	; 00000000b . 03e90 00
d16d1		db	000h	; 00000000b . 03e91 00
d16d2		db	000h	; 00000000b . 03e92 00
d16d3		db	000h	; 00000000b . 03e93 00
d16d4		db	000h	; 00000000b . 03e94 00
d16d5		db	000h	; 00000000b . 03e95 00
d16d6		db	000h	; 00000000b . 03e96 00
d16d7		db	000h	; 00000000b . 03e97 00
d16d8		db	000h	; 00000000b . 03e98 00
d16d9		db	000h	; 00000000b . 03e99 00
d16da		db	000h	; 00000000b . 03e9a 00
d16db		db	000h	; 00000000b . 03e9b 00
d16dc		db	000h	; 00000000b . 03e9c 00
d16dd		db	000h	; 00000000b . 03e9d 00
d16de		db	000h	; 00000000b . 03e9e 00
d16df		db	000h	; 00000000b . 03e9f 00
d16e0		db	000h	; 00000000b . 03ea0 00
d16e1		db	000h	; 00000000b . 03ea1 00
d16e2		db	000h	; 00000000b . 03ea2 00
d16e3		db	000h	; 00000000b . 03ea3 00
d16e4		db	000h	; 00000000b . 03ea4 00
d16e5		db	000h	; 00000000b . 03ea5 00
d16e6		db	000h	; 00000000b . 03ea6 00
d16e7		db	000h	; 00000000b . 03ea7 00
d16e8		db	000h	; 00000000b . 03ea8 00
d16e9		db	000h	; 00000000b . 03ea9 00
d16ea		db	000h	; 00000000b . 03eaa 00
d16eb		db	000h	; 00000000b . 03eab 00
d16ec		db	000h	; 00000000b . 03eac 00
d16ed		db	000h	; 00000000b . 03ead 00
d16ee		db	000h	; 00000000b . 03eae 00
d16ef		db	000h	; 00000000b . 03eaf 00
d16f0		db	000h	; 00000000b . 03eb0 00
d16f1		db	000h	; 00000000b . 03eb1 00
d16f2		db	000h	; 00000000b . 03eb2 00
d16f3		db	000h	; 00000000b . 03eb3 00
d16f4		db	000h	; 00000000b . 03eb4 00
d16f5		db	000h	; 00000000b . 03eb5 00
d16f6		db	000h	; 00000000b . 03eb6 00
d16f7		db	000h	; 00000000b . 03eb7 00
d16f8		db	000h	; 00000000b . 03eb8 00
d16f9		db	000h	; 00000000b . 03eb9 00
d16fa		db	000h	; 00000000b . 03eba 00
d16fb		db	000h	; 00000000b . 03ebb 00
d16fc		db	000h	; 00000000b . 03ebc 00
d16fd		db	000h	; 00000000b . 03ebd 00
d16fe		db	000h	; 00000000b . 03ebe 00
d16ff		db	000h	; 00000000b . 03ebf 00
d1700		db	000h	; 00000000b . 03ec0 00
d1701		db	000h	; 00000000b . 03ec1 00
d1702		db	000h	; 00000000b . 03ec2 00
d1703		db	000h	; 00000000b . 03ec3 00
d1704		db	000h	; 00000000b . 03ec4 00
d1705		db	000h	; 00000000b . 03ec5 00
d1706		db	000h	; 00000000b . 03ec6 00
d1707		db	000h	; 00000000b . 03ec7 00
d1708		db	000h	; 00000000b . 03ec8 00
d1709		db	000h	; 00000000b . 03ec9 00
d170a		db	000h	; 00000000b . 03eca 00
d170b		db	000h	; 00000000b . 03ecb 00
d170c		db	000h	; 00000000b . 03ecc 00
d170d		db	000h	; 00000000b . 03ecd 00
d170e		db	000h	; 00000000b . 03ece 00
d170f		db	000h	; 00000000b . 03ecf 00
d1710		db	000h	; 00000000b . 03ed0 00
d1711		db	000h	; 00000000b . 03ed1 00
d1712		db	000h	; 00000000b . 03ed2 00
d1713		db	000h	; 00000000b . 03ed3 00
d1714		db	000h	; 00000000b . 03ed4 00
d1715		db	000h	; 00000000b . 03ed5 00
d1716		db	000h	; 00000000b . 03ed6 00
d1717		db	000h	; 00000000b . 03ed7 00
d1718		db	000h	; 00000000b . 03ed8 00
d1719		db	000h	; 00000000b . 03ed9 00
d171a		db	000h	; 00000000b . 03eda 00
d171b		db	000h	; 00000000b . 03edb 00
d171c		db	000h	; 00000000b . 03edc 00
d171d		db	000h	; 00000000b . 03edd 00
d171e		db	000h	; 00000000b . 03ede 00
d171f		db	000h	; 00000000b . 03edf 00
d1720		db	000h	; 00000000b . 03ee0 00
d1721		db	000h	; 00000000b . 03ee1 00
d1722		db	000h	; 00000000b . 03ee2 00
d1723		db	000h	; 00000000b . 03ee3 00
d1724		db	000h	; 00000000b . 03ee4 00
d1725		db	000h	; 00000000b . 03ee5 00
d1726		db	000h	; 00000000b . 03ee6 00
d1727		db	000h	; 00000000b . 03ee7 00
d1728		db	000h	; 00000000b . 03ee8 00
d1729		db	000h	; 00000000b . 03ee9 00
d172a		db	000h	; 00000000b . 03eea 00
d172b		db	000h	; 00000000b . 03eeb 00
d172c		db	000h	; 00000000b . 03eec 00
d172d		db	000h	; 00000000b . 03eed 00
d172e		db	000h	; 00000000b . 03eee 00
d172f		db	000h	; 00000000b . 03eef 00
d1730		db	000h	; 00000000b . 03ef0 00
d1731		db	000h	; 00000000b . 03ef1 00
d1732		db	000h	; 00000000b . 03ef2 00
d1733		db	000h	; 00000000b . 03ef3 00
d1734		db	000h	; 00000000b . 03ef4 00
d1735		db	000h	; 00000000b . 03ef5 00
d1736		db	000h	; 00000000b . 03ef6 00
d1737		db	000h	; 00000000b . 03ef7 00
d1738		db	000h	; 00000000b . 03ef8 00
d1739		db	000h	; 00000000b . 03ef9 00
d173a		db	000h	; 00000000b . 03efa 00
d173b		db	000h	; 00000000b . 03efb 00
d173c		db	000h	; 00000000b . 03efc 00
d173d		db	000h	; 00000000b . 03efd 00
d173e		db	000h	; 00000000b . 03efe 00
d173f		db	000h	; 00000000b . 03eff 00
d1740		db	000h	; 00000000b . 03f00 00
d1741		db	000h	; 00000000b . 03f01 00
d1742		db	000h	; 00000000b . 03f02 00
d1743		db	000h	; 00000000b . 03f03 00
d1744		db	000h	; 00000000b . 03f04 00
d1745		db	000h	; 00000000b . 03f05 00
d1746		db	000h	; 00000000b . 03f06 00
d1747		db	000h	; 00000000b . 03f07 00
d1748		db	000h	; 00000000b . 03f08 00
d1749		db	000h	; 00000000b . 03f09 00
d174a		db	000h	; 00000000b . 03f0a 00
d174b		db	000h	; 00000000b . 03f0b 00
d174c		db	000h	; 00000000b . 03f0c 00
d174d		db	000h	; 00000000b . 03f0d 00
d174e		db	000h	; 00000000b . 03f0e 00
d174f		db	000h	; 00000000b . 03f0f 00
d1750		db	000h	; 00000000b . 03f10 00
d1751		db	000h	; 00000000b . 03f11 00
d1752		db	000h	; 00000000b . 03f12 00
d1753		db	000h	; 00000000b . 03f13 00
d1754		db	000h	; 00000000b . 03f14 00
d1755		db	000h	; 00000000b . 03f15 00
d1756		db	000h	; 00000000b . 03f16 00
d1757		db	000h	; 00000000b . 03f17 00
d1758		db	000h	; 00000000b . 03f18 00
d1759		db	000h	; 00000000b . 03f19 00
d175a		db	000h	; 00000000b . 03f1a 00
d175b		db	000h	; 00000000b . 03f1b 00
d175c		db	000h	; 00000000b . 03f1c 00
d175d		db	000h	; 00000000b . 03f1d 00
d175e		db	000h	; 00000000b . 03f1e 00
d175f		db	000h	; 00000000b . 03f1f 00
d1760		db	000h	; 00000000b . 03f20 00
d1761		db	000h	; 00000000b . 03f21 00
d1762		db	000h	; 00000000b . 03f22 00
d1763		db	000h	; 00000000b . 03f23 00
d1764		db	000h	; 00000000b . 03f24 00
d1765		db	000h	; 00000000b . 03f25 00
d1766		db	000h	; 00000000b . 03f26 00
d1767		db	000h	; 00000000b . 03f27 00
d1768		db	000h	; 00000000b . 03f28 00
d1769		db	000h	; 00000000b . 03f29 00
d176a		db	000h	; 00000000b . 03f2a 00
d176b		db	000h	; 00000000b . 03f2b 00
d176c		db	000h	; 00000000b . 03f2c 00
d176d		db	000h	; 00000000b . 03f2d 00
d176e		db	000h	; 00000000b . 03f2e 00
d176f		db	000h	; 00000000b . 03f2f 00
d1770		db	000h	; 00000000b . 03f30 00
d1771		db	000h	; 00000000b . 03f31 00
d1772		db	000h	; 00000000b . 03f32 00
d1773		db	000h	; 00000000b . 03f33 00
d1774		db	000h	; 00000000b . 03f34 00
d1775		db	000h	; 00000000b . 03f35 00
d1776		db	000h	; 00000000b . 03f36 00
d1777		db	000h	; 00000000b . 03f37 00
d1778		db	000h	; 00000000b . 03f38 00
d1779		db	000h	; 00000000b . 03f39 00
d177a		db	000h	; 00000000b . 03f3a 00
d177b		db	000h	; 00000000b . 03f3b 00
d177c		db	000h	; 00000000b . 03f3c 00
d177d		db	000h	; 00000000b . 03f3d 00
d177e		db	000h	; 00000000b . 03f3e 00
d177f		db	000h	; 00000000b . 03f3f 00
d1780		db	000h	; 00000000b . 03f40 00
d1781		db	000h	; 00000000b . 03f41 00
d1782		db	000h	; 00000000b . 03f42 00
d1783		db	000h	; 00000000b . 03f43 00
d1784		db	000h	; 00000000b . 03f44 00
d1785		db	000h	; 00000000b . 03f45 00
d1786		db	000h	; 00000000b . 03f46 00
d1787		db	000h	; 00000000b . 03f47 00
d1788		db	000h	; 00000000b . 03f48 00
d1789		db	000h	; 00000000b . 03f49 00
d178a		db	000h	; 00000000b . 03f4a 00
d178b		db	000h	; 00000000b . 03f4b 00
d178c		db	000h	; 00000000b . 03f4c 00
d178d		db	000h	; 00000000b . 03f4d 00
d178e		db	000h	; 00000000b . 03f4e 00
d178f		db	000h	; 00000000b . 03f4f 00
d1790		db	000h	; 00000000b . 03f50 00
d1791		db	000h	; 00000000b . 03f51 00
d1792		db	000h	; 00000000b . 03f52 00
d1793		db	000h	; 00000000b . 03f53 00
d1794		db	000h	; 00000000b . 03f54 00
d1795		db	000h	; 00000000b . 03f55 00
d1796		db	000h	; 00000000b . 03f56 00
d1797		db	000h	; 00000000b . 03f57 00
d1798		db	000h	; 00000000b . 03f58 00
d1799		db	000h	; 00000000b . 03f59 00
d179a		db	000h	; 00000000b . 03f5a 00
d179b		db	000h	; 00000000b . 03f5b 00
d179c		db	000h	; 00000000b . 03f5c 00
d179d		db	000h	; 00000000b . 03f5d 00
d179e		db	000h	; 00000000b . 03f5e 00
d179f		db	000h	; 00000000b . 03f5f 00
d17a0		db	000h	; 00000000b . 03f60 00
d17a1		db	000h	; 00000000b . 03f61 00
d17a2		db	000h	; 00000000b . 03f62 00
d17a3		db	000h	; 00000000b . 03f63 00
d17a4		db	000h	; 00000000b . 03f64 00
d17a5		db	000h	; 00000000b . 03f65 00
d17a6		db	000h	; 00000000b . 03f66 00
d17a7		db	000h	; 00000000b . 03f67 00
d17a8		db	000h	; 00000000b . 03f68 00
d17a9		db	000h	; 00000000b . 03f69 00
d17aa		db	000h	; 00000000b . 03f6a 00
d17ab		db	000h	; 00000000b . 03f6b 00
d17ac		db	000h	; 00000000b . 03f6c 00
d17ad		db	000h	; 00000000b . 03f6d 00
d17ae		db	000h	; 00000000b . 03f6e 00
d17af		db	000h	; 00000000b . 03f6f 00
d17b0		db	000h	; 00000000b . 03f70 00
d17b1		db	000h	; 00000000b . 03f71 00
d17b2		db	000h	; 00000000b . 03f72 00
d17b3		db	000h	; 00000000b . 03f73 00
d17b4		db	000h	; 00000000b . 03f74 00
d17b5		db	000h	; 00000000b . 03f75 00
d17b6		db	000h	; 00000000b . 03f76 00
d17b7		db	000h	; 00000000b . 03f77 00
d17b8		db	000h	; 00000000b . 03f78 00
d17b9		db	000h	; 00000000b . 03f79 00
d17ba		db	000h	; 00000000b . 03f7a 00
d17bb		db	000h	; 00000000b . 03f7b 00
d17bc		db	000h	; 00000000b . 03f7c 00
d17bd		db	000h	; 00000000b . 03f7d 00
d17be		db	000h	; 00000000b . 03f7e 00
d17bf		db	000h	; 00000000b . 03f7f 00
d17c0		db	000h	; 00000000b . 03f80 00
d17c1		db	000h	; 00000000b . 03f81 00
d17c2		db	000h	; 00000000b . 03f82 00
d17c3		db	000h	; 00000000b . 03f83 00
d17c4		db	000h	; 00000000b . 03f84 00
d17c5		db	000h	; 00000000b . 03f85 00
d17c6		db	000h	; 00000000b . 03f86 00
d17c7		db	000h	; 00000000b . 03f87 00
d17c8		db	000h	; 00000000b . 03f88 00
d17c9		db	000h	; 00000000b . 03f89 00
d17ca		db	000h	; 00000000b . 03f8a 00
d17cb		db	000h	; 00000000b . 03f8b 00
d17cc		db	000h	; 00000000b . 03f8c 00
d17cd		db	000h	; 00000000b . 03f8d 00
d17ce		db	000h	; 00000000b . 03f8e 00
d17cf		db	000h	; 00000000b . 03f8f 00
d17d0		db	000h	; 00000000b . 03f90 00
d17d1		db	000h	; 00000000b . 03f91 00
d17d2		db	000h	; 00000000b . 03f92 00
d17d3		db	000h	; 00000000b . 03f93 00
d17d4		db	000h	; 00000000b . 03f94 00
d17d5		db	000h	; 00000000b . 03f95 00
d17d6		db	000h	; 00000000b . 03f96 00
d17d7		db	000h	; 00000000b . 03f97 00
d17d8		db	000h	; 00000000b . 03f98 00
d17d9		db	000h	; 00000000b . 03f99 00
d17da		db	000h	; 00000000b . 03f9a 00
d17db		db	000h	; 00000000b . 03f9b 00
d17dc		db	000h	; 00000000b . 03f9c 00
d17dd		db	000h	; 00000000b . 03f9d 00
d17de		db	000h	; 00000000b . 03f9e 00
d17df		db	000h	; 00000000b . 03f9f 00
d17e0		db	000h	; 00000000b . 03fa0 00
d17e1		db	000h	; 00000000b . 03fa1 00
d17e2		db	000h	; 00000000b . 03fa2 00
d17e3		db	000h	; 00000000b . 03fa3 00
d17e4		db	000h	; 00000000b . 03fa4 00
d17e5		db	000h	; 00000000b . 03fa5 00
d17e6		db	000h	; 00000000b . 03fa6 00
d17e7		db	000h	; 00000000b . 03fa7 00
d17e8		db	000h	; 00000000b . 03fa8 00
d17e9		db	000h	; 00000000b . 03fa9 00
d17ea		db	000h	; 00000000b . 03faa 00
d17eb		db	000h	; 00000000b . 03fab 00
d17ec		db	000h	; 00000000b . 03fac 00
d17ed		db	000h	; 00000000b . 03fad 00
d17ee		db	000h	; 00000000b . 03fae 00
d17ef		db	000h	; 00000000b . 03faf 00
d17f0		db	000h	; 00000000b . 03fb0 00
d17f1		db	000h	; 00000000b . 03fb1 00
d17f2		db	000h	; 00000000b . 03fb2 00
d17f3		db	000h	; 00000000b . 03fb3 00
d17f4		db	000h	; 00000000b . 03fb4 00
d17f5		db	000h	; 00000000b . 03fb5 00
d17f6		db	000h	; 00000000b . 03fb6 00
d17f7		db	000h	; 00000000b . 03fb7 00
d17f8		db	000h	; 00000000b . 03fb8 00
d17f9		db	000h	; 00000000b . 03fb9 00
d17fa		db	000h	; 00000000b . 03fba 00
d17fb		db	000h	; 00000000b . 03fbb 00
d17fc		db	000h	; 00000000b . 03fbc 00
d17fd		db	000h	; 00000000b . 03fbd 00
d17fe		db	000h	; 00000000b . 03fbe 00
d17ff		db	000h	; 00000000b . 03fbf 00
d1800		db	000h	; 00000000b . 03fc0 00
d1801		db	000h	; 00000000b . 03fc1 00
d1802		db	000h	; 00000000b . 03fc2 00
d1803		db	000h	; 00000000b . 03fc3 00
d1804		db	000h	; 00000000b . 03fc4 00
d1805		db	000h	; 00000000b . 03fc5 00
d1806		db	000h	; 00000000b . 03fc6 00
d1807		db	000h	; 00000000b . 03fc7 00
d1808		db	000h	; 00000000b . 03fc8 00
d1809		db	000h	; 00000000b . 03fc9 00
d180a		db	000h	; 00000000b . 03fca 00
d180b		db	000h	; 00000000b . 03fcb 00
d180c		db	000h	; 00000000b . 03fcc 00
d180d		db	000h	; 00000000b . 03fcd 00
d180e		db	000h	; 00000000b . 03fce 00
d180f		db	000h	; 00000000b . 03fcf 00
d1810		db	000h	; 00000000b . 03fd0 00
d1811		db	000h	; 00000000b . 03fd1 00
d1812		db	000h	; 00000000b . 03fd2 00
d1813		db	000h	; 00000000b . 03fd3 00
d1814		db	000h	; 00000000b . 03fd4 00
d1815		db	000h	; 00000000b . 03fd5 00
d1816		db	000h	; 00000000b . 03fd6 00
d1817		db	000h	; 00000000b . 03fd7 00
d1818		db	000h	; 00000000b . 03fd8 00
d1819		db	000h	; 00000000b . 03fd9 00
d181a		db	000h	; 00000000b . 03fda 00
d181b		db	000h	; 00000000b . 03fdb 00
d181c		db	000h	; 00000000b . 03fdc 00
d181d		db	000h	; 00000000b . 03fdd 00
d181e		db	000h	; 00000000b . 03fde 00
d181f		db	000h	; 00000000b . 03fdf 00
d1820		db	000h	; 00000000b . 03fe0 00
d1821		db	000h	; 00000000b . 03fe1 00
d1822		db	000h	; 00000000b . 03fe2 00
d1823		db	000h	; 00000000b . 03fe3 00
d1824		db	000h	; 00000000b . 03fe4 00
d1825		db	000h	; 00000000b . 03fe5 00
d1826		db	000h	; 00000000b . 03fe6 00
d1827		db	000h	; 00000000b . 03fe7 00
d1828		db	000h	; 00000000b . 03fe8 00
d1829		db	000h	; 00000000b . 03fe9 00
d182a		db	000h	; 00000000b . 03fea 00
d182b		db	000h	; 00000000b . 03feb 00
d182c		db	000h	; 00000000b . 03fec 00
d182d		db	000h	; 00000000b . 03fed 00
d182e		db	000h	; 00000000b . 03fee 00
d182f		db	000h	; 00000000b . 03fef 00
d1830		db	000h	; 00000000b . 03ff0 00
d1831		db	000h	; 00000000b . 03ff1 00
d1832		db	000h	; 00000000b . 03ff2 00
d1833		db	000h	; 00000000b . 03ff3 00
d1834		db	000h	; 00000000b . 03ff4 00
d1835		db	000h	; 00000000b . 03ff5 00
d1836		db	000h	; 00000000b . 03ff6 00
d1837		db	000h	; 00000000b . 03ff7 00
d1838		db	000h	; 00000000b . 03ff8 00
d1839		db	000h	; 00000000b . 03ff9 00
d183a		db	000h	; 00000000b . 03ffa 00
d183b		db	000h	; 00000000b . 03ffb 00
d183c		db	000h	; 00000000b . 03ffc 00
d183d		db	000h	; 00000000b . 03ffd 00
d183e		db	000h	; 00000000b . 03ffe 00
d183f		db	000h	; 00000000b . 03fff 00
d1840		db	000h	; 00000000b . 04000 00
d1841		db	000h	; 00000000b . 04001 00
d1842		db	000h	; 00000000b . 04002 00
d1843		db	000h	; 00000000b . 04003 00
d1844		db	000h	; 00000000b . 04004 00
d1845		db	000h	; 00000000b . 04005 00
d1846		db	000h	; 00000000b . 04006 00
d1847		db	000h	; 00000000b . 04007 00
d1848		db	000h	; 00000000b . 04008 00
d1849		db	000h	; 00000000b . 04009 00
d184a		db	000h	; 00000000b . 0400a 00
d184b		db	000h	; 00000000b . 0400b 00
d184c		db	000h	; 00000000b . 0400c 00
d184d		db	000h	; 00000000b . 0400d 00
d184e		db	000h	; 00000000b . 0400e 00
d184f		db	000h	; 00000000b . 0400f 00
d1850		db	000h	; 00000000b . 04010 00
d1851		db	000h	; 00000000b . 04011 00
d1852		db	000h	; 00000000b . 04012 00
d1853		db	000h	; 00000000b . 04013 00
d1854		db	000h	; 00000000b . 04014 00
d1855		db	000h	; 00000000b . 04015 00
d1856		db	000h	; 00000000b . 04016 00
d1857		db	000h	; 00000000b . 04017 00
d1858		db	000h	; 00000000b . 04018 00
d1859		db	000h	; 00000000b . 04019 00
d185a		db	000h	; 00000000b . 0401a 00
d185b		db	000h	; 00000000b . 0401b 00
d185c		db	000h	; 00000000b . 0401c 00
d185d		db	000h	; 00000000b . 0401d 00
d185e		db	000h	; 00000000b . 0401e 00
d185f		db	000h	; 00000000b . 0401f 00
d1860		db	000h	; 00000000b . 04020 00
d1861		db	000h	; 00000000b . 04021 00
d1862		db	000h	; 00000000b . 04022 00
d1863		db	000h	; 00000000b . 04023 00
d1864		db	000h	; 00000000b . 04024 00
d1865		db	000h	; 00000000b . 04025 00
d1866		db	000h	; 00000000b . 04026 00
d1867		db	000h	; 00000000b . 04027 00
d1868		db	000h	; 00000000b . 04028 00
d1869		db	000h	; 00000000b . 04029 00
d186a		db	000h	; 00000000b . 0402a 00
d186b		db	000h	; 00000000b . 0402b 00
d186c		db	000h	; 00000000b . 0402c 00
d186d		db	000h	; 00000000b . 0402d 00
d186e		db	000h	; 00000000b . 0402e 00
d186f		db	000h	; 00000000b . 0402f 00
d1870		db	000h	; 00000000b . 04030 00
d1871		db	000h	; 00000000b . 04031 00
d1872		db	000h	; 00000000b . 04032 00
d1873		db	000h	; 00000000b . 04033 00
d1874		db	000h	; 00000000b . 04034 00
d1875		db	000h	; 00000000b . 04035 00
d1876		db	000h	; 00000000b . 04036 00
d1877		db	000h	; 00000000b . 04037 00
d1878		db	000h	; 00000000b . 04038 00
d1879		db	000h	; 00000000b . 04039 00
d187a		db	000h	; 00000000b . 0403a 00
d187b		db	000h	; 00000000b . 0403b 00
d187c		db	000h	; 00000000b . 0403c 00
d187d		db	000h	; 00000000b . 0403d 00
d187e		db	000h	; 00000000b . 0403e 00
d187f		db	000h	; 00000000b . 0403f 00
d1880		db	000h	; 00000000b . 04040 00
d1881		db	000h	; 00000000b . 04041 00
d1882		db	000h	; 00000000b . 04042 00
d1883		db	000h	; 00000000b . 04043 00
d1884		db	000h	; 00000000b . 04044 00
d1885		db	000h	; 00000000b . 04045 00
d1886		db	000h	; 00000000b . 04046 00
d1887		db	000h	; 00000000b . 04047 00
d1888		db	000h	; 00000000b . 04048 00
d1889		db	000h	; 00000000b . 04049 00
d188a		db	000h	; 00000000b . 0404a 00
d188b		db	000h	; 00000000b . 0404b 00
d188c		db	000h	; 00000000b . 0404c 00
d188d		db	000h	; 00000000b . 0404d 00
d188e		db	000h	; 00000000b . 0404e 00
d188f		db	000h	; 00000000b . 0404f 00
d1890		db	000h	; 00000000b . 04050 00
d1891		db	000h	; 00000000b . 04051 00
d1892		db	000h	; 00000000b . 04052 00
d1893		db	000h	; 00000000b . 04053 00
d1894		db	000h	; 00000000b . 04054 00
d1895		db	000h	; 00000000b . 04055 00
d1896		db	000h	; 00000000b . 04056 00
d1897		db	000h	; 00000000b . 04057 00
d1898		db	000h	; 00000000b . 04058 00
d1899		db	000h	; 00000000b . 04059 00
d189a		db	000h	; 00000000b . 0405a 00
d189b		db	000h	; 00000000b . 0405b 00
d189c		db	000h	; 00000000b . 0405c 00
d189d		db	000h	; 00000000b . 0405d 00
d189e		db	000h	; 00000000b . 0405e 00
d189f		db	000h	; 00000000b . 0405f 00
d18a0		db	000h	; 00000000b . 04060 00
d18a1		db	000h	; 00000000b . 04061 00
d18a2		db	000h	; 00000000b . 04062 00
d18a3		db	000h	; 00000000b . 04063 00
d18a4		db	000h	; 00000000b . 04064 00
d18a5		db	000h	; 00000000b . 04065 00
d18a6		db	000h	; 00000000b . 04066 00
d18a7		db	000h	; 00000000b . 04067 00
d18a8		db	000h	; 00000000b . 04068 00
d18a9		db	000h	; 00000000b . 04069 00
d18aa		db	000h	; 00000000b . 0406a 00
d18ab		db	000h	; 00000000b . 0406b 00
d18ac		db	000h	; 00000000b . 0406c 00
d18ad		db	000h	; 00000000b . 0406d 00
d18ae		db	000h	; 00000000b . 0406e 00
d18af		db	000h	; 00000000b . 0406f 00
d18b0		db	000h	; 00000000b . 04070 00
d18b1		db	000h	; 00000000b . 04071 00
d18b2		db	000h	; 00000000b . 04072 00
d18b3		db	000h	; 00000000b . 04073 00
d18b4		db	000h	; 00000000b . 04074 00
d18b5		db	000h	; 00000000b . 04075 00
d18b6		db	000h	; 00000000b . 04076 00
d18b7		db	000h	; 00000000b . 04077 00
d18b8		db	000h	; 00000000b . 04078 00
d18b9		db	000h	; 00000000b . 04079 00
d18ba		db	000h	; 00000000b . 0407a 00
d18bb		db	000h	; 00000000b . 0407b 00
d18bc		db	000h	; 00000000b . 0407c 00
d18bd		db	000h	; 00000000b . 0407d 00
d18be		db	000h	; 00000000b . 0407e 00
d18bf		db	000h	; 00000000b . 0407f 00
d18c0		db	000h	; 00000000b . 04080 00
d18c1		db	000h	; 00000000b . 04081 00
d18c2		db	000h	; 00000000b . 04082 00
d18c3		db	000h	; 00000000b . 04083 00
d18c4		db	000h	; 00000000b . 04084 00
d18c5		db	000h	; 00000000b . 04085 00
d18c6		db	000h	; 00000000b . 04086 00
d18c7		db	000h	; 00000000b . 04087 00
d18c8		db	000h	; 00000000b . 04088 00
d18c9		db	000h	; 00000000b . 04089 00
d18ca		db	000h	; 00000000b . 0408a 00
d18cb		db	000h	; 00000000b . 0408b 00
d18cc		db	000h	; 00000000b . 0408c 00
d18cd		db	000h	; 00000000b . 0408d 00
d18ce		db	000h	; 00000000b . 0408e 00
d18cf		db	000h	; 00000000b . 0408f 00
d18d0		db	000h	; 00000000b . 04090 00
d18d1		db	000h	; 00000000b . 04091 00
d18d2		db	000h	; 00000000b . 04092 00
d18d3		db	000h	; 00000000b . 04093 00
d18d4		db	000h	; 00000000b . 04094 00
d18d5		db	000h	; 00000000b . 04095 00
d18d6		db	000h	; 00000000b . 04096 00
d18d7		db	000h	; 00000000b . 04097 00
d18d8		db	000h	; 00000000b . 04098 00
d18d9		db	000h	; 00000000b . 04099 00
d18da		db	000h	; 00000000b . 0409a 00
d18db		db	000h	; 00000000b . 0409b 00
d18dc		db	000h	; 00000000b . 0409c 00
d18dd		db	000h	; 00000000b . 0409d 00
d18de		db	000h	; 00000000b . 0409e 00
d18df		db	000h	; 00000000b . 0409f 00
d18e0		db	000h	; 00000000b . 040a0 00
d18e1		db	000h	; 00000000b . 040a1 00
d18e2		db	000h	; 00000000b . 040a2 00
d18e3		db	000h	; 00000000b . 040a3 00
d18e4		db	000h	; 00000000b . 040a4 00
d18e5		db	000h	; 00000000b . 040a5 00
d18e6		db	000h	; 00000000b . 040a6 00
d18e7		db	000h	; 00000000b . 040a7 00
d18e8		db	000h	; 00000000b . 040a8 00
d18e9		db	000h	; 00000000b . 040a9 00
d18ea		db	000h	; 00000000b . 040aa 00
d18eb		db	000h	; 00000000b . 040ab 00
d18ec		db	000h	; 00000000b . 040ac 00
d18ed		db	000h	; 00000000b . 040ad 00
d18ee		db	000h	; 00000000b . 040ae 00
d18ef		db	000h	; 00000000b . 040af 00
d18f0		db	000h	; 00000000b . 040b0 00
d18f1		db	000h	; 00000000b . 040b1 00
d18f2		db	000h	; 00000000b . 040b2 00
d18f3		db	000h	; 00000000b . 040b3 00
d18f4		db	000h	; 00000000b . 040b4 00
d18f5		db	000h	; 00000000b . 040b5 00
d18f6		db	000h	; 00000000b . 040b6 00
d18f7		db	000h	; 00000000b . 040b7 00
d18f8		db	000h	; 00000000b . 040b8 00
d18f9		db	000h	; 00000000b . 040b9 00
d18fa		db	000h	; 00000000b . 040ba 00
d18fb		db	000h	; 00000000b . 040bb 00
d18fc		db	000h	; 00000000b . 040bc 00
d18fd		db	000h	; 00000000b . 040bd 00
d18fe		db	000h	; 00000000b . 040be 00
d18ff		db	000h	; 00000000b . 040bf 00
d1900		db	000h	; 00000000b . 040c0 00
d1901		db	000h	; 00000000b . 040c1 00
d1902		db	000h	; 00000000b . 040c2 00
d1903		db	000h	; 00000000b . 040c3 00
d1904		db	000h	; 00000000b . 040c4 00
d1905		db	000h	; 00000000b . 040c5 00
d1906		db	000h	; 00000000b . 040c6 00
d1907		db	000h	; 00000000b . 040c7 00
d1908		db	000h	; 00000000b . 040c8 00
d1909		db	000h	; 00000000b . 040c9 00
d190a		db	000h	; 00000000b . 040ca 00
d190b		db	000h	; 00000000b . 040cb 00
d190c		db	000h	; 00000000b . 040cc 00
d190d		db	000h	; 00000000b . 040cd 00
d190e		db	000h	; 00000000b . 040ce 00
d190f		db	000h	; 00000000b . 040cf 00
d1910		db	000h	; 00000000b . 040d0 00
d1911		db	000h	; 00000000b . 040d1 00
d1912		db	000h	; 00000000b . 040d2 00
d1913		db	000h	; 00000000b . 040d3 00
d1914		db	000h	; 00000000b . 040d4 00
d1915		db	000h	; 00000000b . 040d5 00
d1916		db	000h	; 00000000b . 040d6 00
d1917		db	000h	; 00000000b . 040d7 00
d1918		db	000h	; 00000000b . 040d8 00
d1919		db	000h	; 00000000b . 040d9 00
d191a		db	000h	; 00000000b . 040da 00
d191b		db	000h	; 00000000b . 040db 00
d191c		db	000h	; 00000000b . 040dc 00
d191d		db	000h	; 00000000b . 040dd 00
d191e		db	000h	; 00000000b . 040de 00
d191f		db	000h	; 00000000b . 040df 00
d1920		db	000h	; 00000000b . 040e0 00
d1921		db	000h	; 00000000b . 040e1 00
d1922		db	000h	; 00000000b . 040e2 00
d1923		db	000h	; 00000000b . 040e3 00
d1924		db	000h	; 00000000b . 040e4 00
d1925		db	000h	; 00000000b . 040e5 00
d1926		db	000h	; 00000000b . 040e6 00
d1927		db	000h	; 00000000b . 040e7 00
d1928		db	000h	; 00000000b . 040e8 00
d1929		db	000h	; 00000000b . 040e9 00
d192a		db	000h	; 00000000b . 040ea 00
d192b		db	000h	; 00000000b . 040eb 00
d192c		db	000h	; 00000000b . 040ec 00
d192d		db	000h	; 00000000b . 040ed 00
d192e		db	000h	; 00000000b . 040ee 00
d192f		db	000h	; 00000000b . 040ef 00
d1930		db	000h	; 00000000b . 040f0 00
d1931		db	000h	; 00000000b . 040f1 00
d1932		db	000h	; 00000000b . 040f2 00
d1933		db	000h	; 00000000b . 040f3 00
d1934		db	000h	; 00000000b . 040f4 00
d1935		db	000h	; 00000000b . 040f5 00
d1936		db	000h	; 00000000b . 040f6 00
d1937		db	000h	; 00000000b . 040f7 00
d1938		db	000h	; 00000000b . 040f8 00
d1939		db	000h	; 00000000b . 040f9 00
d193a		db	000h	; 00000000b . 040fa 00
d193b		db	000h	; 00000000b . 040fb 00
d193c		db	000h	; 00000000b . 040fc 00
d193d		db	000h	; 00000000b . 040fd 00
d193e		db	000h	; 00000000b . 040fe 00
d193f		db	000h	; 00000000b . 040ff 00
d1940		db	000h	; 00000000b . 04100 00
d1941		db	000h	; 00000000b . 04101 00
d1942		db	000h	; 00000000b . 04102 00
d1943		db	000h	; 00000000b . 04103 00
d1944		db	000h	; 00000000b . 04104 00
d1945		db	000h	; 00000000b . 04105 00
d1946		db	000h	; 00000000b . 04106 00
d1947		db	000h	; 00000000b . 04107 00
d1948		db	000h	; 00000000b . 04108 00
d1949		db	000h	; 00000000b . 04109 00
d194a		db	000h	; 00000000b . 0410a 00
d194b		db	000h	; 00000000b . 0410b 00
d194c		db	000h	; 00000000b . 0410c 00
d194d		db	000h	; 00000000b . 0410d 00
d194e		db	000h	; 00000000b . 0410e 00
d194f		db	000h	; 00000000b . 0410f 00
d1950		db	000h	; 00000000b . 04110 00
d1951		db	000h	; 00000000b . 04111 00
d1952		db	000h	; 00000000b . 04112 00
d1953		db	000h	; 00000000b . 04113 00
d1954		db	000h	; 00000000b . 04114 00
d1955		db	000h	; 00000000b . 04115 00
d1956		db	000h	; 00000000b . 04116 00
d1957		db	000h	; 00000000b . 04117 00
d1958		db	000h	; 00000000b . 04118 00
d1959		db	000h	; 00000000b . 04119 00
d195a		db	000h	; 00000000b . 0411a 00
d195b		db	000h	; 00000000b . 0411b 00
d195c		db	000h	; 00000000b . 0411c 00
d195d		db	000h	; 00000000b . 0411d 00
d195e		db	000h	; 00000000b . 0411e 00
d195f		db	000h	; 00000000b . 0411f 00
d1960		db	000h	; 00000000b . 04120 00
d1961		db	000h	; 00000000b . 04121 00
d1962		db	000h	; 00000000b . 04122 00
d1963		db	000h	; 00000000b . 04123 00
d1964		db	000h	; 00000000b . 04124 00
d1965		db	000h	; 00000000b . 04125 00
d1966		db	000h	; 00000000b . 04126 00
d1967		db	000h	; 00000000b . 04127 00
d1968		db	000h	; 00000000b . 04128 00
d1969		db	000h	; 00000000b . 04129 00
d196a		db	000h	; 00000000b . 0412a 00
d196b		db	000h	; 00000000b . 0412b 00
d196c		db	000h	; 00000000b . 0412c 00
d196d		db	000h	; 00000000b . 0412d 00
d196e		db	000h	; 00000000b . 0412e 00
d196f		db	000h	; 00000000b . 0412f 00
d1970		db	000h	; 00000000b . 04130 00
d1971		db	000h	; 00000000b . 04131 00
d1972		db	000h	; 00000000b . 04132 00
d1973		db	000h	; 00000000b . 04133 00
d1974		db	000h	; 00000000b . 04134 00
d1975		db	000h	; 00000000b . 04135 00
d1976		db	000h	; 00000000b . 04136 00
d1977		db	000h	; 00000000b . 04137 00
d1978		db	000h	; 00000000b . 04138 00
d1979		db	000h	; 00000000b . 04139 00
d197a		db	000h	; 00000000b . 0413a 00
d197b		db	000h	; 00000000b . 0413b 00
d197c		db	000h	; 00000000b . 0413c 00
d197d		db	000h	; 00000000b . 0413d 00
d197e		db	000h	; 00000000b . 0413e 00
d197f		db	000h	; 00000000b . 0413f 00
d1980		db	000h	; 00000000b . 04140 00
d1981		db	000h	; 00000000b . 04141 00
d1982		db	000h	; 00000000b . 04142 00
d1983		db	000h	; 00000000b . 04143 00
d1984		db	000h	; 00000000b . 04144 00
d1985		db	000h	; 00000000b . 04145 00
d1986		db	000h	; 00000000b . 04146 00
d1987		db	000h	; 00000000b . 04147 00
d1988		db	000h	; 00000000b . 04148 00
d1989		db	000h	; 00000000b . 04149 00
d198a		db	000h	; 00000000b . 0414a 00
d198b		db	000h	; 00000000b . 0414b 00
d198c		db	000h	; 00000000b . 0414c 00
d198d		db	000h	; 00000000b . 0414d 00
d198e		db	000h	; 00000000b . 0414e 00
d198f		db	000h	; 00000000b . 0414f 00
d1990		db	000h	; 00000000b . 04150 00
d1991		db	000h	; 00000000b . 04151 00
d1992		db	000h	; 00000000b . 04152 00
d1993		db	000h	; 00000000b . 04153 00
d1994		db	000h	; 00000000b . 04154 00
d1995		db	000h	; 00000000b . 04155 00
d1996		db	000h	; 00000000b . 04156 00
d1997		db	000h	; 00000000b . 04157 00
d1998		db	000h	; 00000000b . 04158 00
d1999		db	000h	; 00000000b . 04159 00
d199a		db	000h	; 00000000b . 0415a 00
d199b		db	000h	; 00000000b . 0415b 00
d199c		db	000h	; 00000000b . 0415c 00
d199d		db	000h	; 00000000b . 0415d 00
d199e		db	000h	; 00000000b . 0415e 00
d199f		db	000h	; 00000000b . 0415f 00
d19a0		db	000h	; 00000000b . 04160 00
d19a1		db	000h	; 00000000b . 04161 00
d19a2		db	000h	; 00000000b . 04162 00
d19a3		db	000h	; 00000000b . 04163 00
d19a4		db	000h	; 00000000b . 04164 00
d19a5		db	000h	; 00000000b . 04165 00
d19a6		db	000h	; 00000000b . 04166 00
d19a7		db	000h	; 00000000b . 04167 00
d19a8		db	000h	; 00000000b . 04168 00
d19a9		db	000h	; 00000000b . 04169 00
d19aa		db	000h	; 00000000b . 0416a 00
d19ab		db	000h	; 00000000b . 0416b 00
d19ac		db	000h	; 00000000b . 0416c 00
d19ad		db	000h	; 00000000b . 0416d 00
d19ae		db	000h	; 00000000b . 0416e 00
d19af		db	000h	; 00000000b . 0416f 00
d19b0		db	000h	; 00000000b . 04170 00
d19b1		db	000h	; 00000000b . 04171 00
d19b2		db	000h	; 00000000b . 04172 00
d19b3		db	000h	; 00000000b . 04173 00
d19b4		db	000h	; 00000000b . 04174 00
d19b5		db	000h	; 00000000b . 04175 00
d19b6		db	000h	; 00000000b . 04176 00
d19b7		db	000h	; 00000000b . 04177 00
d19b8		db	000h	; 00000000b . 04178 00
d19b9		db	000h	; 00000000b . 04179 00
d19ba		db	000h	; 00000000b . 0417a 00
d19bb		db	000h	; 00000000b . 0417b 00
d19bc		db	000h	; 00000000b . 0417c 00
d19bd		db	000h	; 00000000b . 0417d 00
d19be		db	000h	; 00000000b . 0417e 00
d19bf		db	000h	; 00000000b . 0417f 00
d19c0		db	000h	; 00000000b . 04180 00
d19c1		db	000h	; 00000000b . 04181 00
d19c2		db	000h	; 00000000b . 04182 00
d19c3		db	000h	; 00000000b . 04183 00
d19c4		db	000h	; 00000000b . 04184 00
d19c5		db	000h	; 00000000b . 04185 00
d19c6		db	000h	; 00000000b . 04186 00
d19c7		db	000h	; 00000000b . 04187 00
d19c8		db	000h	; 00000000b . 04188 00
d19c9		db	000h	; 00000000b . 04189 00
d19ca		db	000h	; 00000000b . 0418a 00
d19cb		db	000h	; 00000000b . 0418b 00
d19cc		db	000h	; 00000000b . 0418c 00
d19cd		db	000h	; 00000000b . 0418d 00
d19ce		db	000h	; 00000000b . 0418e 00
d19cf		db	000h	; 00000000b . 0418f 00
d19d0		db	000h	; 00000000b . 04190 00
d19d1		db	000h	; 00000000b . 04191 00
d19d2		db	000h	; 00000000b . 04192 00
d19d3		db	000h	; 00000000b . 04193 00
d19d4		db	000h	; 00000000b . 04194 00
d19d5		db	000h	; 00000000b . 04195 00
d19d6		db	000h	; 00000000b . 04196 00
d19d7		db	000h	; 00000000b . 04197 00
d19d8		db	000h	; 00000000b . 04198 00
d19d9		db	000h	; 00000000b . 04199 00
d19da		db	000h	; 00000000b . 0419a 00
d19db		db	000h	; 00000000b . 0419b 00
d19dc		db	000h	; 00000000b . 0419c 00
d19dd		db	000h	; 00000000b . 0419d 00
d19de		db	000h	; 00000000b . 0419e 00
d19df		db	000h	; 00000000b . 0419f 00
d19e0		db	000h	; 00000000b . 041a0 00
d19e1		db	000h	; 00000000b . 041a1 00
d19e2		db	000h	; 00000000b . 041a2 00
d19e3		db	000h	; 00000000b . 041a3 00
d19e4		db	000h	; 00000000b . 041a4 00
d19e5		db	000h	; 00000000b . 041a5 00
d19e6		db	000h	; 00000000b . 041a6 00
d19e7		db	000h	; 00000000b . 041a7 00
d19e8		db	000h	; 00000000b . 041a8 00
d19e9		db	000h	; 00000000b . 041a9 00
d19ea		db	000h	; 00000000b . 041aa 00
d19eb		db	000h	; 00000000b . 041ab 00
d19ec		db	000h	; 00000000b . 041ac 00
d19ed		db	000h	; 00000000b . 041ad 00
d19ee		db	000h	; 00000000b . 041ae 00
d19ef		db	000h	; 00000000b . 041af 00
d19f0		db	000h	; 00000000b . 041b0 00
d19f1		db	000h	; 00000000b . 041b1 00
d19f2		db	000h	; 00000000b . 041b2 00
d19f3		db	000h	; 00000000b . 041b3 00
d19f4		db	000h	; 00000000b . 041b4 00
d19f5		db	000h	; 00000000b . 041b5 00
d19f6		db	000h	; 00000000b . 041b6 00
d19f7		db	000h	; 00000000b . 041b7 00
d19f8		db	000h	; 00000000b . 041b8 00
d19f9		db	000h	; 00000000b . 041b9 00
d19fa		db	001h	; 00000001b . 041ba 01
d19fb		db	000h	; 00000000b . 041bb 00
d19fc		db	000h	; 00000000b . 041bc 00
d19fd		db	000h	; 00000000b . 041bd 00
d19fe		db	000h	; 00000000b . 041be 00
d19ff		db	000h	; 00000000b . 041bf 00
d1a00		db	000h	; 00000000b . 041c0 00
d1a01		db	000h	; 00000000b . 041c1 00
d1a02		db	000h	; 00000000b . 041c2 00
d1a03		db	000h	; 00000000b . 041c3 00
d1a04		db	000h	; 00000000b . 041c4 00
d1a05		db	000h	; 00000000b . 041c5 00
d1a06		db	000h	; 00000000b . 041c6 00
d1a07		db	000h	; 00000000b . 041c7 00
d1a08		db	000h	; 00000000b . 041c8 00
d1a09		db	002h	; 00000010b . 041c9 02
d1a0a		db	002h	; 00000010b . 041ca 02
d1a0b		db	002h	; 00000010b . 041cb 02
d1a0c		db	002h	; 00000010b . 041cc 02
d1a0d		db	000h	; 00000000b . 041cd 00
d1a0e		db	000h	; 00000000b . 041ce 00
d1a0f		db	003h	; 00000011b . 041cf 03
d1a10		db	002h	; 00000010b . 041d0 02
d1a11		db	002h	; 00000010b . 041d1 02
d1a12		db	002h	; 00000010b . 041d2 02
d1a13		db	000h	; 00000000b . 041d3 00
d1a14		db	000h	; 00000000b . 041d4 00
d1a15		db	000h	; 00000000b . 041d5 00
d1a16		db	000h	; 00000000b . 041d6 00
d1a17		db	000h	; 00000000b . 041d7 00
d1a18		db	001h	; 00000001b . 041d8 01
d1a19		db	000h	; 00000000b . 041d9 00
d1a1a		db	000h	; 00000000b . 041da 00
d1a1b		db	000h	; 00000000b . 041db 00
d1a1c		db	000h	; 00000000b . 041dc 00
d1a1d		db	000h	; 00000000b . 041dd 00
d1a1e		db	002h	; 00000010b . 041de 02
d1a1f		db	002h	; 00000010b . 041df 02
d1a20		db	002h	; 00000010b . 041e0 02
d1a21		db	002h	; 00000010b . 041e1 02
d1a22		db	002h	; 00000010b . 041e2 02
d1a23		db	003h	; 00000011b . 041e3 03
d1a24		db	002h	; 00000010b . 041e4 02
d1a25		db	002h	; 00000010b . 041e5 02
d1a26		db	000h	; 00000000b . 041e6 00
d1a27		db	002h	; 00000010b . 041e7 02
d1a28		db	000h	; 00000000b . 041e8 00
d1a29		db	000h	; 00000000b . 041e9 00
d1a2a		db	002h	; 00000010b . 041ea 02
d1a2b		db	000h	; 00000000b . 041eb 00
d1a2c		db	000h	; 00000000b . 041ec 00
d1a2d		db	002h	; 00000010b . 041ed 02
d1a2e		db	000h	; 00000000b . 041ee 00
d1a2f		db	000h	; 00000000b . 041ef 00
d1a30		db	002h	; 00000010b . 041f0 02
d1a31		db	000h	; 00000000b . 041f1 00
d1a32		db	000h	; 00000000b . 041f2 00
d1a33		db	000h	; 00000000b . 041f3 00
d1a34		db	000h	; 00000000b . 041f4 00
d1a35		db	000h	; 00000000b . 041f5 00
d1a36		db	001h	; 00000001b . 041f6 01
d1a37		db	000h	; 00000000b . 041f7 00
d1a38		db	000h	; 00000000b . 041f8 00
d1a39		db	000h	; 00000000b . 041f9 00
d1a3a		db	000h	; 00000000b . 041fa 00
d1a3b		db	000h	; 00000000b . 041fb 00
d1a3c		db	002h	; 00000010b . 041fc 02
d1a3d		db	000h	; 00000000b . 041fd 00
d1a3e		db	000h	; 00000000b . 041fe 00
d1a3f		db	002h	; 00000010b . 041ff 02
d1a40		db	000h	; 00000000b . 04200 00
d1a41		db	000h	; 00000000b . 04201 00
d1a42		db	000h	; 00000000b . 04202 00
d1a43		db	002h	; 00000010b . 04203 02
d1a44		db	000h	; 00000000b . 04204 00
d1a45		db	002h	; 00000010b . 04205 02
d1a46		db	000h	; 00000000b . 04206 00
d1a47		db	000h	; 00000000b . 04207 00
d1a48		db	002h	; 00000010b . 04208 02
d1a49		db	002h	; 00000010b . 04209 02
d1a4a		db	002h	; 00000010b . 0420a 02
d1a4b		db	002h	; 00000010b . 0420b 02
d1a4c		db	000h	; 00000000b . 0420c 00
d1a4d		db	000h	; 00000000b . 0420d 00
d1a4e		db	002h	; 00000010b . 0420e 02
d1a4f		db	000h	; 00000000b . 0420f 00
d1a50		db	000h	; 00000000b . 04210 00
d1a51		db	000h	; 00000000b . 04211 00
d1a52		db	000h	; 00000000b . 04212 00
d1a53		db	000h	; 00000000b . 04213 00
d1a54		db	001h	; 00000001b . 04214 01
d1a55		db	000h	; 00000000b . 04215 00
d1a56		db	000h	; 00000000b . 04216 00
d1a57		db	000h	; 00000000b . 04217 00
d1a58		db	000h	; 00000000b . 04218 00
d1a59		db	000h	; 00000000b . 04219 00
d1a5a		db	002h	; 00000010b . 0421a 02
d1a5b		db	000h	; 00000000b . 0421b 00
d1a5c		db	000h	; 00000000b . 0421c 00
d1a5d		db	002h	; 00000010b . 0421d 02
d1a5e		db	000h	; 00000000b . 0421e 00
d1a5f		db	000h	; 00000000b . 0421f 00
d1a60		db	000h	; 00000000b . 04220 00
d1a61		db	002h	; 00000010b . 04221 02
d1a62		db	000h	; 00000000b . 04222 00
d1a63		db	002h	; 00000010b . 04223 02
d1a64		db	000h	; 00000000b . 04224 00
d1a65		db	000h	; 00000000b . 04225 00
d1a66		db	002h	; 00000010b . 04226 02
d1a67		db	000h	; 00000000b . 04227 00
d1a68		db	000h	; 00000000b . 04228 00
d1a69		db	000h	; 00000000b . 04229 00
d1a6a		db	000h	; 00000000b . 0422a 00
d1a6b		db	000h	; 00000000b . 0422b 00
d1a6c		db	002h	; 00000010b . 0422c 02
d1a6d		db	000h	; 00000000b . 0422d 00
d1a6e		db	000h	; 00000000b . 0422e 00
d1a6f		db	000h	; 00000000b . 0422f 00
d1a70		db	000h	; 00000000b . 04230 00
d1a71		db	000h	; 00000000b . 04231 00
d1a72		db	001h	; 00000001b . 04232 01
d1a73		db	000h	; 00000000b . 04233 00
d1a74		db	000h	; 00000000b . 04234 00
d1a75		db	000h	; 00000000b . 04235 00
d1a76		db	000h	; 00000000b . 04236 00
d1a77		db	000h	; 00000000b . 04237 00
d1a78		db	002h	; 00000010b . 04238 02
d1a79		db	000h	; 00000000b . 04239 00
d1a7a		db	000h	; 00000000b . 0423a 00
d1a7b		db	002h	; 00000010b . 0423b 02
d1a7c		db	000h	; 00000000b . 0423c 00
d1a7d		db	000h	; 00000000b . 0423d 00
d1a7e		db	000h	; 00000000b . 0423e 00
d1a7f		db	002h	; 00000010b . 0423f 02
d1a80		db	000h	; 00000000b . 04240 00
d1a81		db	002h	; 00000010b . 04241 02
d1a82		db	000h	; 00000000b . 04242 00
d1a83		db	000h	; 00000000b . 04243 00
d1a84		db	002h	; 00000010b . 04244 02
d1a85		db	000h	; 00000000b . 04245 00
d1a86		db	000h	; 00000000b . 04246 00
d1a87		db	000h	; 00000000b . 04247 00
d1a88		db	000h	; 00000000b . 04248 00
d1a89		db	000h	; 00000000b . 04249 00
d1a8a		db	002h	; 00000010b . 0424a 02
d1a8b		db	000h	; 00000000b . 0424b 00
d1a8c		db	000h	; 00000000b . 0424c 00
d1a8d		db	000h	; 00000000b . 0424d 00
d1a8e		db	000h	; 00000000b . 0424e 00
d1a8f		db	000h	; 00000000b . 0424f 00
d1a90		db	001h	; 00000001b . 04250 01
d1a91		db	000h	; 00000000b . 04251 00
d1a92		db	000h	; 00000000b . 04252 00
d1a93		db	000h	; 00000000b . 04253 00
d1a94		db	000h	; 00000000b . 04254 00
d1a95		db	000h	; 00000000b . 04255 00
d1a96		db	002h	; 00000010b . 04256 02
d1a97		db	000h	; 00000000b . 04257 00
d1a98		db	000h	; 00000000b . 04258 00
d1a99		db	002h	; 00000010b . 04259 02
d1a9a		db	000h	; 00000000b . 0425a 00
d1a9b		db	000h	; 00000000b . 0425b 00
d1a9c		db	000h	; 00000000b . 0425c 00
d1a9d		db	002h	; 00000010b . 0425d 02
d1a9e		db	000h	; 00000000b . 0425e 00
d1a9f		db	002h	; 00000010b . 0425f 02
d1aa0		db	000h	; 00000000b . 04260 00
d1aa1		db	000h	; 00000000b . 04261 00
d1aa2		db	002h	; 00000010b . 04262 02
d1aa3		db	002h	; 00000010b . 04263 02
d1aa4		db	002h	; 00000010b . 04264 02
d1aa5		db	002h	; 00000010b . 04265 02
d1aa6		db	002h	; 00000010b . 04266 02
d1aa7		db	002h	; 00000010b . 04267 02
d1aa8		db	002h	; 00000010b . 04268 02
d1aa9		db	002h	; 00000010b . 04269 02
d1aaa		db	002h	; 00000010b . 0426a 02
d1aab		db	002h	; 00000010b . 0426b 02
d1aac		db	002h	; 00000010b . 0426c 02
d1aad		db	002h	; 00000010b . 0426d 02
d1aae		db	002h	; 00000010b . 0426e 02
d1aaf		db	002h	; 00000010b . 0426f 02
d1ab0		db	002h	; 00000010b . 04270 02
d1ab1		db	002h	; 00000010b . 04271 02
d1ab2		db	002h	; 00000010b . 04272 02
d1ab3		db	002h	; 00000010b . 04273 02
d1ab4		db	002h	; 00000010b . 04274 02
d1ab5		db	002h	; 00000010b . 04275 02
d1ab6		db	002h	; 00000010b . 04276 02
d1ab7		db	002h	; 00000010b . 04277 02
d1ab8		db	002h	; 00000010b . 04278 02
d1ab9		db	002h	; 00000010b . 04279 02
d1aba		db	002h	; 00000010b . 0427a 02
d1abb		db	002h	; 00000010b . 0427b 02
d1abc		db	000h	; 00000000b . 0427c 00
d1abd		db	002h	; 00000010b . 0427d 02
d1abe		db	000h	; 00000000b . 0427e 00
d1abf		db	000h	; 00000000b . 0427f 00
d1ac0		db	000h	; 00000000b . 04280 00
d1ac1		db	000h	; 00000000b . 04281 00
d1ac2		db	000h	; 00000000b . 04282 00
d1ac3		db	002h	; 00000010b . 04283 02
d1ac4		db	000h	; 00000000b . 04284 00
d1ac5		db	000h	; 00000000b . 04285 00
d1ac6		db	002h	; 00000010b . 04286 02
d1ac7		db	000h	; 00000000b . 04287 00
d1ac8		db	000h	; 00000000b . 04288 00
d1ac9		db	000h	; 00000000b . 04289 00
d1aca		db	000h	; 00000000b . 0428a 00
d1acb		db	000h	; 00000000b . 0428b 00
d1acc		db	001h	; 00000001b . 0428c 01
d1acd		db	000h	; 00000000b . 0428d 00
d1ace		db	000h	; 00000000b . 0428e 00
d1acf		db	000h	; 00000000b . 0428f 00
d1ad0		db	000h	; 00000000b . 04290 00
d1ad1		db	000h	; 00000000b . 04291 00
d1ad2		db	000h	; 00000000b . 04292 00
d1ad3		db	000h	; 00000000b . 04293 00
d1ad4		db	000h	; 00000000b . 04294 00
d1ad5		db	002h	; 00000010b . 04295 02
d1ad6		db	000h	; 00000000b . 04296 00
d1ad7		db	000h	; 00000000b . 04297 00
d1ad8		db	000h	; 00000000b . 04298 00
d1ad9		db	002h	; 00000010b . 04299 02
d1ada		db	000h	; 00000000b . 0429a 00
d1adb		db	002h	; 00000010b . 0429b 02
d1adc		db	000h	; 00000000b . 0429c 00
d1add		db	000h	; 00000000b . 0429d 00
d1ade		db	000h	; 00000000b . 0429e 00
d1adf		db	000h	; 00000000b . 0429f 00
d1ae0		db	000h	; 00000000b . 042a0 00
d1ae1		db	002h	; 00000010b . 042a1 02
d1ae2		db	000h	; 00000000b . 042a2 00
d1ae3		db	000h	; 00000000b . 042a3 00
d1ae4		db	002h	; 00000010b . 042a4 02
d1ae5		db	000h	; 00000000b . 042a5 00
d1ae6		db	000h	; 00000000b . 042a6 00
d1ae7		db	000h	; 00000000b . 042a7 00
d1ae8		db	000h	; 00000000b . 042a8 00
d1ae9		db	000h	; 00000000b . 042a9 00
d1aea		db	001h	; 00000001b . 042aa 01
d1aeb		db	000h	; 00000000b . 042ab 00
d1aec		db	000h	; 00000000b . 042ac 00
d1aed		db	000h	; 00000000b . 042ad 00
d1aee		db	000h	; 00000000b . 042ae 00
d1aef		db	000h	; 00000000b . 042af 00
d1af0		db	000h	; 00000000b . 042b0 00
d1af1		db	000h	; 00000000b . 042b1 00
d1af2		db	000h	; 00000000b . 042b2 00
d1af3		db	002h	; 00000010b . 042b3 02
d1af4		db	000h	; 00000000b . 042b4 00
d1af5		db	000h	; 00000000b . 042b5 00
d1af6		db	000h	; 00000000b . 042b6 00
d1af7		db	002h	; 00000010b . 042b7 02
d1af8		db	000h	; 00000000b . 042b8 00
d1af9		db	002h	; 00000010b . 042b9 02
d1afa		db	000h	; 00000000b . 042ba 00
d1afb		db	000h	; 00000000b . 042bb 00
d1afc		db	002h	; 00000010b . 042bc 02
d1afd		db	002h	; 00000010b . 042bd 02
d1afe		db	002h	; 00000010b . 042be 02
d1aff		db	002h	; 00000010b . 042bf 02
d1b00		db	000h	; 00000000b . 042c0 00
d1b01		db	000h	; 00000000b . 042c1 00
d1b02		db	002h	; 00000010b . 042c2 02
d1b03		db	001h	; 00000001b . 042c3 01
d1b04		db	001h	; 00000001b . 042c4 01
d1b05		db	001h	; 00000001b . 042c5 01
d1b06		db	001h	; 00000001b . 042c6 01
d1b07		db	001h	; 00000001b . 042c7 01
d1b08		db	001h	; 00000001b . 042c8 01
d1b09		db	001h	; 00000001b . 042c9 01
d1b0a		db	001h	; 00000001b . 042ca 01
d1b0b		db	001h	; 00000001b . 042cb 01
d1b0c		db	000h	; 00000000b . 042cc 00
d1b0d		db	000h	; 00000000b . 042cd 00
d1b0e		db	002h	; 00000010b . 042ce 02
d1b0f		db	002h	; 00000010b . 042cf 02
d1b10		db	002h	; 00000010b . 042d0 02
d1b11		db	002h	; 00000010b . 042d1 02
d1b12		db	000h	; 00000000b . 042d2 00
d1b13		db	000h	; 00000000b . 042d3 00
d1b14		db	000h	; 00000000b . 042d4 00
d1b15		db	002h	; 00000010b . 042d5 02
d1b16		db	000h	; 00000000b . 042d6 00
d1b17		db	002h	; 00000010b . 042d7 02
d1b18		db	000h	; 00000000b . 042d8 00
d1b19		db	000h	; 00000000b . 042d9 00
d1b1a		db	002h	; 00000010b . 042da 02
d1b1b		db	000h	; 00000000b . 042db 00
d1b1c		db	000h	; 00000000b . 042dc 00
d1b1d		db	002h	; 00000010b . 042dd 02
d1b1e		db	000h	; 00000000b . 042de 00
d1b1f		db	000h	; 00000000b . 042df 00
d1b20		db	002h	; 00000010b . 042e0 02
d1b21		db	000h	; 00000000b . 042e1 00
d1b22		db	000h	; 00000000b . 042e2 00
d1b23		db	001h	; 00000001b . 042e3 01
d1b24		db	000h	; 00000000b . 042e4 00
d1b25		db	000h	; 00000000b . 042e5 00
d1b26		db	000h	; 00000000b . 042e6 00
d1b27		db	000h	; 00000000b . 042e7 00
d1b28		db	000h	; 00000000b . 042e8 00
d1b29		db	001h	; 00000001b . 042e9 01
d1b2a		db	000h	; 00000000b . 042ea 00
d1b2b		db	000h	; 00000000b . 042eb 00
d1b2c		db	002h	; 00000010b . 042ec 02
d1b2d		db	000h	; 00000000b . 042ed 00
d1b2e		db	000h	; 00000000b . 042ee 00
d1b2f		db	002h	; 00000010b . 042ef 02
d1b30		db	000h	; 00000000b . 042f0 00
d1b31		db	000h	; 00000000b . 042f1 00
d1b32		db	000h	; 00000000b . 042f2 00
d1b33		db	002h	; 00000010b . 042f3 02
d1b34		db	000h	; 00000000b . 042f4 00
d1b35		db	002h	; 00000010b . 042f5 02
d1b36		db	002h	; 00000010b . 042f6 02
d1b37		db	002h	; 00000010b . 042f7 02
d1b38		db	002h	; 00000010b . 042f8 02
d1b39		db	000h	; 00000000b . 042f9 00
d1b3a		db	000h	; 00000000b . 042fa 00
d1b3b		db	002h	; 00000010b . 042fb 02
d1b3c		db	002h	; 00000010b . 042fc 02
d1b3d		db	002h	; 00000010b . 042fd 02
d1b3e		db	002h	; 00000010b . 042fe 02
d1b3f		db	000h	; 00000000b . 042ff 00
d1b40		db	000h	; 00000000b . 04300 00
d1b41		db	001h	; 00000001b . 04301 01
d1b42		db	000h	; 00000000b . 04302 00
d1b43		db	000h	; 00000000b . 04303 00
d1b44		db	000h	; 00000000b . 04304 00
d1b45		db	000h	; 00000000b . 04305 00
d1b46		db	000h	; 00000000b . 04306 00
d1b47		db	001h	; 00000001b . 04307 01
d1b48		db	001h	; 00000001b . 04308 01
d1b49		db	001h	; 00000001b . 04309 01
d1b4a		db	002h	; 00000010b . 0430a 02
d1b4b		db	000h	; 00000000b . 0430b 00
d1b4c		db	000h	; 00000000b . 0430c 00
d1b4d		db	002h	; 00000010b . 0430d 02
d1b4e		db	002h	; 00000010b . 0430e 02
d1b4f		db	002h	; 00000010b . 0430f 02
d1b50		db	002h	; 00000010b . 04310 02
d1b51		db	002h	; 00000010b . 04311 02
d1b52		db	000h	; 00000000b . 04312 00
d1b53		db	002h	; 00000010b . 04313 02
d1b54		db	000h	; 00000000b . 04314 00
d1b55		db	000h	; 00000000b . 04315 00
d1b56		db	000h	; 00000000b . 04316 00
d1b57		db	000h	; 00000000b . 04317 00
d1b58		db	000h	; 00000000b . 04318 00
d1b59		db	001h	; 00000001b . 04319 01
d1b5a		db	000h	; 00000000b . 0431a 00
d1b5b		db	000h	; 00000000b . 0431b 00
d1b5c		db	000h	; 00000000b . 0431c 00
d1b5d		db	000h	; 00000000b . 0431d 00
d1b5e		db	000h	; 00000000b . 0431e 00
d1b5f		db	001h	; 00000001b . 0431f 01
d1b60		db	000h	; 00000000b . 04320 00
d1b61		db	000h	; 00000000b . 04321 00
d1b62		db	000h	; 00000000b . 04322 00
d1b63		db	000h	; 00000000b . 04323 00
d1b64		db	000h	; 00000000b . 04324 00
d1b65		db	001h	; 00000001b . 04325 01
d1b66		db	000h	; 00000000b . 04326 00
d1b67		db	000h	; 00000000b . 04327 00
d1b68		db	000h	; 00000000b . 04328 00
d1b69		db	000h	; 00000000b . 04329 00
d1b6a		db	000h	; 00000000b . 0432a 00
d1b6b		db	002h	; 00000010b . 0432b 02
d1b6c		db	000h	; 00000000b . 0432c 00
d1b6d		db	000h	; 00000000b . 0432d 00
d1b6e		db	000h	; 00000000b . 0432e 00
d1b6f		db	000h	; 00000000b . 0432f 00
d1b70		db	000h	; 00000000b . 04330 00
d1b71		db	002h	; 00000010b . 04331 02
d1b72		db	000h	; 00000000b . 04332 00
d1b73		db	000h	; 00000000b . 04333 00
d1b74		db	000h	; 00000000b . 04334 00
d1b75		db	000h	; 00000000b . 04335 00
d1b76		db	000h	; 00000000b . 04336 00
d1b77		db	001h	; 00000001b . 04337 01
d1b78		db	000h	; 00000000b . 04338 00
d1b79		db	000h	; 00000000b . 04339 00
d1b7a		db	000h	; 00000000b . 0433a 00
d1b7b		db	000h	; 00000000b . 0433b 00
d1b7c		db	000h	; 00000000b . 0433c 00
d1b7d		db	001h	; 00000001b . 0433d 01
d1b7e		db	000h	; 00000000b . 0433e 00
d1b7f		db	000h	; 00000000b . 0433f 00
d1b80		db	000h	; 00000000b . 04340 00
d1b81		db	000h	; 00000000b . 04341 00
d1b82		db	000h	; 00000000b . 04342 00
d1b83		db	001h	; 00000001b . 04343 01
d1b84		db	000h	; 00000000b . 04344 00
d1b85		db	000h	; 00000000b . 04345 00
d1b86		db	000h	; 00000000b . 04346 00
d1b87		db	000h	; 00000000b . 04347 00
d1b88		db	000h	; 00000000b . 04348 00
d1b89		db	002h	; 00000010b . 04349 02
d1b8a		db	000h	; 00000000b . 0434a 00
d1b8b		db	000h	; 00000000b . 0434b 00
d1b8c		db	000h	; 00000000b . 0434c 00
d1b8d		db	000h	; 00000000b . 0434d 00
d1b8e		db	000h	; 00000000b . 0434e 00
d1b8f		db	002h	; 00000010b . 0434f 02
d1b90		db	002h	; 00000010b . 04350 02
d1b91		db	002h	; 00000010b . 04351 02
d1b92		db	002h	; 00000010b . 04352 02
d1b93		db	000h	; 00000000b . 04353 00
d1b94		db	000h	; 00000000b . 04354 00
d1b95		db	002h	; 00000010b . 04355 02
d1b96		db	002h	; 00000010b . 04356 02
d1b97		db	002h	; 00000010b . 04357 02
d1b98		db	002h	; 00000010b . 04358 02
d1b99		db	000h	; 00000000b . 04359 00
d1b9a		db	000h	; 00000000b . 0435a 00
d1b9b		db	001h	; 00000001b . 0435b 01
d1b9c		db	000h	; 00000000b . 0435c 00
d1b9d		db	000h	; 00000000b . 0435d 00
d1b9e		db	000h	; 00000000b . 0435e 00
d1b9f		db	000h	; 00000000b . 0435f 00
d1ba0		db	000h	; 00000000b . 04360 00
d1ba1		db	001h	; 00000001b . 04361 01
d1ba2		db	001h	; 00000001b . 04362 01
d1ba3		db	001h	; 00000001b . 04363 01
d1ba4		db	002h	; 00000010b . 04364 02
d1ba5		db	000h	; 00000000b . 04365 00
d1ba6		db	000h	; 00000000b . 04366 00
d1ba7		db	002h	; 00000010b . 04367 02
d1ba8		db	002h	; 00000010b . 04368 02
d1ba9		db	002h	; 00000010b . 04369 02
d1baa		db	002h	; 00000010b . 0436a 02
d1bab		db	002h	; 00000010b . 0436b 02
d1bac		db	000h	; 00000000b . 0436c 00
d1bad		db	002h	; 00000010b . 0436d 02
d1bae		db	000h	; 00000000b . 0436e 00
d1baf		db	000h	; 00000000b . 0436f 00
d1bb0		db	002h	; 00000010b . 04370 02
d1bb1		db	000h	; 00000000b . 04371 00
d1bb2		db	000h	; 00000000b . 04372 00
d1bb3		db	002h	; 00000010b . 04373 02
d1bb4		db	000h	; 00000000b . 04374 00
d1bb5		db	000h	; 00000000b . 04375 00
d1bb6		db	002h	; 00000010b . 04376 02
d1bb7		db	000h	; 00000000b . 04377 00
d1bb8		db	000h	; 00000000b . 04378 00
d1bb9		db	001h	; 00000001b . 04379 01
d1bba		db	000h	; 00000000b . 0437a 00
d1bbb		db	000h	; 00000000b . 0437b 00
d1bbc		db	000h	; 00000000b . 0437c 00
d1bbd		db	000h	; 00000000b . 0437d 00
d1bbe		db	000h	; 00000000b . 0437e 00
d1bbf		db	001h	; 00000001b . 0437f 01
d1bc0		db	000h	; 00000000b . 04380 00
d1bc1		db	000h	; 00000000b . 04381 00
d1bc2		db	002h	; 00000010b . 04382 02
d1bc3		db	000h	; 00000000b . 04383 00
d1bc4		db	000h	; 00000000b . 04384 00
d1bc5		db	002h	; 00000010b . 04385 02
d1bc6		db	000h	; 00000000b . 04386 00
d1bc7		db	000h	; 00000000b . 04387 00
d1bc8		db	000h	; 00000000b . 04388 00
d1bc9		db	002h	; 00000010b . 04389 02
d1bca		db	000h	; 00000000b . 0438a 00
d1bcb		db	002h	; 00000010b . 0438b 02
d1bcc		db	000h	; 00000000b . 0438c 00
d1bcd		db	000h	; 00000000b . 0438d 00
d1bce		db	002h	; 00000010b . 0438e 02
d1bcf		db	002h	; 00000010b . 0438f 02
d1bd0		db	002h	; 00000010b . 04390 02
d1bd1		db	002h	; 00000010b . 04391 02
d1bd2		db	000h	; 00000000b . 04392 00
d1bd3		db	000h	; 00000000b . 04393 00
d1bd4		db	002h	; 00000010b . 04394 02
d1bd5		db	001h	; 00000001b . 04395 01
d1bd6		db	001h	; 00000001b . 04396 01
d1bd7		db	001h	; 00000001b . 04397 01
d1bd8		db	001h	; 00000001b . 04398 01
d1bd9		db	001h	; 00000001b . 04399 01
d1bda		db	001h	; 00000001b . 0439a 01
d1bdb		db	001h	; 00000001b . 0439b 01
d1bdc		db	001h	; 00000001b . 0439c 01
d1bdd		db	001h	; 00000001b . 0439d 01
d1bde		db	000h	; 00000000b . 0439e 00
d1bdf		db	000h	; 00000000b . 0439f 00
d1be0		db	002h	; 00000010b . 043a0 02
d1be1		db	002h	; 00000010b . 043a1 02
d1be2		db	002h	; 00000010b . 043a2 02
d1be3		db	002h	; 00000010b . 043a3 02
d1be4		db	000h	; 00000000b . 043a4 00
d1be5		db	000h	; 00000000b . 043a5 00
d1be6		db	000h	; 00000000b . 043a6 00
d1be7		db	002h	; 00000010b . 043a7 02
d1be8		db	000h	; 00000000b . 043a8 00
d1be9		db	002h	; 00000010b . 043a9 02
d1bea		db	000h	; 00000000b . 043aa 00
d1beb		db	000h	; 00000000b . 043ab 00
d1bec		db	000h	; 00000000b . 043ac 00
d1bed		db	000h	; 00000000b . 043ad 00
d1bee		db	000h	; 00000000b . 043ae 00
d1bef		db	002h	; 00000010b . 043af 02
d1bf0		db	000h	; 00000000b . 043b0 00
d1bf1		db	000h	; 00000000b . 043b1 00
d1bf2		db	002h	; 00000010b . 043b2 02
d1bf3		db	000h	; 00000000b . 043b3 00
d1bf4		db	000h	; 00000000b . 043b4 00
d1bf5		db	000h	; 00000000b . 043b5 00
d1bf6		db	000h	; 00000000b . 043b6 00
d1bf7		db	000h	; 00000000b . 043b7 00
d1bf8		db	001h	; 00000001b . 043b8 01
d1bf9		db	000h	; 00000000b . 043b9 00
d1bfa		db	000h	; 00000000b . 043ba 00
d1bfb		db	000h	; 00000000b . 043bb 00
d1bfc		db	000h	; 00000000b . 043bc 00
d1bfd		db	000h	; 00000000b . 043bd 00
d1bfe		db	000h	; 00000000b . 043be 00
d1bff		db	000h	; 00000000b . 043bf 00
d1c00		db	000h	; 00000000b . 043c0 00
d1c01		db	002h	; 00000010b . 043c1 02
d1c02		db	000h	; 00000000b . 043c2 00
d1c03		db	000h	; 00000000b . 043c3 00
d1c04		db	000h	; 00000000b . 043c4 00
d1c05		db	002h	; 00000010b . 043c5 02
d1c06		db	000h	; 00000000b . 043c6 00
d1c07		db	002h	; 00000010b . 043c7 02
d1c08		db	000h	; 00000000b . 043c8 00
d1c09		db	000h	; 00000000b . 043c9 00
d1c0a		db	000h	; 00000000b . 043ca 00
d1c0b		db	000h	; 00000000b . 043cb 00
d1c0c		db	000h	; 00000000b . 043cc 00
d1c0d		db	002h	; 00000010b . 043cd 02
d1c0e		db	000h	; 00000000b . 043ce 00
d1c0f		db	000h	; 00000000b . 043cf 00
d1c10		db	002h	; 00000010b . 043d0 02
d1c11		db	000h	; 00000000b . 043d1 00
d1c12		db	000h	; 00000000b . 043d2 00
d1c13		db	000h	; 00000000b . 043d3 00
d1c14		db	000h	; 00000000b . 043d4 00
d1c15		db	000h	; 00000000b . 043d5 00
d1c16		db	001h	; 00000001b . 043d6 01
d1c17		db	000h	; 00000000b . 043d7 00
d1c18		db	000h	; 00000000b . 043d8 00
d1c19		db	000h	; 00000000b . 043d9 00
d1c1a		db	000h	; 00000000b . 043da 00
d1c1b		db	000h	; 00000000b . 043db 00
d1c1c		db	000h	; 00000000b . 043dc 00
d1c1d		db	000h	; 00000000b . 043dd 00
d1c1e		db	000h	; 00000000b . 043de 00
d1c1f		db	002h	; 00000010b . 043df 02
d1c20		db	000h	; 00000000b . 043e0 00
d1c21		db	000h	; 00000000b . 043e1 00
d1c22		db	000h	; 00000000b . 043e2 00
d1c23		db	002h	; 00000010b . 043e3 02
d1c24		db	000h	; 00000000b . 043e4 00
d1c25		db	002h	; 00000010b . 043e5 02
d1c26		db	000h	; 00000000b . 043e6 00
d1c27		db	000h	; 00000000b . 043e7 00
d1c28		db	002h	; 00000010b . 043e8 02
d1c29		db	002h	; 00000010b . 043e9 02
d1c2a		db	002h	; 00000010b . 043ea 02
d1c2b		db	002h	; 00000010b . 043eb 02
d1c2c		db	002h	; 00000010b . 043ec 02
d1c2d		db	002h	; 00000010b . 043ed 02
d1c2e		db	002h	; 00000010b . 043ee 02
d1c2f		db	002h	; 00000010b . 043ef 02
d1c30		db	002h	; 00000010b . 043f0 02
d1c31		db	002h	; 00000010b . 043f1 02
d1c32		db	002h	; 00000010b . 043f2 02
d1c33		db	002h	; 00000010b . 043f3 02
d1c34		db	002h	; 00000010b . 043f4 02
d1c35		db	002h	; 00000010b . 043f5 02
d1c36		db	002h	; 00000010b . 043f6 02
d1c37		db	002h	; 00000010b . 043f7 02
d1c38		db	002h	; 00000010b . 043f8 02
d1c39		db	002h	; 00000010b . 043f9 02
d1c3a		db	002h	; 00000010b . 043fa 02
d1c3b		db	002h	; 00000010b . 043fb 02
d1c3c		db	002h	; 00000010b . 043fc 02
d1c3d		db	002h	; 00000010b . 043fd 02
d1c3e		db	002h	; 00000010b . 043fe 02
d1c3f		db	002h	; 00000010b . 043ff 02
d1c40		db	002h	; 00000010b . 04400 02
d1c41		db	002h	; 00000010b . 04401 02
d1c42		db	000h	; 00000000b . 04402 00
d1c43		db	002h	; 00000010b . 04403 02
d1c44		db	000h	; 00000000b . 04404 00
d1c45		db	000h	; 00000000b . 04405 00
d1c46		db	002h	; 00000010b . 04406 02
d1c47		db	000h	; 00000000b . 04407 00
d1c48		db	000h	; 00000000b . 04408 00
d1c49		db	000h	; 00000000b . 04409 00
d1c4a		db	000h	; 00000000b . 0440a 00
d1c4b		db	000h	; 00000000b . 0440b 00
d1c4c		db	002h	; 00000010b . 0440c 02
d1c4d		db	000h	; 00000000b . 0440d 00
d1c4e		db	000h	; 00000000b . 0440e 00
d1c4f		db	000h	; 00000000b . 0440f 00
d1c50		db	000h	; 00000000b . 04410 00
d1c51		db	000h	; 00000000b . 04411 00
d1c52		db	001h	; 00000001b . 04412 01
d1c53		db	000h	; 00000000b . 04413 00
d1c54		db	000h	; 00000000b . 04414 00
d1c55		db	000h	; 00000000b . 04415 00
d1c56		db	000h	; 00000000b . 04416 00
d1c57		db	000h	; 00000000b . 04417 00
d1c58		db	002h	; 00000010b . 04418 02
d1c59		db	000h	; 00000000b . 04419 00
d1c5a		db	000h	; 00000000b . 0441a 00
d1c5b		db	002h	; 00000010b . 0441b 02
d1c5c		db	000h	; 00000000b . 0441c 00
d1c5d		db	000h	; 00000000b . 0441d 00
d1c5e		db	000h	; 00000000b . 0441e 00
d1c5f		db	002h	; 00000010b . 0441f 02
d1c60		db	000h	; 00000000b . 04420 00
d1c61		db	002h	; 00000010b . 04421 02
d1c62		db	000h	; 00000000b . 04422 00
d1c63		db	000h	; 00000000b . 04423 00
d1c64		db	002h	; 00000010b . 04424 02
d1c65		db	000h	; 00000000b . 04425 00
d1c66		db	000h	; 00000000b . 04426 00
d1c67		db	000h	; 00000000b . 04427 00
d1c68		db	000h	; 00000000b . 04428 00
d1c69		db	000h	; 00000000b . 04429 00
d1c6a		db	002h	; 00000010b . 0442a 02
d1c6b		db	000h	; 00000000b . 0442b 00
d1c6c		db	000h	; 00000000b . 0442c 00
d1c6d		db	000h	; 00000000b . 0442d 00
d1c6e		db	000h	; 00000000b . 0442e 00
d1c6f		db	000h	; 00000000b . 0442f 00
d1c70		db	001h	; 00000001b . 04430 01
d1c71		db	000h	; 00000000b . 04431 00
d1c72		db	000h	; 00000000b . 04432 00
d1c73		db	000h	; 00000000b . 04433 00
d1c74		db	000h	; 00000000b . 04434 00
d1c75		db	000h	; 00000000b . 04435 00
d1c76		db	002h	; 00000010b . 04436 02
d1c77		db	000h	; 00000000b . 04437 00
d1c78		db	000h	; 00000000b . 04438 00
d1c79		db	002h	; 00000010b . 04439 02
d1c7a		db	000h	; 00000000b . 0443a 00
d1c7b		db	000h	; 00000000b . 0443b 00
d1c7c		db	000h	; 00000000b . 0443c 00
d1c7d		db	002h	; 00000010b . 0443d 02
d1c7e		db	000h	; 00000000b . 0443e 00
d1c7f		db	002h	; 00000010b . 0443f 02
d1c80		db	000h	; 00000000b . 04440 00
d1c81		db	000h	; 00000000b . 04441 00
d1c82		db	002h	; 00000010b . 04442 02
d1c83		db	002h	; 00000010b . 04443 02
d1c84		db	002h	; 00000010b . 04444 02
d1c85		db	002h	; 00000010b . 04445 02
d1c86		db	000h	; 00000000b . 04446 00
d1c87		db	000h	; 00000000b . 04447 00
d1c88		db	002h	; 00000010b . 04448 02
d1c89		db	000h	; 00000000b . 04449 00
d1c8a		db	000h	; 00000000b . 0444a 00
d1c8b		db	000h	; 00000000b . 0444b 00
d1c8c		db	000h	; 00000000b . 0444c 00
d1c8d		db	000h	; 00000000b . 0444d 00
d1c8e		db	001h	; 00000001b . 0444e 01
d1c8f		db	000h	; 00000000b . 0444f 00
d1c90		db	000h	; 00000000b . 04450 00
d1c91		db	000h	; 00000000b . 04451 00
d1c92		db	000h	; 00000000b . 04452 00
d1c93		db	000h	; 00000000b . 04453 00
d1c94		db	002h	; 00000010b . 04454 02
d1c95		db	000h	; 00000000b . 04455 00
d1c96		db	000h	; 00000000b . 04456 00
d1c97		db	002h	; 00000010b . 04457 02
d1c98		db	000h	; 00000000b . 04458 00
d1c99		db	000h	; 00000000b . 04459 00
d1c9a		db	000h	; 00000000b . 0445a 00
d1c9b		db	002h	; 00000010b . 0445b 02
d1c9c		db	000h	; 00000000b . 0445c 00
d1c9d		db	002h	; 00000010b . 0445d 02
d1c9e		db	000h	; 00000000b . 0445e 00
d1c9f		db	000h	; 00000000b . 0445f 00
d1ca0		db	002h	; 00000010b . 04460 02
d1ca1		db	000h	; 00000000b . 04461 00
d1ca2		db	000h	; 00000000b . 04462 00
d1ca3		db	002h	; 00000010b . 04463 02
d1ca4		db	000h	; 00000000b . 04464 00
d1ca5		db	000h	; 00000000b . 04465 00
d1ca6		db	002h	; 00000010b . 04466 02
d1ca7		db	000h	; 00000000b . 04467 00
d1ca8		db	000h	; 00000000b . 04468 00
d1ca9		db	000h	; 00000000b . 04469 00
d1caa		db	000h	; 00000000b . 0446a 00
d1cab		db	000h	; 00000000b . 0446b 00
d1cac		db	001h	; 00000001b . 0446c 01
d1cad		db	000h	; 00000000b . 0446d 00
d1cae		db	000h	; 00000000b . 0446e 00
d1caf		db	000h	; 00000000b . 0446f 00
d1cb0		db	000h	; 00000000b . 04470 00
d1cb1		db	000h	; 00000000b . 04471 00
d1cb2		db	002h	; 00000010b . 04472 02
d1cb3		db	000h	; 00000000b . 04473 00
d1cb4		db	000h	; 00000000b . 04474 00
d1cb5		db	002h	; 00000010b . 04475 02
d1cb6		db	000h	; 00000000b . 04476 00
d1cb7		db	000h	; 00000000b . 04477 00
d1cb8		db	000h	; 00000000b . 04478 00
d1cb9		db	002h	; 00000010b . 04479 02
d1cba		db	000h	; 00000000b . 0447a 00
d1cbb		db	002h	; 00000010b . 0447b 02
d1cbc		db	002h	; 00000010b . 0447c 02
d1cbd		db	002h	; 00000010b . 0447d 02
d1cbe		db	002h	; 00000010b . 0447e 02
d1cbf		db	000h	; 00000000b . 0447f 00
d1cc0		db	000h	; 00000000b . 04480 00
d1cc1		db	003h	; 00000011b . 04481 03
d1cc2		db	002h	; 00000010b . 04482 02
d1cc3		db	002h	; 00000010b . 04483 02
d1cc4		db	002h	; 00000010b . 04484 02
d1cc5		db	000h	; 00000000b . 04485 00
d1cc6		db	000h	; 00000000b . 04486 00
d1cc7		db	000h	; 00000000b . 04487 00
d1cc8		db	000h	; 00000000b . 04488 00
d1cc9		db	000h	; 00000000b . 04489 00
d1cca		db	001h	; 00000001b . 0448a 01
d1ccb		db	000h	; 00000000b . 0448b 00
d1ccc		db	000h	; 00000000b . 0448c 00
d1ccd		db	000h	; 00000000b . 0448d 00
d1cce		db	000h	; 00000000b . 0448e 00
d1ccf		db	000h	; 00000000b . 0448f 00
d1cd0		db	002h	; 00000010b . 04490 02
d1cd1		db	002h	; 00000010b . 04491 02
d1cd2		db	002h	; 00000010b . 04492 02
d1cd3		db	002h	; 00000010b . 04493 02
d1cd4		db	002h	; 00000010b . 04494 02
d1cd5		db	003h	; 00000011b . 04495 03
d1cd6		db	002h	; 00000010b . 04496 02
d1cd7		db	002h	; 00000010b . 04497 02
d1cd8		db	000h	; 00000000b . 04498 00
d1cd9		db	000h	; 00000000b . 04499 00
d1cda		db	000h	; 00000000b . 0449a 00
d1cdb		db	000h	; 00000000b . 0449b 00
d1cdc		db	000h	; 00000000b . 0449c 00
d1cdd		db	000h	; 00000000b . 0449d 00
d1cde		db	000h	; 00000000b . 0449e 00
d1cdf		db	000h	; 00000000b . 0449f 00
d1ce0		db	000h	; 00000000b . 044a0 00
d1ce1		db	000h	; 00000000b . 044a1 00
d1ce2		db	000h	; 00000000b . 044a2 00
d1ce3		db	000h	; 00000000b . 044a3 00
d1ce4		db	000h	; 00000000b . 044a4 00
d1ce5		db	000h	; 00000000b . 044a5 00
d1ce6		db	000h	; 00000000b . 044a6 00
d1ce7		db	000h	; 00000000b . 044a7 00
d1ce8		db	001h	; 00000001b . 044a8 01
d1ce9		db	000h	; 00000000b . 044a9 00
d1cea		db	000h	; 00000000b . 044aa 00
d1ceb		db	000h	; 00000000b . 044ab 00
d1cec		db	000h	; 00000000b . 044ac 00
d1ced		db	000h	; 00000000b . 044ad 00
d1cee		db	000h	; 00000000b . 044ae 00
d1cef		db	000h	; 00000000b . 044af 00
d1cf0		db	000h	; 00000000b . 044b0 00
d1cf1		db	000h	; 00000000b . 044b1 00
d1cf2		db	000h	; 00000000b . 044b2 00
d1cf3		db	000h	; 00000000b . 044b3 00
d1cf4		db	000h	; 00000000b . 044b4 00
d1cf5		db	000h	; 00000000b . 044b5 00
d1cf6		db	000h	; 00000000b . 044b6 00
d1cf7		db	000h	; 00000000b . 044b7 00
d1cf8		db	000h	; 00000000b . 044b8 00
d1cf9		db	000h	; 00000000b . 044b9 00
d1cfa		db	000h	; 00000000b . 044ba 00
d1cfb		db	000h	; 00000000b . 044bb 00
d1cfc		db	000h	; 00000000b . 044bc 00
d1cfd		db	000h	; 00000000b . 044bd 00
d1cfe		db	000h	; 00000000b . 044be 00
d1cff		db	000h	; 00000000b . 044bf 00
d1d00		db	000h	; 00000000b . 044c0 00
d1d01		db	000h	; 00000000b . 044c1 00
d1d02		db	000h	; 00000000b . 044c2 00
d1d03		db	000h	; 00000000b . 044c3 00
d1d04		db	000h	; 00000000b . 044c4 00
d1d05		db	000h	; 00000000b . 044c5 00
d1d06		db	001h	; 00000001b . 044c6 01
d1d07		db	000h	; 00000000b . 044c7 00
d1d08		db	000h	; 00000000b . 044c8 00
d1d09		db	000h	; 00000000b . 044c9 00
d1d0a		db	000h	; 00000000b . 044ca 00
d1d0b		db	000h	; 00000000b . 044cb 00
d1d0c		db	000h	; 00000000b . 044cc 00
d1d0d		db	000h	; 00000000b . 044cd 00
d1d0e		db	000h	; 00000000b . 044ce 00
d1d0f		db	000h	; 00000000b . 044cf 00
d1d10		db	000h	; 00000000b . 044d0 00
d1d11		db	000h	; 00000000b . 044d1 00
d1d12		db	000h	; 00000000b . 044d2 00
d1d13		db	000h	; 00000000b . 044d3 00
d1d14		db	000h	; 00000000b . 044d4 00
d1d15		db	000h	; 00000000b . 044d5 00
d1d16		db	000h	; 00000000b . 044d6 00
d1d17		db	000h	; 00000000b . 044d7 00
d1d18		db	000h	; 00000000b . 044d8 00
d1d19		db	000h	; 00000000b . 044d9 00
d1d1a		db	000h	; 00000000b . 044da 00
d1d1b		db	000h	; 00000000b . 044db 00
d1d1c		db	000h	; 00000000b . 044dc 00
d1d1d		db	000h	; 00000000b . 044dd 00
d1d1e		db	000h	; 00000000b . 044de 00
d1d1f		db	000h	; 00000000b . 044df 00
d1d20		db	000h	; 00000000b . 044e0 00
d1d21		db	000h	; 00000000b . 044e1 00
d1d22		db	000h	; 00000000b . 044e2 00
d1d23		db	000h	; 00000000b . 044e3 00
d1d24		db	001h	; 00000001b . 044e4 01
d1d25		db	000h	; 00000000b . 044e5 00
d1d26		db	000h	; 00000000b . 044e6 00
d1d27		db	000h	; 00000000b . 044e7 00
d1d28		db	000h	; 00000000b . 044e8 00
d1d29		db	000h	; 00000000b . 044e9 00
d1d2a		db	000h	; 00000000b . 044ea 00
d1d2b		db	000h	; 00000000b . 044eb 00
d1d2c		db	000h	; 00000000b . 044ec 00
d1d2d		db	000h	; 00000000b . 044ed 00
d1d2e		db	000h	; 00000000b . 044ee 00
d1d2f		db	000h	; 00000000b . 044ef 00
d1d30		db	000h	; 00000000b . 044f0 00
d1d31		db	000h	; 00000000b . 044f1 00
d1d32		db	000h	; 00000000b . 044f2 00
d1d33		db	000h	; 00000000b . 044f3 00
d1d34		db	000h	; 00000000b . 044f4 00
d1d35		db	000h	; 00000000b . 044f5 00
d1d36		db	000h	; 00000000b . 044f6 00
d1d37		db	000h	; 00000000b . 044f7 00
d1d38		db	000h	; 00000000b . 044f8 00
d1d39		db	000h	; 00000000b . 044f9 00
d1d3a		db	000h	; 00000000b . 044fa 00
d1d3b		db	000h	; 00000000b . 044fb 00
d1d3c		db	000h	; 00000000b . 044fc 00
d1d3d		db	000h	; 00000000b . 044fd 00
d1d3e		db	000h	; 00000000b . 044fe 00
d1d3f		db	000h	; 00000000b . 044ff 00
d1d40		db	000h	; 00000000b . 04500 00
d1d41		db	000h	; 00000000b . 04501 00
d1d42		db	001h	; 00000001b . 04502 01
d1d43		db	000h	; 00000000b . 04503 00
d1d44		db	000h	; 00000000b . 04504 00
d1d45		db	000h	; 00000000b . 04505 00
d1d46		db	000h	; 00000000b . 04506 00
d1d47		db	000h	; 00000000b . 04507 00
d1d48		db	000h	; 00000000b . 04508 00
d1d49		db	000h	; 00000000b . 04509 00
d1d4a		db	000h	; 00000000b . 0450a 00
d1d4b		db	000h	; 00000000b . 0450b 00
d1d4c		db	000h	; 00000000b . 0450c 00
d1d4d		db	000h	; 00000000b . 0450d 00
d1d4e		db	000h	; 00000000b . 0450e 00
d1d4f		db	000h	; 00000000b . 0450f 00
d1d50		db	000h	; 00000000b . 04510 00
d1d51		db	000h	; 00000000b . 04511 00
d1d52		db	000h	; 00000000b . 04512 00
d1d53		db	000h	; 00000000b . 04513 00
d1d54		db	000h	; 00000000b . 04514 00
d1d55		db	000h	; 00000000b . 04515 00
d1d56		db	000h	; 00000000b . 04516 00
d1d57		db	000h	; 00000000b . 04517 00
d1d58		db	000h	; 00000000b . 04518 00
d1d59		db	000h	; 00000000b . 04519 00
d1d5a		db	000h	; 00000000b . 0451a 00
d1d5b		db	000h	; 00000000b . 0451b 00
d1d5c		db	000h	; 00000000b . 0451c 00
d1d5d		db	000h	; 00000000b . 0451d 00
d1d5e		db	000h	; 00000000b . 0451e 00
d1d5f		db	000h	; 00000000b . 0451f 00
d1d60		db	001h	; 00000001b . 04520 01
d1d61		db	000h	; 00000000b . 04521 00
d1d62		db	000h	; 00000000b . 04522 00
d1d63		db	000h	; 00000000b . 04523 00
d1d64		db	000h	; 00000000b . 04524 00
d1d65		db	000h	; 00000000b . 04525 00
d1d66		db	000h	; 00000000b . 04526 00
d1d67		db	000h	; 00000000b . 04527 00
d1d68		db	000h	; 00000000b . 04528 00
d1d69		db	000h	; 00000000b . 04529 00
d1d6a		db	000h	; 00000000b . 0452a 00
d1d6b		db	000h	; 00000000b . 0452b 00
d1d6c		db	000h	; 00000000b . 0452c 00
d1d6d		db	000h	; 00000000b . 0452d 00
d1d6e		db	000h	; 00000000b . 0452e 00
d1d6f		db	000h	; 00000000b . 0452f 00
d1d70		db	000h	; 00000000b . 04530 00
d1d71		db	00fh	; 00001111b . 04531 0f
d1d72		db	000h	; 00000000b . 04532 00
d1d73		db	000h	; 00000000b . 04533 00
d1d74		db	03ch	; 00111100b < 04534 3c
d1d75		db	00fh	; 00001111b . 04535 0f
d1d76		db	0c0h	; 11000000b . 04536 c0
d1d77		db	000h	; 00000000b . 04537 00
d1d78		db	0fch	; 11111100b . 04538 fc
d1d79		db	00fh	; 00001111b . 04539 0f
d1d7a		db	0f0h	; 11110000b . 0453a f0
d1d7b		db	003h	; 00000011b . 0453b 03
d1d7c		db	0fch	; 11111100b . 0453c fc
d1d7d		db	00fh	; 00001111b . 0453d 0f
d1d7e		db	0fch	; 11111100b . 0453e fc
d1d7f		db	00fh	; 00001111b . 0453f 0f
d1d80		db	0fch	; 11111100b . 04540 fc
d1d81		db	00fh	; 00001111b . 04541 0f
d1d82		db	0ffh	; 11111111b . 04542 ff
d1d83		db	03fh	; 00111111b ? 04543 3f
d1d84		db	0fch	; 11111100b . 04544 fc
d1d85		db	003h	; 00000011b . 04545 03
d1d86		db	0ffh	; 11111111b . 04546 ff
d1d87		db	0ffh	; 11111111b . 04547 ff
d1d88		db	0f0h	; 11110000b . 04548 f0
d1d89		db	003h	; 00000011b . 04549 03
d1d8a		db	0ffh	; 11111111b . 0454a ff
d1d8b		db	0ffh	; 11111111b . 0454b ff
d1d8c		db	0f0h	; 11110000b . 0454c f0
d1d8d		db	000h	; 00000000b . 0454d 00
d1d8e		db	0ffh	; 11111111b . 0454e ff
d1d8f		db	0ffh	; 11111111b . 0454f ff
d1d90		db	0c0h	; 11000000b . 04550 c0
d1d91		db	000h	; 00000000b . 04551 00
d1d92		db	00fh	; 00001111b . 04552 0f
d1d93		db	0fch	; 11111100b . 04553 fc
d1d94		db	000h	; 00000000b . 04554 00
d1d95		db	000h	; 00000000b . 04555 00
d1d96		db	000h	; 00000000b . 04556 00
d1d97		db	000h	; 00000000b . 04557 00
d1d98		db	000h	; 00000000b . 04558 00
d1d99		db	000h	; 00000000b . 04559 00
d1d9a		db	000h	; 00000000b . 0455a 00
d1d9b		db	000h	; 00000000b . 0455b 00
d1d9c		db	000h	; 00000000b . 0455c 00
d1d9d		db	000h	; 00000000b . 0455d 00
d1d9e		db	0c0h	; 11000000b . 0455e c0
d1d9f		db	000h	; 00000000b . 0455f 00
d1da0		db	0c0h	; 11000000b . 04560 c0
d1da1		db	003h	; 00000011b . 04561 03
d1da2		db	0c0h	; 11000000b . 04562 c0
d1da3		db	000h	; 00000000b . 04563 00
d1da4		db	0f0h	; 11110000b . 04564 f0
d1da5		db	003h	; 00000011b . 04565 03
d1da6		db	0f0h	; 11110000b . 04566 f0
d1da7		db	003h	; 00000011b . 04567 03
d1da8		db	0f0h	; 11110000b . 04568 f0
d1da9		db	00fh	; 00001111b . 04569 0f
d1daa		db	0f0h	; 11110000b . 0456a f0
d1dab		db	003h	; 00000011b . 0456b 03
d1dac		db	0fch	; 11111100b . 0456c fc
d1dad		db	00fh	; 00001111b . 0456d 0f
d1dae		db	0fch	; 11111100b . 0456e fc
d1daf		db	00fh	; 00001111b . 0456f 0f
d1db0		db	0fch	; 11111100b . 04570 fc
d1db1		db	00fh	; 00001111b . 04571 0f
d1db2		db	0fch	; 11111100b . 04572 fc
d1db3		db	00fh	; 00001111b . 04573 0f
d1db4		db	0fch	; 11111100b . 04574 fc
d1db5		db	00fh	; 00001111b . 04575 0f
d1db6		db	0ffh	; 11111111b . 04576 ff
d1db7		db	03fh	; 00111111b ? 04577 3f
d1db8		db	0fch	; 11111100b . 04578 fc
d1db9		db	00fh	; 00001111b . 04579 0f
d1dba		db	0ffh	; 11111111b . 0457a ff
d1dbb		db	03fh	; 00111111b ? 0457b 3f
d1dbc		db	0fch	; 11111100b . 0457c fc
d1dbd		db	003h	; 00000011b . 0457d 03
d1dbe		db	0ffh	; 11111111b . 0457e ff
d1dbf		db	0ffh	; 11111111b . 0457f ff
d1dc0		db	0f0h	; 11110000b . 04580 f0
d1dc1		db	003h	; 00000011b . 04581 03
d1dc2		db	0ffh	; 11111111b . 04582 ff
d1dc3		db	0ffh	; 11111111b . 04583 ff
d1dc4		db	0f0h	; 11110000b . 04584 f0
d1dc5		db	000h	; 00000000b . 04585 00
d1dc6		db	0ffh	; 11111111b . 04586 ff
d1dc7		db	0ffh	; 11111111b . 04587 ff
d1dc8		db	0c0h	; 11000000b . 04588 c0
d1dc9		db	000h	; 00000000b . 04589 00
d1dca		db	00fh	; 00001111b . 0458a 0f
d1dcb		db	0fch	; 11111100b . 0458b fc
d1dcc		db	000h	; 00000000b . 0458c 00
d1dcd		db	000h	; 00000000b . 0458d 00
d1dce		db	000h	; 00000000b . 0458e 00
d1dcf		db	000h	; 00000000b . 0458f 00
d1dd0		db	000h	; 00000000b . 04590 00
d1dd1		db	000h	; 00000000b . 04591 00
d1dd2		db	00fh	; 00001111b . 04592 0f
d1dd3		db	0fch	; 11111100b . 04593 fc
d1dd4		db	000h	; 00000000b . 04594 00
d1dd5		db	000h	; 00000000b . 04595 00
d1dd6		db	0ffh	; 11111111b . 04596 ff
d1dd7		db	0ffh	; 11111111b . 04597 ff
d1dd8		db	0c0h	; 11000000b . 04598 c0
d1dd9		db	003h	; 00000011b . 04599 03
d1dda		db	0ffh	; 11111111b . 0459a ff
d1ddb		db	0ffh	; 11111111b . 0459b ff
d1ddc		db	0f0h	; 11110000b . 0459c f0
d1ddd		db	003h	; 00000011b . 0459d 03
d1dde		db	0ffh	; 11111111b . 0459e ff
d1ddf		db	0ffh	; 11111111b . 0459f ff
d1de0		db	0f0h	; 11110000b . 045a0 f0
d1de1		db	00fh	; 00001111b . 045a1 0f
d1de2		db	0ffh	; 11111111b . 045a2 ff
d1de3		db	0ffh	; 11111111b . 045a3 ff
d1de4		db	0fch	; 11111100b . 045a4 fc
d1de5		db	00fh	; 00001111b . 045a5 0f
d1de6		db	0ffh	; 11111111b . 045a6 ff
d1de7		db	0ffh	; 11111111b . 045a7 ff
d1de8		db	0fch	; 11111100b . 045a8 fc
d1de9		db	00fh	; 00001111b . 045a9 0f
d1dea		db	0ffh	; 11111111b . 045aa ff
d1deb		db	0ffh	; 11111111b . 045ab ff
d1dec		db	0fch	; 11111100b . 045ac fc
d1ded		db	00fh	; 00001111b . 045ad 0f
d1dee		db	0ffh	; 11111111b . 045ae ff
d1def		db	0ffh	; 11111111b . 045af ff
d1df0		db	0fch	; 11111100b . 045b0 fc
d1df1		db	00fh	; 00001111b . 045b1 0f
d1df2		db	0ffh	; 11111111b . 045b2 ff
d1df3		db	0ffh	; 11111111b . 045b3 ff
d1df4		db	0fch	; 11111100b . 045b4 fc
d1df5		db	003h	; 00000011b . 045b5 03
d1df6		db	0ffh	; 11111111b . 045b6 ff
d1df7		db	0ffh	; 11111111b . 045b7 ff
d1df8		db	0f0h	; 11110000b . 045b8 f0
d1df9		db	003h	; 00000011b . 045b9 03
d1dfa		db	0ffh	; 11111111b . 045ba ff
d1dfb		db	0ffh	; 11111111b . 045bb ff
d1dfc		db	0f0h	; 11110000b . 045bc f0
d1dfd		db	000h	; 00000000b . 045bd 00
d1dfe		db	0ffh	; 11111111b . 045be ff
d1dff		db	0ffh	; 11111111b . 045bf ff
d1e00		db	0c0h	; 11000000b . 045c0 c0
d1e01		db	000h	; 00000000b . 045c1 00
d1e02		db	00fh	; 00001111b . 045c2 0f
d1e03		db	0fch	; 11111100b . 045c3 fc
d1e04		db	000h	; 00000000b . 045c4 00
d1e05		db	000h	; 00000000b . 045c5 00
d1e06		db	000h	; 00000000b . 045c6 00
d1e07		db	000h	; 00000000b . 045c7 00
d1e08		db	000h	; 00000000b . 045c8 00
d1e09		db	000h	; 00000000b . 045c9 00
d1e0a		db	000h	; 00000000b . 045ca 00
d1e0b		db	000h	; 00000000b . 045cb 00
d1e0c		db	000h	; 00000000b . 045cc 00
d1e0d		db	000h	; 00000000b . 045cd 00
d1e0e		db	0c0h	; 11000000b . 045ce c0
d1e0f		db	000h	; 00000000b . 045cf 00
d1e10		db	0c0h	; 11000000b . 045d0 c0
d1e11		db	003h	; 00000011b . 045d1 03
d1e12		db	0c0h	; 11000000b . 045d2 c0
d1e13		db	000h	; 00000000b . 045d3 00
d1e14		db	0f0h	; 11110000b . 045d4 f0
d1e15		db	003h	; 00000011b . 045d5 03
d1e16		db	0f0h	; 11110000b . 045d6 f0
d1e17		db	003h	; 00000011b . 045d7 03
d1e18		db	0f0h	; 11110000b . 045d8 f0
d1e19		db	00fh	; 00001111b . 045d9 0f
d1e1a		db	0f0h	; 11110000b . 045da f0
d1e1b		db	003h	; 00000011b . 045db 03
d1e1c		db	0fch	; 11111100b . 045dc fc
d1e1d		db	00fh	; 00001111b . 045dd 0f
d1e1e		db	0fch	; 11111100b . 045de fc
d1e1f		db	00fh	; 00001111b . 045df 0f
d1e20		db	0fch	; 11111100b . 045e0 fc
d1e21		db	00fh	; 00001111b . 045e1 0f
d1e22		db	0fch	; 11111100b . 045e2 fc
d1e23		db	00fh	; 00001111b . 045e3 0f
d1e24		db	0fch	; 11111100b . 045e4 fc
d1e25		db	00fh	; 00001111b . 045e5 0f
d1e26		db	0ffh	; 11111111b . 045e6 ff
d1e27		db	03fh	; 00111111b ? 045e7 3f
d1e28		db	0fch	; 11111100b . 045e8 fc
d1e29		db	00fh	; 00001111b . 045e9 0f
d1e2a		db	0ffh	; 11111111b . 045ea ff
d1e2b		db	03fh	; 00111111b ? 045eb 3f
d1e2c		db	0fch	; 11111100b . 045ec fc
d1e2d		db	003h	; 00000011b . 045ed 03
d1e2e		db	0ffh	; 11111111b . 045ee ff
d1e2f		db	0ffh	; 11111111b . 045ef ff
d1e30		db	0f0h	; 11110000b . 045f0 f0
d1e31		db	003h	; 00000011b . 045f1 03
d1e32		db	0ffh	; 11111111b . 045f2 ff
d1e33		db	0ffh	; 11111111b . 045f3 ff
d1e34		db	0f0h	; 11110000b . 045f4 f0
d1e35		db	000h	; 00000000b . 045f5 00
d1e36		db	0ffh	; 11111111b . 045f6 ff
d1e37		db	0ffh	; 11111111b . 045f7 ff
d1e38		db	0c0h	; 11000000b . 045f8 c0
d1e39		db	000h	; 00000000b . 045f9 00
d1e3a		db	00fh	; 00001111b . 045fa 0f
d1e3b		db	0fch	; 11111100b . 045fb fc
d1e3c		db	000h	; 00000000b . 045fc 00
d1e3d		db	000h	; 00000000b . 045fd 00
d1e3e		db	000h	; 00000000b . 045fe 00
d1e3f		db	000h	; 00000000b . 045ff 00
d1e40		db	000h	; 00000000b . 04600 00
d1e41		db	000h	; 00000000b . 04601 00
d1e42		db	00fh	; 00001111b . 04602 0f
d1e43		db	0fch	; 11111100b . 04603 fc
d1e44		db	000h	; 00000000b . 04604 00
d1e45		db	000h	; 00000000b . 04605 00
d1e46		db	0ffh	; 11111111b . 04606 ff
d1e47		db	0ffh	; 11111111b . 04607 ff
d1e48		db	0c0h	; 11000000b . 04608 c0
d1e49		db	003h	; 00000011b . 04609 03
d1e4a		db	0ffh	; 11111111b . 0460a ff
d1e4b		db	0ffh	; 11111111b . 0460b ff
d1e4c		db	0f0h	; 11110000b . 0460c f0
d1e4d		db	003h	; 00000011b . 0460d 03
d1e4e		db	0ffh	; 11111111b . 0460e ff
d1e4f		db	0ffh	; 11111111b . 0460f ff
d1e50		db	0f0h	; 11110000b . 04610 f0
d1e51		db	00fh	; 00001111b . 04611 0f
d1e52		db	0ffh	; 11111111b . 04612 ff
d1e53		db	03fh	; 00111111b ? 04613 3f
d1e54		db	0fch	; 11111100b . 04614 fc
d1e55		db	00fh	; 00001111b . 04615 0f
d1e56		db	0fch	; 11111100b . 04616 fc
d1e57		db	00fh	; 00001111b . 04617 0f
d1e58		db	0fch	; 11111100b . 04618 fc
d1e59		db	00fh	; 00001111b . 04619 0f
d1e5a		db	0f0h	; 11110000b . 0461a f0
d1e5b		db	003h	; 00000011b . 0461b 03
d1e5c		db	0fch	; 11111100b . 0461c fc
d1e5d		db	00fh	; 00001111b . 0461d 0f
d1e5e		db	0c0h	; 11000000b . 0461e c0
d1e5f		db	000h	; 00000000b . 0461f 00
d1e60		db	0fch	; 11111100b . 04620 fc
d1e61		db	00fh	; 00001111b . 04621 0f
d1e62		db	000h	; 00000000b . 04622 00
d1e63		db	000h	; 00000000b . 04623 00
d1e64		db	03ch	; 00111100b < 04624 3c
d1e65		db	000h	; 00000000b . 04625 00
d1e66		db	000h	; 00000000b . 04626 00
d1e67		db	000h	; 00000000b . 04627 00
d1e68		db	000h	; 00000000b . 04628 00
d1e69		db	000h	; 00000000b . 04629 00
d1e6a		db	000h	; 00000000b . 0462a 00
d1e6b		db	000h	; 00000000b . 0462b 00
d1e6c		db	000h	; 00000000b . 0462c 00
d1e6d		db	000h	; 00000000b . 0462d 00
d1e6e		db	000h	; 00000000b . 0462e 00
d1e6f		db	000h	; 00000000b . 0462f 00
d1e70		db	000h	; 00000000b . 04630 00
d1e71		db	000h	; 00000000b . 04631 00
d1e72		db	000h	; 00000000b . 04632 00
d1e73		db	000h	; 00000000b . 04633 00
d1e74		db	000h	; 00000000b . 04634 00
d1e75		db	000h	; 00000000b . 04635 00
d1e76		db	000h	; 00000000b . 04636 00
d1e77		db	000h	; 00000000b . 04637 00
d1e78		db	000h	; 00000000b . 04638 00
d1e79		db	000h	; 00000000b . 04639 00
d1e7a		db	00fh	; 00001111b . 0463a 0f
d1e7b		db	0fch	; 11111100b . 0463b fc
d1e7c		db	000h	; 00000000b . 0463c 00
d1e7d		db	000h	; 00000000b . 0463d 00
d1e7e		db	0ffh	; 11111111b . 0463e ff
d1e7f		db	0ffh	; 11111111b . 0463f ff
d1e80		db	0c0h	; 11000000b . 04640 c0
d1e81		db	003h	; 00000011b . 04641 03
d1e82		db	0ffh	; 11111111b . 04642 ff
d1e83		db	0ffh	; 11111111b . 04643 ff
d1e84		db	0f0h	; 11110000b . 04644 f0
d1e85		db	003h	; 00000011b . 04645 03
d1e86		db	0ffh	; 11111111b . 04646 ff
d1e87		db	0ffh	; 11111111b . 04647 ff
d1e88		db	0f0h	; 11110000b . 04648 f0
d1e89		db	00fh	; 00001111b . 04649 0f
d1e8a		db	0ffh	; 11111111b . 0464a ff
d1e8b		db	03fh	; 00111111b ? 0464b 3f
d1e8c		db	0fch	; 11111100b . 0464c fc
d1e8d		db	00fh	; 00001111b . 0464d 0f
d1e8e		db	0ffh	; 11111111b . 0464e ff
d1e8f		db	03fh	; 00111111b ? 0464f 3f
d1e90		db	0fch	; 11111100b . 04650 fc
d1e91		db	00fh	; 00001111b . 04651 0f
d1e92		db	0fch	; 11111100b . 04652 fc
d1e93		db	00fh	; 00001111b . 04653 0f
d1e94		db	0fch	; 11111100b . 04654 fc
d1e95		db	00fh	; 00001111b . 04655 0f
d1e96		db	0fch	; 11111100b . 04656 fc
d1e97		db	00fh	; 00001111b . 04657 0f
d1e98		db	0fch	; 11111100b . 04658 fc
d1e99		db	00fh	; 00001111b . 04659 0f
d1e9a		db	0f0h	; 11110000b . 0465a f0
d1e9b		db	003h	; 00000011b . 0465b 03
d1e9c		db	0fch	; 11111100b . 0465c fc
d1e9d		db	003h	; 00000011b . 0465d 03
d1e9e		db	0f0h	; 11110000b . 0465e f0
d1e9f		db	003h	; 00000011b . 0465f 03
d1ea0		db	0f0h	; 11110000b . 04660 f0
d1ea1		db	003h	; 00000011b . 04661 03
d1ea2		db	0c0h	; 11000000b . 04662 c0
d1ea3		db	000h	; 00000000b . 04663 00
d1ea4		db	0f0h	; 11110000b . 04664 f0
d1ea5		db	000h	; 00000000b . 04665 00
d1ea6		db	0c0h	; 11000000b . 04666 c0
d1ea7		db	000h	; 00000000b . 04667 00
d1ea8		db	0c0h	; 11000000b . 04668 c0
d1ea9		db	000h	; 00000000b . 04669 00
d1eaa		db	000h	; 00000000b . 0466a 00
d1eab		db	000h	; 00000000b . 0466b 00
d1eac		db	000h	; 00000000b . 0466c 00
d1ead		db	000h	; 00000000b . 0466d 00
d1eae		db	000h	; 00000000b . 0466e 00
d1eaf		db	000h	; 00000000b . 0466f 00
d1eb0		db	000h	; 00000000b . 04670 00
d1eb1		db	000h	; 00000000b . 04671 00
d1eb2		db	00fh	; 00001111b . 04672 0f
d1eb3		db	0fch	; 11111100b . 04673 fc
d1eb4		db	000h	; 00000000b . 04674 00
d1eb5		db	000h	; 00000000b . 04675 00
d1eb6		db	0ffh	; 11111111b . 04676 ff
d1eb7		db	0ffh	; 11111111b . 04677 ff
d1eb8		db	0c0h	; 11000000b . 04678 c0
d1eb9		db	003h	; 00000011b . 04679 03
d1eba		db	0ffh	; 11111111b . 0467a ff
d1ebb		db	0ffh	; 11111111b . 0467b ff
d1ebc		db	0f0h	; 11110000b . 0467c f0
d1ebd		db	003h	; 00000011b . 0467d 03
d1ebe		db	0ffh	; 11111111b . 0467e ff
d1ebf		db	0ffh	; 11111111b . 0467f ff
d1ec0		db	0f0h	; 11110000b . 04680 f0
d1ec1		db	00fh	; 00001111b . 04681 0f
d1ec2		db	0ffh	; 11111111b . 04682 ff
d1ec3		db	0ffh	; 11111111b . 04683 ff
d1ec4		db	0fch	; 11111100b . 04684 fc
d1ec5		db	00fh	; 00001111b . 04685 0f
d1ec6		db	0ffh	; 11111111b . 04686 ff
d1ec7		db	0ffh	; 11111111b . 04687 ff
d1ec8		db	0fch	; 11111100b . 04688 fc
d1ec9		db	00fh	; 00001111b . 04689 0f
d1eca		db	0ffh	; 11111111b . 0468a ff
d1ecb		db	0ffh	; 11111111b . 0468b ff
d1ecc		db	0fch	; 11111100b . 0468c fc
d1ecd		db	00fh	; 00001111b . 0468d 0f
d1ece		db	0ffh	; 11111111b . 0468e ff
d1ecf		db	0ffh	; 11111111b . 0468f ff
d1ed0		db	0fch	; 11111100b . 04690 fc
d1ed1		db	00fh	; 00001111b . 04691 0f
d1ed2		db	0ffh	; 11111111b . 04692 ff
d1ed3		db	0ffh	; 11111111b . 04693 ff
d1ed4		db	0fch	; 11111100b . 04694 fc
d1ed5		db	003h	; 00000011b . 04695 03
d1ed6		db	0ffh	; 11111111b . 04696 ff
d1ed7		db	0ffh	; 11111111b . 04697 ff
d1ed8		db	0f0h	; 11110000b . 04698 f0
d1ed9		db	003h	; 00000011b . 04699 03
d1eda		db	0ffh	; 11111111b . 0469a ff
d1edb		db	0ffh	; 11111111b . 0469b ff
d1edc		db	0f0h	; 11110000b . 0469c f0
d1edd		db	000h	; 00000000b . 0469d 00
d1ede		db	0ffh	; 11111111b . 0469e ff
d1edf		db	0ffh	; 11111111b . 0469f ff
d1ee0		db	0c0h	; 11000000b . 046a0 c0
d1ee1		db	000h	; 00000000b . 046a1 00
d1ee2		db	00fh	; 00001111b . 046a2 0f
d1ee3		db	0fch	; 11111100b . 046a3 fc
d1ee4		db	000h	; 00000000b . 046a4 00
d1ee5		db	000h	; 00000000b . 046a5 00
d1ee6		db	000h	; 00000000b . 046a6 00
d1ee7		db	000h	; 00000000b . 046a7 00
d1ee8		db	000h	; 00000000b . 046a8 00
d1ee9		db	000h	; 00000000b . 046a9 00
d1eea		db	00fh	; 00001111b . 046aa 0f
d1eeb		db	0fch	; 11111100b . 046ab fc
d1eec		db	000h	; 00000000b . 046ac 00
d1eed		db	000h	; 00000000b . 046ad 00
d1eee		db	0ffh	; 11111111b . 046ae ff
d1eef		db	0ffh	; 11111111b . 046af ff
d1ef0		db	0c0h	; 11000000b . 046b0 c0
d1ef1		db	003h	; 00000011b . 046b1 03
d1ef2		db	0ffh	; 11111111b . 046b2 ff
d1ef3		db	0ffh	; 11111111b . 046b3 ff
d1ef4		db	0f0h	; 11110000b . 046b4 f0
d1ef5		db	003h	; 00000011b . 046b5 03
d1ef6		db	0ffh	; 11111111b . 046b6 ff
d1ef7		db	0ffh	; 11111111b . 046b7 ff
d1ef8		db	0f0h	; 11110000b . 046b8 f0
d1ef9		db	00fh	; 00001111b . 046b9 0f
d1efa		db	0ffh	; 11111111b . 046ba ff
d1efb		db	03fh	; 00111111b ? 046bb 3f
d1efc		db	0fch	; 11111100b . 046bc fc
d1efd		db	00fh	; 00001111b . 046bd 0f
d1efe		db	0ffh	; 11111111b . 046be ff
d1eff		db	03fh	; 00111111b ? 046bf 3f
d1f00		db	0fch	; 11111100b . 046c0 fc
d1f01		db	00fh	; 00001111b . 046c1 0f
d1f02		db	0fch	; 11111100b . 046c2 fc
d1f03		db	00fh	; 00001111b . 046c3 0f
d1f04		db	0fch	; 11111100b . 046c4 fc
d1f05		db	00fh	; 00001111b . 046c5 0f
d1f06		db	0fch	; 11111100b . 046c6 fc
d1f07		db	00fh	; 00001111b . 046c7 0f
d1f08		db	0fch	; 11111100b . 046c8 fc
d1f09		db	00fh	; 00001111b . 046c9 0f
d1f0a		db	0f0h	; 11110000b . 046ca f0
d1f0b		db	003h	; 00000011b . 046cb 03
d1f0c		db	0fch	; 11111100b . 046cc fc
d1f0d		db	003h	; 00000011b . 046cd 03
d1f0e		db	0f0h	; 11110000b . 046ce f0
d1f0f		db	003h	; 00000011b . 046cf 03
d1f10		db	0f0h	; 11110000b . 046d0 f0
d1f11		db	003h	; 00000011b . 046d1 03
d1f12		db	0c0h	; 11000000b . 046d2 c0
d1f13		db	000h	; 00000000b . 046d3 00
d1f14		db	0f0h	; 11110000b . 046d4 f0
d1f15		db	000h	; 00000000b . 046d5 00
d1f16		db	0c0h	; 11000000b . 046d6 c0
d1f17		db	000h	; 00000000b . 046d7 00
d1f18		db	0c0h	; 11000000b . 046d8 c0
d1f19		db	000h	; 00000000b . 046d9 00
d1f1a		db	000h	; 00000000b . 046da 00
d1f1b		db	000h	; 00000000b . 046db 00
d1f1c		db	000h	; 00000000b . 046dc 00
d1f1d		db	000h	; 00000000b . 046dd 00
d1f1e		db	000h	; 00000000b . 046de 00
d1f1f		db	000h	; 00000000b . 046df 00
d1f20		db	000h	; 00000000b . 046e0 00
d1f21		db	000h	; 00000000b . 046e1 00
d1f22		db	00fh	; 00001111b . 046e2 0f
d1f23		db	0fch	; 11111100b . 046e3 fc
d1f24		db	000h	; 00000000b . 046e4 00
d1f25		db	000h	; 00000000b . 046e5 00
d1f26		db	00fh	; 00001111b . 046e6 0f
d1f27		db	0ffh	; 11111111b . 046e7 ff
d1f28		db	0c0h	; 11000000b . 046e8 c0
d1f29		db	000h	; 00000000b . 046e9 00
d1f2a		db	003h	; 00000011b . 046ea 03
d1f2b		db	0ffh	; 11111111b . 046eb ff
d1f2c		db	0f0h	; 11110000b . 046ec f0
d1f2d		db	000h	; 00000000b . 046ed 00
d1f2e		db	000h	; 00000000b . 046ee 00
d1f2f		db	0ffh	; 11111111b . 046ef ff
d1f30		db	0f0h	; 11110000b . 046f0 f0
d1f31		db	000h	; 00000000b . 046f1 00
d1f32		db	000h	; 00000000b . 046f2 00
d1f33		db	03fh	; 00111111b ? 046f3 3f
d1f34		db	0fch	; 11111100b . 046f4 fc
d1f35		db	000h	; 00000000b . 046f5 00
d1f36		db	000h	; 00000000b . 046f6 00
d1f37		db	00fh	; 00001111b . 046f7 0f
d1f38		db	0fch	; 11111100b . 046f8 fc
d1f39		db	000h	; 00000000b . 046f9 00
d1f3a		db	000h	; 00000000b . 046fa 00
d1f3b		db	003h	; 00000011b . 046fb 03
d1f3c		db	0fch	; 11111100b . 046fc fc
d1f3d		db	000h	; 00000000b . 046fd 00
d1f3e		db	000h	; 00000000b . 046fe 00
d1f3f		db	00fh	; 00001111b . 046ff 0f
d1f40		db	0fch	; 11111100b . 04700 fc
d1f41		db	000h	; 00000000b . 04701 00
d1f42		db	000h	; 00000000b . 04702 00
d1f43		db	03fh	; 00111111b ? 04703 3f
d1f44		db	0fch	; 11111100b . 04704 fc
d1f45		db	000h	; 00000000b . 04705 00
d1f46		db	000h	; 00000000b . 04706 00
d1f47		db	0ffh	; 11111111b . 04707 ff
d1f48		db	0f0h	; 11110000b . 04708 f0
d1f49		db	000h	; 00000000b . 04709 00
d1f4a		db	003h	; 00000011b . 0470a 03
d1f4b		db	0ffh	; 11111111b . 0470b ff
d1f4c		db	0f0h	; 11110000b . 0470c f0
d1f4d		db	000h	; 00000000b . 0470d 00
d1f4e		db	00fh	; 00001111b . 0470e 0f
d1f4f		db	0ffh	; 11111111b . 0470f ff
d1f50		db	0c0h	; 11000000b . 04710 c0
d1f51		db	000h	; 00000000b . 04711 00
d1f52		db	00fh	; 00001111b . 04712 0f
d1f53		db	0fch	; 11111100b . 04713 fc
d1f54		db	000h	; 00000000b . 04714 00
d1f55		db	000h	; 00000000b . 04715 00
d1f56		db	000h	; 00000000b . 04716 00
d1f57		db	000h	; 00000000b . 04717 00
d1f58		db	000h	; 00000000b . 04718 00
d1f59		db	000h	; 00000000b . 04719 00
d1f5a		db	00fh	; 00001111b . 0471a 0f
d1f5b		db	0fch	; 11111100b . 0471b fc
d1f5c		db	000h	; 00000000b . 0471c 00
d1f5d		db	000h	; 00000000b . 0471d 00
d1f5e		db	0ffh	; 11111111b . 0471e ff
d1f5f		db	0ffh	; 11111111b . 0471f ff
d1f60		db	0c0h	; 11000000b . 04720 c0
d1f61		db	003h	; 00000011b . 04721 03
d1f62		db	0ffh	; 11111111b . 04722 ff
d1f63		db	0ffh	; 11111111b . 04723 ff
d1f64		db	0f0h	; 11110000b . 04724 f0
d1f65		db	000h	; 00000000b . 04725 00
d1f66		db	03fh	; 00111111b ? 04726 3f
d1f67		db	0ffh	; 11111111b . 04727 ff
d1f68		db	0f0h	; 11110000b . 04728 f0
d1f69		db	000h	; 00000000b . 04729 00
d1f6a		db	003h	; 00000011b . 0472a 03
d1f6b		db	0ffh	; 11111111b . 0472b ff
d1f6c		db	0fch	; 11111100b . 0472c fc
d1f6d		db	000h	; 00000000b . 0472d 00
d1f6e		db	000h	; 00000000b . 0472e 00
d1f6f		db	03fh	; 00111111b ? 0472f 3f
d1f70		db	0fch	; 11111100b . 04730 fc
d1f71		db	000h	; 00000000b . 04731 00
d1f72		db	000h	; 00000000b . 04732 00
d1f73		db	003h	; 00000011b . 04733 03
d1f74		db	0fch	; 11111100b . 04734 fc
d1f75		db	000h	; 00000000b . 04735 00
d1f76		db	000h	; 00000000b . 04736 00
d1f77		db	03fh	; 00111111b ? 04737 3f
d1f78		db	0fch	; 11111100b . 04738 fc
d1f79		db	000h	; 00000000b . 04739 00
d1f7a		db	003h	; 00000011b . 0473a 03
d1f7b		db	0ffh	; 11111111b . 0473b ff
d1f7c		db	0fch	; 11111100b . 0473c fc
d1f7d		db	000h	; 00000000b . 0473d 00
d1f7e		db	03fh	; 00111111b ? 0473e 3f
d1f7f		db	0ffh	; 11111111b . 0473f ff
d1f80		db	0f0h	; 11110000b . 04740 f0
d1f81		db	003h	; 00000011b . 04741 03
d1f82		db	0ffh	; 11111111b . 04742 ff
d1f83		db	0ffh	; 11111111b . 04743 ff
d1f84		db	0f0h	; 11110000b . 04744 f0
d1f85		db	000h	; 00000000b . 04745 00
d1f86		db	0ffh	; 11111111b . 04746 ff
d1f87		db	0ffh	; 11111111b . 04747 ff
d1f88		db	0c0h	; 11000000b . 04748 c0
d1f89		db	000h	; 00000000b . 04749 00
d1f8a		db	00fh	; 00001111b . 0474a 0f
d1f8b		db	0fch	; 11111100b . 0474b fc
d1f8c		db	000h	; 00000000b . 0474c 00
d1f8d		db	000h	; 00000000b . 0474d 00
d1f8e		db	000h	; 00000000b . 0474e 00
d1f8f		db	000h	; 00000000b . 0474f 00
d1f90		db	000h	; 00000000b . 04750 00
d1f91		db	000h	; 00000000b . 04751 00
d1f92		db	00fh	; 00001111b . 04752 0f
d1f93		db	0fch	; 11111100b . 04753 fc
d1f94		db	000h	; 00000000b . 04754 00
d1f95		db	000h	; 00000000b . 04755 00
d1f96		db	0ffh	; 11111111b . 04756 ff
d1f97		db	0ffh	; 11111111b . 04757 ff
d1f98		db	0c0h	; 11000000b . 04758 c0
d1f99		db	003h	; 00000011b . 04759 03
d1f9a		db	0ffh	; 11111111b . 0475a ff
d1f9b		db	0ffh	; 11111111b . 0475b ff
d1f9c		db	0f0h	; 11110000b . 0475c f0
d1f9d		db	003h	; 00000011b . 0475d 03
d1f9e		db	0ffh	; 11111111b . 0475e ff
d1f9f		db	0ffh	; 11111111b . 0475f ff
d1fa0		db	0f0h	; 11110000b . 04760 f0
d1fa1		db	00fh	; 00001111b . 04761 0f
d1fa2		db	0ffh	; 11111111b . 04762 ff
d1fa3		db	0ffh	; 11111111b . 04763 ff
d1fa4		db	0fch	; 11111100b . 04764 fc
d1fa5		db	00fh	; 00001111b . 04765 0f
d1fa6		db	0ffh	; 11111111b . 04766 ff
d1fa7		db	0ffh	; 11111111b . 04767 ff
d1fa8		db	0fch	; 11111100b . 04768 fc
d1fa9		db	00fh	; 00001111b . 04769 0f
d1faa		db	0ffh	; 11111111b . 0476a ff
d1fab		db	0ffh	; 11111111b . 0476b ff
d1fac		db	0fch	; 11111100b . 0476c fc
d1fad		db	00fh	; 00001111b . 0476d 0f
d1fae		db	0ffh	; 11111111b . 0476e ff
d1faf		db	0ffh	; 11111111b . 0476f ff
d1fb0		db	0fch	; 11111100b . 04770 fc
d1fb1		db	00fh	; 00001111b . 04771 0f
d1fb2		db	0ffh	; 11111111b . 04772 ff
d1fb3		db	0ffh	; 11111111b . 04773 ff
d1fb4		db	0fch	; 11111100b . 04774 fc
d1fb5		db	003h	; 00000011b . 04775 03
d1fb6		db	0ffh	; 11111111b . 04776 ff
d1fb7		db	0ffh	; 11111111b . 04777 ff
d1fb8		db	0f0h	; 11110000b . 04778 f0
d1fb9		db	003h	; 00000011b . 04779 03
d1fba		db	0ffh	; 11111111b . 0477a ff
d1fbb		db	0ffh	; 11111111b . 0477b ff
d1fbc		db	0f0h	; 11110000b . 0477c f0
d1fbd		db	000h	; 00000000b . 0477d 00
d1fbe		db	0ffh	; 11111111b . 0477e ff
d1fbf		db	0ffh	; 11111111b . 0477f ff
d1fc0		db	0c0h	; 11000000b . 04780 c0
d1fc1		db	000h	; 00000000b . 04781 00
d1fc2		db	00fh	; 00001111b . 04782 0f
d1fc3		db	0fch	; 11111100b . 04783 fc
d1fc4		db	000h	; 00000000b . 04784 00
d1fc5		db	000h	; 00000000b . 04785 00
d1fc6		db	000h	; 00000000b . 04786 00
d1fc7		db	000h	; 00000000b . 04787 00
d1fc8		db	000h	; 00000000b . 04788 00
d1fc9		db	000h	; 00000000b . 04789 00
d1fca		db	00fh	; 00001111b . 0478a 0f
d1fcb		db	0fch	; 11111100b . 0478b fc
d1fcc		db	000h	; 00000000b . 0478c 00
d1fcd		db	000h	; 00000000b . 0478d 00
d1fce		db	0ffh	; 11111111b . 0478e ff
d1fcf		db	0ffh	; 11111111b . 0478f ff
d1fd0		db	0c0h	; 11000000b . 04790 c0
d1fd1		db	003h	; 00000011b . 04791 03
d1fd2		db	0ffh	; 11111111b . 04792 ff
d1fd3		db	0ffh	; 11111111b . 04793 ff
d1fd4		db	0f0h	; 11110000b . 04794 f0
d1fd5		db	000h	; 00000000b . 04795 00
d1fd6		db	03fh	; 00111111b ? 04796 3f
d1fd7		db	0ffh	; 11111111b . 04797 ff
d1fd8		db	0f0h	; 11110000b . 04798 f0
d1fd9		db	000h	; 00000000b . 04799 00
d1fda		db	003h	; 00000011b . 0479a 03
d1fdb		db	0ffh	; 11111111b . 0479b ff
d1fdc		db	0fch	; 11111100b . 0479c fc
d1fdd		db	000h	; 00000000b . 0479d 00
d1fde		db	000h	; 00000000b . 0479e 00
d1fdf		db	03fh	; 00111111b ? 0479f 3f
d1fe0		db	0fch	; 11111100b . 047a0 fc
d1fe1		db	000h	; 00000000b . 047a1 00
d1fe2		db	000h	; 00000000b . 047a2 00
d1fe3		db	003h	; 00000011b . 047a3 03
d1fe4		db	0fch	; 11111100b . 047a4 fc
d1fe5		db	000h	; 00000000b . 047a5 00
d1fe6		db	000h	; 00000000b . 047a6 00
d1fe7		db	03fh	; 00111111b ? 047a7 3f
d1fe8		db	0fch	; 11111100b . 047a8 fc
d1fe9		db	000h	; 00000000b . 047a9 00
d1fea		db	003h	; 00000011b . 047aa 03
d1feb		db	0ffh	; 11111111b . 047ab ff
d1fec		db	0fch	; 11111100b . 047ac fc
d1fed		db	000h	; 00000000b . 047ad 00
d1fee		db	03fh	; 00111111b ? 047ae 3f
d1fef		db	0ffh	; 11111111b . 047af ff
d1ff0		db	0f0h	; 11110000b . 047b0 f0
d1ff1		db	003h	; 00000011b . 047b1 03
d1ff2		db	0ffh	; 11111111b . 047b2 ff
d1ff3		db	0ffh	; 11111111b . 047b3 ff
d1ff4		db	0f0h	; 11110000b . 047b4 f0
d1ff5		db	000h	; 00000000b . 047b5 00
d1ff6		db	0ffh	; 11111111b . 047b6 ff
d1ff7		db	0ffh	; 11111111b . 047b7 ff
d1ff8		db	0c0h	; 11000000b . 047b8 c0
d1ff9		db	000h	; 00000000b . 047b9 00
d1ffa		db	00fh	; 00001111b . 047ba 0f
d1ffb		db	0fch	; 11111100b . 047bb fc
d1ffc		db	000h	; 00000000b . 047bc 00
d1ffd		db	000h	; 00000000b . 047bd 00
d1ffe		db	000h	; 00000000b . 047be 00
d1fff		db	000h	; 00000000b . 047bf 00
d2000		db	000h	; 00000000b . 047c0 00
d2001		db	000h	; 00000000b . 047c1 00
d2002		db	00fh	; 00001111b . 047c2 0f
d2003		db	0fch	; 11111100b . 047c3 fc
d2004		db	000h	; 00000000b . 047c4 00
d2005		db	000h	; 00000000b . 047c5 00
d2006		db	0ffh	; 11111111b . 047c6 ff
d2007		db	0fch	; 11111100b . 047c7 fc
d2008		db	000h	; 00000000b . 047c8 00
d2009		db	003h	; 00000011b . 047c9 03
d200a		db	0ffh	; 11111111b . 047ca ff
d200b		db	0f0h	; 11110000b . 047cb f0
d200c		db	000h	; 00000000b . 047cc 00
d200d		db	003h	; 00000011b . 047cd 03
d200e		db	0ffh	; 11111111b . 047ce ff
d200f		db	0c0h	; 11000000b . 047cf c0
d2010		db	000h	; 00000000b . 047d0 00
d2011		db	00fh	; 00001111b . 047d1 0f
d2012		db	0ffh	; 11111111b . 047d2 ff
d2013		db	000h	; 00000000b . 047d3 00
d2014		db	000h	; 00000000b . 047d4 00
d2015		db	00fh	; 00001111b . 047d5 0f
d2016		db	0fch	; 11111100b . 047d6 fc
d2017		db	000h	; 00000000b . 047d7 00
d2018		db	000h	; 00000000b . 047d8 00
d2019		db	00fh	; 00001111b . 047d9 0f
d201a		db	0f0h	; 11110000b . 047da f0
d201b		db	000h	; 00000000b . 047db 00
d201c		db	000h	; 00000000b . 047dc 00
d201d		db	00fh	; 00001111b . 047dd 0f
d201e		db	0fch	; 11111100b . 047de fc
d201f		db	000h	; 00000000b . 047df 00
d2020		db	000h	; 00000000b . 047e0 00
d2021		db	00fh	; 00001111b . 047e1 0f
d2022		db	0ffh	; 11111111b . 047e2 ff
d2023		db	000h	; 00000000b . 047e3 00
d2024		db	000h	; 00000000b . 047e4 00
d2025		db	003h	; 00000011b . 047e5 03
d2026		db	0ffh	; 11111111b . 047e6 ff
d2027		db	0c0h	; 11000000b . 047e7 c0
d2028		db	000h	; 00000000b . 047e8 00
d2029		db	003h	; 00000011b . 047e9 03
d202a		db	0ffh	; 11111111b . 047ea ff
d202b		db	0f0h	; 11110000b . 047eb f0
d202c		db	000h	; 00000000b . 047ec 00
d202d		db	000h	; 00000000b . 047ed 00
d202e		db	0ffh	; 11111111b . 047ee ff
d202f		db	0fch	; 11111100b . 047ef fc
d2030		db	000h	; 00000000b . 047f0 00
d2031		db	000h	; 00000000b . 047f1 00
d2032		db	00fh	; 00001111b . 047f2 0f
d2033		db	0fch	; 11111100b . 047f3 fc
d2034		db	000h	; 00000000b . 047f4 00
d2035		db	000h	; 00000000b . 047f5 00
d2036		db	000h	; 00000000b . 047f6 00
d2037		db	000h	; 00000000b . 047f7 00
d2038		db	000h	; 00000000b . 047f8 00
d2039		db	000h	; 00000000b . 047f9 00
d203a		db	00fh	; 00001111b . 047fa 0f
d203b		db	0fch	; 11111100b . 047fb fc
d203c		db	000h	; 00000000b . 047fc 00
d203d		db	000h	; 00000000b . 047fd 00
d203e		db	0ffh	; 11111111b . 047fe ff
d203f		db	0ffh	; 11111111b . 047ff ff

_TRK3_DATA	ends

_TRK4_SCTR1	segment	para public 'DATA'
		; Sector 1                    04600 F6 X0200
		db	512 dup (246)
_TRK4_SCTR1	ends

_TRK4_DATA	segment	para public 'DATA'
		org	2040h

d2040		db	0c0h	; 11000000b . 04a00 c0
d2041		db	003h	; 00000011b . 04a01 03
d2042		db	0ffh	; 11111111b . 04a02 ff
d2043		db	0ffh	; 11111111b . 04a03 ff
d2044		db	0f0h	; 11110000b . 04a04 f0
d2045		db	003h	; 00000011b . 04a05 03
d2046		db	0ffh	; 11111111b . 04a06 ff
d2047		db	0ffh	; 11111111b . 04a07 ff
d2048		db	000h	; 00000000b . 04a08 00
d2049		db	00fh	; 00001111b . 04a09 0f
d204a		db	0ffh	; 11111111b . 04a0a ff
d204b		db	0f0h	; 11110000b . 04a0b f0
d204c		db	000h	; 00000000b . 04a0c 00
d204d		db	00fh	; 00001111b . 04a0d 0f
d204e		db	0ffh	; 11111111b . 04a0e ff
d204f		db	000h	; 00000000b . 04a0f 00
d2050		db	000h	; 00000000b . 04a10 00
d2051		db	00fh	; 00001111b . 04a11 0f
d2052		db	0f0h	; 11110000b . 04a12 f0
d2053		db	000h	; 00000000b . 04a13 00
d2054		db	000h	; 00000000b . 04a14 00
d2055		db	00fh	; 00001111b . 04a15 0f
d2056		db	0ffh	; 11111111b . 04a16 ff
d2057		db	000h	; 00000000b . 04a17 00
d2058		db	000h	; 00000000b . 04a18 00
d2059		db	00fh	; 00001111b . 04a19 0f
d205a		db	0ffh	; 11111111b . 04a1a ff
d205b		db	0f0h	; 11110000b . 04a1b f0
d205c		db	000h	; 00000000b . 04a1c 00
d205d		db	003h	; 00000011b . 04a1d 03
d205e		db	0ffh	; 11111111b . 04a1e ff
d205f		db	0ffh	; 11111111b . 04a1f ff
d2060		db	000h	; 00000000b . 04a20 00
d2061		db	003h	; 00000011b . 04a21 03
d2062		db	0ffh	; 11111111b . 04a22 ff
d2063		db	0ffh	; 11111111b . 04a23 ff
d2064		db	0f0h	; 11110000b . 04a24 f0
d2065		db	000h	; 00000000b . 04a25 00
d2066		db	0ffh	; 11111111b . 04a26 ff
d2067		db	0ffh	; 11111111b . 04a27 ff
d2068		db	0c0h	; 11000000b . 04a28 c0
d2069		db	000h	; 00000000b . 04a29 00
d206a		db	00fh	; 00001111b . 04a2a 0f
d206b		db	0fch	; 11111100b . 04a2b fc
d206c		db	000h	; 00000000b . 04a2c 00
d206d		db	000h	; 00000000b . 04a2d 00
d206e		db	000h	; 00000000b . 04a2e 00
d206f		db	000h	; 00000000b . 04a2f 00
d2070		db	000h	; 00000000b . 04a30 00
d2071		db	000h	; 00000000b . 04a31 00
d2072		db	00fh	; 00001111b . 04a32 0f
d2073		db	0fch	; 11111100b . 04a33 fc
d2074		db	000h	; 00000000b . 04a34 00
d2075		db	000h	; 00000000b . 04a35 00
d2076		db	0ffh	; 11111111b . 04a36 ff
d2077		db	0ffh	; 11111111b . 04a37 ff
d2078		db	0c0h	; 11000000b . 04a38 c0
d2079		db	003h	; 00000011b . 04a39 03
d207a		db	0ffh	; 11111111b . 04a3a ff
d207b		db	0ffh	; 11111111b . 04a3b ff
d207c		db	0f0h	; 11110000b . 04a3c f0
d207d		db	003h	; 00000011b . 04a3d 03
d207e		db	0ffh	; 11111111b . 04a3e ff
d207f		db	0ffh	; 11111111b . 04a3f ff
d2080		db	0f0h	; 11110000b . 04a40 f0
d2081		db	00fh	; 00001111b . 04a41 0f
d2082		db	0ffh	; 11111111b . 04a42 ff
d2083		db	0ffh	; 11111111b . 04a43 ff
d2084		db	0fch	; 11111100b . 04a44 fc
d2085		db	00fh	; 00001111b . 04a45 0f
d2086		db	0ffh	; 11111111b . 04a46 ff
d2087		db	0ffh	; 11111111b . 04a47 ff
d2088		db	0fch	; 11111100b . 04a48 fc
d2089		db	00fh	; 00001111b . 04a49 0f
d208a		db	0ffh	; 11111111b . 04a4a ff
d208b		db	0ffh	; 11111111b . 04a4b ff
d208c		db	0fch	; 11111100b . 04a4c fc
d208d		db	00fh	; 00001111b . 04a4d 0f
d208e		db	0ffh	; 11111111b . 04a4e ff
d208f		db	0ffh	; 11111111b . 04a4f ff
d2090		db	0fch	; 11111100b . 04a50 fc
d2091		db	00fh	; 00001111b . 04a51 0f
d2092		db	0ffh	; 11111111b . 04a52 ff
d2093		db	0ffh	; 11111111b . 04a53 ff
d2094		db	0fch	; 11111100b . 04a54 fc
d2095		db	003h	; 00000011b . 04a55 03
d2096		db	0ffh	; 11111111b . 04a56 ff
d2097		db	0ffh	; 11111111b . 04a57 ff
d2098		db	0f0h	; 11110000b . 04a58 f0
d2099		db	003h	; 00000011b . 04a59 03
d209a		db	0ffh	; 11111111b . 04a5a ff
d209b		db	0ffh	; 11111111b . 04a5b ff
d209c		db	0f0h	; 11110000b . 04a5c f0
d209d		db	000h	; 00000000b . 04a5d 00
d209e		db	0ffh	; 11111111b . 04a5e ff
d209f		db	0ffh	; 11111111b . 04a5f ff
d20a0		db	0c0h	; 11000000b . 04a60 c0
d20a1		db	000h	; 00000000b . 04a61 00
d20a2		db	00fh	; 00001111b . 04a62 0f
d20a3		db	0fch	; 11111100b . 04a63 fc
d20a4		db	000h	; 00000000b . 04a64 00
d20a5		db	000h	; 00000000b . 04a65 00
d20a6		db	000h	; 00000000b . 04a66 00
d20a7		db	000h	; 00000000b . 04a67 00
d20a8		db	000h	; 00000000b . 04a68 00
d20a9		db	000h	; 00000000b . 04a69 00
d20aa		db	00fh	; 00001111b . 04a6a 0f
d20ab		db	0fch	; 11111100b . 04a6b fc
d20ac		db	000h	; 00000000b . 04a6c 00
d20ad		db	000h	; 00000000b . 04a6d 00
d20ae		db	0ffh	; 11111111b . 04a6e ff
d20af		db	0ffh	; 11111111b . 04a6f ff
d20b0		db	0c0h	; 11000000b . 04a70 c0
d20b1		db	003h	; 00000011b . 04a71 03
d20b2		db	0ffh	; 11111111b . 04a72 ff
d20b3		db	0ffh	; 11111111b . 04a73 ff
d20b4		db	0f0h	; 11110000b . 04a74 f0
d20b5		db	003h	; 00000011b . 04a75 03
d20b6		db	0ffh	; 11111111b . 04a76 ff
d20b7		db	0ffh	; 11111111b . 04a77 ff
d20b8		db	000h	; 00000000b . 04a78 00
d20b9		db	00fh	; 00001111b . 04a79 0f
d20ba		db	0ffh	; 11111111b . 04a7a ff
d20bb		db	0f0h	; 11110000b . 04a7b f0
d20bc		db	000h	; 00000000b . 04a7c 00
d20bd		db	00fh	; 00001111b . 04a7d 0f
d20be		db	0ffh	; 11111111b . 04a7e ff
d20bf		db	000h	; 00000000b . 04a7f 00
d20c0		db	000h	; 00000000b . 04a80 00
d20c1		db	00fh	; 00001111b . 04a81 0f
d20c2		db	0f0h	; 11110000b . 04a82 f0
d20c3		db	000h	; 00000000b . 04a83 00
d20c4		db	000h	; 00000000b . 04a84 00
d20c5		db	00fh	; 00001111b . 04a85 0f
d20c6		db	0ffh	; 11111111b . 04a86 ff
d20c7		db	000h	; 00000000b . 04a87 00
d20c8		db	000h	; 00000000b . 04a88 00
d20c9		db	00fh	; 00001111b . 04a89 0f
d20ca		db	0ffh	; 11111111b . 04a8a ff
d20cb		db	0f0h	; 11110000b . 04a8b f0
d20cc		db	000h	; 00000000b . 04a8c 00
d20cd		db	003h	; 00000011b . 04a8d 03
d20ce		db	0ffh	; 11111111b . 04a8e ff
d20cf		db	0ffh	; 11111111b . 04a8f ff
d20d0		db	000h	; 00000000b . 04a90 00
d20d1		db	003h	; 00000011b . 04a91 03
d20d2		db	0ffh	; 11111111b . 04a92 ff
d20d3		db	0ffh	; 11111111b . 04a93 ff
d20d4		db	0f0h	; 11110000b . 04a94 f0
d20d5		db	000h	; 00000000b . 04a95 00
d20d6		db	0ffh	; 11111111b . 04a96 ff
d20d7		db	0ffh	; 11111111b . 04a97 ff
d20d8		db	0c0h	; 11000000b . 04a98 c0
d20d9		db	000h	; 00000000b . 04a99 00
d20da		db	00fh	; 00001111b . 04a9a 0f
d20db		db	0fch	; 11111100b . 04a9b fc
d20dc		db	000h	; 00000000b . 04a9c 00
d20dd		db	000h	; 00000000b . 04a9d 00
d20de		db	000h	; 00000000b . 04a9e 00
d20df		db	000h	; 00000000b . 04a9f 00
d20e0		db	000h	; 00000000b . 04aa0 00
d20e1		db	000h	; 00000000b . 04aa1 00
d20e2		db	005h	; 00000101b . 04aa2 05
d20e3		db	050h	; 01010000b P 04aa3 50
d20e4		db	000h	; 00000000b . 04aa4 00
d20e5		db	000h	; 00000000b . 04aa5 00
d20e6		db	055h	; 01010101b U 04aa6 55
d20e7		db	055h	; 01010101b U 04aa7 55
d20e8		db	000h	; 00000000b . 04aa8 00
d20e9		db	001h	; 00000001b . 04aa9 01
d20ea		db	005h	; 00000101b . 04aaa 05
d20eb		db	050h	; 01010000b P 04aab 50
d20ec		db	040h	; 01000000b @ 04aac 40
d20ed		db	007h	; 00000111b . 04aad 07
d20ee		db	00dh	; 00001101b . 04aae 0d
d20ef		db	070h	; 01110000b p 04aaf 70
d20f0		db	0d0h	; 11010000b . 04ab0 d0
d20f1		db	007h	; 00000111b . 04ab1 07
d20f2		db	0fdh	; 11111101b . 04ab2 fd
d20f3		db	07fh	; 01111111b . 04ab3 7f
d20f4		db	0d0h	; 11010000b . 04ab4 d0
d20f5		db	017h	; 00010111b . 04ab5 17
d20f6		db	0fdh	; 11111101b . 04ab6 fd
d20f7		db	07fh	; 01111111b . 04ab7 7f
d20f8		db	0d4h	; 11010100b . 04ab8 d4
d20f9		db	015h	; 00010101b . 04ab9 15
d20fa		db	0f5h	; 11110101b . 04aba f5
d20fb		db	05fh	; 01011111b _ 04abb 5f
d20fc		db	054h	; 01010100b T 04abc 54
d20fd		db	015h	; 00010101b . 04abd 15
d20fe		db	055h	; 01010101b U 04abe 55
d20ff		db	055h	; 01010101b U 04abf 55
d2100		db	054h	; 01010100b T 04ac0 54
d2101		db	000h	; 00000000b . 04ac1 00
d2102		db	005h	; 00000101b . 04ac2 05
d2103		db	050h	; 01010000b P 04ac3 50
d2104		db	000h	; 00000000b . 04ac4 00
d2105		db	000h	; 00000000b . 04ac5 00
d2106		db	055h	; 01010101b U 04ac6 55
d2107		db	055h	; 01010101b U 04ac7 55
d2108		db	000h	; 00000000b . 04ac8 00
d2109		db	001h	; 00000001b . 04ac9 01
d210a		db	055h	; 01010101b U 04aca 55
d210b		db	055h	; 01010101b U 04acb 55
d210c		db	040h	; 01000000b @ 04acc 40
d210d		db	005h	; 00000101b . 04acd 05
d210e		db	0f5h	; 11110101b . 04ace f5
d210f		db	05fh	; 01011111b _ 04acf 5f
d2110		db	050h	; 01010000b P 04ad0 50
d2111		db	007h	; 00000111b . 04ad1 07
d2112		db	0fdh	; 11111101b . 04ad2 fd
d2113		db	07fh	; 01111111b . 04ad3 7f
d2114		db	0d0h	; 11010000b . 04ad4 d0
d2115		db	017h	; 00010111b . 04ad5 17
d2116		db	0fdh	; 11111101b . 04ad6 fd
d2117		db	07fh	; 01111111b . 04ad7 7f
d2118		db	0d4h	; 11010100b . 04ad8 d4
d2119		db	017h	; 00010111b . 04ad9 17
d211a		db	00dh	; 00001101b . 04ada 0d
d211b		db	070h	; 01110000b p 04adb 70
d211c		db	0d4h	; 11010100b . 04adc d4
d211d		db	015h	; 00010101b . 04add 15
d211e		db	005h	; 00000101b . 04ade 05
d211f		db	050h	; 01010000b P 04adf 50
d2120		db	054h	; 01010100b T 04ae0 54
d2121		db	000h	; 00000000b . 04ae1 00
d2122		db	005h	; 00000101b . 04ae2 05
d2123		db	050h	; 01010000b P 04ae3 50
d2124		db	000h	; 00000000b . 04ae4 00
d2125		db	000h	; 00000000b . 04ae5 00
d2126		db	055h	; 01010101b U 04ae6 55
d2127		db	055h	; 01010101b U 04ae7 55
d2128		db	000h	; 00000000b . 04ae8 00
d2129		db	001h	; 00000001b . 04ae9 01
d212a		db	0f5h	; 11110101b . 04aea f5
d212b		db	05fh	; 01011111b _ 04aeb 5f
d212c		db	040h	; 01000000b @ 04aec 40
d212d		db	007h	; 00000111b . 04aed 07
d212e		db	0fdh	; 11111101b . 04aee fd
d212f		db	07fh	; 01111111b . 04aef 7f
d2130		db	0d0h	; 11010000b . 04af0 d0
d2131		db	004h	; 00000100b . 04af1 04
d2132		db	03dh	; 00111101b = 04af2 3d
d2133		db	043h	; 01000011b C 04af3 43
d2134		db	0d0h	; 11010000b . 04af4 d0
d2135		db	014h	; 00010100b . 04af5 14
d2136		db	03dh	; 00111101b = 04af6 3d
d2137		db	043h	; 01000011b C 04af7 43
d2138		db	0d4h	; 11010100b . 04af8 d4
d2139		db	015h	; 00010101b . 04af9 15
d213a		db	0f5h	; 11110101b . 04afa f5
d213b		db	05fh	; 01011111b _ 04afb 5f
d213c		db	054h	; 01010100b T 04afc 54
d213d		db	015h	; 00010101b . 04afd 15
d213e		db	055h	; 01010101b U 04afe 55
d213f		db	055h	; 01010101b U 04aff 55
d2140		db	054h	; 01010100b T 04b00 54
d2141		db	000h	; 00000000b . 04b01 00
d2142		db	005h	; 00000101b . 04b02 05
d2143		db	050h	; 01010000b P 04b03 50
d2144		db	000h	; 00000000b . 04b04 00
d2145		db	000h	; 00000000b . 04b05 00
d2146		db	055h	; 01010101b U 04b06 55
d2147		db	055h	; 01010101b U 04b07 55
d2148		db	000h	; 00000000b . 04b08 00
d2149		db	001h	; 00000001b . 04b09 01
d214a		db	0f5h	; 11110101b . 04b0a f5
d214b		db	05fh	; 01011111b _ 04b0b 5f
d214c		db	040h	; 01000000b @ 04b0c 40
d214d		db	007h	; 00000111b . 04b0d 07
d214e		db	0fdh	; 11111101b . 04b0e fd
d214f		db	07fh	; 01111111b . 04b0f 7f
d2150		db	0d0h	; 11010000b . 04b10 d0
d2151		db	007h	; 00000111b . 04b11 07
d2152		db	0c1h	; 11000001b . 04b12 c1
d2153		db	07ch	; 01111100b | 04b13 7c
d2154		db	010h	; 00010000b . 04b14 10
d2155		db	017h	; 00010111b . 04b15 17
d2156		db	0c1h	; 11000001b . 04b16 c1
d2157		db	07ch	; 01111100b | 04b17 7c
d2158		db	014h	; 00010100b . 04b18 14
d2159		db	015h	; 00010101b . 04b19 15
d215a		db	0f5h	; 11110101b . 04b1a f5
d215b		db	05fh	; 01011111b _ 04b1b 5f
d215c		db	054h	; 01010100b T 04b1c 54
d215d		db	015h	; 00010101b . 04b1d 15
d215e		db	055h	; 01010101b U 04b1e 55
d215f		db	055h	; 01010101b U 04b1f 55
d2160		db	054h	; 01010100b T 04b20 54
d2161		db	015h	; 00010101b . 04b21 15
d2162		db	055h	; 01010101b U 04b22 55
d2163		db	055h	; 01010101b U 04b23 55
d2164		db	054h	; 01010100b T 04b24 54
d2165		db	015h	; 00010101b . 04b25 15
d2166		db	055h	; 01010101b U 04b26 55
d2167		db	055h	; 01010101b U 04b27 55
d2168		db	054h	; 01010100b T 04b28 54
d2169		db	015h	; 00010101b . 04b29 15
d216a		db	055h	; 01010101b U 04b2a 55
d216b		db	055h	; 01010101b U 04b2b 55
d216c		db	054h	; 01010100b T 04b2c 54
d216d		db	015h	; 00010101b . 04b2d 15
d216e		db	055h	; 01010101b U 04b2e 55
d216f		db	055h	; 01010101b U 04b2f 55
d2170		db	054h	; 01010100b T 04b30 54
d2171		db	015h	; 00010101b . 04b31 15
d2172		db	045h	; 01000101b E 04b32 45
d2173		db	051h	; 01010001b Q 04b33 51
d2174		db	054h	; 01010100b T 04b34 54
d2175		db	005h	; 00000101b . 04b35 05
d2176		db	001h	; 00000001b . 04b36 01
d2177		db	040h	; 01000000b @ 04b37 40
d2178		db	050h	; 01010000b P 04b38 50
d2179		db	014h	; 00010100b . 04b39 14
d217a		db	054h	; 01010100b T 04b3a 54
d217b		db	015h	; 00010101b . 04b3b 15
d217c		db	014h	; 00010100b . 04b3c 14
d217d		db	010h	; 00010000b . 04b3d 10
d217e		db	014h	; 00010100b . 04b3e 14
d217f		db	014h	; 00010100b . 04b3f 14
d2180		db	004h	; 00000100b . 04b40 04
d2181		db	000h	; 00000000b . 04b41 00
d2182		db	007h	; 00000111b . 04b42 07
d2183		db	070h	; 01110000b p 04b43 70
d2184		db	000h	; 00000000b . 04b44 00
d2185		db	000h	; 00000000b . 04b45 00
d2186		db	0ddh	; 11011101b . 04b46 dd
d2187		db	0ddh	; 11011101b . 04b47 dd
d2188		db	000h	; 00000000b . 04b48 00
d2189		db	003h	; 00000011b . 04b49 03
d218a		db	007h	; 00000111b . 04b4a 07
d218b		db	070h	; 01110000b p 04b4b 70
d218c		db	040h	; 01000000b @ 04b4c 40
d218d		db	00fh	; 00001111b . 04b4d 0f
d218e		db	00dh	; 00001101b . 04b4e 0d
d218f		db	0f0h	; 11110000b . 04b4f f0
d2190		db	0d0h	; 11010000b . 04b50 d0
d2191		db	007h	; 00000111b . 04b51 07
d2192		db	0ffh	; 11111111b . 04b52 ff
d2193		db	07fh	; 01111111b . 04b53 7f
d2194		db	0f0h	; 11110000b . 04b54 f0
d2195		db	01fh	; 00011111b . 04b55 1f
d2196		db	0fdh	; 11111101b . 04b56 fd
d2197		db	0ffh	; 11111111b . 04b57 ff
d2198		db	0dch	; 11011100b . 04b58 dc
d2199		db	037h	; 00110111b 7 04b59 37
d219a		db	0f7h	; 11110111b . 04b5a f7
d219b		db	07fh	; 01111111b . 04b5b 7f
d219c		db	074h	; 01110100b t 04b5c 74
d219d		db	01dh	; 00011101b . 04b5d 1d
d219e		db	0ddh	; 11011101b . 04b5e dd
d219f		db	0ddh	; 11011101b . 04b5f dd
d21a0		db	0dch	; 11011100b . 04b60 dc
d21a1		db	000h	; 00000000b . 04b61 00
d21a2		db	007h	; 00000111b . 04b62 07
d21a3		db	070h	; 01110000b p 04b63 70
d21a4		db	000h	; 00000000b . 04b64 00
d21a5		db	000h	; 00000000b . 04b65 00
d21a6		db	0ddh	; 11011101b . 04b66 dd
d21a7		db	0ddh	; 11011101b . 04b67 dd
d21a8		db	000h	; 00000000b . 04b68 00
d21a9		db	003h	; 00000011b . 04b69 03
d21aa		db	077h	; 01110111b w 04b6a 77
d21ab		db	077h	; 01110111b w 04b6b 77
d21ac		db	040h	; 01000000b @ 04b6c 40
d21ad		db	00dh	; 00001101b . 04b6d 0d
d21ae		db	0fdh	; 11111101b . 04b6e fd
d21af		db	0dfh	; 11011111b . 04b6f df
d21b0		db	0d0h	; 11010000b . 04b70 d0
d21b1		db	007h	; 00000111b . 04b71 07
d21b2		db	0ffh	; 11111111b . 04b72 ff
d21b3		db	07fh	; 01111111b . 04b73 7f
d21b4		db	0f0h	; 11110000b . 04b74 f0
d21b5		db	01fh	; 00011111b . 04b75 1f
d21b6		db	0fdh	; 11111101b . 04b76 fd
d21b7		db	0ffh	; 11111111b . 04b77 ff
d21b8		db	0dch	; 11011100b . 04b78 dc
d21b9		db	037h	; 00110111b 7 04b79 37
d21ba		db	00fh	; 00001111b . 04b7a 0f
d21bb		db	070h	; 01110000b p 04b7b 70
d21bc		db	0f4h	; 11110100b . 04b7c f4
d21bd		db	01dh	; 00011101b . 04b7d 1d
d21be		db	00dh	; 00001101b . 04b7e 0d
d21bf		db	0d0h	; 11010000b . 04b7f d0
d21c0		db	0dch	; 11011100b . 04b80 dc
d21c1		db	000h	; 00000000b . 04b81 00
d21c2		db	007h	; 00000111b . 04b82 07
d21c3		db	070h	; 01110000b p 04b83 70
d21c4		db	000h	; 00000000b . 04b84 00
d21c5		db	000h	; 00000000b . 04b85 00
d21c6		db	0ddh	; 11011101b . 04b86 dd
d21c7		db	0ddh	; 11011101b . 04b87 dd
d21c8		db	000h	; 00000000b . 04b88 00
d21c9		db	003h	; 00000011b . 04b89 03
d21ca		db	0f7h	; 11110111b . 04b8a f7
d21cb		db	07fh	; 01111111b . 04b8b 7f
d21cc		db	040h	; 01000000b @ 04b8c 40
d21cd		db	00fh	; 00001111b . 04b8d 0f
d21ce		db	0fdh	; 11111101b . 04b8e fd
d21cf		db	0ffh	; 11111111b . 04b8f ff
d21d0		db	0d0h	; 11010000b . 04b90 d0
d21d1		db	004h	; 00000100b . 04b91 04
d21d2		db	03fh	; 00111111b ? 04b92 3f
d21d3		db	043h	; 01000011b C 04b93 43
d21d4		db	0f0h	; 11110000b . 04b94 f0
d21d5		db	01ch	; 00011100b . 04b95 1c
d21d6		db	03dh	; 00111101b = 04b96 3d
d21d7		db	0c3h	; 11000011b . 04b97 c3
d21d8		db	0dch	; 11011100b . 04b98 dc
d21d9		db	037h	; 00110111b 7 04b99 37
d21da		db	0f7h	; 11110111b . 04b9a f7
d21db		db	07fh	; 01111111b . 04b9b 7f
d21dc		db	074h	; 01110100b t 04b9c 74
d21dd		db	01dh	; 00011101b . 04b9d 1d
d21de		db	0ddh	; 11011101b . 04b9e dd
d21df		db	0ddh	; 11011101b . 04b9f dd
d21e0		db	0dch	; 11011100b . 04ba0 dc
d21e1		db	000h	; 00000000b . 04ba1 00
d21e2		db	007h	; 00000111b . 04ba2 07
d21e3		db	070h	; 01110000b p 04ba3 70
d21e4		db	000h	; 00000000b . 04ba4 00
d21e5		db	000h	; 00000000b . 04ba5 00
d21e6		db	0ddh	; 11011101b . 04ba6 dd
d21e7		db	0ddh	; 11011101b . 04ba7 dd
d21e8		db	000h	; 00000000b . 04ba8 00
d21e9		db	003h	; 00000011b . 04ba9 03
d21ea		db	0f7h	; 11110111b . 04baa f7
d21eb		db	07fh	; 01111111b . 04bab 7f
d21ec		db	040h	; 01000000b @ 04bac 40
d21ed		db	00fh	; 00001111b . 04bad 0f
d21ee		db	0fdh	; 11111101b . 04bae fd
d21ef		db	0ffh	; 11111111b . 04baf ff
d21f0		db	0d0h	; 11010000b . 04bb0 d0
d21f1		db	007h	; 00000111b . 04bb1 07
d21f2		db	0c3h	; 11000011b . 04bb2 c3
d21f3		db	07ch	; 01111100b | 04bb3 7c
d21f4		db	030h	; 00110000b 0 04bb4 30
d21f5		db	01fh	; 00011111b . 04bb5 1f
d21f6		db	0c1h	; 11000001b . 04bb6 c1
d21f7		db	0fch	; 11111100b . 04bb7 fc
d21f8		db	01ch	; 00011100b . 04bb8 1c
d21f9		db	037h	; 00110111b 7 04bb9 37
d21fa		db	0f7h	; 11110111b . 04bba f7
d21fb		db	07fh	; 01111111b . 04bbb 7f
d21fc		db	074h	; 01110100b t 04bbc 74
d21fd		db	01dh	; 00011101b . 04bbd 1d
d21fe		db	0ddh	; 11011101b . 04bbe dd
d21ff		db	0ddh	; 11011101b . 04bbf dd
d2200		db	0dch	; 11011100b . 04bc0 dc
d2201		db	037h	; 00110111b 7 04bc1 37
d2202		db	077h	; 01110111b w 04bc2 77
d2203		db	077h	; 01110111b w 04bc3 77
d2204		db	074h	; 01110100b t 04bc4 74
d2205		db	01dh	; 00011101b . 04bc5 1d
d2206		db	0ddh	; 11011101b . 04bc6 dd
d2207		db	0ddh	; 11011101b . 04bc7 dd
d2208		db	0dch	; 11011100b . 04bc8 dc
d2209		db	037h	; 00110111b 7 04bc9 37
d220a		db	077h	; 01110111b w 04bca 77
d220b		db	077h	; 01110111b w 04bcb 77
d220c		db	074h	; 01110100b t 04bcc 74
d220d		db	01dh	; 00011101b . 04bcd 1d
d220e		db	0ddh	; 11011101b . 04bce dd
d220f		db	0ddh	; 11011101b . 04bcf dd
d2210		db	0dch	; 11011100b . 04bd0 dc
d2211		db	037h	; 00110111b 7 04bd1 37
d2212		db	047h	; 01000111b G 04bd2 47
d2213		db	073h	; 01110011b s 04bd3 73
d2214		db	074h	; 01110100b t 04bd4 74
d2215		db	00dh	; 00001101b . 04bd5 0d
d2216		db	001h	; 00000001b . 04bd6 01
d2217		db	0c0h	; 11000000b . 04bd7 c0
d2218		db	0d0h	; 11010000b . 04bd8 d0
d2219		db	034h	; 00110100b 4 04bd9 34
d221a		db	074h	; 01110100b t 04bda 74
d221b		db	037h	; 00110111b 7 04bdb 37
d221c		db	034h	; 00110100b 4 04bdc 34
d221d		db	010h	; 00010000b . 04bdd 10
d221e		db	01ch	; 00011100b . 04bde 1c
d221f		db	01ch	; 00011100b . 04bdf 1c
d2220		db	00ch	; 00001100b . 04be0 0c
d2221		db	000h	; 00000000b . 04be1 00
d2222		db	00ah	; 00001010b . 04be2 0a
d2223		db	0a0h	; 10100000b . 04be3 a0
d2224		db	000h	; 00000000b . 04be4 00
d2225		db	000h	; 00000000b . 04be5 00
d2226		db	0aah	; 10101010b . 04be6 aa
d2227		db	0aah	; 10101010b . 04be7 aa
d2228		db	000h	; 00000000b . 04be8 00
d2229		db	002h	; 00000010b . 04be9 02
d222a		db	00ah	; 00001010b . 04bea 0a
d222b		db	0a0h	; 10100000b . 04beb a0
d222c		db	080h	; 10000000b . 04bec 80
d222d		db	00bh	; 00001011b . 04bed 0b
d222e		db	00eh	; 00001110b . 04bee 0e
d222f		db	0b0h	; 10110000b . 04bef b0
d2230		db	0e0h	; 11100000b . 04bf0 e0
d2231		db	00bh	; 00001011b . 04bf1 0b
d2232		db	0feh	; 11111110b . 04bf2 fe
d2233		db	0bfh	; 10111111b . 04bf3 bf
d2234		db	0e0h	; 11100000b . 04bf4 e0
d2235		db	02bh	; 00101011b + 04bf5 2b
d2236		db	0feh	; 11111110b . 04bf6 fe
d2237		db	0bfh	; 10111111b . 04bf7 bf
d2238		db	0e8h	; 11101000b . 04bf8 e8
d2239		db	02ah	; 00101010b * 04bf9 2a
d223a		db	0fah	; 11111010b . 04bfa fa
d223b		db	0afh	; 10101111b . 04bfb af
d223c		db	0a8h	; 10101000b . 04bfc a8
d223d		db	02ah	; 00101010b * 04bfd 2a
d223e		db	0aah	; 10101010b . 04bfe aa
d223f		db	0aah	; 10101010b . 04bff aa
d2240		db	0a8h	; 10101000b . 04c00 a8
d2241		db	000h	; 00000000b . 04c01 00
d2242		db	00ah	; 00001010b . 04c02 0a
d2243		db	0a0h	; 10100000b . 04c03 a0
d2244		db	000h	; 00000000b . 04c04 00
d2245		db	000h	; 00000000b . 04c05 00
d2246		db	0aah	; 10101010b . 04c06 aa
d2247		db	0aah	; 10101010b . 04c07 aa
d2248		db	000h	; 00000000b . 04c08 00
d2249		db	002h	; 00000010b . 04c09 02
d224a		db	0aah	; 10101010b . 04c0a aa
d224b		db	0aah	; 10101010b . 04c0b aa
d224c		db	080h	; 10000000b . 04c0c 80
d224d		db	00ah	; 00001010b . 04c0d 0a
d224e		db	0fah	; 11111010b . 04c0e fa
d224f		db	0afh	; 10101111b . 04c0f af
d2250		db	0a0h	; 10100000b . 04c10 a0
d2251		db	00bh	; 00001011b . 04c11 0b
d2252		db	0feh	; 11111110b . 04c12 fe
d2253		db	0bfh	; 10111111b . 04c13 bf
d2254		db	0e0h	; 11100000b . 04c14 e0
d2255		db	02bh	; 00101011b + 04c15 2b
d2256		db	0feh	; 11111110b . 04c16 fe
d2257		db	0bfh	; 10111111b . 04c17 bf
d2258		db	0e8h	; 11101000b . 04c18 e8
d2259		db	02bh	; 00101011b + 04c19 2b
d225a		db	00eh	; 00001110b . 04c1a 0e
d225b		db	0b0h	; 10110000b . 04c1b b0
d225c		db	0e8h	; 11101000b . 04c1c e8
d225d		db	02ah	; 00101010b * 04c1d 2a
d225e		db	00ah	; 00001010b . 04c1e 0a
d225f		db	0a0h	; 10100000b . 04c1f a0
d2260		db	0a8h	; 10101000b . 04c20 a8
d2261		db	000h	; 00000000b . 04c21 00
d2262		db	00ah	; 00001010b . 04c22 0a
d2263		db	0a0h	; 10100000b . 04c23 a0
d2264		db	000h	; 00000000b . 04c24 00
d2265		db	000h	; 00000000b . 04c25 00
d2266		db	0aah	; 10101010b . 04c26 aa
d2267		db	0aah	; 10101010b . 04c27 aa
d2268		db	000h	; 00000000b . 04c28 00
d2269		db	002h	; 00000010b . 04c29 02
d226a		db	0fah	; 11111010b . 04c2a fa
d226b		db	0afh	; 10101111b . 04c2b af
d226c		db	080h	; 10000000b . 04c2c 80
d226d		db	00bh	; 00001011b . 04c2d 0b
d226e		db	0feh	; 11111110b . 04c2e fe
d226f		db	0bfh	; 10111111b . 04c2f bf
d2270		db	0e0h	; 11100000b . 04c30 e0
d2271		db	008h	; 00001000b . 04c31 08
d2272		db	03eh	; 00111110b > 04c32 3e
d2273		db	083h	; 10000011b . 04c33 83
d2274		db	0e0h	; 11100000b . 04c34 e0
d2275		db	028h	; 00101000b ( 04c35 28
d2276		db	03eh	; 00111110b > 04c36 3e
d2277		db	083h	; 10000011b . 04c37 83
d2278		db	0e8h	; 11101000b . 04c38 e8
d2279		db	02ah	; 00101010b * 04c39 2a
d227a		db	0fah	; 11111010b . 04c3a fa
d227b		db	0afh	; 10101111b . 04c3b af
d227c		db	0a8h	; 10101000b . 04c3c a8
d227d		db	02ah	; 00101010b * 04c3d 2a
d227e		db	0aah	; 10101010b . 04c3e aa
d227f		db	0aah	; 10101010b . 04c3f aa
d2280		db	0a8h	; 10101000b . 04c40 a8
d2281		db	000h	; 00000000b . 04c41 00
d2282		db	00ah	; 00001010b . 04c42 0a
d2283		db	0a0h	; 10100000b . 04c43 a0
d2284		db	000h	; 00000000b . 04c44 00
d2285		db	000h	; 00000000b . 04c45 00
d2286		db	0aah	; 10101010b . 04c46 aa
d2287		db	0aah	; 10101010b . 04c47 aa
d2288		db	000h	; 00000000b . 04c48 00
d2289		db	002h	; 00000010b . 04c49 02
d228a		db	0fah	; 11111010b . 04c4a fa
d228b		db	0afh	; 10101111b . 04c4b af
d228c		db	080h	; 10000000b . 04c4c 80
d228d		db	00bh	; 00001011b . 04c4d 0b
d228e		db	0feh	; 11111110b . 04c4e fe
d228f		db	0bfh	; 10111111b . 04c4f bf
d2290		db	0e0h	; 11100000b . 04c50 e0
d2291		db	00bh	; 00001011b . 04c51 0b
d2292		db	0c2h	; 11000010b . 04c52 c2
d2293		db	0bch	; 10111100b . 04c53 bc
d2294		db	020h	; 00100000b   04c54 20
d2295		db	02bh	; 00101011b + 04c55 2b
d2296		db	0c2h	; 11000010b . 04c56 c2
d2297		db	0bch	; 10111100b . 04c57 bc
d2298		db	028h	; 00101000b ( 04c58 28
d2299		db	02ah	; 00101010b * 04c59 2a
d229a		db	0fah	; 11111010b . 04c5a fa
d229b		db	0afh	; 10101111b . 04c5b af
d229c		db	0a8h	; 10101000b . 04c5c a8
d229d		db	02ah	; 00101010b * 04c5d 2a
d229e		db	0aah	; 10101010b . 04c5e aa
d229f		db	0aah	; 10101010b . 04c5f aa
d22a0		db	0a8h	; 10101000b . 04c60 a8
d22a1		db	02ah	; 00101010b * 04c61 2a
d22a2		db	0aah	; 10101010b . 04c62 aa
d22a3		db	0aah	; 10101010b . 04c63 aa
d22a4		db	0a8h	; 10101000b . 04c64 a8
d22a5		db	02ah	; 00101010b * 04c65 2a
d22a6		db	0aah	; 10101010b . 04c66 aa
d22a7		db	0aah	; 10101010b . 04c67 aa
d22a8		db	0a8h	; 10101000b . 04c68 a8
d22a9		db	02ah	; 00101010b * 04c69 2a
d22aa		db	0aah	; 10101010b . 04c6a aa
d22ab		db	0aah	; 10101010b . 04c6b aa
d22ac		db	0a8h	; 10101000b . 04c6c a8
d22ad		db	02ah	; 00101010b * 04c6d 2a
d22ae		db	0aah	; 10101010b . 04c6e aa
d22af		db	0aah	; 10101010b . 04c6f aa
d22b0		db	0a8h	; 10101000b . 04c70 a8
d22b1		db	02ah	; 00101010b * 04c71 2a
d22b2		db	08ah	; 10001010b . 04c72 8a
d22b3		db	0a2h	; 10100010b . 04c73 a2
d22b4		db	0a8h	; 10101000b . 04c74 a8
d22b5		db	00ah	; 00001010b . 04c75 0a
d22b6		db	002h	; 00000010b . 04c76 02
d22b7		db	080h	; 10000000b . 04c77 80
d22b8		db	0a0h	; 10100000b . 04c78 a0
d22b9		db	028h	; 00101000b ( 04c79 28
d22ba		db	0a8h	; 10101000b . 04c7a a8
d22bb		db	02ah	; 00101010b * 04c7b 2a
d22bc		db	028h	; 00101000b ( 04c7c 28
d22bd		db	020h	; 00100000b   04c7d 20
d22be		db	028h	; 00101000b ( 04c7e 28
d22bf		db	028h	; 00101000b ( 04c7f 28
d22c0		db	008h	; 00001000b . 04c80 08
d22c1		db	000h	; 00000000b . 04c81 00
d22c2		db	00bh	; 00001011b . 04c82 0b
d22c3		db	0b0h	; 10110000b . 04c83 b0
d22c4		db	000h	; 00000000b . 04c84 00
d22c5		db	000h	; 00000000b . 04c85 00
d22c6		db	0eeh	; 11101110b . 04c86 ee
d22c7		db	0eeh	; 11101110b . 04c87 ee
d22c8		db	000h	; 00000000b . 04c88 00
d22c9		db	003h	; 00000011b . 04c89 03
d22ca		db	00bh	; 00001011b . 04c8a 0b
d22cb		db	0b0h	; 10110000b . 04c8b b0
d22cc		db	080h	; 10000000b . 04c8c 80
d22cd		db	00fh	; 00001111b . 04c8d 0f
d22ce		db	00eh	; 00001110b . 04c8e 0e
d22cf		db	0f0h	; 11110000b . 04c8f f0
d22d0		db	0e0h	; 11100000b . 04c90 e0
d22d1		db	00bh	; 00001011b . 04c91 0b
d22d2		db	0ffh	; 11111111b . 04c92 ff
d22d3		db	0bfh	; 10111111b . 04c93 bf
d22d4		db	0f0h	; 11110000b . 04c94 f0
d22d5		db	02fh	; 00101111b / 04c95 2f
d22d6		db	0feh	; 11111110b . 04c96 fe
d22d7		db	0ffh	; 11111111b . 04c97 ff
d22d8		db	0ech	; 11101100b . 04c98 ec
d22d9		db	03bh	; 00111011b ; 04c99 3b
d22da		db	0fbh	; 11111011b . 04c9a fb
d22db		db	0bfh	; 10111111b . 04c9b bf
d22dc		db	0b8h	; 10111000b . 04c9c b8
d22dd		db	02eh	; 00101110b . 04c9d 2e
d22de		db	0eeh	; 11101110b . 04c9e ee
d22df		db	0eeh	; 11101110b . 04c9f ee
d22e0		db	0ech	; 11101100b . 04ca0 ec
d22e1		db	000h	; 00000000b . 04ca1 00
d22e2		db	00bh	; 00001011b . 04ca2 0b
d22e3		db	0b0h	; 10110000b . 04ca3 b0
d22e4		db	000h	; 00000000b . 04ca4 00
d22e5		db	000h	; 00000000b . 04ca5 00
d22e6		db	0eeh	; 11101110b . 04ca6 ee
d22e7		db	0eeh	; 11101110b . 04ca7 ee
d22e8		db	000h	; 00000000b . 04ca8 00
d22e9		db	003h	; 00000011b . 04ca9 03
d22ea		db	0bbh	; 10111011b . 04caa bb
d22eb		db	0bbh	; 10111011b . 04cab bb
d22ec		db	080h	; 10000000b . 04cac 80
d22ed		db	00eh	; 00001110b . 04cad 0e
d22ee		db	0feh	; 11111110b . 04cae fe
d22ef		db	0efh	; 11101111b . 04caf ef
d22f0		db	0e0h	; 11100000b . 04cb0 e0
d22f1		db	00bh	; 00001011b . 04cb1 0b
d22f2		db	0ffh	; 11111111b . 04cb2 ff
d22f3		db	0bfh	; 10111111b . 04cb3 bf
d22f4		db	0f0h	; 11110000b . 04cb4 f0
d22f5		db	02fh	; 00101111b / 04cb5 2f
d22f6		db	0feh	; 11111110b . 04cb6 fe
d22f7		db	0ffh	; 11111111b . 04cb7 ff
d22f8		db	0ech	; 11101100b . 04cb8 ec
d22f9		db	03bh	; 00111011b ; 04cb9 3b
d22fa		db	00fh	; 00001111b . 04cba 0f
d22fb		db	0b0h	; 10110000b . 04cbb b0
d22fc		db	0f8h	; 11111000b . 04cbc f8
d22fd		db	02eh	; 00101110b . 04cbd 2e
d22fe		db	00eh	; 00001110b . 04cbe 0e
d22ff		db	0e0h	; 11100000b . 04cbf e0
d2300		db	0ech	; 11101100b . 04cc0 ec
d2301		db	000h	; 00000000b . 04cc1 00
d2302		db	00bh	; 00001011b . 04cc2 0b
d2303		db	0b0h	; 10110000b . 04cc3 b0
d2304		db	000h	; 00000000b . 04cc4 00
d2305		db	000h	; 00000000b . 04cc5 00
d2306		db	0eeh	; 11101110b . 04cc6 ee
d2307		db	0eeh	; 11101110b . 04cc7 ee
d2308		db	000h	; 00000000b . 04cc8 00
d2309		db	003h	; 00000011b . 04cc9 03
d230a		db	0fbh	; 11111011b . 04cca fb
d230b		db	0bfh	; 10111111b . 04ccb bf
d230c		db	080h	; 10000000b . 04ccc 80
d230d		db	00fh	; 00001111b . 04ccd 0f
d230e		db	0feh	; 11111110b . 04cce fe
d230f		db	0ffh	; 11111111b . 04ccf ff
d2310		db	0e0h	; 11100000b . 04cd0 e0
d2311		db	008h	; 00001000b . 04cd1 08
d2312		db	03fh	; 00111111b ? 04cd2 3f
d2313		db	083h	; 10000011b . 04cd3 83
d2314		db	0f0h	; 11110000b . 04cd4 f0
d2315		db	02ch	; 00101100b , 04cd5 2c
d2316		db	03eh	; 00111110b > 04cd6 3e
d2317		db	0c3h	; 11000011b . 04cd7 c3
d2318		db	0ech	; 11101100b . 04cd8 ec
d2319		db	03bh	; 00111011b ; 04cd9 3b
d231a		db	0fbh	; 11111011b . 04cda fb
d231b		db	0bfh	; 10111111b . 04cdb bf
d231c		db	0b8h	; 10111000b . 04cdc b8
d231d		db	02eh	; 00101110b . 04cdd 2e
d231e		db	0eeh	; 11101110b . 04cde ee
d231f		db	0eeh	; 11101110b . 04cdf ee
d2320		db	0ech	; 11101100b . 04ce0 ec
d2321		db	000h	; 00000000b . 04ce1 00
d2322		db	00bh	; 00001011b . 04ce2 0b
d2323		db	0b0h	; 10110000b . 04ce3 b0
d2324		db	000h	; 00000000b . 04ce4 00
d2325		db	000h	; 00000000b . 04ce5 00
d2326		db	0eeh	; 11101110b . 04ce6 ee
d2327		db	0eeh	; 11101110b . 04ce7 ee
d2328		db	000h	; 00000000b . 04ce8 00
d2329		db	003h	; 00000011b . 04ce9 03
d232a		db	0fbh	; 11111011b . 04cea fb
d232b		db	0bfh	; 10111111b . 04ceb bf
d232c		db	080h	; 10000000b . 04cec 80
d232d		db	00fh	; 00001111b . 04ced 0f
d232e		db	0feh	; 11111110b . 04cee fe
d232f		db	0ffh	; 11111111b . 04cef ff
d2330		db	0e0h	; 11100000b . 04cf0 e0
d2331		db	00bh	; 00001011b . 04cf1 0b
d2332		db	0c3h	; 11000011b . 04cf2 c3
d2333		db	0bch	; 10111100b . 04cf3 bc
d2334		db	030h	; 00110000b 0 04cf4 30
d2335		db	02fh	; 00101111b / 04cf5 2f
d2336		db	0c2h	; 11000010b . 04cf6 c2
d2337		db	0fch	; 11111100b . 04cf7 fc
d2338		db	02ch	; 00101100b , 04cf8 2c
d2339		db	03bh	; 00111011b ; 04cf9 3b
d233a		db	0fbh	; 11111011b . 04cfa fb
d233b		db	0bfh	; 10111111b . 04cfb bf
d233c		db	0b8h	; 10111000b . 04cfc b8
d233d		db	02eh	; 00101110b . 04cfd 2e
d233e		db	0eeh	; 11101110b . 04cfe ee
d233f		db	0eeh	; 11101110b . 04cff ee
d2340		db	0ech	; 11101100b . 04d00 ec
d2341		db	03bh	; 00111011b ; 04d01 3b
d2342		db	0bbh	; 10111011b . 04d02 bb
d2343		db	0bbh	; 10111011b . 04d03 bb
d2344		db	0b8h	; 10111000b . 04d04 b8
d2345		db	02eh	; 00101110b . 04d05 2e
d2346		db	0eeh	; 11101110b . 04d06 ee
d2347		db	0eeh	; 11101110b . 04d07 ee
d2348		db	0ech	; 11101100b . 04d08 ec
d2349		db	03bh	; 00111011b ; 04d09 3b
d234a		db	0bbh	; 10111011b . 04d0a bb
d234b		db	0bbh	; 10111011b . 04d0b bb
d234c		db	0b8h	; 10111000b . 04d0c b8
d234d		db	02eh	; 00101110b . 04d0d 2e
d234e		db	0eeh	; 11101110b . 04d0e ee
d234f		db	0eeh	; 11101110b . 04d0f ee
d2350		db	0ech	; 11101100b . 04d10 ec
d2351		db	03bh	; 00111011b ; 04d11 3b
d2352		db	08bh	; 10001011b . 04d12 8b
d2353		db	0b3h	; 10110011b . 04d13 b3
d2354		db	0b8h	; 10111000b . 04d14 b8
d2355		db	00eh	; 00001110b . 04d15 0e
d2356		db	002h	; 00000010b . 04d16 02
d2357		db	0c0h	; 11000000b . 04d17 c0
d2358		db	0e0h	; 11100000b . 04d18 e0
d2359		db	038h	; 00111000b 8 04d19 38
d235a		db	0b8h	; 10111000b . 04d1a b8
d235b		db	03bh	; 00111011b ; 04d1b 3b
d235c		db	038h	; 00111000b 8 04d1c 38
d235d		db	020h	; 00100000b   04d1d 20
d235e		db	02ch	; 00101100b , 04d1e 2c
d235f		db	02ch	; 00101100b , 04d1f 2c
d2360		db	00ch	; 00001100b . 04d20 0c
d2361		db	000h	; 00000000b . 04d21 00
d2362		db	005h	; 00000101b . 04d22 05
d2363		db	050h	; 01010000b P 04d23 50
d2364		db	000h	; 00000000b . 04d24 00
d2365		db	000h	; 00000000b . 04d25 00
d2366		db	050h	; 01010000b P 04d26 50
d2367		db	005h	; 00000101b . 04d27 05
d2368		db	000h	; 00000000b . 04d28 00
d2369		db	001h	; 00000001b . 04d29 01
d236a		db	000h	; 00000000b . 04d2a 00
d236b		db	000h	; 00000000b . 04d2b 00
d236c		db	040h	; 01000000b @ 04d2c 40
d236d		db	004h	; 00000100b . 04d2d 04
d236e		db	03ch	; 00111100b < 04d2e 3c
d236f		db	03ch	; 00111100b < 04d2f 3c
d2370		db	010h	; 00010000b . 04d30 10
d2371		db	004h	; 00000100b . 04d31 04
d2372		db	03ch	; 00111100b < 04d32 3c
d2373		db	03ch	; 00111100b < 04d33 3c
d2374		db	010h	; 00010000b . 04d34 10
d2375		db	010h	; 00010000b . 04d35 10
d2376		db	000h	; 00000000b . 04d36 00
d2377		db	000h	; 00000000b . 04d37 00
d2378		db	004h	; 00000100b . 04d38 04
d2379		db	010h	; 00010000b . 04d39 10
d237a		db	000h	; 00000000b . 04d3a 00
d237b		db	000h	; 00000000b . 04d3b 00
d237c		db	004h	; 00000100b . 04d3c 04
d237d		db	010h	; 00010000b . 04d3d 10
d237e		db	000h	; 00000000b . 04d3e 00
d237f		db	000h	; 00000000b . 04d3f 00
d2380		db	004h	; 00000100b . 04d40 04
d2381		db	000h	; 00000000b . 04d41 00
d2382		db	005h	; 00000101b . 04d42 05
d2383		db	050h	; 01010000b P 04d43 50
d2384		db	000h	; 00000000b . 04d44 00
d2385		db	000h	; 00000000b . 04d45 00
d2386		db	050h	; 01010000b P 04d46 50
d2387		db	005h	; 00000101b . 04d47 05
d2388		db	000h	; 00000000b . 04d48 00
d2389		db	001h	; 00000001b . 04d49 01
d238a		db	000h	; 00000000b . 04d4a 00
d238b		db	000h	; 00000000b . 04d4b 00
d238c		db	040h	; 01000000b @ 04d4c 40
d238d		db	004h	; 00000100b . 04d4d 04
d238e		db	03ch	; 00111100b < 04d4e 3c
d238f		db	03ch	; 00111100b < 04d4f 3c
d2390		db	010h	; 00010000b . 04d50 10
d2391		db	004h	; 00000100b . 04d51 04
d2392		db	03ch	; 00111100b < 04d52 3c
d2393		db	03ch	; 00111100b < 04d53 3c
d2394		db	010h	; 00010000b . 04d54 10
d2395		db	010h	; 00010000b . 04d55 10
d2396		db	000h	; 00000000b . 04d56 00
d2397		db	000h	; 00000000b . 04d57 00
d2398		db	004h	; 00000100b . 04d58 04
d2399		db	010h	; 00010000b . 04d59 10
d239a		db	000h	; 00000000b . 04d5a 00
d239b		db	000h	; 00000000b . 04d5b 00
d239c		db	004h	; 00000100b . 04d5c 04
d239d		db	010h	; 00010000b . 04d5d 10
d239e		db	000h	; 00000000b . 04d5e 00
d239f		db	000h	; 00000000b . 04d5f 00
d23a0		db	004h	; 00000100b . 04d60 04
d23a1		db	000h	; 00000000b . 04d61 00
d23a2		db	005h	; 00000101b . 04d62 05
d23a3		db	050h	; 01010000b P 04d63 50
d23a4		db	000h	; 00000000b . 04d64 00
d23a5		db	000h	; 00000000b . 04d65 00
d23a6		db	050h	; 01010000b P 04d66 50
d23a7		db	005h	; 00000101b . 04d67 05
d23a8		db	000h	; 00000000b . 04d68 00
d23a9		db	001h	; 00000001b . 04d69 01
d23aa		db	000h	; 00000000b . 04d6a 00
d23ab		db	000h	; 00000000b . 04d6b 00
d23ac		db	040h	; 01000000b @ 04d6c 40
d23ad		db	004h	; 00000100b . 04d6d 04
d23ae		db	03ch	; 00111100b < 04d6e 3c
d23af		db	03ch	; 00111100b < 04d6f 3c
d23b0		db	010h	; 00010000b . 04d70 10
d23b1		db	004h	; 00000100b . 04d71 04
d23b2		db	03ch	; 00111100b < 04d72 3c
d23b3		db	03ch	; 00111100b < 04d73 3c
d23b4		db	010h	; 00010000b . 04d74 10
d23b5		db	010h	; 00010000b . 04d75 10
d23b6		db	000h	; 00000000b . 04d76 00
d23b7		db	000h	; 00000000b . 04d77 00
d23b8		db	004h	; 00000100b . 04d78 04
d23b9		db	010h	; 00010000b . 04d79 10
d23ba		db	000h	; 00000000b . 04d7a 00
d23bb		db	000h	; 00000000b . 04d7b 00
d23bc		db	004h	; 00000100b . 04d7c 04
d23bd		db	010h	; 00010000b . 04d7d 10
d23be		db	000h	; 00000000b . 04d7e 00
d23bf		db	000h	; 00000000b . 04d7f 00
d23c0		db	004h	; 00000100b . 04d80 04
d23c1		db	000h	; 00000000b . 04d81 00
d23c2		db	005h	; 00000101b . 04d82 05
d23c3		db	050h	; 01010000b P 04d83 50
d23c4		db	000h	; 00000000b . 04d84 00
d23c5		db	000h	; 00000000b . 04d85 00
d23c6		db	050h	; 01010000b P 04d86 50
d23c7		db	005h	; 00000101b . 04d87 05
d23c8		db	000h	; 00000000b . 04d88 00
d23c9		db	001h	; 00000001b . 04d89 01
d23ca		db	000h	; 00000000b . 04d8a 00
d23cb		db	000h	; 00000000b . 04d8b 00
d23cc		db	040h	; 01000000b @ 04d8c 40
d23cd		db	004h	; 00000100b . 04d8d 04
d23ce		db	03ch	; 00111100b < 04d8e 3c
d23cf		db	03ch	; 00111100b < 04d8f 3c
d23d0		db	010h	; 00010000b . 04d90 10
d23d1		db	004h	; 00000100b . 04d91 04
d23d2		db	03ch	; 00111100b < 04d92 3c
d23d3		db	03ch	; 00111100b < 04d93 3c
d23d4		db	010h	; 00010000b . 04d94 10
d23d5		db	010h	; 00010000b . 04d95 10
d23d6		db	000h	; 00000000b . 04d96 00
d23d7		db	000h	; 00000000b . 04d97 00
d23d8		db	004h	; 00000100b . 04d98 04
d23d9		db	010h	; 00010000b . 04d99 10
d23da		db	000h	; 00000000b . 04d9a 00
d23db		db	000h	; 00000000b . 04d9b 00
d23dc		db	004h	; 00000100b . 04d9c 04
d23dd		db	010h	; 00010000b . 04d9d 10
d23de		db	000h	; 00000000b . 04d9e 00
d23df		db	000h	; 00000000b . 04d9f 00
d23e0		db	004h	; 00000100b . 04da0 04
d23e1		db	013h	; 00010011b . 04da1 13
d23e2		db	0c3h	; 11000011b . 04da2 c3
d23e3		db	0c3h	; 11000011b . 04da3 c3
d23e4		db	0c4h	; 11000100b . 04da4 c4
d23e5		db	01ch	; 00011100b . 04da5 1c
d23e6		db	03ch	; 00111100b < 04da6 3c
d23e7		db	03ch	; 00111100b < 04da7 3c
d23e8		db	034h	; 00110100b 4 04da8 34
d23e9		db	010h	; 00010000b . 04da9 10
d23ea		db	000h	; 00000000b . 04daa 00
d23eb		db	000h	; 00000000b . 04dab 00
d23ec		db	004h	; 00000100b . 04dac 04
d23ed		db	010h	; 00010000b . 04dad 10
d23ee		db	000h	; 00000000b . 04dae 00
d23ef		db	000h	; 00000000b . 04daf 00
d23f0		db	004h	; 00000100b . 04db0 04
d23f1		db	010h	; 00010000b . 04db1 10
d23f2		db	044h	; 01000100b D 04db2 44
d23f3		db	011h	; 00010001b . 04db3 11
d23f4		db	004h	; 00000100b . 04db4 04
d23f5		db	005h	; 00000101b . 04db5 05
d23f6		db	001h	; 00000001b . 04db6 01
d23f7		db	040h	; 01000000b @ 04db7 40
d23f8		db	050h	; 01010000b P 04db8 50
d23f9		db	014h	; 00010100b . 04db9 14
d23fa		db	044h	; 01000100b D 04dba 44
d23fb		db	011h	; 00010001b . 04dbb 11
d23fc		db	014h	; 00010100b . 04dbc 14
d23fd		db	010h	; 00010000b . 04dbd 10
d23fe		db	014h	; 00010100b . 04dbe 14
d23ff		db	014h	; 00010100b . 04dbf 14
d2400		db	004h	; 00000100b . 04dc0 04
d2401		db	000h	; 00000000b . 04dc1 00
d2402		db	00fh	; 00001111b . 04dc2 0f
d2403		db	0f0h	; 11110000b . 04dc3 f0
d2404		db	000h	; 00000000b . 04dc4 00
d2405		db	000h	; 00000000b . 04dc5 00
d2406		db	0ffh	; 11111111b . 04dc6 ff
d2407		db	0ffh	; 11111111b . 04dc7 ff
d2408		db	000h	; 00000000b . 04dc8 00
d2409		db	003h	; 00000011b . 04dc9 03
d240a		db	0ffh	; 11111111b . 04dca ff
d240b		db	0ffh	; 11111111b . 04dcb ff
d240c		db	0c0h	; 11000000b . 04dcc c0
d240d		db	00fh	; 00001111b . 04dcd 0f
d240e		db	0ebh	; 11101011b . 04dce eb
d240f		db	0ebh	; 11101011b . 04dcf eb
d2410		db	0f0h	; 11110000b . 04dd0 f0
d2411		db	00fh	; 00001111b . 04dd1 0f
d2412		db	0ebh	; 11101011b . 04dd2 eb
d2413		db	0ebh	; 11101011b . 04dd3 eb
d2414		db	0f0h	; 11110000b . 04dd4 f0
d2415		db	03fh	; 00111111b ? 04dd5 3f
d2416		db	0ffh	; 11111111b . 04dd6 ff
d2417		db	0ffh	; 11111111b . 04dd7 ff
d2418		db	0fch	; 11111100b . 04dd8 fc
d2419		db	03fh	; 00111111b ? 04dd9 3f
d241a		db	0ffh	; 11111111b . 04dda ff
d241b		db	0ffh	; 11111111b . 04ddb ff
d241c		db	0fch	; 11111100b . 04ddc fc
d241d		db	03fh	; 00111111b ? 04ddd 3f
d241e		db	0ffh	; 11111111b . 04dde ff
d241f		db	0ffh	; 11111111b . 04ddf ff
d2420		db	0fch	; 11111100b . 04de0 fc
d2421		db	000h	; 00000000b . 04de1 00
d2422		db	00fh	; 00001111b . 04de2 0f
d2423		db	0f0h	; 11110000b . 04de3 f0
d2424		db	000h	; 00000000b . 04de4 00
d2425		db	000h	; 00000000b . 04de5 00
d2426		db	0ffh	; 11111111b . 04de6 ff
d2427		db	0ffh	; 11111111b . 04de7 ff
d2428		db	000h	; 00000000b . 04de8 00
d2429		db	003h	; 00000011b . 04de9 03
d242a		db	0ffh	; 11111111b . 04dea ff
d242b		db	0ffh	; 11111111b . 04deb ff
d242c		db	0c0h	; 11000000b . 04dec c0
d242d		db	00fh	; 00001111b . 04ded 0f
d242e		db	0ebh	; 11101011b . 04dee eb
d242f		db	0ebh	; 11101011b . 04def eb
d2430		db	0f0h	; 11110000b . 04df0 f0
d2431		db	00fh	; 00001111b . 04df1 0f
d2432		db	0ebh	; 11101011b . 04df2 eb
d2433		db	0ebh	; 11101011b . 04df3 eb
d2434		db	0f0h	; 11110000b . 04df4 f0
d2435		db	03fh	; 00111111b ? 04df5 3f
d2436		db	0ffh	; 11111111b . 04df6 ff
d2437		db	0ffh	; 11111111b . 04df7 ff
d2438		db	0fch	; 11111100b . 04df8 fc
d2439		db	03fh	; 00111111b ? 04df9 3f
d243a		db	0ffh	; 11111111b . 04dfa ff
d243b		db	0ffh	; 11111111b . 04dfb ff
d243c		db	0fch	; 11111100b . 04dfc fc
d243d		db	03fh	; 00111111b ? 04dfd 3f
d243e		db	0ffh	; 11111111b . 04dfe ff
d243f		db	0ffh	; 11111111b . 04dff ff
d2440		db	0fch	; 11111100b . 04e00 fc
d2441		db	000h	; 00000000b . 04e01 00
d2442		db	00fh	; 00001111b . 04e02 0f
d2443		db	0f0h	; 11110000b . 04e03 f0
d2444		db	000h	; 00000000b . 04e04 00
d2445		db	000h	; 00000000b . 04e05 00
d2446		db	0ffh	; 11111111b . 04e06 ff
d2447		db	0ffh	; 11111111b . 04e07 ff
d2448		db	000h	; 00000000b . 04e08 00
d2449		db	003h	; 00000011b . 04e09 03
d244a		db	0ffh	; 11111111b . 04e0a ff
d244b		db	0ffh	; 11111111b . 04e0b ff
d244c		db	0c0h	; 11000000b . 04e0c c0
d244d		db	00fh	; 00001111b . 04e0d 0f
d244e		db	0ebh	; 11101011b . 04e0e eb
d244f		db	0ebh	; 11101011b . 04e0f eb
d2450		db	0f0h	; 11110000b . 04e10 f0
d2451		db	00fh	; 00001111b . 04e11 0f
d2452		db	0ebh	; 11101011b . 04e12 eb
d2453		db	0ebh	; 11101011b . 04e13 eb
d2454		db	0f0h	; 11110000b . 04e14 f0
d2455		db	03fh	; 00111111b ? 04e15 3f
d2456		db	0ffh	; 11111111b . 04e16 ff
d2457		db	0ffh	; 11111111b . 04e17 ff
d2458		db	0fch	; 11111100b . 04e18 fc
d2459		db	03fh	; 00111111b ? 04e19 3f
d245a		db	0ffh	; 11111111b . 04e1a ff
d245b		db	0ffh	; 11111111b . 04e1b ff
d245c		db	0fch	; 11111100b . 04e1c fc
d245d		db	03fh	; 00111111b ? 04e1d 3f
d245e		db	0ffh	; 11111111b . 04e1e ff
d245f		db	0ffh	; 11111111b . 04e1f ff
d2460		db	0fch	; 11111100b . 04e20 fc
d2461		db	000h	; 00000000b . 04e21 00
d2462		db	00fh	; 00001111b . 04e22 0f
d2463		db	0f0h	; 11110000b . 04e23 f0
d2464		db	000h	; 00000000b . 04e24 00
d2465		db	000h	; 00000000b . 04e25 00
d2466		db	0ffh	; 11111111b . 04e26 ff
d2467		db	0ffh	; 11111111b . 04e27 ff
d2468		db	000h	; 00000000b . 04e28 00
d2469		db	003h	; 00000011b . 04e29 03
d246a		db	0ffh	; 11111111b . 04e2a ff
d246b		db	0ffh	; 11111111b . 04e2b ff
d246c		db	0c0h	; 11000000b . 04e2c c0
d246d		db	00fh	; 00001111b . 04e2d 0f
d246e		db	0ebh	; 11101011b . 04e2e eb
d246f		db	0ebh	; 11101011b . 04e2f eb
d2470		db	0f0h	; 11110000b . 04e30 f0
d2471		db	00fh	; 00001111b . 04e31 0f
d2472		db	0ebh	; 11101011b . 04e32 eb
d2473		db	0ebh	; 11101011b . 04e33 eb
d2474		db	0f0h	; 11110000b . 04e34 f0
d2475		db	03fh	; 00111111b ? 04e35 3f
d2476		db	0ffh	; 11111111b . 04e36 ff
d2477		db	0ffh	; 11111111b . 04e37 ff
d2478		db	0fch	; 11111100b . 04e38 fc
d2479		db	03fh	; 00111111b ? 04e39 3f
d247a		db	0ffh	; 11111111b . 04e3a ff
d247b		db	0ffh	; 11111111b . 04e3b ff
d247c		db	0fch	; 11111100b . 04e3c fc
d247d		db	03fh	; 00111111b ? 04e3d 3f
d247e		db	0ffh	; 11111111b . 04e3e ff
d247f		db	0ffh	; 11111111b . 04e3f ff
d2480		db	0fch	; 11111100b . 04e40 fc
d2481		db	03eh	; 00111110b > 04e41 3e
d2482		db	0beh	; 10111110b . 04e42 be
d2483		db	0beh	; 10111110b . 04e43 be
d2484		db	0bch	; 10111100b . 04e44 bc
d2485		db	03bh	; 00111011b ; 04e45 3b
d2486		db	0ebh	; 11101011b . 04e46 eb
d2487		db	0ebh	; 11101011b . 04e47 eb
d2488		db	0ech	; 11101100b . 04e48 ec
d2489		db	03fh	; 00111111b ? 04e49 3f
d248a		db	0ffh	; 11111111b . 04e4a ff
d248b		db	0ffh	; 11111111b . 04e4b ff
d248c		db	0fch	; 11111100b . 04e4c fc
d248d		db	03fh	; 00111111b ? 04e4d 3f
d248e		db	0ffh	; 11111111b . 04e4e ff
d248f		db	0ffh	; 11111111b . 04e4f ff
d2490		db	0fch	; 11111100b . 04e50 fc
d2491		db	03fh	; 00111111b ? 04e51 3f
d2492		db	0cfh	; 11001111b . 04e52 cf
d2493		db	0f3h	; 11110011b . 04e53 f3
d2494		db	0fch	; 11111100b . 04e54 fc
d2495		db	00fh	; 00001111b . 04e55 0f
d2496		db	003h	; 00000011b . 04e56 03
d2497		db	0c0h	; 11000000b . 04e57 c0
d2498		db	0f0h	; 11110000b . 04e58 f0
d2499		db	03ch	; 00111100b < 04e59 3c
d249a		db	0fch	; 11111100b . 04e5a fc
d249b		db	03fh	; 00111111b ? 04e5b 3f
d249c		db	03ch	; 00111100b < 04e5c 3c
d249d		db	030h	; 00110000b 0 04e5d 30
d249e		db	03ch	; 00111100b < 04e5e 3c
d249f		db	03ch	; 00111100b < 04e5f 3c
d24a0		db	00ch	; 00001100b . 04e60 0c
d24a1		db	000h	; 00000000b . 04e61 00
d24a2		db	000h	; 00000000b . 04e62 00
d24a3		db	000h	; 00000000b . 04e63 00
d24a4		db	000h	; 00000000b . 04e64 00
d24a5		db	000h	; 00000000b . 04e65 00
d24a6		db	0a0h	; 10100000b . 04e66 a0
d24a7		db	00ah	; 00001010b . 04e67 0a
d24a8		db	000h	; 00000000b . 04e68 00
d24a9		db	003h	; 00000011b . 04e69 03
d24aa		db	0ach	; 10101100b . 04e6a ac
d24ab		db	03ah	; 00111010b : 04e6b 3a
d24ac		db	0c0h	; 11000000b . 04e6c c0
d24ad		db	003h	; 00000011b . 04e6d 03
d24ae		db	0fch	; 11111100b . 04e6e fc
d24af		db	03fh	; 00111111b ? 04e6f 3f
d24b0		db	0c0h	; 11000000b . 04e70 c0
d24b1		db	003h	; 00000011b . 04e71 03
d24b2		db	0fch	; 11111100b . 04e72 fc
d24b3		db	03fh	; 00111111b ? 04e73 3f
d24b4		db	0c0h	; 11000000b . 04e74 c0
d24b5		db	000h	; 00000000b . 04e75 00
d24b6		db	0f0h	; 11110000b . 04e76 f0
d24b7		db	00fh	; 00001111b . 04e77 0f
d24b8		db	000h	; 00000000b . 04e78 00
d24b9		db	000h	; 00000000b . 04e79 00
d24ba		db	000h	; 00000000b . 04e7a 00
d24bb		db	000h	; 00000000b . 04e7b 00
d24bc		db	000h	; 00000000b . 04e7c 00
d24bd		db	000h	; 00000000b . 04e7d 00
d24be		db	000h	; 00000000b . 04e7e 00
d24bf		db	000h	; 00000000b . 04e7f 00
d24c0		db	000h	; 00000000b . 04e80 00
d24c1		db	000h	; 00000000b . 04e81 00
d24c2		db	000h	; 00000000b . 04e82 00
d24c3		db	000h	; 00000000b . 04e83 00
d24c4		db	000h	; 00000000b . 04e84 00
d24c5		db	000h	; 00000000b . 04e85 00
d24c6		db	000h	; 00000000b . 04e86 00
d24c7		db	000h	; 00000000b . 04e87 00
d24c8		db	000h	; 00000000b . 04e88 00
d24c9		db	000h	; 00000000b . 04e89 00
d24ca		db	000h	; 00000000b . 04e8a 00
d24cb		db	000h	; 00000000b . 04e8b 00
d24cc		db	000h	; 00000000b . 04e8c 00
d24cd		db	000h	; 00000000b . 04e8d 00
d24ce		db	0f0h	; 11110000b . 04e8e f0
d24cf		db	00fh	; 00001111b . 04e8f 0f
d24d0		db	000h	; 00000000b . 04e90 00
d24d1		db	003h	; 00000011b . 04e91 03
d24d2		db	0fch	; 11111100b . 04e92 fc
d24d3		db	03fh	; 00111111b ? 04e93 3f
d24d4		db	0c0h	; 11000000b . 04e94 c0
d24d5		db	003h	; 00000011b . 04e95 03
d24d6		db	0fch	; 11111100b . 04e96 fc
d24d7		db	03fh	; 00111111b ? 04e97 3f
d24d8		db	0c0h	; 11000000b . 04e98 c0
d24d9		db	003h	; 00000011b . 04e99 03
d24da		db	0ach	; 10101100b . 04e9a ac
d24db		db	03ah	; 00111010b : 04e9b 3a
d24dc		db	0c0h	; 11000000b . 04e9c c0
d24dd		db	000h	; 00000000b . 04e9d 00
d24de		db	0a0h	; 10100000b . 04e9e a0
d24df		db	00ah	; 00001010b . 04e9f 0a
d24e0		db	000h	; 00000000b . 04ea0 00
d24e1		db	000h	; 00000000b . 04ea1 00
d24e2		db	000h	; 00000000b . 04ea2 00
d24e3		db	000h	; 00000000b . 04ea3 00
d24e4		db	000h	; 00000000b . 04ea4 00
d24e5		db	000h	; 00000000b . 04ea5 00
d24e6		db	000h	; 00000000b . 04ea6 00
d24e7		db	000h	; 00000000b . 04ea7 00
d24e8		db	000h	; 00000000b . 04ea8 00
d24e9		db	000h	; 00000000b . 04ea9 00
d24ea		db	0f0h	; 11110000b . 04eaa f0
d24eb		db	00fh	; 00001111b . 04eab 0f
d24ec		db	000h	; 00000000b . 04eac 00
d24ed		db	003h	; 00000011b . 04ead 03
d24ee		db	0fch	; 11111100b . 04eae fc
d24ef		db	03fh	; 00111111b ? 04eaf 3f
d24f0		db	0c0h	; 11000000b . 04eb0 c0
d24f1		db	002h	; 00000010b . 04eb1 02
d24f2		db	0bch	; 10111100b . 04eb2 bc
d24f3		db	02bh	; 00101011b + 04eb3 2b
d24f4		db	0c0h	; 11000000b . 04eb4 c0
d24f5		db	002h	; 00000010b . 04eb5 02
d24f6		db	0bch	; 10111100b . 04eb6 bc
d24f7		db	02bh	; 00101011b + 04eb7 2b
d24f8		db	0c0h	; 11000000b . 04eb8 c0
d24f9		db	000h	; 00000000b . 04eb9 00
d24fa		db	0f0h	; 11110000b . 04eba f0
d24fb		db	00fh	; 00001111b . 04ebb 0f
d24fc		db	000h	; 00000000b . 04ebc 00
d24fd		db	000h	; 00000000b . 04ebd 00
d24fe		db	000h	; 00000000b . 04ebe 00
d24ff		db	000h	; 00000000b . 04ebf 00
d2500		db	000h	; 00000000b . 04ec0 00
d2501		db	000h	; 00000000b . 04ec1 00
d2502		db	000h	; 00000000b . 04ec2 00
d2503		db	000h	; 00000000b . 04ec3 00
d2504		db	000h	; 00000000b . 04ec4 00
d2505		db	000h	; 00000000b . 04ec5 00
d2506		db	000h	; 00000000b . 04ec6 00
d2507		db	000h	; 00000000b . 04ec7 00
d2508		db	000h	; 00000000b . 04ec8 00
d2509		db	000h	; 00000000b . 04ec9 00
d250a		db	0f0h	; 11110000b . 04eca f0
d250b		db	00fh	; 00001111b . 04ecb 0f
d250c		db	000h	; 00000000b . 04ecc 00
d250d		db	003h	; 00000011b . 04ecd 03
d250e		db	0fch	; 11111100b . 04ece fc
d250f		db	03fh	; 00111111b ? 04ecf 3f
d2510		db	0c0h	; 11000000b . 04ed0 c0
d2511		db	003h	; 00000011b . 04ed1 03
d2512		db	0e8h	; 11101000b . 04ed2 e8
d2513		db	03eh	; 00111110b > 04ed3 3e
d2514		db	080h	; 10000000b . 04ed4 80
d2515		db	003h	; 00000011b . 04ed5 03
d2516		db	0e8h	; 11101000b . 04ed6 e8
d2517		db	03eh	; 00111110b > 04ed7 3e
d2518		db	080h	; 10000000b . 04ed8 80
d2519		db	000h	; 00000000b . 04ed9 00
d251a		db	0f0h	; 11110000b . 04eda f0
d251b		db	00fh	; 00001111b . 04edb 0f
d251c		db	000h	; 00000000b . 04edc 00
d251d		db	000h	; 00000000b . 04edd 00
d251e		db	000h	; 00000000b . 04ede 00
d251f		db	000h	; 00000000b . 04edf 00
d2520		db	000h	; 00000000b . 04ee0 00
d2521		db	000h	; 00000000b . 04ee1 00
d2522		db	000h	; 00000000b . 04ee2 00
d2523		db	000h	; 00000000b . 04ee3 00
d2524		db	000h	; 00000000b . 04ee4 00
d2525		db	000h	; 00000000b . 04ee5 00
d2526		db	000h	; 00000000b . 04ee6 00
d2527		db	000h	; 00000000b . 04ee7 00
d2528		db	000h	; 00000000b . 04ee8 00
d2529		db	000h	; 00000000b . 04ee9 00
d252a		db	000h	; 00000000b . 04eea 00
d252b		db	000h	; 00000000b . 04eeb 00
d252c		db	000h	; 00000000b . 04eec 00
d252d		db	000h	; 00000000b . 04eed 00
d252e		db	000h	; 00000000b . 04eee 00
d252f		db	000h	; 00000000b . 04eef 00
d2530		db	000h	; 00000000b . 04ef0 00
d2531		db	000h	; 00000000b . 04ef1 00
d2532		db	000h	; 00000000b . 04ef2 00
d2533		db	000h	; 00000000b . 04ef3 00
d2534		db	000h	; 00000000b . 04ef4 00
d2535		db	000h	; 00000000b . 04ef5 00
d2536		db	000h	; 00000000b . 04ef6 00
d2537		db	000h	; 00000000b . 04ef7 00
d2538		db	000h	; 00000000b . 04ef8 00
d2539		db	000h	; 00000000b . 04ef9 00
d253a		db	000h	; 00000000b . 04efa 00
d253b		db	000h	; 00000000b . 04efb 00
d253c		db	000h	; 00000000b . 04efc 00
d253d		db	000h	; 00000000b . 04efd 00
d253e		db	000h	; 00000000b . 04efe 00
d253f		db	000h	; 00000000b . 04eff 00
d2540		db	000h	; 00000000b . 04f00 00
d2541		db	03fh	; 00111111b ? 04f01 3f
d2542		db	0f0h	; 11110000b . 04f02 f0
d2543		db	0f0h	; 11110000b . 04f03 f0
d2544		db	03ch	; 00111100b < 04f04 3c
d2545		db	0f0h	; 11110000b . 04f05 f0
d2546		db	0fch	; 11111100b . 04f06 fc
d2547		db	0f3h	; 11110011b . 04f07 f3
d2548		db	0fch	; 11111100b . 04f08 fc
d2549		db	0ffh	; 11111111b . 04f09 ff
d254a		db	03ch	; 00111100b < 04f0a 3c
d254b		db	0fch	; 11111100b . 04f0b fc
d254c		db	03ch	; 00111100b < 04f0c 3c
d254d		db	03fh	; 00111111b ? 04f0d 3f
d254e		db	0f0h	; 11110000b . 04f0e f0
d254f		db	000h	; 00000000b . 04f0f 00
d2550		db	000h	; 00000000b . 04f10 00
d2551		db	00fh	; 00001111b . 04f11 0f
d2552		db	000h	; 00000000b . 04f12 00
d2553		db	03fh	; 00111111b ? 04f13 3f
d2554		db	000h	; 00000000b . 04f14 00
d2555		db	00fh	; 00001111b . 04f15 0f
d2556		db	000h	; 00000000b . 04f16 00
d2557		db	00fh	; 00001111b . 04f17 0f
d2558		db	000h	; 00000000b . 04f18 00
d2559		db	00fh	; 00001111b . 04f19 0f
d255a		db	000h	; 00000000b . 04f1a 00
d255b		db	00fh	; 00001111b . 04f1b 0f
d255c		db	000h	; 00000000b . 04f1c 00
d255d		db	0ffh	; 11111111b . 04f1d ff
d255e		db	0f0h	; 11110000b . 04f1e f0
d255f		db	000h	; 00000000b . 04f1f 00
d2560		db	000h	; 00000000b . 04f20 00
d2561		db	03fh	; 00111111b ? 04f21 3f
d2562		db	0c0h	; 11000000b . 04f22 c0
d2563		db	0f0h	; 11110000b . 04f23 f0
d2564		db	0f0h	; 11110000b . 04f24 f0
d2565		db	000h	; 00000000b . 04f25 00
d2566		db	0f0h	; 11110000b . 04f26 f0
d2567		db	00fh	; 00001111b . 04f27 0f
d2568		db	0c0h	; 11000000b . 04f28 c0
d2569		db	03ch	; 00111100b < 04f29 3c
d256a		db	000h	; 00000000b . 04f2a 00
d256b		db	0f0h	; 11110000b . 04f2b f0
d256c		db	0f0h	; 11110000b . 04f2c f0
d256d		db	0ffh	; 11111111b . 04f2d ff
d256e		db	0f0h	; 11110000b . 04f2e f0
d256f		db	000h	; 00000000b . 04f2f 00
d2570		db	000h	; 00000000b . 04f30 00
d2571		db	03fh	; 00111111b ? 04f31 3f
d2572		db	0c0h	; 11000000b . 04f32 c0
d2573		db	0f0h	; 11110000b . 04f33 f0
d2574		db	0f0h	; 11110000b . 04f34 f0
d2575		db	000h	; 00000000b . 04f35 00
d2576		db	0f0h	; 11110000b . 04f36 f0
d2577		db	00fh	; 00001111b . 04f37 0f
d2578		db	0c0h	; 11000000b . 04f38 c0
d2579		db	000h	; 00000000b . 04f39 00
d257a		db	0f0h	; 11110000b . 04f3a f0
d257b		db	0f0h	; 11110000b . 04f3b f0
d257c		db	0f0h	; 11110000b . 04f3c f0
d257d		db	03fh	; 00111111b ? 04f3d 3f
d257e		db	0c0h	; 11000000b . 04f3e c0
d257f		db	000h	; 00000000b . 04f3f 00
d2580		db	000h	; 00000000b . 04f40 00
d2581		db	003h	; 00000011b . 04f41 03
d2582		db	0f0h	; 11110000b . 04f42 f0
d2583		db	00fh	; 00001111b . 04f43 0f
d2584		db	0f0h	; 11110000b . 04f44 f0
d2585		db	03ch	; 00111100b < 04f45 3c
d2586		db	0f0h	; 11110000b . 04f46 f0
d2587		db	0f0h	; 11110000b . 04f47 f0
d2588		db	0f0h	; 11110000b . 04f48 f0
d2589		db	0ffh	; 11111111b . 04f49 ff
d258a		db	0fch	; 11111100b . 04f4a fc
d258b		db	000h	; 00000000b . 04f4b 00
d258c		db	0f0h	; 11110000b . 04f4c f0
d258d		db	003h	; 00000011b . 04f4d 03
d258e		db	0fch	; 11111100b . 04f4e fc
d258f		db	000h	; 00000000b . 04f4f 00
d2590		db	000h	; 00000000b . 04f50 00
d2591		db	0ffh	; 11111111b . 04f51 ff
d2592		db	0f0h	; 11110000b . 04f52 f0
d2593		db	0f0h	; 11110000b . 04f53 f0
d2594		db	000h	; 00000000b . 04f54 00
d2595		db	0ffh	; 11111111b . 04f55 ff
d2596		db	0c0h	; 11000000b . 04f56 c0
d2597		db	000h	; 00000000b . 04f57 00
d2598		db	0f0h	; 11110000b . 04f58 f0
d2599		db	000h	; 00000000b . 04f59 00
d259a		db	0f0h	; 11110000b . 04f5a f0
d259b		db	0f0h	; 11110000b . 04f5b f0
d259c		db	0f0h	; 11110000b . 04f5c f0
d259d		db	03fh	; 00111111b ? 04f5d 3f
d259e		db	0c0h	; 11000000b . 04f5e c0
d259f		db	000h	; 00000000b . 04f5f 00
d25a0		db	000h	; 00000000b . 04f60 00
d25a1		db	00fh	; 00001111b . 04f61 0f
d25a2		db	0c0h	; 11000000b . 04f62 c0
d25a3		db	03ch	; 00111100b < 04f63 3c
d25a4		db	000h	; 00000000b . 04f64 00
d25a5		db	0f0h	; 11110000b . 04f65 f0
d25a6		db	000h	; 00000000b . 04f66 00
d25a7		db	0ffh	; 11111111b . 04f67 ff
d25a8		db	0c0h	; 11000000b . 04f68 c0
d25a9		db	0f0h	; 11110000b . 04f69 f0
d25aa		db	0f0h	; 11110000b . 04f6a f0
d25ab		db	0f0h	; 11110000b . 04f6b f0
d25ac		db	0f0h	; 11110000b . 04f6c f0
d25ad		db	03fh	; 00111111b ? 04f6d 3f
d25ae		db	0c0h	; 11000000b . 04f6e c0
d25af		db	000h	; 00000000b . 04f6f 00
d25b0		db	000h	; 00000000b . 04f70 00
d25b1		db	0ffh	; 11111111b . 04f71 ff
d25b2		db	0f0h	; 11110000b . 04f72 f0
d25b3		db	0f0h	; 11110000b . 04f73 f0
d25b4		db	0f0h	; 11110000b . 04f74 f0
d25b5		db	000h	; 00000000b . 04f75 00
d25b6		db	0f0h	; 11110000b . 04f76 f0
d25b7		db	003h	; 00000011b . 04f77 03
d25b8		db	0c0h	; 11000000b . 04f78 c0
d25b9		db	00fh	; 00001111b . 04f79 0f
d25ba		db	000h	; 00000000b . 04f7a 00
d25bb		db	00fh	; 00001111b . 04f7b 0f
d25bc		db	000h	; 00000000b . 04f7c 00
d25bd		db	00fh	; 00001111b . 04f7d 0f
d25be		db	000h	; 00000000b . 04f7e 00
d25bf		db	000h	; 00000000b . 04f7f 00
d25c0		db	000h	; 00000000b . 04f80 00
d25c1		db	03fh	; 00111111b ? 04f81 3f
d25c2		db	0c0h	; 11000000b . 04f82 c0
d25c3		db	0f0h	; 11110000b . 04f83 f0
d25c4		db	0f0h	; 11110000b . 04f84 f0
d25c5		db	0f0h	; 11110000b . 04f85 f0
d25c6		db	0f0h	; 11110000b . 04f86 f0
d25c7		db	03fh	; 00111111b ? 04f87 3f
d25c8		db	0c0h	; 11000000b . 04f88 c0
d25c9		db	0f0h	; 11110000b . 04f89 f0
d25ca		db	0f0h	; 11110000b . 04f8a f0
d25cb		db	0f0h	; 11110000b . 04f8b f0
d25cc		db	0f0h	; 11110000b . 04f8c f0
d25cd		db	03fh	; 00111111b ? 04f8d 3f
d25ce		db	0c0h	; 11000000b . 04f8e c0
d25cf		db	000h	; 00000000b . 04f8f 00
d25d0		db	000h	; 00000000b . 04f90 00
d25d1		db	03fh	; 00111111b ? 04f91 3f
d25d2		db	0c0h	; 11000000b . 04f92 c0
d25d3		db	0f0h	; 11110000b . 04f93 f0
d25d4		db	0f0h	; 11110000b . 04f94 f0
d25d5		db	0f0h	; 11110000b . 04f95 f0
d25d6		db	0f0h	; 11110000b . 04f96 f0
d25d7		db	03fh	; 00111111b ? 04f97 3f
d25d8		db	0f0h	; 11110000b . 04f98 f0
d25d9		db	000h	; 00000000b . 04f99 00
d25da		db	0f0h	; 11110000b . 04f9a f0
d25db		db	003h	; 00000011b . 04f9b 03
d25dc		db	0c0h	; 11000000b . 04f9c c0
d25dd		db	03fh	; 00111111b ? 04f9d 3f
d25de		db	000h	; 00000000b . 04f9e 00
d25df		db	000h	; 00000000b . 04f9f 00
d25e0		db	000h	; 00000000b . 04fa0 00
d25e1		db	000h	; 00000000b . 04fa1 00
d25e2		db	000h	; 00000000b . 04fa2 00
d25e3		db	000h	; 00000000b . 04fa3 00
d25e4		db	000h	; 00000000b . 04fa4 00
d25e5		db	000h	; 00000000b . 04fa5 00
d25e6		db	000h	; 00000000b . 04fa6 00
d25e7		db	000h	; 00000000b . 04fa7 00
d25e8		db	000h	; 00000000b . 04fa8 00
d25e9		db	000h	; 00000000b . 04fa9 00
d25ea		db	000h	; 00000000b . 04faa 00
d25eb		db	000h	; 00000000b . 04fab 00
d25ec		db	000h	; 00000000b . 04fac 00
d25ed		db	000h	; 00000000b . 04fad 00
d25ee		db	000h	; 00000000b . 04fae 00
d25ef		db	000h	; 00000000b . 04faf 00
d25f0		db	000h	; 00000000b . 04fb0 00
d25f1		db	002h	; 00000010b . 04fb1 02
d25f2		db	00fh	; 00001111b . 04fb2 0f
d25f3		db	003h	; 00000011b . 04fb3 03
d25f4		db	0c0h	; 11000000b . 04fb4 c0
d25f5		db	0f0h	; 11110000b . 04fb5 f0
d25f6		db	030h	; 00110000b 0 04fb6 30
d25f7		db	0cch	; 11001100b . 04fb7 cc
d25f8		db	033h	; 00110011b 3 04fb8 33
d25f9		db	00ch	; 00001100b . 04fb9 0c
d25fa		db	000h	; 00000000b . 04fba 00
d25fb		db	0cch	; 11001100b . 04fbb cc
d25fc		db	033h	; 00110011b 3 04fbc 33
d25fd		db	00ch	; 00001100b . 04fbd 0c
d25fe		db	003h	; 00000011b . 04fbe 03
d25ff		db	00ch	; 00001100b . 04fbf 0c
d2600		db	033h	; 00110011b 3 04fc0 33
d2601		db	00ch	; 00001100b . 04fc1 0c
d2602		db	00ch	; 00001100b . 04fc2 0c
d2603		db	00ch	; 00001100b . 04fc3 0c
d2604		db	033h	; 00110011b 3 04fc4 33
d2605		db	00ch	; 00001100b . 04fc5 0c
d2606		db	030h	; 00110000b 0 04fc6 30
d2607		db	00ch	; 00001100b . 04fc7 0c
d2608		db	033h	; 00110011b 3 04fc8 33
d2609		db	00ch	; 00001100b . 04fc9 0c
d260a		db	03fh	; 00111111b ? 04fca 3f
d260b		db	0c3h	; 11000011b . 04fcb c3
d260c		db	0c0h	; 11000000b . 04fcc c0
d260d		db	0f0h	; 11110000b . 04fcd f0
d260e		db	000h	; 00000000b . 04fce 00
d260f		db	000h	; 00000000b . 04fcf 00
d2610		db	000h	; 00000000b . 04fd0 00
d2611		db	000h	; 00000000b . 04fd1 00
d2612		db	004h	; 00000100b . 04fd2 04
d2613		db	030h	; 00110000b 0 04fd3 30
d2614		db	0c3h	; 11000011b . 04fd4 c3
d2615		db	0c0h	; 11000000b . 04fd5 c0
d2616		db	0f0h	; 11110000b . 04fd6 f0
d2617		db	030h	; 00110000b 0 04fd7 30
d2618		db	0cch	; 11001100b . 04fd8 cc
d2619		db	033h	; 00110011b 3 04fd9 33
d261a		db	00ch	; 00001100b . 04fda 0c
d261b		db	030h	; 00110000b 0 04fdb 30
d261c		db	0cch	; 11001100b . 04fdc cc
d261d		db	033h	; 00110011b 3 04fdd 33
d261e		db	00ch	; 00001100b . 04fde 0c
d261f		db	03fh	; 00111111b ? 04fdf 3f
d2620		db	0cch	; 11001100b . 04fe0 cc
d2621		db	033h	; 00110011b 3 04fe1 33
d2622		db	00ch	; 00001100b . 04fe2 0c
d2623		db	000h	; 00000000b . 04fe3 00
d2624		db	0cch	; 11001100b . 04fe4 cc
d2625		db	033h	; 00110011b 3 04fe5 33
d2626		db	00ch	; 00001100b . 04fe6 0c
d2627		db	000h	; 00000000b . 04fe7 00
d2628		db	0cch	; 11001100b . 04fe8 cc
d2629		db	033h	; 00110011b 3 04fe9 33
d262a		db	00ch	; 00001100b . 04fea 0c
d262b		db	000h	; 00000000b . 04feb 00
d262c		db	0c3h	; 11000011b . 04fec c3
d262d		db	0c0h	; 11000000b . 04fed c0
d262e		db	0f0h	; 11110000b . 04fee f0
d262f		db	000h	; 00000000b . 04fef 00
d2630		db	000h	; 00000000b . 04ff0 00
d2631		db	000h	; 00000000b . 04ff1 00
d2632		db	000h	; 00000000b . 04ff2 00
d2633		db	008h	; 00001000b . 04ff3 08
d2634		db	00fh	; 00001111b . 04ff4 0f
d2635		db	003h	; 00000011b . 04ff5 03
d2636		db	0c0h	; 11000000b . 04ff6 c0
d2637		db	0f0h	; 11110000b . 04ff7 f0
d2638		db	030h	; 00110000b 0 04ff8 30
d2639		db	0cch	; 11001100b . 04ff9 cc
d263a		db	033h	; 00110011b 3 04ffa 33
d263b		db	00ch	; 00001100b . 04ffb 0c
d263c		db	030h	; 00110000b 0 04ffc 30
d263d		db	0cch	; 11001100b . 04ffd cc
d263e		db	033h	; 00110011b 3 04ffe 33
d263f		db	00ch	; 00001100b . 04fff 0c
d2640		db	00fh	; 00001111b . 05000 0f
d2641		db	00ch	; 00001100b . 05001 0c
d2642		db	033h	; 00110011b 3 05002 33
d2643		db	00ch	; 00001100b . 05003 0c
d2644		db	030h	; 00110000b 0 05004 30
d2645		db	0cch	; 11001100b . 05005 cc
d2646		db	033h	; 00110011b 3 05006 33
d2647		db	00ch	; 00001100b . 05007 0c
d2648		db	030h	; 00110000b 0 05008 30
d2649		db	0cch	; 11001100b . 05009 cc
d264a		db	033h	; 00110011b 3 0500a 33
d264b		db	00ch	; 00001100b . 0500b 0c
d264c		db	00fh	; 00001111b . 0500c 0f
d264d		db	003h	; 00000011b . 0500d 03
d264e		db	0c0h	; 11000000b . 0500e c0
d264f		db	0f0h	; 11110000b . 0500f f0
d2650		db	000h	; 00000000b . 05010 00
d2651		db	000h	; 00000000b . 05011 00
d2652		db	000h	; 00000000b . 05012 00
d2653		db	000h	; 00000000b . 05013 00
d2654		db	010h	; 00010000b . 05014 10
d2655		db	0c3h	; 11000011b . 05015 c3
d2656		db	0c0h	; 11000000b . 05016 c0
d2657		db	0f0h	; 11110000b . 05017 f0
d2658		db	03ch	; 00111100b < 05018 3c
d2659		db	0cch	; 11001100b . 05019 cc
d265a		db	033h	; 00110011b 3 0501a 33
d265b		db	00ch	; 00001100b . 0501b 0c
d265c		db	0c3h	; 11000011b . 0501c c3
d265d		db	0cch	; 11001100b . 0501d cc
d265e		db	003h	; 00000011b . 0501e 03
d265f		db	00ch	; 00001100b . 0501f 0c
d2660		db	0c3h	; 11000011b . 05020 c3
d2661		db	0cfh	; 11001111b . 05021 cf
d2662		db	0c3h	; 11000011b . 05022 c3
d2663		db	00ch	; 00001100b . 05023 0c
d2664		db	0c3h	; 11000011b . 05024 c3
d2665		db	0cch	; 11001100b . 05025 cc
d2666		db	033h	; 00110011b 3 05026 33
d2667		db	00ch	; 00001100b . 05027 0c
d2668		db	0c3h	; 11000011b . 05028 c3
d2669		db	0cch	; 11001100b . 05029 cc
d266a		db	033h	; 00110011b 3 0502a 33
d266b		db	00ch	; 00001100b . 0502b 0c
d266c		db	0c3h	; 11000011b . 0502c c3
d266d		db	0c3h	; 11000011b . 0502d c3
d266e		db	0c0h	; 11000000b . 0502e c0
d266f		db	0f0h	; 11110000b . 0502f f0
d2670		db	03ch	; 00111100b < 05030 3c
d2671		db	000h	; 00000000b . 05031 00
d2672		db	000h	; 00000000b . 05032 00
d2673		db	000h	; 00000000b . 05033 00
d2674		db	000h	; 00000000b . 05034 00
d2675		db	000h	; 00000000b . 05035 00
d2676		db	000h	; 00000000b . 05036 00
d2677		db	000h	; 00000000b . 05037 00
d2678		db	000h	; 00000000b . 05038 00
d2679		db	000h	; 00000000b . 05039 00
d267a		db	000h	; 00000000b . 0503a 00
d267b		db	000h	; 00000000b . 0503b 00
d267c		db	000h	; 00000000b . 0503c 00
d267d		db	03ch	; 00111100b < 0503d 3c
d267e		db	000h	; 00000000b . 0503e 00
d267f		db	000h	; 00000000b . 0503f 00
d2680		db	0f0h	; 11110000b . 05040 f0
d2681		db	03fh	; 00111111b ? 05041 3f
d2682		db	000h	; 00000000b . 05042 00
d2683		db	003h	; 00000011b . 05043 03
d2684		db	0f0h	; 11110000b . 05044 f0
d2685		db	03fh	; 00111111b ? 05045 3f
d2686		db	0c0h	; 11000000b . 05046 c0
d2687		db	00fh	; 00001111b . 05047 0f
d2688		db	0f0h	; 11110000b . 05048 f0
d2689		db	03fh	; 00111111b ? 05049 3f
d268a		db	0f0h	; 11110000b . 0504a f0
d268b		db	03fh	; 00111111b ? 0504b 3f
d268c		db	0f0h	; 11110000b . 0504c f0
d268d		db	03fh	; 00111111b ? 0504d 3f
d268e		db	0fch	; 11111100b . 0504e fc
d268f		db	0ffh	; 11111111b . 0504f ff
d2690		db	0f0h	; 11110000b . 05050 f0
d2691		db	00fh	; 00001111b . 05051 0f
d2692		db	0ffh	; 11111111b . 05052 ff
d2693		db	0ffh	; 11111111b . 05053 ff
d2694		db	0c0h	; 11000000b . 05054 c0
d2695		db	00fh	; 00001111b . 05055 0f
d2696		db	0ffh	; 11111111b . 05056 ff
d2697		db	0ffh	; 11111111b . 05057 ff
d2698		db	0c0h	; 11000000b . 05058 c0
d2699		db	003h	; 00000011b . 05059 03
d269a		db	0ffh	; 11111111b . 0505a ff
d269b		db	0ffh	; 11111111b . 0505b ff
d269c		db	000h	; 00000000b . 0505c 00
d269d		db	000h	; 00000000b . 0505d 00
d269e		db	03fh	; 00111111b ? 0505e 3f
d269f		db	0f0h	; 11110000b . 0505f f0
d26a0		db	000h	; 00000000b . 05060 00
d26a1		db	000h	; 00000000b . 05061 00
d26a2		db	000h	; 00000000b . 05062 00
d26a3		db	000h	; 00000000b . 05063 00
d26a4		db	000h	; 00000000b . 05064 00
d26a5		db	000h	; 00000000b . 05065 00
d26a6		db	000h	; 00000000b . 05066 00
d26a7		db	000h	; 00000000b . 05067 00
d26a8		db	000h	; 00000000b . 05068 00
d26a9		db	000h	; 00000000b . 05069 00
d26aa		db	000h	; 00000000b . 0506a 00
d26ab		db	000h	; 00000000b . 0506b 00
d26ac		db	000h	; 00000000b . 0506c 00
d26ad		db	000h	; 00000000b . 0506d 00
d26ae		db	000h	; 00000000b . 0506e 00
d26af		db	000h	; 00000000b . 0506f 00
d26b0		db	000h	; 00000000b . 05070 00
d26b1		db	000h	; 00000000b . 05071 00
d26b2		db	000h	; 00000000b . 05072 00
d26b3		db	000h	; 00000000b . 05073 00
d26b4		db	000h	; 00000000b . 05074 00
d26b5		db	000h	; 00000000b . 05075 00
d26b6		db	000h	; 00000000b . 05076 00
d26b7		db	000h	; 00000000b . 05077 00
d26b8		db	000h	; 00000000b . 05078 00
d26b9		db	03ch	; 00111100b < 05079 3c
d26ba		db	000h	; 00000000b . 0507a 00
d26bb		db	000h	; 00000000b . 0507b 00
d26bc		db	0f0h	; 11110000b . 0507c f0
d26bd		db	03fh	; 00111111b ? 0507d 3f
d26be		db	000h	; 00000000b . 0507e 00
d26bf		db	003h	; 00000011b . 0507f 03
d26c0		db	0f0h	; 11110000b . 05080 f0
d26c1		db	03fh	; 00111111b ? 05081 3f
d26c2		db	0c0h	; 11000000b . 05082 c0
d26c3		db	00fh	; 00001111b . 05083 0f
d26c4		db	0f0h	; 11110000b . 05084 f0
d26c5		db	03fh	; 00111111b ? 05085 3f
d26c6		db	0fch	; 11111100b . 05086 fc
d26c7		db	0ffh	; 11111111b . 05087 ff
d26c8		db	0f0h	; 11110000b . 05088 f0
d26c9		db	03fh	; 00111111b ? 05089 3f
d26ca		db	0ffh	; 11111111b . 0508a ff
d26cb		db	0ffh	; 11111111b . 0508b ff
d26cc		db	0f0h	; 11110000b . 0508c f0
d26cd		db	00fh	; 00001111b . 0508d 0f
d26ce		db	0ffh	; 11111111b . 0508e ff
d26cf		db	0ffh	; 11111111b . 0508f ff
d26d0		db	0c0h	; 11000000b . 05090 c0
d26d1		db	003h	; 00000011b . 05091 03
d26d2		db	0ffh	; 11111111b . 05092 ff
d26d3		db	0ffh	; 11111111b . 05093 ff
d26d4		db	000h	; 00000000b . 05094 00
d26d5		db	000h	; 00000000b . 05095 00
d26d6		db	03fh	; 00111111b ? 05096 3f
d26d7		db	0f0h	; 11110000b . 05097 f0
d26d8		db	000h	; 00000000b . 05098 00
d26d9		db	000h	; 00000000b . 05099 00
d26da		db	000h	; 00000000b . 0509a 00
d26db		db	000h	; 00000000b . 0509b 00
d26dc		db	000h	; 00000000b . 0509c 00
d26dd		db	000h	; 00000000b . 0509d 00
d26de		db	000h	; 00000000b . 0509e 00
d26df		db	000h	; 00000000b . 0509f 00
d26e0		db	000h	; 00000000b . 050a0 00
d26e1		db	000h	; 00000000b . 050a1 00
d26e2		db	000h	; 00000000b . 050a2 00
d26e3		db	000h	; 00000000b . 050a3 00
d26e4		db	000h	; 00000000b . 050a4 00
d26e5		db	000h	; 00000000b . 050a5 00
d26e6		db	000h	; 00000000b . 050a6 00
d26e7		db	000h	; 00000000b . 050a7 00
d26e8		db	000h	; 00000000b . 050a8 00
d26e9		db	000h	; 00000000b . 050a9 00
d26ea		db	000h	; 00000000b . 050aa 00
d26eb		db	000h	; 00000000b . 050ab 00
d26ec		db	000h	; 00000000b . 050ac 00
d26ed		db	000h	; 00000000b . 050ad 00
d26ee		db	000h	; 00000000b . 050ae 00
d26ef		db	000h	; 00000000b . 050af 00
d26f0		db	000h	; 00000000b . 050b0 00
d26f1		db	000h	; 00000000b . 050b1 00
d26f2		db	000h	; 00000000b . 050b2 00
d26f3		db	000h	; 00000000b . 050b3 00
d26f4		db	000h	; 00000000b . 050b4 00
d26f5		db	0f0h	; 11110000b . 050b5 f0
d26f6		db	000h	; 00000000b . 050b6 00
d26f7		db	000h	; 00000000b . 050b7 00
d26f8		db	03ch	; 00111100b < 050b8 3c
d26f9		db	0ffh	; 11111111b . 050b9 ff
d26fa		db	0c0h	; 11000000b . 050ba c0
d26fb		db	00fh	; 00001111b . 050bb 0f
d26fc		db	0fch	; 11111100b . 050bc fc
d26fd		db	03fh	; 00111111b ? 050bd 3f
d26fe		db	0fch	; 11111100b . 050be fc
d26ff		db	0ffh	; 11111111b . 050bf ff
d2700		db	0f0h	; 11110000b . 050c0 f0
d2701		db	03fh	; 00111111b ? 050c1 3f
d2702		db	0ffh	; 11111111b . 050c2 ff
d2703		db	0ffh	; 11111111b . 050c3 ff
d2704		db	0f0h	; 11110000b . 050c4 f0
d2705		db	00fh	; 00001111b . 050c5 0f
d2706		db	0ffh	; 11111111b . 050c6 ff
d2707		db	0ffh	; 11111111b . 050c7 ff
d2708		db	0c0h	; 11000000b . 050c8 c0
d2709		db	003h	; 00000011b . 050c9 03
d270a		db	0ffh	; 11111111b . 050ca ff
d270b		db	0ffh	; 11111111b . 050cb ff
d270c		db	000h	; 00000000b . 050cc 00
d270d		db	000h	; 00000000b . 050cd 00
d270e		db	0ffh	; 11111111b . 050ce ff
d270f		db	0fch	; 11111100b . 050cf fc
d2710		db	000h	; 00000000b . 050d0 00
d2711		db	000h	; 00000000b . 050d1 00
d2712		db	000h	; 00000000b . 050d2 00
d2713		db	000h	; 00000000b . 050d3 00
d2714		db	000h	; 00000000b . 050d4 00
d2715		db	000h	; 00000000b . 050d5 00
d2716		db	000h	; 00000000b . 050d6 00
d2717		db	000h	; 00000000b . 050d7 00
d2718		db	000h	; 00000000b . 050d8 00
d2719		db	000h	; 00000000b . 050d9 00
d271a		db	000h	; 00000000b . 050da 00
d271b		db	000h	; 00000000b . 050db 00
d271c		db	000h	; 00000000b . 050dc 00
d271d		db	000h	; 00000000b . 050dd 00
d271e		db	000h	; 00000000b . 050de 00
d271f		db	000h	; 00000000b . 050df 00
d2720		db	000h	; 00000000b . 050e0 00
d2721		db	000h	; 00000000b . 050e1 00
d2722		db	000h	; 00000000b . 050e2 00
d2723		db	000h	; 00000000b . 050e3 00
d2724		db	000h	; 00000000b . 050e4 00
d2725		db	000h	; 00000000b . 050e5 00
d2726		db	000h	; 00000000b . 050e6 00
d2727		db	000h	; 00000000b . 050e7 00
d2728		db	000h	; 00000000b . 050e8 00
d2729		db	000h	; 00000000b . 050e9 00
d272a		db	000h	; 00000000b . 050ea 00
d272b		db	000h	; 00000000b . 050eb 00
d272c		db	000h	; 00000000b . 050ec 00
d272d		db	000h	; 00000000b . 050ed 00
d272e		db	000h	; 00000000b . 050ee 00
d272f		db	000h	; 00000000b . 050ef 00
d2730		db	000h	; 00000000b . 050f0 00
d2731		db	0f0h	; 11110000b . 050f1 f0
d2732		db	000h	; 00000000b . 050f2 00
d2733		db	000h	; 00000000b . 050f3 00
d2734		db	03ch	; 00111100b < 050f4 3c
d2735		db	0ffh	; 11111111b . 050f5 ff
d2736		db	0f0h	; 11110000b . 050f6 f0
d2737		db	03fh	; 00111111b ? 050f7 3f
d2738		db	0fch	; 11111100b . 050f8 fc
d2739		db	03fh	; 00111111b ? 050f9 3f
d273a		db	0ffh	; 11111111b . 050fa ff
d273b		db	0ffh	; 11111111b . 050fb ff
d273c		db	0f0h	; 11110000b . 050fc f0
d273d		db	03fh	; 00111111b ? 050fd 3f
d273e		db	0ffh	; 11111111b . 050fe ff
d273f		db	0ffh	; 11111111b . 050ff ff
d2740		db	0f0h	; 11110000b . 05100 f0
d2741		db	00fh	; 00001111b . 05101 0f
d2742		db	0ffh	; 11111111b . 05102 ff
d2743		db	0ffh	; 11111111b . 05103 ff
d2744		db	0c0h	; 11000000b . 05104 c0
d2745		db	000h	; 00000000b . 05105 00
d2746		db	0ffh	; 11111111b . 05106 ff
d2747		db	0fch	; 11111100b . 05107 fc
d2748		db	000h	; 00000000b . 05108 00
d2749		db	000h	; 00000000b . 05109 00
d274a		db	000h	; 00000000b . 0510a 00
d274b		db	000h	; 00000000b . 0510b 00
d274c		db	000h	; 00000000b . 0510c 00
d274d		db	000h	; 00000000b . 0510d 00
d274e		db	000h	; 00000000b . 0510e 00
d274f		db	000h	; 00000000b . 0510f 00
d2750		db	000h	; 00000000b . 05110 00
d2751		db	000h	; 00000000b . 05111 00
d2752		db	000h	; 00000000b . 05112 00
d2753		db	000h	; 00000000b . 05113 00
d2754		db	000h	; 00000000b . 05114 00
d2755		db	000h	; 00000000b . 05115 00
d2756		db	000h	; 00000000b . 05116 00
d2757		db	000h	; 00000000b . 05117 00
d2758		db	000h	; 00000000b . 05118 00
d2759		db	000h	; 00000000b . 05119 00
d275a		db	000h	; 00000000b . 0511a 00
d275b		db	000h	; 00000000b . 0511b 00
d275c		db	000h	; 00000000b . 0511c 00
d275d		db	000h	; 00000000b . 0511d 00
d275e		db	000h	; 00000000b . 0511e 00
d275f		db	000h	; 00000000b . 0511f 00
d2760		db	000h	; 00000000b . 05120 00
d2761		db	000h	; 00000000b . 05121 00
d2762		db	000h	; 00000000b . 05122 00
d2763		db	000h	; 00000000b . 05123 00
d2764		db	000h	; 00000000b . 05124 00
d2765		db	000h	; 00000000b . 05125 00
d2766		db	000h	; 00000000b . 05126 00
d2767		db	000h	; 00000000b . 05127 00
d2768		db	000h	; 00000000b . 05128 00
d2769		db	000h	; 00000000b . 05129 00
d276a		db	000h	; 00000000b . 0512a 00
d276b		db	000h	; 00000000b . 0512b 00
d276c		db	000h	; 00000000b . 0512c 00
d276d		db	0fch	; 11111100b . 0512d fc
d276e		db	000h	; 00000000b . 0512e 00
d276f		db	000h	; 00000000b . 0512f 00
d2770		db	0fch	; 11111100b . 05130 fc
d2771		db	0ffh	; 11111111b . 05131 ff
d2772		db	0ffh	; 11111111b . 05132 ff
d2773		db	0ffh	; 11111111b . 05133 ff
d2774		db	0fch	; 11111100b . 05134 fc
d2775		db	03fh	; 00111111b ? 05135 3f
d2776		db	0ffh	; 11111111b . 05136 ff
d2777		db	0ffh	; 11111111b . 05137 ff
d2778		db	0f0h	; 11110000b . 05138 f0
d2779		db	00fh	; 00001111b . 05139 0f
d277a		db	0ffh	; 11111111b . 0513a ff
d277b		db	0ffh	; 11111111b . 0513b ff
d277c		db	0c0h	; 11000000b . 0513c c0
d277d		db	000h	; 00000000b . 0513d 00
d277e		db	0ffh	; 11111111b . 0513e ff
d277f		db	0fch	; 11111100b . 0513f fc
d2780		db	000h	; 00000000b . 05140 00
d2781		db	000h	; 00000000b . 05141 00
d2782		db	000h	; 00000000b . 05142 00
d2783		db	000h	; 00000000b . 05143 00
d2784		db	000h	; 00000000b . 05144 00
d2785		db	000h	; 00000000b . 05145 00
d2786		db	000h	; 00000000b . 05146 00
d2787		db	000h	; 00000000b . 05147 00
d2788		db	000h	; 00000000b . 05148 00
d2789		db	000h	; 00000000b . 05149 00
d278a		db	000h	; 00000000b . 0514a 00
d278b		db	000h	; 00000000b . 0514b 00
d278c		db	000h	; 00000000b . 0514c 00
d278d		db	000h	; 00000000b . 0514d 00
d278e		db	000h	; 00000000b . 0514e 00
d278f		db	000h	; 00000000b . 0514f 00
d2790		db	000h	; 00000000b . 05150 00
d2791		db	000h	; 00000000b . 05151 00
d2792		db	000h	; 00000000b . 05152 00
d2793		db	000h	; 00000000b . 05153 00
d2794		db	000h	; 00000000b . 05154 00
d2795		db	000h	; 00000000b . 05155 00
d2796		db	000h	; 00000000b . 05156 00
d2797		db	000h	; 00000000b . 05157 00
d2798		db	000h	; 00000000b . 05158 00
d2799		db	000h	; 00000000b . 05159 00
d279a		db	000h	; 00000000b . 0515a 00
d279b		db	000h	; 00000000b . 0515b 00
d279c		db	000h	; 00000000b . 0515c 00
d279d		db	000h	; 00000000b . 0515d 00
d279e		db	000h	; 00000000b . 0515e 00
d279f		db	000h	; 00000000b . 0515f 00
d27a0		db	000h	; 00000000b . 05160 00
d27a1		db	000h	; 00000000b . 05161 00
d27a2		db	000h	; 00000000b . 05162 00
d27a3		db	000h	; 00000000b . 05163 00
d27a4		db	000h	; 00000000b . 05164 00
d27a5		db	000h	; 00000000b . 05165 00
d27a6		db	000h	; 00000000b . 05166 00
d27a7		db	000h	; 00000000b . 05167 00
d27a8		db	000h	; 00000000b . 05168 00
d27a9		db	0ffh	; 11111111b . 05169 ff
d27aa		db	0ffh	; 11111111b . 0516a ff
d27ab		db	0ffh	; 11111111b . 0516b ff
d27ac		db	0fch	; 11111100b . 0516c fc
d27ad		db	0ffh	; 11111111b . 0516d ff
d27ae		db	0ffh	; 11111111b . 0516e ff
d27af		db	0ffh	; 11111111b . 0516f ff
d27b0		db	0fch	; 11111100b . 05170 fc
d27b1		db	03fh	; 00111111b ? 05171 3f
d27b2		db	0ffh	; 11111111b . 05172 ff
d27b3		db	0ffh	; 11111111b . 05173 ff
d27b4		db	0f0h	; 11110000b . 05174 f0
d27b5		db	003h	; 00000011b . 05175 03
d27b6		db	0ffh	; 11111111b . 05176 ff
d27b7		db	0ffh	; 11111111b . 05177 ff
d27b8		db	000h	; 00000000b . 05178 00
d27b9		db	000h	; 00000000b . 05179 00
d27ba		db	000h	; 00000000b . 0517a 00
d27bb		db	000h	; 00000000b . 0517b 00
d27bc		db	000h	; 00000000b . 0517c 00
d27bd		db	000h	; 00000000b . 0517d 00
d27be		db	000h	; 00000000b . 0517e 00
d27bf		db	000h	; 00000000b . 0517f 00
d27c0		db	000h	; 00000000b . 05180 00
d27c1		db	000h	; 00000000b . 05181 00
d27c2		db	000h	; 00000000b . 05182 00
d27c3		db	000h	; 00000000b . 05183 00
d27c4		db	000h	; 00000000b . 05184 00
d27c5		db	000h	; 00000000b . 05185 00
d27c6		db	000h	; 00000000b . 05186 00
d27c7		db	000h	; 00000000b . 05187 00
d27c8		db	000h	; 00000000b . 05188 00
d27c9		db	000h	; 00000000b . 05189 00
d27ca		db	000h	; 00000000b . 0518a 00
d27cb		db	000h	; 00000000b . 0518b 00
d27cc		db	000h	; 00000000b . 0518c 00
d27cd		db	000h	; 00000000b . 0518d 00
d27ce		db	000h	; 00000000b . 0518e 00
d27cf		db	000h	; 00000000b . 0518f 00
d27d0		db	000h	; 00000000b . 05190 00
d27d1		db	000h	; 00000000b . 05191 00
d27d2		db	000h	; 00000000b . 05192 00
d27d3		db	000h	; 00000000b . 05193 00
d27d4		db	000h	; 00000000b . 05194 00
d27d5		db	000h	; 00000000b . 05195 00
d27d6		db	000h	; 00000000b . 05196 00
d27d7		db	000h	; 00000000b . 05197 00
d27d8		db	000h	; 00000000b . 05198 00
d27d9		db	000h	; 00000000b . 05199 00
d27da		db	000h	; 00000000b . 0519a 00
d27db		db	000h	; 00000000b . 0519b 00
d27dc		db	000h	; 00000000b . 0519c 00
d27dd		db	000h	; 00000000b . 0519d 00
d27de		db	000h	; 00000000b . 0519e 00
d27df		db	000h	; 00000000b . 0519f 00
d27e0		db	000h	; 00000000b . 051a0 00
d27e1		db	000h	; 00000000b . 051a1 00
d27e2		db	03fh	; 00111111b ? 051a2 3f
d27e3		db	0f0h	; 11110000b . 051a3 f0
d27e4		db	000h	; 00000000b . 051a4 00
d27e5		db	03fh	; 00111111b ? 051a5 3f
d27e6		db	0ffh	; 11111111b . 051a6 ff
d27e7		db	0ffh	; 11111111b . 051a7 ff
d27e8		db	0f0h	; 11110000b . 051a8 f0
d27e9		db	0ffh	; 11111111b . 051a9 ff
d27ea		db	0ffh	; 11111111b . 051aa ff
d27eb		db	0ffh	; 11111111b . 051ab ff
d27ec		db	0fch	; 11111100b . 051ac fc
d27ed		db	00fh	; 00001111b . 051ad 0f
d27ee		db	0ffh	; 11111111b . 051ae ff
d27ef		db	0ffh	; 11111111b . 051af ff
d27f0		db	0c0h	; 11000000b . 051b0 c0
d27f1		db	000h	; 00000000b . 051b1 00
d27f2		db	000h	; 00000000b . 051b2 00
d27f3		db	000h	; 00000000b . 051b3 00
d27f4		db	000h	; 00000000b . 051b4 00
d27f5		db	000h	; 00000000b . 051b5 00
d27f6		db	000h	; 00000000b . 051b6 00
d27f7		db	000h	; 00000000b . 051b7 00
d27f8		db	000h	; 00000000b . 051b8 00
d27f9		db	000h	; 00000000b . 051b9 00
d27fa		db	000h	; 00000000b . 051ba 00
d27fb		db	000h	; 00000000b . 051bb 00
d27fc		db	000h	; 00000000b . 051bc 00
d27fd		db	000h	; 00000000b . 051bd 00
d27fe		db	000h	; 00000000b . 051be 00
d27ff		db	000h	; 00000000b . 051bf 00
d2800		db	000h	; 00000000b . 051c0 00
d2801		db	000h	; 00000000b . 051c1 00
d2802		db	000h	; 00000000b . 051c2 00
d2803		db	000h	; 00000000b . 051c3 00
d2804		db	000h	; 00000000b . 051c4 00
d2805		db	000h	; 00000000b . 051c5 00
d2806		db	000h	; 00000000b . 051c6 00
d2807		db	000h	; 00000000b . 051c7 00
d2808		db	000h	; 00000000b . 051c8 00
d2809		db	000h	; 00000000b . 051c9 00
d280a		db	000h	; 00000000b . 051ca 00
d280b		db	000h	; 00000000b . 051cb 00
d280c		db	000h	; 00000000b . 051cc 00
d280d		db	000h	; 00000000b . 051cd 00
d280e		db	000h	; 00000000b . 051ce 00
d280f		db	000h	; 00000000b . 051cf 00
d2810		db	000h	; 00000000b . 051d0 00
d2811		db	000h	; 00000000b . 051d1 00
d2812		db	000h	; 00000000b . 051d2 00
d2813		db	000h	; 00000000b . 051d3 00
d2814		db	000h	; 00000000b . 051d4 00
d2815		db	000h	; 00000000b . 051d5 00
d2816		db	000h	; 00000000b . 051d6 00
d2817		db	000h	; 00000000b . 051d7 00
d2818		db	000h	; 00000000b . 051d8 00
d2819		db	000h	; 00000000b . 051d9 00
d281a		db	00fh	; 00001111b . 051da 0f
d281b		db	0c0h	; 11000000b . 051db c0
d281c		db	000h	; 00000000b . 051dc 00
d281d		db	000h	; 00000000b . 051dd 00
d281e		db	0ffh	; 11111111b . 051de ff
d281f		db	0fch	; 11111100b . 051df fc
d2820		db	000h	; 00000000b . 051e0 00
d2821		db	03fh	; 00111111b ? 051e1 3f
d2822		db	0ffh	; 11111111b . 051e2 ff
d2823		db	0ffh	; 11111111b . 051e3 ff
d2824		db	0f0h	; 11110000b . 051e4 f0
d2825		db	03fh	; 00111111b ? 051e5 3f
d2826		db	0ffh	; 11111111b . 051e6 ff
d2827		db	0ffh	; 11111111b . 051e7 ff
d2828		db	0f0h	; 11110000b . 051e8 f0
d2829		db	000h	; 00000000b . 051e9 00
d282a		db	000h	; 00000000b . 051ea 00
d282b		db	000h	; 00000000b . 051eb 00
d282c		db	000h	; 00000000b . 051ec 00
d282d		db	000h	; 00000000b . 051ed 00
d282e		db	000h	; 00000000b . 051ee 00
d282f		db	000h	; 00000000b . 051ef 00
d2830		db	000h	; 00000000b . 051f0 00
d2831		db	000h	; 00000000b . 051f1 00
d2832		db	000h	; 00000000b . 051f2 00
d2833		db	000h	; 00000000b . 051f3 00
d2834		db	000h	; 00000000b . 051f4 00
d2835		db	000h	; 00000000b . 051f5 00
d2836		db	000h	; 00000000b . 051f6 00
d2837		db	000h	; 00000000b . 051f7 00
d2838		db	000h	; 00000000b . 051f8 00
d2839		db	000h	; 00000000b . 051f9 00
d283a		db	000h	; 00000000b . 051fa 00
d283b		db	000h	; 00000000b . 051fb 00
d283c		db	000h	; 00000000b . 051fc 00
d283d		db	000h	; 00000000b . 051fd 00
d283e		db	000h	; 00000000b . 051fe 00
d283f		db	000h	; 00000000b . 051ff 00
d2840		db	000h	; 00000000b . 05200 00
d2841		db	000h	; 00000000b . 05201 00
d2842		db	000h	; 00000000b . 05202 00
d2843		db	000h	; 00000000b . 05203 00
d2844		db	000h	; 00000000b . 05204 00
d2845		db	000h	; 00000000b . 05205 00
d2846		db	000h	; 00000000b . 05206 00
d2847		db	000h	; 00000000b . 05207 00
d2848		db	000h	; 00000000b . 05208 00
d2849		db	000h	; 00000000b . 05209 00
d284a		db	000h	; 00000000b . 0520a 00
d284b		db	000h	; 00000000b . 0520b 00
d284c		db	000h	; 00000000b . 0520c 00
d284d		db	000h	; 00000000b . 0520d 00
d284e		db	000h	; 00000000b . 0520e 00
d284f		db	000h	; 00000000b . 0520f 00
d2850		db	000h	; 00000000b . 05210 00
d2851		db	000h	; 00000000b . 05211 00
d2852		db	003h	; 00000011b . 05212 03
d2853		db	000h	; 00000000b . 05213 00
d2854		db	000h	; 00000000b . 05214 00
d2855		db	000h	; 00000000b . 05215 00
d2856		db	03fh	; 00111111b ? 05216 3f
d2857		db	0f0h	; 11110000b . 05217 f0
d2858		db	000h	; 00000000b . 05218 00
d2859		db	003h	; 00000011b . 05219 03
d285a		db	0ffh	; 11111111b . 0521a ff
d285b		db	0ffh	; 11111111b . 0521b ff
d285c		db	000h	; 00000000b . 0521c 00
d285d		db	00fh	; 00001111b . 0521d 0f
d285e		db	0ffh	; 11111111b . 0521e ff
d285f		db	0ffh	; 11111111b . 0521f ff
d2860		db	0c0h	; 11000000b . 05220 c0
d2861		db	03fh	; 00111111b ? 05221 3f
d2862		db	0c0h	; 11000000b . 05222 c0
d2863		db	00fh	; 00001111b . 05223 0f
d2864		db	0f0h	; 11110000b . 05224 f0
d2865		db	000h	; 00000000b . 05225 00
d2866		db	000h	; 00000000b . 05226 00
d2867		db	000h	; 00000000b . 05227 00
d2868		db	000h	; 00000000b . 05228 00
d2869		db	000h	; 00000000b . 05229 00
d286a		db	000h	; 00000000b . 0522a 00
d286b		db	000h	; 00000000b . 0522b 00
d286c		db	000h	; 00000000b . 0522c 00
d286d		db	000h	; 00000000b . 0522d 00
d286e		db	000h	; 00000000b . 0522e 00
d286f		db	000h	; 00000000b . 0522f 00
d2870		db	000h	; 00000000b . 05230 00
d2871		db	000h	; 00000000b . 05231 00
d2872		db	000h	; 00000000b . 05232 00
d2873		db	000h	; 00000000b . 05233 00
d2874		db	000h	; 00000000b . 05234 00
d2875		db	000h	; 00000000b . 05235 00
d2876		db	000h	; 00000000b . 05236 00
d2877		db	000h	; 00000000b . 05237 00
d2878		db	000h	; 00000000b . 05238 00
d2879		db	000h	; 00000000b . 05239 00
d287a		db	000h	; 00000000b . 0523a 00
d287b		db	000h	; 00000000b . 0523b 00
d287c		db	000h	; 00000000b . 0523c 00
d287d		db	000h	; 00000000b . 0523d 00
d287e		db	000h	; 00000000b . 0523e 00
d287f		db	000h	; 00000000b . 0523f 00
d2880		db	000h	; 00000000b . 05240 00
d2881		db	000h	; 00000000b . 05241 00
d2882		db	000h	; 00000000b . 05242 00
d2883		db	000h	; 00000000b . 05243 00
d2884		db	000h	; 00000000b . 05244 00
d2885		db	000h	; 00000000b . 05245 00
d2886		db	000h	; 00000000b . 05246 00
d2887		db	000h	; 00000000b . 05247 00
d2888		db	000h	; 00000000b . 05248 00
d2889		db	000h	; 00000000b . 05249 00
d288a		db	003h	; 00000011b . 0524a 03
d288b		db	000h	; 00000000b . 0524b 00
d288c		db	000h	; 00000000b . 0524c 00
d288d		db	000h	; 00000000b . 0524d 00
d288e		db	00fh	; 00001111b . 0524e 0f
d288f		db	0c0h	; 11000000b . 0524f c0
d2890		db	000h	; 00000000b . 05250 00
d2891		db	000h	; 00000000b . 05251 00
d2892		db	03fh	; 00111111b ? 05252 3f
d2893		db	0f0h	; 11110000b . 05253 f0
d2894		db	000h	; 00000000b . 05254 00
d2895		db	003h	; 00000011b . 05255 03
d2896		db	0ffh	; 11111111b . 05256 ff
d2897		db	0ffh	; 11111111b . 05257 ff
d2898		db	000h	; 00000000b . 05258 00
d2899		db	00fh	; 00001111b . 05259 0f
d289a		db	0f0h	; 11110000b . 0525a f0
d289b		db	03fh	; 00111111b ? 0525b 3f
d289c		db	0c0h	; 11000000b . 0525c c0
d289d		db	000h	; 00000000b . 0525d 00
d289e		db	000h	; 00000000b . 0525e 00
d289f		db	000h	; 00000000b . 0525f 00
d28a0		db	000h	; 00000000b . 05260 00
d28a1		db	000h	; 00000000b . 05261 00
d28a2		db	000h	; 00000000b . 05262 00
d28a3		db	000h	; 00000000b . 05263 00
d28a4		db	000h	; 00000000b . 05264 00
d28a5		db	000h	; 00000000b . 05265 00
d28a6		db	000h	; 00000000b . 05266 00
d28a7		db	000h	; 00000000b . 05267 00
d28a8		db	000h	; 00000000b . 05268 00
d28a9		db	000h	; 00000000b . 05269 00
d28aa		db	000h	; 00000000b . 0526a 00
d28ab		db	000h	; 00000000b . 0526b 00
d28ac		db	000h	; 00000000b . 0526c 00
d28ad		db	000h	; 00000000b . 0526d 00
d28ae		db	000h	; 00000000b . 0526e 00
d28af		db	000h	; 00000000b . 0526f 00
d28b0		db	000h	; 00000000b . 05270 00
d28b1		db	000h	; 00000000b . 05271 00
d28b2		db	000h	; 00000000b . 05272 00
d28b3		db	000h	; 00000000b . 05273 00
d28b4		db	000h	; 00000000b . 05274 00
d28b5		db	000h	; 00000000b . 05275 00
d28b6		db	000h	; 00000000b . 05276 00
d28b7		db	000h	; 00000000b . 05277 00
d28b8		db	000h	; 00000000b . 05278 00
d28b9		db	000h	; 00000000b . 05279 00
d28ba		db	000h	; 00000000b . 0527a 00
d28bb		db	000h	; 00000000b . 0527b 00
d28bc		db	000h	; 00000000b . 0527c 00
d28bd		db	000h	; 00000000b . 0527d 00
d28be		db	000h	; 00000000b . 0527e 00
d28bf		db	000h	; 00000000b . 0527f 00
d28c0		db	000h	; 00000000b . 05280 00
d28c1		db	000h	; 00000000b . 05281 00
d28c2		db	003h	; 00000011b . 05282 03
d28c3		db	000h	; 00000000b . 05283 00
d28c4		db	000h	; 00000000b . 05284 00
d28c5		db	000h	; 00000000b . 05285 00
d28c6		db	00fh	; 00001111b . 05286 0f
d28c7		db	0c0h	; 11000000b . 05287 c0
d28c8		db	000h	; 00000000b . 05288 00
d28c9		db	000h	; 00000000b . 05289 00
d28ca		db	03fh	; 00111111b ? 0528a 3f
d28cb		db	0f0h	; 11110000b . 0528b f0
d28cc		db	000h	; 00000000b . 0528c 00
d28cd		db	000h	; 00000000b . 0528d 00
d28ce		db	03fh	; 00111111b ? 0528e 3f
d28cf		db	0f0h	; 11110000b . 0528f f0
d28d0		db	000h	; 00000000b . 05290 00
d28d1		db	000h	; 00000000b . 05291 00
d28d2		db	0f0h	; 11110000b . 05292 f0
d28d3		db	03ch	; 00111100b < 05293 3c
d28d4		db	000h	; 00000000b . 05294 00
d28d5		db	003h	; 00000011b . 05295 03
d28d6		db	0c0h	; 11000000b . 05296 c0
d28d7		db	00fh	; 00001111b . 05297 0f
d28d8		db	000h	; 00000000b . 05298 00
d28d9		db	000h	; 00000000b . 05299 00
d28da		db	000h	; 00000000b . 0529a 00
d28db		db	000h	; 00000000b . 0529b 00
d28dc		db	000h	; 00000000b . 0529c 00
d28dd		db	000h	; 00000000b . 0529d 00
d28de		db	000h	; 00000000b . 0529e 00
d28df		db	000h	; 00000000b . 0529f 00
d28e0		db	000h	; 00000000b . 052a0 00
d28e1		db	000h	; 00000000b . 052a1 00
d28e2		db	000h	; 00000000b . 052a2 00
d28e3		db	000h	; 00000000b . 052a3 00
d28e4		db	000h	; 00000000b . 052a4 00
d28e5		db	000h	; 00000000b . 052a5 00
d28e6		db	000h	; 00000000b . 052a6 00
d28e7		db	000h	; 00000000b . 052a7 00
d28e8		db	000h	; 00000000b . 052a8 00
d28e9		db	000h	; 00000000b . 052a9 00
d28ea		db	000h	; 00000000b . 052aa 00
d28eb		db	000h	; 00000000b . 052ab 00
d28ec		db	000h	; 00000000b . 052ac 00
d28ed		db	000h	; 00000000b . 052ad 00
d28ee		db	000h	; 00000000b . 052ae 00
d28ef		db	000h	; 00000000b . 052af 00
d28f0		db	000h	; 00000000b . 052b0 00
d28f1		db	000h	; 00000000b . 052b1 00
d28f2		db	000h	; 00000000b . 052b2 00
d28f3		db	000h	; 00000000b . 052b3 00
d28f4		db	000h	; 00000000b . 052b4 00
d28f5		db	000h	; 00000000b . 052b5 00
d28f6		db	000h	; 00000000b . 052b6 00
d28f7		db	000h	; 00000000b . 052b7 00
d28f8		db	000h	; 00000000b . 052b8 00
d28f9		db	000h	; 00000000b . 052b9 00
d28fa		db	003h	; 00000011b . 052ba 03
d28fb		db	000h	; 00000000b . 052bb 00
d28fc		db	000h	; 00000000b . 052bc 00
d28fd		db	000h	; 00000000b . 052bd 00
d28fe		db	003h	; 00000011b . 052be 03
d28ff		db	000h	; 00000000b . 052bf 00
d2900		db	000h	; 00000000b . 052c0 00
d2901		db	000h	; 00000000b . 052c1 00
d2902		db	00fh	; 00001111b . 052c2 0f
d2903		db	0c0h	; 11000000b . 052c3 c0
d2904		db	000h	; 00000000b . 052c4 00
d2905		db	000h	; 00000000b . 052c5 00
d2906		db	03fh	; 00111111b ? 052c6 3f
d2907		db	0f0h	; 11110000b . 052c7 f0
d2908		db	000h	; 00000000b . 052c8 00
d2909		db	000h	; 00000000b . 052c9 00
d290a		db	03ch	; 00111100b < 052ca 3c
d290b		db	0f0h	; 11110000b . 052cb f0
d290c		db	000h	; 00000000b . 052cc 00
d290d		db	000h	; 00000000b . 052cd 00
d290e		db	0f0h	; 11110000b . 052ce f0
d290f		db	03ch	; 00111100b < 052cf 3c
d2910		db	000h	; 00000000b . 052d0 00
d2911		db	000h	; 00000000b . 052d1 00
d2912		db	0c0h	; 11000000b . 052d2 c0
d2913		db	00ch	; 00001100b . 052d3 0c
d2914		db	000h	; 00000000b . 052d4 00
d2915		db	000h	; 00000000b . 052d5 00
d2916		db	000h	; 00000000b . 052d6 00
d2917		db	000h	; 00000000b . 052d7 00
d2918		db	000h	; 00000000b . 052d8 00
d2919		db	000h	; 00000000b . 052d9 00
d291a		db	000h	; 00000000b . 052da 00
d291b		db	000h	; 00000000b . 052db 00
d291c		db	000h	; 00000000b . 052dc 00
d291d		db	000h	; 00000000b . 052dd 00
d291e		db	000h	; 00000000b . 052de 00
d291f		db	000h	; 00000000b . 052df 00
d2920		db	000h	; 00000000b . 052e0 00
d2921		db	000h	; 00000000b . 052e1 00
d2922		db	000h	; 00000000b . 052e2 00
d2923		db	000h	; 00000000b . 052e3 00
d2924		db	000h	; 00000000b . 052e4 00
d2925		db	000h	; 00000000b . 052e5 00
d2926		db	000h	; 00000000b . 052e6 00
d2927		db	000h	; 00000000b . 052e7 00
d2928		db	000h	; 00000000b . 052e8 00
d2929		db	000h	; 00000000b . 052e9 00
d292a		db	000h	; 00000000b . 052ea 00
d292b		db	000h	; 00000000b . 052eb 00
d292c		db	000h	; 00000000b . 052ec 00
d292d		db	000h	; 00000000b . 052ed 00
d292e		db	000h	; 00000000b . 052ee 00
d292f		db	000h	; 00000000b . 052ef 00
d2930		db	000h	; 00000000b . 052f0 00
d2931		db	000h	; 00000000b . 052f1 00
d2932		db	000h	; 00000000b . 052f2 00
d2933		db	000h	; 00000000b . 052f3 00
d2934		db	000h	; 00000000b . 052f4 00
d2935		db	000h	; 00000000b . 052f5 00
d2936		db	003h	; 00000011b . 052f6 03
d2937		db	000h	; 00000000b . 052f7 00
d2938		db	000h	; 00000000b . 052f8 00
d2939		db	000h	; 00000000b . 052f9 00
d293a		db	003h	; 00000011b . 052fa 03
d293b		db	000h	; 00000000b . 052fb 00
d293c		db	000h	; 00000000b . 052fc 00
d293d		db	000h	; 00000000b . 052fd 00
d293e		db	00fh	; 00001111b . 052fe 0f
d293f		db	0c0h	; 11000000b . 052ff c0
d2940		db	000h	; 00000000b . 05300 00
d2941		db	000h	; 00000000b . 05301 00
d2942		db	00ch	; 00001100b . 05302 0c
d2943		db	0c0h	; 11000000b . 05303 c0
d2944		db	000h	; 00000000b . 05304 00
d2945		db	000h	; 00000000b . 05305 00
d2946		db	000h	; 00000000b . 05306 00
d2947		db	000h	; 00000000b . 05307 00
d2948		db	000h	; 00000000b . 05308 00
d2949		db	000h	; 00000000b . 05309 00
d294a		db	030h	; 00110000b 0 0530a 30
d294b		db	030h	; 00110000b 0 0530b 30
d294c		db	000h	; 00000000b . 0530c 00
d294d		db	000h	; 00000000b . 0530d 00
d294e		db	000h	; 00000000b . 0530e 00
d294f		db	000h	; 00000000b . 0530f 00
d2950		db	000h	; 00000000b . 05310 00
d2951		db	000h	; 00000000b . 05311 00
d2952		db	000h	; 00000000b . 05312 00
d2953		db	000h	; 00000000b . 05313 00
d2954		db	000h	; 00000000b . 05314 00
d2955		db	000h	; 00000000b . 05315 00
d2956		db	000h	; 00000000b . 05316 00
d2957		db	000h	; 00000000b . 05317 00
d2958		db	000h	; 00000000b . 05318 00
d2959		db	000h	; 00000000b . 05319 00
d295a		db	000h	; 00000000b . 0531a 00
d295b		db	000h	; 00000000b . 0531b 00
d295c		db	000h	; 00000000b . 0531c 00
d295d		db	000h	; 00000000b . 0531d 00
d295e		db	000h	; 00000000b . 0531e 00
d295f		db	000h	; 00000000b . 0531f 00
d2960		db	000h	; 00000000b . 05320 00
d2961		db	000h	; 00000000b . 05321 00
d2962		db	000h	; 00000000b . 05322 00
d2963		db	000h	; 00000000b . 05323 00
d2964		db	000h	; 00000000b . 05324 00
d2965		db	000h	; 00000000b . 05325 00
d2966		db	000h	; 00000000b . 05326 00
d2967		db	000h	; 00000000b . 05327 00
d2968		db	000h	; 00000000b . 05328 00
d2969		db	000h	; 00000000b . 05329 00
d296a		db	000h	; 00000000b . 0532a 00
d296b		db	000h	; 00000000b . 0532b 00
d296c		db	000h	; 00000000b . 0532c 00
d296d		db	000h	; 00000000b . 0532d 00
d296e		db	003h	; 00000011b . 0532e 03
d296f		db	000h	; 00000000b . 0532f 00
d2970		db	000h	; 00000000b . 05330 00
d2971		db	000h	; 00000000b . 05331 00
d2972		db	003h	; 00000011b . 05332 03
d2973		db	000h	; 00000000b . 05333 00
d2974		db	000h	; 00000000b . 05334 00
d2975		db	000h	; 00000000b . 05335 00
d2976		db	003h	; 00000011b . 05336 03
d2977		db	000h	; 00000000b . 05337 00
d2978		db	000h	; 00000000b . 05338 00
d2979		db	000h	; 00000000b . 05339 00
d297a		db	003h	; 00000011b . 0533a 03
d297b		db	000h	; 00000000b . 0533b 00
d297c		db	000h	; 00000000b . 0533c 00
d297d		db	000h	; 00000000b . 0533d 00
d297e		db	000h	; 00000000b . 0533e 00
d297f		db	000h	; 00000000b . 0533f 00
d2980		db	000h	; 00000000b . 05340 00
d2981		db	000h	; 00000000b . 05341 00
d2982		db	000h	; 00000000b . 05342 00
d2983		db	000h	; 00000000b . 05343 00
d2984		db	000h	; 00000000b . 05344 00
d2985		db	000h	; 00000000b . 05345 00
d2986		db	000h	; 00000000b . 05346 00
d2987		db	0c0h	; 11000000b . 05347 c0
d2988		db	000h	; 00000000b . 05348 00
d2989		db	000h	; 00000000b . 05349 00
d298a		db	000h	; 00000000b . 0534a 00
d298b		db	0c0h	; 11000000b . 0534b c0
d298c		db	000h	; 00000000b . 0534c 00
d298d		db	000h	; 00000000b . 0534d 00
d298e		db	0c0h	; 11000000b . 0534e c0
d298f		db	0c0h	; 11000000b . 0534f c0
d2990		db	0c0h	; 11000000b . 05350 c0
d2991		db	000h	; 00000000b . 05351 00
d2992		db	030h	; 00110000b 0 05352 30
d2993		db	0c3h	; 11000011b . 05353 c3
d2994		db	000h	; 00000000b . 05354 00
d2995		db	000h	; 00000000b . 05355 00
d2996		db	00ch	; 00001100b . 05356 0c
d2997		db	00ch	; 00001100b . 05357 0c
d2998		db	000h	; 00000000b . 05358 00
d2999		db	000h	; 00000000b . 05359 00
d299a		db	000h	; 00000000b . 0535a 00
d299b		db	000h	; 00000000b . 0535b 00
d299c		db	000h	; 00000000b . 0535c 00
d299d		db	00fh	; 00001111b . 0535d 0f
d299e		db	0f0h	; 11110000b . 0535e f0
d299f		db	003h	; 00000011b . 0535f 03
d29a0		db	0fch	; 11111100b . 05360 fc
d29a1		db	000h	; 00000000b . 05361 00
d29a2		db	000h	; 00000000b . 05362 00
d29a3		db	000h	; 00000000b . 05363 00
d29a4		db	000h	; 00000000b . 05364 00
d29a5		db	000h	; 00000000b . 05365 00
d29a6		db	00ch	; 00001100b . 05366 0c
d29a7		db	00ch	; 00001100b . 05367 0c
d29a8		db	000h	; 00000000b . 05368 00
d29a9		db	000h	; 00000000b . 05369 00
d29aa		db	030h	; 00110000b 0 0536a 30
d29ab		db	0c3h	; 11000011b . 0536b c3
d29ac		db	000h	; 00000000b . 0536c 00
d29ad		db	000h	; 00000000b . 0536d 00
d29ae		db	0c0h	; 11000000b . 0536e c0
d29af		db	0c0h	; 11000000b . 0536f c0
d29b0		db	0c0h	; 11000000b . 05370 c0
d29b1		db	000h	; 00000000b . 05371 00
d29b2		db	000h	; 00000000b . 05372 00
d29b3		db	0c0h	; 11000000b . 05373 c0
d29b4		db	000h	; 00000000b . 05374 00
d29b5		db	000h	; 00000000b . 05375 00
d29b6		db	000h	; 00000000b . 05376 00
d29b7		db	0c0h	; 11000000b . 05377 c0
d29b8		db	000h	; 00000000b . 05378 00
d29b9		db	000h	; 00000000b . 05379 00
d29ba		db	000h	; 00000000b . 0537a 00
d29bb		db	000h	; 00000000b . 0537b 00
d29bc		db	000h	; 00000000b . 0537c 00
d29bd		db	000h	; 00000000b . 0537d 00
d29be		db	000h	; 00000000b . 0537e 00
d29bf		db	0c0h	; 11000000b . 0537f c0
d29c0		db	000h	; 00000000b . 05380 00
d29c1		db	000h	; 00000000b . 05381 00
d29c2		db	000h	; 00000000b . 05382 00
d29c3		db	0c0h	; 11000000b . 05383 c0
d29c4		db	000h	; 00000000b . 05384 00
d29c5		db	000h	; 00000000b . 05385 00
d29c6		db	0c0h	; 11000000b . 05386 c0
d29c7		db	0c0h	; 11000000b . 05387 c0
d29c8		db	0c0h	; 11000000b . 05388 c0
d29c9		db	000h	; 00000000b . 05389 00
d29ca		db	030h	; 00110000b 0 0538a 30
d29cb		db	0c3h	; 11000011b . 0538b c3
d29cc		db	000h	; 00000000b . 0538c 00
d29cd		db	000h	; 00000000b . 0538d 00
d29ce		db	00ch	; 00001100b . 0538e 0c
d29cf		db	00ch	; 00001100b . 0538f 0c
d29d0		db	000h	; 00000000b . 05390 00
d29d1		db	000h	; 00000000b . 05391 00
d29d2		db	000h	; 00000000b . 05392 00
d29d3		db	000h	; 00000000b . 05393 00
d29d4		db	000h	; 00000000b . 05394 00
d29d5		db	00fh	; 00001111b . 05395 0f
d29d6		db	0f0h	; 11110000b . 05396 f0
d29d7		db	003h	; 00000011b . 05397 03
d29d8		db	0fch	; 11111100b . 05398 fc
d29d9		db	000h	; 00000000b . 05399 00
d29da		db	000h	; 00000000b . 0539a 00
d29db		db	000h	; 00000000b . 0539b 00
d29dc		db	000h	; 00000000b . 0539c 00
d29dd		db	000h	; 00000000b . 0539d 00
d29de		db	00ch	; 00001100b . 0539e 0c
d29df		db	00ch	; 00001100b . 0539f 0c
d29e0		db	000h	; 00000000b . 053a0 00
d29e1		db	000h	; 00000000b . 053a1 00
d29e2		db	030h	; 00110000b 0 053a2 30
d29e3		db	0c3h	; 11000011b . 053a3 c3
d29e4		db	000h	; 00000000b . 053a4 00
d29e5		db	000h	; 00000000b . 053a5 00
d29e6		db	0c0h	; 11000000b . 053a6 c0
d29e7		db	0c0h	; 11000000b . 053a7 c0
d29e8		db	0c0h	; 11000000b . 053a8 c0
d29e9		db	000h	; 00000000b . 053a9 00
d29ea		db	000h	; 00000000b . 053aa 00
d29eb		db	0c0h	; 11000000b . 053ab c0
d29ec		db	000h	; 00000000b . 053ac 00
d29ed		db	000h	; 00000000b . 053ad 00
d29ee		db	000h	; 00000000b . 053ae 00
d29ef		db	0c0h	; 11000000b . 053af c0
d29f0		db	000h	; 00000000b . 053b0 00
d29f1		db	000h	; 00000000b . 053b1 00
d29f2		db	000h	; 00000000b . 053b2 00
d29f3		db	000h	; 00000000b . 053b3 00
d29f4		db	000h	; 00000000b . 053b4 00
d29f5		db	000h	; 00000000b . 053b5 00
d29f6		db	000h	; 00000000b . 053b6 00
d29f7		db	000h	; 00000000b . 053b7 00
d29f8		db	000h	; 00000000b . 053b8 00
d29f9		db	000h	; 00000000b . 053b9 00
d29fa		db	000h	; 00000000b . 053ba 00
d29fb		db	000h	; 00000000b . 053bb 00
d29fc		db	000h	; 00000000b . 053bc 00
d29fd		db	000h	; 00000000b . 053bd 00
d29fe		db	000h	; 00000000b . 053be 00
d29ff		db	000h	; 00000000b . 053bf 00
d2a00		db	000h	; 00000000b . 053c0 00
d2a01		db	000h	; 00000000b . 053c1 00
d2a02		db	000h	; 00000000b . 053c2 00
d2a03		db	000h	; 00000000b . 053c3 00
d2a04		db	000h	; 00000000b . 053c4 00
d2a05		db	000h	; 00000000b . 053c5 00
d2a06		db	000h	; 00000000b . 053c6 00
d2a07		db	000h	; 00000000b . 053c7 00
d2a08		db	000h	; 00000000b . 053c8 00
d2a09		db	000h	; 00000000b . 053c9 00
d2a0a		db	000h	; 00000000b . 053ca 00
d2a0b		db	000h	; 00000000b . 053cb 00
d2a0c		db	000h	; 00000000b . 053cc 00
d2a0d		db	000h	; 00000000b . 053cd 00
d2a0e		db	000h	; 00000000b . 053ce 00
d2a0f		db	000h	; 00000000b . 053cf 00
d2a10		db	000h	; 00000000b . 053d0 00
d2a11		db	000h	; 00000000b . 053d1 00
d2a12		db	000h	; 00000000b . 053d2 00
d2a13		db	000h	; 00000000b . 053d3 00
d2a14		db	000h	; 00000000b . 053d4 00
d2a15		db	000h	; 00000000b . 053d5 00
d2a16		db	000h	; 00000000b . 053d6 00
d2a17		db	000h	; 00000000b . 053d7 00
d2a18		db	000h	; 00000000b . 053d8 00
d2a19		db	000h	; 00000000b . 053d9 00
d2a1a		db	000h	; 00000000b . 053da 00
d2a1b		db	000h	; 00000000b . 053db 00
d2a1c		db	000h	; 00000000b . 053dc 00
d2a1d		db	000h	; 00000000b . 053dd 00
d2a1e		db	000h	; 00000000b . 053de 00
d2a1f		db	000h	; 00000000b . 053df 00
d2a20		db	000h	; 00000000b . 053e0 00
d2a21		db	000h	; 00000000b . 053e1 00
d2a22		db	000h	; 00000000b . 053e2 00
d2a23		db	000h	; 00000000b . 053e3 00
d2a24		db	000h	; 00000000b . 053e4 00
d2a25		db	000h	; 00000000b . 053e5 00
d2a26		db	000h	; 00000000b . 053e6 00
d2a27		db	000h	; 00000000b . 053e7 00
d2a28		db	000h	; 00000000b . 053e8 00
d2a29		db	000h	; 00000000b . 053e9 00
d2a2a		db	000h	; 00000000b . 053ea 00
d2a2b		db	000h	; 00000000b . 053eb 00
d2a2c		db	000h	; 00000000b . 053ec 00
d2a2d		db	000h	; 00000000b . 053ed 00
d2a2e		db	07ah	; 01111010b z 053ee 7a
d2a2f		db	02eh	; 00101110b . 053ef 2e
d2a30		db	019h	; 00011001b . 053f0 19
d2a31		db	00eh	; 00001110b . 053f1 0e
d2a32		db	000h	; 00000000b . 053f2 00
d2a33		db	076h	; 01110110b v 053f3 76
d2a34		db	02eh	; 00101110b . 053f4 2e
d2a35		db	00eh	; 00001110b . 053f5 0e
d2a36		db	00eh	; 00001110b . 053f6 0e
d2a37		db	000h	; 00000000b . 053f7 00
d2a38		db	000h	; 00000000b . 053f8 00
d2a39		db	000h	; 00000000b . 053f9 00
d2a3a		db	000h	; 00000000b . 053fa 00
d2a3b		db	000h	; 00000000b . 053fb 00
d2a3c		db	000h	; 00000000b . 053fc 00
d2a3d		db	000h	; 00000000b . 053fd 00
d2a3e		db	000h	; 00000000b . 053fe 00
d2a3f		db	000h	; 00000000b . 053ff 00
d2a40		db	000h	; 00000000b . 05400 00
d2a41		db	000h	; 00000000b . 05401 00
d2a42		db	000h	; 00000000b . 05402 00
d2a43		db	000h	; 00000000b . 05403 00
d2a44		db	000h	; 00000000b . 05404 00
d2a45		db	000h	; 00000000b . 05405 00
d2a46		db	000h	; 00000000b . 05406 00
d2a47		db	000h	; 00000000b . 05407 00
d2a48		db	000h	; 00000000b . 05408 00
d2a49		db	000h	; 00000000b . 05409 00
d2a4a		db	000h	; 00000000b . 0540a 00
d2a4b		db	000h	; 00000000b . 0540b 00
d2a4c		db	000h	; 00000000b . 0540c 00
d2a4d		db	000h	; 00000000b . 0540d 00
d2a4e		db	000h	; 00000000b . 0540e 00
d2a4f		db	000h	; 00000000b . 0540f 00
d2a50		db	000h	; 00000000b . 05410 00
d2a51		db	000h	; 00000000b . 05411 00
d2a52		db	000h	; 00000000b . 05412 00
d2a53		db	000h	; 00000000b . 05413 00
d2a54		db	000h	; 00000000b . 05414 00
d2a55		db	000h	; 00000000b . 05415 00
d2a56		db	000h	; 00000000b . 05416 00
d2a57		db	000h	; 00000000b . 05417 00
d2a58		db	000h	; 00000000b . 05418 00
d2a59		db	000h	; 00000000b . 05419 00
d2a5a		db	000h	; 00000000b . 0541a 00
d2a5b		db	000h	; 00000000b . 0541b 00
d2a5c		db	000h	; 00000000b . 0541c 00
d2a5d		db	000h	; 00000000b . 0541d 00
d2a5e		db	000h	; 00000000b . 0541e 00
d2a5f		db	000h	; 00000000b . 0541f 00
d2a60		db	000h	; 00000000b . 05420 00
d2a61		db	000h	; 00000000b . 05421 00
d2a62		db	000h	; 00000000b . 05422 00
d2a63		db	000h	; 00000000b . 05423 00
d2a64		db	000h	; 00000000b . 05424 00
d2a65		db	000h	; 00000000b . 05425 00
d2a66		db	000h	; 00000000b . 05426 00
d2a67		db	000h	; 00000000b . 05427 00
d2a68		db	000h	; 00000000b . 05428 00
d2a69		db	000h	; 00000000b . 05429 00
d2a6a		db	000h	; 00000000b . 0542a 00
d2a6b		db	000h	; 00000000b . 0542b 00
d2a6c		db	000h	; 00000000b . 0542c 00
d2a6d		db	000h	; 00000000b . 0542d 00
d2a6e		db	000h	; 00000000b . 0542e 00
d2a6f		db	000h	; 00000000b . 0542f 00
d2a70		db	000h	; 00000000b . 05430 00
d2a71		db	000h	; 00000000b . 05431 00
d2a72		db	000h	; 00000000b . 05432 00
d2a73		db	000h	; 00000000b . 05433 00
d2a74		db	000h	; 00000000b . 05434 00
d2a75		db	000h	; 00000000b . 05435 00
d2a76		db	000h	; 00000000b . 05436 00
d2a77		db	000h	; 00000000b . 05437 00
d2a78		db	000h	; 00000000b . 05438 00
d2a79		db	000h	; 00000000b . 05439 00
d2a7a		db	000h	; 00000000b . 0543a 00
d2a7b		db	000h	; 00000000b . 0543b 00
d2a7c		db	000h	; 00000000b . 0543c 00
d2a7d		db	000h	; 00000000b . 0543d 00
d2a7e		db	000h	; 00000000b . 0543e 00
d2a7f		db	000h	; 00000000b . 0543f 00
d2a80		db	000h	; 00000000b . 05440 00
d2a81		db	000h	; 00000000b . 05441 00
d2a82		db	000h	; 00000000b . 05442 00
d2a83		db	000h	; 00000000b . 05443 00
d2a84		db	000h	; 00000000b . 05444 00
d2a85		db	000h	; 00000000b . 05445 00
d2a86		db	000h	; 00000000b . 05446 00
d2a87		db	000h	; 00000000b . 05447 00
d2a88		db	000h	; 00000000b . 05448 00
d2a89		db	000h	; 00000000b . 05449 00
d2a8a		db	000h	; 00000000b . 0544a 00
d2a8b		db	000h	; 00000000b . 0544b 00
d2a8c		db	000h	; 00000000b . 0544c 00
d2a8d		db	000h	; 00000000b . 0544d 00
d2a8e		db	000h	; 00000000b . 0544e 00
d2a8f		db	000h	; 00000000b . 0544f 00
d2a90		db	000h	; 00000000b . 05450 00
d2a91		db	000h	; 00000000b . 05451 00
d2a92		db	000h	; 00000000b . 05452 00
d2a93		db	000h	; 00000000b . 05453 00
d2a94		db	000h	; 00000000b . 05454 00
d2a95		db	000h	; 00000000b . 05455 00
d2a96		db	000h	; 00000000b . 05456 00
d2a97		db	000h	; 00000000b . 05457 00
d2a98		db	000h	; 00000000b . 05458 00
d2a99		db	000h	; 00000000b . 05459 00
d2a9a		db	000h	; 00000000b . 0545a 00
d2a9b		db	000h	; 00000000b . 0545b 00
d2a9c		db	000h	; 00000000b . 0545c 00
d2a9d		db	000h	; 00000000b . 0545d 00
d2a9e		db	000h	; 00000000b . 0545e 00
d2a9f		db	000h	; 00000000b . 0545f 00
d2aa0		db	000h	; 00000000b . 05460 00
d2aa1		db	000h	; 00000000b . 05461 00
d2aa2		db	000h	; 00000000b . 05462 00
d2aa3		db	000h	; 00000000b . 05463 00
d2aa4		db	000h	; 00000000b . 05464 00
d2aa5		db	000h	; 00000000b . 05465 00
d2aa6		db	000h	; 00000000b . 05466 00
d2aa7		db	000h	; 00000000b . 05467 00
d2aa8		db	000h	; 00000000b . 05468 00
d2aa9		db	002h	; 00000010b . 05469 02
d2aaa		db	06dh	; 01101101b m 0546a 6d
d2aab		db	030h	; 00110000b 0 0546b 30
d2aac		db	01ah	; 00011010b . 0546c 1a
d2aad		db	026h	; 00100110b & 0546d 26
d2aae		db	000h	; 00000000b . 0546e 00
d2aaf		db	06dh	; 01101101b m 0546f 6d
d2ab0		db	030h	; 00110000b 0 05470 30
d2ab1		db	00eh	; 00001110b . 05471 0e
d2ab2		db	00eh	; 00001110b . 05472 0e
d2ab3		db	000h	; 00000000b . 05473 00
d2ab4		db	004h	; 00000100b . 05474 04
d2ab5		db	000h	; 00000000b . 05475 00
d2ab6		db	000h	; 00000000b . 05476 00
d2ab7		db	000h	; 00000000b . 05477 00
d2ab8		db	000h	; 00000000b . 05478 00
d2ab9		db	000h	; 00000000b . 05479 00
d2aba		db	000h	; 00000000b . 0547a 00
d2abb		db	000h	; 00000000b . 0547b 00
d2abc		db	000h	; 00000000b . 0547c 00
d2abd		db	000h	; 00000000b . 0547d 00
d2abe		db	000h	; 00000000b . 0547e 00
d2abf		db	000h	; 00000000b . 0547f 00
d2ac0		db	000h	; 00000000b . 05480 00
d2ac1		db	000h	; 00000000b . 05481 00
d2ac2		db	000h	; 00000000b . 05482 00
d2ac3		db	000h	; 00000000b . 05483 00
d2ac4		db	000h	; 00000000b . 05484 00
d2ac5		db	000h	; 00000000b . 05485 00
d2ac6		db	000h	; 00000000b . 05486 00
d2ac7		db	000h	; 00000000b . 05487 00
d2ac8		db	000h	; 00000000b . 05488 00
d2ac9		db	000h	; 00000000b . 05489 00
d2aca		db	000h	; 00000000b . 0548a 00
d2acb		db	000h	; 00000000b . 0548b 00
d2acc		db	000h	; 00000000b . 0548c 00
d2acd		db	000h	; 00000000b . 0548d 00
d2ace		db	000h	; 00000000b . 0548e 00
d2acf		db	000h	; 00000000b . 0548f 00
d2ad0		db	000h	; 00000000b . 05490 00
d2ad1		db	000h	; 00000000b . 05491 00
d2ad2		db	000h	; 00000000b . 05492 00
d2ad3		db	000h	; 00000000b . 05493 00
d2ad4		db	000h	; 00000000b . 05494 00
d2ad5		db	000h	; 00000000b . 05495 00
d2ad6		db	000h	; 00000000b . 05496 00
d2ad7		db	000h	; 00000000b . 05497 00
d2ad8		db	000h	; 00000000b . 05498 00
d2ad9		db	000h	; 00000000b . 05499 00
d2ada		db	000h	; 00000000b . 0549a 00
d2adb		db	000h	; 00000000b . 0549b 00
d2adc		db	000h	; 00000000b . 0549c 00
d2add		db	000h	; 00000000b . 0549d 00
d2ade		db	000h	; 00000000b . 0549e 00
d2adf		db	000h	; 00000000b . 0549f 00
d2ae0		db	000h	; 00000000b . 054a0 00
d2ae1		db	000h	; 00000000b . 054a1 00
d2ae2		db	000h	; 00000000b . 054a2 00
d2ae3		db	000h	; 00000000b . 054a3 00
d2ae4		db	000h	; 00000000b . 054a4 00
d2ae5		db	000h	; 00000000b . 054a5 00
d2ae6		db	000h	; 00000000b . 054a6 00
d2ae7		db	000h	; 00000000b . 054a7 00
d2ae8		db	000h	; 00000000b . 054a8 00
d2ae9		db	000h	; 00000000b . 054a9 00
d2aea		db	000h	; 00000000b . 054aa 00
d2aeb		db	000h	; 00000000b . 054ab 00
d2aec		db	000h	; 00000000b . 054ac 00
d2aed		db	000h	; 00000000b . 054ad 00
d2aee		db	000h	; 00000000b . 054ae 00
d2aef		db	000h	; 00000000b . 054af 00
d2af0		db	000h	; 00000000b . 054b0 00
d2af1		db	000h	; 00000000b . 054b1 00
d2af2		db	000h	; 00000000b . 054b2 00
d2af3		db	000h	; 00000000b . 054b3 00
d2af4		db	000h	; 00000000b . 054b4 00
d2af5		db	000h	; 00000000b . 054b5 00
d2af6		db	000h	; 00000000b . 054b6 00
d2af7		db	000h	; 00000000b . 054b7 00
d2af8		db	000h	; 00000000b . 054b8 00
d2af9		db	000h	; 00000000b . 054b9 00
d2afa		db	000h	; 00000000b . 054ba 00
d2afb		db	000h	; 00000000b . 054bb 00
d2afc		db	000h	; 00000000b . 054bc 00
d2afd		db	000h	; 00000000b . 054bd 00
d2afe		db	000h	; 00000000b . 054be 00
d2aff		db	000h	; 00000000b . 054bf 00
d2b00		db	000h	; 00000000b . 054c0 00
d2b01		db	000h	; 00000000b . 054c1 00
d2b02		db	000h	; 00000000b . 054c2 00
d2b03		db	000h	; 00000000b . 054c3 00
d2b04		db	000h	; 00000000b . 054c4 00
d2b05		db	000h	; 00000000b . 054c5 00
d2b06		db	000h	; 00000000b . 054c6 00
d2b07		db	000h	; 00000000b . 054c7 00
d2b08		db	000h	; 00000000b . 054c8 00
d2b09		db	000h	; 00000000b . 054c9 00
d2b0a		db	000h	; 00000000b . 054ca 00
d2b0b		db	000h	; 00000000b . 054cb 00
d2b0c		db	000h	; 00000000b . 054cc 00
d2b0d		db	000h	; 00000000b . 054cd 00
d2b0e		db	000h	; 00000000b . 054ce 00
d2b0f		db	000h	; 00000000b . 054cf 00
d2b10		db	000h	; 00000000b . 054d0 00
d2b11		db	000h	; 00000000b . 054d1 00
d2b12		db	000h	; 00000000b . 054d2 00
d2b13		db	000h	; 00000000b . 054d3 00
d2b14		db	000h	; 00000000b . 054d4 00
d2b15		db	000h	; 00000000b . 054d5 00
d2b16		db	000h	; 00000000b . 054d6 00
d2b17		db	000h	; 00000000b . 054d7 00
d2b18		db	000h	; 00000000b . 054d8 00
d2b19		db	000h	; 00000000b . 054d9 00
d2b1a		db	000h	; 00000000b . 054da 00
d2b1b		db	000h	; 00000000b . 054db 00
d2b1c		db	000h	; 00000000b . 054dc 00
d2b1d		db	000h	; 00000000b . 054dd 00
d2b1e		db	000h	; 00000000b . 054de 00
d2b1f		db	000h	; 00000000b . 054df 00
d2b20		db	000h	; 00000000b . 054e0 00
d2b21		db	000h	; 00000000b . 054e1 00
d2b22		db	000h	; 00000000b . 054e2 00
d2b23		db	000h	; 00000000b . 054e3 00
d2b24		db	000h	; 00000000b . 054e4 00
d2b25		db	003h	; 00000011b . 054e5 03
d2b26		db	08bh	; 10001011b . 054e6 8b
d2b27		db	02eh	; 00101110b . 054e7 2e
d2b28		db	01ah	; 00011010b . 054e8 1a
d2b29		db	026h	; 00100110b & 054e9 26
d2b2a		db	000h	; 00000000b . 054ea 00
d2b2b		db	08bh	; 10001011b . 054eb 8b
d2b2c		db	02eh	; 00101110b . 054ec 2e
d2b2d		db	00eh	; 00001110b . 054ed 0e
d2b2e		db	00eh	; 00001110b . 054ee 0e
d2b2f		db	000h	; 00000000b . 054ef 00
d2b30		db	004h	; 00000100b . 054f0 04
d2b31		db	000h	; 00000000b . 054f1 00
d2b32		db	000h	; 00000000b . 054f2 00
d2b33		db	000h	; 00000000b . 054f3 00
d2b34		db	000h	; 00000000b . 054f4 00
d2b35		db	000h	; 00000000b . 054f5 00
d2b36		db	000h	; 00000000b . 054f6 00
d2b37		db	000h	; 00000000b . 054f7 00
d2b38		db	000h	; 00000000b . 054f8 00
d2b39		db	000h	; 00000000b . 054f9 00
d2b3a		db	000h	; 00000000b . 054fa 00
d2b3b		db	000h	; 00000000b . 054fb 00
d2b3c		db	000h	; 00000000b . 054fc 00
d2b3d		db	000h	; 00000000b . 054fd 00
d2b3e		db	000h	; 00000000b . 054fe 00
d2b3f		db	000h	; 00000000b . 054ff 00
d2b40		db	000h	; 00000000b . 05500 00
d2b41		db	000h	; 00000000b . 05501 00
d2b42		db	000h	; 00000000b . 05502 00
d2b43		db	000h	; 00000000b . 05503 00
d2b44		db	000h	; 00000000b . 05504 00
d2b45		db	000h	; 00000000b . 05505 00
d2b46		db	000h	; 00000000b . 05506 00
d2b47		db	000h	; 00000000b . 05507 00
d2b48		db	000h	; 00000000b . 05508 00
d2b49		db	000h	; 00000000b . 05509 00
d2b4a		db	000h	; 00000000b . 0550a 00
d2b4b		db	000h	; 00000000b . 0550b 00
d2b4c		db	000h	; 00000000b . 0550c 00
d2b4d		db	000h	; 00000000b . 0550d 00
d2b4e		db	000h	; 00000000b . 0550e 00
d2b4f		db	000h	; 00000000b . 0550f 00
d2b50		db	000h	; 00000000b . 05510 00
d2b51		db	000h	; 00000000b . 05511 00
d2b52		db	000h	; 00000000b . 05512 00
d2b53		db	000h	; 00000000b . 05513 00
d2b54		db	000h	; 00000000b . 05514 00
d2b55		db	000h	; 00000000b . 05515 00
d2b56		db	000h	; 00000000b . 05516 00
d2b57		db	000h	; 00000000b . 05517 00
d2b58		db	000h	; 00000000b . 05518 00
d2b59		db	000h	; 00000000b . 05519 00
d2b5a		db	000h	; 00000000b . 0551a 00
d2b5b		db	000h	; 00000000b . 0551b 00
d2b5c		db	000h	; 00000000b . 0551c 00
d2b5d		db	000h	; 00000000b . 0551d 00
d2b5e		db	000h	; 00000000b . 0551e 00
d2b5f		db	000h	; 00000000b . 0551f 00
d2b60		db	000h	; 00000000b . 05520 00
d2b61		db	000h	; 00000000b . 05521 00
d2b62		db	000h	; 00000000b . 05522 00
d2b63		db	000h	; 00000000b . 05523 00
d2b64		db	000h	; 00000000b . 05524 00
d2b65		db	000h	; 00000000b . 05525 00
d2b66		db	000h	; 00000000b . 05526 00
d2b67		db	000h	; 00000000b . 05527 00
d2b68		db	000h	; 00000000b . 05528 00
d2b69		db	000h	; 00000000b . 05529 00
d2b6a		db	000h	; 00000000b . 0552a 00
d2b6b		db	000h	; 00000000b . 0552b 00
d2b6c		db	000h	; 00000000b . 0552c 00
d2b6d		db	000h	; 00000000b . 0552d 00
d2b6e		db	000h	; 00000000b . 0552e 00
d2b6f		db	000h	; 00000000b . 0552f 00
d2b70		db	000h	; 00000000b . 05530 00
d2b71		db	000h	; 00000000b . 05531 00
d2b72		db	000h	; 00000000b . 05532 00
d2b73		db	000h	; 00000000b . 05533 00
d2b74		db	000h	; 00000000b . 05534 00
d2b75		db	000h	; 00000000b . 05535 00
d2b76		db	000h	; 00000000b . 05536 00
d2b77		db	000h	; 00000000b . 05537 00
d2b78		db	000h	; 00000000b . 05538 00
d2b79		db	000h	; 00000000b . 05539 00
d2b7a		db	000h	; 00000000b . 0553a 00
d2b7b		db	000h	; 00000000b . 0553b 00
d2b7c		db	000h	; 00000000b . 0553c 00
d2b7d		db	000h	; 00000000b . 0553d 00
d2b7e		db	000h	; 00000000b . 0553e 00
d2b7f		db	000h	; 00000000b . 0553f 00
d2b80		db	000h	; 00000000b . 05540 00
d2b81		db	000h	; 00000000b . 05541 00
d2b82		db	000h	; 00000000b . 05542 00
d2b83		db	000h	; 00000000b . 05543 00
d2b84		db	000h	; 00000000b . 05544 00
d2b85		db	000h	; 00000000b . 05545 00
d2b86		db	000h	; 00000000b . 05546 00
d2b87		db	000h	; 00000000b . 05547 00
d2b88		db	000h	; 00000000b . 05548 00
d2b89		db	000h	; 00000000b . 05549 00
d2b8a		db	000h	; 00000000b . 0554a 00
d2b8b		db	000h	; 00000000b . 0554b 00
d2b8c		db	000h	; 00000000b . 0554c 00
d2b8d		db	000h	; 00000000b . 0554d 00
d2b8e		db	000h	; 00000000b . 0554e 00
d2b8f		db	000h	; 00000000b . 0554f 00
d2b90		db	000h	; 00000000b . 05550 00
d2b91		db	000h	; 00000000b . 05551 00
d2b92		db	000h	; 00000000b . 05552 00
d2b93		db	000h	; 00000000b . 05553 00
d2b94		db	000h	; 00000000b . 05554 00
d2b95		db	000h	; 00000000b . 05555 00
d2b96		db	000h	; 00000000b . 05556 00
d2b97		db	000h	; 00000000b . 05557 00
d2b98		db	000h	; 00000000b . 05558 00
d2b99		db	000h	; 00000000b . 05559 00
d2b9a		db	000h	; 00000000b . 0555a 00
d2b9b		db	000h	; 00000000b . 0555b 00
d2b9c		db	000h	; 00000000b . 0555c 00
d2b9d		db	000h	; 00000000b . 0555d 00
d2b9e		db	000h	; 00000000b . 0555e 00
d2b9f		db	000h	; 00000000b . 0555f 00
d2ba0		db	000h	; 00000000b . 05560 00
d2ba1		db	000h	; 00000000b . 05561 00
d2ba2		db	092h	; 10010010b . 05562 92
d2ba3		db	02eh	; 00101110b . 05563 2e
d2ba4		db	019h	; 00011001b . 05564 19
d2ba5		db	026h	; 00100110b & 05565 26
d2ba6		db	000h	; 00000000b . 05566 00
d2ba7		db	092h	; 10010010b . 05567 92
d2ba8		db	02eh	; 00101110b . 05568 2e
d2ba9		db	00eh	; 00001110b . 05569 0e
d2baa		db	00eh	; 00001110b . 0556a 0e
d2bab		db	000h	; 00000000b . 0556b 00
d2bac		db	000h	; 00000000b . 0556c 00
d2bad		db	000h	; 00000000b . 0556d 00
d2bae		db	000h	; 00000000b . 0556e 00
d2baf		db	000h	; 00000000b . 0556f 00
d2bb0		db	000h	; 00000000b . 05570 00
d2bb1		db	000h	; 00000000b . 05571 00
d2bb2		db	000h	; 00000000b . 05572 00
d2bb3		db	000h	; 00000000b . 05573 00
d2bb4		db	000h	; 00000000b . 05574 00
d2bb5		db	000h	; 00000000b . 05575 00
d2bb6		db	000h	; 00000000b . 05576 00
d2bb7		db	000h	; 00000000b . 05577 00
d2bb8		db	000h	; 00000000b . 05578 00
d2bb9		db	000h	; 00000000b . 05579 00
d2bba		db	000h	; 00000000b . 0557a 00
d2bbb		db	000h	; 00000000b . 0557b 00
d2bbc		db	000h	; 00000000b . 0557c 00
d2bbd		db	000h	; 00000000b . 0557d 00
d2bbe		db	000h	; 00000000b . 0557e 00
d2bbf		db	000h	; 00000000b . 0557f 00
d2bc0		db	000h	; 00000000b . 05580 00
d2bc1		db	000h	; 00000000b . 05581 00
d2bc2		db	000h	; 00000000b . 05582 00
d2bc3		db	000h	; 00000000b . 05583 00
d2bc4		db	000h	; 00000000b . 05584 00
d2bc5		db	000h	; 00000000b . 05585 00
d2bc6		db	000h	; 00000000b . 05586 00
d2bc7		db	000h	; 00000000b . 05587 00
d2bc8		db	000h	; 00000000b . 05588 00
d2bc9		db	000h	; 00000000b . 05589 00
d2bca		db	000h	; 00000000b . 0558a 00
d2bcb		db	000h	; 00000000b . 0558b 00
d2bcc		db	000h	; 00000000b . 0558c 00
d2bcd		db	000h	; 00000000b . 0558d 00
d2bce		db	000h	; 00000000b . 0558e 00
d2bcf		db	000h	; 00000000b . 0558f 00
d2bd0		db	000h	; 00000000b . 05590 00
d2bd1		db	000h	; 00000000b . 05591 00
d2bd2		db	000h	; 00000000b . 05592 00
d2bd3		db	000h	; 00000000b . 05593 00
d2bd4		db	000h	; 00000000b . 05594 00
d2bd5		db	000h	; 00000000b . 05595 00
d2bd6		db	000h	; 00000000b . 05596 00
d2bd7		db	000h	; 00000000b . 05597 00
d2bd8		db	000h	; 00000000b . 05598 00
d2bd9		db	000h	; 00000000b . 05599 00
d2bda		db	000h	; 00000000b . 0559a 00
d2bdb		db	000h	; 00000000b . 0559b 00
d2bdc		db	000h	; 00000000b . 0559c 00
d2bdd		db	000h	; 00000000b . 0559d 00
d2bde		db	000h	; 00000000b . 0559e 00
d2bdf		db	000h	; 00000000b . 0559f 00
d2be0		db	000h	; 00000000b . 055a0 00
d2be1		db	000h	; 00000000b . 055a1 00
d2be2		db	000h	; 00000000b . 055a2 00
d2be3		db	000h	; 00000000b . 055a3 00
d2be4		db	000h	; 00000000b . 055a4 00
d2be5		db	000h	; 00000000b . 055a5 00
d2be6		db	000h	; 00000000b . 055a6 00
d2be7		db	000h	; 00000000b . 055a7 00
d2be8		db	000h	; 00000000b . 055a8 00
d2be9		db	000h	; 00000000b . 055a9 00
d2bea		db	000h	; 00000000b . 055aa 00
d2beb		db	000h	; 00000000b . 055ab 00
d2bec		db	000h	; 00000000b . 055ac 00
d2bed		db	000h	; 00000000b . 055ad 00
d2bee		db	000h	; 00000000b . 055ae 00
d2bef		db	000h	; 00000000b . 055af 00
d2bf0		db	000h	; 00000000b . 055b0 00
d2bf1		db	000h	; 00000000b . 055b1 00
d2bf2		db	000h	; 00000000b . 055b2 00
d2bf3		db	000h	; 00000000b . 055b3 00
d2bf4		db	000h	; 00000000b . 055b4 00
d2bf5		db	000h	; 00000000b . 055b5 00
d2bf6		db	000h	; 00000000b . 055b6 00
d2bf7		db	000h	; 00000000b . 055b7 00
d2bf8		db	000h	; 00000000b . 055b8 00
d2bf9		db	000h	; 00000000b . 055b9 00
d2bfa		db	000h	; 00000000b . 055ba 00
d2bfb		db	000h	; 00000000b . 055bb 00
d2bfc		db	000h	; 00000000b . 055bc 00
d2bfd		db	000h	; 00000000b . 055bd 00
d2bfe		db	000h	; 00000000b . 055be 00
d2bff		db	000h	; 00000000b . 055bf 00
d2c00		db	000h	; 00000000b . 055c0 00
d2c01		db	000h	; 00000000b . 055c1 00
d2c02		db	000h	; 00000000b . 055c2 00
d2c03		db	000h	; 00000000b . 055c3 00
d2c04		db	000h	; 00000000b . 055c4 00
d2c05		db	000h	; 00000000b . 055c5 00
d2c06		db	000h	; 00000000b . 055c6 00
d2c07		db	000h	; 00000000b . 055c7 00
d2c08		db	000h	; 00000000b . 055c8 00
d2c09		db	000h	; 00000000b . 055c9 00
d2c0a		db	000h	; 00000000b . 055ca 00
d2c0b		db	000h	; 00000000b . 055cb 00
d2c0c		db	000h	; 00000000b . 055cc 00
d2c0d		db	000h	; 00000000b . 055cd 00
d2c0e		db	000h	; 00000000b . 055ce 00
d2c0f		db	000h	; 00000000b . 055cf 00
d2c10		db	000h	; 00000000b . 055d0 00
d2c11		db	000h	; 00000000b . 055d1 00
d2c12		db	000h	; 00000000b . 055d2 00
d2c13		db	000h	; 00000000b . 055d3 00
d2c14		db	000h	; 00000000b . 055d4 00
d2c15		db	000h	; 00000000b . 055d5 00
d2c16		db	000h	; 00000000b . 055d6 00
d2c17		db	000h	; 00000000b . 055d7 00
d2c18		db	000h	; 00000000b . 055d8 00
d2c19		db	000h	; 00000000b . 055d9 00
d2c1a		db	000h	; 00000000b . 055da 00
d2c1b		db	000h	; 00000000b . 055db 00
d2c1c		db	000h	; 00000000b . 055dc 00
d2c1d		db	002h	; 00000010b . 055dd 02
d2c1e		db	0adh	; 10101101b . 055de ad
d2c1f		db	02ch	; 00101100b , 055df 2c
d2c20		db	01ah	; 00011010b . 055e0 1a
d2c21		db	026h	; 00100110b & 055e1 26
d2c22		db	000h	; 00000000b . 055e2 00
d2c23		db	0adh	; 10101101b . 055e3 ad
d2c24		db	02ch	; 00101100b , 055e4 2c
d2c25		db	00eh	; 00001110b . 055e5 0e
d2c26		db	00eh	; 00001110b . 055e6 0e
d2c27		db	000h	; 00000000b . 055e7 00
d2c28		db	004h	; 00000100b . 055e8 04
d2c29		db	000h	; 00000000b . 055e9 00
d2c2a		db	000h	; 00000000b . 055ea 00
d2c2b		db	000h	; 00000000b . 055eb 00
d2c2c		db	000h	; 00000000b . 055ec 00
d2c2d		db	000h	; 00000000b . 055ed 00
d2c2e		db	000h	; 00000000b . 055ee 00
d2c2f		db	000h	; 00000000b . 055ef 00
d2c30		db	000h	; 00000000b . 055f0 00
d2c31		db	000h	; 00000000b . 055f1 00
d2c32		db	000h	; 00000000b . 055f2 00
d2c33		db	000h	; 00000000b . 055f3 00
d2c34		db	000h	; 00000000b . 055f4 00
d2c35		db	000h	; 00000000b . 055f5 00
d2c36		db	000h	; 00000000b . 055f6 00
d2c37		db	000h	; 00000000b . 055f7 00
d2c38		db	000h	; 00000000b . 055f8 00
d2c39		db	000h	; 00000000b . 055f9 00
d2c3a		db	000h	; 00000000b . 055fa 00
d2c3b		db	000h	; 00000000b . 055fb 00
d2c3c		db	000h	; 00000000b . 055fc 00
d2c3d		db	000h	; 00000000b . 055fd 00
d2c3e		db	000h	; 00000000b . 055fe 00
d2c3f		db	000h	; 00000000b . 055ff 00
d2c40		db	000h	; 00000000b . 05600 00
d2c41		db	000h	; 00000000b . 05601 00
d2c42		db	000h	; 00000000b . 05602 00
d2c43		db	000h	; 00000000b . 05603 00
d2c44		db	000h	; 00000000b . 05604 00
d2c45		db	000h	; 00000000b . 05605 00
d2c46		db	000h	; 00000000b . 05606 00
d2c47		db	000h	; 00000000b . 05607 00
d2c48		db	000h	; 00000000b . 05608 00
d2c49		db	000h	; 00000000b . 05609 00
d2c4a		db	000h	; 00000000b . 0560a 00
d2c4b		db	000h	; 00000000b . 0560b 00
d2c4c		db	000h	; 00000000b . 0560c 00
d2c4d		db	000h	; 00000000b . 0560d 00
d2c4e		db	000h	; 00000000b . 0560e 00
d2c4f		db	000h	; 00000000b . 0560f 00
d2c50		db	000h	; 00000000b . 05610 00
d2c51		db	000h	; 00000000b . 05611 00
d2c52		db	000h	; 00000000b . 05612 00
d2c53		db	000h	; 00000000b . 05613 00
d2c54		db	000h	; 00000000b . 05614 00
d2c55		db	000h	; 00000000b . 05615 00
d2c56		db	000h	; 00000000b . 05616 00
d2c57		db	000h	; 00000000b . 05617 00
d2c58		db	000h	; 00000000b . 05618 00
d2c59		db	000h	; 00000000b . 05619 00
d2c5a		db	000h	; 00000000b . 0561a 00
d2c5b		db	000h	; 00000000b . 0561b 00
d2c5c		db	000h	; 00000000b . 0561c 00
d2c5d		db	000h	; 00000000b . 0561d 00
d2c5e		db	000h	; 00000000b . 0561e 00
d2c5f		db	000h	; 00000000b . 0561f 00
d2c60		db	000h	; 00000000b . 05620 00
d2c61		db	000h	; 00000000b . 05621 00
d2c62		db	000h	; 00000000b . 05622 00
d2c63		db	000h	; 00000000b . 05623 00
d2c64		db	000h	; 00000000b . 05624 00
d2c65		db	000h	; 00000000b . 05625 00
d2c66		db	000h	; 00000000b . 05626 00
d2c67		db	000h	; 00000000b . 05627 00
d2c68		db	000h	; 00000000b . 05628 00
d2c69		db	000h	; 00000000b . 05629 00
d2c6a		db	000h	; 00000000b . 0562a 00
d2c6b		db	000h	; 00000000b . 0562b 00
d2c6c		db	000h	; 00000000b . 0562c 00
d2c6d		db	000h	; 00000000b . 0562d 00
d2c6e		db	000h	; 00000000b . 0562e 00
d2c6f		db	000h	; 00000000b . 0562f 00
d2c70		db	000h	; 00000000b . 05630 00
d2c71		db	000h	; 00000000b . 05631 00
d2c72		db	000h	; 00000000b . 05632 00
d2c73		db	000h	; 00000000b . 05633 00
d2c74		db	000h	; 00000000b . 05634 00
d2c75		db	000h	; 00000000b . 05635 00
d2c76		db	000h	; 00000000b . 05636 00
d2c77		db	000h	; 00000000b . 05637 00
d2c78		db	000h	; 00000000b . 05638 00
d2c79		db	000h	; 00000000b . 05639 00
d2c7a		db	000h	; 00000000b . 0563a 00
d2c7b		db	000h	; 00000000b . 0563b 00
d2c7c		db	000h	; 00000000b . 0563c 00
d2c7d		db	000h	; 00000000b . 0563d 00
d2c7e		db	000h	; 00000000b . 0563e 00
d2c7f		db	000h	; 00000000b . 0563f 00
d2c80		db	000h	; 00000000b . 05640 00
d2c81		db	000h	; 00000000b . 05641 00
d2c82		db	000h	; 00000000b . 05642 00
d2c83		db	000h	; 00000000b . 05643 00
d2c84		db	000h	; 00000000b . 05644 00
d2c85		db	000h	; 00000000b . 05645 00
d2c86		db	000h	; 00000000b . 05646 00
d2c87		db	000h	; 00000000b . 05647 00
d2c88		db	000h	; 00000000b . 05648 00
d2c89		db	000h	; 00000000b . 05649 00
d2c8a		db	000h	; 00000000b . 0564a 00
d2c8b		db	000h	; 00000000b . 0564b 00
d2c8c		db	000h	; 00000000b . 0564c 00
d2c8d		db	000h	; 00000000b . 0564d 00
d2c8e		db	000h	; 00000000b . 0564e 00
d2c8f		db	000h	; 00000000b . 0564f 00
d2c90		db	000h	; 00000000b . 05650 00
d2c91		db	000h	; 00000000b . 05651 00
d2c92		db	000h	; 00000000b . 05652 00
d2c93		db	000h	; 00000000b . 05653 00
d2c94		db	000h	; 00000000b . 05654 00
d2c95		db	000h	; 00000000b . 05655 00
d2c96		db	000h	; 00000000b . 05656 00
d2c97		db	000h	; 00000000b . 05657 00
d2c98		db	000h	; 00000000b . 05658 00
d2c99		db	0e6h	; 11100110b . 05659 e6
d2c9a		db	0c8h	; 11001000b . 0565a c8
d2c9b		db	000h	; 00000000b . 0565b 00
d2c9c		db	000h	; 00000000b . 0565c 00
d2c9d		db	000h	; 00000000b . 0565d 00
d2c9e		db	038h	; 00111000b 8 0565e 38
d2c9f		db	000h	; 00000000b . 0565f 00
d2ca0		db	070h	; 01110000b p 05660 70
d2ca1		db	000h	; 00000000b . 05661 00
d2ca2		db	0a8h	; 10101000b . 05662 a8
d2ca3		db	000h	; 00000000b . 05663 00
d2ca4		db	0e0h	; 11100000b . 05664 e0
d2ca5		db	000h	; 00000000b . 05665 00
d2ca6		db	018h	; 00011000b . 05666 18
d2ca7		db	001h	; 00000001b . 05667 01
d2ca8		db	050h	; 01010000b P 05668 50
d2ca9		db	001h	; 00000001b . 05669 01
d2caa		db	088h	; 10001000b . 0566a 88
d2cab		db	001h	; 00000001b . 0566b 01
d2cac		db	0c0h	; 11000000b . 0566c c0
d2cad		db	001h	; 00000001b . 0566d 01
d2cae		db	0f8h	; 11111000b . 0566e f8
d2caf		db	001h	; 00000001b . 0566f 01
d2cb0		db	030h	; 00110000b 0 05670 30
d2cb1		db	002h	; 00000010b . 05671 02
d2cb2		db	068h	; 01101000b h 05672 68
d2cb3		db	002h	; 00000010b . 05673 02
d2cb4		db	0a0h	; 10100000b . 05674 a0
d2cb5		db	002h	; 00000010b . 05675 02
d2cb6		db	0d8h	; 11011000b . 05676 d8
d2cb7		db	002h	; 00000010b . 05677 02
d2cb8		db	010h	; 00010000b . 05678 10
d2cb9		db	003h	; 00000011b . 05679 03
d2cba		db	048h	; 01001000b H 0567a 48
d2cbb		db	003h	; 00000011b . 0567b 03
d2cbc		db	000h	; 00000000b . 0567c 00
d2cbd		db	0e2h	; 11100010b . 0567d e2
d2cbe		db	01eh	; 00011110b . 0567e 1e
d2cbf		db	0ffh	; 11111111b . 0567f ff
d2cc0		db	001h	; 00000001b . 05680 01
d2cc1		db	060h	; 01100000b ` 05681 60
d2cc2		db	0ffh	; 11111111b . 05682 ff
d2cc3		db	0a0h	; 10100000b . 05683 a0
d2cc4		db	000h	; 00000000b . 05684 00
d2cc5		db	0ffh	; 11111111b . 05685 ff
d2cc6		db	0ffh	; 11111111b . 05686 ff
d2cc7		db	001h	; 00000001b . 05687 01
d2cc8		db	000h	; 00000000b . 05688 00
d2cc9		db	000h	; 00000000b . 05689 00
d2cca		db	000h	; 00000000b . 0568a 00
d2ccb		db	00eh	; 00001110b . 0568b 0e
d2ccc		db	001h	; 00000001b . 0568c 01
d2ccd		db	000h	; 00000000b . 0568d 00
d2cce		db	000h	; 00000000b . 0568e 00
d2ccf		db	000h	; 00000000b . 0568f 00
d2cd0		db	002h	; 00000010b . 05690 02
d2cd1		db	000h	; 00000000b . 05691 00
d2cd2		db	002h	; 00000010b . 05692 02
d2cd3		db	000h	; 00000000b . 05693 00
d2cd4		db	0e3h	; 11100011b . 05694 e3
d2cd5		db	008h	; 00001000b . 05695 08
d2cd6		db	028h	; 00101000b ( 05696 28
d2cd7		db	00ah	; 00001010b . 05697 0a
d2cd8		db	0d9h	; 11011001b . 05698 d9
d2cd9		db	00bh	; 00001011b . 05699 0b
d2cda		db	055h	; 01010101b U 0569a 55
d2cdb		db	00dh	; 00001101b . 0569b 0d
d2cdc		db	0c6h	; 11000110b . 0569c c6
d2cdd		db	011h	; 00010001b . 0569d 11
d2cde		db	0d9h	; 11011001b . 0569e d9
d2cdf		db	00bh	; 00001011b . 0569f 0b
d2ce0		db	055h	; 01010101b U 056a0 55
d2ce1		db	00dh	; 00001101b . 056a1 0d
d2ce2		db	03ch	; 00111100b < 056a2 3c
d2ce3		db	00fh	; 00001111b . 056a3 0f
d2ce4		db	0c6h	; 11000110b . 056a4 c6
d2ce5		db	011h	; 00010001b . 056a5 11
d2ce6		db	0ffh	; 11111111b . 056a6 ff
d2ce7		db	013h	; 00010011b . 056a7 13
d2ce8		db	0a9h	; 10101001b . 056a8 a9
d2ce9		db	01ah	; 00011010b . 056a9 1a
d2cea		db	0c6h	; 11000110b . 056aa c6
d2ceb		db	011h	; 00010001b . 056ab 11
d2cec		db	0ffh	; 11111111b . 056ac ff
d2ced		db	013h	; 00010011b . 056ad 13
d2cee		db	0dah	; 11011010b . 056ae da
d2cef		db	016h	; 00010110b . 056af 16
d2cf0		db	0a9h	; 10101001b . 056b0 a9
d2cf1		db	01ah	; 00011010b . 056b1 1a
d2cf2		db	0feh	; 11111110b . 056b2 fe
d2cf3		db	01dh	; 00011101b . 056b3 1d
d2cf4		db	0feh	; 11111110b . 056b4 fe
d2cf5		db	027h	; 00100111b ' 056b5 27
d2cf6		db	0a9h	; 10101001b . 056b6 a9
d2cf7		db	01ah	; 00011010b . 056b7 1a
d2cf8		db	0feh	; 11111110b . 056b8 fe
d2cf9		db	01dh	; 00011101b . 056b9 1d
d2cfa		db	047h	; 01000111b G 056ba 47
d2cfb		db	022h	; 00100010b " 056bb 22
d2cfc		db	0feh	; 11111110b . 056bc fe
d2cfd		db	027h	; 00100111b ' 056bd 27
d2cfe		db	0fdh	; 11111101b . 056be fd
d2cff		db	02ch	; 00101100b , 056bf 2c
d2d00		db	0fch	; 11111100b . 056c0 fc
d2d01		db	03bh	; 00111011b ; 056c1 3b
d2d02		db	0feh	; 11111110b . 056c2 fe
d2d03		db	027h	; 00100111b ' 056c3 27
d2d04		db	002h	; 00000010b . 056c4 02
d2d05		db	000h	; 00000000b . 056c5 00
d2d06		db	0f0h	; 11110000b . 056c6 f0
d2d07		db	005h	; 00000101b . 056c7 05
d2d08		db	0f6h	; 11110110b . 056c8 f6
d2d09		db	003h	; 00000011b . 056c9 03
d2d0a		db	002h	; 00000010b . 056ca 02
d2d0b		db	000h	; 00000000b . 056cb 00
d2d0c		db	0f0h	; 11110000b . 056cc f0
d2d0d		db	005h	; 00000101b . 056cd 05
d2d0e		db	0f6h	; 11110110b . 056ce f6
d2d0f		db	003h	; 00000011b . 056cf 03
d2d10		db	002h	; 00000010b . 056d0 02
d2d11		db	000h	; 00000000b . 056d1 00
d2d12		db	002h	; 00000010b . 056d2 02
d2d13		db	000h	; 00000000b . 056d3 00
d2d14		db	06ah	; 01101010b j 056d4 6a
d2d15		db	030h	; 00110000b 0 056d5 30
d2d16		db	06eh	; 01101110b n 056d6 6e
d2d17		db	030h	; 00110000b 0 056d7 30
d2d18		db	08ah	; 10001010b . 056d8 8a
d2d19		db	02eh	; 00101110b . 056d9 2e
d2d1a		db	08eh	; 10001110b . 056da 8e
d2d1b		db	02eh	; 00101110b . 056db 2e
d2d1c		db	08ah	; 10001010b . 056dc 8a
d2d1d		db	02eh	; 00101110b . 056dd 2e
d2d1e		db	08eh	; 10001110b . 056de 8e
d2d1f		db	02eh	; 00101110b . 056df 2e
d2d20		db	0aah	; 10101010b . 056e0 aa
d2d21		db	02ch	; 00101100b , 056e1 2c
d2d22		db	0aeh	; 10101110b . 056e2 ae
d2d23		db	02ch	; 00101100b , 056e3 2c
d2d24		db	000h	; 00000000b . 056e4 00
d2d25		db	000h	; 00000000b . 056e5 00
d2d26		db	03ch	; 00111100b < 056e6 3c
d2d27		db	000h	; 00000000b . 056e7 00
d2d28		db	020h	; 00100000b   056e8 20
d2d29		db	03ch	; 00111100b < 056e9 3c
d2d2a		db	000h	; 00000000b . 056ea 00
d2d2b		db	000h	; 00000000b . 056eb 00
d2d2c		db	000h	; 00000000b . 056ec 00
d2d2d		db	000h	; 00000000b . 056ed 00
d2d2e		db	000h	; 00000000b . 056ee 00
d2d2f		db	001h	; 00000001b . 056ef 01
d2d30		db	005h	; 00000101b . 056f0 05
d2d31		db	000h	; 00000000b . 056f1 00
d2d32		db	009h	; 00001001b . 056f2 09
d2d33		db	060h	; 01100000b ` 056f3 60
d2d34		db	000h	; 00000000b . 056f4 00
d2d35		db	000h	; 00000000b . 056f5 00
d2d36		db	025h	; 00100101b % 056f6 25
d2d37		db	0a8h	; 10101000b . 056f7 a8
d2d38		db	000h	; 00000000b . 056f8 00
d2d39		db	000h	; 00000000b . 056f9 00
d2d3a		db	068h	; 01101000b h 056fa 68
d2d3b		db	015h	; 00010101b . 056fb 15
d2d3c		db	000h	; 00000000b . 056fc 00
d2d3d		db	000h	; 00000000b . 056fd 00
d2d3e		db	050h	; 01010000b P 056fe 50
d2d3f		db	009h	; 00001001b . 056ff 09
d2d40		db	000h	; 00000000b . 05700 00
d2d41		db	000h	; 00000000b . 05701 00
d2d42		db	090h	; 10010000b . 05702 90
d2d43		db	00ah	; 00001010b . 05703 0a
d2d44		db	000h	; 00000000b . 05704 00
d2d45		db	000h	; 00000000b . 05705 00
d2d46		db	0a0h	; 10100000b . 05706 a0
d2d47		db	006h	; 00000110b . 05707 06
d2d48		db	000h	; 00000000b . 05708 00
d2d49		db	000h	; 00000000b . 05709 00
d2d4a		db	060h	; 01100000b ` 0570a 60
d2d4b		db	000h	; 00000000b . 0570b 00
d2d4c		db	000h	; 00000000b . 0570c 00
d2d4d		db	000h	; 00000000b . 0570d 00
d2d4e		db	050h	; 01010000b P 0570e 50
d2d4f		db	000h	; 00000000b . 0570f 00
d2d50		db	000h	; 00000000b . 05710 00
d2d51		db	000h	; 00000000b . 05711 00
d2d52		db	090h	; 10010000b . 05712 90
d2d53		db	000h	; 00000000b . 05713 00
d2d54		db	000h	; 00000000b . 05714 00
d2d55		db	000h	; 00000000b . 05715 00
d2d56		db	0a0h	; 10100000b . 05716 a0
d2d57		db	000h	; 00000000b . 05717 00
d2d58		db	000h	; 00000000b . 05718 00
d2d59		db	000h	; 00000000b . 05719 00
d2d5a		db	060h	; 01100000b ` 0571a 60
d2d5b		db	000h	; 00000000b . 0571b 00
d2d5c		db	000h	; 00000000b . 0571c 00
d2d5d		db	000h	; 00000000b . 0571d 00
d2d5e		db	050h	; 01010000b P 0571e 50
d2d5f		db	000h	; 00000000b . 0571f 00
d2d60		db	000h	; 00000000b . 05720 00
d2d61		db	000h	; 00000000b . 05721 00
d2d62		db	090h	; 10010000b . 05722 90
d2d63		db	000h	; 00000000b . 05723 00
d2d64		db	000h	; 00000000b . 05724 00
d2d65		db	000h	; 00000000b . 05725 00
d2d66		db	0a0h	; 10100000b . 05726 a0
d2d67		db	000h	; 00000000b . 05727 00
d2d68		db	000h	; 00000000b . 05728 00
d2d69		db	000h	; 00000000b . 05729 00
d2d6a		db	003h	; 00000011b . 0572a 03
d2d6b		db	000h	; 00000000b . 0572b 00
d2d6c		db	000h	; 00000000b . 0572c 00
d2d6d		db	000h	; 00000000b . 0572d 00
d2d6e		db	000h	; 00000000b . 0572e 00
d2d6f		db	000h	; 00000000b . 0572f 00
d2d70		db	007h	; 00000111b . 05730 07
d2d71		db	0aah	; 10101010b . 05731 aa
d2d72		db	0aah	; 10101010b . 05732 aa
d2d73		db	0a0h	; 10100000b . 05733 a0
d2d74		db	007h	; 00000111b . 05734 07
d2d75		db	0a2h	; 10100010b . 05735 a2
d2d76		db	0aah	; 10101010b . 05736 aa
d2d77		db	0a0h	; 10100000b . 05737 a0
d2d78		db	007h	; 00000111b . 05738 07
d2d79		db	0aah	; 10101010b . 05739 aa
d2d7a		db	0aah	; 10101010b . 0573a aa
d2d7b		db	020h	; 00100000b   0573b 20
d2d7c		db	007h	; 00000111b . 0573c 07
d2d7d		db	0aah	; 10101010b . 0573d aa
d2d7e		db	08ah	; 10001010b . 0573e 8a
d2d7f		db	0a0h	; 10100000b . 0573f a0
d2d80		db	007h	; 00000111b . 05740 07
d2d81		db	0eah	; 11101010b . 05741 ea
d2d82		db	0aah	; 10101010b . 05742 aa
d2d83		db	0a0h	; 10100000b . 05743 a0
d2d84		db	005h	; 00000101b . 05744 05
d2d85		db	0e2h	; 11100010b . 05745 e2
d2d86		db	0aah	; 10101010b . 05746 aa
d2d87		db	0a0h	; 10100000b . 05747 a0
d2d88		db	001h	; 00000001b . 05748 01
d2d89		db	0eah	; 11101010b . 05749 ea
d2d8a		db	0aah	; 10101010b . 0574a aa
d2d8b		db	0a0h	; 10100000b . 0574b a0
d2d8c		db	001h	; 00000001b . 0574c 01
d2d8d		db	0fah	; 11111010b . 0574d fa
d2d8e		db	0a2h	; 10100010b . 0574e a2
d2d8f		db	0a0h	; 10100000b . 0574f a0
d2d90		db	001h	; 00000001b . 05750 01
d2d91		db	07eh	; 01111110b ~ 05751 7e
d2d92		db	0aah	; 10101010b . 05752 aa
d2d93		db	0a0h	; 10100000b . 05753 a0
d2d94		db	000h	; 00000000b . 05754 00
d2d95		db	05fh	; 01011111b _ 05755 5f
d2d96		db	0fah	; 11111010b . 05756 fa
d2d97		db	0a0h	; 10100000b . 05757 a0
d2d98		db	000h	; 00000000b . 05758 00
d2d99		db	015h	; 00010101b . 05759 15
d2d9a		db	07fh	; 01111111b . 0575a 7f
d2d9b		db	0f0h	; 11110000b . 0575b f0
d2d9c		db	000h	; 00000000b . 0575c 00
d2d9d		db	000h	; 00000000b . 0575d 00
d2d9e		db	055h	; 01010101b U 0575e 55
d2d9f		db	050h	; 01010000b P 0575f 50
d2da0		db	000h	; 00000000b . 05760 00
d2da1		db	000h	; 00000000b . 05761 00
d2da2		db	000h	; 00000000b . 05762 00
d2da3		db	000h	; 00000000b . 05763 00
d2da4		db	000h	; 00000000b . 05764 00
d2da5		db	006h	; 00000110b . 05765 06
d2da6		db	000h	; 00000000b . 05766 00
d2da7		db	000h	; 00000000b . 05767 00
d2da8		db	000h	; 00000000b . 05768 00
d2da9		db	000h	; 00000000b . 05769 00
d2daa		db	040h	; 01000000b @ 0576a 40
d2dab		db	000h	; 00000000b . 0576b 00
d2dac		db	000h	; 00000000b . 0576c 00
d2dad		db	000h	; 00000000b . 0576d 00
d2dae		db	040h	; 01000000b @ 0576e 40
d2daf		db	000h	; 00000000b . 0576f 00
d2db0		db	000h	; 00000000b . 05770 00
d2db1		db	001h	; 00000001b . 05771 01
d2db2		db	040h	; 01000000b @ 05772 40
d2db3		db	000h	; 00000000b . 05773 00
d2db4		db	000h	; 00000000b . 05774 00
d2db5		db	003h	; 00000011b . 05775 03
d2db6		db	040h	; 01000000b @ 05776 40
d2db7		db	000h	; 00000000b . 05777 00
d2db8		db	000h	; 00000000b . 05778 00
d2db9		db	00fh	; 00001111b . 05779 0f
d2dba		db	0c0h	; 11000000b . 0577a c0
d2dbb		db	000h	; 00000000b . 0577b 00
d2dbc		db	000h	; 00000000b . 0577c 00
d2dbd		db	03fh	; 00111111b ? 0577d 3f
d2dbe		db	0c0h	; 11000000b . 0577e c0
d2dbf		db	000h	; 00000000b . 0577f 00
d2dc0		db	000h	; 00000000b . 05780 00
d2dc1		db	0ffh	; 11111111b . 05781 ff
d2dc2		db	000h	; 00000000b . 05782 00
d2dc3		db	000h	; 00000000b . 05783 00
d2dc4		db	003h	; 00000011b . 05784 03
d2dc5		db	0dfh	; 11011111b . 05785 df
d2dc6		db	000h	; 00000000b . 05786 00
d2dc7		db	000h	; 00000000b . 05787 00
d2dc8		db	00fh	; 00001111b . 05788 0f
d2dc9		db	07ch	; 01111100b | 05789 7c
d2dca		db	000h	; 00000000b . 0578a 00
d2dcb		db	000h	; 00000000b . 0578b 00
d2dcc		db	03dh	; 00111101b = 0578c 3d
d2dcd		db	0f0h	; 11110000b . 0578d f0
d2dce		db	000h	; 00000000b . 0578e 00
d2dcf		db	000h	; 00000000b . 0578f 00
d2dd0		db	0f7h	; 11110111b . 05790 f7
d2dd1		db	0c0h	; 11000000b . 05791 c0
d2dd2		db	000h	; 00000000b . 05792 00
d2dd3		db	00fh	; 00001111b . 05793 0f
d2dd4		db	0ffh	; 11111111b . 05794 ff
d2dd5		db	000h	; 00000000b . 05795 00
d2dd6		db	000h	; 00000000b . 05796 00
d2dd7		db	017h	; 00010111b . 05797 17
d2dd8		db	0f0h	; 11110000b . 05798 f0
d2dd9		db	000h	; 00000000b . 05799 00
d2dda		db	000h	; 00000000b . 0579a 00
d2ddb		db	000h	; 00000000b . 0579b 00
d2ddc		db	000h	; 00000000b . 0579c 00
d2ddd		db	000h	; 00000000b . 0579d 00
d2dde		db	000h	; 00000000b . 0579e 00
d2ddf		db	001h	; 00000001b . 0579f 01
d2de0		db	000h	; 00000000b . 057a0 00
d2de1		db	000h	; 00000000b . 057a1 00
d2de2		db	000h	; 00000000b . 057a2 00
d2de3		db	000h	; 00000000b . 057a3 00
d2de4		db	020h	; 00100000b   057a4 20
d2de5		db	000h	; 00000000b . 057a5 00
d2de6		db	000h	; 00000000b . 057a6 00
d2de7		db	040h	; 01000000b @ 057a7 40
d2de8		db	0a0h	; 10100000b . 057a8 a0
d2de9		db	000h	; 00000000b . 057a9 00
d2dea		db	001h	; 00000001b . 057aa 01
d2deb		db	042h	; 01000010b B 057ab 42
d2dec		db	0aah	; 10101010b . 057ac aa
d2ded		db	080h	; 10000000b . 057ad 80
d2dee		db	005h	; 00000101b . 057ae 05
d2def		db	04ah	; 01001010b J 057af 4a
d2df0		db	0aah	; 10101010b . 057b0 aa
d2df1		db	080h	; 10000000b . 057b1 80
d2df2		db	005h	; 00000101b . 057b2 05
d2df3		db	04ah	; 01001010b J 057b3 4a
d2df4		db	0aah	; 10101010b . 057b4 aa
d2df5		db	080h	; 10000000b . 057b5 80
d2df6		db	005h	; 00000101b . 057b6 05
d2df7		db	04ah	; 01001010b J 057b7 4a
d2df8		db	0aah	; 10101010b . 057b8 aa
d2df9		db	0a8h	; 10101000b . 057b9 a8
d2dfa		db	015h	; 00010101b . 057ba 15
d2dfb		db	00ah	; 00001010b . 057bb 0a
d2dfc		db	0aah	; 10101010b . 057bc aa
d2dfd		db	0a0h	; 10100000b . 057bd a0
d2dfe		db	015h	; 00010101b . 057be 15
d2dff		db	006h	; 00000110b . 057bf 06
d2e00		db	0aah	; 10101010b . 057c0 aa
d2e01		db	080h	; 10000000b . 057c1 80
d2e02		db	015h	; 00010101b . 057c2 15
d2e03		db	005h	; 00000101b . 057c3 05
d2e04		db	0aah	; 10101010b . 057c4 aa
d2e05		db	000h	; 00000000b . 057c5 00
d2e06		db	014h	; 00010100b . 057c6 14
d2e07		db	010h	; 00010000b . 057c7 10
d2e08		db	000h	; 00000000b . 057c8 00
d2e09		db	000h	; 00000000b . 057c9 00
d2e0a		db	015h	; 00010101b . 057ca 15
d2e0b		db	040h	; 01000000b @ 057cb 40
d2e0c		db	000h	; 00000000b . 057cc 00
d2e0d		db	000h	; 00000000b . 057cd 00
d2e0e		db	015h	; 00010101b . 057ce 15
d2e0f		db	055h	; 01010101b U 057cf 55
d2e10		db	055h	; 01010101b U 057d0 55
d2e11		db	040h	; 01000000b @ 057d1 40
d2e12		db	015h	; 00010101b . 057d2 15
d2e13		db	055h	; 01010101b U 057d3 55
d2e14		db	050h	; 01010000b P 057d4 50
d2e15		db	000h	; 00000000b . 057d5 00
d2e16		db	015h	; 00010101b . 057d6 15
d2e17		db	054h	; 01010100b T 057d7 54
d2e18		db	000h	; 00000000b . 057d8 00
d2e19		db	000h	; 00000000b . 057d9 00
d2e1a		db	001h	; 00000001b . 057da 01
d2e1b		db	005h	; 00000101b . 057db 05
d2e1c		db	000h	; 00000000b . 057dc 00
d2e1d		db	000h	; 00000000b . 057dd 00
d2e1e		db	000h	; 00000000b . 057de 00
d2e1f		db	000h	; 00000000b . 057df 00
d2e20		db	000h	; 00000000b . 057e0 00
d2e21		db	002h	; 00000010b . 057e1 02
d2e22		db	0a0h	; 10100000b . 057e2 a0
d2e23		db	00ah	; 00001010b . 057e3 0a
d2e24		db	080h	; 10000000b . 057e4 80
d2e25		db	00ah	; 00001010b . 057e5 0a
d2e26		db	0a8h	; 10101000b . 057e6 a8
d2e27		db	02ah	; 00101010b * 057e7 2a
d2e28		db	0a0h	; 10100000b . 057e8 a0
d2e29		db	02bh	; 00101011b + 057e9 2b
d2e2a		db	0eah	; 11101010b . 057ea ea
d2e2b		db	0aah	; 10101010b . 057eb aa
d2e2c		db	0a8h	; 10101000b . 057ec a8
d2e2d		db	02fh	; 00101111b / 057ed 2f
d2e2e		db	0aah	; 10101010b . 057ee aa
d2e2f		db	0aah	; 10101010b . 057ef aa
d2e30		db	0a8h	; 10101000b . 057f0 a8
d2e31		db	02fh	; 00101111b / 057f1 2f
d2e32		db	0aah	; 10101010b . 057f2 aa
d2e33		db	0aah	; 10101010b . 057f3 aa
d2e34		db	0a8h	; 10101000b . 057f4 a8
d2e35		db	02bh	; 00101011b + 057f5 2b
d2e36		db	0aah	; 10101010b . 057f6 aa
d2e37		db	0aah	; 10101010b . 057f7 aa
d2e38		db	0a8h	; 10101000b . 057f8 a8
d2e39		db	00ah	; 00001010b . 057f9 0a
d2e3a		db	0eah	; 11101010b . 057fa ea
d2e3b		db	0aah	; 10101010b . 057fb aa
d2e3c		db	0a0h	; 10100000b . 057fc a0
d2e3d		db	00ah	; 00001010b . 057fd 0a
d2e3e		db	0aah	; 10101010b . 057fe aa
d2e3f		db	0aah	; 10101010b . 057ff aa
d2e40		db	0a0h	; 10100000b . 05800 a0
d2e41		db	002h	; 00000010b . 05801 02
d2e42		db	0aah	; 10101010b . 05802 aa
d2e43		db	0aah	; 10101010b . 05803 aa
d2e44		db	080h	; 10000000b . 05804 80
d2e45		db	000h	; 00000000b . 05805 00
d2e46		db	0aah	; 10101010b . 05806 aa
d2e47		db	0aah	; 10101010b . 05807 aa
d2e48		db	000h	; 00000000b . 05808 00
d2e49		db	000h	; 00000000b . 05809 00
d2e4a		db	02ah	; 00101010b * 0580a 2a
d2e4b		db	0a8h	; 10101000b . 0580b a8
d2e4c		db	000h	; 00000000b . 0580c 00
d2e4d		db	000h	; 00000000b . 0580d 00
d2e4e		db	002h	; 00000010b . 0580e 02
d2e4f		db	080h	; 10000000b . 0580f 80
d2e50		db	000h	; 00000000b . 05810 00
d2e51		db	000h	; 00000000b . 05811 00
d2e52		db	000h	; 00000000b . 05812 00
d2e53		db	000h	; 00000000b . 05813 00
d2e54		db	000h	; 00000000b . 05814 00
d2e55		db	002h	; 00000010b . 05815 02
d2e56		db	005h	; 00000101b . 05816 05
d2e57		db	000h	; 00000000b . 05817 00
d2e58		db	000h	; 00000000b . 05818 00
d2e59		db	000h	; 00000000b . 05819 00
d2e5a		db	000h	; 00000000b . 0581a 00
d2e5b		db	000h	; 00000000b . 0581b 00
d2e5c		db	000h	; 00000000b . 0581c 00
d2e5d		db	002h	; 00000010b . 0581d 02
d2e5e		db	000h	; 00000000b . 0581e 00
d2e5f		db	000h	; 00000000b . 0581f 00
d2e60		db	000h	; 00000000b . 05820 00
d2e61		db	002h	; 00000010b . 05821 02
d2e62		db	080h	; 10000000b . 05822 80
d2e63		db	000h	; 00000000b . 05823 00
d2e64		db	000h	; 00000000b . 05824 00
d2e65		db	000h	; 00000000b . 05825 00
d2e66		db	080h	; 10000000b . 05826 80
d2e67		db	000h	; 00000000b . 05827 00
d2e68		db	000h	; 00000000b . 05828 00
d2e69		db	003h	; 00000011b . 05829 03
d2e6a		db	0c0h	; 11000000b . 0582a c0
d2e6b		db	000h	; 00000000b . 0582b 00
d2e6c		db	000h	; 00000000b . 0582c 00
d2e6d		db	003h	; 00000011b . 0582d 03
d2e6e		db	0c0h	; 11000000b . 0582e c0
d2e6f		db	000h	; 00000000b . 0582f 00
d2e70		db	000h	; 00000000b . 05830 00
d2e71		db	003h	; 00000011b . 05831 03
d2e72		db	0c0h	; 11000000b . 05832 c0
d2e73		db	000h	; 00000000b . 05833 00
d2e74		db	000h	; 00000000b . 05834 00
d2e75		db	003h	; 00000011b . 05835 03
d2e76		db	0c0h	; 11000000b . 05836 c0
d2e77		db	000h	; 00000000b . 05837 00
d2e78		db	000h	; 00000000b . 05838 00
d2e79		db	003h	; 00000011b . 05839 03
d2e7a		db	0c0h	; 11000000b . 0583a c0
d2e7b		db	000h	; 00000000b . 0583b 00
d2e7c		db	000h	; 00000000b . 0583c 00
d2e7d		db	005h	; 00000101b . 0583d 05
d2e7e		db	051h	; 01010001b Q 0583e 51
d2e7f		db	050h	; 01010000b P 0583f 50
d2e80		db	004h	; 00000100b . 05840 04
d2e81		db	001h	; 00000001b . 05841 01
d2e82		db	041h	; 01000001b A 05842 41
d2e83		db	010h	; 00010000b . 05843 10
d2e84		db	005h	; 00000101b . 05844 05
d2e85		db	055h	; 01010101b U 05845 55
d2e86		db	055h	; 01010101b U 05846 55
d2e87		db	050h	; 01010000b P 05847 50
d2e88		db	001h	; 00000001b . 05848 01
d2e89		db	055h	; 01010101b U 05849 55
d2e8a		db	054h	; 01010100b T 0584a 54
d2e8b		db	000h	; 00000000b . 0584b 00
d2e8c		db	000h	; 00000000b . 0584c 00
d2e8d		db	000h	; 00000000b . 0584d 00
d2e8e		db	000h	; 00000000b . 0584e 00
d2e8f		db	000h	; 00000000b . 0584f 00
d2e90		db	004h	; 00000100b . 05850 04
d2e91		db	000h	; 00000000b . 05851 00
d2e92		db	000h	; 00000000b . 05852 00
d2e93		db	000h	; 00000000b . 05853 00
d2e94		db	02ah	; 00101010b * 05854 2a
d2e95		db	0a8h	; 10101000b . 05855 a8
d2e96		db	000h	; 00000000b . 05856 00
d2e97		db	002h	; 00000010b . 05857 02
d2e98		db	083h	; 10000011b . 05858 83
d2e99		db	0c2h	; 11000010b . 05859 c2
d2e9a		db	080h	; 10000000b . 0585a 80
d2e9b		db	008h	; 00001000b . 0585b 08
d2e9c		db	003h	; 00000011b . 0585c 03
d2e9d		db	0c0h	; 11000000b . 0585d c0
d2e9e		db	020h	; 00100000b   0585e 20
d2e9f		db	008h	; 00001000b . 0585f 08
d2ea0		db	00fh	; 00001111b . 05860 0f
d2ea1		db	0f0h	; 11110000b . 05861 f0
d2ea2		db	020h	; 00100000b   05862 20
d2ea3		db	023h	; 00100011b # 05863 23
d2ea4		db	0ffh	; 11111111b . 05864 ff
d2ea5		db	0ffh	; 11111111b . 05865 ff
d2ea6		db	0c8h	; 11001000b . 05866 c8
d2ea7		db	02fh	; 00101111b / 05867 2f
d2ea8		db	0ffh	; 11111111b . 05868 ff
d2ea9		db	0ffh	; 11111111b . 05869 ff
d2eaa		db	0f8h	; 11111000b . 0586a f8
d2eab		db	023h	; 00100011b # 0586b 23
d2eac		db	0ffh	; 11111111b . 0586c ff
d2ead		db	0ffh	; 11111111b . 0586d ff
d2eae		db	0c8h	; 11001000b . 0586e c8
d2eaf		db	020h	; 00100000b   0586f 20
d2eb0		db	0ffh	; 11111111b . 05870 ff
d2eb1		db	0ffh	; 11111111b . 05871 ff
d2eb2		db	008h	; 00001000b . 05872 08
d2eb3		db	020h	; 00100000b   05873 20
d2eb4		db	03fh	; 00111111b ? 05874 3f
d2eb5		db	0fch	; 11111100b . 05875 fc
d2eb6		db	008h	; 00001000b . 05876 08
d2eb7		db	020h	; 00100000b   05877 20
d2eb8		db	03fh	; 00111111b ? 05878 3f
d2eb9		db	0fch	; 11111100b . 05879 fc
d2eba		db	008h	; 00001000b . 0587a 08
d2ebb		db	008h	; 00001000b . 0587b 08
d2ebc		db	0ffh	; 11111111b . 0587c ff
d2ebd		db	0ffh	; 11111111b . 0587d ff
d2ebe		db	020h	; 00100000b   0587e 20
d2ebf		db	008h	; 00001000b . 0587f 08
d2ec0		db	0fch	; 11111100b . 05880 fc
d2ec1		db	03fh	; 00111111b ? 05881 3f
d2ec2		db	020h	; 00100000b   05882 20
d2ec3		db	002h	; 00000010b . 05883 02
d2ec4		db	080h	; 10000000b . 05884 80
d2ec5		db	002h	; 00000010b . 05885 02
d2ec6		db	080h	; 10000000b . 05886 80
d2ec7		db	000h	; 00000000b . 05887 00
d2ec8		db	02ah	; 00101010b * 05888 2a
d2ec9		db	0a8h	; 10101000b . 05889 a8
d2eca		db	000h	; 00000000b . 0588a 00
d2ecb		db	006h	; 00000110b . 0588b 06
d2ecc		db	000h	; 00000000b . 0588c 00
d2ecd		db	000h	; 00000000b . 0588d 00
d2ece		db	000h	; 00000000b . 0588e 00
d2ecf		db	03fh	; 00111111b ? 0588f 3f
d2ed0		db	0f0h	; 11110000b . 05890 f0
d2ed1		db	000h	; 00000000b . 05891 00
d2ed2		db	000h	; 00000000b . 05892 00
d2ed3		db	0ffh	; 11111111b . 05893 ff
d2ed4		db	0fch	; 11111100b . 05894 fc
d2ed5		db	000h	; 00000000b . 05895 00
d2ed6		db	003h	; 00000011b . 05896 03
d2ed7		db	0ffh	; 11111111b . 05897 ff
d2ed8		db	0ffh	; 11111111b . 05898 ff
d2ed9		db	000h	; 00000000b . 05899 00
d2eda		db	00fh	; 00001111b . 0589a 0f
d2edb		db	0f0h	; 11110000b . 0589b f0
d2edc		db	03fh	; 00111111b ? 0589c 3f
d2edd		db	0c0h	; 11000000b . 0589d c0
d2ede		db	00fh	; 00001111b . 0589e 0f
d2edf		db	0cfh	; 11001111b . 0589f cf
d2ee0		db	0cfh	; 11001111b . 058a0 cf
d2ee1		db	0c0h	; 11000000b . 058a1 c0
d2ee2		db	00fh	; 00001111b . 058a2 0f
d2ee3		db	0cfh	; 11001111b . 058a3 cf
d2ee4		db	0cfh	; 11001111b . 058a4 cf
d2ee5		db	0c0h	; 11000000b . 058a5 c0
d2ee6		db	00fh	; 00001111b . 058a6 0f
d2ee7		db	0cfh	; 11001111b . 058a7 cf
d2ee8		db	0cfh	; 11001111b . 058a8 cf
d2ee9		db	0c0h	; 11000000b . 058a9 c0
d2eea		db	003h	; 00000011b . 058aa 03
d2eeb		db	0f3h	; 11110011b . 058ab f3
d2eec		db	03fh	; 00111111b ? 058ac 3f
d2eed		db	000h	; 00000000b . 058ad 00
d2eee		db	000h	; 00000000b . 058ae 00
d2eef		db	0f3h	; 11110011b . 058af f3
d2ef0		db	03ch	; 00111100b < 058b0 3c
d2ef1		db	000h	; 00000000b . 058b1 00
d2ef2		db	000h	; 00000000b . 058b2 00
d2ef3		db	033h	; 00110011b 3 058b3 33
d2ef4		db	030h	; 00110000b 0 058b4 30
d2ef5		db	000h	; 00000000b . 058b5 00
d2ef6		db	000h	; 00000000b . 058b6 00
d2ef7		db	020h	; 00100000b   058b7 20
d2ef8		db	020h	; 00100000b   058b8 20
d2ef9		db	000h	; 00000000b . 058b9 00
d2efa		db	000h	; 00000000b . 058ba 00
d2efb		db	02ah	; 00101010b * 058bb 2a
d2efc		db	0a0h	; 10100000b . 058bc a0
d2efd		db	000h	; 00000000b . 058bd 00
d2efe		db	000h	; 00000000b . 058be 00
d2eff		db	020h	; 00100000b   058bf 20
d2f00		db	020h	; 00100000b   058c0 20
d2f01		db	000h	; 00000000b . 058c1 00
d2f02		db	000h	; 00000000b . 058c2 00
d2f03		db	00ah	; 00001010b . 058c3 0a
d2f04		db	080h	; 10000000b . 058c4 80
d2f05		db	000h	; 00000000b . 058c5 00
d2f06		db	03fh	; 00111111b ? 058c6 3f
d2f07		db	0f0h	; 11110000b . 058c7 f0
d2f08		db	0c0h	; 11000000b . 058c8 c0
d2f09		db	00ch	; 00001100b . 058c9 0c
d2f0a		db	0c0h	; 11000000b . 058ca c0
d2f0b		db	00ch	; 00001100b . 058cb 0c
d2f0c		db	03fh	; 00111111b ? 058cc 3f
d2f0d		db	0f0h	; 11110000b . 058cd f0
d2f0e		db	000h	; 00000000b . 058ce 00
d2f0f		db	000h	; 00000000b . 058cf 00
d2f10		db	0c0h	; 11000000b . 058d0 c0
d2f11		db	030h	; 00110000b 0 058d1 30
d2f12		db	0ffh	; 11111111b . 058d2 ff
d2f13		db	0fch	; 11111100b . 058d3 fc
d2f14		db	0c0h	; 11000000b . 058d4 c0
d2f15		db	000h	; 00000000b . 058d5 00
d2f16		db	0f0h	; 11110000b . 058d6 f0
d2f17		db	030h	; 00110000b 0 058d7 30
d2f18		db	0cch	; 11001100b . 058d8 cc
d2f19		db	00ch	; 00001100b . 058d9 0c
d2f1a		db	0c3h	; 11000011b . 058da c3
d2f1b		db	00ch	; 00001100b . 058db 0c
d2f1c		db	0c0h	; 11000000b . 058dc c0
d2f1d		db	0f0h	; 11110000b . 058dd f0
d2f1e		db	030h	; 00110000b 0 058de 30
d2f1f		db	030h	; 00110000b 0 058df 30
d2f20		db	0c0h	; 11000000b . 058e0 c0
d2f21		db	00ch	; 00001100b . 058e1 0c
d2f22		db	0c3h	; 11000011b . 058e2 c3
d2f23		db	00ch	; 00001100b . 058e3 0c
d2f24		db	03ch	; 00111100b < 058e4 3c
d2f25		db	0f0h	; 11110000b . 058e5 f0
d2f26		db	003h	; 00000011b . 058e6 03
d2f27		db	0fch	; 11111100b . 058e7 fc
d2f28		db	003h	; 00000011b . 058e8 03
d2f29		db	000h	; 00000000b . 058e9 00
d2f2a		db	003h	; 00000011b . 058ea 03
d2f2b		db	000h	; 00000000b . 058eb 00
d2f2c		db	0ffh	; 11111111b . 058ec ff
d2f2d		db	0fch	; 11111100b . 058ed fc
d2f2e		db	033h	; 00110011b 3 058ee 33
d2f2f		db	0fch	; 11111100b . 058ef fc
d2f30		db	0c3h	; 11000011b . 058f0 c3
d2f31		db	00ch	; 00001100b . 058f1 0c
d2f32		db	0c3h	; 11000011b . 058f2 c3
d2f33		db	00ch	; 00001100b . 058f3 0c
d2f34		db	03ch	; 00111100b < 058f4 3c
d2f35		db	00ch	; 00001100b . 058f5 0c
d2f36		db	03fh	; 00111111b ? 058f6 3f
d2f37		db	0f0h	; 11110000b . 058f7 f0
d2f38		db	0c3h	; 11000011b . 058f8 c3
d2f39		db	00ch	; 00001100b . 058f9 0c
d2f3a		db	0c3h	; 11000011b . 058fa c3
d2f3b		db	00ch	; 00001100b . 058fb 0c
d2f3c		db	03ch	; 00111100b < 058fc 3c
d2f3d		db	030h	; 00110000b 0 058fd 30
d2f3e		db	00eh	; 00001110b . 058fe 0e
d2f3f		db	001h	; 00000001b . 058ff 01
d2f40		db	000h	; 00000000b . 05900 00
d2f41		db	000h	; 00000000b . 05901 00
d2f42		db	000h	; 00000000b . 05902 00
d2f43		db	000h	; 00000000b . 05903 00
d2f44		db	000h	; 00000000b . 05904 00
d2f45		db	000h	; 00000000b . 05905 00
d2f46		db	000h	; 00000000b . 05906 00
d2f47		db	000h	; 00000000b . 05907 00
d2f48		db	000h	; 00000000b . 05908 00
d2f49		db	000h	; 00000000b . 05909 00
d2f4a		db	000h	; 00000000b . 0590a 00
d2f4b		db	000h	; 00000000b . 0590b 00
d2f4c		db	000h	; 00000000b . 0590c 00
d2f4d		db	000h	; 00000000b . 0590d 00
d2f4e		db	000h	; 00000000b . 0590e 00
d2f4f		db	000h	; 00000000b . 0590f 00
d2f50		db	000h	; 00000000b . 05910 00
d2f51		db	000h	; 00000000b . 05911 00
d2f52		db	000h	; 00000000b . 05912 00
d2f53		db	000h	; 00000000b . 05913 00
d2f54		db	000h	; 00000000b . 05914 00
d2f55		db	000h	; 00000000b . 05915 00
d2f56		db	000h	; 00000000b . 05916 00
d2f57		db	000h	; 00000000b . 05917 00
d2f58		db	000h	; 00000000b . 05918 00
d2f59		db	000h	; 00000000b . 05919 00
d2f5a		db	000h	; 00000000b . 0591a 00
d2f5b		db	000h	; 00000000b . 0591b 00
d2f5c		db	000h	; 00000000b . 0591c 00
d2f5d		db	000h	; 00000000b . 0591d 00
d2f5e		db	000h	; 00000000b . 0591e 00
d2f5f		db	000h	; 00000000b . 0591f 00
d2f60		db	000h	; 00000000b . 05920 00
d2f61		db	000h	; 00000000b . 05921 00
d2f62		db	000h	; 00000000b . 05922 00
d2f63		db	000h	; 00000000b . 05923 00
d2f64		db	000h	; 00000000b . 05924 00
d2f65		db	000h	; 00000000b . 05925 00
d2f66		db	000h	; 00000000b . 05926 00
d2f67		db	000h	; 00000000b . 05927 00
d2f68		db	000h	; 00000000b . 05928 00
d2f69		db	000h	; 00000000b . 05929 00
d2f6a		db	000h	; 00000000b . 0592a 00
d2f6b		db	000h	; 00000000b . 0592b 00
d2f6c		db	000h	; 00000000b . 0592c 00
d2f6d		db	000h	; 00000000b . 0592d 00
d2f6e		db	000h	; 00000000b . 0592e 00
d2f6f		db	000h	; 00000000b . 0592f 00
d2f70		db	000h	; 00000000b . 05930 00
d2f71		db	000h	; 00000000b . 05931 00
d2f72		db	000h	; 00000000b . 05932 00
d2f73		db	000h	; 00000000b . 05933 00
d2f74		db	000h	; 00000000b . 05934 00
d2f75		db	000h	; 00000000b . 05935 00
d2f76		db	000h	; 00000000b . 05936 00
d2f77		db	000h	; 00000000b . 05937 00
d2f78		db	000h	; 00000000b . 05938 00
d2f79		db	000h	; 00000000b . 05939 00
d2f7a		db	000h	; 00000000b . 0593a 00
d2f7b		db	000h	; 00000000b . 0593b 00
d2f7c		db	000h	; 00000000b . 0593c 00
d2f7d		db	000h	; 00000000b . 0593d 00
d2f7e		db	000h	; 00000000b . 0593e 00
d2f7f		db	000h	; 00000000b . 0593f 00
d2f80		db	000h	; 00000000b . 05940 00
d2f81		db	000h	; 00000000b . 05941 00
d2f82		db	000h	; 00000000b . 05942 00
d2f83		db	000h	; 00000000b . 05943 00
d2f84		db	000h	; 00000000b . 05944 00
d2f85		db	000h	; 00000000b . 05945 00
d2f86		db	000h	; 00000000b . 05946 00
d2f87		db	000h	; 00000000b . 05947 00
d2f88		db	000h	; 00000000b . 05948 00
d2f89		db	000h	; 00000000b . 05949 00
d2f8a		db	000h	; 00000000b . 0594a 00
d2f8b		db	000h	; 00000000b . 0594b 00
d2f8c		db	000h	; 00000000b . 0594c 00
d2f8d		db	000h	; 00000000b . 0594d 00
d2f8e		db	000h	; 00000000b . 0594e 00
d2f8f		db	001h	; 00000001b . 0594f 01
d2f90		db	000h	; 00000000b . 05950 00
d2f91		db	000h	; 00000000b . 05951 00
d2f92		db	000h	; 00000000b . 05952 00
d2f93		db	000h	; 00000000b . 05953 00
d2f94		db	000h	; 00000000b . 05954 00
d2f95		db	000h	; 00000000b . 05955 00
d2f96		db	000h	; 00000000b . 05956 00
d2f97		db	000h	; 00000000b . 05957 00
d2f98		db	09bh	; 10011011b . 05958 9b
d2f99		db	00fh	; 00001111b . 05959 0f
d2f9a		db	08ah	; 10001010b . 0595a 8a
d2f9b		db	00fh	; 00001111b . 0595b 0f
d2f9c		db	079h	; 01111001b y 0595c 79
d2f9d		db	00fh	; 00001111b . 0595d 0f
d2f9e		db	06ah	; 01101010b j 0595e 6a
d2f9f		db	00fh	; 00001111b . 0595f 0f
d2fa0		db	001h	; 00000001b . 05960 01
d2fa1		db	000h	; 00000000b . 05961 00
d2fa2		db	090h	; 10010000b . 05962 90
d2fa3		db	001h	; 00000001b . 05963 01
d2fa4		db	0b4h	; 10110100b . 05964 b4
d2fa5		db	001h	; 00000001b . 05965 01
d2fa6		db	0e0h	; 11100000b . 05966 e0
d2fa7		db	001h	; 00000001b . 05967 01
d2fa8		db	015h	; 00010101b . 05968 15
d2fa9		db	002h	; 00000010b . 05969 02
d2faa		db	058h	; 01011000b X 0596a 58
d2fab		db	002h	; 00000010b . 0596b 02
d2fac		db	015h	; 00010101b . 0596c 15
d2fad		db	002h	; 00000010b . 0596d 02
d2fae		db	0e0h	; 11100000b . 0596e e0
d2faf		db	001h	; 00000001b . 0596f 01
d2fb0		db	0b4h	; 10110100b . 05970 b4
d2fb1		db	001h	; 00000001b . 05971 01
d2fb2		db	090h	; 10010000b . 05972 90
d2fb3		db	001h	; 00000001b . 05973 01
d2fb4		db	088h	; 10001000b . 05974 88
d2fb5		db	013h	; 00010011b . 05975 13
d2fb6		db	002h	; 00000010b . 05976 02
d2fb7		db	000h	; 00000000b . 05977 00
d2fb8		db	070h	; 01110000b p 05978 70
d2fb9		db	017h	; 00010111b . 05979 17
d2fba		db	002h	; 00000010b . 0597a 02
d2fbb		db	000h	; 00000000b . 0597b 00
d2fbc		db	04ch	; 01001100b L 0597c 4c
d2fbd		db	01dh	; 00011101b . 0597d 1d
d2fbe		db	002h	; 00000010b . 0597e 02
d2fbf		db	000h	; 00000000b . 0597f 00
d2fc0		db	010h	; 00010000b . 05980 10
d2fc1		db	027h	; 00100111b ' 05981 27
d2fc2		db	002h	; 00000010b . 05982 02
d2fc3		db	000h	; 00000000b . 05983 00
d2fc4		db	0a3h	; 10100011b . 05984 a3
d2fc5		db	002h	; 00000010b . 05985 02
d2fc6		db	0e0h	; 11100000b . 05986 e0
d2fc7		db	002h	; 00000010b . 05987 02
d2fc8		db	023h	; 00100011b # 05988 23
d2fc9		db	003h	; 00000011b . 05989 03
d2fca		db	06bh	; 01101011b k 0598a 6b
d2fcb		db	003h	; 00000011b . 0598b 03
d2fcc		db	0bbh	; 10111011b . 0598c bb
d2fcd		db	003h	; 00000011b . 0598d 03
d2fce		db	011h	; 00010001b . 0598e 11
d2fcf		db	004h	; 00000100b . 0598f 04
d2fd0		db	06fh	; 01101111b o 05990 6f
d2fd1		db	004h	; 00000100b . 05991 04
d2fd2		db	0d6h	; 11010110b . 05992 d6
d2fd3		db	004h	; 00000100b . 05993 04
d2fd4		db	046h	; 01000110b F 05994 46
d2fd5		db	005h	; 00000101b . 05995 05
d2fd6		db	0c0h	; 11000000b . 05996 c0
d2fd7		db	005h	; 00000101b . 05997 05
d2fd8		db	045h	; 01000101b E 05998 45
d2fd9		db	006h	; 00000110b . 05999 06
d2fda		db	0d7h	; 11010111b . 0599a d7
d2fdb		db	006h	; 00000110b . 0599b 06
d2fdc		db	075h	; 01110101b u 0599c 75
d2fdd		db	007h	; 00000111b . 0599d 07
d2fde		db	022h	; 00100010b " 0599e 22
d2fdf		db	008h	; 00001000b . 0599f 08
d2fe0		db	0deh	; 11011110b . 059a0 de
d2fe1		db	008h	; 00001000b . 059a1 08
d2fe2		db	0ach	; 10101100b . 059a2 ac
d2fe3		db	009h	; 00001001b . 059a3 09
d2fe4		db	08ch	; 10001100b . 059a4 8c
d2fe5		db	00ah	; 00001010b . 059a5 0a
d2fe6		db	080h	; 10000000b . 059a6 80
d2fe7		db	00bh	; 00001011b . 059a7 0b
d2fe8		db	08bh	; 10001011b . 059a8 8b
d2fe9		db	00ch	; 00001100b . 059a9 0c
d2fea		db	0adh	; 10101101b . 059aa ad
d2feb		db	00dh	; 00001101b . 059ab 0d
d2fec		db	0eah	; 11101010b . 059ac ea
d2fed		db	00eh	; 00001110b . 059ad 0e
d2fee		db	044h	; 01000100b D 059ae 44
d2fef		db	010h	; 00010000b . 059af 10
d2ff0		db	0bdh	; 10111101b . 059b0 bd
d2ff1		db	011h	; 00010001b . 059b1 11
d2ff2		db	058h	; 01011000b X 059b2 58
d2ff3		db	013h	; 00010011b . 059b3 13
d2ff4		db	018h	; 00011000b . 059b4 18
d2ff5		db	015h	; 00010101b . 059b5 15
d2ff6		db	0eah	; 11101010b . 059b6 ea
d2ff7		db	006h	; 00000110b . 059b7 06
d2ff8		db	0d4h	; 11010100b . 059b8 d4
d2ff9		db	00dh	; 00001101b . 059b9 0d
d2ffa		db	01eh	; 00011110b . 059ba 1e
d2ffb		db	006h	; 00000110b . 059bb 06
d2ffc		db	03dh	; 00111101b = 059bc 3d
d2ffd		db	00ch	; 00001100b . 059bd 0c
d2ffe		db	06ah	; 01101010b j 059be 6a
d2fff		db	005h	; 00000101b . 059bf 05
d3000		db	0d4h	; 11010100b . 059c0 d4
d3001		db	00ah	; 00001010b . 059c1 0a
d3002		db	0cbh	; 11001011b . 059c2 cb
d3003		db	004h	; 00000100b . 059c3 04
d3004		db	095h	; 10010101b . 059c4 95
d3005		db	009h	; 00001001b . 059c5 09
d3006		db	03eh	; 00111110b > 059c6 3e
d3007		db	004h	; 00000100b . 059c7 04
d3008		db	07bh	; 01111011b { 059c8 7b
d3009		db	008h	; 00001000b . 059c9 08
d300a		db	0c1h	; 11000001b . 059ca c1
d300b		db	003h	; 00000011b . 059cb 03
d300c		db	081h	; 10000001b . 059cc 81
d300d		db	007h	; 00000111b . 059cd 07
d300e		db	052h	; 01010010b R 059ce 52
d300f		db	003h	; 00000011b . 059cf 03
d3010		db	0a4h	; 10100100b . 059d0 a4
d3011		db	006h	; 00000110b . 059d1 06
d3012		db	0f0h	; 11110000b . 059d2 f0
d3013		db	002h	; 00000010b . 059d3 02
d3014		db	0e1h	; 11100001b . 059d4 e1
d3015		db	005h	; 00000101b . 059d5 05
d3016		db	09ah	; 10011010b . 059d6 9a
d3017		db	002h	; 00000010b . 059d7 02
d3018		db	034h	; 00110100b 4 059d8 34
d3019		db	005h	; 00000101b . 059d9 05
d301a		db	04dh	; 01001101b M 059da 4d
d301b		db	002h	; 00000010b . 059db 02
d301c		db	09ah	; 10011010b . 059dc 9a
d301d		db	004h	; 00000100b . 059dd 04
d301e		db	009h	; 00001001b . 059de 09
d301f		db	002h	; 00000010b . 059df 02
d3020		db	013h	; 00010011b . 059e0 13
d3021		db	004h	; 00000100b . 059e1 04
d3022		db	0cdh	; 11001101b . 059e2 cd
d3023		db	001h	; 00000001b . 059e3 01
d3024		db	09bh	; 10011011b . 059e4 9b
d3025		db	003h	; 00000011b . 059e5 03
d3026		db	000h	; 00000000b . 059e6 00
d3027		db	000h	; 00000000b . 059e7 00
d3028		db	000h	; 00000000b . 059e8 00
d3029		db	000h	; 00000000b . 059e9 00
d302a		db	000h	; 00000000b . 059ea 00
d302b		db	000h	; 00000000b . 059eb 00
d302c		db	000h	; 00000000b . 059ec 00
d302d		db	000h	; 00000000b . 059ed 00
d302e		db	000h	; 00000000b . 059ee 00
d302f		db	000h	; 00000000b . 059ef 00
_TRK4_data	ends

_TRK4_STACK	segment	para stack 'STACK'

l59f0		db	4 dup ('stak')
		;db	03ch dup ('stak')
l5af0		label	word	; Top of stack.
_TRK4_STACK	ends

		; 05AF0

		; Tracks 5 through 13 (avoid >64K warning).
_TRKS_5_13	segment	para public 'ZZZ'

		; Rest of disk is F6 (division sign)
		; 9 sectors
l5a00		db	((13-5+1)*9*512) dup (0f6h)

_TRKS_5_13	ends

		; 0FC00

		; Tracks 14 through 27.
_TRKS14_27	segment	para public 'ZZZ'

		; 14 sectors
lfc00		db	((27-14+1)*9*512) dup (0f6h)

_TRKS14_27	ends

		; 1F800

		; Tracks 14 through 27.
_TRKS28_39	segment	para public 'ZZZ'

		; Rest of disk is F6 (division sign)
		; 12 sectors
l1f800		db	((39-28+1)*9*512) dup (0f6h)

_TRKS28_39	ends

		;end	_bootstrap
