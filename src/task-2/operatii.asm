;9
;Ana are 27 de mere si 32 de pere

section .data
    ; initializare cu 0
    max_words dd 0
    ; format folosit la debug
    format_printf db "%s - %d", 10, 0
    ; format folosit la debug
    format_printf_one_number db "%d", 10, 0

section .text
global compare
global sort
global get_words

; in plus pentru functiile scrise de mine
extern qsort
extern strcmp
extern strlen
extern printf

;---------------------------------------------------------------------------------------------------first function-------------
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
compare:
    ; prologul functiei. asa a fost dat.
    enter 0,0
    xor eax, eax

    ; calee-saved
    push ebx
    push esi
    push edi

    ; preiau parametrii de pe stivq
    ; array-ul (1)
    mov esi, [ebp + 8]
    ; trebuie sa dereferentiez
    mov esi, [esi]
    ; array-ul (2)
    mov edi, [ebp + 12]
    ; trebuie sa dereferentiez
    mov edi, [edi]

    ; in ebx tin lungimea primului array
    push esi
    call strlen
    ; refac stiva in urma apelurilor
    add esp, 4
    mov ebx, eax

    ; in ecx tin lungimea celui de-al doilea array
    push edi
    call strlen
    ; refac stiva in urma apelurilor
    add esp, 4
    mov ecx, eax

    ; debug: afisez lungimile pentru fiecaere
    ; push ebx
    ; push format_printf_one_number
    ; call printf
    ; add esp, 8
    ; pt celalalt string
    ; push ecx
    ; push format_printf_one_number
    ; call printf
    ; add esp, 8

    ; compar in functie de lungimi
    cmp ebx, ecx
    jl finish_lower
    jg finish_greater

    ; am ajuns aici deci trebuie sa compar lexicografic
    push edi
    push esi
    call strcmp
    ; refac stiva in urma apelurilor
    add esp, 8
    jmp final_compare

finish_lower:
    ; -1 e valoarea de return pt comparatie
    mov eax, -1
    jmp final_compare

finish_greater:
    ; 1 e valoarea de return pt comparatie 
    mov eax, 1

final_compare:
    ; callee-saved
    pop edi
    pop esi
    pop ebx
    leave
    ret

sort:
    ; prologul functiei. asa a fost dat.
    enter 0, 0

    ; callee-saved
    push ebx
    push esi
    push edi

    ; preiau parametrii de pe stiva
    ; array-ul de cuvinte
    mov ebx, [ebp + 8]

    ; nr de cuvinte
    mov ecx, [ebp + 12]

    ; size-ul cuvintelor
    mov edx, [ebp + 16]

    ; semnatura pt qsort este: qsort(base, num, size, compare_fct)
    ; asadar pun parametrii pe stiva in ordinea corespunzatoare

    push compare
    push edx
    push ecx
    push ebx
    call qsort
    ; refac stiva in urma apelurilor
    add esp, 16

    ; calee-saved
    pop edi
    pop esi
    pop ebx

    leave
    ret
;---------------------------------------------------------------------------------------------------second function-------------
;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; prologul functiei. asa a fost dat.
    enter 0, 0
    xor eax, eax
    ; callee-saved
    push ebx
    push esi
    push edi

    ; iau parametrii trimisi pe stiva
    ; textul mare cu care lucrez
    mov ebx, [ebp + 8]
    ; array-ul de cuvinte
    mov edx, [ebp + 12]
    ; in [ebp + 16] se afla numarul total de cuvinte

    ; pregatesc contoarele cu care o sa ma plimb prin texte
    ; index pentru textul mare
    xor ecx, ecx
    ; index pentru array-ul de cuvinte
    xor edi, edi

    ; flag ca sa vad daca sunt la inceputul unui cuvant
    ; 0 = nu sunt in cuvant
    ; 1 = sunt deja in cuvant
    xor esi, esi
    loop:
    ; caracterul curent
    mov al, byte [ebx + ecx]

    cmp al, ' '
    je next_word

    cmp al, ','
    je next_word

    cmp al, '.'
    je next_word

    ; cod ASCII pt \n
    cmp al, 10
    je next_word

    ; verif daca s-a terminat textul mare    
    cmp al, 0
    je finish

    ; daca am ajuns aici inseamna ca am gasit un caracter normal

    ; verific flag-ul
    cmp esi, 0
    jg inside_word

    ; am gasit inceputul unui cuvant
    ; setez flag-ul ca sunt intr-un cuvant nou
    mov esi, 1

    ; setez pointerul la cuvant !!!
    lea eax, [ebx + ecx]
    ; inmultesc cu 4 ca sa ajung la pointerul care trebuie; un pointer are size-ul 4 bytes
    mov [edx + edi * 4], eax
    inside_word:
    ; incrementez ca sa trec la urm caracter
    inc ecx
    jmp loop

    next_word:
    ; verific flag-ul
    cmp esi, 1
    jl skip_delimiter
    ; am ajuns aici deci trb sa pun '\0' in text
    mov byte [ebx + ecx], 0
    ; si sa resetez flag-ul
    mov esi, 0
    inc edi
    ; verific daca mai am cuvinte de parcurs
    cmp edi, dword [ebp + 16]
    jge finish
    skip_delimiter:
    inc ecx
    jmp loop

    finish:
    ; calee-saved
    pop edi
    pop esi
    pop ebx

    leave
    ret