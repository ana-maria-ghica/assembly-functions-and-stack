section .text
global kfib

; const int fib(int n, int K);

kfib:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax

    ; callee-saved
    push ebx
    push esi
    push edi

    ; initializez registrii cu valorile transmise ca param

    ; pozitia termenului cerut din sirul KFib (indexarea este de la 1)
    mov esi, [ebp + 8]

    ; specifica tipul sirului de tip Fibonacci
    mov edi, [ebp + 12]

    ; eax reprezinta valoarea de return a fiecarui apel, pe care o s-o adun la ebx
    xor eax, eax

    cmp esi, edi
    jl n_less_than_k

    cmp esi, edi
    je n_equal_to_k

    cmp esi, edi
    jg n_bigger_than_k

    n_less_than_k:
    ; pun 0 in registrul eax deoarece aceasta e valoarea de retur corespunzatoare cazului n < k
    mov eax, 0
    jmp finish

    n_equal_to_k:
    ; pun 1 in registrul eax deoarece aceasta e valoarea de retur corespunzatoare cazului n = k
    mov eax, 1
    jmp finish

    n_bigger_than_k:
    ; in ebx tin suma tuturor apelurilor recursive
    xor ebx, ebx

    ; indexare de la 1
    mov ecx, 1

    recursive_sum:
    ; initial voiam sa decrementez efectiv valoarea lui esi si sa o pasez ca parametru din ce in ce mai mica
    ; dar nu stiam cum sa revin la val originala in urma tuturor apelurilor recursive
    ; si ca sa evit seg-fault-ul, am ales sa o pun separat in eax si sa scad apoi din eax

    ; asadar:
    ; eax = n - i, unde i = {1 ... K}
    mov eax, esi
    sub eax, ecx 

    push ecx

    push edi
    push eax
    call kfib
    ; esp + 8 pentru ca am pus 2 parametri pe stiva
    add esp, 8

    pop ecx

    add ebx, eax
    inc ecx
    cmp ecx, edi
    jle recursive_sum

    mov eax, ebx

    finish:
    ; callee-saved
    pop edi
    pop esi
    pop ebx

    leave
    ret