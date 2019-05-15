/*
bool palin(char *chaine)
{
uint64_t inf, sup;
for (inf = 0, sup = strlen(chaine) - 1;
(inf < sup) && (chaine[inf] == chaine[sup]);
inf++, sup--);
return inf >= sup;
}
*/
    .text
    .globl palin
    // bool palin(char *chaine)
    // chaine: %rdi
palin:
    // uint64_t inf : %rbp - 8
    // uint64_t sup : %rbp - 16
    enter $32, $0
    // sauvegarde du parametre %rdi = chaine dans la pile
    movq %rdi, -24(%rbp)
    // inf = 0
    movq $0, -8(%rbp)
    // sup = strlen(chaine) - 1;
    call strlen
    movq -24(%rbp), %rdi
    subq $1, %rax
    movq %rax, -16(%rbp)
while:
    // inf < sup
    movq -8(%rbp), %r10
    movq -16(%rbp), %r11
    cmpq %r11, %r10
    jge end_while
    // chaine[inf] == chaine[sup]
    movb (%rdi, %r10), %r10b
    movb (%rdi, %r11), %r11b
    cmpb %r11b, %r10b
    jne end_while
    // inf++
    addq $1, -8(%rbp)
    // sup--
    subq $1, -16(%rbp)
end_while:
    // return inf >= sup
    movq -8(%rbp), %rax
    cmpq -16(%rbp), %rax
    setge %al
fin:
    leave
    ret
