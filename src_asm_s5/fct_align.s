    .text
    .globl affiche_asm
/*
  void affiche_asm(char c, uint16_t s)
  {
      affiche_c(c + 1, s - 1);
  }
*/
affiche_asm:
    enter $0, $0
    movl $0, %eax
    // uin16_t s
    movw 12(%ebp), %ax
    // s - 1
    subw $1, %ax
    pushl %eax
    movl $0, %eax
    // char c
    movb 8(%ebp), %al
    // c + 1
    addb $1, %al
    pushl %eax
    call affiche_c
    addl $8, %esp
    leave
    ret
