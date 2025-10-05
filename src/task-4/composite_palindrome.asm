section .bss
    ; reserve 1 dword pt result
    result resd 1
    ; reserve 1 dword pt current_string
    current_string resd 1
    ; reserve 1 dword pt concatenated_string
    concatenated_string resd 1

section .data
    ; initializez reverse array ca sa l pregatesc pentru algoritm
    reverse_array times 500 db 0
    ; max_words e de 15
    max_words db 15
    ; initial lungimea e 0
    length dd 0

section .text
global check_palindrome
global composite_palindrome

; functii "externe" adaugate de mine
extern strcmp
extern strlen
extern strcpy
extern strcat


check_palindrome:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax

    ; calee-saved
    push ebx
    push esi
    push edi

    ; vectorul de caractere
    mov ebx, [ebp + 8]

    ; lungimea vectorului
    mov ecx, [ebp + 12]

    ; daca e 0 atunci string-ul nu e palindrom
    cmp ecx, 0
    je is_not_palindrome

    ; ca sa obtin pozitia caracterului pe n-1
    dec ecx

    ; contorul pentru reverse_array
    xor esi, esi

    ; formez un nou sir cu toate caracterele celuilalt, de la coada la cap
    iter_through_array:
    xor eax, eax
    mov al, byte [ebx + ecx]
    mov byte [reverse_array + esi], al
    inc esi
    dec ecx
    ; -1 e indexul la care ma asigur ca se ia in calcul si 0 prin decrementare
    cmp ecx, -1
    jg iter_through_array

    ; pun terminatorul de sir in noul array format
    mov byte [reverse_array + esi], 0

    ; apelez strcmp (m-am asigurat ca ambele siruri se termina cu \0)
    push reverse_array
    push ebx
    call strcmp
    ; refac stiva in urma apelului
    add esp, 8

    ; verific daca rezultatul in urma apelului strcmp este 0 sau 1 pt a vedea daca e palindrom sau nu
    cmp eax, 0
    je is_palindrome
    jmp is_not_palindrome

    is_palindrome:
    xor eax, eax
    inc eax
    jmp finish

    is_not_palindrome:
    xor eax, eax
    jmp finish  
    finish:
    ; callee-saved
    pop edi
    pop esi
    pop ebx

    leave
    ret

composite_palindrome:
    ; create a new stack frame
    enter 0,0
    xor eax, eax

    leave
    ret