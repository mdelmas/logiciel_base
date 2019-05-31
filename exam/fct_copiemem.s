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
    addl $1, -4(%ebp)
    jmp for
end_for:
    leave
    ret

    .text
    .globl copiemem2
copiemem2:
    enter $0, $0
    leave
    ret

    .text
    .globl copiemem3
 copiemem3:
    enter $0, $0
    leave
    ret

