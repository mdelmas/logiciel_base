#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <inttypes.h>

struct cell_t {
    uint8_t val;
    struct cell_t *suiv;
};

struct liste_t {
    struct cell_t tete;
};

struct liste_t *nouv_liste(void)
{
    struct liste_t *nouv_liste = malloc(sizeof(struct liste_t));
    assert(nouv_liste);
    nouv_liste->tete.val = 0;
    nouv_liste->tete.suiv = NULL;
    return nouv_liste;
}

bool est_vide_liste(struct liste_t *liste)
{
    assert(liste);
    return liste->tete.suiv == NULL;
}

void inserer_tete_liste(uint8_t val, struct liste_t *liste)
{
    assert(liste);
    struct cell_t *tmp = liste->tete.suiv;
    struct cell_t *new = malloc(sizeof(struct cell_t)); assert(new);
    new->val = val;
    new->suiv = tmp;
    liste->tete.suiv = new;
}

bool supprimer_val_liste(uint8_t val, struct liste_t *liste)
{
    assert(liste);
    struct cell_t *ptr = NULL;
    struct cell_t *curr = &(liste->tete);
    while (curr->suiv != NULL) {
        if (curr->suiv->val == val) {
            ptr = curr->suiv;
            curr->suiv = curr->suiv->suiv;
            free(ptr);
            return true;
        }
        curr = curr->suiv;
    }
    return false;
}

void afficher_liste(struct liste_t *liste)
{
    assert(liste);
    struct cell_t *curr = liste->tete.suiv;
    while (curr != NULL) {
        printf("%" PRIu8 " <-> ", curr->val); fflush(stdout);
        curr = curr->suiv;
    }
    printf("FIN\n");
}

void detruire_liste(struct liste_t **liste)
{
    assert(*liste);
    struct cell_t *ptr = NULL;
    struct cell_t *curr = (*liste)->tete.suiv;
    while (curr != NULL) {
        ptr = curr;
        curr = curr->suiv;
        free(ptr);
    }

    free(*liste);
    *liste = NULL;
}
