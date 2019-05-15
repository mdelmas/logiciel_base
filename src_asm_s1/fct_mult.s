/*
fct_mult.s
.
uint64_t mult_simple(void)
{
res = 0;
while (y != 0) {
res = res + x;
y--;
}
return res;
}

uint64_t mult_egypt(void)
{
res = 0;
while (y != 0) {
if (y % 2 == 1) {
res = res + x;
}
x = x * 2;
y = y / 2;
}
return res;
}
*/


    .text
    .globl mult_simple
    .globl mult_egypt
mult_simple:
    enter $0, $0
    movq $0, res
    movq x, %rax
while:
    cmpq $0, y
    je end_while
    addq %rax, res
    subq $1, y
    jmp while
end_while:
    movq res, %rax
    leave
    ret
mult_egypt:
    enter $0, $0
    movq $0, res
while:
    cmpq $0, y
    je end_while
if:
    test $1, y

end_if:
    shl $1, x
    shr $1, y
    jmp while
end_while:
    movq res, %rax
    leave
    ret
    .data
    .comm res, 8
