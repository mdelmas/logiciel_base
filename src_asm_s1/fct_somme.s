/*
uint8_t i, res;

uint8_t somme(void)
{
    res = 0;
    for (i = 1; i <= 10; i++) {
        res = res + i;
    }
    return res;
}
*/
    .text
    .globl somme
somme:
    enter $0, $0
    movb $0, res
    movb $1, i
for:
    cmpb $10, i
    jnbe end_for
    movb i, %al
    addb %al, res
    addb $1, i
    jmp for
end_for:
    movb res, %al
    leave
    ret
    .data
    // uint8_t i, res;
    .comm i, 1
    .comm res, 1
