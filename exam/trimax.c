#include <time.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <inttypes.h> 

// fonctions a implanter en assembleur x86_64
extern struct cellule_t *creer_liste1(uint16_t tab[], uint32_t taille);
extern void trier_liste1(struct cellule_t **liste);

// le type d'une cellule de la liste chaine
struct cellule_t {
    uint16_t val;
    struct cellule_t *suiv;
};

// fonction qui affiche le contenu du tableau passe en parametre
//   (n'affiche rien si le tableau contient plus de 20 elements)
static void afficher_tableau(uint16_t tab[], uint32_t taille)
{
    if (taille <= 20) {
        printf("  => contenu du tableau  : ");
        for (uint32_t i = 0; i < taille; i++) {
            printf("%03" PRIu16 " ", tab[i]);
        }
        puts("");
    }
}

// fonction de creation d'une liste a partir d'un tableau
//   c'est la fonction de reference en C
static struct cellule_t *creer_liste0(uint16_t tab[], uint32_t taille)
{
    struct cellule_t *liste = NULL;
    for (int32_t i = taille - 1; i >= 0; i--) {
        struct cellule_t *cell = malloc(sizeof(struct cellule_t)); assert(NULL != cell);
        cell->val = tab[i];
        cell->suiv = liste;
        liste = cell;
    }
    return liste;
}

// fonction qui affiche le contenu d'une liste chaine
//   (n'affiche rien si la liste contient plus de 20 elements)
static void afficher_liste(struct cellule_t *liste, uint32_t taille)
{
    if (taille <= 20) {
        printf("  => contenu de la liste : ");
        struct cellule_t *cour = liste;
        while (NULL != cour) {
            printf("%03" PRIu16 " ", cour->val);
            cour = cour->suiv;
        }
        puts("");
    }
}

// fonction de tri d'une liste chainee
//   c'est la fonction de reference en C
static void trier_liste0(struct cellule_t **liste)
{
    assert(NULL != liste);
    struct cellule_t fictif;
    fictif.suiv = *liste;
    *liste = NULL;
    while (NULL != fictif.suiv) {
        struct cellule_t *prec_max = &fictif;
        struct cellule_t *prec = fictif.suiv;
        while (NULL != prec->suiv) {
            if (prec->suiv->val > prec_max->suiv->val) {
                prec_max = prec;
            }
            prec = prec->suiv;
        }
        prec = prec_max->suiv->suiv;
        prec_max->suiv->suiv = *liste;
        *liste = prec_max->suiv;
        prec_max->suiv = prec;
    }
}

// fonction qui detruit une liste chaine en desallouant toutes
//   ses cellules (affecte le pointeur a NULL a la fin)
static void detruire_liste(struct cellule_t **liste)
{
    assert(NULL != liste);
    while (NULL != *liste) {
        struct cellule_t *suiv = (*liste)->suiv;
        free(*liste);
        *liste = suiv;
    }
    *liste = NULL;
}

// fonction qui verifie qu'une liste chainee est bien triee
//   par ordre croissant
static void verifier_triee(struct cellule_t *liste)
{
    int16_t prec = -1;
    while (NULL != liste) {
        if (prec > liste->val) {
            puts("  => ERREUR : la liste n'est pas triee par ordre croissant !!");
            return;
        }
        prec = liste->val;
        liste = liste->suiv;
    }
    puts("  => OK");
}

// fonction qui compare le contenu de deux listes chainees
static void comparer_listes(struct cellule_t *liste0, struct cellule_t *liste1)
{
    while ((NULL != liste0) && (NULL != liste1)) {
        if (liste0->val != liste1->val) {
            puts("  => ERREUR : les listes contiennent des valeurs differentes !!");
            return;
        }
        liste0 = liste0->suiv;
        liste1 = liste1->suiv;
    }
    if (NULL != liste0) {
        puts("  => ERREUR : la liste creee en assembleur est trop courte !!");
        return;
    }
    if (NULL != liste1) {
        puts("  => ERREUR : la liste creee en assembleur est trop longue !!");
        return;
    }
    puts("  => OK");
}

int main(int argc, char *argv[])
{
    // analyse des parametres de la ligne de commande
    if (argc != 2) {
        fprintf(stderr, "usage : %s <nombre d'elements>\n", argv[0]);
        return 1;
    }
    uint32_t taille = atoi(argv[1]);

    // construction d'un tableau d'entiers aleatoires
    printf("Initialisation du tableau de %" PRIu32 " elements\n", taille);
    srandom(time(NULL));
    uint16_t tab[taille];
    for (uint32_t i = 0; i < taille; i++) {
        tab[i] = random() % 1000;
    }
    afficher_tableau(tab, taille);

    puts("Creation de la liste de reference...");
    struct cellule_t *liste0 = creer_liste0(tab, taille);
    afficher_liste(liste0, taille);
    puts("Creation de la liste en assembleur...");
    struct cellule_t *liste1 = creer_liste1(tab, taille);
    afficher_liste(liste1, taille);
    puts("Comparaison des deux listes...");
    comparer_listes(liste0, liste1);
    puts("Tri de la liste de reference...");
    trier_liste0(&liste0);
    afficher_liste(liste0, taille);
    puts("Verification que la liste de reference est triee :");
    verifier_triee(liste0);
    puts("Tri de la liste creee en assembleur...");
    trier_liste1(&liste1);
    afficher_liste(liste1, taille);
    puts("Verification que la liste cree en assembleur est triee :");
    verifier_triee(liste1);
    puts("Comparaison des deux listes...");
    comparer_listes(liste0, liste1);
    puts("Destruction de la liste de reference...");
    detruire_liste(&liste0);
    puts("Destruction de la liste creee en assembleur...");
    detruire_liste(&liste1);

    return 0;
}
