/*
struct cellule_t {
    int64_t val; cellule_t
    struct cellule_t *suiv; cellule_t+4
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
    // l    : 8(%ebp)
    // res  : -4(%ebp)
    // suiv : -4(%ebp)
inverse:
    enter $8,$0
    //res = NULL;
    movl $0,-4(%ebp)
while:
    // cond(*l != NULL)
    movl 8(%ebp),%edx
    cmpl $0,(%edx)
    je fin_while

    // %ecx = *l
    movl 8(%ebp),%edx
    movl (%edx),%ecx
    // %eax = (*l)->suiv;
    movl 4(%ecx),%eax
    // suiv = (*l)->suiv;
    movl %eax,-8(%ebp)

    // %eax = res
    movl -4(%ebp),%eax
    // %ecx = *l
    movl 8(%ebp),%edx
    movl (%edx),%ecx
    // (*l)->suiv = res;
    movl %eax,4(%ecx)

    // %ecx = *l
    movl 8(%ebp),%edx
    movl (%edx),%ecx
    // res = *l
    movl %ecx,-4(%ebp)

    // %eax = suiv
    movl -8(%ebp),%eax
    //*l = suiv;
    movl 8(%ebp),%edx
    movl %eax,(%edx)

    jmp while
fin_while:
    // %eax = res
    movl -4(%ebp),%eax
    //*l = res;
    movl 8(%ebp),%edx
    movl %eax,(%edx)
    leave
    ret
