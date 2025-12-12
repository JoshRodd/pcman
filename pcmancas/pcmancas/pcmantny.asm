data_logo	equ	0
data_		equ	4e6h
negged_flag	equ	2fa0h
flag_2		equ	2f8fh
data_2		equ	5f8h

		nop
		nop
		nop
		call	chk_equip

		; Load ES with the CGA's framebuffer address
		mov	ax,0b800h
		mov	es,ax

		; Turn the speaker on
		mov	al,4fh
		out	61h,al
		mov	al,0b6h
		out	43h,al

		; Set mode 320x200, 4 colours
		mov	ax,4
		int	10h

		; Change the palette to bright and cyan/magenta/white
		mov	dx,3d9h
		mov	al,10h
		out	dx,al

		; Delay 3 ticks
		mov	dl,3
		call	delay

		; Draw the logo
		mov	di,150h		; Start at 32,4
		mov	si,0		; Logo starts at top of data
		mov	bx,-12		; Prepare to backtrack
blit_next_char:	mov	cx,17h		; Copy 17 rows
		mov	dx,1ff7h	; Distance to odd rows (2000h - 9)
		mov	bp,0e047h	; Distance back to even (-1fb9h)
		cld
blit_loop:	movsw			; Copy 9 bytes (36 pixels)
		movsw
		movsw
		movsw
		movsb
      db 3,0fah;add	di,dx		; Advance to next row
		xchg	dx,bp
		loop	blit_loop

		sub	di,2370h	; Position of next character
		add	di,[bx+4e6h]	; Initially 4dah
		add	bx,2		; Move 8 pixels over
		jnz	blit_next_char	; Draw next character

;l004E: db 0xBE,0xE6,0x04                     ; mov si,0x4e6                        
;l0051: db 0xBD,0x12,0x01                     ; mov bp,0x112                        
;l0054: db 0xB4,0x00                          ; mov ah,0x0                          
;l0056: db 0xCD,0x1A                          ; int byte 0x1a                       
;l0058: db 0x8B,0xDA                          ; mov bx,dx                           
;l005A: db 0xB4,0x00                          ; mov ah,0x0                          
;l005C: db 0xCD,0x1A                          ; int byte 0x1a                       
;l005E: db 0x3B,0xDA                          ; cmp bx,dx                           
;l0060: db 0x74,0xF8                          ; jz 0x5a                             
;l0062: db 0xB4,0x01                          ; mov ah,0x1                          
;l0064: db 0xCD,0x16                          ; int byte 0x16                       
;l0066: db 0x74,0x0C                          ; jz 0x74                             
;l0068: db 0xE8,0x45,0x0F                     ; call 0xfb0                          
;l006B: db 0x90                               ; nop                                 
;l006C: db 0x3C,0x13                          ; cmp al,0x13                         
;l006E: db 0x75,0x04                          ; jnz 0x74                            
;l0070: db 0xF6,0x1E,0xA0,0x2F                ; neg byte [0x2fa0]                   
;l0074: db 0xAD                               ; lodsw                               
;l0075: db 0x80,0x3E,0xA0,0x2F,0x00           ; cmp byte [0x2fa0],0x0               
;l007A: db 0x7F,0x06                          ; jg 0x82                             
;l007C: db 0xE8,0xD1,0x0E                     ; call 0xf50                          
;l007F: db 0xEB,0x07                          ; jmp 0x88                            
;l0081: db 0x90                               ; nop                                 
;l0082: db 0xE6,0x42                          ; out byte 0x42,al                    
;l0084: db 0x8A,0xC4                          ; mov al,ah                           
;l0086: db 0xE6,0x42                          ; out byte 0x42,al                    
;l0088: db 0x83,0xED,0x02                     ; sub bp,0x2                          
;l008B: db 0x75,0xC7                          ; jnz 0x54                            
;l008D: db 0xB2,0x03                          ; mov dl,0x3                          
;l008F: db 0xE8,0x7F,0x00                     ; call 0x111                          
;l0092: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
;l0095: db 0xBE,0xF8,0x05                     ; mov si,0x5f8                        
;l0098: db 0xFC                               ; cld                                 
;l0099: db 0xAD                               ; lodsw                               
;l009A: db 0x8B,0xD0                          ; mov dx,ax                           
;l009C: db 0xB7,0x00                          ; mov bh,0x0                          
;l009E: db 0xB4,0x02                          ; mov ah,0x2                          
;l00A0: db 0xCD,0x10                          ; int byte 0x10                       
;l00A2: db 0xAC                               ; lodsb                               
;l00A3: db 0x3C,0x00                          ; cmp al,0x0                          
;l00A5: db 0x74,0x09                          ; jz 0xb0                             
;l00A7: db 0xBB,0x02,0x00                     ; mov bx,0x2                          
;l00AA: db 0xB4,0x0E                          ; mov ah,0xe                          
;l00AC: db 0xCD,0x10                          ; int byte 0x10                       
;l00AE: db 0xEB,0xF2                          ; jmp 0xa2                            
;l00B0: db 0xE2,0xE6                          ; loop 0x98                           
;l00B2: db 0xC6,0x06,0x8F,0x2F,0x01           ; mov byte [0x2f8f],0x1               
;l00B7: db 0xE8,0xF6,0x0E                     ; call 0xfb0                          
;l00BA: db 0x80,0xFC,0x24                     ; cmp ah,0x24                         
;l00BD: db 0x74,0x1F                          ; jz 0xde                             
;l00BF: db 0x90                               ; nop                                 
;l00C0: db 0x90                               ; nop                                 
;l00C1: db 0xC6,0x06,0x8F,0x2F,0x00           ; mov byte [0x2f8f],0x0               
;l00C6: db 0x90                               ; nop                                 
;l00C7: db 0x90                               ; nop                                 
;l00C8: db 0x90                               ; nop                                 
;l00C9: db 0x90                               ; nop                                 
;l00CA: db 0x90                               ; nop                                 
;l00CB: db 0x90                               ; nop                                 
;l00CC: db 0x90                               ; nop                                 
;l00CD: db 0x90                               ; nop                                 
;l00CE: db 0x90                               ; nop                                 
;l00CF: db 0x90                               ; nop                                 

		mov	si,data_
		mov	bp,112h
next_music:	mov	ah,0
		int	1ah
    db 8bh,0dah;mov	bx,dx
timer_loop:	mov	ah,0
		int	1ah
    db 3bh,0dah;cmp	bx,dx
		jz	timer_loop
		; Check if a key has been pressed
		mov	ah,1
		int	16h
		jz	music_loop
		; Check if it was the Esc key
		call	chk_esc_key
		nop
		; Check if it was the Enter key
		cmp	al,13h
		jnz	music_loop
		neg	byte [negged_flag]	; Unclear what this does
music_loop:	lodsw

		cmp	byte [negged_flag],0
		jg	l0082
		call	l0F50
		jmp	l0088
		nop
l0082:		out	42h,al
    db 8ah,0c4h;mov	al,ah
		out	42h,al
l0088:		sub	bp,2
		jnz	next_music

		mov	dl,3
		call	delay
		mov	cx,5
		mov	si,data_2
l0098:		cld
		lodsw
    db 8bh,0d0h;mov	dx,ax
		mov	bh,0
		mov	ah,2
		int	10h
l00A2:		lodsb
		cmp	al,0
		jz	l00B0

		mov	bx,2
		mov	ah,0eh
		int	10h
		jmp	l00A2
l00B0:		loop	l0098

		mov	byte [flag_2],1
		call	chk_esc_key
		cmp	ah,24h
		jz	l00DE

		nop
		nop
		mov	byte [flag_2],0
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
l00D0: db 0x3C,0x20                          ; cmp al,0x20                         
l00D2: db 0x74,0x0A                          ; jz 0xde                             
l00D4: db 0x3C,0x13                          ; cmp al,0x13                         
l00D6: db 0x75,0xDA                          ; jnz 0xb2                            
l00D8: db 0xF6,0x1E,0xA0,0x2F                ; neg byte [0x2fa0]                   
l00DC: db 0xEB,0xD4                          ; jmp 0xb2                            
l00DE: db 0xC7,0x06,0x24,0x2D,0x00,0x00      ; mov word [0x2d24],0x0               
l00E4: db 0xC6,0x06,0xF0,0x06,0x03           ; mov byte [0x6f0],0x3                
l00E9: db 0xC7,0x06,0xF1,0x06,0x00,0x00      ; mov word [0x6f1],0x0                
l00EF: db 0x06                               ; push es                             
l00F0: db 0x1E                               ; push ds                             
l00F1: db 0x07                               ; pop es                              
l00F2: db 0xBF,0x7E,0x2F                     ; mov di,0x2f7e                       
l00F5: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l00F8: db 0xFC                               ; cld                                 
l00F9: db 0xB0,0x00                          ; mov al,0x0                          
l00FB: db 0xF3,0xAA                          ; rep stosb                           
l00FD: db 0x07                               ; pop es                              
l00FE: db 0xE8,0x1D,0x00                     ; call 0x11e                          
l0101: db 0xB0,0x02                          ; mov al,0x2                          
l0103: db 0xE6,0x42                          ; out byte 0x42,al                    
l0105: db 0x32,0xC0                          ; xor al,al                           
l0107: db 0xE6,0x42                          ; out byte 0x42,al                    
l0109: db 0xBE,0x78,0x06                     ; mov si,0x678                        
l010C: db 0xB9,0x02,0x00                     ; mov cx,0x2                          
l010F: db 0xEB,0x87                          ; jmp 0x98                            

; Sleeps. Specify the number of seconds in DL.
delay:
		mov	cx,0
delay_l:	loop	delay_l
		mov	cx,0
		dec	dl
		jnz	delay_l
		ret

