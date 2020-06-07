.model small
.stack 100

.data
    str1 db "                               ****CAESAR'S CIPHER****", "$"
    str2 db 13,10,"Enter 0 to ENCRYPT, 1 to DECRYPT, or 2 to Perform BRUTE FORCE ATTACK: ", "$"
    str3 db 13, 10,"Enter the Key of encryption or Decryption between A-Z: ", "$"
    str4 db 13, 10, "Enter the Cipher Text:","$"
    str5 db 13,10, "The Text: ", "$"
    i db
    text db 100 dup(?)
    key db ?
    str_length db ?
.code

main proc

mov ax, @data
mov ds, ax
    
mov dx, offset str1
mov ah, 09h
int 21h

mov dx, offset str2
mov ah, 09h
int 21h

mov ah, 01h
int 21h

sub al,30h

cmp al, 0
je to_encrypt
cmp al, 1
je to_decrypt
cmp al, 2
je to_bruteForce


to_encrypt:
mov ah, 06h
mov bh, 71h

mov cx, 0000h
mov dx,2479
int 10h

mov ax, 00
mov bx, 00
mov cx, 00
mov dx, 00

call encryption
jmp exiting
to_decrypt:
mov ah, 06h
mov bh, 71h

mov cx, 0000h
mov dx,2479
int 10h
mov ah, 06h
mov bh, 71h

mov cx, 0000h
mov dx,2479
int 10h

mov ax, 00
mov bx, 00
mov cx, 00
mov dx, 00
mov bx, 00

call decryption
jmp exiting
to_bruteForce:
call brute_force
jmp exiting

exiting:

mov ah, 4ch
int 21h

main endp










brute_force proc
call accepting_

mov cx, 00
mov bx, 00
mov i, 00
force_it:
    mov dx, offset str5
    mov ah, 09h
    int 21h
    inc i
    mov bx, 00
    mov cx, 00
    mov dl, i
    mov key, dl
    

force:
cmp cl, str_length
jne force_decrypting
je exit_forcing

force_decrypting:
mov dl, text[bx]
add dl, key
cmp dl, 5bh
jge forced_nested_if
continuing_forcing:
mov ah, 02h
int 21h
inc bx
inc cl
jmp force

forced_nested_if:
mov ax, 00
mov al, dl
mov dl, 5bh

div dl
mov dl, ah
add dl, 41h
jmp continuing_forcing


exit_forcing:
cmp i, 27H
jne force_it
ret
brute_force endp




encryption proc
    call accepting
    
    mov cx, 00
    mov bx, 00
    
    mov dx, offset str5
    mov ah, 09h
    int 21h
    

encrypt:
cmp cl, str_length
jne encrypting
je exit

encrypting:
mov dl, text[bx]
add dl, key
cmp dl, 5bh
jge nested_if
continuing:
mov ah, 02h
int 21h
inc bx
inc cx
jmp encrypt

 
nested_if:
mov ax, 00
mov al, dl
mov dl, 5BH

div dl
mov dl, ah
add dl, 41h 
jmp continuing


exit:    
    ret
encryption endp






decryption proc
    
call accepting

    mov dx, offset str5
    mov ah, 09h
    int 21h
mov cx, 00
mov bx, 00
decrypt:
cmp cl, str_length
jne decrypting
je exit1

decrypting:
mov dl, text[bx]
sub dl, key
cmp dl, 41h
jle nested_if_decryption
continuing_decryption:
mov ah, 02h
int 21h
inc bx
inc cx
jmp decrypt

nested_if_decryption:
mov ax, 41h
div dl
mov dl, ah
add dl, 41h
jmp continuing_decryption 

exit1:
ret
decryption endp

accepting proc

mov dx, offset str4
mov ah, 09h
int 21h


mov cl, 00
mov bl, 00
accept:
mov ah, 01h
int 21h
cmp al, 0DH
je appending
mov text[bx], al
inc bx
inc cl
cmp cl, 99h
je appending
jne accept

;appending and storing
appending:
mov text[bx+1],"$"
mov dl,cl
mov str_length, dl


mov dx, offset str3
mov ah, 09h
int 21h

mov ah, 01h
int 21h
sub al, 'A'
mov key, al

ret
accepting endp

accepting_ proc


mov dx, offset str4
mov ah, 09h
int 21h


mov cl, 00
mov bl, 00
accept_:
mov ah, 01h
int 21h
cmp al, 0DH
je appending_
mov text[bx], al
inc bx
inc cl
cmp cl, 99h
je appending_
jne accept_

;appending and storing
appending_:
mov text[bx+1],"$"
mov dl,cl
mov str_length, dl
ret
accepting_ endp
end main
