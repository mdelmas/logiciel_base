/*
struct cellule_t {
    int64_t val; cellule_t
    struct cellule_t *suiv; cellule_t+8
};
*/
/*
void inverse(struct cellule_t **l)
{
    struct cellule_t *res, *suiv;
    res = NULL;
    while (*l != NULL) {
        suiv = (*l)->suiv;
        (*l)->suiv = res;
        res = *l;
        *l = suiv;
    }
    *l = res;
}
*/
    .globl inverse
    .text
    // l : 8(%ebp)
    // struct cellule_t *res : -4(%ebp)
    // struct cellule_t *suiv : -8(%ebp)

inverse:
    enter $8, $0

    // res = NULL;
    movl $0, -4(%ebp)
while:
    // while (*l != NULL)
    movl 8(%ebp), %eax
    cmpl $0, (%eax)
    je fin_while

    // suiv = (*l)->suiv
    // *l
    movl 8(%ebp), %eax
    // (*l)->suiv
    movl 4(%eax), %eax
    movl %eax, -8(%ebp)

    // (*l)->suiv = res
    // *l
    movl 8(%ebp), %eax
    // (*l)->suiv
    movl -4(%ebp), %ecx
    movl %ecx, 4(%eax)

    // res = *l
    // *l
    movl 8(%ebp), %eax
    movl %eax, -4(%ebp)

    // *l = suiv
    // suiv
    movl -8(%ebp), %eax
    movl %eax, 8(%ebp)

    jmp while
fin_while:
    // *l = res
    movl -4(%ebp), %eax
    movl %eax, 8(%ebp)

    leave
    ret
