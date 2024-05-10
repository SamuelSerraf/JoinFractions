.MODEL small
.STACK 100h 
.DATA
msg1 db 13,10,'Enter a number: $'
waitforkey db 13,10, 'Press any key to go into graphic mode  $', 13,10
 a db ?  ;a in a/b + c/d = x/y
 b db ?  ;b in a/b + c/d = x/y
 c db ?  ;c in a/b + c/d = x/y
 d db ?  ;d in a/b + c/d = x/y
 aAscii db ?  ;Ascii form of a to put in a string
 bAscii db ?  ;Ascii form of b to put in a string
 cAscii db ?  ;Ascii form of c to put in a string
 dAscii db ?  ;Ascii form of d to put in a string
 CommonDenominatorAscii1 db ? ;first digit in ascii form of CommonDenominator to put in a string 
 CommonDenominatorAscii2 db ? ;second digit in ascii form of CommonDenominator to put in a string 
 CommonDenominator db ?  ; Common denominator of b and d
 AddedUpper dw ?  ;Added up digit after multiplication of a and c;
 AddedUpperAscii1 db ? ;first digit in ascii form of AddedUpper to put in a string
 AddedUpperAscii2 db ? ;second digit in ascii form of AddedUpper to put in a string
 resultMsg db 13,10,'The result of the addition of fractions is: / + / =  /  $' ;result message
 w dw 36 ;width
h dw 14  ;height
x dw 54  ;horizontal 
y dw 20  ;vertical
color db 15
times db ?
logo0 db "       _       _         ______              _   _                 ",13,10
logo1 db "      | |     (_)       |  ____|            | | (_)                ",13,10
logo2 db "      | | ___  _ _ __   | |__ _ __ __ _  ___| |_ _  ___  _ __  ___ ",13,10
logo3 db "  _   | |/ _ \| | '_ \  |  __| '__/ _` |/ __| __| |/ _ \| '_ \/ __|",13,10
logo4 db " | |__| | (_) | | | | | | |  | | | (_| | (__| |_| | (_) | | | \__ \",13,10
logo5 db "  \____/ \___/|_|_| |_| |_|  |_|  \__,_|\___|\__|_|\___/|_| |_|___/",13,10,13,10,"$"
name0 db 13,10,"Presented by:Samuel Serraf $",13,10,  ;name 
.code
mov ax,@DATA
mov ds,ax
xor ax,ax
lea dx,logo0
mov ah,09h
int 21h
lea dx,name0
mov ah,09h
int 21h

               
call InputNumber  
mov [a], al
call InputNumber 
mov [b], al
call InputNumber 
mov [c], al
call InputNumber 
mov [d], al

call JoinFractions
mov cx,10                  ;reducing the fraction
ReduceTheFraction:
dec cl
cmp cl,0
je NoDivide
mov ax,addedupper
div cl
cmp ah,0
je CheckCommonDenominator
jmp ReduceTheFraction
CheckCommonDenominator:
mov al,CommonDenominator
div cl
cmp ah,0
je Dividebycx
jmp ReduceTheFraction

Dividebycx:
mov ax,addedupper
div cl
mov byte ptr addedupper,al
mov al,CommonDenominator   
div cl
mov CommonDenominator,al
NoDivide:

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

lea DX,waitforkey 
mov AH,09h 
int 21h

;wait for keypress
  mov ah,00
  int 16h
  
mov ah, 0   ;video mode
mov al, 13h 
int 10h

mov color,15   ;drawing plus
mov x,138
mov w,18
mov y,12
mov h,18
call BottomLine
mov x,148
mov y,20
mov h,18
call LeftLine

mov w,36
mov h,18
mov x,54
mov y,20

xor ax,ax
mov  al,  a
push ax
mov al, b
push ax
call DrawFraction


mov  al,  c
push ax
mov al, d
push ax
mov x,210
mov y,21
call DrawFraction

mov color,15
mov x,0
mov y,80                                                
mov w, 319
call BottomLine

mov  ax,  AddedUpper
push ax
mov al, CommonDenominator
push ax
inc h
mov x,30
mov y,100

