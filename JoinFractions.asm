.MODEL small
.STACK 100h 
.DATA
msg1 db 13,10,'enter a number: $'
 a db ?
 b db ?
 c db ?
 d db ?
 aAscii db ?
 bAscii db ?
 cAscii db ?
 dAscii db ?
 CommonDenominatorAscii1 db ?
 CommonDenominatorAscii2 db ? 
 CommonDenominator db ?
 AddedUpper dw ?
 AddedUpperAscii1 db ?
 AddedUpperAscii2 db ?
 resultMsg db 13,10,'The result of the addition of fractions is: / + / =  /  $'
 
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

mov bl,a
mov aAscii,bl
mov bl,b
mov bAscii,bl
mov bl,c
mov cAscii,bl
mov bl,d
mov dAscii,bl

mov ax,0
mov al,CommonDenominator 
mov bl,10
div bl
mov CommonDenominatorAscii1,al
mov CommonDenominatorAscii2,ah
mov ax, 0      
mov ax, AddedUpper        
mov bl, 10      
div bl           
mov AddedUpperAscii1, al  
mov AddedUpperAscii2, ah  



call ChangeToAscii
add aAscii,al
add bAscii,al
add cAscii,al
add dAscii,al
add CommonDenominatorAscii1,al
add CommonDenominatorAscii2,al
add AddedUpperAscii1,al
add AddedUpperAscii2,al


lea bx,resultmsg
mov al,aAscii
mov [bx+45],al
mov al,bAscii
mov [bx+47],al
mov al,cAscii
mov [bx+49],al
mov al,dAscii
mov [bx+51],al
mov al,AddedUpperAscii1
mov [bx+53],al
mov al,AddedUpperAscii2
mov [bx+54],al
mov al,CommonDenominatorAscii1
mov [bx+56],al
mov al,CommonDenominatorAscii2
mov [bx+57],al
lea DX,resultmsg 
mov AH,09h 
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
proc ChangeToAscii
xor ax,ax         
add al, 30h     
ret
endp ChangeToAscii
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
 
