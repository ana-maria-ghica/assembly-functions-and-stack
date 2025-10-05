section .data
    ; initializare cu 0
    end_loop dd 0
    ; initializare cu 0
    min_value dd 0
    ; initializare cu 0
    current_value dd 0

section .bss
    struc node
        .val resd 1
        .next resd 1
    endstruc

section .text
global sort

;   struct node {
;    int val;
;    struct node* next;
;   };

;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list

sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax

    ; salvez registrii callee-saved
    push ebx
    push esi
    push edi

    ; pregatesc registrii
    xor esi, esi
    xor ebx, ebx

    ; atribui datele de pe stiva

    ; numarul de noduri din array
    mov esi, [ebp + 8]

    ; pointer la inceputul array-ului
    mov ebx, [ebp + 12]

    ; folosesc ecx si edi pe post de "indici"
    xor ecx, ecx
    xor edi, edi

    ; setez unde se termina loop-ul
    mov dword [end_loop], esi


    ; trebuie sa gasesc intai head-ul listei
    ; stiind ca array-ul incepe mereu cu valoarea 1, caut valoarea 1 in lista

    ; in eax salvez head-ul, in eax il returnez
    xor eax, eax
    ; pun valoarea 1 pentru ca SE PRECIZEAZA IN ENUNT ca array-ul incepe cu valoarea 1
    mov dword [current_value], 1

    find_list_head:
    ; vad daca am gasit valoarea 1
    cmp dword [ebx + ecx * node_size], 1
    je set_list_head

    inc ecx
    cmp ecx, dword [end_loop]
    jl find_list_head

    jmp continue_to_connect_nodes

    set_list_head:
    ; pun adresa nodului care are valoarea 1
    lea eax, [ebx + ecx * node_size]

    ; incrementez valoarea curenta pe care trebuie sa o caut apoi in lista
    inc dword [current_value]

    ; recap:
    ; in ecx am indicele valorii 1
    ; in edi voi avea indicele noii valori gasite (- in cazul meu: 2)
    ; dupa ce o gasesc, ecx = edi, iar edi continua sa gaseasca o noua valoare in array (3, si tot asa)
    continue_to_connect_nodes:
    ; resetez pt o noua cautare
    xor edi, edi
    mov edx, dword [current_value] 

    ; caut valoarea in array
    loop_array:
    cmp dword [ebx + edi * node_size], edx
    ; am gasit valoarea, trec direct la connect nodes
    je connect_nodes

    inc edi
    cmp edi, dword [end_loop]
    jl loop_array

    ; daca am parcurs array-ul si nu am gasit valoarea, verific daca mai exista valori de cautat
    inc dword [current_value]
    cmp dword [current_value], esi
    jle continue_to_connect_nodes
    jmp finish

    connect_nodes:
    push edx
    lea edx, [ebx + edi * node_size]
    mov [ebx + ecx * node_size + node.next], edx
    pop edx

    ; ca sa pregatesc pentru aceasta mutare mai departe
    mov ecx, edi

    ; incrementez valoarea curenta
    inc dword [current_value]

    ; verific daca am ajuns la final
    cmp dword [current_value], esi
    jle continue_to_connect_nodes
    jmp finish

    finish:
    ; trebuie sa setez si ultimul nod pe NULL !!
    mov dword [ebx + ecx * node_size + node.next], 0

    ; reiau registrii callee-saved
    pop edi
    pop esi
    pop ebx

    leave
    ret