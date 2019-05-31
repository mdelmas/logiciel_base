/*
void copiemem0(uint8_t *dst, uint8_t *src, uint32_t taille)
{
    for (uint32_t i = 0; i < taille; i++) {
        dst[i] = src[i];
    }
}
*/

    .text
    .globl copiemem1
    // void copiemem0(uint8_t *dst, uint8_t *src, uint32_t taille)
    // uint8_t *dst : 8(%ebp)
    // uint8_t *src : 12(%ebp)
    // uint32_t taille : 16(%ebp)
copiemem1:
    // uint32_t i : -4(%ebp)
    enter $4, $0
    // uint32_t i = 0
    movl $0, -4(%ebp)
for:
    // for (i < taille)
    movl 16(%ebp), %eax
    cmpl %eax, -4(%ebp)
    jge end_for
    // src[i]
    movl 12(%ebp), %eax
    movl -4(%ebp), %edx
    movb (%eax, %edx, 1), %cl
    // dst[i] = src[i]
    movl 8(%ebp), %eax
    movb %cl, (%eax, %edx, 1)
    // i++
    addl $1, -4(%ebp)
    jmp for
end_for:
    leave
    ret



    .text
    .globl copiemem2
    // void copiemem0(uint8_t *dst, uint8_t *src, uint32_t taille)
    // uint8_t *dst : 8(%ebp)      -> %eax
    // uint8_t *src : 12(%ebp)     -> %ecx
    // uint32_t taille : 16(%ebp)  -> %edx
copiemem2:
    // uint32_t i : -4(%ebp)       -> %esi
    enter $0, $0
    // sauvegarde registres non scratch
    pushl %ebx
    pushl %esi
    pushl %edi
    // copie valeurs des paramètres dans des registres
    movl 8(%ebp), %eax
    movl 12(%ebp), %ecx
    movl 16(%ebp), %edx
    movl $0, %ebx
    // uint32_t i = 0
    movl $0, %esi
for2:
    // for (i < taille)
    cmpl %edx, %esi
    jge end_for2
    // src[i]
    movb (%ecx, %esi, 1), %bl
    // dst[i] = src[i]
    movb %bl, (%eax, %esi, 1)
    // i++
    addl $1, %esi
    jmp for2
end_for2:
    // restauration registres non scratch
    popl %edi
    popl %esi
    popl %ebx
    leave
    ret

    .text
    .globl copiemem3
    // void copiemem0(uint8_t *dst, uint8_t *src, uint32_t taille)
    // uint8_t *dst : 8(%ebp)
    // uint8_t *src : 12(%ebp)
    // uint32_t taille : 16(%ebp)
copiemem3:
    enter $0, $0
    // adresse de la zone source dans %esi
    movl 12(%ebp), %esi
    // adresse de la zone destination dans %edi
    movl 8(%ebp), %edi
    // mise à zéro du bit D de %eflags : on incrémente %esi et %edi
    cld
    // parametrage du nombre de répétitions
    movl 16(%ebp), %ecx
    // instruction movsb sera répété "taille" fois
    rep movsb
    leave
    ret
