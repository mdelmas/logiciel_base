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
    // n : 8(%ebp)
fact:
    // on aligne sur un multiple de 16
    enter $0, $0
    // if (n <= 1)
    cmpl $1, 8(%ebp)
    jnbe else
    // return 1
    movl $1, %eax
    jmp fin
else:
    // return n*fact(n-1)
    pushl 8(%ebp)
    subl $1, (%esp)
    call fact
    addl $4, %esp
    // %eax * 8(%ebp) -> %edx : %eax
    mull 8(%ebp)
    cmpl $0, %edx
    je fin
    pushl 8(%ebp)
    call erreur_fact
fin:
    leave
    ret
