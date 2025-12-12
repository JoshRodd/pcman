org 100h

mov ax,cs	; 00000000  8CC8                              
db 5 ; add ax,imm byte
dw 10h ; byte 10h
;add ax,0x10	; 00000002  051000                            
push ax	; 00000005  50                                
add ax,0x100	; 00000006  050001                            
mov ds,ax	; 00000009  8ED8                              
mov ax,0x13	; 0000000B  B81300                            
push ax	; 0000000E  50                                
retf	; 0000000F  CB                                
nop	; 00000010  90                                
nop	; 00000011  90                                
nop	; 00000012  90                                
call 0xfe0	; 00000013  E8CA0F                            
mov ax,0xb800	; 00000016  B800B8                            
mov es,ax	; 00000019  8EC0                              
mov al,0x4f	; 0000001B  B04F                              
out byte 0x61,al	; 0000001D  E661                              
mov al,0xb6	; 0000001F  B0B6                              
out byte 0x43,al	; 00000021  E643                              
mov ax,0x4	; 00000023  B80400                            
int byte 0x10	; 00000026  CD10                              
mov dx,0x3d9	; 00000028  BAD903                            
mov al,0x10	; 0000002B  B010                              
out dx,al	; 0000002D  EE                                
mov dl,0x3	; 0000002E  B203                              
call 0x121	; 00000030  E8EE00                            
mov di,0x150	; 00000033  BF5001                            
mov si,0x0	; 00000036  BE0000                            
mov bx,0xfff4	; 00000039  BBF4FF                            
mov cx,0x17	; 0000003C  B91700                            
mov dx,0x1ff7	; 0000003F  BAF71F                            
mov bp,0xe047	; 00000042  BD47E0                            
cld	; 00000045  FC                                
movsw	; 00000046  A5                                
movsw	; 00000047  A5                                
movsw	; 00000048  A5                                
movsw	; 00000049  A5                                
movsb	; 0000004A  A4                                
add di,dx	; 0000004B  03FA                              
xchg dx,bp	; 0000004D  87D5                              
loop 0x46	; 0000004F  E2F5                              
sub di,0x2370	; 00000051  81EF7023                          
add di,[bx+0x4e6]	; 00000055  03BFE604                          
add bx,0x2	; 00000059  83C302                            
jnz 0x3c	; 0000005C  75DE                              
mov si,0x4e6	; 0000005E  BEE604                            
mov bp,0x112	; 00000061  BD1201                            
mov ah,0x0	; 00000064  B400                              
int byte 0x1a	; 00000066  CD1A                              
mov bx,dx	; 00000068  8BDA                              
mov ah,0x0	; 0000006A  B400                              
int byte 0x1a	; 0000006C  CD1A                              
cmp bx,dx	; 0000006E  3BDA                              
jz 0x6a	; 00000070  74F8                              
mov ah,0x1	; 00000072  B401                              
int byte 0x16	; 00000074  CD16                              
jz 0x84	; 00000076  740C                              
call 0xfc0	; 00000078  E8450F                            
nop	; 0000007B  90                                
cmp al,0x13	; 0000007C  3C13                              
jnz 0x84	; 0000007E  7504                              
neg byte [0x2fa0]	; 00000080  F61EA02F                          
lodsw	; 00000084  AD                                
cmp byte [0x2fa0],0x0	; 00000085  803EA02F00                        
jg 0x92	; 0000008A  7F06                              
call 0xf60	; 0000008C  E8D10E                            
jmp 0x98	; 0000008F  EB07                              
nop	; 00000091  90                                
out byte 0x42,al	; 00000092  E642                              
mov al,ah	; 00000094  8AC4                              
out byte 0x42,al	; 00000096  E642                              
sub bp,0x2	; 00000098  83ED02                            
jnz 0x64	; 0000009B  75C7                              
mov dl,0x3	; 0000009D  B203                              
call 0x121	; 0000009F  E87F00                            
mov cx,0x5	; 000000A2  B90500                            
mov si,0x5f8	; 000000A5  BEF805                            
cld	; 000000A8  FC                                
lodsw	; 000000A9  AD                                
mov dx,ax	; 000000AA  8BD0                              
mov bh,0x0	; 000000AC  B700                              
mov ah,0x2	; 000000AE  B402                              
int byte 0x10	; 000000B0  CD10                              
lodsb	; 000000B2  AC                                
cmp al,0x0	; 000000B3  3C00                              
jz 0xc0	; 000000B5  7409                              
mov bx,0x2	; 000000B7  BB0200                            
mov ah,0xe	; 000000BA  B40E                              
int byte 0x10	; 000000BC  CD10                              
jmp 0xb2	; 000000BE  EBF2                              
loop 0xa8	; 000000C0  E2E6                              
mov byte [0x2f8f],0x1	; 000000C2  C6068F2F01                        
call 0xfc0	; 000000C7  E8F60E                            
cmp ah,0x24	; 000000CA  80FC24                            
jz 0xee	; 000000CD  741F                              
nop	; 000000CF  90                                
nop	; 000000D0  90                                
mov byte [0x2f8f],0x0	; 000000D1  C6068F2F00                        
nop	; 000000D6  90                                
nop	; 000000D7  90                                
nop	; 000000D8  90                                
nop	; 000000D9  90                                
nop	; 000000DA  90                                
nop	; 000000DB  90                                
nop	; 000000DC  90                                
nop	; 000000DD  90                                
nop	; 000000DE  90                                
nop	; 000000DF  90                                
cmp al,0x20	; 000000E0  3C20                              
jz 0xee	; 000000E2  740A                              
cmp al,0x13	; 000000E4  3C13                              
jnz 0xc2	; 000000E6  75DA                              
neg byte [0x2fa0]	; 000000E8  F61EA02F                          
jmp 0xc2	; 000000EC  EBD4                              
mov word [0x2d24],0x0	; 000000EE  C706242D0000                      
mov byte [0x6f0],0x3	; 000000F4  C606F00603                        
mov word [0x6f1],0x0	; 000000F9  C706F1060000                      
push es	; 000000FF  06                                
push ds	; 00000100  1E                                
pop es	; 00000101  07                                
mov di,0x2f7e	; 00000102  BF7E2F                            
mov cx,0x5	; 00000105  B90500                            
cld	; 00000108  FC                                
mov al,0x0	; 00000109  B000                              
rep stosb	; 0000010B  F3AA                              
pop es	; 0000010D  07                                
call 0x12e	; 0000010E  E81D00                            
mov al,0x2	; 00000111  B002                              
out byte 0x42,al	; 00000113  E642                              
xor al,al	; 00000115  32C0                              
out byte 0x42,al	; 00000117  E642                              
mov si,0x678	; 00000119  BE7806                            
mov cx,0x2	; 0000011C  B90200                            
jmp 0xa8	; 0000011F  EB87                              
mov cx,0x0	; 00000121  B90000                            
loop 0x124	; 00000124  E2FE                              
mov cx,0x0	; 00000126  B90000                            
dec dl	; 00000129  FECA                              
jnz 0x124	; 0000012B  75F7                              
ret	; 0000012D  C3                                
mov ax,0x4	; 0000012E  B80400                            
int byte 0x10	; 00000131  CD10                              
mov ah,0xb	; 00000133  B40B                              
mov bx,0x100	; 00000135  BB0001                            
int byte 0x10	; 00000138  CD10                              
mov ah,0xb	; 0000013A  B40B                              
mov bx,0x10	; 0000013C  BB1000                            
int byte 0x10	; 0000013F  CD10                              
mov dh,0x32	; 00000141  B632                              
mov di,0xd	; 00000143  BF0D00                            
mov bx,0xa09	; 00000146  BB090A                            
mov dl,0x3e	; 00000149  B23E                              
mov al,[bx]	; 0000014B  8A07                              
inc bx	; 0000014D  43                                
cmp al,0x0	; 0000014E  3C00                              
jz 0x173	; 00000150  7421                              
mov ah,0x0	; 00000152  B400                              
mov si,ax	; 00000154  8BF0                              
shl si,0x0	; 00000156  D1E6                              
shl si,0x0	; 00000158  D1E6                              
add si,0x991	; 0000015A  81C69109                          
mov bp,0x1fff	; 0000015E  BDFF1F                            
mov cx,0x4	; 00000161  B90400                            
cld	; 00000164  FC                                
movsb	; 00000165  A4                                
add di,bp	; 00000166  03FD                              
neg bp	; 00000168  F7DD                              
add bp,0x4e	; 0000016A  83C54E                            
loop 0x165	; 0000016D  E2F6                              
sub di,0xa0	; 0000016F  81EFA000                          
inc di	; 00000173  47                                
dec dl	; 00000174  FECA                              
jnz 0x14b	; 00000176  75D3                              
add di,0x62	; 00000178  83C762                            
dec dh	; 0000017B  FECE                              
jnz 0x149	; 0000017D  75CA                              
push es	; 0000017F  06                                
push ds	; 00000180  1E                                
pop es	; 00000181  07                                
mov byte [0x2c99],0xe6	; 00000182  C606992CE6                        
mov si,0x19ea	; 00000187  BEEA19                            
mov di,0x1673	; 0000018A  BF7316                            
mov cx,0x377	; 0000018D  B97703                            
cld	; 00000190  FC                                
rep movsb	; 00000191  F3A4                              
pop es	; 00000193  07                                
mov dh,0x18	; 00000194  B618                              
mov di,0xaf	; 00000196  BFAF00                            
mov bx,0x1692	; 00000199  BB9216                            
mov dl,0x1d	; 0000019C  B21D                              
mov al,[bx]	; 0000019E  8A07                              
inc bx	; 000001A0  43                                
cmp al,0x2	; 000001A1  3C02                              
jc 0x1ca	; 000001A3  7225                              
mov ah,0x0	; 000001A5  B400                              
mov si,ax	; 000001A7  8BF0                              
shl si,0x0	; 000001A9  D1E6                              
shl si,0x0	; 000001AB  D1E6                              
shl si,0x0	; 000001AD  D1E6                              
shl si,0x0	; 000001AF  D1E6                              
add si,0x1615	; 000001B1  81C61516                          
mov bp,0x1ffe	; 000001B5  BDFE1F                            
mov cx,0x8	; 000001B8  B90800                            
cld	; 000001BB  FC                                
movsw	; 000001BC  A5                                
add di,bp	; 000001BD  03FD                              
neg bp	; 000001BF  F7DD                              
add bp,0x4c	; 000001C1  83C54C                            
loop 0x1bc	; 000001C4  E2F6                              
sub di,0x140	; 000001C6  81EF4001                          
add di,0x2	; 000001CA  83C702                            
dec dl	; 000001CD  FECA                              
jnz 0x19e	; 000001CF  75CD                              
inc bx	; 000001D1  43                                
add di,0x106	; 000001D2  81C70601                          
dec dh	; 000001D6  FECE                              
jnz 0x19c	; 000001D8  75C2                              
mov ah,0x2	; 000001DA  B402                              
mov dx,0x101	; 000001DC  BA0101                            
mov bh,0x0	; 000001DF  B700                              
int byte 0x10	; 000001E1  CD10                              
mov si,0x6c3	; 000001E3  BEC306                            
mov cx,0x27	; 000001E6  B92700                            
cld	; 000001E9  FC                                
lodsb	; 000001EA  AC                                
mov bx,0x3	; 000001EB  BB0300                            
mov ah,0xe	; 000001EE  B40E                              
int byte 0x10	; 000001F0  CD10                              
loop 0x1ea	; 000001F2  E2F6                              
push es	; 000001F4  06                                
push ds	; 000001F5  1E                                
pop es	; 000001F6  07                                
mov di,0x2f88	; 000001F7  BF882F                            
mov si,0x2f83	; 000001FA  BE832F                            
mov cx,0x5	; 000001FD  B90500                            
rep movsb	; 00000200  F3A4                              
pop es	; 00000202  07                                
mov di,0xa00	; 00000203  BF000A                            
call 0xec4	; 00000206  E8BB0C                            
call 0xe78	; 00000209  E86C0C                            
mov ax,[0x6f1]	; 0000020C  A1F106                            
inc ax	; 0000020F  40                                
cmp ax,0xc	; 00000210  3D0C00                            
jng 0x218	; 00000213  7E03                              
mov ax,0xc	; 00000215  B80C00                            
mov [0x6f1],ax	; 00000218  A3F106                            
mov si,ax	; 0000021B  8BF0                              
shl si,0x0	; 0000021D  D1E6                              
shl si,0x0	; 0000021F  D1E6                              
lea si,[si+0x6ef]	; 00000221  8DB4EF06                          
cld	; 00000225  FC                                
lodsb	; 00000226  AC                                
mov [0x2c9a],al	; 00000227  A29A2C                            
lodsb	; 0000022A  AC                                
mov [0x2d26],al	; 0000022B  A2262D                            
lodsw	; 0000022E  AD                                
mov [0x2d27],ax	; 0000022F  A3272D                            
mov bx,[0x6f1]	; 00000232  8B1EF106                          
cmp bx,0x8	; 00000236  83FB08                            
jng 0x23e	; 00000239  7E03                              
mov bx,0x8	; 0000023B  BB0800                            
mov di,0x1d19	; 0000023E  BF191D                            
mov si,0x2d2e	; 00000241  BE2E2D                            
mov dx,0x1ffc	; 00000244  BAFC1F                            
mov bp,0xe04c	; 00000247  BD4CE0                            
mov cx,0xe	; 0000024A  B90E00                            
add si,0x3	; 0000024D  83C603                            
cld	; 00000250  FC                                
movsw	; 00000251  A5                                
movsw	; 00000252  A5                                
add di,dx	; 00000253  03FA                              
xchg dx,bp	; 00000255  87D5                              
loop 0x251	; 00000257  E2F8                              
sub di,0x4b0	; 00000259  81EFB004                          
dec bx	; 0000025D  4B                                
jnz 0x24a	; 0000025E  75EA                              
mov bl,[0x6f0]	; 00000260  8A1EF006                          
mov bh,0x0	; 00000264  B700                              
dec bx	; 00000266  4B                                
jz 0x29f	; 00000267  7436                              
mov di,bx	; 00000269  8BFB                              
shl di,0x0	; 0000026B  D1E7                              
shl di,0x0	; 0000026D  D1E7                              
add di,bx	; 0000026F  03FB                              
shl di,0x0	; 00000271  D1E7                              
shl di,0x0	; 00000273  D1E7                              
shl di,0x0	; 00000275  D1E7                              
shl di,0x0	; 00000277  D1E7                              
shl di,0x0	; 00000279  D1E7                              
shl di,0x0	; 0000027B  D1E7                              
shl di,0x0	; 0000027D  D1E7                              
neg di	; 0000027F  F7DF                              
add di,0x1f3b	; 00000281  81C73B1F                          
mov si,0x1f59	; 00000285  BE591F                            
mov dx,0x1ffc	; 00000288  BAFC1F                            
mov bp,0xe04c	; 0000028B  BD4CE0                            
mov cx,0xe	; 0000028E  B90E00                            
movsw	; 00000291  A5                                
movsw	; 00000292  A5                                
add di,dx	; 00000293  03FA                              
xchg dx,bp	; 00000295  87D5                              
loop 0x291	; 00000297  E2F8                              
add di,0x50	; 00000299  83C750                            
dec bx	; 0000029C  4B                                
jnz 0x285	; 0000029D  75E6                              
push es	; 0000029F  06                                
push ds	; 000002A0  1E                                
pop es	; 000002A1  07                                
cld	; 000002A2  FC                                
mov di,0x2f90	; 000002A3  BF902F                            
mov cx,0x4	; 000002A6  B90400                            
mov ax,0x0	; 000002A9  B80000                            
rep stosw	; 000002AC  F3AB                              
mov word [0x2c9b],0x0	; 000002AE  C7069B2C0000                      
mov byte [0x2cc9],0x0	; 000002B4  C606C92C00                        
mov byte [0x2cbc],0x0	; 000002B9  C606BC2C00                        
lea si,[0x725]	; 000002BE  8D362507                          
lea di,[0x2a2d]	; 000002C2  8D3E2D2A                          
mov cx,0x26c	; 000002C6  B96C02                            
rep movsb	; 000002C9  F3A4                              
pop es	; 000002CB  07                                
call 0x8d9	; 000002CC  E80A06                            
mov bx,0x1f0	; 000002CF  BBF001                            
cld	; 000002D2  FC                                
lea si,[bx+0x2a39]	; 000002D3  8DB7392A                          
mov di,[bx+0x2a2e]	; 000002D7  8BBF2E2A                          
mov cx,0xe	; 000002DB  B90E00                            
mov dx,0xe04c	; 000002DE  BA4CE0                            
mov bp,0x1ffc	; 000002E1  BDFC1F                            
movsw	; 000002E4  A5                                
movsw	; 000002E5  A5                                
add di,dx	; 000002E6  03FA                              
xchg dx,bp	; 000002E8  87D5                              
loop 0x2e4	; 000002EA  E2F8                              
sub bx,0x7c	; 000002EC  83EB7C                            
jnz 0x2d3	; 000002EF  75E2                              
mov si,0x1e09	; 000002F1  BE091E                            
mov di,[0x2a2e]	; 000002F4  8B3E2E2A                          
mov dx,0xe04c	; 000002F8  BA4CE0                            
mov cx,0xe	; 000002FB  B90E00                            
cld	; 000002FE  FC                                
movsw	; 000002FF  A5                                
movsw	; 00000300  A5                                
add di,dx	; 00000301  03FA                              
neg dx	; 00000303  F7DA                              
add dx,0x48	; 00000305  83C248                            
loop 0x2ff	; 00000308  E2F5                              
mov dx,0x0	; 0000030A  BA0000                            
mov ah,0x2	; 0000030D  B402                              
mov bh,0x0	; 0000030F  B700                              
int byte 0x10	; 00000311  CD10                              
mov di,0xc07	; 00000313  BF070C                            
mov bp,0x6	; 00000316  BD0600                            
mov al,[ds:bp+0x6e9]	; 00000319  3E8A86E906                        
mov cx,0x1	; 0000031E  B90100                            
mov bx,0x2	; 00000321  BB0200                            
mov ah,0x9	; 00000324  B409                              
int byte 0x10	; 00000326  CD10                              
push ds	; 00000328  1E                                
push es	; 00000329  06                                
pop ds	; 0000032A  1F                                
mov si,0x0	; 0000032B  BE0000                            
mov dx,0x1ffe	; 0000032E  BAFE1F                            
mov bx,0xe04e	; 00000331  BB4EE0                            
mov cx,0x8	; 00000334  B90800                            
movsw	; 00000337  A5                                
add di,dx	; 00000338  03FA                              
add si,dx	; 0000033A  03F2                              
xchg dx,bx	; 0000033C  87D3                              
loop 0x337	; 0000033E  E2F7                              
pop ds	; 00000340  1F                                
dec bp	; 00000341  4D                                
jnz 0x319	; 00000342  75D5                              
mov di,0x0	; 00000344  BF0000                            
mov ax,0x0	; 00000347  B80000                            
mov dx,0x1ffe	; 0000034A  BAFE1F                            
mov bp,0xe04e	; 0000034D  BD4EE0                            
mov cx,0x8	; 00000350  B90800                            
stosw	; 00000353  AB                                
add di,dx	; 00000354  03FA                              
xchg dx,bp	; 00000356  87D5                              
loop 0x353	; 00000358  E2F9                              
mov dh,0x5	; 0000035A  B605                              
mov cx,0x0	; 0000035C  B90000                            
loop 0x35f	; 0000035F  E2FE                              
mov cx,0x0	; 00000361  B90000                            
dec dh	; 00000364  FECE                              
jnz 0x35f	; 00000366  75F7                              
mov di,0xc07	; 00000368  BF070C                            
mov ax,0x0	; 0000036B  B80000                            
mov cx,0x30	; 0000036E  B93000                            
mov dx,0x1ffe	; 00000371  BAFE1F                            
mov bp,0xe04e	; 00000374  BD4EE0                            
stosw	; 00000377  AB                                
add di,dx	; 00000378  03FA                              
xchg dx,bp	; 0000037A  87D5                              
loop 0x377	; 0000037C  E2F9                              
call 0x4db	; 0000037E  E85A01                            
mov al,0x2	; 00000381  B002                              
out byte 0x42,al	; 00000383  E642                              
xor al,al	; 00000385  32C0                              
out byte 0x42,al	; 00000387  E642                              
call 0xe78	; 00000389  E8EC0A                            
cmp byte [0x2c99],0x0	; 0000038C  803E992C00                        
jnz 0x3ac	; 00000391  7519                              
mov di,[0x2a2e]	; 00000393  8B3E2E2A                          
mov si,0x1dd1	; 00000397  BED11D                            
mov dx,0xe04c	; 0000039A  BA4CE0                            
mov bp,0x1ffc	; 0000039D  BDFC1F                            
mov cx,0xe	; 000003A0  B90E00                            
cld	; 000003A3  FC                                
movsw	; 000003A4  A5                                
movsw	; 000003A5  A5                                
add di,dx	; 000003A6  03FA                              
xchg dx,bp	; 000003A8  87D5                              
loop 0x3a4	; 000003AA  E2F8                              
mov dl,0x2	; 000003AC  B202                              
mov cx,0x0	; 000003AE  B90000                            
loop 0x3b1	; 000003B1  E2FE                              
mov cx,0x0	; 000003B3  B90000                            
dec dl	; 000003B6  FECA                              
jnz 0x3b1	; 000003B8  75F7                              
mov bx,0x26c	; 000003BA  BB6C02                            
mov di,[bx+0x2a2e]	; 000003BD  8BBF2E2A                          
mov si,0x2a71	; 000003C1  BE712A                            
add si,bx	; 000003C4  03F3                              
mov dx,0xe04c	; 000003C6  BA4CE0                            
mov bp,0x1ffc	; 000003C9  BDFC1F                            
mov cl,[bx+0x2a35]	; 000003CC  8A8F352A                          
mov ch,0x0	; 000003D0  B500                              
jcxz 0x3dd	; 000003D2  E309                              
cld	; 000003D4  FC                                
movsw	; 000003D5  A5                                
movsw	; 000003D6  A5                                
add di,dx	; 000003D7  03FA                              
xchg dx,bp	; 000003D9  87D5                              
loop 0x3d5	; 000003DB  E2F8                              
sub bx,0x7c	; 000003DD  83EB7C                            
jnz 0x3bd	; 000003E0  75DB                              
cmp byte [0x2c99],0x0	; 000003E2  803E992C00                        
jz 0x3ec	; 000003E7  7403                              
jmp 0x40d	; 000003E9  EB22                              
nop	; 000003EB  90                                
mov bh,0x7	; 000003EC  B707                              
mov dx,0x3d9	; 000003EE  BAD903                            
mov al,0x20	; 000003F1  B020                              
mov ah,0x10	; 000003F3  B410                              
mov bl,0x2	; 000003F5  B302                              
mov cx,0x0	; 000003F7  B90000                            
loop 0x3fa	; 000003FA  E2FE                              
mov cx,0x8000	; 000003FC  B90080                            
dec bl	; 000003FF  FECB                              
jnz 0x3fa	; 00000401  75F7                              
out dx,al	; 00000403  EE                                
xchg al,ah	; 00000404  86C4                              
dec bh	; 00000406  FECF                              
jnz 0x3f5	; 00000408  75EB                              
jmp 0x12e	; 0000040A  E921FD                            
mov bp,[0x2a2e]	; 0000040D  8B2E2E2A                          
mov si,0x2675	; 00000411  BE7526                            
mov ax,0x2cd0	; 00000414  B8D02C                            
mov [0x723],ax	; 00000417  A32307                            
mov di,0x2	; 0000041A  BF0200                            
push si	; 0000041D  56                                
mov si,[0x723]	; 0000041E  8B362307                          
mov ah,0x0	; 00000422  B400                              
int byte 0x1a	; 00000424  CD1A                              
mov bx,dx	; 00000426  8BDA                              
mov ah,0x0	; 00000428  B400                              
int byte 0x1a	; 0000042A  CD1A                              
cmp dx,bx	; 0000042C  3BD3                              
jz 0x428	; 0000042E  74F8                              
lodsw	; 00000430  AD                                
cmp byte [0x2fa0],0x0	; 00000431  803EA02F00                        
jl 0x43e	; 00000436  7C06                              
out byte 0x42,al	; 00000438  E642                              
mov al,ah	; 0000043A  8AC4                              
out byte 0x42,al	; 0000043C  E642                              
dec di	; 0000043E  4F                                
jnz 0x422	; 0000043F  75E1                              
mov [0x723],si	; 00000441  89362307                          
pop si	; 00000445  5E                                
cld	; 00000446  FC                                
mov di,bp	; 00000447  8BFD                              
mov bx,0x1ffc	; 00000449  BBFC1F                            
mov dx,0xe04c	; 0000044C  BA4CE0                            
mov cl,[0x2a35]	; 0000044F  8A0E352A                          
mov ch,0x0	; 00000453  B500                              
mov ax,cx	; 00000455  8BC1                              
neg ax	; 00000457  F7D8                              
add ax,0xe	; 00000459  050E00                            
shl ax,0x0	; 0000045C  D1E0                              
shl ax,0x0	; 0000045E  D1E0                              
jcxz 0x46a	; 00000460  E308                              
movsw	; 00000462  A5                                
movsw	; 00000463  A5                                
add di,dx	; 00000464  03FA                              
xchg dx,bx	; 00000466  87D3                              
loop 0x462	; 00000468  E2F8                              
add si,ax	; 0000046A  03F0                              
cmp si,0x2a2d	; 0000046C  81FE2D2A                          
jnz 0x41a	; 00000470  75A8                              
mov di,bp	; 00000472  8BFD                              
mov si,0x2a71	; 00000474  BE712A                            
mov dx,0xe04c	; 00000477  BA4CE0                            
mov bp,0x1ffc	; 0000047A  BDFC1F                            
mov cl,[0x2a35]	; 0000047D  8A0E352A                          
mov ch,0x0	; 00000481  B500                              
jcxz 0x48e	; 00000483  E309                              
cld	; 00000485  FC                                
movsw	; 00000486  A5                                
movsw	; 00000487  A5                                
add di,dx	; 00000488  03FA                              
xchg dx,bp	; 0000048A  87D5                              
loop 0x486	; 0000048C  E2F8                              
mov al,[0x6f0]	; 0000048E  A0F006                            
mov ah,0x0	; 00000491  B400                              
dec ax	; 00000493  48                                
mov [0x6f0],al	; 00000494  A2F006                            
jz 0x4da	; 00000497  7441                              
mov di,ax	; 00000499  8BF8                              
shl di,0x0	; 0000049B  D1E7                              
shl di,0x0	; 0000049D  D1E7                              
add di,ax	; 0000049F  03F8                              
shl di,0x0	; 000004A1  D1E7                              
shl di,0x0	; 000004A3  D1E7                              
shl di,0x0	; 000004A5  D1E7                              
shl di,0x0	; 000004A7  D1E7                              
shl di,0x0	; 000004A9  D1E7                              
shl di,0x0	; 000004AB  D1E7                              
shl di,0x0	; 000004AD  D1E7                              
neg di	; 000004AF  F7DF                              
add di,0x1f3b	; 000004B1  81C73B1F                          
mov ax,0x0	; 000004B5  B80000                            
mov dx,0x1ffc	; 000004B8  BAFC1F                            
mov bp,0xe04c	; 000004BB  BD4CE0                            
mov cx,0xe	; 000004BE  B90E00                            
cld	; 000004C1  FC                                
stosw	; 000004C2  AB                                
stosw	; 000004C3  AB                                
add di,dx	; 000004C4  03FA                              
xchg dx,bp	; 000004C6  87D5                              
loop 0x4c2	; 000004C8  E2F8                              
mov byte [0x2f44],0x1	; 000004CA  C606442F01                        
mov byte [0x2f43],0x0	; 000004CF  C606432F00                        
call 0xc61	; 000004D4  E88A07                            
jmp 0x260	; 000004D7  E986FD                            
ret	; 000004DA  C3                                
mov ah,0x0	; 000004DB  B400                              
int byte 0x1a	; 000004DD  CD1A                              
mov bx,dx	; 000004DF  8BDA                              
mov ah,0x0	; 000004E1  B400                              
int byte 0x1a	; 000004E3  CD1A                              
cmp bx,dx	; 000004E5  3BDA                              
jz 0x4e1	; 000004E7  74F8                              
mov word [0x2cce],0x0	; 000004E9  C706CE2C0000                      
inc byte [0x2cca]	; 000004EF  FE06CA2C                          
mov al,[0x2c9b]	; 000004F3  A09B2C                            
cmp al,0x0	; 000004F6  3C00                              
jz 0x50e	; 000004F8  7414                              
dec al	; 000004FA  FEC8                              
mov [0x2c9b],al	; 000004FC  A29B2C                            
jnz 0x50e	; 000004FF  750D                              
mov bx,0x1f0	; 00000501  BBF001                            
and byte [bx+0x2a38],0xfe	; 00000504  80A7382AFE                        
sub bx,0x7c	; 00000509  83EB7C                            
jnz 0x504	; 0000050C  75F6                              
dec byte [0x2ccb]	; 0000050E  FE0ECB2C                          
jnz 0x519	; 00000512  7505                              
mov byte [0x2ccb],0xe	; 00000514  C606CB2C0E                        
mov bx,0x8	; 00000519  BB0800                            
mov si,0x1645	; 0000051C  BE4516                            
cmp byte [0x2ccb],0x7	; 0000051F  803ECB2C07                        
jg 0x529	; 00000524  7F03                              
add si,0x10	; 00000526  83C610                            
mov di,[bx+0x1623]	; 00000529  8BBF2316                          
mov al,[di]	; 0000052D  8A05                              
cmp al,0x3	; 0000052F  3C03                              
jnz 0x554	; 00000531  7521                              
mov cx,0x8	; 00000533  B90800                            
mov di,[bx+0x162b]	; 00000536  8BBF2B16                          
mov ax,[0x2a2e]	; 0000053A  A12E2A                            
sub ax,di	; 0000053D  2BC7                              
cmp ax,0x1f5f	; 0000053F  3D5F1F                            
jz 0x554	; 00000542  7410                              
mov dx,0x1ffe	; 00000544  BAFE1F                            
movsw	; 00000547  A5                                
add di,dx	; 00000548  03FA                              
neg dx	; 0000054A  F7DA                              
add dx,0x4c	; 0000054C  83C24C                            
loop 0x547	; 0000054F  E2F6                              
sub si,0x10	; 00000551  83EE10                            
dec bx	; 00000554  4B                                
dec bx	; 00000555  4B                                
jnz 0x529	; 00000556  75D1                              
mov bx,0x1f0	; 00000558  BBF001                            
mov cx,0x5	; 0000055B  B90500                            
mov ax,[bx+0x2a2e]	; 0000055E  8B872E2A                          
mov [bx+0x2a33],ax	; 00000562  8987332A                          
mov al,[bx+0x2a35]	; 00000566  8A87352A                          
mov [bx+0x2a36],al	; 0000056A  8887362A                          
sub bx,0x7c	; 0000056E  83EB7C                            
loop 0x55e	; 00000571  E2EB                              
call 0xd6d	; 00000573  E8F707                            
test byte [0x2a31],0x1	; 00000576  F606312A01                        
jnz 0x5be	; 0000057B  7541                              
test byte [0x2a30],0x1	; 0000057D  F606302A01                        
jnz 0x5be	; 00000582  753A                              
mov ah,0x0	; 00000584  B400                              
mov al,[0x2a30]	; 00000586  A0302A                            
sar ax,0x0	; 00000589  D1F8                              
mov dx,0x1e	; 0000058B  BA1E00                            
mul dx	; 0000058E  F7E2                              
mov bx,ax	; 00000590  8BD8                              
mov ax,[0x2a31]	; 00000592  A1312A                            
sar ax,0x0	; 00000595  D1F8                              
add bx,ax	; 00000597  03D8                              
cmp byte [bx+0x1673],0x1	; 00000599  80BF731601                        
jg 0x5db	; 0000059E  7F3B                              
mov al,[0x2cbc]	; 000005A0  A0BC2C                            
mov ah,0x0	; 000005A3  B400                              
mov si,ax	; 000005A5  8BF0                              
mov al,[si+0x2cbd]	; 000005A7  8A84BD2C                          
cbw	; 000005AB  98                                
mov si,ax	; 000005AC  8BF0                              
cmp byte [bx+si+0x1673],0x0	; 000005AE  80B8731600                        
jz 0x5c1	; 000005B3  740C                              
mov al,[0x2cbc]	; 000005B5  A0BC2C                            
mov [0x2a2d],al	; 000005B8  A22D2A                            
jmp 0x657	; 000005BB  E99900                            
jmp 0x646	; 000005BE  E98500                            
mov al,[0x2a2d]	; 000005C1  A02D2A                            
mov ah,0x0	; 000005C4  B400                              
mov si,ax	; 000005C6  8BF0                              
mov al,[si+0x2cbd]	; 000005C8  8A84BD2C                          
cbw	; 000005CC  98                                
mov si,ax	; 000005CD  8BF0                              
cmp byte [bx+si+0x1673],0x0	; 000005CF  80B8731600                        
jnz 0x5bb	; 000005D4  75E5                              
jmp 0x6af	; 000005D6  E9D600                            
jmp 0x5a0	; 000005D9  EBC5                              
mov ax,0x401	; 000005DB  B80104                            
call 0xe3a	; 000005DE  E85908                            
mov al,0x1	; 000005E1  B001                              
xchg al,[bx+0x1673]	; 000005E3  86877316                          
cmp al,0x3	; 000005E7  3C03                              
jnz 0x614	; 000005E9  7529                              
mov byte [0x2f91],0x19	; 000005EB  C606912F19                        
mov ax,0x404	; 000005F0  B80404                            
call 0xe3a	; 000005F3  E84408                            
mov word [0x2f8d],0x0	; 000005F6  C7068D2F0000                      
mov al,[0x2c9a]	; 000005FC  A09A2C                            
mov [0x2c9b],al	; 000005FF  A29B2C                            
mov si,0x1f0	; 00000602  BEF001                            
or byte [si+0x2a38],0x1	; 00000605  808C382A01                        
xor byte [si+0x2a2d],0x1	; 0000060A  80B42D2A01                        
sub si,0x7c	; 0000060F  83EE7C                            
jnz 0x605	; 00000612  75F1                              
dec byte [0x2c99]	; 00000614  FE0E992C                          
jnz 0x61b	; 00000618  7501                              
ret	; 0000061A  C3                                
cld	; 0000061B  FC                                
push es	; 0000061C  06                                
push ds	; 0000061D  1E                                
pop es	; 0000061E  07                                
mov ax,0x0	; 0000061F  B80000                            
mov cx,0x8	; 00000622  B90800                            
mov di,0x2a7e	; 00000625  BF7E2A                            
stosw	; 00000628  AB                                
inc di	; 00000629  47                                
inc di	; 0000062A  47                                
loop 0x628	; 0000062B  E2FB                              
pop es	; 0000062D  07                                
mov byte [0x2f90],0x2	; 0000062E  C606902F02                        
neg byte [0x2ccc]	; 00000633  F61ECC2C                          
jg 0x5d9	; 00000637  7FA0                              
inc byte [0x2f90]	; 00000639  FE06902F                          
mov word [0x2cce],0x7c	; 0000063D  C706CE2C7C00                      
jmp 0x6af	; 00000643  EB6A                              
nop	; 00000645  90                                
mov al,[0x2a2d]	; 00000646  A02D2A                            
xor al,[0x2cbc]	; 00000649  3206BC2C                          
test al,0x2	; 0000064D  A802                              
jnz 0x657	; 0000064F  7506                              
mov al,[0x2cbc]	; 00000651  A0BC2C                            
mov [0x2a2d],al	; 00000654  A22D2A                            
mov al,[0x2a2d]	; 00000657  A02D2A                            
mov ah,0x0	; 0000065A  B400                              
mov si,ax	; 0000065C  8BF0                              
shl si,0x0	; 0000065E  D1E6                              
mov ax,[si+0x2cc1]	; 00000660  8B84C12C                          
add ax,[0x2a2e]	; 00000664  03062E2A                          
mov [0x2a2e],ax	; 00000668  A32E2A                            
mov ax,si	; 0000066B  8BC6                              
test ax,0x4	; 0000066D  A90400                            
jnz 0x67d	; 00000670  750B                              
dec ax	; 00000672  48                                
add al,[0x2a30]	; 00000673  0206302A                          
mov [0x2a30],al	; 00000677  A2302A                            
jmp 0x684	; 0000067A  EB08                              
nop	; 0000067C  90                                
sub ax,0x5	; 0000067D  2D0500                            
add [0x2a31],al	; 00000680  0006312A                          
mov al,[0x2cc9]	; 00000684  A0C92C                            
inc al	; 00000687  FEC0                              
and al,0x3	; 00000689  2403                              
mov [0x2cc9],al	; 0000068B  A2C92C                            
mov bx,si	; 0000068E  8BDE                              
shl bx,0x0	; 00000690  D1E3                              
mov ah,0x0	; 00000692  B400                              
add bx,ax	; 00000694  03D8                              
shl bx,0x0	; 00000696  D1E3                              
mov si,[bx+0x2c9c]	; 00000698  8BB79C2C                          
add si,0x1d61	; 0000069C  81C6611D                          
mov di,0x2a39	; 000006A0  BF392A                            
mov cx,0xe	; 000006A3  B90E00                            
push es	; 000006A6  06                                
push ds	; 000006A7  1E                                
pop es	; 000006A8  07                                
cld	; 000006A9  FC                                
movsw	; 000006AA  A5                                
movsw	; 000006AB  A5                                
loop 0x6aa	; 000006AC  E2FC                              
pop es	; 000006AE  07                                
mov bx,0x1f0	; 000006AF  BBF001                            
cmp byte [bx+0x2a37],0x2	; 000006B2  80BF372A02                        
jl 0x6c1	; 000006B7  7C08                              
mov byte [bx+0x2a37],0x1	; 000006B9  C687372A01                        
jmp 0x765	; 000006BE  E9A400                            
test byte [bx+0x2a31],0x1	; 000006C1  F687312A01                        
jnz 0x710	; 000006C6  7548                              
test byte [bx+0x2a30],0x1	; 000006C8  F687302A01                        
jnz 0x710	; 000006CD  7541                              
mov byte [0x2ccd],0x0	; 000006CF  C606CD2C00                        
mov ah,0x0	; 000006D4  B400                              
mov al,[bx+0x2a30]	; 000006D6  8A87302A                          
sar ax,0x0	; 000006DA  D1F8                              
mov dx,0x1e	; 000006DC  BA1E00                            
mul dx	; 000006DF  F7E2                              
mov bp,ax	; 000006E1  8BE8                              
mov ax,[bx+0x2a31]	; 000006E3  8B87312A                          
sar ax,0x0	; 000006E7  D1F8                              
add bp,ax	; 000006E9  03E8                              
call 0x95a	; 000006EB  E86C02                            
cmp [bx+0x2a2d],al	; 000006EE  38872D2A                          
jz 0x719	; 000006F2  7425                              
mov dl,al	; 000006F4  8AD0                              
xchg dl,[bx+0x2a2d]	; 000006F6  86972D2A                          
cmp byte [bx+0x2a37],0x1	; 000006FA  80BF372A01                        
jz 0x719	; 000006FF  7418                              
mov [bx+0x2a2d],dl	; 00000701  88972D2A                          
mov byte [bx+0x2a37],0x1	; 00000705  C687372A01                        
jmp 0x765	; 0000070A  EB59                              
nop	; 0000070C  90                                
jmp 0x719	; 0000070D  EB0A                              
nop	; 0000070F  90                                
mov al,[bx+0x2a2d]	; 00000710  8A872D2A                          
mov byte [0x2ccd],0x1	; 00000714  C606CD2C01                        
mov ah,0x0	; 00000719  B400                              
mov si,ax	; 0000071B  8BF0                              
shl si,0x0	; 0000071D  D1E6                              
mov si,[si+0x2cc1]	; 0000071F  8BB4C12C                          
add [bx+0x2a2e],si	; 00000723  01B72E2A                          
mov ah,al	; 00000727  8AE0                              
sar ax,0x0	; 00000729  D1F8                              
cbw	; 0000072B  98                                
shl ah,0x0	; 0000072C  D0E4                              
inc ah	; 0000072E  FEC4                              
neg ah	; 00000730  F6DC                              
and al,0x7f	; 00000732  247F                              
mov dl,al	; 00000734  8AD0                              
mov al,ah	; 00000736  8AC4                              
mov dh,0x0	; 00000738  B600                              
mov di,dx	; 0000073A  8BFA                              
add [bx+di+0x2a30],al	; 0000073C  0081302A                          
mov byte [bx+0x2a37],0x0	; 00000740  C687372A00                        
cmp byte [bx+0x2a38],0x2	; 00000745  80BF382A02                        
jl 0x757	; 0000074A  7C0B                              
cmp byte [bx+0x2a38],0x6	; 0000074C  80BF382A06                        
jnl 0x757	; 00000751  7D04                              
sub [bx+di+0x2a30],al	; 00000753  2881302A                          
cmp byte [0x2ccd],0x1	; 00000757  803ECD2C01                        
jz 0x765	; 0000075C  7407                              
cmp byte [bx+0x2a38],0x6	; 0000075E  80BF382A06                        
jnl 0x710	; 00000763  7DAB                              
sub bx,0x7c	; 00000765  83EB7C                            
jz 0x76d	; 00000768  7403                              
jmp 0x6b2	; 0000076A  E945FF                            
call 0x8d9	; 0000076D  E86901                            
mov cx,0x5	; 00000770  B90500                            
mov bx,0x0	; 00000773  BB0000                            
mov al,[bx+0x2a30]	; 00000776  8A87302A                          
cmp al,0x0	; 0000077A  3C00                              
mov ah,0x3a	; 0000077C  B43A                              
mov dx,0x2440	; 0000077E  BA4024                            
jl 0x78c	; 00000781  7C09                              
cmp al,0x39	; 00000783  3C39                              
mov ah,0xc6	; 00000785  B4C6                              
mov dx,0xdbc0	; 00000787  BAC0DB                            
jng 0x796	; 0000078A  7E0A                              
add al,ah	; 0000078C  02C4                              
mov [bx+0x2a30],al	; 0000078E  8887302A                          
add [bx+0x2a2e],dx	; 00000792  01972E2A                          
cmp byte [bx+0x2a37],0x1	; 00000796  80BF372A01                        
jz 0x7c9	; 0000079B  742C                              
cmp byte [bx+0x2a31],0x20	; 0000079D  80BF312A20                        
jnz 0x7b6	; 000007A2  7512                              
mov byte [bx+0x2a37],0x2	; 000007A4  C687372A02                        
cmp al,0xc	; 000007A9  3C0C                              
jl 0x7b6	; 000007AB  7C09                              
cmp al,0x26	; 000007AD  3C26                              
jg 0x7b6	; 000007AF  7F05                              
mov byte [bx+0x2a37],0x0	; 000007B1  C687372A00                        
cmp byte [bx+0x2a38],0x0	; 000007B6  80BF382A00                        
jz 0x7c9	; 000007BB  740C                              
cmp byte [bx+0x2a38],0x6	; 000007BD  80BF382A06                        
jnl 0x7c9	; 000007C2  7D05                              
mov byte [bx+0x2a37],0x2	; 000007C4  C687372A02                        
mov ah,0x0	; 000007C9  B400                              
shl ax,0x0	; 000007CB  D1E0                              
shl ax,0x0	; 000007CD  D1E0                              
neg ax	; 000007CF  F7D8                              
add ax,0xcf	; 000007D1  05CF00                            
cmp ax,0x0	; 000007D4  3D0000                            
jl 0x7e4	; 000007D7  7C0B                              
cmp ax,0xe	; 000007D9  3D0E00                            
jng 0x7e7	; 000007DC  7E09                              
mov ax,0xe	; 000007DE  B80E00                            
jmp 0x7e7	; 000007E1  EB04                              
nop	; 000007E3  90                                
mov ax,0x0	; 000007E4  B80000                            
mov [bx+0x2a35],al	; 000007E7  8887352A                          
add bx,0x7c	; 000007EB  83C37C                            
loop 0x776	; 000007EE  E286                              
call 0xf21	; 000007F0  E82E07                            
call 0xe78	; 000007F3  E88206                            
call 0xb5c	; 000007F6  E86303                            
cld	; 000007F9  FC                                
mov bx,0x26c	; 000007FA  BB6C02                            
sub bx,0x7c	; 000007FD  83EB7C                            
mov si,0x2a71	; 00000800  BE712A                            
add si,bx	; 00000803  03F3                              
mov dx,0xe04c	; 00000805  BA4CE0                            
mov bp,0x1ffc	; 00000808  BDFC1F                            
mov di,[bx+0x2a33]	; 0000080B  8BBF332A                          
mov cl,[bx+0x2a36]	; 0000080F  8A8F362A                          
mov ch,0x0	; 00000813  B500                              
jcxz 0x81f	; 00000815  E308                              
movsw	; 00000817  A5                                
movsw	; 00000818  A5                                
add di,dx	; 00000819  03FA                              
xchg dx,bp	; 0000081B  87D5                              
loop 0x817	; 0000081D  E2F8                              
cmp bx,[0x2cce]	; 0000081F  3B1ECE2C                          
jnz 0x7fd	; 00000823  75D8                              
cmp byte [0x2f44],0x0	; 00000825  803E442F00                        
jz 0x82f	; 0000082A  7403                              
call 0xc61	; 0000082C  E83204                            
mov bx,[0x2cce]	; 0000082F  8B1ECE2C                          
sub bx,0x26c	; 00000833  81EB6C02                          
mov bp,0x48	; 00000837  BD4800                            
add bx,0x7c	; 0000083A  83C37C                            
mov si,[bx+0x2c1e]	; 0000083D  8BB71E2C                          
mov dx,0xe04c	; 00000841  BA4CE0                            
mov bp,0x1ffc	; 00000844  BDFC1F                            
mov di,0x2c61	; 00000847  BF612C                            
add di,bx	; 0000084A  03FB                              
mov cx,0xe	; 0000084C  B90E00                            
push es	; 0000084F  06                                
push ds	; 00000850  1E                                
pop es	; 00000851  07                                
pop ds	; 00000852  1F                                
movsw	; 00000853  A5                                
movsw	; 00000854  A5                                
add si,dx	; 00000855  03F2                              
xchg dx,bp	; 00000857  87D5                              
loop 0x853	; 00000859  E2F8                              
push es	; 0000085B  06                                
push ds	; 0000085C  1E                                
pop es	; 0000085D  07                                
pop ds	; 0000085E  1F                                
mov si,0x2c29	; 0000085F  BE292C                            
add si,bx	; 00000862  03F3                              
mov dx,0xe04c	; 00000864  BA4CE0                            
mov bp,0x1ffc	; 00000867  BDFC1F                            
mov di,[bx+0x2c1e]	; 0000086A  8BBF1E2C                          
mov cl,[bx+0x2c25]	; 0000086E  8A8F252C                          
mov ch,0x0	; 00000872  B500                              
jcxz 0x88f	; 00000874  E319                              
mov al,[es:di]	; 00000876  268A05                            
and al,0xc0	; 00000879  24C0                              
or al,[si]	; 0000087B  0A04                              
inc si	; 0000087D  46                                
stosb	; 0000087E  AA                                
movsw	; 0000087F  A5                                
mov al,[es:di]	; 00000880  268A05                            
and al,0x3	; 00000883  2403                              
or al,[si]	; 00000885  0A04                              
inc si	; 00000887  46                                
stosb	; 00000888  AA                                
add di,dx	; 00000889  03FA                              
xchg dx,bp	; 0000088B  87D5                              
loop 0x876	; 0000088D  E2E7                              
cmp bx,0x0	; 0000088F  83FB00                            
jnz 0x83a	; 00000892  75A6                              
mov bx,0x1f0	; 00000894  BBF001                            
cmp byte [bx+0x2a38],0x2	; 00000897  80BF382A02                        
jnl 0x8c2	; 0000089C  7D24                              
mov ax,[bx+0x2a30]	; 0000089E  8B87302A                          
sub al,[0x2a30]	; 000008A2  2A06302A                          
jnl 0x8aa	; 000008A6  7D02                              
neg al	; 000008A8  F6D8                              
sub ah,[0x2a31]	; 000008AA  2A26312A                          
jnl 0x8b2	; 000008AE  7D02                              
neg ah	; 000008B0  F6DC                              
add al,ah	; 000008B2  02C4                              
cmp al,0x2	; 000008B4  3C02                              
jg 0x8c2	; 000008B6  7F0A                              
cmp byte [bx+0x2a38],0x0	; 000008B8  80BF382A00                        
jz 0x8d8	; 000008BD  7419                              
call 0xcb6	; 000008BF  E8F403                            
sub bx,0x7c	; 000008C2  83EB7C                            
jnz 0x897	; 000008C5  75D0                              
mov di,0x1f3c	; 000008C7  BF3C1F                            
mov ax,0x0	; 000008CA  B80000                            
cld	; 000008CD  FC                                
stosw	; 000008CE  AB                                
stosw	; 000008CF  AB                                
sub di,0x54	; 000008D0  83EF54                            
stosw	; 000008D3  AB                                
stosw	; 000008D4  AB                                
jmp 0x4db	; 000008D5  E903FC                            
ret	; 000008D8  C3                                
push es	; 000008D9  06                                
push ds	; 000008DA  1E                                
pop es	; 000008DB  07                                
mov bx,0x26c	; 000008DC  BB6C02                            
mov bp,0x280	; 000008DF  BD8002                            
sub bx,0x7c	; 000008E2  83EB7C                            
sub bp,0xa0	; 000008E5  81EDA000                          
mov cx,0x8	; 000008E9  B90800                            
mov al,[bx+0x2a2d]	; 000008EC  8A872D2A                          
mov ah,0x0	; 000008F0  B400                              
mov si,ax	; 000008F2  8BF0                              
shl si,0x0	; 000008F4  D1E6                              
shl si,0x0	; 000008F6  D1E6                              
shl si,0x0	; 000008F8  D1E6                              
shl si,0x0	; 000008FA  D1E6                              
shl si,0x0	; 000008FC  D1E6                              
add si,0x20e1	; 000008FE  81C6E120                          
mov ax,0x3c0	; 00000902  B8C003                            
cmp byte [bx+0x2a38],0x6	; 00000905  80BF382A06                        
jnl 0x929	; 0000090A  7D1D                              
mov ax,bp	; 0000090C  8BC5                              
test byte [bx+0x2a38],0x1	; 0000090E  F687382A01                        
jz 0x929	; 00000913  7414                              
mov ax,0x280	; 00000915  B88002                            
cmp byte [0x2c9b],0x46	; 00000918  803E9B2C46                        
ja 0x929	; 0000091D  770A                              
cmp byte [0x2ccb],0x8	; 0000091F  803ECB2C08                        
jl 0x929	; 00000924  7C03                              
add ax,0xa0	; 00000926  05A000                            
mov di,0x2a39	; 00000929  BF392A                            
add di,bx	; 0000092C  03FB                              
call 0xb10	; 0000092E  E8DF01                            
mov si,0x2161	; 00000931  BE6121                            
mov cx,0x4	; 00000934  B90400                            
call 0xb10	; 00000937  E8D601                            
mov si,[0x2cca]	; 0000093A  8B36CA2C                          
and si,0x2	; 0000093E  81E60200                          
shl si,0x0	; 00000942  D1E6                              
shl si,0x0	; 00000944  D1E6                              
add si,0x2171	; 00000946  81C67121                          
mov cx,0x2	; 0000094A  B90200                            
call 0xb10	; 0000094D  E8C001                            
cmp bp,0x0	; 00000950  83FD00                            
jnz 0x8e2	; 00000953  758D                              
pop es	; 00000955  07                                
ret	; 00000956  C3                                
jmp 0xa2b	; 00000957  E9D100                            
push es	; 0000095A  06                                
push ds	; 0000095B  1E                                
pop es	; 0000095C  07                                
mov di,0x2d2a	; 0000095D  BF2A2D                            
mov al,0x1	; 00000960  B001                              
mov cx,0x4	; 00000962  B90400                            
cld	; 00000965  FC                                
rep stosb	; 00000966  F3AA                              
mov al,[bx+0x2a38]	; 00000968  8A87382A                          
sar al,0x0	; 0000096C  D0F8                              
jz 0x957	; 0000096E  74E7                              
dec al	; 00000970  FEC8                              
jnz 0x9a9	; 00000972  7535                              
mov ax,[bx+0x2a2e]	; 00000974  8B872E2A                          
sub ax,0x2e92	; 00000978  2D922E                            
jnz 0x995	; 0000097B  7518                              
sub byte [bx+0x2a38],0x2	; 0000097D  80AF382A02                        
mov word [bx+0x2a30],0x2619	; 00000982  C787302A1926                      
call 0xb01	; 00000988  E87601                            
rcl ax,0x0	; 0000098B  D1D0                              
mov ax,0x0	; 0000098D  B80000                            
rcl ax,0x0	; 00000990  D1D0                              
jmp 0xaff	; 00000992  E96A01                            
cmp ax,0xffe2	; 00000995  3DE2FF                            
jna 0x99f	; 00000998  7605                              
mov al,0x3	; 0000099A  B003                              
jmp 0xaff	; 0000099C  E96001                            
rcl ax,0x0	; 0000099F  D1D0                              
mov ax,0x0	; 000009A1  B80000                            
rcl ax,0x0	; 000009A4  D1D0                              
jmp 0xaff	; 000009A6  E95601                            
dec al	; 000009A9  FEC8                              
jnz 0x9f2	; 000009AB  7545                              
mov al,[bx+0x2a2d]	; 000009AD  8A872D2A                          
mov ah,0x0	; 000009B1  B400                              
mov si,ax	; 000009B3  8BF0                              
mov dx,bx	; 000009B5  8BD3                              
mov cx,0x0	; 000009B7  B90000                            
inc cx	; 000009BA  41                                
sub dx,0x7c	; 000009BB  83EA7C                            
jnz 0x9ba	; 000009BE  75FA                              
shl cx,0x0	; 000009C0  D1E1                              
add si,cx	; 000009C2  03F1                              
shl si,0x0	; 000009C4  D1E6                              
mov dx,[bx+0x2a2e]	; 000009C6  8B972E2A                          
cmp dx,[si+0x2d0c]	; 000009CA  3B940C2D                          
jnz 0x9ef	; 000009CE  751F                              
xor al,0x1	; 000009D0  3401                              
cmp al,0x3	; 000009D2  3C03                              
jnz 0x9ef	; 000009D4  7519                              
test byte [bx+0x2a38],0x1	; 000009D6  F687382A01                        
jnz 0x9ef	; 000009DB  7512                              
call 0xb01	; 000009DD  E82101                            
cmp ax,[0x2d27]	; 000009E0  3B06272D                          
mov al,0x3	; 000009E4  B003                              
jnc 0x9ef	; 000009E6  7307                              
sub byte [bx+0x2a38],0x2	; 000009E8  80AF382A02                        
jmp 0x974	; 000009ED  EB85                              
jmp 0xaff	; 000009EF  E90D01                            
cmp word [bx+0x2a30],0x261a	; 000009F2  81BF302A1A26                      
jnz 0xa2b	; 000009F8  7531                              
sub byte [bx+0x2a38],0x2	; 000009FA  80AF382A02                        
mov dx,bx	; 000009FF  8BD3                              
mov cx,0x0	; 00000A01  B90000                            
inc cx	; 00000A04  41                                
sub dx,0x7c	; 00000A05  83EA7C                            
jnz 0xa04	; 00000A08  75FA                              
shl cx,0x0	; 00000A0A  D1E1                              
shl cx,0x0	; 00000A0C  D1E1                              
mov si,cx	; 00000A0E  8BF1                              
mov ax,[si+0x2d10]	; 00000A10  8B84102D                          
mov [bx+0x2a2e],ax	; 00000A14  89872E2A                          
cmp cx,0xc	; 00000A18  83F90C                            
jnz 0xa22	; 00000A1B  7505                              
sub byte [bx+0x2a38],0x2	; 00000A1D  80AF382A02                        
mov al,0x3	; 00000A22  B003                              
mov [bx+0x2a2d],al	; 00000A24  88872D2A                          
jmp 0xaff	; 00000A28  E9D400                            
mov al,[0x2d26]	; 00000A2B  A0262D                            
mov [0x2d29],al	; 00000A2E  A2292D                            
mov dl,[bx+0x2a38]	; 00000A31  8A97382A                          
mov cl,dl	; 00000A35  8ACA                              
xor cx,0x1	; 00000A37  81F10100                          
and cx,0x1	; 00000A3B  81E10100                          
cmp dl,0x6	; 00000A3F  80FA06                            
jl 0xa4c	; 00000A42  7C08                              
mov byte [0x2d29],0x3c	; 00000A44  C606292D3C                        
mov cx,0x1	; 00000A49  B90100                            
mov al,[0x2a30]	; 00000A4C  A0302A                            
cmp dl,0x6	; 00000A4F  80FA06                            
jl 0xa56	; 00000A52  7C02                              
mov al,0x1a	; 00000A54  B01A                              
sub al,[bx+0x2a30]	; 00000A56  2A87302A                          
jcxz 0xa5e	; 00000A5A  E302                              
neg al	; 00000A5C  F6D8                              
jz 0xa70	; 00000A5E  7410                              
rcl al,0x0	; 00000A60  D0D0                              
mov ax,0x0	; 00000A62  B80000                            
rcl ax,0x0	; 00000A65  D1D0                              
mov di,ax	; 00000A67  8BF8                              
mov al,[0x2d29]	; 00000A69  A0292D                            
mov [di+0x2d2a],al	; 00000A6C  88852A2D                          
mov al,[0x2a31]	; 00000A70  A0312A                            
cmp dl,0x6	; 00000A73  80FA06                            
jl 0xa7a	; 00000A76  7C02                              
mov al,0x26	; 00000A78  B026                              
sub al,[bx+0x2a31]	; 00000A7A  2A87312A                          
jcxz 0xa82	; 00000A7E  E302                              
neg al	; 00000A80  F6D8                              
jz 0xa94	; 00000A82  7410                              
rcl al,0x0	; 00000A84  D0D0                              
mov ax,0x1	; 00000A86  B80100                            
rcl ax,0x0	; 00000A89  D1D0                              
mov di,ax	; 00000A8B  8BF8                              
mov al,[0x2d29]	; 00000A8D  A0292D                            
mov [di+0x2d2a],al	; 00000A90  88852A2D                          
mov cx,0x4	; 00000A94  B90400                            
mov di,cx	; 00000A97  8BF9                              
mov al,[di+0x2cbc]	; 00000A99  8A85BC2C                          
cbw	; 00000A9D  98                                
mov si,ax	; 00000A9E  8BF0                              
cmp byte [ds:bp+si+0x1673],0x0	; 00000AA0  3E80BA731600                      
jnz 0xaad	; 00000AA6  7505                              
mov byte [di+0x2d29],0x0	; 00000AA8  C685292D00                        
loop 0xa97	; 00000AAD  E2E8                              
mov al,[bx+0x2a2d]	; 00000AAF  8A872D2A                          
mov ah,0x0	; 00000AB3  B400                              
mov di,ax	; 00000AB5  8BF8                              
cmp byte [bx+0x2a37],0x1	; 00000AB7  80BF372A01                        
jz 0xad0	; 00000ABC  7412                              
mov ax,di	; 00000ABE  8BC7                              
mov ah,[bx+0x2a31]	; 00000AC0  8AA7312A                          
xor ah,0x20	; 00000AC4  80F420                            
test ax,0xfffe	; 00000AC7  A9FEFF                            
jz 0xad0	; 00000ACA  7404                              
shl byte [di+0x2d2a],0x0	; 00000ACC  D0A52A2D                          
xor di,0x1	; 00000AD0  81F70100                          
mov byte [di+0x2d2a],0x0	; 00000AD4  C6852A2D00                        
mov cx,0x4	; 00000AD9  B90400                            
mov bp,0x0	; 00000ADC  BD0000                            
mov si,0x2d2a	; 00000ADF  BE2A2D                            
mov ah,0x0	; 00000AE2  B400                              
lodsb	; 00000AE4  AC                                
add bp,ax	; 00000AE5  03E8                              
loop 0xae4	; 00000AE7  E2FB                              
call 0xb01	; 00000AE9  E81500                            
mul bp	; 00000AEC  F7E5                              
mov si,0x2d2a	; 00000AEE  BE2A2D                            
mov ah,0x0	; 00000AF1  B400                              
lodsb	; 00000AF3  AC                                
sub dx,ax	; 00000AF4  2BD0                              
jnl 0xaf3	; 00000AF6  7DFB                              
mov ax,0x2d2b	; 00000AF8  B82B2D                            
neg ax	; 00000AFB  F7D8                              
add ax,si	; 00000AFD  03C6                              
pop es	; 00000AFF  07                                
ret	; 00000B00  C3                                
mov ax,[0x2d24]	; 00000B01  A1242D                            
mov dx,0x98dd	; 00000B04  BADD98                            
mul dx	; 00000B07  F7E2                              
add ax,0xd5ef	; 00000B09  05EFD5                            
mov [0x2d24],ax	; 00000B0C  A3242D                            
ret	; 00000B0F  C3                                
add si,ax	; 00000B10  03F0                              
cld	; 00000B12  FC                                
movsw	; 00000B13  A5                                
movsw	; 00000B14  A5                                
loop 0xb13	; 00000B15  E2FC                              
ret	; 00000B17  C3                                
mov byte [0x2f93],0x18	; 00000B18  C606932F18                        
mov al,[0x6f0]	; 00000B1D  A0F006                            
mov ah,0x0	; 00000B20  B400                              
inc al	; 00000B22  FEC0                              
mov [0x6f0],al	; 00000B24  A2F006                            
mov di,ax	; 00000B27  8BF8                              
shl di,0x0	; 00000B29  D1E7                              
shl di,0x0	; 00000B2B  D1E7                              
add di,ax	; 00000B2D  03F8                              
shl di,0x0	; 00000B2F  D1E7                              
shl di,0x0	; 00000B31  D1E7                              
shl di,0x0	; 00000B33  D1E7                              
shl di,0x0	; 00000B35  D1E7                              
shl di,0x0	; 00000B37  D1E7                              
shl di,0x0	; 00000B39  D1E7                              
shl di,0x0	; 00000B3B  D1E7                              
neg di	; 00000B3D  F7DF                              
add di,0x21bb	; 00000B3F  81C7BB21                          
mov si,0x1f59	; 00000B43  BE591F                            
mov dx,0x1ffc	; 00000B46  BAFC1F                            
mov bp,0xe04c	; 00000B49  BD4CE0                            
mov cx,0xe	; 00000B4C  B90E00                            
cld	; 00000B4F  FC                                
movsw	; 00000B50  A5                                
movsw	; 00000B51  A5                                
add di,dx	; 00000B52  03FA                              
xchg dx,bp	; 00000B54  87D5                              
loop 0xb50	; 00000B56  E2F8                              
ret	; 00000B58  C3                                
jmp 0xbea	; 00000B59  E98E00                            
mov byte [0x2f44],0x0	; 00000B5C  C606442F00                        
cmp byte [0x2f43],0x2	; 00000B61  803E432F02                        
jnz 0xb59	; 00000B66  75F1                              
cmp word [0x2a2e],0x2e86	; 00000B68  813E2E2A862E                      
jnz 0xb59	; 00000B6E  75E9                              
mov byte [0x2f92],0x9	; 00000B70  C606922F09                        
mov byte [0x2f43],0x1	; 00000B75  C606432F01                        
mov word [0x2f3e],0x3c	; 00000B7A  C7063E2F3C00                      
push es	; 00000B80  06                                
push ds	; 00000B81  1E                                
pop es	; 00000B82  07                                
mov di,0x2f45	; 00000B83  BF452F                            
mov bx,[0x2f41]	; 00000B86  8B1E412F                          
mov bp,0x3	; 00000B8A  BD0300                            
cmp byte [bx],0x0	; 00000B8D  803F00                            
jnz 0xba4	; 00000B90  7512                              
mov ax,0x0	; 00000B92  B80000                            
cld	; 00000B95  FC                                
stosw	; 00000B96  AB                                
stosw	; 00000B97  AB                                
inc bx	; 00000B98  43                                
dec bp	; 00000B99  4D                                
add di,0x1e	; 00000B9A  83C71E                            
cld	; 00000B9D  FC                                
stosw	; 00000B9E  AB                                
stosw	; 00000B9F  AB                                
stosw	; 00000BA0  AB                                
sub di,0x24	; 00000BA1  83EF24                            
mov al,[bx]	; 00000BA4  8A07                              
inc bx	; 00000BA6  43                                
mov ah,0x0	; 00000BA7  B400                              
mov si,ax	; 00000BA9  8BF0                              
shl si,0x0	; 00000BAB  D1E6                              
shl si,0x0	; 00000BAD  D1E6                              
shl si,0x0	; 00000BAF  D1E6                              
add si,0x2f06	; 00000BB1  81C6062F                          
mov cx,0x4	; 00000BB5  B90400                            
rep movsw	; 00000BB8  F3A5                              
mov ax,0x0	; 00000BBA  B80000                            
stosw	; 00000BBD  AB                                
dec bp	; 00000BBE  4D                                
jnz 0xba4	; 00000BBF  75E3                              
mov si,0x2f06	; 00000BC1  BE062F                            
mov cx,0x4	; 00000BC4  B90400                            
rep movsw	; 00000BC7  F3A5                              
mov ax,0x0	; 00000BC9  B80000                            
stosw	; 00000BCC  AB                                
pop es	; 00000BCD  07                                
sub bx,0x3	; 00000BCE  83EB03                            
mov dx,0x3	; 00000BD1  BA0300                            
mov ah,dl	; 00000BD4  8AE2                              
neg ah	; 00000BD6  F6DC                              
add ah,0x5	; 00000BD8  80C405                            
mov al,[bx]	; 00000BDB  8A07                              
call 0xe3a	; 00000BDD  E85A02                            
inc bx	; 00000BE0  43                                
dec dx	; 00000BE1  4A                                
jnz 0xbd4	; 00000BE2  75F0                              
mov byte [0x2f44],0x2	; 00000BE4  C606442F02                        
ret	; 00000BE9  C3                                
cmp byte [0x2f43],0x0	; 00000BEA  803E432F00                        
jnz 0xc49	; 00000BEF  7558                              
mov al,[0x2c99]	; 00000BF1  A0992C                            
cmp al,[0x2f40]	; 00000BF4  3A06402F                          
jz 0xc02	; 00000BF8  7408                              
cmp al,0xaa	; 00000BFA  3CAA                              
jz 0xc03	; 00000BFC  7405                              
cmp al,0x50	; 00000BFE  3C50                              
jz 0xc03	; 00000C00  7401                              
ret	; 00000C02  C3                                
mov [0x2f40],al	; 00000C03  A2402F                            
mov byte [0x2f43],0x2	; 00000C06  C606432F02                        
mov word [0x2f3e],0x87	; 00000C0B  C7063E2F8700                      
mov byte [0x2f44],0x3	; 00000C11  C606442F03                        
mov di,0x2f45	; 00000C16  BF452F                            
mov ax,[0x6f1]	; 00000C19  A1F106                            
dec ax	; 00000C1C  48                                
cmp ax,0x8	; 00000C1D  3D0800                            
jl 0xc2f	; 00000C20  7C0D                              
call 0xb01	; 00000C22  E8DCFE                            
mov al,0x0	; 00000C25  B000                              
rol ax,0x0	; 00000C27  D1C0                              
rol ax,0x0	; 00000C29  D1C0                              
rol ax,0x0	; 00000C2B  D1C0                              
mov ah,0x0	; 00000C2D  B400                              
mov dx,0x3b	; 00000C2F  BA3B00                            
mul dx	; 00000C32  F7E2                              
add ax,0x2d2e	; 00000C34  052E2D                            
mov [0x2f41],ax	; 00000C37  A3412F                            
mov si,ax	; 00000C3A  8BF0                              
add si,0x3	; 00000C3C  83C603                            
mov cx,0x1c	; 00000C3F  B91C00                            
push es	; 00000C42  06                                
push ds	; 00000C43  1E                                
pop es	; 00000C44  07                                
rep movsw	; 00000C45  F3A5                              
pop es	; 00000C47  07                                
ret	; 00000C48  C3                                
dec word [0x2f3e]	; 00000C49  FF0E3E2F                          
jz 0xc50	; 00000C4D  7401                              
ret	; 00000C4F  C3                                
mov byte [0x2f43],0x0	; 00000C50  C606432F00                        
mov word [0x2f3e],0x10e	; 00000C55  C7063E2F0E01                      
mov byte [0x2f44],0x1	; 00000C5B  C606442F01                        
ret	; 00000C60  C3                                
cld	; 00000C61  FC                                
cmp byte [0x2f44],0x2	; 00000C62  803E442F02                        
jg 0xc9e	; 00000C67  7F35                              
jz 0xc83	; 00000C69  7418                              
mov di,0xde6	; 00000C6B  BFE60D                            
mov ax,0x0	; 00000C6E  B80000                            
mov cx,0x14	; 00000C71  B91400                            
mov dx,0x1ffc	; 00000C74  BAFC1F                            
mov bp,0xe04c	; 00000C77  BD4CE0                            
stosw	; 00000C7A  AB                                
stosw	; 00000C7B  AB                                
add di,dx	; 00000C7C  03FA                              
xchg dx,bp	; 00000C7E  87D5                              
loop 0xc7a	; 00000C80  E2F8                              
ret	; 00000C82  C3                                
mov di,0xde6	; 00000C83  BFE60D                            
mov si,0x2f45	; 00000C86  BE452F                            
mov cx,0x14	; 00000C89  B91400                            
mov dx,0x1ffc	; 00000C8C  BAFC1F                            
mov bp,0xe04c	; 00000C8F  BD4CE0                            
mov al,0x0	; 00000C92  B000                              
stosb	; 00000C94  AA                                
movsw	; 00000C95  A5                                
stosb	; 00000C96  AA                                
add di,dx	; 00000C97  03FA                              
xchg dx,bp	; 00000C99  87D5                              
loop 0xc94	; 00000C9B  E2F7                              
ret	; 00000C9D  C3                                
mov di,0x2e86	; 00000C9E  BF862E                            
mov si,0x2f45	; 00000CA1  BE452F                            
mov cx,0xe	; 00000CA4  B90E00                            
mov dx,0xe04c	; 00000CA7  BA4CE0                            
mov bp,0x1ffc	; 00000CAA  BDFC1F                            
movsw	; 00000CAD  A5                                
movsw	; 00000CAE  A5                                
add di,dx	; 00000CAF  03FA                              
xchg dx,bp	; 00000CB1  87D5                              
loop 0xcad	; 00000CB3  E2F8                              
ret	; 00000CB5  C3                                
cld	; 00000CB6  FC                                
mov di,[0x2f8d]	; 00000CB7  8B3E8D2F                          
mov al,[di+0x25f1]	; 00000CBB  8A85F125                          
mov ah,0x3	; 00000CBF  B403                              
call 0xe3a	; 00000CC1  E87601                            
mov byte [bx+0x2a38],0x6	; 00000CC4  C687382A06                        
add si,bx	; 00000CC9  03F3                              
mov di,[bx+0x2a2e]	; 00000CCB  8BBF2E2A                          
mov cl,[bx+0x2a35]	; 00000CCF  8A8F352A                          
call 0xd54	; 00000CD3  E87E00                            
mov di,[0x2a2e]	; 00000CD6  8B3E2E2A                          
mov cl,[0x2a35]	; 00000CDA  8A0E352A                          
call 0xd54	; 00000CDE  E87300                            
call 0xd12	; 00000CE1  E82E00                            
mov al,0x2	; 00000CE4  B002                              
out byte 0x42,al	; 00000CE6  E642                              
xor al,al	; 00000CE8  32C0                              
out byte 0x42,al	; 00000CEA  E642                              
mov si,0x2ff6	; 00000CEC  BEF62F                            
mov bp,0x18	; 00000CEF  BD1800                            
cld	; 00000CF2  FC                                
lodsw	; 00000CF3  AD                                
cmp byte [0x2fa0],0x0	; 00000CF4  803EA02F00                        
jl 0xd01	; 00000CF9  7C06                              
out byte 0x42,al	; 00000CFB  E642                              
mov al,ah	; 00000CFD  8AC4                              
out byte 0x42,al	; 00000CFF  E642                              
mov cx,0x140a	; 00000D01  B90A14                            
loop 0xd04	; 00000D04  E2FE                              
dec bp	; 00000D06  4D                                
jnz 0xcf3	; 00000D07  75EA                              
call 0xd12	; 00000D09  E80600                            
add word [0x2f8d],0x21	; 00000D0C  83068D2F21                        
ret	; 00000D11  C3                                
mov dx,0xe04c	; 00000D12  BA4CE0                            
mov bp,0x1ffc	; 00000D15  BDFC1F                            
mov di,[0x2a2e]	; 00000D18  8B3E2E2A                          
add di,[bx+0x2a2e]	; 00000D1C  03BF2E2A                          
sar di,0x0	; 00000D20  D1FF                              
add di,0xa0	; 00000D22  81C7A000                          
mov si,0x25f2	; 00000D26  BEF225                            
add si,[0x2f8d]	; 00000D29  03368D2F                          
mov cl,[0x2a35]	; 00000D2D  8A0E352A                          
add cl,[bx+0x2a35]	; 00000D31  028F352A                          
sar cl,0x0	; 00000D35  D0F9                              
mov ch,0x0	; 00000D37  B500                              
jcxz 0xd53	; 00000D39  E318                              
cmp cx,0x8	; 00000D3B  83F908                            
jng 0xd43	; 00000D3E  7E03                              
mov cx,0x8	; 00000D40  B90800                            
lodsw	; 00000D43  AD                                
xor ax,[es:di]	; 00000D44  263305                            
stosw	; 00000D47  AB                                
lodsw	; 00000D48  AD                                
xor ax,[es:di]	; 00000D49  263305                            
stosw	; 00000D4C  AB                                
add di,dx	; 00000D4D  03FA                              
xchg dx,bp	; 00000D4F  87D5                              
loop 0xd43	; 00000D51  E2F0                              
ret	; 00000D53  C3                                
mov ax,0x0	; 00000D54  B80000                            
mov dx,0xe04c	; 00000D57  BA4CE0                            
mov bp,0x1ffc	; 00000D5A  BDFC1F                            
mov ch,0x0	; 00000D5D  B500                              
jcxz 0xd69	; 00000D5F  E308                              
stosw	; 00000D61  AB                                
stosw	; 00000D62  AB                                
add di,dx	; 00000D63  03FA                              
xchg dx,bp	; 00000D65  87D5                              
loop 0xd61	; 00000D67  E2F8                              
ret	; 00000D69  C3                                
pop ax	; 00000D6A  58                                
pop ax	; 00000D6B  58                                
ret	; 00000D6C  C3                                
mov ah,0x1	; 00000D6D  B401                              
int byte 0x16	; 00000D6F  CD16                              
jz 0xdcf	; 00000D71  745C                              
call 0xfc0	; 00000D73  E84A02                            
nop	; 00000D76  90                                
cmp ax,0x0	; 00000D77  3D0000                            
jz 0xd6a	; 00000D7A  74EE                              
cmp al,0x13	; 00000D7C  3C13                              
jnz 0xd84	; 00000D7E  7504                              
neg byte [0x2fa0]	; 00000D80  F61EA02F                          
cmp byte [0x2f8f],0x1	; 00000D84  803E8F2F01                        
jz 0xdcf	; 00000D89  7444                              
and al,0xdf	; 00000D8B  24DF                              
mov bl,0x0	; 00000D8D  B300                              
cmp ah,0x48	; 00000D8F  80FC48                            
jz 0xdca	; 00000D92  7436                              
cmp al,0x45	; 00000D94  3C45                              
jz 0xdca	; 00000D96  7432                              
cmp al,0x49	; 00000D98  3C49                              
jz 0xdca	; 00000D9A  742E                              
inc bl	; 00000D9C  FEC3                              
cmp ah,0x50	; 00000D9E  80FC50                            
jz 0xdca	; 00000DA1  7427                              
cmp al,0x4a	; 00000DA3  3C4A                              
jz 0xdca	; 00000DA5  7423                              
cmp al,0x44	; 00000DA7  3C44                              
jz 0xdca	; 00000DA9  741F                              
inc bl	; 00000DAB  FEC3                              
cmp ah,0x4b	; 00000DAD  80FC4B                            
jz 0xdca	; 00000DB0  7418                              
cmp al,0x41	; 00000DB2  3C41                              
jz 0xdca	; 00000DB4  7414                              
cmp al,0x4b	; 00000DB6  3C4B                              
jz 0xdca	; 00000DB8  7410                              
inc bl	; 00000DBA  FEC3                              
cmp ah,0x4d	; 00000DBC  80FC4D                            
jz 0xdca	; 00000DBF  7409                              
cmp al,0x4c	; 00000DC1  3C4C                              
jz 0xdca	; 00000DC3  7405                              
cmp al,0x53	; 00000DC5  3C53                              
jz 0xdca	; 00000DC7  7401                              
ret	; 00000DC9  C3                                
mov [0x2cbc],bl	; 00000DCA  881EBC2C                          
ret	; 00000DCE  C3                                
cmp byte [0x2f8f],0x1	; 00000DCF  803E8F2F01                        
jnz 0xdc9	; 00000DD4  75F3                              
mov al,[0x2a2d]	; 00000DD6  A02D2A                            
mov [0x2cbc],al	; 00000DD9  A2BC2C                            
cli	; 00000DDC  FA                                
mov dx,0x201	; 00000DDD  BA0102                            
mov cx,0x190	; 00000DE0  B99001                            
mov al,0xff	; 00000DE3  B0FF                              
mov ah,0x1	; 00000DE5  B401                              
out dx,al	; 00000DE7  EE                                
in al,dx	; 00000DE8  EC                                
and al,ah	; 00000DE9  22C4                              
loopne 0xde8	; 00000DEB  E0FB                              
mov bx,cx	; 00000DED  8BD9                              
jcxz 0xdf6	; 00000DEF  E305                              
nop	; 00000DF1  90                                
nop	; 00000DF2  90                                
nop	; 00000DF3  90                                
loop 0xdf1	; 00000DF4  E2FB                              
add bx,0xfeca	; 00000DF6  81C3CAFE                          
mov cx,0x190	; 00000DFA  B99001                            
mov al,0xff	; 00000DFD  B0FF                              
mov ah,0x2	; 00000DFF  B402                              
out dx,al	; 00000E01  EE                                
in al,dx	; 00000E02  EC                                
and al,ah	; 00000E03  22C4                              
loopne 0xe02	; 00000E05  E0FB                              
sti	; 00000E07  FB                                
add cx,0xfebe	; 00000E08  81C1BEFE                          
neg cx	; 00000E0C  F7D9                              
mov dx,cx	; 00000E0E  8BD1                              
add cx,bx	; 00000E10  03CB                              
mov si,cx	; 00000E12  8BF1                              
jnl 0xe18	; 00000E14  7D02                              
neg si	; 00000E16  F7DE                              
sub dx,bx	; 00000E18  2BD3                              
mov di,dx	; 00000E1A  8BFA                              
jnl 0xe20	; 00000E1C  7D02                              
neg di	; 00000E1E  F7DF                              
add si,di	; 00000E20  03F7                              
cmp si,0x51	; 00000E22  83FE51                            
jl 0xdc9	; 00000E25  7CA2                              
mov ax,0x0	; 00000E27  B80000                            
rcl cx,0x0	; 00000E2A  D1D1                              
rcl ax,0x0	; 00000E2C  D1D0                              
rcl dx,0x0	; 00000E2E  D1D2                              
rcl ax,0x0	; 00000E30  D1D0                              
inc ax	; 00000E32  40                                
and ax,0x3	; 00000E33  250300                            
mov [0x2cbc],al	; 00000E36  A2BC2C                            
ret	; 00000E39  C3                                
push es	; 00000E3A  06                                
push ds	; 00000E3B  1E                                
pop es	; 00000E3C  07                                
std	; 00000E3D  FD                                
lea di,[0x2f7e]	; 00000E3E  8D3E7E2F                          
mov cl,ah	; 00000E42  8ACC                              
mov ch,0x0	; 00000E44  B500                              
add di,cx	; 00000E46  03F9                              
add al,[di]	; 00000E48  0205                              
mov ah,0xff	; 00000E4A  B4FF                              
inc ah	; 00000E4C  FEC4                              
sub al,0xa	; 00000E4E  2C0A                              
jnl 0xe4c	; 00000E50  7DFA                              
add al,0xa	; 00000E52  040A                              
stosb	; 00000E54  AA                                
mov al,ah	; 00000E55  8AC4                              
cmp al,0x0	; 00000E57  3C00                              
loopne 0xe48	; 00000E59  E0ED                              
cld	; 00000E5B  FC                                
pop es	; 00000E5C  07                                
mov si,di	; 00000E5D  8BF7                              
mov ax,0x2f7e	; 00000E5F  B87E2F                            
sub ax,di	; 00000E62  2BC7                              
jnz 0xe77	; 00000E64  7511                              
lodsb	; 00000E66  AC                                
cmp al,0x0	; 00000E67  3C00                              
jnz 0xe77	; 00000E69  750C                              
cmp byte [si],0x1	; 00000E6B  803C01                            
jnz 0xe77	; 00000E6E  7507                              
push si	; 00000E70  56                                
push dx	; 00000E71  52                                
call 0xb18	; 00000E72  E8A3FC                            
pop dx	; 00000E75  5A                                
pop si	; 00000E76  5E                                
ret	; 00000E77  C3                                
cld	; 00000E78  FC                                
push es	; 00000E79  06                                
push ds	; 00000E7A  1E                                
pop es	; 00000E7B  07                                
lea si,[0x2f7e]	; 00000E7C  8D367E2F                          
lea di,[0x2f88]	; 00000E80  8D3E882F                          
mov cx,0x5	; 00000E84  B90500                            
rep movsb	; 00000E87  F3A4                              
pop es	; 00000E89  07                                
mov di,0x280	; 00000E8A  BF8002                            
call 0xec4	; 00000E8D  E83400                            
push es	; 00000E90  06                                
push ds	; 00000E91  1E                                
pop es	; 00000E92  07                                
lea si,[0x2f7e]	; 00000E93  8D367E2F                          
lea di,[0x2f83]	; 00000E97  8D3E832F                          
mov cx,0x5	; 00000E9B  B90500                            
repe cmpsb	; 00000E9E  F3A6                              
jz 0xec2	; 00000EA0  7420                              
dec di	; 00000EA2  4F                                
dec si	; 00000EA3  4E                                
mov al,[di]	; 00000EA4  8A05                              
cmp al,[si]	; 00000EA6  3A04                              
jg 0xec2	; 00000EA8  7F18                              
inc cx	; 00000EAA  41                                
rep movsb	; 00000EAB  F3A4                              
lea si,[0x2f83]	; 00000EAD  8D36832F                          
lea di,[0x2f88]	; 00000EB1  8D3E882F                          
mov cx,0x5	; 00000EB5  B90500                            
rep movsb	; 00000EB8  F3A4                              
pop es	; 00000EBA  07                                
mov di,0xa00	; 00000EBB  BF000A                            
call 0xec4	; 00000EBE  E80300                            
ret	; 00000EC1  C3                                
pop es	; 00000EC2  07                                
ret	; 00000EC3  C3                                
mov byte [0x2f7d],0x1	; 00000EC4  C6067D2F01                        
mov bx,0x0	; 00000EC9  BB0000                            
mov al,[bx+0x2f88]	; 00000ECC  8A87882F                          
cmp al,0x0	; 00000ED0  3C00                              
jz 0xed9	; 00000ED2  7405                              
mov byte [0x2f7d],0x0	; 00000ED4  C6067D2F00                        
cmp byte [0x2f7d],0x0	; 00000ED9  803E7D2F00                        
jz 0xef6	; 00000EDE  7416                              
mov dx,0x1ffe	; 00000EE0  BAFE1F                            
mov bp,0xe04e	; 00000EE3  BD4EE0                            
mov cx,0x8	; 00000EE6  B90800                            
mov ax,0x0	; 00000EE9  B80000                            
stosw	; 00000EEC  AB                                
add di,dx	; 00000EED  03FA                              
xchg dx,bp	; 00000EEF  87D5                              
loop 0xeec	; 00000EF1  E2F9                              
jmp 0xf16	; 00000EF3  EB21                              
nop	; 00000EF5  90                                
mov dx,0x1ffe	; 00000EF6  BAFE1F                            
mov bp,0xe04e	; 00000EF9  BD4EE0                            
mov cx,0x8	; 00000EFC  B90800                            
mov ah,0x0	; 00000EFF  B400                              
mov si,ax	; 00000F01  8BF0                              
shl si,0x0	; 00000F03  D1E6                              
shl si,0x0	; 00000F05  D1E6                              
shl si,0x0	; 00000F07  D1E6                              
shl si,0x0	; 00000F09  D1E6                              
add si,0x2541	; 00000F0B  81C64125                          
movsw	; 00000F0F  A5                                
add di,dx	; 00000F10  03FA                              
xchg dx,bp	; 00000F12  87D5                              
loop 0xf0f	; 00000F14  E2F9                              
add di,0xfec2	; 00000F16  81C7C2FE                          
inc bx	; 00000F1A  43                                
cmp bx,0x5	; 00000F1B  83FB05                            
jl 0xecc	; 00000F1E  7CAC                              
ret	; 00000F20  C3                                
push es	; 00000F21  06                                
mov ax,ds	; 00000F22  8CD8                              
mov es,ax	; 00000F24  8EC0                              
mov cx,0x8	; 00000F26  B90800                            
mov di,0x2f90	; 00000F29  BF902F                            
mov si,0x0	; 00000F2C  BE0000                            
mov ah,0x0	; 00000F2F  B400                              
cld	; 00000F31  FC                                
mov al,0x0	; 00000F32  B000                              
repe scasb	; 00000F34  F3AE                              
jz 0xf48	; 00000F36  7410                              
mov al,[di-0x1]	; 00000F38  8A45FF                            
dec al	; 00000F3B  FEC8                              
mov ah,al	; 00000F3D  8AE0                              
mov [di-0x1],al	; 00000F3F  8845FF                            
mov si,di	; 00000F42  8BF7                              
jcxz 0xf48	; 00000F44  E302                              
jmp 0xf32	; 00000F46  EBEA                              
pop es	; 00000F48  07                                
cmp si,0x0	; 00000F49  83FE00                            
jz 0xf60	; 00000F4C  7412                              
mov bx,0x2f90	; 00000F4E  BB902F                            
sub si,bx	; 00000F51  2BF3                              
shl si,0x0	; 00000F53  D1E6                              
cmp byte [0x2fa0],0x0	; 00000F55  803EA02F00                        
jl 0xf60	; 00000F5A  7C04                              
jmp word near [si+0x2f96]	; 00000F5C  FFA4962F                          
mov ax,0x2	; 00000F60  B80200                            
out byte 0x42,al	; 00000F63  E642                              
mov al,ah	; 00000F65  8AC4                              
out byte 0x42,al	; 00000F67  E642                              
ret	; 00000F69  C3                                
test ah,0x1	; 00000F6A  F6C401                            
jz 0xf60	; 00000F6D  74F1                              
mov ax,0x190	; 00000F6F  B89001                            
out byte 0x42,al	; 00000F72  E642                              
mov al,ah	; 00000F74  8AC4                              
out byte 0x42,al	; 00000F76  E642                              
ret	; 00000F78  C3                                
mov bl,ah	; 00000F79  8ADC                              
mov bh,0x0	; 00000F7B  B700                              
shl bx,0x0	; 00000F7D  D1E3                              
mov ax,[bx+0x2fa2]	; 00000F7F  8B87A22F                          
out byte 0x42,al	; 00000F83  E642                              
mov al,ah	; 00000F85  8AC4                              
out byte 0x42,al	; 00000F87  E642                              
ret	; 00000F89  C3                                
mov bl,ah	; 00000F8A  8ADC                              
mov bh,0x0	; 00000F8C  B700                              
shl bx,0x0	; 00000F8E  D1E3                              
mov ax,[bx+0x2fc4]	; 00000F90  8B87C42F                          
out byte 0x42,al	; 00000F94  E642                              
mov al,ah	; 00000F96  8AC4                              
out byte 0x42,al	; 00000F98  E642                              
ret	; 00000F9A  C3                                
mov al,[0x2fa1]	; 00000F9B  A0A12F                            
inc al	; 00000F9E  FEC0                              
cmp al,0x8	; 00000FA0  3C08                              
jl 0xfa6	; 00000FA2  7C02                              
mov al,0x0	; 00000FA4  B000                              
mov [0x2fa1],al	; 00000FA6  A2A12F                            
mov bl,al	; 00000FA9  8AD8                              
mov bh,0x0	; 00000FAB  B700                              
shl bx,0x0	; 00000FAD  D1E3                              
mov ax,[bx+0x2fb4]	; 00000FAF  8B87B42F                          
out byte 0x42,al	; 00000FB3  E642                              
mov al,ah	; 00000FB5  8AC4                              
out byte 0x42,al	; 00000FB7  E642                              
ret	; 00000FB9  C3                                
add [bx+si],al	; 00000FBA  0000                              
add [bx+si],al	; 00000FBC  0000                              
add [bx+si],al	; 00000FBE  0000                              
mov ah,0x0	; 00000FC0  B400                              
int byte 0x16	; 00000FC2  CD16                              
cmp al,0x1b	; 00000FC4  3C1B                              
jz 0xfc9	; 00000FC6  7401                              
ret	; 00000FC8  C3                                
mov al,0x4d	; 00000FC9  B04D                              
out byte 0x61,al	; 00000FCB  E661                              
mov ax,0x3	; 00000FCD  B80300                            
int byte 0x10	; 00000FD0  CD10                              
mov ax,0x4c00	; 00000FD2  B8004C                            
int byte 0x21	; 00000FD5  CD21                              
hlt	; 00000FD7  F4                                
nop	; 00000FD8  90                                
nop	; 00000FD9  90                                
nop	; 00000FDA  90                                
nop	; 00000FDB  90                                
nop	; 00000FDC  90                                
nop	; 00000FDD  90                                
nop	; 00000FDE  90                                
nop	; 00000FDF  90                                
int byte 0x11	; 00000FE0  CD11                              
and al,0x30	; 00000FE2  2430                              
cmp al,0x20	; 00000FE4  3C20                              
jnz 0xfd2	; 00000FE6  75EA                              
ret	; 00000FE8  C3                                
nop	; 00000FE9  90                                
nop	; 00000FEA  90                                
nop	; 00000FEB  90                                
nop	; 00000FEC  90                                
nop	; 00000FED  90                                
nop	; 00000FEE  90                                
nop	; 00000FEF  90                                
nop	; 00000FF0  90                                
nop	; 00000FF1  90                                
nop	; 00000FF2  90                                
nop	; 00000FF3  90                                
nop	; 00000FF4  90                                
nop	; 00000FF5  90                                
nop	; 00000FF6  90                                
nop	; 00000FF7  90                                
nop	; 00000FF8  90                                
nop	; 00000FF9  90                                
nop	; 00000FFA  90                                
nop	; 00000FFB  90                                
nop	; 00000FFC  90                                
nop	; 00000FFD  90                                
nop	; 00000FFE  90                                
nop	; 00000FFF  90                                
add [bx+si],al	; 00001000  0000                              
aas	; 00001002  3F                                
push ax	; 00001003  FFF0                              
add [bx+si],al	; 00001005  0000                              
add [bx+si],al	; 00001007  0000                              
add [bp+di],al	; 00001009  0003                              
db 0xff	; 0000100B  FF                                
db 0xff	; 0000100C  FF                                
inc word [bx+si]	; 0000100D  FF00                              
add [bx+si],al	; 0000100F  0000                              
add [bx+si],al	; 00001011  0000                              
aas	; 00001013  3F                                
db 0xff	; 00001014  FF                                
db 0xff	; 00001015  FF                                
inc ax	; 00001016  FFC0                              
add [bx+si],al	; 00001018  0000                              
add [bx+si],al	; 0000101A  0000                              
db 0xff	; 0000101C  FF                                
db 0xff	; 0000101D  FF                                
db 0xff	; 0000101E  FF                                
push ax	; 0000101F  FFF0                              
add [bx+si],al	; 00001021  0000                              
add [bx+si],al	; 00001023  0000                              
db 0xff	; 00001025  FF                                
db 0xff	; 00001026  FF                                
db 0xff	; 00001027  FF                                
push ax	; 00001028  FFF0                              
add [bx+si],al	; 0000102A  0000                              
add [bp+di],al	; 0000102C  0003                              
db 0xff	; 0000102E  FF                                
dec di	; 0000102F  FFCF                              
db 0xff	; 00001031  FF                                
cld	; 00001032  FC                                
add [bx+si],al	; 00001033  0000                              
add [bp+di],al	; 00001035  0003                              
db 0xff	; 00001037  FF                                
dec di	; 00001038  FFCF                              
db 0xff	; 0000103A  FF                                
cld	; 0000103B  FC                                
add [bx+si],al	; 0000103C  0000                              
add [bp+di],al	; 0000103E  0003                              
db 0xff	; 00001040  FF                                
dec di	; 00001041  FFCF                              
db 0xff	; 00001043  FF                                
inc word [bx+si]	; 00001044  FF00                              
add [bx+si],al	; 00001046  0000                              
add di,di	; 00001048  03FF                              
dec di	; 0000104A  FFCF                              
db 0xff	; 0000104C  FF                                
inc word [bx+si]	; 0000104D  FF00                              
add [bx+si],al	; 0000104F  0000                              
add di,di	; 00001051  03FF                              
dec di	; 00001053  FFCF                              
db 0xff	; 00001055  FF                                
inc word [bx+si]	; 00001056  FF00                              
add [bx+si],al	; 00001058  0000                              
add di,di	; 0000105A  03FF                              
dec di	; 0000105C  FFCF                              
db 0xff	; 0000105E  FF                                
inc word [bx+si]	; 0000105F  FF00                              
add [bx+si],al	; 00001061  0000                              
add di,di	; 00001063  03FF                              
dec di	; 00001065  FFCF                              
db 0xff	; 00001067  FF                                
cld	; 00001068  FC                                
add [bx+si],al	; 00001069  0000                              
add [bp+di],al	; 0000106B  0003                              
db 0xff	; 0000106D  FF                                
dec di	; 0000106E  FFCF                              
db 0xff	; 00001070  FF                                
cld	; 00001071  FC                                
add [bx+si],al	; 00001072  0000                              
add [bp+di],al	; 00001074  0003                              
db 0xff	; 00001076  FF                                
db 0xff	; 00001077  FF                                
db 0xff	; 00001078  FF                                
push ax	; 00001079  FFF0                              
add [bx+si],al	; 0000107B  0000                              
add [bp+di],al	; 0000107D  0003                              
db 0xff	; 0000107F  FF                                
db 0xff	; 00001080  FF                                
db 0xff	; 00001081  FF                                
inc ax	; 00001082  FFC0                              
add [bx+si],al	; 00001084  0000                              
add [bp+di],al	; 00001086  0003                              
db 0xff	; 00001088  FF                                
db 0xff	; 00001089  FF                                
db 0xff	; 0000108A  FF                                
inc ax	; 0000108B  FFC0                              
add [bx+si],al	; 0000108D  0000                              
add [bp+di],al	; 0000108F  0003                              
db 0xff	; 00001091  FF                                
db 0xff	; 00001092  FF                                
db 0xff	; 00001093  FF                                
inc word [bx+si]	; 00001094  FF00                              
add [bx+si],al	; 00001096  0000                              
add [bp+di],al	; 00001098  0003                              
db 0xff	; 0000109A  FF                                
db 0xff	; 0000109B  FF                                
inc ax	; 0000109C  FFC0                              
add [bx+si],al	; 0000109E  0000                              
add [bx+si],al	; 000010A0  0000                              
add di,di	; 000010A2  03FF                              
inc ax	; 000010A4  FFC0                              
add [bx+si],al	; 000010A6  0000                              
add [bx+si],al	; 000010A8  0000                              
add [bp+di],al	; 000010AA  0003                              
db 0xff	; 000010AC  FF                                
inc ax	; 000010AD  FFC0                              
add [bx+si],al	; 000010AF  0000                              
add [bx+si],al	; 000010B1  0000                              
add [bp+di],al	; 000010B3  0003                              
db 0xff	; 000010B5  FF                                
inc ax	; 000010B6  FFC0                              
add [bx+si],al	; 000010B8  0000                              
add [bx+si],al	; 000010BA  0000                              
add [bp+di],al	; 000010BC  0003                              
db 0xff	; 000010BE  FF                                
inc ax	; 000010BF  FFC0                              
add [bx+si],al	; 000010C1  0000                              
add [bx+si],al	; 000010C3  0000                              
add [bp+di],al	; 000010C5  0003                              
db 0xff	; 000010C7  FF                                
inc ax	; 000010C8  FFC0                              
add [bx+si],al	; 000010CA  0000                              
add [bx+si],al	; 000010CC  0000                              
add [bx+si],al	; 000010CE  0000                              
add [bp+di],al	; 000010D0  0003                              
db 0xff	; 000010D2  FF                                
push ax	; 000010D3  FFF0                              
add [bx+si],al	; 000010D5  0000                              
add [bx+si],al	; 000010D7  0000                              
add bh,bh	; 000010D9  00FF                              
db 0xff	; 000010DB  FF                                
db 0xff	; 000010DC  FF                                
inc ax	; 000010DD  FFC0                              
add [bx+si],al	; 000010DF  0000                              
add [bx],cl	; 000010E1  000F                              
db 0xff	; 000010E3  FF                                
db 0xff	; 000010E4  FF                                
db 0xff	; 000010E5  FF                                
db 0xff	; 000010E6  FF                                
cld	; 000010E7  FC                                
add [bx+si],al	; 000010E8  0000                              
add [bx],bh	; 000010EA  003F                              
db 0xff	; 000010EC  FF                                
db 0xff	; 000010ED  FF                                
db 0xff	; 000010EE  FF                                
db 0xff	; 000010EF  FF                                
inc word [bx+si]	; 000010F0  FF00                              
add [bx+si],al	; 000010F2  0000                              
db 0xff	; 000010F4  FF                                
db 0xff	; 000010F5  FF                                
db 0xff	; 000010F6  FF                                
db 0xff	; 000010F7  FF                                
db 0xff	; 000010F8  FF                                
inc ax	; 000010F9  FFC0                              
add [bx+si],al	; 000010FB  0000                              
db 0xff	; 000010FD  FF                                
db 0xff	; 000010FE  FF                                
db 0xff	; 000010FF  FF                                
db 0xff	; 00001100  FF                                
db 0xff	; 00001101  FF                                
inc ax	; 00001102  FFC0                              
add [bp+di],al	; 00001104  0003                              
db 0xff	; 00001106  FF                                
db 0xff	; 00001107  FF                                
db 0xff	; 00001108  FF                                
db 0xff	; 00001109  FF                                
db 0xff	; 0000110A  FF                                
push ax	; 0000110B  FFF0                              
add [bp+di],al	; 0000110D  0003                              
db 0xff	; 0000110F  FF                                
db 0xff	; 00001110  FF                                
db 0xff	; 00001111  FF                                
aas	; 00001112  3F                                
db 0xff	; 00001113  FF                                
push ax	; 00001114  FFF0                              
add [bx],cl	; 00001116  000F                              
db 0xff	; 00001118  FF                                
db 0xff	; 00001119  FF                                
db 0xff	; 0000111A  FF                                
aas	; 0000111B  3F                                
db 0xff	; 0000111C  FF                                
db 0xff	; 0000111D  FF                                
cld	; 0000111E  FC                                
add [bx],cl	; 0000111F  000F                              
db 0xff	; 00001121  FF                                
db 0xff	; 00001122  FF                                
db 0xff	; 00001123  FF                                
aas	; 00001124  3F                                
db 0xff	; 00001125  FF                                
db 0xff	; 00001126  FF                                
cld	; 00001127  FC                                
add [bx],cl	; 00001128  000F                              
db 0xff	; 0000112A  FF                                
db 0xff	; 0000112B  FF                                
db 0xff	; 0000112C  FF                                
aas	; 0000112D  3F                                
db 0xff	; 0000112E  FF                                
db 0xff	; 0000112F  FF                                
cld	; 00001130  FC                                
add [bx],cl	; 00001131  000F                              
db 0xff	; 00001133  FF                                
db 0xff	; 00001134  FF                                
inc word [bx+si]	; 00001135  FF00                              
add [bx+si],al	; 00001137  0000                              
add [bx+si],al	; 00001139  0000                              
ud0 di,di	; 0000113B  0FFFFF                            
db 0xff	; 0000113E  FF                                
aas	; 0000113F  3F                                
db 0xff	; 00001140  FF                                
db 0xff	; 00001141  FF                                
cld	; 00001142  FC                                
add [bx],cl	; 00001143  000F                              
db 0xff	; 00001145  FF                                
db 0xff	; 00001146  FF                                
db 0xff	; 00001147  FF                                
aas	; 00001148  3F                                
db 0xff	; 00001149  FF                                
db 0xff	; 0000114A  FF                                
cld	; 0000114B  FC                                
add [bx],cl	; 0000114C  000F                              
db 0xff	; 0000114E  FF                                
db 0xff	; 0000114F  FF                                
db 0xff	; 00001150  FF                                
aas	; 00001151  3F                                
db 0xff	; 00001152  FF                                
db 0xff	; 00001153  FF                                
cld	; 00001154  FC                                
add [bp+di],al	; 00001155  0003                              
db 0xff	; 00001157  FF                                
db 0xff	; 00001158  FF                                
db 0xff	; 00001159  FF                                
aas	; 0000115A  3F                                
db 0xff	; 0000115B  FF                                
push ax	; 0000115C  FFF0                              
add [bp+di],al	; 0000115E  0003                              
db 0xff	; 00001160  FF                                
db 0xff	; 00001161  FF                                
db 0xff	; 00001162  FF                                
db 0xff	; 00001163  FF                                
db 0xff	; 00001164  FF                                
push ax	; 00001165  FFF0                              
add [bx+si],al	; 00001167  0000                              
db 0xff	; 00001169  FF                                
db 0xff	; 0000116A  FF                                
db 0xff	; 0000116B  FF                                
db 0xff	; 0000116C  FF                                
db 0xff	; 0000116D  FF                                
inc ax	; 0000116E  FFC0                              
add [bx+si],al	; 00001170  0000                              
db 0xff	; 00001172  FF                                
db 0xff	; 00001173  FF                                
db 0xff	; 00001174  FF                                
db 0xff	; 00001175  FF                                
db 0xff	; 00001176  FF                                
inc ax	; 00001177  FFC0                              
add [bx+si],al	; 00001179  0000                              
aas	; 0000117B  3F                                
db 0xff	; 0000117C  FF                                
db 0xff	; 0000117D  FF                                
db 0xff	; 0000117E  FF                                
db 0xff	; 0000117F  FF                                
inc word [bx+si]	; 00001180  FF00                              
add [bx+si],al	; 00001182  0000                              
ud0 di,di	; 00001184  0FFFFF                            
db 0xff	; 00001187  FF                                
db 0xff	; 00001188  FF                                
cld	; 00001189  FC                                
add [bx+si],al	; 0000118A  0000                              
add [bx+si],al	; 0000118C  0000                              
db 0xff	; 0000118E  FF                                
db 0xff	; 0000118F  FF                                
db 0xff	; 00001190  FF                                
inc ax	; 00001191  FFC0                              
add [bx+si],al	; 00001193  0000                              
add [bx+si],al	; 00001195  0000                              
add di,di	; 00001197  03FF                              
push ax	; 00001199  FFF0                              
add [bx+si],al	; 0000119B  0000                              
add [bx+si],al	; 0000119D  0000                              
add [bx+si],al	; 0000119F  0000                              
add [bx+si],al	; 000011A1  0000                              
add [bx+si],al	; 000011A3  0000                              
add [bx+si],al	; 000011A5  0000                              
add [bx+si],al	; 000011A7  0000                              
add [bx+si],al	; 000011A9  0000                              
add [bx+si],al	; 000011AB  0000                              
add [bx+si],al	; 000011AD  0000                              
add [bx+si],al	; 000011AF  0000                              
add [bx+si],al	; 000011B1  0000                              
add [bx+si],al	; 000011B3  0000                              
add [bx+si],al	; 000011B5  0000                              
add [bx+si],al	; 000011B7  0000                              
add [bx+si],al	; 000011B9  0000                              
add [bx+si],al	; 000011BB  0000                              
add [bx+si],al	; 000011BD  0000                              
add [bx+si],al	; 000011BF  0000                              
add [bx+si],al	; 000011C1  0000                              
add [bx+si],al	; 000011C3  0000                              
add [bx+si],al	; 000011C5  0000                              
add [bx+si],al	; 000011C7  0000                              
add [bx+si],al	; 000011C9  0000                              
add [bx+si],al	; 000011CB  0000                              
add [bx+si],al	; 000011CD  0000                              
add [bx+si],al	; 000011CF  0000                              
add [bx+si],al	; 000011D1  0000                              
add [bx+si],al	; 000011D3  0000                              
add [bx+si],al	; 000011D5  0000                              
add [bx+si],al	; 000011D7  0000                              
add [bx+si],al	; 000011D9  0000                              
add [bx+si],al	; 000011DB  0000                              
db 0xff	; 000011DD  FF                                
db 0xff	; 000011DE  FF                                
db 0xff	; 000011DF  FF                                
inc word [bx+si]	; 000011E0  FF00                              
add [bx+si],al	; 000011E2  0000                              
add [bx+si],al	; 000011E4  0000                              
db 0xff	; 000011E6  FF                                
db 0xff	; 000011E7  FF                                
db 0xff	; 000011E8  FF                                
inc word [bx+si]	; 000011E9  FF00                              
add [bx+si],al	; 000011EB  0000                              
add [bx+si],al	; 000011ED  0000                              
db 0xff	; 000011EF  FF                                
db 0xff	; 000011F0  FF                                
db 0xff	; 000011F1  FF                                
inc word [bx+si]	; 000011F2  FF00                              
add [bx+si],al	; 000011F4  0000                              
add [bx+si],al	; 000011F6  0000                              
db 0xff	; 000011F8  FF                                
db 0xff	; 000011F9  FF                                
db 0xff	; 000011FA  FF                                
inc word [bx+si]	; 000011FB  FF00                              
add [bx+si],al	; 000011FD  0000                              
add [bx+si],al	; 000011FF  0000                              
db 0xff	; 00001201  FF                                
db 0xff	; 00001202  FF                                
db 0xff	; 00001203  FF                                
inc word [bx+si]	; 00001204  FF00                              
add [bx+si],al	; 00001206  0000                              
add [bx+si],al	; 00001208  0000                              
db 0xff	; 0000120A  FF                                
db 0xff	; 0000120B  FF                                
db 0xff	; 0000120C  FF                                
inc word [bx+si]	; 0000120D  FF00                              
add [bx+si],al	; 0000120F  0000                              
add [bx+si],al	; 00001211  0000                              
db 0xff	; 00001213  FF                                
db 0xff	; 00001214  FF                                
db 0xff	; 00001215  FF                                
inc word [bx+si]	; 00001216  FF00                              
add [bx+si],al	; 00001218  0000                              
add [bx+si],al	; 0000121A  0000                              
db 0xff	; 0000121C  FF                                
db 0xff	; 0000121D  FF                                
db 0xff	; 0000121E  FF                                
inc word [bx+si]	; 0000121F  FF00                              
add [bx+si],al	; 00001221  0000                              
add [bx+si],al	; 00001223  0000                              
add [bx+si],al	; 00001225  0000                              
add [bx+si],al	; 00001227  0000                              
add [bx+si],al	; 00001229  0000                              
add [bx+si],al	; 0000122B  0000                              
add [bx+si],al	; 0000122D  0000                              
add [bx+si],al	; 0000122F  0000                              
add [bx+si],al	; 00001231  0000                              
add [bx+si],al	; 00001233  0000                              
add [bx+si],al	; 00001235  0000                              
add [bx+si],al	; 00001237  0000                              
add [bx+si],al	; 00001239  0000                              
add [bx+si],al	; 0000123B  0000                              
add [bx+si],al	; 0000123D  0000                              
add [bx+si],al	; 0000123F  0000                              
add [bx+si],al	; 00001241  0000                              
add [bx+si],al	; 00001243  0000                              
add [bx+si],al	; 00001245  0000                              
add [bx+si],al	; 00001247  0000                              
add [bx+si],al	; 00001249  0000                              
add [bx+si],al	; 0000124B  0000                              
add [bx+si],al	; 0000124D  0000                              
add [bx+si],al	; 0000124F  0000                              
add [bx+si],al	; 00001251  0000                              
add [bx+si],al	; 00001253  0000                              
add [bx+si],al	; 00001255  0000                              
add [bx+si],al	; 00001257  0000                              
add [bx+si],al	; 00001259  0000                              
add [bx+si],al	; 0000125B  0000                              
add [bx+si],al	; 0000125D  0000                              
add [bx+si],al	; 0000125F  0000                              
add [bx+si],al	; 00001261  0000                              
add [bx+si],al	; 00001263  0000                              
add [bx+si],al	; 00001265  0000                              
add [bx+si],al	; 00001267  0000                              
add [bx+si],al	; 00001269  0000                              
add [bx+si],al	; 0000126B  0000                              
add [bx+si],al	; 0000126D  0000                              
xor [bx+si],al	; 0000126F  3000                              
add [bp+di],al	; 00001271  0003                              
add [bx+si],al	; 00001273  0000                              
add [bx+si],al	; 00001275  0000                              
add ah,bh	; 00001277  00FC                              
add [bx+si],al	; 00001279  0000                              
xadd [bx+si],al	; 0000127B  0FC000                            
add [bx+si],al	; 0000127E  0000                              
add ah,bh	; 00001280  00FC                              
add [bx+si],al	; 00001282  0000                              
xadd [bx+si],al	; 00001284  0FC000                            
add [bx+si],al	; 00001287  0000                              
add bh,bh	; 00001289  00FF                              
add [bx+si],al	; 0000128B  0000                              
aas	; 0000128D  3F                                
rol byte [bx+si],byte 0x0	; 0000128E  C00000                            
add [bp+di],al	; 00001291  0003                              
inc word [bx+si]	; 00001293  FF00                              
add [bx],bh	; 00001295  003F                              
lock add [bx+si],al	; 00001297  F00000                            
add [bp+di],al	; 0000129A  0003                              
inc ax	; 0000129C  FFC0                              
add bh,bh	; 0000129E  00FF                              
lock add [bx+si],al	; 000012A0  F00000                            
add [bp+di],al	; 000012A3  0003                              
inc ax	; 000012A5  FFC0                              
add bh,bh	; 000012A7  00FF                              
lock add [bx+si],al	; 000012A9  F00000                            
add [bx],cl	; 000012AC  000F                              
push ax	; 000012AE  FFF0                              
add di,di	; 000012B0  03FF                              
cld	; 000012B2  FC                                
add [bx+si],al	; 000012B3  0000                              
add [bx],cl	; 000012B5  000F                              
db 0xff	; 000012B7  FF                                
cld	; 000012B8  FC                                
ud0 di,sp	; 000012B9  0FFFFC                            
add [bx+si],al	; 000012BC  0000                              
add [bx],cl	; 000012BE  000F                              
db 0xff	; 000012C0  FF                                
cld	; 000012C1  FC                                
ud0 di,sp	; 000012C2  0FFFFC                            
add [bx+si],al	; 000012C5  0000                              
add [bx],bh	; 000012C7  003F                              
db 0xff	; 000012C9  FF                                
db 0xff	; 000012CA  FF                                
aas	; 000012CB  3F                                
db 0xff	; 000012CC  FF                                
inc word [bx+si]	; 000012CD  FF00                              
add [bx+si],al	; 000012CF  0000                              
aas	; 000012D1  3F                                
db 0xff	; 000012D2  FF                                
db 0xff	; 000012D3  FF                                
db 0xff	; 000012D4  FF                                
db 0xff	; 000012D5  FF                                
inc word [bx+si]	; 000012D6  FF00                              
add [bx+si],al	; 000012D8  0000                              
db 0xff	; 000012DA  FF                                
db 0xff	; 000012DB  FF                                
db 0xff	; 000012DC  FF                                
db 0xff	; 000012DD  FF                                
db 0xff	; 000012DE  FF                                
inc ax	; 000012DF  FFC0                              
add [bx+si],al	; 000012E1  0000                              
db 0xff	; 000012E3  FF                                
db 0xff	; 000012E4  FF                                
db 0xff	; 000012E5  FF                                
db 0xff	; 000012E6  FF                                
db 0xff	; 000012E7  FF                                
inc ax	; 000012E8  FFC0                              
add [bp+di],al	; 000012EA  0003                              
db 0xff	; 000012EC  FF                                
db 0xff	; 000012ED  FF                                
db 0xff	; 000012EE  FF                                
db 0xff	; 000012EF  FF                                
db 0xff	; 000012F0  FF                                
push ax	; 000012F1  FFF0                              
add [bp+di],al	; 000012F3  0003                              
db 0xff	; 000012F5  FF                                
db 0xff	; 000012F6  FF                                
db 0xff	; 000012F7  FF                                
db 0xff	; 000012F8  FF                                
db 0xff	; 000012F9  FF                                
push ax	; 000012FA  FFF0                              
add [bx],cl	; 000012FC  000F                              
db 0xff	; 000012FE  FF                                
cld	; 000012FF  FC                                
db 0xff	; 00001300  FF                                
dec di	; 00001301  FFCF                              
db 0xff	; 00001303  FF                                
cld	; 00001304  FC                                
add [bx],cl	; 00001305  000F                              
db 0xff	; 00001307  FF                                
cld	; 00001308  FC                                
db 0xff	; 00001309  FF                                
dec di	; 0000130A  FFCF                              
db 0xff	; 0000130C  FF                                
cld	; 0000130D  FC                                
add [bx],cl	; 0000130E  000F                              
db 0xff	; 00001310  FF                                
cld	; 00001311  FC                                
db 0xff	; 00001312  FF                                
dec di	; 00001313  FFCF                              
db 0xff	; 00001315  FF                                
cld	; 00001316  FC                                
add [bx],bh	; 00001317  003F                              
db 0xff	; 00001319  FF                                
cld	; 0000131A  FC                                
db 0xff	; 0000131B  FF                                
dec di	; 0000131C  FFCF                              
db 0xff	; 0000131E  FF                                
inc word [bx+si]	; 0000131F  FF00                              
aas	; 00001321  3F                                
db 0xff	; 00001322  FF                                
cld	; 00001323  FC                                
db 0xff	; 00001324  FF                                
dec di	; 00001325  FFCF                              
db 0xff	; 00001327  FF                                
inc word [bx+si]	; 00001328  FF00                              
db 0xff	; 0000132A  FF                                
db 0xff	; 0000132B  FF                                
cld	; 0000132C  FC                                
db 0xff	; 0000132D  FF                                
dec di	; 0000132E  FFCF                              
db 0xff	; 00001330  FF                                
inc ax	; 00001331  FFC0                              
db 0xff	; 00001333  FF                                
db 0xff	; 00001334  FF                                
cld	; 00001335  FC                                
db 0xff	; 00001336  FF                                
dec di	; 00001337  FFCF                              
db 0xff	; 00001339  FF                                
inc ax	; 0000133A  FFC0                              
add [bx+si],al	; 0000133C  0000                              
ud0 ax,ax	; 0000133E  0FFFC0                            
add [bx+si],al	; 00001341  0000                              
add [bx+si],al	; 00001343  0000                              
add [bx+si],al	; 00001345  0000                              
db 0xff	; 00001347  FF                                
db 0xff	; 00001348  FF                                
cld	; 00001349  FC                                
add [bx+si],al	; 0000134A  0000                              
add [bx+si],al	; 0000134C  0000                              
add [bx],cl	; 0000134E  000F                              
db 0xff	; 00001350  FF                                
db 0xff	; 00001351  FF                                
inc ax	; 00001352  FFC0                              
add [bx+si],al	; 00001354  0000                              
add [bx+si],al	; 00001356  0000                              
aas	; 00001358  3F                                
db 0xff	; 00001359  FF                                
db 0xff	; 0000135A  FF                                
push ax	; 0000135B  FFF0                              
add [bx+si],al	; 0000135D  0000                              
add [bx+si],al	; 0000135F  0000                              
aas	; 00001361  3F                                
db 0xff	; 00001362  FF                                
db 0xff	; 00001363  FF                                
push ax	; 00001364  FFF0                              
add [bx+si],al	; 00001366  0000                              
add [bx+si],al	; 00001368  0000                              
db 0xff	; 0000136A  FF                                
db 0xff	; 0000136B  FF                                
db 0xff	; 0000136C  FF                                
db 0xff	; 0000136D  FF                                
cld	; 0000136E  FC                                
add [bx+si],al	; 0000136F  0000                              
add [bx+si],al	; 00001371  0000                              
db 0xff	; 00001373  FF                                
dec di	; 00001374  FFCF                              
db 0xff	; 00001376  FF                                
cld	; 00001377  FC                                
add [bx+si],al	; 00001378  0000                              
add [bp+di],al	; 0000137A  0003                              
db 0xff	; 0000137C  FF                                
dec di	; 0000137D  FFCF                              
db 0xff	; 0000137F  FF                                
inc word [bx+si]	; 00001380  FF00                              
add [bx+si],al	; 00001382  0000                              
add di,di	; 00001384  03FF                              
dec di	; 00001386  FFCF                              
db 0xff	; 00001388  FF                                
inc word [bx+si]	; 00001389  FF00                              
add [bx+si],al	; 0000138B  0000                              
add di,di	; 0000138D  03FF                              
dec di	; 0000138F  FFCF                              
db 0xff	; 00001391  FF                                
inc word [bx+si]	; 00001392  FF00                              
add [bx+si],al	; 00001394  0000                              
add di,di	; 00001396  03FF                              
dec di	; 00001398  FFCF                              
db 0xff	; 0000139A  FF                                
inc word [bx+si]	; 0000139B  FF00                              
add [bx+si],al	; 0000139D  0000                              
add di,di	; 0000139F  03FF                              
db 0xff	; 000013A1  FF                                
db 0xff	; 000013A2  FF                                
db 0xff	; 000013A3  FF                                
inc word [bx+si]	; 000013A4  FF00                              
add [bx+si],al	; 000013A6  0000                              
add di,di	; 000013A8  03FF                              
db 0xff	; 000013AA  FF                                
db 0xff	; 000013AB  FF                                
db 0xff	; 000013AC  FF                                
inc word [bx+si]	; 000013AD  FF00                              
add [bx+si],al	; 000013AF  0000                              
add di,di	; 000013B1  03FF                              
db 0xff	; 000013B3  FF                                
db 0xff	; 000013B4  FF                                
db 0xff	; 000013B5  FF                                
inc word [bx+si]	; 000013B6  FF00                              
add [bx+si],al	; 000013B8  0000                              
add di,di	; 000013BA  03FF                              
db 0xff	; 000013BC  FF                                
db 0xff	; 000013BD  FF                                
db 0xff	; 000013BE  FF                                
inc word [bx+si]	; 000013BF  FF00                              
add [bx+si],al	; 000013C1  0000                              
add di,di	; 000013C3  03FF                              
db 0xff	; 000013C5  FF                                
db 0xff	; 000013C6  FF                                
db 0xff	; 000013C7  FF                                
inc word [bx+si]	; 000013C8  FF00                              
add [bx+si],al	; 000013CA  0000                              
add di,di	; 000013CC  03FF                              
db 0xff	; 000013CE  FF                                
db 0xff	; 000013CF  FF                                
db 0xff	; 000013D0  FF                                
inc word [bx+si]	; 000013D1  FF00                              
add [bx+si],al	; 000013D3  0000                              
add di,di	; 000013D5  03FF                              
dec di	; 000013D7  FFCF                              
db 0xff	; 000013D9  FF                                
inc word [bx+si]	; 000013DA  FF00                              
add [bx+si],al	; 000013DC  0000                              
add di,di	; 000013DE  03FF                              
dec di	; 000013E0  FFCF                              
db 0xff	; 000013E2  FF                                
inc word [bx+si]	; 000013E3  FF00                              
add [bx+si],al	; 000013E5  0000                              
add di,di	; 000013E7  03FF                              
dec di	; 000013E9  FFCF                              
db 0xff	; 000013EB  FF                                
inc word [bx+si]	; 000013EC  FF00                              
add [bx+si],al	; 000013EE  0000                              
add di,di	; 000013F0  03FF                              
dec di	; 000013F2  FFCF                              
db 0xff	; 000013F4  FF                                
inc word [bx+si]	; 000013F5  FF00                              
add [bx+si],al	; 000013F7  0000                              
add di,di	; 000013F9  03FF                              
dec di	; 000013FB  FFCF                              
db 0xff	; 000013FD  FF                                
inc word [bx+si]	; 000013FE  FF00                              
add [bx+si],al	; 00001400  0000                              
add di,di	; 00001402  03FF                              
dec di	; 00001404  FFCF                              
db 0xff	; 00001406  FF                                
inc word [bx+si]	; 00001407  FF00                              
add [bx+si],al	; 00001409  0000                              
add di,di	; 0000140B  03FF                              
db 0xff	; 0000140D  FF                                
inc word [bx+si]	; 0000140E  FF00                              
add [bx+si],al	; 00001410  0000                              
add [bx+si],al	; 00001412  0000                              
add di,di	; 00001414  03FF                              
db 0xff	; 00001416  FF                                
db 0xff	; 00001417  FF                                
cld	; 00001418  FC                                
add [bx+si],al	; 00001419  0000                              
add [bx+si],al	; 0000141B  0000                              
add di,di	; 0000141D  03FF                              
db 0xff	; 0000141F  FF                                
db 0xff	; 00001420  FF                                
inc ax	; 00001421  FFC0                              
add [bx+si],al	; 00001423  0000                              
add [bp+di],al	; 00001425  0003                              
db 0xff	; 00001427  FF                                
db 0xff	; 00001428  FF                                
db 0xff	; 00001429  FF                                
push ax	; 0000142A  FFF0                              
add [bx+si],al	; 0000142C  0000                              
add [bp+di],al	; 0000142E  0003                              
db 0xff	; 00001430  FF                                
db 0xff	; 00001431  FF                                
db 0xff	; 00001432  FF                                
push ax	; 00001433  FFF0                              
add [bx+si],al	; 00001435  0000                              
add [bp+di],al	; 00001437  0003                              
db 0xff	; 00001439  FF                                
db 0xff	; 0000143A  FF                                
db 0xff	; 0000143B  FF                                
db 0xff	; 0000143C  FF                                
cld	; 0000143D  FC                                
add [bx+si],al	; 0000143E  0000                              
add [bp+di],al	; 00001440  0003                              
db 0xff	; 00001442  FF                                
db 0xff	; 00001443  FF                                
db 0xff	; 00001444  FF                                
db 0xff	; 00001445  FF                                
cld	; 00001446  FC                                
add [bx+si],al	; 00001447  0000                              
add [bp+di],al	; 00001449  0003                              
db 0xff	; 0000144B  FF                                
db 0xff	; 0000144C  FF                                
db 0xff	; 0000144D  FF                                
db 0xff	; 0000144E  FF                                
inc word [bx+si]	; 0000144F  FF00                              
add [bx+si],al	; 00001451  0000                              
add di,di	; 00001453  03FF                              
db 0xff	; 00001455  FF                                
db 0xff	; 00001456  FF                                
db 0xff	; 00001457  FF                                
inc word [bx+si]	; 00001458  FF00                              
add [bx+si],al	; 0000145A  0000                              
add di,di	; 0000145C  03FF                              
db 0xff	; 0000145E  FF                                
db 0xff	; 0000145F  FF                                
db 0xff	; 00001460  FF                                
inc word [bx+si]	; 00001461  FF00                              
add [bx+si],al	; 00001463  0000                              
add di,di	; 00001465  03FF                              
db 0xff	; 00001467  FF                                
db 0xff	; 00001468  FF                                
db 0xff	; 00001469  FF                                
inc word [bx+si]	; 0000146A  FF00                              
add [bx+si],al	; 0000146C  0000                              
add di,di	; 0000146E  03FF                              
dec di	; 00001470  FFCF                              
db 0xff	; 00001472  FF                                
inc word [bx+si]	; 00001473  FF00                              
add [bx+si],al	; 00001475  0000                              
add di,di	; 00001477  03FF                              
dec di	; 00001479  FFCF                              
db 0xff	; 0000147B  FF                                
inc word [bx+si]	; 0000147C  FF00                              
add [bx+si],al	; 0000147E  0000                              
add di,di	; 00001480  03FF                              
dec di	; 00001482  FFCF                              
db 0xff	; 00001484  FF                                
inc word [bx+si]	; 00001485  FF00                              
add [bx+si],al	; 00001487  0000                              
add di,di	; 00001489  03FF                              
dec di	; 0000148B  FFCF                              
db 0xff	; 0000148D  FF                                
inc word [bx+si]	; 0000148E  FF00                              
add [bx+si],al	; 00001490  0000                              
add di,di	; 00001492  03FF                              
dec di	; 00001494  FFCF                              
db 0xff	; 00001496  FF                                
inc word [bx+si]	; 00001497  FF00                              
add [bx+si],al	; 00001499  0000                              
add di,di	; 0000149B  03FF                              
dec di	; 0000149D  FFCF                              
db 0xff	; 0000149F  FF                                
inc word [bx+si]	; 000014A0  FF00                              
add [bx+si],al	; 000014A2  0000                              
add di,di	; 000014A4  03FF                              
dec di	; 000014A6  FFCF                              
db 0xff	; 000014A8  FF                                
inc word [bx+si]	; 000014A9  FF00                              
add [bx+si],al	; 000014AB  0000                              
add di,di	; 000014AD  03FF                              
dec di	; 000014AF  FFCF                              
db 0xff	; 000014B1  FF                                
inc word [bx+si]	; 000014B2  FF00                              
add [bx+si],al	; 000014B4  0000                              
add di,di	; 000014B6  03FF                              
dec di	; 000014B8  FFCF                              
db 0xff	; 000014BA  FF                                
inc word [bx+si]	; 000014BB  FF00                              
add [bx+si],al	; 000014BD  0000                              
add di,di	; 000014BF  03FF                              
dec di	; 000014C1  FFCF                              
db 0xff	; 000014C3  FF                                
inc word [bx+si]	; 000014C4  FF00                              
add [bx+si],al	; 000014C6  0000                              
add di,di	; 000014C8  03FF                              
dec di	; 000014CA  FFCF                              
db 0xff	; 000014CC  FF                                
inc word [bx+si]	; 000014CD  FF00                              
add [bx+si],al	; 000014CF  0000                              
add di,di	; 000014D1  03FF                              
dec di	; 000014D3  FFCF                              
db 0xff	; 000014D5  FF                                
inc word [bx+si]	; 000014D6  FF00                              
add [bx+si],al	; 000014D8  0000                              
pop es	; 000014DA  07                                
add [bx+di],cl	; 000014DB  0009                              
add [di],al	; 000014DD  0005                              
add [bp+si],cl	; 000014DF  000A                              
add [bx],al	; 000014E1  0007                              
add [bx],al	; 000014E3  0007                              
add [si+0x3],dl	; 000014E5  005403                            
push sp	; 000014E8  54                                
add ax,[bp+si]	; 000014E9  0302                              
add [bp+si],al	; 000014EB  0002                              
add [bx-0x78fd],al	; 000014ED  00870387                          
add ax,[bp+si]	; 000014F1  0302                              
add [bp+si],al	; 000014F3  0002                              
add [di-0x42fd],bh	; 000014F5  00BD03BD                          
add ax,[bx-0x78fd]	; 000014F9  03870387                          
add di,[di-0x42fd]	; 000014FD  03BD03BD                          
add si,bp	; 00001501  03F5                              
add si,bp	; 00001503  03F5                              
add si,[bp+si]	; 00001505  0332                              
add al,0x32	; 00001507  0432                              
add al,0x2	; 00001509  0402                              
add [bp+si],al	; 0000150B  0002                              
add [bp+si+0x4],dh	; 0000150D  007204                            
jc 0x1516	; 00001510  7204                              
add al,[bx+si]	; 00001512  0200                              
add al,[bx+si]	; 00001514  0200                              
mov ch,0x4	; 00001516  B504                              
mov ch,0x4	; 00001518  B504                              
mov ch,0x4	; 0000151A  B504                              
mov ch,0x4	; 0000151C  B504                              
jc 0x1524	; 0000151E  7204                              
jc 0x1526	; 00001520  7204                              
jc 0x1528	; 00001522  7204                              
jc 0x152a	; 00001524  7204                              
cmc	; 00001526  F5                                
add si,bp	; 00001527  03F5                              
add ax,[bp+si]	; 00001529  0302                              
add [bp+si],al	; 0000152B  0002                              
add [bp+si],dh	; 0000152D  0032                              
add al,0x32	; 0000152F  0432                              
add al,0x2	; 00001531  0402                              
add [bp+si],al	; 00001533  0002                              
add [bp+si+0x4],dh	; 00001535  007204                            
jc 0x153e	; 00001538  7204                              
xor al,[si]	; 0000153A  3204                              
xor al,[si]	; 0000153C  3204                              
jc 0x1544	; 0000153E  7204                              
jc 0x1546	; 00001540  7204                              
mov ch,0x4	; 00001542  B504                              
mov ch,0x4	; 00001544  B504                              
std	; 00001546  FD                                
add al,0xfd	; 00001547  04FD                              
add al,0x2	; 00001549  0402                              
add [bp+si],al	; 0000154B  0002                              
add [bx+di+0x5],cl	; 0000154D  004905                            
dec cx	; 00001550  49                                
add ax,0x2	; 00001551  050200                            
add al,[bx+si]	; 00001554  0200                              
cwd	; 00001556  99                                
add ax,0x599	; 00001557  059905                            
cwd	; 0000155A  99                                
add ax,0x599	; 0000155B  059905                            
dec cx	; 0000155E  49                                
add ax,0x549	; 0000155F  054905                            
dec cx	; 00001562  49                                
add ax,0x549	; 00001563  054905                            
jc 0x156c	; 00001566  7204                              
jc 0x156e	; 00001568  7204                              
add al,[bx+si]	; 0000156A  0200                              
add al,[bx+si]	; 0000156C  0200                              
out dx,al	; 0000156E  EE                                
add ax,0x2	; 0000156F  050200                            
out dx,al	; 00001572  EE                                
add ax,0x2	; 00001573  050200                            
dec cx	; 00001576  49                                
push es	; 00001577  06                                
dec cx	; 00001578  49                                
push es	; 00001579  06                                
dec cx	; 0000157A  49                                
push es	; 0000157B  06                                
dec cx	; 0000157C  49                                
push es	; 0000157D  06                                
out dx,al	; 0000157E  EE                                
add ax,0x5ee	; 0000157F  05EE05                            
out dx,al	; 00001582  EE                                
add ax,0x5ee	; 00001583  05EE05                            
jc 0x158c	; 00001586  7204                              
jc 0x158e	; 00001588  7204                              
add al,[bx+si]	; 0000158A  0200                              
add al,[bx+si]	; 0000158C  0200                              
out dx,al	; 0000158E  EE                                
add ax,0x2	; 0000158F  050200                            
out dx,al	; 00001592  EE                                
add ax,0x2	; 00001593  050200                            
dec cx	; 00001596  49                                
push es	; 00001597  06                                
dec cx	; 00001598  49                                
push es	; 00001599  06                                
dec cx	; 0000159A  49                                
push es	; 0000159B  06                                
dec cx	; 0000159C  49                                
push es	; 0000159D  06                                
out dx,al	; 0000159E  EE                                
add ax,0x5ee	; 0000159F  05EE05                            
out dx,al	; 000015A2  EE                                
add ax,0x5ee	; 000015A3  05EE05                            
push cs	; 000015A6  0E                                
pop es	; 000015A7  07                                
push cs	; 000015A8  0E                                
pop es	; 000015A9  07                                
test al,0x6	; 000015AA  A806                              
test al,0x6	; 000015AC  A806                              
dec cx	; 000015AE  49                                
push es	; 000015AF  06                                
dec cx	; 000015B0  49                                
push es	; 000015B1  06                                
out dx,al	; 000015B2  EE                                
add ax,0x5ee	; 000015B3  05EE05                            
cwd	; 000015B6  99                                
add ax,0x599	; 000015B7  059905                            
dec cx	; 000015BA  49                                
add ax,0x549	; 000015BB  054905                            
std	; 000015BE  FD                                
add al,0xfd	; 000015BF  04FD                              
add al,0xb5	; 000015C1  04B5                              
add al,0xb5	; 000015C3  04B5                              
add al,0x72	; 000015C5  0472                              
add al,0x72	; 000015C7  0472                              
add al,0x2	; 000015C9  0402                              
add [bp+si],al	; 000015CB  0002                              
add [bp+si],dh	; 000015CD  0032                              
add al,0x32	; 000015CF  0432                              
add al,0x2	; 000015D1  0402                              
add [bp+si],al	; 000015D3  0002                              
add ch,dh	; 000015D5  00F5                              
add si,bp	; 000015D7  03F5                              
add ax,[bp+si]	; 000015D9  0302                              
add [bp+si],al	; 000015DB  0002                              
add [bx-0x78fd],al	; 000015DD  00870387                          
add ax,[bp+si]	; 000015E1  0302                              
add [bp+si],al	; 000015E3  0002                              
add [si+0x3],dl	; 000015E5  005403                            
push sp	; 000015E8  54                                
add dx,[si+0x3]	; 000015E9  035403                            
push sp	; 000015EC  54                                
add dx,[si+0x3]	; 000015ED  035403                            
push sp	; 000015F0  54                                
add dx,[si+0x3]	; 000015F1  035403                            
push sp	; 000015F4  54                                
add ax,[bp+si]	; 000015F5  0302                              
add [bp+di],dl	; 000015F7  0013                              
or [bp+si+0x79],sp	; 000015F9  096279                            
add [di],cl	; 000015FC  000D                              
or ax,[bx+0x72]	; 000015FE  0B4772                            
and [gs:ebx+0x75],cl	; 00001601  6567204B75                        
jo 0x166d	; 00001606  7065                              
jc 0x166c	; 00001608  7262                              
gs jc 0x1674	; 0000160A  657267                            
add [bp+di],al	; 0000160D  0003                              
adc [bx+si+0x52],dl	; 0000160F  105052                            
inc bp	; 00001612  45                                
push bx	; 00001613  53                                
push bx	; 00001614  53                                
and [bp+di+0x70],dh	; 00001615  207370                            
popa	; 00001618  61                                
arpl [di+0x20],sp	; 00001619  636520                            
bound sp,[bx+di+0x72]	; 0000161C  626172                            
and [bp+0x4f],al	; 0000161F  20464F                            
push dx	; 00001622  52                                
and [bp+di+0x45],cl	; 00001623  204B45                            
pop cx	; 00001626  59                                
inc dx	; 00001627  42                                
dec di	; 00001628  4F                                
inc cx	; 00001629  41                                
push dx	; 0000162A  52                                
inc sp	; 0000162B  44                                
and [bx+si+0x4c],dl	; 0000162C  20504C                            
inc cx	; 0000162F  41                                
pop cx	; 00001630  59                                
add [bp+si],al	; 00001631  0002                              
adc ah,[bx+si]	; 00001633  1220                              
and [bx+si],ah	; 00001635  2020                              
and [bx+0x52],cl	; 00001637  204F52                            
and [bp+si],ah	; 0000163A  2022                              
dec dx	; 0000163C  4A                                
and ch,[di]	; 0000163D  222D                              
imul sp,[di+0x79],0x20	; 0000163F  6B657920                          
inc si	; 00001643  46                                
dec di	; 00001644  4F                                
push dx	; 00001645  52                                
and [bp+si+0x4f],cl	; 00001646  204A4F                            
pop cx	; 00001649  59                                
push bx	; 0000164A  53                                
push sp	; 0000164B  54                                
dec cx	; 0000164C  49                                
inc bx	; 0000164D  43                                
dec bx	; 0000164E  4B                                
and [bx+si+0x4c],dl	; 0000164F  20504C                            
inc cx	; 00001652  41                                
pop cx	; 00001653  59                                
and [bx+si],ah	; 00001654  2020                              
and [bx+si],ah	; 00001656  2020                              
add [0x2818],al	; 00001658  00061828                          
inc bx	; 0000165C  43                                
sub [bx+di],si	; 0000165D  2931                              
cmp [bx+si],di	; 0000165F  3938                              
xor ah,[bx+si]	; 00001661  3220                              
dec di	; 00001663  4F                                
push dx	; 00001664  52                                
dec cx	; 00001665  49                                
dec di	; 00001666  4F                                
dec si	; 00001667  4E                                
and [bp+di+0x4f],dl	; 00001668  20534F                            
inc si	; 0000166B  46                                
push sp	; 0000166C  54                                
push di	; 0000166D  57                                
inc cx	; 0000166E  41                                
push dx	; 0000166F  52                                
inc bp	; 00001670  45                                
sub al,0x20	; 00001671  2C20                              
dec cx	; 00001673  49                                
dec si	; 00001674  4E                                
inc bx	; 00001675  43                                
add [cs:bp+di],al	; 00001676  2E0003                            
or al,0x50	; 00001679  0C50                              
push dx	; 0000167B  52                                
inc bp	; 0000167C  45                                
push bx	; 0000167D  53                                
push bx	; 0000167E  53                                
and [bp+di+0x70],dh	; 0000167F  207370                            
popa	; 00001682  61                                
arpl [di+0x20],sp	; 00001683  636520                            
bound sp,[bx+di+0x72]	; 00001686  626172                            
and [bp+0x4f],al	; 00001689  20464F                            
push dx	; 0000168C  52                                
and [bp+di+0x45],cl	; 0000168D  204B45                            
pop cx	; 00001690  59                                
inc dx	; 00001691  42                                
dec di	; 00001692  4F                                
inc cx	; 00001693  41                                
push dx	; 00001694  52                                
inc sp	; 00001695  44                                
and [bx+si+0x4c],dl	; 00001696  20504C                            
inc cx	; 00001699  41                                
pop cx	; 0000169A  59                                
add [bp+si],al	; 0000169B  0002                              
push cs	; 0000169D  0E                                
and [bx+si],ah	; 0000169E  2020                              
and [bx+si],ah	; 000016A0  2020                              
dec di	; 000016A2  4F                                
push dx	; 000016A3  52                                
and [bp+si],ah	; 000016A4  2022                              
dec dx	; 000016A6  4A                                
and ch,[di]	; 000016A7  222D                              
imul sp,[di+0x79],0x20	; 000016A9  6B657920                          
inc si	; 000016AD  46                                
dec di	; 000016AE  4F                                
push dx	; 000016AF  52                                
and [bp+si+0x4f],cl	; 000016B0  204A4F                            
pop cx	; 000016B3  59                                
push bx	; 000016B4  53                                
push sp	; 000016B5  54                                
dec cx	; 000016B6  49                                
inc bx	; 000016B7  43                                
dec bx	; 000016B8  4B                                
and [bx+si+0x4c],dl	; 000016B9  20504C                            
inc cx	; 000016BC  41                                
pop cx	; 000016BD  59                                
and [bx+si],ah	; 000016BE  2020                              
and [bx+si],ah	; 000016C0  2020                              
add [bp+di+0x43],dl	; 000016C2  005343                            
dec di	; 000016C5  4F                                
push dx	; 000016C6  52                                
inc bp	; 000016C7  45                                
or ax,0x200a	; 000016C8  0D0A20                            
and [bx+si],ah	; 000016CB  2020                              
and [bx+si],ah	; 000016CD  2020                              
xor [di],cl	; 000016CF  300D                              
or cl,[bp+si]	; 000016D1  0A0A                              
or cl,[bp+si]	; 000016D3  0A0A                              
and [bx+si+0x49],cl	; 000016D5  204849                            
inc di	; 000016D8  47                                
dec ax	; 000016D9  48                                
or ax,0x200a	; 000016DA  0D0A20                            
push bx	; 000016DD  53                                
inc bx	; 000016DE  43                                
dec di	; 000016DF  4F                                
push dx	; 000016E0  52                                
inc bp	; 000016E1  45                                
or ax,0x200a	; 000016E2  0D0A20                            
and [bx+si],ah	; 000016E5  2020                              
and [bx+si],ah	; 000016E7  2020                              
xor [bx+di],ah	; 000016E9  3021                              
pop cx	; 000016EB  59                                
inc sp	; 000016EC  44                                
inc cx	; 000016ED  41                                
inc bp	; 000016EE  45                                
push dx	; 000016EF  52                                
add ax,[bx+si]	; 000016F0  0300                              
add al,cl	; 000016F2  00C8                              
or al,0x0	; 000016F4  0C00                              
and [bx+si+0x1c],bh	; 000016F6  20781C                            
add [bx+si],ah	; 000016F9  0020                              
xchg ax,si	; 000016FB  96                                
sbb al,0x0	; 000016FC  1C00                              
sub [bp+si+0x1c],bl	; 000016FE  285A1C                            
add [bx+si],ch	; 00001701  0028                              
js 0x1741	; 00001703  783C                              
add [bx+si+0x3c],al	; 00001705  00403C                            
cmp al,0x0	; 00001708  3C00                              
inc ax	; 0000170A  40                                
cmp al,0x3c	; 0000170B  3C3C                              
add [bx+si+0x1e],al	; 0000170D  00401E                            
cmp al,0x0	; 00001710  3C00                              
push ax	; 00001712  50                                
or bh,[si]	; 00001713  0A3C                              
add [bx+si+0x3c14],al	; 00001715  0080143C                          
add [bx+si+0x3c05],al	; 00001719  0080053C                          
add [bx+si+0x3c05],al	; 0000171D  0080053C                          
db 0xff	; 00001721  FF                                
inc word [bx+si]	; 00001722  FF00                              
add [bx+si],al	; 00001724  0000                              
jpe 0x1756	; 00001726  7A2E                              
sbb [0x7a00],cx	; 00001728  190E007A                          
cs push cs	; 0000172C  2E0E                              
push cs	; 0000172E  0E                                
add [bx+si],al	; 0000172F  0000                              
add [bx+si],al	; 00001731  0000                              
add [bx+si],al	; 00001733  0000                              
add [bx+si],al	; 00001735  0000                              
add [bx+si],al	; 00001737  0000                              
add [bx+si],al	; 00001739  0000                              
add [bx+si],al	; 0000173B  0000                              
add [bx+si],al	; 0000173D  0000                              
add [bx+si],al	; 0000173F  0000                              
add [bx+si],al	; 00001741  0000                              
add [bx+si],al	; 00001743  0000                              
add [bx+si],al	; 00001745  0000                              
add [bx+si],al	; 00001747  0000                              
add [bx+si],al	; 00001749  0000                              
add [bx+si],al	; 0000174B  0000                              
add [bx+si],al	; 0000174D  0000                              
add [bx+si],al	; 0000174F  0000                              
add [bx+si],al	; 00001751  0000                              
add [bx+si],al	; 00001753  0000                              
add [bx+si],al	; 00001755  0000                              
add [bx+si],al	; 00001757  0000                              
add [bx+si],al	; 00001759  0000                              
add [bx+si],al	; 0000175B  0000                              
add [bx+si],al	; 0000175D  0000                              
add [bx+si],al	; 0000175F  0000                              
add [bx+si],al	; 00001761  0000                              
add [bx+si],al	; 00001763  0000                              
add [bx+si],al	; 00001765  0000                              
add [bx+si],al	; 00001767  0000                              
add [bx+si],al	; 00001769  0000                              
add [bx+si],al	; 0000176B  0000                              
add [bx+si],al	; 0000176D  0000                              
add [bx+si],al	; 0000176F  0000                              
add [bx+si],al	; 00001771  0000                              
add [bx+si],al	; 00001773  0000                              
add [bx+si],al	; 00001775  0000                              
add [bx+si],al	; 00001777  0000                              
add [bx+si],al	; 00001779  0000                              
add [bx+si],al	; 0000177B  0000                              
add [bx+si],al	; 0000177D  0000                              
add [bx+si],al	; 0000177F  0000                              
add [bx+si],al	; 00001781  0000                              
add [bx+si],al	; 00001783  0000                              
add [bx+si],al	; 00001785  0000                              
add [bx+si],al	; 00001787  0000                              
add [bx+si],al	; 00001789  0000                              
add [bx+si],al	; 0000178B  0000                              
add [bx+si],al	; 0000178D  0000                              
add [bx+si],al	; 0000178F  0000                              
add [bx+si],al	; 00001791  0000                              
add [bx+si],al	; 00001793  0000                              
add [bx+si],al	; 00001795  0000                              
add [bx+si],al	; 00001797  0000                              
add [bx+si],al	; 00001799  0000                              
add [bx+si],al	; 0000179B  0000                              
add [bx+si],al	; 0000179D  0000                              
add [bx+si],al	; 0000179F  0000                              
add ch,[di+0x30]	; 000017A1  026D30                            
sbb ah,[0x6d00]	; 000017A4  1A26006D                          
xor [0xe],cl	; 000017A8  300E0E00                          
add al,0x0	; 000017AC  0400                              
add [bx+si],al	; 000017AE  0000                              
add [bx+si],al	; 000017B0  0000                              
add [bx+si],al	; 000017B2  0000                              
add [bx+si],al	; 000017B4  0000                              
add [bx+si],al	; 000017B6  0000                              
add [bx+si],al	; 000017B8  0000                              
add [bx+si],al	; 000017BA  0000                              
add [bx+si],al	; 000017BC  0000                              
add [bx+si],al	; 000017BE  0000                              
add [bx+si],al	; 000017C0  0000                              
add [bx+si],al	; 000017C2  0000                              
add [bx+si],al	; 000017C4  0000                              
add [bx+si],al	; 000017C6  0000                              
add [bx+si],al	; 000017C8  0000                              
add [bx+si],al	; 000017CA  0000                              
add [bx+si],al	; 000017CC  0000                              
add [bx+si],al	; 000017CE  0000                              
add [bx+si],al	; 000017D0  0000                              
add [bx+si],al	; 000017D2  0000                              
add [bx+si],al	; 000017D4  0000                              
add [bx+si],al	; 000017D6  0000                              
add [bx+si],al	; 000017D8  0000                              
add [bx+si],al	; 000017DA  0000                              
add [bx+si],al	; 000017DC  0000                              
add [bx+si],al	; 000017DE  0000                              
add [bx+si],al	; 000017E0  0000                              
add [bx+si],al	; 000017E2  0000                              
add [bx+si],al	; 000017E4  0000                              
add [bx+si],al	; 000017E6  0000                              
add [bx+si],al	; 000017E8  0000                              
add [bx+si],al	; 000017EA  0000                              
add [bx+si],al	; 000017EC  0000                              
add [bx+si],al	; 000017EE  0000                              
add [bx+si],al	; 000017F0  0000                              
add [bx+si],al	; 000017F2  0000                              
add [bx+si],al	; 000017F4  0000                              
add [bx+si],al	; 000017F6  0000                              
add [bx+si],al	; 000017F8  0000                              
add [bx+si],al	; 000017FA  0000                              
add [bx+si],al	; 000017FC  0000                              
add [bx+si],al	; 000017FE  0000                              
add [bx+si],al	; 00001800  0000                              
add [bx+si],al	; 00001802  0000                              
add [bx+si],al	; 00001804  0000                              
add [bx+si],al	; 00001806  0000                              
add [bx+si],al	; 00001808  0000                              
add [bx+si],al	; 0000180A  0000                              
add [bx+si],al	; 0000180C  0000                              
add [bx+si],al	; 0000180E  0000                              
add [bx+si],al	; 00001810  0000                              
add [bx+si],al	; 00001812  0000                              
add [bx+si],al	; 00001814  0000                              
add [bx+si],al	; 00001816  0000                              
add [bx+si],al	; 00001818  0000                              
add [bx+si],al	; 0000181A  0000                              
add [bp+di],al	; 0000181C  0003                              
mov bp,[0x261a]	; 0000181E  8B2E1A26                          
add [bp+di+0xe2e],cl	; 00001822  008B2E0E                          
push cs	; 00001826  0E                                
add [si],al	; 00001827  0004                              
add [bx+si],al	; 00001829  0000                              
add [bx+si],al	; 0000182B  0000                              
add [bx+si],al	; 0000182D  0000                              
add [bx+si],al	; 0000182F  0000                              
add [bx+si],al	; 00001831  0000                              
add [bx+si],al	; 00001833  0000                              
add [bx+si],al	; 00001835  0000                              
add [bx+si],al	; 00001837  0000                              
add [bx+si],al	; 00001839  0000                              
add [bx+si],al	; 0000183B  0000                              
add [bx+si],al	; 0000183D  0000                              
add [bx+si],al	; 0000183F  0000                              
add [bx+si],al	; 00001841  0000                              
add [bx+si],al	; 00001843  0000                              
add [bx+si],al	; 00001845  0000                              
add [bx+si],al	; 00001847  0000                              
add [bx+si],al	; 00001849  0000                              
add [bx+si],al	; 0000184B  0000                              
add [bx+si],al	; 0000184D  0000                              
add [bx+si],al	; 0000184F  0000                              
add [bx+si],al	; 00001851  0000                              
add [bx+si],al	; 00001853  0000                              
add [bx+si],al	; 00001855  0000                              
add [bx+si],al	; 00001857  0000                              
add [bx+si],al	; 00001859  0000                              
add [bx+si],al	; 0000185B  0000                              
add [bx+si],al	; 0000185D  0000                              
add [bx+si],al	; 0000185F  0000                              
add [bx+si],al	; 00001861  0000                              
add [bx+si],al	; 00001863  0000                              
add [bx+si],al	; 00001865  0000                              
add [bx+si],al	; 00001867  0000                              
add [bx+si],al	; 00001869  0000                              
add [bx+si],al	; 0000186B  0000                              
add [bx+si],al	; 0000186D  0000                              
add [bx+si],al	; 0000186F  0000                              
add [bx+si],al	; 00001871  0000                              
add [bx+si],al	; 00001873  0000                              
add [bx+si],al	; 00001875  0000                              
add [bx+si],al	; 00001877  0000                              
add [bx+si],al	; 00001879  0000                              
add [bx+si],al	; 0000187B  0000                              
add [bx+si],al	; 0000187D  0000                              
add [bx+si],al	; 0000187F  0000                              
add [bx+si],al	; 00001881  0000                              
add [bx+si],al	; 00001883  0000                              
add [bx+si],al	; 00001885  0000                              
add [bx+si],al	; 00001887  0000                              
add [bx+si],al	; 00001889  0000                              
add [bx+si],al	; 0000188B  0000                              
add [bx+si],al	; 0000188D  0000                              
add [bx+si],al	; 0000188F  0000                              
add [bx+si],al	; 00001891  0000                              
add [bx+si],al	; 00001893  0000                              
add [bx+si],al	; 00001895  0000                              
add [bx+si],al	; 00001897  0000                              
add [bp+si+0x192e],dl	; 00001899  00922E19                          
add [es:bp+si+0xe2e],dl	; 0000189D  2600922E0E                        
push cs	; 000018A2  0E                                
add [bx+si],al	; 000018A3  0000                              
add [bx+si],al	; 000018A5  0000                              
add [bx+si],al	; 000018A7  0000                              
add [bx+si],al	; 000018A9  0000                              
add [bx+si],al	; 000018AB  0000                              
add [bx+si],al	; 000018AD  0000                              
add [bx+si],al	; 000018AF  0000                              
add [bx+si],al	; 000018B1  0000                              
add [bx+si],al	; 000018B3  0000                              
add [bx+si],al	; 000018B5  0000                              
add [bx+si],al	; 000018B7  0000                              
add [bx+si],al	; 000018B9  0000                              
add [bx+si],al	; 000018BB  0000                              
add [bx+si],al	; 000018BD  0000                              
add [bx+si],al	; 000018BF  0000                              
add [bx+si],al	; 000018C1  0000                              
add [bx+si],al	; 000018C3  0000                              
add [bx+si],al	; 000018C5  0000                              
add [bx+si],al	; 000018C7  0000                              
add [bx+si],al	; 000018C9  0000                              
add [bx+si],al	; 000018CB  0000                              
add [bx+si],al	; 000018CD  0000                              
add [bx+si],al	; 000018CF  0000                              
add [bx+si],al	; 000018D1  0000                              
add [bx+si],al	; 000018D3  0000                              
add [bx+si],al	; 000018D5  0000                              
add [bx+si],al	; 000018D7  0000                              
add [bx+si],al	; 000018D9  0000                              
add [bx+si],al	; 000018DB  0000                              
add [bx+si],al	; 000018DD  0000                              
add [bx+si],al	; 000018DF  0000                              
add [bx+si],al	; 000018E1  0000                              
add [bx+si],al	; 000018E3  0000                              
add [bx+si],al	; 000018E5  0000                              
add [bx+si],al	; 000018E7  0000                              
add [bx+si],al	; 000018E9  0000                              
add [bx+si],al	; 000018EB  0000                              
add [bx+si],al	; 000018ED  0000                              
add [bx+si],al	; 000018EF  0000                              
add [bx+si],al	; 000018F1  0000                              
add [bx+si],al	; 000018F3  0000                              
add [bx+si],al	; 000018F5  0000                              
add [bx+si],al	; 000018F7  0000                              
add [bx+si],al	; 000018F9  0000                              
add [bx+si],al	; 000018FB  0000                              
add [bx+si],al	; 000018FD  0000                              
add [bx+si],al	; 000018FF  0000                              
add [bx+si],al	; 00001901  0000                              
add [bx+si],al	; 00001903  0000                              
add [bx+si],al	; 00001905  0000                              
add [bx+si],al	; 00001907  0000                              
add [bx+si],al	; 00001909  0000                              
add [bx+si],al	; 0000190B  0000                              
add [bx+si],al	; 0000190D  0000                              
add [bx+si],al	; 0000190F  0000                              
add [bx+si],al	; 00001911  0000                              
add [bx+si],al	; 00001913  0000                              
add ch,[di+0x1a2c]	; 00001915  02AD2C1A                          
add [es:di+0xe2c],ch	; 00001919  2600AD2C0E                        
push cs	; 0000191E  0E                                
add [si],al	; 0000191F  0004                              
add [bx+si],al	; 00001921  0000                              
add [bx+si],al	; 00001923  0000                              
add [bx+si],al	; 00001925  0000                              
add [bx+si],al	; 00001927  0000                              
add [bx+si],al	; 00001929  0000                              
add [bx+si],al	; 0000192B  0000                              
add [bx+si],al	; 0000192D  0000                              
add [bx+si],al	; 0000192F  0000                              
add [bx+si],al	; 00001931  0000                              
add [bx+si],al	; 00001933  0000                              
add [bx+si],al	; 00001935  0000                              
add [bx+si],al	; 00001937  0000                              
add [bx+si],al	; 00001939  0000                              
add [bx+si],al	; 0000193B  0000                              
add [bx+si],al	; 0000193D  0000                              
add [bx+si],al	; 0000193F  0000                              
add [bx+si],al	; 00001941  0000                              
add [bx+si],al	; 00001943  0000                              
add [bx+si],al	; 00001945  0000                              
add [bx+si],al	; 00001947  0000                              
add [bx+si],al	; 00001949  0000                              
add [bx+si],al	; 0000194B  0000                              
add [bx+si],al	; 0000194D  0000                              
add [bx+si],al	; 0000194F  0000                              
add [bx+si],al	; 00001951  0000                              
add [bx+si],al	; 00001953  0000                              
add [bx+si],al	; 00001955  0000                              
add [bx+si],al	; 00001957  0000                              
add [bx+si],al	; 00001959  0000                              
add [bx+si],al	; 0000195B  0000                              
add [bx+si],al	; 0000195D  0000                              
add [bx+si],al	; 0000195F  0000                              
add [bx+si],al	; 00001961  0000                              
add [bx+si],al	; 00001963  0000                              
add [bx+si],al	; 00001965  0000                              
add [bx+si],al	; 00001967  0000                              
add [bx+si],al	; 00001969  0000                              
add [bx+si],al	; 0000196B  0000                              
add [bx+si],al	; 0000196D  0000                              
add [bx+si],al	; 0000196F  0000                              
add [bx+si],al	; 00001971  0000                              
add [bx+si],al	; 00001973  0000                              
add [bx+si],al	; 00001975  0000                              
add [bx+si],al	; 00001977  0000                              
add [bx+si],al	; 00001979  0000                              
add [bx+si],al	; 0000197B  0000                              
add [bx+si],al	; 0000197D  0000                              
add [bx+si],al	; 0000197F  0000                              
add [bx+si],al	; 00001981  0000                              
add [bx+si],al	; 00001983  0000                              
add [bx+si],al	; 00001985  0000                              
add [bx+si],al	; 00001987  0000                              
add [bx+si],al	; 00001989  0000                              
add [bx+si],al	; 0000198B  0000                              
add [bx+si],al	; 0000198D  0000                              
add [bx+si],al	; 0000198F  0000                              
add [bx+si],al	; 00001991  0000                              
add [bx+si],al	; 00001993  0000                              
push bp	; 00001995  55                                
add [bx+si],al	; 00001996  0000                              
add [bx+si+0x40],al	; 00001998  004040                            
inc ax	; 0000199B  40                                
inc ax	; 0000199C  40                                
add [bx+di],ax	; 0000199D  0101                              
add [bx+di],ax	; 0000199F  0101                              
add [bx+si],al	; 000019A1  0000                              
add [di+0x5],dl	; 000019A3  005505                            
adc [bx+si+0x40],al	; 000019A6  104040                            
push ax	; 000019A9  50                                
add al,0x1	; 000019AA  0401                              
add [bx+si+0x40],ax	; 000019AC  014040                            
adc [di],al	; 000019AF  1005                              
add [bx+di],ax	; 000019B1  0101                              
add al,0x50	; 000019B3  0450                              
adc ax,0x0	; 000019B5  150000                            
add [bx+si+0x40],al	; 000019B8  004040                            
inc ax	; 000019BB  40                                
add [bx+si],al	; 000019BC  0000                              
add [bx+di],ax	; 000019BE  0101                              
add [bx+si],ax	; 000019C0  0100                              
add [bx+si],al	; 000019C2  0000                              
push sp	; 000019C4  54                                
push sp	; 000019C5  54                                
add [bx+si],al	; 000019C6  0000                              
add [bx+si],al	; 000019C8  0000                              
inc ax	; 000019CA  40                                
inc ax	; 000019CB  40                                
inc ax	; 000019CC  40                                
add [bx+di],ax	; 000019CD  0101                              
add [bx+si],ax	; 000019CF  0100                              
add [bx+si],al	; 000019D1  0000                              
add [di],dl	; 000019D3  0015                              
inc ax	; 000019D5  40                                
add [bx+si],al	; 000019D6  0000                              
add [bx+di],al	; 000019D8  0001                              
add [bx+si],al	; 000019DA  0000                              
add [bx+si],al	; 000019DC  0000                              
add [bx+si],al	; 000019DE  0000                              
inc ax	; 000019E0  40                                
add [bx+si],al	; 000019E1  0000                              
add [bx+di],al	; 000019E3  0001                              
adc ax,0x40	; 000019E5  154000                            
add [si+0x1],dl	; 000019E8  005401                            
add [bx+si],al	; 000019EB  0000                              
add [bx+si],al	; 000019ED  0000                              
inc ax	; 000019EF  40                                
adc ax,0x0	; 000019F0  150000                            
add [si+0x0],dx	; 000019F3  015400                            
add [bx+di],al	; 000019F6  0001                              
add [bx+si],ax	; 000019F8  0100                              
add [bx+si+0x40],al	; 000019FA  004040                            
add [bx+di],ax	; 000019FD  0101                              
add [bx+si],al	; 000019FF  0000                              
inc ax	; 00001A01  40                                
inc ax	; 00001A02  40                                
add [bx+si],al	; 00001A03  0000                              
add al,[bp+si]	; 00001A05  0202                              
add al,[bp+si]	; 00001A07  0202                              
sbb [di],dx	; 00001A09  1915                              
add [bx+di],ax	; 00001A0B  0101                              
add [bx+di],ax	; 00001A0D  0101                              
add [bx+di],ax	; 00001A0F  0101                              
add [bx+di],ax	; 00001A11  0101                              
push ss	; 00001A13  16                                
sbb bl,[bx+di]	; 00001A14  1A19                              
adc ax,0x101	; 00001A16  150101                            
add [bx+di],ax	; 00001A19  0101                              
add [bx+di],ax	; 00001A1B  0101                              
add [bx+di],ax	; 00001A1D  0101                              
push ss	; 00001A1F  16                                
sbb al,[bx+si]	; 00001A20  1A00                              
add [bx+si],al	; 00001A22  0000                              
add [bx+si],al	; 00001A24  0000                              
add [bp+di],al	; 00001A26  0003                              
add [bx+si],al	; 00001A28  0000                              
add [bx+si],al	; 00001A2A  0000                              
add al,[bx+si]	; 00001A2C  0200                              
add [bx+si],al	; 00001A2E  0000                              
add [bx+si],al	; 00001A30  0000                              
add [bx+di],bl	; 00001A32  0019                              
adc ax,0x101	; 00001A34  150101                            
add [bx+di],ax	; 00001A37  0101                              
add [bx+di],ax	; 00001A39  0101                              
add [bx+di],ax	; 00001A3B  0101                              
add [bx+di],ax	; 00001A3D  0101                              
add [bx+di],ax	; 00001A3F  0101                              
add [bx+di],ax	; 00001A41  0101                              
add [bx+di],ax	; 00001A43  0101                              
push ss	; 00001A45  16                                
sbb al,[bp+di]	; 00001A46  1A03                              
add [bx+si],al	; 00001A48  0000                              
add [bx+si],al	; 00001A4A  0000                              
add [bx+si],al	; 00001A4C  0000                              
add [bx+si],al	; 00001A4E  0000                              
add [bx+si],al	; 00001A50  0000                              
add al,[bp+di]	; 00001A52  0203                              
add [bx+si],al	; 00001A54  0000                              
add [bx+si],al	; 00001A56  0000                              
add [bx+si],al	; 00001A58  0000                              
add [bx+si],al	; 00001A5A  0000                              
add [bx+si],al	; 00001A5C  0000                              
add al,[bx+si]	; 00001A5E  0200                              
add [bx+si],al	; 00001A60  0000                              
add [bx+si],al	; 00001A62  0000                              
add [bp+di],al	; 00001A64  0003                              
add [bx+si],al	; 00001A66  0000                              
add [bx+si],al	; 00001A68  0000                              
add al,[bx+si]	; 00001A6A  0200                              
add [bx+si],al	; 00001A6C  0000                              
add [bx+si],al	; 00001A6E  0000                              
add [bp+di],al	; 00001A70  0003                              
add [bx+si],al	; 00001A72  0000                              
add [bx+si],al	; 00001A74  0000                              
add [bx+si],al	; 00001A76  0000                              
add [bx+si],al	; 00001A78  0000                              
add [bx+si],al	; 00001A7A  0000                              
add [bx+si],al	; 00001A7C  0000                              
add [bx+si],al	; 00001A7E  0000                              
add [bx+si],al	; 00001A80  0000                              
add [bx+si],al	; 00001A82  0000                              
add al,[bp+di]	; 00001A84  0203                              
add [bx+si],al	; 00001A86  0000                              
add [bx+si],al	; 00001A88  0000                              
add [bx+si],al	; 00001A8A  0000                              
add [bx+si],al	; 00001A8C  0000                              
add [bx+si],al	; 00001A8E  0000                              
add al,[bp+di]	; 00001A90  0203                              
add [bx+si],al	; 00001A92  0000                              
add [bx+si],al	; 00001A94  0000                              
add [bx+si],al	; 00001A96  0000                              
add [bx+si],al	; 00001A98  0000                              
add [bx+si],al	; 00001A9A  0000                              
add al,[bx+si]	; 00001A9C  0200                              
add [bx+si],al	; 00001A9E  0000                              
add [bx+si],al	; 00001AA0  0000                              
add [bp+di],al	; 00001AA2  0003                              
add [bx+si],al	; 00001AA4  0000                              
add [bx+si],al	; 00001AA6  0000                              
add al,[bx+si]	; 00001AA8  0200                              
add [bx+si],al	; 00001AAA  0000                              
add [bx+si],al	; 00001AAC  0000                              
add [bp+di],al	; 00001AAE  0003                              
add [bx+si],al	; 00001AB0  0000                              
add [bx+si],al	; 00001AB2  0000                              
add [bx+si],al	; 00001AB4  0000                              
add [bx+si],al	; 00001AB6  0000                              
add [bx+si],al	; 00001AB8  0000                              
add [bx+si],al	; 00001ABA  0000                              
add [bx+si],al	; 00001ABC  0000                              
add [bx+si],al	; 00001ABE  0000                              
add [bx+si],al	; 00001AC0  0000                              
add al,[bp+di]	; 00001AC2  0203                              
add [bx+si],al	; 00001AC4  0000                              
add [bx+si],al	; 00001AC6  0000                              
add [bx+si],al	; 00001AC8  0000                              
add [bx+si],al	; 00001ACA  0000                              
add [bx+si],al	; 00001ACC  0000                              
pop es	; 00001ACE  07                                
or [bx+si],al	; 00001ACF  0800                              
add [bx+si],al	; 00001AD1  0000                              
add [bx+si],al	; 00001AD3  0000                              
add [bx+si],al	; 00001AD5  0000                              
add [bx+si],al	; 00001AD7  0000                              
add [bp+si],al	; 00001AD9  0002                              
add [bx+si],al	; 00001ADB  0000                              
add [bx+si],al	; 00001ADD  0000                              
add [bx+si],al	; 00001ADF  0000                              
add ax,[bx+si]	; 00001AE1  0300                              
add [bx+si],al	; 00001AE3  0000                              
add [bp+si],al	; 00001AE5  0002                              
add [bx+si],al	; 00001AE7  0000                              
add [bx+si],al	; 00001AE9  0000                              
add [bx+si],al	; 00001AEB  0000                              
add ax,[bx+si]	; 00001AED  0300                              
add [bx+si],al	; 00001AEF  0000                              
add [bx+si],al	; 00001AF1  0000                              
add [bx+si],al	; 00001AF3  0000                              
add [bx+si],al	; 00001AF5  0000                              
add [bx+si],al	; 00001AF7  0000                              
add [bx+si],al	; 00001AF9  0000                              
add [bx+si],al	; 00001AFB  0000                              
add [bx+si],al	; 00001AFD  0000                              
add [bp+si],al	; 00001AFF  0002                              
add ax,[bx+si]	; 00001B01  0300                              
add [bx+si],al	; 00001B03  0000                              
add [di],al	; 00001B05  0005                              
push es	; 00001B07  06                                
add [bx+si],al	; 00001B08  0000                              
add [bx+si],al	; 00001B0A  0000                              
add [bx+si],al	; 00001B0C  0000                              
add [bx+si],al	; 00001B0E  0000                              
add [bx+si],al	; 00001B10  0000                              
add ax,0x6	; 00001B12  050600                            
add [bx+si],al	; 00001B15  0000                              
add [bp+si],al	; 00001B17  0002                              
add [bx+si],al	; 00001B19  0000                              
add [bx+si],al	; 00001B1B  0000                              
add [bx+si],al	; 00001B1D  0000                              
add ax,[bx+si]	; 00001B1F  0300                              
add [bx+si],al	; 00001B21  0000                              
add [bp+si],al	; 00001B23  0002                              
add [bx+si],al	; 00001B25  0000                              
add [bx+si],al	; 00001B27  0000                              
add [bx+si],al	; 00001B29  0000                              
add ax,[bx+si]	; 00001B2B  0300                              
add [bx+si],al	; 00001B2D  0000                              
add [di],al	; 00001B2F  0005                              
push es	; 00001B31  06                                
add [bx+si],al	; 00001B32  0000                              
add [bx+si],al	; 00001B34  0000                              
add ax,0x101	; 00001B36  050101                            
push es	; 00001B39  06                                
add [bx+si],al	; 00001B3A  0000                              
add [bx+si],al	; 00001B3C  0000                              
add al,[bp+di]	; 00001B3E  0203                              
add [bx+si],al	; 00001B40  0000                              
add [bx+si],al	; 00001B42  0000                              
add al,[bp+di]	; 00001B44  0203                              
add [bx+si],al	; 00001B46  0000                              
add [bx+si],al	; 00001B48  0000                              
add [bx+si],al	; 00001B4A  0000                              
add [bx+si],al	; 00001B4C  0000                              
add [bx+si],al	; 00001B4E  0000                              
add al,[bp+di]	; 00001B50  0203                              
add [bx+si],al	; 00001B52  0000                              
add [bx+si],al	; 00001B54  0000                              
add al,[bx+si]	; 00001B56  0200                              
add [bx+si],al	; 00001B58  0000                              
add [bx+si],al	; 00001B5A  0000                              
add [bp+di],al	; 00001B5C  0003                              
add [bx+si],al	; 00001B5E  0000                              
add [bx+si],al	; 00001B60  0000                              
add al,[bx+si]	; 00001B62  0200                              
add [bx+si],al	; 00001B64  0000                              
add [bx+si],al	; 00001B66  0000                              
add [bp+di],al	; 00001B68  0003                              
add [bx+si],al	; 00001B6A  0000                              
add [bx+si],al	; 00001B6C  0000                              
add al,[bp+di]	; 00001B6E  0203                              
add [bx+si],al	; 00001B70  0000                              
add [bx+si],al	; 00001B72  0000                              
add al,[bx+si]	; 00001B74  0200                              
add [bp+di],al	; 00001B76  0003                              
add [bx+si],al	; 00001B78  0000                              
add [bx+si],al	; 00001B7A  0000                              
add al,[bp+di]	; 00001B7C  0203                              
add [bx+si],al	; 00001B7E  0000                              
add [bx+si],al	; 00001B80  0000                              
add al,[bp+di]	; 00001B82  0203                              
add [bx+si],al	; 00001B84  0000                              
add [bx+si],al	; 00001B86  0000                              
add [bx+si],al	; 00001B88  0000                              
add [bx+si],al	; 00001B8A  0000                              
add [bx+si],al	; 00001B8C  0000                              
add al,[bp+di]	; 00001B8E  0203                              
add [bx+si],al	; 00001B90  0000                              
add [bx+si],al	; 00001B92  0000                              
add al,[bx+si]	; 00001B94  0200                              
add [bx+si],al	; 00001B96  0000                              
add [bx+si],al	; 00001B98  0000                              
add [bp+di],al	; 00001B9A  0003                              
add [bx+si],al	; 00001B9C  0000                              
add [bx+si],al	; 00001B9E  0000                              
add al,[bx+si]	; 00001BA0  0200                              
add [bx+si],al	; 00001BA2  0000                              
add [bx+si],al	; 00001BA4  0000                              
add [bp+di],al	; 00001BA6  0003                              
add [bx+si],al	; 00001BA8  0000                              
add [bx+si],al	; 00001BAA  0000                              
add al,[bp+di]	; 00001BAC  0203                              
add [bx+si],al	; 00001BAE  0000                              
add [bx+si],al	; 00001BB0  0000                              
add al,[bx+si]	; 00001BB2  0200                              
add [bp+di],al	; 00001BB4  0003                              
add [bx+si],al	; 00001BB6  0000                              
add [bx+si],al	; 00001BB8  0000                              
add al,[bp+di]	; 00001BBA  0203                              
add [bx+si],al	; 00001BBC  0000                              
add [bx+si],al	; 00001BBE  0000                              
add al,[bp+di]	; 00001BC0  0203                              
add [bx+si],al	; 00001BC2  0000                              
add [bx+si],al	; 00001BC4  0000                              
add [bx+si],al	; 00001BC6  0000                              
add [bx+si],al	; 00001BC8  0000                              
add [si],dl	; 00001BCA  0014                              
or al,[bp+di]	; 00001BCC  0A03                              
add [bx+si],al	; 00001BCE  0000                              
add [bx+si],al	; 00001BD0  0000                              
add al,[bx+si]	; 00001BD2  0200                              
add [bx+si],al	; 00001BD4  0000                              
add [bx+si],al	; 00001BD6  0000                              
add [bp+di],al	; 00001BD8  0003                              
add [bx+si],al	; 00001BDA  0000                              
add [bx+si],al	; 00001BDC  0000                              
add al,[bx+si]	; 00001BDE  0200                              
add [bx+si],al	; 00001BE0  0000                              
add [bx+si],al	; 00001BE2  0000                              
add [bp+di],al	; 00001BE4  0003                              
add [bx+si],al	; 00001BE6  0000                              
add [bx+si],al	; 00001BE8  0000                              
add al,[bp+di]	; 00001BEA  0203                              
add [bx+si],al	; 00001BEC  0000                              
add [bx+si],al	; 00001BEE  0000                              
add al,[bx+si]	; 00001BF0  0200                              
add [bp+di],al	; 00001BF2  0003                              
add [bx+si],al	; 00001BF4  0000                              
add [bx+si],al	; 00001BF6  0000                              
add al,[bp+di]	; 00001BF8  0203                              
add [bx+si],al	; 00001BFA  0000                              
add [bx+si],al	; 00001BFC  0000                              
add al,[bp+di]	; 00001BFE  0203                              
add [bx+si],al	; 00001C00  0000                              
add [bx+si],al	; 00001C02  0000                              
add ax,0x101	; 00001C04  050101                            
add [bx+di],ax	; 00001C07  0101                              
or ax,0x300	; 00001C09  0D0003                            
add [bx+si],al	; 00001C0C  0000                              
add [bx+si],al	; 00001C0E  0000                              
add al,[bx+si]	; 00001C10  0200                              
add [bx+si],al	; 00001C12  0000                              
add [bx+si],al	; 00001C14  0000                              
add [bp+di],al	; 00001C16  0003                              
add [bx+si],al	; 00001C18  0000                              
add [bx+si],al	; 00001C1A  0000                              
add al,[bx+si]	; 00001C1C  0200                              
add [bx+si],al	; 00001C1E  0000                              
add [bx+si],al	; 00001C20  0000                              
add [bp+di],al	; 00001C22  0003                              
add [bx+si],al	; 00001C24  0000                              
add [bx+si],al	; 00001C26  0000                              
add al,[bp+di]	; 00001C28  0203                              
add [bx+si],al	; 00001C2A  0000                              
add [bx+si],al	; 00001C2C  0000                              
add al,[bx+si]	; 00001C2E  0200                              
add [bp+di],al	; 00001C30  0003                              
add [bx+si],al	; 00001C32  0000                              
add [bx+si],al	; 00001C34  0000                              
add al,[bp+di]	; 00001C36  0203                              
add [bx+si],al	; 00001C38  0000                              
add [bx+si],al	; 00001C3A  0000                              
add al,[bp+di]	; 00001C3C  0203                              
add [bx+si],al	; 00001C3E  0000                              
add [bx+si],al	; 00001C40  0000                              
pop es	; 00001C42  07                                
add al,0x4	; 00001C43  0404                              
add al,0x4	; 00001C45  0404                              
add al,0x4	; 00001C47  0404                              
or [bx+si],al	; 00001C49  0800                              
add [bx+si],al	; 00001C4B  0000                              
add [bx],al	; 00001C4D  0007                              
add al,0x4	; 00001C4F  0404                              
add al,0x4	; 00001C51  0404                              
add al,0x4	; 00001C53  0404                              
or [bx+si],al	; 00001C55  0800                              
add [bx+si],al	; 00001C57  0000                              
add [bx],al	; 00001C59  0007                              
add al,0x4	; 00001C5B  0404                              
add al,0x4	; 00001C5D  0404                              
add al,0x4	; 00001C5F  0404                              
or [bx+si],al	; 00001C61  0800                              
add [bx+si],al	; 00001C63  0000                              
add [bx],al	; 00001C65  0007                              
or [bx+si],al	; 00001C67  0800                              
add [bx+si],al	; 00001C69  0000                              
add [bx],al	; 00001C6B  0007                              
add al,0x4	; 00001C6D  0404                              
or [bx+si],al	; 00001C6F  0800                              
add [bx+si],al	; 00001C71  0000                              
add [bp+si],al	; 00001C73  0002                              
add ax,[bx+si]	; 00001C75  0300                              
add [bx+si],al	; 00001C77  0000                              
add [bp+si],al	; 00001C79  0002                              
add ax,[bx+si]	; 00001C7B  0300                              
add [bx+si],al	; 00001C7D  0000                              
add [bx+si],al	; 00001C7F  0000                              
add [bx+si],al	; 00001C81  0000                              
add [bx+si],al	; 00001C83  0000                              
add [bx+si],al	; 00001C85  0000                              
add [bx+si],al	; 00001C87  0000                              
add [bx+si],al	; 00001C89  0000                              
add [bx+si],al	; 00001C8B  0000                              
add [bx+si],al	; 00001C8D  0000                              
add [bx+si],al	; 00001C8F  0000                              
add [bx+si],al	; 00001C91  0000                              
add [bx+si],al	; 00001C93  0000                              
add [bx+si],al	; 00001C95  0000                              
add [bx+si],al	; 00001C97  0000                              
add [bx+si],al	; 00001C99  0000                              
add [bx+si],al	; 00001C9B  0000                              
add [bx+si],al	; 00001C9D  0000                              
add [bx+si],al	; 00001C9F  0000                              
add [bx+si],al	; 00001CA1  0000                              
add [bx+si],al	; 00001CA3  0000                              
add [bx+si],al	; 00001CA5  0000                              
add [bx+si],al	; 00001CA7  0000                              
add [bx+si],al	; 00001CA9  0000                              
add [bx+si],al	; 00001CAB  0000                              
add [bx+si],al	; 00001CAD  0000                              
add [bx+si],al	; 00001CAF  0000                              
add [bp+si],al	; 00001CB1  0002                              
add ax,[bx+si]	; 00001CB3  0300                              
add [bx+si],al	; 00001CB5  0000                              
add [bp+si],al	; 00001CB7  0002                              
add ax,[bx+si]	; 00001CB9  0300                              
add [bx+si],al	; 00001CBB  0000                              
add [bx+si],al	; 00001CBD  0000                              
add [bx+si],al	; 00001CBF  0000                              
add [bx+si],al	; 00001CC1  0000                              
add [bx+si],al	; 00001CC3  0000                              
add [bx+si],al	; 00001CC5  0000                              
add [bx+si],al	; 00001CC7  0000                              
add [bx+si],al	; 00001CC9  0000                              
add [bx+si],al	; 00001CCB  0000                              
add [bx+si],al	; 00001CCD  0000                              
add [bx+si],al	; 00001CCF  0000                              
add [bx+si],al	; 00001CD1  0000                              
add [bx+si],al	; 00001CD3  0000                              
add [bx+si],al	; 00001CD5  0000                              
add [bx+si],al	; 00001CD7  0000                              
add [bx+si],al	; 00001CD9  0000                              
add [bx+si],al	; 00001CDB  0000                              
add [bx+si],al	; 00001CDD  0000                              
add [bx+si],al	; 00001CDF  0000                              
add [bx+si],al	; 00001CE1  0000                              
add [bx+si],al	; 00001CE3  0000                              
add [bx+si],al	; 00001CE5  0000                              
add [bx+si],al	; 00001CE7  0000                              
add [bx+si],al	; 00001CE9  0000                              
add [bx+si],al	; 00001CEB  0000                              
add [bx+si],al	; 00001CED  0000                              
add [bp+si],al	; 00001CEF  0002                              
add ax,[bx+si]	; 00001CF1  0300                              
add [bx+si],al	; 00001CF3  0000                              
add [bp+si],al	; 00001CF5  0002                              
add ax,[bx+si]	; 00001CF7  0300                              
add [bx+si],al	; 00001CF9  0000                              
add [bx+si],al	; 00001CFB  0000                              
add [bx+si],al	; 00001CFD  0000                              
add [bx+si],al	; 00001CFF  0000                              
add [bx+si],al	; 00001D01  0000                              
add [bx+si],al	; 00001D03  0000                              
add [bx+si],al	; 00001D05  0000                              
add [bx+si],al	; 00001D07  0000                              
add [bx+si],al	; 00001D09  0000                              
add [bx+si],al	; 00001D0B  0000                              
add [bx+si],al	; 00001D0D  0000                              
add [bx+si],al	; 00001D0F  0000                              
add [bx+si],al	; 00001D11  0000                              
add [bx+si],al	; 00001D13  0000                              
add [bx+si],al	; 00001D15  0000                              
add [bx+si],al	; 00001D17  0000                              
add [bx+si],al	; 00001D19  0000                              
add [bx+si],al	; 00001D1B  0000                              
add [bx+si],al	; 00001D1D  0000                              
add [bx+si],al	; 00001D1F  0000                              
add [bx+si],al	; 00001D21  0000                              
add [bx+si],al	; 00001D23  0000                              
add [bx+si],al	; 00001D25  0000                              
add [bx+si],al	; 00001D27  0000                              
add [bx+si],al	; 00001D29  0000                              
add [bx+si],al	; 00001D2B  0000                              
add [bp+si],al	; 00001D2D  0002                              
add ax,[bx+si]	; 00001D2F  0300                              
add [bx+si],al	; 00001D31  0000                              
add [bp+si],al	; 00001D33  0002                              
movlps qword [bx+si],xmm0	; 00001D35  0F1300                            
add [bx+si],al	; 00001D38  0000                              
add [bx+si],al	; 00001D3A  0000                              
add [bx+si],al	; 00001D3C  0000                              
add [bx+si],al	; 00001D3E  0000                              
add [bx+si],al	; 00001D40  0000                              
add [bx+si],al	; 00001D42  0000                              
add [bx+si],al	; 00001D44  0000                              
add [bx+si],al	; 00001D46  0000                              
add [bx+si],al	; 00001D48  0000                              
add [bx+si],al	; 00001D4A  0000                              
add [bx+si],al	; 00001D4C  0000                              
add [bx+si],al	; 00001D4E  0000                              
add [bx+si],al	; 00001D50  0000                              
add [bx+si],al	; 00001D52  0000                              
add [bx+si],al	; 00001D54  0000                              
add [bx+si],al	; 00001D56  0000                              
add [bx+si],al	; 00001D58  0000                              
add [bx+si],al	; 00001D5A  0000                              
add [bx+si],al	; 00001D5C  0000                              
add [bx+si],al	; 00001D5E  0000                              
add [bx+si],al	; 00001D60  0000                              
add [bx+si],al	; 00001D62  0000                              
add [bx+si],al	; 00001D64  0000                              
add [bx+si],al	; 00001D66  0000                              
add [bx+si],al	; 00001D68  0000                              
add [bx+si],al	; 00001D6A  0000                              
add al,[bp+di]	; 00001D6C  0203                              
add [bx+si],al	; 00001D6E  0000                              
add [bx+si],al	; 00001D70  0000                              
add al,[bx+si]	; 00001D72  0200                              
or [bx+di],ax	; 00001D74  0901                              
add [bx+di],ax	; 00001D76  0101                              
add [0x0],ax	; 00001D78  01060000                          
add [bx+si],al	; 00001D7C  0000                              
add ax,0x6	; 00001D7E  050600                            
add [bx+si],al	; 00001D81  0000                              
add [di],al	; 00001D83  0005                              
add [bx+di],ax	; 00001D85  0101                              
add [bx+di],ax	; 00001D87  0101                              
add [bx+di],ax	; 00001D89  0101                              
push es	; 00001D8B  06                                
add [bx+si],al	; 00001D8C  0000                              
add [bx+si],al	; 00001D8E  0000                              
add ax,0x101	; 00001D90  050101                            
add [bx+di],ax	; 00001D93  0101                              
add [bx+di],ax	; 00001D95  0101                              
add [bx+di],ax	; 00001D97  0101                              
add [bx+di],ax	; 00001D99  0101                              
add [bx+di],ax	; 00001D9B  0101                              
push es	; 00001D9D  06                                
add [bx+si],al	; 00001D9E  0000                              
add [bx+si],al	; 00001DA0  0000                              
add ax,0x101	; 00001DA2  050101                            
push es	; 00001DA5  06                                
add [bx+si],al	; 00001DA6  0000                              
add [bx+si],al	; 00001DA8  0000                              
add al,[bp+di]	; 00001DAA  0203                              
add [bx+si],al	; 00001DAC  0000                              
add [bx+si],al	; 00001DAE  0000                              
add al,[bx+si]	; 00001DB0  0200                              
adc [si],al	; 00001DB2  1004                              
add al,0x4	; 00001DB4  0404                              
add al,0x8	; 00001DB6  0408                              
add [bx+si],al	; 00001DB8  0000                              
add [bx+si],al	; 00001DBA  0000                              
add al,[bp+di]	; 00001DBC  0203                              
add [bx+si],al	; 00001DBE  0000                              
add [bx+si],al	; 00001DC0  0000                              
pop es	; 00001DC2  07                                
add al,0x4	; 00001DC3  0404                              
add al,0x4	; 00001DC5  0404                              
add al,0x4	; 00001DC7  0404                              
or [bx+si],al	; 00001DC9  0800                              
add [bx+si],al	; 00001DCB  0000                              
add [bx],al	; 00001DCD  0007                              
add al,0x4	; 00001DCF  0404                              
add al,0x4	; 00001DD1  0404                              
or al,0x0	; 00001DD3  0C00                              
add [bx+si],dl	; 00001DD5  0010                              
add al,0x4	; 00001DD7  0404                              
add al,0x4	; 00001DD9  0404                              
or [bx+si],al	; 00001DDB  0800                              
add [bx+si],al	; 00001DDD  0000                              
add [bp+si],al	; 00001DDF  0002                              
add [bx+si],al	; 00001DE1  0000                              
add ax,[bx+si]	; 00001DE3  0300                              
add [bx+si],al	; 00001DE5  0000                              
add [bp+si],al	; 00001DE7  0002                              
add ax,[bx+si]	; 00001DE9  0300                              
add [bx+si],al	; 00001DEB  0000                              
add [bp+si],al	; 00001DED  0002                              
or dx,[bx+di]	; 00001DEF  0B11                              
add [bx+si],al	; 00001DF1  0000                              
add [bx+si],al	; 00001DF3  0000                              
add [bx+si],al	; 00001DF5  0000                              
add [bx+si],al	; 00001DF7  0000                              
add [bp+si],al	; 00001DF9  0002                              
add ax,[bx+si]	; 00001DFB  0300                              
add [bx+si],al	; 00001DFD  0000                              
add [bx+si],al	; 00001DFF  0000                              
add [bx+si],al	; 00001E01  0000                              
add [bx+si],al	; 00001E03  0000                              
add [bx+si],al	; 00001E05  0000                              
add [bx+si],al	; 00001E07  0000                              
add [bx+si],al	; 00001E09  0000                              
add [bx+si],al	; 00001E0B  0000                              
add [bx+si],al	; 00001E0D  0000                              
add [bx+si],al	; 00001E0F  0000                              
adc cl,[0x110b]	; 00001E11  120E0B11                          
add [bx+si],al	; 00001E15  0000                              
add [bx+si],al	; 00001E17  0000                              
add [bx+si],al	; 00001E19  0000                              
add [bx+si],al	; 00001E1B  0000                              
add [bp+si],al	; 00001E1D  0002                              
add [bx+si],al	; 00001E1F  0000                              
add ax,[bx+si]	; 00001E21  0300                              
add [bx+si],al	; 00001E23  0000                              
add [bp+si],al	; 00001E25  0002                              
add ax,[bx+si]	; 00001E27  0300                              
add [bx+si],al	; 00001E29  0000                              
add [bp+si],al	; 00001E2B  0002                              
add ax,[bx+si]	; 00001E2D  0300                              
add [bx+si],al	; 00001E2F  0000                              
add [bx+si],al	; 00001E31  0000                              
add [bx+si],al	; 00001E33  0000                              
add [bx+si],al	; 00001E35  0000                              
add [bp+si],al	; 00001E37  0002                              
add ax,[bx+si]	; 00001E39  0300                              
add [bx+si],al	; 00001E3B  0000                              
add [bx+si],al	; 00001E3D  0000                              
add [bx+si],al	; 00001E3F  0000                              
add [bx+si],al	; 00001E41  0000                              
add [bx+si],al	; 00001E43  0000                              
add [bx+si],al	; 00001E45  0000                              
add [bx+si],al	; 00001E47  0000                              
add [bx+si],al	; 00001E49  0000                              
add [bx+si],al	; 00001E4B  0000                              
add [bx+si],al	; 00001E4D  0000                              
add [bp+si],al	; 00001E4F  0002                              
add ax,[bx+si]	; 00001E51  0300                              
add [bx+si],al	; 00001E53  0000                              
add [bx+si],al	; 00001E55  0000                              
add [bx+si],al	; 00001E57  0000                              
add [bx+si],al	; 00001E59  0000                              
add [bp+si],al	; 00001E5B  0002                              
add [bx+si],al	; 00001E5D  0000                              
add ax,[bx+si]	; 00001E5F  0300                              
add [bx+si],al	; 00001E61  0000                              
add [bp+si],al	; 00001E63  0002                              
add ax,[bx+si]	; 00001E65  0300                              
add [bx+si],al	; 00001E67  0000                              
add [bp+si],al	; 00001E69  0002                              
add ax,[bx+si]	; 00001E6B  0300                              
add [bx+si],al	; 00001E6D  0000                              
add [bx+si],al	; 00001E6F  0000                              
add [bx+si],al	; 00001E71  0000                              
add [bx+si],al	; 00001E73  0000                              
add [bp+si],al	; 00001E75  0002                              
add ax,[bx+si]	; 00001E77  0300                              
add [bx+si],al	; 00001E79  0000                              
add [bx+si],al	; 00001E7B  0000                              
add [bx+si],al	; 00001E7D  0000                              
add [bx+si],al	; 00001E7F  0000                              
add [bx+si],al	; 00001E81  0000                              
add [bx+si],al	; 00001E83  0000                              
add [bx+si],al	; 00001E85  0000                              
add [bx+si],al	; 00001E87  0000                              
add [bx+si],al	; 00001E89  0000                              
add [bx+si],al	; 00001E8B  0000                              
add [bp+si],al	; 00001E8D  0002                              
add ax,[bx+si]	; 00001E8F  0300                              
add [bx+si],al	; 00001E91  0000                              
add [bx+si],al	; 00001E93  0000                              
add [bx+si],al	; 00001E95  0000                              
add [bx+si],al	; 00001E97  0000                              
add [bp+si],al	; 00001E99  0002                              
add [bx+si],al	; 00001E9B  0000                              
add ax,[bx+si]	; 00001E9D  0300                              
add [bx+si],al	; 00001E9F  0000                              
add [bp+si],al	; 00001EA1  0002                              
add ax,[bx+si]	; 00001EA3  0300                              
add [bx+si],al	; 00001EA5  0000                              
add [bx],al	; 00001EA7  0007                              
or [bx+si],al	; 00001EA9  0800                              
add [bx+si],al	; 00001EAB  0000                              
add [bx+si],al	; 00001EAD  0000                              
add [bx+si],al	; 00001EAF  0000                              
add [bx+si],al	; 00001EB1  0000                              
add [bx],al	; 00001EB3  0007                              
or [bx+si],al	; 00001EB5  0800                              
add [bx+si],al	; 00001EB7  0000                              
add [bx+si],al	; 00001EB9  0000                              
add [bx+si],al	; 00001EBB  0000                              
add [bx+si],al	; 00001EBD  0000                              
add [bx+si],al	; 00001EBF  0000                              
add [bx+si],al	; 00001EC1  0000                              
add [bx+si],al	; 00001EC3  0000                              
add [bx+si],al	; 00001EC5  0000                              
add [bx+si],al	; 00001EC7  0000                              
add [bx+si],al	; 00001EC9  0000                              
add [bx],al	; 00001ECB  0007                              
or [bx+si],al	; 00001ECD  0800                              
add [bx+si],al	; 00001ECF  0000                              
add [bx+si],al	; 00001ED1  0000                              
add [bx+si],al	; 00001ED3  0000                              
add [bx+si],al	; 00001ED5  0000                              
add [bx],al	; 00001ED7  0007                              
add al,0x4	; 00001ED9  0404                              
or [bx+si],al	; 00001EDB  0800                              
add [bx+si],al	; 00001EDD  0000                              
add [bp+si],al	; 00001EDF  0002                              
add ax,[bx+si]	; 00001EE1  0300                              
add [bx+si],al	; 00001EE3  0000                              
add [bx+si],al	; 00001EE5  0000                              
add [bx+si],al	; 00001EE7  0000                              
add [bx+si],al	; 00001EE9  0000                              
add [di],al	; 00001EEB  0005                              
push es	; 00001EED  06                                
add [bx+si],al	; 00001EEE  0000                              
add [bx+si],al	; 00001EF0  0000                              
add [bx+si],al	; 00001EF2  0000                              
add [bx+si],al	; 00001EF4  0000                              
add [bx+si],al	; 00001EF6  0000                              
add ax,0x6	; 00001EF8  050600                            
add [bx+si],al	; 00001EFB  0000                              
add [di],al	; 00001EFD  0005                              
add [bx+di],ax	; 00001EFF  0101                              
add [bx+di],ax	; 00001F01  0101                              
add [bx+di],ax	; 00001F03  0101                              
push es	; 00001F05  06                                
add [bx+si],al	; 00001F06  0000                              
add [bx+si],al	; 00001F08  0000                              
add [bx+si],al	; 00001F0A  0000                              
add [bx+si],al	; 00001F0C  0000                              
add [bx+si],al	; 00001F0E  0000                              
add ax,0x6	; 00001F10  050600                            
add [bx+si],al	; 00001F13  0000                              
add [bx+si],al	; 00001F15  0000                              
add [bx+si],al	; 00001F17  0000                              
add [bx+si],al	; 00001F19  0000                              
add [bx+si],al	; 00001F1B  0000                              
add [bp+si],al	; 00001F1D  0002                              
add ax,[bx+si]	; 00001F1F  0300                              
add [bx+si],al	; 00001F21  0000                              
add [bx+si],al	; 00001F23  0000                              
add [bx+si],al	; 00001F25  0000                              
add [bx+si],al	; 00001F27  0000                              
add [bp+si],al	; 00001F29  0002                              
add ax,[bx+si]	; 00001F2B  0300                              
add [bx+si],al	; 00001F2D  0000                              
add [bx+si],al	; 00001F2F  0000                              
add [bx+si],al	; 00001F31  0000                              
add [bx+si],al	; 00001F33  0000                              
add [bp+si],al	; 00001F35  0002                              
add ax,[bx+si]	; 00001F37  0300                              
add [bx+si],al	; 00001F39  0000                              
add [bp+si],al	; 00001F3B  0002                              
add [bx+si],al	; 00001F3D  0000                              
add [bx+si],al	; 00001F3F  0000                              
add [bx+si],al	; 00001F41  0000                              
add ax,[bx+si]	; 00001F43  0300                              
add [bx+si],al	; 00001F45  0000                              
add [bx+si],al	; 00001F47  0000                              
add [bx+si],al	; 00001F49  0000                              
add [bx+si],al	; 00001F4B  0000                              
add [bp+si],al	; 00001F4D  0002                              
add ax,[bx+si]	; 00001F4F  0300                              
add [bx+si],al	; 00001F51  0000                              
add [bx+si],al	; 00001F53  0000                              
add [bx+si],al	; 00001F55  0000                              
add [bx+si],al	; 00001F57  0000                              
add [bx+si],al	; 00001F59  0000                              
add [bp+si],al	; 00001F5B  0002                              
add ax,[bx+si]	; 00001F5D  0300                              
add [bx+si],al	; 00001F5F  0000                              
add [bx+si],al	; 00001F61  0000                              
add [bx+si],al	; 00001F63  0000                              
add [bx+si],al	; 00001F65  0000                              
add [bp+si],al	; 00001F67  0002                              
add ax,[bx+si]	; 00001F69  0300                              
add [bx+si],al	; 00001F6B  0000                              
add [bx+si],al	; 00001F6D  0000                              
add [bx+si],al	; 00001F6F  0000                              
add [bx+si],al	; 00001F71  0000                              
add [bp+si],al	; 00001F73  0002                              
add ax,[bx+si]	; 00001F75  0300                              
add [bx+si],al	; 00001F77  0000                              
add [bp+si],al	; 00001F79  0002                              
add [bx+si],al	; 00001F7B  0000                              
add [bx+si],al	; 00001F7D  0000                              
add [bx+si],al	; 00001F7F  0000                              
add ax,[bx+si]	; 00001F81  0300                              
add [bx+si],al	; 00001F83  0000                              
add [bx+si],al	; 00001F85  0000                              
add [bx+si],al	; 00001F87  0000                              
add [bx+si],al	; 00001F89  0000                              
add [bp+si],al	; 00001F8B  0002                              
add ax,[bx+si]	; 00001F8D  0300                              
add [bx+si],al	; 00001F8F  0000                              
add [bx+si],al	; 00001F91  0000                              
add [bx+si],al	; 00001F93  0000                              
add [bx+si],al	; 00001F95  0000                              
add [bx+si],al	; 00001F97  0000                              
add [bp+si],al	; 00001F99  0002                              
add ax,[bx+si]	; 00001F9B  0300                              
add [bx+si],al	; 00001F9D  0000                              
add [bx+si],al	; 00001F9F  0000                              
add [bx+si],al	; 00001FA1  0000                              
add [bx+si],al	; 00001FA3  0000                              
adc al,0xa	; 00001FA5  140A                              
add ax,[bx+si]	; 00001FA7  0300                              
add [bx+si],al	; 00001FA9  0000                              
add [bx+si],al	; 00001FAB  0000                              
add [bx+si],al	; 00001FAD  0000                              
add [bx+si],al	; 00001FAF  0000                              
adc al,0xa	; 00001FB1  140A                              
add ax,[bx+si]	; 00001FB3  0300                              
add [bx+si],al	; 00001FB5  0000                              
add [bp+si],al	; 00001FB7  0002                              
add [bx+si],al	; 00001FB9  0000                              
add [bx+si],al	; 00001FBB  0000                              
add [bx+si],al	; 00001FBD  0000                              
sbb ax,0x0	; 00001FBF  1D0000                            
add [bx+si],al	; 00001FC2  0000                              
add [bx+si],al	; 00001FC4  0000                              
add [bx+si],al	; 00001FC6  0000                              
add [si],dl	; 00001FC8  0014                              
or al,[bp+di]	; 00001FCA  0A03                              
add [bx+si],al	; 00001FCC  0000                              
add [bx+si],al	; 00001FCE  0000                              
add [bx+si],al	; 00001FD0  0000                              
add [bx+si],al	; 00001FD2  0000                              
add [bx+si],al	; 00001FD4  0000                              
add [si],dl	; 00001FD6  0014                              
or al,[bp+di]	; 00001FD8  0A03                              
add [bx+si],al	; 00001FDA  0000                              
add [bx+si],al	; 00001FDC  0000                              
add ax,0x101	; 00001FDE  050101                            
add [bx+di],ax	; 00001FE1  0101                              
or ax,0x300	; 00001FE3  0D0003                            
add [bx+si],al	; 00001FE6  0000                              
add [bx+si],al	; 00001FE8  0000                              
add ax,0x101	; 00001FEA  050101                            
add [bx+di],ax	; 00001FED  0101                              
or ax,0x300	; 00001FEF  0D0003                            
add [bx+si],al	; 00001FF2  0000                              
add [bx+si],al	; 00001FF4  0000                              
add al,[bx+si]	; 00001FF6  0200                              
add [bx+si],al	; 00001FF8  0000                              
add [bx+si],al	; 00001FFA  0000                              
add [di],bl	; 00001FFC  001D                              
add [bx+si],al	; 00001FFE  0000                              
add [bx+si],al	; 00002000  0000                              
add ax,0x101	; 00002002  050101                            
add [bx+di],ax	; 00002005  0101                              
or ax,0x300	; 00002007  0D0003                            
add [bx+si],al	; 0000200A  0000                              
add [bx+si],al	; 0000200C  0000                              
add ax,0x101	; 0000200E  050101                            
add [bx+di],ax	; 00002011  0101                              
add [bx+di],ax	; 00002013  0101                              
or ax,0x300	; 00002015  0D0003                            
add [bx+si],al	; 00002018  0000                              
add [bx+si],al	; 0000201A  0000                              
pop es	; 0000201C  07                                
add al,0x4	; 0000201D  0404                              
add al,0x4	; 0000201F  0404                              
or al,0x0	; 00002021  0C00                              
add ax,[bx+si]	; 00002023  0300                              
add [bx+si],al	; 00002025  0000                              
add [bx],al	; 00002027  0007                              
add al,0x4	; 00002029  0404                              
add al,0x4	; 0000202B  0404                              
or al,0x0	; 0000202D  0C00                              
add ax,[bx+si]	; 0000202F  0300                              
add [bx+si],al	; 00002031  0000                              
add [bp+si],al	; 00002033  0002                              
add [bx+si],al	; 00002035  0000                              
add [bx+si],al	; 00002037  0000                              
add [bx+si],al	; 00002039  0000                              
sbb ax,0x0	; 0000203B  1D0000                            
add [bx+si],al	; 0000203E  0000                              
pop es	; 00002040  07                                
add al,0x4	; 00002041  0404                              
add al,0x4	; 00002043  0404                              
or al,0x0	; 00002045  0C00                              
add ax,[bx+si]	; 00002047  0300                              
add [bx+si],al	; 00002049  0000                              
add [bx],al	; 0000204B  0007                              
add al,0x4	; 0000204D  0404                              
add al,0x4	; 0000204F  0404                              
add al,0x4	; 00002051  0404                              
or al,0x0	; 00002053  0C00                              
add ax,[bx+si]	; 00002055  0300                              
add [bx+si],al	; 00002057  0000                              
add [bx+si],al	; 00002059  0000                              
add [bx+si],al	; 0000205B  0000                              
add [bx+si],al	; 0000205D  0000                              
adc cl,[0x3]	; 0000205F  120E0300                          
add [bx+si],al	; 00002063  0000                              
add [bx+si],al	; 00002065  0000                              
add [bx+si],al	; 00002067  0000                              
add [bx+si],al	; 00002069  0000                              
adc cl,[0x3]	; 0000206B  120E0300                          
add [bx+si],al	; 0000206F  0000                              
add [bp+si],al	; 00002071  0002                              
add [bx+si],al	; 00002073  0000                              
add [bx+si],al	; 00002075  0000                              
add [bx+si],al	; 00002077  0000                              
sbb ax,0x0	; 00002079  1D0000                            
add [bx+si],al	; 0000207C  0000                              
add [bx+si],al	; 0000207E  0000                              
add [bx+si],al	; 00002080  0000                              
add [bp+si],dl	; 00002082  0012                              
push cs	; 00002084  0E                                
add ax,[bx+si]	; 00002085  0300                              
add [bx+si],al	; 00002087  0000                              
add [bx+si],al	; 00002089  0000                              
add [bx+si],al	; 0000208B  0000                              
add [bx+si],al	; 0000208D  0000                              
add [bx+si],al	; 0000208F  0000                              
adc cl,[0x3]	; 00002091  120E0300                          
add [bx+si],al	; 00002095  0000                              
add [bx+si],al	; 00002097  0000                              
add [bx+si],al	; 00002099  0000                              
add [bx+si],al	; 0000209B  0000                              
add [bp+si],al	; 0000209D  0002                              
add ax,[bx+si]	; 0000209F  0300                              
add [bx+si],al	; 000020A1  0000                              
add [bx+si],al	; 000020A3  0000                              
add [bx+si],al	; 000020A5  0000                              
add [bx+si],al	; 000020A7  0000                              
add [bp+si],al	; 000020A9  0002                              
add ax,[bx+si]	; 000020AB  0300                              
add [bx+si],al	; 000020AD  0000                              
add [bp+si],al	; 000020AF  0002                              
add [bx+si],al	; 000020B1  0000                              
add [bx+si],al	; 000020B3  0000                              
add [bx+si],al	; 000020B5  0000                              
add ax,[bx+si]	; 000020B7  0300                              
add [bx+si],al	; 000020B9  0000                              
add [bx+si],al	; 000020BB  0000                              
add [bx+si],al	; 000020BD  0000                              
add [bx+si],al	; 000020BF  0000                              
add [bp+si],al	; 000020C1  0002                              
add ax,[bx+si]	; 000020C3  0300                              
add [bx+si],al	; 000020C5  0000                              
add [bx+si],al	; 000020C7  0000                              
add [bx+si],al	; 000020C9  0000                              
add [bx+si],al	; 000020CB  0000                              
add [bx+si],al	; 000020CD  0000                              
add [bp+si],al	; 000020CF  0002                              
add ax,[bx+si]	; 000020D1  0300                              
add [bx+si],al	; 000020D3  0000                              
add [bx+si],al	; 000020D5  0000                              
add [bx+si],al	; 000020D7  0000                              
add [bx+si],al	; 000020D9  0000                              
add [bp+si],al	; 000020DB  0002                              
add ax,[bx+si]	; 000020DD  0300                              
add [bx+si],al	; 000020DF  0000                              
add [bx+si],al	; 000020E1  0000                              
add [bx+si],al	; 000020E3  0000                              
add [bx+si],al	; 000020E5  0000                              
add [bp+si],al	; 000020E7  0002                              
add ax,[bx+si]	; 000020E9  0300                              
add [bx+si],al	; 000020EB  0000                              
add [bp+si],al	; 000020ED  0002                              
add [bx+si],al	; 000020EF  0000                              
add [bx+si],al	; 000020F1  0000                              
add [bx+si],al	; 000020F3  0000                              
add ax,[bx+si]	; 000020F5  0300                              
add [bx+si],al	; 000020F7  0000                              
add [bx+si],al	; 000020F9  0000                              
add [bx+si],al	; 000020FB  0000                              
add [bx+si],al	; 000020FD  0000                              
add [bp+si],al	; 000020FF  0002                              
add ax,[bx+si]	; 00002101  0300                              
add [bx+si],al	; 00002103  0000                              
add [bx+si],al	; 00002105  0000                              
add [bx+si],al	; 00002107  0000                              
add [bx+si],al	; 00002109  0000                              
add [bx+si],al	; 0000210B  0000                              
add [bp+si],al	; 0000210D  0002                              
add ax,[bx+si]	; 0000210F  0300                              
add [bx+si],al	; 00002111  0000                              
add [bx+si],al	; 00002113  0000                              
add [bx+si],al	; 00002115  0000                              
add [bx+si],al	; 00002117  0000                              
add [bx],al	; 00002119  0007                              
or [bx+si],al	; 0000211B  0800                              
add [bx+si],al	; 0000211D  0000                              
add [bx+si],al	; 0000211F  0000                              
add [bx+si],al	; 00002121  0000                              
add [bx+si],al	; 00002123  0000                              
add [bx],al	; 00002125  0007                              
or [bx+si],al	; 00002127  0800                              
add [bx+si],al	; 00002129  0000                              
add [bx],al	; 0000212B  0007                              
add al,0x4	; 0000212D  0404                              
add al,0x4	; 0000212F  0404                              
add al,0x4	; 00002131  0404                              
or [bx+si],al	; 00002133  0800                              
add [bx+si],al	; 00002135  0000                              
add [bx+si],al	; 00002137  0000                              
add [bx+si],al	; 00002139  0000                              
add [bx+si],al	; 0000213B  0000                              
add [bx],al	; 0000213D  0007                              
or [bx+si],al	; 0000213F  0800                              
add [bx+si],al	; 00002141  0000                              
add [bx+si],al	; 00002143  0000                              
add [bx+si],al	; 00002145  0000                              
add [bx+si],al	; 00002147  0000                              
add [bx+si],al	; 00002149  0000                              
add [bp+si],al	; 0000214B  0002                              
add ax,[bx+si]	; 0000214D  0300                              
add [bx+si],al	; 0000214F  0000                              
add [di],al	; 00002151  0005                              
push es	; 00002153  06                                
add [bx+si],al	; 00002154  0000                              
add [bx+si],al	; 00002156  0000                              
add [bx+si],al	; 00002158  0000                              
add [bx+si],al	; 0000215A  0000                              
add [bx+si],al	; 0000215C  0000                              
add ax,0x6	; 0000215E  050600                            
add [bx+si],al	; 00002161  0000                              
add [bx+si],al	; 00002163  0000                              
add [bx+si],al	; 00002165  0000                              
add [bx+si],al	; 00002167  0000                              
add [bx+si],al	; 00002169  0000                              
add [bx+si],al	; 0000216B  0000                              
add [bx+si],al	; 0000216D  0000                              
add [bx+si],al	; 0000216F  0000                              
add [bx+si],al	; 00002171  0000                              
add [bx+si],al	; 00002173  0000                              
add [di],al	; 00002175  0005                              
push es	; 00002177  06                                
add [bx+si],al	; 00002178  0000                              
add [bx+si],al	; 0000217A  0000                              
add [bx+si],al	; 0000217C  0000                              
add [bx+si],al	; 0000217E  0000                              
add [bx+si],al	; 00002180  0000                              
add ax,0x101	; 00002182  050101                            
push es	; 00002185  06                                
add [bx+si],al	; 00002186  0000                              
add [bx+si],al	; 00002188  0000                              
add al,[bp+di]	; 0000218A  0203                              
add [bx+si],al	; 0000218C  0000                              
add [bx+si],al	; 0000218E  0000                              
add al,[bp+di]	; 00002190  0203                              
add [bx+si],al	; 00002192  0000                              
add [bx+si],al	; 00002194  0000                              
add [bx+si],al	; 00002196  0000                              
add [bx+si],al	; 00002198  0000                              
add [bx+si],al	; 0000219A  0000                              
add al,[bp+di]	; 0000219C  0203                              
add [bx+si],al	; 0000219E  0000                              
add [bx+si],al	; 000021A0  0000                              
add [bx+si],al	; 000021A2  0000                              
add [bx+si],al	; 000021A4  0000                              
add [bx+si],al	; 000021A6  0000                              
add [bx+si],al	; 000021A8  0000                              
add [bx+si],al	; 000021AA  0000                              
add [bx+si],al	; 000021AC  0000                              
add [bx+si],al	; 000021AE  0000                              
add [bx+si],al	; 000021B0  0000                              
add [bx+si],al	; 000021B2  0000                              
add al,[bp+di]	; 000021B4  0203                              
add [bx+si],al	; 000021B6  0000                              
add [bx+si],al	; 000021B8  0000                              
add [bx+si],al	; 000021BA  0000                              
add [bx+si],al	; 000021BC  0000                              
add [bx+si],al	; 000021BE  0000                              
add al,[bx+si]	; 000021C0  0200                              
add [bp+di],al	; 000021C2  0003                              
add [bx+si],al	; 000021C4  0000                              
add [bx+si],al	; 000021C6  0000                              
add al,[bp+di]	; 000021C8  0203                              
add [bx+si],al	; 000021CA  0000                              
add [bx+si],al	; 000021CC  0000                              
add al,[bp+di]	; 000021CE  0203                              
add [bx+si],al	; 000021D0  0000                              
add [bx+si],al	; 000021D2  0000                              
add [bx+si],al	; 000021D4  0000                              
add [bx+si],al	; 000021D6  0000                              
add [bx+si],al	; 000021D8  0000                              
add al,[bp+di]	; 000021DA  0203                              
add [bx+si],al	; 000021DC  0000                              
add [bx+si],al	; 000021DE  0000                              
add [bx+si],al	; 000021E0  0000                              
add [bx+si],al	; 000021E2  0000                              
add [bx+si],al	; 000021E4  0000                              
add [bx+si],al	; 000021E6  0000                              
add [bx+si],al	; 000021E8  0000                              
add [bx+si],al	; 000021EA  0000                              
add [bx+si],al	; 000021EC  0000                              
add [bx+si],al	; 000021EE  0000                              
add [bx+si],al	; 000021F0  0000                              
add al,[bp+di]	; 000021F2  0203                              
add [bx+si],al	; 000021F4  0000                              
add [bx+si],al	; 000021F6  0000                              
add [bx+si],al	; 000021F8  0000                              
add [bx+si],al	; 000021FA  0000                              
add [bx+si],al	; 000021FC  0000                              
add al,[bx+si]	; 000021FE  0200                              
add [bp+di],al	; 00002200  0003                              
add [bx+si],al	; 00002202  0000                              
add [bx+si],al	; 00002204  0000                              
add al,[bp+di]	; 00002206  0203                              
add [bx+si],al	; 00002208  0000                              
add [bx+si],al	; 0000220A  0000                              
add cl,[bx]	; 0000220C  020F                              
adc ax,[bx+si]	; 0000220E  1300                              
add [bx+si],al	; 00002210  0000                              
add [bx+si],al	; 00002212  0000                              
add [bx+si],al	; 00002214  0000                              
add [bx+si],al	; 00002216  0000                              
add al,[bp+di]	; 00002218  0203                              
add [bx+si],al	; 0000221A  0000                              
add [bx+si],al	; 0000221C  0000                              
add [bx+si],al	; 0000221E  0000                              
add [bx+si],al	; 00002220  0000                              
add [bx+si],al	; 00002222  0000                              
add [bx+si],al	; 00002224  0000                              
add [bx+si],al	; 00002226  0000                              
add [bx+si],al	; 00002228  0000                              
add [bx+si],al	; 0000222A  0000                              
add [bx+si],al	; 0000222C  0000                              
add [si],dl	; 0000222E  0014                              
or cl,[bx]	; 00002230  0A0F                              
adc ax,[bx+si]	; 00002232  1300                              
add [bx+si],al	; 00002234  0000                              
add [bx+si],al	; 00002236  0000                              
add [bx+si],al	; 00002238  0000                              
add [bx+si],al	; 0000223A  0000                              
add al,[bx+si]	; 0000223C  0200                              
add [bp+di],al	; 0000223E  0003                              
add [bx+si],al	; 00002240  0000                              
add [bx+si],al	; 00002242  0000                              
add al,[bp+di]	; 00002244  0203                              
add [bx+si],al	; 00002246  0000                              
add [bx+si],al	; 00002248  0000                              
add al,[bx+si]	; 0000224A  0200                              
or [bx+di],ax	; 0000224C  0901                              
add [bx+di],ax	; 0000224E  0101                              
add [0x0],ax	; 00002250  01060000                          
add [bx+si],al	; 00002254  0000                              
add al,[bp+di]	; 00002256  0203                              
add [bx+si],al	; 00002258  0000                              
add [bx+si],al	; 0000225A  0000                              
add ax,0x101	; 0000225C  050101                            
add [bx+di],ax	; 0000225F  0101                              
add [bx+di],ax	; 00002261  0101                              
push es	; 00002263  06                                
add [bx+si],al	; 00002264  0000                              
add [bx+si],al	; 00002266  0000                              
add ax,0x101	; 00002268  050101                            
add [bx+di],ax	; 0000226B  0101                              
or ax,0x0	; 0000226D  0D0000                            
or [bx+di],ax	; 00002270  0901                              
add [bx+di],ax	; 00002272  0101                              
add [0x0],ax	; 00002274  01060000                          
add [bx+si],al	; 00002278  0000                              
add al,[bx+si]	; 0000227A  0200                              
add [bp+di],al	; 0000227C  0003                              
add [bx+si],al	; 0000227E  0000                              
add [bx+si],al	; 00002280  0000                              
add al,[bp+di]	; 00002282  0203                              
add [bx+si],al	; 00002284  0000                              
add [bx+si],al	; 00002286  0000                              
add al,[bx+si]	; 00002288  0200                              
adc [si],al	; 0000228A  1004                              
add al,0x4	; 0000228C  0404                              
add al,0x8	; 0000228E  0408                              
add [bx+si],al	; 00002290  0000                              
add [bx+si],al	; 00002292  0000                              
pop es	; 00002294  07                                
or [bx+si],al	; 00002295  0800                              
add [bx+si],al	; 00002297  0000                              
add [bx],al	; 00002299  0007                              
add al,0x4	; 0000229B  0404                              
add al,0x4	; 0000229D  0404                              
add al,0x4	; 0000229F  0404                              
or [bx+si],al	; 000022A1  0800                              
add [bx+si],al	; 000022A3  0000                              
add [bx],al	; 000022A5  0007                              
add al,0x4	; 000022A7  0404                              
add al,0x4	; 000022A9  0404                              
add al,0x4	; 000022AB  0404                              
add al,0x4	; 000022AD  0404                              
add al,0x4	; 000022AF  0404                              
add al,0x4	; 000022B1  0404                              
or [bx+si],al	; 000022B3  0800                              
add [bx+si],al	; 000022B5  0000                              
add [bx],al	; 000022B7  0007                              
add al,0x4	; 000022B9  0404                              
or [bx+si],al	; 000022BB  0800                              
add [bx+si],al	; 000022BD  0000                              
add [bp+si],al	; 000022BF  0002                              
add ax,[bx+si]	; 000022C1  0300                              
add [bx+si],al	; 000022C3  0000                              
add [bp+si],al	; 000022C5  0002                              
or dx,[bx+di]	; 000022C7  0B11                              
add [bx+si],al	; 000022C9  0000                              
add [bx+si],al	; 000022CB  0000                              
add [bx+si],al	; 000022CD  0000                              
add [bx+si],al	; 000022CF  0000                              
add [bx+si],al	; 000022D1  0000                              
add [bx+si],al	; 000022D3  0000                              
add [bx+si],al	; 000022D5  0000                              
add [bx+si],al	; 000022D7  0000                              
add [bx+si],al	; 000022D9  0000                              
add [bx+si],al	; 000022DB  0000                              
add [bx+si],al	; 000022DD  0000                              
add [bx+si],al	; 000022DF  0000                              
add [bx+si],al	; 000022E1  0000                              
add [bx+si],al	; 000022E3  0000                              
add [bx+si],al	; 000022E5  0000                              
add [bx+si],al	; 000022E7  0000                              
add [bx+si],al	; 000022E9  0000                              
add [bx+si],al	; 000022EB  0000                              
add [bx+si],al	; 000022ED  0000                              
add [bx+si],al	; 000022EF  0000                              
add [bx+si],al	; 000022F1  0000                              
add [bx+si],al	; 000022F3  0000                              
add [bx+si],al	; 000022F5  0000                              
add [bx+si],al	; 000022F7  0000                              
add [bx+si],al	; 000022F9  0000                              
add [bx+si],al	; 000022FB  0000                              
add [bp+si],al	; 000022FD  0002                              
add ax,[bx+si]	; 000022FF  0300                              
add [bx+si],al	; 00002301  0000                              
add [bp+si],al	; 00002303  0002                              
add ax,[bx+si]	; 00002305  0300                              
add [bx+si],al	; 00002307  0000                              
add [bx+si],al	; 00002309  0000                              
add [bx+si],al	; 0000230B  0000                              
add [bx+si],al	; 0000230D  0000                              
add [bx+si],al	; 0000230F  0000                              
add [bx+si],al	; 00002311  0000                              
add [bx+si],al	; 00002313  0000                              
add [bx+si],al	; 00002315  0000                              
add [bx+si],al	; 00002317  0000                              
add [bx+si],al	; 00002319  0000                              
add [bx+si],al	; 0000231B  0000                              
add [bx+si],al	; 0000231D  0000                              
add [bx+si],al	; 0000231F  0000                              
add [bx+si],al	; 00002321  0000                              
add [bx+si],al	; 00002323  0000                              
add [bx+si],al	; 00002325  0000                              
add [bx+si],al	; 00002327  0000                              
add [bx+si],al	; 00002329  0000                              
add [bx+si],al	; 0000232B  0000                              
add [bx+si],al	; 0000232D  0000                              
add [bx+si],al	; 0000232F  0000                              
add [bx+si],al	; 00002331  0000                              
add [bx+si],al	; 00002333  0000                              
add [bx+si],al	; 00002335  0000                              
add [bx+si],al	; 00002337  0000                              
add [bx+si],al	; 00002339  0000                              
add [bp+si],al	; 0000233B  0002                              
add ax,[bx+si]	; 0000233D  0300                              
add [bx+si],al	; 0000233F  0000                              
add [bp+si],al	; 00002341  0002                              
add ax,[bx+si]	; 00002343  0300                              
add [bx+si],al	; 00002345  0000                              
add [bx+si],al	; 00002347  0000                              
add [bx+si],al	; 00002349  0000                              
add [bx+si],al	; 0000234B  0000                              
add [bx+si],al	; 0000234D  0000                              
add [bx+si],al	; 0000234F  0000                              
add [bx+si],al	; 00002351  0000                              
add [bx+si],al	; 00002353  0000                              
add [bx+si],al	; 00002355  0000                              
add [bx+si],al	; 00002357  0000                              
add [bx+si],al	; 00002359  0000                              
add [bx+si],al	; 0000235B  0000                              
add [bx+si],al	; 0000235D  0000                              
add [bx+si],al	; 0000235F  0000                              
add [bx+si],al	; 00002361  0000                              
add [bx+si],al	; 00002363  0000                              
add [bx+si],al	; 00002365  0000                              
add [bx+si],al	; 00002367  0000                              
add [bx+si],al	; 00002369  0000                              
add [bx+si],al	; 0000236B  0000                              
add [bx+si],al	; 0000236D  0000                              
add [bx+si],al	; 0000236F  0000                              
add [bx+si],al	; 00002371  0000                              
add [bx+si],al	; 00002373  0000                              
add [bx+si],al	; 00002375  0000                              
add [bx+si],al	; 00002377  0000                              
add [bp+si],al	; 00002379  0002                              
add ax,[bx+si]	; 0000237B  0300                              
add [bx+si],al	; 0000237D  0000                              
add [bp+si],al	; 0000237F  0002                              
add ax,[bx+si]	; 00002381  0300                              
add [bx+si],al	; 00002383  0000                              
add [bx+si],al	; 00002385  0000                              
add [bx+si],al	; 00002387  0000                              
add [bx+si],al	; 00002389  0000                              
add [bx+si],al	; 0000238B  0000                              
add [bx+si],al	; 0000238D  0000                              
add [bx+si],al	; 0000238F  0000                              
add [bx+si],al	; 00002391  0000                              
add [bx+si],al	; 00002393  0000                              
add [bx+si],al	; 00002395  0000                              
add [bx+si],al	; 00002397  0000                              
add [bx+si],al	; 00002399  0000                              
add [bx+si],al	; 0000239B  0000                              
add [bx+si],al	; 0000239D  0000                              
add [bx+si],al	; 0000239F  0000                              
add [bx+si],al	; 000023A1  0000                              
add [bx+si],al	; 000023A3  0000                              
add [bx+si],al	; 000023A5  0000                              
add [bx+si],al	; 000023A7  0000                              
add [bx+si],al	; 000023A9  0000                              
add [bx+si],al	; 000023AB  0000                              
add [bx+si],al	; 000023AD  0000                              
add [bx+si],al	; 000023AF  0000                              
add [bx+si],al	; 000023B1  0000                              
add [bx+si],al	; 000023B3  0000                              
add [bx+si],al	; 000023B5  0000                              
add [bp+si],al	; 000023B7  0002                              
add ax,[bx+si]	; 000023B9  0300                              
add [bx+si],al	; 000023BB  0000                              
add [bp+si],al	; 000023BD  0002                              
add ax,[bx+si]	; 000023BF  0300                              
add [bx+si],al	; 000023C1  0000                              
add [di],al	; 000023C3  0005                              
add [bx+di],ax	; 000023C5  0101                              
add [bx+di],ax	; 000023C7  0101                              
add [bx+di],ax	; 000023C9  0101                              
push es	; 000023CB  06                                
add [bx+si],al	; 000023CC  0000                              
add [bx+si],al	; 000023CE  0000                              
add ax,0x101	; 000023D0  050101                            
add [bx+di],ax	; 000023D3  0101                              
add [bx+di],ax	; 000023D5  0101                              
push es	; 000023D7  06                                
add [bx+si],al	; 000023D8  0000                              
add [bx+si],al	; 000023DA  0000                              
add ax,0x101	; 000023DC  050101                            
add [bx+di],ax	; 000023DF  0101                              
add [bx+di],ax	; 000023E1  0101                              
push es	; 000023E3  06                                
add [bx+si],al	; 000023E4  0000                              
add [bx+si],al	; 000023E6  0000                              
add ax,0x6	; 000023E8  050600                            
add [bx+si],al	; 000023EB  0000                              
add [di],al	; 000023ED  0005                              
add [bx+di],ax	; 000023EF  0101                              
push es	; 000023F1  06                                
add [bx+si],al	; 000023F2  0000                              
add [bx+si],al	; 000023F4  0000                              
add al,[bp+di]	; 000023F6  0203                              
add [bx+si],al	; 000023F8  0000                              
add [bx+si],al	; 000023FA  0000                              
add al,[bp+di]	; 000023FC  0203                              
add [bx+si],al	; 000023FE  0000                              
add [bx+si],al	; 00002400  0000                              
pop es	; 00002402  07                                
add al,0x4	; 00002403  0404                              
add al,0x4	; 00002405  0404                              
or al,0x0	; 00002407  0C00                              
add ax,[bx+si]	; 00002409  0300                              
add [bx+si],al	; 0000240B  0000                              
add [bp+si],al	; 0000240D  0002                              
add [bx+si],al	; 0000240F  0000                              
add [bx+si],al	; 00002411  0000                              
add [bx+si],al	; 00002413  0000                              
add ax,[bx+si]	; 00002415  0300                              
add [bx+si],al	; 00002417  0000                              
add [bp+si],al	; 00002419  0002                              
add [bx+si],al	; 0000241B  0000                              
add [bx+si],al	; 0000241D  0000                              
add [bx+si],al	; 0000241F  0000                              
add ax,[bx+si]	; 00002421  0300                              
add [bx+si],al	; 00002423  0000                              
add [bp+si],al	; 00002425  0002                              
add ax,[bx+si]	; 00002427  0300                              
add [bx+si],al	; 00002429  0000                              
add [bp+si],al	; 0000242B  0002                              
add [bx+si],al	; 0000242D  0000                              
add ax,[bx+si]	; 0000242F  0300                              
add [bx+si],al	; 00002431  0000                              
add [bp+si],al	; 00002433  0002                              
add ax,[bx+si]	; 00002435  0300                              
add [bx+si],al	; 00002437  0000                              
add [bp+si],al	; 00002439  0002                              
add ax,[bx+si]	; 0000243B  0300                              
add [bx+si],al	; 0000243D  0000                              
add [bx+si],al	; 0000243F  0000                              
add [bx+si],al	; 00002441  0000                              
add [bx+si],al	; 00002443  0000                              
adc cl,[0x3]	; 00002445  120E0300                          
add [bx+si],al	; 00002449  0000                              
add [bp+si],al	; 0000244B  0002                              
add [bx+si],al	; 0000244D  0000                              
add [bx+si],al	; 0000244F  0000                              
add [bx+si],al	; 00002451  0000                              
add ax,[bx+si]	; 00002453  0300                              
add [bx+si],al	; 00002455  0000                              
add [bp+si],al	; 00002457  0002                              
add [bx+si],al	; 00002459  0000                              
add [bx+si],al	; 0000245B  0000                              
add [bx+si],al	; 0000245D  0000                              
add ax,[bx+si]	; 0000245F  0300                              
add [bx+si],al	; 00002461  0000                              
add [bp+si],al	; 00002463  0002                              
add ax,[bx+si]	; 00002465  0300                              
add [bx+si],al	; 00002467  0000                              
add [bp+si],al	; 00002469  0002                              
add [bx+si],al	; 0000246B  0000                              
add ax,[bx+si]	; 0000246D  0300                              
add [bx+si],al	; 0000246F  0000                              
add [bp+si],al	; 00002471  0002                              
add ax,[bx+si]	; 00002473  0300                              
add [bx+si],al	; 00002475  0000                              
add [bp+si],al	; 00002477  0002                              
add ax,[bx+si]	; 00002479  0300                              
add [bx+si],al	; 0000247B  0000                              
add [bx+si],al	; 0000247D  0000                              
add [bx+si],al	; 0000247F  0000                              
add [bx+si],al	; 00002481  0000                              
add [bp+si],al	; 00002483  0002                              
add ax,[bx+si]	; 00002485  0300                              
add [bx+si],al	; 00002487  0000                              
add [bp+si],al	; 00002489  0002                              
add [bx+si],al	; 0000248B  0000                              
add [bx+si],al	; 0000248D  0000                              
add [bx+si],al	; 0000248F  0000                              
add ax,[bx+si]	; 00002491  0300                              
add [bx+si],al	; 00002493  0000                              
add [bp+si],al	; 00002495  0002                              
add [bx+si],al	; 00002497  0000                              
add [bx+si],al	; 00002499  0000                              
add [bx+si],al	; 0000249B  0000                              
add ax,[bx+si]	; 0000249D  0300                              
add [bx+si],al	; 0000249F  0000                              
add [bp+si],al	; 000024A1  0002                              
add ax,[bx+si]	; 000024A3  0300                              
add [bx+si],al	; 000024A5  0000                              
add [bp+si],al	; 000024A7  0002                              
add [bx+si],al	; 000024A9  0000                              
add ax,[bx+si]	; 000024AB  0300                              
add [bx+si],al	; 000024AD  0000                              
add [bp+si],al	; 000024AF  0002                              
add ax,[bx+si]	; 000024B1  0300                              
add [bx+si],al	; 000024B3  0000                              
add [bp+si],al	; 000024B5  0002                              
add ax,[bx+si]	; 000024B7  0300                              
add [bx+si],al	; 000024B9  0000                              
add [bx+si],al	; 000024BB  0000                              
add [bx+si],al	; 000024BD  0000                              
add [bx+si],al	; 000024BF  0000                              
add [bp+si],al	; 000024C1  0002                              
add ax,[bx+si]	; 000024C3  0300                              
add [bx+si],al	; 000024C5  0000                              
add [bp+si],al	; 000024C7  0002                              
add [bx+si],al	; 000024C9  0000                              
add [bx+si],al	; 000024CB  0000                              
add [bx+si],al	; 000024CD  0000                              
add ax,[bx+si]	; 000024CF  0300                              
add [bx+si],al	; 000024D1  0000                              
add [bp+si],al	; 000024D3  0002                              
add [bx+si],al	; 000024D5  0000                              
add [bx+si],al	; 000024D7  0000                              
add [bx+si],al	; 000024D9  0000                              
add ax,[bx+si]	; 000024DB  0300                              
add [bx+si],al	; 000024DD  0000                              
add [bp+si],al	; 000024DF  0002                              
add ax,[bx+si]	; 000024E1  0300                              
add [bx+si],al	; 000024E3  0000                              
add [bp+si],al	; 000024E5  0002                              
add [bx+si],al	; 000024E7  0000                              
add ax,[bx+si]	; 000024E9  0300                              
add [bx+si],al	; 000024EB  0000                              
add [bp+si],al	; 000024ED  0002                              
add ax,[bx+si]	; 000024EF  0300                              
add [bx+si],al	; 000024F1  0000                              
add [bx],al	; 000024F3  0007                              
or [bx+si],al	; 000024F5  0800                              
add [bx+si],al	; 000024F7  0000                              
add [bx+si],al	; 000024F9  0000                              
add [bx+si],al	; 000024FB  0000                              
add [bx+si],al	; 000024FD  0000                              
add [bx],al	; 000024FF  0007                              
or [bx+si],al	; 00002501  0800                              
add [bx+si],al	; 00002503  0000                              
add [bp+si],al	; 00002505  0002                              
add [bx+si],al	; 00002507  0000                              
add [bx+si],al	; 00002509  0000                              
add [bx+si],al	; 0000250B  0000                              
add ax,[bx+si]	; 0000250D  0300                              
add [bx+si],al	; 0000250F  0000                              
add [bp+si],al	; 00002511  0002                              
add [bx+si],al	; 00002513  0000                              
add [bx+si],al	; 00002515  0000                              
add [bx+si],al	; 00002517  0000                              
add ax,[bx+si]	; 00002519  0300                              
add [bx+si],al	; 0000251B  0000                              
add [bx],al	; 0000251D  0007                              
or [bx+si],al	; 0000251F  0800                              
add [bx+si],al	; 00002521  0000                              
add [bx],al	; 00002523  0007                              
add al,0x4	; 00002525  0404                              
or [bx+si],al	; 00002527  0800                              
add [bx+si],al	; 00002529  0000                              
add [bp+si],al	; 0000252B  0002                              
add ax,[bx+si]	; 0000252D  0300                              
add [bx+si],al	; 0000252F  0000                              
add [bx+si],al	; 00002531  0000                              
add [bx+si],al	; 00002533  0000                              
add [bx+si],al	; 00002535  0000                              
add [di],al	; 00002537  0005                              
push es	; 00002539  06                                
add [bx+si],al	; 0000253A  0000                              
add [bx+si],al	; 0000253C  0000                              
add [bx+si],al	; 0000253E  0000                              
add [bx+si],al	; 00002540  0000                              
add [bx+si],al	; 00002542  0000                              
add al,[bx+si]	; 00002544  0200                              
add [bx+si],al	; 00002546  0000                              
add [bx+si],al	; 00002548  0000                              
add [bp+di],al	; 0000254A  0003                              
add [bx+si],al	; 0000254C  0000                              
add [bx+si],al	; 0000254E  0000                              
add al,[bx+si]	; 00002550  0200                              
add [bx+si],al	; 00002552  0000                              
add [bx+si],al	; 00002554  0000                              
add [bp+di],al	; 00002556  0003                              
add [bx+si],al	; 00002558  0000                              
add [bx+si],al	; 0000255A  0000                              
add [bx+si],al	; 0000255C  0000                              
add [bx+si],al	; 0000255E  0000                              
add [bx+si],al	; 00002560  0000                              
add [bx+si],al	; 00002562  0000                              
add [bx+si],al	; 00002564  0000                              
add [bx+si],al	; 00002566  0000                              
add [bx+si],al	; 00002568  0000                              
add al,[bp+di]	; 0000256A  0203                              
add [bx+si],al	; 0000256C  0000                              
add [bx+si],al	; 0000256E  0000                              
add [bx+si],al	; 00002570  0000                              
add [bx+si],al	; 00002572  0000                              
add [bx+si],al	; 00002574  0000                              
add al,[bp+di]	; 00002576  0203                              
add [bx+si],al	; 00002578  0000                              
add [bx+si],al	; 0000257A  0000                              
add [bx+si],al	; 0000257C  0000                              
add [bx+si],al	; 0000257E  0000                              
add [bx+si],al	; 00002580  0000                              
add al,[bx+si]	; 00002582  0200                              
add [bx+si],al	; 00002584  0000                              
add [bx+si],al	; 00002586  0000                              
add [bp+di],al	; 00002588  0003                              
add [bx+si],al	; 0000258A  0000                              
add [bx+si],al	; 0000258C  0000                              
add al,[bx+si]	; 0000258E  0200                              
add [bx+si],al	; 00002590  0000                              
add [bx+si],al	; 00002592  0000                              
add [bp+di],al	; 00002594  0003                              
add [bx+si],al	; 00002596  0000                              
add [bx+si],al	; 00002598  0000                              
add [bx+si],al	; 0000259A  0000                              
add [bx+si],al	; 0000259C  0000                              
add [bx+si],al	; 0000259E  0000                              
add [bx+si],al	; 000025A0  0000                              
add [bx+si],al	; 000025A2  0000                              
add [bx+si],al	; 000025A4  0000                              
add [bx+si],al	; 000025A6  0000                              
add al,[bp+di]	; 000025A8  0203                              
add [bx+si],al	; 000025AA  0000                              
add [bx+si],al	; 000025AC  0000                              
add [bx+si],al	; 000025AE  0000                              
add [bx+si],al	; 000025B0  0000                              
add [bx+si],al	; 000025B2  0000                              
add al,[bp+di]	; 000025B4  0203                              
add [bx+si],al	; 000025B6  0000                              
add [bx+si],al	; 000025B8  0000                              
add [bx+si],al	; 000025BA  0000                              
add [bx+si],al	; 000025BC  0000                              
add [bx+si],al	; 000025BE  0000                              
add al,[bx+si]	; 000025C0  0200                              
add [bx+si],al	; 000025C2  0000                              
add [bx+si],al	; 000025C4  0000                              
add [bp+di],al	; 000025C6  0003                              
add [bx+si],al	; 000025C8  0000                              
add [bx+si],al	; 000025CA  0000                              
add al,[bx+si]	; 000025CC  0200                              
add [bx+si],al	; 000025CE  0000                              
add [bx+si],al	; 000025D0  0000                              
add [bp+di],al	; 000025D2  0003                              
add [bx+si],al	; 000025D4  0000                              
add [bx+si],al	; 000025D6  0000                              
add [bx+si],al	; 000025D8  0000                              
add [bx+si],al	; 000025DA  0000                              
add [bx+si],al	; 000025DC  0000                              
add [bx+si],al	; 000025DE  0000                              
add [bx+si],al	; 000025E0  0000                              
add [bx+si],al	; 000025E2  0000                              
add [bx+si],al	; 000025E4  0000                              
add bl,[bp+di]	; 000025E6  021B                              
pop ss	; 000025E8  17                                
add al,0x4	; 000025E9  0404                              
add al,0x4	; 000025EB  0404                              
add al,0x4	; 000025ED  0404                              
add al,0x4	; 000025EF  0404                              
sbb [si],bl	; 000025F1  181C                              
sbb dx,[bx]	; 000025F3  1B17                              
add al,0x4	; 000025F5  0404                              
add al,0x4	; 000025F7  0404                              
add al,0x4	; 000025F9  0404                              
add al,0x4	; 000025FB  0404                              
sbb [si],bl	; 000025FD  181C                              
add [bx+si],al	; 000025FF  0000                              
add [bx+si],al	; 00002601  0000                              
add [bx+si],al	; 00002603  0000                              
add ax,[bx+si]	; 00002605  0300                              
add [bx+si],al	; 00002607  0000                              
add [bp+si],al	; 00002609  0002                              
add [bx+si],al	; 0000260B  0000                              
add [bx+si],al	; 0000260D  0000                              
add [bx+si],al	; 0000260F  0000                              
sbb dx,[bx]	; 00002611  1B17                              
add al,0x4	; 00002613  0404                              
add al,0x4	; 00002615  0404                              
add al,0x4	; 00002617  0404                              
add al,0x4	; 00002619  0404                              
add al,0x4	; 0000261B  0404                              
add al,0x4	; 0000261D  0404                              
add al,0x4	; 0000261F  0404                              
add al,0x4	; 00002621  0404                              
sbb [si],bl	; 00002623  181C                              
cbw	; 00002625  98                                
push ss	; 00002626  16                                
lodsb	; 00002627  AC                                
push ss	; 00002628  16                                
dec dx	; 00002629  4A                                
sbb [bp+0x19],bx	; 0000262A  195E19                            
mov bx,0xe300	; 0000262D  BB00E3                            
add [bp+di+0x1d],bh	; 00002630  007B1D                            
mov [0x1d],ax	; 00002633  A31D00                            
add [bx+si],al	; 00002636  0000                              
add [bx+si],al	; 00002638  0000                              
add [bp+di],al	; 0000263A  0003                              
rol byte [bp+di],byte 0xc0	; 0000263C  C003C0                            
add [bx+si],al	; 0000263F  0000                              
add [bx+si],al	; 00002641  0000                              
add [bx+si],al	; 00002643  0000                              
db 0x0f	; 00002645  0F                                
lock	; 00002646  F0                                
aas	; 00002647  3F                                
cld	; 00002648  FC                                
db 0xff	; 00002649  FF                                
db 0xff	; 0000264A  FF                                
db 0xff	; 0000264B  FF                                
db 0xff	; 0000264C  FF                                
db 0xff	; 0000264D  FF                                
db 0xff	; 0000264E  FF                                
db 0xff	; 0000264F  FF                                
db 0xff	; 00002650  FF                                
aas	; 00002651  3F                                
cld	; 00002652  FC                                
db 0x0f	; 00002653  0F                                
lock add [bx+si],al	; 00002654  F00000                            
add [bx+si],al	; 00002657  0000                              
add [bx+si],al	; 00002659  0000                              
add [bx+si],al	; 0000265B  0000                              
add [bx+si],al	; 0000265D  0000                              
add [bx+si],al	; 0000265F  0000                              
add [bx+si],al	; 00002661  0000                              
add [bx+si],al	; 00002663  0000                              
add [bx+si],ax	; 00002665  0100                              
add [bx+si],al	; 00002667  0000                              
add [bx+si],al	; 00002669  0000                              
add [bx+si],al	; 0000266B  0000                              
add [bx+si],al	; 0000266D  0000                              
add [bx+si],al	; 0000266F  0000                              
add [bx+si],al	; 00002671  0000                              
add [bx+si],al	; 00002673  0000                              
add [bx+si],al	; 00002675  0000                              
add [bx+si],al	; 00002677  0000                              
add [bx+si],al	; 00002679  0000                              
add [bx+si],al	; 0000267B  0000                              
add [bx+si],al	; 0000267D  0000                              
add [bx+si],al	; 0000267F  0000                              
add [bx+si],al	; 00002681  0000                              
add [bx+si],al	; 00002683  0000                              
add [bx+si],al	; 00002685  0000                              
add [bx+si],al	; 00002687  0000                              
add [bx+si],al	; 00002689  0000                              
add [bx+si],al	; 0000268B  0000                              
add [bx+si],al	; 0000268D  0000                              
add [bx+si],al	; 0000268F  0000                              
add [bx+si],al	; 00002691  0000                              
add [bx+si],al	; 00002693  0000                              
add [bx+si],al	; 00002695  0000                              
add [bx+si],al	; 00002697  0000                              
add [bx+si],al	; 00002699  0000                              
add [bx+si],al	; 0000269B  0000                              
add [bx+si],al	; 0000269D  0000                              
add [bx+si],al	; 0000269F  0000                              
add [bx+si],al	; 000026A1  0000                              
add [bx+si],al	; 000026A3  0000                              
add [bx+si],al	; 000026A5  0000                              
add [bx+si],al	; 000026A7  0000                              
add [bx+si],al	; 000026A9  0000                              
add [bx+si],al	; 000026AB  0000                              
add [bx+si],al	; 000026AD  0000                              
add [bx+si],al	; 000026AF  0000                              
add [bx+si],al	; 000026B1  0000                              
add [bx+si],al	; 000026B3  0000                              
add [bx+si],al	; 000026B5  0000                              
add [bx+si],al	; 000026B7  0000                              
add [bx+si],al	; 000026B9  0000                              
add [bx+si],al	; 000026BB  0000                              
add [bx+si],al	; 000026BD  0000                              
add [bx+si],al	; 000026BF  0000                              
add [bx+si],al	; 000026C1  0000                              
add [bx+si],al	; 000026C3  0000                              
add [bx+si],al	; 000026C5  0000                              
add [bx+si],al	; 000026C7  0000                              
add [bx+si],al	; 000026C9  0000                              
add [bx+si],al	; 000026CB  0000                              
add [bx+si],al	; 000026CD  0000                              
add [bx+si],al	; 000026CF  0000                              
add [bx+si],al	; 000026D1  0000                              
add [bx+si],al	; 000026D3  0000                              
add [bx+si],al	; 000026D5  0000                              
add [bx+si],al	; 000026D7  0000                              
add [bx+si],al	; 000026D9  0000                              
add [bx+si],al	; 000026DB  0000                              
add [bx+si],al	; 000026DD  0000                              
add [bx+si],al	; 000026DF  0000                              
add [bx+si],al	; 000026E1  0000                              
add [bx+si],al	; 000026E3  0000                              
add [bx+si],al	; 000026E5  0000                              
add [bx+si],al	; 000026E7  0000                              
add [bx+si],al	; 000026E9  0000                              
add [bx+si],al	; 000026EB  0000                              
add [bx+si],al	; 000026ED  0000                              
add [bx+si],al	; 000026EF  0000                              
add [bx+si],al	; 000026F1  0000                              
add [bx+si],al	; 000026F3  0000                              
add [bx+si],al	; 000026F5  0000                              
add [bx+si],al	; 000026F7  0000                              
add [bx+si],al	; 000026F9  0000                              
add [bx+si],al	; 000026FB  0000                              
add [bx+si],al	; 000026FD  0000                              
add [bx+si],al	; 000026FF  0000                              
add [bx+si],al	; 00002701  0000                              
add [bx+si],al	; 00002703  0000                              
add [bx+si],al	; 00002705  0000                              
add [bx+si],al	; 00002707  0000                              
add [bx+si],al	; 00002709  0000                              
add [bx+si],al	; 0000270B  0000                              
add [bx+si],al	; 0000270D  0000                              
add [bx+si],al	; 0000270F  0000                              
add [bx+si],al	; 00002711  0000                              
add [bx+si],al	; 00002713  0000                              
add [bx+si],al	; 00002715  0000                              
add [bx+si],al	; 00002717  0000                              
add [bx+si],al	; 00002719  0000                              
add [bx+si],al	; 0000271B  0000                              
add [bx+si],al	; 0000271D  0000                              
add [bx+si],al	; 0000271F  0000                              
add [bx+si],al	; 00002721  0000                              
add [bx+si],al	; 00002723  0000                              
add [bx+si],al	; 00002725  0000                              
add [bx+si],al	; 00002727  0000                              
add [bx+si],al	; 00002729  0000                              
add [bx+si],al	; 0000272B  0000                              
add [bx+si],al	; 0000272D  0000                              
add [bx+si],al	; 0000272F  0000                              
add [bx+si],al	; 00002731  0000                              
add [bx+si],al	; 00002733  0000                              
add [bx+si],al	; 00002735  0000                              
add [bx+si],al	; 00002737  0000                              
add [bx+si],al	; 00002739  0000                              
add [bx+si],al	; 0000273B  0000                              
add [bx+si],al	; 0000273D  0000                              
add [bx+si],al	; 0000273F  0000                              
add [bx+si],al	; 00002741  0000                              
add [bx+si],al	; 00002743  0000                              
add [bx+si],al	; 00002745  0000                              
add [bx+si],al	; 00002747  0000                              
add [bx+si],al	; 00002749  0000                              
add [bx+si],al	; 0000274B  0000                              
add [bx+si],al	; 0000274D  0000                              
add [bx+si],al	; 0000274F  0000                              
add [bx+si],al	; 00002751  0000                              
add [bx+si],al	; 00002753  0000                              
add [bx+si],al	; 00002755  0000                              
add [bx+si],al	; 00002757  0000                              
add [bx+si],al	; 00002759  0000                              
add [bx+si],al	; 0000275B  0000                              
add [bx+si],al	; 0000275D  0000                              
add [bx+si],al	; 0000275F  0000                              
add [bx+si],al	; 00002761  0000                              
add [bx+si],al	; 00002763  0000                              
add [bx+si],al	; 00002765  0000                              
add [bx+si],al	; 00002767  0000                              
add [bx+si],al	; 00002769  0000                              
add [bx+si],al	; 0000276B  0000                              
add [bx+si],al	; 0000276D  0000                              
add [bx+si],al	; 0000276F  0000                              
add [bx+si],al	; 00002771  0000                              
add [bx+si],al	; 00002773  0000                              
add [bx+si],al	; 00002775  0000                              
add [bx+si],al	; 00002777  0000                              
add [bx+si],al	; 00002779  0000                              
add [bx+si],al	; 0000277B  0000                              
add [bx+si],al	; 0000277D  0000                              
add [bx+si],al	; 0000277F  0000                              
add [bx+si],al	; 00002781  0000                              
add [bx+si],al	; 00002783  0000                              
add [bx+si],al	; 00002785  0000                              
add [bx+si],al	; 00002787  0000                              
add [bx+si],al	; 00002789  0000                              
add [bx+si],al	; 0000278B  0000                              
add [bx+si],al	; 0000278D  0000                              
add [bx+si],al	; 0000278F  0000                              
add [bx+si],al	; 00002791  0000                              
add [bx+si],al	; 00002793  0000                              
add [bx+si],al	; 00002795  0000                              
add [bx+si],al	; 00002797  0000                              
add [bx+si],al	; 00002799  0000                              
add [bx+si],al	; 0000279B  0000                              
add [bx+si],al	; 0000279D  0000                              
add [bx+si],al	; 0000279F  0000                              
add [bx+si],al	; 000027A1  0000                              
add [bx+si],al	; 000027A3  0000                              
add [bx+si],al	; 000027A5  0000                              
add [bx+si],al	; 000027A7  0000                              
add [bx+si],al	; 000027A9  0000                              
add [bx+si],al	; 000027AB  0000                              
add [bx+si],al	; 000027AD  0000                              
add [bx+si],al	; 000027AF  0000                              
add [bx+si],al	; 000027B1  0000                              
add [bx+si],al	; 000027B3  0000                              
add [bx+si],al	; 000027B5  0000                              
add [bx+si],al	; 000027B7  0000                              
add [bx+si],al	; 000027B9  0000                              
add [bx+si],al	; 000027BB  0000                              
add [bx+si],al	; 000027BD  0000                              
add [bx+si],al	; 000027BF  0000                              
add [bx+si],al	; 000027C1  0000                              
add [bx+si],al	; 000027C3  0000                              
add [bx+si],al	; 000027C5  0000                              
add [bx+si],al	; 000027C7  0000                              
add [bx+si],al	; 000027C9  0000                              
add [bx+si],al	; 000027CB  0000                              
add [bx+si],al	; 000027CD  0000                              
add [bx+si],al	; 000027CF  0000                              
add [bx+si],al	; 000027D1  0000                              
add [bx+si],al	; 000027D3  0000                              
add [bx+si],al	; 000027D5  0000                              
add [bx+si],al	; 000027D7  0000                              
add [bx+si],al	; 000027D9  0000                              
add [bx+si],al	; 000027DB  0000                              
add [bx+si],al	; 000027DD  0000                              
add [bx+si],al	; 000027DF  0000                              
add [bx+si],al	; 000027E1  0000                              
add [bx+si],al	; 000027E3  0000                              
add [bx+si],al	; 000027E5  0000                              
add [bx+si],al	; 000027E7  0000                              
add [bx+si],al	; 000027E9  0000                              
add [bx+si],al	; 000027EB  0000                              
add [bx+si],al	; 000027ED  0000                              
add [bx+si],al	; 000027EF  0000                              
add [bx+si],al	; 000027F1  0000                              
add [bx+si],al	; 000027F3  0000                              
add [bx+si],al	; 000027F5  0000                              
add [bx+si],al	; 000027F7  0000                              
add [bx+si],al	; 000027F9  0000                              
add [bx+si],al	; 000027FB  0000                              
add [bx+si],al	; 000027FD  0000                              
add [bx+si],al	; 000027FF  0000                              
add [bx+si],al	; 00002801  0000                              
add [bx+si],al	; 00002803  0000                              
add [bx+si],al	; 00002805  0000                              
add [bx+si],al	; 00002807  0000                              
add [bx+si],al	; 00002809  0000                              
add [bx+si],al	; 0000280B  0000                              
add [bx+si],al	; 0000280D  0000                              
add [bx+si],al	; 0000280F  0000                              
add [bx+si],al	; 00002811  0000                              
add [bx+si],al	; 00002813  0000                              
add [bx+si],al	; 00002815  0000                              
add [bx+si],al	; 00002817  0000                              
add [bx+si],al	; 00002819  0000                              
add [bx+si],al	; 0000281B  0000                              
add [bx+si],al	; 0000281D  0000                              
add [bx+si],al	; 0000281F  0000                              
add [bx+si],al	; 00002821  0000                              
add [bx+si],al	; 00002823  0000                              
add [bx+si],al	; 00002825  0000                              
add [bx+si],al	; 00002827  0000                              
add [bx+si],al	; 00002829  0000                              
add [bx+si],al	; 0000282B  0000                              
add [bx+si],al	; 0000282D  0000                              
add [bx+si],al	; 0000282F  0000                              
add [bx+si],al	; 00002831  0000                              
add [bx+si],al	; 00002833  0000                              
add [bx+si],al	; 00002835  0000                              
add [bx+si],al	; 00002837  0000                              
add [bx+si],al	; 00002839  0000                              
add [bx+si],al	; 0000283B  0000                              
add [bx+si],al	; 0000283D  0000                              
add [bx+si],al	; 0000283F  0000                              
add [bx+si],al	; 00002841  0000                              
add [bx+si],al	; 00002843  0000                              
add [bx+si],al	; 00002845  0000                              
add [bx+si],al	; 00002847  0000                              
add [bx+si],al	; 00002849  0000                              
add [bx+si],al	; 0000284B  0000                              
add [bx+si],al	; 0000284D  0000                              
add [bx+si],al	; 0000284F  0000                              
add [bx+si],al	; 00002851  0000                              
add [bx+si],al	; 00002853  0000                              
add [bx+si],al	; 00002855  0000                              
add [bx+si],al	; 00002857  0000                              
add [bx+si],al	; 00002859  0000                              
add [bx+si],al	; 0000285B  0000                              
add [bx+si],al	; 0000285D  0000                              
add [bx+si],al	; 0000285F  0000                              
add [bx+si],al	; 00002861  0000                              
add [bx+si],al	; 00002863  0000                              
add [bx+si],al	; 00002865  0000                              
add [bx+si],al	; 00002867  0000                              
add [bx+si],al	; 00002869  0000                              
add [bx+si],al	; 0000286B  0000                              
add [bx+si],al	; 0000286D  0000                              
add [bx+si],al	; 0000286F  0000                              
add [bx+si],al	; 00002871  0000                              
add [bx+si],al	; 00002873  0000                              
add [bx+si],al	; 00002875  0000                              
add [bx+si],al	; 00002877  0000                              
add [bx+si],al	; 00002879  0000                              
add [bx+si],al	; 0000287B  0000                              
add [bx+si],al	; 0000287D  0000                              
add [bx+si],al	; 0000287F  0000                              
add [bx+si],al	; 00002881  0000                              
add [bx+si],al	; 00002883  0000                              
add [bx+si],al	; 00002885  0000                              
add [bx+si],al	; 00002887  0000                              
add [bx+si],al	; 00002889  0000                              
add [bx+si],al	; 0000288B  0000                              
add [bx+si],al	; 0000288D  0000                              
add [bx+si],al	; 0000288F  0000                              
add [bx+si],al	; 00002891  0000                              
add [bx+si],al	; 00002893  0000                              
add [bx+si],al	; 00002895  0000                              
add [bx+si],al	; 00002897  0000                              
add [bx+si],al	; 00002899  0000                              
add [bx+si],al	; 0000289B  0000                              
add [bx+si],al	; 0000289D  0000                              
add [bx+si],al	; 0000289F  0000                              
add [bx+si],al	; 000028A1  0000                              
add [bx+si],al	; 000028A3  0000                              
add [bx+si],al	; 000028A5  0000                              
add [bx+si],al	; 000028A7  0000                              
add [bx+si],al	; 000028A9  0000                              
add [bx+si],al	; 000028AB  0000                              
add [bx+si],al	; 000028AD  0000                              
add [bx+si],al	; 000028AF  0000                              
add [bx+si],al	; 000028B1  0000                              
add [bx+si],al	; 000028B3  0000                              
add [bx+si],al	; 000028B5  0000                              
add [bx+si],al	; 000028B7  0000                              
add [bx+si],al	; 000028B9  0000                              
add [bx+si],al	; 000028BB  0000                              
add [bx+si],al	; 000028BD  0000                              
add [bx+si],al	; 000028BF  0000                              
add [bx+si],al	; 000028C1  0000                              
add [bx+si],al	; 000028C3  0000                              
add [bx+si],al	; 000028C5  0000                              
add [bx+si],al	; 000028C7  0000                              
add [bx+si],al	; 000028C9  0000                              
add [bx+si],al	; 000028CB  0000                              
add [bx+si],al	; 000028CD  0000                              
add [bx+si],al	; 000028CF  0000                              
add [bx+si],al	; 000028D1  0000                              
add [bx+si],al	; 000028D3  0000                              
add [bx+si],al	; 000028D5  0000                              
add [bx+si],al	; 000028D7  0000                              
add [bx+si],al	; 000028D9  0000                              
add [bx+si],al	; 000028DB  0000                              
add [bx+si],al	; 000028DD  0000                              
add [bx+si],al	; 000028DF  0000                              
add [bx+si],al	; 000028E1  0000                              
add [bx+si],al	; 000028E3  0000                              
add [bx+si],al	; 000028E5  0000                              
add [bx+si],al	; 000028E7  0000                              
add [bx+si],al	; 000028E9  0000                              
add [bx+si],al	; 000028EB  0000                              
add [bx+si],al	; 000028ED  0000                              
add [bx+si],al	; 000028EF  0000                              
add [bx+si],al	; 000028F1  0000                              
add [bx+si],al	; 000028F3  0000                              
add [bx+si],al	; 000028F5  0000                              
add [bx+si],al	; 000028F7  0000                              
add [bx+si],al	; 000028F9  0000                              
add [bx+si],al	; 000028FB  0000                              
add [bx+si],al	; 000028FD  0000                              
add [bx+si],al	; 000028FF  0000                              
add [bx+si],al	; 00002901  0000                              
add [bx+si],al	; 00002903  0000                              
add [bx+si],al	; 00002905  0000                              
add [bx+si],al	; 00002907  0000                              
add [bx+si],al	; 00002909  0000                              
add [bx+si],al	; 0000290B  0000                              
add [bx+si],al	; 0000290D  0000                              
add [bx+si],al	; 0000290F  0000                              
add [bx+si],al	; 00002911  0000                              
add [bx+si],al	; 00002913  0000                              
add [bx+si],al	; 00002915  0000                              
add [bx+si],al	; 00002917  0000                              
add [bx+si],al	; 00002919  0000                              
add [bx+si],al	; 0000291B  0000                              
add [bx+si],al	; 0000291D  0000                              
add [bx+si],al	; 0000291F  0000                              
add [bx+si],al	; 00002921  0000                              
add [bx+si],al	; 00002923  0000                              
add [bx+si],al	; 00002925  0000                              
add [bx+si],al	; 00002927  0000                              
add [bx+si],al	; 00002929  0000                              
add [bx+si],al	; 0000292B  0000                              
add [bx+si],al	; 0000292D  0000                              
add [bx+si],al	; 0000292F  0000                              
add [bx+si],al	; 00002931  0000                              
add [bx+si],al	; 00002933  0000                              
add [bx+si],al	; 00002935  0000                              
add [bx+si],al	; 00002937  0000                              
add [bx+si],al	; 00002939  0000                              
add [bx+si],al	; 0000293B  0000                              
add [bx+si],al	; 0000293D  0000                              
add [bx+si],al	; 0000293F  0000                              
add [bx+si],al	; 00002941  0000                              
add [bx+si],al	; 00002943  0000                              
add [bx+si],al	; 00002945  0000                              
add [bx+si],al	; 00002947  0000                              
add [bx+si],al	; 00002949  0000                              
add [bx+si],al	; 0000294B  0000                              
add [bx+si],al	; 0000294D  0000                              
add [bx+si],al	; 0000294F  0000                              
add [bx+si],al	; 00002951  0000                              
add [bx+si],al	; 00002953  0000                              
add [bx+si],al	; 00002955  0000                              
add [bx+si],al	; 00002957  0000                              
add [bx+si],al	; 00002959  0000                              
add [bx+si],al	; 0000295B  0000                              
add [bx+si],al	; 0000295D  0000                              
add [bx+si],al	; 0000295F  0000                              
add [bx+si],al	; 00002961  0000                              
add [bx+si],al	; 00002963  0000                              
add [bx+si],al	; 00002965  0000                              
add [bx+si],al	; 00002967  0000                              
add [bx+si],al	; 00002969  0000                              
add [bx+si],al	; 0000296B  0000                              
add [bx+si],al	; 0000296D  0000                              
add [bx+si],al	; 0000296F  0000                              
add [bx+si],al	; 00002971  0000                              
add [bx+si],al	; 00002973  0000                              
add [bx+si],al	; 00002975  0000                              
add [bx+si],al	; 00002977  0000                              
add [bx+si],al	; 00002979  0000                              
add [bx+si],al	; 0000297B  0000                              
add [bx+si],al	; 0000297D  0000                              
add [bx+si],al	; 0000297F  0000                              
add [bx+si],al	; 00002981  0000                              
add [bx+si],al	; 00002983  0000                              
add [bx+si],al	; 00002985  0000                              
add [bx+si],al	; 00002987  0000                              
add [bx+si],al	; 00002989  0000                              
add [bx+si],al	; 0000298B  0000                              
add [bx+si],al	; 0000298D  0000                              
add [bx+si],al	; 0000298F  0000                              
add [bx+si],al	; 00002991  0000                              
add [bx+si],al	; 00002993  0000                              
add [bx+si],al	; 00002995  0000                              
add [bx+si],al	; 00002997  0000                              
add [bx+si],al	; 00002999  0000                              
add [bx+si],al	; 0000299B  0000                              
add [bx+si],al	; 0000299D  0000                              
add [bx+si],al	; 0000299F  0000                              
add [bx+si],al	; 000029A1  0000                              
add [bx+si],al	; 000029A3  0000                              
add [bx+si],al	; 000029A5  0000                              
add [bx+si],al	; 000029A7  0000                              
add [bx+si],al	; 000029A9  0000                              
add [bx+si],al	; 000029AB  0000                              
add [bx+si],al	; 000029AD  0000                              
add [bx+si],al	; 000029AF  0000                              
add [bx+si],al	; 000029B1  0000                              
add [bx+si],al	; 000029B3  0000                              
add [bx+si],al	; 000029B5  0000                              
add [bx+si],al	; 000029B7  0000                              
add [bx+si],al	; 000029B9  0000                              
add [bx+si],al	; 000029BB  0000                              
add [bx+si],al	; 000029BD  0000                              
add [bx+si],al	; 000029BF  0000                              
add [bx+si],al	; 000029C1  0000                              
add [bx+si],al	; 000029C3  0000                              
add [bx+si],al	; 000029C5  0000                              
add [bx+si],al	; 000029C7  0000                              
add [bx+si],al	; 000029C9  0000                              
add [bx+si],al	; 000029CB  0000                              
add [bx+si],al	; 000029CD  0000                              
add [bx+si],al	; 000029CF  0000                              
add [bx+si],al	; 000029D1  0000                              
add [bx+si],al	; 000029D3  0000                              
add [bx+si],al	; 000029D5  0000                              
add [bx+si],al	; 000029D7  0000                              
add [bx+si],al	; 000029D9  0000                              
add [bx+si],al	; 000029DB  0000                              
add [bx+si],al	; 000029DD  0000                              
add [bx+si],al	; 000029DF  0000                              
add [bx+si],al	; 000029E1  0000                              
add [bx+si],al	; 000029E3  0000                              
add [bx+si],al	; 000029E5  0000                              
add [bx+si],al	; 000029E7  0000                              
add [bx+si],al	; 000029E9  0000                              
add [bx+si],al	; 000029EB  0000                              
add [bx+si],al	; 000029ED  0000                              
add [bx+si],al	; 000029EF  0000                              
add [bx+si],al	; 000029F1  0000                              
add [bx+si],al	; 000029F3  0000                              
add [bx+si],al	; 000029F5  0000                              
add [bx+si],al	; 000029F7  0000                              
add [bx+di],al	; 000029F9  0001                              
add [bx+si],al	; 000029FB  0000                              
add [bx+si],al	; 000029FD  0000                              
add [bx+si],al	; 000029FF  0000                              
add [bx+si],al	; 00002A01  0000                              
add [bx+si],al	; 00002A03  0000                              
add [bx+si],al	; 00002A05  0000                              
add [bx+si],al	; 00002A07  0000                              
add al,[bp+si]	; 00002A09  0202                              
add al,[bp+si]	; 00002A0B  0202                              
add [bx+si],al	; 00002A0D  0000                              
add ax,[bp+si]	; 00002A0F  0302                              
add al,[bp+si]	; 00002A11  0202                              
add [bx+si],al	; 00002A13  0000                              
add [bx+si],al	; 00002A15  0000                              
add [bx+di],al	; 00002A17  0001                              
add [bx+si],al	; 00002A19  0000                              
add [bx+si],al	; 00002A1B  0000                              
add [bp+si],al	; 00002A1D  0002                              
add al,[bp+si]	; 00002A1F  0202                              
add al,[bp+si]	; 00002A21  0202                              
add ax,[bp+si]	; 00002A23  0302                              
add al,[bx+si]	; 00002A25  0200                              
add al,[bx+si]	; 00002A27  0200                              
add [bp+si],al	; 00002A29  0002                              
add [bx+si],al	; 00002A2B  0000                              
add al,[bx+si]	; 00002A2D  0200                              
add [bp+si],al	; 00002A2F  0002                              
add [bx+si],al	; 00002A31  0000                              
add [bx+si],al	; 00002A33  0000                              
add [bx+di],al	; 00002A35  0001                              
add [bx+si],al	; 00002A37  0000                              
add [bx+si],al	; 00002A39  0000                              
add [bp+si],al	; 00002A3B  0002                              
add [bx+si],al	; 00002A3D  0000                              
add al,[bx+si]	; 00002A3F  0200                              
add [bx+si],al	; 00002A41  0000                              
add al,[bx+si]	; 00002A43  0200                              
add al,[bx+si]	; 00002A45  0200                              
add [bp+si],al	; 00002A47  0002                              
add al,[bp+si]	; 00002A49  0202                              
add al,[bx+si]	; 00002A4B  0200                              
add [bp+si],al	; 00002A4D  0002                              
add [bx+si],al	; 00002A4F  0000                              
add [bx+si],al	; 00002A51  0000                              
add [bx+di],al	; 00002A53  0001                              
add [bx+si],al	; 00002A55  0000                              
add [bx+si],al	; 00002A57  0000                              
add [bp+si],al	; 00002A59  0002                              
add [bx+si],al	; 00002A5B  0000                              
add al,[bx+si]	; 00002A5D  0200                              
add [bx+si],al	; 00002A5F  0000                              
add al,[bx+si]	; 00002A61  0200                              
add al,[bx+si]	; 00002A63  0200                              
add [bp+si],al	; 00002A65  0002                              
add [bx+si],al	; 00002A67  0000                              
add [bx+si],al	; 00002A69  0000                              
add [bp+si],al	; 00002A6B  0002                              
add [bx+si],al	; 00002A6D  0000                              
add [bx+si],al	; 00002A6F  0000                              
add [bx+di],al	; 00002A71  0001                              
add [bx+si],al	; 00002A73  0000                              
add [bx+si],al	; 00002A75  0000                              
add [bp+si],al	; 00002A77  0002                              
add [bx+si],al	; 00002A79  0000                              
add al,[bx+si]	; 00002A7B  0200                              
add [bx+si],al	; 00002A7D  0000                              
add al,[bx+si]	; 00002A7F  0200                              
add al,[bx+si]	; 00002A81  0200                              
add [bp+si],al	; 00002A83  0002                              
add [bx+si],al	; 00002A85  0000                              
add [bx+si],al	; 00002A87  0000                              
add [bp+si],al	; 00002A89  0002                              
add [bx+si],al	; 00002A8B  0000                              
add [bx+si],al	; 00002A8D  0000                              
add [bx+di],al	; 00002A8F  0001                              
add [bx+si],al	; 00002A91  0000                              
add [bx+si],al	; 00002A93  0000                              
add [bp+si],al	; 00002A95  0002                              
add [bx+si],al	; 00002A97  0000                              
add al,[bx+si]	; 00002A99  0200                              
add [bx+si],al	; 00002A9B  0000                              
add al,[bx+si]	; 00002A9D  0200                              
add al,[bx+si]	; 00002A9F  0200                              
add [bp+si],al	; 00002AA1  0002                              
add al,[bp+si]	; 00002AA3  0202                              
add al,[bp+si]	; 00002AA5  0202                              
add al,[bp+si]	; 00002AA7  0202                              
add al,[bp+si]	; 00002AA9  0202                              
add al,[bp+si]	; 00002AAB  0202                              
add al,[bp+si]	; 00002AAD  0202                              
add al,[bp+si]	; 00002AAF  0202                              
add al,[bp+si]	; 00002AB1  0202                              
add al,[bp+si]	; 00002AB3  0202                              
add al,[bp+si]	; 00002AB5  0202                              
add al,[bp+si]	; 00002AB7  0202                              
add al,[bp+si]	; 00002AB9  0202                              
add al,[bx+si]	; 00002ABB  0200                              
add al,[bx+si]	; 00002ABD  0200                              
add [bx+si],al	; 00002ABF  0000                              
add [bx+si],al	; 00002AC1  0000                              
add al,[bx+si]	; 00002AC3  0200                              
add [bp+si],al	; 00002AC5  0002                              
add [bx+si],al	; 00002AC7  0000                              
add [bx+si],al	; 00002AC9  0000                              
add [bx+di],al	; 00002ACB  0001                              
add [bx+si],al	; 00002ACD  0000                              
add [bx+si],al	; 00002ACF  0000                              
add [bx+si],al	; 00002AD1  0000                              
add [bx+si],al	; 00002AD3  0000                              
add al,[bx+si]	; 00002AD5  0200                              
add [bx+si],al	; 00002AD7  0000                              
add al,[bx+si]	; 00002AD9  0200                              
add al,[bx+si]	; 00002ADB  0200                              
add [bx+si],al	; 00002ADD  0000                              
add [bx+si],al	; 00002ADF  0000                              
add al,[bx+si]	; 00002AE1  0200                              
add [bp+si],al	; 00002AE3  0002                              
add [bx+si],al	; 00002AE5  0000                              
add [bx+si],al	; 00002AE7  0000                              
add [bx+di],al	; 00002AE9  0001                              
add [bx+si],al	; 00002AEB  0000                              
add [bx+si],al	; 00002AED  0000                              
add [bx+si],al	; 00002AEF  0000                              
add [bx+si],al	; 00002AF1  0000                              
add al,[bx+si]	; 00002AF3  0200                              
add [bx+si],al	; 00002AF5  0000                              
add al,[bx+si]	; 00002AF7  0200                              
add al,[bx+si]	; 00002AF9  0200                              
add [bp+si],al	; 00002AFB  0002                              
add al,[bp+si]	; 00002AFD  0202                              
add al,[bx+si]	; 00002AFF  0200                              
add [bp+si],al	; 00002B01  0002                              
add [bx+di],ax	; 00002B03  0101                              
add [bx+di],ax	; 00002B05  0101                              
add [bx+di],ax	; 00002B07  0101                              
add [bx+di],ax	; 00002B09  0101                              
add [bx+si],ax	; 00002B0B  0100                              
add [bp+si],al	; 00002B0D  0002                              
add al,[bp+si]	; 00002B0F  0202                              
add al,[bx+si]	; 00002B11  0200                              
add [bx+si],al	; 00002B13  0000                              
add al,[bx+si]	; 00002B15  0200                              
add al,[bx+si]	; 00002B17  0200                              
add [bp+si],al	; 00002B19  0002                              
add [bx+si],al	; 00002B1B  0000                              
add al,[bx+si]	; 00002B1D  0200                              
add [bp+si],al	; 00002B1F  0002                              
add [bx+si],al	; 00002B21  0000                              
add [bx+si],ax	; 00002B23  0100                              
add [bx+si],al	; 00002B25  0000                              
add [bx+si],al	; 00002B27  0000                              
add [bx+si],ax	; 00002B29  0100                              
add [bp+si],al	; 00002B2B  0002                              
add [bx+si],al	; 00002B2D  0000                              
add al,[bx+si]	; 00002B2F  0200                              
add [bx+si],al	; 00002B31  0000                              
add al,[bx+si]	; 00002B33  0200                              
add al,[bp+si]	; 00002B35  0202                              
add al,[bp+si]	; 00002B37  0202                              
add [bx+si],al	; 00002B39  0000                              
add al,[bp+si]	; 00002B3B  0202                              
add al,[bp+si]	; 00002B3D  0202                              
add [bx+si],al	; 00002B3F  0000                              
add [bx+si],ax	; 00002B41  0100                              
add [bx+si],al	; 00002B43  0000                              
add [bx+si],al	; 00002B45  0000                              
add [bx+di],ax	; 00002B47  0101                              
add [bp+si],ax	; 00002B49  0102                              
add [bx+si],al	; 00002B4B  0000                              
add al,[bp+si]	; 00002B4D  0202                              
add al,[bp+si]	; 00002B4F  0202                              
add al,[bx+si]	; 00002B51  0200                              
add al,[bx+si]	; 00002B53  0200                              
add [bx+si],al	; 00002B55  0000                              
add [bx+si],al	; 00002B57  0000                              
add [bx+si],ax	; 00002B59  0100                              
add [bx+si],al	; 00002B5B  0000                              
add [bx+si],al	; 00002B5D  0000                              
add [bx+si],ax	; 00002B5F  0100                              
add [bx+si],al	; 00002B61  0000                              
add [bx+si],al	; 00002B63  0000                              
add [bx+si],ax	; 00002B65  0100                              
add [bx+si],al	; 00002B67  0000                              
add [bx+si],al	; 00002B69  0000                              
add al,[bx+si]	; 00002B6B  0200                              
add [bx+si],al	; 00002B6D  0000                              
add [bx+si],al	; 00002B6F  0000                              
add al,[bx+si]	; 00002B71  0200                              
add [bx+si],al	; 00002B73  0000                              
add [bx+si],al	; 00002B75  0000                              
add [bx+si],ax	; 00002B77  0100                              
add [bx+si],al	; 00002B79  0000                              
add [bx+si],al	; 00002B7B  0000                              
add [bx+si],ax	; 00002B7D  0100                              
add [bx+si],al	; 00002B7F  0000                              
add [bx+si],al	; 00002B81  0000                              
add [bx+si],ax	; 00002B83  0100                              
add [bx+si],al	; 00002B85  0000                              
add [bx+si],al	; 00002B87  0000                              
add al,[bx+si]	; 00002B89  0200                              
add [bx+si],al	; 00002B8B  0000                              
add [bx+si],al	; 00002B8D  0000                              
add al,[bp+si]	; 00002B8F  0202                              
add al,[bp+si]	; 00002B91  0202                              
add [bx+si],al	; 00002B93  0000                              
add al,[bp+si]	; 00002B95  0202                              
add al,[bp+si]	; 00002B97  0202                              
add [bx+si],al	; 00002B99  0000                              
add [bx+si],ax	; 00002B9B  0100                              
add [bx+si],al	; 00002B9D  0000                              
add [bx+si],al	; 00002B9F  0000                              
add [bx+di],ax	; 00002BA1  0101                              
add [bp+si],ax	; 00002BA3  0102                              
add [bx+si],al	; 00002BA5  0000                              
add al,[bp+si]	; 00002BA7  0202                              
add al,[bp+si]	; 00002BA9  0202                              
add al,[bx+si]	; 00002BAB  0200                              
add al,[bx+si]	; 00002BAD  0200                              
add [bp+si],al	; 00002BAF  0002                              
add [bx+si],al	; 00002BB1  0000                              
add al,[bx+si]	; 00002BB3  0200                              
add [bp+si],al	; 00002BB5  0002                              
add [bx+si],al	; 00002BB7  0000                              
add [bx+si],ax	; 00002BB9  0100                              
add [bx+si],al	; 00002BBB  0000                              
add [bx+si],al	; 00002BBD  0000                              
add [bx+si],ax	; 00002BBF  0100                              
add [bp+si],al	; 00002BC1  0002                              
add [bx+si],al	; 00002BC3  0000                              
add al,[bx+si]	; 00002BC5  0200                              
add [bx+si],al	; 00002BC7  0000                              
add al,[bx+si]	; 00002BC9  0200                              
add al,[bx+si]	; 00002BCB  0200                              
add [bp+si],al	; 00002BCD  0002                              
add al,[bp+si]	; 00002BCF  0202                              
add al,[bx+si]	; 00002BD1  0200                              
add [bp+si],al	; 00002BD3  0002                              
add [bx+di],ax	; 00002BD5  0101                              
add [bx+di],ax	; 00002BD7  0101                              
add [bx+di],ax	; 00002BD9  0101                              
add [bx+di],ax	; 00002BDB  0101                              
add [bx+si],ax	; 00002BDD  0100                              
add [bp+si],al	; 00002BDF  0002                              
add al,[bp+si]	; 00002BE1  0202                              
add al,[bx+si]	; 00002BE3  0200                              
add [bx+si],al	; 00002BE5  0000                              
add al,[bx+si]	; 00002BE7  0200                              
add al,[bx+si]	; 00002BE9  0200                              
add [bx+si],al	; 00002BEB  0000                              
add [bx+si],al	; 00002BED  0000                              
add al,[bx+si]	; 00002BEF  0200                              
add [bp+si],al	; 00002BF1  0002                              
add [bx+si],al	; 00002BF3  0000                              
add [bx+si],al	; 00002BF5  0000                              
add [bx+di],al	; 00002BF7  0001                              
add [bx+si],al	; 00002BF9  0000                              
add [bx+si],al	; 00002BFB  0000                              
add [bx+si],al	; 00002BFD  0000                              
add [bx+si],al	; 00002BFF  0000                              
add al,[bx+si]	; 00002C01  0200                              
add [bx+si],al	; 00002C03  0000                              
add al,[bx+si]	; 00002C05  0200                              
add al,[bx+si]	; 00002C07  0200                              
add [bx+si],al	; 00002C09  0000                              
add [bx+si],al	; 00002C0B  0000                              
add al,[bx+si]	; 00002C0D  0200                              
add [bp+si],al	; 00002C0F  0002                              
add [bx+si],al	; 00002C11  0000                              
add [bx+si],al	; 00002C13  0000                              
add [bx+di],al	; 00002C15  0001                              
add [bx+si],al	; 00002C17  0000                              
add [bx+si],al	; 00002C19  0000                              
add [bx+si],al	; 00002C1B  0000                              
add [bx+si],al	; 00002C1D  0000                              
add al,[bx+si]	; 00002C1F  0200                              
add [bx+si],al	; 00002C21  0000                              
add al,[bx+si]	; 00002C23  0200                              
add al,[bx+si]	; 00002C25  0200                              
add [bp+si],al	; 00002C27  0002                              
add al,[bp+si]	; 00002C29  0202                              
add al,[bp+si]	; 00002C2B  0202                              
add al,[bp+si]	; 00002C2D  0202                              
add al,[bp+si]	; 00002C2F  0202                              
add al,[bp+si]	; 00002C31  0202                              
add al,[bp+si]	; 00002C33  0202                              
add al,[bp+si]	; 00002C35  0202                              
add al,[bp+si]	; 00002C37  0202                              
add al,[bp+si]	; 00002C39  0202                              
add al,[bp+si]	; 00002C3B  0202                              
add al,[bp+si]	; 00002C3D  0202                              
add al,[bp+si]	; 00002C3F  0202                              
add al,[bx+si]	; 00002C41  0200                              
add al,[bx+si]	; 00002C43  0200                              
add [bp+si],al	; 00002C45  0002                              
add [bx+si],al	; 00002C47  0000                              
add [bx+si],al	; 00002C49  0000                              
add [bp+si],al	; 00002C4B  0002                              
add [bx+si],al	; 00002C4D  0000                              
add [bx+si],al	; 00002C4F  0000                              
add [bx+di],al	; 00002C51  0001                              
add [bx+si],al	; 00002C53  0000                              
add [bx+si],al	; 00002C55  0000                              
add [bp+si],al	; 00002C57  0002                              
add [bx+si],al	; 00002C59  0000                              
add al,[bx+si]	; 00002C5B  0200                              
add [bx+si],al	; 00002C5D  0000                              
add al,[bx+si]	; 00002C5F  0200                              
add al,[bx+si]	; 00002C61  0200                              
add [bp+si],al	; 00002C63  0002                              
add [bx+si],al	; 00002C65  0000                              
add [bx+si],al	; 00002C67  0000                              
add [bp+si],al	; 00002C69  0002                              
add [bx+si],al	; 00002C6B  0000                              
add [bx+si],al	; 00002C6D  0000                              
add [bx+di],al	; 00002C6F  0001                              
add [bx+si],al	; 00002C71  0000                              
add [bx+si],al	; 00002C73  0000                              
add [bp+si],al	; 00002C75  0002                              
add [bx+si],al	; 00002C77  0000                              
add al,[bx+si]	; 00002C79  0200                              
add [bx+si],al	; 00002C7B  0000                              
add al,[bx+si]	; 00002C7D  0200                              
add al,[bx+si]	; 00002C7F  0200                              
add [bp+si],al	; 00002C81  0002                              
add al,[bp+si]	; 00002C83  0202                              
add al,[bx+si]	; 00002C85  0200                              
add [bp+si],al	; 00002C87  0002                              
add [bx+si],al	; 00002C89  0000                              
add [bx+si],al	; 00002C8B  0000                              
add [bx+di],al	; 00002C8D  0001                              
add [bx+si],al	; 00002C8F  0000                              
add [bx+si],al	; 00002C91  0000                              
add [bp+si],al	; 00002C93  0002                              
add [bx+si],al	; 00002C95  0000                              
add al,[bx+si]	; 00002C97  0200                              
add [bx+si],al	; 00002C99  0000                              
add al,[bx+si]	; 00002C9B  0200                              
add al,[bx+si]	; 00002C9D  0200                              
add [bp+si],al	; 00002C9F  0002                              
add [bx+si],al	; 00002CA1  0000                              
add al,[bx+si]	; 00002CA3  0200                              
add [bp+si],al	; 00002CA5  0002                              
add [bx+si],al	; 00002CA7  0000                              
add [bx+si],al	; 00002CA9  0000                              
add [bx+di],al	; 00002CAB  0001                              
add [bx+si],al	; 00002CAD  0000                              
add [bx+si],al	; 00002CAF  0000                              
add [bp+si],al	; 00002CB1  0002                              
add [bx+si],al	; 00002CB3  0000                              
add al,[bx+si]	; 00002CB5  0200                              
add [bx+si],al	; 00002CB7  0000                              
add al,[bx+si]	; 00002CB9  0200                              
add al,[bp+si]	; 00002CBB  0202                              
add al,[bp+si]	; 00002CBD  0202                              
add [bx+si],al	; 00002CBF  0000                              
add ax,[bp+si]	; 00002CC1  0302                              
add al,[bp+si]	; 00002CC3  0202                              
add [bx+si],al	; 00002CC5  0000                              
add [bx+si],al	; 00002CC7  0000                              
add [bx+di],al	; 00002CC9  0001                              
add [bx+si],al	; 00002CCB  0000                              
add [bx+si],al	; 00002CCD  0000                              
add [bp+si],al	; 00002CCF  0002                              
add al,[bp+si]	; 00002CD1  0202                              
add al,[bp+si]	; 00002CD3  0202                              
add ax,[bp+si]	; 00002CD5  0302                              
add al,[bx+si]	; 00002CD7  0200                              
add [bx+si],al	; 00002CD9  0000                              
add [bx+si],al	; 00002CDB  0000                              
add [bx+si],al	; 00002CDD  0000                              
add [bx+si],al	; 00002CDF  0000                              
add [bx+si],al	; 00002CE1  0000                              
add [bx+si],al	; 00002CE3  0000                              
add [bx+si],al	; 00002CE5  0000                              
add [bx+di],al	; 00002CE7  0001                              
add [bx+si],al	; 00002CE9  0000                              
add [bx+si],al	; 00002CEB  0000                              
add [bx+si],al	; 00002CED  0000                              
add [bx+si],al	; 00002CEF  0000                              
add [bx+si],al	; 00002CF1  0000                              
add [bx+si],al	; 00002CF3  0000                              
add [bx+si],al	; 00002CF5  0000                              
add [bx+si],al	; 00002CF7  0000                              
add [bx+si],al	; 00002CF9  0000                              
add [bx+si],al	; 00002CFB  0000                              
add [bx+si],al	; 00002CFD  0000                              
add [bx+si],al	; 00002CFF  0000                              
add [bx+si],al	; 00002D01  0000                              
add [bx+si],al	; 00002D03  0000                              
add [bx+di],al	; 00002D05  0001                              
add [bx+si],al	; 00002D07  0000                              
add [bx+si],al	; 00002D09  0000                              
add [bx+si],al	; 00002D0B  0000                              
add [bx+si],al	; 00002D0D  0000                              
add [bx+si],al	; 00002D0F  0000                              
add [bx+si],al	; 00002D11  0000                              
add [bx+si],al	; 00002D13  0000                              
add [bx+si],al	; 00002D15  0000                              
add [bx+si],al	; 00002D17  0000                              
add [bx+si],al	; 00002D19  0000                              
add [bx+si],al	; 00002D1B  0000                              
add [bx+si],al	; 00002D1D  0000                              
add [bx+si],al	; 00002D1F  0000                              
add [bx+si],al	; 00002D21  0000                              
add [bx+di],al	; 00002D23  0001                              
add [bx+si],al	; 00002D25  0000                              
add [bx+si],al	; 00002D27  0000                              
add [bx+si],al	; 00002D29  0000                              
add [bx+si],al	; 00002D2B  0000                              
add [bx+si],al	; 00002D2D  0000                              
add [bx+si],al	; 00002D2F  0000                              
add [bx+si],al	; 00002D31  0000                              
add [bx+si],al	; 00002D33  0000                              
add [bx+si],al	; 00002D35  0000                              
add [bx+si],al	; 00002D37  0000                              
add [bx+si],al	; 00002D39  0000                              
add [bx+si],al	; 00002D3B  0000                              
add [bx+si],al	; 00002D3D  0000                              
add [bx+si],al	; 00002D3F  0000                              
add [bx+di],al	; 00002D41  0001                              
add [bx+si],al	; 00002D43  0000                              
add [bx+si],al	; 00002D45  0000                              
add [bx+si],al	; 00002D47  0000                              
add [bx+si],al	; 00002D49  0000                              
add [bx+si],al	; 00002D4B  0000                              
add [bx+si],al	; 00002D4D  0000                              
add [bx+si],al	; 00002D4F  0000                              
add [bx+si],al	; 00002D51  0000                              
add [bx+si],al	; 00002D53  0000                              
add [bx+si],al	; 00002D55  0000                              
add [bx+si],al	; 00002D57  0000                              
add [bx+si],al	; 00002D59  0000                              
add [bx+si],al	; 00002D5B  0000                              
add [bx+si],al	; 00002D5D  0000                              
add [bx+di],al	; 00002D5F  0001                              
add [bx+si],al	; 00002D61  0000                              
add [bx+si],al	; 00002D63  0000                              
add [bx+si],al	; 00002D65  0000                              
add [bx+si],al	; 00002D67  0000                              
add [bx+si],al	; 00002D69  0000                              
add [bx+si],al	; 00002D6B  0000                              
add [bx+si],al	; 00002D6D  0000                              
add [bx+si],al	; 00002D6F  0000                              
sldt word [bx+si]	; 00002D71  0F0000                            
cmp al,0xf	; 00002D74  3C0F                              
rol byte [bx+si],byte 0xfc	; 00002D76  C000FC                            
db 0x0f	; 00002D79  0F                                
lock	; 00002D7A  F0                                
add di,sp	; 00002D7B  03FC                              
paddb mm1,[bx]	; 00002D7D  0FFC0F                            
cld	; 00002D80  FC                                
ud0 di,[bx]	; 00002D81  0FFF3F                            
cld	; 00002D84  FC                                
add di,di	; 00002D85  03FF                              
push ax	; 00002D87  FFF0                              
add di,di	; 00002D89  03FF                              
push ax	; 00002D8B  FFF0                              
add bh,bh	; 00002D8D  00FF                              
inc ax	; 00002D8F  FFC0                              
add [bx],cl	; 00002D91  000F                              
cld	; 00002D93  FC                                
add [bx+si],al	; 00002D94  0000                              
add [bx+si],al	; 00002D96  0000                              
add [bx+si],al	; 00002D98  0000                              
add [bx+si],al	; 00002D9A  0000                              
add [bx+si],al	; 00002D9C  0000                              
rol byte [bx+si],byte 0xc0	; 00002D9E  C000C0                            
add ax,ax	; 00002DA1  03C0                              
add al,dh	; 00002DA3  00F0                              
add si,ax	; 00002DA5  03F0                              
add si,ax	; 00002DA7  03F0                              
db 0x0f	; 00002DA9  0F                                
lock	; 00002DAA  F0                                
add di,sp	; 00002DAB  03FC                              
paddb mm1,[bx]	; 00002DAD  0FFC0F                            
cld	; 00002DB0  FC                                
paddb mm1,[bx]	; 00002DB1  0FFC0F                            
cld	; 00002DB4  FC                                
ud0 di,[bx]	; 00002DB5  0FFF3F                            
cld	; 00002DB8  FC                                
ud0 di,[bx]	; 00002DB9  0FFF3F                            
cld	; 00002DBC  FC                                
add di,di	; 00002DBD  03FF                              
push ax	; 00002DBF  FFF0                              
add di,di	; 00002DC1  03FF                              
push ax	; 00002DC3  FFF0                              
add bh,bh	; 00002DC5  00FF                              
inc ax	; 00002DC7  FFC0                              
add [bx],cl	; 00002DC9  000F                              
cld	; 00002DCB  FC                                
add [bx+si],al	; 00002DCC  0000                              
add [bx+si],al	; 00002DCE  0000                              
add [bx+si],al	; 00002DD0  0000                              
paddb mm0,[bx+si]	; 00002DD2  0FFC00                            
add bh,bh	; 00002DD5  00FF                              
inc ax	; 00002DD7  FFC0                              
add di,di	; 00002DD9  03FF                              
push ax	; 00002DDB  FFF0                              
add di,di	; 00002DDD  03FF                              
push ax	; 00002DDF  FFF0                              
ud0 di,di	; 00002DE1  0FFFFF                            
cld	; 00002DE4  FC                                
ud0 di,di	; 00002DE5  0FFFFF                            
cld	; 00002DE8  FC                                
ud0 di,di	; 00002DE9  0FFFFF                            
cld	; 00002DEC  FC                                
ud0 di,di	; 00002DED  0FFFFF                            
cld	; 00002DF0  FC                                
ud0 di,di	; 00002DF1  0FFFFF                            
cld	; 00002DF4  FC                                
add di,di	; 00002DF5  03FF                              
push ax	; 00002DF7  FFF0                              
add di,di	; 00002DF9  03FF                              
push ax	; 00002DFB  FFF0                              
add bh,bh	; 00002DFD  00FF                              
inc ax	; 00002DFF  FFC0                              
add [bx],cl	; 00002E01  000F                              
cld	; 00002E03  FC                                
add [bx+si],al	; 00002E04  0000                              
add [bx+si],al	; 00002E06  0000                              
add [bx+si],al	; 00002E08  0000                              
add [bx+si],al	; 00002E0A  0000                              
add [bx+si],al	; 00002E0C  0000                              
rol byte [bx+si],byte 0xc0	; 00002E0E  C000C0                            
add ax,ax	; 00002E11  03C0                              
add al,dh	; 00002E13  00F0                              
add si,ax	; 00002E15  03F0                              
add si,ax	; 00002E17  03F0                              
db 0x0f	; 00002E19  0F                                
lock	; 00002E1A  F0                                
add di,sp	; 00002E1B  03FC                              
paddb mm1,[bx]	; 00002E1D  0FFC0F                            
cld	; 00002E20  FC                                
paddb mm1,[bx]	; 00002E21  0FFC0F                            
cld	; 00002E24  FC                                
ud0 di,[bx]	; 00002E25  0FFF3F                            
cld	; 00002E28  FC                                
ud0 di,[bx]	; 00002E29  0FFF3F                            
cld	; 00002E2C  FC                                
add di,di	; 00002E2D  03FF                              
push ax	; 00002E2F  FFF0                              
add di,di	; 00002E31  03FF                              
push ax	; 00002E33  FFF0                              
add bh,bh	; 00002E35  00FF                              
inc ax	; 00002E37  FFC0                              
add [bx],cl	; 00002E39  000F                              
cld	; 00002E3B  FC                                
add [bx+si],al	; 00002E3C  0000                              
add [bx+si],al	; 00002E3E  0000                              
add [bx+si],al	; 00002E40  0000                              
paddb mm0,[bx+si]	; 00002E42  0FFC00                            
add bh,bh	; 00002E45  00FF                              
inc ax	; 00002E47  FFC0                              
add di,di	; 00002E49  03FF                              
push ax	; 00002E4B  FFF0                              
add di,di	; 00002E4D  03FF                              
push ax	; 00002E4F  FFF0                              
ud0 di,[bx]	; 00002E51  0FFF3F                            
cld	; 00002E54  FC                                
paddb mm1,[bx]	; 00002E55  0FFC0F                            
cld	; 00002E58  FC                                
db 0x0f	; 00002E59  0F                                
lock	; 00002E5A  F0                                
add di,sp	; 00002E5B  03FC                              
xadd [bx+si],al	; 00002E5D  0FC000                            
cld	; 00002E60  FC                                
sldt word [bx+si]	; 00002E61  0F0000                            
cmp al,0x0	; 00002E64  3C00                              
add [bx+si],al	; 00002E66  0000                              
add [bx+si],al	; 00002E68  0000                              
add [bx+si],al	; 00002E6A  0000                              
add [bx+si],al	; 00002E6C  0000                              
add [bx+si],al	; 00002E6E  0000                              
add [bx+si],al	; 00002E70  0000                              
add [bx+si],al	; 00002E72  0000                              
add [bx+si],al	; 00002E74  0000                              
add [bx+si],al	; 00002E76  0000                              
add [bx+si],al	; 00002E78  0000                              
paddb mm0,[bx+si]	; 00002E7A  0FFC00                            
add bh,bh	; 00002E7D  00FF                              
inc ax	; 00002E7F  FFC0                              
add di,di	; 00002E81  03FF                              
push ax	; 00002E83  FFF0                              
add di,di	; 00002E85  03FF                              
push ax	; 00002E87  FFF0                              
ud0 di,[bx]	; 00002E89  0FFF3F                            
cld	; 00002E8C  FC                                
ud0 di,[bx]	; 00002E8D  0FFF3F                            
cld	; 00002E90  FC                                
paddb mm1,[bx]	; 00002E91  0FFC0F                            
cld	; 00002E94  FC                                
paddb mm1,[bx]	; 00002E95  0FFC0F                            
cld	; 00002E98  FC                                
db 0x0f	; 00002E99  0F                                
lock	; 00002E9A  F0                                
add di,sp	; 00002E9B  03FC                              
add si,ax	; 00002E9D  03F0                              
add si,ax	; 00002E9F  03F0                              
add ax,ax	; 00002EA1  03C0                              
add al,dh	; 00002EA3  00F0                              
add al,al	; 00002EA5  00C0                              
add al,al	; 00002EA7  00C0                              
add [bx+si],al	; 00002EA9  0000                              
add [bx+si],al	; 00002EAB  0000                              
add [bx+si],al	; 00002EAD  0000                              
add [bx+si],al	; 00002EAF  0000                              
add [bx],cl	; 00002EB1  000F                              
cld	; 00002EB3  FC                                
add [bx+si],al	; 00002EB4  0000                              
db 0xff	; 00002EB6  FF                                
inc ax	; 00002EB7  FFC0                              
add di,di	; 00002EB9  03FF                              
push ax	; 00002EBB  FFF0                              
add di,di	; 00002EBD  03FF                              
push ax	; 00002EBF  FFF0                              
ud0 di,di	; 00002EC1  0FFFFF                            
cld	; 00002EC4  FC                                
ud0 di,di	; 00002EC5  0FFFFF                            
cld	; 00002EC8  FC                                
ud0 di,di	; 00002EC9  0FFFFF                            
cld	; 00002ECC  FC                                
ud0 di,di	; 00002ECD  0FFFFF                            
cld	; 00002ED0  FC                                
ud0 di,di	; 00002ED1  0FFFFF                            
cld	; 00002ED4  FC                                
add di,di	; 00002ED5  03FF                              
push ax	; 00002ED7  FFF0                              
add di,di	; 00002ED9  03FF                              
push ax	; 00002EDB  FFF0                              
add bh,bh	; 00002EDD  00FF                              
inc ax	; 00002EDF  FFC0                              
add [bx],cl	; 00002EE1  000F                              
cld	; 00002EE3  FC                                
add [bx+si],al	; 00002EE4  0000                              
add [bx+si],al	; 00002EE6  0000                              
add [bx+si],al	; 00002EE8  0000                              
paddb mm0,[bx+si]	; 00002EEA  0FFC00                            
add bh,bh	; 00002EED  00FF                              
inc ax	; 00002EEF  FFC0                              
add di,di	; 00002EF1  03FF                              
push ax	; 00002EF3  FFF0                              
add di,di	; 00002EF5  03FF                              
push ax	; 00002EF7  FFF0                              
ud0 di,[bx]	; 00002EF9  0FFF3F                            
cld	; 00002EFC  FC                                
ud0 di,[bx]	; 00002EFD  0FFF3F                            
cld	; 00002F00  FC                                
paddb mm1,[bx]	; 00002F01  0FFC0F                            
cld	; 00002F04  FC                                
paddb mm1,[bx]	; 00002F05  0FFC0F                            
cld	; 00002F08  FC                                
db 0x0f	; 00002F09  0F                                
lock	; 00002F0A  F0                                
add di,sp	; 00002F0B  03FC                              
add si,ax	; 00002F0D  03F0                              
add si,ax	; 00002F0F  03F0                              
add ax,ax	; 00002F11  03C0                              
add al,dh	; 00002F13  00F0                              
add al,al	; 00002F15  00C0                              
add al,al	; 00002F17  00C0                              
add [bx+si],al	; 00002F19  0000                              
add [bx+si],al	; 00002F1B  0000                              
add [bx+si],al	; 00002F1D  0000                              
add [bx+si],al	; 00002F1F  0000                              
add [bx],cl	; 00002F21  000F                              
cld	; 00002F23  FC                                
add [bx+si],al	; 00002F24  0000                              
ud0 ax,ax	; 00002F26  0FFFC0                            
add [bp+di],al	; 00002F29  0003                              
push ax	; 00002F2B  FFF0                              
add [bx+si],al	; 00002F2D  0000                              
push ax	; 00002F2F  FFF0                              
add [bx+si],al	; 00002F31  0000                              
aas	; 00002F33  3F                                
cld	; 00002F34  FC                                
add [bx+si],al	; 00002F35  0000                              
paddb mm0,[bx+si]	; 00002F37  0FFC00                            
add [bp+di],al	; 00002F3A  0003                              
cld	; 00002F3C  FC                                
add [bx+si],al	; 00002F3D  0000                              
paddb mm0,[bx+si]	; 00002F3F  0FFC00                            
add [bx],bh	; 00002F42  003F                              
cld	; 00002F44  FC                                
add [bx+si],al	; 00002F45  0000                              
push ax	; 00002F47  FFF0                              
add [bp+di],al	; 00002F49  0003                              
push ax	; 00002F4B  FFF0                              
add [bx],cl	; 00002F4D  000F                              
inc ax	; 00002F4F  FFC0                              
add [bx],cl	; 00002F51  000F                              
cld	; 00002F53  FC                                
add [bx+si],al	; 00002F54  0000                              
add [bx+si],al	; 00002F56  0000                              
add [bx+si],al	; 00002F58  0000                              
paddb mm0,[bx+si]	; 00002F5A  0FFC00                            
add bh,bh	; 00002F5D  00FF                              
inc ax	; 00002F5F  FFC0                              
add di,di	; 00002F61  03FF                              
push ax	; 00002F63  FFF0                              
add [bx],bh	; 00002F65  003F                              
push ax	; 00002F67  FFF0                              
add [bp+di],al	; 00002F69  0003                              
db 0xff	; 00002F6B  FF                                
cld	; 00002F6C  FC                                
add [bx+si],al	; 00002F6D  0000                              
aas	; 00002F6F  3F                                
cld	; 00002F70  FC                                
add [bx+si],al	; 00002F71  0000                              
add di,sp	; 00002F73  03FC                              
add [bx+si],al	; 00002F75  0000                              
aas	; 00002F77  3F                                
cld	; 00002F78  FC                                
add [bp+di],al	; 00002F79  0003                              
db 0xff	; 00002F7B  FF                                
cld	; 00002F7C  FC                                
add [bx],bh	; 00002F7D  003F                              
push ax	; 00002F7F  FFF0                              
add di,di	; 00002F81  03FF                              
push ax	; 00002F83  FFF0                              
add bh,bh	; 00002F85  00FF                              
inc ax	; 00002F87  FFC0                              
add [bx],cl	; 00002F89  000F                              
cld	; 00002F8B  FC                                
add [bx+si],al	; 00002F8C  0000                              
add [bx+si],al	; 00002F8E  0000                              
add [bx+si],al	; 00002F90  0000                              
paddb mm0,[bx+si]	; 00002F92  0FFC00                            
add bh,bh	; 00002F95  00FF                              
inc ax	; 00002F97  FFC0                              
add di,di	; 00002F99  03FF                              
push ax	; 00002F9B  FFF0                              
add di,di	; 00002F9D  03FF                              
push ax	; 00002F9F  FFF0                              
ud0 di,di	; 00002FA1  0FFFFF                            
cld	; 00002FA4  FC                                
ud0 di,di	; 00002FA5  0FFFFF                            
cld	; 00002FA8  FC                                
ud0 di,di	; 00002FA9  0FFFFF                            
cld	; 00002FAC  FC                                
ud0 di,di	; 00002FAD  0FFFFF                            
cld	; 00002FB0  FC                                
ud0 di,di	; 00002FB1  0FFFFF                            
cld	; 00002FB4  FC                                
add di,di	; 00002FB5  03FF                              
push ax	; 00002FB7  FFF0                              
add di,di	; 00002FB9  03FF                              
push ax	; 00002FBB  FFF0                              
add bh,bh	; 00002FBD  00FF                              
inc ax	; 00002FBF  FFC0                              
add [bx],cl	; 00002FC1  000F                              
cld	; 00002FC3  FC                                
add [bx+si],al	; 00002FC4  0000                              
add [bx+si],al	; 00002FC6  0000                              
add [bx+si],al	; 00002FC8  0000                              
paddb mm0,[bx+si]	; 00002FCA  0FFC00                            
add bh,bh	; 00002FCD  00FF                              
inc ax	; 00002FCF  FFC0                              
add di,di	; 00002FD1  03FF                              
push ax	; 00002FD3  FFF0                              
add [bx],bh	; 00002FD5  003F                              
push ax	; 00002FD7  FFF0                              
add [bp+di],al	; 00002FD9  0003                              
db 0xff	; 00002FDB  FF                                
cld	; 00002FDC  FC                                
add [bx+si],al	; 00002FDD  0000                              
aas	; 00002FDF  3F                                
cld	; 00002FE0  FC                                
add [bx+si],al	; 00002FE1  0000                              
add di,sp	; 00002FE3  03FC                              
add [bx+si],al	; 00002FE5  0000                              
aas	; 00002FE7  3F                                
cld	; 00002FE8  FC                                
add [bp+di],al	; 00002FE9  0003                              
db 0xff	; 00002FEB  FF                                
cld	; 00002FEC  FC                                
add [bx],bh	; 00002FED  003F                              
push ax	; 00002FEF  FFF0                              
add di,di	; 00002FF1  03FF                              
push ax	; 00002FF3  FFF0                              
add bh,bh	; 00002FF5  00FF                              
inc ax	; 00002FF7  FFC0                              
add [bx],cl	; 00002FF9  000F                              
cld	; 00002FFB  FC                                
add [bx+si],al	; 00002FFC  0000                              
add [bx+si],al	; 00002FFE  0000                              
add [bx+si],al	; 00003000  0000                              
paddb mm0,[bx+si]	; 00003002  0FFC00                            
add bh,bh	; 00003005  00FF                              
cld	; 00003007  FC                                
add [bp+di],al	; 00003008  0003                              
push ax	; 0000300A  FFF0                              
add [bp+di],al	; 0000300C  0003                              
inc ax	; 0000300E  FFC0                              
add [bx],cl	; 00003010  000F                              
inc word [bx+si]	; 00003012  FF00                              
add [bx],cl	; 00003014  000F                              
cld	; 00003016  FC                                
add [bx+si],al	; 00003017  0000                              
db 0x0f	; 00003019  0F                                
lock add [bx+si],al	; 0000301A  F00000                            
paddb mm0,[bx+si]	; 0000301D  0FFC00                            
add [bx],cl	; 00003020  000F                              
inc word [bx+si]	; 00003022  FF00                              
add [bp+di],al	; 00003024  0003                              
inc ax	; 00003026  FFC0                              
add [bp+di],al	; 00003028  0003                              
push ax	; 0000302A  FFF0                              
add [bx+si],al	; 0000302C  0000                              
db 0xff	; 0000302E  FF                                
cld	; 0000302F  FC                                
add [bx+si],al	; 00003030  0000                              
paddb mm0,[bx+si]	; 00003032  0FFC00                            
add [bx+si],al	; 00003035  0000                              
add [bx+si],al	; 00003037  0000                              
add [bx],cl	; 00003039  000F                              
cld	; 0000303B  FC                                
add [bx+si],al	; 0000303C  0000                              
db 0xff	; 0000303E  FF                                
inc ax	; 0000303F  FFC0                              
add di,di	; 00003041  03FF                              
push ax	; 00003043  FFF0                              
add di,di	; 00003045  03FF                              
inc word [bx+si]	; 00003047  FF00                              
ud0 si,ax	; 00003049  0FFFF0                            
add [bx],cl	; 0000304C  000F                              
inc word [bx+si]	; 0000304E  FF00                              
add [bx],cl	; 00003050  000F                              
lock add [bx+si],al	; 00003052  F00000                            
ud0 ax,[bx+si]	; 00003055  0FFF00                            
add [bx],cl	; 00003058  000F                              
push ax	; 0000305A  FFF0                              
add [bp+di],al	; 0000305C  0003                              
db 0xff	; 0000305E  FF                                
inc word [bx+si]	; 0000305F  FF00                              
add di,di	; 00003061  03FF                              
push ax	; 00003063  FFF0                              
add bh,bh	; 00003065  00FF                              
inc ax	; 00003067  FFC0                              
add [bx],cl	; 00003069  000F                              
cld	; 0000306B  FC                                
add [bx+si],al	; 0000306C  0000                              
add [bx+si],al	; 0000306E  0000                              
add [bx+si],al	; 00003070  0000                              
paddb mm0,[bx+si]	; 00003072  0FFC00                            
add bh,bh	; 00003075  00FF                              
inc ax	; 00003077  FFC0                              
add di,di	; 00003079  03FF                              
push ax	; 0000307B  FFF0                              
add di,di	; 0000307D  03FF                              
push ax	; 0000307F  FFF0                              
ud0 di,di	; 00003081  0FFFFF                            
cld	; 00003084  FC                                
ud0 di,di	; 00003085  0FFFFF                            
cld	; 00003088  FC                                
ud0 di,di	; 00003089  0FFFFF                            
cld	; 0000308C  FC                                
ud0 di,di	; 0000308D  0FFFFF                            
cld	; 00003090  FC                                
ud0 di,di	; 00003091  0FFFFF                            
cld	; 00003094  FC                                
add di,di	; 00003095  03FF                              
push ax	; 00003097  FFF0                              
add di,di	; 00003099  03FF                              
push ax	; 0000309B  FFF0                              
add bh,bh	; 0000309D  00FF                              
inc ax	; 0000309F  FFC0                              
add [bx],cl	; 000030A1  000F                              
cld	; 000030A3  FC                                
add [bx+si],al	; 000030A4  0000                              
add [bx+si],al	; 000030A6  0000                              
add [bx+si],al	; 000030A8  0000                              
paddb mm0,[bx+si]	; 000030AA  0FFC00                            
add bh,bh	; 000030AD  00FF                              
inc ax	; 000030AF  FFC0                              
add di,di	; 000030B1  03FF                              
push ax	; 000030B3  FFF0                              
add di,di	; 000030B5  03FF                              
inc word [bx+si]	; 000030B7  FF00                              
ud0 si,ax	; 000030B9  0FFFF0                            
add [bx],cl	; 000030BC  000F                              
inc word [bx+si]	; 000030BE  FF00                              
add [bx],cl	; 000030C0  000F                              
lock add [bx+si],al	; 000030C2  F00000                            
ud0 ax,[bx+si]	; 000030C5  0FFF00                            
add [bx],cl	; 000030C8  000F                              
push ax	; 000030CA  FFF0                              
add [bp+di],al	; 000030CC  0003                              
db 0xff	; 000030CE  FF                                
inc word [bx+si]	; 000030CF  FF00                              
add di,di	; 000030D1  03FF                              
push ax	; 000030D3  FFF0                              
add bh,bh	; 000030D5  00FF                              
inc ax	; 000030D7  FFC0                              
add [bx],cl	; 000030D9  000F                              
cld	; 000030DB  FC                                
add [bx+si],al	; 000030DC  0000                              
add [bx+si],al	; 000030DE  0000                              
add [bx+si],al	; 000030E0  0000                              
add ax,0x50	; 000030E2  055000                            
add [di+0x55],dl	; 000030E5  005555                            
add [bx+di],al	; 000030E8  0001                              
add ax,0x4050	; 000030EA  055040                            
pop es	; 000030ED  07                                
or ax,0xd070	; 000030EE  0D70D0                            
pop es	; 000030F1  07                                
std	; 000030F2  FD                                
jg 0x30c5	; 000030F3  7FD0                              
pop ss	; 000030F5  17                                
std	; 000030F6  FD                                
jg 0x30cd	; 000030F7  7FD4                              
adc ax,0x5ff5	; 000030F9  15F55F                            
push sp	; 000030FC  54                                
adc ax,0x5555	; 000030FD  155555                            
push sp	; 00003100  54                                
add [di],al	; 00003101  0005                              
push ax	; 00003103  50                                
add [bx+si],al	; 00003104  0000                              
push bp	; 00003106  55                                
push bp	; 00003107  55                                
add [bx+di],al	; 00003108  0001                              
push bp	; 0000310A  55                                
push bp	; 0000310B  55                                
inc ax	; 0000310C  40                                
add ax,0x5ff5	; 0000310D  05F55F                            
push ax	; 00003110  50                                
pop es	; 00003111  07                                
std	; 00003112  FD                                
jg 0x30e5	; 00003113  7FD0                              
pop ss	; 00003115  17                                
std	; 00003116  FD                                
jg 0x30ed	; 00003117  7FD4                              
pop ss	; 00003119  17                                
or ax,0xd470	; 0000311A  0D70D4                            
adc ax,0x5005	; 0000311D  150550                            
push sp	; 00003120  54                                
add [di],al	; 00003121  0005                              
push ax	; 00003123  50                                
add [bx+si],al	; 00003124  0000                              
push bp	; 00003126  55                                
push bp	; 00003127  55                                
add [bx+di],al	; 00003128  0001                              
cmc	; 0000312A  F5                                
pop di	; 0000312B  5F                                
inc ax	; 0000312C  40                                
pop es	; 0000312D  07                                
std	; 0000312E  FD                                
jg 0x3101	; 0000312F  7FD0                              
add al,0x3d	; 00003131  043D                              
inc bx	; 00003133  43                                
rcl byte [si],0x0	; 00003134  D014                              
cmp ax,0xd443	; 00003136  3D43D4                            
adc ax,0x5ff5	; 00003139  15F55F                            
push sp	; 0000313C  54                                
adc ax,0x5555	; 0000313D  155555                            
push sp	; 00003140  54                                
add [di],al	; 00003141  0005                              
push ax	; 00003143  50                                
add [bx+si],al	; 00003144  0000                              
push bp	; 00003146  55                                
push bp	; 00003147  55                                
add [bx+di],al	; 00003148  0001                              
cmc	; 0000314A  F5                                
pop di	; 0000314B  5F                                
inc ax	; 0000314C  40                                
pop es	; 0000314D  07                                
std	; 0000314E  FD                                
jg 0x3121	; 0000314F  7FD0                              
pop es	; 00003151  07                                
sar word [si+0x10],byte 0x17	; 00003152  C17C1017                          
sar word [si+0x14],byte 0x15	; 00003156  C17C1415                          
cmc	; 0000315A  F5                                
pop di	; 0000315B  5F                                
push sp	; 0000315C  54                                
adc ax,0x5555	; 0000315D  155555                            
push sp	; 00003160  54                                
adc ax,0x5555	; 00003161  155555                            
push sp	; 00003164  54                                
adc ax,0x5555	; 00003165  155555                            
push sp	; 00003168  54                                
adc ax,0x5555	; 00003169  155555                            
push sp	; 0000316C  54                                
adc ax,0x5555	; 0000316D  155555                            
push sp	; 00003170  54                                
adc ax,0x5145	; 00003171  154551                            
push sp	; 00003174  54                                
add ax,0x4001	; 00003175  050140                            
push ax	; 00003178  50                                
adc al,0x54	; 00003179  1454                              
adc ax,0x1014	; 0000317B  151410                            
adc al,0x14	; 0000317E  1414                              
add al,0x0	; 00003180  0400                              
pop es	; 00003182  07                                
jo 0x3185	; 00003183  7000                              
add ch,bl	; 00003185  00DD                              
fld qword [bx+si]	; 00003187  DD00                              
add ax,[bx]	; 00003189  0307                              
jo 0x31cd	; 0000318B  7040                              
db 0x0f	; 0000318D  0F                                
or ax,0xd0f0	; 0000318E  0DF0D0                            
pop es	; 00003191  07                                
db 0xff	; 00003192  FF                                
jg 0x3185	; 00003193  7FF0                              
pop ds	; 00003195  1F                                
std	; 00003196  FD                                
db 0xff	; 00003197  FF                                
fdiv qword [bx]	; 00003198  DC37                              
idiv word [bx+0x74]	; 0000319A  F77F74                            
sbb ax,0xdddd	; 0000319D  1DDDDD                            
fadd qword [bx+si]	; 000031A0  DC00                              
pop es	; 000031A2  07                                
jo 0x31a5	; 000031A3  7000                              
add ch,bl	; 000031A5  00DD                              
fld qword [bx+si]	; 000031A7  DD00                              
add si,[bx+0x77]	; 000031A9  037777                            
inc ax	; 000031AC  40                                
or ax,0xdffd	; 000031AD  0DFDDF                            
rol byte [bx],0x0	; 000031B0  D007                              
db 0xff	; 000031B2  FF                                
jg 0x31a5	; 000031B3  7FF0                              
pop ds	; 000031B5  1F                                
std	; 000031B6  FD                                
db 0xff	; 000031B7  FF                                
fdiv qword [bx]	; 000031B8  DC37                              
pshufw mm6,mm4,0x1d	; 000031BA  0F70F41D                          
or ax,0xdcd0	; 000031BE  0DD0DC                            
add [bx],al	; 000031C1  0007                              
jo 0x31c5	; 000031C3  7000                              
add ch,bl	; 000031C5  00DD                              
fld qword [bx+si]	; 000031C7  DD00                              
add si,di	; 000031C9  03F7                              
jg 0x320d	; 000031CB  7F40                              
paddw mm7,mm7	; 000031CD  0FFDFF                            
rol byte [si],0x0	; 000031D0  D004                              
aas	; 000031D2  3F                                
inc bx	; 000031D3  43                                
lock	; 000031D4  F0                                
sbb al,0x3d	; 000031D5  1C3D                              
ret	; 000031D7  C3                                
fdiv qword [bx]	; 000031D8  DC37                              
idiv word [bx+0x74]	; 000031DA  F77F74                            
sbb ax,0xdddd	; 000031DD  1DDDDD                            
fadd qword [bx+si]	; 000031E0  DC00                              
pop es	; 000031E2  07                                
jo 0x31e5	; 000031E3  7000                              
add ch,bl	; 000031E5  00DD                              
fld qword [bx+si]	; 000031E7  DD00                              
add si,di	; 000031E9  03F7                              
jg 0x322d	; 000031EB  7F40                              
paddw mm7,mm7	; 000031ED  0FFDFF                            
rol byte [bx],0x0	; 000031F0  D007                              
ret	; 000031F2  C3                                
jl 0x3225	; 000031F3  7C30                              
pop ds	; 000031F5  1F                                
sar sp,byte 0x1c	; 000031F6  C1FC1C                            
aaa	; 000031F9  37                                
idiv word [bx+0x74]	; 000031FA  F77F74                            
sbb ax,0xdddd	; 000031FD  1DDDDD                            
fdiv qword [bx]	; 00003200  DC37                              
ja 0x327b	; 00003202  7777                              
jz 0x3223	; 00003204  741D                              
fstp st5	; 00003206  DDDD                              
fdiv qword [bx]	; 00003208  DC37                              
ja 0x3283	; 0000320A  7777                              
jz 0x322b	; 0000320C  741D                              
fstp st5	; 0000320E  DDDD                              
fdiv qword [bx]	; 00003210  DC37                              
inc di	; 00003212  47                                
jnc 0x3289	; 00003213  7374                              
or ax,0xc001	; 00003215  0D01C0                            
db 0xd0	; 00003218  D0                                
xor al,0x74	; 00003219  3474                              
aaa	; 0000321B  37                                
xor al,0x10	; 0000321C  3410                              
sbb al,0x1c	; 0000321E  1C1C                              
or al,0x0	; 00003220  0C00                              
or ah,[bx+si+0x0]	; 00003222  0AA00000                          
stosb	; 00003226  AA                                
stosb	; 00003227  AA                                
add [bp+si],al	; 00003228  0002                              
or ah,[bx+si+0xb80]	; 0000322A  0AA0800B                          
push cs	; 0000322E  0E                                
mov al,0xe0	; 0000322F  B0E0                              
or di,si	; 00003231  0BFE                              
mov di,0x2be0	; 00003233  BFE02B                            
db 0xfe	; 00003236  FE                                
mov di,0x2ae8	; 00003237  BFE82A                            
cli	; 0000323A  FA                                
scasw	; 0000323B  AF                                
test al,0x2a	; 0000323C  A82A                              
stosb	; 0000323E  AA                                
stosb	; 0000323F  AA                                
test al,0x0	; 00003240  A800                              
or ah,[bx+si+0x0]	; 00003242  0AA00000                          
stosb	; 00003246  AA                                
stosb	; 00003247  AA                                
add [bp+si],al	; 00003248  0002                              
stosb	; 0000324A  AA                                
stosb	; 0000324B  AA                                
or byte [bp+si],0xfa	; 0000324C  800AFA                            
scasw	; 0000324F  AF                                
mov al,[0xfe0b]	; 00003250  A00BFE                            
mov di,0x2be0	; 00003253  BFE02B                            
db 0xfe	; 00003256  FE                                
mov di,0x2be8	; 00003257  BFE82B                            
push cs	; 0000325A  0E                                
mov al,0xe8	; 0000325B  B0E8                              
sub cl,[bp+si]	; 0000325D  2A0A                              
mov al,[0xa8]	; 0000325F  A0A800                            
or ah,[bx+si+0x0]	; 00003262  0AA00000                          
stosb	; 00003266  AA                                
stosb	; 00003267  AA                                
add [bp+si],al	; 00003268  0002                              
cli	; 0000326A  FA                                
scasw	; 0000326B  AF                                
or byte [bp+di],0xfe	; 0000326C  800BFE                            
mov di,0x8e0	; 0000326F  BFE008                            
ds and ax,0x28	; 00003272  3E83E028                          
ds sub ax,0x2a	; 00003276  3E83E82A                          
cli	; 0000327A  FA                                
scasw	; 0000327B  AF                                
test al,0x2a	; 0000327C  A82A                              
stosb	; 0000327E  AA                                
stosb	; 0000327F  AA                                
test al,0x0	; 00003280  A800                              
or ah,[bx+si+0x0]	; 00003282  0AA00000                          
stosb	; 00003286  AA                                
stosb	; 00003287  AA                                
add [bp+si],al	; 00003288  0002                              
cli	; 0000328A  FA                                
scasw	; 0000328B  AF                                
or byte [bp+di],0xfe	; 0000328C  800BFE                            
mov di,0xbe0	; 0000328F  BFE00B                            
ret word 0x20bc	; 00003292  C2BC20                            
sub ax,dx	; 00003295  2BC2                              
mov sp,0x2a28	; 00003297  BC282A                            
cli	; 0000329A  FA                                
scasw	; 0000329B  AF                                
test al,0x2a	; 0000329C  A82A                              
stosb	; 0000329E  AA                                
stosb	; 0000329F  AA                                
test al,0x2a	; 000032A0  A82A                              
stosb	; 000032A2  AA                                
stosb	; 000032A3  AA                                
test al,0x2a	; 000032A4  A82A                              
stosb	; 000032A6  AA                                
stosb	; 000032A7  AA                                
test al,0x2a	; 000032A8  A82A                              
stosb	; 000032AA  AA                                
stosb	; 000032AB  AA                                
test al,0x2a	; 000032AC  A82A                              
stosb	; 000032AE  AA                                
stosb	; 000032AF  AA                                
test al,0x2a	; 000032B0  A82A                              
mov ah,[bp+si+0xaa8]	; 000032B2  8AA2A80A                          
add al,[bx+si+0x28a0]	; 000032B6  0280A028                          
test al,0x2a	; 000032BA  A82A                              
sub [bx+si],ah	; 000032BC  2820                              
sub [bx+si],ch	; 000032BE  2828                              
or [bx+si],al	; 000032C0  0800                              
or si,[bx+si+0x0]	; 000032C2  0BB00000                          
out dx,al	; 000032C6  EE                                
out dx,al	; 000032C7  EE                                
add [bp+di],al	; 000032C8  0003                              
or si,[bx+si+0xf80]	; 000032CA  0BB0800F                          
push cs	; 000032CE  0E                                
lock	; 000032CF  F0                                
loopne 0x32dd	; 000032D0  E00B                              
db 0xff	; 000032D2  FF                                
mov di,0x2ff0	; 000032D3  BFF02F                            
db 0xfe	; 000032D6  FE                                
db 0xff	; 000032D7  FF                                
in al,dx	; 000032D8  EC                                
cmp di,bx	; 000032D9  3BFB                              
mov di,0x2eb8	; 000032DB  BFB82E                            
out dx,al	; 000032DE  EE                                
out dx,al	; 000032DF  EE                                
in al,dx	; 000032E0  EC                                
add [bp+di],cl	; 000032E1  000B                              
mov al,0x0	; 000032E3  B000                              
add dh,ch	; 000032E5  00EE                              
out dx,al	; 000032E7  EE                                
add [bp+di],al	; 000032E8  0003                              
mov bx,0x80bb	; 000032EA  BBBB80                            
push cs	; 000032ED  0E                                
db 0xfe	; 000032EE  FE                                
out dx,ax	; 000032EF  EF                                
loopne 0x32fd	; 000032F0  E00B                              
db 0xff	; 000032F2  FF                                
mov di,0x2ff0	; 000032F3  BFF02F                            
db 0xfe	; 000032F6  FE                                
db 0xff	; 000032F7  FF                                
in al,dx	; 000032F8  EC                                
cmp cx,[bx]	; 000032F9  3B0F                              
mov al,0xf8	; 000032FB  B0F8                              
cs push cs	; 000032FD  2E0E                              
loopne 0x32ed	; 000032FF  E0EC                              
add [bp+di],cl	; 00003301  000B                              
mov al,0x0	; 00003303  B000                              
add dh,ch	; 00003305  00EE                              
out dx,al	; 00003307  EE                                
add [bp+di],al	; 00003308  0003                              
sti	; 0000330A  FB                                
mov di,0xf80	; 0000330B  BF800F                            
db 0xfe	; 0000330E  FE                                
db 0xff	; 0000330F  FF                                
loopne 0x331a	; 00003310  E008                              
aas	; 00003312  3F                                
xor ax,0x2c	; 00003313  83F02C                            
ds ret	; 00003316  3EC3                              
in al,dx	; 00003318  EC                                
cmp di,bx	; 00003319  3BFB                              
mov di,0x2eb8	; 0000331B  BFB82E                            
out dx,al	; 0000331E  EE                                
out dx,al	; 0000331F  EE                                
in al,dx	; 00003320  EC                                
add [bp+di],cl	; 00003321  000B                              
mov al,0x0	; 00003323  B000                              
add dh,ch	; 00003325  00EE                              
out dx,al	; 00003327  EE                                
add [bp+di],al	; 00003328  0003                              
sti	; 0000332A  FB                                
mov di,0xf80	; 0000332B  BF800F                            
db 0xfe	; 0000332E  FE                                
db 0xff	; 0000332F  FF                                
loopne 0x333d	; 00003330  E00B                              
ret	; 00003332  C3                                
mov sp,0x2f30	; 00003333  BC302F                            
ret word 0x2cfc	; 00003336  C2FC2C                            
cmp di,bx	; 00003339  3BFB                              
mov di,0x2eb8	; 0000333B  BFB82E                            
out dx,al	; 0000333E  EE                                
out dx,al	; 0000333F  EE                                
in al,dx	; 00003340  EC                                
cmp di,[bp+di-0x4745]	; 00003341  3BBBBBB8                          
cs out dx,al	; 00003345  2EEE                              
out dx,al	; 00003347  EE                                
in al,dx	; 00003348  EC                                
cmp di,[bp+di-0x4745]	; 00003349  3BBBBBB8                          
cs out dx,al	; 0000334D  2EEE                              
out dx,al	; 0000334F  EE                                
in al,dx	; 00003350  EC                                
cmp cx,[bp+di-0x474d]	; 00003351  3B8BB3B8                          
push cs	; 00003355  0E                                
add al,al	; 00003356  02C0                              
loopne 0x3392	; 00003358  E038                              
mov ax,0x383b	; 0000335A  B83B38                            
and [si],ch	; 0000335D  202C                              
sub al,0xc	; 0000335F  2C0C                              
add [di],al	; 00003361  0005                              
push ax	; 00003363  50                                
add [bx+si],al	; 00003364  0000                              
push ax	; 00003366  50                                
add ax,0x100	; 00003367  050001                            
add [bx+si],al	; 0000336A  0000                              
inc ax	; 0000336C  40                                
add al,0x3c	; 0000336D  043C                              
cmp al,0x10	; 0000336F  3C10                              
add al,0x3c	; 00003371  043C                              
cmp al,0x10	; 00003373  3C10                              
adc [bx+si],al	; 00003375  1000                              
add [si],al	; 00003377  0004                              
adc [bx+si],al	; 00003379  1000                              
add [si],al	; 0000337B  0004                              
adc [bx+si],al	; 0000337D  1000                              
add [si],al	; 0000337F  0004                              
add [di],al	; 00003381  0005                              
push ax	; 00003383  50                                
add [bx+si],al	; 00003384  0000                              
push ax	; 00003386  50                                
add ax,0x100	; 00003387  050001                            
add [bx+si],al	; 0000338A  0000                              
inc ax	; 0000338C  40                                
add al,0x3c	; 0000338D  043C                              
cmp al,0x10	; 0000338F  3C10                              
add al,0x3c	; 00003391  043C                              
cmp al,0x10	; 00003393  3C10                              
adc [bx+si],al	; 00003395  1000                              
add [si],al	; 00003397  0004                              
adc [bx+si],al	; 00003399  1000                              
add [si],al	; 0000339B  0004                              
adc [bx+si],al	; 0000339D  1000                              
add [si],al	; 0000339F  0004                              
add [di],al	; 000033A1  0005                              
push ax	; 000033A3  50                                
add [bx+si],al	; 000033A4  0000                              
push ax	; 000033A6  50                                
add ax,0x100	; 000033A7  050001                            
add [bx+si],al	; 000033AA  0000                              
inc ax	; 000033AC  40                                
add al,0x3c	; 000033AD  043C                              
cmp al,0x10	; 000033AF  3C10                              
add al,0x3c	; 000033B1  043C                              
cmp al,0x10	; 000033B3  3C10                              
adc [bx+si],al	; 000033B5  1000                              
add [si],al	; 000033B7  0004                              
adc [bx+si],al	; 000033B9  1000                              
add [si],al	; 000033BB  0004                              
adc [bx+si],al	; 000033BD  1000                              
add [si],al	; 000033BF  0004                              
add [di],al	; 000033C1  0005                              
push ax	; 000033C3  50                                
add [bx+si],al	; 000033C4  0000                              
push ax	; 000033C6  50                                
add ax,0x100	; 000033C7  050001                            
add [bx+si],al	; 000033CA  0000                              
inc ax	; 000033CC  40                                
add al,0x3c	; 000033CD  043C                              
cmp al,0x10	; 000033CF  3C10                              
add al,0x3c	; 000033D1  043C                              
cmp al,0x10	; 000033D3  3C10                              
adc [bx+si],al	; 000033D5  1000                              
add [si],al	; 000033D7  0004                              
adc [bx+si],al	; 000033D9  1000                              
add [si],al	; 000033DB  0004                              
adc [bx+si],al	; 000033DD  1000                              
add [si],al	; 000033DF  0004                              
adc ax,bx	; 000033E1  13C3                              
ret	; 000033E3  C3                                
les bx,word [si]	; 000033E4  C41C                              
cmp al,0x3c	; 000033E6  3C3C                              
xor al,0x10	; 000033E8  3410                              
add [bx+si],al	; 000033EA  0000                              
add al,0x10	; 000033EC  0410                              
add [bx+si],al	; 000033EE  0000                              
add al,0x10	; 000033F0  0410                              
inc sp	; 000033F2  44                                
adc [si],ax	; 000033F3  1104                              
add ax,0x4001	; 000033F5  050140                            
push ax	; 000033F8  50                                
adc al,0x44	; 000033F9  1444                              
adc [si],dx	; 000033FB  1114                              
adc [si],dl	; 000033FD  1014                              
adc al,0x4	; 000033FF  1404                              
add [bx],cl	; 00003401  000F                              
lock add [bx+si],al	; 00003403  F00000                            
db 0xff	; 00003406  FF                                
inc word [bx+si]	; 00003407  FF00                              
add di,di	; 00003409  03FF                              
inc ax	; 0000340B  FFC0                              
por mm5,mm3	; 0000340D  0FEBEB                            
lock	; 00003410  F0                                
por mm5,mm3	; 00003411  0FEBEB                            
lock	; 00003414  F0                                
aas	; 00003415  3F                                
db 0xff	; 00003416  FF                                
db 0xff	; 00003417  FF                                
cld	; 00003418  FC                                
aas	; 00003419  3F                                
db 0xff	; 0000341A  FF                                
db 0xff	; 0000341B  FF                                
cld	; 0000341C  FC                                
aas	; 0000341D  3F                                
db 0xff	; 0000341E  FF                                
db 0xff	; 0000341F  FF                                
cld	; 00003420  FC                                
add [bx],cl	; 00003421  000F                              
lock add [bx+si],al	; 00003423  F00000                            
db 0xff	; 00003426  FF                                
inc word [bx+si]	; 00003427  FF00                              
add di,di	; 00003429  03FF                              
inc ax	; 0000342B  FFC0                              
por mm5,mm3	; 0000342D  0FEBEB                            
lock	; 00003430  F0                                
por mm5,mm3	; 00003431  0FEBEB                            
lock	; 00003434  F0                                
aas	; 00003435  3F                                
db 0xff	; 00003436  FF                                
db 0xff	; 00003437  FF                                
cld	; 00003438  FC                                
aas	; 00003439  3F                                
db 0xff	; 0000343A  FF                                
db 0xff	; 0000343B  FF                                
cld	; 0000343C  FC                                
aas	; 0000343D  3F                                
db 0xff	; 0000343E  FF                                
db 0xff	; 0000343F  FF                                
cld	; 00003440  FC                                
add [bx],cl	; 00003441  000F                              
lock add [bx+si],al	; 00003443  F00000                            
db 0xff	; 00003446  FF                                
inc word [bx+si]	; 00003447  FF00                              
add di,di	; 00003449  03FF                              
inc ax	; 0000344B  FFC0                              
por mm5,mm3	; 0000344D  0FEBEB                            
lock	; 00003450  F0                                
por mm5,mm3	; 00003451  0FEBEB                            
lock	; 00003454  F0                                
aas	; 00003455  3F                                
db 0xff	; 00003456  FF                                
db 0xff	; 00003457  FF                                
cld	; 00003458  FC                                
aas	; 00003459  3F                                
db 0xff	; 0000345A  FF                                
db 0xff	; 0000345B  FF                                
cld	; 0000345C  FC                                
aas	; 0000345D  3F                                
db 0xff	; 0000345E  FF                                
db 0xff	; 0000345F  FF                                
cld	; 00003460  FC                                
add [bx],cl	; 00003461  000F                              
lock add [bx+si],al	; 00003463  F00000                            
db 0xff	; 00003466  FF                                
inc word [bx+si]	; 00003467  FF00                              
add di,di	; 00003469  03FF                              
inc ax	; 0000346B  FFC0                              
por mm5,mm3	; 0000346D  0FEBEB                            
lock	; 00003470  F0                                
por mm5,mm3	; 00003471  0FEBEB                            
lock	; 00003474  F0                                
aas	; 00003475  3F                                
db 0xff	; 00003476  FF                                
db 0xff	; 00003477  FF                                
cld	; 00003478  FC                                
aas	; 00003479  3F                                
db 0xff	; 0000347A  FF                                
db 0xff	; 0000347B  FF                                
cld	; 0000347C  FC                                
aas	; 0000347D  3F                                
db 0xff	; 0000347E  FF                                
db 0xff	; 0000347F  FF                                
cld	; 00003480  FC                                
ds mov si,0xbcbe	; 00003481  3EBEBEBC                          
cmp bp,bx	; 00003485  3BEB                              
jmp 0x3475	; 00003487  EBEC                              
aas	; 00003489  3F                                
db 0xff	; 0000348A  FF                                
db 0xff	; 0000348B  FF                                
cld	; 0000348C  FC                                
aas	; 0000348D  3F                                
db 0xff	; 0000348E  FF                                
db 0xff	; 0000348F  FF                                
cld	; 00003490  FC                                
aas	; 00003491  3F                                
iret	; 00003492  CF                                
rep cld	; 00003493  F3FC                              
lsl ax,ax	; 00003495  0F03C0                            
lock	; 00003498  F0                                
cmp al,0xfc	; 00003499  3CFC                              
aas	; 0000349B  3F                                
cmp al,0x30	; 0000349C  3C30                              
cmp al,0x3c	; 0000349E  3C3C                              
or al,0x0	; 000034A0  0C00                              
add [bx+si],al	; 000034A2  0000                              
add [bx+si],al	; 000034A4  0000                              
mov al,[0xa]	; 000034A6  A00A00                            
add bp,[si-0x3fc6]	; 000034A9  03AC3AC0                          
add di,sp	; 000034AD  03FC                              
aas	; 000034AF  3F                                
rol byte [bp+di],byte 0xfc	; 000034B0  C003FC                            
aas	; 000034B3  3F                                
rol byte [bx+si],byte 0xf0	; 000034B4  C000F0                            
sldt word [bx+si]	; 000034B7  0F0000                            
add [bx+si],al	; 000034BA  0000                              
add [bx+si],al	; 000034BC  0000                              
add [bx+si],al	; 000034BE  0000                              
add [bx+si],al	; 000034C0  0000                              
add [bx+si],al	; 000034C2  0000                              
add [bx+si],al	; 000034C4  0000                              
add [bx+si],al	; 000034C6  0000                              
add [bx+si],al	; 000034C8  0000                              
add [bx+si],al	; 000034CA  0000                              
add [bx+si],al	; 000034CC  0000                              
lock	; 000034CE  F0                                
sldt word [bp+di]	; 000034CF  0F0003                            
cld	; 000034D2  FC                                
aas	; 000034D3  3F                                
rol byte [bp+di],byte 0xfc	; 000034D4  C003FC                            
aas	; 000034D7  3F                                
rol byte [bp+di],byte 0xac	; 000034D8  C003AC                            
cmp al,al	; 000034DB  3AC0                              
add [bx+si+0xa],ah	; 000034DD  00A00A00                          
add [bx+si],al	; 000034E1  0000                              
add [bx+si],al	; 000034E3  0000                              
add [bx+si],al	; 000034E5  0000                              
add [bx+si],al	; 000034E7  0000                              
add al,dh	; 000034E9  00F0                              
sldt word [bp+di]	; 000034EB  0F0003                            
cld	; 000034EE  FC                                
aas	; 000034EF  3F                                
rol byte [bp+si],byte 0xbc	; 000034F0  C002BC                            
sub ax,ax	; 000034F3  2BC0                              
add bh,[si-0x3fd5]	; 000034F5  02BC2BC0                          
add al,dh	; 000034F9  00F0                              
sldt word [bx+si]	; 000034FB  0F0000                            
add [bx+si],al	; 000034FE  0000                              
add [bx+si],al	; 00003500  0000                              
add [bx+si],al	; 00003502  0000                              
add [bx+si],al	; 00003504  0000                              
add [bx+si],al	; 00003506  0000                              
add [bx+si],al	; 00003508  0000                              
lock	; 0000350A  F0                                
sldt word [bp+di]	; 0000350B  0F0003                            
cld	; 0000350E  FC                                
aas	; 0000350F  3F                                
rol byte [bp+di],byte 0xe8	; 00003510  C003E8                            
add byte [ds:bp+di],0xe8	; 00003513  3E8003E8                          
add byte [ds:bx+si],0xf0	; 00003517  3E8000F0                          
sldt word [bx+si]	; 0000351B  0F0000                            
add [bx+si],al	; 0000351E  0000                              
add [bx+si],al	; 00003520  0000                              
add [bx+si],al	; 00003522  0000                              
add [bx+si],al	; 00003524  0000                              
add [bx+si],al	; 00003526  0000                              
add [bx+si],al	; 00003528  0000                              
add [bx+si],al	; 0000352A  0000                              
add [bx+si],al	; 0000352C  0000                              
add [bx+si],al	; 0000352E  0000                              
add [bx+si],al	; 00003530  0000                              
add [bx+si],al	; 00003532  0000                              
add [bx+si],al	; 00003534  0000                              
add [bx+si],al	; 00003536  0000                              
add [bx+si],al	; 00003538  0000                              
add [bx+si],al	; 0000353A  0000                              
add [bx+si],al	; 0000353C  0000                              
add [bx+si],al	; 0000353E  0000                              
add [bx],bh	; 00003540  003F                              
lock	; 00003542  F0                                
lock	; 00003543  F0                                
cmp al,0xf0	; 00003544  3CF0                              
cld	; 00003546  FC                                
rep cld	; 00003547  F3FC                              
db 0xff	; 00003549  FF                                
cmp al,0xfc	; 0000354A  3CFC                              
cmp al,0x3f	; 0000354C  3C3F                              
lock add [bx+si],al	; 0000354E  F00000                            
db 0x0f	; 00003551  0F                                
add [bx],bh	; 00003552  003F                              
add [bx],cl	; 00003554  000F                              
add [bx],cl	; 00003556  000F                              
add [bx],cl	; 00003558  000F                              
add [bx],cl	; 0000355A  000F                              
add bh,bh	; 0000355C  00FF                              
lock add [bx+si],al	; 0000355E  F00000                            
aas	; 00003561  3F                                
db 0xc0	; 00003562  C0                                
lock add al,dh	; 00003563  F0F000F0                          
xadd [si],bh	; 00003567  0FC03C                            
add al,dh	; 0000356A  00F0                              
lock	; 0000356C  F0                                
push ax	; 0000356D  FFF0                              
add [bx+si],al	; 0000356F  0000                              
aas	; 00003571  3F                                
db 0xc0	; 00003572  C0                                
lock add al,dh	; 00003573  F0F000F0                          
xadd [bx+si],al	; 00003577  0FC000                            
lock	; 0000357A  F0                                
lock	; 0000357B  F0                                
lock	; 0000357C  F0                                
aas	; 0000357D  3F                                
rol byte [bx+si],byte 0x0	; 0000357E  C00000                            
add si,ax	; 00003581  03F0                              
db 0x0f	; 00003583  0F                                
lock	; 00003584  F0                                
cmp al,0xf0	; 00003585  3CF0                              
lock	; 00003587  F0                                
lock	; 00003588  F0                                
db 0xff	; 00003589  FF                                
cld	; 0000358A  FC                                
add al,dh	; 0000358B  00F0                              
add di,sp	; 0000358D  03FC                              
add [bx+si],al	; 0000358F  0000                              
push ax	; 00003591  FFF0                              
lock add bh,bh	; 00003593  F000FF                            
rol byte [bx+si],byte 0xf0	; 00003596  C000F0                            
add al,dh	; 00003599  00F0                              
lock	; 0000359B  F0                                
lock	; 0000359C  F0                                
aas	; 0000359D  3F                                
rol byte [bx+si],byte 0x0	; 0000359E  C00000                            
xadd [si],bh	; 000035A1  0FC03C                            
add al,dh	; 000035A4  00F0                              
add bh,bh	; 000035A6  00FF                              
db 0xc0	; 000035A8  C0                                
lock	; 000035A9  F0                                
lock	; 000035AA  F0                                
lock	; 000035AB  F0                                
lock	; 000035AC  F0                                
aas	; 000035AD  3F                                
rol byte [bx+si],byte 0x0	; 000035AE  C00000                            
push ax	; 000035B1  FFF0                              
lock add al,dh	; 000035B3  F0F000F0                          
add ax,ax	; 000035B7  03C0                              
str word [bx]	; 000035B9  0F000F                            
add [bx],cl	; 000035BC  000F                              
add [bx+si],al	; 000035BE  0000                              
add [bx],bh	; 000035C0  003F                              
db 0xc0	; 000035C2  C0                                
lock	; 000035C3  F0                                
lock	; 000035C4  F0                                
lock	; 000035C5  F0                                
lock	; 000035C6  F0                                
aas	; 000035C7  3F                                
db 0xc0	; 000035C8  C0                                
lock	; 000035C9  F0                                
lock	; 000035CA  F0                                
lock	; 000035CB  F0                                
lock	; 000035CC  F0                                
aas	; 000035CD  3F                                
rol byte [bx+si],byte 0x0	; 000035CE  C00000                            
aas	; 000035D1  3F                                
db 0xc0	; 000035D2  C0                                
lock	; 000035D3  F0                                
lock	; 000035D4  F0                                
lock	; 000035D5  F0                                
lock	; 000035D6  F0                                
aas	; 000035D7  3F                                
lock add al,dh	; 000035D8  F000F0                            
add ax,ax	; 000035DB  03C0                              
aas	; 000035DD  3F                                
add [bx+si],al	; 000035DE  0000                              
add [bx+si],al	; 000035E0  0000                              
add [bx+si],al	; 000035E2  0000                              
add [bx+si],al	; 000035E4  0000                              
add [bx+si],al	; 000035E6  0000                              
add [bx+si],al	; 000035E8  0000                              
add [bx+si],al	; 000035EA  0000                              
add [bx+si],al	; 000035EC  0000                              
add [bx+si],al	; 000035EE  0000                              
add [bp+si],al	; 000035F0  0002                              
lsl ax,ax	; 000035F2  0F03C0                            
lock xor ah,cl	; 000035F5  F030CC                            
xor cx,[si]	; 000035F8  330C                              
add ah,cl	; 000035FA  00CC                              
xor cx,[si]	; 000035FC  330C                              
add cx,[si]	; 000035FE  030C                              
xor cx,[si]	; 00003600  330C                              
or al,0xc	; 00003602  0C0C                              
xor cx,[si]	; 00003604  330C                              
xor [si],cl	; 00003606  300C                              
xor cx,[si]	; 00003608  330C                              
aas	; 0000360A  3F                                
ret	; 0000360B  C3                                
db 0xc0	; 0000360C  C0                                
lock add [bx+si],al	; 0000360D  F00000                            
add [bx+si],al	; 00003610  0000                              
add al,0x30	; 00003612  0430                              
ret	; 00003614  C3                                
db 0xc0	; 00003615  C0                                
lock xor ah,cl	; 00003616  F030CC                            
xor cx,[si]	; 00003619  330C                              
xor ah,cl	; 0000361B  30CC                              
xor cx,[si]	; 0000361D  330C                              
aas	; 0000361F  3F                                
int3	; 00003620  CC                                
xor cx,[si]	; 00003621  330C                              
add ah,cl	; 00003623  00CC                              
xor cx,[si]	; 00003625  330C                              
add ah,cl	; 00003627  00CC                              
xor cx,[si]	; 00003629  330C                              
add bl,al	; 0000362B  00C3                              
db 0xc0	; 0000362D  C0                                
lock add [bx+si],al	; 0000362E  F00000                            
add [bx+si],al	; 00003631  0000                              
or [bx],cl	; 00003633  080F                              
add ax,ax	; 00003635  03C0                              
lock xor ah,cl	; 00003637  F030CC                            
xor cx,[si]	; 0000363A  330C                              
xor ah,cl	; 0000363C  30CC                              
xor cx,[si]	; 0000363E  330C                              
db 0x0f	; 00003640  0F                                
or al,0x33	; 00003641  0C33                              
or al,0x30	; 00003643  0C30                              
int3	; 00003645  CC                                
xor cx,[si]	; 00003646  330C                              
xor ah,cl	; 00003648  30CC                              
xor cx,[si]	; 0000364A  330C                              
lsl ax,ax	; 0000364C  0F03C0                            
lock add [bx+si],al	; 0000364F  F00000                            
add [bx+si],al	; 00003652  0000                              
adc bl,al	; 00003654  10C3                              
db 0xc0	; 00003656  C0                                
lock	; 00003657  F0                                
cmp al,0xcc	; 00003658  3CCC                              
xor cx,[si]	; 0000365A  330C                              
ret	; 0000365C  C3                                
int3	; 0000365D  CC                                
add cx,[si]	; 0000365E  030C                              
ret	; 00003660  C3                                
iret	; 00003661  CF                                
ret	; 00003662  C3                                
or al,0xc3	; 00003663  0CC3                              
int3	; 00003665  CC                                
xor cx,[si]	; 00003666  330C                              
ret	; 00003668  C3                                
int3	; 00003669  CC                                
xor cx,[si]	; 0000366A  330C                              
ret	; 0000366C  C3                                
ret	; 0000366D  C3                                
db 0xc0	; 0000366E  C0                                
lock	; 0000366F  F0                                
cmp al,0x0	; 00003670  3C00                              
add [bx+si],al	; 00003672  0000                              
add [bx+si],al	; 00003674  0000                              
add [bx+si],al	; 00003676  0000                              
add [bx+si],al	; 00003678  0000                              
add [bx+si],al	; 0000367A  0000                              
add [si],bh	; 0000367C  003C                              
add [bx+si],al	; 0000367E  0000                              
lock	; 00003680  F0                                
aas	; 00003681  3F                                
add [bp+di],al	; 00003682  0003                              
lock	; 00003684  F0                                
aas	; 00003685  3F                                
ror byte [bx],byte 0xf0	; 00003686  C00FF0                            
aas	; 00003689  3F                                
lock	; 0000368A  F0                                
aas	; 0000368B  3F                                
lock	; 0000368C  F0                                
aas	; 0000368D  3F                                
cld	; 0000368E  FC                                
push ax	; 0000368F  FFF0                              
ud0 di,di	; 00003691  0FFFFF                            
ror byte [bx],byte 0xff	; 00003694  C00FFF                            
inc ax	; 00003697  FFC0                              
add di,di	; 00003699  03FF                              
inc word [bx+si]	; 0000369B  FF00                              
add [bx],bh	; 0000369D  003F                              
lock add [bx+si],al	; 0000369F  F00000                            
add [bx+si],al	; 000036A2  0000                              
add [bx+si],al	; 000036A4  0000                              
add [bx+si],al	; 000036A6  0000                              
add [bx+si],al	; 000036A8  0000                              
add [bx+si],al	; 000036AA  0000                              
add [bx+si],al	; 000036AC  0000                              
add [bx+si],al	; 000036AE  0000                              
add [bx+si],al	; 000036B0  0000                              
add [bx+si],al	; 000036B2  0000                              
add [bx+si],al	; 000036B4  0000                              
add [bx+si],al	; 000036B6  0000                              
add [si],bh	; 000036B8  003C                              
add [bx+si],al	; 000036BA  0000                              
lock	; 000036BC  F0                                
aas	; 000036BD  3F                                
add [bp+di],al	; 000036BE  0003                              
lock	; 000036C0  F0                                
aas	; 000036C1  3F                                
ror byte [bx],byte 0xf0	; 000036C2  C00FF0                            
aas	; 000036C5  3F                                
cld	; 000036C6  FC                                
push ax	; 000036C7  FFF0                              
aas	; 000036C9  3F                                
db 0xff	; 000036CA  FF                                
push ax	; 000036CB  FFF0                              
ud0 di,di	; 000036CD  0FFFFF                            
rol byte [bp+di],byte 0xff	; 000036D0  C003FF                            
inc word [bx+si]	; 000036D3  FF00                              
add [bx],bh	; 000036D5  003F                              
lock add [bx+si],al	; 000036D7  F00000                            
add [bx+si],al	; 000036DA  0000                              
add [bx+si],al	; 000036DC  0000                              
add [bx+si],al	; 000036DE  0000                              
add [bx+si],al	; 000036E0  0000                              
add [bx+si],al	; 000036E2  0000                              
add [bx+si],al	; 000036E4  0000                              
add [bx+si],al	; 000036E6  0000                              
add [bx+si],al	; 000036E8  0000                              
add [bx+si],al	; 000036EA  0000                              
add [bx+si],al	; 000036EC  0000                              
add [bx+si],al	; 000036EE  0000                              
add [bx+si],al	; 000036F0  0000                              
add [bx+si],al	; 000036F2  0000                              
add al,dh	; 000036F4  00F0                              
add [bx+si],al	; 000036F6  0000                              
cmp al,0xff	; 000036F8  3CFF                              
ror byte [bx],byte 0xfc	; 000036FA  C00FFC                            
aas	; 000036FD  3F                                
cld	; 000036FE  FC                                
push ax	; 000036FF  FFF0                              
aas	; 00003701  3F                                
db 0xff	; 00003702  FF                                
push ax	; 00003703  FFF0                              
ud0 di,di	; 00003705  0FFFFF                            
rol byte [bp+di],byte 0xff	; 00003708  C003FF                            
inc word [bx+si]	; 0000370B  FF00                              
add bh,bh	; 0000370D  00FF                              
cld	; 0000370F  FC                                
add [bx+si],al	; 00003710  0000                              
add [bx+si],al	; 00003712  0000                              
add [bx+si],al	; 00003714  0000                              
add [bx+si],al	; 00003716  0000                              
add [bx+si],al	; 00003718  0000                              
add [bx+si],al	; 0000371A  0000                              
add [bx+si],al	; 0000371C  0000                              
add [bx+si],al	; 0000371E  0000                              
add [bx+si],al	; 00003720  0000                              
add [bx+si],al	; 00003722  0000                              
add [bx+si],al	; 00003724  0000                              
add [bx+si],al	; 00003726  0000                              
add [bx+si],al	; 00003728  0000                              
add [bx+si],al	; 0000372A  0000                              
add [bx+si],al	; 0000372C  0000                              
add [bx+si],al	; 0000372E  0000                              
add al,dh	; 00003730  00F0                              
add [bx+si],al	; 00003732  0000                              
cmp al,0xff	; 00003734  3CFF                              
lock	; 00003736  F0                                
aas	; 00003737  3F                                
cld	; 00003738  FC                                
aas	; 00003739  3F                                
db 0xff	; 0000373A  FF                                
push ax	; 0000373B  FFF0                              
aas	; 0000373D  3F                                
db 0xff	; 0000373E  FF                                
push ax	; 0000373F  FFF0                              
ud0 di,di	; 00003741  0FFFFF                            
rol byte [bx+si],byte 0xff	; 00003744  C000FF                            
cld	; 00003747  FC                                
add [bx+si],al	; 00003748  0000                              
add [bx+si],al	; 0000374A  0000                              
add [bx+si],al	; 0000374C  0000                              
add [bx+si],al	; 0000374E  0000                              
add [bx+si],al	; 00003750  0000                              
add [bx+si],al	; 00003752  0000                              
add [bx+si],al	; 00003754  0000                              
add [bx+si],al	; 00003756  0000                              
add [bx+si],al	; 00003758  0000                              
add [bx+si],al	; 0000375A  0000                              
add [bx+si],al	; 0000375C  0000                              
add [bx+si],al	; 0000375E  0000                              
add [bx+si],al	; 00003760  0000                              
add [bx+si],al	; 00003762  0000                              
add [bx+si],al	; 00003764  0000                              
add [bx+si],al	; 00003766  0000                              
add [bx+si],al	; 00003768  0000                              
add [bx+si],al	; 0000376A  0000                              
add ah,bh	; 0000376C  00FC                              
add [bx+si],al	; 0000376E  0000                              
cld	; 00003770  FC                                
db 0xff	; 00003771  FF                                
db 0xff	; 00003772  FF                                
db 0xff	; 00003773  FF                                
cld	; 00003774  FC                                
aas	; 00003775  3F                                
db 0xff	; 00003776  FF                                
push ax	; 00003777  FFF0                              
ud0 di,di	; 00003779  0FFFFF                            
rol byte [bx+si],byte 0xff	; 0000377C  C000FF                            
cld	; 0000377F  FC                                
add [bx+si],al	; 00003780  0000                              
add [bx+si],al	; 00003782  0000                              
add [bx+si],al	; 00003784  0000                              
add [bx+si],al	; 00003786  0000                              
add [bx+si],al	; 00003788  0000                              
add [bx+si],al	; 0000378A  0000                              
add [bx+si],al	; 0000378C  0000                              
add [bx+si],al	; 0000378E  0000                              
add [bx+si],al	; 00003790  0000                              
add [bx+si],al	; 00003792  0000                              
add [bx+si],al	; 00003794  0000                              
add [bx+si],al	; 00003796  0000                              
add [bx+si],al	; 00003798  0000                              
add [bx+si],al	; 0000379A  0000                              
add [bx+si],al	; 0000379C  0000                              
add [bx+si],al	; 0000379E  0000                              
add [bx+si],al	; 000037A0  0000                              
add [bx+si],al	; 000037A2  0000                              
add [bx+si],al	; 000037A4  0000                              
add [bx+si],al	; 000037A6  0000                              
add bh,bh	; 000037A8  00FF                              
db 0xff	; 000037AA  FF                                
db 0xff	; 000037AB  FF                                
cld	; 000037AC  FC                                
db 0xff	; 000037AD  FF                                
db 0xff	; 000037AE  FF                                
db 0xff	; 000037AF  FF                                
cld	; 000037B0  FC                                
aas	; 000037B1  3F                                
db 0xff	; 000037B2  FF                                
push ax	; 000037B3  FFF0                              
add di,di	; 000037B5  03FF                              
inc word [bx+si]	; 000037B7  FF00                              
add [bx+si],al	; 000037B9  0000                              
add [bx+si],al	; 000037BB  0000                              
add [bx+si],al	; 000037BD  0000                              
add [bx+si],al	; 000037BF  0000                              
add [bx+si],al	; 000037C1  0000                              
add [bx+si],al	; 000037C3  0000                              
add [bx+si],al	; 000037C5  0000                              
add [bx+si],al	; 000037C7  0000                              
add [bx+si],al	; 000037C9  0000                              
add [bx+si],al	; 000037CB  0000                              
add [bx+si],al	; 000037CD  0000                              
add [bx+si],al	; 000037CF  0000                              
add [bx+si],al	; 000037D1  0000                              
add [bx+si],al	; 000037D3  0000                              
add [bx+si],al	; 000037D5  0000                              
add [bx+si],al	; 000037D7  0000                              
add [bx+si],al	; 000037D9  0000                              
add [bx+si],al	; 000037DB  0000                              
add [bx+si],al	; 000037DD  0000                              
add [bx+si],al	; 000037DF  0000                              
add [bx],bh	; 000037E1  003F                              
lock add [bx],bh	; 000037E3  F0003F                            
db 0xff	; 000037E6  FF                                
push ax	; 000037E7  FFF0                              
db 0xff	; 000037E9  FF                                
db 0xff	; 000037EA  FF                                
db 0xff	; 000037EB  FF                                
cld	; 000037EC  FC                                
ud0 di,di	; 000037ED  0FFFFF                            
rol byte [bx+si],byte 0x0	; 000037F0  C00000                            
add [bx+si],al	; 000037F3  0000                              
add [bx+si],al	; 000037F5  0000                              
add [bx+si],al	; 000037F7  0000                              
add [bx+si],al	; 000037F9  0000                              
add [bx+si],al	; 000037FB  0000                              
add [bx+si],al	; 000037FD  0000                              
add [bx+si],al	; 000037FF  0000                              
add [bx+si],al	; 00003801  0000                              
add [bx+si],al	; 00003803  0000                              
add [bx+si],al	; 00003805  0000                              
add [bx+si],al	; 00003807  0000                              
add [bx+si],al	; 00003809  0000                              
add [bx+si],al	; 0000380B  0000                              
add [bx+si],al	; 0000380D  0000                              
add [bx+si],al	; 0000380F  0000                              
add [bx+si],al	; 00003811  0000                              
add [bx+si],al	; 00003813  0000                              
add [bx+si],al	; 00003815  0000                              
add [bx+si],al	; 00003817  0000                              
add [bx],cl	; 00003819  000F                              
rol byte [bx+si],byte 0x0	; 0000381B  C00000                            
db 0xff	; 0000381E  FF                                
cld	; 0000381F  FC                                
add [bx],bh	; 00003820  003F                              
db 0xff	; 00003822  FF                                
push ax	; 00003823  FFF0                              
aas	; 00003825  3F                                
db 0xff	; 00003826  FF                                
push ax	; 00003827  FFF0                              
add [bx+si],al	; 00003829  0000                              
add [bx+si],al	; 0000382B  0000                              
add [bx+si],al	; 0000382D  0000                              
add [bx+si],al	; 0000382F  0000                              
add [bx+si],al	; 00003831  0000                              
add [bx+si],al	; 00003833  0000                              
add [bx+si],al	; 00003835  0000                              
add [bx+si],al	; 00003837  0000                              
add [bx+si],al	; 00003839  0000                              
add [bx+si],al	; 0000383B  0000                              
add [bx+si],al	; 0000383D  0000                              
add [bx+si],al	; 0000383F  0000                              
add [bx+si],al	; 00003841  0000                              
add [bx+si],al	; 00003843  0000                              
add [bx+si],al	; 00003845  0000                              
add [bx+si],al	; 00003847  0000                              
add [bx+si],al	; 00003849  0000                              
add [bx+si],al	; 0000384B  0000                              
add [bx+si],al	; 0000384D  0000                              
add [bx+si],al	; 0000384F  0000                              
add [bp+di],al	; 00003851  0003                              
add [bx+si],al	; 00003853  0000                              
add [bx],bh	; 00003855  003F                              
lock add [bp+di],al	; 00003857  F00003                            
db 0xff	; 0000385A  FF                                
inc word [bx+si]	; 0000385B  FF00                              
ud0 di,di	; 0000385D  0FFFFF                            
sar byte [bx],byte 0xc0	; 00003860  C03FC0                            
db 0x0f	; 00003863  0F                                
lock add [bx+si],al	; 00003864  F00000                            
add [bx+si],al	; 00003867  0000                              
add [bx+si],al	; 00003869  0000                              
add [bx+si],al	; 0000386B  0000                              
add [bx+si],al	; 0000386D  0000                              
add [bx+si],al	; 0000386F  0000                              
add [bx+si],al	; 00003871  0000                              
add [bx+si],al	; 00003873  0000                              
add [bx+si],al	; 00003875  0000                              
add [bx+si],al	; 00003877  0000                              
add [bx+si],al	; 00003879  0000                              
add [bx+si],al	; 0000387B  0000                              
add [bx+si],al	; 0000387D  0000                              
add [bx+si],al	; 0000387F  0000                              
add [bx+si],al	; 00003881  0000                              
add [bx+si],al	; 00003883  0000                              
add [bx+si],al	; 00003885  0000                              
add [bx+si],al	; 00003887  0000                              
add [bp+di],al	; 00003889  0003                              
add [bx+si],al	; 0000388B  0000                              
add [bx],cl	; 0000388D  000F                              
rol byte [bx+si],byte 0x0	; 0000388F  C00000                            
aas	; 00003892  3F                                
lock add [bp+di],al	; 00003893  F00003                            
db 0xff	; 00003896  FF                                
inc word [bx+si]	; 00003897  FF00                              
db 0x0f	; 00003899  0F                                
lock	; 0000389A  F0                                
aas	; 0000389B  3F                                
rol byte [bx+si],byte 0x0	; 0000389C  C00000                            
add [bx+si],al	; 0000389F  0000                              
add [bx+si],al	; 000038A1  0000                              
add [bx+si],al	; 000038A3  0000                              
add [bx+si],al	; 000038A5  0000                              
add [bx+si],al	; 000038A7  0000                              
add [bx+si],al	; 000038A9  0000                              
add [bx+si],al	; 000038AB  0000                              
add [bx+si],al	; 000038AD  0000                              
add [bx+si],al	; 000038AF  0000                              
add [bx+si],al	; 000038B1  0000                              
add [bx+si],al	; 000038B3  0000                              
add [bx+si],al	; 000038B5  0000                              
add [bx+si],al	; 000038B7  0000                              
add [bx+si],al	; 000038B9  0000                              
add [bx+si],al	; 000038BB  0000                              
add [bx+si],al	; 000038BD  0000                              
add [bx+si],al	; 000038BF  0000                              
add [bp+di],al	; 000038C1  0003                              
add [bx+si],al	; 000038C3  0000                              
add [bx],cl	; 000038C5  000F                              
rol byte [bx+si],byte 0x0	; 000038C7  C00000                            
aas	; 000038CA  3F                                
lock add [bx+si],al	; 000038CB  F00000                            
aas	; 000038CE  3F                                
lock add [bx+si],al	; 000038CF  F00000                            
lock	; 000038D2  F0                                
cmp al,0x0	; 000038D3  3C00                              
add ax,ax	; 000038D5  03C0                              
sldt word [bx+si]	; 000038D7  0F0000                            
add [bx+si],al	; 000038DA  0000                              
add [bx+si],al	; 000038DC  0000                              
add [bx+si],al	; 000038DE  0000                              
add [bx+si],al	; 000038E0  0000                              
add [bx+si],al	; 000038E2  0000                              
add [bx+si],al	; 000038E4  0000                              
add [bx+si],al	; 000038E6  0000                              
add [bx+si],al	; 000038E8  0000                              
add [bx+si],al	; 000038EA  0000                              
add [bx+si],al	; 000038EC  0000                              
add [bx+si],al	; 000038EE  0000                              
add [bx+si],al	; 000038F0  0000                              
add [bx+si],al	; 000038F2  0000                              
add [bx+si],al	; 000038F4  0000                              
add [bx+si],al	; 000038F6  0000                              
add [bx+si],al	; 000038F8  0000                              
add ax,[bx+si]	; 000038FA  0300                              
add [bx+si],al	; 000038FC  0000                              
add ax,[bx+si]	; 000038FE  0300                              
add [bx+si],al	; 00003900  0000                              
xadd [bx+si],al	; 00003902  0FC000                            
add [bx],bh	; 00003905  003F                              
lock add [bx+si],al	; 00003907  F00000                            
cmp al,0xf0	; 0000390A  3CF0                              
add [bx+si],al	; 0000390C  0000                              
lock	; 0000390E  F0                                
cmp al,0x0	; 0000390F  3C00                              
add al,al	; 00003911  00C0                              
or al,0x0	; 00003913  0C00                              
add [bx+si],al	; 00003915  0000                              
add [bx+si],al	; 00003917  0000                              
add [bx+si],al	; 00003919  0000                              
add [bx+si],al	; 0000391B  0000                              
add [bx+si],al	; 0000391D  0000                              
add [bx+si],al	; 0000391F  0000                              
add [bx+si],al	; 00003921  0000                              
add [bx+si],al	; 00003923  0000                              
add [bx+si],al	; 00003925  0000                              
add [bx+si],al	; 00003927  0000                              
add [bx+si],al	; 00003929  0000                              
add [bx+si],al	; 0000392B  0000                              
add [bx+si],al	; 0000392D  0000                              
add [bx+si],al	; 0000392F  0000                              
add [bx+si],al	; 00003931  0000                              
add [bx+si],al	; 00003933  0000                              
add [bp+di],al	; 00003935  0003                              
add [bx+si],al	; 00003937  0000                              
add [bp+di],al	; 00003939  0003                              
add [bx+si],al	; 0000393B  0000                              
add [bx],cl	; 0000393D  000F                              
rol byte [bx+si],byte 0x0	; 0000393F  C00000                            
or al,0xc0	; 00003942  0CC0                              
add [bx+si],al	; 00003944  0000                              
add [bx+si],al	; 00003946  0000                              
add [bx+si],al	; 00003948  0000                              
xor [bx+si],dh	; 0000394A  3030                              
add [bx+si],al	; 0000394C  0000                              
add [bx+si],al	; 0000394E  0000                              
add [bx+si],al	; 00003950  0000                              
add [bx+si],al	; 00003952  0000                              
add [bx+si],al	; 00003954  0000                              
add [bx+si],al	; 00003956  0000                              
add [bx+si],al	; 00003958  0000                              
add [bx+si],al	; 0000395A  0000                              
add [bx+si],al	; 0000395C  0000                              
add [bx+si],al	; 0000395E  0000                              
add [bx+si],al	; 00003960  0000                              
add [bx+si],al	; 00003962  0000                              
add [bx+si],al	; 00003964  0000                              
add [bx+si],al	; 00003966  0000                              
add [bx+si],al	; 00003968  0000                              
add [bx+si],al	; 0000396A  0000                              
add [bx+si],al	; 0000396C  0000                              
add ax,[bx+si]	; 0000396E  0300                              
add [bx+si],al	; 00003970  0000                              
add ax,[bx+si]	; 00003972  0300                              
add [bx+si],al	; 00003974  0000                              
add ax,[bx+si]	; 00003976  0300                              
add [bx+si],al	; 00003978  0000                              
add ax,[bx+si]	; 0000397A  0300                              
add [bx+si],al	; 0000397C  0000                              
add [bx+si],al	; 0000397E  0000                              
add [bx+si],al	; 00003980  0000                              
add [bx+si],al	; 00003982  0000                              
add [bx+si],al	; 00003984  0000                              
add al,al	; 00003986  00C0                              
add [bx+si],al	; 00003988  0000                              
add al,al	; 0000398A  00C0                              
add [bx+si],al	; 0000398C  0000                              
rol al,byte 0xc0	; 0000398E  C0C0C0                            
add [bx+si],dh	; 00003991  0030                              
ret	; 00003993  C3                                
add [bx+si],al	; 00003994  0000                              
or al,0xc	; 00003996  0C0C                              
add [bx+si],al	; 00003998  0000                              
add [bx+si],al	; 0000399A  0000                              
add [bx],cl	; 0000399C  000F                              
lock	; 0000399E  F0                                
add di,sp	; 0000399F  03FC                              
add [bx+si],al	; 000039A1  0000                              
add [bx+si],al	; 000039A3  0000                              
add [si],cl	; 000039A5  000C                              
or al,0x0	; 000039A7  0C00                              
add [bx+si],dh	; 000039A9  0030                              
ret	; 000039AB  C3                                
add [bx+si],al	; 000039AC  0000                              
rol al,byte 0xc0	; 000039AE  C0C0C0                            
add [bx+si],al	; 000039B1  0000                              
rol byte [bx+si],byte 0x0	; 000039B3  C00000                            
add al,al	; 000039B6  00C0                              
add [bx+si],al	; 000039B8  0000                              
add [bx+si],al	; 000039BA  0000                              
add [bx+si],al	; 000039BC  0000                              
add al,al	; 000039BE  00C0                              
add [bx+si],al	; 000039C0  0000                              
add al,al	; 000039C2  00C0                              
add [bx+si],al	; 000039C4  0000                              
rol al,byte 0xc0	; 000039C6  C0C0C0                            
add [bx+si],dh	; 000039C9  0030                              
ret	; 000039CB  C3                                
add [bx+si],al	; 000039CC  0000                              
or al,0xc	; 000039CE  0C0C                              
add [bx+si],al	; 000039D0  0000                              
add [bx+si],al	; 000039D2  0000                              
add [bx],cl	; 000039D4  000F                              
lock	; 000039D6  F0                                
add di,sp	; 000039D7  03FC                              
add [bx+si],al	; 000039D9  0000                              
add [bx+si],al	; 000039DB  0000                              
add [si],cl	; 000039DD  000C                              
or al,0x0	; 000039DF  0C00                              
add [bx+si],dh	; 000039E1  0030                              
ret	; 000039E3  C3                                
add [bx+si],al	; 000039E4  0000                              
rol al,byte 0xc0	; 000039E6  C0C0C0                            
add [bx+si],al	; 000039E9  0000                              
rol byte [bx+si],byte 0x0	; 000039EB  C00000                            
add al,al	; 000039EE  00C0                              
add [bx+si],al	; 000039F0  0000                              
add [bx+si],al	; 000039F2  0000                              
add [bx+si],al	; 000039F4  0000                              
add [bx+si],al	; 000039F6  0000                              
add [bx+si],al	; 000039F8  0000                              
add [bx+si],al	; 000039FA  0000                              
add [bx+si],al	; 000039FC  0000                              
add [bx+si],al	; 000039FE  0000                              
add [bx+si],al	; 00003A00  0000                              
add [bx+si],al	; 00003A02  0000                              
add [bx+si],al	; 00003A04  0000                              
add [bx+si],al	; 00003A06  0000                              
add [bx+si],al	; 00003A08  0000                              
add [bx+si],al	; 00003A0A  0000                              
add [bx+si],al	; 00003A0C  0000                              
add [bx+si],al	; 00003A0E  0000                              
add [bx+si],al	; 00003A10  0000                              
add [bx+si],al	; 00003A12  0000                              
add [bx+si],al	; 00003A14  0000                              
add [bx+si],al	; 00003A16  0000                              
add [bx+si],al	; 00003A18  0000                              
add [bx+si],al	; 00003A1A  0000                              
add [bx+si],al	; 00003A1C  0000                              
add [bx+si],al	; 00003A1E  0000                              
add [bx+si],al	; 00003A20  0000                              
add [bx+si],al	; 00003A22  0000                              
add [bx+si],al	; 00003A24  0000                              
add [bx+si],al	; 00003A26  0000                              
add [bx+si],al	; 00003A28  0000                              
add [bx+si],al	; 00003A2A  0000                              
add [bx+si],al	; 00003A2C  0000                              
jpe 0x3a5e	; 00003A2E  7A2E                              
sbb [0x7600],cx	; 00003A30  190E0076                          
cs push cs	; 00003A34  2E0E                              
push cs	; 00003A36  0E                                
add [bx+si],al	; 00003A37  0000                              
add [bx+si],al	; 00003A39  0000                              
add [bx+si],al	; 00003A3B  0000                              
add [bx+si],al	; 00003A3D  0000                              
add [bx+si],al	; 00003A3F  0000                              
add [bx+si],al	; 00003A41  0000                              
add [bx+si],al	; 00003A43  0000                              
add [bx+si],al	; 00003A45  0000                              
add [bx+si],al	; 00003A47  0000                              
add [bx+si],al	; 00003A49  0000                              
add [bx+si],al	; 00003A4B  0000                              
add [bx+si],al	; 00003A4D  0000                              
add [bx+si],al	; 00003A4F  0000                              
add [bx+si],al	; 00003A51  0000                              
add [bx+si],al	; 00003A53  0000                              
add [bx+si],al	; 00003A55  0000                              
add [bx+si],al	; 00003A57  0000                              
add [bx+si],al	; 00003A59  0000                              
add [bx+si],al	; 00003A5B  0000                              
add [bx+si],al	; 00003A5D  0000                              
add [bx+si],al	; 00003A5F  0000                              
add [bx+si],al	; 00003A61  0000                              
add [bx+si],al	; 00003A63  0000                              
add [bx+si],al	; 00003A65  0000                              
add [bx+si],al	; 00003A67  0000                              
add [bx+si],al	; 00003A69  0000                              
add [bx+si],al	; 00003A6B  0000                              
add [bx+si],al	; 00003A6D  0000                              
add [bx+si],al	; 00003A6F  0000                              
add [bx+si],al	; 00003A71  0000                              
add [bx+si],al	; 00003A73  0000                              
add [bx+si],al	; 00003A75  0000                              
add [bx+si],al	; 00003A77  0000                              
add [bx+si],al	; 00003A79  0000                              
add [bx+si],al	; 00003A7B  0000                              
add [bx+si],al	; 00003A7D  0000                              
add [bx+si],al	; 00003A7F  0000                              
add [bx+si],al	; 00003A81  0000                              
add [bx+si],al	; 00003A83  0000                              
add [bx+si],al	; 00003A85  0000                              
add [bx+si],al	; 00003A87  0000                              
add [bx+si],al	; 00003A89  0000                              
add [bx+si],al	; 00003A8B  0000                              
add [bx+si],al	; 00003A8D  0000                              
add [bx+si],al	; 00003A8F  0000                              
add [bx+si],al	; 00003A91  0000                              
add [bx+si],al	; 00003A93  0000                              
add [bx+si],al	; 00003A95  0000                              
add [bx+si],al	; 00003A97  0000                              
add [bx+si],al	; 00003A99  0000                              
add [bx+si],al	; 00003A9B  0000                              
add [bx+si],al	; 00003A9D  0000                              
add [bx+si],al	; 00003A9F  0000                              
add [bx+si],al	; 00003AA1  0000                              
add [bx+si],al	; 00003AA3  0000                              
add [bx+si],al	; 00003AA5  0000                              
add [bx+si],al	; 00003AA7  0000                              
add ch,[di+0x30]	; 00003AA9  026D30                            
sbb ah,[0x6d00]	; 00003AAC  1A26006D                          
xor [0xe],cl	; 00003AB0  300E0E00                          
add al,0x0	; 00003AB4  0400                              
add [bx+si],al	; 00003AB6  0000                              
add [bx+si],al	; 00003AB8  0000                              
add [bx+si],al	; 00003ABA  0000                              
add [bx+si],al	; 00003ABC  0000                              
add [bx+si],al	; 00003ABE  0000                              
add [bx+si],al	; 00003AC0  0000                              
add [bx+si],al	; 00003AC2  0000                              
add [bx+si],al	; 00003AC4  0000                              
add [bx+si],al	; 00003AC6  0000                              
add [bx+si],al	; 00003AC8  0000                              
add [bx+si],al	; 00003ACA  0000                              
add [bx+si],al	; 00003ACC  0000                              
add [bx+si],al	; 00003ACE  0000                              
add [bx+si],al	; 00003AD0  0000                              
add [bx+si],al	; 00003AD2  0000                              
add [bx+si],al	; 00003AD4  0000                              
add [bx+si],al	; 00003AD6  0000                              
add [bx+si],al	; 00003AD8  0000                              
add [bx+si],al	; 00003ADA  0000                              
add [bx+si],al	; 00003ADC  0000                              
add [bx+si],al	; 00003ADE  0000                              
add [bx+si],al	; 00003AE0  0000                              
add [bx+si],al	; 00003AE2  0000                              
add [bx+si],al	; 00003AE4  0000                              
add [bx+si],al	; 00003AE6  0000                              
add [bx+si],al	; 00003AE8  0000                              
add [bx+si],al	; 00003AEA  0000                              
add [bx+si],al	; 00003AEC  0000                              
add [bx+si],al	; 00003AEE  0000                              
add [bx+si],al	; 00003AF0  0000                              
add [bx+si],al	; 00003AF2  0000                              
add [bx+si],al	; 00003AF4  0000                              
add [bx+si],al	; 00003AF6  0000                              
add [bx+si],al	; 00003AF8  0000                              
add [bx+si],al	; 00003AFA  0000                              
add [bx+si],al	; 00003AFC  0000                              
add [bx+si],al	; 00003AFE  0000                              
add [bx+si],al	; 00003B00  0000                              
add [bx+si],al	; 00003B02  0000                              
add [bx+si],al	; 00003B04  0000                              
add [bx+si],al	; 00003B06  0000                              
add [bx+si],al	; 00003B08  0000                              
add [bx+si],al	; 00003B0A  0000                              
add [bx+si],al	; 00003B0C  0000                              
add [bx+si],al	; 00003B0E  0000                              
add [bx+si],al	; 00003B10  0000                              
add [bx+si],al	; 00003B12  0000                              
add [bx+si],al	; 00003B14  0000                              
add [bx+si],al	; 00003B16  0000                              
add [bx+si],al	; 00003B18  0000                              
add [bx+si],al	; 00003B1A  0000                              
add [bx+si],al	; 00003B1C  0000                              
add [bx+si],al	; 00003B1E  0000                              
add [bx+si],al	; 00003B20  0000                              
add [bx+si],al	; 00003B22  0000                              
add [bp+di],al	; 00003B24  0003                              
mov bp,[0x261a]	; 00003B26  8B2E1A26                          
add [bp+di+0xe2e],cl	; 00003B2A  008B2E0E                          
push cs	; 00003B2E  0E                                
add [si],al	; 00003B2F  0004                              
add [bx+si],al	; 00003B31  0000                              
add [bx+si],al	; 00003B33  0000                              
add [bx+si],al	; 00003B35  0000                              
add [bx+si],al	; 00003B37  0000                              
add [bx+si],al	; 00003B39  0000                              
add [bx+si],al	; 00003B3B  0000                              
add [bx+si],al	; 00003B3D  0000                              
add [bx+si],al	; 00003B3F  0000                              
add [bx+si],al	; 00003B41  0000                              
add [bx+si],al	; 00003B43  0000                              
add [bx+si],al	; 00003B45  0000                              
add [bx+si],al	; 00003B47  0000                              
add [bx+si],al	; 00003B49  0000                              
add [bx+si],al	; 00003B4B  0000                              
add [bx+si],al	; 00003B4D  0000                              
add [bx+si],al	; 00003B4F  0000                              
add [bx+si],al	; 00003B51  0000                              
add [bx+si],al	; 00003B53  0000                              
add [bx+si],al	; 00003B55  0000                              
add [bx+si],al	; 00003B57  0000                              
add [bx+si],al	; 00003B59  0000                              
add [bx+si],al	; 00003B5B  0000                              
add [bx+si],al	; 00003B5D  0000                              
add [bx+si],al	; 00003B5F  0000                              
add [bx+si],al	; 00003B61  0000                              
add [bx+si],al	; 00003B63  0000                              
add [bx+si],al	; 00003B65  0000                              
add [bx+si],al	; 00003B67  0000                              
add [bx+si],al	; 00003B69  0000                              
add [bx+si],al	; 00003B6B  0000                              
add [bx+si],al	; 00003B6D  0000                              
add [bx+si],al	; 00003B6F  0000                              
add [bx+si],al	; 00003B71  0000                              
add [bx+si],al	; 00003B73  0000                              
add [bx+si],al	; 00003B75  0000                              
add [bx+si],al	; 00003B77  0000                              
add [bx+si],al	; 00003B79  0000                              
add [bx+si],al	; 00003B7B  0000                              
add [bx+si],al	; 00003B7D  0000                              
add [bx+si],al	; 00003B7F  0000                              
add [bx+si],al	; 00003B81  0000                              
add [bx+si],al	; 00003B83  0000                              
add [bx+si],al	; 00003B85  0000                              
add [bx+si],al	; 00003B87  0000                              
add [bx+si],al	; 00003B89  0000                              
add [bx+si],al	; 00003B8B  0000                              
add [bx+si],al	; 00003B8D  0000                              
add [bx+si],al	; 00003B8F  0000                              
add [bx+si],al	; 00003B91  0000                              
add [bx+si],al	; 00003B93  0000                              
add [bx+si],al	; 00003B95  0000                              
add [bx+si],al	; 00003B97  0000                              
add [bx+si],al	; 00003B99  0000                              
add [bx+si],al	; 00003B9B  0000                              
add [bx+si],al	; 00003B9D  0000                              
add [bx+si],al	; 00003B9F  0000                              
add [bp+si+0x192e],dl	; 00003BA1  00922E19                          
add [es:bp+si+0xe2e],dl	; 00003BA5  2600922E0E                        
push cs	; 00003BAA  0E                                
add [bx+si],al	; 00003BAB  0000                              
add [bx+si],al	; 00003BAD  0000                              
add [bx+si],al	; 00003BAF  0000                              
add [bx+si],al	; 00003BB1  0000                              
add [bx+si],al	; 00003BB3  0000                              
add [bx+si],al	; 00003BB5  0000                              
add [bx+si],al	; 00003BB7  0000                              
add [bx+si],al	; 00003BB9  0000                              
add [bx+si],al	; 00003BBB  0000                              
add [bx+si],al	; 00003BBD  0000                              
add [bx+si],al	; 00003BBF  0000                              
add [bx+si],al	; 00003BC1  0000                              
add [bx+si],al	; 00003BC3  0000                              
add [bx+si],al	; 00003BC5  0000                              
add [bx+si],al	; 00003BC7  0000                              
add [bx+si],al	; 00003BC9  0000                              
add [bx+si],al	; 00003BCB  0000                              
add [bx+si],al	; 00003BCD  0000                              
add [bx+si],al	; 00003BCF  0000                              
add [bx+si],al	; 00003BD1  0000                              
add [bx+si],al	; 00003BD3  0000                              
add [bx+si],al	; 00003BD5  0000                              
add [bx+si],al	; 00003BD7  0000                              
add [bx+si],al	; 00003BD9  0000                              
add [bx+si],al	; 00003BDB  0000                              
add [bx+si],al	; 00003BDD  0000                              
add [bx+si],al	; 00003BDF  0000                              
add [bx+si],al	; 00003BE1  0000                              
add [bx+si],al	; 00003BE3  0000                              
add [bx+si],al	; 00003BE5  0000                              
add [bx+si],al	; 00003BE7  0000                              
add [bx+si],al	; 00003BE9  0000                              
add [bx+si],al	; 00003BEB  0000                              
add [bx+si],al	; 00003BED  0000                              
add [bx+si],al	; 00003BEF  0000                              
add [bx+si],al	; 00003BF1  0000                              
add [bx+si],al	; 00003BF3  0000                              
add [bx+si],al	; 00003BF5  0000                              
add [bx+si],al	; 00003BF7  0000                              
add [bx+si],al	; 00003BF9  0000                              
add [bx+si],al	; 00003BFB  0000                              
add [bx+si],al	; 00003BFD  0000                              
add [bx+si],al	; 00003BFF  0000                              
add [bx+si],al	; 00003C01  0000                              
add [bx+si],al	; 00003C03  0000                              
add [bx+si],al	; 00003C05  0000                              
add [bx+si],al	; 00003C07  0000                              
add [bx+si],al	; 00003C09  0000                              
add [bx+si],al	; 00003C0B  0000                              
add [bx+si],al	; 00003C0D  0000                              
add [bx+si],al	; 00003C0F  0000                              
add [bx+si],al	; 00003C11  0000                              
add [bx+si],al	; 00003C13  0000                              
add [bx+si],al	; 00003C15  0000                              
add [bx+si],al	; 00003C17  0000                              
add [bx+si],al	; 00003C19  0000                              
add [bx+si],al	; 00003C1B  0000                              
add ch,[di+0x1a2c]	; 00003C1D  02AD2C1A                          
add [es:di+0xe2c],ch	; 00003C21  2600AD2C0E                        
push cs	; 00003C26  0E                                
add [si],al	; 00003C27  0004                              
add [bx+si],al	; 00003C29  0000                              
add [bx+si],al	; 00003C2B  0000                              
add [bx+si],al	; 00003C2D  0000                              
add [bx+si],al	; 00003C2F  0000                              
add [bx+si],al	; 00003C31  0000                              
add [bx+si],al	; 00003C33  0000                              
add [bx+si],al	; 00003C35  0000                              
add [bx+si],al	; 00003C37  0000                              
add [bx+si],al	; 00003C39  0000                              
add [bx+si],al	; 00003C3B  0000                              
add [bx+si],al	; 00003C3D  0000                              
add [bx+si],al	; 00003C3F  0000                              
add [bx+si],al	; 00003C41  0000                              
add [bx+si],al	; 00003C43  0000                              
add [bx+si],al	; 00003C45  0000                              
add [bx+si],al	; 00003C47  0000                              
add [bx+si],al	; 00003C49  0000                              
add [bx+si],al	; 00003C4B  0000                              
add [bx+si],al	; 00003C4D  0000                              
add [bx+si],al	; 00003C4F  0000                              
add [bx+si],al	; 00003C51  0000                              
add [bx+si],al	; 00003C53  0000                              
add [bx+si],al	; 00003C55  0000                              
add [bx+si],al	; 00003C57  0000                              
add [bx+si],al	; 00003C59  0000                              
add [bx+si],al	; 00003C5B  0000                              
add [bx+si],al	; 00003C5D  0000                              
add [bx+si],al	; 00003C5F  0000                              
add [bx+si],al	; 00003C61  0000                              
add [bx+si],al	; 00003C63  0000                              
add [bx+si],al	; 00003C65  0000                              
add [bx+si],al	; 00003C67  0000                              
add [bx+si],al	; 00003C69  0000                              
add [bx+si],al	; 00003C6B  0000                              
add [bx+si],al	; 00003C6D  0000                              
add [bx+si],al	; 00003C6F  0000                              
add [bx+si],al	; 00003C71  0000                              
add [bx+si],al	; 00003C73  0000                              
add [bx+si],al	; 00003C75  0000                              
add [bx+si],al	; 00003C77  0000                              
add [bx+si],al	; 00003C79  0000                              
add [bx+si],al	; 00003C7B  0000                              
add [bx+si],al	; 00003C7D  0000                              
add [bx+si],al	; 00003C7F  0000                              
add [bx+si],al	; 00003C81  0000                              
add [bx+si],al	; 00003C83  0000                              
add [bx+si],al	; 00003C85  0000                              
add [bx+si],al	; 00003C87  0000                              
add [bx+si],al	; 00003C89  0000                              
add [bx+si],al	; 00003C8B  0000                              
add [bx+si],al	; 00003C8D  0000                              
add [bx+si],al	; 00003C8F  0000                              
add [bx+si],al	; 00003C91  0000                              
add [bx+si],al	; 00003C93  0000                              
add [bx+si],al	; 00003C95  0000                              
add [bx+si],al	; 00003C97  0000                              
out byte 0xc8,al	; 00003C99  E6C8                              
add [bx+si],al	; 00003C9B  0000                              
add [bx+si],bh	; 00003C9D  0038                              
add [bx+si+0x0],dh	; 00003C9F  007000                            
test al,0x0	; 00003CA2  A800                              
loopne 0x3ca6	; 00003CA4  E000                              
sbb [bx+di],al	; 00003CA6  1801                              
push ax	; 00003CA8  50                                
add [bx+si-0x3fff],cx	; 00003CA9  018801C0                          
add ax,di	; 00003CAD  01F8                              
add [bx+si],si	; 00003CAF  0130                              
add ch,[bx+si+0x2]	; 00003CB1  026802                            
mov al,[0xd802]	; 00003CB4  A002D8                            
add dl,[bx+si]	; 00003CB7  0210                              
add cx,[bx+si+0x3]	; 00003CB9  034803                            
add dl,ah	; 00003CBC  00E2                              
push ds	; 00003CBE  1E                                
inc word [bx+di]	; 00003CBF  FF01                              
pusha	; 00003CC1  60                                
jmp word near [bx+si-0x100]	; 00003CC2  FFA000FF                          
inc word [bx+di]	; 00003CC6  FF01                              
add [bx+si],al	; 00003CC8  0000                              
add [0x1],cl	; 00003CCA  000E0100                          
add [bx+si],al	; 00003CCE  0000                              
add al,[bx+si]	; 00003CD0  0200                              
add al,[bx+si]	; 00003CD2  0200                              
jcxz 0x3cde	; 00003CD4  E308                              
sub [bp+si],cl	; 00003CD6  280A                              
db 0xd9	; 00003CD8  D9                                
or dx,[di+0xd]	; 00003CD9  0B550D                            
db 0xc6	; 00003CDC  C6                                
adc cx,bx	; 00003CDD  11D9                              
or dx,[di+0xd]	; 00003CDF  0B550D                            
cmp al,0xf	; 00003CE2  3C0F                              
db 0xc6	; 00003CE4  C6                                
adc di,di	; 00003CE5  11FF                              
adc bp,[bx+di-0x39e6]	; 00003CE7  13A91AC6                          
adc di,di	; 00003CEB  11FF                              
adc bx,dx	; 00003CED  13DA                              
push ss	; 00003CEF  16                                
test ax,0xfe1a	; 00003CF0  A91AFE                            
sbb ax,0x27fe	; 00003CF3  1DFE27                            
test ax,0xfe1a	; 00003CF6  A91AFE                            
sbb ax,0x2247	; 00003CF9  1D4722                            
db 0xfe	; 00003CFC  FE                                
daa	; 00003CFD  27                                
std	; 00003CFE  FD                                
sub al,0xfc	; 00003CFF  2CFC                              
cmp di,si	; 00003D01  3BFE                              
daa	; 00003D03  27                                
add al,[bx+si]	; 00003D04  0200                              
lock	; 00003D06  F0                                
add ax,0x3f6	; 00003D07  05F603                            
add al,[bx+si]	; 00003D0A  0200                              
lock	; 00003D0C  F0                                
add ax,0x3f6	; 00003D0D  05F603                            
add al,[bx+si]	; 00003D10  0200                              
add al,[bx+si]	; 00003D12  0200                              
push word 0x30	; 00003D14  6A30                              
outsb	; 00003D16  6E                                
xor [bp+si-0x71d2],cl	; 00003D17  308A2E8E                          
mov ch,[cs:0x2e8e]	; 00003D1B  2E8A2E8E2E                        
stosb	; 00003D20  AA                                
sub al,0xae	; 00003D21  2CAE                              
sub al,0x0	; 00003D23  2C00                              
add [si],bh	; 00003D25  003C                              
add [bx+si],ah	; 00003D27  0020                              
cmp al,0x0	; 00003D29  3C00                              
add [bx+si],al	; 00003D2B  0000                              
add [bx+si],al	; 00003D2D  0000                              
add [di],ax	; 00003D2F  0105                              
add [bx+di],cl	; 00003D31  0009                              
pusha	; 00003D33  60                                
add [bx+si],al	; 00003D34  0000                              
and ax,0xa8	; 00003D36  25A800                            
add [bx+si+0x15],ch	; 00003D39  006815                            
add [bx+si],al	; 00003D3C  0000                              
push ax	; 00003D3E  50                                
or [bx+si],ax	; 00003D3F  0900                              
add [bx+si+0xa],dl	; 00003D41  00900A00                          
add [bx+si+0x6],ah	; 00003D45  00A00600                          
add [bx+si+0x0],ah	; 00003D49  006000                            
add [bx+si],al	; 00003D4C  0000                              
push ax	; 00003D4E  50                                
add [bx+si],al	; 00003D4F  0000                              
add [bx+si+0x0],dl	; 00003D51  00900000                          
add [bx+si+0x0],ah	; 00003D55  00A00000                          
add [bx+si+0x0],ah	; 00003D59  006000                            
add [bx+si],al	; 00003D5C  0000                              
push ax	; 00003D5E  50                                
add [bx+si],al	; 00003D5F  0000                              
add [bx+si+0x0],dl	; 00003D61  00900000                          
add [bx+si+0x0],ah	; 00003D65  00A00000                          
add [bp+di],al	; 00003D69  0003                              
add [bx+si],al	; 00003D6B  0000                              
add [bx+si],al	; 00003D6D  0000                              
add [bx],al	; 00003D6F  0007                              
stosb	; 00003D71  AA                                
stosb	; 00003D72  AA                                
mov al,[0xa207]	; 00003D73  A007A2                            
stosb	; 00003D76  AA                                
mov al,[0xaa07]	; 00003D77  A007AA                            
stosb	; 00003D7A  AA                                
and [bx],al	; 00003D7B  2007                              
stosb	; 00003D7D  AA                                
mov ah,[bx+si-0x15f9]	; 00003D7E  8AA007EA                          
stosb	; 00003D82  AA                                
mov al,[0xe205]	; 00003D83  A005E2                            
stosb	; 00003D86  AA                                
mov al,[0xea01]	; 00003D87  A001EA                            
stosb	; 00003D8A  AA                                
mov al,[0xfa01]	; 00003D8B  A001FA                            
mov [0x1a0],al	; 00003D8E  A2A001                            
jng 0x3d3d	; 00003D91  7EAA                              
mov al,[0x5f00]	; 00003D93  A0005F                            
cli	; 00003D96  FA                                
mov al,[0x1500]	; 00003D97  A00015                            
jg 0x3d8c	; 00003D9A  7FF0                              
add [bx+si],al	; 00003D9C  0000                              
push bp	; 00003D9E  55                                
push ax	; 00003D9F  50                                
add [bx+si],al	; 00003DA0  0000                              
add [bx+si],al	; 00003DA2  0000                              
add [0x0],al	; 00003DA4  00060000                          
add [bx+si],al	; 00003DA8  0000                              
inc ax	; 00003DAA  40                                
add [bx+si],al	; 00003DAB  0000                              
add [bx+si+0x0],al	; 00003DAD  004000                            
add [bx+di],al	; 00003DB0  0001                              
inc ax	; 00003DB2  40                                
add [bx+si],al	; 00003DB3  0000                              
add ax,[bx+si+0x0]	; 00003DB5  034000                            
add [bx],cl	; 00003DB8  000F                              
rol byte [bx+si],byte 0x0	; 00003DBA  C00000                            
aas	; 00003DBD  3F                                
rol byte [bx+si],byte 0x0	; 00003DBE  C00000                            
inc word [bx+si]	; 00003DC1  FF00                              
add [bp+di],al	; 00003DC3  0003                              
fild word [bx+si]	; 00003DC5  DF00                              
add [bx],cl	; 00003DC7  000F                              
jl 0x3dcb	; 00003DC9  7C00                              
add [di],bh	; 00003DCB  003D                              
lock add [bx+si],al	; 00003DCD  F00000                            
test ax,0xf00	; 00003DD0  F7C0000F                          
inc word [bx+si]	; 00003DD4  FF00                              
add [bx],dl	; 00003DD6  0017                              
lock add [bx+si],al	; 00003DD8  F00000                            
add [bx+si],al	; 00003DDB  0000                              
add [bx+si],al	; 00003DDD  0000                              
add [bx+si],ax	; 00003DDF  0100                              
add [bx+si],al	; 00003DE1  0000                              
add [bx+si],ah	; 00003DE3  0020                              
add [bx+si],al	; 00003DE5  0000                              
inc ax	; 00003DE7  40                                
mov al,[0x100]	; 00003DE8  A00001                            
inc dx	; 00003DEB  42                                
stosb	; 00003DEC  AA                                
add byte [di],0x4a	; 00003DED  80054A                            
stosb	; 00003DF0  AA                                
add byte [di],0x4a	; 00003DF1  80054A                            
stosb	; 00003DF4  AA                                
add byte [di],0x4a	; 00003DF5  80054A                            
stosb	; 00003DF8  AA                                
test al,0x15	; 00003DF9  A815                              
or ch,[bp+si+0x15a0]	; 00003DFB  0AAAA015                          
push es	; 00003DFF  06                                
stosb	; 00003E00  AA                                
adc byte [di],0x5	; 00003E01  801505                            
stosb	; 00003E04  AA                                
add [si],dl	; 00003E05  0014                              
adc [bx+si],al	; 00003E07  1000                              
add [di],dl	; 00003E09  0015                              
inc ax	; 00003E0B  40                                
add [bx+si],al	; 00003E0C  0000                              
adc ax,0x5555	; 00003E0E  155555                            
inc ax	; 00003E11  40                                
adc ax,0x5055	; 00003E12  155550                            
add [di],dl	; 00003E15  0015                              
push sp	; 00003E17  54                                
add [bx+si],al	; 00003E18  0000                              
add [di],ax	; 00003E1A  0105                              
add [bx+si],al	; 00003E1C  0000                              
add [bx+si],al	; 00003E1E  0000                              
add [bp+si],al	; 00003E20  0002                              
mov al,[0x800a]	; 00003E22  A00A80                            
or ch,[bx+si-0x5fd6]	; 00003E25  0AA82AA0                          
sub bp,dx	; 00003E29  2BEA                              
stosb	; 00003E2B  AA                                
test al,0x2f	; 00003E2C  A82F                              
stosb	; 00003E2E  AA                                
stosb	; 00003E2F  AA                                
test al,0x2f	; 00003E30  A82F                              
stosb	; 00003E32  AA                                
stosb	; 00003E33  AA                                
test al,0x2b	; 00003E34  A82B                              
stosb	; 00003E36  AA                                
stosb	; 00003E37  AA                                
test al,0xa	; 00003E38  A80A                              
jmp word 0xaa0a:word 0xa0aa	; 00003E3A  EAAAA00AAA                        
stosb	; 00003E3F  AA                                
mov al,[0xaa02]	; 00003E40  A002AA                            
stosb	; 00003E43  AA                                
add byte [bx+si],0xaa	; 00003E44  8000AA                            
stosb	; 00003E47  AA                                
add [bx+si],al	; 00003E48  0000                              
sub ch,[bx+si+0x0]	; 00003E4A  2AA80000                          
add al,[bx+si+0x0]	; 00003E4E  02800000                          
add [bx+si],al	; 00003E52  0000                              
add [bp+si],al	; 00003E54  0002                              
add ax,0x0	; 00003E56  050000                            
add [bx+si],al	; 00003E59  0000                              
add [bx+si],al	; 00003E5B  0000                              
add al,[bx+si]	; 00003E5D  0200                              
add [bx+si],al	; 00003E5F  0000                              
add al,[bx+si+0x0]	; 00003E61  02800000                          
add [bx+si+0x0],al	; 00003E65  00800000                          
add ax,ax	; 00003E69  03C0                              
add [bx+si],al	; 00003E6B  0000                              
add ax,ax	; 00003E6D  03C0                              
add [bx+si],al	; 00003E6F  0000                              
add ax,ax	; 00003E71  03C0                              
add [bx+si],al	; 00003E73  0000                              
add ax,ax	; 00003E75  03C0                              
add [bx+si],al	; 00003E77  0000                              
add ax,ax	; 00003E79  03C0                              
add [bx+si],al	; 00003E7B  0000                              
add ax,0x5051	; 00003E7D  055150                            
add al,0x1	; 00003E80  0401                              
inc cx	; 00003E82  41                                
adc [di],al	; 00003E83  1005                              
push bp	; 00003E85  55                                
push bp	; 00003E86  55                                
push ax	; 00003E87  50                                
add [di+0x54],dx	; 00003E88  015554                            
add [bx+si],al	; 00003E8B  0000                              
add [bx+si],al	; 00003E8D  0000                              
add [si],al	; 00003E8F  0004                              
add [bx+si],al	; 00003E91  0000                              
add [bp+si],ch	; 00003E93  002A                              
test al,0x0	; 00003E95  A800                              
add al,[bp+di-0x7f3e]	; 00003E97  0283C280                          
or [bp+di],al	; 00003E9B  0803                              
shl byte [bx+si],byte 0x8	; 00003E9D  C02008                            
db 0x0f	; 00003EA0  0F                                
lock and [bp+di],ah	; 00003EA1  F02023                            
db 0xff	; 00003EA4  FF                                
dec ax	; 00003EA5  FFC8                              
das	; 00003EA7  2F                                
db 0xff	; 00003EA8  FF                                
db 0xff	; 00003EA9  FF                                
clc	; 00003EAA  F8                                
and di,di	; 00003EAB  23FF                              
dec ax	; 00003EAD  FFC8                              
and bh,bh	; 00003EAF  20FF                              
dec word [bx+si]	; 00003EB1  FF08                              
and [bx],bh	; 00003EB3  203F                              
cld	; 00003EB5  FC                                
or [bx+si],ah	; 00003EB6  0820                              
aas	; 00003EB8  3F                                
cld	; 00003EB9  FC                                
or [bx+si],cl	; 00003EBA  0808                              
db 0xff	; 00003EBC  FF                                
jmp word near [bx+si]	; 00003EBD  FF20                              
or ah,bh	; 00003EBF  08FC                              
aas	; 00003EC1  3F                                
and [bp+si],al	; 00003EC2  2002                              
add byte [bp+si],0x80	; 00003EC4  800280                            
add [bp+si],ch	; 00003EC7  002A                              
test al,0x0	; 00003EC9  A800                              
push es	; 00003ECB  06                                
add [bx+si],al	; 00003ECC  0000                              
add [bx],bh	; 00003ECE  003F                              
lock add [bx+si],al	; 00003ED0  F00000                            
db 0xff	; 00003ED3  FF                                
cld	; 00003ED4  FC                                
add [bp+di],al	; 00003ED5  0003                              
db 0xff	; 00003ED7  FF                                
inc word [bx+si]	; 00003ED8  FF00                              
db 0x0f	; 00003EDA  0F                                
lock	; 00003EDB  F0                                
aas	; 00003EDC  3F                                
ror byte [bx],byte 0xcf	; 00003EDD  C00FCF                            
iret	; 00003EE0  CF                                
ror byte [bx],byte 0xcf	; 00003EE1  C00FCF                            
iret	; 00003EE4  CF                                
ror byte [bx],byte 0xcf	; 00003EE5  C00FCF                            
iret	; 00003EE8  CF                                
rol byte [bp+di],byte 0xf3	; 00003EE9  C003F3                            
aas	; 00003EEC  3F                                
add [bx+si],al	; 00003EED  0000                              
rep cmp al,0x0	; 00003EEF  F33C00                            
add [bp+di],dh	; 00003EF2  0033                              
xor [bx+si],al	; 00003EF4  3000                              
add [bx+si],ah	; 00003EF6  0020                              
and [bx+si],al	; 00003EF8  2000                              
add [bp+si],ch	; 00003EFA  002A                              
mov al,[0x0]	; 00003EFC  A00000                            
and [bx+si],ah	; 00003EFF  2020                              
add [bx+si],al	; 00003F01  0000                              
or al,[bx+si+0x3f00]	; 00003F03  0A80003F                          
lock	; 00003F07  F0                                
ror byte [si],byte 0xc0	; 00003F08  C00CC0                            
or al,0x3f	; 00003F0B  0C3F                              
lock add [bx+si],al	; 00003F0D  F00000                            
db 0xc0	; 00003F10  C0                                
xor bh,bh	; 00003F11  30FF                              
cld	; 00003F13  FC                                
rol byte [bx+si],byte 0xf0	; 00003F14  C000F0                            
xor ah,cl	; 00003F17  30CC                              
or al,0xc3	; 00003F19  0CC3                              
or al,0xc0	; 00003F1B  0CC0                              
lock xor [bx+si],dh	; 00003F1D  F03030                            
ror byte [si],byte 0xc3	; 00003F20  C00CC3                            
or al,0x3c	; 00003F23  0C3C                              
lock	; 00003F25  F0                                
add di,sp	; 00003F26  03FC                              
add ax,[bx+si]	; 00003F28  0300                              
add ax,[bx+si]	; 00003F2A  0300                              
db 0xff	; 00003F2C  FF                                
cld	; 00003F2D  FC                                
xor di,sp	; 00003F2E  33FC                              
ret	; 00003F30  C3                                
or al,0xc3	; 00003F31  0CC3                              
or al,0x3c	; 00003F33  0C3C                              
or al,0x3f	; 00003F35  0C3F                              
lock	; 00003F37  F0                                
ret	; 00003F38  C3                                
or al,0xc3	; 00003F39  0CC3                              
or al,0x3c	; 00003F3B  0C3C                              
xor [0x1],cl	; 00003F3D  300E0100                          
add [bx+si],al	; 00003F41  0000                              
add [bx+si],al	; 00003F43  0000                              
add [bx+si],al	; 00003F45  0000                              
add [bx+si],al	; 00003F47  0000                              
add [bx+si],al	; 00003F49  0000                              
add [bx+si],al	; 00003F4B  0000                              
add [bx+si],al	; 00003F4D  0000                              
add [bx+si],al	; 00003F4F  0000                              
add [bx+si],al	; 00003F51  0000                              
add [bx+si],al	; 00003F53  0000                              
add [bx+si],al	; 00003F55  0000                              
add [bx+si],al	; 00003F57  0000                              
add [bx+si],al	; 00003F59  0000                              
add [bx+si],al	; 00003F5B  0000                              
add [bx+si],al	; 00003F5D  0000                              
add [bx+si],al	; 00003F5F  0000                              
add [bx+si],al	; 00003F61  0000                              
add [bx+si],al	; 00003F63  0000                              
add [bx+si],al	; 00003F65  0000                              
add [bx+si],al	; 00003F67  0000                              
add [bx+si],al	; 00003F69  0000                              
add [bx+si],al	; 00003F6B  0000                              
add [bx+si],al	; 00003F6D  0000                              
add [bx+si],al	; 00003F6F  0000                              
add [bx+si],al	; 00003F71  0000                              
add [bx+si],al	; 00003F73  0000                              
add [bx+si],al	; 00003F75  0000                              
add [bx+si],al	; 00003F77  0000                              
add [bx+si],al	; 00003F79  0000                              
add [bx+si],al	; 00003F7B  0000                              
add [bx+si],al	; 00003F7D  0000                              
add [bx+si],al	; 00003F7F  0000                              
add [bx+si],al	; 00003F81  0000                              
add [bx+si],al	; 00003F83  0000                              
add [bx+si],al	; 00003F85  0000                              
add [bx+si],al	; 00003F87  0000                              
add [bx+si],al	; 00003F89  0000                              
add [bx+si],al	; 00003F8B  0000                              
add [bx+si],al	; 00003F8D  0000                              
add [bx+si],ax	; 00003F8F  0100                              
add [bx+si],al	; 00003F91  0000                              
add [bx+si],al	; 00003F93  0000                              
add [bx+si],al	; 00003F95  0000                              
add [bp+di-0x75f1],bl	; 00003F97  009B0F8A                          
vmwrite ecx,dword [bx]	; 00003F9B  0F790F                            
push word 0xf	; 00003F9E  6A0F                              
add [bx+si],ax	; 00003FA0  0100                              
nop	; 00003FA2  90                                
add [si-0x1fff],si	; 00003FA3  01B401E0                          
add [di],dx	; 00003FA7  0115                              
add bl,[bx+si+0x2]	; 00003FA9  025802                            
adc ax,0xe002	; 00003FAC  1502E0                            
add [si-0x6fff],si	; 00003FAF  01B40190                          
add [bx+si+0x213],cx	; 00003FB3  01881302                          
add [bx+si+0x17],dh	; 00003FB7  007017                            
add al,[bx+si]	; 00003FBA  0200                              
dec sp	; 00003FBC  4C                                
sbb ax,0x2	; 00003FBD  1D0200                            
adc [bx],ah	; 00003FC0  1027                              
add al,[bx+si]	; 00003FC2  0200                              
mov [0xe002],ax	; 00003FC4  A302E0                            
add ah,[bp+di]	; 00003FC7  0223                              
add bp,[bp+di+0x3]	; 00003FC9  036B03                            
mov bx,0x1103	; 00003FCC  BB0311                            
add al,0x6f	; 00003FCF  046F                              
add al,0xd6	; 00003FD1  04D6                              
add al,0x46	; 00003FD3  0446                              
add ax,0x5c0	; 00003FD5  05C005                            
inc bp	; 00003FD8  45                                
push es	; 00003FD9  06                                
xlatb	; 00003FDA  D7                                
push es	; 00003FDB  06                                
jnz 0x3fe5	; 00003FDC  7507                              
and cl,[bx+si]	; 00003FDE  2208                              
fimul word [bx+si]	; 00003FE0  DE08                              
lodsb	; 00003FE2  AC                                
or [si-0x7ff6],cx	; 00003FE3  098C0A80                          
or cx,[bp+di-0x52f4]	; 00003FE7  0B8B0CAD                          
or ax,0xeea	; 00003FEB  0DEA0E                            
inc sp	; 00003FEE  44                                
adc [di+0x5811],bh	; 00003FEF  10BD1158                          
adc bx,[bx+si]	; 00003FF3  1318                              
adc ax,0x6ea	; 00003FF5  15EA06                            
aam byte 0xd	; 00003FF8  D40D                              
push ds	; 00003FFA  1E                                
push es	; 00003FFB  06                                
cmp ax,0x6a0c	; 00003FFC  3D0C6A                            
add ax,0xad4	; 00003FFF  05D40A                            
retf	; 00004002  CB                                
add al,0x95	; 00004003  0495                              
or [0x7b04],di	; 00004005  093E047B                          
or cl,al	; 00004009  08C1                              
add ax,[bx+di+0x5207]	; 0000400B  03810752                          
add sp,[si-0xffa]	; 0000400F  03A406F0                          
add ah,cl	; 00004013  02E1                              
add ax,0x29a	; 00004015  059A02                            
xor al,0x5	; 00004018  3405                              
dec bp	; 0000401A  4D                                
add bl,[bp+si+0x904]	; 0000401B  029A0409                          
add dl,[bp+di]	; 0000401F  0213                              
add al,0xcd	; 00004021  04CD                              
add [bp+di+0x3],bx	; 00004023  019B0300                          
add [bx+si],al	; 00004027  0000                              
add [bx+si],al	; 00004029  0000                              
add [bx+si],al	; 0000402B  0000                              
add [bx+si],al	; 0000402D  0000                              
add [bp+di+0x74],dh	; 0000402F  007374                            
popa	; 00004032  61                                
imul si,[bp+di+0x74],0x61	; 00004033  6B737461                          
imul si,[bp+di+0x74],0x61	; 00004037  6B737461                          
imul si,[bp+di+0x74],0x61	; 0000403B  6B737461                          
db 0x6b	; 0000403F  6B                                
