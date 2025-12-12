bits 16

section .bootsect start=0

org 0
; disable interrupts
cli
; place stack at 0000:0400h (top of IVT)
xor ax,ax
mov dx,400h
mov ss,ax
mov sp,dx
; place mov ax,426dh; iret onto the stack
; (will be at INT 0FFh)
;mov es,ax
;mov di,11h*4 ; int 11h vector
;mov ax,0cf42h ; mov ax,42xxh
;push ax
;mov ax,6db8h ; ...6dh; iret
;push ax
;mov ax,sp
;stosw
;mov ax,cs
;stosw
; copy image to 50:0h
mov ds,ax
call getoffset
offset_base:
mov ax,50h
mov es,ax
xor di,di
mov cx,16448/2
rep movsw
; default flags
; (nv up di ng nz nz po nc)
mov ax,0f182h
push ax
mov ax,50h
add ax,100h
mov ds,ax
mov ax,0b800h
mov es,ax
push ax
mov ax,1bh ; skip int11h memory check code
push ax
; segment registers:
; CS:IP = 0050:001B
; DS    = 0150
; ES    = B800
; SS    = 0000:0400
iret

; returns offset of image in a position
; independent code manner
getoffset:
pop si
push si
add si,image-offset_base
ret

align 16

image equ $
