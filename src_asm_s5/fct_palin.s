/*
bool palin(char *chaine)
{
    uint32_t inf, sup;
    for (inf = 0, sup = strlen(chaine) - 1;
      (inf < sup) && (chaine[inf] == chaine[sup]);
      inf++, sup--);
    return inf >= sup;
}
*/
    .globl palin
    // chaine : %ebp + 8
    .text
palin:
    // uint32_t inf : %ebp - 4
    // uint64_t sup : %ebp - 8
    enter $8, $0

    movl $0, -4(%ebp)

    // sup = strlen(chaine) - 1
    pushl 8(%ebp)
    call strlen
    addl $4, %esp

    // sup = strlen(chaine) - 1
    subl $1, %eax
    movl %eax, -8(%ebp)

for:
    // if (inf < sup)
    movl -4(%ebp), %eax
    movl -8(%ebp), %ecx
    cmpl %eax, %ecx
    jna fin_for

    // if (chaine[inf] == chaine[sup])
    movl 8(%ebp), %edx
    movb (%edx,%eax), %al
    cmpb %al, (%edx, %ecx)
    jne fin_for

    // inf ++
    addl $1, -4(%ebp)
    // sup --
    addl $1, -8(%ebp)
    jmp for

fin_for:
    // return inf >= sup;
    movl -8(%ebp), %eax
    cmpl %eax, -4(%ebp)
    setne %al

    leave
    ret
