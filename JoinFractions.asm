.MODEL small
.STACK 100h 
.DATA
msg1 db 13,10,'enter a number: $'
 a db ?
 b db ?
 c db ?
 d db ?
 CommonDenominator db ?
 AddedUpper dw ?
 resultMsg db 13,10,'The result of the addition of fractions is: $'
        

.CODE

mov ax,@DATA
mov ds,ax
xor ax,ax



call InputNumber  
mov [a], al
call InputNumber 
mov [b], al
call InputNumber 
mov [c], al
call InputNumber 
mov [d], al
call JoinFractions
mov ah, 09h         
lea dx, resultmsg
int 21h             







mov AH, 4Ch 
int 21h
proc InputNumber 
mov ah, 09h     ;
lea dx, msg1   
int 21h         

mov ah, 01h     
int 21h         
sub al, 30h     
ret

endp InputNumber 
proc CommonGround
xor ax,ax
xor bx,bx
xor cx,cx
mov cl,d
cmp b,cl
ja bAbove
je Equal
jl dAbove

bAbove:
mov cl,b
loopb:
mov ah,0
mov al,cl
mov bl,cl
div d
add cl,b
cmp ah,0
je Exit
jmp loopb
dAbove:
mov cl,d
loopd:
mov ah,0
mov al,cl
mov bl,cl
div b
add cl,d
cmp ah,0
je Exit
jmp loopd
Equal:
mov bl,b
Exit:
mov CommonDenominator,bl
ret
    
endp CommonGround
proc JoinFractions
pusha
call CommonGround
xor ax,ax
xor cx,cx

mov al,bl   ;moving common denominator into al to divide b with it
div b
mul a       ;by  common denominator/b
mov dx,ax   ;saving in dx the new number
xor ax,ax
mov al,bl
div d
mul c
mov cx,ax   ;saving in cx the new number
add dx,cx
mov AddedUpper,dx
popa
ret   
endp JoinFractions
END 
