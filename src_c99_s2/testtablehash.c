#include "tablehash.h"
#include <stdio.h>
#include <inttypes.h>

int main(void)
{
    struct tablehash_t *th = nouv_tablehash();
    afficher_tablehash(th);
    printf("\n");

    if (est_vide_tablehash(th)) {
        printf("La table de hash est vide :(\n");
    }

    inserer_val_tablehash(1, th);
    inserer_val_tablehash(2, th);
    inserer_val_tablehash(3, th);
    inserer_val_tablehash(4, th);
    inserer_val_tablehash(5, th);
    inserer_val_tablehash(6, th);
    afficher_tablehash(th);

    supprimer_val_tablehash(3, th);
    afficher_tablehash(th);
    supprimer_val_tablehash(2, th);
    afficher_tablehash(th);
    supprimer_val_tablehash(1, th);
    afficher_tablehash(th);

    for (int i = 0; i < 5; i++) {
        inserer_val_tablehash(i, th);
    }
    afficher_tablehash(th);
    detruire_tablehash(&th);

    return 0;
}
