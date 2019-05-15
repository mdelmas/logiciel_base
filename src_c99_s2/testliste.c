#include "liste.h"
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    // la fonction srandom initialise le generateur de
    //   nombres aleatoires
    srandom(time(NULL));
    // ensuite, on utilise random() pour recuperer une valeur
    //   aleatoire entre 0 et une valeur max tres grande
    // si on veut par exemple recuperer des entiers entre 0 et
    //   9, on utilisera un modulo : random() % 10
    // a completer
    struct liste_t *liste = nouv_liste();
    afficher_liste(liste);

    if (est_vide_liste(liste)) {
        printf("La liste est vide :(\n");
    }

    inserer_tete_liste(1, liste);
    inserer_tete_liste(2, liste);
    inserer_tete_liste(3, liste);
    afficher_liste(liste);

    supprimer_val_liste(3, liste);
    afficher_liste(liste);
    supprimer_val_liste(2, liste);
    afficher_liste(liste);
    supprimer_val_liste(1, liste);
    afficher_liste(liste);

    for (int i = 0; i < 5; i++) {
        inserer_tete_liste(random() % 255, liste);
    }
    afficher_liste(liste);
    detruire_liste(&liste);

    return 0;
}
