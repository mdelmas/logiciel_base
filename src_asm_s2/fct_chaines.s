    .text
    .globl taille_chaine
    .globl inverse_chaine

taille_chaine:
    enter $0, $0
    leaq chaine, %r10
    movq $0, %r11
while:
    cmpb $0, (%r10, %r11, 1)
    je end_while
    addq $1, %r11
    jmp while
end_while:
    movq %r11, taille
    movq %r11, %rax
    leave
    ret

inverse_chaine:
    enter $0, $0

    movq taille, %r11
    subq $1, %r11
    movq %r11, dep

    leaq chaine, %r10
    movq %r10, ptr

while2:
    movq dep, %r11
    cmpq $0, %r11
    jle end_while2

    movq ptr, %r10
    movb (%r10), %al
    movb %al, tmp

    movq dep, %r11
    movb (%r10, %r11, 1), %al
    movb %al, (%r10)

    movb tmp, %al
    movb %al, (%r10, %r11, 1)

    subq $2, dep
    addq $1, ptr

    jmp while2
end_while2:
    leave
    ret

    .data
    .comm taille 8
    .comm ptr 8
    .comm dep 8
    .comm tmp 1
