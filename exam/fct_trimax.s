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


    .globl trier_liste1
trier_liste1:
    enter $0, $0
    leave
    ret