call DrawFraction

mov AH, 4Ch 
int 21h

proc DrawFraction   ;drawing the added fraction need to push atx=[bp+22] and y=[bp 20] x/y 
push bp
pusha
mov bp,sp
mov al,[bp +22]
div [bp +20]
cmp al,0
je temp1
cmp ah,0
jne add1
jmp dontadd
add1:
inc times
dontadd:
add times,al
jmp square
temp1:
mov times,1
jmp square


addy:
sub x,4
xor ax,ax
mov al,[bp +20]
sub [bp +22],al
add y,20
mov al,4
mul dl
sub  x, ax
inc h
square:
mov color,15
xor dl,dl
mov bl,[bp +20]
mov al,4
mul bl
mov  w,  ax 
call DrawSquare
mov cl,[bp +20]
cmp cl,1
je again
dec cl
again:

add x,4
inc dl
call LeftLine
dec cl
cmp cl,0
jne again

xor cx,cx
dec h
inc x
mov color,5

mov al,4           
mul dl
sub x, ax       ;back to 1 pixel after the white to draw pink
mov al,4
mov bl,[bp +22]
mul bl 
mov cl,al
dec cl
mov al,4
mov bl,[bp +20]
mul bl
mov bl,4
draw:
call LeftLine
inc x
cmp al,2
je time
dec cl
dec al
cmp cl,0
je time
jmp draw


time:
mov al,[bp +20]
cmp al,1
je xplus4
jmp finishtime
xplus4:
add x,4
finishtime:
dec times
cmp times,0
je ending
jmp addy

ending:
popa
pop bp
ret 4
endp DrawFraction ;draw of x/y finished

proc InputNumber ;getting a char of a number and turning it into a number  
mov ah, 09h     
lea dx, msg1   
int 21h
         
reinput:
mov ah,01h
int 16h
jz reinput

mov ah,00h
int 16h

cmp al,30h
jb reinput

cmp al,39h
ja reinput

mov dl,al
mov ah,02h
int 21h
    
sub al, 30h
     
ret                                                         
endp InputNumber ; the outcome goes into al which is the effective adress of the parameter i put

proc ChangeToAscii ;moving to al 30 to add the number to change then into ascii form
xor ax,ax         
add al, 30h     
ret
endp ChangeToAscii ;al=30h 

proc CommonGround ;takes b and d and puts their common denominator in CommonDenominator
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
    
endp CommonGround ; the common denominator of b and d is CommonDenominator 

proc JoinFractions ; puts in AddedUpper a+c (after it was multiplied by the right number of the common denominator) example: 2/4 + 1/2 = 2/4 + 2/4 and Added upper is 2 + 2
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
endp JoinFractions ; AddedUpper is a+c (after it was multiplied by the right number of the common denominator) example: 2/4 + 1/2 = 2/4 + 2/4 and Added upper is 2 + 2

proc UpLine ; draw upper  the line of the square:
pusha

    mov cx, x
    add cx,w    ; column
    mov dx, y     ; row
    mov al, color     ; white
line1: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, x
    jae line1 ;
    popa
    ret
endp UpLine

proc BottomLine  ; draw the bottom line of the square:
pusha

    mov cx, x
    add cx,w  ; column
    mov dx, y
    add dx,h   ; row
    mov al, color     ; white
line2: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, x
    ja line2
    popa
    ret
endp BottomLine

proc LeftLine ; draw the left line of the square:
    pusha 

    mov cx, x    ; column
    mov dx, y
    add dx,h   ; row
    mov al, color     ; white
line3: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, y
    ja line3
    popa
    ret
endp LeftLine

proc RightLine  ; draw the right line of the square:
pusha
    mov cx, x
    add cx,w  ; column
    mov dx, y
    add dx,h   ; row
    mov al, color     ; white
line4: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, y
    ja line4
    popa
    ret
endp RightLine ;calling the 4 sides of the square 
proc DrawSquare
call UpLine
call BottomLine
call RightLine
call LeftLine
ret
endp DrawSquare
END 
