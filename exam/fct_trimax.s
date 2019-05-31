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
    // uint32_t taille : %esi -> -36(%rbp) (32 bits)
creer_liste1:
    // struct cellule_t *liste : -8(%rbp)  (64 bits)
    // int32_t i : -16(%rbp)               (32 bits)
    // struct cellule_t *cell : -20(%rbp)  (64 bits)
    enter $48, $0
    // sauvegarde paramètres
    movq %rdi, -28(%rbp)
    movl %esi, -36(%rbp)
    // liste = NULL
    movq $0, -8(%rbp)
    // i = taille - 1
    movl %esi, %eax
    subl $1, %eax
    movl %eax, -16(%rbp)
for:
    // for i >= 0
    cmpl $0, -16(%rbp)
    jnae end_for
    // struct cellule_t *cell = malloc(sizeof(struct cellule_t))
    movq $16, %rdi
    call malloc
    movq %rax, -20(%rbp)
    // cell->val = tab[i]
    movw (-28(%rbp), -16(%rbp), 2), -20(%rbp)
    // cell->suiv = liste
    movq -8(%rbp), (-20+8)(%rbp)
    // liste = cell
    movq -20(%rbp), -8(%rbp)
    // i--
    subl $1, -16(%rbp)
end_for:
    // return liste
    movq -8(%rbp), %rax
    leave
    ret
