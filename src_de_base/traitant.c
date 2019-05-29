#include "traitant.h"

int32_t nb_tics = 0;
int32_t nb_secondes = 0;


void tic_PIT(void)
{
    outb(0x20, 0x20);
    nb_tics++;
    if (nb_tics == 50) {
        nb_secondes++;
        nb_tics = 0;
        affiche_heure(nb_secondes);
    }
    // compter le nombre de seconde
    // afficher
}

void init_traitant_IT32(void (*traitant)(void))
{
    uint32_t *table = (uint32_t *)0x1000;
    *(table + 2*32) = KERNEL_CS << 16 | ((uint32_t)traitant & 0x0000FFFF);
    *(table + 2*32+1) = ((uint32_t)traitant & 0xFFFF0000) | 0x8E00;
}

void init_traitant(uint8_t n, void (*traitant)(void))
{
    uint32_t *table = (uint32_t *)0x1000;
    *(table + 2*n) = KERNEL_CS << 16 | ((uint32_t)traitant & 0x0000FFFF);
    *(table + 2*n+1) = ((uint32_t)traitant & 0xFFFF0000) | 0x8E00;
}

// void demasquer_IRQ0(void)
// {
//     char masque = inb(0x21);
//     masque = masque & 0xFE;
//     outb(masque, 0x21);
// }

void demasquer_IRQ8(void)
{
    char masque = inb(0x21);
    masque = masque & 0xFB;
    outb(masque, 0x21);

    masque = inb(0xA1);
    masque = masque & 0xFE;
    outb(masque, 0xA1);
}

// void regler_horloge(void)
// {
//     outb(0x34, 0x43);
//     outb((QUARTZ / CLOCKFREQ) % 256, 0x40);
//     outb((QUARTZ / CLOCKFREQ) >> 8, 0x40);
// }

uint8_t lit_CMOS(uint8_t reg) {
    outb(0x80 | reg, 0x70);
    uint8_t res = inb(0x71);
    uint8_t unite = res & 0x0F;
    uint8_t dizaine = res >> 4;
    return dizaine * 10 + unite;
}

void affiche_date() {
    // uint8_t jour = lit_CMOS(6);
    uint8_t sec = lit_CMOS(0);
    uint8_t min = lit_CMOS(2);
    uint8_t h = lit_CMOS(4);

    uint8_t date = lit_CMOS(7);
    uint8_t mois = lit_CMOS(8);
    uint8_t annee = lit_CMOS(9);
    // uint8_t centenaire = lit_CMOS(0x32);

    ecrit_date(date, mois, annee, h, min, sec);
}

void regle_frequence_RTC(void) {
    outb(0x8A, 0x70);
    uint8_t v = inb(0x71);
    outb(0x8A, 0x70);
    outb((v << 4) + 2, 0x71);

    outb(0x8B, 0x70);
    v = inb(0x71);
    outb(0x8B, 0x70);
    outb(v | 0b01000000, 0x71);
}
