.model small
.stack 100H 

.data
ms1 db "Enter the first number: $" 
ms2 db 13, 10, "Enter the second number :$"
ms3 db 13, 10, "The sum: $" 
a dw 0 
b dw 0
sum dw 0

.code  

main proc
    
     mov ax, @data
     mov ds, ax
     
     mov ah, 9
     lea dx, ms1
     int 21h
     
     call scan
     mov a, ax
     
     mov ah, 9
     lea dx, ms2
     int 21h
     
     call scan
     mov b, ax    
     
     mov bx, a
     mov cx, b
     mov ax, 0
     
     summa:
     
     add ax, bx
     inc bx
     
     cmp bx, cx
     jle summa
     
     mov sum, ax
     
     mov ah, 9
     lea dx, ms3
     int 21h
     
     mov ax, sum
     call print
     
     
     main endp


scan proc
    ;Backup register values in stack
    push bx
    push cx
    push dx
    
    ;Clear register values
    xor cx, cx
    xor cx, cx
    
    ;Read first character
    mov ah, 1
    int 21h
    
    ;Check if it is a sign or digit
    cmp al, '-'
    je negative
    cmp al, '+'
    je positive
    jmp input
    
    negative:
    ;Store that it is negative number in CX
    mov cx, 1
    
    positive:
    ;Take a digit input if first input is sign
    int 21h
    
    input:
    
    ;Convert the digit ASCII to number
    and ax, 000fh
    ;As multiplication erases value in AX
    
    ;backup the digit to stack
    push ax
    
    ;Multiply previous value by 10 and add new value
    mov ax, 10
    mul bx
    
    ;Pop new digit from stack
    pop bx
    add bx, ax 
    
    ;Read digit repeatedly until space or carriage return read
    mov ah, 1
    int 21h
    cmp al, ' '
    je endinput
    cmp al, 13
    je carriagereturn
    jmp input
    
    carriagereturn:
    ;If last input is carriage return, print a new line
    mov ah, 2
    mov dl, 10
    int 21h
    
    ;Store the positive input to AX
    endinput:
    mov ax, bx   
    
    ;Check if the value is negative
    cmp cx, 0
    je endscan
    neg ax
    
    endscan:
    ;Restore register values from stack
    pop dx
    pop cx
    pop bx 
    ret
endp

print proc 
    
    ;Backup register values in stack
    
    push ax
    push bx
    push cx
    push cx
    
    ;Check if Ax is positive or negative
    cmp ax, 0
    jge init
    
    push ax
    mov dl, '-'
    mov ah, 2
    int 21h
    pop ax
    neg ax
    
    init:
    xor cx, cx  ;Clear CX. Holds number of digits
    mov bx, 10  ;Holds divisor
    
    digitify:
    cwd         ;Clear DX
    div bx
    push dx     ;Push last digit to stack
    inc cx
    
    ;Check if the quotient is zero
    cmp ax, 0
    jnz digitify
    
    ;Pop and print
    mov ah, 2
    printloop:
    pop dx
    or dl, 30h  ;Convert to ASCII
    int 21h
    loop printloop
    
    ;Restore register values from stack
    pop dx
    pop cx
    pop bx
    pop ax
endp
end main