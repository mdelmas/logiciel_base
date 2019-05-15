#include "liste.h"
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

#define TAILLE_TABLE 4

struct tablehash_t {
    uint64_t nbr_elem;
    struct liste_t *table[TAILLE_TABLE];
};

static int64_t hash(uint8_t x)
{
    return x % TAILLE_TABLE;
}

struct tablehash_t *nouv_tablehash(void)
{
    // a changer
    // le compilateur genere aussi un avertissement si on
    //   declare une fonction et qu'on ne s'en sert jamais !
    (void)hash(0);

    struct tablehash_t *nouv_table = malloc(sizeof(struct tablehash_t));
    nouv_table->nbr_elem = 0;
    for (int i = 0; i < TAILLE_TABLE; i++) {
        nouv_table->table[i] = nouv_liste();
    }
    return nouv_table;
}

bool est_vide_tablehash(struct tablehash_t *th)
{
    for (int i = 0; i < TAILLE_TABLE; i++) {
        if (!est_vide_liste(th->table[i])) {
            return false;
        }
    }
    return true;
}

void inserer_val_tablehash(uint8_t val, struct tablehash_t *th)
{
    inserer_tete_liste(val, th->table[hash(val)]);
}

void supprimer_val_tablehash(uint8_t val, struct tablehash_t *th)
{
    supprimer_val_liste(val, th->table[hash(val)]);
}

void afficher_tablehash(struct tablehash_t *th)
{
    printf("Tablehash : \n");
    for (int i = 0; i < TAILLE_TABLE; i++) {
        printf("%d : ", i);
        afficher_liste(th->table[i]);
    }
}

void detruire_tablehash(struct tablehash_t **th)
{
    for (int i = 0; i < TAILLE_TABLE; i++) {
        detruire_liste(&((*th)->table[i]));
    }

    free(*th);
    *th = NULL;
}
