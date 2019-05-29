#include "const.h"
    .text
    .globl ptr_mem
    .globl ecrit_car
    // .globl place_curseur

// uint16_t *ptr_mem(uint32_t lig, uint32_t col)
ptr_mem:
    // uint32_t lig: %ebp+8
    // uint32_t col: %ebp+12
    enter $0, $0
    // (MEM_VIDEO + 2*(lig*NB_COL + col))
    movl 8(%ebp), %eax
    movl $NB_COL, %edx
    // lig*NB_COL
    mull %edx
    // lig*NB_COL + col
    addl 12(%ebp), %eax
    // 2*(lig*NB_COL + col)
    shll $1, %eax
    // return (MEM_VIDEO + 2*(lig*NB_COL + col))
    addl $MEM_VIDEO, %eax
    leave
    ret

// void ecrit_car(uint32_t lig, uint32_t col, char c, uint32_t coul_texte, uint32_t coul_fond)
ecrit_car:
    // uint32_t lig: %ebp+8
    // uint32_t col: %ebp+12
    // char c: %ebp+16
    // uint32_t ct: %ebp+20
    // uint32_t cf: %ebp+24
    enter $0, $0
    // uint16_t *ptr = ptr_mem(lig, col)
    pushl 12(%ebp)
    pushl 8(%ebp)
    call ptr_mem
    addl $8, %esp
    // coul_fond << 12
    movl 24(%ebp), %ecx
    shll $12, %ecx
    // coul_texte << 8
    movl 20(%ebp), %edx
    shll $8, %edx
    // (coul_fond << 12) | (coul_texte << 8)
    orl %edx, %ecx
    // (coul_fond << 12) | (coul_texte << 8) | c
    orl 16(%ebp), %ecx
    // *ptr = (coul_fond << 12) | (coul_texte << 8) | c
    movw %cx, (%eax)
    leave
    ret

// void place_curseur(uint32_t lig, uint32_t col)
place_curseur:
    // uint32_t lig: %ebp+8
    // uint32_t col: %ebp+12

    enter $4, $0

    movl 8(%ebp), %eax
    movl $NB_COL, %edx
    // lig*NB_COL
    mull %edx
    // lig*NB_COL + col
    addl 12(%ebp), %eax
    // uint32_t pos = lig*NB_COL + col
    movl %eax, -4(%ebp)

    // outb(uint8_t val, uint16_t port)
    // outb(0x0E, 0x3D4)
    movb $0x0E, %al
    movw $0x3D4, %dx
    outb %al, %dx

    // outb(pos >> 8, 0x3D5)
    movl -4(%ebp), %eax
    shrb $8, %al
    movw $0x3D5, %dx
    outb %al, %dx

    // outb(0x0F, 0x3D4)
    movb $0x0F, %al
    movw $0x3D4, %dx
    outb %al, %dx

    // outb((uint16_t)pos, 0x3D5)
    movb -4(%ebp), %al
    movw $0x3D5, %dx
    outb %al, %dx

    leave
    ret
