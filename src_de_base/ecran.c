#include "ecran.h"



typedef struct
{
    uint32_t col;
    uint32_t lig;
    uint32_t coul_texte;
    uint32_t coul_fond;
} curr_info_t;

curr_info_t curr;


// uint16_t *ptr_mem(uint32_t lig, uint32_t col)
// {
//     return (uint16_t *)(MEM_VIDEO + 2*(lig*NB_COL + col));
// }
//
// void ecrit_car(uint32_t lig, uint32_t col, char c,
//         uint32_t coul_texte, uint32_t coul_fond)
// {
//     uint16_t *ptr = ptr_mem(lig, col);
//     // 0 cf(3bits) ct(4bits)   char(8bits)
//     *ptr = (coul_fond << 12) | (coul_texte << 8) | c;
//     return ;
// }

void efface_ecran(void)
{
    for (int lig = 0; lig < NB_LIG; lig++) {
        for (int col = 0; col < NB_COL; col++) {
            ecrit_car(lig, col, ' ', 0xF, 0x0);
        }
    }
    curr.col = 0;
    curr.lig = 0;
    return ;
}

void place_curseur(uint32_t lig, uint32_t col)
{
    uint32_t pos = lig*NB_COL + col;
    outb(0x0E, 0x3D4);
    outb(pos >> 8, 0x3D5);
    outb(0x0F, 0x3D4);
    outb((uint16_t)pos, 0x3D5);
    return ;
}

void traite_car(char c)
{
    if (c == '\b') {
        curr.col = curr.col != 0 ? curr.col - 1 : curr.col;
    } else if (c == '\t') {
        while (curr.col % 8 != 0) {
            curr.col++;
        }
        if (curr.col > 72) {
            curr.col = 79;
        }
    } else if (c == '\n') {
        curr.col = 0;
        curr.lig++;
        if (curr.lig == NB_LIG) {
            defilement();
        }
    } else if (c == '\f') {
        efface_ecran();
        curr.col = 0;
        curr.lig = 0;
    } else if (c == '\r') {
        curr.col = 0;
    } else if (c >= ' ' && c <= '~') {
        ecrit_car(curr.lig, curr.col, c, 0xF, 0x0);
        curr.col++;
        if (curr.col > NB_COL) {
            curr.col = 0;
            curr.lig++;
            if (curr.lig == NB_LIG) {
                defilement();
            }
        }
    }
    place_curseur(curr.lig, curr.col);
    return ;
}

void defilement(void)
{
    // void *memmove(void *dest, const void *src, size_t n);
    memmove((uint16_t *)MEM_VIDEO, (uint16_t *)(MEM_VIDEO + 2*NB_COL), 2*(NB_LIG-1)*NB_COL);
    for (int col = 0; col < 80; col++) {
        ecrit_car(24, col, ' ', 0xF, 0x0);
    }
    curr.lig--;
    place_curseur(curr.lig, curr.col);
    return ;
}

void console_putbytes(char *chaine, int32_t taille)
{
    for (int i = 0; i < taille; i++) {
        traite_car(chaine[i]);
    }
    return ;
}

// void affiche_heure(char *chaine, int32_t taille) {
//     for (int i = 0; i < taille; i++) {
//         ecrit_car(0, NB_COL - (taille - i), chaine[i], 0xF, 0x0);
//     }
// }
void affiche_heure(int32_t sec) {
    char heure[11];
    sprintf(heure, "<%02d:%02d:%02d>", sec/3600, (sec%3600)/60, sec%60);
    for (int i = 0; i < 10; i++) {
        ecrit_car(1, NB_COL-(10-i), heure[i], 0xF, 0x0);
    }
}

// ecrit_date(date, mois, annee, h, min, sec);

void ecrit_date(int8_t jour, int8_t mois, int8_t annee, int8_t h, int8_t min, int8_t sec) {
    char date[20];
    sprintf(date, "%02d/%02d/%02d <%02d:%02d:%02d>", jour, mois, annee, h, min, sec);
    for (int i = 0; i < 20; i++) {
        ecrit_car(0, NB_COL-(20-i), date[i], 0xF, 0x0);
    }
}
