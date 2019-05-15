/*
uint64_t fact(uint64_t n)
{
if (n <= 1) {
return 1;
} else {
return n * fact(n - 1);
}
}
*/
    .text
    .globl fact
    // uint64_t fact(uint64_t n)
    // n: %rdi
fact:
    // on reserve de la place pour la sauvegarde de %rdi
    enter $16, $0
    // sauvegarde du parametre %rdi = n dans la pile
    movq %rdi, -8(%rbp)
    // if (n < 21)
    cmpq $21, %rdi
    jae erreur
if:
    // if (n <= 1)
    cmpq $1, %rdi
    jnbe else
    // return 1;
    movq $1, %rax
    jmp fin
else:
    // return n * fact(n-1)
    subq $1, %rdi
    call fact
    movq -8(%rbp), %rdi
    mulq %rdi
    jmp fin
erreur:
    call erreur_fact
fin:
    leave
    ret
