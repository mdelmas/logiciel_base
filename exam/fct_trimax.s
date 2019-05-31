/*

struct cellule_t *creer_liste0(uint16_t tab[], uint32_t taille)
{
    struct cellule_t *liste = NULL;
    for (int32_t i = taille - 1; i >= 0; i--) {
        struct cellule_t *cell = malloc(sizeof(struct cellule_t));
        assert(NULL != cell);
        cell->val = tab[i];
        cell->suiv = liste;
        liste = cell;
    }
    return liste;
}

struct cellule_t {
    uint16_t val;               %rax
    struct cellule_t *suiv;     8(%rax)
};

*/

    .text
    // struct cellule_t *creer_liste1(uint16_t tab[], uint32_t taille)
    .globl creer_liste1
    // uint16_t tab[] : %rdi -> -28(%rbp)  (64 bits)
creer_liste1:
    // struct cellule_t *liste : -8(%rbp)  (64 bits)
    // int32_t i : -12(%rbp)               (32 bits)
    // struct cellule_t *cell : -20(%rbp)  (64 bits)
    enter $32, $0
    // sauvegarde paramètres
    movq %rdi, -28(%rbp)
    // liste = NULL
    movq $0, -8(%rbp)
    // i = taille - 1
    movl %esi, %eax
    subl $1, %eax
    movl %eax, -12(%rbp)
for:
    // for i >= 0
    cmpl $0, -12(%rbp)
    jnge end_for
    // struct cellule_t *cell = malloc(sizeof(struct cellule_t))
    movq $16, %rdi
    call malloc
    movq %rax, -20(%rbp)
    // cell->val = tab[i]
    movq -28(%rbp), %rdx
    movl -12(%rbp), %eax
    movw (%rdx, %rax, 2), %ax
    movq -20(%rbp), %rdx
    movw %ax, (%rdx)
    // cell->suiv = liste
    movq -8(%rbp), %rax
    movq -20(%rbp), %rdx
    movq %rax, 8(%rdx)
    // liste = cell
    movq -20(%rbp), %rax
    movq %rax, -8(%rbp)
    // i--
    subl $1, -12(%rbp)
    jmp for
end_for:
    // return liste
    movq -8(%rbp), %rax
    leave
    ret

/*
void trier_liste0(struct cellule_t **liste)
{
    struct cellule_t fictif;
    fictif.suiv = *liste;
    *liste = NULL;
    while (NULL != fictif.suiv) {
        struct cellule_t *prec_max = &fictif;
        struct cellule_t *prec = fictif.suiv;
        while (NULL != prec->suiv) {
            if (prec->suiv->val > prec_max->suiv->val) {
                prec_max = prec;
            }
            prec = prec->suiv;
        }
    }
    prec = prec_max->suiv->suiv;
    prec_max->suiv->suiv = *liste;
    *liste = prec_max->suiv;
    prec_max->suiv = prec;
}
*/
    .text
    // void trier_liste0(struct cellule_t **liste)
    .globl trier_liste1
    // struct cellule_t **liste : %rdi
trier_liste1:
    // struct cellule_t fictif : -16(%rbp)    (128 bits)
        // fictif.val : -16(%rbp)
        // fictif.suiv : (-16+8)(%rbp)
    // struct cellule_t *prec_max : -24(%rbp) (64 bits)
    // struct cellule_t *prec : -32(%rbp)     (64 bits)
    enter $32, $0
    // fictif.suiv = *liste
    movq (%rdi), %rax
    movq %rax, (-16+8)(%rbp)
    // *liste = NULL
    movq $0, (%rdi)
while:
    // while (NULL != fictif.suiv)
    cmpq $0, (-16+8)(%rbp)
    je end_while
    // struct cellule_t *prec_max = &fictif
    leaq -16(%rbp), %rax
    movq %rax, -24(%rbp)
    // struct cellule_t *prec = fictif.suiv
    movq (-16+8)(%rbp), %rax
    movq %rax, -32(%rbp)
while2:
    // while (NULL != prec->suiv)
    movq -32(%rbp), %rax
    cmpq $0, 8(%rax)
    je end_while2
if:
    // if (prec->suiv->val > prec_max->suiv->val)
    movq -32(%rbp), %rax
    movq 8(%rax), %rax
    movw (%rax), %ax
    movq -24(%rbp), %rdx
    movq 8(%rdx), %rdx
    movw (%rdx), %dx
    cmpw %dx, %ax
    jle end_if
    // prec_max = prec
    movq -32(%rbp), %rax
    movq %rax, -24(%rbp)
end_if:
    // prec = prec->suiv
    movq -32(%rbp), %rax
    movq 8(%rax), %rax
    movq %rax, -32(%rbp)
    jmp while2
end_while2:
    jmp while
end_while:
    // prec = prec_max->suiv->suiv
    movq -24(%rbp), %rax
    movq 8(%rax), %rax
    movq 8(%rax), %rax
    movq %rax, -32(%rbp)
    // prec_max->suiv->suiv = *liste
    movq (%rdi), %rdx
    movq -24(%rbp), %rax
    movq 8(%rax), %rax
    movq %rdx, 8(%rax)
    // *liste = prec_max->suiv
    movq -24(%rbp), %rax
    movq 8(%rax), %rax
    movq %rax, (%rdi)
    // prec_max->suiv = prec
    movq -24(%rbp), %rax
    movq -32(%rbp), %rdx
    movq %rdx, 8(%rax)
    leave
    ret
