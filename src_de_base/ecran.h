#ifndef __ECRAN_H__
#define __ECRAN_H__

#include "cpu.h"
#include <inttypes.h>
#include "string.h"
#include "const.h"
#include <stdio.h>

/*
 * This is the function called by printf to send its output to the screen. You
 * have to implement it in the kernel and in the user program.
 */
void console_putbytes(char *chaine, int32_t taille);

uint16_t *ptr_mem(uint32_t lig, uint32_t col);
void ecrit_car(uint32_t lig, uint32_t col, char c, uint32_t coul_texte, uint32_t coul_fond);
void efface_ecran(void);
void place_curseur(uint32_t lig, uint32_t col);
void traite_car(char c);
void defilement(void);
void affiche_heure(int32_t nb_secondes);
// void ecrit_date(int8_t jour, int8_t mois, int8_t annee);
void ecrit_date(int8_t jour, int8_t mois, int8_t annee, int8_t h, int8_t min, int8_t sec);

#endif