;l0111: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
;l0114: db 0xE2,0xFE                          ; loop 0x114                          
;l0116: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
;l0119: db 0xFE,0xCA                          ; dec dl                              
;l011B: db 0x75,0xF7                          ; jnz 0x114                           
;l011D: db 0xC3                               ; ret                                 
l011E: db 0xB8,0x04,0x00                     ; mov ax,0x4                          
l0121: db 0xCD,0x10                          ; int byte 0x10                       
l0123: db 0xB4,0x0B                          ; mov ah,0xb                          
l0125: db 0xBB,0x00,0x01                     ; mov bx,0x100                        
l0128: db 0xCD,0x10                          ; int byte 0x10                       
l012A: db 0xB4,0x0B                          ; mov ah,0xb                          
l012C: db 0xBB,0x10,0x00                     ; mov bx,0x10                         
l012F: db 0xCD,0x10                          ; int byte 0x10                       
l0131: db 0xB6,0x32                          ; mov dh,0x32                         
l0133: db 0xBF,0x0D,0x00                     ; mov di,0xd                          
l0136: db 0xBB,0x09,0x0A                     ; mov bx,0xa09                        
l0139: db 0xB2,0x3E                          ; mov dl,0x3e                         
l013B: db 0x8A,0x07                          ; mov al,[bx]                         
l013D: db 0x43                               ; inc bx                              
l013E: db 0x3C,0x00                          ; cmp al,0x0                          
l0140: db 0x74,0x21                          ; jz 0x163                            
l0142: db 0xB4,0x00                          ; mov ah,0x0                          
l0144: db 0x8B,0xF0                          ; mov si,ax                           
l0146: db 0xD1,0xE6                          ; shl si,0x0                          
l0148: db 0xD1,0xE6                          ; shl si,0x0                          
l014A: db 0x81,0xC6,0x91,0x09                ; add si,0x991                        
l014E: db 0xBD,0xFF,0x1F                     ; mov bp,0x1fff                       
l0151: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0154: db 0xFC                               ; cld                                 
l0155: db 0xA4                               ; movsb                               
l0156: db 0x03,0xFD                          ; add di,bp                           
l0158: db 0xF7,0xDD                          ; neg bp                              
l015A: db 0x83,0xC5,0x4E                     ; add bp,0x4e                         
l015D: db 0xE2,0xF6                          ; loop 0x155                          
l015F: db 0x81,0xEF,0xA0,0x00                ; sub di,0xa0                         
l0163: db 0x47                               ; inc di                              
l0164: db 0xFE,0xCA                          ; dec dl                              
l0166: db 0x75,0xD3                          ; jnz 0x13b                           
l0168: db 0x83,0xC7,0x62                     ; add di,0x62                         
l016B: db 0xFE,0xCE                          ; dec dh                              
l016D: db 0x75,0xCA                          ; jnz 0x139                           
l016F: db 0x06                               ; push es                             
l0170: db 0x1E                               ; push ds                             
l0171: db 0x07                               ; pop es                              
l0172: db 0xC6,0x06,0x99,0x2C,0xE6           ; mov byte [0x2c99],0xe6              
l0177: db 0xBE,0xEA,0x19                     ; mov si,0x19ea                       
l017A: db 0xBF,0x73,0x16                     ; mov di,0x1673                       
l017D: db 0xB9,0x77,0x03                     ; mov cx,0x377                        
l0180: db 0xFC                               ; cld                                 
l0181: db 0xF3,0xA4                          ; rep movsb                           
l0183: db 0x07                               ; pop es                              
l0184: db 0xB6,0x18                          ; mov dh,0x18                         
l0186: db 0xBF,0xAF,0x00                     ; mov di,0xaf                         
l0189: db 0xBB,0x92,0x16                     ; mov bx,0x1692                       
l018C: db 0xB2,0x1D                          ; mov dl,0x1d                         
l018E: db 0x8A,0x07                          ; mov al,[bx]                         
l0190: db 0x43                               ; inc bx                              
l0191: db 0x3C,0x02                          ; cmp al,0x2                          
l0193: db 0x72,0x25                          ; jc 0x1ba                            
l0195: db 0xB4,0x00                          ; mov ah,0x0                          
l0197: db 0x8B,0xF0                          ; mov si,ax                           
l0199: db 0xD1,0xE6                          ; shl si,0x0                          
l019B: db 0xD1,0xE6                          ; shl si,0x0                          
l019D: db 0xD1,0xE6                          ; shl si,0x0                          
l019F: db 0xD1,0xE6                          ; shl si,0x0                          
l01A1: db 0x81,0xC6,0x15,0x16                ; add si,0x1615                       
l01A5: db 0xBD,0xFE,0x1F                     ; mov bp,0x1ffe                       
l01A8: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l01AB: db 0xFC                               ; cld                                 
l01AC: db 0xA5                               ; movsw                               
l01AD: db 0x03,0xFD                          ; add di,bp                           
l01AF: db 0xF7,0xDD                          ; neg bp                              
l01B1: db 0x83,0xC5,0x4C                     ; add bp,0x4c                         
l01B4: db 0xE2,0xF6                          ; loop 0x1ac                          
l01B6: db 0x81,0xEF,0x40,0x01                ; sub di,0x140                        
l01BA: db 0x83,0xC7,0x02                     ; add di,0x2                          
l01BD: db 0xFE,0xCA                          ; dec dl                              
l01BF: db 0x75,0xCD                          ; jnz 0x18e                           
l01C1: db 0x43                               ; inc bx                              
l01C2: db 0x81,0xC7,0x06,0x01                ; add di,0x106                        
l01C6: db 0xFE,0xCE                          ; dec dh                              
l01C8: db 0x75,0xC2                          ; jnz 0x18c                           
l01CA: db 0xB4,0x02                          ; mov ah,0x2                          
l01CC: db 0xBA,0x01,0x01                     ; mov dx,0x101                        
l01CF: db 0xB7,0x00                          ; mov bh,0x0                          
l01D1: db 0xCD,0x10                          ; int byte 0x10                       
l01D3: db 0xBE,0xC3,0x06                     ; mov si,0x6c3                        
l01D6: db 0xB9,0x27,0x00                     ; mov cx,0x27                         
l01D9: db 0xFC                               ; cld                                 
l01DA: db 0xAC                               ; lodsb                               
l01DB: db 0xBB,0x03,0x00                     ; mov bx,0x3                          
l01DE: db 0xB4,0x0E                          ; mov ah,0xe                          
l01E0: db 0xCD,0x10                          ; int byte 0x10                       
l01E2: db 0xE2,0xF6                          ; loop 0x1da                          
l01E4: db 0x06                               ; push es                             
l01E5: db 0x1E                               ; push ds                             
l01E6: db 0x07                               ; pop es                              
l01E7: db 0xBF,0x88,0x2F                     ; mov di,0x2f88                       
l01EA: db 0xBE,0x83,0x2F                     ; mov si,0x2f83                       
l01ED: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l01F0: db 0xF3,0xA4                          ; rep movsb                           
l01F2: db 0x07                               ; pop es                              
l01F3: db 0xBF,0x00,0x0A                     ; mov di,0xa00                        
l01F6: db 0xE8,0xBB,0x0C                     ; call 0xeb4                          
l01F9: db 0xE8,0x6C,0x0C                     ; call 0xe68                          
l01FC: db 0xA1,0xF1,0x06                     ; mov ax,[0x6f1]                      
l01FF: db 0x40                               ; inc ax                              
l0200: db 0x3D,0x0C,0x00                     ; cmp ax,0xc                          
l0203: db 0x7E,0x03                          ; jng 0x208                           
l0205: db 0xB8,0x0C,0x00                     ; mov ax,0xc                          
l0208: db 0xA3,0xF1,0x06                     ; mov [0x6f1],ax                      
l020B: db 0x8B,0xF0                          ; mov si,ax                           
l020D: db 0xD1,0xE6                          ; shl si,0x0                          
l020F: db 0xD1,0xE6                          ; shl si,0x0                          
l0211: db 0x8D,0xB4,0xEF,0x06                ; lea si,[si+0x6ef]                   
l0215: db 0xFC                               ; cld                                 
l0216: db 0xAC                               ; lodsb                               
l0217: db 0xA2,0x9A,0x2C                     ; mov [0x2c9a],al                     
l021A: db 0xAC                               ; lodsb                               
l021B: db 0xA2,0x26,0x2D                     ; mov [0x2d26],al                     
l021E: db 0xAD                               ; lodsw                               
l021F: db 0xA3,0x27,0x2D                     ; mov [0x2d27],ax                     
l0222: db 0x8B,0x1E,0xF1,0x06                ; mov bx,[0x6f1]                      
l0226: db 0x83,0xFB,0x08                     ; cmp bx,0x8                          
l0229: db 0x7E,0x03                          ; jng 0x22e                           
l022B: db 0xBB,0x08,0x00                     ; mov bx,0x8                          
l022E: db 0xBF,0x19,0x1D                     ; mov di,0x1d19                       
l0231: db 0xBE,0x2E,0x2D                     ; mov si,0x2d2e                       
l0234: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l0237: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l023A: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l023D: db 0x83,0xC6,0x03                     ; add si,0x3                          
l0240: db 0xFC                               ; cld                                 
l0241: db 0xA5                               ; movsw                               
l0242: db 0xA5                               ; movsw                               
l0243: db 0x03,0xFA                          ; add di,dx                           
l0245: db 0x87,0xD5                          ; xchg dx,bp                          
l0247: db 0xE2,0xF8                          ; loop 0x241                          
l0249: db 0x81,0xEF,0xB0,0x04                ; sub di,0x4b0                        
l024D: db 0x4B                               ; dec bx                              
l024E: db 0x75,0xEA                          ; jnz 0x23a                           
l0250: db 0x8A,0x1E,0xF0,0x06                ; mov bl,[0x6f0]                      
l0254: db 0xB7,0x00                          ; mov bh,0x0                          
l0256: db 0x4B                               ; dec bx                              
l0257: db 0x74,0x36                          ; jz 0x28f                            
l0259: db 0x8B,0xFB                          ; mov di,bx                           
l025B: db 0xD1,0xE7                          ; shl di,0x0                          
l025D: db 0xD1,0xE7                          ; shl di,0x0                          
l025F: db 0x03,0xFB                          ; add di,bx                           
l0261: db 0xD1,0xE7                          ; shl di,0x0                          
l0263: db 0xD1,0xE7                          ; shl di,0x0                          
l0265: db 0xD1,0xE7                          ; shl di,0x0                          
l0267: db 0xD1,0xE7                          ; shl di,0x0                          
l0269: db 0xD1,0xE7                          ; shl di,0x0                          
l026B: db 0xD1,0xE7                          ; shl di,0x0                          
l026D: db 0xD1,0xE7                          ; shl di,0x0                          
l026F: db 0xF7,0xDF                          ; neg di                              
l0271: db 0x81,0xC7,0x3B,0x1F                ; add di,0x1f3b                       
l0275: db 0xBE,0x59,0x1F                     ; mov si,0x1f59                       
l0278: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l027B: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l027E: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l0281: db 0xA5                               ; movsw                               
l0282: db 0xA5                               ; movsw                               
l0283: db 0x03,0xFA                          ; add di,dx                           
l0285: db 0x87,0xD5                          ; xchg dx,bp                          
l0287: db 0xE2,0xF8                          ; loop 0x281                          
l0289: db 0x83,0xC7,0x50                     ; add di,0x50                         
l028C: db 0x4B                               ; dec bx                              
l028D: db 0x75,0xE6                          ; jnz 0x275                           
l028F: db 0x06                               ; push es                             
l0290: db 0x1E                               ; push ds                             
l0291: db 0x07                               ; pop es                              
l0292: db 0xFC                               ; cld                                 
l0293: db 0xBF,0x90,0x2F                     ; mov di,0x2f90                       
l0296: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0299: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l029C: db 0xF3,0xAB                          ; rep stosw                           
l029E: db 0xC7,0x06,0x9B,0x2C,0x00,0x00      ; mov word [0x2c9b],0x0               
l02A4: db 0xC6,0x06,0xC9,0x2C,0x00           ; mov byte [0x2cc9],0x0               
l02A9: db 0xC6,0x06,0xBC,0x2C,0x00           ; mov byte [0x2cbc],0x0               
l02AE: db 0x8D,0x36,0x25,0x07                ; lea si,[0x725]                      
l02B2: db 0x8D,0x3E,0x2D,0x2A                ; lea di,[0x2a2d]                     
l02B6: db 0xB9,0x6C,0x02                     ; mov cx,0x26c                        
l02B9: db 0xF3,0xA4                          ; rep movsb                           
l02BB: db 0x07                               ; pop es                              
l02BC: db 0xE8,0x0A,0x06                     ; call 0x8c9                          
l02BF: db 0xBB,0xF0,0x01                     ; mov bx,0x1f0                        
l02C2: db 0xFC                               ; cld                                 
l02C3: db 0x8D,0xB7,0x39,0x2A                ; lea si,[bx+0x2a39]                  
l02C7: db 0x8B,0xBF,0x2E,0x2A                ; mov di,[bx+0x2a2e]                  
l02CB: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l02CE: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l02D1: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l02D4: db 0xA5                               ; movsw                               
l02D5: db 0xA5                               ; movsw                               
l02D6: db 0x03,0xFA                          ; add di,dx                           
l02D8: db 0x87,0xD5                          ; xchg dx,bp                          
l02DA: db 0xE2,0xF8                          ; loop 0x2d4                          
l02DC: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l02DF: db 0x75,0xE2                          ; jnz 0x2c3                           
l02E1: db 0xBE,0x09,0x1E                     ; mov si,0x1e09                       
l02E4: db 0x8B,0x3E,0x2E,0x2A                ; mov di,[0x2a2e]                     
l02E8: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l02EB: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l02EE: db 0xFC                               ; cld                                 
l02EF: db 0xA5                               ; movsw                               
l02F0: db 0xA5                               ; movsw                               
l02F1: db 0x03,0xFA                          ; add di,dx                           
l02F3: db 0xF7,0xDA                          ; neg dx                              
l02F5: db 0x83,0xC2,0x48                     ; add dx,0x48                         
l02F8: db 0xE2,0xF5                          ; loop 0x2ef                          
l02FA: db 0xBA,0x00,0x00                     ; mov dx,0x0                          
l02FD: db 0xB4,0x02                          ; mov ah,0x2                          
l02FF: db 0xB7,0x00                          ; mov bh,0x0                          
l0301: db 0xCD,0x10                          ; int byte 0x10                       
l0303: db 0xBF,0x07,0x0C                     ; mov di,0xc07                        
l0306: db 0xBD,0x06,0x00                     ; mov bp,0x6                          
l0309: db 0x3E,0x8A,0x86,0xE9,0x06           ; mov al,[ds:bp+0x6e9]                
l030E: db 0xB9,0x01,0x00                     ; mov cx,0x1                          
l0311: db 0xBB,0x02,0x00                     ; mov bx,0x2                          
l0314: db 0xB4,0x09                          ; mov ah,0x9                          
l0316: db 0xCD,0x10                          ; int byte 0x10                       
l0318: db 0x1E                               ; push ds                             
l0319: db 0x06                               ; push es                             
l031A: db 0x1F                               ; pop ds                              
l031B: db 0xBE,0x00,0x00                     ; mov si,0x0                          
l031E: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l0321: db 0xBB,0x4E,0xE0                     ; mov bx,0xe04e                       
l0324: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0327: db 0xA5                               ; movsw                               
l0328: db 0x03,0xFA                          ; add di,dx                           
l032A: db 0x03,0xF2                          ; add si,dx                           
l032C: db 0x87,0xD3                          ; xchg dx,bx                          
l032E: db 0xE2,0xF7                          ; loop 0x327                          
l0330: db 0x1F                               ; pop ds                              
l0331: db 0x4D                               ; dec bp                              
l0332: db 0x75,0xD5                          ; jnz 0x309                           
l0334: db 0xBF,0x00,0x00                     ; mov di,0x0                          
l0337: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l033A: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l033D: db 0xBD,0x4E,0xE0                     ; mov bp,0xe04e                       
l0340: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0343: db 0xAB                               ; stosw                               
l0344: db 0x03,0xFA                          ; add di,dx                           
l0346: db 0x87,0xD5                          ; xchg dx,bp                          
l0348: db 0xE2,0xF9                          ; loop 0x343                          
l034A: db 0xB6,0x05                          ; mov dh,0x5                          
l034C: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l034F: db 0xE2,0xFE                          ; loop 0x34f                          
l0351: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l0354: db 0xFE,0xCE                          ; dec dh                              
l0356: db 0x75,0xF7                          ; jnz 0x34f                           
l0358: db 0xBF,0x07,0x0C                     ; mov di,0xc07                        
l035B: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l035E: db 0xB9,0x30,0x00                     ; mov cx,0x30                         
l0361: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l0364: db 0xBD,0x4E,0xE0                     ; mov bp,0xe04e                       
l0367: db 0xAB                               ; stosw                               
l0368: db 0x03,0xFA                          ; add di,dx                           
l036A: db 0x87,0xD5                          ; xchg dx,bp                          
l036C: db 0xE2,0xF9                          ; loop 0x367                          
l036E: db 0xE8,0x5A,0x01                     ; call 0x4cb                          
l0371: db 0xB0,0x02                          ; mov al,0x2                          
l0373: db 0xE6,0x42                          ; out byte 0x42,al                    
l0375: db 0x32,0xC0                          ; xor al,al                           
l0377: db 0xE6,0x42                          ; out byte 0x42,al                    
l0379: db 0xE8,0xEC,0x0A                     ; call 0xe68                          
l037C: db 0x80,0x3E,0x99,0x2C,0x00           ; cmp byte [0x2c99],0x0               
l0381: db 0x75,0x19                          ; jnz 0x39c                           
l0383: db 0x8B,0x3E,0x2E,0x2A                ; mov di,[0x2a2e]                     
l0387: db 0xBE,0xD1,0x1D                     ; mov si,0x1dd1                       
l038A: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l038D: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l0390: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l0393: db 0xFC                               ; cld                                 
l0394: db 0xA5                               ; movsw                               
l0395: db 0xA5                               ; movsw                               
l0396: db 0x03,0xFA                          ; add di,dx                           
l0398: db 0x87,0xD5                          ; xchg dx,bp                          
l039A: db 0xE2,0xF8                          ; loop 0x394                          
l039C: db 0xB2,0x02                          ; mov dl,0x2                          
l039E: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l03A1: db 0xE2,0xFE                          ; loop 0x3a1                          
l03A3: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l03A6: db 0xFE,0xCA                          ; dec dl                              
l03A8: db 0x75,0xF7                          ; jnz 0x3a1                           
l03AA: db 0xBB,0x6C,0x02                     ; mov bx,0x26c                        
l03AD: db 0x8B,0xBF,0x2E,0x2A                ; mov di,[bx+0x2a2e]                  
l03B1: db 0xBE,0x71,0x2A                     ; mov si,0x2a71                       
l03B4: db 0x03,0xF3                          ; add si,bx                           
l03B6: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l03B9: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l03BC: db 0x8A,0x8F,0x35,0x2A                ; mov cl,[bx+0x2a35]                  
l03C0: db 0xB5,0x00                          ; mov ch,0x0                          
l03C2: db 0xE3,0x09                          ; jcxz 0x3cd                          
l03C4: db 0xFC                               ; cld                                 
l03C5: db 0xA5                               ; movsw                               
l03C6: db 0xA5                               ; movsw                               
l03C7: db 0x03,0xFA                          ; add di,dx                           
l03C9: db 0x87,0xD5                          ; xchg dx,bp                          
l03CB: db 0xE2,0xF8                          ; loop 0x3c5                          
l03CD: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l03D0: db 0x75,0xDB                          ; jnz 0x3ad                           
l03D2: db 0x80,0x3E,0x99,0x2C,0x00           ; cmp byte [0x2c99],0x0               
l03D7: db 0x74,0x03                          ; jz 0x3dc                            
l03D9: db 0xEB,0x22                          ; jmp 0x3fd                           
l03DB: db 0x90                               ; nop                                 
l03DC: db 0xB7,0x07                          ; mov bh,0x7                          
l03DE: db 0xBA,0xD9,0x03                     ; mov dx,0x3d9                        
l03E1: db 0xB0,0x20                          ; mov al,0x20                         
l03E3: db 0xB4,0x10                          ; mov ah,0x10                         
l03E5: db 0xB3,0x02                          ; mov bl,0x2                          
l03E7: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l03EA: db 0xE2,0xFE                          ; loop 0x3ea                          
l03EC: db 0xB9,0x00,0x80                     ; mov cx,0x8000                       
l03EF: db 0xFE,0xCB                          ; dec bl                              
l03F1: db 0x75,0xF7                          ; jnz 0x3ea                           
l03F3: db 0xEE                               ; out dx,al                           
l03F4: db 0x86,0xC4                          ; xchg al,ah                          
l03F6: db 0xFE,0xCF                          ; dec bh                              
l03F8: db 0x75,0xEB                          ; jnz 0x3e5                           
l03FA: db 0xE9,0x21,0xFD                     ; jmp 0x11e                           
l03FD: db 0x8B,0x2E,0x2E,0x2A                ; mov bp,[0x2a2e]                     
l0401: db 0xBE,0x75,0x26                     ; mov si,0x2675                       
l0404: db 0xB8,0xD0,0x2C                     ; mov ax,0x2cd0                       
l0407: db 0xA3,0x23,0x07                     ; mov [0x723],ax                      
l040A: db 0xBF,0x02,0x00                     ; mov di,0x2                          
l040D: db 0x56                               ; push si                             
l040E: db 0x8B,0x36,0x23,0x07                ; mov si,[0x723]                      
l0412: db 0xB4,0x00                          ; mov ah,0x0                          
l0414: db 0xCD,0x1A                          ; int byte 0x1a                       
l0416: db 0x8B,0xDA                          ; mov bx,dx                           
l0418: db 0xB4,0x00                          ; mov ah,0x0                          
l041A: db 0xCD,0x1A                          ; int byte 0x1a                       
l041C: db 0x3B,0xD3                          ; cmp dx,bx                           
l041E: db 0x74,0xF8                          ; jz 0x418                            
l0420: db 0xAD                               ; lodsw                               
l0421: db 0x80,0x3E,0xA0,0x2F,0x00           ; cmp byte [0x2fa0],0x0               
l0426: db 0x7C,0x06                          ; jl 0x42e                            
l0428: db 0xE6,0x42                          ; out byte 0x42,al                    
l042A: db 0x8A,0xC4                          ; mov al,ah                           
l042C: db 0xE6,0x42                          ; out byte 0x42,al                    
l042E: db 0x4F                               ; dec di                              
l042F: db 0x75,0xE1                          ; jnz 0x412                           
l0431: db 0x89,0x36,0x23,0x07                ; mov [0x723],si                      
l0435: db 0x5E                               ; pop si                              
l0436: db 0xFC                               ; cld                                 
l0437: db 0x8B,0xFD                          ; mov di,bp                           
l0439: db 0xBB,0xFC,0x1F                     ; mov bx,0x1ffc                       
l043C: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l043F: db 0x8A,0x0E,0x35,0x2A                ; mov cl,[0x2a35]                     
l0443: db 0xB5,0x00                          ; mov ch,0x0                          
l0445: db 0x8B,0xC1                          ; mov ax,cx                           
l0447: db 0xF7,0xD8                          ; neg ax                              
l0449: db 0x05,0x0E,0x00                     ; add ax,0xe                          
l044C: db 0xD1,0xE0                          ; shl ax,0x0                          
l044E: db 0xD1,0xE0                          ; shl ax,0x0                          
l0450: db 0xE3,0x08                          ; jcxz 0x45a                          
l0452: db 0xA5                               ; movsw                               
l0453: db 0xA5                               ; movsw                               
l0454: db 0x03,0xFA                          ; add di,dx                           
l0456: db 0x87,0xD3                          ; xchg dx,bx                          
l0458: db 0xE2,0xF8                          ; loop 0x452                          
l045A: db 0x03,0xF0                          ; add si,ax                           
l045C: db 0x81,0xFE,0x2D,0x2A                ; cmp si,0x2a2d                       
l0460: db 0x75,0xA8                          ; jnz 0x40a                           
l0462: db 0x8B,0xFD                          ; mov di,bp                           
l0464: db 0xBE,0x71,0x2A                     ; mov si,0x2a71                       
l0467: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l046A: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l046D: db 0x8A,0x0E,0x35,0x2A                ; mov cl,[0x2a35]                     
l0471: db 0xB5,0x00                          ; mov ch,0x0                          
l0473: db 0xE3,0x09                          ; jcxz 0x47e                          
l0475: db 0xFC                               ; cld                                 
l0476: db 0xA5                               ; movsw                               
l0477: db 0xA5                               ; movsw                               
l0478: db 0x03,0xFA                          ; add di,dx                           
l047A: db 0x87,0xD5                          ; xchg dx,bp                          
l047C: db 0xE2,0xF8                          ; loop 0x476                          
l047E: db 0xA0,0xF0,0x06                     ; mov al,[0x6f0]                      
l0481: db 0xB4,0x00                          ; mov ah,0x0                          
l0483: db 0x48                               ; dec ax                              
l0484: db 0xA2,0xF0,0x06                     ; mov [0x6f0],al                      
l0487: db 0x74,0x41                          ; jz 0x4ca                            
l0489: db 0x8B,0xF8                          ; mov di,ax                           
l048B: db 0xD1,0xE7                          ; shl di,0x0                          
l048D: db 0xD1,0xE7                          ; shl di,0x0                          
l048F: db 0x03,0xF8                          ; add di,ax                           
l0491: db 0xD1,0xE7                          ; shl di,0x0                          
l0493: db 0xD1,0xE7                          ; shl di,0x0                          
l0495: db 0xD1,0xE7                          ; shl di,0x0                          
l0497: db 0xD1,0xE7                          ; shl di,0x0                          
l0499: db 0xD1,0xE7                          ; shl di,0x0                          
l049B: db 0xD1,0xE7                          ; shl di,0x0                          
l049D: db 0xD1,0xE7                          ; shl di,0x0                          
l049F: db 0xF7,0xDF                          ; neg di                              
l04A1: db 0x81,0xC7,0x3B,0x1F                ; add di,0x1f3b                       
l04A5: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l04A8: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l04AB: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l04AE: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l04B1: db 0xFC                               ; cld                                 
l04B2: db 0xAB                               ; stosw                               
l04B3: db 0xAB                               ; stosw                               
l04B4: db 0x03,0xFA                          ; add di,dx                           
l04B6: db 0x87,0xD5                          ; xchg dx,bp                          
l04B8: db 0xE2,0xF8                          ; loop 0x4b2                          
l04BA: db 0xC6,0x06,0x44,0x2F,0x01           ; mov byte [0x2f44],0x1               
l04BF: db 0xC6,0x06,0x43,0x2F,0x00           ; mov byte [0x2f43],0x0               
l04C4: db 0xE8,0x8A,0x07                     ; call 0xc51                          
l04C7: db 0xE9,0x86,0xFD                     ; jmp 0x250                           
l04CA: db 0xC3                               ; ret                                 
l04CB: db 0xB4,0x00                          ; mov ah,0x0                          
l04CD: db 0xCD,0x1A                          ; int byte 0x1a                       
l04CF: db 0x8B,0xDA                          ; mov bx,dx                           
l04D1: db 0xB4,0x00                          ; mov ah,0x0                          
l04D3: db 0xCD,0x1A                          ; int byte 0x1a                       
l04D5: db 0x3B,0xDA                          ; cmp bx,dx                           
l04D7: db 0x74,0xF8                          ; jz 0x4d1                            
l04D9: db 0xC7,0x06,0xCE,0x2C,0x00,0x00      ; mov word [0x2cce],0x0               
l04DF: db 0xFE,0x06,0xCA,0x2C                ; inc byte [0x2cca]                   
l04E3: db 0xA0,0x9B,0x2C                     ; mov al,[0x2c9b]                     
l04E6: db 0x3C,0x00                          ; cmp al,0x0                          
l04E8: db 0x74,0x14                          ; jz 0x4fe                            
l04EA: db 0xFE,0xC8                          ; dec al                              
l04EC: db 0xA2,0x9B,0x2C                     ; mov [0x2c9b],al                     
l04EF: db 0x75,0x0D                          ; jnz 0x4fe                           
l04F1: db 0xBB,0xF0,0x01                     ; mov bx,0x1f0                        
l04F4: db 0x80,0xA7,0x38,0x2A,0xFE           ; and byte [bx+0x2a38],0xfe           
l04F9: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l04FC: db 0x75,0xF6                          ; jnz 0x4f4                           
l04FE: db 0xFE,0x0E,0xCB,0x2C                ; dec byte [0x2ccb]                   
l0502: db 0x75,0x05                          ; jnz 0x509                           
l0504: db 0xC6,0x06,0xCB,0x2C,0x0E           ; mov byte [0x2ccb],0xe               
l0509: db 0xBB,0x08,0x00                     ; mov bx,0x8                          
l050C: db 0xBE,0x45,0x16                     ; mov si,0x1645                       
l050F: db 0x80,0x3E,0xCB,0x2C,0x07           ; cmp byte [0x2ccb],0x7               
l0514: db 0x7F,0x03                          ; jg 0x519                            
l0516: db 0x83,0xC6,0x10                     ; add si,0x10                         
l0519: db 0x8B,0xBF,0x23,0x16                ; mov di,[bx+0x1623]                  
l051D: db 0x8A,0x05                          ; mov al,[di]                         
l051F: db 0x3C,0x03                          ; cmp al,0x3                          
l0521: db 0x75,0x21                          ; jnz 0x544                           
l0523: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0526: db 0x8B,0xBF,0x2B,0x16                ; mov di,[bx+0x162b]                  
l052A: db 0xA1,0x2E,0x2A                     ; mov ax,[0x2a2e]                     
l052D: db 0x2B,0xC7                          ; sub ax,di                           
l052F: db 0x3D,0x5F,0x1F                     ; cmp ax,0x1f5f                       
l0532: db 0x74,0x10                          ; jz 0x544                            
l0534: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l0537: db 0xA5                               ; movsw                               
l0538: db 0x03,0xFA                          ; add di,dx                           
l053A: db 0xF7,0xDA                          ; neg dx                              
l053C: db 0x83,0xC2,0x4C                     ; add dx,0x4c                         
l053F: db 0xE2,0xF6                          ; loop 0x537                          
l0541: db 0x83,0xEE,0x10                     ; sub si,0x10                         
l0544: db 0x4B                               ; dec bx                              
l0545: db 0x4B                               ; dec bx                              
l0546: db 0x75,0xD1                          ; jnz 0x519                           
l0548: db 0xBB,0xF0,0x01                     ; mov bx,0x1f0                        
l054B: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l054E: db 0x8B,0x87,0x2E,0x2A                ; mov ax,[bx+0x2a2e]                  
l0552: db 0x89,0x87,0x33,0x2A                ; mov [bx+0x2a33],ax                  
l0556: db 0x8A,0x87,0x35,0x2A                ; mov al,[bx+0x2a35]                  
l055A: db 0x88,0x87,0x36,0x2A                ; mov [bx+0x2a36],al                  
l055E: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l0561: db 0xE2,0xEB                          ; loop 0x54e                          
l0563: db 0xE8,0xF7,0x07                     ; call 0xd5d                          
l0566: db 0xF6,0x06,0x31,0x2A,0x01           ; test byte [0x2a31],0x1              
l056B: db 0x75,0x41                          ; jnz 0x5ae                           
l056D: db 0xF6,0x06,0x30,0x2A,0x01           ; test byte [0x2a30],0x1              
l0572: db 0x75,0x3A                          ; jnz 0x5ae                           
l0574: db 0xB4,0x00                          ; mov ah,0x0                          
l0576: db 0xA0,0x30,0x2A                     ; mov al,[0x2a30]                     
l0579: db 0xD1,0xF8                          ; sar ax,0x0                          
l057B: db 0xBA,0x1E,0x00                     ; mov dx,0x1e                         
l057E: db 0xF7,0xE2                          ; mul dx                              
l0580: db 0x8B,0xD8                          ; mov bx,ax                           
l0582: db 0xA1,0x31,0x2A                     ; mov ax,[0x2a31]                     
l0585: db 0xD1,0xF8                          ; sar ax,0x0                          
l0587: db 0x03,0xD8                          ; add bx,ax                           
l0589: db 0x80,0xBF,0x73,0x16,0x01           ; cmp byte [bx+0x1673],0x1            
l058E: db 0x7F,0x3B                          ; jg 0x5cb                            
l0590: db 0xA0,0xBC,0x2C                     ; mov al,[0x2cbc]                     
l0593: db 0xB4,0x00                          ; mov ah,0x0                          
l0595: db 0x8B,0xF0                          ; mov si,ax                           
l0597: db 0x8A,0x84,0xBD,0x2C                ; mov al,[si+0x2cbd]                  
l059B: db 0x98                               ; cbw                                 
l059C: db 0x8B,0xF0                          ; mov si,ax                           
l059E: db 0x80,0xB8,0x73,0x16,0x00           ; cmp byte [bx+si+0x1673],0x0         
l05A3: db 0x74,0x0C                          ; jz 0x5b1                            
l05A5: db 0xA0,0xBC,0x2C                     ; mov al,[0x2cbc]                     
l05A8: db 0xA2,0x2D,0x2A                     ; mov [0x2a2d],al                     
l05AB: db 0xE9,0x99,0x00                     ; jmp 0x647                           
l05AE: db 0xE9,0x85,0x00                     ; jmp 0x636                           
l05B1: db 0xA0,0x2D,0x2A                     ; mov al,[0x2a2d]                     
l05B4: db 0xB4,0x00                          ; mov ah,0x0                          
l05B6: db 0x8B,0xF0                          ; mov si,ax                           
l05B8: db 0x8A,0x84,0xBD,0x2C                ; mov al,[si+0x2cbd]                  
l05BC: db 0x98                               ; cbw                                 
l05BD: db 0x8B,0xF0                          ; mov si,ax                           
l05BF: db 0x80,0xB8,0x73,0x16,0x00           ; cmp byte [bx+si+0x1673],0x0         
l05C4: db 0x75,0xE5                          ; jnz 0x5ab                           
l05C6: db 0xE9,0xD6,0x00                     ; jmp 0x69f                           
l05C9: db 0xEB,0xC5                          ; jmp 0x590                           
l05CB: db 0xB8,0x01,0x04                     ; mov ax,0x401                        
l05CE: db 0xE8,0x59,0x08                     ; call 0xe2a                          
l05D1: db 0xB0,0x01                          ; mov al,0x1                          
l05D3: db 0x86,0x87,0x73,0x16                ; xchg al,[bx+0x1673]                 
l05D7: db 0x3C,0x03                          ; cmp al,0x3                          
l05D9: db 0x75,0x29                          ; jnz 0x604                           
l05DB: db 0xC6,0x06,0x91,0x2F,0x19           ; mov byte [0x2f91],0x19              
l05E0: db 0xB8,0x04,0x04                     ; mov ax,0x404                        
l05E3: db 0xE8,0x44,0x08                     ; call 0xe2a                          
l05E6: db 0xC7,0x06,0x8D,0x2F,0x00,0x00      ; mov word [0x2f8d],0x0               
l05EC: db 0xA0,0x9A,0x2C                     ; mov al,[0x2c9a]                     
l05EF: db 0xA2,0x9B,0x2C                     ; mov [0x2c9b],al                     
l05F2: db 0xBE,0xF0,0x01                     ; mov si,0x1f0                        
l05F5: db 0x80,0x8C,0x38,0x2A,0x01           ; or byte [si+0x2a38],0x1             
l05FA: db 0x80,0xB4,0x2D,0x2A,0x01           ; xor byte [si+0x2a2d],0x1            
l05FF: db 0x83,0xEE,0x7C                     ; sub si,0x7c                         
l0602: db 0x75,0xF1                          ; jnz 0x5f5                           
l0604: db 0xFE,0x0E,0x99,0x2C                ; dec byte [0x2c99]                   
l0608: db 0x75,0x01                          ; jnz 0x60b                           
l060A: db 0xC3                               ; ret                                 
l060B: db 0xFC                               ; cld                                 
l060C: db 0x06                               ; push es                             
l060D: db 0x1E                               ; push ds                             
l060E: db 0x07                               ; pop es                              
l060F: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0612: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0615: db 0xBF,0x7E,0x2A                     ; mov di,0x2a7e                       
l0618: db 0xAB                               ; stosw                               
l0619: db 0x47                               ; inc di                              
l061A: db 0x47                               ; inc di                              
l061B: db 0xE2,0xFB                          ; loop 0x618                          
l061D: db 0x07                               ; pop es                              
l061E: db 0xC6,0x06,0x90,0x2F,0x02           ; mov byte [0x2f90],0x2               
l0623: db 0xF6,0x1E,0xCC,0x2C                ; neg byte [0x2ccc]                   
l0627: db 0x7F,0xA0                          ; jg 0x5c9                            
l0629: db 0xFE,0x06,0x90,0x2F                ; inc byte [0x2f90]                   
l062D: db 0xC7,0x06,0xCE,0x2C,0x7C,0x00      ; mov word [0x2cce],0x7c              
l0633: db 0xEB,0x6A                          ; jmp 0x69f                           
l0635: db 0x90                               ; nop                                 
l0636: db 0xA0,0x2D,0x2A                     ; mov al,[0x2a2d]                     
l0639: db 0x32,0x06,0xBC,0x2C                ; xor al,[0x2cbc]                     
l063D: db 0xA8,0x02                          ; test al,0x2                         
l063F: db 0x75,0x06                          ; jnz 0x647                           
l0641: db 0xA0,0xBC,0x2C                     ; mov al,[0x2cbc]                     
l0644: db 0xA2,0x2D,0x2A                     ; mov [0x2a2d],al                     
l0647: db 0xA0,0x2D,0x2A                     ; mov al,[0x2a2d]                     
l064A: db 0xB4,0x00                          ; mov ah,0x0                          
l064C: db 0x8B,0xF0                          ; mov si,ax                           
l064E: db 0xD1,0xE6                          ; shl si,0x0                          
l0650: db 0x8B,0x84,0xC1,0x2C                ; mov ax,[si+0x2cc1]                  
l0654: db 0x03,0x06,0x2E,0x2A                ; add ax,[0x2a2e]                     
l0658: db 0xA3,0x2E,0x2A                     ; mov [0x2a2e],ax                     
l065B: db 0x8B,0xC6                          ; mov ax,si                           
l065D: db 0xA9,0x04,0x00                     ; test ax,0x4                         
l0660: db 0x75,0x0B                          ; jnz 0x66d                           
l0662: db 0x48                               ; dec ax                              
l0663: db 0x02,0x06,0x30,0x2A                ; add al,[0x2a30]                     
l0667: db 0xA2,0x30,0x2A                     ; mov [0x2a30],al                     
l066A: db 0xEB,0x08                          ; jmp 0x674                           
l066C: db 0x90                               ; nop                                 
l066D: db 0x2D,0x05,0x00                     ; sub ax,0x5                          
l0670: db 0x00,0x06,0x31,0x2A                ; add [0x2a31],al                     
l0674: db 0xA0,0xC9,0x2C                     ; mov al,[0x2cc9]                     
l0677: db 0xFE,0xC0                          ; inc al                              
l0679: db 0x24,0x03                          ; and al,0x3                          
l067B: db 0xA2,0xC9,0x2C                     ; mov [0x2cc9],al                     
l067E: db 0x8B,0xDE                          ; mov bx,si                           
l0680: db 0xD1,0xE3                          ; shl bx,0x0                          
l0682: db 0xB4,0x00                          ; mov ah,0x0                          
l0684: db 0x03,0xD8                          ; add bx,ax                           
l0686: db 0xD1,0xE3                          ; shl bx,0x0                          
l0688: db 0x8B,0xB7,0x9C,0x2C                ; mov si,[bx+0x2c9c]                  
l068C: db 0x81,0xC6,0x61,0x1D                ; add si,0x1d61                       
l0690: db 0xBF,0x39,0x2A                     ; mov di,0x2a39                       
l0693: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l0696: db 0x06                               ; push es                             
l0697: db 0x1E                               ; push ds                             
l0698: db 0x07                               ; pop es                              
l0699: db 0xFC                               ; cld                                 
l069A: db 0xA5                               ; movsw                               
l069B: db 0xA5                               ; movsw                               
l069C: db 0xE2,0xFC                          ; loop 0x69a                          
l069E: db 0x07                               ; pop es                              
l069F: db 0xBB,0xF0,0x01                     ; mov bx,0x1f0                        
l06A2: db 0x80,0xBF,0x37,0x2A,0x02           ; cmp byte [bx+0x2a37],0x2            
l06A7: db 0x7C,0x08                          ; jl 0x6b1                            
l06A9: db 0xC6,0x87,0x37,0x2A,0x01           ; mov byte [bx+0x2a37],0x1            
l06AE: db 0xE9,0xA4,0x00                     ; jmp 0x755                           
l06B1: db 0xF6,0x87,0x31,0x2A,0x01           ; test byte [bx+0x2a31],0x1           
l06B6: db 0x75,0x48                          ; jnz 0x700                           
l06B8: db 0xF6,0x87,0x30,0x2A,0x01           ; test byte [bx+0x2a30],0x1           
l06BD: db 0x75,0x41                          ; jnz 0x700                           
l06BF: db 0xC6,0x06,0xCD,0x2C,0x00           ; mov byte [0x2ccd],0x0               
l06C4: db 0xB4,0x00                          ; mov ah,0x0                          
l06C6: db 0x8A,0x87,0x30,0x2A                ; mov al,[bx+0x2a30]                  
l06CA: db 0xD1,0xF8                          ; sar ax,0x0                          
l06CC: db 0xBA,0x1E,0x00                     ; mov dx,0x1e                         
l06CF: db 0xF7,0xE2                          ; mul dx                              
l06D1: db 0x8B,0xE8                          ; mov bp,ax                           
l06D3: db 0x8B,0x87,0x31,0x2A                ; mov ax,[bx+0x2a31]                  
l06D7: db 0xD1,0xF8                          ; sar ax,0x0                          
l06D9: db 0x03,0xE8                          ; add bp,ax                           
l06DB: db 0xE8,0x6C,0x02                     ; call 0x94a                          
l06DE: db 0x38,0x87,0x2D,0x2A                ; cmp [bx+0x2a2d],al                  
l06E2: db 0x74,0x25                          ; jz 0x709                            
l06E4: db 0x8A,0xD0                          ; mov dl,al                           
l06E6: db 0x86,0x97,0x2D,0x2A                ; xchg dl,[bx+0x2a2d]                 
l06EA: db 0x80,0xBF,0x37,0x2A,0x01           ; cmp byte [bx+0x2a37],0x1            
l06EF: db 0x74,0x18                          ; jz 0x709                            
l06F1: db 0x88,0x97,0x2D,0x2A                ; mov [bx+0x2a2d],dl                  
l06F5: db 0xC6,0x87,0x37,0x2A,0x01           ; mov byte [bx+0x2a37],0x1            
l06FA: db 0xEB,0x59                          ; jmp 0x755                           
l06FC: db 0x90                               ; nop                                 
l06FD: db 0xEB,0x0A                          ; jmp 0x709                           
l06FF: db 0x90                               ; nop                                 
l0700: db 0x8A,0x87,0x2D,0x2A                ; mov al,[bx+0x2a2d]                  
l0704: db 0xC6,0x06,0xCD,0x2C,0x01           ; mov byte [0x2ccd],0x1               
l0709: db 0xB4,0x00                          ; mov ah,0x0                          
l070B: db 0x8B,0xF0                          ; mov si,ax                           
l070D: db 0xD1,0xE6                          ; shl si,0x0                          
l070F: db 0x8B,0xB4,0xC1,0x2C                ; mov si,[si+0x2cc1]                  
l0713: db 0x01,0xB7,0x2E,0x2A                ; add [bx+0x2a2e],si                  
l0717: db 0x8A,0xE0                          ; mov ah,al                           
l0719: db 0xD1,0xF8                          ; sar ax,0x0                          
l071B: db 0x98                               ; cbw                                 
l071C: db 0xD0,0xE4                          ; shl ah,0x0                          
l071E: db 0xFE,0xC4                          ; inc ah                              
l0720: db 0xF6,0xDC                          ; neg ah                              
l0722: db 0x24,0x7F                          ; and al,0x7f                         
l0724: db 0x8A,0xD0                          ; mov dl,al                           
l0726: db 0x8A,0xC4                          ; mov al,ah                           
l0728: db 0xB6,0x00                          ; mov dh,0x0                          
l072A: db 0x8B,0xFA                          ; mov di,dx                           
l072C: db 0x00,0x81,0x30,0x2A                ; add [bx+di+0x2a30],al               
l0730: db 0xC6,0x87,0x37,0x2A,0x00           ; mov byte [bx+0x2a37],0x0            
l0735: db 0x80,0xBF,0x38,0x2A,0x02           ; cmp byte [bx+0x2a38],0x2            
l073A: db 0x7C,0x0B                          ; jl 0x747                            
l073C: db 0x80,0xBF,0x38,0x2A,0x06           ; cmp byte [bx+0x2a38],0x6            
l0741: db 0x7D,0x04                          ; jnl 0x747                           
l0743: db 0x28,0x81,0x30,0x2A                ; sub [bx+di+0x2a30],al               
l0747: db 0x80,0x3E,0xCD,0x2C,0x01           ; cmp byte [0x2ccd],0x1               
l074C: db 0x74,0x07                          ; jz 0x755                            
l074E: db 0x80,0xBF,0x38,0x2A,0x06           ; cmp byte [bx+0x2a38],0x6            
l0753: db 0x7D,0xAB                          ; jnl 0x700                           
l0755: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l0758: db 0x74,0x03                          ; jz 0x75d                            
l075A: db 0xE9,0x45,0xFF                     ; jmp 0x6a2                           
l075D: db 0xE8,0x69,0x01                     ; call 0x8c9                          
l0760: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l0763: db 0xBB,0x00,0x00                     ; mov bx,0x0                          
l0766: db 0x8A,0x87,0x30,0x2A                ; mov al,[bx+0x2a30]                  
l076A: db 0x3C,0x00                          ; cmp al,0x0                          
l076C: db 0xB4,0x3A                          ; mov ah,0x3a                         
l076E: db 0xBA,0x40,0x24                     ; mov dx,0x2440                       
l0771: db 0x7C,0x09                          ; jl 0x77c                            
l0773: db 0x3C,0x39                          ; cmp al,0x39                         
l0775: db 0xB4,0xC6                          ; mov ah,0xc6                         
l0777: db 0xBA,0xC0,0xDB                     ; mov dx,0xdbc0                       
l077A: db 0x7E,0x0A                          ; jng 0x786                           
l077C: db 0x02,0xC4                          ; add al,ah                           
l077E: db 0x88,0x87,0x30,0x2A                ; mov [bx+0x2a30],al                  
l0782: db 0x01,0x97,0x2E,0x2A                ; add [bx+0x2a2e],dx                  
l0786: db 0x80,0xBF,0x37,0x2A,0x01           ; cmp byte [bx+0x2a37],0x1            
l078B: db 0x74,0x2C                          ; jz 0x7b9                            
l078D: db 0x80,0xBF,0x31,0x2A,0x20           ; cmp byte [bx+0x2a31],0x20           
l0792: db 0x75,0x12                          ; jnz 0x7a6                           
l0794: db 0xC6,0x87,0x37,0x2A,0x02           ; mov byte [bx+0x2a37],0x2            
l0799: db 0x3C,0x0C                          ; cmp al,0xc                          
l079B: db 0x7C,0x09                          ; jl 0x7a6                            
l079D: db 0x3C,0x26                          ; cmp al,0x26                         
l079F: db 0x7F,0x05                          ; jg 0x7a6                            
l07A1: db 0xC6,0x87,0x37,0x2A,0x00           ; mov byte [bx+0x2a37],0x0            
l07A6: db 0x80,0xBF,0x38,0x2A,0x00           ; cmp byte [bx+0x2a38],0x0            
l07AB: db 0x74,0x0C                          ; jz 0x7b9                            
l07AD: db 0x80,0xBF,0x38,0x2A,0x06           ; cmp byte [bx+0x2a38],0x6            
l07B2: db 0x7D,0x05                          ; jnl 0x7b9                           
l07B4: db 0xC6,0x87,0x37,0x2A,0x02           ; mov byte [bx+0x2a37],0x2            
l07B9: db 0xB4,0x00                          ; mov ah,0x0                          
l07BB: db 0xD1,0xE0                          ; shl ax,0x0                          
l07BD: db 0xD1,0xE0                          ; shl ax,0x0                          
l07BF: db 0xF7,0xD8                          ; neg ax                              
l07C1: db 0x05,0xCF,0x00                     ; add ax,0xcf                         
l07C4: db 0x3D,0x00,0x00                     ; cmp ax,0x0                          
l07C7: db 0x7C,0x0B                          ; jl 0x7d4                            
l07C9: db 0x3D,0x0E,0x00                     ; cmp ax,0xe                          
l07CC: db 0x7E,0x09                          ; jng 0x7d7                           
l07CE: db 0xB8,0x0E,0x00                     ; mov ax,0xe                          
l07D1: db 0xEB,0x04                          ; jmp 0x7d7                           
l07D3: db 0x90                               ; nop                                 
l07D4: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l07D7: db 0x88,0x87,0x35,0x2A                ; mov [bx+0x2a35],al                  
l07DB: db 0x83,0xC3,0x7C                     ; add bx,0x7c                         
l07DE: db 0xE2,0x86                          ; loop 0x766                          
l07E0: db 0xE8,0x2E,0x07                     ; call 0xf11                          
l07E3: db 0xE8,0x82,0x06                     ; call 0xe68                          
l07E6: db 0xE8,0x63,0x03                     ; call 0xb4c                          
l07E9: db 0xFC                               ; cld                                 
l07EA: db 0xBB,0x6C,0x02                     ; mov bx,0x26c                        
l07ED: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l07F0: db 0xBE,0x71,0x2A                     ; mov si,0x2a71                       
l07F3: db 0x03,0xF3                          ; add si,bx                           
l07F5: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l07F8: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l07FB: db 0x8B,0xBF,0x33,0x2A                ; mov di,[bx+0x2a33]                  
l07FF: db 0x8A,0x8F,0x36,0x2A                ; mov cl,[bx+0x2a36]                  
l0803: db 0xB5,0x00                          ; mov ch,0x0                          
l0805: db 0xE3,0x08                          ; jcxz 0x80f                          
l0807: db 0xA5                               ; movsw                               
l0808: db 0xA5                               ; movsw                               
l0809: db 0x03,0xFA                          ; add di,dx                           
l080B: db 0x87,0xD5                          ; xchg dx,bp                          
l080D: db 0xE2,0xF8                          ; loop 0x807                          
l080F: db 0x3B,0x1E,0xCE,0x2C                ; cmp bx,[0x2cce]                     
l0813: db 0x75,0xD8                          ; jnz 0x7ed                           
l0815: db 0x80,0x3E,0x44,0x2F,0x00           ; cmp byte [0x2f44],0x0               
l081A: db 0x74,0x03                          ; jz 0x81f                            
l081C: db 0xE8,0x32,0x04                     ; call 0xc51                          
l081F: db 0x8B,0x1E,0xCE,0x2C                ; mov bx,[0x2cce]                     
l0823: db 0x81,0xEB,0x6C,0x02                ; sub bx,0x26c                        
l0827: db 0xBD,0x48,0x00                     ; mov bp,0x48                         
l082A: db 0x83,0xC3,0x7C                     ; add bx,0x7c                         
l082D: db 0x8B,0xB7,0x1E,0x2C                ; mov si,[bx+0x2c1e]                  
l0831: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l0834: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l0837: db 0xBF,0x61,0x2C                     ; mov di,0x2c61                       
l083A: db 0x03,0xFB                          ; add di,bx                           
l083C: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l083F: db 0x06                               ; push es                             
l0840: db 0x1E                               ; push ds                             
l0841: db 0x07                               ; pop es                              
l0842: db 0x1F                               ; pop ds                              
l0843: db 0xA5                               ; movsw                               
l0844: db 0xA5                               ; movsw                               
l0845: db 0x03,0xF2                          ; add si,dx                           
l0847: db 0x87,0xD5                          ; xchg dx,bp                          
l0849: db 0xE2,0xF8                          ; loop 0x843                          
l084B: db 0x06                               ; push es                             
l084C: db 0x1E                               ; push ds                             
l084D: db 0x07                               ; pop es                              
l084E: db 0x1F                               ; pop ds                              
l084F: db 0xBE,0x29,0x2C                     ; mov si,0x2c29                       
l0852: db 0x03,0xF3                          ; add si,bx                           
l0854: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l0857: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l085A: db 0x8B,0xBF,0x1E,0x2C                ; mov di,[bx+0x2c1e]                  
l085E: db 0x8A,0x8F,0x25,0x2C                ; mov cl,[bx+0x2c25]                  
l0862: db 0xB5,0x00                          ; mov ch,0x0                          
l0864: db 0xE3,0x19                          ; jcxz 0x87f                          
l0866: db 0x26,0x8A,0x05                     ; mov al,[es:di]                      
l0869: db 0x24,0xC0                          ; and al,0xc0                         
l086B: db 0x0A,0x04                          ; or al,[si]                          
l086D: db 0x46                               ; inc si                              
l086E: db 0xAA                               ; stosb                               
l086F: db 0xA5                               ; movsw                               
l0870: db 0x26,0x8A,0x05                     ; mov al,[es:di]                      
l0873: db 0x24,0x03                          ; and al,0x3                          
l0875: db 0x0A,0x04                          ; or al,[si]                          
l0877: db 0x46                               ; inc si                              
l0878: db 0xAA                               ; stosb                               
l0879: db 0x03,0xFA                          ; add di,dx                           
l087B: db 0x87,0xD5                          ; xchg dx,bp                          
l087D: db 0xE2,0xE7                          ; loop 0x866                          
l087F: db 0x83,0xFB,0x00                     ; cmp bx,0x0                          
l0882: db 0x75,0xA6                          ; jnz 0x82a                           
l0884: db 0xBB,0xF0,0x01                     ; mov bx,0x1f0                        
l0887: db 0x80,0xBF,0x38,0x2A,0x02           ; cmp byte [bx+0x2a38],0x2            
l088C: db 0x7D,0x24                          ; jnl 0x8b2                           
l088E: db 0x8B,0x87,0x30,0x2A                ; mov ax,[bx+0x2a30]                  
l0892: db 0x2A,0x06,0x30,0x2A                ; sub al,[0x2a30]                     
l0896: db 0x7D,0x02                          ; jnl 0x89a                           
l0898: db 0xF6,0xD8                          ; neg al                              
l089A: db 0x2A,0x26,0x31,0x2A                ; sub ah,[0x2a31]                     
l089E: db 0x7D,0x02                          ; jnl 0x8a2                           
l08A0: db 0xF6,0xDC                          ; neg ah                              
l08A2: db 0x02,0xC4                          ; add al,ah                           
l08A4: db 0x3C,0x02                          ; cmp al,0x2                          
l08A6: db 0x7F,0x0A                          ; jg 0x8b2                            
l08A8: db 0x80,0xBF,0x38,0x2A,0x00           ; cmp byte [bx+0x2a38],0x0            
l08AD: db 0x74,0x19                          ; jz 0x8c8                            
l08AF: db 0xE8,0xF4,0x03                     ; call 0xca6                          
l08B2: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l08B5: db 0x75,0xD0                          ; jnz 0x887                           
l08B7: db 0xBF,0x3C,0x1F                     ; mov di,0x1f3c                       
l08BA: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l08BD: db 0xFC                               ; cld                                 
l08BE: db 0xAB                               ; stosw                               
l08BF: db 0xAB                               ; stosw                               
l08C0: db 0x83,0xEF,0x54                     ; sub di,0x54                         
l08C3: db 0xAB                               ; stosw                               
l08C4: db 0xAB                               ; stosw                               
l08C5: db 0xE9,0x03,0xFC                     ; jmp 0x4cb                           
l08C8: db 0xC3                               ; ret                                 
l08C9: db 0x06                               ; push es                             
l08CA: db 0x1E                               ; push ds                             
l08CB: db 0x07                               ; pop es                              
l08CC: db 0xBB,0x6C,0x02                     ; mov bx,0x26c                        
l08CF: db 0xBD,0x80,0x02                     ; mov bp,0x280                        
l08D2: db 0x83,0xEB,0x7C                     ; sub bx,0x7c                         
l08D5: db 0x81,0xED,0xA0,0x00                ; sub bp,0xa0                         
l08D9: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l08DC: db 0x8A,0x87,0x2D,0x2A                ; mov al,[bx+0x2a2d]                  
l08E0: db 0xB4,0x00                          ; mov ah,0x0                          
l08E2: db 0x8B,0xF0                          ; mov si,ax                           
l08E4: db 0xD1,0xE6                          ; shl si,0x0                          
l08E6: db 0xD1,0xE6                          ; shl si,0x0                          
l08E8: db 0xD1,0xE6                          ; shl si,0x0                          
l08EA: db 0xD1,0xE6                          ; shl si,0x0                          
l08EC: db 0xD1,0xE6                          ; shl si,0x0                          
l08EE: db 0x81,0xC6,0xE1,0x20                ; add si,0x20e1                       
l08F2: db 0xB8,0xC0,0x03                     ; mov ax,0x3c0                        
l08F5: db 0x80,0xBF,0x38,0x2A,0x06           ; cmp byte [bx+0x2a38],0x6            
l08FA: db 0x7D,0x1D                          ; jnl 0x919                           
l08FC: db 0x8B,0xC5                          ; mov ax,bp                           
l08FE: db 0xF6,0x87,0x38,0x2A,0x01           ; test byte [bx+0x2a38],0x1           
l0903: db 0x74,0x14                          ; jz 0x919                            
l0905: db 0xB8,0x80,0x02                     ; mov ax,0x280                        
l0908: db 0x80,0x3E,0x9B,0x2C,0x46           ; cmp byte [0x2c9b],0x46              
l090D: db 0x77,0x0A                          ; ja 0x919                            
l090F: db 0x80,0x3E,0xCB,0x2C,0x08           ; cmp byte [0x2ccb],0x8               
l0914: db 0x7C,0x03                          ; jl 0x919                            
l0916: db 0x05,0xA0,0x00                     ; add ax,0xa0                         
l0919: db 0xBF,0x39,0x2A                     ; mov di,0x2a39                       
l091C: db 0x03,0xFB                          ; add di,bx                           
l091E: db 0xE8,0xDF,0x01                     ; call 0xb00                          
l0921: db 0xBE,0x61,0x21                     ; mov si,0x2161                       
l0924: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0927: db 0xE8,0xD6,0x01                     ; call 0xb00                          
l092A: db 0x8B,0x36,0xCA,0x2C                ; mov si,[0x2cca]                     
l092E: db 0x81,0xE6,0x02,0x00                ; and si,0x2                          
l0932: db 0xD1,0xE6                          ; shl si,0x0                          
l0934: db 0xD1,0xE6                          ; shl si,0x0                          
l0936: db 0x81,0xC6,0x71,0x21                ; add si,0x2171                       
l093A: db 0xB9,0x02,0x00                     ; mov cx,0x2                          
l093D: db 0xE8,0xC0,0x01                     ; call 0xb00                          
l0940: db 0x83,0xFD,0x00                     ; cmp bp,0x0                          
l0943: db 0x75,0x8D                          ; jnz 0x8d2                           
l0945: db 0x07                               ; pop es                              
l0946: db 0xC3                               ; ret                                 
l0947: db 0xE9,0xD1,0x00                     ; jmp 0xa1b                           
l094A: db 0x06                               ; push es                             
l094B: db 0x1E                               ; push ds                             
l094C: db 0x07                               ; pop es                              
l094D: db 0xBF,0x2A,0x2D                     ; mov di,0x2d2a                       
l0950: db 0xB0,0x01                          ; mov al,0x1                          
l0952: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0955: db 0xFC                               ; cld                                 
l0956: db 0xF3,0xAA                          ; rep stosb                           
l0958: db 0x8A,0x87,0x38,0x2A                ; mov al,[bx+0x2a38]                  
l095C: db 0xD0,0xF8                          ; sar al,0x0                          
l095E: db 0x74,0xE7                          ; jz 0x947                            
l0960: db 0xFE,0xC8                          ; dec al                              
l0962: db 0x75,0x35                          ; jnz 0x999                           
l0964: db 0x8B,0x87,0x2E,0x2A                ; mov ax,[bx+0x2a2e]                  
l0968: db 0x2D,0x92,0x2E                     ; sub ax,0x2e92                       
l096B: db 0x75,0x18                          ; jnz 0x985                           
l096D: db 0x80,0xAF,0x38,0x2A,0x02           ; sub byte [bx+0x2a38],0x2            
l0972: db 0xC7,0x87,0x30,0x2A,0x19,0x26      ; mov word [bx+0x2a30],0x2619         
l0978: db 0xE8,0x76,0x01                     ; call 0xaf1                          
l097B: db 0xD1,0xD0                          ; rcl ax,0x0                          
l097D: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0980: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0982: db 0xE9,0x6A,0x01                     ; jmp 0xaef                           
l0985: db 0x3D,0xE2,0xFF                     ; cmp ax,0xffe2                       
l0988: db 0x76,0x05                          ; jna 0x98f                           
l098A: db 0xB0,0x03                          ; mov al,0x3                          
l098C: db 0xE9,0x60,0x01                     ; jmp 0xaef                           
l098F: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0991: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0994: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0996: db 0xE9,0x56,0x01                     ; jmp 0xaef                           
l0999: db 0xFE,0xC8                          ; dec al                              
l099B: db 0x75,0x45                          ; jnz 0x9e2                           
l099D: db 0x8A,0x87,0x2D,0x2A                ; mov al,[bx+0x2a2d]                  
l09A1: db 0xB4,0x00                          ; mov ah,0x0                          
l09A3: db 0x8B,0xF0                          ; mov si,ax                           
l09A5: db 0x8B,0xD3                          ; mov dx,bx                           
l09A7: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l09AA: db 0x41                               ; inc cx                              
l09AB: db 0x83,0xEA,0x7C                     ; sub dx,0x7c                         
l09AE: db 0x75,0xFA                          ; jnz 0x9aa                           
l09B0: db 0xD1,0xE1                          ; shl cx,0x0                          
l09B2: db 0x03,0xF1                          ; add si,cx                           
l09B4: db 0xD1,0xE6                          ; shl si,0x0                          
l09B6: db 0x8B,0x97,0x2E,0x2A                ; mov dx,[bx+0x2a2e]                  
l09BA: db 0x3B,0x94,0x0C,0x2D                ; cmp dx,[si+0x2d0c]                  
l09BE: db 0x75,0x1F                          ; jnz 0x9df                           
l09C0: db 0x34,0x01                          ; xor al,0x1                          
l09C2: db 0x3C,0x03                          ; cmp al,0x3                          
l09C4: db 0x75,0x19                          ; jnz 0x9df                           
l09C6: db 0xF6,0x87,0x38,0x2A,0x01           ; test byte [bx+0x2a38],0x1           
l09CB: db 0x75,0x12                          ; jnz 0x9df                           
l09CD: db 0xE8,0x21,0x01                     ; call 0xaf1                          
l09D0: db 0x3B,0x06,0x27,0x2D                ; cmp ax,[0x2d27]                     
l09D4: db 0xB0,0x03                          ; mov al,0x3                          
l09D6: db 0x73,0x07                          ; jnc 0x9df                           
l09D8: db 0x80,0xAF,0x38,0x2A,0x02           ; sub byte [bx+0x2a38],0x2            
l09DD: db 0xEB,0x85                          ; jmp 0x964                           
l09DF: db 0xE9,0x0D,0x01                     ; jmp 0xaef                           
l09E2: db 0x81,0xBF,0x30,0x2A,0x1A,0x26      ; cmp word [bx+0x2a30],0x261a         
l09E8: db 0x75,0x31                          ; jnz 0xa1b                           
l09EA: db 0x80,0xAF,0x38,0x2A,0x02           ; sub byte [bx+0x2a38],0x2            
l09EF: db 0x8B,0xD3                          ; mov dx,bx                           
l09F1: db 0xB9,0x00,0x00                     ; mov cx,0x0                          
l09F4: db 0x41                               ; inc cx                              
l09F5: db 0x83,0xEA,0x7C                     ; sub dx,0x7c                         
l09F8: db 0x75,0xFA                          ; jnz 0x9f4                           
l09FA: db 0xD1,0xE1                          ; shl cx,0x0                          
l09FC: db 0xD1,0xE1                          ; shl cx,0x0                          
l09FE: db 0x8B,0xF1                          ; mov si,cx                           
l0A00: db 0x8B,0x84,0x10,0x2D                ; mov ax,[si+0x2d10]                  
l0A04: db 0x89,0x87,0x2E,0x2A                ; mov [bx+0x2a2e],ax                  
l0A08: db 0x83,0xF9,0x0C                     ; cmp cx,0xc                          
l0A0B: db 0x75,0x05                          ; jnz 0xa12                           
l0A0D: db 0x80,0xAF,0x38,0x2A,0x02           ; sub byte [bx+0x2a38],0x2            
l0A12: db 0xB0,0x03                          ; mov al,0x3                          
l0A14: db 0x88,0x87,0x2D,0x2A                ; mov [bx+0x2a2d],al                  
l0A18: db 0xE9,0xD4,0x00                     ; jmp 0xaef                           
l0A1B: db 0xA0,0x26,0x2D                     ; mov al,[0x2d26]                     
l0A1E: db 0xA2,0x29,0x2D                     ; mov [0x2d29],al                     
l0A21: db 0x8A,0x97,0x38,0x2A                ; mov dl,[bx+0x2a38]                  
l0A25: db 0x8A,0xCA                          ; mov cl,dl                           
l0A27: db 0x81,0xF1,0x01,0x00                ; xor cx,0x1                          
l0A2B: db 0x81,0xE1,0x01,0x00                ; and cx,0x1                          
l0A2F: db 0x80,0xFA,0x06                     ; cmp dl,0x6                          
l0A32: db 0x7C,0x08                          ; jl 0xa3c                            
l0A34: db 0xC6,0x06,0x29,0x2D,0x3C           ; mov byte [0x2d29],0x3c              
l0A39: db 0xB9,0x01,0x00                     ; mov cx,0x1                          
l0A3C: db 0xA0,0x30,0x2A                     ; mov al,[0x2a30]                     
l0A3F: db 0x80,0xFA,0x06                     ; cmp dl,0x6                          
l0A42: db 0x7C,0x02                          ; jl 0xa46                            
l0A44: db 0xB0,0x1A                          ; mov al,0x1a                         
l0A46: db 0x2A,0x87,0x30,0x2A                ; sub al,[bx+0x2a30]                  
l0A4A: db 0xE3,0x02                          ; jcxz 0xa4e                          
l0A4C: db 0xF6,0xD8                          ; neg al                              
l0A4E: db 0x74,0x10                          ; jz 0xa60                            
l0A50: db 0xD0,0xD0                          ; rcl al,0x0                          
l0A52: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0A55: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0A57: db 0x8B,0xF8                          ; mov di,ax                           
l0A59: db 0xA0,0x29,0x2D                     ; mov al,[0x2d29]                     
l0A5C: db 0x88,0x85,0x2A,0x2D                ; mov [di+0x2d2a],al                  
l0A60: db 0xA0,0x31,0x2A                     ; mov al,[0x2a31]                     
l0A63: db 0x80,0xFA,0x06                     ; cmp dl,0x6                          
l0A66: db 0x7C,0x02                          ; jl 0xa6a                            
l0A68: db 0xB0,0x26                          ; mov al,0x26                         
l0A6A: db 0x2A,0x87,0x31,0x2A                ; sub al,[bx+0x2a31]                  
l0A6E: db 0xE3,0x02                          ; jcxz 0xa72                          
l0A70: db 0xF6,0xD8                          ; neg al                              
l0A72: db 0x74,0x10                          ; jz 0xa84                            
l0A74: db 0xD0,0xD0                          ; rcl al,0x0                          
l0A76: db 0xB8,0x01,0x00                     ; mov ax,0x1                          
l0A79: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0A7B: db 0x8B,0xF8                          ; mov di,ax                           
l0A7D: db 0xA0,0x29,0x2D                     ; mov al,[0x2d29]                     
l0A80: db 0x88,0x85,0x2A,0x2D                ; mov [di+0x2d2a],al                  
l0A84: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0A87: db 0x8B,0xF9                          ; mov di,cx                           
l0A89: db 0x8A,0x85,0xBC,0x2C                ; mov al,[di+0x2cbc]                  
l0A8D: db 0x98                               ; cbw                                 
l0A8E: db 0x8B,0xF0                          ; mov si,ax                           
l0A90: db 0x3E,0x80,0xBA,0x73,0x16,0x00      ; cmp byte [ds:bp+si+0x1673],0x0      
l0A96: db 0x75,0x05                          ; jnz 0xa9d                           
l0A98: db 0xC6,0x85,0x29,0x2D,0x00           ; mov byte [di+0x2d29],0x0            
l0A9D: db 0xE2,0xE8                          ; loop 0xa87                          
l0A9F: db 0x8A,0x87,0x2D,0x2A                ; mov al,[bx+0x2a2d]                  
l0AA3: db 0xB4,0x00                          ; mov ah,0x0                          
l0AA5: db 0x8B,0xF8                          ; mov di,ax                           
l0AA7: db 0x80,0xBF,0x37,0x2A,0x01           ; cmp byte [bx+0x2a37],0x1            
l0AAC: db 0x74,0x12                          ; jz 0xac0                            
l0AAE: db 0x8B,0xC7                          ; mov ax,di                           
l0AB0: db 0x8A,0xA7,0x31,0x2A                ; mov ah,[bx+0x2a31]                  
l0AB4: db 0x80,0xF4,0x20                     ; xor ah,0x20                         
l0AB7: db 0xA9,0xFE,0xFF                     ; test ax,0xfffe                      
l0ABA: db 0x74,0x04                          ; jz 0xac0                            
l0ABC: db 0xD0,0xA5,0x2A,0x2D                ; shl byte [di+0x2d2a],0x0            
l0AC0: db 0x81,0xF7,0x01,0x00                ; xor di,0x1                          
l0AC4: db 0xC6,0x85,0x2A,0x2D,0x00           ; mov byte [di+0x2d2a],0x0            
l0AC9: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0ACC: db 0xBD,0x00,0x00                     ; mov bp,0x0                          
l0ACF: db 0xBE,0x2A,0x2D                     ; mov si,0x2d2a                       
l0AD2: db 0xB4,0x00                          ; mov ah,0x0                          
l0AD4: db 0xAC                               ; lodsb                               
l0AD5: db 0x03,0xE8                          ; add bp,ax                           
l0AD7: db 0xE2,0xFB                          ; loop 0xad4                          
l0AD9: db 0xE8,0x15,0x00                     ; call 0xaf1                          
l0ADC: db 0xF7,0xE5                          ; mul bp                              
l0ADE: db 0xBE,0x2A,0x2D                     ; mov si,0x2d2a                       
l0AE1: db 0xB4,0x00                          ; mov ah,0x0                          
l0AE3: db 0xAC                               ; lodsb                               
l0AE4: db 0x2B,0xD0                          ; sub dx,ax                           
l0AE6: db 0x7D,0xFB                          ; jnl 0xae3                           
l0AE8: db 0xB8,0x2B,0x2D                     ; mov ax,0x2d2b                       
l0AEB: db 0xF7,0xD8                          ; neg ax                              
l0AED: db 0x03,0xC6                          ; add ax,si                           
l0AEF: db 0x07                               ; pop es                              
l0AF0: db 0xC3                               ; ret                                 
l0AF1: db 0xA1,0x24,0x2D                     ; mov ax,[0x2d24]                     
l0AF4: db 0xBA,0xDD,0x98                     ; mov dx,0x98dd                       
l0AF7: db 0xF7,0xE2                          ; mul dx                              
l0AF9: db 0x05,0xEF,0xD5                     ; add ax,0xd5ef                       
l0AFC: db 0xA3,0x24,0x2D                     ; mov [0x2d24],ax                     
l0AFF: db 0xC3                               ; ret                                 
l0B00: db 0x03,0xF0                          ; add si,ax                           
l0B02: db 0xFC                               ; cld                                 
l0B03: db 0xA5                               ; movsw                               
l0B04: db 0xA5                               ; movsw                               
l0B05: db 0xE2,0xFC                          ; loop 0xb03                          
l0B07: db 0xC3                               ; ret                                 
l0B08: db 0xC6,0x06,0x93,0x2F,0x18           ; mov byte [0x2f93],0x18              
l0B0D: db 0xA0,0xF0,0x06                     ; mov al,[0x6f0]                      
l0B10: db 0xB4,0x00                          ; mov ah,0x0                          
l0B12: db 0xFE,0xC0                          ; inc al                              
l0B14: db 0xA2,0xF0,0x06                     ; mov [0x6f0],al                      
l0B17: db 0x8B,0xF8                          ; mov di,ax                           
l0B19: db 0xD1,0xE7                          ; shl di,0x0                          
l0B1B: db 0xD1,0xE7                          ; shl di,0x0                          
l0B1D: db 0x03,0xF8                          ; add di,ax                           
l0B1F: db 0xD1,0xE7                          ; shl di,0x0                          
l0B21: db 0xD1,0xE7                          ; shl di,0x0                          
l0B23: db 0xD1,0xE7                          ; shl di,0x0                          
l0B25: db 0xD1,0xE7                          ; shl di,0x0                          
l0B27: db 0xD1,0xE7                          ; shl di,0x0                          
l0B29: db 0xD1,0xE7                          ; shl di,0x0                          
l0B2B: db 0xD1,0xE7                          ; shl di,0x0                          
l0B2D: db 0xF7,0xDF                          ; neg di                              
l0B2F: db 0x81,0xC7,0xBB,0x21                ; add di,0x21bb                       
l0B33: db 0xBE,0x59,0x1F                     ; mov si,0x1f59                       
l0B36: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l0B39: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l0B3C: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l0B3F: db 0xFC                               ; cld                                 
l0B40: db 0xA5                               ; movsw                               
l0B41: db 0xA5                               ; movsw                               
l0B42: db 0x03,0xFA                          ; add di,dx                           
l0B44: db 0x87,0xD5                          ; xchg dx,bp                          
l0B46: db 0xE2,0xF8                          ; loop 0xb40                          
l0B48: db 0xC3                               ; ret                                 
l0B49: db 0xE9,0x8E,0x00                     ; jmp 0xbda                           
l0B4C: db 0xC6,0x06,0x44,0x2F,0x00           ; mov byte [0x2f44],0x0               
l0B51: db 0x80,0x3E,0x43,0x2F,0x02           ; cmp byte [0x2f43],0x2               
l0B56: db 0x75,0xF1                          ; jnz 0xb49                           
l0B58: db 0x81,0x3E,0x2E,0x2A,0x86,0x2E      ; cmp word [0x2a2e],0x2e86            
l0B5E: db 0x75,0xE9                          ; jnz 0xb49                           
l0B60: db 0xC6,0x06,0x92,0x2F,0x09           ; mov byte [0x2f92],0x9               
l0B65: db 0xC6,0x06,0x43,0x2F,0x01           ; mov byte [0x2f43],0x1               
l0B6A: db 0xC7,0x06,0x3E,0x2F,0x3C,0x00      ; mov word [0x2f3e],0x3c              
l0B70: db 0x06                               ; push es                             
l0B71: db 0x1E                               ; push ds                             
l0B72: db 0x07                               ; pop es                              
l0B73: db 0xBF,0x45,0x2F                     ; mov di,0x2f45                       
l0B76: db 0x8B,0x1E,0x41,0x2F                ; mov bx,[0x2f41]                     
l0B7A: db 0xBD,0x03,0x00                     ; mov bp,0x3                          
l0B7D: db 0x80,0x3F,0x00                     ; cmp byte [bx],0x0                   
l0B80: db 0x75,0x12                          ; jnz 0xb94                           
l0B82: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0B85: db 0xFC                               ; cld                                 
l0B86: db 0xAB                               ; stosw                               
l0B87: db 0xAB                               ; stosw                               
l0B88: db 0x43                               ; inc bx                              
l0B89: db 0x4D                               ; dec bp                              
l0B8A: db 0x83,0xC7,0x1E                     ; add di,0x1e                         
l0B8D: db 0xFC                               ; cld                                 
l0B8E: db 0xAB                               ; stosw                               
l0B8F: db 0xAB                               ; stosw                               
l0B90: db 0xAB                               ; stosw                               
l0B91: db 0x83,0xEF,0x24                     ; sub di,0x24                         
l0B94: db 0x8A,0x07                          ; mov al,[bx]                         
l0B96: db 0x43                               ; inc bx                              
l0B97: db 0xB4,0x00                          ; mov ah,0x0                          
l0B99: db 0x8B,0xF0                          ; mov si,ax                           
l0B9B: db 0xD1,0xE6                          ; shl si,0x0                          
l0B9D: db 0xD1,0xE6                          ; shl si,0x0                          
l0B9F: db 0xD1,0xE6                          ; shl si,0x0                          
l0BA1: db 0x81,0xC6,0x06,0x2F                ; add si,0x2f06                       
l0BA5: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0BA8: db 0xF3,0xA5                          ; rep movsw                           
l0BAA: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0BAD: db 0xAB                               ; stosw                               
l0BAE: db 0x4D                               ; dec bp                              
l0BAF: db 0x75,0xE3                          ; jnz 0xb94                           
l0BB1: db 0xBE,0x06,0x2F                     ; mov si,0x2f06                       
l0BB4: db 0xB9,0x04,0x00                     ; mov cx,0x4                          
l0BB7: db 0xF3,0xA5                          ; rep movsw                           
l0BB9: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0BBC: db 0xAB                               ; stosw                               
l0BBD: db 0x07                               ; pop es                              
l0BBE: db 0x83,0xEB,0x03                     ; sub bx,0x3                          
l0BC1: db 0xBA,0x03,0x00                     ; mov dx,0x3                          
l0BC4: db 0x8A,0xE2                          ; mov ah,dl                           
l0BC6: db 0xF6,0xDC                          ; neg ah                              
l0BC8: db 0x80,0xC4,0x05                     ; add ah,0x5                          
l0BCB: db 0x8A,0x07                          ; mov al,[bx]                         
l0BCD: db 0xE8,0x5A,0x02                     ; call 0xe2a                          
l0BD0: db 0x43                               ; inc bx                              
l0BD1: db 0x4A                               ; dec dx                              
l0BD2: db 0x75,0xF0                          ; jnz 0xbc4                           
l0BD4: db 0xC6,0x06,0x44,0x2F,0x02           ; mov byte [0x2f44],0x2               
l0BD9: db 0xC3                               ; ret                                 
l0BDA: db 0x80,0x3E,0x43,0x2F,0x00           ; cmp byte [0x2f43],0x0               
l0BDF: db 0x75,0x58                          ; jnz 0xc39                           
l0BE1: db 0xA0,0x99,0x2C                     ; mov al,[0x2c99]                     
l0BE4: db 0x3A,0x06,0x40,0x2F                ; cmp al,[0x2f40]                     
l0BE8: db 0x74,0x08                          ; jz 0xbf2                            
l0BEA: db 0x3C,0xAA                          ; cmp al,0xaa                         
l0BEC: db 0x74,0x05                          ; jz 0xbf3                            
l0BEE: db 0x3C,0x50                          ; cmp al,0x50                         
l0BF0: db 0x74,0x01                          ; jz 0xbf3                            
l0BF2: db 0xC3                               ; ret                                 
l0BF3: db 0xA2,0x40,0x2F                     ; mov [0x2f40],al                     
l0BF6: db 0xC6,0x06,0x43,0x2F,0x02           ; mov byte [0x2f43],0x2               
l0BFB: db 0xC7,0x06,0x3E,0x2F,0x87,0x00      ; mov word [0x2f3e],0x87              
l0C01: db 0xC6,0x06,0x44,0x2F,0x03           ; mov byte [0x2f44],0x3               
l0C06: db 0xBF,0x45,0x2F                     ; mov di,0x2f45                       
l0C09: db 0xA1,0xF1,0x06                     ; mov ax,[0x6f1]                      
l0C0C: db 0x48                               ; dec ax                              
l0C0D: db 0x3D,0x08,0x00                     ; cmp ax,0x8                          
l0C10: db 0x7C,0x0D                          ; jl 0xc1f                            
l0C12: db 0xE8,0xDC,0xFE                     ; call 0xaf1                          
l0C15: db 0xB0,0x00                          ; mov al,0x0                          
l0C17: db 0xD1,0xC0                          ; rol ax,0x0                          
l0C19: db 0xD1,0xC0                          ; rol ax,0x0                          
l0C1B: db 0xD1,0xC0                          ; rol ax,0x0                          
l0C1D: db 0xB4,0x00                          ; mov ah,0x0                          
l0C1F: db 0xBA,0x3B,0x00                     ; mov dx,0x3b                         
l0C22: db 0xF7,0xE2                          ; mul dx                              
l0C24: db 0x05,0x2E,0x2D                     ; add ax,0x2d2e                       
l0C27: db 0xA3,0x41,0x2F                     ; mov [0x2f41],ax                     
l0C2A: db 0x8B,0xF0                          ; mov si,ax                           
l0C2C: db 0x83,0xC6,0x03                     ; add si,0x3                          
l0C2F: db 0xB9,0x1C,0x00                     ; mov cx,0x1c                         
l0C32: db 0x06                               ; push es                             
l0C33: db 0x1E                               ; push ds                             
l0C34: db 0x07                               ; pop es                              
l0C35: db 0xF3,0xA5                          ; rep movsw                           
l0C37: db 0x07                               ; pop es                              
l0C38: db 0xC3                               ; ret                                 
l0C39: db 0xFF,0x0E,0x3E,0x2F                ; dec word [0x2f3e]                   
l0C3D: db 0x74,0x01                          ; jz 0xc40                            
l0C3F: db 0xC3                               ; ret                                 
l0C40: db 0xC6,0x06,0x43,0x2F,0x00           ; mov byte [0x2f43],0x0               
l0C45: db 0xC7,0x06,0x3E,0x2F,0x0E,0x01      ; mov word [0x2f3e],0x10e             
l0C4B: db 0xC6,0x06,0x44,0x2F,0x01           ; mov byte [0x2f44],0x1               
l0C50: db 0xC3                               ; ret                                 
l0C51: db 0xFC                               ; cld                                 
l0C52: db 0x80,0x3E,0x44,0x2F,0x02           ; cmp byte [0x2f44],0x2               
l0C57: db 0x7F,0x35                          ; jg 0xc8e                            
l0C59: db 0x74,0x18                          ; jz 0xc73                            
l0C5B: db 0xBF,0xE6,0x0D                     ; mov di,0xde6                        
l0C5E: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0C61: db 0xB9,0x14,0x00                     ; mov cx,0x14                         
l0C64: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l0C67: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l0C6A: db 0xAB                               ; stosw                               
l0C6B: db 0xAB                               ; stosw                               
l0C6C: db 0x03,0xFA                          ; add di,dx                           
l0C6E: db 0x87,0xD5                          ; xchg dx,bp                          
l0C70: db 0xE2,0xF8                          ; loop 0xc6a                          
l0C72: db 0xC3                               ; ret                                 
l0C73: db 0xBF,0xE6,0x0D                     ; mov di,0xde6                        
l0C76: db 0xBE,0x45,0x2F                     ; mov si,0x2f45                       
l0C79: db 0xB9,0x14,0x00                     ; mov cx,0x14                         
l0C7C: db 0xBA,0xFC,0x1F                     ; mov dx,0x1ffc                       
l0C7F: db 0xBD,0x4C,0xE0                     ; mov bp,0xe04c                       
l0C82: db 0xB0,0x00                          ; mov al,0x0                          
l0C84: db 0xAA                               ; stosb                               
l0C85: db 0xA5                               ; movsw                               
l0C86: db 0xAA                               ; stosb                               
l0C87: db 0x03,0xFA                          ; add di,dx                           
l0C89: db 0x87,0xD5                          ; xchg dx,bp                          
l0C8B: db 0xE2,0xF7                          ; loop 0xc84                          
l0C8D: db 0xC3                               ; ret                                 
l0C8E: db 0xBF,0x86,0x2E                     ; mov di,0x2e86                       
l0C91: db 0xBE,0x45,0x2F                     ; mov si,0x2f45                       
l0C94: db 0xB9,0x0E,0x00                     ; mov cx,0xe                          
l0C97: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l0C9A: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l0C9D: db 0xA5                               ; movsw                               
l0C9E: db 0xA5                               ; movsw                               
l0C9F: db 0x03,0xFA                          ; add di,dx                           
l0CA1: db 0x87,0xD5                          ; xchg dx,bp                          
l0CA3: db 0xE2,0xF8                          ; loop 0xc9d                          
l0CA5: db 0xC3                               ; ret                                 
l0CA6: db 0xFC                               ; cld                                 
l0CA7: db 0x8B,0x3E,0x8D,0x2F                ; mov di,[0x2f8d]                     
l0CAB: db 0x8A,0x85,0xF1,0x25                ; mov al,[di+0x25f1]                  
l0CAF: db 0xB4,0x03                          ; mov ah,0x3                          
l0CB1: db 0xE8,0x76,0x01                     ; call 0xe2a                          
l0CB4: db 0xC6,0x87,0x38,0x2A,0x06           ; mov byte [bx+0x2a38],0x6            
l0CB9: db 0x03,0xF3                          ; add si,bx                           
l0CBB: db 0x8B,0xBF,0x2E,0x2A                ; mov di,[bx+0x2a2e]                  
l0CBF: db 0x8A,0x8F,0x35,0x2A                ; mov cl,[bx+0x2a35]                  
l0CC3: db 0xE8,0x7E,0x00                     ; call 0xd44                          
l0CC6: db 0x8B,0x3E,0x2E,0x2A                ; mov di,[0x2a2e]                     
l0CCA: db 0x8A,0x0E,0x35,0x2A                ; mov cl,[0x2a35]                     
l0CCE: db 0xE8,0x73,0x00                     ; call 0xd44                          
l0CD1: db 0xE8,0x2E,0x00                     ; call 0xd02                          
l0CD4: db 0xB0,0x02                          ; mov al,0x2                          
l0CD6: db 0xE6,0x42                          ; out byte 0x42,al                    
l0CD8: db 0x32,0xC0                          ; xor al,al                           
l0CDA: db 0xE6,0x42                          ; out byte 0x42,al                    
l0CDC: db 0xBE,0xF6,0x2F                     ; mov si,0x2ff6                       
l0CDF: db 0xBD,0x18,0x00                     ; mov bp,0x18                         
l0CE2: db 0xFC                               ; cld                                 
l0CE3: db 0xAD                               ; lodsw                               
l0CE4: db 0x80,0x3E,0xA0,0x2F,0x00           ; cmp byte [0x2fa0],0x0               
l0CE9: db 0x7C,0x06                          ; jl 0xcf1                            
l0CEB: db 0xE6,0x42                          ; out byte 0x42,al                    
l0CED: db 0x8A,0xC4                          ; mov al,ah                           
l0CEF: db 0xE6,0x42                          ; out byte 0x42,al                    
l0CF1: db 0xB9,0x0A,0x14                     ; mov cx,0x140a                       
l0CF4: db 0xE2,0xFE                          ; loop 0xcf4                          
l0CF6: db 0x4D                               ; dec bp                              
l0CF7: db 0x75,0xEA                          ; jnz 0xce3                           
l0CF9: db 0xE8,0x06,0x00                     ; call 0xd02                          
l0CFC: db 0x83,0x06,0x8D,0x2F,0x21           ; add word [0x2f8d],0x21              
l0D01: db 0xC3                               ; ret                                 
l0D02: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l0D05: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l0D08: db 0x8B,0x3E,0x2E,0x2A                ; mov di,[0x2a2e]                     
l0D0C: db 0x03,0xBF,0x2E,0x2A                ; add di,[bx+0x2a2e]                  
l0D10: db 0xD1,0xFF                          ; sar di,0x0                          
l0D12: db 0x81,0xC7,0xA0,0x00                ; add di,0xa0                         
l0D16: db 0xBE,0xF2,0x25                     ; mov si,0x25f2                       
l0D19: db 0x03,0x36,0x8D,0x2F                ; add si,[0x2f8d]                     
l0D1D: db 0x8A,0x0E,0x35,0x2A                ; mov cl,[0x2a35]                     
l0D21: db 0x02,0x8F,0x35,0x2A                ; add cl,[bx+0x2a35]                  
l0D25: db 0xD0,0xF9                          ; sar cl,0x0                          
l0D27: db 0xB5,0x00                          ; mov ch,0x0                          
l0D29: db 0xE3,0x18                          ; jcxz 0xd43                          
l0D2B: db 0x83,0xF9,0x08                     ; cmp cx,0x8                          
l0D2E: db 0x7E,0x03                          ; jng 0xd33                           
l0D30: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0D33: db 0xAD                               ; lodsw                               
l0D34: db 0x26,0x33,0x05                     ; xor ax,[es:di]                      
l0D37: db 0xAB                               ; stosw                               
l0D38: db 0xAD                               ; lodsw                               
l0D39: db 0x26,0x33,0x05                     ; xor ax,[es:di]                      
l0D3C: db 0xAB                               ; stosw                               
l0D3D: db 0x03,0xFA                          ; add di,dx                           
l0D3F: db 0x87,0xD5                          ; xchg dx,bp                          
l0D41: db 0xE2,0xF0                          ; loop 0xd33                          
l0D43: db 0xC3                               ; ret                                 
l0D44: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0D47: db 0xBA,0x4C,0xE0                     ; mov dx,0xe04c                       
l0D4A: db 0xBD,0xFC,0x1F                     ; mov bp,0x1ffc                       
l0D4D: db 0xB5,0x00                          ; mov ch,0x0                          
l0D4F: db 0xE3,0x08                          ; jcxz 0xd59                          
l0D51: db 0xAB                               ; stosw                               
l0D52: db 0xAB                               ; stosw                               
l0D53: db 0x03,0xFA                          ; add di,dx                           
l0D55: db 0x87,0xD5                          ; xchg dx,bp                          
l0D57: db 0xE2,0xF8                          ; loop 0xd51                          
l0D59: db 0xC3                               ; ret                                 
l0D5A: db 0x58                               ; pop ax                              
l0D5B: db 0x58                               ; pop ax                              
l0D5C: db 0xC3                               ; ret                                 
l0D5D: db 0xB4,0x01                          ; mov ah,0x1                          
l0D5F: db 0xCD,0x16                          ; int byte 0x16                       
l0D61: db 0x74,0x5C                          ; jz 0xdbf                            
l0D63: db 0xE8,0x4A,0x02                     ; call 0xfb0                          
l0D66: db 0x90                               ; nop                                 
l0D67: db 0x3D,0x00,0x00                     ; cmp ax,0x0                          
l0D6A: db 0x74,0xEE                          ; jz 0xd5a                            
l0D6C: db 0x3C,0x13                          ; cmp al,0x13                         
l0D6E: db 0x75,0x04                          ; jnz 0xd74                           
l0D70: db 0xF6,0x1E,0xA0,0x2F                ; neg byte [0x2fa0]                   
l0D74: db 0x80,0x3E,0x8F,0x2F,0x01           ; cmp byte [0x2f8f],0x1               
l0D79: db 0x74,0x44                          ; jz 0xdbf                            
l0D7B: db 0x24,0xDF                          ; and al,0xdf                         
l0D7D: db 0xB3,0x00                          ; mov bl,0x0                          
l0D7F: db 0x80,0xFC,0x48                     ; cmp ah,0x48                         
l0D82: db 0x74,0x36                          ; jz 0xdba                            
l0D84: db 0x3C,0x45                          ; cmp al,0x45                         
l0D86: db 0x74,0x32                          ; jz 0xdba                            
l0D88: db 0x3C,0x49                          ; cmp al,0x49                         
l0D8A: db 0x74,0x2E                          ; jz 0xdba                            
l0D8C: db 0xFE,0xC3                          ; inc bl                              
l0D8E: db 0x80,0xFC,0x50                     ; cmp ah,0x50                         
l0D91: db 0x74,0x27                          ; jz 0xdba                            
l0D93: db 0x3C,0x4A                          ; cmp al,0x4a                         
l0D95: db 0x74,0x23                          ; jz 0xdba                            
l0D97: db 0x3C,0x44                          ; cmp al,0x44                         
l0D99: db 0x74,0x1F                          ; jz 0xdba                            
l0D9B: db 0xFE,0xC3                          ; inc bl                              
l0D9D: db 0x80,0xFC,0x4B                     ; cmp ah,0x4b                         
l0DA0: db 0x74,0x18                          ; jz 0xdba                            
l0DA2: db 0x3C,0x41                          ; cmp al,0x41                         
l0DA4: db 0x74,0x14                          ; jz 0xdba                            
l0DA6: db 0x3C,0x4B                          ; cmp al,0x4b                         
l0DA8: db 0x74,0x10                          ; jz 0xdba                            
l0DAA: db 0xFE,0xC3                          ; inc bl                              
l0DAC: db 0x80,0xFC,0x4D                     ; cmp ah,0x4d                         
l0DAF: db 0x74,0x09                          ; jz 0xdba                            
l0DB1: db 0x3C,0x4C                          ; cmp al,0x4c                         
l0DB3: db 0x74,0x05                          ; jz 0xdba                            
l0DB5: db 0x3C,0x53                          ; cmp al,0x53                         
l0DB7: db 0x74,0x01                          ; jz 0xdba                            
l0DB9: db 0xC3                               ; ret                                 
l0DBA: db 0x88,0x1E,0xBC,0x2C                ; mov [0x2cbc],bl                     
l0DBE: db 0xC3                               ; ret                                 
l0DBF: db 0x80,0x3E,0x8F,0x2F,0x01           ; cmp byte [0x2f8f],0x1               
l0DC4: db 0x75,0xF3                          ; jnz 0xdb9                           
l0DC6: db 0xA0,0x2D,0x2A                     ; mov al,[0x2a2d]                     
l0DC9: db 0xA2,0xBC,0x2C                     ; mov [0x2cbc],al                     
l0DCC: db 0xFA                               ; cli                                 
l0DCD: db 0xBA,0x01,0x02                     ; mov dx,0x201                        
l0DD0: db 0xB9,0x90,0x01                     ; mov cx,0x190                        
l0DD3: db 0xB0,0xFF                          ; mov al,0xff                         
l0DD5: db 0xB4,0x01                          ; mov ah,0x1                          
l0DD7: db 0xEE                               ; out dx,al                           
l0DD8: db 0xEC                               ; in al,dx                            
l0DD9: db 0x22,0xC4                          ; and al,ah                           
l0DDB: db 0xE0,0xFB                          ; loopne 0xdd8                        
l0DDD: db 0x8B,0xD9                          ; mov bx,cx                           
l0DDF: db 0xE3,0x05                          ; jcxz 0xde6                          
l0DE1: db 0x90                               ; nop                                 
l0DE2: db 0x90                               ; nop                                 
l0DE3: db 0x90                               ; nop                                 
l0DE4: db 0xE2,0xFB                          ; loop 0xde1                          
l0DE6: db 0x81,0xC3,0xCA,0xFE                ; add bx,0xfeca                       
l0DEA: db 0xB9,0x90,0x01                     ; mov cx,0x190                        
l0DED: db 0xB0,0xFF                          ; mov al,0xff                         
l0DEF: db 0xB4,0x02                          ; mov ah,0x2                          
l0DF1: db 0xEE                               ; out dx,al                           
l0DF2: db 0xEC                               ; in al,dx                            
l0DF3: db 0x22,0xC4                          ; and al,ah                           
l0DF5: db 0xE0,0xFB                          ; loopne 0xdf2                        
l0DF7: db 0xFB                               ; sti                                 
l0DF8: db 0x81,0xC1,0xBE,0xFE                ; add cx,0xfebe                       
l0DFC: db 0xF7,0xD9                          ; neg cx                              
l0DFE: db 0x8B,0xD1                          ; mov dx,cx                           
l0E00: db 0x03,0xCB                          ; add cx,bx                           
l0E02: db 0x8B,0xF1                          ; mov si,cx                           
l0E04: db 0x7D,0x02                          ; jnl 0xe08                           
l0E06: db 0xF7,0xDE                          ; neg si                              
l0E08: db 0x2B,0xD3                          ; sub dx,bx                           
l0E0A: db 0x8B,0xFA                          ; mov di,dx                           
l0E0C: db 0x7D,0x02                          ; jnl 0xe10                           
l0E0E: db 0xF7,0xDF                          ; neg di                              
l0E10: db 0x03,0xF7                          ; add si,di                           
l0E12: db 0x83,0xFE,0x51                     ; cmp si,0x51                         
l0E15: db 0x7C,0xA2                          ; jl 0xdb9                            
l0E17: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0E1A: db 0xD1,0xD1                          ; rcl cx,0x0                          
l0E1C: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0E1E: db 0xD1,0xD2                          ; rcl dx,0x0                          
l0E20: db 0xD1,0xD0                          ; rcl ax,0x0                          
l0E22: db 0x40                               ; inc ax                              
l0E23: db 0x25,0x03,0x00                     ; and ax,0x3                          
l0E26: db 0xA2,0xBC,0x2C                     ; mov [0x2cbc],al                     
l0E29: db 0xC3                               ; ret                                 
l0E2A: db 0x06                               ; push es                             
l0E2B: db 0x1E                               ; push ds                             
l0E2C: db 0x07                               ; pop es                              
l0E2D: db 0xFD                               ; std                                 
l0E2E: db 0x8D,0x3E,0x7E,0x2F                ; lea di,[0x2f7e]                     
l0E32: db 0x8A,0xCC                          ; mov cl,ah                           
l0E34: db 0xB5,0x00                          ; mov ch,0x0                          
l0E36: db 0x03,0xF9                          ; add di,cx                           
l0E38: db 0x02,0x05                          ; add al,[di]                         
l0E3A: db 0xB4,0xFF                          ; mov ah,0xff                         
l0E3C: db 0xFE,0xC4                          ; inc ah                              
l0E3E: db 0x2C,0x0A                          ; sub al,0xa                          
l0E40: db 0x7D,0xFA                          ; jnl 0xe3c                           
l0E42: db 0x04,0x0A                          ; add al,0xa                          
l0E44: db 0xAA                               ; stosb                               
l0E45: db 0x8A,0xC4                          ; mov al,ah                           
l0E47: db 0x3C,0x00                          ; cmp al,0x0                          
l0E49: db 0xE0,0xED                          ; loopne 0xe38                        
l0E4B: db 0xFC                               ; cld                                 
l0E4C: db 0x07                               ; pop es                              
l0E4D: db 0x8B,0xF7                          ; mov si,di                           
l0E4F: db 0xB8,0x7E,0x2F                     ; mov ax,0x2f7e                       
l0E52: db 0x2B,0xC7                          ; sub ax,di                           
l0E54: db 0x75,0x11                          ; jnz 0xe67                           
l0E56: db 0xAC                               ; lodsb                               
l0E57: db 0x3C,0x00                          ; cmp al,0x0                          
l0E59: db 0x75,0x0C                          ; jnz 0xe67                           
l0E5B: db 0x80,0x3C,0x01                     ; cmp byte [si],0x1                   
l0E5E: db 0x75,0x07                          ; jnz 0xe67                           
l0E60: db 0x56                               ; push si                             
l0E61: db 0x52                               ; push dx                             
l0E62: db 0xE8,0xA3,0xFC                     ; call 0xb08                          
l0E65: db 0x5A                               ; pop dx                              
l0E66: db 0x5E                               ; pop si                              
l0E67: db 0xC3                               ; ret                                 
l0E68: db 0xFC                               ; cld                                 
l0E69: db 0x06                               ; push es                             
l0E6A: db 0x1E                               ; push ds                             
l0E6B: db 0x07                               ; pop es                              
l0E6C: db 0x8D,0x36,0x7E,0x2F                ; lea si,[0x2f7e]                     
l0E70: db 0x8D,0x3E,0x88,0x2F                ; lea di,[0x2f88]                     
l0E74: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l0E77: db 0xF3,0xA4                          ; rep movsb                           
l0E79: db 0x07                               ; pop es                              
l0E7A: db 0xBF,0x80,0x02                     ; mov di,0x280                        
l0E7D: db 0xE8,0x34,0x00                     ; call 0xeb4                          
l0E80: db 0x06                               ; push es                             
l0E81: db 0x1E                               ; push ds                             
l0E82: db 0x07                               ; pop es                              
l0E83: db 0x8D,0x36,0x7E,0x2F                ; lea si,[0x2f7e]                     
l0E87: db 0x8D,0x3E,0x83,0x2F                ; lea di,[0x2f83]                     
l0E8B: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l0E8E: db 0xF3,0xA6                          ; repe cmpsb                          
l0E90: db 0x74,0x20                          ; jz 0xeb2                            
l0E92: db 0x4F                               ; dec di                              
l0E93: db 0x4E                               ; dec si                              
l0E94: db 0x8A,0x05                          ; mov al,[di]                         
l0E96: db 0x3A,0x04                          ; cmp al,[si]                         
l0E98: db 0x7F,0x18                          ; jg 0xeb2                            
l0E9A: db 0x41                               ; inc cx                              
l0E9B: db 0xF3,0xA4                          ; rep movsb                           
l0E9D: db 0x8D,0x36,0x83,0x2F                ; lea si,[0x2f83]                     
l0EA1: db 0x8D,0x3E,0x88,0x2F                ; lea di,[0x2f88]                     
l0EA5: db 0xB9,0x05,0x00                     ; mov cx,0x5                          
l0EA8: db 0xF3,0xA4                          ; rep movsb                           
l0EAA: db 0x07                               ; pop es                              
l0EAB: db 0xBF,0x00,0x0A                     ; mov di,0xa00                        
l0EAE: db 0xE8,0x03,0x00                     ; call 0xeb4                          
l0EB1: db 0xC3                               ; ret                                 
l0EB2: db 0x07                               ; pop es                              
l0EB3: db 0xC3                               ; ret                                 
l0EB4: db 0xC6,0x06,0x7D,0x2F,0x01           ; mov byte [0x2f7d],0x1               
l0EB9: db 0xBB,0x00,0x00                     ; mov bx,0x0                          
l0EBC: db 0x8A,0x87,0x88,0x2F                ; mov al,[bx+0x2f88]                  
l0EC0: db 0x3C,0x00                          ; cmp al,0x0                          
l0EC2: db 0x74,0x05                          ; jz 0xec9                            
l0EC4: db 0xC6,0x06,0x7D,0x2F,0x00           ; mov byte [0x2f7d],0x0               
l0EC9: db 0x80,0x3E,0x7D,0x2F,0x00           ; cmp byte [0x2f7d],0x0               
l0ECE: db 0x74,0x16                          ; jz 0xee6                            
l0ED0: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l0ED3: db 0xBD,0x4E,0xE0                     ; mov bp,0xe04e                       
l0ED6: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0ED9: db 0xB8,0x00,0x00                     ; mov ax,0x0                          
l0EDC: db 0xAB                               ; stosw                               
l0EDD: db 0x03,0xFA                          ; add di,dx                           
l0EDF: db 0x87,0xD5                          ; xchg dx,bp                          
l0EE1: db 0xE2,0xF9                          ; loop 0xedc                          
l0EE3: db 0xEB,0x21                          ; jmp 0xf06                           
l0EE5: db 0x90                               ; nop                                 
l0EE6: db 0xBA,0xFE,0x1F                     ; mov dx,0x1ffe                       
l0EE9: db 0xBD,0x4E,0xE0                     ; mov bp,0xe04e                       
l0EEC: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0EEF: db 0xB4,0x00                          ; mov ah,0x0                          
l0EF1: db 0x8B,0xF0                          ; mov si,ax                           
l0EF3: db 0xD1,0xE6                          ; shl si,0x0                          
l0EF5: db 0xD1,0xE6                          ; shl si,0x0                          
l0EF7: db 0xD1,0xE6                          ; shl si,0x0                          
l0EF9: db 0xD1,0xE6                          ; shl si,0x0                          
l0EFB: db 0x81,0xC6,0x41,0x25                ; add si,0x2541                       
l0EFF: db 0xA5                               ; movsw                               
l0F00: db 0x03,0xFA                          ; add di,dx                           
l0F02: db 0x87,0xD5                          ; xchg dx,bp                          
l0F04: db 0xE2,0xF9                          ; loop 0xeff                          
l0F06: db 0x81,0xC7,0xC2,0xFE                ; add di,0xfec2                       
l0F0A: db 0x43                               ; inc bx                              
l0F0B: db 0x83,0xFB,0x05                     ; cmp bx,0x5                          
l0F0E: db 0x7C,0xAC                          ; jl 0xebc                            
l0F10: db 0xC3                               ; ret                                 
l0F11: db 0x06                               ; push es                             
l0F12: db 0x8C,0xD8                          ; mov ax,ds                           
l0F14: db 0x8E,0xC0                          ; mov es,ax                           
l0F16: db 0xB9,0x08,0x00                     ; mov cx,0x8                          
l0F19: db 0xBF,0x90,0x2F                     ; mov di,0x2f90                       
l0F1C: db 0xBE,0x00,0x00                     ; mov si,0x0                          
l0F1F: db 0xB4,0x00                          ; mov ah,0x0                          
l0F21: db 0xFC                               ; cld                                 
l0F22: db 0xB0,0x00                          ; mov al,0x0                          
l0F24: db 0xF3,0xAE                          ; repe scasb                          
l0F26: db 0x74,0x10                          ; jz 0xf38                            
l0F28: db 0x8A,0x45,0xFF                     ; mov al,[di-0x1]                     
l0F2B: db 0xFE,0xC8                          ; dec al                              
l0F2D: db 0x8A,0xE0                          ; mov ah,al                           
l0F2F: db 0x88,0x45,0xFF                     ; mov [di-0x1],al                     
l0F32: db 0x8B,0xF7                          ; mov si,di                           
l0F34: db 0xE3,0x02                          ; jcxz 0xf38                          
l0F36: db 0xEB,0xEA                          ; jmp 0xf22                           
l0F38: db 0x07                               ; pop es                              
l0F39: db 0x83,0xFE,0x00                     ; cmp si,0x0                          
l0F3C: db 0x74,0x12                          ; jz 0xf50                            
l0F3E: db 0xBB,0x90,0x2F                     ; mov bx,0x2f90                       
l0F41: db 0x2B,0xF3                          ; sub si,bx                           
l0F43: db 0xD1,0xE6                          ; shl si,0x0                          
l0F45: db 0x80,0x3E,0xA0,0x2F,0x00           ; cmp byte [0x2fa0],0x0               
l0F4A: db 0x7C,0x04                          ; jl 0xf50                            
l0F4C: db 0xFF,0xA4,0x96,0x2F                ; jmp word near [si+0x2f96]           
l0F50: db 0xB8,0x02,0x00                     ; mov ax,0x2                          
l0F53: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F55: db 0x8A,0xC4                          ; mov al,ah                           
l0F57: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F59: db 0xC3                               ; ret                                 
l0F5A: db 0xF6,0xC4,0x01                     ; test ah,0x1                         
l0F5D: db 0x74,0xF1                          ; jz 0xf50                            
l0F5F: db 0xB8,0x90,0x01                     ; mov ax,0x190                        
l0F62: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F64: db 0x8A,0xC4                          ; mov al,ah                           
l0F66: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F68: db 0xC3                               ; ret                                 
l0F69: db 0x8A,0xDC                          ; mov bl,ah                           
l0F6B: db 0xB7,0x00                          ; mov bh,0x0                          
l0F6D: db 0xD1,0xE3                          ; shl bx,0x0                          
l0F6F: db 0x8B,0x87,0xA2,0x2F                ; mov ax,[bx+0x2fa2]                  
l0F73: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F75: db 0x8A,0xC4                          ; mov al,ah                           
l0F77: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F79: db 0xC3                               ; ret                                 
l0F7A: db 0x8A,0xDC                          ; mov bl,ah                           
l0F7C: db 0xB7,0x00                          ; mov bh,0x0                          
l0F7E: db 0xD1,0xE3                          ; shl bx,0x0                          
l0F80: db 0x8B,0x87,0xC4,0x2F                ; mov ax,[bx+0x2fc4]                  
l0F84: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F86: db 0x8A,0xC4                          ; mov al,ah                           
l0F88: db 0xE6,0x42                          ; out byte 0x42,al                    
l0F8A: db 0xC3                               ; ret                                 
l0F8B: db 0xA0,0xA1,0x2F                     ; mov al,[0x2fa1]                     
l0F8E: db 0xFE,0xC0                          ; inc al                              
l0F90: db 0x3C,0x08                          ; cmp al,0x8                          
l0F92: db 0x7C,0x02                          ; jl 0xf96                            
l0F94: db 0xB0,0x00                          ; mov al,0x0                          
l0F96: db 0xA2,0xA1,0x2F                     ; mov [0x2fa1],al                     
l0F99: db 0x8A,0xD8                          ; mov bl,al                           
l0F9B: db 0xB7,0x00                          ; mov bh,0x0                          
l0F9D: db 0xD1,0xE3                          ; shl bx,0x0                          
l0F9F: db 0x8B,0x87,0xB4,0x2F                ; mov ax,[bx+0x2fb4]                  
l0FA3: db 0xE6,0x42                          ; out byte 0x42,al                    
l0FA5: db 0x8A,0xC4                          ; mov al,ah                           
l0FA7: db 0xE6,0x42                          ; out byte 0x42,al                    
l0FA9: db 0xC3                               ; ret                                 

		db	6 dup (0)	; Pad to paragraph boundary

; This code was added as part of the conversion from the original disk
; booter to a DOS .COM version.

; Read a keystroke and return it in AL. If the Esc key is pressed,
; silence the speaker, reset the video mode, and exit to DOS.
chk_esc_key:	mov	ah,0		; Get keypress
		int	16h
		cmp	al,1bh		; Check for Esc key
		jz 	reset_video	; Quit if pressed
		ret

; Turns off the speaker, resets the video mode, and exits to DOS.
reset_video:	mov	al,4dh		; Silence the speaker
		out	61h,al
		mov	ax,3		; Reset to 80x25 colour text mode
		int	10h

; Exits to DOS.
exit_to_dos:	mov	ax,4c00h
		int	21h
		hlt

		align	16		; 9 bytes

; Checks the equipment list for 80x25 color.
;
; This is an idiotic check since this program would run normally on a 40x25
; colour system.
chk_equip:	int	11h
		and	al,30h		; Mask off everything but video bits
		cmp	al,20h		; Check for 80x25 colour mode.
		jnz	exit_to_dos	; Quit if not present.
		ret

; This pads the size of our image to 4,080 byte (4,096 bytes with the relocator
; stub header).
trailer:	db	23 dup (90h)
