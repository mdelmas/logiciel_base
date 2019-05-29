#ifndef _TRAITANT_H
#define _TRAITANT_H

#include "cpu.h"
#include "inttypes.h"
#include "ecran.h"
#include "segment.h"
#include "const.h"



void tic_PIT(void);
void init_traitant_IT32(void (*traitant)(void));
void traitant_IT_32(void);
void traitant_IT_40(void);
void init_traitant(uint8_t n, void (*traitant)(void));
void demasquer_IRQ0(void);
void demasquer_IRQ8(void);
void regler_horloge(void);
uint8_t lit_CMOS(uint8_t reg);
void affiche_date();
void regle_frequence_RTC(void);

#endif
