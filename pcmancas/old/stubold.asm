bits 16

section .bootsect start=0

org 0
call near __start
;nop ; replaced with CD 20
;nop
;nop ; replaced with segment of top of memory
db 0
db 0 ; reserved (will be 0)
call far 0f10dh:0feeeh ; call far to vector at int 33h
; 0feeeh is also the program size (assumes 64k)
dd 0 ; old int 22h
dd 0 ; old int 23h
dd 0 ; old int 24h
dw 0 ; parent's PSP segment
db 20 dup (0) ; job file table
dw 0 ; environment segment
dd 0 ; SS:SP on entry to last Int 21h
dw 0 ; job file table size
dd 0 ; pointer to job file table
dd 0 ; pointer to previous PSP
dd 0 ; reserved
dw 0 ; DOS version to return (DOS 5 and later)
int 21h ; far call to DOS
retf
dw 0 ; reserved
db 7 dup (0) ; reserved (extended FCB)
db 16 dup (0) ; FCB 1
db 20 dup (0) ; FCB 2
db 0 ; length of command line
db 0dh ; carriage return to terminate command line
__start: ; this is always at 81h
push cs
pop dx ; cs=dx=0000
pop ax ; ip=ax=7c03
sub ax,3 ; adjust to start
; we want to turn 0000:7c00 into 7c0:0
mov bx,ax
shr bx,1
shr bx,1
shr bx,1
shr bx,1
; bx is now 7c0 which should be added to dx (cs)
add dx,bx
; get desired ip
and ax,0fh
; advance IP 256 bytes
add ax,100h
; save that
mov bp,ax
; stack goes at top of IVT
xor ax,ax
mov bx,400h

mov ss,ax
mov sp,bx

;mov ss,dx
;mov sp,ax

; push 0 (for near return) onto stack
xor ax,ax
push ax
; change int 11h vector
mov es,ax
mov di,11h*4
lea ax,int11h_proc
stosw
mov ax,dx
stosw
; change equipment flags 11h uses
mov ax,40h
mov ds,ax
mov ax,426dh
mov [10h],ax
; set DS=ES=SS=CS
mov es,dx
mov ds,dx
; change PSP's beginning to INT 20h
mov di,0
mov ax,020cdh
stosw
; assume image is 1044 paragraphs
mov ax,es
add ax,414h
stosw
; copy image from ds:100h to 40:100h
mov ax,40h
mov es,ax
mov si,100h
mov di,si
mov cx,1044*16/2
rep movsw
; change seg regs to 40h
mov dx,ax
mov es,dx
mov ds,dx
; push desired flags on stack
mov bx,0f182h
push bx
; push desired cs on stack
push dx
; push desired ip on stack
push bp
; clear registers
xor ax,ax
mov cx,4040h
xor dx,dx
xor bx,bx
xor si,si
xor di,di
xor bp,bp
; execute program
iret

; int 11h vector
int11h_proc:
sti
push ds
mov ax,40h
mov ds,ax
mov ax,[10h]
pop ds
iret
iret

db 5 dup (90h)

image equ $

;mov ax,0b800h
;mov es,ax
;xor di,di
;lea si,hello
;mov cx,hellosz
;mov ah,7
;_l1:
;lodsb
;mov [di-8000h],ax ; write to MDPA memory as well
;stosw
;loop _l1
;
;
;_end:
;cli
;hlt
;jmp _end
;
;hello db 'hello world'
;hellosz equ $-hello
