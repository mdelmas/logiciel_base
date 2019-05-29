#include "const.h"
# cette directive sert a rendre l’etiquette publique
    .text
    .globl traitant_IT_32
    .globl traitant_IT_40
    .globl demasquer_IRQ0
    .globl regler_horloge

# debut du traitant
traitant_IT_32:
# sauvegarde des registres importants
    pushl %eax
    pushl %edx
    pushl %ecx
# appel a la fonction C realisant le traitant
    call tic_PIT
# restauration des registres importants
    popl %ecx
    popl %edx
    popl %eax
# fin du traitant
    iret

# debut du traitant
traitant_IT_40:
# sauvegarde des registres importants
    pushl %eax
    pushl %edx
    pushl %ecx
# acquittement interruption 40
    movw $0x20, %dx
    movb $0x20, %al
    outb %al, %dx
    movw $0xA0, %dx
    movb $0x20, %al
    outb %al, %dx
# lecture de la RTC
    movw $0x70, %dx
    movb $0x8C, %al
    outb %al, %dx
    movw $0x71, %dx
    inb %dx, %al
# appel a la fonction C realisant le traitant
    call affiche_date
# restauration des registres importants
    popl %ecx
    popl %edx
    popl %eax
# fin du traitant
    iret


/*
void demasquer_IRQ0(void)
{
    char masque = inb(0x21);
    masque = masque & 11111110;
    outb(masque, 0x21);
}
*/
// void demasquer_IRQ0(void)
demasquer_IRQ0:
    enter $0, $0
    // char masque = inb(0x21)
    movw $0x21, %dx
    inb %dx, %al
    // masque = masque & 11111110
    andb $0xFE, %al
    // outb(masque, 0x21)
    outb %al, %dx
    leave
    ret

/*
void regler_horloge(void)
{
    outb(0x34, 0x43);
    outb((QUARTZ / CLOCKFREQ) % 256, 0x40);
    outb((QUARTZ / CLOCKFREQ) >> 8, 0x40);
}
*/
// void regler_horloge(void)
regler_horloge:
    enter $0, $0
    // outb(0x34, 0x43)
    movw $0x43, %dx
    movb $0x34, %al
    outb %al, %dx
    // outb((QUARTZ / CLOCKFREQ) % 256, 0x40)
    movl $0, %edx
    movl $QUARTZ, %eax
    movl $CLOCKFREQ, %ecx
    divl %ecx
    andl $0x00FF, %eax
    movw $0x40, %dx
    outb %al, %dx
    // outb((QUARTZ / CLOCKFREQ) >> 8, 0x40);
    movl $0, %edx
    movl $QUARTZ, %eax
    movl $CLOCKFREQ, %ecx
    divl %ecx
    shrl $8, %eax
    movw $0x40, %dx
    outb %al, %dx
    leave
    ret
